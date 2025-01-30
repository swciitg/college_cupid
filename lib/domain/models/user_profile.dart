import 'package:college_cupid/shared/enums.dart';

class UserProfile {
  String name;
  Gender? gender;
  String email;
  String publicKey;
  String bio;
  int? yearOfJoin;
  Program? program;
  List<String> interests;
  SexualOrientationModel? sexualOrientation;
  RelationshipGoal? relationshipGoals;
  List<ImageModel> images;

  UserProfile({
    this.name = '',
    this.gender,
    this.email = '',
    this.bio = '',
    this.yearOfJoin,
    this.program,
    this.publicKey = '',
    this.interests = const [],
    this.sexualOrientation,
    this.images = const [],
    this.relationshipGoals,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      gender: Gender.fromDatabaseString(json['gender']),
      email: json['email'],
      bio: json['bio'],
      yearOfJoin: json['yearOfJoin'],
      program: Program.fromDatabaseString(json['program']),
      publicKey: json['publicKey'],
      interests: json['interests'].cast<String>(),
      sexualOrientation: json['sexualOrientation'] != null
          ? SexualOrientationModel.fromJson(json['sexualOrientation'])
          : null,
      images: (json['profilePicUrls'] as List? ?? []).map((e) => ImageModel.fromJson(e)).toList(),
      relationshipGoals: json['relationshipGoals'] != null
          ? RelationshipGoal.fromJson(json['relationshipGoals'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender?.databaseString;
    data['email'] = email;
    data['bio'] = bio;
    data['yearOfJoin'] = yearOfJoin;
    data['program'] = program?.databaseString;
    data['publicKey'] = publicKey;
    data['interests'] = interests;
    data['sexualOrientation'] = sexualOrientation?.toJson();
    data['profilePicUrls'] = images.map((e) => e.toJson()).toList();
    data['relationshipGoals'] = relationshipGoals?.toJson();
    return data;
  }

  UserProfile copyWith({
    String? name,
    String? profilePicUrl,
    Gender? gender,
    String? email,
    String? bio,
    int? yearOfJoin,
    Program? program,
    String? publicKey,
    List<String>? interests,
    SexualOrientationModel? sexualOrientation,
    RelationshipGoal? relationshipGoals,
    List<ImageModel>? images,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      yearOfJoin: yearOfJoin ?? this.yearOfJoin,
      program: program ?? this.program,
      publicKey: publicKey ?? this.publicKey,
      interests: interests ?? this.interests,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      relationshipGoals: relationshipGoals ?? this.relationshipGoals,
      images: images ?? this.images,
    );
  }
}

class SexualOrientationModel {
  final SexualOrientation type;
  final bool display;

  SexualOrientationModel({
    required this.type,
    required this.display,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type.databaseString;
    data['display'] = display;
    return data;
  }

  SexualOrientationModel.fromJson(Map<String, dynamic> json)
      : type = SexualOrientation.values
            .firstWhere((element) => element.databaseString == json['type']),
        display = json['display'];

  SexualOrientationModel copyWith({
    SexualOrientation? type,
    bool? display,
  }) {
    return SexualOrientationModel(
      type: type ?? this.type,
      display: display ?? this.display,
    );
  }
}

class ImageModel {
  final String url;
  final String? blurHash;

  ImageModel({
    required this.url,
    this.blurHash,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Url'] = url;
    data['blurHash'] = blurHash;
    return data;
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['Url'] ?? "",
      blurHash: json['blurHash'],
    );
  }
}

class RelationshipGoal {
  final LookingFor goal;
  final bool display;

  RelationshipGoal({
    required this.goal,
    required this.display,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['goal'] = goal.databaseString;
    data['display'] = display;
    return data;
  }

  factory RelationshipGoal.fromJson(Map<String, dynamic> json) {
    return RelationshipGoal(
      goal: LookingFor.fromDatabaseString(json['goal']),
      display: json['display'],
    );
  }

  RelationshipGoal copyWith({
    LookingFor? goal,
    bool? display,
  }) {
    return RelationshipGoal(
      goal: goal ?? this.goal,
      display: display ?? this.display,
    );
  }
}
