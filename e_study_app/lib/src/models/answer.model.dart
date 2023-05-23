// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toJson());

class Answer {
  final String id;
  final String question;
  final String answeredBy;
  final String content;
  final DateTime createdAt;
  final List<dynamic> voteCount;
  final bool isActive;
  final List<dynamic> reportedBy;
  final int v;

  Answer({
    required this.id,
    required this.question,
    required this.answeredBy,
    required this.content,
    required this.createdAt,
    required this.voteCount,
    required this.isActive,
    required this.reportedBy,
    required this.v,
  });

  Answer copyWith({
    String? id,
    String? question,
    String? answeredBy,
    String? content,
    DateTime? createdAt,
    List<dynamic>? voteCount,
    bool? isActive,
    List<dynamic>? reportedBy,
    int? v,
  }) =>
      Answer(
        id: id ?? this.id,
        question: question ?? this.question,
        answeredBy: answeredBy ?? this.answeredBy,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        voteCount: voteCount ?? this.voteCount,
        isActive: isActive ?? this.isActive,
        reportedBy: reportedBy ?? this.reportedBy,
        v: v ?? this.v,
      );

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["_id"],
        question: json["question"],
        answeredBy: json["answeredBy"],
        content: json["content"],
        createdAt: DateTime.parse(json["createdAt"]),
        voteCount: List<dynamic>.from(json["voteCount"].map((x) => x)),
        isActive: json["isActive"],
        reportedBy: List<dynamic>.from(json["reportedBy"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "answeredBy": answeredBy,
        "content": content,
        "createdAt": createdAt.toIso8601String(),
        "voteCount": List<dynamic>.from(voteCount.map((x) => x)),
        "isActive": isActive,
        "reportedBy": List<dynamic>.from(reportedBy.map((x) => x)),
        "__v": v,
      };
}
