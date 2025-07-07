import 'package:flame/components.dart';
import 'dart:math';
import 'platform.dart';
import 'dart:ui';

class TiltingPlatform extends Platform {
  final double angle; // vaste kantelhoek

  TiltingPlatform(Vector2 position)
      : angle = (Random().nextDouble() - 0.5) * 1.0, // tussen -0.3 en +0.3 rad
        super(position);

  double get currentAngle => angle;

  @override
  void render(Canvas canvas) {
    canvas.save();
    // Kantel rond het midden van het platform
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);
    canvas.translate(-size.x / 2, -size.y / 2);
    super.render(canvas);
    canvas.restore();
  }
}