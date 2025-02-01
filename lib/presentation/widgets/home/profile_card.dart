import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/profile/user_info.dart';
import 'package:college_cupid/presentation/widgets/profile/user_profile_images.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile user;

  const ProfileCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          return GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                elevation: 0,
                builder: (context) => ProfileOptionsBottomSheet(userEmail: user.email),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  UserProfileImages(
                    user: user,
                    moveToProfile: true,
                    height: maxHeight,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      height: maxHeight - 16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfo(userProfile: user),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
