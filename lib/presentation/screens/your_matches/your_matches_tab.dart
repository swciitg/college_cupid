import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_test_screen.dart';
import 'package:college_cupid/presentation/widgets/your_matches/countdown_timer.dart';
import 'package:college_cupid/presentation/widgets/your_matches/match_info.dart';
import 'package:college_cupid/presentation/widgets/your_matches/prominent_countdown.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/matches_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourMatches extends ConsumerStatefulWidget {
  const YourMatches({super.key});

  @override
  ConsumerState<YourMatches> createState() => _YourMatchesState();
}

class _YourMatchesState extends ConsumerState<YourMatches> {
  Duration difference = matchReleaseTime.difference(DateTime.now());
  var showTimer = false;

  @override
  void initState() {
    showTimer = difference.inSeconds > 0;
    super.initState();
  }

  void _showMBTITest(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(top: kToolbarHeight),
            child: MbtiTestScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchesRepo = ref.read(matchesRepoProvider);
    final crushesRepo = ref.read(crushesRepoProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Your Matches', style: CupidTextStyles.brandTitle1),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Take an MBTI Test',
                          style: CupidTextStyles.subHeadingTextStyle),
                      Text('Get a Match to your personality',
                          style: CupidTextStyles.body2),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _showMBTITest(context);
                      },
                      child: const Text("Take now"))
                ],
              ),
            ),
          ),
          if (showTimer)
            Expanded(
              child: FutureBuilder(
                future: crushesRepo.getCrushesCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CupidColors.secondaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Please try again later!',
                        textAlign: TextAlign.center,
                        style: CupidTextStyles.body1,
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
                          ProminentCountdown(
                            reset: () {
                              setState(() {
                                showTimer = false;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const CountdownTimer(),
                          Text(
                            "Admirer Count: ${snapshot.data ?? 0}",
                            style: CupidTextStyles.brandTitle1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getAdmirerCountMessage(snapshot.data ?? 0),
                            // getAdmirerCountMessage(0),
                            style: CupidTextStyles.title2.copyWith(
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
          if (!showTimer)
            Expanded(
              child: FutureBuilder(
                future: matchesRepo.getMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: CupidColors.secondaryColor,
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Please try again later!',
                        textAlign: TextAlign.center,
                        style: CupidTextStyles.body1,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No Matches as of now\nGood Luck!!!',
                        textAlign: TextAlign.center,
                        style: CupidTextStyles.body1,
                      ),
                    );
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Matches as of now\nGood Luck!!!',
                          textAlign: TextAlign.center,
                          style: CupidTextStyles.body1,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MatchInfo(email: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
