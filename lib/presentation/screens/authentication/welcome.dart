import 'dart:math';

import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 2 * kToolbarHeight),
          SizedBox(
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
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64),
            child: Text(
              'Ready to find your perfect campus match?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'NeueMontreal',
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: CupidColors.blackColor,
              ),
            ),
          ),
          Text(
            'Yes of course!',
            style: CupidStyles.lightTextStyle.setColor(
              const Color.fromARGB(255, 148, 187, 233),
            ),
          ),

          // Curved Arrow Image
          Transform.translate(
            offset: const Offset(48, -48),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/curved_arrow.png',
                width: 158.02,
                height: 218.0,
              ),
            ),
          ),

          //sign in through outlook
          Transform.translate(
            offset: const Offset(0, -48),
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(AppRoutes.loginWebview.name);
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileSetup()));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: CupidColors.offWhiteColor,
                backgroundColor: CupidColors.blackColor,
                textStyle: const TextStyle(
                  fontFamily: 'NeueMontreal',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                splashFactory: InkRipple.splashFactory,
              ),
              child: Text(
                'Sign in with Outlook',
                style: CupidStyles.lightTextStyle.semiBold.setColor(
                  CupidColors.offWhiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
