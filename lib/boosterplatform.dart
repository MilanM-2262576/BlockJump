import 'platform.dart';
import 'player.dart';
import 'package:flame/components.dart';
import 'dart:ui';

class BoosterPlatform extends Platform {
  BoosterPlatform(Vector2 position)
      : super(position);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Booster-platform visueel onderscheiden (bijv. oranje glow)
    final boosterPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 240, 74)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawRect(size.toRect(), boosterPaint);
  }

  // Roep deze functie aan als de speler het platform raakt
  void boostPlayer(Player player) {
    player.velocity.y = -1200; // Pas deze waarde aan voor gewenste boost
  }
}