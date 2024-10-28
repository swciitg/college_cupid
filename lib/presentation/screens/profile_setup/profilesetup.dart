import 'dart:ui';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_intrests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/dating_pref.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'loading_page.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  int _currentStep = 0;

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const ChooseIntrests();
      case 1:
        return const LookingFor();
      case 2:
        return const DatingPreference();
      default:
        return Container();
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else if (_currentStep == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoadingPage()));
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
      body: Stack(
        children: [
          if (_currentStep == 0) ...[
            Builder(builder: (context) {
              return  Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.07,
                  right: 0,
                  child: HeartWidget(
                      size: 125,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: MediaQuery.of(context).size.width * 0.27,
                  top: MediaQuery.of(context).size.height * 0.07,
                  child: const HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: 0,
                  bottom: -MediaQuery.of(context).size.height * .15,
                  child: const HeartWidget(
                      size: 500,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
          if (_currentStep == 1) ...[
            Builder(builder: (context) {
              return const Positioned(
                  top: 50,
                  right: 0,
                  child: HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: -75,
                  bottom: MediaQuery.of(context).size.height * 0.27,
                  child: const HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: -40,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                  child: const HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99EAE27A)));
            }),
          ],
          if (_currentStep == 2) ...[
            Builder(builder: (context) {
              return const Positioned(
                  bottom: 50,
                  right: 0,
                  child: HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99FBA8AA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  right: -75,
                  top: MediaQuery.of(context).size.height * 0.09,
                  child: const HeartWidget(
                      size: 200,
                      asset: "assets/icons/heart_outline.svg",
                      color: Color(0x99A8CEFA)));
            }),
            Builder(builder: (context) {
              return Positioned(
                  left: -50,
                  bottom: MediaQuery.of(context).size.height * 0.40,
                  child: const HeartWidget(
                      size: 200,
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
                  _buildStepContent(_currentStep),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: _previousStep,
                        child: const Text(
                          'Back',
                          style: TextStyle(color: CupidColors.textColorBlack),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
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

class HeartWidget extends StatelessWidget {
  final double size;
  final String asset;
  final Color color;

  const HeartWidget({
    super.key,
    required this.size,
    required this.asset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
