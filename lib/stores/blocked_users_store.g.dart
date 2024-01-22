// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BlockedUsersStore on _BlockedUsersStore, Store {
  late final _$blockedUserListAtom =
      Atom(name: '_BlockedUsersStore.blockedUserList', context: context);

  @override
  List<dynamic> get blockedUserList {
    _$blockedUserListAtom.reportRead();
    return super.blockedUserList;
  }

  @override
  set blockedUserList(List<dynamic> value) {
    _$blockedUserListAtom.reportWrite(value, super.blockedUserList, () {
      super.blockedUserList = value;
    });
  }

  late final _$getBlockedUsersAsyncAction =
      AsyncAction('_BlockedUsersStore.getBlockedUsers', context: context);

  @override
  Future<void> getBlockedUsers() {
    return _$getBlockedUsersAsyncAction.run(() => super.getBlockedUsers());
  }

  late final _$unblockUserAsyncAction =
      AsyncAction('_BlockedUsersStore.unblockUser', context: context);

  @override
  Future<void> unblockUser(int index) {
    return _$unblockUserAsyncAction.run(() => super.unblockUser(index));
  }

  late final _$_BlockedUsersStoreActionController =
      ActionController(name: '_BlockedUsersStore', context: context);

  @override
  void setBlockedUsers(List<dynamic> value) {
    final _$actionInfo = _$_BlockedUsersStoreActionController.startAction(
        name: '_BlockedUsersStore.setBlockedUsers');
    try {
      return super.setBlockedUsers(value);
    } finally {
      _$_BlockedUsersStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
blockedUserList: ${blockedUserList}
    ''';
  }
}
