import 'dart:developer';

import 'package:college_cupid/presentation/controllers/crushes_controller.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/your_crushes/crush_info_tile.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourCrushesTab extends ConsumerStatefulWidget {
  const YourCrushesTab({super.key});

  @override
  ConsumerState<YourCrushesTab> createState() => _YourCrushesTabState();
}

class _YourCrushesTabState extends ConsumerState<YourCrushesTab> {
  @override
  void initState() {
    super.initState();
    ref.read(crushesControllerProvider.notifier).getCrushProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final crushesListState = ref.watch(crushesControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Crushes', style: CupidStyles.headingStyle),
              const SizedBox(height: 8),
              Text(
                'You can select a maximum of 7 crushes at a time.',
                style: CupidStyles.lightTextStyle.setFontSize(13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: crushesListState.when(
            data: (crushesList) {
              if (crushesList.isEmpty) {
                return const Center(
                  child: Text(
                    'No Crushes as of now\nGet Rolling!!!',
                    textAlign: TextAlign.center,
                    style: CupidStyles.lightTextStyle,
                  ),
                );
              } else {
                final activeUsers =
                    crushesList.where((e) => !e.deactivated).toList();
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: activeUsers.length,
                  itemBuilder: (context, index) => CrushInfoTile(
                    profile: activeUsers[index],
                    index: index,
                  ),
                );
              }
            },
            error: (err, st) {
              log(err.toString());
              return const Center(
                child: Text(
                  'Some error occurred\nPlease try again!',
                  textAlign: TextAlign.center,
                  style: CupidStyles.lightTextStyle,
                ),
              );
            },
            loading: () => const CustomLoader(),
          ),
        ),
      ],
    );
  }
}
