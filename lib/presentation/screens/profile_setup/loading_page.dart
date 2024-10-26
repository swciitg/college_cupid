import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../home/home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Adjust speed of rotation
      vsync: this,
    )..repeat(); // Repeat animation indefinitely

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating circular text
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: CircularTextPainter(_controller.value),
                  child: const SizedBox(
                    width: 150,
                    height: 150,
                  ),
                );
              },
            ),
            const SizedBox(height: 40), // Space between rotating text and the loading text
            // Loading text
            const Text(
              "Looking for the best \n match for you....",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change to match your theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularTextPainter extends CustomPainter {
  final double rotation;

  CircularTextPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 4; // Adjusted to give more space for the text
    final text = "College Cupid . "; // Added a dot to make the circular flow smoother
    final angleStep = 2 * pi / text.length;

    final textStyle = TextStyle(
      fontSize: 18, // Adjust font size for better readability
      fontWeight: FontWeight.bold,
      color: CupidColors.textColorBlack, // Using your app's custom color
    );

    for (int i = 0; i < text.length; i++) {
      // Calculate each letter's position around the circle
      final double angle = i * angleStep + rotation * 2 * pi;
      final Offset offset = Offset(
        size.width / 2 + radius * cos(angle),
        size.height / 2 + radius * sin(angle),
      );

      // Rotate each letter to face outward along the circular path
      final textPainter = TextPainter(
        text: TextSpan(text: text[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + pi / 2); // Rotate the text to face outward
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CircularTextPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
