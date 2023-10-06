import './timer_block.dart';
import '../../shared/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  DateTime currTime = DateTime.now().toLocal();
  Timer? countdown;

  @override
  void initState() {
    super.initState();
    countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currTime = DateTime.now().toLocal();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime valentineTime = DateTime(currTime.year + 1, 2, 14);
    if(currTime.compareTo(DateTime(currTime.year, 2, 14)) < 0)valentineTime = DateTime(currTime.year, 2, 14);
    Duration timeLeft = valentineTime.difference(currTime);
    return Container(
      width: 280,
      height: 100,
      decoration: BoxDecoration(
          color: CupidColors.pinkColor,
          borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TimerBlock(time: timeLeft.inDays.toString(), label: 'DAYS'),
        TimerBlock(time: (timeLeft.inHours % 24).toString(), label: 'HOURS'),
        TimerBlock(time: (timeLeft.inMinutes % 60).toString(), label: 'MINS'),
        TimerBlock(time: (timeLeft.inSeconds % 60).toString(), label: 'SECS'),
      ]),
    );
  }
}
