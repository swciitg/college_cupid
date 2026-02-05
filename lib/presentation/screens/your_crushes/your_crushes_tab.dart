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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Crushes', style: CupidTextStyles.brandTitle1),
              SizedBox(height: 8),
              Text(
                'You can select a maximum of 7 crushes at a time.',
                style: CupidTextStyles.body1,
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
                    style: CupidTextStyles.body1,
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
                  style: CupidTextStyles.body1,
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
