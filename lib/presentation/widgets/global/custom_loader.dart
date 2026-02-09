import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  @Deprecated('Color parameter is no longer used. Loader will always use primary color.')
  final Color? color;
  const CustomLoader({this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color:CupidColors.primary),
    );
  }
}
