import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

void main() => runApp(SexualOrientationScreen());

class SexualOrientationScreen extends StatefulWidget {
  const SexualOrientationScreen({super.key});

  @override
  State<SexualOrientationScreen> createState() => _SexualOrientationState();
}

class _SexualOrientationState extends State<SexualOrientationScreen> {
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
  List<String> _selectedFilters = [];
  List<Widget> _buildFilterChips() {
    return _tags.map((tag) {
      return FilterChip(
        label: Text(tag),
        selected: _selectedFilters.contains(tag),
        backgroundColor: Colors.white,
        selectedColor: CupidColors.secondaryColor, // Custom selected color
        checkmarkColor: Colors.white,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedFilters.add(tag);
            } else {
              _selectedFilters.remove(tag);
            }
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
          Container(
            alignment: Alignment(-1, 0),
            margin: const EdgeInsets.only(left: 20, top: 160),
            child: const Text(
              "some more details about you",
              style: CupidStyles.nextTextStyle,
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
            children: _buildFilterChips(),
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
          const SizedBox(height: 40),
          Row(
            children: [
              Container(
                alignment: Alignment(-1, 0),
                margin: const EdgeInsets.only(left: 10),
                child: TextButton(
                    onPressed: () {},
                    child:
                        const Text('back', style: CupidStyles.nextTextStyle)),
              ),
              Expanded(child: Container()),
              Container(
                alignment: Alignment(1, 0),
                margin: const EdgeInsets.only(right: 10),
                child: TextButton(
                    onPressed: () {},
                    child:
                        const Text('next', style: CupidStyles.nextTextStyle)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
