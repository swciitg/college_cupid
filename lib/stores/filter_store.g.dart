// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on _FilterStore, Store {
  late final _$interestedInGenderAtom =
      Atom(name: '_FilterStore.interestedInGender', context: context);

  @override
  InterestedInGender get interestedInGender {
    _$interestedInGenderAtom.reportRead();
    return super.interestedInGender;
  }

  @override
  set interestedInGender(InterestedInGender value) {
    _$interestedInGenderAtom.reportWrite(value, super.interestedInGender, () {
      super.interestedInGender = value;
    });
  }

  late final _$yearOfJoinAtom =
      Atom(name: '_FilterStore.yearOfJoin', context: context);

  @override
  int? get yearOfJoin {
    _$yearOfJoinAtom.reportRead();
    return super.yearOfJoin;
  }

  @override
  set yearOfJoin(int? value) {
    _$yearOfJoinAtom.reportWrite(value, super.yearOfJoin, () {
      super.yearOfJoin = value;
    });
  }

  late final _$programAtom =
      Atom(name: '_FilterStore.program', context: context);

  @override
  Program get program {
    _$programAtom.reportRead();
    return super.program;
  }

  @override
  set program(Program value) {
    _$programAtom.reportWrite(value, super.program, () {
      super.program = value;
    });
  }

  late final _$_FilterStoreActionController =
      ActionController(name: '_FilterStore', context: context);

  @override
  void setYearOfJoin(int? year) {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.setYearOfJoin');
    try {
      return super.setYearOfJoin(year);
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgram(Program p) {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.setProgram');
    try {
      return super.setProgram(p);
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInterestedInGender(InterestedInGender gender) {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.setInterestedInGender');
    try {
      return super.setInterestedInGender(gender);
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilters(
      {required InterestedInGender gender,
      required int? year,
      required Program p}) {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.setFilters');
    try {
      return super.setFilters(gender: gender, year: year, p: p);
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
interestedInGender: ${interestedInGender},
yearOfJoin: ${yearOfJoin},
program: ${program}
    ''';
  }
}
