import 'dart:ffi';

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

  Future <dynamic> createNote(String userId) async {
    dynamic response = await NetworkApiServices().postApiResponse('/notes', {
      'user_id': userId,
      'title': 'New Note',
      'content': 'No content',
      'icon': 'iconName',
    });
    debugPrint('Response: $response');
    return response;
  }

  Future<Note> getNoteById(String noteId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('note/$noteId');
      Note note = Note.fromMap(response);
      debugPrint('CASTING NOTE By ID: $note');
      return note;
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

  Future updateNote(Note note) async {
    try {
      dynamic response = await _apiServices.putApiResponse('notes/${note.id}',
          note.toMap(), queryParams: {"title": note.title,"content": note.content,"icon": note.icon});
      Note updatedNote = Note.fromMap(response);
      debugPrint('CASTING NOTE: $updatedNote');
      return updatedNote;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }


  Future createTodo(String noteId, String text, bool isFinished) async {
    try {
      dynamic response = await _apiServices.postApiResponse('notes/$noteId/todos',
          {"text": text, "is_finished": isFinished});
      return response;
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }
}
