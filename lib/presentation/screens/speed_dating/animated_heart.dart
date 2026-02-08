import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedHeart extends StatefulWidget {
  final Duration startDelay;
  const AnimatedHeart({super.key, this.startDelay = Duration.zero});

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration:
            const Duration(seconds: 4)); // Slow duration as per path length

    // Path: Bottom Right - 90 (approx aligned with doll center) -> Mid Left -> Top Right
    _alignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          // Start slightly BELOW center (inside doll body)
          begin: const Alignment(0.2, 0.6),
          end: Alignment.centerLeft,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
        ),
        weight: 50,
      ),
    ]).animate(_controller);

    // Size: 35 -> 100 -> 100
    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 35, end: 100),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(100),
        weight: 50,
      ),
    ]).animate(_controller);

    // Color: EB425E -> F8ACA4
    _colorAnimation = ColorTween(
      begin: const Color(0xFFEB425E),
      end: const Color.fromARGB(0, 248, 172, 164),
    ).animate(_controller);

    if (widget.startDelay == Duration.zero) {
      _controller.repeat();
    } else {
      Future.delayed(widget.startDelay, () {
        if (mounted) {
          _controller.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appear = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // If the controller hasn't started yet (due to delay), don't show the heart or show it at start position?
        // Better to hide it until it starts moving or let it sit at start?
        // User wants "coming from the doll", so it should probably be invisible until it starts or just sit there?
        // If we want it to "appear" and start moving, maybe we should fade it in?
        // But simply delaying the start of the repeat loop will make it stay at value 0 (bottom right) until it starts.
        // Let's hide it if not animating?
        // Actually, value 0 is bottom right (behind the doll maybe?).
        // Let's just let it be at value 0.

        // Wait, if 3 hearts are there, and 2 are waiting, they will all be at bottom right.
        // That's fine as they emerge from the doll.

        return Align(
            alignment: _alignmentAnimation.value,
            child: Transform.rotate(
              // To and fro motion: sin wave
              // Adjust frequency (phases) as needed.
              // 4 * pi means 2 full cycles? let's try 6 * pi for more wiggles
              angle: sin(_controller.value * 6 * pi) * 0.3,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: appear.value,
                child: Transform.scale(
                  scale: appear.value,
                  child: Image.asset(
                    'assets/images/heart.png',
                    height: _sizeAnimation.value,
                    color: _colorAnimation.value,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ));
      },
    );
  }
}
