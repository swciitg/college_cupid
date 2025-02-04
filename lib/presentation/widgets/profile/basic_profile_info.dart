import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/overlay_chip.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_match_score.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicProfileInfo extends ConsumerWidget {
  final double maxHeight;
  final double width;
  final UserProfile userProfile;
  const BasicProfileInfo({
    super.key,
    required this.maxHeight,
    required this.width,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider).myProfile!;
    Program program = userProfile.program!;
    final programString = program.displayString.toLowerCase();
    String programAndYearDisplayString =
        "$programString ${DateTime.now().year % 100 - userProfile.yearOfJoin!}";
    // Ensures mutual display
    final showRelationshipGoal =
        currentUser.relationshipGoal?.display == true &&
            userProfile.relationshipGoal?.display == true;
    final showSexualOrientation =
        currentUser.sexualOrientation?.display == true &&
            userProfile.sexualOrientation?.display == true;
    return SizedBox(
      height: maxHeight,
      width: width,
      child: Column(
        children: [
          Expanded(
            child: ProfileImage(
              height: maxHeight,
              width: width,
              index: 0,
              overlay: showRelationshipGoal
                  ? OverlayChip(
                      label: userProfile.relationshipGoal!.goal.displayString)
                  : null,
              url: userProfile.images.first.url,
              blurHash: userProfile.images.first.blurHash,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      overflow: TextOverflow.ellipsis,
                      style: CupidStyles.subHeadingTextStyle
                          .setFontWeight(FontWeight.bold),
                    ),
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: CupidColors.secondaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(
                              programAndYearDisplayString,
                              style: CupidStyles.normalTextStyle,
                            ),
                          ),
                        ),
                        if (showSexualOrientation) const SizedBox(width: 8),
                        if (showSexualOrientation)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: CupidColors.cupidYellow,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                userProfile
                                    .sexualOrientation!.type.displayString,
                                style: CupidStyles.normalTextStyle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (currentUser.email != userProfile.email)
                _buildMatchScore(currentUser),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMatchScore(UserProfile currentUser) {
    final matchScore = currentUser.getMatchScore(userProfile);
    if (matchScore == null) {
      return const SizedBox();
    }
    final myPreferredGender = currentUser.sexualOrientation!.type
        .preferredGender(currentUser.gender!);
    final otherGender = userProfile.gender!;
    if (myPreferredGender != null && myPreferredGender != otherGender) {
      return const SizedBox();
    }
    return ProfileMatchScore(matchScore: matchScore);
  }
}
