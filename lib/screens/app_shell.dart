import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lesson_drawer.dart';
import 'tabs/timetable_tab.dart';
import 'tabs/global_hub_tab.dart';
import 'tabs/notes_tab.dart';
import 'tabs/profile_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _tabs = [
    (title: 'Schedule', icon: Icons.calendar_month),
    (title: 'Global Hub', icon: Icons.forum),
    (title: 'Notes', icon: Icons.menu_book),
    (title: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lessonProvider.selectedLesson?.name ?? 'Student Dashboard',
        ),
        actions: [
          if (lessonProvider.selectedLesson != null)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(lessonProvider.selectedLesson!.name),
                onDeleted: () => lessonProvider.clearSelection(),
              ),
            ),
        ],
      ),
      drawer: LessonDrawer(
        lessons: lessonProvider.lessons,
        selectedLesson: lessonProvider.selectedLesson,
        onSelect: (l) => lessonProvider.selectLesson(l),
        onClear: () => lessonProvider.clearSelection(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TimetableTab(),
          GlobalHubTab(),
          NotesTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: _tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.title,
                ))
            .toList(),
      ),
    );
  }
}
