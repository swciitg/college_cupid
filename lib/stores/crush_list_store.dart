import 'package:college_cupid/services/api.dart';
import 'package:mobx/mobx.dart';

part 'crush_list_store.g.dart';

class CrushListStore = _CrushListStore with _$CrushListStore;

abstract class _CrushListStore with Store {
  @observable
  ObservableList<String> crushList = ObservableList();

  @action
  Future<void> getCrushes() async {
    crushList = ObservableList();
    crushList.addAll(await APIService().getCrushes());
  }

  @action
  Future<void> removeCrush(int index) async {
    bool success = await APIService().removeCrush(index);
    if (success) crushList.removeAt(index);
  }
}
