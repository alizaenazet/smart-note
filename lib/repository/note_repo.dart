import 'package:flutter/material.dart';
import 'package:smart_note/data/network/netwrok_api_services.dart';
import 'package:smart_note/model/note.dart';

class NoteRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Note>> getNotesByUserId(String userId) async {
    try {
      dynamic response = await _apiServices
          .getApiResponse('notes', queryParams: {'user_id': userId});
      List<Note> notes = [];
      debugPrint('response City Fetch: $response');

      notes = (response as List<dynamic>).map((e) => Note.fromMap(e)).toList();

      debugPrint('CASTING NOTES: $notes');
      return notes;
    } catch (e) {
      rethrow;
    }
  }
}
