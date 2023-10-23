class PersonalInfo {
  late String email;
  late String publicKey;
  late List<String> crushes;
  late List<String> matches;
  late String hashedPassword;
  late String encryptedPrivateKey;
  late List<String> encryptedCrushes;

  PersonalInfo(
      {required this.email,
      required this.hashedPassword,
      required this.encryptedPrivateKey,
      required this.publicKey,
      required this.crushes,
      required this.encryptedCrushes,
      required this.matches});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    hashedPassword = json['hashedPassword'];
    encryptedPrivateKey = json['encryptedPrivateKey'];
    publicKey = json['publicKey'];
    encryptedCrushes = json['encryptedCrushes'].cast<String>();
    crushes = json['crushes'].cast<String>();
    matches = json['matches'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['hashedPassword'] = hashedPassword;
    data['encryptedPrivateKey'] = encryptedPrivateKey;
    data['publicKey'] = publicKey;
    data['encryptedCrushes'] = encryptedCrushes;
    data['crushes'] = crushes;
    data['matches'] = matches;
    return data;
  }
}
