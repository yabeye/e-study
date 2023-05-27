import 'dart:convert';

import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_provider.dart';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  final _provider = ApiProvider();
  User? currentUser;
  String? token;
  String emailStore = "";
  String passwordStore = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  get isLoggedIn => token != null;

  checkAuth() async {
    final SharedPreferences pref = await _prefs;

    // debugPrint("==> ${jsonDecode(pref.get('user').toString())}");
    // currentUser = User.fromJson(jsonDecode(pref.get('user').toString()));
    // debugPrint("Current User: $currentUser");
    final json = pref.getString("user");
    if (json == null) return null;

    token = (pref.getString('token'));
    print("Token is $token");
    emailStore = (pref.getString('email')) ?? "";
    passwordStore = (pref.getString('password')) ?? "";
    final map = jsonDecode(json);

    currentUser = User.fromJson(map);

    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final SharedPreferences pref = await _prefs;
    await pref.setString('email', email);
    await pref.setString('password', password);

    emailStore = email;
    passwordStore = password;

    notifyListeners();

    final response = await _provider.post("auth/login", {
      "email": email,
      "password": password,
    });

    token = "Bearer ${response['data']['accessToken']}";
    final userRes = response['data']['user'];
    print("User REs: ${userRes}");
    currentUser = User.fromJson(userRes);
    print("DONE!!!!");

    // print("Toke is $token");
    // print("Current user is $currentUser");

    await pref.setString('token', token!);
    await pref.setString('user', jsonEncode(currentUser));

    notifyListeners();
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await _provider.post("auth/register", {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
    });

    notifyListeners();
    await login(email: email, password: password);
  }

  clear() async {
    currentUser = null;
    token = null;

    final SharedPreferences pref = await _prefs;
    pref.clear();

    notifyListeners();
  }
}
