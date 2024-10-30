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
  List<Program> programs = [Program.none];
  Program myProgram = Program.none;
  final TextEditingController age = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController programController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: const Alignment(-1, 0),
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            "some details about you",
            style: CupidStyles.pageHeadingStyle.copyWith(
              color: CupidColors.normalTextColor,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Opacity(
          opacity: 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              focusNode: FocusNode(),
              controller: name,
              decoration: CupidStyles.textFieldInputDecoration.copyWith(
                labelText: "Name",
                floatingLabelAlignment: FloatingLabelAlignment.start,
                labelStyle: const TextStyle(color: CupidColors.blackColor),
                enabled: false,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Opacity(
          opacity: 0.4,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              focusNode: FocusNode(),
              controller: genderController,
              decoration: CupidStyles.textFieldInputDecoration.copyWith(
                labelText: "Gender",
                floatingLabelAlignment: FloatingLabelAlignment.start,
                labelStyle: const TextStyle(color: CupidColors.blackColor),
                enabled: false,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Opacity(
          opacity: 0.4,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              focusNode: FocusNode(),
              controller: programController,
              decoration: CupidStyles.textFieldInputDecoration.copyWith(
                labelText: "Course",
                floatingLabelAlignment: FloatingLabelAlignment.start,
                labelStyle: const TextStyle(color: CupidColors.blackColor),
                enabled: false,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          height: 48,
          child: TextField(
            focusNode: FocusNode(),
            controller: age,
            decoration: CupidStyles.textFieldInputDecoration.copyWith(
              labelText: "Age",
              floatingLabelAlignment: FloatingLabelAlignment.start,
              labelStyle: const TextStyle(color: CupidColors.blackColor),
              enabled: true,
            ),
          ),
        ),
      ],
    );
  }
}
