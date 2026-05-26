import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/update_service.dart';
import 'providers/auth_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/timetable_provider.dart';
import 'providers/notes_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/app_shell.dart';
import 'widgets/update_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StudentDashboardApp());
}

class StudentDashboardApp extends StatefulWidget {
  const StudentDashboardApp({super.key});

  @override
  State<StudentDashboardApp> createState() => _StudentDashboardAppState();
}

class _StudentDashboardAppState extends State<StudentDashboardApp> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _updateService = UpdateService();

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    final result = await _updateService.checkForUpdate();
    if (result.hasUpdate && result.info != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => UpdateDialog(info: result.info!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(_authService)),
        ChangeNotifierProvider(
          create: (_) => LessonProvider(_firestoreService),
        ),
        ChangeNotifierProvider(
          create: (_) => TimetableProvider(_firestoreService),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesProvider(_firestoreService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(_firestoreService),
        ),
      ],
      child: MaterialApp(
        title: 'Student Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90D9),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90D9),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: AuthGate(authService: _authService),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  final AuthService authService;

  const AuthGate({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return auth.isLoggedIn ? const AppShell() : const AuthScreen();
  }
}
