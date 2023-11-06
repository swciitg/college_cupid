import 'package:college_cupid/services/api.dart';
import 'package:mobx/mobx.dart';

part 'crush_list_store.g.dart';

class CrushListStore = _CrushListStore with _$CrushListStore;

abstract class _CrushListStore with Store {
  @observable
  List crushList = [];

  @action
  Future<void> getCrushes() async {
    crushList = await APIService().getCrushes();
  }

  @action
  Future<void> removeCrush(int index) async {
    await APIService().removeCrush(index);
    await getCrushes();
  }

  @action
  void setCrushes(List value) {
    crushList = value;
  }
}
