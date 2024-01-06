import 'package:college_cupid/shared/enums.dart';
import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  @observable
  InterestedInGender interestedInGender = InterestedInGender.both;

  @observable
  int? yearOfJoin;

  @observable
  int pageNumber = 0;

  @observable
  String name = '';

  @observable
  Program program = Program.none;

  @action
  void setYearOfJoin(int? year) {
    yearOfJoin = year;
    setPageNumber(0);
  }

  @action
  void setPageNumber(int value) {
    pageNumber = 0;
  }

  @action
  void setName(String value) {
    name = value;
    setPageNumber(0);
  }

  @action
  void setProgram(Program p) {
    program = p;
    setPageNumber(0);
  }

  @action
  void setInterestedInGender(InterestedInGender gender) {
    interestedInGender = gender;
  }

  @action
  void clearFilters() {
    setPageNumber(0);
    program = Program.none;
    yearOfJoin = null;
    interestedInGender = InterestedInGender.both;
  }

  @action
  void setFilters(
      {required InterestedInGender gender,
      required int? year,
      required Program p}) {
    interestedInGender = gender;
    yearOfJoin = year;
    program = p;
    setPageNumber(0);
  }
}
