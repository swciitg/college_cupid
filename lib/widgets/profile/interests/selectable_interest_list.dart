import 'package:college_cupid/widgets/profile/interests/selectable_interest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SelectableInterestList extends StatefulWidget {
  final List<String> selectedInterests;
  final List<String> allInterests;

  const SelectableInterestList(
      {required this.selectedInterests, required this.allInterests, super.key});

  @override
  State<SelectableInterestList> createState() => _SelectableInterestListState();
}

class _SelectableInterestListState extends State<SelectableInterestList> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            direction: Axis.horizontal,
            spacing: 5,
            runSpacing: 10,
            children: widget.allInterests.map((interest) {
              return SelectableInterestCard(
                  selected: widget.selectedInterests.contains(interest),
                  text: interest);
            }).toList(),
          ),
        ],
      );
    });
  }
}
