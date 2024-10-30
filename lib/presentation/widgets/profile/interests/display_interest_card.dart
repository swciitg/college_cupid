import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class DisplayInterestCard extends StatelessWidget {
  final String text;

  const DisplayInterestCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupidColors.cupidYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0, color: CupidColors.glassWhite),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}
