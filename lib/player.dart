import 'package:flame/components.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'skins.dart';

//Player klasse
class Player extends PositionComponent {
  final Skin skin;

  Player({required this.skin})
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

    // --- Glow shape (volgt de vorm van de skin) ---
    final Path glowPath = Path();
    if (skin.icon == Icons.hexagon) {
      const int sides = 6;
      final double radius = 24;
      for (int i = 0; i < sides; i++) {
        final double theta = (i * 2 * pi / sides) - pi / 2;
        final double x = radius * pulse * cos(theta);
        final double y = radius * pulse * sin(theta);
        if (i == 0) {
          glowPath.moveTo(x, y);
        } else {
          glowPath.lineTo(x, y);
        }
      }
      glowPath.close();
    } else if (skin.icon == Icons.star) {
      final double r = 24;
      final double r2 = r / 2.2;
      for (int i = 0; i < 10; i++) {
        final double theta = (i * 2 * pi / 10) - pi / 2;
        final double radius = i.isEven ? r : r2;
        final double x = radius * pulse * cos(theta);
        final double y = radius * pulse * sin(theta);
        if (i == 0) {
          glowPath.moveTo(x, y);
        } else {
          glowPath.lineTo(x, y);
        }
      }
      glowPath.close();
    } else if (skin.icon == Icons.crop_square) {
      final rect = Rect.fromCenter(center: Offset.zero, width: 40 * pulse, height: 40 * pulse);
      glowPath.addRect(rect);
    } else if (skin.icon == Icons.change_history) {
      // Driehoek
      final double r = 24;
      for (int i = 0; i < 3; i++) {
        final double theta = (i * 2 * pi / 3) - pi / 2;
        final double x = r * pulse * cos(theta);
        final double y = r * pulse * sin(theta);
        if (i == 0) {
          glowPath.moveTo(x, y);
        } else {
          glowPath.lineTo(x, y);
        }
      }
      glowPath.close();
    } else {
      // fallback: cirkel
      glowPath.addOval(Rect.fromCircle(center: Offset.zero, radius: 24 * pulse));
    }

    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          skin.color.withOpacity(0.45),
          Colors.transparent,
        ],
        stops: [0.7, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 28 * pulse))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(glowPath, glowPaint);

    // --- Hoofdvorm ---
    final Path shapePath = Path();
    if (skin.icon == Icons.hexagon) {
      const int sides = 6;
      final double radius = 22;
      for (int i = 0; i < sides; i++) {
        final double theta = (i * 2 * pi / sides) - pi / 2;
        final double x = radius * pulse * cos(theta);
        final double y = radius * pulse * sin(theta);
        if (i == 0) {
          shapePath.moveTo(x, y);
        } else {
          shapePath.lineTo(x, y);
        }
      }
      shapePath.close();
    } else if (skin.icon == Icons.crop_square) {
      final rect = Rect.fromCenter(center: Offset.zero, width: 36 * pulse, height: 36 * pulse);
      shapePath.addRect(rect);
    } else if (skin.icon == Icons.change_history) {
      // Driehoek
      final double r = 22;
      for (int i = 0; i < 3; i++) {
        final double theta = (i * 2 * pi / 3) - pi / 2;
        final double x = r * pulse * cos(theta);
        final double y = r * pulse * sin(theta);
        if (i == 0) {
          shapePath.moveTo(x, y);
        } else {
          shapePath.lineTo(x, y);
        }
      }
      shapePath.close();
    } else {
      // fallback: cirkel
      shapePath.addOval(Rect.fromCircle(center: Offset.zero, radius: 22 * pulse));
    }

    final Paint shapePaint = Paint()
      ..shader = LinearGradient(
        colors: [skin.color.withOpacity(0.8), skin.color],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 22 * pulse));

    canvas.drawPath(shapePath, shapePaint);

    // --- Neon rand ---
    final Paint borderPaint = Paint()
      ..color = skin.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawPath(shapePath, borderPaint);

    // --- Gezichtje ---
    final facePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    switch (skin.face) {
      case "smile":
        canvas.drawArc(
          Rect.fromCenter(center: Offset(0, 7), width: 12, height: 6),
          0.1, pi - 0.2, false, facePaint);
        canvas.drawCircle(Offset(-7, -4), 2.5, facePaint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(7, -4), 2.5, facePaint);
        break;
      case "wink":
        canvas.drawArc(
          Rect.fromCenter(center: Offset(0, 7), width: 12, height: 6),
          0.1, pi - 0.2, false, facePaint);
        canvas.drawLine(
          Offset(-9, -4), Offset(-4, -4), facePaint);
        canvas.drawCircle(Offset(7, -4), 2.5, facePaint);
        break;
      case "neutral":
        canvas.drawLine(
          Offset(-6, 8), Offset(6, 8), facePaint);
        canvas.drawCircle(Offset(-7, -4), 2.5, facePaint);
        canvas.drawCircle(Offset(7, -4), 2.5, facePaint);
        break;
      default:
        // fallback: smile
        canvas.drawArc(
          Rect.fromCenter(center: Offset(0, 7), width: 12, height: 6),
          0.1, pi - 0.2, false, facePaint);
        canvas.drawCircle(Offset(-7, -4), 2.5, facePaint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(7, -4), 2.5, facePaint);
    }

    // --- Accent streepje ---
    final accentPaint = Paint()
      ..color = skin.color.withOpacity(0.7)
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