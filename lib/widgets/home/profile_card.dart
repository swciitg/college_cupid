import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/widgets/profile/user_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          builder: (context) =>
              ProfileOptionsBottomSheet(userEmail: user.email),
        );
      },
      onTap: () {
        FocusScope.of(context).unfocus();
        context.pushNamed(AppRoutes.userProfileScreen.name,
            extra: {'isMine': false, 'userProfile': user});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'profilePic',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: user.profilePicUrl,
                    fit: BoxFit.cover,
                    cacheManager: customCacheManager,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Container(
                      color: CupidColors.backgroundColor,
                      child: const CustomLoader(),
                    ),
                  ),
                ),
              ),
            ),
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
