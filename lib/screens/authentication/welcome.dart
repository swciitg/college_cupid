import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/screens/authentication/login_webview.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  static String id = '/welcome';

  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'CollegeCupid',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SedgwickAve',
              fontWeight: FontWeight.bold,
              color: CupidColors.titleColor,
              fontSize: 44,
            ),
          ),
          SizedBox(
            width: 0.8 * screenWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset('assets/images/couple.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CupidButton(
              text: 'Continue with Outlook',
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginWebview.id);
              },
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
