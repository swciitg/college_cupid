import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/profile/user_info.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/globals.dart';
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
          builder: (context) => ProfileOptionsBottomSheet(userEmail: user.email),
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
            _profileImage(screenWidth - 20),
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

  Widget _profileImage(double width) {
    final blurHash = user.images[1].blurHash;
    return Hero(
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
            imageUrl: user.images[1].url,
            fit: BoxFit.cover,
            cacheManager: customCacheManager,
            placeholder: (context, url) {
              if (blurHash == null) return const CustomLoader();
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: width,
                  height: width,
                  child: BlurhashFfi(
                    hash: user.images.first.blurHash!,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
