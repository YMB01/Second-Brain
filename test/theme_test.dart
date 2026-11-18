import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_brain/core/theme/app_theme.dart';
import 'package:second_brain/main.dart';

double contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (a > b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05));
}

void main() {
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    test('${theme.brightness.name} theme has readable text and accents', () {
      final colors = theme.colorScheme;
      for (final background in [
        theme.scaffoldBackgroundColor,
        colors.surface,
        theme.cardTheme.color!,
      ]) {
        expect(
          contrast(colors.onSurface, background),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrast(colors.onSurfaceVariant, background),
          greaterThanOrEqualTo(4.5),
        );
      }
      for (final pair in [
        (colors.primary, colors.onPrimary),
        (colors.primaryContainer, colors.onPrimaryContainer),
        (colors.secondaryContainer, colors.onSecondaryContainer),
        (colors.inversePrimary, colors.onSurface),
        (
          colors.primary,
          Color.alphaBlend(
            colors.primary.withValues(alpha: 0.08),
            colors.surface,
          ),
        ),
      ]) {
        expect(contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
      }
    });
  }

  testWidgets('System theme changes preserve the selected tab', (tester) async {
    final platform = tester.platformDispatcher;
    addTearDown(platform.clearPlatformBrightnessTestValue);
    platform.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(const MyApp());

    ThemeData activeTheme() => Theme.of(tester.element(find.byType(Scaffold)));

    expect(activeTheme().brightness, Brightness.light);
    expect(activeTheme().colorScheme.primary, const Color(0xFF7856D8));
    expect(find.text('Today placeholder'), findsOneWidget);
    await tester.tap(find.text('Habit'));
    await tester.pumpAndSettle();

    platform.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(activeTheme().brightness, Brightness.dark);
    expect(find.text('Habit placeholder'), findsOneWidget);

    platform.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(activeTheme().brightness, Brightness.light);
    expect(find.text('Habit placeholder'), findsOneWidget);
  });
}
