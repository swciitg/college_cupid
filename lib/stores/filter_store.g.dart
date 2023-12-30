// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on _FilterStore, Store {
  late final _$filtersAtom =
      Atom(name: '_FilterStore.filters', context: context);

  @override
  Map<String, dynamic>? get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(Map<String, dynamic>? value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

  late final _$_FilterStoreActionController =
      ActionController(name: '_FilterStore', context: context);

  @override
  void setFilters(Map<String, dynamic>? newFilters) {
    final _$actionInfo = _$_FilterStoreActionController.startAction(
        name: '_FilterStore.setFilters');
    try {
      return super.setFilters(newFilters);
    } finally {
      _$_FilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filters: ${filters}
    ''';
  }
}
