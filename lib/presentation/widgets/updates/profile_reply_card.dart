import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/updates/update_card_footer.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileReplyCard extends StatelessWidget {
  final UpdateModel update;

  const ProfileReplyCard({super.key, required this.update});

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
          _buildContent(),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          UpdateCardFooter(update: update),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(FluentIcons.arrow_reply_24_regular,
            size: 16, color: CupidColors.cupidPurple),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            update.headerText, // "Replied to your profile"
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

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder grey box (as per user image)
        Container(
          width: 80,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: update.mediaUrl != null
                ? Image.network(
                    update.mediaUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error_outline),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[400],
                  ),
          ),
        ),
        const SizedBox(width: 12),
        // Reply text
        Expanded(
          child: Text(
            update.replyText ?? '',
            style: CupidStyles.normalTextStyle.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
