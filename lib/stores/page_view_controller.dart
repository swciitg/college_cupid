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

  void addHomeTabProfiles(List<UserProfile> value, {bool search = false}) {
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
      final newAddition = PageViewState(
        loading: false,
        homeTabProfileList: state.homeTabProfileList.sublist(currentPage),
      );
      final data = {
        'state': newAddition.toJson(),
        'pageNumber': pageNumber,
      };
      log("pageNumber: ${data['pageNumber']}", name: 'PageViewNotifier');
      ls.write('pageViewState', data);
    }
  }

  void removeHomeTabProfile(String email) {
    state = state.copyWith(
      homeTabProfileList:
          state.homeTabProfileList.where((element) => element.email != email).toList(),
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
  }

  Future<void> getInitialProfiles({bool search = false}) async {
    resetStore();
    final userProfileRepo = _ref.read(userProfileRepoProvider);
    final filterStore = _ref.read(filterProvider);
    final user = _ref.read(userProvider).myProfile;
    if (user?.deactivated == true) return;
    try {
      setLoading(true);
      final ls = GetStorage();
      final data = ls.read('pageViewState');
      if (data != null && !search) {
        log("pageNumber: ${data['pageNumber']}", name: 'PageViewNotifier');
        final pageNumber = data['pageNumber'] as int;
        final current = PageViewState.fromJson(data['state']);
        final previousProfiles = current.homeTabProfileList;
        log("profiles: ${previousProfiles.length}", name: 'PageViewNotifier');
        setPageNumber(pageNumber);
        setCurrentPage(0);
        state = current.copyWith(
          homeTabProfileList: previousProfiles,
        );
        setLoading(false);
        return;
      }
      if (user?.personalityType == null) return;
      final profiles = await userProfileRepo.getPaginatedUsers(0, {
        //don't want it to be triggered when pageNumber is changed
        'gender': filterStore.interestedInGender.databaseString,
        'program': filterStore.program.databaseString,
        'yearOfJoin': filterStore.yearOfJoin,
        'name': filterStore.name,
      });
      setHomeTabProfiles(profiles);
      setPageNumber(profiles.length < 10 && !search ? 0 : 1);
      setLoading(false);
    } catch (e) {
      showSnackBar("Something went wrong! try again later.");
      log("Error fetching initial profiles: ${e.toString()}");
      setLoading(false);
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

  Map<String, dynamic> toJson() {
    return {
      'loading': loading,
      'homeTabProfileList': homeTabProfileList.map((e) => e.toJson()).toList(),
    };
  }

  factory PageViewState.fromJson(Map<String, dynamic> json) {
    return PageViewState(
      loading: json['loading'],
      homeTabProfileList:
          (json['homeTabProfileList'] as List).map((e) => UserProfile.fromJson(e)).toList(),
    );
  }
}
