import 'dart:async';

import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late final Timer timer;
  Duration difference = matchReleaseTime.difference(DateTime.now());

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (difference.inSeconds > 0) {
        setState(() {
          difference = Duration(seconds: difference.inSeconds - 1);
        });
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = difference.inDays;
    final hours = (difference.inHours % 24);
    final minutes = (difference.inMinutes % 60);
    final seconds = (difference.inSeconds % 60);
    final hourString = days == 0 || hours == 0
        ? ""
        : "$hours Hour${hours > 1 ? "s" : ""}, ${minutes == 0 ? "and " : ""}";
    final minuteString = (days == 0 && hours == 0) || minutes == 0
        ? ""
        : "$minutes Minute${minutes > 1 ? "s" : ""}, and ";
    final secondString = days == 0 && hours == 0 && minutes == 0
        ? ""
        : "$seconds Second${seconds > 1 ? "s" : ""}";
    final text = "$hourString$minuteString$secondString";
    return text.isEmpty
        ? const SizedBox()
        : Text(
            text,
            style: CupidStyles.normalTextStyle,
            textAlign: TextAlign.center,
          );
  }
}
