import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class DisplayInterestCard extends StatelessWidget {
  final String text;

  const DisplayInterestCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupidColors.selectedInterestTileColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
