// lib/models/billiards_ball.dart
import 'package:flutter/material.dart';

class BilliardsBall {
  final int number;
  final bool isActive;
  final double size;

  BilliardsBall({
    required this.number,
    this.isActive = true,
    this.size = 40,
  });

  // Color map for billiard balls
  static final Map<int, Color> ballColors = {
    1: Color(0xFFFDD835), // Yellow
    2: Color(0xFF1E88E5), // Blue
    3: Color(0xFFE53935), // Red
    4: Color(0xFF7B1FA2), // Purple
    5: Color(0xFFFF9800), // Orange
    6: Color(0xFF2E7D32), // Green
    7: Color(0xFF795548), // Brown
    8: Color(0xFF000000), // Black
  };

  bool get isCue => number == 0;
  bool get isSolid => number >= 1 && number <= 8;
  bool get isStriped => number >= 9 && number <= 15;

  Color get ballColor {
    if (isCue) return Colors.white;
    final int colorNumber = number - (number > 8 ? 8 : 0);
    return ballColors[colorNumber] ?? Colors.white;
  }

  Widget build() {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: _buildBallSvg(),
    );
  }

  Widget _buildBallSvg() {
    return CustomPaint(
      size: Size(size, size),
      painter: BilliardsBallPainter(
        number: number,
        ballColor: ballColor,
        isActive: isActive,
      ),
    );
  }
}

class BilliardsBallPainter extends CustomPainter {
  final int number;
  final Color ballColor;
  final bool isActive;

  BilliardsBallPainter({
    required this.number,
    required this.ballColor,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Ball background (always white for cue/striped, colored for solid)
    final ballPaint = Paint()
      ..color = number >= 9 || number == 0 ? Colors.white : ballColor
      ..style = PaintingStyle.fill;

    // Draw the ball
    canvas.drawCircle(center, radius, ballPaint);

    // For striped balls, draw the stripe
    if (number >= 9 && number <= 15) {
      final stripePaint = Paint()
        ..color = ballColor
        ..style = PaintingStyle.fill;

      // Draw a rectangle for the stripe with clip path to constrain it to the circle
      canvas.save();
      final stripePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius));
      canvas.clipPath(stripePath);

      final stripeRect = Rect.fromLTWH(
        0,
        center.dy - radius * 0.5,
        size.width,
        radius * 1,
      );
      canvas.drawRect(stripeRect, stripePaint);
      canvas.restore();
    }

    // Draw the border
    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw number circle (except for cue ball)
    if (number > 0) {
      final circleRadius = radius * 0.4;
      final circlePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, circleRadius, circlePaint);

      // Draw number text
      final textStyle = TextStyle(
        color: Colors.black,
        fontSize: radius * 0.6,
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(
        text: number.toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final textOffset = Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(BilliardsBallPainter oldDelegate) {
    return oldDelegate.number != number ||
        oldDelegate.ballColor != ballColor ||
        oldDelegate.isActive != isActive;
  }
}
