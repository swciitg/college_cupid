import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/updates/update_card_footer.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoiceNoteReplyCard extends StatelessWidget {
  final UpdateModel update;

  const VoiceNoteReplyCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
            update.headerText, // "Replied to your voice note"
            style: CupidTextStyles.body1
                .copyWith(color: CupidColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        Text(
          DateFormat('d MMM, yyyy').format(update.timestamp),
          style: CupidTextStyles.body1.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildContent() {
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
            decoration:
                const BoxDecoration(color: CupidColors.backgroundColor, shape: BoxShape.circle),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: CupidColors.primary,
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
                      color: CupidColors.primary.withValues(alpha: 0.6),
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
  }
}
