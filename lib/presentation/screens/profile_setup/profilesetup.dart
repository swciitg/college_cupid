import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_intrests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/dating_pref.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/upload_pics.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'widgets/gender_select.dart';
import 'loading_page.dart';
import 'widgets/heart_shape.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  int _currentStep = 0;
  final List<Widget> steps = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.glassWhite,
      body: Stack(
        children: [
          if (_currentStep == 0 || _currentStep == 1) ...[
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
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: 0,
                  bottom: -MediaQuery.of(context).size.height * .15,
                  child: const HeartShape(
                      size: 500,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
          if (_currentStep == 2) ...[
            Builder(builder: (context) {
              return const Positioned(
                  top: 50,
                  right: 0,
                  child: HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: -75,
                  bottom: MediaQuery.of(context).size.height * 0.27,
                  child: const HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: -40,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  child: const HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
          if (_currentStep == 3) ...[
            Builder(builder: (context) {
              return const Positioned(
                  bottom: 50,
                  right: 0,
                  child: HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: -75,
                  top: MediaQuery.of(context).size.height * 0.09,
                  child: const HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: -50,
                  bottom: MediaQuery.of(context).size.height * 0.40,
                  child: const HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
          if (_currentStep == 4) ...[
            Builder(builder: (context) {
              return const Positioned(
                  top: 100,
                  left: -60,
                  child: HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: 75,
                  bottom: MediaQuery.of(context).size.height * 0.09,
                  child: const HeartShape(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: -50,
                  top: MediaQuery.of(context).size.height * 0.25,
                  child: const HeartShape(
                      size: 180,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
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
