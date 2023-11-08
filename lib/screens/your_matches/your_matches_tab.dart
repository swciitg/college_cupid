import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/crush_list_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/your_crushes/crush_info.dart';
import 'package:flutter/material.dart';
import '../../widgets/your_matches/countdown.dart';

class YourMatches extends StatefulWidget {
  const YourMatches({super.key});

  @override
  State<YourMatches> createState() => _YourMatchesState();
}

class _YourMatchesState extends State<YourMatches> {
  final crushListStore = CrushListStore();
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
            child: Text('Your Matches',
                style: CupidStyles.headingStyle
                    .copyWith(color: CupidColors.titleColor)),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 10),
          //   child: const Text(
          //       'You can select a maximum of 5 crushes at a time.',
          //       style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w400,
          //           height: 1.5,
          //           color: CupidColors.grayColor,
          //           fontFamily: 'Sk-Modernist')),
          // ),
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
                    child: Text('No Matches as of now\nGet Rolling !!!!'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CrushInfo(
                        crushListStore: crushListStore,
                        email: Encryption.decryptAES(
                                encryptedText: Encryption.hexadecimalToBytes(
                                    snapshot.data![index].toString()),
                                key: LoginStore.password!)
                            .replaceAll('0', ''),
                        index: index,
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
    // return Column(
    //   children: [
    //     Align(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 30, bottom: 20, top: 10),
    //         child: Text(
    //           'Your Matches',
    //           style: CupidStyles.headingStyle
    //               .copyWith(color: CupidColors.titleColor),
    //           textAlign: TextAlign.left,
    //         ),
    //       ),
    //     ),
    //     const Expanded(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Center(
    //             child: Countdown(),
    //           ),
    //           SizedBox(height: 15),
    //           Padding(
    //             padding: EdgeInsets.all(16.0),
    //             child: Text(
    //               'Please wait till the end of the timer to see your matches',
    //               style: TextStyle(
    //                   color: Colors.black,
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.w400),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
