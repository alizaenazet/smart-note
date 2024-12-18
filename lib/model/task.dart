//class sementara

class Task {
  String id;
  String noteId;
  String text;
  bool isFinished;

  Task({
    required this.id,
    required this.noteId,
    required this.text,
    required this.isFinished,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      noteId: json['note_id'] as String,
      text: json['text'] as String,
      isFinished: json['is_finished'] as bool,
    );
  }

  // Method to convert a Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_id': noteId,
      'text': text,
      'is_finished': isFinished,
    };
  }
}