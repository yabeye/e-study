import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

class ApiProvider {
  final String _baseUrl = "";

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
      final completeUri = Uri.parse(_baseUrl + url);
      final response =
          await http.post(completeUri, body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' +
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0NWU1N2FlMDM3ZmM3NTI1YzgwNGI3ZSIsImlhdCI6MTY4MzkwNjc4NCwiZXhwIjoxNzAxOTA2Nzg0fQ.IlzDDrBktQL5DKuZM94uSrk-t7-f8RXmgZzzf7CIwxc',
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
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
