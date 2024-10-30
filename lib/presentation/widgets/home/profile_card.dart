import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/profile/interests/display_only_interest_list.dart';
import 'package:college_cupid/presentation/widgets/profile/user_info.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:screenWidth * 0.04),
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            height: 514,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
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
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              height: 47,
                              width: 47,
                              decoration: BoxDecoration(
                                color: CupidColors.semiGlasswhite,
                                borderRadius: BorderRadius.circular(47 / 2),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/back_icon.svg",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                color: CupidColors.semiGlasswhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'short term open for long',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: CupidColors.textColorBlack,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                //overflow:TextOverflow.visible,
                              ),
                              Row(
                                children: [
                                  _buildChip(user.program.toLowerCase(), CupidColors.cupidBlue),
                                  const SizedBox(width: 10),
                                  _buildChip(user.gender.toLowerCase(), CupidColors.cupidYellow),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 15, bottom: 15),
                        //   child: _buildPercentageIndicator(80),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:screenWidth * 0.04),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CupidColors.glassWhite,
                        borderRadius: const BorderRadius.all(Radius.circular(50),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "i’ve always wanted to learn how to ",
                              style: TextStyle(
                                color: CupidColors.textColorBlack,
                                fontSize: 17,
                                fontWeight: FontWeight.w500
                              ),
                            ),SizedBox(height: 10),
                            Text(
                              "play guitar—it's expressive, freeing, and perfect for campfire sing-alongs with friends.",
                              style: TextStyle(
                                color: CupidColors.textColorBlack,
                                fontSize: 17,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:25.0),
                    child: DisplayOnlyInterestList(
                      interests: user.interests,
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircleCHip(Icons.close_rounded,const Color(0xFFFCD3D5)),
                        const SizedBox(width: 25,),
                        _buildCircleCHip(Icons.menu_rounded,const Color(0xFFDBEBFC)),
                        const SizedBox(width: 25,),
                        _buildCircleCHip(Icons.favorite,const Color(0xFFBDF5D4)),

                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


_buildChip(String label,Color color){
  return Chip(
    label: Text(label),
    backgroundColor: color,
    labelStyle: const TextStyle(color: CupidColors.textColorBlack,fontSize: 14),
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
    ),
  );
}

_buildCircleCHip(IconData icon,Color color){
  return InkWell(
    onTap: (){},
    child: Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        border: Border.all(
          color: CupidColors.glassWhite,
          width: 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(child: Icon(icon,color: CupidColors.glassWhite,size: 30,),),
    ),
  );
}