import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    StateNotifierProvider<UserController, UserProviderState>((ref) => UserController(ref));

class UserController extends StateNotifier<UserProviderState> {
  final Ref _ref;

  UserController(this._ref) : super(UserProviderState());

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> updateMyProfile(UserProfile userProfile) async {
    await SharedPrefService.saveMyProfile(userProfile.toJson());
    state = state.copyWith(myProfile: userProfile);
  }

  Future<void> initializeProfile() async {
    final myProfile = UserProfile.fromJson(await SharedPrefService.getMyProfile());
    state = state.copyWith(myProfile: myProfile);

    // Set storage type from loaded profile
    _ref.read(storageTypeProvider.notifier).state = myProfile.storageType;
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
