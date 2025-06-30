import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:ui';

//Player klasse
class Player extends PositionComponent {
    Player()
      : super(
          size: Vector2(50, 50),
          position: Vector2(200, 200),
        );

  Vector2 velocity = Vector2(0,0);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF2196F3));
  }

  @override
  void update(double dt) {
    velocity.y += 2000 * dt;
    position += velocity * dt;
  }
}