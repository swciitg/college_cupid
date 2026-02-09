import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/recorder.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends ConsumerStatefulWidget {
  static const id = 'editProfile';

  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  List<Program> programs = Program.values.where((e) => e != Program.none).toList();
  late Gender _selectedGender;
  late Program _selectedProgram;
  late int _yearOfJoin;
  var _loading = false;
  String? _loadingMessage;
  SexualOrientation? _selectedSexualOrientation;
  late bool _displaySexualOrientation;
  late LookingFor _relationshipGoal;
  late bool _displayRelationshipGoal;
  List<File?> newImages = [null, null, null];
  List<String> deletedImages = [];
  late UserProfile profileSave;
  List<QuizQuestion> surprizeQuiz = [];
  List<TextEditingController> textEditingControllers = [];
  final Map<int, String?> _audioPaths = {}; // Track audio paths for each question
  late TextEditingController _instaController;
  late TextEditingController _phoneController;
  late TextEditingController _hometownController;
  late TextEditingController _ageController;

  @override
  void initState() {
    final userState = ref.read(userProvider);
    profileSave = userState.myProfile!;

    // Merge surpriseQuiz and voiceRecordings like in display_profile_info.dart
    final Map<String, QuizQuestion> questionsMap = {};

    // Add all text quiz answers
    for (var quiz in profileSave.surpriseQuiz) {
      questionsMap[quiz.question] = quiz;
    }

    // Add voice recordings - either merge with existing or add new
    for (var voice in profileSave.voiceRecordings) {
      if (voice.question.isNotEmpty && voice.answer.isNotEmpty) {
        if (questionsMap.containsKey(voice.question)) {
          // Merge: add audioPath to existing question
          questionsMap[voice.question] = questionsMap[voice.question]!.copyWith(
            audioPath: voice.answer,
          );
        } else {
          // Add new question with only audio answer
          questionsMap[voice.question] = QuizQuestion(
            question: voice.question,
            answer: '',
            audioPath: voice.answer,
          );
        }
      }
    }

    surprizeQuiz.addAll(questionsMap.values);
    debugPrint('Total questions after merge: ${surprizeQuiz.length}');
    for (var q in surprizeQuiz) {
      debugPrint(
          'Question: ${q.question}, hasText: ${q.answer.isNotEmpty}, hasAudio: ${q.audioPath != null}');
    }

    textEditingControllers
        .addAll(surprizeQuiz.map((e) => TextEditingController(text: e.answer)).toList());

    // Initialize audio paths from existing data
    for (int i = 0; i < surprizeQuiz.length; i++) {
      _audioPaths[i] = surprizeQuiz[i].audioPath;
    }

    _selectedProgram = userState.myProfile!.program!;
    _selectedGender = userState.myProfile!.gender!;
    _selectedSexualOrientation = userState.myProfile!.sexualOrientation?.type;
    _displaySexualOrientation = userState.myProfile!.sexualOrientation?.display ?? true;
    _yearOfJoin = DateTime.now().year % 100 - userState.myProfile!.yearOfJoin!;
    _relationshipGoal = userState.myProfile!.relationshipGoal?.goal ?? LookingFor.longTermPartner;
    _displayRelationshipGoal = userState.myProfile!.relationshipGoal?.display ?? true;

    _instaController = TextEditingController(text: userState.myProfile!.insta);
    _phoneController = TextEditingController(text: userState.myProfile!.phnNumber);
    _hometownController = TextEditingController(text: userState.myProfile!.hometown);
    _ageController = TextEditingController(text: userState.myProfile!.age.toString());

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingControllerProvider.notifier).setInterests(
            userState.myProfile!.interests,
          );
    });
  }

  @override
  void dispose() {
    _instaController.dispose();
    _phoneController.dispose();
    _hometownController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _deleteImage(int index) {
    newImages[index] = null;
    setState(() {});
    if (index < ref.read(userProvider).myProfile!.images.length) {
      final image = ref.read(userProvider).myProfile!.images[index];
      if (!deletedImages.contains(image.url)) {
        deletedImages.add(image.url);
        final updatedImages = ref
            .read(userProvider)
            .myProfile!
            .images
            .where(
              (e) => e.url != image.url,
            )
            .toList();
        final currentProfile = ref.read(userProvider).myProfile!;
        ref.read(userProvider.notifier).updateMyProfile(
              currentProfile.copyWith(images: updatedImages),
            );
      }
    }
    setState(() {});
  }

  void _updateProfile() async {
    if (_loading) return;
    final newInterests = ref.read(onboardingControllerProvider).interests;
    if (newInterests == null || newInterests.length < 5) {
      showSnackBar("Please select at least 5 interests");
      return;
    }

    // Validate phone number
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      if (phoneNumber.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
        showSnackBar("Phone number must be exactly 10 digits");
        return;
      }
    }

    // Validate age
    final ageText = _ageController.text.trim();
    int? age;
    if (ageText.isNotEmpty) {
      age = int.tryParse(ageText);
      if (age == null || age < 18 || age > 100) {
        showSnackBar("Please enter a valid age between 18 and 100");
        return;
      }
    } else {
      showSnackBar("Age is required");
      return;
    }

    // Check if all questions have either text or audio answers
    for (int i = 0; i < surprizeQuiz.length; i++) {
      final hasText = textEditingControllers[i].text.trim().isNotEmpty;
      final hasAudio = _audioPaths[i] != null && _audioPaths[i]!.isNotEmpty;
      if (!hasText && !hasAudio) {
        showSnackBar("Please answer all quiz questions with text or audio!");
        return;
      }
    }

    setState(() {
      _loading = true;
    });
    var profile = ref.read(userProvider).myProfile!;
    var newImagesLenth = newImages.where((e) => e != null).length;
    if (newImagesLenth + profile.images.length < 3) {
      showSnackBar("Select all 3 images");
      setState(() {
        _loading = false;
      });
      return;
    }
    var updatedImages = profile.images;
    try {
      if (newImagesLenth != 0) {
        _loadingMessage = "Uploading Images";
        setState(() {});
        var count = 0;
        for (int i = 0; i < newImages.length; i++) {
          final image = newImages[i];
          if (image == null) continue;
          final url = await ref.read(userProfileRepoProvider).postUserProfileImage(image,
              onSendProgress: (val) {
            final imageProgress = (count + val) / newImagesLenth * 100;
            setState(
              () {
                _loadingMessage = "Uploading Image(s) : ${imageProgress.toInt()}%";
              },
            );
          });
          final blurHash = await imageHelpers.encodeBlurHash(imageProvider: FileImage(image));
          if (i <= profile.images.length - 1) {
            updatedImages[i] = ImageModel(url: url, blurHash: blurHash);
          } else {
            updatedImages.add(ImageModel(url: url, blurHash: blurHash));
          }
          count++;
        }
      }

      final userProfile = profile.copyWith(
        gender: _selectedGender,
        program: _selectedProgram,
        age: age,
        insta: _instaController.text.trim(),
        phnNumber: _phoneController.text.trim(),
        hometown: _hometownController.text.trim(),
        sexualOrientation: _selectedSexualOrientation != null
            ? SexualOrientationModel(
                type: _selectedSexualOrientation!,
                display: _displaySexualOrientation,
              )
            : null,
        relationshipGoal: RelationshipGoal(
          goal: _relationshipGoal,
          display: _displayRelationshipGoal,
        ),
        images: updatedImages,
        surpriseQuiz: List.generate(
          surprizeQuiz.length,
          (index) {
            final audioPath = _audioPaths[index];
            // Only include local file paths for upload, not server paths
            final isLocalFile = audioPath != null &&
                !audioPath.startsWith('/uploads/') &&
                !audioPath.startsWith('http');

            return surprizeQuiz[index].copyWith(
              answer: textEditingControllers[index].text.trim(),
              audioPath: isLocalFile ? audioPath : null,
            );
          },
        ),
      );

      // Upload audio files if new recordings exist
      _loadingMessage = "Uploading audio notes";
      setState(() {});
      await ref.read(userProfileRepoProvider).postAudioNotes(userProfile);

      final updatedProfileMap =
          await ref.read(userProfileRepoProvider).updateUserProfile(userProfile);
      if (updatedProfileMap != null) {
        final updatedProfile = UserProfile.fromJson(updatedProfileMap);
        ref.read(userProvider.notifier).updateMyProfile(updatedProfile);
        await SharedPrefService.saveMyProfile(updatedProfile.toJson());
      }

      setState(() {
        _loading = false;
      });
      for (var e in deletedImages) {
        final id = _extractPhotoID(e);
        await ref.read(userProfileRepoProvider).deleteProfileImage(id);
      }
      navigatorKey.currentState!.pop();
      showSnackBar("Profile updated successfully");
    } catch (e) {
      showSnackBar("Failed to update profile");
      log("Error updating profile: $e");
      setState(() {
        _loading = false;
        _loadingMessage = null;
      });
    }
  }

  String _extractPhotoID(String url) {
    Uri uri = Uri.parse(url);
    final id = uri.queryParameters['photoId']!.split('-compressed').first;
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            if (!_loading) return;
            await ref.read(userProvider.notifier).updateMyProfile(profileSave);
            navigatorKey.currentState?.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(context),
          floatingActionButton: _submitButton(),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildNameEmailHeader(),
                    const SizedBox(height: 24),
                    _buildCustomTextField(
                      label: "Age",
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      label: "Instagram Username",
                      controller: _instaController,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      label: "WhatsApp Number",
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomTextField(
                      label: "Hometown",
                      controller: _hometownController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Profile Pictures",
                      style: CupidTextStyles.title2,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _profilePic(0, context),
                        const SizedBox(width: 16),
                        _profilePic(1, context),
                        const SizedBox(width: 16),
                        _profilePic(2, context),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Gender",
                      style: CupidTextStyles.title2,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: List.generate(Gender.values.length, (index) {
                        final gender = Gender.values[index];
                        final selected = _selectedGender == gender;
                        return _buildChip(gender.displayString, selected, () {
                          setState(() {
                            _selectedGender = gender;
                          });
                        });
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Program",
                      style: CupidTextStyles.title2,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: List.generate(programs.length, (index) {
                        final program = programs[index];
                        final selected = _selectedProgram == program;
                        return _buildChip(program.displayString, selected, () {
                          setState(() {
                            _selectedProgram = program;
                          });
                        });
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Year",
                      style: CupidTextStyles.title2,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: [
                        ...List.generate(5, (index) {
                          final year = index + 1;
                          return _buildChip(year.toString(), _yearOfJoin == year, () {});
                        }),
                        _buildChip("beyond", _yearOfJoin == 6, () {}),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Interests", style: CupidTextStyles.title2),
                        IconButton(
                          onPressed: () {
                            context.goNamed(AppRoutes.editInterests.name);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildInterests(),
                    const SizedBox(height: 16),
                    const Text(
                      'Sexual orientation',
                      style: CupidTextStyles.title2,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your results will be based on your preference',
                      style: CupidTextStyles.body1,
                    ),
                    const SizedBox(height: 8),
                    _buildSexualOrientationChoiceChips(_selectedSexualOrientation,
                        onSelected: (value) {
                      setState(() {
                        _selectedSexualOrientation = value;
                      });
                    }),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Display on profile',
                          style: CupidTextStyles.body1,
                        ),
                        Switch(
                          inactiveTrackColor: WidgetStateColor.transparent,
                          activeThumbColor: CupidColors.primary,
                          inactiveThumbColor: CupidColors.primary.withValues(alpha: 0.4),
                          activeTrackColor: CupidColors.primary.withValues(alpha: 0.4),
                          value: _displaySexualOrientation,
                          onChanged: (value) {
                            setState(() {
                              _displaySexualOrientation = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("Surprise quiz", style: CupidTextStyles.title2),
                    const SizedBox(height: 8),
                    _buildQuestions(),
                    const SizedBox(height: 16),
                    const Text("Looking for", style: CupidTextStyles.title2),
                    const SizedBox(height: 4),
                    const Text(
                      "The profiles showed to you will be based on this",
                      style: CupidTextStyles.body1,
                    ),
                    const SizedBox(height: 16),
                    _buildLookingForChoiceChips(_relationshipGoal, onSelected: (value) {
                      setState(() {
                        _relationshipGoal = value;
                      });
                    }),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Display on profile",
                          style: CupidTextStyles.body1,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _displayRelationshipGoal,
                          onChanged: (value) {
                            setState(() {
                              _displayRelationshipGoal = value;
                            });
                          },
                          inactiveTrackColor: WidgetStateColor.transparent,
                          activeThumbColor: CupidColors.primary,
                          inactiveThumbColor: CupidColors.primary.withValues(alpha: 0.4),
                          activeTrackColor: CupidColors.primary.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120)
                  ],
                ),
              ),
              if (_loadingMessage != null)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: CupidColors.secondaryColor,
                        ),
                        child: Text(
                          _loadingMessage!,
                          style: CupidTextStyles.body1.setColor(Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameEmailHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LoginStore.displayName ?? 'User',
          style: CupidTextStyles.brandTitle1.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          LoginStore.email ?? '',
          style: CupidTextStyles.body1.copyWith(
            color: CupidColors.greySecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupidColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: CupidColors.primaryDark, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Recording at least 1 voice note increases your chances of matchmaking.",
                  style: CupidTextStyles.normalTextStyle.copyWith(
                    color: CupidColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          surprizeQuiz.length,
          (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}',
                              style: CupidTextStyles.body2.copyWith(
                                color: CupidColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              surprizeQuiz[index].question,
                              style: CupidTextStyles.label1.copyWith(
                                color: CupidColors.grey950,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            var rand = math.Random().nextInt(quizQuestions.length);
                            while (surprizeQuiz
                                .any((e) => e.question == quizQuestions[rand].question)) {
                              rand = math.Random().nextInt(quizQuestions.length);
                            }
                            surprizeQuiz[index] = quizQuestions[rand];
                            textEditingControllers[index].clear();
                            _audioPaths[index] = null;
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh_rounded,
                              color: CupidColors.primary, size: 20),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          tooltip: 'Change question',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AudioRecorder(
                    existingFilePath: _audioPaths[index],
                    textController: textEditingControllers[index],
                    onRecordingComplete: (path) {
                      setState(() {
                        _audioPaths[index] = path;
                      });
                      log("Recording completed for question $index: $path");
                    },
                    onDelete: () {
                      setState(() {
                        _audioPaths[index] = null;
                      });
                      log("Recording deleted for question $index");
                    },
                    onChanged: (text) {
                      // Text changed callback
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Wrap _buildInterests() {
    return Wrap(
      spacing: 8,
      children: List.generate(
        ref.watch(onboardingControllerProvider).interests?.length ?? 0,
        (index) {
          final interest = ref.watch(onboardingControllerProvider).interests?[index] ?? "";
          return _buildChip(interest, false, () {});
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () async {
          await ref.read(userProvider.notifier).updateMyProfile(profileSave);
          navigatorKey.currentState?.pop();
        },
      ),
      scrolledUnderElevation: 0,
      title: const Text(
        "Edit Profile",
        style: CupidTextStyles.brandTitle1,
      ),
      centerTitle: false,
    );
  }

  Widget _buildChip(String option, bool isSelected, VoidCallback onSelected) {
    return ChoiceChip(
      label: Text(
        option,
        style: CupidTextStyles.label2.setColor(
          isSelected ? CupidColors.primary : CupidColors.blackColor,
        ),
      ),
      selected: isSelected,
      selectedColor: CupidColors.secondaryColor,
      elevation: 0,
      color: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return CupidColors.primary.withValues(alpha: 0.1);
          }
          return CupidColors.offWhiteColor;
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      checkmarkColor: CupidColors.primary,
      onSelected: (bool selected) {
        onSelected();
      },
    );
  }

  Widget _buildSexualOrientationChoiceChips(SexualOrientation? selectedChoice,
      {required Function(SexualOrientation) onSelected}) {
    return Wrap(
      spacing: 8,
      children: SexualOrientation.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidTextStyles.label2.copyWith(
              color: selectedChoice == tag ? CupidColors.primary : CupidColors.blackColor,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.primary.withValues(alpha: 0.1);
              }
              return CupidColors.offWhiteColor;
            },
          ),
          checkmarkColor: CupidColors.primary,
          selected: selectedChoice == tag,
          onSelected: (_) {
            onSelected(tag);
          },
        );
      }).toList(),
    );
  }

  Widget _buildLookingForChoiceChips(LookingFor? selectedChoice,
      {required void Function(LookingFor) onSelected}) {
    return Wrap(
      spacing: 8,
      children: LookingFor.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidTextStyles.label2.copyWith(
              color: selectedChoice == tag ? CupidColors.primary : CupidColors.blackColor,
            ),
          ),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.primary.withValues(alpha: 0.1);
              }
              return CupidColors.offWhiteColor;
            },
          ),
          checkmarkColor: CupidColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          selected: selectedChoice == tag,
          onSelected: (val) {
            onSelected(tag);
          },
        );
      }).toList(),
    );
  }

  Widget _profilePic(int index, BuildContext context) {
    String? url;
    String? blurHash;
    if (index <= ref.read(userProvider).myProfile!.images.length - 1) {
      url = ref.read(userProvider).myProfile!.images[index].url;
      blurHash = ref.read(userProvider).myProfile!.images[index].blurHash;
    }
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          final height = size * 4 / 3;
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF11142A), width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: SizedBox(
              height: height,
              child: newImages[index] != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            child: Image.file(newImages[index]!, fit: BoxFit.cover),
                          ),
                        ),
                        _deleteImageButton(index),
                      ],
                    )
                  : url != null
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: url,
                                  fadeInDuration: const Duration(milliseconds: 300),
                                  fadeOutDuration: const Duration(milliseconds: 100),
                                  placeholder: (context, url) {
                                    if (blurHash == null) {
                                      return const CustomLoader();
                                    }
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BlurhashFfi(hash: blurHash),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    if (blurHash == null) {
                                      return const CustomLoader();
                                    }
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BlurhashFfi(hash: blurHash),
                                    );
                                  },
                                ),
                              ),
                            ),
                            _deleteImageButton(index),
                          ],
                        )
                      : GestureDetector(
                          onTap: () async {
                            final image = await imageHelpers.pickImage();
                            if (image == null) return;
                            final pickedImage = await imageHelpers.xFileToImage(xFile: image);
                            if (!mounted) return;
                            final croppedImage =
                                await Navigator.of(context).push<File>(MaterialPageRoute(
                              builder: (context) => CropImageScreen(image: pickedImage),
                            ));
                            if (croppedImage == null) return;
                            setState(() {
                              newImages[index] = croppedImage;
                            });
                          },
                          child: const Center(
                            child: Icon(Icons.add, size: 40),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _deleteImageButton(int index) {
    return GestureDetector(
      onTap: () => _deleteImage(index),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withValues(
                alpha: 0.5,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                size: 20,
                color: CupidColors.secondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton _submitButton() {
    return FloatingActionButton(
      backgroundColor: CupidColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      onPressed: () {
        _updateProfile();
      },
      child: _loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(
              Icons.check,
              size: 30,
              color: Colors.white,
            ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CupidTextStyles.label1.copyWith(color: CupidColors.greySecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: CupidTextStyles.label2.copyWith(color: CupidColors.grey950),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
