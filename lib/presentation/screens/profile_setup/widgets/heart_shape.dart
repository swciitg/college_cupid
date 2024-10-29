import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeartShape extends StatelessWidget {
  final double size;
  final String asset;
  final Color color;

  const HeartShape({
    super.key,
    required this.size,
    required this.asset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
