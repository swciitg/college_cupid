import 'package:college_cupid/presentation/controllers/crushes_controller.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/your_crushes/crush_info_tile.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourCrushesTab extends StatelessWidget {
  const YourCrushesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Your Crushes',
              style: CupidStyles.headingStyle
                  .copyWith(color: CupidColors.titleColor)),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
                'You can select a maximum of 5 crushes at a time.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: CupidColors.grayColor,
                    fontFamily: 'Sk-Modernist')),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final crushesListState = ref.watch(crushesProvider);
              return crushesListState.when(
                  data: (crushesList) {
                    if (crushesList.isEmpty) {
                      return const Center(
                          child: Text('No Crushes as of now\nGet Rolling!!!',
                              textAlign: TextAlign.center,
                              style: CupidStyles.lightTextStyle));
                    } else {
                      return ListView.builder(
                          itemCount: crushesList.length,
                          itemBuilder: (context, index) => CrushInfoTile(
                              profile: crushesList[index], index: index));
                    }
                  },
                  error: (err, st) => const Center(
                      child: Text('Some error occurred\nPlease try again!',
                          textAlign: TextAlign.center,
                          style: CupidStyles.lightTextStyle)),
                  loading: () => const CustomLoader());
            }),
          ),
        ],
      ),
    );
  }
}
