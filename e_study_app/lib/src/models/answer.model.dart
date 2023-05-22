// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_study_app/src/models/user.model.dart';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toJson());

class Answer {
  String id;
  String question;
  User answeredBy;
  String content;
  DateTime createdAt;
  List<String> voteCount;
  bool isActive;
  List<User> reportedBy;
  Answer({
    required this.id,
    required this.question,
    required this.answeredBy,
    required this.content,
    required this.createdAt,
    required this.voteCount,
    required this.isActive,
    required this.reportedBy,
  });

  Answer copyWith({
    String? id,
    String? question,
    User? answeredBy,
    String? content,
    DateTime? createdAt,
    List<String>? voteCount,
    bool? isActive,
    List<User>? reportedBy,
  }) {
    return Answer(
      id: id ?? this.id,
      question: question ?? this.question,
      answeredBy: answeredBy ?? this.answeredBy,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      voteCount: voteCount ?? this.voteCount,
      isActive: isActive ?? this.isActive,
      reportedBy: reportedBy ?? this.reportedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answeredBy': answeredBy.toJson(),
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'voteCount': voteCount,
      'isActive': isActive,
      'reportedBy': reportedBy.map((x) => x.toJson()).toList(),
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      answeredBy: User.fromJson(map['answeredBy']),
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      voteCount: List<String>.from(map['voteCount']),
      isActive: map['isActive'] ?? false,
      reportedBy:
          List<User>.from(map['reportedBy']?.map((x) => User.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Answer.fromJson(String source) => Answer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Answer(id: $id, question: $question, answeredBy: $answeredBy, content: $content, createdAt: $createdAt, voteCount: $voteCount, isActive: $isActive, reportedBy: $reportedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Answer &&
        other.id == id &&
        other.question == question &&
        other.answeredBy == answeredBy &&
        other.content == content &&
        other.createdAt == createdAt &&
        listEquals(other.voteCount, voteCount) &&
        other.isActive == isActive &&
        listEquals(other.reportedBy, reportedBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        answeredBy.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        voteCount.hashCode ^
        isActive.hashCode ^
        reportedBy.hashCode;
  }
}
