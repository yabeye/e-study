// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/user.model.dart';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));
List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isOpen;
  final DateTime createdAt;
  final User askedBy;
  final List<Answer> answers;
  List<String> hashTags;
  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isOpen,
    required this.createdAt,
    required this.askedBy,
    required this.answers,
    this.hashTags = const [],
  });

  Question copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isOpen,
    DateTime? createdAt,
    User? askedBy,
    List<Answer>? answers,
  }) {
    return Question(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isOpen: isOpen ?? this.isOpen,
      createdAt: createdAt ?? this.createdAt,
      askedBy: askedBy ?? this.askedBy,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isOpen': isOpen,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'askedBy': askedBy.toJson(),
      'answers': answers.map((x) => x.toJson()).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      isOpen: map['isOpen'] ?? false,
      createdAt: DateTime.parse(map["createdAt"]),
      askedBy: User.fromJson(map['askedBy']),
      answers:
          List<Answer>.from(map['answers']?.map((x) => Answer.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Question(id: $id, title: $title, description: $description, category: $category, isOpen: $isOpen, createdAt: $createdAt, askedBy: $askedBy, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.isOpen == isOpen &&
        other.createdAt == createdAt &&
        other.askedBy == askedBy &&
        listEquals(other.answers, answers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        isOpen.hashCode ^
        createdAt.hashCode ^
        askedBy.hashCode ^
        answers.hashCode;
  }

  static List<Question> filterQuestions(
      List<Question> allQuestions, String key) {
    List<Question> filteredQuestions = [];
    filteredQuestions =
        allQuestions.where((q) => (q.category == key) || key == "All").toList();
    return filteredQuestions;
  }
}
