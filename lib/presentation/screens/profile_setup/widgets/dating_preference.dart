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
    final onboardingController = ref.read(onboardingControllerProvider.notifier);

    final TextStyle headingStyle = CupidTextStyles.normalTextStyle.copyWith(
      fontSize: 16,
      color: CupidColors.grey600,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Sexual Orientation",
          style:headingStyle  
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: SexualOrientation.values.map((orientation) {
            return SelectionChip(
              label: orientation.displayString,
              isSelected: onboardingState.userProfile?.sexualOrientation?.type == orientation,
              onTap: () => onboardingController.updateSexualOrientation(orientation),
              textStyle: CupidTextStyles.normalTextStyle.copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.brandPurple600,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        
        // Type of Relationship Section
         Text(
          "Type of Relationship",
          style: headingStyle
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: LookingFor.values.map((goal) {
            return SelectionChip(
              label: goal.displayString,
              isSelected: onboardingState.userProfile?.relationshipGoal?.goal == goal,
              onTap: () => onboardingController.updateLookingForType(goal),
              textStyle: CupidTextStyles.normalTextStyle.copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.brandPurple600,
                fontWeight: FontWeight.bold,
              ),

            );
          }).toList(),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
