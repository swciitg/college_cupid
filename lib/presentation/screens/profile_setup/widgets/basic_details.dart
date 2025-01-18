import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/shared/enums.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({super.key});

  @override
  State<BasicDetails> createState() => _BasicDetailsState();

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

class _BasicDetailsState extends State<BasicDetails> {
  List<Program> programs = Program.values.where((e) => e != Program.none).toList();
  Program myProgram = Program.none;
  final TextEditingController nameController = TextEditingController();
  String? selectedGender;
  String? selectedCourse;
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "About you",
          style: CupidStyles.headingStyle,
        ),
        const SizedBox(height: 8),
        TextField(
          focusNode: FocusNode(),
          controller: nameController,
          decoration: CupidStyles.textFieldInputDecoration.copyWith(
            labelText: "Name",
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelStyle: const TextStyle(color: CupidColors.blackColor),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Gender",
          style: CupidStyles.subHeadingTextStyle,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          alignment: WrapAlignment.start,
          children: List.generate(Gender.values.length, (index) {
            final gender = Gender.values[index];
            final selected = selectedGender == gender.databaseString;
            return _buildChip(gender.displayString, selected, () {
              setState(() => selectedGender = gender.databaseString);
            });
          }),
        ),
        const SizedBox(height: 16),
        const Text(
          "Program",
          style: CupidStyles.subHeadingTextStyle,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          alignment: WrapAlignment.start,
          children: List.generate(programs.length, (index) {
            final program = programs[index];
            final selected = selectedCourse == program.databaseString;
            return _buildChip(program.displayString, selected, () {
              setState(() => selectedCourse = program.databaseString);
            });
          }),
        ),
        const SizedBox(height: 16),
        const Text(
          "Year",
          style: CupidStyles.subHeadingTextStyle,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          alignment: WrapAlignment.start,
          children: [
            ...List.generate(5, (index) {
              final year = index + 1;
              return _buildChip(year.toString(), selectedYear == year, () {
                setState(() => selectedYear = year);
              });
            }),
            _buildChip(
              "beyond",
              selectedYear == 6,
              () {
                setState(() => selectedYear = 6);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChip(String option, bool isSelected, VoidCallback onSelected) {
    return ChoiceChip(
      label: Text(
        option,
        style: CupidStyles.normalTextStyle.setColor(
          isSelected ? Colors.white : CupidColors.textColorBlack,
        ),
      ),
      selected: isSelected,
      selectedColor: CupidColors.secondaryColor,
      elevation: 0,
      color: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return CupidColors.secondaryColor;
          }
          return Colors.transparent;
        },
      ),
      checkmarkColor: Colors.white,
      onSelected: (bool selected) {
        onSelected();
      },
    );
  }
}
