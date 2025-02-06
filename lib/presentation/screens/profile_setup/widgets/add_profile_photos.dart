import 'dart:io';

import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'heart_state.dart';

class AddPhotos extends ConsumerWidget {
  const AddPhotos({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: _profilePic(0, ref, context),
              ),
              Positioned(
                top: 70,
                left: 0,
                child: _profilePic(1, ref, context),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: _profilePic(2, ref, context),
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
          Icons.close,
          const Color(0xFFFBA8AA),
          "Avoid group shots",
        )
      ],
    );
  }

  Widget _profilePic(int index, WidgetRef ref, BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final image = onboardingState.images?[index];
    const height = 230.0;
    const width = 230 * 0.75;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(onboardingControllerProvider.notifier).pickImage((val) {
          return Navigator.of(context).push<File>(
            MaterialPageRoute(
              builder: (context) => CropImageScreen(image: val),
            ),
          );
        }, index);
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
