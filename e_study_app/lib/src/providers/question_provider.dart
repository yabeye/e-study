import 'dart:convert';

import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/files.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:http/http.dart' as http;

import '../api/api_provider.dart';
import '../common/constants.dart';
import '../models/user.model.dart';

class QuestionProvider extends ChangeNotifier {
  final _provider = ApiProvider();
  List<Question> questions = [];
  List<FileModel> files = [
    FileModel(
      name: "2012 Biology Model Exam for Bethelehem Secondary School",
      size: "22MB",
      category: categories[1],
      uploadedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "liya",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      createdAt: DateTime.now(),
    ),
    FileModel(
      name: "Math Note on Trigonometry",
      size: "12MB",
      category: categories[3],
      uploadedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "dimond",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      createdAt: DateTime.now(),
    ),
    FileModel(
      name: "2010 Mathematics Model Exam for Bethelehem Secondary School",
      size: "55MB",
      category: categories[3],
      uploadedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "yeabsera",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      createdAt: DateTime.now(),
    ),
    FileModel(
      name: "2014 Grade 12 National Civics Exam Preparation test",
      size: "5MB",
      category: categories[2],
      uploadedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "abel",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      createdAt: DateTime.now(),
    ),
  ];

  Future<void> getQuestions() async {
    final response = await _provider.get("questions/all");
    final resQuestions = response['data']['questions'];
    clear();
    for (int i = 0; i < resQuestions.length; i++) {
      questions.add(Question.fromJson(resQuestions[i]));
    }
    notifyListeners();
  }

  Future<void> addNewQuestions({
    required String title,
    required String description,
    required String category,
    required String subject,
  }) async {
    await _provider.post("questions/ask", {
      "title": title,
      "description": description,
      "category": category,
      "subject": subject,
    });
  }

  Future<Answer> addAnswer({
    required String id,
    required String content,
  }) async {
    final response = await _provider.post("answers/$id", {
      "content": content,
    });
    final resQuestions = response['data']['answer'];

    return Answer.fromJson(resQuestions);
  }

  Future<Question> voteQuestion({required String id, bool? voting}) async {
    final response = await _provider.patch("questions/$id", {
      "voting": voting,
    });

    final resQuestions = response['data']['question'];

    await getQuestions();

    return Question.fromJson(resQuestions);
  }

  void clear() {
    questions = [];
    notifyListeners();
  }
}
