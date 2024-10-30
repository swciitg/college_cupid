import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:flutter/material.dart';

import '../../../../shared/colors.dart';

class DatingPreference extends StatefulWidget {
  const DatingPreference({super.key});

  @override
  State<DatingPreference> createState() => _DatingPreferenceState();

  static List<Widget> getBackgroundHearts() {
    return [
      Builder(builder: (context) {
        return const Positioned(
            bottom: 50,
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

class _DatingPreferenceState extends State<DatingPreference> {
  String? selectedGender;
  String? selectedCourse;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select",
            style: TextStyle(
                fontSize: 32, color: CupidColors.textColorBlack, fontWeight: FontWeight.w400),
          ),
          const Text(
            "dating preference",
            style: TextStyle(
                fontSize: 32, color: CupidColors.textColorBlack, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          const Text(
            "the profiles showed to you will be\n based on this",
            style: TextStyle(
              fontSize: 16,
              color: CupidColors.textColorBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "gender",
            style: TextStyle(fontSize: 23, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildChip("male", selectedGender, (value) {
                setState(() => selectedGender = value);
              }),
              _buildChip("female", selectedGender, (value) {
                setState(() => selectedGender = value);
              }),
              _buildChip("everyone", selectedGender, (value) {
                setState(() => selectedGender = value);
              }),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "select course",
            style: TextStyle(fontSize: 23, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildChip("bachelor", selectedCourse, (value) {
                setState(() => selectedCourse = value);
              }),
              _buildChip("masters", selectedCourse, (value) {
                setState(() => selectedCourse = value);
              }),
              _buildChip("phd", selectedCourse, (value) {
                setState(() => selectedCourse = value);
              }),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "select year",
            style: TextStyle(fontSize: 23, color: CupidColors.textColorBlack),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildChip("1", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
              _buildChip("2", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
              _buildChip("3", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
              _buildChip("4", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
              _buildChip("5", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
              _buildChip("beyond", selectedYear, (value) {
                setState(() => selectedYear = value);
              }),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChip(String option, String? selectedOption, Function(String) onSelected) {
    final isSelected = option == selectedOption;

    return GestureDetector(
      onTap: () => onSelected(option),
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x78FBA8AA) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            option,
            style: const TextStyle(
              fontSize: 16,
              color: CupidColors.textColorBlack,
            ),
          ),
        ),
      ),
    );
  }
}
