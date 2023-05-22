import 'dart:convert';

import 'package:e_study_app/src/models/question.model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:http/http.dart' as http;

import '../api/api_provider.dart';

class QuestionProvider extends ChangeNotifier {
  final _provider = ApiProvider();
  List<Question> questions = [];

  Future<void> getQuestions() async {
    final response = await _provider.get("questions/all");
    final resQuestions = response['data']['questions'];
    clear();
    for (int i = 0; i < resQuestions.length; i++) {
      questions.add(Question.fromMap(resQuestions[i]));
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

    await getQuestions();
  }

  void clear() {
    questions = [];
    notifyListeners();
  }
}
