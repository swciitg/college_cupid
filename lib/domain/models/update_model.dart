import 'package:college_cupid/domain/models/user_profile.dart';

enum UpdateType {
  voiceReply,
  textReply,
  match,
  confessionReply,
}

class UpdateModel {
  final String id;
  final UserProfile senderUser;
  final UpdateType type;
  final String headerText;
  final String? contentPayload;
  final String? mediaUrl;
  final DateTime timestamp;
  final UserProfile? matchedUser; // Only for match type

  UpdateModel({
    required this.id,
    required this.senderUser,
    required this.type,
    required this.headerText,
    required this.timestamp,
    this.contentPayload,
    this.mediaUrl,
    this.matchedUser,
  });
}
