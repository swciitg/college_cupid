import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'heart_state.dart';

class LookingForScreen extends ConsumerWidget {
  const LookingForScreen({super.key});

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 200,
        top: 50,
        right: 0,
      ),
      "blue": HeartState(
        size: 200,
        left: -75,
        bottom: size.height * 0.27,
      ),
      "pink": HeartState(
        size: 200,
        right: -40,
        bottom: size.height * 0.05,
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Looking for", style: CupidStyles.headingStyle),
        const SizedBox(height: 5),
        const Text(
          "The profiles showed to you will be based on this",
          style: CupidStyles.normalTextStyle,
        ),
        const SizedBox(height: 16),
        _buildchoiceChips(onboardingState.userProfile?.relationshipGoal?.goal,
            onSelected: (value) {
          onboardingController.updateLookingForType(value);
        }),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Display on profile",
              style: CupidStyles.lightTextStyle,
            ),
            const SizedBox(width: 8),
            Switch(
              value: onboardingState.userProfile?.relationshipGoal?.display ??
                  false,
              onChanged: (value) {
                onboardingController.updateLookingForDisplay(value);
              },
              inactiveTrackColor: WidgetStateColor.transparent,
              activeColor: Colors.pinkAccent,
              inactiveThumbColor: const Color(0xFFFBA8AA),
              activeTrackColor: const Color(0x48FBA8AA),
            ),
          ],
        ),
        const SizedBox(height: 2 * kBottomNavigationBarHeight),
      ],
    );
  }

  Widget _buildchoiceChips(LookingFor? selectedChoice,
      {required void Function(LookingFor) onSelected}) {
    return Wrap(
      spacing: 8,
      children: LookingFor.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidStyles.normalTextStyle.copyWith(
              color: selectedChoice == tag
                  ? Colors.white
                  : CupidColors.textColorBlack,
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
}
