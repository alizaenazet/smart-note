import 'package:flutter/material.dart';
import 'package:smart_note/model/note.dart';

class DetailNoteViewModel with ChangeNotifier {
  Note _note = Note();
  Note get note => _note;

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
}
