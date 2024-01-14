import 'dart:io';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/main.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile/select_interests_screen.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/global/custom_drop_down.dart';
import 'package:college_cupid/widgets/profile/disabled_text_field.dart';
import 'package:college_cupid/widgets/profile/gender_tile.dart';
import 'package:college_cupid/widgets/profile/interests/display_only_interest_list.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:provider/provider.dart';

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

  List<Program> programs = [Program.none];
  late Program myProgram;
  late InterestStore interestStore;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController yearOfJoinController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  bool loading = false;

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

  @override
  void initState() {
    myProgram = Program.values
        .firstWhere((element) => element.databaseString == myProfile.program);
    gender = Gender.values
        .firstWhere((element) => element.databaseString == myProfile.gender);
    nameController.text = myProfile.name;
    bioController.text = myProfile.bio;
    emailController.text = myProfile.email;
    yearOfJoinController.text = '20${myProfile.yearOfJoin}';
    programController.text = myProgram.displayString;
    programs.addAll(getProgramListFromRollNumber(LoginStore.rollNumber!));

    interestStore = context.read<InterestStore>();
    interestStore.setSelectedInterests(myProfile.interests);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: CupidColors.titleColor,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
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
                              color: Colors.white,
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
                          child: GenderTile(
                              gender: Gender.male,
                              isSelected: Gender.male == gender),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.female;
                            });
                          },
                          child: GenderTile(
                              gender: Gender.female,
                              isSelected: Gender.female == gender),
                        )
                      ]),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDropDown(
                      items: programs.map((e) => e.displayString).toList(),
                      label: "Program",
                      value: myProgram.displayString,
                      validator: (value) {},
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            myProgram = Program.values.firstWhere(
                                (element) => element.displayString == value);
                            programController.text = myProgram.displayString;
                          });
                        }
                      },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Interests",
                          style: CupidStyles.headingStyle
                              .copyWith(color: CupidColors.titleColor),
                        ),
                        IconButton(
                            padding: const EdgeInsets.all(15),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectInterestsScreen(),
                                  ));
                            },
                            icon: const Icon(
                              FluentIcons.chevron_right_24_regular,
                              color: CupidColors.grayColor,
                            ))
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                DisplayOnlyInterestList(
                  interests: interestStore.selectedInterests,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: CupidButton(
              text: "Confirm",
              loading: loading,
              onTap: () async {
                if (myProgram == Program.none) {
                  showSnackBar("Please select your program!");
                  return;
                }
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
                    yearOfJoin:
                        getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
                    program: myProgram.databaseString!,
                    publicKey: LoginStore.dhPublicKey!,
                    interests: interestStore.selectedInterests,
                  );

                  updatedProfile.profilePicUrl = await APIService()
                      .updateUserProfile(image, updatedProfile);
                  final updatedProfileMap =
                      await APIService().getUserProfile(LoginStore.email!);

                  if (updatedProfileMap != null) {
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
                  showSnackBar("Some error occurred!");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
