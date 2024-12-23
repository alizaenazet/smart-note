//class sementara karna backend blm selesai spy ga error viewnya
import 'package:flutter/material.dart';
import 'package:smart_note/model/task.dart';

class Note {
  final String id;
  final String title;
  final String description;
  final String date;
  final List<Task> tasks;
  final IconData icon;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.tasks,
    required this.icon,
  });

  bool get isCompleted {
    return tasks.every((task) => task.isCompleted);
  }

  List<Task> getCompletedTasks() {
    return tasks.where((task) => task.isCompleted).toList();
  }
}
