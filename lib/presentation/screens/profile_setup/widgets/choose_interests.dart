import 'package:college_cupid/presentation/widgets/profile/interests/display_interests.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'heart_state.dart';

class ChooseInterests extends StatefulWidget {
  const ChooseInterests({super.key});

  @override
  State<ChooseInterests> createState() => _ChooseInterestsState();

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

class _ChooseInterestsState extends State<ChooseInterests> {
  final List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else if (selectedInterests.length < 3) {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: kToolbarHeight),
        Text("Choose your Interests", style: CupidStyles.headingStyle),
        Text(
          "This will be displayed on your profile",
          style: CupidStyles.lightTextStyle,
        ),
        SizedBox(height: 8),
        // Wrap(
        //   spacing: 20,
        //   runSpacing: 15,
        //   children: [
        //     _buildChip("sports", Icons.sports_basketball_outlined),
        //     _buildChip("studying", CupertinoIcons.book),
        //     _buildChip("everyone", Icons.cookie_outlined),
        //     _buildChip("travelling", Icons.wallet_travel),
        //     _buildChip("exploring", Icons.travel_explore),
        //     _buildChip("fitness", Icons.fitness_center),
        //     _buildChip("cooking", FluentIcons.spatula_spoon_16_filled),
        //     _buildChip("fashion", Icons.star),
        //     _buildChip("staying in", Icons.tv),
        //     _buildChip("music & concerts", CupertinoIcons.music_note),
        //     _buildChip("photography", Icons.camera),
        //     _buildChip("arts & crafts", Icons.carpenter),
        //     _buildChip("gardening", Icons.grass),
        //     _buildChip("gaming", CupertinoIcons.gamecontroller_alt_fill),
        //     _buildChip("writing", CupertinoIcons.pencil_outline),
        //     _buildChip("other", CupertinoIcons.personalhotspot)
        //   ],
        // ),
        DisplayInterests(),
        SizedBox(height: 20),
      ],
    );
  }
}
