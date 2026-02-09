import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EventsRepository {
  Future<List<EventModel>> fetchEvents({bool filterViewed = false});
  Future<void> createEvent({
    required String name,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String eventType,
  });
  Future<void> updateEvent({
    required String id,
    required String name,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String eventType,
  });
  Future<void> deleteEvent(String id);
}

class EventsRepositoryImpl implements EventsRepository {
  final ApiRepository _apiRepository;

  EventsRepositoryImpl(this._apiRepository);

  @override
  Future<List<EventModel>> fetchEvents({bool filterViewed = false}) async {
    try {
      final response = await _apiRepository.dio.get('/events/');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> eventsJson = response.data['events'];
        final events = eventsJson.map((json) => EventModel.fromJson(json)).toList();

        if (filterViewed) {
          final viewedIds = await SharedPrefService.getViewedEventIds();
          return events.where((event) => !viewedIds.contains(event.id)).toList();
        }
        return events;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> createEvent({
    required String name,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String eventType,
  }) async {
    try {
      await _apiRepository.dio.post('/events/', data: {
        'name': name,
        'title': title,
        'description': description,
        'startTime': startTime,
        'endTime': endTime,
        'event_type': eventType,
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<void> updateEvent({
    required String id,
    required String name,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String eventType,
  }) async {
    try {
      await _apiRepository.dio.put('/events/$id', data: {
        'name': name,
        'title': title,
        'description': description,
        'startTime': startTime,
        'endTime': endTime,
        'event_type': eventType,
      });
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _apiRepository.dio.delete('/events/$id');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}

final eventsRepoProvider = Provider<EventsRepository>((ref) {
  final apiRepo = ref.read(apiRepositoryProvider);
  return EventsRepositoryImpl(apiRepo);
});

// Provider for Unseen Events (used by EventUpdateMessageCard)
final eventsFutureProvider = FutureProvider<List<EventModel>>((ref) {
  // Watch user provider to refresh events when user logs in/out
  ref.watch(userProvider);
  final repo = ref.watch(eventsRepoProvider);
  return repo.fetchEvents(filterViewed: true);
});
