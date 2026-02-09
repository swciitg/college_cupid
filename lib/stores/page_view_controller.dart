import 'dart:developer';

import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:get_storage/get_storage.dart';

final pageViewProvider = StateNotifierProvider<PageViewNotifier, PageViewState>((ref) {
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
    final search = _ref.read(filterProvider.notifier).hasFilters;
    state = state.copyWith(
      homeTabProfileList: [...state.homeTabProfileList, ...value],
    );
    if (value.length < 10) {
      if (search) {
        setIsLastPage(true);
      } else {
        setPageNumber(0);
      }
    } else {
      setPageNumber(pageNumber + 1);
      setIsLastPage(false);
    }
    if (!search) {
      final ls = GetStorage();
      final data = {
        'pageNumber': pageNumber,
      };
      log("pageNumber (write): ${data['pageNumber']}", name: 'PageViewNotifier');
      ls.write('pageViewState', data);
    }
  }

  void removeHomeTabProfile(String email) {
    state = state.copyWith(
      homeTabProfileList:
          state.homeTabProfileList.where((element) => element.email != email).toList(),
    );
  }

  void insertProfileAtStart(UserProfile profile) {
    // Remove if already exists to avoid duplicates
    final updatedList =
        state.homeTabProfileList.where((element) => element.email != profile.email).toList();
    // Insert at the beginning
    state = state.copyWith(
      homeTabProfileList: [profile, ...updatedList],
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
    state = state.copyWith(loading: false, homeTabProfileList: []);
  }

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  void setCurrentPage(int value) {
    currentPage = value;
    // Trigger state rebuild by creating a new state object
    state = state.copyWith();
  }

  Future<void> getInitialProfiles() async {
    resetStore();
    final search = _ref.read(filterProvider.notifier).hasFilters;
    final userProfileRepo = _ref.read(userProfileRepoProvider);
    final filterStore = _ref.read(filterProvider);
    final user = _ref.read(userProvider).myProfile;
    if (user?.deactivated == true) return;
    try {
      setLoading(true);
      final ls = GetStorage();
      final data = ls.read('pageViewState');
      if (data != null && !search) {
        var pageNumber = data['pageNumber'] as int;
        pageNumber = (pageNumber - 2).clamp(0, pageNumber);
        setPageNumber(pageNumber);
        log("pageNumber (read): $pageNumber", name: 'PageViewNotifier');
        setCurrentPage(0);
        setLoading(false);
      }
      if (user?.personalityType == null) return;
      final profiles = await userProfileRepo.getPaginatedUsers(pageNumber, {
        //don't want it to be triggered when pageNumber is changed
        'gender': filterStore.interestedInGender.databaseString,
        'program': filterStore.program.databaseString,
        'yearOfJoin': filterStore.yearOfJoin,
        'name': filterStore.name,
      });
      setHomeTabProfiles(profiles);
      setPageNumber(profiles.length < 10 ? 0 : pageNumber + 1);
      setLoading(false);
    } catch (e) {
      showSnackBar("Something went wrong! try again later.");
      log("Error fetching initial profiles: ${e.toString()}");
      setLoading(false);
    }
  }

  Future<void> nextProfile() async {
    final nextIndex = currentPage + 1;
    setCurrentPage(nextIndex);

    // Fetch more if needed
    final filterStore = _ref.read(filterProvider);
    if (!isLastPage &&
        state.homeTabProfileList.length - nextIndex <= 4 &&
        filterStore.name.isEmpty) {
      final userProfileRepo = _ref.read(userProfileRepoProvider);
      final filter = {
        'gender': filterStore.interestedInGender.databaseString,
        'program': filterStore.program.databaseString,
        'yearOfJoin': filterStore.yearOfJoin,
        'name': filterStore.name
      };
      try {
        final List<UserProfile> users = await userProfileRepo.getPaginatedUsers(pageNumber, filter);
        addHomeTabProfiles(users);
      } catch (e) {
        log("Error fetching more profiles: $e");
      }
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
