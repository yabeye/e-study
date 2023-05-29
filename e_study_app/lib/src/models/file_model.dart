// To parse this JSON data, do
//
//     final fileModel = fileModelFromJson(jsonString);

import 'package:e_study_app/src/models/user.model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
  final String id;
  final String name;
  final String category;
  final User uploadedBy;
  final String path;
  final DateTime createdAt;
  final List<dynamic> voteCount;
  final bool isActive;
  final List<dynamic> reportedBy;
  final int v;

  FileModel({
    required this.id,
    required this.name,
    required this.category,
    required this.uploadedBy,
    required this.path,
    required this.createdAt,
    required this.voteCount,
    required this.isActive,
    required this.reportedBy,
    required this.v,
  });

  FileModel copyWith({
    String? id,
    String? name,
    String? category,
    User? uploadedBy,
    String? path,
    DateTime? createdAt,
    List<dynamic>? voteCount,
    bool? isActive,
    List<dynamic>? reportedBy,
    int? v,
  }) =>
      FileModel(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        uploadedBy: uploadedBy ?? this.uploadedBy,
        path: path ?? this.path,
        createdAt: createdAt ?? this.createdAt,
        voteCount: voteCount ?? this.voteCount,
        isActive: isActive ?? this.isActive,
        reportedBy: reportedBy ?? this.reportedBy,
        v: v ?? this.v,
      );

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
        uploadedBy: User.fromJson(json["uploadedBy"]),
        path: json["path"],
        createdAt: DateTime.parse(json["createdAt"]),
        voteCount: List<dynamic>.from(json["voteCount"].map((x) => x)),
        isActive: json["isActive"],
        reportedBy: List<dynamic>.from(json["reportedBy"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "category": category,
        "uploadedBy": uploadedBy,
        "path": path,
        "createdAt": createdAt.toIso8601String(),
        "voteCount": List<dynamic>.from(voteCount.map((x) => x)),
        "isActive": isActive,
        "reportedBy": List<dynamic>.from(reportedBy.map((x) => x)),
        "__v": v,
      };
}
