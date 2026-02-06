import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/updates/update_card_footer.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfessionReplyCard extends StatelessWidget {
  final UpdateModel update;

  const ConfessionReplyCard({super.key, required this.update});

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
          const SizedBox(height: 2),
          _buildReply(),
          const SizedBox(height: 6),
          UpdateCardFooter(update: update),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(FluentIcons.arrow_reply_24_regular, size: 16, color: CupidColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            update.headerText, // "Replied to your confession"
            style: CupidTextStyles.body1
                .copyWith(color: CupidColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        Text(
          DateFormat('d MMM, yyyy').format(update.timestamp),
          style: CupidTextStyles.label3.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupidColors.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        update.replyTo ?? '',
        style: CupidTextStyles.body1.copyWith(fontSize: 13),
      ),
    );
  }

  Widget _buildReply() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Text(
        update.replyText ?? '',
        style: CupidTextStyles.body1.copyWith(fontSize: 13),
      ),
    );
  }
}
