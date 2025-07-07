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
    final double pulse = 1 + 0.08 * sin(angle * 4 + position.y * 0.05);

    const int sides = 5;
    const double radius = 24;

    final Color baseColor = const Color(0xFF1976D2); // Bijvoorbeeld een mooie matte blauw

    // Glow/shadow
    final glowPaint = Paint()
      ..color = baseColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final glowPath = Path();
    for (int i = 0; i < sides; i++) {
      final double theta = (i * 2 * pi / sides) - pi / 2;
      final double x = (radius + 8) * pulse * cos(theta);
      final double y = (radius + 8) * pulse * sin(theta);
      if (i == 0) {
        glowPath.moveTo(x, y);
      } else {
        glowPath.lineTo(x, y);
      }
    }
    glowPath.close();
    canvas.drawPath(glowPath, glowPaint);

    // Vijfhoek zelf
    final paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final double theta = (i * 2 * pi / sides) - pi / 2;
      final double x = radius * pulse * cos(theta);
      final double y = radius * pulse * sin(theta);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

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