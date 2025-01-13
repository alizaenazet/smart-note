import 'package:flutter/material.dart';
import 'package:smart_note/data/response/api_response.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/repository/note_repo.dart';

class DashboardViewModel with ChangeNotifier {
  final _noteRepo = NoteRepository();

  ApiResponse<List<Note>> _notes = ApiResponse<List<Note>>.notStarted();
  ApiResponse<List<Note>> get notes => _notes;

  ApiResponse<Note> _pickednote = ApiResponse<Note>.notStarted();
  ApiResponse<Note> get pickednote => _pickednote;

  setNotes(ApiResponse<List<Note>> value) {
    _notes = value;
    notifyListeners();
  }

  Future<void> getUserNotes(String userId) async {
    setNotes(ApiResponse.loading());
    // _notes = ApiResponse.loading();
    notifyListeners();
    try {
      final notes = await _noteRepo.getNotesByUserId(userId);
      setNotes(ApiResponse.completed(notes));
    } catch (e) {
      print("ERROR: $e");
      // _notes = ApiResponse<List<Note>>.error(e.toString());
      setNotes(ApiResponse<List<Note>>.error(e.toString()));
      notifyListeners();
    }
  }

  specificNote(ApiResponse<Note> value) {
    _pickednote = value;
    notifyListeners();
  }

  Future <Note> getSpecificUserNote(String noteId) async {
    specificNote(ApiResponse.loading());
    // _notes = ApiResponse.loading();
    notifyListeners();
    try {
      final note = await _noteRepo.getNoteById(noteId);
      specificNote(ApiResponse.completed(note));
      return note;
    } catch (e) {
      print("ERROR: $e");
      // _notes = ApiResponse<List<Note>>.error(e.toString());
      specificNote(ApiResponse<Note>.error(e.toString()));
      notifyListeners();
      return Note();
    }

  }

  // Create Note
  Future createNote(String userId) async {
    final response = await _noteRepo.createNote(userId);
    return response;
  }
}
