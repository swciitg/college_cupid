import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/home/countdown.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> myCrushes = [
    'Donald Trump',
    'Joe Biden',
    'Vladimir Putin',
    'Narendra Modi',
    'Barack Obama'
  ];

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text('Home'),
      ),
    );
  }
}
