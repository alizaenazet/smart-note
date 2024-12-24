import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_note/data/network/base_api_services.dart';
import 'package:smart_note/shared/shared.dart';

import '../app_exception.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices implements BaseApiServices {
  @override
  Future deleteApiResponse(String url) {
    // TODO: implement deleteApiResponse
    throw UnimplementedError();
  }

  @override
  Future getApiResponse(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      print("\n\n🛜🛜🛜\nNETWORK API SERVICE CALLED");
      print(Const.smartNoteBaseUrl);
      final queryParamsWithKey = {
        ...?queryParams,
      };
      debugPrint(
          "\n\n🛜🛜🛜\nENDPOINT: $endpoint $queryParams"); // Executed fine
      final uri = Uri.https(
          Const.smartNoteBaseUrl, endpoint, queryParamsWithKey); // NOT WORKING
      print("\n\n🛜🛜🛜\nURI: $uri");
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Response [$endpoint]: $response');
      return returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Api not responding');
    } catch (e) {
      print("\n\n🛜🛜🛜\nERROR: $e");
      throw FetchDataException(e.toString());
    }
  }

  @override
  Future postApiResponse(String endpoint, data,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final queryParamsWithKey = {
        ...?queryParams,
      };
      final uri =
          Uri.https(Const.smartNoteBaseUrl, endpoint, queryParamsWithKey);
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );
      debugPrint('Response [$endpoint]: $response');
      return returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Api not responding');
    }
  }

  @override
  Future putApiResponse(String url, data) {
    // TODO: implement putApiResponse
    throw UnimplementedError();
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 201:
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicating with server');
    }
  }
}
