import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  @observable
  Map<String, dynamic>? filters;

  @action
  void setFilters(Map<String, dynamic>? newFilters) {
    filters = newFilters;
  }
}
