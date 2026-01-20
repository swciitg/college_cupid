import 'package:college_cupid/domain/models/confession.dart';
// ApiRepository import removed

import 'package:flutter_riverpod/flutter_riverpod.dart';

final confessionsRepoProvider =
    Provider<ConfessionsRepository>((ref) => MockConfessionsRepository());

abstract class ConfessionsRepository {
  Future<List<Confession>> getConfessions({ConfessionCategory? category});
  Future<void> postConfession(String text, ConfessionCategory category,
      {String? song});
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
        encryptedEmail: 'user1',
        text:
            'I saw someone wearing a really cool Spider-Man hoodie at the library today. If you are reading this, where did you get it?',
        typeOfConfession: ConfessionCategory.spottedInCampus,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        reactions: [
          Reaction(reaction: '❤️', user: 'user1'),
          Reaction(reaction: '😂', user: 'user2'),
          Reaction(reaction: '🔥', user: 'user3')
        ],
        song: 'Song Data Here', // Simplified string
      ),
      Confession(
        id: '2',
        encryptedEmail: 'user2',
        text:
            'Why is the coffee machine always broken when I have an 8 AM class? This is a conspiracy.',
        typeOfConfession: ConfessionCategory.gossip,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        reactions: [
          Reaction(reaction: '😢', user: 'user4'),
          Reaction(reaction: '😡', user: 'user5')
        ],
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
        encryptedEmail: 'user3',
        text:
            'To the girl who shared her umbrella with me yesterday near the Biotech department, thank you! You made my day.',
        typeOfConfession: ConfessionCategory.spottedInCampus,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        reactions: [
          Reaction(reaction: '❤️', user: 'user6'),
          Reaction(reaction: '❤️', user: 'user7'),
          Reaction(reaction: '❤️', user: 'user8'),
          Reaction(reaction: '👍', user: 'user9')
        ],
      ),
      Confession(
        id: '4',
        encryptedEmail: 'me',
        text:
            'I have a massive crush on my lab partner but I cant say anything because I don\'t want to make things awkward.',
        typeOfConfession: ConfessionCategory.byYou,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        reactions: [Reaction(reaction: '😂', user: 'user10')],
      ),
    ];

    if (category == null || category == ConfessionCategory.all) {
      return allConfessions;
    } else if (category == ConfessionCategory.byYou) {
      return allConfessions.where((c) => c.encryptedEmail == 'me').toList();
    } else {
      return allConfessions
          .where((c) => c.typeOfConfession == category)
          .toList();
    }
  }

  @override
  Future<void> postConfession(String text, ConfessionCategory category,
      {String? song}) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implementation needed
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
