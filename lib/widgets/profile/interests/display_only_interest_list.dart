import 'package:college_cupid/widgets/profile/interests/display_interest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DisplayOnlyInterestList extends StatelessWidget {
  final List<String> interests;

  const DisplayOnlyInterestList({required this.interests, super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
        warnWhenNoObservables: false,
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                direction: Axis.horizontal,
                spacing: 5,
                runSpacing: 10,
                children: interests.map((interest) {
                  return DisplayInterestCard(text: interest);
                }).toList(),
              ),
            ],
          );
        });
  }
}
