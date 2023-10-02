import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import './screens/authentication/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollegeCupid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // added this so that app has same accents in scroll overflow and such other things
        colorScheme: ColorScheme.fromSeed(seedColor: CupidColors.titleColor),
        textSelectionTheme: TextSelectionThemeData(
          //updated textfield cursor and selectionhandlecolor to the app theme
          selectionHandleColor: CupidColors.titleColor,
          cursorColor: CupidColors.secondaryColor,
          selectionColor: CupidColors.secondaryColor.withOpacity(0.75),
        ),
      ),
      home: const SignIn(),
    );
  }
}
