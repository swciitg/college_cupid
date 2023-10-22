import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import '../../widgets/your_matches/countdown.dart';

class YourMatches extends StatelessWidget {
  const YourMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20, top: 10),
            child: Text(
              'Your Matches',
              style: CupidStyles.headingStyle
                  .copyWith(color: CupidColors.titleColor),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Countdown(),
              ),
              SizedBox(height: 15),
              Padding(
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
            ],
          ),
        ),
      ],
    );
  }
}
