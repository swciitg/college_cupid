import 'package:college_cupid/models/user_profile.dart';
import 'package:mobx/mobx.dart';
part 'page_view_store.g.dart';

class PageViewStore = _PageViewStore with _$PageViewStore;

abstract class _PageViewStore with Store {
  @observable
  int pageNumber = 0;

  @observable
  bool isLastPage = false;

  @observable
  ObservableList<UserProfile> homeTabProfileList =
      ObservableList<UserProfile>();

  @action
  void setIsLastPage(bool value) {
    isLastPage = value;
  }

  @action
  void addHomeTabProfiles(List<UserProfile> value) {
    homeTabProfileList.addAll(value);
  }

  @action
  void setPageNumber(int value) {
    pageNumber = value;
  }

  @action
  void resetStore() {
    pageNumber = 0;
    homeTabProfileList.clear();
  }
}
