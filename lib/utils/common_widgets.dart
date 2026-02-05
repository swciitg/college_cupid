import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CommonWidgets {
  static Widget button({required String title, Color? bgColor, TextStyle? textStyle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: ShapeDecoration(
          color: CupidColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
          ),
      ),
      child: Center(
        child: Text(
            title,
            style:textStyle?? CupidTextStyles.label1,
        ),
      ),
      ),
    );
  }
}