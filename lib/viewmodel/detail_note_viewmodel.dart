import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';
import 'package:smart_note/repository/note_repo.dart';
import 'package:smart_note/repository/todo_repo.dart';

class DetailNoteViewModel with ChangeNotifier {
  final _noteRepo = NoteRepository();
  final _todoRepo = ToDoRepository();

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

  Future<void> refetchNote() async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedNote = await _noteRepo.getNoteById(_note.id!);
      debugPrint("updatedNote in refetchNote: " + updatedNote.toString());
      _note = updatedNote;
    } catch (e) {
      _error = 'Failed to fetch note: ${e.toString()}';
      debugPrint("Error fetching note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
          await _noteRepo.generateNoteTasks(_note.id!, _note.content!);
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

  Future<void> setTasks(List<Task> tasks) async {
    _note.todoList = tasks;
    notifyListeners();
  }

  Future<void> addTask(
      String noteId, String taskContent, bool isCompleted) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create a new task
      final newTask = Task(
        todo: taskContent,
        isCompleted: isCompleted,
      );

      // Initialize todoList if null
      if (_note.todoList == null) {
        _note.todoList = [];
      }

      // Add to local state first for immediate UI update
      _note.todoList!.add(newTask);
      notifyListeners();

      // Update in backend
      await _noteRepo.createTodo(noteId, taskContent, isCompleted);

      // Refresh note data from server to get the updated task with ID
      final updatedNote = await _noteRepo.getNoteById(noteId);
      _note = updatedNote;
    } catch (e) {
      _error = 'Failed to add task: ${e.toString()}';
      debugPrint("Error adding task: $e");

      // Rollback the local change if server update failed
      if (_note.todoList != null && _note.todoList!.isNotEmpty) {
        _note.todoList!.removeLast();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> updateTask(
      String noteId, String todoId, String title, bool isFinished) async {
    try {
      await _todoRepo.updateTodo(noteId, todoId, title, isFinished);
    } catch (e) {
      _error = 'Failed to update task: ${e.toString()}';
      debugPrint("Error updating task: $e");
    }
  }

  Future<void> deleteTask(String noteId, String todoId) async {
    try {
      debugPrint("Delete note id: $noteId, todo id: $todoId");
      await _todoRepo.deleteTodo(noteId, todoId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete task: ${e.toString()}';
      debugPrint("Error deleting task: $e");
    }
  }
}
