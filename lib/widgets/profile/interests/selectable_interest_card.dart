import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectableInterestCard extends StatelessWidget {
  final String text;
  final bool selected;

  const SelectableInterestCard(
      {super.key, required this.selected, required this.text});

  @override
  Widget build(BuildContext context) {
    final interestStore = context.read<InterestStore>();
    return GestureDetector(
      onTap: () {
        if (selected) {
          interestStore.removeInterest(text);
        } else {
          interestStore.addInterest(text);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              selected ? CupidColors.selectedInterestTileColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 1,
              color: selected
                  ? CupidColors.selectedInterestTileBorderColor
                  : CupidColors.grayColor),
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
