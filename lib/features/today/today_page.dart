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
      child: Column(
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
              _HeaderIcon(
                icon: Icons.calendar_today_outlined,
                label: 'Calendar',
              ),
              _HeaderIcon(icon: Icons.inbox_outlined, label: 'Inbox'),
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
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 48,
    child: Center(
      child: Icon(
        icon,
        semanticLabel: label,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
