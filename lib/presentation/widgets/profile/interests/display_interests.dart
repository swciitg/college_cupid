import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/widgets/profile/interests/selectable_interest_list.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayInterests extends ConsumerWidget {
  const DisplayInterests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterests = ref.watch(onboardingControllerProvider).interests ?? [];
    return Column(
      children: [
        const Text(
          "Select a few of your interests and let everyone know what you’re passionate about.",
          style: CupidStyles.lightTextStyle,
        ),
        const SizedBox(height: 16),
        ...interestsMap.keys
            .map(
              (key) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                        fontSize: 20, color: CupidColors.greyColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SelectableInterestList(
                    allInterests: interestsMap[key]!,
                    selectedInterests: selectedInterests,
                  ),
                  const SizedBox(height: 16),
                  const Divider()
                ],
              ),
            )
            .toList()
      ],
    );
  }
}
