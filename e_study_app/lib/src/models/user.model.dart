// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username;
  final String roles;
  final List<String> question;
  final List<String> answer;
  final List<String> bookmarks;
  final String? profilePic;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.roles,
    required this.question,
    required this.answer,
    required this.bookmarks,
    this.profilePic,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? username,
    String? roles,
    List<String>? question,
    List<String>? answer,
    List<String>? bookmarks,
    String? profilePic,
  }) =>
      User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        username: username ?? this.username,
        roles: roles ?? this.roles,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        bookmarks: bookmarks ?? this.bookmarks,
        profilePic: profilePic ?? this.profilePic,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        roles: json["roles"],
        question: List<String>.from(json["question"].map((x) => x)),
        answer: List<String>.from(json["answer"].map((x) => x)),
        bookmarks: List<String>.from(json["bookmarks"].map((x) => x)),
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "username": username,
        "roles": roles,
        "question": List<dynamic>.from(question.map((x) => x)),
        "answer": List<dynamic>.from(answer.map((x) => x)),
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
        "profilePic": profilePic,
      };
}
