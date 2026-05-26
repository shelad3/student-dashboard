import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import 'app_shell.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  const TeacherAssignmentScreen({super.key});

  @override
  State<TeacherAssignmentScreen> createState() =>
      _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen> {
  final Set<int> _selected = {};
  final _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final lessons = _firestore.getLessons();

    return Scaffold(
      appBar: AppBar(title: Text('Assign Your Lessons')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the lessons you teach:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              'You can select multiple subjects.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: lessons.length,
                separatorBuilder: (_, _) => Divider(),
                itemBuilder: (_, i) {
                  final lesson = lessons[i];
                  final selected = _selected.contains(lesson.id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.check,
                        color: selected ? Colors.white : Colors.transparent,
                      ),
                    ),
                    title: Text(lesson.name),
                    subtitle: Text('Lesson ${lesson.id}'),
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(lesson.id);
                        } else {
                          _selected.add(lesson.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () {
                        context.read<AuthProvider>().completeFirstLogin();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppShell(),
                          ),
                        );
                      },
                child: Text('Save & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
