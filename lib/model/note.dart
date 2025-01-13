import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_note/model/task.dart';

class Note extends Equatable {
  String? id;
  String? title;
  String? content;
  String? updatedAt;
  String? icon;
  bool? isComplete;
  List<Task>? todoList;

  Note({
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
    if (icon == null) {
      return Icons.help_outline; // Default icon when icon is null
    }
    debugPrint("Icon in getIcon: $icon");
    switch (icon?.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'gardening':
        return Icons.local_florist;
      case 'sports':
        return Icons.sports_soccer;
      case 'cooking':
        return Icons.restaurant;
      case 'study':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      case 'finance':
        return Icons.attach_money;
      default:
        return Icons.note_alt_outlined;
    }
  }

  // String get getIconName {
  //   switch (icon) {
  //     case 'work':
  //       return 'Work';
  //     case 'gardening':
  //       return 'Gardening';
  //     case 'sports':
  //       return 'Sports';
  //     case 'cooking':
  //       return 'Cooking';
  //     case 'study':
  //       return 'Study';
  //     case 'travel':
  //       return 'Travel';
  //     case 'shopping':
  //       return 'Shopping';
  //     case 'health':
  //       return 'Health';
  //     case 'finance':
  //       return 'Finance';
  //     default:
  //       return 'Note';
  //   }
  // }

  bool get isCompleted {
    return todoList!.every((task) => task.isCompleted!);
  }

  List<Task> getCompletedTasks() {
    return todoList!.where((task) => task.isCompleted!).toList();
  }
}
