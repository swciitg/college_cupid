import 'package:college_cupid/services/api.dart';
import 'package:mobx/mobx.dart';

part 'blocked_users_store.g.dart';

class BlockedUsersStore = _BlockedUsersStore with _$BlockedUsersStore;

abstract class _BlockedUsersStore with Store {
  @observable
  List blockedUserList = [];

  @action
  Future<void> getBlockedUsers() async {
    blockedUserList = await APIService().getBlockedUsers();
  }

  @action
  Future<void> unblockUser(int index) async {
    await APIService().unblockUser(index);
    await getBlockedUsers();
  }

  @action
  void setBlockedUsers(List value) {
    blockedUserList = value;
  }
}
