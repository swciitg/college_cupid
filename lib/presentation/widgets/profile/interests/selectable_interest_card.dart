import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
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
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    return GestureDetector(
      onTap: () {
        if (selected) {
          onboardingController.removeInterest(text);
        } else {
          onboardingController.addInterest(text);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? CupidColors.selectedInterestTileColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 1,
              color:
                  selected ? CupidColors.selectedInterestTileBorderColor : CupidColors.greyColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
