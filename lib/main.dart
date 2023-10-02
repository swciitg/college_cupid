import 'package:flutter/material.dart';
import './screens/authentication/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CollegeCupid',
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
