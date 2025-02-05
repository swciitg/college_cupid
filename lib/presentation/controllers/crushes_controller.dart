import 'dart:async';

import 'package:college_cupid/application/crushes_service.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesControllerProvider = StateNotifierProvider.autoDispose<
    CrushesController, AsyncValue<List<UserProfile>>>((ref) {
  return CrushesController(crushesService: ref.read(crushesServiceProvider));
});

class CrushesController extends StateNotifier<AsyncValue<List<UserProfile>>> {
  final CrushesService crushesService;

  CrushesController({required this.crushesService})
      : super(const AsyncLoading());

  Future<void> getCrushProfiles() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<List<UserProfile>>(() {
      return crushesService.getCrushProfiles();
    });
  }

  Future<void> removeCrush(int index, String email) async {
    state = const AsyncLoading<List<UserProfile>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final status = await crushesService.removeCrush(index, email);
      List<UserProfile> newList = state.value!;
      if (status) {
        newList.removeAt(index);
      }
      return newList;
    });
  }
}
