import 'dart:developer';

import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicDetails extends ConsumerStatefulWidget {
  const BasicDetails({super.key});

  @override
  ConsumerState<BasicDetails> createState() => _BasicDetailsState();

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 200,
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

class _BasicDetailsState extends ConsumerState<BasicDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardingController =
          ref.read(onboardingControllerProvider.notifier);
      final yearOfJoin = DateTime.now().year % 100 -
          getYearOfJoinFromRollNumber(LoginStore.rollNumber!);
      log("Year of join : $yearOfJoin");
      onboardingController.updateYearOfJoin(yearOfJoin);
    });
  }

  List<Program> programs =
      Program.values.where((e) => e != Program.none).toList();

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: kToolbarHeight),
        const Text(
          "About you",
          style: CupidStyles.headingStyle,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: LoginStore.displayName),
          decoration: CupidStyles.textFieldInputDecoration.copyWith(
            labelText: "Name",
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelStyle: const TextStyle(color: CupidColors.secondaryColor),
            enabled: false,
            fillColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: LoginStore.email),
          decoration: CupidStyles.textFieldInputDecoration.copyWith(
            labelText: "Email",
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelStyle: const TextStyle(color: CupidColors.secondaryColor),
            enabled: false,
            fillColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Gender",
          style: CupidStyles.subHeadingTextStyle,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(Gender.values.length, (index) {
            final gender = Gender.values[index];
            final selected = onboardingState.userProfile?.gender == gender;
            return _buildChip(gender.displayString, selected, () {
              onboardingController.updateGender(gender);
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
          spacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(programs.length, (index) {
            final program = programs[index];
            final selected = onboardingState.userProfile?.program == program;
            return _buildChip(program.displayString, selected, () {
              onboardingController.updateProgram(program);
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
          spacing: 8,
          alignment: WrapAlignment.start,
          children: [
            ...List.generate(5, (index) {
              final year = index + 1;
              return _buildChip(year.toString(),
                  onboardingState.userProfile?.yearOfJoin == year, () {
                // onboardingController.updateYearOfJoin(year);
              });
            }),
            _buildChip(
              "beyond",
              onboardingState.userProfile?.yearOfJoin == 6,
              () {
                // onboardingController.updateYearOfJoin(6);
              },
            ),
          ],
        ),
        const SizedBox(height: 2 * kBottomNavigationBarHeight),
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
