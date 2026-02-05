import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectableInterestCard extends ConsumerWidget {
  final String text;
  final bool selected;

  const SelectableInterestCard({
    super.key,
    required this.selected,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    return ChoiceChip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
      side: BorderSide.none,
      label: Text(
        text,
        style: CupidTextStyles.label2.setColor(
          selected ? CupidColors.primaryDark : CupidColors.greySecondary,
        ),
      ),
      selected: selected,
      elevation: 0,
      color: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return CupidColors.primaryLight;
          }
          return CupidColors.surfaceSpecialSecondaryAlphaBase;
        },
      ),
      checkmarkColor: Colors.white,
      onSelected: (bool selected) {
        if (!selected) {
          onboardingController.removeInterest(text);
        } else {
          onboardingController.addInterest(text);
        }
      },
    );
  }
}
