import 'dart:io';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/about_you/about_you.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
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
  bool isMale = true;
  File? image;

  // late UserModel user;
  List<String> programs = [
    'B.Tech',
    'M.Tech',
    'B.Des',
    'M.Des',
    'PhD',
    'M.Sc',
  ];
  var program = 'B.Tech';
  TextEditingController name = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController gender = TextEditingController();

  // late TextEditingController program;
  // late TextEditingController year;
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  List<String> year = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    '5th Year',
    '6th Year'
  ];
  String yearOfStudy = '1st Year';

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

  void onSubmit() {
    if (image == null) {
      showSnackBar(
          " Please pick your profile picture. You can change it later.");
      return;
    }
    if (_validatePasswords()) {
      DiffieHellman df = DiffieHellman();
      String publicKey = df.publicKey.toString();
      String privateKey = df.privateKey.toString();

      String encryptedPrivateKey = Encryption.bytesToHexadecimal(
          Encryption.encryptAES(privateKey, pass.text));

      UserProfile myProfile = UserProfile(
          name: LoginStore.displayName!,
          profilePicUrl: '',
          gender: isMale ? 'male' : 'female',
          email: LoginStore.email!,
          bio: '',
          yearOfStudy: yearOfStudy,
          program: program,
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

      print(myInfo.toJson().toString());
      print(myProfile.toJson().toString());
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
    name.text = LoginStore.displayName!;
    pass.text = '';
    emailController.text = LoginStore.email!;
    gender.text = 'male';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile Details',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            )),
      ),
      body: Padding(
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
                        ))
                      : ClipOval(
                          child: Container(
                            width: 100,
                            height: 100,
                            color: CupidColors.titleColor,
                          ),
                        )),
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
            SizedBox(
              height: 56,
              child: TextFormField(
                focusNode: FocusNode(),
                controller: name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: TextStyle(color: CupidColors.pinkColor),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabled: false,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Your name please!";
                  }
                  return null;
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            SizedBox(
              height: 56,
              child: TextFormField(
                  focusNode: FocusNode(),
                  controller: emailController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    labelStyle: TextStyle(color: CupidColors.pinkColor),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CupidColors.pinkColor, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CupidColors.pinkColor, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Your name please!";
                    }
                    return null;
                  }),
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
                      'Select Gender ',
                      style: TextStyle(
                        color: CupidColors.pinkColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? CupidColors.titleColor
                                : CupidColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Male",
                            style: TextStyle(
                                color: isMale
                                    ? CupidColors.whiteColor
                                    : CupidColors.titleColor),
                          ),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            color: !isMale
                                ? CupidColors.titleColor
                                : CupidColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Female",
                            style: TextStyle(
                                color: !isMale
                                    ? CupidColors.whiteColor
                                    : CupidColors.titleColor),
                          ),
                        )),
                      ),
                    )
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: program,
                      items: programs.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          program = value!;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      decoration: InputDecoration(
                          labelText: "Program",
                          labelStyle:
                              const TextStyle(color: CupidColors.pinkColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: CupidColors.pinkColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  const SizedBox(
                      width: 16), // Add some spacing between dropdowns
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: yearOfStudy,
                      items: year.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          yearOfStudy = value!;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      decoration: InputDecoration(
                        labelText: "Year",
                        labelStyle:
                            const TextStyle(color: CupidColors.pinkColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: CupidColors.pinkColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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
                decoration: const InputDecoration(
                  label: Text(
                    "Password",
                    style: TextStyle(color: CupidColors.pinkColor),
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: TextStyle(color: CupidColors.pinkColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
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
                decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    labelStyle: TextStyle(color: CupidColors.pinkColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CupidColors.pinkColor, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CupidColors.pinkColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CupidColors.pinkColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
            ),
            const Expanded(child: SizedBox()),
            CupidButton(text: 'Continue', onTap: onSubmit),
          ],
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
