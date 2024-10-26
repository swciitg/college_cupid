import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/functions/launchers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 800,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cupid Image
                  Positioned(
                    top: 105,
                    child: SizedBox(
                      width: 270,
                      height: 162,
                      child: Image.asset(
                        'assets/images/cupid_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Ready to find your perfect campus match? Text
                  const Positioned(
                    top: 275,
                    child: SizedBox(
                      width: 273,
                      height: 130,
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
                  ),

                  // "Yes of course!" Text
                  const Positioned(
                    top: 410,
                    child: Text(
                      'yes of course!',
                      style: TextStyle(
                        fontFamily: 'NeueMontreal',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA8CEFA),
                      ),
                    ),
                  ),

                  // Curved Arrow Image
                  Positioned(
                    left: 157.5,
                    top: 381.5,
                    child: Image.asset(
                      'assets/images/curved_arrow.png',
                      width: 158.02,
                      height: 218.0,
                    ),
                  ),

                  //sign in through outlook
                  Positioned(
                    top: 605,
                    child: TextButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.loginWebview.name);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: CupidColors.blackColor,
                        textStyle: const TextStyle(
                          fontFamily: 'NeueMontreal',
                          decoration: TextDecoration.underline,
                          decorationThickness: 2.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        splashFactory: InkRipple.splashFactory,
                      ),
                      child: const Text('sign in through outlook'),
                    ),
                  ),

                  // College Cupid Rotated Image
                  Positioned(
                    top: 65,
                    left: (screenWidth - 350) / 2,
                    child: SizedBox(
                      width: 88,
                      height: 88,
                      child: Transform.rotate(
                        angle: 226 * 3.14159 / 180,
                        child: Image.asset(
                          'assets/images/college_cupid_rotated_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Blur Rectangle Images to censor cupid
                  Positioned(
                    top: 202,
                    left: 130,
                    child: SizedBox(
                      width: 22,
                      height: 54,
                      child: Image.asset(
                        'assets/images/blur_rectangle.png',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 162,
                    left: 160,
                    child: SizedBox(
                      width: 40,
                      height: 49,
                      child: Image.asset(
                        'assets/images/blur_rectangle.png',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 198,
                    left: 35,
                    child: Transform.rotate(
                      angle: 269 * 3.14159 / 180,
                      child: SizedBox(
                        width: 80,
                        height: 55,
                        child: Image.asset(
                          'assets/images/blur_rectangle.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
