import 'package:flutter/material.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';
import 'package:smart_note/repository/note_repo.dart';

class DetailNoteViewModel with ChangeNotifier {
  final _noteRepo = NoteRepository();
  Note _note = Note();
  Note get note => _note;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  bool _isGenerateTasks = false;
  bool get isGenerateTasks => _isGenerateTasks;



  setNote(Note value) {
    _note = value;
    notifyListeners();
  }

  void setNoteStatus(bool status) {
    print('Status: $status');
    _note.isComplete = status;
    notifyListeners();
  }
  void setNoteTitle(String title) {
    debugPrint("New Title: $title");
    _note.title = title;
    debugPrint("_note.title: ${_note.title}");
    notifyListeners();
  }
  void setNoteContent(String content) {
    _note.content = content;
    notifyListeners();
  }

  void setIcon(String icon) {
    _note.icon = icon;
    notifyListeners();
  }
  void updateNote(
    String title,
    String content,
    String icon,
  ) {
    _note.title = title;
    _note.content = content;
    _note.icon = icon;
    notifyListeners();
  }

  Future<void> generateTasks() async {
    if (_note.content == null ||
        _note.content!.isEmpty ||
        _note.content!.length < 5) {
      return;
    }

    _isGenerateTasks = true;
    notifyListeners();
    try {
      final tasks =
          // TODO: CHANGE THE MOCKING NOTE ID TO THE REAL NOTE ID
          await _noteRepo.generateNoteTasks("NOT_121", _note.content!);
      if (_note.todoList == null || _note.todoList!.isEmpty) {
        _note.todoList = tasks;
      } else {
        _note.todoList!.addAll(tasks);
        notifyListeners();
      }

      _isGenerateTasks = false;
      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
      _isGenerateTasks = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String task) async {
    // TODO: Add task to the note in the database by hit the API
    
    // TODO: Add task to the note in the local state
    _note.todoList!.add(Task(
      id: 0,
      todo: task,
      isCompleted: false,
    ));
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    // Delete the tasks from the application locally without hitting the API

  }

  Future<void> saveNote(Note note) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _noteRepo.updateNote(note);
      
    } catch (e) {
      _error = 'Failed to update note: ${e.toString()}';
      debugPrint("Error updating note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> updateTask() async {}
}
