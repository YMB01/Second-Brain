import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_brain/features/main/main_widget.dart';
import 'package:second_brain/features/today/today_page.dart';
import 'package:second_brain/main.dart';

void main() {
  testWidgets('Tabs switch content and keep the bottom bar visible', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(TodayPage), findsOneWidget);

      for (final tab in ['Habit', 'More', 'Today']) {
        await tester.tap(_tabLabel(tab));
        await tester.pumpAndSettle();
        expect(_tabContent(tab), findsOneWidget);
        expect(find.byType(MainBottomNavigation), findsOneWidget);
        for (final label in ['Today', 'Habit', 'More']) {
          expect(_tabLabel(label), findsOneWidget);
          final data = tester
              .getSemantics(
                find.descendant(
                  of: find.byType(MainBottomNavigation),
                  matching: find.bySemanticsLabel(label),
                ),
              )
              .getSemanticsData();
          expect(data.flagsCollection.isButton, isTrue);
          expect(
            data.flagsCollection.isSelected == Tristate.isTrue,
            label == tab,
          );
          expect(data.hasAction(SemanticsAction.tap), isTrue);
        }
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('Root routes hide the bar and restore the selected tab', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Habit'));
    await tester.pumpAndSettle();
    final navigator = Navigator.of(
      tester.element(find.text('Habit placeholder')),
      rootNavigator: true,
    );
    navigator.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Center(child: Text('Test route'))),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Test route'), findsOneWidget);
    expect(find.byType(MainBottomNavigation), findsNothing);

    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Habit placeholder'), findsOneWidget);
    expect(find.byType(MainBottomNavigation), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets(
      '${brightness.name} navigation fits small phones with large text',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(const MyApp(themeMode: ThemeMode.system));

        for (final tab in ['Today', 'Habit', 'More']) {
          await tester.tap(_tabLabel(tab));
          await tester.pumpAndSettle();
          expect(_tabContent(tab), findsOneWidget);
          final target = tester.getSize(
            find.ancestor(of: _tabLabel(tab), matching: find.byType(InkWell)),
          );
          expect(target.width, greaterThanOrEqualTo(48));
          expect(target.height, greaterThanOrEqualTo(48));
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}

Finder _tabLabel(String label) => find.descendant(
  of: find.byType(MainBottomNavigation),
  matching: find.text(label),
);

Finder _tabContent(String tab) =>
    tab == 'Today' ? find.byType(TodayPage) : find.text('$tab placeholder');
