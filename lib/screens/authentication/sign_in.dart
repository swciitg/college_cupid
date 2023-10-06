import 'package:college_cupid/screens/profile/profile_details.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Spacer(),
              const Text(
                'CollegeCupid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 400,
                width: 400,
                child: Image.asset('assets/icons/couple.jpg'),
              ),
              const Spacer(),
              const Text(
                'Sign up to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              CupidButton(
                text: 'Continue with Outlook', onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const ProfileDetails(),
                      type: PageTransitionType.rightToLeftWithFade,
                      curve: Curves.decelerate,
                    ),
                  );
                }, height: 50,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
