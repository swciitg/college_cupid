import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisabledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const DisabledTextField(
      {required this.controller, required this.labelText, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: CupidColors.pinkColor),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: CupidColors.pinkColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
