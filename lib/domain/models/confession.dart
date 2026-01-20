// UserProfile import removed

enum ConfessionCategory {
  all,
  spottedInCampus,
  gossip,
  byYou,
}

extension ConfessionCategoryExtension on ConfessionCategory {
  String get displayName {
    switch (this) {
      case ConfessionCategory.spottedInCampus:
        return 'Spotted in Campus';
      case ConfessionCategory.gossip:
        return 'Gossip';
      case ConfessionCategory.byYou:
        return 'By You';
      case ConfessionCategory.all:
        return 'All';
    }
  }
}

class Reaction {
  final String reaction;
  final String user; // encryptedEmail or ObjectId

  Reaction({
    required this.reaction,
    required this.user,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      reaction: json['reaction'] ?? '',
      user: json['user']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reaction': reaction,
      'user': user,
    };
  }
}

class Reply {
  final String id;
  final String confessionId;
  final String userId;
  final String content;
  final DateTime timestamp;
  final String? profilePicUrl;

  Reply({
    required this.id,
    required this.confessionId,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.profilePicUrl,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] ?? '',
      confessionId: json['confessionId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      profilePicUrl: json['profilePicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'confessionId': confessionId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'profilePicUrl': profilePicUrl,
    };
  }
}

class Confession {
  final String id;
  final String encryptedEmail; // Backend: encryptedEmail
  final String text; // Backend: text
  final ConfessionCategory typeOfConfession; // Backend: typeOfConfession
  final DateTime createdAt; // Backend: timestamps -> createdAt
  final List<Reaction> reactions;
  final String song; // Backend: song (url string)
  final List<Reply> replies;

  Confession({
    required this.id,
    required this.encryptedEmail,
    required this.text,
    required this.typeOfConfession,
    required this.createdAt,
    this.reactions = const [],
    this.song = '',
    this.replies = const [],
  });

  factory Confession.fromJson(Map<String, dynamic> json) {
    return Confession(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      encryptedEmail: json['encryptedEmail'] ?? '',
      text: json['text'] ?? '',
      typeOfConfession: ConfessionCategory.values.firstWhere(
        (e) => e.name == json['typeOfConfession'],
        orElse: () => ConfessionCategory.values.firstWhere(
            (e) =>
                e.name == json['category'], 
            orElse: () => ConfessionCategory.gossip),
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now()),
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => Reaction.fromJson(e))
              .toList() ??
          [],
      song: json['song'] ?? '',
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Reply.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encryptedEmail': encryptedEmail,
      'text': text,
      'typeOfConfession': typeOfConfession.name,
      'createdAt': createdAt.toIso8601String(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
      'song': song,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  Confession copyWith({
    String? id,
    String? encryptedEmail,
    String? text,
    ConfessionCategory? typeOfConfession,
    DateTime? createdAt,
    List<Reaction>? reactions,
    String? song,
    List<Reply>? replies,
  }) {
    return Confession(
      id: id ?? this.id,
      encryptedEmail: encryptedEmail ?? this.encryptedEmail,
      text: text ?? this.text,
      typeOfConfession: typeOfConfession ?? this.typeOfConfession,
      createdAt: createdAt ?? this.createdAt,
      reactions: reactions ?? this.reactions,
      song: song ?? this.song,
      replies: replies ?? this.replies,
    );
  }
}
