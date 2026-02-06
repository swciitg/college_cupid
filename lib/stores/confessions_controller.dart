import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/repositories/confessions_repository.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final confessionsProvider =
    StateNotifierProvider<ConfessionsController, ConfessionsState>(
        (ref) => ConfessionsController(ref.read(confessionsRepoProvider)));

enum ConfessionsFilter { all, spottedInCampus, gossip, byYou }

extension ConfessionsFilterExtension on ConfessionsFilter {
  String get displayName {
    switch (this) {
      case ConfessionsFilter.all:
        return 'All';
      case ConfessionsFilter.spottedInCampus:
        return 'Spotted in Campus';
      case ConfessionsFilter.gossip:
        return 'Gossip';
      case ConfessionsFilter.byYou:
        return 'By You';
    }
  }
}

class ConfessionsState {
  final bool isLoading;
  final Map<ConfessionsFilter, List<Confession>> confessionsMap;
  final Map<ConfessionsFilter, int> pages;
  final Map<ConfessionsFilter, bool> hasMore;
  final Set<String> myConfessionIds;
  final String? errorMessage;
  final ConfessionsFilter selectedFilter;

  ConfessionsState({
    this.isLoading = false,
    this.confessionsMap = const {},
    this.pages = const {},
    this.hasMore = const {},
    this.myConfessionIds = const {},
    this.errorMessage,
    this.selectedFilter = ConfessionsFilter.all,
  });

  List<Confession>? get confessions => confessionsMap[selectedFilter];

