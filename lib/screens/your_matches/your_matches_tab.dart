import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/your_matches/match_info.dart';
import 'package:flutter/material.dart';

class YourMatches extends StatefulWidget {
  const YourMatches({super.key});

  @override
  State<YourMatches> createState() => _YourMatchesState();
}

class _YourMatchesState extends State<YourMatches> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Your Matches',
            style: CupidStyles.headingStyle
                .copyWith(color: CupidColors.titleColor),
          ),
          FutureBuilder(
              future: APIService().getCrushesCount(),
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
                String text = 'You have got ${snapshot.data} admirers!';
                if (snapshot.data! == 1) {
                  text = 'You have got an admirer!';
                }
                if (snapshot.data! == 0) {
                  text = 'Your admirer has not registered yet :(';
                }
                return Text(text,
                    style: CupidStyles.headingStyle
                        .copyWith(color: CupidColors.titleColor, fontSize: 16));
              }),
          Expanded(
            child: FutureBuilder(
              future: APIService().getMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: CupidColors.pinkColor,
                  ));
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Please try again later!',
                      textAlign: TextAlign.center,
                      style: CupidStyles.lightTextStyle,
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No Matches as of now\nGood Luck!!!',
                      textAlign: TextAlign.center,
                      style: CupidStyles.lightTextStyle,
                    ),
                  );
                } else {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Matches as of now\nGood Luck!!!',
                        textAlign: TextAlign.center,
                        style: CupidStyles.lightTextStyle,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MatchInfo(
                        email: snapshot.data![index],
                      );
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
