import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class MBTIOptionButton extends StatelessWidget {
  final int index;
  final bool selected;
  final VoidCallback onTap;
  const MBTIOptionButton({
    super.key,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: EdgeInsets.only(right: index != 4 ? 8 : 0),
          decoration: BoxDecoration(
            color: selected
                ? CupidColors.cupidGreen.withValues(alpha: 0.8)
                : CupidColors.glassWhite,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: selected ? Colors.black54 : Colors.black38),
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: CupidStyles.normalTextStyle.copyWith(
                color: selected ? Colors.white : CupidColors.textColorBlack,
                fontSize: selected ? 16 : null,
                fontWeight: selected ? FontWeight.w900 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
