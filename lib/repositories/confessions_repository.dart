import 'package:college_cupid/domain/models/confession.dart';
// ApiRepository import removed

import 'package:flutter_riverpod/flutter_riverpod.dart';

final confessionsRepoProvider =
    Provider<ConfessionsRepository>((ref) => MockConfessionsRepository());

abstract class ConfessionsRepository {
  Future<List<Confession>> getConfessions({ConfessionCategory? category});
  Future<void> postConfession(String content, ConfessionCategory category,
      {SongAttachment? song});
  Future<void> reactToConfession(String id, String reaction);
  Future<void> replyToConfession(String confessionId, String content);
}

class MockConfessionsRepository implements ConfessionsRepository {
  @override
  Future<List<Confession>> getConfessions(
      {ConfessionCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network

    List<Confession> allConfessions = [
      Confession(
        id: '1',
        userId: 'user1',
        content:
            'I saw someone wearing a really cool Spider-Man hoodie at the library today. If you are reading this, where did you get it?',
        category: ConfessionCategory.spottedInCampus,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        reactions: ['❤️', '😂', '🔥'],
        songAttachment: SongAttachment(
          songName: 'Sunflower',
          artistName: 'Post Malone, Swae Lee',
        ),
      ),
      Confession(
        id: '2',
        userId: 'user2',
        content:
            'Why is the coffee machine always broken when I have an 8 AM class? This is a conspiracy.',
        category: ConfessionCategory.gossip,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        reactions: ['😢', '😡'],
        replies: [
          Reply(
            id: 'r1',
            confessionId: '2',
            userId: 'user3',
            content: 'Honestly same.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          )
        ],
      ),
      Confession(
        id: '3',
        userId: 'user3',
        content:
            'To the girl who shared her umbrella with me yesterday near the Biotech department, thank you! You made my day.',
        category: ConfessionCategory.spottedInCampus,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        reactions: ['❤️', '❤️', '❤️', '👍'],
      ),
      Confession(
        id: '4',
        userId: 'me',
        content:
            'I have a massive crush on my lab partner but I cant say anything because I don\'t want to make things awkward.',
        category: ConfessionCategory.byYou,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        reactions: ['😂'],
      ),
    ];

    if (category == null || category == ConfessionCategory.all) {
      return allConfessions;
    } else if (category == ConfessionCategory.byYou) {
      return allConfessions.where((c) => c.userId == 'me').toList();
    } else {
      return allConfessions.where((c) => c.category == category).toList();
    }
  }

  @override
  Future<void> postConfession(String content, ConfessionCategory category,
      {SongAttachment? song}) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would send data to server
  }

  @override
  Future<void> reactToConfession(String id, String reaction) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> replyToConfession(String confessionId, String content) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
