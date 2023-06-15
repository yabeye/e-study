// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/user.model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  String id;
  String title;
  String description;
  String category;
  String subject;
  bool isOpen;
  DateTime createdAt;
  User askedBy;
  List<dynamic> voteCount;
  List<dynamic> voteCountDown;
  List<Answer> answers;
  bool isActive;
  List<dynamic> reportedBy;
  List<String> hashTags;
  List<String> comments;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subject,
    required this.isOpen,
    required this.createdAt,
    required this.askedBy,
    required this.voteCount,
    required this.voteCountDown,
    required this.answers,
    required this.isActive,
    required this.reportedBy,
    this.hashTags = const [],
    this.comments = const [],
  });

  Question copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? subject,
    bool? isOpen,
    DateTime? createdAt,
    User? askedBy,
    List<dynamic>? voteCount,
    List<dynamic>? voteCountDown,
    List<Answer>? answers,
    bool? isActive,
    List<dynamic>? reportedBy,
    List<String>? comments,
  }) =>
      Question(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        subject: subject ?? this.subject,
        isOpen: isOpen ?? this.isOpen,
        createdAt: createdAt ?? this.createdAt,
        askedBy: askedBy ?? this.askedBy,
        voteCount: voteCount ?? this.voteCount,
        voteCountDown: voteCountDown ?? this.voteCountDown,
        answers: answers ?? this.answers,
        isActive: isActive ?? this.isActive,
        reportedBy: reportedBy ?? this.reportedBy,
        comments: comments ?? this.comments,
      );

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        subject: json["subject"],
        isOpen: json["isOpen"],
        createdAt: DateTime.parse(json["createdAt"]),
        askedBy: User.fromJson(json["askedBy"]),
        voteCount: List<dynamic>.from(json["voteCount"].map((x) => x)),
        voteCountDown: List<dynamic>.from(json["voteCountDown"].map((x) => x)),
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        isActive: json["isActive"],
        reportedBy: List<dynamic>.from(json["reportedBy"].map((x) => x)),
        hashTags: List<String>.from(json["hashTags"].map((x) => x)),
        comments: List<String>.from((json["comments"] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "category": category,
        "subject": subject,
        "isOpen": isOpen,
        "createdAt": createdAt.toIso8601String(),
        "askedBy": askedBy.toJson(),
        "voteCount": List<dynamic>.from(voteCount.map((x) => x)),
        "voteCountDown": List<dynamic>.from(voteCountDown.map((x) => x)),
        "answers": List<dynamic>.from(answers.map((x) => x)),
        "isActive": isActive,
        "reportedBy": List<dynamic>.from(reportedBy.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x)),
      };

  static List<Question> filterQuestions(
      List<Question> allQuestions, String key) {
    List<Question> filteredQuestions = [];
    filteredQuestions =
        allQuestions.where((q) => (q.category == key) || key == "All").toList();
    return filteredQuestions;
  }
}
