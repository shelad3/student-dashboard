import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/timetable_provider.dart';
import '../../widgets/timetable_card.dart';

class TimetableTab extends StatelessWidget {
  const TimetableTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final timetableProvider = context.watch<TimetableProvider>();

    final events = timetableProvider.getTimetable(
      lessonId: lessonProvider.selectedLesson?.id,
    );

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 48, color: Colors.grey.shade400),
            SizedBox(height: 16),
            Text('No schedule events for this week'),
          ],
        ),
      );
    }

    final grouped = <String, List>{};
    for (final e in events) {
      final day = DateFormat('EEEE').format(e.currentTime);
      grouped.putIfAbsent(day, () => []).add(e);
    }

    final dayOrder = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    final sortedDays = grouped.keys.toList()
      ..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: sortedDays.expand((day) {
        final dayEvents = grouped[day]!;
        return [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              day,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...dayEvents.map((e) => TimetableCard(event: e)),
        ];
      }).toList(),
    );
  }
}
