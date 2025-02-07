import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'heart_state.dart';

class SexualOrientationScreen extends ConsumerWidget {
  const SexualOrientationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Choose your \n',
                style: CupidStyles.subHeadingTextStyle,
              ),
              TextSpan(
                text: 'Sexual orientation',
                style: CupidStyles.headingStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your results will be based on your preference',
          style: CupidStyles.normalTextStyle,
        ),
        const SizedBox(height: 24),
        _buildchoiceChips(onboardingState.userProfile?.sexualOrientation?.type,
            onSelected: (value) {
          onboardingController.updateSexualOrientation(value);
        }),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Display on profile',
              style: CupidStyles.lightTextStyle,
            ),
            Switch(
              inactiveTrackColor: WidgetStateColor.transparent,
              activeColor: CupidColors.secondaryColor,
              inactiveThumbColor:
                  CupidColors.secondaryColor.withValues(alpha: 0.4),
              activeTrackColor:
                  CupidColors.secondaryColor.withValues(alpha: 0.4),
              value: onboardingState.userProfile?.sexualOrientation?.display ??
                  false,
              onChanged: (value) {
                onboardingController.updateSexualOrientationDisplay(value);
              },
            ),
          ],
        ),
        const SizedBox(height: 2 * kBottomNavigationBarHeight),
      ],
    );
  }

  Widget _buildchoiceChips(SexualOrientation? selectedChoice,
      {required Function(SexualOrientation) onSelected}) {
    return Wrap(
      spacing: 8,
      children: SexualOrientation.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidStyles.normalTextStyle.copyWith(
              color: selectedChoice == tag
                  ? Colors.white
                  : CupidColors.textColorBlack,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.secondaryColor;
              }
              return Colors.white;
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

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 500,
        left: 0,
        bottom: -size.height * .15,
      ),
      "blue": HeartState(
        size: 200,
        right: size.width * 0.27,
        top: size.height * 0.07,
      ),
      "pink": HeartState(
        size: 125,
        right: 0,
        bottom: size.height * 0.07,
      ),
    };
  }
}
