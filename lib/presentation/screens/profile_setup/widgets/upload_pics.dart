import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({super.key});

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
                text: "add ",
                style: TextStyle(
                    fontSize: 32,
                    color: CupidColors.textColorBlack,
                    fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                      text: "photos",
                      style: TextStyle(
                          fontSize: 32,
                          color: CupidColors.textColorBlack,
                          fontWeight: FontWeight.w400))
                ]),
          ),
          const SizedBox(height: 15,),
          Container(
            height: 411,
            width: 383,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 60,
                  child: _buildContainer(),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  child: _buildContainer(),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: _buildContainer(),
                ),
              ],
            ),
          ),
          const Text(
            "pro tips:",
            style: TextStyle(
                fontSize: 20,
                color: CupidColors.textColorBlack,
                fontWeight: FontWeight.w400),
          ),
          _buildTextRow(Icons.check, const Color(0xFF7AEAA9), "selfies are good"),
          _buildTextRow(Icons.check, const Color(0xFF7AEAA9), "use photos related to your interests"),
          _buildTextRow(Icons.close, const Color(0xFFFBA8AA), "avoid group shots")
        ],
      ),
    );
  }
}

Widget _buildContainer(){
  return Container(
    //margin: EdgeInsets.all(8),
    height: 230,
    width: 170,
    decoration: BoxDecoration(
      color: CupidColors.glassWhite,
      border: Border.all(color: const Color(0xFF11142A), width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    ),
    child: const Center(
      child: Icon(
        Icons.add,
        size: 40,
      ),
    ),
  );
}

Widget _buildTextRow(IconData icon, Color color, String text){
  return Row(
    children: [
      Icon(icon,color: color,),
      const SizedBox(width:4),
      Text(text,style: const TextStyle(
          fontSize: 18,
          color: CupidColors.textColorBlack,
          fontWeight: FontWeight.w400,
        overflow: TextOverflow.fade
      ))
    ],
  );
}