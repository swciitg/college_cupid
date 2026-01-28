import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/updates/match_update_card.dart';
import 'package:college_cupid/presentation/widgets/updates/confession_reply_card.dart';
import 'package:college_cupid/presentation/widgets/updates/voice_note_reply_card.dart';
import 'package:college_cupid/presentation/widgets/updates/profile_reply_card.dart';
import 'package:flutter/material.dart';

class UpdateItemBuilder extends StatelessWidget {
  final UpdateModel update;

  const UpdateItemBuilder({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    switch (update.type) {
      case UpdateType.match:
        return MatchUpdateCard(update: update);
      case UpdateType.voiceReply:
        return VoiceNoteReplyCard(update: update);
      case UpdateType.profileReply:
        return ProfileReplyCard(update: update);
      case UpdateType.textReply:
      case UpdateType.confessionReply:
        return ConfessionReplyCard(update: update);
    }
  }
}
