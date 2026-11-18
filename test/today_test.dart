import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_brain/features/main/main_widget.dart';
import 'package:second_brain/features/today/today_page.dart';
import 'package:second_brain/main.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      '${brightness.name} dashboard scrolls above the fixed navigation',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        final platform = tester.platformDispatcher;
        platform.platformBrightnessTestValue = brightness;
        platform.textScaleFactorTestValue = 2;
        addTearDown(tester.view.reset);
        addTearDown(platform.clearPlatformBrightnessTestValue);
        addTearDown(platform.clearTextScaleFactorTestValue);

        await tester.pumpWidget(const MyApp(themeMode: ThemeMode.system));
        await tester.pumpAndSettle();
        final nav = find.byType(MainBottomNavigation);
        final quickAdd = find.byType(FloatingActionButton);
        final navPosition = tester.getTopLeft(nav);
        final quickAddPosition = tester.getTopLeft(quickAdd);

        final checks = tester.widgetList<Checkbox>(find.byType(Checkbox));
        final completed = checks.where((check) => check.value == true).length;
        expect(checks, hasLength(7));
        expect(completed, 3);
        expect(
          find.text('$completed of ${checks.length} completed'),
          findsOneWidget,
        );
        expect(find.text('43%'), findsOneWidget);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          closeTo(completed / checks.length, 0.001),
        );
        expect(
          tester
              .widget<CircularProgressIndicator>(
                find.byType(CircularProgressIndicator),
              )
              .value,
          0.72,
        );
        expect(checks.every((check) => check.onChanged == null), isTrue);
        expect(tester.widget<FloatingActionButton>(quickAdd).onPressed, isNull);
        expect(find.text('Overdue'), findsOneWidget);
        expect(find.text('Tasks'), findsOneWidget);
        final priorityDots = find.byIcon(Icons.circle);
        expect(priorityDots, findsNWidgets(4));
        expect(
          find.textContaining('priority', findRichText: true),
          findsNothing,
        );
        expect(
          tester.getCenter(priorityDots.first).dx,
          greaterThan(
            tester.getCenter(find.text('Finish project proposal')).dx,
          ),
        );

        await tester.scrollUntilVisible(
          find.text('Take a 20-minute walk'),
          240,
          scrollable: find.byType(Scrollable),
        );
        expect(find.text('Habits'), findsOneWidget);
        expect(
          find.textContaining('Weekdays', findRichText: true),
          findsOneWidget,
        );
        expect(tester.getTopLeft(nav), navPosition);
        expect(tester.getTopLeft(quickAdd), quickAddPosition);
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Habit'));
        await tester.pumpAndSettle();
        expect(find.text('Habit placeholder'), findsOneWidget);
        expect(quickAdd, findsNothing);
      },
    );
  }

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
