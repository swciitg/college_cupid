import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EventsRepository {
  Future<List<EventModel>> fetchEvents({bool filterViewed = false});
}

class EventsRepositoryImpl implements EventsRepository {
  final ApiRepository _apiRepository;
  final StorageRepository _storageRepository;

  EventsRepositoryImpl(this._apiRepository, this._storageRepository);

  @override
  Future<List<EventModel>> fetchEvents({bool filterViewed = false}) async {
    try {
      final response = await _apiRepository.dio.get('/events/');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> eventsJson = response.data['events'];
        final events =
            eventsJson.map((json) => EventModel.fromJson(json)).toList();

        if (filterViewed) {
          final viewedIds = await _storageRepository.getViewedEventIds();
          return events
              .where((event) => !viewedIds.contains(event.id))
              .toList();
        }
        return events;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

final eventsRepoProvider = Provider<EventsRepository>((ref) {
  final apiRepo = ref.read(apiRepositoryProvider);
  final storageRepo = ref.read(storageRepositoryProvider);
  return EventsRepositoryImpl(apiRepo, storageRepo);
});

// Provider for Unseen Events (used by EventUpdateMessageCard)
final eventsFutureProvider = FutureProvider<List<EventModel>>((ref) {
  // Watch user provider to refresh events when user logs in/out
  ref.watch(userProvider);
  final repo = ref.watch(eventsRepoProvider);
  return repo.fetchEvents(filterViewed: true);
});
