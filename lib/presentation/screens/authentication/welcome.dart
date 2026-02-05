import 'dart:math';

import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_router.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: CupidColors.backgroundColor,
  body: Stack(
    children: [
      // 1. The Background Image
      Positioned.fill(
        child: Image.asset(
          'assets/images/login_bg.png',
          fit: BoxFit.cover, // This ensures the image covers the entire screen
        ),
      ),
      // 2. Your UI Content
      Column(
        children: [
          const Spacer(), // Replaces Expanded(child: Container()) for cleaner code
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: CommonWidgets.button(
              title: 'Log in with Outlook',
              onTap: () {
                context.goNamed(AppRoutes.loginWebview.name);
              },
            ),
          ),
        ],
      ),
    ],
  ),
);
  }

  TextStyle _headingStyle() {
    return const TextStyle(
      fontFamily: 'NeueMontreal',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: CupidColors.blackColor,
    );
  }

  SizedBox _cupidImage() {
    return SizedBox(
      width: 270,
      height: 162,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/cupid_image.png',
            fit: BoxFit.cover,
          ),
          Transform.translate(
            offset: const Offset(-40, -40),
            child: SizedBox(
              width: 88,
              height: 88,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 30),
                builder: (context, double value, child) {
                  return Transform.rotate(
                    angle: value * 2 * pi,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/college_cupid_rotated_image.png',
                  fit: BoxFit.cover,
                ),
                onEnd: () {
                  setState(() {});
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
