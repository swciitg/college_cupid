import 'dart:ui';

import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class OverlayChip extends StatelessWidget {
  final String label;
  const OverlayChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: CupidStyles.normalTextStyle.setColor(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

}
