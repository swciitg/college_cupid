import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CupidTextButton extends StatelessWidget {
  final Color? fontColor;
  final String text;
  final void Function() onPressed;
  const CupidTextButton({this.fontColor, required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        text,
        style: CupidStyles.textButtonStyle.copyWith(color: fontColor),
      ),
    );
  }
}
