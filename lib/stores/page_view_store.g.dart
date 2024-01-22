// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_view_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PageViewStore on _PageViewStore, Store {
  late final _$pageNumberAtom =
      Atom(name: '_PageViewStore.pageNumber', context: context);

  @override
  int get pageNumber {
    _$pageNumberAtom.reportRead();
    return super.pageNumber;
  }

  @override
  set pageNumber(int value) {
    _$pageNumberAtom.reportWrite(value, super.pageNumber, () {
      super.pageNumber = value;
    });
  }

  late final _$isLastPageAtom =
      Atom(name: '_PageViewStore.isLastPage', context: context);

  @override
  bool get isLastPage {
    _$isLastPageAtom.reportRead();
    return super.isLastPage;
  }

  @override
  set isLastPage(bool value) {
    _$isLastPageAtom.reportWrite(value, super.isLastPage, () {
      super.isLastPage = value;
    });
  }

  late final _$homeTabProfileListAtom =
      Atom(name: '_PageViewStore.homeTabProfileList', context: context);

  @override
  ObservableList<UserProfile> get homeTabProfileList {
    _$homeTabProfileListAtom.reportRead();
    return super.homeTabProfileList;
  }

  @override
  set homeTabProfileList(ObservableList<UserProfile> value) {
    _$homeTabProfileListAtom.reportWrite(value, super.homeTabProfileList, () {
      super.homeTabProfileList = value;
    });
  }

  late final _$_PageViewStoreActionController =
      ActionController(name: '_PageViewStore', context: context);

  @override
  void setIsLastPage(bool value) {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.setIsLastPage');
    try {
      return super.setIsLastPage(value);
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addHomeTabProfiles(List<UserProfile> value) {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.addHomeTabProfiles');
    try {
      return super.addHomeTabProfiles(value);
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeHomeTabProfile(String email) {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.removeHomeTabProfile');
    try {
      return super.removeHomeTabProfile(email);
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHomeTabProfiles(List<UserProfile> value) {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.setHomeTabProfiles');
    try {
      return super.setHomeTabProfiles(value);
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPageNumber(int value) {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.setPageNumber');
    try {
      return super.setPageNumber(value);
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetStore() {
    final _$actionInfo = _$_PageViewStoreActionController.startAction(
        name: '_PageViewStore.resetStore');
    try {
      return super.resetStore();
    } finally {
      _$_PageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageNumber: ${pageNumber},
isLastPage: ${isLastPage},
homeTabProfileList: ${homeTabProfileList}
    ''';
  }
}
