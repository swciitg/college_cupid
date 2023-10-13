class UserInfo {
  late String name;
  late String profilePicUrl;
  late String gender;
  late String email;
  late String publicKey;
  late String bio;
  late String yearOfStudy;
  late String program;
  late List<String> interests;

  UserInfo({
    required this.name,
    required this.profilePicUrl,
    required this.gender,
    required this.email,
    required this.bio,
    required this.yearOfStudy,
    required this.program,
    required this.publicKey,
    required this.interests,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicUrl = json['profilePicUrl'];
    gender = json['gender'];
    email = json['email'];
    bio = json['bio'];
    yearOfStudy = json['yearOfStudy'];
    program = json['program'];
    publicKey = json['publicKey'];
    interests = json['interests'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profilePicUrl'] = profilePicUrl;
    data['gender'] = gender;
    data['email'] = email;
    data['bio'] = bio;
    data['yearOfStudy'] = yearOfStudy;
    data['program'] = program;
    data['publicKey'] = publicKey;
    data['interests'] = interests;
    return data;
  }
}
