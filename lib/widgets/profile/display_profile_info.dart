import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile/edit_profile.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/profile/icon_label_text.dart';
import 'package:college_cupid/widgets/profile/interests/display_only_interest_list.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
    Program myProgram = Program.values
        .firstWhere((p) => p.databaseString == widget.userProfile.program);
    String programAndYearDisplayString =
        "${myProgram.displayString} '${widget.userProfile.yearOfJoin}";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          Container(
                            foregroundDecoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.black],
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.userProfile.profilePicUrl,
                              cacheManager: customCacheManager,
                              progressIndicatorBuilder:
                                  (context, url, progress) => SizedBox(
                                height: MediaQuery.of(context).size.width,
                                child: const CustomLoader(),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    widget.userProfile.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                ),
                                IconLabelText(
                                    text: widget.userProfile.email,
                                    icon: FluentIcons.mail_32_filled),
                                IconLabelText(
                                    text: programAndYearDisplayString,
                                    icon: FluentIcons.hat_graduation_12_filled)
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
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
                              const Text(
                                "Interested in",
                                style: TextStyle(
                                    color: CupidColors.grayColor, fontSize: 18),
                                textAlign: TextAlign.left,
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
      ),
    );
  }
}
