import 'package:flame/components.dart';
import '../game.dart'; 

abstract class Powerup extends PositionComponent {
  Powerup(Vector2 position) : super(position: position, size: Vector2(32, 32));


  void onCollect(Game game);
}