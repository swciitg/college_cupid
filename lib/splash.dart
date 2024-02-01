import 'package:college_cupid/screens/authentication/welcome.dart';
import 'package:college_cupid/screens/home/home.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    LoginStore.isAuthenticated().then((value) async {
      if (value == true &&
          LoginStore.isProfileCompleted &&
          LoginStore.isPasswordSaved) {
        debugPrint('USER IS AUTHENTICATED');
        final nav = Navigator.of(context);
        await context.read<CommonStore>().initializeProfile();
        nav.pushNamedAndRemoveUntil(Home.id, (route) => false);
      } else {
        debugPrint('USER IS NOT AUTHENTICATED');
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
