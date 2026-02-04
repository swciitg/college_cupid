import 'package:college_cupid/presentation/widgets/profile/interests/display_interests.dart';

import 'package:flutter/material.dart';
import 'heart_state.dart';

class ChooseInterests extends StatelessWidget {
  const ChooseInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayInterests(),
        SizedBox(height: 2 * kBottomNavigationBarHeight),
      ],
    );
  }

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
