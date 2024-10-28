import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../shared/colors.dart';

class ChooseIntrests extends StatefulWidget {
  const ChooseIntrests({super.key});

  @override
  State<ChooseIntrests> createState() => _ChooseIntrestsState();
}

class _ChooseIntrestsState extends State<ChooseIntrests> {
  final List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else if (selectedInterests.length < 3) {
        selectedInterests.add(interest);
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
            "choose your",
            style: TextStyle(
                fontSize: 32,
                color: CupidColors.textColorBlack,
                fontWeight: FontWeight.w400),
          ),
          const Text(
            "Interests",
            style: TextStyle(
                fontSize: 32,
                color: CupidColors.textColorBlack,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          const Text(
            "this will be displayed on your profile",
            style: TextStyle(
              fontSize: 16,
              color: CupidColors.textColorBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "select any 3",
            style: TextStyle(fontSize: 23, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 20,
            runSpacing: 15,
            children: [
              _buildChip("sports", Icons.sports_basketball_outlined),
              _buildChip("studying", CupertinoIcons.book),
              _buildChip("everyone", Icons.cookie_outlined),
              _buildChip("travelling", Icons.wallet_travel),
              _buildChip("exploring", Icons.travel_explore),
              _buildChip("fitness", Icons.fitness_center),
              _buildChip("cooking", FluentIcons.spatula_spoon_16_filled),
              _buildChip("fashion", Icons.star),
              _buildChip("staying in", Icons.tv),
              _buildChip("music & concerts", CupertinoIcons.music_note),
              _buildChip("photography", Icons.camera),
              _buildChip("arts & crafts", Icons.carpenter),
              _buildChip("gardening", Icons.grass),
              _buildChip("gaming", CupertinoIcons.gamecontroller_alt_fill),
              _buildChip("writing", CupertinoIcons.pencil_outline),
              _buildChip("other", CupertinoIcons.personalhotspot)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChip(String option, IconData icon) {
    final isSelected = selectedInterests.contains(option);

    return GestureDetector(
      onTap: () => toggleInterest(option),
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0x78FBA8AA) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.pinkAccent : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Icon(icon, size: 23),
              SizedBox(width: 5),
              Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: CupidColors.textColorBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
