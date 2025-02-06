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

String getAdmirerCountMessage(int count) {
  if (count <= 0) {
    return "You never know who’s crushing on you from afar :)";
  }
  if (count == 1) {
    return "Someone’s got their eye on you!";
  }
  if (count > 1 && count <= 5) {
    return "A few hearts are beating for you ;)";
  }
  if (count > 5 && count <= 10) {
    return "Crush alert...your fan club is growing!";
  }
  if (count > 10 && count <= 100) {
    return "So many people are crushing on you—feeling the love?";
  }
  return "You are the obsession of many.\nA legend in the making!";
}
