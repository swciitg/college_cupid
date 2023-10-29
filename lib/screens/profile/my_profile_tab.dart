import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/profile/view_interests_grid.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class MyProfileTab extends StatefulWidget {
  const MyProfileTab({super.key});

  @override
  State<MyProfileTab> createState() => _MyProfileTabState();
}

class _MyProfileTabState extends State<MyProfileTab> {
  bool readMore = true;
  var myProfile = UserProfile.fromJson(LoginStore.myProfile);
  final defaultPicUrl =
      "https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg?crop=0.670xw:1.00xh;0.167xw,0&resize=640:*";

  void editProfile() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const EditProfile()));
    setState(() {
      myProfile = UserProfile.fromJson(LoginStore.myProfile);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var safeArea = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          editProfile();
        },
        backgroundColor: CupidColors.pinkColor,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      backgroundColor: CupidColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              child: Image.network(myProfile.profilePicUrl.isNotEmpty
                  ? myProfile.profilePicUrl
                  : defaultPicUrl),
            ),
            Column(
              children: [
                SizedBox(
                  height: safeArea.width * 0.9,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: CupidColors.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myProfile.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text(
                              myProfile.email,
                              textAlign: TextAlign.left,
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              '${myProfile.program}, ${myProfile.yearOfStudy.toLowerCase()}',
                              textAlign: TextAlign.right,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'About',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: readMore ? 33 : null,
                        child: Text(myProfile.bio, overflow: TextOverflow.clip),
                      ),
                      const SizedBox(height: 8),
                      if (myProfile.bio.length > 30)
                        GestureDetector(
                          child: Text(
                            !readMore ? "Show less" : "Read more",
                            style: const TextStyle(
                                color: CupidColors.navBarIconColor),
                            textAlign: TextAlign.left,
                          ),
                          onTap: () {
                            setState(() {
                              readMore = !readMore;
                            });
                          },
                        ),
                      const SizedBox(height: 8),
                      if (myProfile.interests.isNotEmpty)
                        ViewInterestsGrid(interests: myProfile.interests)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
