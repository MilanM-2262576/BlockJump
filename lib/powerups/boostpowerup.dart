import 'powerup.dart';
import '../game.dart'; 
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'dart:math';

class BoostPowerup extends Powerup {
  double timer = 0;

  BoostPowerup(Vector2 position) : super(position);

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double pulse = 0.5 + 0.5 * sin(timer * 5);
    final double float = sin(timer * 2.5) * 3;
    final double arrowWidth = size.x * 0.5;
    final double arrowHeight = size.y * 0.6;
    final double centerX = size.x / 2;
    final double centerY = size.y / 2 + float;

    // Meerdere lagen van gloed voor diepte-effect
    for (int i = 2; i >= 0; i--) {
      final double layerScale = 1.0 + (i * 0.18);
      final double layerOpacity = 0.4 - (i * 0.09);

      final List<Color> colors = [
        Color.fromARGB(255, 238, 255, 0).withOpacity(layerOpacity + pulse * 0.6),
        Color.fromARGB(255, 255, 0, 0).withOpacity(layerOpacity + pulse * 0.6),
      ];

      final Gradient gradient = LinearGradient(
        colors: colors,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

      final Rect rect = Rect.fromLTWH(0, 0, size.x, size.y);
      final Paint neonPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, (12 - i * 3) * pulse);

      // Één pijl
      final Path arrow = Path();
      final double tipX = centerX;
      final double tipY = centerY - arrowHeight * 0.6 * layerScale;
      final double baseWidth = arrowWidth * 0.5 * layerScale;
      final double baseY = centerY + arrowHeight * 0.2 * layerScale;

      arrow.moveTo(tipX, tipY);
      arrow.quadraticBezierTo(
        tipX + baseWidth * 0.3, tipY + arrowHeight * 0.3 * layerScale,
        tipX + baseWidth, baseY - arrowHeight * 0.1 * layerScale
      );
      arrow.lineTo(tipX + baseWidth * 0.7, baseY);
      arrow.lineTo(tipX, baseY + arrowHeight * 0.18 * layerScale);
      arrow.lineTo(tipX - baseWidth * 0.7, baseY);
      arrow.lineTo(tipX - baseWidth, baseY - arrowHeight * 0.1 * layerScale);
      arrow.quadraticBezierTo(
        tipX - baseWidth * 0.3, tipY + arrowHeight * 0.3 * layerScale,
        tipX, tipY
      );

      canvas.drawPath(arrow, neonPaint);

      // Witte omranding
      final Paint outlinePaint = Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(arrow, outlinePaint);

      // Raketeffect onderaan
      final Path flames = Path();
      final double flameBaseY = centerY + arrowHeight * 0.5;
      final double flameWidth = arrowWidth * 0.6 * (0.8 + 0.2 * sin(timer * 8));

      flames.moveTo(centerX - flameWidth / 2, flameBaseY);

      for (int j = 0; j <= 8; j++) {
        final double t = j / 8;
        final double waveHeight = arrowHeight * 0.3 * (1.0 + sin(timer * 10 + j * 2));
        final double x = centerX - flameWidth / 2 + flameWidth * t;
        final double y = flameBaseY + waveHeight;
        flames.lineTo(x, y);
      }

      flames.lineTo(centerX + flameWidth / 2, flameBaseY);
      flames.close();

      canvas.drawPath(flames, neonPaint);

      // Omranding voor de vlammen
      final Paint flameOutlinePaint = Paint()
        ..color = Colors.white.withOpacity(0.6 * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(flames, flameOutlinePaint);
    }
  }

  @override
  void onCollect(Game game) {
    game.player.velocity.y = -500; // Geef een flinke boost omhoog
    removeFromParent();
  }
}