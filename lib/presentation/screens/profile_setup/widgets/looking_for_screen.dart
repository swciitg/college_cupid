import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

import 'heart_state.dart';

class LookingForScreen extends StatefulWidget {
  const LookingForScreen({super.key});

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();

  static List<Widget> getBackgroundHearts() {
    return [
      Builder(builder: (context) {
        return const Positioned(
            top: 50,
            right: 0,
            child: HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99FBA8AA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            left: -75,
            bottom: MediaQuery.of(context).size.height * 0.27,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99A8CEFA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            right: -40,
            bottom: MediaQuery.of(context).size.height * 0.05,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99EAE27A)));
      }),
    ];
  }

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 200,
        top: 50,
        right: 0,
      ),
      "blue": HeartState(
        size: 200,
        left: -75,
        bottom: size.height * 0.27,
      ),
      "pink": HeartState(
        size: 200,
        right: -40,
        bottom: size.height * 0.05,
      ),
    };
  }
}

class _LookingForScreenState extends State<LookingForScreen> {
  bool _displayOnProfile = false;
  var _selectedOption = LookingFor.longTermPartner;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Looking for", style: CupidStyles.headingStyle),
        const SizedBox(height: 5),
        const Text(
          "The profiles showed to you will be based on this",
          style: CupidStyles.normalTextStyle,
        ),
        const SizedBox(height: 16),
        _buildchoiceChips(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Display on profile",
              style: CupidStyles.lightTextStyle,
            ),
            const SizedBox(width: 8),
            Switch(
              value: _displayOnProfile,
              onChanged: (value) {
                setState(() {
                  _displayOnProfile = value;
                });
              },
              inactiveTrackColor: WidgetStateColor.transparent,
              activeColor: Colors.pinkAccent,
              inactiveThumbColor: const Color(0xFFFBA8AA),
              activeTrackColor: const Color(0x48FBA8AA),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildchoiceChips() {
    return Wrap(
      spacing: 8,
      children: LookingFor.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidStyles.normalTextStyle.copyWith(
              color: _selectedOption == tag ? Colors.white : CupidColors.textColorBlack,
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
          selected: _selectedOption == tag,
          onSelected: (_) {
            setState(() {
              _selectedOption = tag;
            });
          },
        );
      }).toList(),
    );
  }
}
