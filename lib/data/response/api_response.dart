import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_note/data/app_exception.dart';

import './status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading()
      : status = Status.loading,
        data = null,
        message = null;
  ApiResponse.notStarted()
      : status = Status.notStarted,
        data = null,
        message = null;
  ApiResponse.completed(this.data)
      : status = Status.completed,
        message = null;
  ApiResponse.error(this.message)
      : status = Status.error,
        data = null;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
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
