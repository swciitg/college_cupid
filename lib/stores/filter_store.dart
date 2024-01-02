import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  @observable
  InterestedInGender interestedInGender =
      LoginStore.myProfile['gender'] == 'male'
          ? InterestedInGender.girls
          : InterestedInGender.boys;

  @observable
  int? yearOfJoin;

  @observable
  Program program = Program.none;

  @action
  void setYearOfJoin(int? year) {
    yearOfJoin = year;
  }

  @action
  void setProgram(Program p) {
    program = p;
  }

  @action
  void setInterestedInGender(InterestedInGender gender) {
    interestedInGender = gender;
  }

  @action
  void clearFilters() {
    program = Program.none;
    yearOfJoin = null;
    interestedInGender = LoginStore.myProfile['gender'] == 'male'
        ? InterestedInGender.girls
        : InterestedInGender.boys;
  }

  @action
  void setFilters(
      {required InterestedInGender gender,
      required int? year,
      required Program p}) {
    interestedInGender = gender;
    yearOfJoin = year;
    program = p;
  }
}
