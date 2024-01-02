import 'package:college_cupid/shared/enums.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');
}

Map<String, int?> getYearOfJoinMap() {
  Map<String, int?> map = {"Select": null};
  int currentYear = DateTime.now().toLocal().year;
  for (int i = 0; i < 10; i++) {
    // map.add((currentYear - i).toString());
    map[(currentYear - i).toString()] = (currentYear - i) % 100;
  }
  return map;
}

int getYearOfJoinFromRollNumber(String rollNumber) {
  return int.parse(rollNumber.substring(0, 2));
}

Program getProgramFromRollNumber(String rollNumber) {
  int code = int.parse(rollNumber.substring(2, 3));
  return Program.values.firstWhere((element) => element.rollNumberCode == code);
}
