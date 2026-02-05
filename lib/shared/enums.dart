import 'dart:math';

enum Program {
  none("Select", null, null, null),
  bTech("B.Tech", "BTECH", 0, 4),
  bDes("B.Des", "BDES", 0, 4),
  mTech("M.Tech", "MTECH", 4, 2),
  mDes("M.Des", "MDES", 4, 2),
  mba("MBA", "MBA", 4, 2),
  ma("MA", "MA", 2, 2),
  mSc("MSc", "MSC", 2, 2),
  dualPhD("PhD (Dual)", "DUALPHD", 6, 5),
  phD("PhD", "PHD", 6, 5);

  final String displayString;
  final String? databaseString;
  final int? rollNumberCode;
  final int? numberOfYears;

  const Program(this.displayString, this.databaseString, this.rollNumberCode, this.numberOfYears);

  static Program fromDatabaseString(String databaseString) {
    final program =
        Program.values.firstWhere((e) => e.databaseString == databaseString, orElse: () {
      return Program.none;
    });
    return program;
  }
}

enum InterestedInGender {
  boys("Boys", "MALE"),
  girls("Girls", "FEMALE"),
  both("Both", null);

  final String displayString;
  final String? databaseString;

  const InterestedInGender(this.displayString, this.databaseString);
}

enum Zodiac {
  aries("Aries", "ARIES"),
  taurus("Taurus", "TAURUS"),
  gemini("Gemini", "GEMINI"),
  cancer("Cancer", "CANCER"),
  leo("Leo", "LEO"),
  virgo("Virgo", "VIRGO"),
  libra("Libra", "LIBRA"),
  scorpio("Scorpio", "SCORPIO"),
  sagittarius("Sagittarius", "SAGITTARIUS"),
  capricorn("Capricorn", "CAPRICORN"),
  aquarius("Aquarius", "AQUARIUS"),
  pisces("Pisces", "PISCES");

  final String displayString;
  final String databaseString;

  const Zodiac(this.displayString, this.databaseString);

  static Zodiac fromDatabaseString(String databaseString) {
    final zodiac = Zodiac.values.firstWhere((e) => e.databaseString == databaseString, orElse: () {
      return Zodiac.aries;
    });
    return zodiac;
  }
}

enum Gender {
  male("Male", "MALE"),
  female("Female", "FEMALE"),
  nonBinary("Non-binary", "NONBINARY");

  final String displayString;
  final String databaseString;

  const Gender(this.displayString, this.databaseString);

  static Gender fromDatabaseString(String databaseString) {
    final gender = Gender.values.firstWhere((e) => e.databaseString == databaseString, orElse: () {
      return Gender.male;
    });
    return gender;
  }
}

enum SexualOrientation {
  straight("Straight", "STRAIGHT"),
  bisexual("Bisexual", "BISEXUAL"),
  lesbian("Lesbian", "LESBIAN"),
  gay("Gay", "GAY"),
  others("Others", "OTHERS");

  final String displayString;
  final String databaseString;

  const SexualOrientation(this.displayString, this.databaseString);

  Gender? preferredGender(Gender gender) {
    switch (this) {
      case gay:
        return Gender.male;
      case lesbian:
        return Gender.female;
      case straight:
        return gender == Gender.male ? Gender.female : Gender.male;
      default:
        // Not that simple
        return null;
    }
  }

  static SexualOrientation fromDatabaseString(String databaseString) {
    final orientation =
        SexualOrientation.values.firstWhere((e) => e.databaseString == databaseString, orElse: () {
      return SexualOrientation.straight;
    });
    return orientation;
  }
}

enum LookingFor {
  longTermPartner("Long term", "LONG TERM"),
  shortTermFun("Short term", "SHORT TERM"),
  longTermOpenToShort("Casual", "CASUAL"),
  newFriends("Not looking to date", "NOT LOOOKING TO DATE"),
  shortTermOpenToLong("Casual- Open to long term", "CASUAL - OPEN TO LONG TERM");

  final String displayString;
  final String databaseString;

  const LookingFor(this.displayString, this.databaseString);

  static LookingFor fromDatabaseString(String databaseString) {
    final orientation =
        LookingFor.values.firstWhere((e) => e.databaseString == databaseString, orElse: () {
      return LookingFor.longTermPartner;
    });
    return orientation;
  }
}

enum QuestionCategory {
  energy,
  mind,
  nature,
  tactics,
}

enum PersonalityType {
  enfj, // Extraverted, Intuitive, Feeling, Judging
  enfp, // Extraverted, Intuitive, Feeling, Prospecting
  entj, // Extraverted, Intuitive, Thinking, Judging
  entp, // Extraverted, Intuitive, Thinking, Prospecting
  esfj, // Extraverted, Observant, Feeling, Judging
  esfp, // Extraverted, Observant, Feeling, Prospecting
  estj, // Extraverted, Observant, Thinking, Judging
  estp, // Extraverted, Observant, Thinking, Prospecting
  infj, // Introverted, Intuitive, Feeling, Judging
  infp, // Introverted, Intuitive, Feeling, Prospecting
  intj, // Introverted, Intuitive, Thinking, Judging
  intp, // Introverted, Intuitive, Thinking, Prospecting
  isfj, // Introverted, Observant, Feeling, Judging
  isfp, // Introverted, Observant, Feeling, Prospecting
  istj, // Introverted, Observant, Thinking, Judging
  istp; // Introverted, Observant, Thinking, Prospecting

  const PersonalityType();

  static PersonalityType fromString(String value) {
    return PersonalityType.values.firstWhere((e) => e.name == value);
  }

  static PersonalityType random() {
    final random = Random();
    return PersonalityType.values[
      random.nextInt(PersonalityType.values.length)
    ];
  }
}
