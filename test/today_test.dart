import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_brain/features/today/today_page.dart';

void main() {
  testWidgets(
    'Today formats the local date and refreshes at midnight and on resume',
    (tester) async {
      var now = DateTime(2026, 11, 18, 23, 59, 59);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TodayPage(now: () => now)),
        ),
      );

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Wednesday, Nov 18, 2026'), findsOneWidget);
      expect(find.bySemanticsLabel('Calendar'), findsOneWidget);
      expect(find.bySemanticsLabel('Inbox'), findsOneWidget);

      now = DateTime(2026, 11, 19);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Thursday, Nov 19, 2026'), findsOneWidget);

      final changeLifecycle = tester.binding.handleAppLifecycleStateChanged;
      changeLifecycle(AppLifecycleState.inactive);
      changeLifecycle(AppLifecycleState.hidden);
      changeLifecycle(AppLifecycleState.paused);
      now = DateTime(2026, 12, 1);
      changeLifecycle(AppLifecycleState.hidden);
      changeLifecycle(AppLifecycleState.inactive);
      changeLifecycle(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('Tuesday, Dec 1, 2026'), findsOneWidget);
    },
  );
}
