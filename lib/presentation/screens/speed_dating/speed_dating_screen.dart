import 'dart:async';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';

import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:college_cupid/presentation/screens/speed_dating/animated_heart.dart';
// import 'waiting.dart';

import 'waiting_page.dart';

class SpeedDatingScreen extends StatefulWidget {
  const SpeedDatingScreen({super.key});

  @override
  State<SpeedDatingScreen> createState() => _SpeedDatingScreenState();
}

class _SpeedDatingScreenState extends State<SpeedDatingScreen> {
  // We remove repository listening from here because WaitingPage and ChatScreen handle it.
  // Actually, chat screen might pop back here?
  // User profile loading is still needed.

  bool _isLoading = true;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profileMap = await SharedPrefService.getMyProfile();
      if (profileMap.isNotEmpty) {
        setState(() {
          _userProfile = UserProfile.fromJson(profileMap);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() => _isLoading = false);
    }
  }

  void _joinPool() {
    if (_userProfile == null) return;

    // Navigate to WaitingPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingPage(userProfile: _userProfile!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: CupidColors.surfaceS0,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back,
                          size: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Speed Dating",
                      style: CupidTextStyles.brandTitle1),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "No profiles or photos—just a 3-minute chat with another student. If both like the vibe, profiles unlock.",
                    style: CupidTextStyles.body1,
                  ),
                ],
              ),
            ),
            const Divider(
              color: CupidColors.borderSecondary,
            ),
            Expanded(
              child: Stack(
                children: [
                  // Animated Hearts
                  const AnimatedHeart(startDelay: Duration(milliseconds: 0)),
                  const AnimatedHeart(startDelay: Duration(milliseconds: 1000)),
                  const AnimatedHeart(startDelay: Duration(milliseconds: 2000)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: CupidColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/dating_pref_doll.png',
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CupidButton(
                text: 'Start Chatting',
                trailingIcon: Icon(
                  Icons.arrow_forward,
                  color: CupidColors.whitePrimary,
                  size: 20,
                ),
                onTap: _joinPool,
                backgroundColor: CupidColors.primary,
                style: CupidTextStyles.label1.copyWith(
                  color: CupidColors.whitePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
