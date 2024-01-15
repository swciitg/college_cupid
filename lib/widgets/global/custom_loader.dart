import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;
  const CustomLoader({this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? CupidColors.pinkColor),
    );
  }
}
