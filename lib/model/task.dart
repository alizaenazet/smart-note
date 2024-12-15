//class sementara karna backend blm selesai spy ga error viewnya
import 'package:smart_note/model/task_status.dart';

class Task {
  final String description;
  bool isCompleted;
  final TaskStatus status;

  Task({
    required this.description,
    this.isCompleted = false, 
    required this.status,
  });
}
