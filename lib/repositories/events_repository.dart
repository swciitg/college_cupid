import 'package:college_cupid/domain/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EventsRepository {
  Future<List<EventModel>> fetchEvents();
}

class MockEventsRepository implements EventsRepository {
  @override
  Future<List<EventModel>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    // Mock data based on user request: "Speed dating is now Live"
    return [
      EventModel(
        id: '1',
        title: 'Speed dating is now Live',
        description:
            'Join the queue to get matched anonymously with other students!',
        actionText: 'Start Anonymous Chat',
        isLive: true,
      ),
    ];
  }
}

final eventsRepoProvider = Provider<EventsRepository>((ref) {
  return MockEventsRepository();
});
