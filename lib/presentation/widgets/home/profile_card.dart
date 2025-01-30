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
    final double screenWidth = MediaQuery.of(context).size.width;
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Stack(
          children: [
            UserProfileImages(user: user, moveToProfile: true),
            Positioned(
              bottom: 15,
              left: 25,
              child: UserInfo(userProfile: user),
            ),
          ],
        ),
      ),
    );
  }
}
