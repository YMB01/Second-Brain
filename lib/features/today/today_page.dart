import 'dart:async';

import 'package:flutter/material.dart';

import 'today_widget.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key, this.now = DateTime.now});

  final DateTime Function() now;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late final AppLifecycleListener _lifecycle;
  late DateTime _date;
  Timer? _refreshTimer;

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    final now = widget.now().toLocal();
    _date = DateUtils.dateOnly(now);
    _scheduleRefresh(now);
    _lifecycle = AppLifecycleListener(onResume: _refreshDate);
  }

  void _refreshDate() {
    final now = widget.now().toLocal();
    final date = DateUtils.dateOnly(now);
    if (date != _date) {
      setState(() => _date = date);
    }
    _scheduleRefresh(now);
  }

  void _scheduleRefresh(DateTime now) {
    _refreshTimer?.cancel();
    // Construct the next local calendar day so DST can change the day's length.
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final untilMidnight = midnight.difference(now);
    // Recheck the clock while active in case its time or time zone changes.
    const clockCheckInterval = Duration(minutes: 1);
    _refreshTimer = Timer(
      untilMidnight < clockCheckInterval ? untilMidnight : clockCheckInterval,
      _refreshDate,
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dateLabel =
        '${_weekdays[_date.weekday - 1]}, ${_months[_date.month - 1]} '
        '${_date.day}, ${_date.year}';

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildScrollContent(theme, colors, dateLabel),
        const PositionedDirectional(
          end: 16,
          bottom: 16,
          child: TodayQuickAdd(),
        ),
      ],
    );
  }

  Widget _buildScrollContent(
    ThemeData theme,
    ColorScheme colors,
    String dateLabel,
  ) {
    return SingleChildScrollView(
      key: const PageStorageKey('today-dashboard'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme, colors, dateLabel),
              const SizedBox(height: 16),
              const TodayDashboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colors, String dateLabel) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 48,
            end: 0,
            width: 248,
            height: 86,
            child: IgnorePointer(
              child: CustomPaint(painter: _HeaderWaves(colors.primary)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/second_brain_icon.png',
                      width: 24,
                      height: 24,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Second Brain',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const _HeaderIcon(_HeaderGlyph.calendar),
                  const _HeaderIcon(_HeaderGlyph.inbox),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(
                header: true,
                child: Text(
                  'Today',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colors.onSurface,
                    fontFamily: 'serif',
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateLabel,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _HeaderGlyph { calendar, inbox }

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon(this.glyph);

  final _HeaderGlyph glyph;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 48,
    child: Semantics(
      label: glyph == _HeaderGlyph.calendar ? 'Calendar' : 'Inbox',
      child: Center(
        child: CustomPaint(
          size: const Size.square(24),
          painter: _HeaderIconPainter(
            glyph,
            Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}

class _HeaderIconPainter extends CustomPainter {
  const _HeaderIconPainter(this.glyph, this.color);

  final _HeaderGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (glyph == _HeaderGlyph.calendar) {
      canvas.drawRRect(
        RRect.fromLTRBR(3, 4, 21, 21, const Radius.circular(2.5)),
        stroke,
      );
      canvas.drawLine(const Offset(3, 9), const Offset(21, 9), stroke);
      canvas.drawLine(const Offset(8, 2), const Offset(8, 6), stroke);
      canvas.drawLine(const Offset(16, 2), const Offset(16, 6), stroke);
      canvas.drawCircle(const Offset(15, 13), 0.85, Paint()..color = color);
    } else {
      final tray = Path()
        ..moveTo(2.5, 12.5)
        ..lineTo(6, 5)
        ..quadraticBezierTo(6.5, 4, 8, 4)
        ..lineTo(16, 4)
        ..quadraticBezierTo(17.5, 4, 18, 5)
        ..lineTo(21.5, 12.5)
        ..lineTo(21.5, 18)
        ..quadraticBezierTo(21.5, 20.5, 19, 20.5)
        ..lineTo(5, 20.5)
        ..quadraticBezierTo(2.5, 20.5, 2.5, 18)
        ..close()
        ..moveTo(2.5, 13)
        ..lineTo(8, 13)
        ..lineTo(10, 16)
        ..lineTo(14, 16)
        ..lineTo(16, 13)
        ..lineTo(21.5, 13);
      canvas.drawPath(tray, stroke);
    }
  }

  @override
  bool shouldRepaint(_HeaderIconPainter oldDelegate) =>
      glyph != oldDelegate.glyph || color != oldDelegate.color;
}

class _HeaderWaves extends CustomPainter {
  const _HeaderWaves(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 248, size.height / 86);
    final back = Path()
      ..moveTo(0, 52)
      ..cubicTo(42, 48, 79, 39, 113, 18)
      ..cubicTo(152, -6, 172, 39, 211, 29)
      ..quadraticBezierTo(225, 24, 248, 19)
      ..lineTo(248, 86)
      ..lineTo(0, 86)
      ..close();
    final front = Path()
      ..moveTo(0, 73)
      ..cubicTo(56, 71, 107, 64, 148, 44)
      ..cubicTo(192, 22, 215, 37, 248, 47)
      ..lineTo(248, 86)
      ..lineTo(0, 86)
      ..close();
    final bounds = const Rect.fromLTWH(0, 0, 248, 86);
    canvas.drawPath(
      back,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.17), color.withValues(alpha: 0)],
        ).createShader(bounds),
    );
    canvas.drawPath(
      front,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.24), color.withValues(alpha: 0)],
        ).createShader(bounds),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HeaderWaves oldDelegate) => color != oldDelegate.color;
}
