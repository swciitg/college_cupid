import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeartShape extends StatefulWidget {
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
  State<HeartShape> createState() => _HeartShapeState();
}

class _HeartShapeState extends State<HeartShape> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset(
              widget.asset,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
