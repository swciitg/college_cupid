import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_intrests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/dating_pref.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/upload_pics.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'widgets/gender_select.dart';
import 'loading_page.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  int _currentStep = 0;
  final steps = [
    const BasicDetails(),
    const GenderSelect(),
    const ChooseIntrests(),
    const LookingFor(),
    const DatingPreference(),
    const AddPhotos(),
  ];

  void _nextStep() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep += 1;
      });
    } else if (_currentStep == steps.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoadingPage(),
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  List<Widget> getBackgroundHearts() {
    switch (_currentStep) {
      case 0:
        return BasicDetails.getBackgroundHearts();
      case 1:
        return GenderSelect.getBackgroundHearts();
      case 2:
        return ChooseIntrests.getBackgroundHearts();
      case 3:
        return LookingFor.getBackgroundHearts();
      case 4:
        return DatingPreference.getBackgroundHearts();
      case 5:
        return AddPhotos.getBackgroundHearts();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.glassWhite,
      body: Stack(
        children: [
          ...getBackgroundHearts(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  steps[_currentStep],
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment:
                        _currentStep == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep != 0)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.transparent),
                            elevation: WidgetStateProperty.all(0),
                          ),
                          onPressed: _previousStep,
                          child: const Text(
                            'Back',
                            style: TextStyle(color: CupidColors.textColorBlack),
                          ),
                        ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {
                          _nextStep();
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: CupidColors.textColorBlack),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
