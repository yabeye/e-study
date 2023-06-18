import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'exceptions.dart';

class ApiProvider {
  static String publicUrl = "https://e-study-api.vercel.app/";
  static String baseUrl = "${publicUrl}api/";
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final completeUri = Uri.parse(baseUrl + url);
      final response = await http.get(completeUri);

      responseJson = _response(response);
    } on FetchDataException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(
    String url,
    Object? body,
  ) async {
    var responseJson;
    try {
      final SharedPreferences pref = await prefs;
      String? token = (pref.getString('token'));
      // print("Token sis $token");

      final completeUri = Uri.parse(baseUrl + url);
      final response =
          await http.post(completeUri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer ${token ?? ""}",
      });
      responseJson = _response(response);
    } on FetchDataException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String url, Object? body) async {
    var responseJson;
    try {
      final SharedPreferences pref = await prefs;
      String? token = (pref.getString('token'));
      debugPrint("Path token is:  ${token}");

      final completeUri = Uri.parse(baseUrl + url);

      final response =
          await http.patch(completeUri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer ${token ?? ""}",
      });
      responseJson = _response(response);
    } on FetchDataException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var responseJson;
    try {
      final SharedPreferences pref = await prefs;
      String? token = (pref.getString('token'));

      final completeUri = Uri.parse(baseUrl + url);

      final response = await http.delete(completeUri, headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer ${token ?? ""}",
      });
      responseJson = _response(response);
    } on FetchDataException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    var responseJson = json.decode(response.body.toString());

    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());

        throw BadRequestException(responseJson['error']['message'].toString());
      case 401:
      case 403:
        throw UnAuthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
