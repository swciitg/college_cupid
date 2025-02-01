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
  gay("Gay", "GAY"),
  lesbian("Lesbian", "LESBIAN"),
  bisexual("Bisexual", "BISEXUAL"),
  asexual("Asexual", "ASEXUAL"),
  demiSexual("Demi-sexual", "DEMISEXUAL"),
  pansexual("Pansexual", "PANSEXUAL"),
  queer("Queer", "QUEER"),
  stillFiguringItOut("Still figuring it out", "STILLFIGURINGITOUT");

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
  longTermPartner("Long-Term Partner", "LONGTERMPARTNER"),
  shortTermFun("Short-Term Fun", "SHORTTERMFUN"),
  longTermOpenToShort("Long-Term, Open to Short", "LONGTERM_OPENTOSHORT"),
  newFriends("New Friends", "NEWFRIENDS"),
  shortTermOpenToLong("Short-Term, Open to Long", "SHORTTERM_OPENTOLONG"),
  stillFiguringItOut("Still Figuring It Out", "STILLFIGURINGITOUT");

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
}
