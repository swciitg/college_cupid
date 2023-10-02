import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, bottom: 20, top: 40, right: 80),
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
          SizedBox(
            height: 30,
          ),
          SizedBox(height: 70, child: Image.asset('assets/icons/clock.png')),
          SizedBox(height: 25),
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
                  descriptionTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  endTime: DateTime.now().add(
                    Duration(
                      days: 30,
                      hours: 00,
                      minutes: 00,
                      seconds: 00,
                    ),
                  ),
                  onEnd: () {
                    print("Timer finished");
                  },
                  timeTextStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
