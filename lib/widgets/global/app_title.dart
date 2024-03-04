import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final double? fontSize;

  const AppTitle({this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('CollegeCupid',
          style: TextStyle(
            fontFamily: 'SedgwickAve',
            color: CupidColors.titleColor,
            fontSize: fontSize ?? 32,
          )),
    );
  }
}
