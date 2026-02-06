import 'dart:io';

import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/crop_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPhotos extends ConsumerWidget {
  const AddPhotos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    final images = onboardingState.images ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(images.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPhotoSlot(context, ref, index, images[index]),
          );
        }),

        // Add Photo Slot Button
        GestureDetector(
          onTap: () {
            onboardingController.addPhotoSlot();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Photo Slot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.add_circle, color: Colors.black87, size: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 100), // Bottom padding for nav buttons
      ],
    );
  }

  Widget _buildPhotoSlot(BuildContext context, WidgetRef ref, int index, File? image) {
    // Aspect ratio 1:1 or 4:5? Design looks like square or slightly tall.
    // Using simple container with height.
    const height = 350.0;

    return GestureDetector(
      onTap: () {
        _pickImage(context, ref, index);
      },
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.file(image, fit: BoxFit.cover)
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text("Image Preview", style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            )
                          ]),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Add Image",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.add_circle, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              if (image != null)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            )
                          ]),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Replace Image",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.refresh, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, WidgetRef ref, int index) {
    ref.read(onboardingControllerProvider.notifier).pickImage((val) {
      return Navigator.of(context).push<File>(
        MaterialPageRoute(
          builder: (context) => CropImageScreen(image: val),
        ),
      );
    }, index);
  }
}
