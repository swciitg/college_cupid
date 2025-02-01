import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/icon_label_text.dart';
import 'package:college_cupid/shared/enums.dart';
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
    return SizedBox(
      width: width - 32,
      child: Row(
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
    );
  }

  Widget _buildMatchScore(UserProfile currentUser) {
    final matchScore = currentUser.getMatchScore(userProfile);
    if (matchScore == null) {
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
