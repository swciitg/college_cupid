import 'package:flutter/material.dart';
import 'dart:math' as math show sqrt;

class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final double minRadius;
  final int ripplesCount;

  const RippleAnimation({
    Key? key,
    required this.child,
    this.color = Colors.red,
    this.duration = const Duration(milliseconds: 1500),
    this.minRadius = 60,
    this.ripplesCount = 3,
  }) : super(key: key);

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RipplePainter(
        _controller,
        color: widget.color,
        ripplesCount: widget.ripplesCount,
      ),
      child: widget.child,
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> mutation;
  final Color color;
  final int ripplesCount;

  _RipplePainter(
    this.mutation, {
    required this.color,
    required this.ripplesCount,
  }) : super(repaint: mutation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    final double maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height) / 2 + 20;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < ripplesCount; i++) {
      // Offset each ripple
      double value = (mutation.value + (i / ripplesCount)) % 1.0;

      // Opacity goes from 0.5 to 0.0 as it expands
      double opacity = (1.0 - value).clamp(0.0, 1.0) * 0.5;

      paint.color = color.withOpacity(opacity);

      // Radius expands from 0 to maxRadius
      // Using a curve makes it look more natural (easeOut)
      double radius = maxRadius * value;

      canvas.drawCircle(rect.center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) => true;
}
