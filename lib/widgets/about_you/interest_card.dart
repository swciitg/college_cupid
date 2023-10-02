import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class InterestCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? gapInBetween;
  const InterestCard({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.height,
    this.width,
    this.gapInBetween,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15).copyWith(left: 15),
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? CupidColors.titleColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CupidColors.titleColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CupidColors.secondaryColor.withOpacity(0.75),
                    blurRadius: 10,
                    offset: const Offset(4, 7),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : CupidColors.titleColor,
            ),
            SizedBox(width: gapInBetween ?? 10),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: CupidStyles.normalTextStyle.copyWith(
                color: isSelected ? Colors.white : CupidColors.normalTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
