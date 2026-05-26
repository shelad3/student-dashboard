import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../../models/note_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notes_provider.dart';

class NoteReaderScreen extends StatefulWidget {
  final Note note;

  const NoteReaderScreen({super.key, required this.note});

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late QuillController _controller;
  late bool _isTeacher;
  final _highlights = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    try {
      final delta = jsonDecode(widget.note.content);
      final doc = Document.fromJson(delta as List<dynamic>);
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (_) {
      _controller = QuillController(
        document: Document()..insert(0, widget.note.content),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    _isTeacher = context.read<AuthProvider>().isTeacher;

    try {
      final raw = jsonDecode(widget.note.teacherHighlightsJson);
      if (raw is List) {
        _highlights.addAll(raw.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextSelected() {
    final sel = _controller.selection;
    if (!sel.isValid || sel.isCollapsed) return;

    if (_isTeacher) {
      _showTeacherHighlightDialog(sel);
    } else {
      _showStudentNoteDialog(sel);
    }
  }

  void _showTeacherHighlightDialog(TextSelection sel) {
    final colors = [
      '#FFEB3B', '#4CAF50', '#FF9800', '#2196F3', '#FF5722',
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Teacher Highlight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select highlight color:'),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: colors.map((c) {
                final color = Color(int.parse(c.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () {
                    context.read<NotesProvider>().saveTeacherHighlight(
                      widget.note.noteId,
                      {
                        'index': sel.start,
                        'length': sel.end - sel.start,
                        'color': c,
                        'dateToBeTaught':
                            DateTime.now().toIso8601String().split('T')[0],
                      },
                    );
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showStudentNoteDialog(TextSelection sel) {
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Personal Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selected text (${sel.end - sel.start} chars)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(
                hintText: 'Your personal note...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final auth = context.read<AuthProvider>();
              context.read<NotesProvider>().saveStudentNote(
                widget.note.noteId,
                auth.currentUser!.uid,
                {
                  'index': sel.start,
                  'length': sel.end - sel.start,
                  'note': noteCtrl.text,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              Navigator.pop(ctx);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note.title)),
      body: Column(
        children: [
          if (_highlights.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.amber.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Teacher highlights:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  ..._highlights.map((h) => Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '• ${h['dateToBeTaught'] ?? 'No date'} — ${h['length']} chars',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade800),
                    ),
                  )),
                ],
              ),
            ),
          Expanded(
            child: GestureDetector(
              onLongPress: _onTextSelected,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: const QuillEditorConfig(
                    showCursor: false,
                    placeholder: 'No content',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _onTextSelected,
        child: Icon(_isTeacher ? Icons.highlight : Icons.edit_note),
      ),
    );
  }
}
