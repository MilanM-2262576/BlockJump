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
  bool isBase;

  double _shakeTime = 0;
  double _shakeStrength = 0;
  bool hasShaken = false;


  Platform(Vector2 position, {this.isBase = false})
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

  void shake({double strength = 6, double duration = 0.2}) {
    if (!hasShaken) { 
      _shakeStrength = strength;
      _shakeTime = duration;
      hasShaken = true;
    }
  }

   @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Trillings-offset berekenen
    double dx = 0, dy = 0;
    if (_shakeTime > 0) {
      final rand = Random();
      dx = (rand.nextDouble() * 2 - 1) * _shakeStrength;
      dy = (rand.nextDouble() * 2 - 1) * _shakeStrength;
    }

    canvas.save();
    canvas.translate(dx, dy);
    canvas.drawRect(size.toRect(), _fillPaint);
    canvas.drawRect(size.toRect(), _neonPaint);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_shakeTime > 0) {
      _shakeTime -= dt;
      if (_shakeTime <= 0) {
        _shakeTime = 0;
        _shakeStrength = 0;
      }
    }
  }
}