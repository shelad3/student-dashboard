class Announcement {
  final String id;
  final String teacherId;
  final String teacherName;
  final String content;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.content,
    required this.createdAt,
  });
}
