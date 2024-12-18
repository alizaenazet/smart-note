//class sementara 
import 'package:flutter/material.dart';
import 'package:smart_note/model/task.dart';

class Note {
  String id;
  String title;
  String content;
  String updatedAt;
  bool isComplete;
  List<Task> tasks;
  String icon;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    required this.isComplete,
    required this.tasks,
    this.icon = 'Gardening',
  });

  // Add a task to the note
  void addTask(Task task) {
    tasks.add(task);
  }

  // Remove a task from the note
  void removeTask(Task task) {
    tasks.remove(task);
  }

  // Update a task's completion status
  void updateTaskStatus(Task task, bool isCompleted) {
    task.isFinished = isCompleted;
  }

   factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      updatedAt: json['updated_at'] as String,
      isComplete: json['is_complete'] as bool,
      tasks: (json['tasks'] as List<dynamic>).map((taskJson) => Task.fromJson(taskJson)).toList(),
       icon: json['icon'] as String? ?? 'Gardening',
    );
  }

  // Method to convert a Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updated_at': updatedAt,
      'is_complete': isComplete,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'icon': icon,
    };
  }
}


