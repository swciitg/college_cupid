import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:college_cupid/widgets/profile/interests/selectable_interest_list.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class DisplayInterests extends StatelessWidget {
  const DisplayInterests({super.key});

  @override
  Widget build(BuildContext context) {
    final InterestStore interestStore = context.read<InterestStore>();
    return Observer(builder: (_) {
      return Column(
          children: interestsMap.keys
              .map(
                (key) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        key,
                        style: const TextStyle(
                            fontSize: 20,
                            color: CupidColors.grayColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: SelectableInterestList(
                        allInterests: interestsMap[key]!,
                        selectedInterests: interestStore.selectedInterests,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider()
                  ],
                ),
              )
              .toList());
    });
  }
}
