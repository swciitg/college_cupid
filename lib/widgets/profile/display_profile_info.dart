import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/profile/interests/display_only_interest_list.dart';
import 'package:college_cupid/widgets/profile/user_info.dart';
import 'package:flutter/material.dart';

import '../../shared/colors.dart';

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
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: 'profilePic',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                              bottom: Radius.zero,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              constraints: const BoxConstraints(
                                minHeight: 250,
                              ),
                              color: Colors.black,
                              foregroundDecoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black],
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: widget.userProfile.profilePicUrl,
                                cacheManager: customCacheManager,
                                progressIndicatorBuilder:
                                    (context, url, progress) => SizedBox(
                                  height: MediaQuery.of(context).size.width,
                                  child: const CustomLoader(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 25,
                          child: UserInfo(userProfile: widget.userProfile),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        color: CupidColors.backgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About me',
                            style: TextStyle(
                                fontSize: 18, color: CupidColors.grayColor),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.userProfile.bio,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                color: CupidColors.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          if (widget.userProfile.interests.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Interested in",
                                style: TextStyle(
                                    color: CupidColors.grayColor, fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          DisplayOnlyInterestList(
                            interests: widget.userProfile.interests,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
