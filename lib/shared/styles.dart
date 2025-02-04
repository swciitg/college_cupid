import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './colors.dart';

class CupidStyles {
  static const textFieldInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        width: 1.2,
        color: CupidColors.blackColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: CupidColors.blackColor),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CupidColors.greyColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  static const textButtonStyle = TextStyle(
      fontFamily: 'Neue Montreal', fontSize: 24, color: CupidColors.blackColor);

  static const statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  static const countdownStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: CupidColors.navBarBackgroundColor,
  );

  static const countdownLabelStyle =
      TextStyle(fontSize: 14, color: CupidColors.backgroundColor);

  static const headingStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const pageHeadingStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 30,
    color: CupidColors.normalTextColor,
  );
  static const lightTextStyle = TextStyle(
    fontFamily: 'Sk-Modernist',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: CupidColors.lightTextColor,
  );
  static const normalTextStyle = TextStyle(
    fontFamily: 'Sk-Modernist',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CupidColors.normalTextColor,
  );
  static const subHeadingTextStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: CupidColors.normalTextColor,
  );
  static const nextTextStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 22,
    color: CupidColors.normalTextColor,
  );
}

extension CupidTextStylesExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get regular => copyWith(fontWeight: FontWeight.normal);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle setFontSize(double size) => copyWith(fontSize: size);
  TextStyle setFontFamily(String family) => copyWith(fontFamily: family);
  TextStyle setLineHeight(double height) => copyWith(height: height);
  TextStyle setFontWeight(FontWeight fontWeight) =>
      copyWith(fontWeight: fontWeight);
}
