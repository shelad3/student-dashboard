import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/announcement_model.dart';
import '../models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final FirestoreService _firestore;

  ChatProvider(this._firestore);

  List<Announcement> getAnnouncements() => _firestore.getAnnouncements();

  void addAnnouncement(String teacherId, String teacherName, String content) {
    _firestore.addAnnouncement(teacherId, teacherName, content);
    notifyListeners();
  }

  List<ChatMessage> getMessages() => _firestore.getMessages();

  void addMessage(ChatMessage msg) {
    _firestore.addMessage(msg);
    notifyListeners();
  }
}
