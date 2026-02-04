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
      body: Column(
        children: [
          Expanded(child: Container()),
          Padding(padding: const EdgeInsets.only(left: 16,right: 16,bottom: 32), child: CommonWidgets.button(title: 'Log in with Outlook', onTap: (){
            // context.goNamed(AppRoutes.loginWebview.name);
            context.goNamed(AppRoutes.loginWebview.name);
            // goRouter.goNamed(AppRoutes.profileSetup.name);
          })),
        ],
      ),


      // body: Center(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         const SizedBox(height: 2 * kToolbarHeight),
      //         _cupidImage(),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 64),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 'Ready to find your\nperfect campus\nmatch?',
      //                 textAlign: TextAlign.left,
      //                 style: _headingStyle(),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(height: 32),
      //         Text(
      //           'Yes of course!',
      //           style: CupidStyles.lightTextStyle.setColor(
      //             const Color.fromARGB(255, 148, 187, 233),
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //         ElevatedButton(
      //           onPressed: () {
      //             context.goNamed(AppRoutes.loginWebview.name);
      //           },
      //           style: ElevatedButton.styleFrom(
      //             elevation: 0,
      //             foregroundColor: CupidColors.offWhiteColor,
      //             backgroundColor: CupidColors.blackColor,
      //             textStyle: const TextStyle(
      //               fontFamily: 'NeueMontreal',
      //               fontWeight: FontWeight.bold,
      //               fontSize: 20,
      //             ),
      //             splashFactory: InkRipple.splashFactory,
      //           ),
      //           child: Text(
      //             'Sign in with Outlook',
      //             style: CupidStyles.lightTextStyle.semiBold.setColor(
      //               CupidColors.offWhiteColor,
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 32),
      //       ],
      //     ),
      //   ),
      // ),
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
