import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/profile/interests/display_only_interest_list.dart';
import 'package:college_cupid/presentation/widgets/profile/user_info.dart';
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
    final size = MediaQuery.sizeOf(context);
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
                        _buildProfileImage(context, size.width - 20),
                        Positioned(
                          bottom: 10,
                          left: 25,
                          child: UserInfo(userProfile: widget.userProfile),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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

  Hero _buildProfileImage(BuildContext context, double width) {
    final blurHash = widget.userProfile.images.first.blurHash;
    return Hero(
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
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.center,
                end: Alignment.bottomCenter),
          ),
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: widget.userProfile.images.first.url,
            placeholder: (context, url) {
              if (blurHash == null) {
                return const CustomLoader();
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: width,
                  height: width,
                  child: BlurhashFfi(
                    hash: widget.userProfile.images.first.blurHash!,
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
