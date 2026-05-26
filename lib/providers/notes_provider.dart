import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  final FirestoreService _firestore;

  NotesProvider(this._firestore);

  List<Note> getNotes({int? lessonId}) =>
      _firestore.getNotes(lessonId: lessonId);

  Note? getNote(String noteId) => _firestore.getNote(noteId);

  void saveTeacherHighlight(String noteId, Map<String, dynamic> highlight) {
    _firestore.saveTeacherHighlight(noteId, highlight);
    notifyListeners();
  }

  void saveStudentNote(String noteId, String userId, Map<String, dynamic> note) {
    _firestore.saveStudentNote(noteId, userId, note);
    notifyListeners();
  }
}
