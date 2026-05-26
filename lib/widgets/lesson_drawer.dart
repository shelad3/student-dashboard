import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonDrawer extends StatelessWidget {
  final List<Lesson> lessons;
  final Lesson? selectedLesson;
  final void Function(Lesson) onSelect;
  final VoidCallback onClear;

  const LessonDrawer({
    super.key,
    required this.lessons,
    required this.selectedLesson,
    required this.onSelect,
    required this.onClear,
  });

  static const _colors = [
    0xFF4A90D9,
    0xFF7B61FF,
    0xFFE67E22,
    0xFF27AE60,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Lessons',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select a lesson to filter',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.all_inclusive),
              title: Text('All Lessons'),
              selected: selectedLesson == null,
              onTap: () {
                onClear();
                Navigator.pop(context);
              },
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: lessons.asMap().entries.map((entry) {
                  final i = entry.key;
                  final lesson = entry.value;
                  final color = Color(_colors[i % _colors.length]);
                  final isSelected = selectedLesson?.id == lesson.id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Text(
                        lesson.name[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(lesson.name),
                    subtitle: Text('Lesson ${lesson.id}'),
                    selected: isSelected,
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: color)
                        : null,
                    onTap: () {
                      onSelect(lesson);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
