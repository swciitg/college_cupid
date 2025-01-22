import 'dart:io';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/edit_profile/crop_image_screen.dart';
import 'heart_state.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({super.key});
  @override
  State<AddPhotos> createState() => _AddPhotosState();

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 200,
        left: -60,
        bottom: size.height * 0.25,
      ),
      "blue": HeartState(
        size: 200,
        right: 75,
        bottom: size.height * 0.09,
      ),
      "pink": HeartState(
        size: 180,
        right: -50,
        top: size.height * 0.25,
      ),
    };
  }
}

class _AddPhotosState extends State<AddPhotos> {
  File? image1;
  File? image2;
  File? image3;

  void _selectImage(int index) async {
    final nav = Navigator.of(context);
    final value = await imageHelpers.pickImage(source: ImageSource.gallery);

    if (value == null) return;

    Image pickedImage = await imageHelpers.xFileToImage(xFile: value);
    final croppedImage = await nav.push<File>(
      MaterialPageRoute(
        builder: (context) => CropImageScreen(image: pickedImage),
      ),
    );

    setState(() {
      switch (index) {
        case 0:
          image1 = croppedImage;
          break;
        case 1:
          image2 = croppedImage;
          break;
        default:
          image3 = croppedImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add Photos", style: CupidStyles.headingStyle),
        const SizedBox(height: 16),
        SizedBox(
          height: size.height * 0.5,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 60,
                child: _profilePic(0),
              ),
              Positioned(
                top: 70,
                left: 0,
                child: _profilePic(1),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: _profilePic(2),
              ),
            ],
          ),
        ),
        const Text(
          "Pro tips:",
          style: CupidStyles.subHeadingTextStyle,
        ),
        _buildTextRow(
          Icons.check,
          const Color(0xFF7AEAA9),
          "Selfies are good",
        ),
        _buildTextRow(
          Icons.check,
          const Color(0xFF7AEAA9),
          "Use photos related to your interests",
        ),
        _buildTextRow(
          Icons.close,
          const Color(0xFFFBA8AA),
          "Avoid group shots",
        )
      ],
    );
  }

  Widget _profilePic(int index) {
    final image = index == 0
        ? image1
        : index == 1
            ? image2
            : image3;
    const height = 230.0;
    const width = 230 * 0.75;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _selectImage(index);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupidColors.glassWhite,
          border: Border.all(color: const Color(0xFF11142A), width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: image == null
              ? const Center(child: Icon(Icons.add, size: 40))
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }

  Widget _buildTextRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: CupidStyles.lightTextStyle,
        )
      ],
    );
  }
}
