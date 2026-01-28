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
          color: CupidColors.surfacePrimaryMedEm,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 1,
                  color:Color(0xFF5B51D1),// Colors.black /* Outline-primary_button_top */,
              ),
              borderRadius: BorderRadius.circular(14),
          ),
          shadows: const [
              BoxShadow(
                  color: Color(0x07000000),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                  spreadRadius: -0.50,
              )
          ],
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