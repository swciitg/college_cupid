import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/main.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:college_cupid/screens/profile/edit_profile/select_interests_screen.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/global/custom_drop_down.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/profile/disabled_text_field.dart';
import 'package:college_cupid/widgets/profile/gender_tile.dart';
import 'package:college_cupid/widgets/profile/interests/display_only_interest_list.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  static String id = '/editProfile';

  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ImageHelpers imageHelpers = ImageHelpers();
  late Gender gender;
  File? image;

  final _cupidFormKey = GlobalKey<FormState>();

  List<Program> programs = [Program.none];
  late Program myProgram;
  late InterestStore interestStore;
  late CommonStore commonStore;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController yearOfJoinController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    commonStore = context.read<CommonStore>();
    UserProfile myProfile = UserProfile.fromJson(commonStore.myProfile);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: CupidStyles.statusBarStyle,
          foregroundColor: CupidColors.titleColor,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          title:
              const Text("Edit Profile", style: CupidStyles.pageHeadingStyle),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CupidColors.titleColor,
          onPressed: () async {
            if (loading) return;
            if (_cupidFormKey.currentState!.validate() == false) return;
            if (myProgram == Program.none) {
              showSnackBar("Please select your program!");
              return;
            }
            if (interestStore.selectedInterests.length < 5) {
              showSnackBar("Select at least 5 interests!");
              return;
            }
            if (interestStore.selectedInterests.length > 20) {
              showSnackBar("You cannot select more than 20 interests!");
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
                bio: bioController.text.trim(),
                yearOfJoin: getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
                program: myProgram.databaseString!,
                publicKey: LoginStore.dhPublicKey!,
                interests: interestStore.selectedInterests,
              );

              updatedProfile.profilePicUrl =
                  await APIService().updateUserProfile(image, updatedProfile);
              final updatedProfileMap =
                  await APIService().getUserProfile(LoginStore.email!);

              if (updatedProfileMap != null) {
                await commonStore.updateMyProfile(updatedProfileMap);
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
          child: loading
              ? const CustomLoader(
                  color: Colors.white,
                )
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
        ),
        body: Form(
          key: _cupidFormKey,
          child: Observer(builder: (_) {
            UserProfile myProfile = UserProfile.fromJson(commonStore.myProfile);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Stack(children: [
                      Hero(
                        tag: 'profilePic',
                        child: GestureDetector(
                          onTap: () async {
                            final nav = Navigator.of(context);
                            final value = await imageHelpers.pickImage(
                                source: ImageSource.gallery);

                            if (value == null) return;

                            Image pickedImage =
                                await ImageHelpers.xFileToImage(xFile: value);
                            final croppedImage =
                                await nav.push<File>(MaterialPageRoute(
                              builder: (context) =>
                                  CropImageScreen(image: pickedImage),
                            ));

                            setState(() {
                              image = croppedImage;
                            });
                          },
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    image!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : myProfile.profilePicUrl.isNotEmpty
                                  ? SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: myProfile.profilePicUrl,
                                          cacheManager: customCacheManager,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Container(
                                            color: CupidColors.titleColor,
                                            child: const CustomLoader(color: Colors.white,),
                                          ),
                                        ),
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
                      ),
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
                                    (element) =>
                                        element.displayString == value);
                                programController.text =
                                    myProgram.displayString;
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your bio";
                            }
                            return null;
                          },
                          controller: bioController,
                          maxLines: 5,
                          style: CupidStyles.normalTextStyle,
                          decoration:
                              CupidStyles.textFieldInputDecoration.copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectInterestsScreen(),
                                ));
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Your Interests",
                                    style: CupidStyles.headingStyle.copyWith(
                                        color: CupidColors.titleColor),
                                  ),
                                  const Icon(
                                    FluentIcons.chevron_right_24_regular,
                                    color: CupidColors.grayColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                    DisplayOnlyInterestList(
                      interests: interestStore.selectedInterests,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
