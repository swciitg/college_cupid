import 'package:college_cupid/services/shared_prefs.dart';
import 'package:mobx/mobx.dart';

part 'common_store.g.dart';

class CommonStore = _CommonStore with _$CommonStore;

abstract class _CommonStore with Store {
  @observable
  String password = "";

  @observable
  ObservableMap<String, dynamic> myProfile = ObservableMap();

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  Future<void> updateMyProfile(Map<String, dynamic> map) async {
    await SharedPrefs.saveMyProfile(map);
    myProfile = ObservableMap.of(map);
  }

  @action
  Future<void> initializeProfile() async {
    myProfile = ObservableMap.of(await SharedPrefs.getMyProfile());
  }
}
