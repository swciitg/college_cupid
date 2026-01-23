import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StandardUpdateCard extends StatelessWidget {
  final UpdateModel update;

  const StandardUpdateCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildContent(context),
          const SizedBox(height: 12),
          const Divider(
              height: 1, color: Color(0xFFEEEEEE)), // Light grey divider
          const SizedBox(height: 12),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    IconData icon;
    Color iconColor;

    switch (update.type) {
      case UpdateType.voiceReply:
      case UpdateType.textReply:
      case UpdateType.confessionReply:
        icon = FluentIcons.arrow_reply_24_regular;
        iconColor = CupidColors.cupidPurple;
        break;

      default:
        icon = FluentIcons.alert_24_regular;
        iconColor = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            update.headerText, // e.g., "Replied to your voice note"
            style: CupidStyles.normalTextStyle.copyWith(
                color: CupidColors.cupidPurple,
                fontWeight: FontWeight.w600,
                fontSize: 12),
          ),
        ),
        Text(
          DateFormat('d MMM, yyyy').format(update.timestamp),
          style: CupidStyles.lightTextStyle.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (update.type == UpdateType.voiceReply && update.mediaUrl != null) {
      // TODO: Replace with actual Waveform widget
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupidColors.offWhiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFFE0E7FF), // Light purple/blue
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: CupidColors.cupidPurple,
              ),
            ),
            const SizedBox(width: 8),
            // Mock waveform
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(30, (index) {
                    return Container(
                      width: 3,
                      height: 10 + (index % 5) * 6.0,
                      decoration: BoxDecoration(
                        color: CupidColors.cupidPurple.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupidColors.offWhiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          update.contentPayload ?? '',
          style: CupidStyles.normalTextStyle.copyWith(fontSize: 13),
        ),
      );
    }
  }

  Widget _buildFooter() {
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: ProfileImage(
            url: update.senderUser.images.first.url,
            blurHash: update.senderUser.images.first.blurHash,
            width: 32,
            height: 32,
            index: 0,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            update.senderUser.name,
            style: CupidStyles.normalTextStyle
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                'Smash',
                style: CupidStyles.normalTextStyle
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              const Icon(
                FluentIcons.heart_24_regular,
                size: 14,
              )
            ],
          ),
        )
      ],
    );
  }
}
