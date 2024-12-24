import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_note/model/task.dart';

class Note extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final String? updatedAt;
  final String? icon;
  final bool? isComplete;
  final List<Task>? todoList;

  const Note({
    this.id,
    this.title,
    this.content,
    this.updatedAt,
    this.icon,
    this.isComplete,
    this.todoList,
  });

  factory Note.fromMap(Map<String, dynamic> data) => Note(
        id: data['id'] as String?,
        title: data['title'] as String?,
        content: data['content'] as String?,
        updatedAt: data['updatedAt'] as String?,
        icon: data['icon'] as String?,
        isComplete: data['isComplete'] as bool?,
        todoList: (data['todoList'] as List<dynamic>?)
            ?.map((e) => Task.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt,
        'icon': icon,
        'isComplete': isComplete,
        'todoList': todoList?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Note].
  factory Note.fromJson(String data) {
    return Note.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Note] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props {
    return [
      id,
      title,
      content,
      updatedAt,
      icon,
      isComplete,
      todoList,
    ];
  }

  IconData get getIcon {
    switch (icon) {
      case 'work':
        return Icons.work;
      case 'study':
        return Icons.menu_book;
      case 'home':
        return Icons.home;
      case 'others':
        return Icons.category;
      default:
        return Icons.note_alt_outlined;
    }
  }

  bool get isCompleted {
    return todoList!.every((task) => task.isCompleted!);
  }

  List<Task> getCompletedTasks() {
    return todoList!.where((task) => task.isCompleted!).toList();
  }
}
