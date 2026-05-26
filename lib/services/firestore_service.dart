import 'dart:convert';
import '../models/timetable_model.dart';
import '../models/note_model.dart';
import '../models/announcement_model.dart';
import '../models/message_model.dart';
import '../models/lesson.dart';

class FirestoreService {
  final _lessons = [
    const Lesson(id: 1, name: 'Electrical Principles', teacherId: 'tch001'),
    const Lesson(id: 2, name: 'Mathematics', teacherId: 'tch002'),
    const Lesson(id: 3, name: 'Communication Skills', teacherId: 'tch003'),
    const Lesson(id: 4, name: 'Programming', teacherId: 'tch004'),
  ];

  final _timetable = <TimetableEvent>[];
  final _notes = <Note>[];
  final _announcements = <Announcement>[];
  final _messages = <ChatMessage>[];

  FirestoreService() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    for (var i = 0; i < 4; i++) {
      final lessonId = i + 1;
      final days = [1, 3, 5];
      for (final day in days) {
        final date = weekStart.add(Duration(days: day - 1));
        _timetable.add(TimetableEvent(
          eventId: 'evt_${lessonId}_$day',
          lessonId: lessonId,
          originalTime: DateTime(date.year, date.month, date.day, 8 + i * 2),
          currentTime: DateTime(date.year, date.month, date.day, 8 + i * 2),
          isShifted: false,
          roomLocation: 'Room ${100 + lessonId}',
        ));
      }
    }

    _timetable[2] = TimetableEvent(
      eventId: _timetable[2].eventId,
      lessonId: _timetable[2].lessonId,
      originalTime: _timetable[2].originalTime,
      currentTime: _timetable[2].currentTime
          .add(Duration(hours: 2)),
      isShifted: true,
      roomLocation: 'Lab 103',
      shiftReason: 'Room maintenance',
    );

    final noteTitles = [
      ['Topic 1: Circuit Basics', 'Topic 2: Ohm\'s Law', 'Topic 3: Series & Parallel'],
      ['Topic 1: Algebra Review', 'Topic 2: Calculus Intro', 'Topic 3: Trigonometry'],
      ['Topic 1: Report Writing', 'Topic 2: Presentation Skills', 'Topic 3: Group Dynamics'],
      ['Topic 1: Variables & Types', 'Topic 2: Control Flow', 'Topic 3: Functions'],
    ];

    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 3; j++) {
        _notes.add(Note(
          noteId: 'note_${i + 1}_${j + 1}',
          lessonId: i + 1,
          title: noteTitles[i][j],
          content: jsonEncode([
            {'insert': '${noteTitles[i][j]}\n\n'},
            {
              'insert':
                  'This is the core content for this topic. Students should review the key concepts before class.\n\nKey points:\n- Understanding fundamental principles\n- Practical applications in real-world scenarios\n- Common pitfalls and how to avoid them\n\nReference materials are available in the library.',
            },
          ]),
          teacherHighlightsJson: jsonEncode([
            {
              'index': 0,
              'length': 20,
              'color': '#FFEB3B',
              'dateToBeTaught': '2026-06-01',
            }
          ]),
          studentNotesJson: '{}',
        ));
      }
    }

    _announcements.add(Announcement(
      id: 'ann_1',
      teacherId: 'tch001',
      teacherName: 'Dr. Jane Wanjiku',
      content: 'Reminder: Bring your circuit kits for tomorrow\'s practical session.',
      createdAt: now.subtract(Duration(hours: 2)),
    ));

    _messages.addAll([
      ChatMessage(
        id: 'msg_1',
        senderId: 'stu001',
        senderName: 'Alice Mwangi',
        senderRole: 'student',
        content: 'Has anyone completed the assignment?',
        createdAt: now.subtract(Duration(hours: 3)),
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'tch002',
        senderName: 'Mr. Peter Otieno',
        senderRole: 'teacher',
        content: 'Class cancelled tomorrow. Will reschedule.',
        createdAt: now.subtract(Duration(hours: 1)),
      ),
    ]);
  }

  List<Lesson> getLessons() => _lessons;
  Lesson? getLesson(int id) {
    try {
      return _lessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TimetableEvent> getTimetable({int? lessonId}) {
    if (lessonId != null) {
      return _timetable.where((e) => e.lessonId == lessonId).toList();
    }
    return _timetable;
  }

  void shiftEvent(String eventId, DateTime newTime, String newRoom) {
    final idx = _timetable.indexWhere((e) => e.eventId == eventId);
    if (idx == -1) return;
    _timetable[idx] = TimetableEvent(
      eventId: _timetable[idx].eventId,
      lessonId: _timetable[idx].lessonId,
      originalTime: _timetable[idx].originalTime,
      currentTime: newTime,
      isShifted: true,
      roomLocation: newRoom,
      shiftReason: 'Updated by teacher',
    );
  }

  List<Note> getNotes({int? lessonId}) {
    if (lessonId != null) {
      return _notes.where((n) => n.lessonId == lessonId).toList();
    }
    return _notes;
  }

  Note? getNote(String noteId) {
    try {
      return _notes.firstWhere((n) => n.noteId == noteId);
    } catch (_) {
      return null;
    }
  }

  void saveTeacherHighlight(String noteId, Map<String, dynamic> highlight) {
    final idx = _notes.indexWhere((n) => n.noteId == noteId);
    if (idx == -1) return;
    final existing =
        (jsonDecode(_notes[idx].teacherHighlightsJson) as List).toList();
    existing.add(highlight);
    _notes[idx] = Note(
      noteId: _notes[idx].noteId,
      lessonId: _notes[idx].lessonId,
      title: _notes[idx].title,
      content: _notes[idx].content,
      teacherHighlightsJson: jsonEncode(existing),
      studentNotesJson: _notes[idx].studentNotesJson,
    );
  }

  void saveStudentNote(String noteId, String userId, Map<String, dynamic> note) {
    final idx = _notes.indexWhere((n) => n.noteId == noteId);
    if (idx == -1) return;
    final existing =
        jsonDecode(_notes[idx].studentNotesJson) as Map<String, dynamic>;
    existing[userId] = note;
    _notes[idx] = Note(
      noteId: _notes[idx].noteId,
      lessonId: _notes[idx].lessonId,
      title: _notes[idx].title,
      content: _notes[idx].content,
      teacherHighlightsJson: _notes[idx].teacherHighlightsJson,
      studentNotesJson: jsonEncode(existing),
    );
  }

  List<Announcement> getAnnouncements() => List.from(_announcements)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void addAnnouncement(String teacherId, String teacherName, String content) {
    _announcements.insert(
      0,
      Announcement(
        id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
        teacherId: teacherId,
        teacherName: teacherName,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
  }

  List<ChatMessage> getMessages() => List.from(_messages)
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  void addMessage(ChatMessage msg) {
    _messages.add(msg);
  }
}
