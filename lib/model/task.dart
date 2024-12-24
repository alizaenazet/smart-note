import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String? todo;
  bool? isCompleted;

  Task({this.id, this.todo, this.isCompleted});

  factory Task.fromMap(Map<String, dynamic> data) => Task(
        id: data['id'] as int?,
        todo: data['todo'] as String?,
        isCompleted: data['isCompleted'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'todo': todo,
        'isCompleted': isCompleted,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Task].
  factory Task.fromJson(String data) {
    return Task.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Task] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [id, todo, isCompleted];
}
