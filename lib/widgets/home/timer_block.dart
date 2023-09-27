import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class TimerBlock extends StatelessWidget {
  final String time;
  final String label;

  const TimerBlock({required this.time, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: CupidStyles.countdownStyle,
        ),
        Text(
          label,
          style: CupidStyles.countdownLabelStyle,
        ),
      ],
    );
  }
}
