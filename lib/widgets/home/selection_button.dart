import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final bool isSelected;
  final VoidCallback? onTap;
  const SelectionButton({
    super.key,
    required this.label,
    required this.isSelected,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isSelected
                ? CupidColors.pinkColor
                : CupidColors.backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(15),
            border: border ?? Border.all(color: CupidColors.pinkColor),
          ),
          child: Center(
            child: Text(
              label,
              style: isSelected
                  ? CupidStyles.normalTextStyle.copyWith(
                      fontSize: 14,
                      color: CupidColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    )
                  : CupidStyles.normalTextStyle.copyWith(
                      fontSize: 14,
                      color: CupidColors.blackColor,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
