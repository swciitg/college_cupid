import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        widthFactor: 10,
        child: SizedBox(
          width: 300,
          height: 100,
          child: SlideCountdown(
            duration: Duration(days: 10),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            icon: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.access_time_sharp,
                color: Colors.white,
                size: 40,
              ),
            ),
            showZeroValue: true,
          ),
        ),
      ),
    );
  }
}
