import 'package:flutter/material.dart';
import '../../widgets/your_matches/countdown.dart';

class YourMatches extends StatelessWidget {
  const YourMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
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
          const SizedBox(
            height: 30,
          ),
          SizedBox(height: 70, child: Image.asset('assets/icons/clock.png')),
          const SizedBox(height: 25),
          const Center(child: Countdown(),),
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
