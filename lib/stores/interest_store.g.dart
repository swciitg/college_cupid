// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InterestStore on _InterestStore, Store {
  late final _$selectedInterestsAtom =
      Atom(name: '_InterestStore.selectedInterests', context: context);

  @override
  ObservableList<String> get selectedInterests {
    _$selectedInterestsAtom.reportRead();
    return super.selectedInterests;
  }

  @override
  set selectedInterests(ObservableList<String> value) {
    _$selectedInterestsAtom.reportWrite(value, super.selectedInterests, () {
      super.selectedInterests = value;
    });
  }

  late final _$_InterestStoreActionController =
      ActionController(name: '_InterestStore', context: context);

  @override
  void addMultipleInterests(List<String> list) {
    final _$actionInfo = _$_InterestStoreActionController.startAction(
        name: '_InterestStore.addMultipleInterests');
    try {
      return super.addMultipleInterests(list);
    } finally {
      _$_InterestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addInterest(String value) {
    final _$actionInfo = _$_InterestStoreActionController.startAction(
        name: '_InterestStore.addInterest');
    try {
      return super.addInterest(value);
    } finally {
      _$_InterestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeInterest(String value) {
    final _$actionInfo = _$_InterestStoreActionController.startAction(
        name: '_InterestStore.removeInterest');
    try {
      return super.removeInterest(value);
    } finally {
      _$_InterestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedInterests(List<String> list) {
    final _$actionInfo = _$_InterestStoreActionController.startAction(
        name: '_InterestStore.setSelectedInterests');
    try {
      return super.setSelectedInterests(list);
    } finally {
      _$_InterestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedInterests: ${selectedInterests}
    ''';
  }
}
