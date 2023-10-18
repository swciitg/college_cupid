import 'dart:convert';
import 'dart:io';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/about_you/interest_card.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutYouScreen extends StatefulWidget {
  static String id = 'aboutYou';
  final PersonalInfo myInfo;
  final File? image;

  const AboutYouScreen({super.key, required this.image, required this.myInfo});

  @override
  State<AboutYouScreen> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  late TextEditingController bioController;

  @override
  void initState() {
    bioController = TextEditingController();
    super.initState();
  }

  Map<String, IconData> interests = {
    "Photography": Icons.camera_alt_outlined,
    "Shopping": Icons.shopping_bag_outlined,
    "Karoake": Icons.mic_none_outlined,
    "Yoga": Icons.circle_outlined,
    "Cooking": Icons.food_bank_outlined,
    "Tennis": Icons.sports_baseball_outlined,
    "Run": Icons.run_circle_outlined,
    "Swimming": Icons.waves_rounded,
    "Art": Icons.color_lens_outlined,
    "Travelling": Icons.travel_explore_rounded,
    "Extreme": Icons.travel_explore_outlined,
    "Music": Icons.music_note_outlined,
  };

  Set<String> selectedInterests = {};

  void interestSelected(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  Widget _buildInterestsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 140 / 50,
        // as in figma design
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: interests.entries
            .map(
              (interest) => InterestCard(
                icon: interest.value,
                text: interest.key,
                isSelected: selectedInterests.contains(interest.key),
                onTap: () => interestSelected(interest.key),
              ),
            )
            .toList(),
      ),
    );
  }

  final _cupidFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CupidColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CupidColors.titleColor,
          ),
        ),
        title: const Text("About You", style: CupidStyles.pageHeadingStyle),
        elevation: 0,
      ),
      body: Form(
        key: _cupidFormkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                // had to keep these in different column
                // so that padding does cut the boxshadow of selected interests
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Bio',
                        style: CupidStyles.headingStyle
                            .copyWith(color: CupidColors.titleColor)),
                    const SizedBox(height: 10),
                    const Text(
                      'Write a brief description about yourself to attract people to your profile.',
                      softWrap: true,
                      style: CupidStyles.lightTextStyle,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: bioController,
                      maxLines: 5,
                      style: CupidStyles.normalTextStyle,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            width: 1.2,
                            color: CupidColors.secondaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: CupidColors.titleColor),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CupidColors.pinkColor, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your bio";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Your Interests",
                      style: CupidStyles.headingStyle
                          .copyWith(color: CupidColors.titleColor),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Select a few of your interests and let everyone know what you’re passionate about.",
                      style: CupidStyles.lightTextStyle,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildInterestsGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 20),
        child: CupidButton(
          text: "Confirm",
          onTap: () async {
            if (_cupidFormkey.currentState!.validate()) {
              widget.myInfo.bio = bioController.text;
              widget.myInfo.interests = selectedInterests.toList();
              NavigatorState nav = Navigator.of(context);
              String profilePicUrl =
                  await APIService().postMyInfo(widget.image, widget.myInfo);
              widget.myInfo.profilePicUrl = profilePicUrl;
              SharedPreferences user = await SharedPreferences.getInstance();
              await user.setString(
                  'myInfo', jsonEncode(widget.myInfo.toJson()));
              await LoginStore().updateUserData();
              await user.setBool('isProfileCompleted', true);

              nav.pushNamedAndRemoveUntil(SplashScreen.id, (route) => false);
            }
          },
        ),
      ),
    );
  }
}
