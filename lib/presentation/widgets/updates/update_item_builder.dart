import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/updates/match_update_card.dart';
import 'package:college_cupid/presentation/widgets/updates/standard_update_card.dart';
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
      case UpdateType.textReply:
      case UpdateType.confessionReply:
        return StandardUpdateCard(update: update);
    }
  }
}
