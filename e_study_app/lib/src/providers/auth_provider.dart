import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_provider.dart';

class AuthProvider extends ChangeNotifier {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  final _provider = ApiProvider();
  User? currentUser;
  String? token;

  get isLoggedIn => token != null;

  checkAuth() async {}

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

  void clear() {
    currentUser = null;
    notifyListeners();
  }
}
