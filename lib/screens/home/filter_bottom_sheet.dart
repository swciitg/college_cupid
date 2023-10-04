import 'dart:math';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/global/cupid_botton.dart';
import 'package:college_cupid/widgets/global/custom_drop_down.dart';
import 'package:college_cupid/widgets/home/selection_button.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool intoGirls = true;
  List<String> programs = ["B.tech", "M.tech", "B.Des", "M.Des", "MSc", "PhD"];
  List<String> yearOfStudy = ["First", "Second", "Third", "Fourth", "Fifth"];

  // TODO: change this accordingly
  Map<String, int> noOfYears = {
    "B.tech": 4,
    "M.tech": 2,
    "B.Des": 4,
    "M.Des": 2,
    "MSc": 3,
    "PhD": 5,
  };

  String? program = "B.tech";
  String? year = "First";

  void selectedGenderChange(String gender) {
    setState(() {
      // won't change selection if clicked on selection again
      if (gender == "Boys" && !intoGirls) {
        return;
      } else if (gender == "Girls" && intoGirls) {
        return;
      } else {
        intoGirls = !intoGirls;
      }
    });
  }

  void changeProgram(String? value) {
    setState(() {
      program = value ?? "B.tech";
    });
  }

  void changeYear(String? value) {
    setState(() {
      year = value ?? "First";
    });
  }

  void clearFilter() {
    setState(() {
      intoGirls = true;
      program = "B.tech";
      year = "First";
    });
  }

  void applyFilter() {
    final selectedGender = intoGirls ? "Girls" : "Boys";
    debugPrint("selected gender: $selectedGender");
    debugPrint("program: $program");
    debugPrint("year: $year");
    Navigator.pop(context);
    // TODO: implement actual filter function
  }

  final dropDownIcon = Transform.rotate(
    angle: pi / 2,
    child: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.grey,
      size: 14,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40).copyWith(top: 0),
      decoration: const BoxDecoration(
        color: CupidColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(3)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                const Center(
                  child: Text('Filters', style: CupidStyles.headingStyle),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: clearFilter,
                    child: Text(
                      "Clear",
                      style: CupidStyles.headingStyle.copyWith(
                        color: CupidColors.pinkColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Interested in',
            style: CupidStyles.headingStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SelectionButton(
                onTap: () => selectedGenderChange("Girls"),
                label: "Girls",
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(
                    15,
                  ),
                ),
                isSelected: intoGirls,
              ),
              SelectionButton(
                onTap: () => selectedGenderChange("Boys"),
                label: "Boys",
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(
                    15,
                  ),
                ),
                isSelected: !intoGirls,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              CustomDropDown(
                items: programs,
                label: 'Programs',
                value: program,
                onChanged: changeProgram,
                validator: (value) {
                  return null;
                },
                icon: dropDownIcon,
              ),
              const SizedBox(width: 20),
              CustomDropDown(
                items: yearOfStudy.sublist(0, noOfYears[program]),
                label: "Year of study ",
                value: year,
                onChanged: changeYear,
                validator: (value) {
                  return null;
                },
                icon: dropDownIcon,
              ),
            ],
          ),
          const SizedBox(height: 30),
          CupidButton(
            text: "Apply",
            onTap: applyFilter,
            backgroundColor: CupidColors.pinkColor,
          )
        ],
      ),
    );
  }
}
