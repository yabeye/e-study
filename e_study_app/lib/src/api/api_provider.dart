import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

class ApiProvider {
  final String _baseUrl = "http://192.168.8.100:5100/api/";
  final storage = const FlutterSecureStorage();

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final completeUri = Uri.parse(_baseUrl + url);
      final response = await http.get(completeUri);

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Object? body) async {
    var responseJson;
    try {
      String? token = await storage.read(key: "token");
      print("Token sis $token");

      final completeUri = Uri.parse(_baseUrl + url);
      print("HOST ${completeUri.data}");
      final response =
          await http.post(completeUri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer ${token!}",
      });
      print("REsponse: ${response.body}");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(String url, Object? body) async {
    var responseJson;
    try {
      String? token = await storage.read(key: "token");
      print("Token sis $token");

      final completeUri = Uri.parse(_baseUrl + url);
      print("HOST ${completeUri.data}");
      final response =
          await http.patch(completeUri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': "Bearer ${token!}",
      });
      print("REsponse: ${response.body}");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    var responseJson = json.decode(response.body.toString());
    debugPrint("$responseJson");
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        debugPrint("$responseJson");
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
