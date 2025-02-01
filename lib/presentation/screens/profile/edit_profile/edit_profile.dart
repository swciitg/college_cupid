import 'dart:developer';
import 'dart:io';

import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends ConsumerStatefulWidget {
  static const id = 'editProfile';
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  List<Program> programs = Program.values.where((e) => e != Program.none).toList();
  late TextEditingController _bioController;
  late Gender _selectedGender;
  late Program _selectedProgram;
  late int _yearOfJoin;
  var _loading = false;
  String? _loadingMessage;
  late SexualOrientation _selectedSexualOrientation;
  late bool _displaySexualOrientation;
  late LookingFor _relationshipGoal;
  late bool _displayRelationshipGoal;
  List<File?> newImages = [null, null, null];
  List<ImageModel> deletedImages = [];
  late UserProfile profileSave;

  @override
  void initState() {
    final userState = ref.read(userProvider);
    profileSave = userState.myProfile!;
    _selectedProgram = userState.myProfile!.program!;
    _selectedGender = userState.myProfile!.gender!;
    _selectedSexualOrientation = userState.myProfile!.sexualOrientation!.type;
    _displaySexualOrientation = userState.myProfile!.sexualOrientation!.display;
    _yearOfJoin = DateTime.now().year % 100 - userState.myProfile!.yearOfJoin!;
    _relationshipGoal = userState.myProfile!.relationshipGoal?.goal ?? LookingFor.longTermPartner;
    _displayRelationshipGoal = userState.myProfile!.relationshipGoal?.display ?? true;
    _bioController = TextEditingController(text: userState.myProfile!.bio);
    super.initState();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _deleteImage(int index) {
    if (newImages[index] != null) {
      newImages[index] == null;
    }
    if (index < ref.read(userProvider).myProfile!.images.length) {
      final image = ref.read(userProvider).myProfile!.images[index];
      if (!deletedImages.contains(image)) {
        deletedImages.add(image);
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
    final bio = _bioController.text.trim();
    if (bio.isEmpty) {
      showSnackBar("Bio cannot be empty");
      return;
    }
    setState(() {
      _loading = true;
    });
    var profile = ref.read(userProvider).myProfile!;
    var newImagesLenth = newImages.where((e) => e != null).length;
    var updatedImages = profile.images;
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
              _loadingMessage = "Uploading Image(s) : ${imageProgress.toStringAsFixed(2)}%";
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
      bio: bio,
      gender: _selectedGender,
      program: _selectedProgram,
      sexualOrientation: SexualOrientationModel(
        type: _selectedSexualOrientation,
        display: _displaySexualOrientation,
      ),
      relationshipGoal: RelationshipGoal(
        goal: _relationshipGoal,
        display: _displayRelationshipGoal,
      ),
      images: updatedImages,
    );
    try {
      await ref.read(userProfileRepoProvider).updateUserProfile(userProfile);
      ref.read(userProvider.notifier).updateMyProfile(userProfile);
      await SharedPrefs.saveMyProfile(userProfile.toJson());
      ref.read(userProvider.notifier).updateMyProfile(userProfile);
      setState(() {
        _loading = false;
      });
      for (var e in deletedImages) {
        final id = _extractPhotoID(e.url);
        await ref.read(userProfileRepoProvider).deleteProfileImage(id);
      }
      navigatorKey.currentState!.pop();
      showSnackBar("Profile updated successfully");
    } catch (e) {
      showSnackBar("Failed to update profile");
      setState(() {
        _loading = false;
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await ref.read(userProvider.notifier).updateMyProfile(profileSave);
          navigatorKey.currentState?.pop();
        }
      },
      child: Scaffold(
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
                  TextField(
                    controller: TextEditingController(text: LoginStore.displayName),
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: "Name",
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.secondaryColor),
                      enabled: false,
                      fillColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: LoginStore.email),
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: "Email",
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.secondaryColor),
                      enabled: false,
                      fillColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Bio",
                    style: CupidStyles.subHeadingTextStyle,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bioController,
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      hintText: "Bio",
                      hintStyle: const TextStyle(color: CupidColors.secondaryColor),
                      enabled: true,
                      fillColor: Colors.transparent,
                    ),
                    maxLines: 5,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Profile Pictures",
                    style: CupidStyles.subHeadingTextStyle,
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
                    style: CupidStyles.subHeadingTextStyle,
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
                    style: CupidStyles.subHeadingTextStyle,
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
                    style: CupidStyles.subHeadingTextStyle,
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
                  const Text(
                    'Sexual orientation',
                    style: CupidStyles.subHeadingTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your results will be based on your preference',
                    style: CupidStyles.normalTextStyle,
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
                        style: CupidStyles.lightTextStyle,
                      ),
                      Switch(
                        activeColor: CupidColors.secondaryColor,
                        inactiveThumbColor: CupidColors.secondaryColor,
                        inactiveTrackColor: CupidColors.offWhiteColor,
                        value: _displaySexualOrientation,
                        onChanged: (value) {
                          setState(() {
                            _displaySexualOrientation = value;
                          });
                        },
                      ),
                    ],
                  ),
                  //
                  // TODO: Redirect to choose interests
                  //
                  const Text("Looking for", style: CupidStyles.subHeadingTextStyle),
                  const SizedBox(height: 5),
                  const Text(
                    "The profiles showed to you will be based on this",
                    style: CupidStyles.normalTextStyle,
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
                        style: CupidStyles.lightTextStyle,
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
                        activeColor: Colors.pinkAccent,
                        inactiveThumbColor: const Color(0xFFFBA8AA),
                        activeTrackColor: const Color(0x48FBA8AA),
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
                    child: Text(
                      _loadingMessage!,
                      style: CupidStyles.normalTextStyle,
                    ),
                  ),
                ),
              ),
          ],
        ),
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
        style: CupidStyles.headingStyle,
      ),
      centerTitle: false,
    );
  }

  Widget _buildChip(String option, bool isSelected, VoidCallback onSelected) {
    return ChoiceChip(
      label: Text(
        option,
        style: CupidStyles.normalTextStyle.setColor(
          isSelected ? Colors.white : CupidColors.textColorBlack,
        ),
      ),
      selected: isSelected,
      selectedColor: CupidColors.secondaryColor,
      elevation: 0,
      color: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return CupidColors.secondaryColor;
          }
          return Colors.transparent;
        },
      ),
      checkmarkColor: Colors.white,
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
            style: CupidStyles.normalTextStyle.copyWith(
              color: selectedChoice == tag ? Colors.white : CupidColors.textColorBlack,
            ),
          ),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.secondaryColor;
              }
              return Colors.transparent;
            },
          ),
          checkmarkColor: Colors.white,
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
            style: CupidStyles.normalTextStyle.copyWith(
              color: selectedChoice == tag ? Colors.white : CupidColors.textColorBlack,
            ),
          ),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.secondaryColor;
              }
              return Colors.transparent;
            },
          ),
          checkmarkColor: Colors.white,
          selected: selectedChoice == tag,
          onSelected: (val) {
            onSelected(tag);
          },
        );
      }).toList(),
    );
  }

  Widget _profilePic(int index, BuildContext context) {
    final image = newImages[index];
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
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: SizedBox(
              height: height,
              child: image != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Image.file(image, fit: BoxFit.cover),
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
                                  Radius.circular(30),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: url,
                                  placeholder: (context, url) {
                                    if (blurHash == null) return const CustomLoader();
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

  GestureDetector _deleteImageButton(int index) {
    return GestureDetector(
      onTap: () => _deleteImage(index),
      child: Align(
        alignment: Alignment.center,
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
    );
  }

  FloatingActionButton _submitButton() {
    return FloatingActionButton(
      backgroundColor: CupidColors.titleColor,
      onPressed: () {
        _updateProfile();
      },
      child: _loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(
              FluentIcons.save_16_regular,
              size: 30,
              color: Colors.white,
            ),
    );
  }
}
