import 'dart:io';
import 'dart:ui' as ui;

import 'package:college_cupid/presentation/widgets/global/cupid_text_button.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/services/image_helpers.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:crop_image/crop_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class CropImageScreen extends StatefulWidget {
  final Image image;

  const CropImageScreen({required this.image, super.key});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final controller = CropController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Edit Image',
          style: CupidStyles.pageHeadingStyle.copyWith(color: Colors.white),
        ),
        actions: [
          CupidTextButton(
              text: 'Revert',
              fontColor: Colors.white,
              onPressed: () {
                setAspectRatio(-1);
              })
        ],
      ),
      body: CropImage(
        image: widget.image,
        controller: controller,
        onCrop: (value) {},
        paddingSize: 25,
        alwaysShowThirdLines: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: _finished,
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CustomLoader(color: Colors.white),
              )
            : const Icon(
                Icons.done,
                color: Colors.white,
              ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  FluentIcons.arrow_rotate_counterclockwise_24_regular,
                  color: Colors.white,
                ),
                onPressed: _rotateLeft,
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.arrow_rotate_clockwise_24_regular,
                  color: Colors.white,
                ),
                onPressed: _rotateRight,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setAspectRatio(1);
                },
                child: Text(
                  '1 : 1',
                  style:
                      CupidStyles.textButtonStyle.copyWith(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  setAspectRatio(3 / 4);
                },
                child: Text(
                  '3 : 4',
                  style:
                      CupidStyles.textButtonStyle.copyWith(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  setAspectRatio(9 / 16);
                },
                child: Text(
                  '9 : 16',
                  style:
                      CupidStyles.textButtonStyle.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  void setAspectRatio(double ratio) {
    controller.aspectRatio = ratio == -1 ? null : ratio;
    controller.crop = const Rect.fromLTRB(0, 0, 1, 1);
  }

  Future<void> _finished() async {
    if (loading) return;
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final nav = Navigator.of(context);
    ui.Image image = await controller.croppedBitmap();
    File croppedFile = await ImageHelpers.imageToFile(image: image);
    nav.pop(croppedFile);
  }
}
