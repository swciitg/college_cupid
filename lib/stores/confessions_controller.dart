import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/repositories/confessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confessionsProvider =
    StateNotifierProvider<ConfessionsController, ConfessionsState>(
        (ref) => ConfessionsController(ref.read(confessionsRepoProvider)));

class ConfessionsState {
  final bool isLoading;
  final List<Confession>? confessions;
  final String? errorMessage;
  final ConfessionCategory selectedCategory;

  ConfessionsState({
    this.isLoading = false,
    this.confessions,
    this.errorMessage,
    this.selectedCategory = ConfessionCategory.all,
  });

  ConfessionsState copyWith({
    bool? isLoading,
    List<Confession>? confessions,
    String? errorMessage,
    ConfessionCategory? selectedCategory,
  }) {
    return ConfessionsState(
      isLoading: isLoading ?? this.isLoading,
      confessions: confessions ?? this.confessions,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ConfessionsController extends StateNotifier<ConfessionsState> {
  final ConfessionsRepository _repository;

  ConfessionsController(this._repository) : super(ConfessionsState()) {
    getConfessions();
  }

  Future<void> getConfessions({ConfessionCategory? category}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final confessions = await _repository.getConfessions(category: category);
      state = state.copyWith(
          isLoading: false,
          confessions: confessions,
          selectedCategory: category);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async {
    await getConfessions(category: state.selectedCategory);
  }

  Future<void> reactToConfession(String id, String reaction) async {
    try {
      await _repository.reactToConfession(id, reaction);
      if (state.confessions != null) {
        state = state.copyWith(
          confessions: state.confessions!.map((c) {
            if (c.id == id) {
              final newReactions = List<String>.from(c.reactions);
              newReactions.add(reaction);
              return c.copyWith(reactions: newReactions);
            }
            return c;
          }).toList(),
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void setCategory(ConfessionCategory category) {
    if (state.selectedCategory == category) return;
    getConfessions(category: category);
  }
}
