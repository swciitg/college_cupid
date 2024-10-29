import 'package:college_cupid/presentation/screens/profile/edit_profile/surprise_quiz.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';


class GenderSelect extends StatefulWidget {
  const GenderSelect({super.key});

  @override
  State<GenderSelect> createState() => _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect> {
  bool _yesNoSwitchValue = false;
  final List<String> _tags = [
    "straight",
    "gay",
    "lesbian",
    "bisexual",
    "asexual",
    "demisexual",
    "pansexual",
    "queer",
    "still figuring it out"
  ];
  String _selectedChoice = "";
  List<Widget> _buildchoiceChips() {
    return _tags.map((tag) {
      return ChoiceChip(
        label: Text(tag),
        selectedColor: CupidColors.secondaryColor,
        checkmarkColor: Colors.white,
        selected: _selectedChoice == tag,
        onSelected: (bool selected) {
          setState(() {
            _selectedChoice = selected ? tag : "";
          });
        },
      );

  }).toList();
        }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment(-1, 0),
              margin: const EdgeInsets.only(left: 20, top: 160),
              child: const Text(
                "some more details about you",
                style: CupidStyles.nextTextStyle,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment(-1, 0),
            margin: const EdgeInsets.only(left: 20),
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'choose your \n',
                    style: CupidStyles.pageHeadingStyle,
                  ),
                  TextSpan(
                    text: 'sexual orientation',
                    style: CupidStyles.headingStyle,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment(-1, 0),
            margin: const EdgeInsets.only(left: 20),
            child: const Text('your results will be based on your \npreference',
                style: CupidStyles.labelTextStyle),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 8.0,
            children: _buildchoiceChips(),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Container(
                alignment: Alignment(-1, 0),
                margin: const EdgeInsets.only(left: 20),
                child: const Text('display on profile',
                    style: CupidStyles.nextTextStyle),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  activeColor: CupidColors.secondaryColor,
                  inactiveThumbColor: CupidColors.secondaryColor,
                  inactiveTrackColor: CupidColors.offWhiteColor,
                  value: _yesNoSwitchValue,
                  onChanged: (value) {
                    setState(() {
                      _yesNoSwitchValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
