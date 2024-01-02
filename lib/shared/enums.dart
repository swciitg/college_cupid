enum Program {
  // TODO: change this accordingly
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

  const Program(this.displayString, this.databaseString, this.rollNumberCode,
      this.numberOfYears);
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
  female("Female", "FEMALE");

  final String displayString;
  final String databaseString;

  const Gender(this.displayString, this.databaseString);
}
