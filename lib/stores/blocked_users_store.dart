import 'package:college_cupid/repositories/user_moderation_repository.dart';
import 'package:mobx/mobx.dart';

part 'blocked_users_store.g.dart';

class BlockedUsersStore = _BlockedUsersStore with _$BlockedUsersStore;

abstract class _BlockedUsersStore with Store {
  @observable
  ObservableList<String> blockedUserList = ObservableList();

  @action
  Future<void> getBlockedUsers() async {
    blockedUserList = ObservableList();
    blockedUserList.addAll(await UserModerationRepository().getBlockedUsers());
  }

  @action
  Future<void> unblockUser(int index) async {
    bool success = await UserModerationRepository().unblockUser(index);
    if (success) blockedUserList.removeAt(index);
  }
}
