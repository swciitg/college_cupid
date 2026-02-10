import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/functions/launchers.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/jam.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MatchUpdateCard extends ConsumerWidget {
  final bool blindMatch;
  final UpdateModel update;

  const MatchUpdateCard(
      {super.key, required this.update, this.blindMatch = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (update.matchedUser == null) {
      return const SizedBox.shrink(); // Hide card if user not found
    }

    // Get current user's profile
    final myProfile = ref.watch(userProvider).myProfile;

    // If current user profile not available, don't show the card
    if (myProfile == null || myProfile.images.isEmpty) {
      return const SizedBox.shrink();
    }

    final whatsappURL = "https://wa.me/${update.matchedUser!.phnNumber}";
    final instagramURL = "https://instagram.com/${update.matchedUser!.insta}";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF3366), // Pinkish red
            Color(0xFFFF6B6B), // Lighter pink
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: CupidColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAvatar(
                  myProfile.images.first.url, myProfile.images.first.blurHash),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(FluentIcons.heart_24_filled,
                    color: Colors.white, size: 28),
              ),
              _buildAvatar(update.matchedUser!.images.first.url,
                  update.matchedUser!.images.first.blurHash),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${blindMatch ? "Blind Match: " : ""}You have a match with ${update.matchedUser!.name}!',
            style: CupidTextStyles.title2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CommonWidgets.button(
                  height: 40,
                  icon: const Iconify(Jam.whatsapp, color: Colors.green),
                  bgColor: CupidColors.whitePrimary.withAlpha(200),
                  title: update.matchedUser!.phnNumber,
                  textStyle:
                      CupidTextStyles.body1.copyWith(color: Colors.green),
                  onTap: () async {
                    final uri = Uri.parse(whatsappURL);
                    if (!await launchUrl(uri,
                        mode: LaunchMode.externalApplication)) {
                      debugPrint('Could not launch $whatsappURL');
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CommonWidgets.button(
                  height: 40,
                  title: update.matchedUser!.insta,
                  textStyle: CupidTextStyles.body1
                      .copyWith(color: CupidColors.primary),
                  icon:
                      const Iconify(Jam.instagram, color: CupidColors.primary),
                  bgColor: CupidColors.whitePrimary.withAlpha(200),
                  onTap: () async {
                    final uri = Uri.parse(instagramURL);
                    if (!await launchUrl(uri,
                        mode: LaunchMode.externalApplication)) {
                      debugPrint('Could not launch $instagramURL');
                    }
                  },
                ),
              ),
            ],
          ),
          // )
        ],
      ),
    );
  }

  Widget _buildAvatar(String url, String? blurHash) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: SizedBox(
          width: 60,
          height: 60,
          child: ProfileImage(
            url: url,
            blurHash: blurHash,
            width: 60,
            height: 60,
            index: 0,
          ),
        ),
      ),
    );
  }
}
