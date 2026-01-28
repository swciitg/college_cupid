import 'dart:developer';

import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
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
}

class _BasicDetailsState extends ConsumerState<BasicDetails> {
  // Controllers for fields present in design but not in current model (Mock integration)
  late TextEditingController _ageController;
  late TextEditingController _zodiacController;
  late TextEditingController _hometownController;
  
  // Controller for Name (from LoginStore)
  late TextEditingController _nameController;
  Zodiac? selectedZodiac;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: LoginStore.displayName);
    _ageController = TextEditingController();
    _zodiacController = TextEditingController();
    _hometownController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardingController = ref.read(onboardingControllerProvider.notifier);
      // Auto-calculate year of join if possible, or keep existing logic
      if (LoginStore.rollNumber != null) {
        final yearOfJoin = DateTime.now().year % 100 -
            getYearOfJoinFromRollNumber(LoginStore.rollNumber!);
        // log("Year of join : $yearOfJoin");
        onboardingController.updateYearOfJoin(yearOfJoin);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _zodiacController.dispose();
    _hometownController.dispose();
    super.dispose();
  }

  List<Program> programs =
      Program.values.where((e) => e != Program.none).toList();

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        

        CustomTextField(
          label: "Your Full Name",
          controller: _nameController,
          enabled: false,
        ),
        const SizedBox(height: 16),

        CustomTextField(
          label: "Age",
          hintText: "20", // Placeholder from design
          controller: _ageController,
          keyboardType: TextInputType.number,
          onChanged:(age){
            onboardingController.updateAge(age);
          }
        ),
        const SizedBox(height: 16),

        const Text(
          "Zodiac",
          style: CupidTextStyles.label1,
        ),
        const SizedBox(height: 8),
        DropdownButton<Zodiac>(
          hint: const Text("Select Zodiac"),
          value: selectedZodiac,
          isExpanded: true,
          items: Zodiac.values.map((Zodiac zodiac) {
            return DropdownMenuItem<Zodiac>(
              value: zodiac,
              child: Text(zodiac.displayString),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              selectedZodiac = value;
              onboardingController.updateZodiac(value);
              setState((){});
            }
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          "Gender",
          style: CupidTextStyles.label1
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: Gender.values.map((gender) {
            return SelectionChip(
              label: gender.displayString,
              isSelected: onboardingState.userProfile?.gender == gender,
              onTap: () => onboardingController.updateGender(gender),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          label: "Hometown",
          hintText: "Banglore",
          controller: _hometownController,
          onChanged: (city){
            onboardingController.updateHometown(city);
          },
        ),
        const SizedBox(height: 16),

        const Text(
          "Degree",
          style: CupidTextStyles.label1
        ),
        const SizedBox(height: 8),
         Wrap(
          spacing: 10,
          runSpacing: 10,
          children: programs.map((program) {
            return SelectionChip(
              label: program.displayString,
              isSelected: onboardingState.userProfile?.program == program,
              onTap: () => onboardingController.updateProgram(program),
            );
          }).toList(),
        ),
        // Note: The design asked for "Bachelors, Masters, PhD". 
        // We are showing actual programs to maintain data integrity with the backend.
        
        const SizedBox(height: 20),
      ],
    );
  }
}
