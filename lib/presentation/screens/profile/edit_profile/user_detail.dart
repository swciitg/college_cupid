import 'package:college_cupid/presentation/screens/profile/edit_profile/sexual_orientation_screen.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/shared/enums.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailsState();
  }

  class _UserDetailsState extends State<UserDetailScreen> {
  List<Program> programs = [Program.none];
  Program myProgram = Program.none;
  final TextEditingController age = TextEditingController();
    final TextEditingController genderController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController programController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.offWhiteColor,
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment:Alignment(-1, 0),
              margin: const EdgeInsets.only( left:20,top:160),
              child:
              const Text("some details about you",
              style: CupidStyles.headingTextStyle,),
            ),
            const SizedBox(height:30,),
            const Padding(padding: EdgeInsets.only(top: 8,
              left: 24,
              bottom: 8,)),
            Container(
              margin: const EdgeInsets.only(left:20,right:20),
              height: 48,
              child: TextFormField(
                focusNode: FocusNode(),
                controller: name,
                decoration: CupidStyles.textFieldInputDecoration.copyWith(
                  labelText: "name",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: const TextStyle(color: CupidColors.blackColor),
                  enabled: true,
                ),
              ),
            ),
            const SizedBox(height:20,),
            const Padding(padding: EdgeInsets.only(top: 8,
              left: 24,
              bottom: 8,)),
            Container(
              margin: const EdgeInsets.only(left:20,right:20),
              height: 48,
              child: TextFormField(
                focusNode: FocusNode(),
                controller: genderController,
                decoration: CupidStyles.textFieldInputDecoration.copyWith(
                  labelText: "gender",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: const TextStyle(
                      color: CupidColors.blackColor),
                  enabled: true,
                ),
              ),

            ),
            const SizedBox(height:20,),
            const Padding(padding: EdgeInsets.only(top: 8,
              left: 24,
              bottom: 8,)),
            Container(
              margin: const EdgeInsets.only(left:20,right:20),
              height: 48,
              child: TextFormField(
                focusNode: FocusNode(),
                controller: programController,
                decoration: CupidStyles.textFieldInputDecoration.copyWith(
                  labelText: "course",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: const TextStyle(color: CupidColors.blackColor),
                  enabled: true,
                ),
              ),
            ),
            const SizedBox(height:20,),
            const Padding(padding: EdgeInsets.only(top: 8,
              left: 24,
              bottom: 8,)),
            Container(
              margin: const EdgeInsets.only(left:20,right:20),
              height: 48,
              child: TextFormField(
                focusNode: FocusNode(),
                controller: age,
                decoration: CupidStyles.textFieldInputDecoration.copyWith(
                  labelText: "age",
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelStyle: const TextStyle(color: CupidColors.blackColor),
                  enabled: true,
                ),
              ),
            ),
            Container(
              alignment: const Alignment(1,0),
              margin:const EdgeInsets.only(right:30,top:40),
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SexualOrientationScreen()));
              }, child: const Text('next',
              style:CupidStyles.textButtonStyle)
              ),
            ),
          ],
          

        ),
      )
    );
  }}