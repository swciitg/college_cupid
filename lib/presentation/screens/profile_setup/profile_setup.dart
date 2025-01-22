import 'package:college_cupid/presentation/screens/profile_setup/widgets/basic_details.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/choose_interests.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/looking_for_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/add_profile_photos.dart';
import 'package:college_cupid/shared/assets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'widgets/heart_shape.dart';
import 'widgets/sexual_orientation_screen.dart';
import 'loading_page.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  int _currentStep = 0;
  late HeartState? _yellow;
  late HeartState? _blue;
  late HeartState? _pink;
  final steps = [
    const BasicDetails(),
    const SexualOrientationScreen(),
    const ChooseInterests(),
    const AddPhotos(),
    const LookingForScreen(),
  ];

  final List<Map<String, HeartState>> _heartStates = [];

  void _nextStep() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep += 1;
        _updateHeartStates();
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
        _updateHeartStates();
      });
    }
  }

  void _updateHeartStates() {
    if (_heartStates.isEmpty) {
      _heartStates.addAll(
        [
          BasicDetails.heartStates(context),
          SexualOrientationScreen.heartStates(context),
          ChooseInterests.heartStates(context),
          AddPhotos.heartStates(context),
          LookingForScreen.heartStates(context),
        ],
      );
    }
    _yellow = _heartStates[_currentStep]['yellow'];
    _blue = _heartStates[_currentStep]['blue'];
    _pink = _heartStates[_currentStep]['pink'];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (_heartStates.isEmpty) _updateHeartStates();
    return Scaffold(
      backgroundColor: CupidColors.glassWhite,
      body: Stack(
        children: [
          ..._heartShapes(),
          SizedBox(
            height: size.height,
            width: size.width,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: steps[_currentStep],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _navigationButtons(),
    );
  }

  List<Widget> _heartShapes() {
    return [
      if (_yellow != null)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
          top: _yellow!.top,
          right: _yellow!.right,
          bottom: _yellow!.bottom,
          left: _yellow!.left,
          child: HeartShape(
            size: _yellow!.size,
            asset: CupidIcons.heartOutline,
            color: const Color(0x99EAE27A),
          ),
        ),
      if (_blue != null)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
          top: _blue!.top,
          right: _blue!.right,
          bottom: _blue!.bottom,
          left: _blue!.left,
          child: HeartShape(
            size: _blue!.size,
            asset: CupidIcons.heartOutline,
            color: const Color(0x99A8CEFA),
          ),
        ),
      if (_pink != null)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
          top: _pink!.top,
          right: _pink!.right,
          bottom: _pink!.bottom,
          left: _pink!.left,
          child: HeartShape(
            size: _pink!.size,
            asset: CupidIcons.heartOutline,
            color: const Color(0x99F9A8D4),
          ),
        ),
    ];
  }

  Widget _navigationButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      child: Row(
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
    );
  }
}
