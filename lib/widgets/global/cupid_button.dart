import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:flutter/material.dart';

class CupidButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final TextStyle? style;
  final bool? loading;

  const CupidButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.style,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 60,
        width: width ?? screenWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? CupidColors.titleColor,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
        ),
        child: Center(
          child: loading!
              ? const CustomLoader()
              : Text(
                  text,
                  style: style ??
                      CupidStyles.headingStyle.copyWith(
                        color: CupidColors.backgroundColor,
                        fontSize: 16,
                      ),
                ),
        ),
      ),
    );
  }
}
