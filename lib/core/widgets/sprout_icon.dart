import 'package:flutter/material.dart';

class SproutIcon extends StatelessWidget {
  const SproutIcon({super.key, required this.color, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _SproutPainter(color));
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
