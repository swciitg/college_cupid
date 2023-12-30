enum Program {
  bTech("BTECH", 0),
  bDes("BDES", 0),
  mTech("MTECH", 4),
  mDes("MDES", 4),
  mba("MBA", 4),
  ma("MA", 2),
  mSc("MSC", 2),
  dualPhD("DUALPHD", 6),
  phD("PHD", 6);

  final String name;
  final int rollNumberCode;

  const Program(this.name, this.rollNumberCode);
}
