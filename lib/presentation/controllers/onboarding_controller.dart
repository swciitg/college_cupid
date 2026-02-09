import 'dart:developer';
import 'dart:io';
import 'package:college_cupid/domain/models/personal_info.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
// import 'package:college_cupid/services/secure_storage_service.dart';
// import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/repositories/personal_info_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/diffie_hellman_constants.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref: ref),
);

enum OnboardingStep {
  basicDetails,
  datingPreference,
  surpriseQuiz,
  chooseInterests,
  addPhotos,
}

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingController({required Ref ref})
      : _ref = ref,
        super(OnboardingState(currentStep: 0));

  // final List<Map<String, HeartState>> _heartStates = [];

  // void updateHeartStates(BuildContext context) {
  //   if (_heartStates.isEmpty) {
  //     _heartStates.addAll(
  //       [
  //         // BasicDetails.heartStates(context),
  //         SexualOrientationScreen.heartStates(context),
  //         ChooseInterests.heartStates(context),
  //         AddPhotos.heartStates(context),
  //         LookingForScreen.heartStates(context),
  //         MbtiTestScreen.heartStates(context),
  //       ],
  //     );
  //   }
  //   final yellow = _heartStates[state.currentStep]['yellow'];
  //   final blue = _heartStates[state.currentStep]['blue'];
  //   final pink = _heartStates[state.currentStep]['pink'];

  //   state = state.copyWith(
  //     yellow: yellow,
  //     blue: blue,
  //     pink: pink,
  //   );
  // }

  void nextStep() async {
    final valid = await validateSubmit();
    if (!valid) return;
    if (state.currentStep < OnboardingStep.values.length - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    } else if (state.currentStep == OnboardingStep.values.length - 1) {
      navigatorKey.currentContext?.goNamed(AppRoutes.splash.name);
      showSnackBar("Profile setup complete");
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<bool> validateSubmit() async {
    switch (OnboardingStep.values[state.currentStep]) {
      case OnboardingStep.basicDetails:
        if (state.userProfile?.gender == null ||
                state.userProfile?.program == null ||
                state.userProfile?.insta.isEmpty == true ||
                state.userProfile?.phnNumber.isEmpty == true
            // || state.userProfile?.yearOfJoin == null
            ) {
          showSnackBar("Please fill in all fields");
          return false;
        }
        _initNewUser();
        return true;
      case OnboardingStep.datingPreference:
        if (state.userProfile?.sexualOrientation == null) {
          showSnackBar("Please select a sexual orientation");
          return false;
        }
        if (state.userProfile?.relationshipGoal == null) {
          showSnackBar("Please select what you're looking for");
          return false;
        }
        return true;
      case OnboardingStep.chooseInterests:
        if (state.interests == null || state.interests!.length < 5) {
          showSnackBar("Please select at least 5 interests");
          return false;
        }
        state = state.copyWith(
          userProfile: state.userProfile?.copyWith(interests: state.interests),
        );
        return true;
      case OnboardingStep.addPhotos:
        final nonNullImagesCount = state.images!.where((element) => element != null).length;
        if (nonNullImagesCount < 3) {
          showSnackBar("Select all images!");
          return false;
        }
        // Create user profile here so we can check isAdmin before drive connect
        final created = await createUser();
        if (created) {
          // Fetch the created user profile to get isAdmin status
          try {
            final userProfileMap =
                await _ref.read(userProfileRepoProvider).getUserProfile(LoginStore.email!);
            if (userProfileMap != null) {
              final userProfile = UserProfile.fromJson(userProfileMap);
              state = state.copyWith(
                userProfile: userProfile,
                isAdminUser: userProfile.isAdmin,
              );
              log("User isAdmin: ${userProfile.isAdmin}", name: "OnboardingController");
            }
          } catch (e) {
            log("Error fetching user profile for admin check: $e", name: "OnboardingController");
          }
        }
        return created;
      case OnboardingStep.surpriseQuiz:
        for (var e in state.userProfile!.surpriseQuiz) {
          if (e.answer.isEmpty && (e.audioPath == null || e.audioPath!.isEmpty)) {
            showSnackBar("Please answer all questions");

            return false;
          }
        }
        return true;
    }
  }

  void _initNewUser() async {
    KeyPair keyPair = DiffieHellman.generateKeyPair();
    String publicKey = keyPair.publicKey.toString();
    String privateKey = keyPair.privateKey.toString();

    PersonalInfo personalInfo = PersonalInfo(
      email: LoginStore.email!,
      sharedSecretList: [],
      matchedEmailList: [],
    );

    await SharedPrefService.setDHPublicKey(publicKey);
    await SharedPrefService.setDHPrivateKey(privateKey);

    state = state.copyWith(
      personalInfo: personalInfo,
      diffieHellmanPrivateKey: privateKey,
      userProfile: state.userProfile?.copyWith(
        name: LoginStore.displayName!,
        profilePicUrl: '',
        email: LoginStore.email,
        yearOfJoin: getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
        publicKey: publicKey,
      ),
    );
  }

  void updateAge(String ageStr) {
    int? age = int.tryParse(ageStr);
    if (age != null) {
      state = state.copyWith(
        userProfile: state.userProfile?.copyWith(age: age),
      );
    }
  }

  void updateGender(Gender gender) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(gender: gender),
    );
  }

  void updateHometown(String hometown) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(hometown: hometown),
    );
  }

  void updateZodiac(Zodiac value) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(zodiac: value),
    );
  }

  void updateProgram(Program program) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(program: program),
    );
  }

  void updatePhnNumber(String phnNumber) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(phnNumber: phnNumber),
    );
  }

  void updateInsta(String insta) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(insta: insta),
    );
  }

  void updateYearOfJoin(int year) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(yearOfJoin: year),
    );
  }

  void updateSexualOrientationDisplay(bool value) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(
        sexualOrientation: state.userProfile?.sexualOrientation?.copyWith(display: value),
      ),
    );
  }

  void updateSexualOrientation(SexualOrientation type) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(
        sexualOrientation: SexualOrientationModel(
          type: type,
          display: state.userProfile?.sexualOrientation?.display ?? false,
        ),
      ),
    );
  }

  void addInterest(String interest) {
    if ((state.interests ?? []).length >= 20) {
      showSnackBar("Only 20 interests are allowed!");
      return;
    }
    var interests = state.interests;
    interests ??= [];
    interests.add(interest);
    state = state.copyWith(interests: interests);
  }

  void removeInterest(String interest) {
    var interests = state.interests;
    interests ??= [];
    interests.remove(interest);
    state = state.copyWith(interests: interests);
  }

  void updateLookingForDisplay(bool value) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(
        relationshipGoal: state.userProfile?.relationshipGoal?.copyWith(display: value),
      ),
    );
  }

  void updateLookingForType(LookingFor type) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(
        relationshipGoal: RelationshipGoal(
          goal: type,
          display: state.userProfile?.relationshipGoal?.display ?? false,
        ),
      ),
    );
  }

  void pickImage(Future<File?> Function(Image) cropImage, int index) async {
    final image = await imageHelpers.pickImage();
    if (image == null) return;
    Image pickedImage = await imageHelpers.xFileToImage(xFile: image);
    final croppedImage = await cropImage(pickedImage);
    final images = state.images;
    images![index] = croppedImage;
    state = state.copyWith(images: images);
  }

  Future<bool> createUser() async {
    state = state.copyWith(loading: true);
    log(state.dhPrivateKey != null ? "DH Private Key exists" : "DH Private Key is null");
    log(state.userProfile != null ? "User Profile exists" : "User Profile is null");
    try {
      final personalInfoRepo = _ref.read(personalInfoRepoProvider);
      final userProfileRepo = _ref.read(userProfileRepoProvider);

      log("BEFORE POST - PersonalInfo: ${state.personalInfo?.toJson()}",
          name: "OnboardingController");
      await personalInfoRepo.postPersonalInfo(state.personalInfo!);
      log("PERSONAL INFO POSTED", name: "OnboardingController");

      state = state.copyWith(loadingMessage: "Uploading Profile Images");
      var imageProgress = 0.0;
      final imageModels = <ImageModel>[];

      log("IMAGES COUNT: ${state.images?.length}, Images: $state.images",
          name: "OnboardingController");
      for (int i = 0; i < state.images!.length; i++) {
        final image = state.images![i];
        if (image != null) {
          log("UPLOADING IMAGE $i", name: "OnboardingController");
          final imageUrl = await userProfileRepo.postUserProfileImage(
            image,
            onSendProgress: (val) {
              imageProgress = (i + val) / state.images!.length * 100;
              state = state.copyWith(
                loadingMessage: "Uploading Profile Images ${imageProgress.toInt()}%",
              );
            },
          );
          final blurHash = await imageHelpers.encodeBlurHash(imageProvider: FileImage(image));
          imageModels.add(ImageModel(url: imageUrl, blurHash: blurHash));
        }
      }
      log("IMAGES POSTED", name: "OnboardingController");
      state = state.copyWith(userProfile: state.userProfile?.copyWith(images: imageModels));
      state = state.copyWith(loadingMessage: "Creating User Profile");

      log("POSTING USER PROFILE: ${state.userProfile}", name: "OnboardingController");
      final createdProfile = await userProfileRepo.postUserProfile(state.userProfile!);
      log("USER PROFILE POSTED", name: "OnboardingController");

      // Update state with the profile returned from backend (includes _id)
      state = state.copyWith(userProfile: createdProfile);

      // Save profile to shared prefs BEFORE OneDrive upload so _getUserId() can access it
      await SharedPrefService.saveMyProfile(createdProfile.toJson());
      log("PROFILE SAVED TO SHARED PREFS with ID: ${createdProfile.id}",
          name: "OnboardingController");

      //upload voice
      await userProfileRepo.postAudioNotes(state.userProfile!);

      log("BEFORE DH KEY UPLOAD - Key: ${state.dhPrivateKey}", name: "OnboardingController");
      await OneDriveRepository.uploadDHPrivateKey(state.dhPrivateKey!);
      log("Private Key posted to storage: ${state.dhPrivateKey}", name: "OnboardingController");
      await _ref.read(userProvider.notifier).initializeProfile();
      state = state.copyWith(loading: false);
      return true;
    } catch (e, stackTrace) {
      log("CREATE USER ERROR: $e, StackTrace: $stackTrace");
      log("STATE AT ERROR - DH Key: ${state.dhPrivateKey}, UserProfile: ${state.userProfile}, Images: ${state.images}",
          name: "OnboardingController");
      showSnackBar("Something went wrong. Please try again");
      state = state.copyWith(loading: false);
      return false;
    }
  }

  void setInterests(List<String> interests) {
    state = state.copyWith(interests: interests);
  }

  void setSurpriseQuiz(List<QuizQuestion> ques) {
    final user = state.userProfile!.copyWith(surpriseQuiz: ques);
    state = state.copyWith(userProfile: user);
  }

  void updateSurpriseQuizAnswer(List<QuizQuestion> ques, int index) {
    final user = state.userProfile!.copyWith(surpriseQuiz: ques);
    state = state.copyWith(userProfile: user);
  }

  void reset() {
    state = OnboardingState(currentStep: 0);
  }

  /// Load user profile and personal info from backend
  Future<void> loadUserData() async {
    try {
      state = state.copyWith(loading: true, loadingMessage: "Loading your profile...");

      final email = LoginStore.email;
      if (email == null) {
        throw Exception("User email not found");
      }

      // Fetch user profile from backend
      final userProfileMap = await _ref.read(userProfileRepoProvider).getUserProfile(email);
      if (userProfileMap != null) {
        final userProfile = UserProfile.fromJson(userProfileMap);
        await _ref.read(userProvider.notifier).updateMyProfile(userProfile);
        await SharedPrefService.setDHPublicKey(userProfile.publicKey);
        log("User profile loaded successfully");
      }

      // Fetch personal info from backend
      final personalInfo = await _ref.read(personalInfoRepoProvider).getPersonalInfo();
      if (personalInfo != null) {
        log("Personal info loaded successfully");
      }

      state = state.copyWith(loading: false, loadingMessage: null);
    } catch (e) {
      log("Error loading user data: $e");
      state = state.copyWith(loading: false, loadingMessage: null);
      throw Exception("Failed to load user data: $e");
    }
  }
}

