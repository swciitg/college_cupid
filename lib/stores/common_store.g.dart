// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CommonStore on _CommonStore, Store {
  late final _$passwordAtom =
      Atom(name: '_CommonStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$myProfileAtom =
      Atom(name: '_CommonStore.myProfile', context: context);

  @override
  ObservableMap<String, dynamic> get myProfile {
    _$myProfileAtom.reportRead();
    return super.myProfile;
  }

  @override
  set myProfile(ObservableMap<String, dynamic> value) {
    _$myProfileAtom.reportWrite(value, super.myProfile, () {
      super.myProfile = value;
    });
  }

  late final _$updateMyProfileAsyncAction =
      AsyncAction('_CommonStore.updateMyProfile', context: context);

  @override
  Future<void> updateMyProfile(Map<String, dynamic> map) {
    return _$updateMyProfileAsyncAction.run(() => super.updateMyProfile(map));
  }

  late final _$initializeProfileAsyncAction =
      AsyncAction('_CommonStore.initializeProfile', context: context);

  @override
  Future<void> initializeProfile() {
    return _$initializeProfileAsyncAction.run(() => super.initializeProfile());
  }

  late final _$_CommonStoreActionController =
      ActionController(name: '_CommonStore', context: context);

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_CommonStoreActionController.startAction(
        name: '_CommonStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_CommonStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
password: ${password},
myProfile: ${myProfile}
    ''';
  }
}
