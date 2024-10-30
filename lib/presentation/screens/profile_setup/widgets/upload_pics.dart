import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class AddPhotos extends StatelessWidget {
  const AddPhotos({super.key});

  static List<Widget> getBackgroundHearts() {
    return [
      Builder(builder: (context) {
        return const Positioned(
            top: 100,
            left: -60,
            child: HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99FBA8AA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            right: 75,
            bottom: MediaQuery.of(context).size.height * 0.09,
            child: const HeartShape(
                size: 200, asset: "assets/icons/heart_outline.svg", color: Color(0x99A8CEFA)));
      }),
      Builder(builder: (context) {
        return Positioned(
            right: -50,
            top: MediaQuery.of(context).size.height * 0.25,
            child: const HeartShape(
                size: 180, asset: "assets/icons/heart_outline.svg", color: Color(0x99EAE27A)));
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
              text: "add ",
              style: TextStyle(
                  fontSize: 32, color: CupidColors.textColorBlack, fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                    text: "photos",
                    style: TextStyle(
                        fontSize: 32,
                        color: CupidColors.textColorBlack,
                        fontWeight: FontWeight.w400))
              ]),
        ),
        const SizedBox(
          height: 15,
        ),
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
              fontSize: 20, color: CupidColors.textColorBlack, fontWeight: FontWeight.w400),
        ),
        _buildTextRow(Icons.check, const Color(0xFF7AEAA9), "selfies are good"),
        _buildTextRow(Icons.check, const Color(0xFF7AEAA9), "use photos related to your interests"),
        _buildTextRow(Icons.close, const Color(0xFFFBA8AA), "avoid group shots")
      ],
    );
  }
}

Widget _buildContainer() {
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

Widget _buildTextRow(IconData icon, Color color, String text) {
  return Row(
    children: [
      Icon(
        icon,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(text,
          style: const TextStyle(
              fontSize: 18,
              color: CupidColors.textColorBlack,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.fade))
    ],
  );
}
