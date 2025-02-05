class PersonalInfo {
  final String email;
  final List<String> sharedSecretList;
  final List<String> matchedEmailList;

  PersonalInfo({
    required this.email,
    required this.sharedSecretList,
    required this.matchedEmailList,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      email: json['email'],
      sharedSecretList: json['sharedSecretList'].cast<String>(),
      matchedEmailList: json['matchedEmailList'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['sharedSecretList'] = sharedSecretList;
    data['matchedEmailList'] = matchedEmailList;
    return data;
  }
}
