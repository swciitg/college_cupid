import 'package:flutter/material.dart';

import '../../shared/colors.dart';

class YourCrushesTab extends StatefulWidget {
  const YourCrushesTab({super.key});

  @override
  State<YourCrushesTab> createState() => _YourCrushesTabState();
}

class _YourCrushesTabState extends State<YourCrushesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left:40, right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getTitle(),
          getSubTitle(),
          getInstruction(),
          getCrushList()
        ],
      ),
    );
  }

  Widget getTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 23),
      child:  const Text('CollegeCupid', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, height: 1.5, color: CupidColors.blackColor, fontFamily: 'Sk-Modernist')),
    );
  }

  Widget getSubTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 11),
      child:  const Text('Your Crushes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.5, color: CupidColors.pinkColor, fontFamily: 'Sk-Modernist')),
    );
  }

  Widget getInstruction() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child:  const Text('You can select a maximum of 5 crushes at a time.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: CupidColors.grayColor, fontFamily: 'Sk-Modernist')),
    );
  }

  Widget getCrushList() {
    return Expanded(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.only(top:32),
                  height: 66,
                  width: 295,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: CupidColors.pinkColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: getCrushListItem()
              );
            }
        )
    );
  }

  Widget getCrushListItem(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getProfileImage(),
        getNameAndCourse(),
        getCloseButton()
      ],
    );
  }

  Widget getProfileImage()  {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Image border
      child: SizedBox.fromSize(
        child: const Image(image: AssetImage('assets/images/profile_photo.png'), fit: BoxFit.cover, width: 64, height: 66),
      ),
    );
  }

  Widget getNameAndCourse(){
    return Container(
      margin: const EdgeInsets.only(left:15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getName(),
          getCourse()
        ],
      ),
    );
  }

  Widget getName() {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      child:  const Text('Selena Singh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5, color: CupidColors.blackColor, fontFamily: 'Sk-Modernist')),
    );
  }

  Widget getCourse() {
     return const Text('B. Tech ‘25', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: CupidColors.blackColor, fontFamily: 'Sk-Modernist'));
  }

  Widget getCloseButton() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          getCloseImage()
        ],
      ),
    );
  }

  Widget getCloseImage() {
    return Container(
      margin: const EdgeInsets.only(right: 24.54, top: 24.54),
      child: const Image(image: AssetImage('assets/images/close_image.png'), fit: BoxFit.cover, width: 17, height: 17),
    );
  }
}
