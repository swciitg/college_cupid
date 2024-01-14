import 'package:college_cupid/screens/authentication/login_webview.dart';
import 'package:college_cupid/screens/authentication/welcome.dart';
import 'package:college_cupid/screens/home/home.dart';
import 'package:college_cupid/screens/profile/edit_profile/profile_details.dart';
import 'package:college_cupid/splash.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.id: (context) => const SplashScreen(),
  ProfileDetails.id: (context) => const ProfileDetails(),
  Welcome.id: (context) => const Welcome(),
  LoginWebview.id: (context) => const LoginWebview(),
  Home.id: (context) => const Home(),
  // AboutYouScreen.id: (context) => const AboutYouScreen(image: image, user: user)
};
