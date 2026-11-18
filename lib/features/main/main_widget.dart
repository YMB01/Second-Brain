import 'package:flutter/material.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 8),
        child: Row(
          children: [
            for (var index = 0; index < 3; index++)
              Expanded(
                child: _TabButton(
                  index: index,
                  selected: selectedIndex == index,
                  onTap: () => onDestinationSelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final bool selected;
  final VoidCallback onTap;

  static const _labels = ['Today', 'Habit', 'More'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final foreground = selected ? colors.primary : colors.onSurfaceVariant;
    final largeText = MediaQuery.textScalerOf(context).scale(12) > 18;

    return Semantics(
      label: _labels[index],
      button: true,
      selected: selected,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        excludeFromSemantics: true,
        child: ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              heightFactor: 1,
              child: Ink(
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: largeText ? 4 : 18,
                  vertical: 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index == 1)
                      CustomPaint(
                        size: const Size(24, 24),
                        painter: _SproutPainter(foreground),
                      )
                    else
                      Icon(
                        index == 0
                            ? (selected
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outlined)
                            : Icons.more_horiz,
                        size: 24,
                        color: foreground,
                      ),
                    const SizedBox(height: 3),
                    Text(
                      _labels[index],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: foreground,
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vector sprout matching the reference without adding an icon dependency.
class _SproutPainter extends CustomPainter {
  const _SproutPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(12, 22)
      ..cubicTo(12, 15, 13, 10, 19, 5)
      ..moveTo(13, 14)
      ..cubicTo(11, 7, 17, 3, 22, 3)
      ..cubicTo(22, 9, 19, 14, 13, 14)
      ..moveTo(12, 18)
      ..cubicTo(12, 12, 7, 8, 2, 8)
      ..cubicTo(2, 14, 6, 18, 12, 18)
      ..moveTo(6, 12)
      ..lineTo(12, 18);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SproutPainter oldDelegate) => color != oldDelegate.color;
}
