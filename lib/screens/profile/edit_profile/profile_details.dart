import 'dart:io';

import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile/about_you.dart';
import 'package:college_cupid/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/diffie_hellman_constants.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/authentication/logout_button.dart';
import 'package:college_cupid/widgets/global/custom_drop_down.dart';
import 'package:college_cupid/widgets/profile/disabled_text_field.dart';
import 'package:college_cupid/widgets/profile/gender_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetails extends StatefulWidget {
  static String id = '/profileDetails';

  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ImageHelpers imageHelpers = ImageHelpers();
  Gender gender = Gender.male;
  File? image;

  List<Program> programs = [Program.none];
  Program myProgram = Program.none;

  final TextEditingController name = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController yearOfJoinController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  void onSubmit() {
    if (image == null) {
      showSnackBar(
          "Please pick your profile picture. You can change it later.");
      return;
    }
    if (myProgram == Program.none) {
      showSnackBar("Please select your program!");
      return;
    }
    if (_validatePasswords()) {
      KeyPair keyPair = DiffieHellman.generateKeyPair();

      String publicKey = keyPair.publicKey.toString();
      String privateKey = keyPair.privateKey.toString();

      String encryptedPrivateKey = Encryption.bytesToHexadecimal(
          Encryption.encryptAES(plainText: privateKey, key: pass.text));

      UserProfile myProfile = UserProfile(
          name: LoginStore.displayName!,
          profilePicUrl: '',
          gender: gender.databaseString,
          email: LoginStore.email!,
          bio: '',
          yearOfJoin: getYearOfJoinFromRollNumber(LoginStore.rollNumber!),
          program: myProgram.databaseString!,
          publicKey: publicKey,
          interests: []);

      PersonalInfo myInfo = PersonalInfo(
        email: LoginStore.email!,
        hashedPassword: Encryption.bytesToHexadecimal(
            Encryption.calculateSHA256(pass.text)),
        encryptedPrivateKey: encryptedPrivateKey,
        publicKey: publicKey,
        crushes: [],
        encryptedCrushes: [],
        matches: [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AboutYouScreen(
            image: image,
            myProfile: myProfile,
            myInfo: myInfo,
            password: pass.text,
            privateKey: privateKey,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    programs.addAll(getProgramListFromRollNumber(LoginStore.rollNumber!));
    name.text = LoginStore.displayName!;
    pass.text = '';
    emailController.text = LoginStore.email!;
    yearOfJoinController.text =
        '20${getYearOfJoinFromRollNumber(LoginStore.rollNumber!)}';
    programController.text = myProgram.displayString;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CupidColors.titleColor,
          onPressed: onSubmit,
          child: const Icon(
            FluentIcons.chevron_right_32_regular,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: CupidStyles.statusBarStyle,
          actions: const [LogoutButton()],
          title: const Text(
            'Profile Details',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          forceMaterialTransparency: true,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          // physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(25).copyWith(bottom: 0),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
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
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 150,
                                height: 150,
                                color: CupidColors.titleColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    controller: name,
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: "Name",
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.pinkColor),
                      enabled: false,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    controller: emailController,
                    enabled: false,
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: 'Email',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.pinkColor),
                    ),
                  ),
                ),
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
                            isSelected: gender == Gender.male,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.female;
                            });
                          },
                          child: GenderTile(
                              gender: Gender.female,
                              isSelected: gender == Gender.female),
                        )
                      ]),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomDropDown(
                        items: programs.map((e) => e.displayString).toList(),
                        label: "Program",
                        value: Program.none.displayString,
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
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    controller: pass,
                    obscureText: true,
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: "Password",
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.pinkColor),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    controller: confirmPass,
                    obscureText: true,
                    decoration: CupidStyles.textFieldInputDecoration.copyWith(
                      labelText: "Confirm Password",
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      labelStyle: const TextStyle(color: CupidColors.pinkColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePasswords() {
    if (pass.text.isEmpty || confirmPass.text.isEmpty) {
      showSnackBar('Please fill all the details!');
      return false;
    } else if (confirmPass.text != pass.text) {
      showSnackBar('Passwords do not match!');
      return false;
    }
    return true;
  }
}
