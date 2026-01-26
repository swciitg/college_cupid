import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/updates_repository.dart';
import 'package:college_cupid/shared/enums.dart';

class MockUpdatesRepository implements UpdatesRepository {
  @override
  Future<List<UpdateModel>> fetchUpdates({int page = 0, String? filter}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final dummyUser = UserProfile(
      name: 'Ayush Bahuguna',
      gender: Gender.male,
      email: 'ayush@example.com',
      images: [
        ImageModel(
            url:
                'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
            blurHash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I')
      ],
      interests: ['Coding', 'Music'],
      program: Program.bTech,
    );

    final kartikUser = UserProfile(
      name: 'Kartik',
      gender: Gender.male,
      email: 'kartik@example.com',
      images: [
        ImageModel(
            url:
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
            blurHash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I')
      ],
      interests: ['Gym', 'Travel'],
      program: Program.bTech,
    );

    final allUpdates = [
      UpdateModel(
        id: '1',
        senderUser: dummyUser,
        type: UpdateType.voiceReply,
        headerText: 'Replied to your voice note',
        mediaUrl: 'https://example.com/voice.mp3', // Mock URL
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        contentPayload:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      ),
      UpdateModel(
        id: '2',
        senderUser: dummyUser,
        type: UpdateType.textReply,
        headerText: 'Replied to your answer',
        contentPayload:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      UpdateModel(
        id: '3',
        senderUser: dummyUser,
        type: UpdateType.match,
        headerText: 'You have a match!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        matchedUser: kartikUser,
      ),
      UpdateModel(
        id: '4',
        senderUser: dummyUser,
        type: UpdateType.confessionReply,
        headerText: 'Replied to your confession',
        contentPayload:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UpdateModel(
        id: '5',
        senderUser: dummyUser,
        type: UpdateType.voiceReply,
        headerText: 'Replied to your voice note',
        mediaUrl: 'https://example.com/voice.mp3',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        contentPayload:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      ),
    ];

    if (filter != null && filter != 'All') {
      if (filter == 'Profile') {
        return allUpdates
            .where((u) =>
                u.type == UpdateType.voiceReply ||
                u.type == UpdateType.textReply)
            .toList();
      } else if (filter == 'Confession') {
        return allUpdates
            .where((u) => u.type == UpdateType.confessionReply)
            .toList();
      } else if (filter == 'Match') {
        return allUpdates.where((u) => u.type == UpdateType.match).toList();
      }
    }

    return allUpdates;
  }
}
