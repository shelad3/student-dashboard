class TimetableEvent {
  final String eventId;
  final int lessonId;
  final DateTime originalTime;
  final DateTime currentTime;
  final bool isShifted;
  final String roomLocation;
  final String? shiftReason;

  const TimetableEvent({
    required this.eventId,
    required this.lessonId,
    required this.originalTime,
    required this.currentTime,
    required this.isShifted,
    required this.roomLocation,
    this.shiftReason,
  });
}
