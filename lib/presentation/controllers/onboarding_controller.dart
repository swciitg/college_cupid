import 'dart:developer';
import 'dart:io';

import 'package:college_cupid/domain/models/personal_info.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/add_profile_photos.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_interests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_test_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/sexual_orientation_screen.dart';
import 'package:college_cupid/repositories/personal_info_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/diffie_hellman_constants.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref: ref),
);

enum OnboardingStep {
  basicDetails,
  sexualOrientation,
  chooseInterests,
  addPhotos,
  lookingFor;
  // mbtiTest;
}

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref _ref;
  OnboardingController({required Ref ref})
      : _ref = ref,
        super(OnboardingState(currentStep: 0));

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final List<Map<String, HeartState>> _heartStates = [];

  void updateHeartStates(BuildContext context) {
    if (_heartStates.isEmpty) {
      _heartStates.addAll(
        [
          BasicDetails.heartStates(context),
          SexualOrientationScreen.heartStates(context),
          ChooseInterests.heartStates(context),
          AddPhotos.heartStates(context),
          LookingForScreen.heartStates(context),
          MbtiTestScreen.heartStates(context),
        ],
      );
    }
    final yellow = _heartStates[state.currentStep]['yellow'];
    final blue = _heartStates[state.currentStep]['blue'];
    final pink = _heartStates[state.currentStep]['pink'];

    state = state.copyWith(
      yellow: yellow,
      blue: blue,
      pink: pink,
    );
  }

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

  Future<bool> validateSubmit({bool submit = true}) async {
    switch (OnboardingStep.values[state.currentStep]) {
      case OnboardingStep.basicDetails:
        final password = passwordController.text.trim();
        if (password.length < 6) {
          if (submit) showSnackBar("Password must be at least 6 characters long");
          return false;
        }
        final confirmPassword = confirmPasswordController.text.trim();
        if (password != confirmPassword) {
          if (submit) showSnackBar("Passwords do not match");
          return false;
        }
        if (bioController.text.trim().isEmpty) {
          if (submit) showSnackBar("Bio cannot be empty");
          return false;
        }
        if (state.userProfile?.gender == null ||
            state.userProfile?.program == null ||
            state.userProfile?.yearOfJoin == null) {
          if (submit) showSnackBar("Please fill in all fields");
          return false;
        }
        if (submit) _initNewUser();
        return true;
      case OnboardingStep.sexualOrientation:
        if (state.userProfile?.sexualOrientation == null) {
          if (submit) showSnackBar("Please select a sexual orientation");
          return false;
        }
        return true;
      case OnboardingStep.chooseInterests:
        if (state.interests == null || state.interests!.length < 5) {
          if (submit) showSnackBar("Please select at least 5 interests");
          return false;
        }
        state = state.copyWith(
          userProfile: state.userProfile?.copyWith(interests: state.interests),
        );
        return true;
      case OnboardingStep.addPhotos:
        final nonNullImagesCount = state.images!.where((element) => element != null).length;
        if (nonNullImagesCount < 2) {
          if (submit) showSnackBar("Please upload atleast 2 photos");
          return false;
        }
        return true;
      case OnboardingStep.lookingFor:
        if (state.userProfile?.relationshipGoals == null) {
          if (submit) showSnackBar("Please select what you're looking for");
          return false;
        }
        return await createUser();
    }
  }

  void _initNewUser() async {
    KeyPair keyPair = DiffieHellman.generateKeyPair();
    String publicKey = keyPair.publicKey.toString();
    String privateKey = keyPair.privateKey.toString();
    final pass = passwordController.text.trim();
    String encryptedPrivateKey = Encryption.bytesToHexadecimal(
      Encryption.encryptAES(plainText: privateKey, key: pass),
    );

    PersonalInfo personalInfo = PersonalInfo(
      email: LoginStore.email!,
      hashedPassword: Encryption.bytesToHexadecimal(
        Encryption.calculateSHA256(pass),
      ),
      encryptedPrivateKey: encryptedPrivateKey,
      publicKey: publicKey,
      crushes: [],
      encryptedCrushes: [],
      matches: [],
    );

    await SharedPrefs.setDHPublicKey(publicKey);
    await SharedPrefs.setDHPrivateKey(privateKey);
    await SharedPrefs.setPassword(pass);

    state = state.copyWith(
      personalInfo: personalInfo,
      userProfile: state.userProfile?.copyWith(
        name: LoginStore.displayName!,
        profilePicUrl: '',
        email: LoginStore.email,
        bio: bioController.text.trim(),
        yearOfJoin: getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
        publicKey: publicKey,
      ),
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(gender: gender),
    );
  }

  void updateProgram(Program program) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(program: program),
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
        relationshipGoals: state.userProfile?.relationshipGoals?.copyWith(display: value),
      ),
    );
  }

  void updateLookingForType(LookingFor type) {
    state = state.copyWith(
      userProfile: state.userProfile?.copyWith(
        relationshipGoals: RelationshipGoal(
          goal: type,
          display: state.userProfile?.relationshipGoals?.display ?? false,
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
    try {
      final personalInfoRepo = _ref.read(personalInfoRepoProvider);
      final userProfileRepo = _ref.read(userProfileRepoProvider);
      await personalInfoRepo.postPersonalInfo(state.personalInfo!);
      log("PERSONAL INFO POSTED", name: "OnboardingController");
      state = state.copyWith(loadingMessage: "Uploading Profile Images");
      var imageProgress = 0.0;
      final imageModels = <ImageModel>[];
      for (int i = 0; i < state.images!.length; i++) {
        final image = state.images![i];
        if (image != null) {
          final imageUrl = await userProfileRepo.postUserProfileImage(image, onSendProgress: (val) {
            imageProgress = (i + val) / state.images!.length * 100;
            state = state.copyWith(
              loadingMessage: "Uploading Profile Images ${imageProgress.toStringAsFixed(2)}%",
            );
          });
          final blurHash = await imageHelpers.encodeBlurHash(imageProvider: FileImage(image));
          imageModels.add(ImageModel(url: imageUrl, blurHash: blurHash));
        }
      }
      log("IMAGES POSTED", name: "OnboardingController");
      state = state.copyWith(userProfile: state.userProfile?.copyWith(images: imageModels));
      state = state.copyWith(loadingMessage: "Creating User Profile");
      await userProfileRepo.postUserProfile(state.userProfile!);
      log("USER PROFILE POSTED", name: "OnboardingController");
      await SharedPrefs.saveMyProfile(state.userProfile!.toJson());
      await _ref.read(userProvider.notifier).initializeProfile();
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      log("CREATE USER ERROR: $e");
      showSnackBar("Something went wrong. Please try again");
      state = state.copyWith(loading: false);
      return false;
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

class OnboardingState {
  final PersonalInfo? personalInfo;
  final int currentStep;
  late UserProfile? userProfile;
  late List<File?>? images;
  final int year;
  final List<String>? interests;
  final HeartState? yellow;
  final HeartState? blue;
  final HeartState? pink;
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final bool loading;
  final String? loadingMessage;

  OnboardingState({
    this.personalInfo,
    required this.currentStep,
    this.userProfile,
    this.images,
    this.year = 1,
    this.interests,
    this.yellow,
    this.blue,
    this.pink,
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.loading = false,
    this.loadingMessage,
  }) {
    images ??= [null, null, null];
    userProfile ??= UserProfile();
  }

  OnboardingState copyWith({
    PersonalInfo? personalInfo,
    int? currentStep,
    UserProfile? userProfile,
    List<File?>? images,
    int? year,
    SexualOrientationModel? sexualOrientation,
    List<String>? interests,
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
      currentStep: currentStep ?? this.currentStep,
      userProfile: userProfile ?? this.userProfile,
      images: images ?? this.images,
      year: year ?? this.year,
      interests: interests ?? this.interests,
      yellow: yellow ?? this.yellow,
      blue: blue ?? this.blue,
      pink: pink ?? this.pink,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
      loading: loading ?? this.loading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }
}
