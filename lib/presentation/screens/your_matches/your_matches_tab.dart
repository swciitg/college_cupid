import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/widgets/your_matches/countdown_timer.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/matches_repository.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourMatches extends ConsumerWidget {
  const YourMatches({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesRepo = ref.read(matchesRepoProvider);
    final crushesRepo = ref.read(crushesRepoProvider);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Your Matches', style: CupidStyles.headingStyle),
          Expanded(
            child: FutureBuilder(
              future: crushesRepo.getCrushesCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError || snapshot.hasData == false) {
                  return const Center(
                    child: Text(
                      'Some error occurred!',
                      textAlign: TextAlign.center,
                      style: CupidStyles.lightTextStyle,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountdownTimer(),
                        Text(
                          "Admirer Count: ${snapshot.data ?? 0}",
                          style: CupidStyles.normalTextStyle.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          // getAdmirerCountMessage(snapshot.data ?? 0),
                          getAdmirerCountMessage(0),
                          style: CupidStyles.normalTextStyle.copyWith(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Expanded(
          //   child: FutureBuilder(
          //     future: matchesRepo.getMatches(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //             child: CircularProgressIndicator(
          //           color: CupidColors.pinkColor,
          //         ));
          //       } else if (snapshot.hasError) {
          //         return const Center(
          //           child: Text(
          //             'Please try again later!',
          //             textAlign: TextAlign.center,
          //             style: CupidStyles.lightTextStyle,
          //           ),
          //         );
          //       } else if (!snapshot.hasData) {
          //         return const Center(
          //           child: Text(
          //             'No Matches as of now\nGood Luck!!!',
          //             textAlign: TextAlign.center,
          //             style: CupidStyles.lightTextStyle,
          //           ),
          //         );
          //       } else {
          //         if (snapshot.data!.isEmpty) {
          //           return const Center(
          //             child: Text(
          //               'No Matches as of now\nGood Luck!!!',
          //               textAlign: TextAlign.center,
          //               style: CupidStyles.lightTextStyle,
          //             ),
          //           );
          //         }
          //         return ListView.builder(
          //           padding: EdgeInsets.zero,
          //           itemCount: snapshot.data!.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return MatchInfo(
          //               email: snapshot.data![index],
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
