import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use a Container with a soft background for the icon to make it look modern
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CupidColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person_rounded, // A slightly more modern icon
                  size: 80,
                  color: CupidColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Access Restricted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: CupidColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your account has been suspended due to a violation of our Community Guidelines. To maintain a safe environment for all students, we take these actions seriously.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54, // Or CupidColors.blackColor with lower opacity
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              // Added a professional Call to Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to support or appeal form
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupidColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Contact Support",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}