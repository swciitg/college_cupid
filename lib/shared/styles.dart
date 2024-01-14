import 'package:flutter/services.dart';

import './colors.dart';
import 'package:flutter/material.dart';

class CupidStyles {
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
    fontFamily: 'Sk-Modernist',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const pageHeadingStyle = TextStyle(
    fontFamily: 'Sk-Modernist',
    fontSize: 34,
    fontWeight: FontWeight.bold,
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
}
