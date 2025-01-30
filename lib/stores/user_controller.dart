import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    StateNotifierProvider<UserController, UserProviderState>((ref) => UserController());

class UserController extends StateNotifier<UserProviderState> {
  UserController() : super(UserProviderState());

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> updateMyProfile(UserProfile userProfile) async {
    await SharedPrefs.saveMyProfile(userProfile.toJson());
    state = state.copyWith(myProfile: userProfile);
  }

  Future<void> initializeProfile() async {
    final myProfile = UserProfile.fromJson(await SharedPrefs.getMyProfile());
    state = state.copyWith(myProfile: myProfile);
  }
}

class UserProviderState {
  final String password;
  final UserProfile? myProfile;

  UserProviderState({
    this.password = "",
    this.myProfile,
  });

  UserProviderState copyWith({
    String? password,
    UserProfile? myProfile,
  }) {
    return UserProviderState(
      password: password ?? this.password,
      myProfile: myProfile ?? this.myProfile,
    );
  }
}
