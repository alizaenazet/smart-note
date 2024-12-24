import 'package:flutter/material.dart';
import 'package:smart_note/data/response/api_response.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';
import 'package:smart_note/repository/note_repo.dart';

class DashboardViewModel with ChangeNotifier {
  final _noteRepo = NoteRepository();

  ApiResponse<List<Note>> _notes = ApiResponse<List<Note>>.notStarted();
  ApiResponse<List<Note>> get notes => _notes;

  Future<void> getUserNotes(String userId) async {
    _notes = ApiResponse<List<Note>>.loading();
    notifyListeners();
    try {
      final notes = await _noteRepo.getNotesByUserId(userId);
      _notes = ApiResponse.completed(notes);
    } catch (e) {
      _notes = ApiResponse<List<Note>>.error(e.toString());
    }
    notifyListeners();
  }
}
