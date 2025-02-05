import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/shared/enums.dart';

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterState {
  final InterestedInGender interestedInGender;
  final int? yearOfJoin;
  final String name;
  final Program program;

  FilterState({
    this.interestedInGender = InterestedInGender.both,
    this.yearOfJoin,
    this.name = '',
    this.program = Program.none,
  });

  FilterState copyWith({
    InterestedInGender? interestedInGender,
    int? yearOfJoin,
    String? name,
    Program? program,
  }) {
    return FilterState(
      interestedInGender: interestedInGender ?? this.interestedInGender,
      yearOfJoin: yearOfJoin ?? this.yearOfJoin,
      name: name ?? this.name,
      program: program ?? this.program,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void setYearOfJoin(int? year) {
    state = state.copyWith(yearOfJoin: year);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setProgram(Program p) {
    state = state.copyWith(program: p);
  }

  void setInterestedInGender(InterestedInGender gender) {
    state = state.copyWith(interestedInGender: gender);
  }

  void resetStore() {
    state = FilterState();
  }

  void clearFilters() {
    state = state.copyWith(
      program: Program.none,
      yearOfJoin: null,
      interestedInGender: InterestedInGender.both,
    );
  }

  void setFilters({
    required InterestedInGender gender,
    required int? year,
    required Program p,
  }) {
    state = state.copyWith(
      interestedInGender: gender,
      yearOfJoin: year,
      program: p,
    );
  }
}
