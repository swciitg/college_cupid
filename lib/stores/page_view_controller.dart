import 'dart:developer';

import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:provider/provider.dart';

final pageViewProvider =
    StateNotifierProvider<PageViewNotifier, PageViewState>((ref) {
  return PageViewNotifier(ref: ref);
});

class PageViewNotifier extends StateNotifier<PageViewState> {
  final Ref _ref;
  PageViewNotifier({required Ref ref})
      : _ref = ref,
        super(PageViewState());

  int currentPage = 0;
  int pageNumber = 0;
  bool isLastPage = false;

  void setIsLastPage(bool value) {
    isLastPage = value;
  }

  void addHomeTabProfiles(List<UserProfile> value) {
    state = state.copyWith(
      homeTabProfileList: [...state.homeTabProfileList, ...value],
    );
  }

  void removeHomeTabProfile(String email) {
    state = state.copyWith(
      homeTabProfileList: state.homeTabProfileList
          .where((element) => element.email != email)
          .toList(),
    );
  }

  void setHomeTabProfiles(List<UserProfile> value) {
    state = state.copyWith(homeTabProfileList: value);
  }

  void setPageNumber(int value) {
    pageNumber = value;
  }

  void resetStore() {
    currentPage = 0;
    pageNumber = 0;
    isLastPage = false;
    state = state.copyWith(loading: false, homeTabProfileList: []);
  }

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  void setCurrentPage(int value) {
    currentPage = value;
  }

  void getInitialProfiles(BuildContext context) async {
    resetStore();
    final userProfileRepo = _ref.read(userProfileRepoProvider);
    final filterStore = context.read<FilterStore>();
    final pageViewStore = _ref.read(pageViewProvider.notifier);
    try {
      pageViewStore.setLoading(true);
      final profiles = await userProfileRepo.getPaginatedUsers(0, {
        //don't want it to be triggered when pageNumber is changed
        'gender': filterStore.interestedInGender.databaseString,
        'program': filterStore.program.databaseString,
        'yearOfJoin': filterStore.yearOfJoin,
        'name': filterStore.name,
      });
      pageViewStore.setHomeTabProfiles(profiles);
      pageViewStore.setIsLastPage(profiles.length < 10);
      pageViewStore.setLoading(false);
    } catch (e) {
      showSnackBar("Something went wrong! try again later.");
      log("Error fetching initial profiles: ${e.toString()}");
      pageViewStore.setLoading(false);
    }
  }
}

class PageViewState {
  final bool loading;
  final List<UserProfile> homeTabProfileList;

  PageViewState({
    this.loading = false,
    this.homeTabProfileList = const [],
  });

  PageViewState copyWith({
    List<UserProfile>? homeTabProfileList,
    bool? loading,
  }) {
    return PageViewState(
      loading: loading ?? this.loading,
      homeTabProfileList: homeTabProfileList ?? this.homeTabProfileList,
    );
  }
}
