import 'package:flutter/material.dart';
import 'package:smart_note/data/network/netwrok_api_services.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';

class ToDoRepository {
  final _apiService = NetworkApiServices(); 

  Future createTodo(String noteId, String title, String isFinished) async {
    try{
      dynamic response = await _apiService.postApiResponse('notes/$noteId/todos',
       {
        "text": title,
        "is_finished": isFinished
       }
      );
      return response;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }

  Future updateTodo(String noteId, String todoId, String title, String isFinished) async {
    try{
      dynamic response = await _apiService.putApiResponse('notes/$noteId/todos/$todoId',
       {
        "text": title,
        "is_finished": isFinished
       }
      );
      return response;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }

  Future deleteTodo(String noteId, String todoId) async {
    try{
      dynamic response = await _apiService.deleteApiResponse('notes/$noteId/todos/$todoId');
      return response;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }


}