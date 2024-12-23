import 'package:flutter/material.dart';
import 'package:smart_note/model/note.dart';
import 'package:smart_note/model/task.dart';

class DashboardViewModel with ChangeNotifier {
  List<Note> notes = [
    Note(
        id: "1",
        title: "tes-1",
        description: "descipition-tes",
        date: DateTime.now().toString(),
        tasks: [
          Task(
            description: "task 1",
          )
        ],
        icon: Icons.note),
    Note(
        id: "2",
        title: "tes-2",
        description: "descipition-tes",
        date: DateTime.now().toString(),
        tasks: [Task(description: "task 2", isCompleted: true)],
        icon: Icons.note),
  ];
}
