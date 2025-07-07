import 'package:flame/components.dart';
import 'dart:math';
import 'package:flutter/material.dart';

//Player klasse
class Player extends PositionComponent {
  Player()
      : super(
          size: Vector2(50, 50),
          position: Vector2(200, 200),
        );

  Vector2 velocity = Vector2(0, 0);
  double angle = 0; // rotatiehoek in radialen

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Sla canvas op en roteer rond het midden
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);

    // Pulsatie-effect op basis van snelheid en tijd
    final double pulse = 1 + 0.10 * sin(angle * 4 + position.y * 0.07);

    // --- Glow ring ---
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.7),
          Colors.transparent,
        ],
        stops: [0.7, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 32));
    canvas.drawCircle(Offset.zero, 32 * pulse, glowPaint);

    // --- Hoofdvorm: een zeshoek met gradient ---
    final int sides = 6;
    final double radius = 22;
    final Path hexPath = Path();
    for (int i = 0; i < sides; i++) {
      final double theta = (i * 2 * pi / sides) - pi / 2;
      final double x = radius * pulse * cos(theta);
      final double y = radius * pulse * sin(theta);
      if (i == 0) {
        hexPath.moveTo(x, y);
      } else {
        hexPath.lineTo(x, y);
      }
    }
    hexPath.close();

    final Paint hexPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.shade800, Colors.cyanAccent.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius * pulse));

    canvas.drawPath(hexPath, hexPaint);

    // --- Neon rand ---
    final Paint borderPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawPath(hexPath, borderPaint);

    // --- Ogen ---
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(-7, -4), 3.2, eyePaint);
    canvas.drawCircle(Offset(7, -4), 3.2, eyePaint);

    // --- Pupillen ---
    final pupilPaint = Paint()..color = Colors.blueGrey.shade900;
    canvas.drawCircle(Offset(-7, -4), 1.3, pupilPaint);
    canvas.drawCircle(Offset(7, -4), 1.3, pupilPaint);

    // --- Mond (smile) ---
    final mouthPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final mouthRect = Rect.fromCenter(center: Offset(0, 7), width: 12, height: 6);
    canvas.drawArc(mouthRect, 0.1, pi - 0.2, false, mouthPaint);

    // --- Accent streepje ---
    final accentPaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.7)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-10, -13), Offset(-2, -17), accentPaint);

    canvas.restore();
  }

  @override
  void update(double dt) {
    velocity.y += 2000 * dt;
    position += velocity * dt;

    // Draai sneller bij hogere verticale snelheid
    angle += velocity.y * dt * 0.005;
  }
}