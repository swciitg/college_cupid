import 'package:college_cupid/services/api.dart';
import 'package:mobx/mobx.dart';

part 'blocked_users_store.g.dart';

class BlockedUsersStore = _BlockedUsersStore with _$BlockedUsersStore;

abstract class _BlockedUsersStore with Store {
  @observable
  ObservableList<String> blockedUserList = ObservableList();

  @action
  Future<void> getBlockedUsers() async {
    blockedUserList = ObservableList();
    blockedUserList.addAll(await APIService().getBlockedUsers());
  }

  @action
  Future<void> unblockUser(int index) async {
    bool success = await APIService().unblockUser(index);
    if (success) blockedUserList.removeAt(index);
  }
}
