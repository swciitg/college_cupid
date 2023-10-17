class PersonalInfo {
  late String name;
  late String profilePicUrl;
  late String gender;
  late String email;
  late String hashedPassword;
  late String bio;
  late String yearOfStudy;
  late String program;
  late String encryptedPrivateKey;
  late String publicKey;
  late List<String> interests;
  late List<String> encryptedCrushes;
  late List<String> crushes;
  late List<String> matches;

  PersonalInfo(
      {required this.name,
      required this.profilePicUrl,
      required this.gender,
      required this.email,
      required this.hashedPassword,
      required this.bio,
      required this.yearOfStudy,
      required this.program,
      required this.encryptedPrivateKey,
      required this.publicKey,
      required this.interests,
      required this.crushes,
      required this.encryptedCrushes,
      required this.matches});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicUrl = json['profilePicUrl'];
    gender = json['gender'];
    email = json['email'];
    hashedPassword = json['hashedPassword'];
    bio = json['bio'];
    yearOfStudy = json['yearOfStudy'];
    program = json['program'];
    encryptedPrivateKey = json['encryptedPrivateKey'];
    publicKey = json['publicKey'];
    interests = json['interests'].cast<String>();
    encryptedCrushes = json['encryptedCrushes'].cast<String>();
    crushes = json['crushes'].cast<String>();
    matches = json['matches'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profilePicUrl'] = profilePicUrl;
    data['gender'] = gender;
    data['email'] = email;
    data['hashedPassword'] = hashedPassword;
    data['bio'] = bio;
    data['yearOfStudy'] = yearOfStudy;
    data['program'] = program;
    data['encryptedPrivateKey'] = encryptedPrivateKey;
    data['publicKey'] = publicKey;
    data['interests'] = interests;
    data['encryptedCrushes'] = encryptedCrushes;
    data['crushes'] = crushes;
    data['matches'] = matches;
    return data;
  }
}
