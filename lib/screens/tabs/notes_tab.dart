import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/notes_provider.dart';
import '../../widgets/note_list_item.dart';
import '../sub/note_reader_screen.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final notesProvider = context.watch<NotesProvider>();

    final notes = notesProvider.getNotes(
      lessonId: lessonProvider.selectedLesson?.id,
    );

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 48, color: Colors.grey.shade400),
            SizedBox(height: 16),
            Text(
              lessonProvider.selectedLesson == null
                  ? 'Select a lesson from the sidebar'
                  : 'No notes for this lesson',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: notes.length,
      itemBuilder: (_, i) => NoteListItem(
        note: notes[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteReaderScreen(note: notes[i]),
          ),
        ),
      ),
    );
  }
}
