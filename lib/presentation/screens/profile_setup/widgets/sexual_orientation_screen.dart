import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

import 'heart_state.dart';

class SexualOrientationScreen extends StatefulWidget {
  const SexualOrientationScreen({super.key});

  @override
  State<SexualOrientationScreen> createState() => _SexualOrientationScreenState();

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 500,
        left: 0,
        bottom: -size.height * .15,
      ),
      "blue": HeartState(
        size: 200,
        right: size.width * 0.27,
        top: size.height * 0.07,
      ),
      "pink": HeartState(
        size: 125,
        right: 0,
        bottom: size.height * 0.07,
      ),
    };
  }
}

class _SexualOrientationScreenState extends State<SexualOrientationScreen> {
  bool _displayOnProfile = false;
  SexualOrientation _selectedChoice = SexualOrientation.straight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Choose your \n',
                style: CupidStyles.subHeadingTextStyle,
              ),
              TextSpan(
                text: 'Sexual orientation',
                style: CupidStyles.headingStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your results will be based on your preference',
          style: CupidStyles.normalTextStyle,
        ),
        const SizedBox(height: 24),
        _buildchoiceChips(),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Display on profile',
              style: CupidStyles.lightTextStyle,
            ),
            Switch(
              activeColor: CupidColors.secondaryColor,
              inactiveThumbColor: CupidColors.secondaryColor,
              inactiveTrackColor: CupidColors.offWhiteColor,
              value: _displayOnProfile,
              onChanged: (value) {
                setState(() {
                  _displayOnProfile = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildchoiceChips() {
    return Wrap(
      spacing: 8,
      children: SexualOrientation.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
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
          onSelected: (_) {
            setState(() {
              _selectedChoice = tag;
            });
          },
        );
      }).toList(),
    );
  }
}
