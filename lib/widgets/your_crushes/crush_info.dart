import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/crush_list_store.dart';
import 'package:flutter/material.dart';

class CrushInfo extends StatelessWidget {
  final String email;
  final int index;
  final CrushListStore crushListStore;

  const CrushInfo(
      {required this.crushListStore,
      required this.email,
      required this.index,
      super.key});

  @override
  Widget build(BuildContext context) {
    print(email);
    return FutureBuilder(
      future: APIService().getUserProfile(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 32),
            height: 66,
            width: 295,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: CupidColors.pinkColor),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(19), right: Radius.zero),
                  // Image border
                  child: SizedBox.fromSize(
                    child: Image(
                        image: snapshot.data!['profilePicUrl']
                                .toString()
                                .startsWith('https://')
                            ? NetworkImage(
                                snapshot.data!['profilePicUrl'].toString())
                            : const NetworkImage(
                                'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/default-avatar.png'),
                        fit: BoxFit.cover,
                        width: 64,
                        height: 66),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 9),
                        child: Text(snapshot.data!['name'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: CupidColors.blackColor,
                                fontFamily: 'Sk-Modernist')),
                      ),
                      Text(
                          "${snapshot.data!['program']} - ${snapshot.data!['yearOfStudy']}",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: CupidColors.blackColor,
                              fontFamily: 'Sk-Modernist')),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () async {
                    await crushListStore.removeCrush(index);
                    // await APIService().removeCrush(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 24.54, top: 24.54),
                    child: const Image(
                        image: AssetImage('assets/images/close_image.png'),
                        fit: BoxFit.cover,
                        width: 17,
                        height: 17),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
