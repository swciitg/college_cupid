import 'package:college_cupid/presentation/widgets/profile/interests/selectable_interest_list.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class DisplayInterests extends StatelessWidget {
  const DisplayInterests({super.key});

  @override
  Widget build(BuildContext context) {
    final InterestStore interestStore = context.read<InterestStore>();
    return Observer(builder: (_) {
      return Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            "Select a few of your interests and let everyone know what you’re passionate about.",
            style: CupidStyles.lightTextStyle,
          ),
        ),
        ...interestsMap.keys
            .map(
              (key) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      key,
                      style: const TextStyle(
                          fontSize: 20, color: CupidColors.greyColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
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
            .toList()
      ]);
    });
  }
}
