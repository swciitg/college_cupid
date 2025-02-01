import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/interests/display_only_interest_list.dart';
import 'package:college_cupid/presentation/widgets/profile/user_info.dart';
import 'package:college_cupid/presentation/widgets/profile/user_profile_images.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class DisplayProfileInfo extends StatefulWidget {
  final UserProfile userProfile;

  const DisplayProfileInfo({required this.userProfile, super.key});

  @override
  State<DisplayProfileInfo> createState() => _DisplayProfileInfoState();
}

class _DisplayProfileInfoState extends State<DisplayProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  UserProfileImages(
                    user: widget.userProfile,
                    moveToProfile: false,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    child: UserInfo(userProfile: widget.userProfile),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CupidColors.backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About me',
                      style: TextStyle(fontSize: 18, color: CupidColors.greyColor),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      widget.userProfile.bio,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                          color: CupidColors.blackColor, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    if (widget.userProfile.interests.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Interested in",
                          style: TextStyle(color: CupidColors.greyColor, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    DisplayOnlyInterestList(
                      interests: widget.userProfile.interests,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
