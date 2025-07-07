import 'package:flame/components.dart';
import 'platform.dart';
import 'dart:math';

class MovingPlatform extends Platform {
  final double amplitude; 
  final double speed;    
  double _time = 0;
  final double startX;
  double lastDeltaX = 0;

  MovingPlatform(Vector2 position, {this.amplitude = 200, this.speed = 3.0})
      : startX = position.x,
        super(position);

   @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    final oldX = position.x;
    position.x = startX + amplitude * (0.5 * (1 + (sin(_time * speed))));
    lastDeltaX = position.x - oldX;
  }
}