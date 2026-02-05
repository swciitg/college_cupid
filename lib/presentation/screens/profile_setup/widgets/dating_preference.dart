import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatingPreferenceScreen extends ConsumerWidget {
  const DatingPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sexual Orientation",
            style: CupidTextStyles.label1
                .copyWith(color: CupidColors.greySecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: SexualOrientation.values.map((orientation) {
            return SelectionChip(
              label: orientation.displayString,
              isSelected:
                  onboardingState.userProfile?.sexualOrientation?.type ==
                      orientation,
              onTap: () =>
                  onboardingController.updateSexualOrientation(orientation),
              textStyle: CupidTextStyles.normalTextStyle
                  .copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text("Type of Relationship",
            style: CupidTextStyles.label1
                .copyWith(color: CupidColors.greySecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: LookingFor.values.map((goal) {
            return SelectionChip(
              label: goal.displayString,
              isSelected:
                  onboardingState.userProfile?.relationshipGoal?.goal == goal,
              onTap: () => onboardingController.updateLookingForType(goal),
              textStyle: CupidTextStyles.normalTextStyle
                  .copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 150,
                  decoration: BoxDecoration(
                    shape:
                        BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CupidColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset( 0, 10), 
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/dating_pref_doll.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
