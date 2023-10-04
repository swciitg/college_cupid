import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Timer extends StatelessWidget {
  const Timer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, bottom: 20, top: 40, right: 80),
              child: Text(
                'Your Matches',
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(height: 70, child: Image.asset('assets/icons/clock.png')),
          const SizedBox(height: 25),
          Center(
            child: Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: TimerCountdown(
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                  descriptionTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  endTime: DateTime.now().add(
                    const Duration(
                      days: 30,
                      hours: 00,
                      minutes: 00,
                      seconds: 00,
                    ),
                  ),
                  onEnd: () {
                    debugPrint("Timer finished");
                  },
                  timeTextStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please wait till the end of the timer to see your matches',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
