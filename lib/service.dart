import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_note/model/task.dart';

class NoteService {
  final String baseUrl = "https://mockapi.example.com";

  // Fetch Notes
  Future<List<dynamic>> fetchNotes(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/notes?user_id=$userId"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load notes");
    }
  }

  // Create Note
  Future<void> createNote(String userId, String title, String content) async {
    final response = await http.post(
      Uri.parse("$baseUrl/notes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "title": title, "content": content}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to create note");
    }
  }

  // Edit Note
  Future<void> editNote(String noteId, String title, String content) async {
    final response = await http.put(
      Uri.parse("$baseUrl/notes/$noteId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "content": content}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to edit note");
    }
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    final response = await http.delete(Uri.parse("$baseUrl/notes/$noteId"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete note");
    }
  }

  Future<Task> createTask(String noteId, String text) async {
    final response = await http.post(
      Uri.parse("$baseUrl/notes/$noteId/todos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": text,
        "is_finished": false,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task(
        id: data['id'],
        noteId: data['note_id'],
        text: data['text'],
        isFinished: data['is_finished'],
      );
    } else {
      throw Exception("Failed to create task");
    }
  }

  // Update Todo (Task)
  Future<Task> updateTask(String noteId, String taskId, bool isFinished) async {
    final response = await http.put(
      Uri.parse("$baseUrl/notes/$noteId/todos/$taskId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": "Updated task", // You can add a field to change text if needed
        "is_finished": isFinished,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task(
        id: data['id'],
        noteId: data['note_id'],
        text: data['text'],
        isFinished: data['is_finished'],
      );
    } else {
      throw Exception("Failed to update task");
    }
  }

  // Delete Todo (Task)
  Future<void> deleteTask(String noteId, String taskId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/notes/$noteId/todos/$taskId"),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
