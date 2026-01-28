import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_match_score.dart';

import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_attribute.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:college_cupid/presentation/widgets/global/like_button.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';

class BasicProfileInfo extends ConsumerWidget {
  final double maxHeight;
  final double width;
  final UserProfile userProfile;
  final bool backButton;
  final bool isMine;
  const BasicProfileInfo({
    super.key,
    required this.maxHeight,
    required this.width,
    required this.userProfile,
    this.backButton = false,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep currentUser for other checks if needed, or remove if isMine covers it.
    // However, isMine is explicitly passed now.
    final currentUser = ref.watch(userProvider).myProfile!;
    Program program = userProfile.program!;

    final showRelationshipGoal = userProfile.relationshipGoal?.display == true;
    final showSexualOrientation =
        userProfile.sexualOrientation?.display == true;
    return SizedBox(
      height: maxHeight,
      width: width,
      child: Column(
        children: [
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            userProfile.name,
                            overflow: TextOverflow.ellipsis,
                            style: CupidStyles.subHeadingTextStyle
                                .setFontWeight(FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 28),
                        if (isMine)
                          GestureDetector(
                            onTap: () {
                              // context.pushNamed(AppRoutes.editProfile.name);
                              //TODO: Change to edit profile route when ready
                              goRouter.goNamed(AppRoutes.profileSetup.name);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: CupidStyles.normalTextStyle.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(FluentIcons.edit_16_regular,
                                      size: 14),
                                ],
                              ),
                            ),
                          )
                        else if (!isMine)
                          _buildMatchScore(currentUser)
                      ],
                    ),
                    //Show Gender
                    if (userProfile.gender != null)
                      Text(
                        userProfile.gender!.displayString,
                        style: CupidStyles.normalTextStyle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (showSexualOrientation || isMine) ...[
                            ProfileAttribute(
                              icon: FluentIcons.person_24_regular,
                              text: userProfile
                                      .sexualOrientation?.type.displayString ??
                                  '',
                            ),
                            const SizedBox(width: 12),
                          ],
                          ProfileAttribute(
                            icon: FluentIcons.hat_graduation_24_regular,
                            text:
                                '${program.displayString} ${userProfile.yearOfJoin}',
                          ),
                          if (showRelationshipGoal || isMine) ...[
                            const SizedBox(width: 12),
                            ProfileAttribute(
                              icon: FluentIcons.handshake_24_regular,
                              text: userProfile
                                      .relationshipGoal?.goal.displayString ??
                                  '',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Stack(
              children: [
                ProfileImage(
                  height: maxHeight,
                  width: width,
                  index: 0,
                  overlay: null,
                  url: userProfile.images.first.url,
                  blurHash: userProfile.images.first.blurHash,
                  backButton: backButton,
                ),
                if (!isMine)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReplyButton(onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ReplyBottomSheet(
                              title: 'Reply to Profile',
                              onSend: (message) {
                                // TODO: Implement reply logic for profile
                              },
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
                        LikeButton(onTap: () {
                          // TODO: Implement like logic
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
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
