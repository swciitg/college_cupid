import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> options = [
  "long-term partner",
  "short-term fun",
  "long-term, open to short",
  "new friends",
  "short-term, open to long",
  "still figuring it out"
];
bool displayOnProfile = false;

// This Set stores selected options
Set<String> selectedOptions = {};

Widget _buildChip(String option, Function(String) onSelected) {
  bool isSelected = selectedOptions.contains(option);

  return GestureDetector(
    onTap: () => onSelected(option),
    child: Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0x78FBA8AA) : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            color: CupidColors.textColorBlack,
          ),
        ),
      ),
    ),
  );
}

class LookingFor extends StatefulWidget {
  const LookingFor({super.key});

  @override
  State<LookingFor> createState() => _LookingForState();

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
}

class _LookingForState extends State<LookingFor> {
  void _toggleSelection(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "looking for",
            style: TextStyle(fontSize: 30, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 5),
          const Text(
            "the profiles showed to you will be\n based on this",
            style: TextStyle(fontSize: 15, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              return _buildChip(option, _toggleSelection);
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "display on profile",
                style: TextStyle(
                  fontSize: 20,
                  color: CupidColors.textColorBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: displayOnProfile,
                  onChanged: (value) {
                    setState(() {
                      displayOnProfile = value;
                    });
                  },
                  inactiveTrackColor: WidgetStateColor.transparent,
                  activeColor: Colors.pinkAccent,
                  inactiveThumbColor: const Color(0xFFFBA8AA),
                  activeTrackColor: const Color(0x48FBA8AA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