class OnboardingState {
  final PersonalInfo? personalInfo;
  final String? dhPrivateKey;
  final int currentStep;
  late UserProfile? userProfile;
  late List<File?>? images;
  final int year;
  final List<String>? interests;
  final bool? isAdminUser;
  final HeartState? yellow;
  final HeartState? blue;
  final HeartState? pink;
  final bool loading;
  final String? loadingMessage;

  OnboardingState({
    this.personalInfo,
    this.dhPrivateKey,
    required this.currentStep,
    this.userProfile,
    this.images,
    this.year = 1,
    this.interests,
    this.isAdminUser,
    this.yellow,
    this.blue,
    this.pink,
    this.loading = false,
    this.loadingMessage,
  }) {
    images ??= [null, null, null];
    userProfile ??= UserProfile();
  }

  // Dynamic validation for next button
  bool get isNextEnabled {
    switch (OnboardingStep.values[currentStep]) {
      case OnboardingStep.basicDetails:
        return userProfile?.gender != null &&
            userProfile?.program != null &&
            userProfile?.insta.isNotEmpty == true &&
            userProfile?.phnNumber.isNotEmpty == true;
      case OnboardingStep.datingPreference:
        return userProfile?.sexualOrientation != null && userProfile?.relationshipGoal != null;
      case OnboardingStep.chooseInterests:
        return interests != null && interests!.length >= 5;
      case OnboardingStep.addPhotos:
        final nonNullImagesCount = images?.where((element) => element != null).length ?? 0;
        return nonNullImagesCount >= 3;
      case OnboardingStep.surpriseQuiz:
        return userProfile?.surpriseQuiz.every(
                (e) => e.answer.isNotEmpty || (e.audioPath != null && e.audioPath!.isNotEmpty)) ??
            false;
    }
  }

  OnboardingState copyWith({
    PersonalInfo? personalInfo,
    String? diffieHellmanPrivateKey,
    int? currentStep,
    UserProfile? userProfile,
    List<File?>? images,
    int? year,
    SexualOrientationModel? sexualOrientation,
    List<String>? interests,
    bool? isAdminUser,
    HeartState? yellow,
    HeartState? blue,
    HeartState? pink,
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    bool? loading,
    String? loadingMessage,
  }) {
    return OnboardingState(
      personalInfo: personalInfo ?? this.personalInfo,
      dhPrivateKey: diffieHellmanPrivateKey ?? dhPrivateKey,
      currentStep: currentStep ?? this.currentStep,
      userProfile: userProfile ?? this.userProfile,
      images: images ?? this.images,
      year: year ?? this.year,
      interests: interests ?? this.interests,
      isAdminUser: isAdminUser ?? this.isAdminUser,
      yellow: yellow ?? this.yellow,
      blue: blue ?? this.blue,
      pink: pink ?? this.pink,
      loading: loading ?? this.loading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }
}
