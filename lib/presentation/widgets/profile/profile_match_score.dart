import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileMatchScore extends StatelessWidget {
  const ProfileMatchScore({
    super.key,
    required this.matchScore,
  });

  final double matchScore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        height: 40,
        width: 40,
        child: Stack(
          children: [
            Positioned.fill(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: matchScore),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      UserProfile.getColorForMatchScore(value.toInt()),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Text(
                matchScore.toInt().toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}