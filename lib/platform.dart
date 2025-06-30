import 'package:flame/components.dart';
import 'dart:ui';
import 'dart:math';

class Platform extends PositionComponent {
  static final _fillPaint = Paint()..color = const Color(0xFF000000); // zwart
  static final _neonPaint = Paint()
  ..color = const Color(0xFF00FFFF)
  ..style = PaintingStyle.stroke
  ..strokeWidth = 4
  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5); // glow effect verwijderd

  bool hasBeenPassed = false;

  Platform(Vector2 position)
      : super(
          position: position,
          size: Vector2(64, 32),
        );

  Rect getCollisionRect() {
    return Rect.fromLTWH(
      position.x,
      position.y,
      size.x,
      size.y,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Zwart blok
    canvas.drawRect(size.toRect(), _fillPaint);
    // Neon omranding
    canvas.drawRect(size.toRect(), _neonPaint);

    canvas.restore();
  }
}