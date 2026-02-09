import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/functions/snackbar.dart';

import 'package:college_cupid/repositories/updates_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatesRepositoryProvider = Provider<UpdatesRepository>((ref) {
  return ref.read(updatesRepoProvider);
});

final updatesControllerProvider =
    StateNotifierProvider<UpdatesController, List<UpdateModel>>((ref) {
  return UpdatesController(ref.read(updatesRepositoryProvider));
});

class UpdatesController extends StateNotifier<List<UpdateModel>> {
  final UpdatesRepository _repository;

  UpdatesController(this._repository) : super(const []) {
    fetchUpdates();
  }

  Future<void> fetchUpdates({String filter = 'All', bool isRefresh = false}) async {
    if (isRefresh) {
      state = [];
    } else {
      state = [];
    }
    try {
      final updates = await _repository.fetchUpdates(filter: filter);
      state = updates;
    } catch (e) {
      showSnackBar("Error Fetching updates");
      state = [];
    }
  }
}
