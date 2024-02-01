import 'dart:math';

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

String generateRandomString({required int length}) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

Map<String, int?> getYearOfJoinMap() {
  Map<String, int?> map = {"Select": null};
  int currentYear = DateTime.now().toLocal().year;
  for (int i = 0; i < 10; i++) {
    map[(currentYear - i).toString()] = (currentYear - i) % 100;
  }
  return map;
}

int getYearOfJoinFromRollNumber(String rollNumber) {
  return int.parse(rollNumber.substring(0, 2));
}

List<Program> getProgramListFromRollNumber(String rollNumber) {
  int code = int.parse(rollNumber.substring(2, 3));
  return Program.values
      .where((element) => element.rollNumberCode == code)
      .toList();
}
