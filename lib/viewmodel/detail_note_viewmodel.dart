import 'package:flutter/material.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';
import 'package:smart_note/repository/note_repo.dart';

class DetailNoteViewModel with ChangeNotifier {
  final _noteRepo = NoteRepository();
  Note _note = Note();
  Note get note => _note;

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

  void setNoteContent(String content) {
    _note.content = content;
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

    // TODO: Update note in the database by hit the API
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
}