  ConfessionsState copyWith({
    bool? isLoading,
    Map<ConfessionsFilter, List<Confession>>? confessionsMap,
    Map<ConfessionsFilter, int>? pages,
    Map<ConfessionsFilter, bool>? hasMore,
    Set<String>? myConfessionIds,
    String? errorMessage,
    ConfessionsFilter? selectedFilter,
  }) {
    return ConfessionsState(
      isLoading: isLoading ?? this.isLoading,
      confessionsMap: confessionsMap ?? this.confessionsMap,
      pages: pages ?? this.pages,
      hasMore: hasMore ?? this.hasMore,
      myConfessionIds: myConfessionIds ?? this.myConfessionIds,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class ConfessionsController extends StateNotifier<ConfessionsState> {
  final ConfessionsRepository _repository;

  ConfessionsController(this._repository) : super(ConfessionsState()) {
    _fetchMyConfessionIds();
    getConfessions();
  }

  Future<void> _fetchMyConfessionIds() async {
    try {
      if (LoginStore.email == null) return;

      final encryptedEmail =
          Encryption.encryptEmail(LoginStore.email!, Endpoints.apiSecurityKey);

      final myConfessions = await _repository.getMyConfessions(encryptedEmail);
      final myIds = myConfessions.map((c) => c.id).toSet();

      // Optimize: Populate the 'byYou' list since we have the data
      // This avoids a second fetch when user clicks the tab
      final updatedMap =
          Map<ConfessionsFilter, List<Confession>>.from(state.confessionsMap);
      updatedMap[ConfessionsFilter.byYou] = myConfessions;

      state =
          state.copyWith(myConfessionIds: myIds, confessionsMap: updatedMap);
    } catch (e) {
      debugPrint('Error fetching my confession IDs: $e');
    }
  }

  Future<void> getConfessions({
    ConfessionsFilter? filter,
    bool isRefresh = false,
  }) async {
    final targetFilter = filter ?? state.selectedFilter;

    if (filter != null &&
        filter != state.selectedFilter &&
        state.confessionsMap.containsKey(filter) &&
        !isRefresh) {
      state = state.copyWith(selectedFilter: filter);
      return;
    }

    final currentPage = isRefresh ? 0 : (state.pages[targetFilter] ?? 0);

    state = state.copyWith(
        isLoading: true, errorMessage: null, selectedFilter: targetFilter);

    try {
      List<Confession> newConfessions;
      if (targetFilter == ConfessionsFilter.byYou) {
        if (LoginStore.email == null) {
          state = state.copyWith(
              isLoading: false, errorMessage: "User email not found");
          return;
        }

        debugPrint(
            'DEBUG: Fetching "By You" confessions for email: ${LoginStore.email}');
        final encryptedEmail = Encryption.encryptEmail(
            LoginStore.email!, Endpoints.apiSecurityKey);
        debugPrint('DEBUG: Encrypted Email: $encryptedEmail');

        newConfessions = await _repository.getMyConfessions(encryptedEmail);
        debugPrint('DEBUG: Fetched ${newConfessions.length} my confessions');
      } else {
        ConfessionCategory? category;
        if (targetFilter == ConfessionsFilter.spottedInCampus) {
          category = ConfessionCategory.SPOTTED_IN_CAMPUS;
        } else if (targetFilter == ConfessionsFilter.gossip) {
          category = ConfessionCategory.GOSSIP;
        }
        newConfessions = await _repository.getConfessions(
            category: category, page: currentPage);
      }

      final Map<ConfessionsFilter, List<Confession>> updatedMap =
          Map.from(state.confessionsMap);
      final Map<ConfessionsFilter, int> updatedPages = Map.from(state.pages);
      final Map<ConfessionsFilter, bool> updatedHasMore =
          Map.from(state.hasMore);

      if (isRefresh || currentPage == 0) {
        updatedMap[targetFilter] = newConfessions;
      } else {
        updatedMap[targetFilter] = [
          ...?updatedMap[targetFilter],
          ...newConfessions
        ];
      }

      updatedPages[targetFilter] = currentPage;
      // If we got fewer than limit, no more data.
      if (newConfessions.isEmpty || newConfessions.length < 20) {
        updatedHasMore[targetFilter] = false;
      } else {
        updatedHasMore[targetFilter] = true;
      }

      state = state.copyWith(
          isLoading: false,
          confessionsMap: updatedMap,
          pages: updatedPages,
          hasMore: updatedHasMore,
          selectedFilter: targetFilter);
    } catch (e, st) {
      debugPrint('DEBUG CONTROLLER: Error in getConfessions: $e');
      debugPrint('Stack trace: $st');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    if (state.hasMore[state.selectedFilter] == false) return;
    state = state.copyWith(isLoading: true);

    try {
      final currentFilter = state.selectedFilter;
      final nextPage = (state.pages[currentFilter] ?? 0) + 1;

      List<Confession> newConfessions;
      if (currentFilter == ConfessionsFilter.byYou) {
        state = state.copyWith(isLoading: false);
        return;
      } else {
        ConfessionCategory? category;
        if (currentFilter == ConfessionsFilter.spottedInCampus) {
          category = ConfessionCategory.SPOTTED_IN_CAMPUS;
        } else if (currentFilter == ConfessionsFilter.gossip) {
          category = ConfessionCategory.GOSSIP;
        }
        newConfessions = await _repository.getConfessions(
            category: category, page: nextPage);
      }

      final updatedMap =
          Map<ConfessionsFilter, List<Confession>>.from(state.confessionsMap);
      final updatedPages = Map<ConfessionsFilter, int>.from(state.pages);
      final updatedHasMore = Map<ConfessionsFilter, bool>.from(state.hasMore);

      if (newConfessions.isNotEmpty) {
        updatedMap[currentFilter] = [
          ...?updatedMap[currentFilter],
          ...newConfessions
        ];
        updatedPages[currentFilter] = nextPage;
      } else {
        updatedHasMore[currentFilter] = false;
      }

      if (newConfessions.length < 20) {
        updatedHasMore[currentFilter] = false;
      }

      state = state.copyWith(
        isLoading: false,
        confessionsMap: updatedMap,
        pages: updatedPages,
        hasMore: updatedHasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async {
    await getConfessions(filter: state.selectedFilter, isRefresh: true);
  }

  Future<bool> postConfession(String text, ConfessionCategory category) async {
    try {
      if (LoginStore.email == null) {
        state = state.copyWith(errorMessage: 'User email not found');
        return false;
      }
      final encryptedEmail =
          Encryption.encryptEmail(LoginStore.email!, Endpoints.apiSecurityKey);

      final success =
          await _repository.postConfession(text, category.name, encryptedEmail);
      if (success) {
        _fetchMyConfessionIds();
        await refresh();
      } else {
        state = state.copyWith(errorMessage: 'Failed to post confession');
      }
      return success;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  void _updateConfessionInList(Confession updatedConfession) {
    final updatedMap =
        Map<ConfessionsFilter, List<Confession>>.from(state.confessionsMap);

    updatedMap.forEach((filter, list) {
      final index = list.indexWhere((c) => c.id == updatedConfession.id);
      if (index != -1) {
        final newList = List<Confession>.from(list);
        newList[index] = updatedConfession;
        updatedMap[filter] = newList;
      }
    });

    state = state.copyWith(confessionsMap: updatedMap);
  }

  void _removeConfessionFromList(String id) {
    final updatedMap =
        Map<ConfessionsFilter, List<Confession>>.from(state.confessionsMap);

    updatedMap.forEach((filter, list) {
      updatedMap[filter] = list.where((c) => c.id != id).toList();
    });

    state = state.copyWith(confessionsMap: updatedMap);
  }

  Future<void> reactToConfession(String id, String reaction) async {
    try {
      final success = await _repository.reactToConfession(id, reaction);
      if (success) {
        Confession? target;
        for (var list in state.confessionsMap.values) {
          final c = list.firstWhere((c) => c.id == id,
              orElse: () => Confession(
                  id: 'null',
                  encryptedEmail: '',
                  text: '',
                  typeOfConfession: ConfessionCategory.GOSSIP,
                  createdAt: DateTime.now()));
          if (c.id != 'null') {
            target = c;
            break;
          }
        }

        if (target != null) {
          final hasReacted =
              target.reactions.any((r) => r.user == LoginStore.userId);
          List<Reaction> updatedReactions;
          if (hasReacted) {
            updatedReactions = target.reactions.map((r) {
              if (r.user == LoginStore.userId) {
                return Reaction(reaction: reaction, user: LoginStore.userId!);
              }
              return r;
            }).toList();
          } else {
            updatedReactions = [
              ...target.reactions,
              Reaction(reaction: reaction, user: LoginStore.userId!)
            ];
          }
          final updatedConfession =
              target.copyWith(reactions: updatedReactions);
          _updateConfessionInList(updatedConfession);
        }
      } else {
        state = state.copyWith(errorMessage: 'Failed to react');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<bool> deleteConfession(String id) async {
    try {
      debugPrint('DEBUG CONTROLLER: Deleting confession $id');
      final encryptedEmail =
          Encryption.encryptEmail(LoginStore.email!, Endpoints.apiSecurityKey);
      final success = await _repository.deleteConfession(id, encryptedEmail);
      debugPrint('DEBUG CONTROLLER: Delete result: $success');
      if (success) {
        final updatedIds = Set<String>.from(state.myConfessionIds)..remove(id);
        state = state.copyWith(myConfessionIds: updatedIds);
        _removeConfessionFromList(id);
      } else {
        state = state.copyWith(errorMessage: 'Failed to delete confession');
      }
      return success;
    } catch (e) {
      debugPrint('DEBUG CONTROLLER: Error deleting: $e');
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> reportConfession(
      String id, ConfessionReportCategory category) async {
    try {
      final success = await _repository.reportConfession(id, category);
      if (!success) {
        state = state.copyWith(errorMessage: 'Failed to report confession');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> removeReaction(String id) async {
    try {
      final success = await _repository.removeReaction(id);
      if (success) {
        Confession? target;
        for (var list in state.confessionsMap.values) {
          final c = list.firstWhere((c) => c.id == id,
              orElse: () => Confession(
                  id: 'null',
                  encryptedEmail: '',
                  text: '',
                  typeOfConfession: ConfessionCategory.GOSSIP,
                  createdAt: DateTime.now()));
          if (c.id != 'null') {
            target = c;
            break;
          }
        }

        if (target != null) {
          final updatedConfession = target.copyWith(
            reactions: target.reactions
                .where((r) => r.user != LoginStore.userId)
                .toList(),
          );
          _updateConfessionInList(updatedConfession);
        }
      } else {
        state = state.copyWith(errorMessage: 'Failed to remove reaction');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> replyToConfession(String id, String content) async {
    try {
      final success = await _repository.replyToConfession(id, content);
      if (success) {
        // Optionally refresh or update local state
        await refresh();
      } else {
        state = state.copyWith(errorMessage: 'Failed to reply');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void setFilter(ConfessionsFilter filter) {
    debugPrint('DEBUG CONTROLLER: setFilter called with $filter');
    // If selecting same filter, do nothing
    if (state.selectedFilter == filter) return;

    // If we already have data for this filter, just switch view
    if (state.confessionsMap.containsKey(filter)) {
      debugPrint('DEBUG CONTROLLER: Switching to cached data for $filter');
      state = state.copyWith(selectedFilter: filter);
    } else {
      // Else fetch data for this filter
      debugPrint('DEBUG CONTROLLER: Fetching data for $filter');
      getConfessions(filter: filter);
    }
  }
}
