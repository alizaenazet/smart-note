import 'package:flutter/material.dart';
import 'package:smart_note/data/network/netwrok_api_services.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';

class NoteRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Note>> getNotesByUserId(String userId) async {
    try {
      dynamic response = await _apiServices
          .getApiResponse('notes', queryParams: {'user_id': userId});
      List<Note> notes = [];
      debugPrint('\n🔥🔥\n🔥🔥🔥\n🔥 response Notes Fetch: $response');

      notes = (response as List<dynamic>).map((e) => Note.fromMap(e)).toList();

      debugPrint('CASTING NOTES: $notes');
      return notes;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }

  Future<List<Task>> generateNoteTasks(String noteId, String note) async {
    try {
      dynamic response = await _apiServices
          .postApiResponse('notes/$noteId/generate-todos', {"note": note});
      List<Task> tasks = [];
      debugPrint('\n🔥🔥\n🔥🔥🔥\n🔥 response Tasks Fetch: $response');

      tasks = (response as List<dynamic>).map((e) => Task.fromMap(e)).toList();

      debugPrint('\n\n🚨🚨🚨\n🚨🚨\n🚨CASTING TASKS: $tasks');
      return tasks;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }
}
