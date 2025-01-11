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
  Future deleteApiResponse(String endpoint) async {
    try {
      print("\n\n🛜🛜🛜\nDELETE API SERVICE CALLED");
      final uri = Uri.https(Const.smartNoteBaseUrl, endpoint);
      print("\n\n🛜🛜🛜\nDELETE URI: $uri");
      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Response [$endpoint]: $response');
      return returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Api not responding');
    } catch (e) {
      print("\n\n🛜🛜🛜\nERROR: $e");
      throw FetchDataException(e.toString());
    }
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

      // Debug print to verify the request
      debugPrint('Request URL: $uri');
      debugPrint('Request Body: ${jsonEncode(data)}');

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );
      debugPrint('Response [$endpoint]: $response');

      // Debugging the raw response
    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

      return returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Api not responding');
    }
  }

  @override
  Future putApiResponse(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParams}) async {
    try {
      print("\n\n🛜🛜🛜\nPUT API SERVICE CALLED");
      final queryParamsWithKey = {
        ...?queryParams,
      };
      final uri =
          Uri.https(Const.smartNoteBaseUrl, endpoint, queryParamsWithKey);
    print("\n\n🛜🛜🛜\nPUT URI: $uri");
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: data != null ? jsonEncode(data) : null,
    );
    debugPrint('Response [$endpoint]: $response');
    return returnResponse(response);
  } on SocketException {
    throw NoInternetException('No Internet Connection');
  } on TimeoutException {
    throw FetchDataException('API not responding');
  } catch (e) {
    print("\n\n🛜🛜🛜\nERROR: $e");
    throw FetchDataException(e.toString());
  }
  }


  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
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
