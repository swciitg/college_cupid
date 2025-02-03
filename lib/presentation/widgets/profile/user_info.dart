import 'dart:ui';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/icon_label_text.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfo extends ConsumerWidget {
  final UserProfile userProfile;

  const UserInfo({required this.userProfile, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Program program = userProfile.program!;
    String programAndYearDisplayString = "${program.displayString} '${userProfile.yearOfJoin}";
    final width = MediaQuery.sizeOf(context).width;
    final currentUser = ref.watch(userProvider).myProfile!;
    // Ensures mutual display
    final showSexualOrientation = currentUser.sexualOrientation?.display == true &&
        userProfile.sexualOrientation?.display == true;
    final showRelationshipGoal = currentUser.relationshipGoal?.display == true &&
        userProfile.relationshipGoal?.display == true;
    final visible = showSexualOrientation || showRelationshipGoal;
    return SizedBox(
      width: width - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                    ),
                    IconLabelText(text: userProfile.email, icon: FluentIcons.mail_32_filled),
                    IconLabelText(
                      text: programAndYearDisplayString,
                      icon: FluentIcons.hat_graduation_12_filled,
                    )
                  ],
                ),
              ),
              if (currentUser.email != userProfile.email) _buildMatchScore(currentUser)
            ],
          ),
          if (visible)
            Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0, top: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (showSexualOrientation)
                    _chip(userProfile.sexualOrientation!.type.displayString),
                  if (showRelationshipGoal) _chip(userProfile.relationshipGoal!.goal.displayString),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: CupidStyles.normalTextStyle.setColor(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchScore(UserProfile currentUser) {
    final matchScore = currentUser.getMatchScore(userProfile);
    if (matchScore == null) {
      return const SizedBox();
    }
    final myPreferredGender =
        currentUser.sexualOrientation!.type.preferredGender(currentUser.gender!);
    final otherGender = userProfile.gender!;
    if (myPreferredGender != null && myPreferredGender != otherGender) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  color: Colors.white,
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
