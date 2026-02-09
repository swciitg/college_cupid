import 'package:college_cupid/domain/models/user_profile.dart';

enum UpdateType {
  voiceReply,
  textReply,
  match,
  confessionReply,
  profileReply,
  blindDateReply,
}

class UpdateModel {
  final String id;
  final UserProfile senderUser;
  final UpdateType type;
  final String headerText;
  final String? replyText;
  final String?
      replyTo; // Content that was replied to(valid for confession and text answers)
  final String? mediaUrl; //Voice notes and photo urls will be stored here(valid for voice and profile replies)
  final DateTime timestamp;
  final UserProfile? matchedUser; // Only for match type

  UpdateModel({
    required this.id,
    required this.senderUser,
    required this.type,
    required this.headerText,
    required this.timestamp,
    this.replyText,
    this.replyTo,
    this.mediaUrl,
    this.matchedUser,
  });
}
