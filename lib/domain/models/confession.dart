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

class SongAttachment {
  final String songName;
  final String artistName;
  final String albumArtUrl; // Optional for UI
  final String previewUrl; // Optional for playback

  SongAttachment({
    required this.songName,
    required this.artistName,
    this.albumArtUrl = '',
    this.previewUrl = '',
  });

  factory SongAttachment.fromJson(Map<String, dynamic> json) {
    return SongAttachment(
      songName: json['songName'] ?? '',
      artistName: json['artistName'] ?? '',
      albumArtUrl: json['albumArtUrl'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songName': songName,
      'artistName': artistName,
      'albumArtUrl': albumArtUrl,
      'previewUrl': previewUrl,
    };
  }
}

class Reply {
  final String id;
  final String confessionId;
  final String userId; // Or author name if anonymous
  final String content;
  final DateTime timestamp;
  final String? profilePicUrl; // For UI

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
      timestamp: DateTime.parse(json['timestamp']),
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
  final String userId;
  final String content;
  final ConfessionCategory category;
  final DateTime timestamp;
  final List<String> reactions;
  final SongAttachment? songAttachment;
  final List<Reply> replies;

  Confession({
    required this.id,
    required this.userId,
    required this.content,
    required this.category,
    required this.timestamp,
    this.reactions = const [],
    this.songAttachment,
    this.replies = const [],
  });

  factory Confession.fromJson(Map<String, dynamic> json) {
    return Confession(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      category: ConfessionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ConfessionCategory.gossip,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      songAttachment: json['songAttachment'] != null
          ? SongAttachment.fromJson(json['songAttachment'])
          : null,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Reply.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'category': category.name,
      'timestamp': timestamp.toIso8601String(),
      'reactions': reactions,
      'songAttachment': songAttachment?.toJson(),
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  Confession copyWith({
    String? id,
    String? userId,
    String? content,
    ConfessionCategory? category,
    DateTime? timestamp,
    List<String>? reactions,
    SongAttachment? songAttachment,
    List<Reply>? replies,
  }) {
    return Confession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      reactions: reactions ?? this.reactions,
      songAttachment: songAttachment ?? this.songAttachment,
      replies: replies ?? this.replies,
    );
  }
}
