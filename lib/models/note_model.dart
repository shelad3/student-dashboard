class Note {
  final String noteId;
  final int lessonId;
  final String title;
  final String content;
  final String teacherHighlightsJson;
  final String studentNotesJson;

  const Note({
    required this.noteId,
    required this.lessonId,
    required this.title,
    required this.content,
    this.teacherHighlightsJson = '[]',
    this.studentNotesJson = '{}',
  });
}
