import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class MatchUpdateCard extends StatelessWidget {
  final UpdateModel update;

  const MatchUpdateCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    if (update.matchedUser == null) {
      return const SizedBox.shrink(); // Safety check
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF3366), // Pinkish red
            Color(0xFFFF6B6B), // Lighter pink
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3366).withValues(alpha: 0.3),
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
              _buildAvatar(update.senderUser.images.first.url,
                  update.senderUser.images.first.blurHash),
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
            'You have a match with ${update.matchedUser!.name}!',
            style: CupidStyles.normalTextStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildSocialButton(
                      'Whatsapp', FluentIcons.chat_24_regular)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildSocialButton(
                      'Instagram', FluentIcons.camera_24_regular)),
            ],
          )
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

  Widget _buildSocialButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}
