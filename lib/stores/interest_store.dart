import 'package:mobx/mobx.dart';

part 'interest_store.g.dart';

class InterestStore = _InterestStore with _$InterestStore;

abstract class _InterestStore with Store {
  @observable
  ObservableList<String> selectedInterests = ObservableList();

  @action
  void addMultipleInterests(List<String> list) {
    selectedInterests.addAll(list);
  }

  @action
  void addInterest(String value) {
    selectedInterests.add(value);
  }

  @action
  void removeInterest(String value) {
    selectedInterests.remove(value);
  }

  @action
  void setSelectedInterests(List<String> list) {
    selectedInterests = ObservableList();
    selectedInterests.addAll(list);
  }
}
