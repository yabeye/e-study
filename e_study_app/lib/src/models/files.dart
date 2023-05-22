import 'dart:convert';

import 'package:e_study_app/src/models/user.model.dart';

class FileModel {
  String? id;
  String name;
  String size;
  String category;
  User uploadedBy;
  DateTime createdAt;
  FileModel({
    this.id,
    required this.name,
    required this.size,
    required this.category,
    required this.uploadedBy,
    required this.createdAt,
  });

  FileModel copyWith({
    String? id,
    String? name,
    String? size,
    String? category,
    User? uploadedBy,
    DateTime? createdAt,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      category: category ?? this.category,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'category': category,
      'uploadedBy': uploadedBy.toJson(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      name: map['name'] ?? '',
      size: map['size'] ?? '',
      category: map['category'] ?? '',
      uploadedBy: User.fromJson(map['uploadedBy']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FileModel(id: $id, name: $name, size: $size, category: $category, uploadedBy: $uploadedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileModel &&
        other.id == id &&
        other.name == name &&
        other.size == size &&
        other.category == category &&
        other.uploadedBy == uploadedBy &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        size.hashCode ^
        category.hashCode ^
        uploadedBy.hashCode ^
        createdAt.hashCode;
  }
}
