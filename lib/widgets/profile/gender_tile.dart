import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:flutter/cupertino.dart';

class GenderTile extends StatelessWidget {
  final Gender gender;
  final bool isSelected;

  const GenderTile({required this.isSelected, required this.gender, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          color:
              isSelected ? CupidColors.titleColor : CupidColors.backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          gender.displayString,
          style: TextStyle(
              color: isSelected
                  ? CupidColors.offWhiteColor
                  : CupidColors.titleColor),
        ),
      )),
    );
  }
}
