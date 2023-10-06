import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:college_cupid/screens/home/home.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/about_you/interest_card.dart';
import 'package:college_cupid/widgets/global/cupid_botton.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isMale = true;
  File? image;
  List<String> programs = ['B.Tech', 'B.Sc', 'M.Tech', 'PHd', 'M.Sc', 'M.BA'];
  var selectedValue1 = 'B.Tech';

  List<String> year = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    '5th Year',
    '6th Year'
  ];
  var selectedValue2 = '1st Year';

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
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 140 / 53, // as in figma design
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
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        decoration: const BoxDecoration(
                            color: CupidColors.titleColor, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.camera_alt_outlined,
                              color: Colors.white),
                        )))
              ]),
              const Padding(padding: EdgeInsets.only(top: 30)),
              TextField(
                focusNode: FocusNode(),
                decoration: const InputDecoration(
                  labelText: "Name",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: TextStyle(color: CupidColors.pinkColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
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
                              color: isMale ? CupidColors.titleColor : CupidColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Male",
                              style: TextStyle(
                                  color: isMale ? Colors.white : CupidColors.titleColor),
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
                              color: !isMale ? CupidColors.titleColor : CupidColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Female",
                              style: TextStyle(
                                  color: !isMale ? Colors.white : CupidColors.titleColor),
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
                    child: DropdownButtonFormField<String>(
                      value: selectedValue1,
                      items: programs.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue1 = value!;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      decoration: InputDecoration(
                          labelText: "Program",
                          labelStyle: const TextStyle(color: CupidColors.pinkColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: CupidColors.pinkColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  const SizedBox(width: 16), // Add some spacing between dropdowns
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedValue2,
                      items: year.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue2 = value!;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      decoration: InputDecoration(
                          labelText: "Year",
                          labelStyle: const TextStyle(color: CupidColors.pinkColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: CupidColors.pinkColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                ],
              ),
              Column(
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
                  TextField(
                    // controller: bioController,
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
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 20),
        child: CupidButton(
          text: "Confirm",
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
      ),
    );
  }
}
