import 'dart:io';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/profile/interests/display_interests.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutYouScreen extends StatefulWidget {
  static String id = 'aboutYou';
  final PersonalInfo myInfo;
  final String password;
  final String privateKey;
  final File? image;
  final UserProfile myProfile;

  const AboutYouScreen(
      {super.key,
      required this.myProfile,
      required this.privateKey,
      required this.password,
      required this.image,
      required this.myInfo});

  @override
  State<AboutYouScreen> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  late TextEditingController bioController;
  late InterestStore interestStore;

  @override
  void initState() {
    bioController = TextEditingController();
    interestStore = context.read<InterestStore>();
    interestStore.setSelectedInterests([]);
    super.initState();
  }

  final _cupidFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
          forceMaterialTransparency: true,
        ),
        body: Form(
          key: _cupidFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                      child: Text('Bio',
                          style: CupidStyles.headingStyle
                              .copyWith(color: CupidColors.titleColor)),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      child: Text(
                        'Write a brief description about yourself to attract people to your profile.',
                        softWrap: true,
                        style: CupidStyles.lightTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: bioController,
                        maxLines: 5,
                        style: CupidStyles.normalTextStyle,
                        decoration:
                            CupidStyles.textFieldInputDecoration.copyWith(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your bio";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                      child: Text(
                        "Your Interests",
                        style: CupidStyles.headingStyle
                            .copyWith(color: CupidColors.titleColor),
                      ),
                    ),
                    const DisplayInterests(),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CupidColors.titleColor,
          onPressed: () async {
            if (_cupidFormKey.currentState!.validate()) {
              widget.myProfile.bio = bioController.text.trim();
              widget.myProfile.interests
                  .addAll(interestStore.selectedInterests);
              NavigatorState nav = Navigator.of(context);

              await APIService().postPersonalInfo(widget.myInfo);

              widget.myProfile.profilePicUrl = await APIService()
                  .postUserProfile(widget.image, widget.myProfile);

              await SharedPrefs.setDHPublicKey(widget.myInfo.publicKey);
              await SharedPrefs.setDHPrivateKey(widget.privateKey);
              await SharedPrefs.setPassword(widget.password);
              await SharedPrefs.saveMyProfile(widget.myProfile.toJson());
              await LoginStore.initializeMyProfile();

              nav.pushNamedAndRemoveUntil(SplashScreen.id, (route) => false);
            }
          },
          child: const Icon(
            FluentIcons.chevron_right_32_regular,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
