import 'package:flutter_test/flutter_test.dart';
import 'package:student_dashboard/main.dart';

void main() {
  testWidgets('App loads with login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentDashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
