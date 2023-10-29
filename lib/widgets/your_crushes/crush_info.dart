import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CrushInfo extends StatefulWidget {
  Map receiveData;
  CrushInfo(this.receiveData);

  @override
  State<CrushInfo> createState() => _CrushInfoState();
}

class _CrushInfoState extends State<CrushInfo> {
  late String name;
  late String profilePicUrl;
  late String yearOfStudy;
  late String program;

  @override
  void initState() {
    super.initState();
    name = widget.receiveData['name'];
    profilePicUrl = widget.receiveData['profilePicUrl'];
    yearOfStudy = widget.receiveData['yearOfStudy'];
    program = widget.receiveData['program'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      height: 66,
      width: 295,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: CupidColors.pinkColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(19), right: Radius.zero), // Image border
            child: SizedBox.fromSize(
              child:  Image(
                  image: AssetImage(profilePicUrl),
                  fit: BoxFit.cover,
                  width: 64,
                  height: 66),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 9),
                  child: Text(name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: CupidColors.blackColor,
                          fontFamily: 'Sk-Modernist')),
                ),
                Text( program +"'"+yearOfStudy,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: CupidColors.blackColor,
                        fontFamily: 'Sk-Modernist')),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.only(right: 24.54, top: 24.54),
            child: const Image(
                image: AssetImage('assets/images/close_image.png'),
                fit: BoxFit.cover,
                width: 17,
                height: 17),
          )
        ],
      ),
    );
  }
}
