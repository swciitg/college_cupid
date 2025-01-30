import 'package:college_cupid/presentation/widgets/profile/interests/selectable_interest_card.dart';
import 'package:flutter/material.dart';

class SelectableInterestList extends StatelessWidget {
  final List<String> selectedInterests;
  final List<String> allInterests;

  const SelectableInterestList(
      {required this.selectedInterests, required this.allInterests, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          direction: Axis.horizontal,
          spacing: 4,
          runSpacing: 8,
          children: allInterests.map(
            (interest) {
              return SelectableInterestCard(
                selected: selectedInterests.contains(interest),
                text: interest,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
