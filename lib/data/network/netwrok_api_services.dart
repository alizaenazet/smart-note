import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_note/data/network/base_api_services.dart';
import 'package:smart_note/shared/shared.dart';

import '../app_exception.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices implements BaseApiServices {
  Future<dynamic> _handleApiCall(
    Future<http.Response> Function() apiCall,
    String endpoint,
    String method,
  ) async {
    try {
      debugPrint('\n\n🛜🛜🛜\n$method API SERVICE CALLED');
      final response = await apiCall();
      debugPrint('Response [$endpoint]: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Api not responding');
    } catch (e) {
      debugPrint('\n\n🛜🛜🛜\nERROR: $e');
      throw FetchDataException(e.toString());
    }
  }

  @override
  Future deleteApiResponse(String endpoint) async {
    final uri = Uri.https(Const.smartNoteBaseUrl, endpoint);
    return _handleApiCall(
      () => http.delete(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json',
        },
      ),
      endpoint,
      'DELETE',
    );
  }

  @override
  Future getApiResponse(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    final queryParamsWithKey = {
      ...?queryParams,
    };
    final uri = Uri.https(
        Const.smartNoteBaseUrl, endpoint, queryParamsWithKey);
    return _handleApiCall(
      () => http.get(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json',
        },
      ),
      endpoint,
      'GET',
    );
  }

  @override
  Future postApiResponse(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParams}) async {
    final queryParamsWithKey = {
      ...?queryParams,
    };
    final uri =
        Uri.https(Const.smartNoteBaseUrl, endpoint, queryParamsWithKey);
    return _handleApiCall(
      () => http.post(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      ),
      endpoint,
      'POST',
    );
  }

  @override
  Future putApiResponse(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParams}) async {
    final queryParamsWithKey = {
      ...?queryParams,
    };
    final uri =
        Uri.https(Const.smartNoteBaseUrl, endpoint, queryParamsWithKey);
    return _handleApiCall(
      () => http.put(
        uri,
        headers: const <String, String>{
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      ),
      endpoint,
      'PUT',
    );
  }

  dynamic _returnResponse(http.Response response) {
    try {
      final responseJson = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
        case 201:
          return responseJson;
        case 400:
          throw BadRequestException(response.body.toString());
        case 404:
        case 500:
          throw UnauthorisedException(response.body.toString());
        default:
          throw FetchDataException(
              'Error occurred while communicating with server');
      }
    } on FormatException {
      throw FetchDataException('Invalid JSON response');
    }
  }
}