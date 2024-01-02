import 'dart:io';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/main.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/profile/disabled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/about_you/interest_card.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';

class EditProfile extends StatefulWidget {
  static String id = '/editProfile';

  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final myProfile = UserProfile.fromJson(LoginStore.myProfile);
  ImageHelpers imageHelpers = ImageHelpers();
  late Gender gender;
  File? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController yearOfJoinController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  bool loading = false;

  Map<String, IconData> interests = {
    "Photography": Icons.camera_alt_outlined,
    "Shopping": Icons.shopping_bag_outlined,
    "Karaoke": Icons.mic_none_outlined,
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
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 140 / 53,
      crossAxisSpacing: 20,
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
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await imageHelpers.pickImage(source: source);
      if (image == null) return;
      await cropImage(image);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> cropImage(XFile image) async {
    final croppedImage = await imageHelpers.crop(file: image);
    if (croppedImage != null) {
      setState(() {
        this.image = File(croppedImage.path);
      });
    }
  }

  void onConfirm() async {
    try {
      setState(() {
        loading = true;
      });
      UserProfile updatedProfile = UserProfile(
        name: LoginStore.displayName!,
        profilePicUrl: '',
        gender: gender.databaseString,
        email: LoginStore.email!,
        bio: bioController.text,
        yearOfJoin: getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
        program: programController.text,
        publicKey: LoginStore.dhPublicKey!,
        interests: selectedInterests.toList(),
      );

      updatedProfile.profilePicUrl =
          await APIService().updateUserProfile(image, updatedProfile);
      final updatedProfileMap =
          await APIService().getUserProfile(LoginStore.email!);

      if (updatedProfileMap != null) {
        print(updatedProfileMap);
        await LoginStore.updateMyProfile(updatedProfileMap);
        showSnackBar("Profile updated Successfully");
      } else {
        showSnackBar(
            "Profile couldn't update locally. Kindly update again later!");
      }
      setState(() {
        loading = false;
      });
      navigatorKey.currentState!.pop(updatedProfile);
    } catch (e) {
      setState(() {
        loading = false;
      });
      showSnackBar("Some error occured!");
    }
  }

  @override
  void initState() {
    gender = Gender.values
        .firstWhere((element) => element.databaseString == myProfile.gender);
    nameController.text = myProfile.name;
    bioController.text = myProfile.bio;
    emailController.text = myProfile.email;
    yearOfJoinController.text = '20${myProfile.yearOfJoin}';
    programController.text = Program.values
        .firstWhere((element) => element.databaseString == myProfile.program)
        .displayString;
    selectedInterests = myProfile.interests.toSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CupidColors.backgroundColor,
        appBar: AppBar(
          foregroundColor: CupidColors.titleColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Edit Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Stack(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pickImage(ImageSource.gallery);
                      });
                    },
                    child: image != null
                        ? ClipOval(
                            child: Image.file(
                              image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : myProfile.profilePicUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  myProfile.profilePicUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: CupidColors.titleColor,
                                ),
                              ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: CupidColors.titleColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CupidColors.backgroundColor,
                              width: 3,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.camera_alt_outlined,
                                color: Colors.white),
                          )))
                ]),
                const Padding(padding: EdgeInsets.only(top: 30)),
                DisabledTextField(
                    controller: nameController, labelText: "Name"),
                const Padding(padding: EdgeInsets.only(top: 15)),
                DisabledTextField(
                    controller: emailController, labelText: "Email"),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: CupidColors.pinkColor,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Select Gender',
                          style: TextStyle(
                            color: CupidColors.pinkColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.male;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: gender == Gender.male
                                    ? CupidColors.titleColor
                                    : CupidColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                Gender.male.displayString,
                                style: TextStyle(
                                    color: gender == Gender.male
                                        ? Colors.white
                                        : CupidColors.titleColor),
                              ),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.female;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: gender == Gender.female
                                    ? CupidColors.titleColor
                                    : CupidColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                Gender.female.displayString,
                                style: TextStyle(
                                    color: gender == Gender.female
                                        ? Colors.white
                                        : CupidColors.titleColor),
                              ),
                            )),
                          ),
                        )
                      ]),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: DisabledTextField(
                        controller: programController,
                        labelText: "Program",
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add some spacing between dropdowns
                    Expanded(
                      child: DisabledTextField(
                        controller: yearOfJoinController,
                        labelText: "Year of joining",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    TextField(
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
                      ),
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
                _buildInterestsGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: CupidColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: CupidButton(
              text: "Confirm",
              loading: loading,
              onTap: () {
                onConfirm();
              },
            ),
          ),
        ),
      ),
    );
  }
}
