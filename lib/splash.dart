import 'package:college_cupid/screens/authentication/welcome.dart';
import 'package:college_cupid/screens/home/home.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String id = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    LoginStore.isAuthenticated().then((value) {
      if (value == true &&
          LoginStore.isProfileCompleted &&
          LoginStore.isPasswordSaved) {
        print('USER IS AUTHENTICATED');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Home.id, (route) => false);
      } else {
        print('USER IS NOT AUTHENTICATED');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Welcome.id, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
