import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile user;

  const ProfileCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                      isMine: false,
                      userProfile: user,
                    )));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0.05 * screenWidth, 10, 0.05 * screenWidth, 20),
        width: 0.95 * screenWidth,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: CupidColors.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(30, 5, 10, 0.3),
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          image: DecorationImage(
              image:
                  CachedNetworkImageProvider(user.profilePicUrl, cacheManager: customCacheManager),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
            gradient: LinearGradient(
                stops: [0, 0.6, 1],
                colors: [Colors.transparent, Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: SizedBox(
                // width: 120,
                child: Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
