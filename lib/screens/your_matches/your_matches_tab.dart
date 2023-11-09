import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
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
          Container(
            margin: const EdgeInsets.only(top: 11),
            child: Text(
              'Your Matches',
              style: CupidStyles.headingStyle
                  .copyWith(color: CupidColors.titleColor),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: APIService().getMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: CupidColors.secondaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'No Matches as of now\nGood Luck !!!!',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Matches as of now\nGood Luck !!!!',
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
