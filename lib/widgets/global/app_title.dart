import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('CollegeCupid',
          style: TextStyle(
            fontFamily: 'SedgwickAve',
            color: CupidColors.titleColor,
            fontSize: 32,
          )),
    );
  }
}
