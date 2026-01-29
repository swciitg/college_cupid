import 'package:flutter/material.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';

class ProfileAttribute extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileAttribute({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: CupidColors.cupidPurple),
        const SizedBox(width: 4),
        Text(
          text,
          style: CupidTextStyles.label2.copyWith(
            color: CupidColors.cupidPurple,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
