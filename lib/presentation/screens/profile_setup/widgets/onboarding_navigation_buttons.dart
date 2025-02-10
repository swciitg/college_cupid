import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboaringNavigationButtons extends ConsumerWidget {
  const OnboaringNavigationButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    final onboardingState = ref.watch(onboardingControllerProvider);
    final currentStep = onboardingState.currentStep;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: currentStep == 0 || currentStep == 2
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep != 0 && currentStep != 2)
            ElevatedButton(
              key: const Key('back_button'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(CupidColors.secondaryColor),
                elevation: WidgetStateProperty.all(0),
                overlayColor: WidgetStateProperty.all(CupidColors.secondaryColor),
              ),
              onPressed: () => onboardingController.previousStep(),
              child: Text('Back', style: CupidStyles.normalTextStyle.setColor(Colors.white)),
            ),
          ElevatedButton(
            key: const Key('next_button'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(CupidColors.secondaryColor),
              elevation: WidgetStateProperty.all(0),
              overlayColor: WidgetStateProperty.all(CupidColors.secondaryColor),
            ),
            onPressed: () => onboardingController.nextStep(),
            child: Text('Next', style: CupidStyles.normalTextStyle.setColor(Colors.white)),
          ),
        ],
      ),
    );
  }
}
