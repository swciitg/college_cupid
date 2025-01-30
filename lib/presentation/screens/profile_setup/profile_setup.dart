import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_interests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/add_profile_photos.dart';
// import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_test_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/onboarding_navigation_buttons.dart';
import 'package:college_cupid/shared/assets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/heart_shape.dart';
import 'widgets/sexual_orientation_screen.dart';

class ProfileSetup extends ConsumerStatefulWidget {
  const ProfileSetup({super.key});

  @override
  ConsumerState<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends ConsumerState<ProfileSetup> {
  final steps = [
    const BasicDetails(),
    const SexualOrientationScreen(),
    const ChooseInterests(),
    const AddPhotos(),
    const LookingForScreen(),
    // const MbtiTestScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardingController = ref.read(onboardingControllerProvider.notifier);
      onboardingController.updateHeartStates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final onboardingState = ref.watch(onboardingControllerProvider);
    final loading = onboardingState.loading;
    final loadingMessage = onboardingState.loadingMessage;
    return Scaffold(
      backgroundColor: CupidColors.glassWhite,
      body: Stack(
        children: [
          ..._heartShapes(),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: steps[onboardingState.currentStep],
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                        color: CupidColors.secondaryColor,
                      ),
                    ),
                    if (loadingMessage != null) const SizedBox(height: 16),
                    if (loadingMessage != null)
                      Text(
                        loadingMessage,
                        style: CupidStyles.normalTextStyle,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: !loading ? const OnboaringNavigationButtons() : null,
    );
  }

  List<Widget> _heartShapes() {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final yellow = onboardingState.yellow;
    final blue = onboardingState.blue;
    final pink = onboardingState.pink;
    if (yellow == null || blue == null || pink == null) {
      return [const SizedBox()];
    }
    return [
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: yellow.top,
        right: yellow.right,
        bottom: yellow.bottom,
        left: yellow.left,
        child: HeartShape(
          size: yellow.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99EAE27A),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: blue.top,
        right: blue.right,
        bottom: blue.bottom,
        left: blue.left,
        child: HeartShape(
          size: blue.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99A8CEFA),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: pink.top,
        right: pink.right,
        bottom: pink.bottom,
        left: pink.left,
        child: HeartShape(
          size: pink.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99F9A8D4),
        ),
      ),
    ];
  }
}
