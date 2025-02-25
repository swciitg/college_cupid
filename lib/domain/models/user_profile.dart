import 'dart:developer';

import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:flutter/material.dart';

class UserProfile {
  String name;
  Gender? gender;
  String email;
  String publicKey;
  int? yearOfJoin;
  Program? program;
  List<String> interests;
  SexualOrientationModel? sexualOrientation;
  RelationshipGoal? relationshipGoal;
  List<ImageModel> images;
  PersonalityType? personalityType;
  bool deactivated;
  List<QuizQuestion> surpriseQuiz;

  static const personalityWeight = 30;
  static const interestsWeight = 30;
  static const sexualOrientationWeight = 20;
  static const relationshipGoalsWeight = 20;

  UserProfile({
    this.name = '',
    this.gender,
    this.email = '',
    this.yearOfJoin,
    this.program,
    this.publicKey = '',
    this.interests = const [],
    this.sexualOrientation,
    this.images = const [],
    this.relationshipGoal,
    this.personalityType,
    this.deactivated = false,
    this.surpriseQuiz = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      gender: Gender.fromDatabaseString(json['gender']),
      email: json['email'],
      yearOfJoin: json['yearOfJoin'],
      program: Program.fromDatabaseString(json['program']),
      publicKey: json['publicKey'],
      interests: json['interests'].cast<String>(),
      sexualOrientation: json['sexualOrientation'] != null
          ? SexualOrientationModel.fromJson(json['sexualOrientation'])
          : null,
      images: (json['profilePicUrls'] as List? ?? [])
          .map((e) => ImageModel.fromJson(e))
          .toList(),
      relationshipGoal: json['relationshipGoals'] != null
          ? RelationshipGoal.fromJson(json['relationshipGoals'])
          : null,
      personalityType:
          json['personalityType'] != null && json['personalityType'] != ''
              ? PersonalityType.values.firstWhere(
                  (e) => e.name == json['personalityType'],
                )
              : null,
      deactivated: json['email'] == 'deactivatedUser@iitg.ac.in',
      surpriseQuiz: (json['surpriseQuiz'] as List? ?? [])
          .map((e) => QuizQuestion.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender?.databaseString;
    data['email'] = email;
    data['yearOfJoin'] = yearOfJoin;
    data['program'] = program?.databaseString;
    data['publicKey'] = publicKey;
    data['interests'] = interests;
    data['sexualOrientation'] = sexualOrientation?.toJson();
    data['profilePicUrls'] = images.map((e) => e.toJson()).toList();
    data['relationshipGoals'] = relationshipGoal?.toJson();
    data['personalityType'] = personalityType?.name;
    data['deactivated'] = deactivated;
    data['surpriseQuiz'] = surpriseQuiz.map((e) => e.toJson()).toList();
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
    RelationshipGoal? relationshipGoal,
    List<ImageModel>? images,
    PersonalityType? personalityType,
    bool? deactivated,
    List<QuizQuestion>? surpriseQuiz,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      yearOfJoin: yearOfJoin ?? this.yearOfJoin,
      program: program ?? this.program,
      publicKey: publicKey ?? this.publicKey,
      interests: interests ?? this.interests,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      images: images ?? this.images,
      personalityType: personalityType ?? this.personalityType,
      deactivated: deactivated ?? this.deactivated,
      surpriseQuiz: surpriseQuiz ?? this.surpriseQuiz,
    );
  }

  double? getMatchScore(UserProfile other) {
    if (other.personalityType == null ||
        other.sexualOrientation == null ||
        other.relationshipGoal == null) {
      return null;
    }
    final personalityScore =
        _getPersonalityTypeScore(other.personalityType!.name);
    final sexualOrientationScore =
        _sexualOrientationScore(other.sexualOrientation!.type, other.gender!);
    final relationshipGoalsScore =
        _relationshipGoalsScore(other.relationshipGoal!.goal);
    final interestsScore = _interestsScore(other.interests);
    final totalScore = personalityScore +
        sexualOrientationScore +
        relationshipGoalsScore +
        interestsScore;
    log("Total Score: $totalScore");
    return totalScore;
  }

  double _getPersonalityTypeScore(String personalityType) {
    log("$personalityType vs ${this.personalityType?.name}");
    final myType = this.personalityType?.name ?? '';
    final commonletters = myType
        .split('')
        .where((element) => personalityType.contains(element))
        .length;
    final score = commonletters / 4 * 100;
    final finalScore = score * personalityWeight / 100;
    log("Personality Score: $finalScore");
    return finalScore;
  }

  double _sexualOrientationScore(
      SexualOrientation sexualOrientation, Gender gender) {
    if (this.sexualOrientation == null) return 0;
    log("(${gender.displayString}, ${sexualOrientation.displayString}) vs (${this.gender!.displayString}, ${this.sexualOrientation!.type.displayString})");
    final otherPreferedGender = sexualOrientation.preferredGender(gender);
    final myPreferedGender =
        this.sexualOrientation!.type.preferredGender(this.gender!);
    if (myPreferedGender == null && otherPreferedGender == null) {
      log("Sexual Orientation Score: ${sexualOrientationWeight.toDouble()}");
      return sexualOrientationWeight.toDouble();
    }
    log('Preferred: $otherPreferedGender vs $myPreferedGender');
    if (otherPreferedGender == this.gender && myPreferedGender == gender) {
      log("Sexual Orientation Score: ${sexualOrientationWeight.toDouble()}");
      return sexualOrientationWeight.toDouble();
    }
    log("Sexual Orientation Score: 0");
    return 0;
  }

  double _relationshipGoalsScore(LookingFor goal) {
    if (relationshipGoal == null) return 0;

    if (relationshipGoal!.goal == goal) {
      log("Relationship Goals Score: ${relationshipGoalsWeight.toDouble()}");
      return relationshipGoalsWeight.toDouble();
    }
    log("Relationship Goals Score: 0");
    return 0;
  }

  double _interestsScore(List<String> interests) {
    interests = interests.map((e) {
      final firstSpace = e.indexOf(' ');
      return e.substring(firstSpace + 1);
    }).toList();
    final updatedInterestMap = interestsMap.map((key, value) {
      final updatedValue = value.map((e) {
        final firstSpace = e.indexOf(' ');
        return e.substring(firstSpace + 1);
      }).toList();
      return MapEntry(key, updatedValue);
    });
    final myInterests = this.interests.map((e) {
      final firstSpace = e.indexOf(' ');
      return e.substring(firstSpace + 1);
    }).toList();
    final allCategories = updatedInterestMap.entries.toList();
    final userCategories = <String, List<String>>{};
    final myCategories = <String, List<String>>{};
    for (final interest in interests) {
      final category = allCategories.firstWhere(
        (element) => element.value.contains(interest),
        orElse: () {
          return allCategories.first;
        },
      ).key;
      if (userCategories.containsKey(category)) {
        userCategories[category]!.add(interest);
      } else {
        userCategories[category] = [interest];
      }
    }
    for (final interest in myInterests) {
      final category = allCategories
          .firstWhere((element) => element.value.contains(interest))
          .key;
      if (myCategories.containsKey(category)) {
        myCategories[category]!.add(interest);
      } else {
        myCategories[category] = [interest];
      }
    }

    final commonCategories = userCategories.keys.where(
      (element) => myCategories.keys.contains(element),
    );
    log("Common Categories: $commonCategories");
    final unionLength =
        userCategories.length + myCategories.length - commonCategories.length;

    // half score for common categories
    final categoryScore = (commonCategories.length / unionLength) * (100 / 2);
    log("Category Score: $categoryScore");
    // half score for common interests in common categories
    final eachCategoryPart = 100 / commonCategories.length / 2;
    var interestsScore = 0.0;
    for (var e in commonCategories) {
      final commonInterests = userCategories[e]!
          .where((element) => myCategories[e]!.contains(element));
      final unionLength = userCategories[e]!.length +
          myCategories[e]!.length -
          commonInterests.length;
      interestsScore += commonInterests.length / unionLength * eachCategoryPart;
      log("$e: ${commonInterests.length / unionLength * eachCategoryPart}");
    }
    log("Interests Score: $interestsScore");
    final finalScore = (categoryScore + interestsScore) * interestsWeight / 100;
    log("Final Interests Score: $finalScore");
    return finalScore;
  }

  static Color getColorForMatchScore(int score) {
    // Ensure the score is within the range 0-100
    score = score.clamp(0, 100);

    if (score <= 20) {
      return Colors.red; // Poor match
    } else if (score <= 50) {
      return Colors.orange; // Fair match
    } else if (score <= 80) {
      return Colors.yellow; // Good match
    } else {
      return Colors.green; // Excellent match
    }
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

class QuizQuestion {
  final String question;
  final String answer;

  QuizQuestion({
    required this.question,
    this.answer = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      answer: json['answer'],
    );
  }

  QuizQuestion copyWith({
    String? question,
    String? answer,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
