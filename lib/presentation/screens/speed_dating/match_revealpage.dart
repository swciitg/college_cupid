import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/speed_dating/animated_heart.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter_plus/icons/jam.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';

class MatchRevealPage extends ConsumerStatefulWidget {
  final String? email;

  const MatchRevealPage({
    super.key,
    this.email,
  });

  @override
  ConsumerState<MatchRevealPage> createState() => _MatchRevealPageState();
}

class _MatchRevealPageState extends ConsumerState<MatchRevealPage> {
  bool _isLoading = false;
  UserProfile? _fetchedProfile;
  late final bool matched;

  @override
  void initState() {
    matched = widget.email != null;
    super.initState();
    if (widget.email != null) {
      _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(userProfileRepoProvider);
      final profileMap = await repo.getUserProfile(widget.email!);

      if (profileMap != null) {
        if (mounted) {
          setState(() {
            _fetchedProfile = UserProfile.fromJson(profileMap);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/chatbg.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Stack(
              children: [
                const AnimatedHeart(
                  startDelay: Duration(milliseconds: 0),
                  begin: 0.0,
                  end: 0.9,
                ),
                const AnimatedHeart(
                  startDelay: Duration(milliseconds: 1000),
                  begin: 0.0,
                  end: 0.9,
                ),
                const AnimatedHeart(
                  startDelay: Duration(milliseconds: 2000),
                  begin: 0.0,
                  end: 0.9,
                ),
                const AnimatedHeart(startDelay: Duration(milliseconds: 3000)),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              matched ? size.height * 0.4 : size.height * 0.3),
                      child: Image.asset(
                        "assets/images/doll_wo_hands.png",
                        fit: BoxFit.cover,
                        width: size.width * 0.35,
                      ),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: Stack(
                      children: [
                        _content(context),
                        Transform.translate(
                          offset: Offset(0, -(size.height * 0.02)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/hands.png",
                                fit: BoxFit.cover,
                                width: size.width * 0.35,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _content(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.email != null
                      ? "It's a match!"
                      : "Conversation ended!",
                  style: CupidTextStyles.title2
                      .copyWith(color: CupidColors.greyPrimary),
                ),
                widget.email == null
                    ? Text("No reveal this time. On to the next?",
                        style: CupidTextStyles.body1
                            .copyWith(color: CupidColors.greySecondary))
                    : Align(
                        alignment: Alignment.center,
                        child: Text(
                          _fetchedProfile!.name,
                          textAlign: TextAlign.center,
                          style: CupidTextStyles.body1.copyWith(
                              color: CupidColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),

                // if (widget.email != null &&
                //     _fetchedProfile != null) ...[
                //   Text(
                //     _fetchedProfile!.name ,
                //     style: CupidTextStyles.label3,
                //   ),
                //   Text(
                //     _fetchedProfile!.program?.displayString ?? "",
                //     style: CupidTextStyles.label3
                //         .copyWith(color: CupidColors.greySecondary),
                //   ),
                // ],
              ],
            ),
          ),
          const Divider(
            color: CupidColors.borderSecondary,
            thickness: 1,
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.email != null && _fetchedProfile != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // WhatsApp Button
                      if (_fetchedProfile!.phnNumber.isNotEmpty)
                        Expanded(
                          child: CommonWidgets.button(
                            icon: const Iconify(Jam.whatsapp,
                                color: Colors.green),
                            bgColor: CupidColors.whitePrimary,
                            title: "WhatsApp",
                            textStyle: CupidTextStyles.body1
                                .copyWith(color: Colors.green),
                            onTap: () {
                              _launchUrl(
                                  "https://wa.me/${_fetchedProfile!.phnNumber}");
                            },
                          ),
                        ),
                      if (_fetchedProfile!.phnNumber.isNotEmpty &&
                          _fetchedProfile!.insta.isNotEmpty)
                        const SizedBox(width: 10),
                      // Instagram Button
                      if (_fetchedProfile!.insta.isNotEmpty)
                        Expanded(
                          child: CommonWidgets.button(
                            title: "Instagram",
                            textStyle: CupidTextStyles.body1
                                .copyWith(color: CupidColors.primary),
                            icon: const Iconify(Jam.instagram,
                                color: CupidColors.primary),
                            bgColor: CupidColors.whitePrimary,
                            onTap: () {
                              _launchUrl(
                                  "https://instagram.com/${_fetchedProfile!.insta}");
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (!_isLoading)
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                child: CommonWidgets.button(
                    title: widget.email != null ? "View Profile" : "Try Again",
                    onTap: () {
                      if (widget.email != null) {
                        if (_fetchedProfile != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                userProfile: _fetchedProfile!,
                                isMine: false,
                              ),
                            ),
                          );
                        } else {
                          // Fallback if profile failed to fetch but we have email
                          // Maybe retry or just go back
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      } else {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    })),
        ],
      ),
    );
  }
}
