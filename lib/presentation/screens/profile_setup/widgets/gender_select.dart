import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class SexualOrientation extends StatefulWidget {
  const SexualOrientation({super.key});

  @override
  State<SexualOrientation> createState() => _SexualOrientationState();

  static List<Widget> getBackgroundHearts() {
    return [
      Builder(builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).size.height * 0.07,
          right: 0,
          child: const HeartShape(
            size: 125,
            asset: "assets/icons/heart_outline.svg",
            color: Color(0x99FBA8AA),
          ),
        );
      }),
      Builder(builder: (context) {
        return Positioned(
            right: MediaQuery.of(context).size.width * 0.27,
            top: MediaQuery.of(context).size.height * 0.07,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99A8CEFA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            left: 0,
            bottom: -MediaQuery.of(context).size.height * .15,
            child: const HeartShape(
                size: 500, asset: "assets/icons/heart_outline.svg", color: Color(0x99EAE27A)));
      }),
    ];
  }
}

class _SexualOrientationState extends State<SexualOrientation> {
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
        label: Text(
          tag,
          style: CupidStyles.normalTextStyle.copyWith(
            color: _selectedChoice == tag ? Colors.white : CupidColors.textColorBlack,
          ),
        ),
        color: WidgetStateColor.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return CupidColors.secondaryColor;
            }
            return Colors.transparent;
          },
        ),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "some more details about you",
        style: CupidStyles.nextTextStyle,
      ),
      const SizedBox(height: 16),
      const Text.rich(
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
      const SizedBox(height: 8),
      const Text(
        'your results will be based on your \npreference',
        style: CupidStyles.labelTextStyle,
      ),
      const SizedBox(height: 24),
      Wrap(
        spacing: 8.0,
        children: _buildchoiceChips(),
      ),
      const SizedBox(height: 40),
      Row(
        children: [
          Container(
            alignment: const Alignment(-1, 0),
            margin: const EdgeInsets.only(left: 20),
            child: const Text('display on profile', style: CupidStyles.nextTextStyle),
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
    ]);
  }
}
