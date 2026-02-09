import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/surprise_quiz.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_interests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/dating_preference.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/add_profile_photos.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/drive_connect.dart';
import 'package:college_cupid/shared/assets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSetup extends ConsumerStatefulWidget {
  const ProfileSetup({super.key});

  @override
  ConsumerState<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends ConsumerState<ProfileSetup> {
  final ScrollController _scrollController = ScrollController();

  final steps = [
    const BasicDetails(),
    const DatingPreferenceScreen(),
    const MoreAboutYou(),
    const ChooseInterests(),
    const AddPhotos(),
    const DriveConnect(),
  ];
  final List<String> stepTitles = [
    'Your Basic Details',
    'Dating Preferences',
    'More about you',
    'Interests',
    'Your Photos',
    'Connect Your Drive',
  ];
  final List<String> stepSubtitles = [
    '',
    '',
    'Answer 3 questions',
    '',
    '',
    'Secure storage for your data',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    final loading = onboardingState.loading;
    final loadingMessage = onboardingState.loadingMessage;
    final currentStepIndex = onboardingState.currentStep;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        CupidColors.navBarIconColor.withValues(alpha: 0.3),
                        CupidColors.navBarIconColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      CupidImages.onboardingImage,
                      height: 100,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stepTitles[currentStepIndex], style: CupidTextStyles.brandTitle1),
                          //  const SizedBox(height: 8),
                          if (stepSubtitles[currentStepIndex].isNotEmpty) ...[
                            Text(stepSubtitles[currentStepIndex], style: CupidTextStyles.body1),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ProfileProgressBar(
                        currentStep: currentStepIndex,
                        totalSteps: steps.length,
                      ),
                    ),
                    const SizedBox(height: 45),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        child: steps[currentStepIndex],
                      ),
                    ),
                  ],
                ),
                if (loading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: CupidColors.secondaryColor,
                          ),
                          if (loadingMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupidColors.secondaryColor,
                              ),
                              child: Text(
                                loadingMessage,
                                style: CupidStyles.normalTextStyle.setColor(Colors.white),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: !loading
              ? BottomNavButtons(
                  onBack: currentStepIndex > 0
                      ? () {
                          onboardingController.previousStep();
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  onNext: () {
                    onboardingController.nextStep();
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isNextEnabled: onboardingState.isNextEnabled,
                  nextLabel: currentStepIndex == steps.length - 1 ? 'Finish' : 'Next',
                )
              : null,
        ),
      ),
    );
  }
}
