import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonWidgets {
  static Widget button(
      {required String title,
      Color? bgColor,
      Widget? icon,
      TextStyle? textStyle,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: ShapeDecoration(
          color: bgColor ?? CupidColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            // side: BorderSide(color: CupidColors.borderSecondary),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              const SizedBox(width: 8),
              Text(
                title,
                style: textStyle ?? CupidTextStyles.label1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget backButton(
      {required BuildContext context, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap ?? () => context.pop(),
        child: Container(
          height: 36,
          width: 36,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
        ),
      ),
    );
  }
}
