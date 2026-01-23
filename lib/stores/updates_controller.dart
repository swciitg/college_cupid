import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/repositories/mock_updates_repository.dart';
import 'package:college_cupid/repositories/updates_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatesRepositoryProvider = Provider<UpdatesRepository>((ref) {
  return MockUpdatesRepository();
});

final updatesControllerProvider =
    StateNotifierProvider<UpdatesController, AsyncValue<List<UpdateModel>>>(
        (ref) {
  return UpdatesController(ref.read(updatesRepositoryProvider));
});

class UpdatesController extends StateNotifier<AsyncValue<List<UpdateModel>>> {
  final UpdatesRepository _repository;

  UpdatesController(this._repository) : super(const AsyncValue.loading()) {
    fetchUpdates();
  }

  Future<void> fetchUpdates({String filter = 'All'}) async {
    state = const AsyncValue.loading();
    try {
      final updates = await _repository.fetchUpdates(filter: filter);
      state = AsyncValue.data(updates);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
