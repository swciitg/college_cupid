import 'dart:async';

import 'package:college_cupid/shared/globals.dart';
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
    final days = difference.inDays.toString().padLeft(2, '0');
    final hours = (difference.inHours % 24).toString().padLeft(2, '0');
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
    return Text("$days:$hours:$minutes:$seconds");
  }
}
