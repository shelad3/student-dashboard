import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/timetable_model.dart';

class TimetableProvider extends ChangeNotifier {
  final FirestoreService _firestore;

  TimetableProvider(this._firestore);

  List<TimetableEvent> getTimetable({int? lessonId}) =>
      _firestore.getTimetable(lessonId: lessonId);

  void shiftEvent(String eventId, DateTime newTime, String newRoom) {
    _firestore.shiftEvent(eventId, newTime, newRoom);
    notifyListeners();
  }
}
