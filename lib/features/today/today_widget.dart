import 'package:flutter/material.dart';

import '../../core/widgets/sprout_icon.dart';

typedef _SampleTask = ({
  String title,
  String time,
  String category,
  String priority,
  bool done,
});

class TodayDashboard extends StatelessWidget {
  const TodayDashboard({super.key});

  // Preview data for the dashboard. Nothing here is persisted or editable.
  static const _overdue = [
    (
      title: 'Finish project proposal',
      time: 'Yesterday',
      category: 'Work',
      priority: 'High',
      done: false,
    ),
  ];
  static const _today = [
    (
      title: 'Morning journal',
      time: '8:00 AM',
      category: 'Self-care',
      priority: 'Low',
      done: true,
    ),
    (
      title: 'Team standup',
      time: '10:00 AM',
      category: 'Work',
      priority: 'Medium',
      done: false,
    ),
    (
      title: 'Review product feedback',
      time: '12:30 PM',
      category: 'Product',
      priority: 'High',
      done: false,
    ),
    (
      title: 'Water the plants',
      time: '1:00 PM',
      category: 'Home',
      priority: 'Low',
      done: true,
    ),
    (
      title: 'Plan tomorrow',
      time: '4:30 PM',
      category: 'Planning',
      priority: 'Low',
      done: true,
    ),
    (
      title: 'Read for 30 minutes',
      time: '7:00 PM',
      category: 'Learning',
      priority: 'Low',
      done: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final completed = _today.where((task) => task.done).length;
    final total = _overdue.length + _today.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DailyProgress(completed: completed, total: total),
        const SizedBox(height: 16),
        const _FocusCard(),
        const SizedBox(height: 16),
        _TaskSection(title: 'Overdue', tasks: _overdue, overdue: true),
        const SizedBox(height: 16),
        _TaskSection(title: 'Tasks', tasks: _today),
        const SizedBox(height: 16),
        const _SectionHeading(title: 'Habits', count: 2),
        const SizedBox(height: 8),
        const _HabitTile(
          title: 'Drink a glass of water',
          recurrence: 'Daily',
          icon: Icons.water_drop_outlined,
        ),
        const SizedBox(height: 4),
        const _HabitTile(
          title: 'Take a 20-minute walk',
          recurrence: 'Weekdays',
          icon: Icons.directions_walk_outlined,
        ),
      ],
    );
  }
}

class _DailyProgress extends StatelessWidget {
  const _DailyProgress({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = completed / total;
    final percentage = '${(progress * 100).round()}%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$completed of $total completed',
                style: theme.textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              percentage,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: colors.outlineVariant,
          color: colors.primary,
          semanticsLabel: 'Daily task progress',
          semanticsValue: percentage,
        ),
      ],
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard();

  static const _score = 72;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final summary = Row(
      children: [
        ExcludeSemantics(
          child: SizedBox.square(
            dimension: 48,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _score / 100,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  backgroundColor: colors.outlineVariant,
                  color: colors.primary,
                ),
                Center(
                  child: SproutIcon(color: colors.onSurfaceVariant, size: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Score',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Text.rich(
                TextSpan(
                  text: '$_score',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: ' / 100',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                semanticsLabel: '$_score out of 100',
              ),
            ],
          ),
        ),
      ],
    );
    final quote = Text(
      'A focused day builds a sharper mind.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(
              colors.primary.withValues(alpha: 0.06),
              colors.surface,
            ),
            Color.alphaBlend(
              colors.primary.withValues(alpha: 0.13),
              colors.surface,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final largeText = MediaQuery.textScalerOf(context).scale(14) > 21;
            if (constraints.maxWidth < 280 || largeText) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [summary, const SizedBox(height: 8), quote],
              );
            }
            return Row(
              children: [
                Expanded(child: summary),
                Container(
                  height: 36,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: colors.outlineVariant,
                ),
                Expanded(child: quote),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.count,
    this.overdue = false,
  });

  final String title;
  final int count;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: overdue
                  ? colors.errorContainer
                  : colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                '$count',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: overdue
                      ? colors.onErrorContainer
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.title,
    required this.tasks,
    this.overdue = false,
  });

  final String title;
  final List<_SampleTask> tasks;
  final bool overdue;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _SectionHeading(title: title, count: tasks.length, overdue: overdue),
      for (final task in tasks) ...[
        const SizedBox(height: 4),
        _TaskTile(task: task, overdue: overdue),
      ],
    ],
  );
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.overdue});

  final _SampleTask task;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final priorityColor = switch ((overdue, task.priority)) {
      (true, _) => colors.error,
      (_, 'High') => dark ? const Color(0xFFFFAE70) : const Color(0xFFC26423),
      (_, 'Medium') => dark ? const Color(0xFFF4CD73) : const Color(0xFFAD780E),
      _ => dark ? const Color(0xFF8CCB91) : const Color(0xFF438447),
    };
    return _DashboardTile(
      tint: overdue ? colors.error : (task.done ? colors.primary : null),
      leading: SizedBox.square(
        dimension: 26,
        child: Checkbox(
          value: task.done,
          onChanged: null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: colors.onSurfaceVariant, width: 1.5),
          fillColor: WidgetStatePropertyAll(
            task.done ? colors.primary : Colors.transparent,
          ),
          checkColor: colors.onPrimary,
          semanticLabel: task.done ? 'Completed' : 'Incomplete',
        ),
      ),
      title: task.title,
      completed: task.done,
      trailing: task.done
          ? null
          : Icon(
              Icons.circle,
              size: 9,
              color: priorityColor,
              semanticLabel: '${task.priority} priority',
            ),
      details: [
        _TileDetail(
          icon: Icons.schedule_outlined,
          label: task.time,
          color: overdue ? colors.error : colors.onSurfaceVariant,
        ),
        _TileDetail(icon: Icons.folder_outlined, label: task.category),
      ],
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.title,
    required this.recurrence,
    required this.icon,
  });

  final String title;
  final String recurrence;
  final IconData icon;

  @override
  Widget build(BuildContext context) => _DashboardTile(
    leading: SizedBox.square(
      dimension: 26,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    ),
    title: title,
    details: [_TileDetail(icon: Icons.repeat, label: recurrence)],
  );
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.leading,
    required this.title,
    required this.details,
    this.completed = false,
    this.tint,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final List<Widget> details;
  final bool completed;
  final Color? tint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          tint?.withValues(alpha: 0.07) ?? Colors.transparent,
          colors.surfaceContainerLow,
        ),
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: completed
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(spacing: 10, runSpacing: 3, children: details),
              ],
            ),
          ),
          if (trailing case final indicator?) ...[
            const SizedBox(width: 10),
            indicator,
          ],
        ],
      ),
    );
  }
}

class _TileDetail extends StatelessWidget {
  const _TileDetail({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = color ?? theme.colorScheme.onSurfaceVariant;
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: 13, color: foreground),
          ),
          TextSpan(text: ' $label'),
        ],
      ),
      style: theme.textTheme.bodySmall?.copyWith(color: foreground),
    );
  }
}

class TodayQuickAdd extends StatelessWidget {
  const TodayQuickAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: null,
      heroTag: null,
      tooltip: 'Quick Add',
      shape: const CircleBorder(),
      elevation: 4,
      disabledElevation: 4,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      child: const Icon(Icons.add, size: 30),
    );
  }
}
