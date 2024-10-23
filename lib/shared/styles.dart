import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './colors.dart';

class CupidStyles {
  static const textFieldInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        width: 1.2,
        color: CupidColors.blackColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: CupidColors.blackColor),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CupidColors.blackColor, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
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
  static const headingTextStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 26,
    fontWeight:FontWeight.bold,
    color: CupidColors.normalTextColor,
  );
  static const labelTextStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 14,
    color: CupidColors.normalTextColor,
  );
  static const nextTextStyle = TextStyle(
    fontFamily: 'Neue Montreal',
    fontSize: 22,
    color: CupidColors.normalTextColor,
  );




}
