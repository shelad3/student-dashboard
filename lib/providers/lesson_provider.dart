import 'package:flutter/foundation.dart';
import '../models/lesson.dart';
import '../services/firestore_service.dart';

class LessonProvider extends ChangeNotifier {
  final FirestoreService _firestore;
  Lesson? _selectedLesson;

  LessonProvider(this._firestore);

  Lesson? get selectedLesson => _selectedLesson;

  List<Lesson> get lessons => _firestore.getLessons();

  void selectLesson(Lesson lesson) {
    _selectedLesson = lesson;
    notifyListeners();
  }

  void clearSelection() {
    _selectedLesson = null;
    notifyListeners();
  }
}
