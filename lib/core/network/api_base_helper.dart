import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_architecture/core/error/app_exceptions.dart';
import 'package:dio/dio.dart';

class ApiBaseHelper {
//  final String _baseUrl = "http://api.themoviedb.org/3/";

  final Dio client;

  ApiBaseHelper({
    @required this.client,
  });

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {var data}) async {
    var responseJson;
    try {
      final response = await client.post(url, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, {var data}) async {
    var responseJson;
    try {
      final response = await client.put(url, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, {var data}) async {
    var responseJson;
    try {
      final response = await client.delete(url, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
