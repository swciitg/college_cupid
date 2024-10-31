import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

import 'heart_shape.dart';
class SurpriseQuiz extends StatefulWidget {
  const SurpriseQuiz({super.key});

  @override
  State<SurpriseQuiz> createState() => _SurpriseQuizState();
  static List<Widget> getBackgroundHearts() {
    return [
      Builder(builder: (context) {
        return const Positioned(
            bottom: 100,
            right: 0,
            child: HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99FBA8AA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            right: -75,
            top: MediaQuery.of(context).size.height * 0.09,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99A8CEFA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            left: -50,
            bottom: MediaQuery.of(context).size.height * 0.40,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99EAE27A)));
      }),
    ];
  }
}


class _SurpriseQuizState extends State<SurpriseQuiz> {

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child:
       SingleChildScrollView(
        child: Column(
          children: [


              Container(
                alignment: const Alignment(-1, 0),
                margin: const EdgeInsets.only(left: 20,top:20),
                child: const Text(
                  "Surprise Quiz",
                  style: CupidStyles.pageHeadingStyle,
                ),
              ),

            const SizedBox(height: 10),
            Container(
              alignment: const Alignment(-1, 0),
              margin: const EdgeInsets.only(left: 25),
              child: const Text(
                'Answer like your (dating) life depends on it',
                style: CupidStyles.labelTextStyle,
              ),
            ),

            // Horizontal Progress Bar

          ],
        ),
      ),



    );
  }
}
