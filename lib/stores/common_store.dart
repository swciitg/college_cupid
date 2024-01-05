import 'package:mobx/mobx.dart';

part 'common_store.g.dart';

class CommonStore = _CommonStore with _$CommonStore;

abstract class _CommonStore with Store {
  @observable
  String password = "";

  @action
  void setPassword(String value){
    password = value;
  }
}