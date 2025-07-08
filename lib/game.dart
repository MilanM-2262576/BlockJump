import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'player.dart';
import 'platform.dart';
import 'boosterplatform.dart';
import 'movingplatform.dart';
import 'tiltingplatform.dart';
import 'skins.dart';

class Game extends FlameGame with PanDetector {
  late Player player;
  late World world;


  final void Function(int score)? onGameOver;
  final Skin skin;

  Vector2? _swipeStart;
  Vector2? _swipeCurrent;
  List<Vector2> _swipeTrail = [];

  double highestPlatformY = 200;

  static final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  int score = 0;
  int highestscore = 0;
  
  bool canJump = true;

  Game({this.onGameOver, required this.skin});

  @override
  Future<void> onLoad() async {
    world = World();
    add(world);

    player = Player(skin: skin);
    await world.add(player);

    await world.add(
      Platform(Vector2(0, size.y - 80), isBase: true)..size = Vector2(size.x, 80)
    );
    await world.add(Platform(Vector2(80, size.y - 120)));
    await world.add(Platform(Vector2(200, size.y - 240)));
    await world.add(Platform(Vector2(40, size.y - 360)));
    await world.add(Platform(Vector2(70, size.y - 460)));
    await world.add(Platform(Vector2(160, size.y - 550)));
    await world.add(Platform(Vector2(100, size.y - 660)));

    camera.world = world;
  }

  @override
  void update(double dt) {
    super.update(dt);
    checkCollisions(dt);
    keepInBounds(dt);
    updateCam();
    generatePlatforms();
    checkScore();
  }

  @override
  void render(Canvas canvas) {
    final double camY = camera.viewfinder.position.y;
    // Gebruik camY om de hue te laten verlopen (0..360)
    final double hueBase = ((-camY + size.y / 2) / 6) % 360;
    final double hueTop = (hueBase + 40) % 360;

    final colorBottom = HSLColor.fromAHSL(1.0, hueBase, 0.7, 0.45).toColor();
    final colorTop = HSLColor.fromAHSL(1.0, hueTop, 0.7, 0.65).toColor();

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [colorBottom, colorTop],
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    super.render(canvas);

    // swipe trail
    if (_swipeTrail.isNotEmpty) {
      final trailPaint = Paint()
        ..color = const Color(0xFF00FFFF).withOpacity(0.7)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < _swipeTrail.length - 1; i++) {
        canvas.drawLine(
          _swipeTrail[i].toOffset(),
          _swipeTrail[i + 1].toOffset(),
          trailPaint..color = trailPaint.color.withOpacity((i + 1) / _swipeTrail.length),
        );
      }
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _swipeStart = info.eventPosition.global;
    _swipeCurrent = info.eventPosition.global;
    _swipeTrail = [_swipeCurrent!];
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_swipeStart != null && _swipeCurrent != null && canJump) {
      final swipeVector = _swipeCurrent! - _swipeStart!;
      if (swipeVector.length > 30) {
        final direction = swipeVector.normalized();
        const double jumpSpeed = 1020;
        const double horizontalFactor = 0.3;
        player.velocity = Vector2(direction.x * jumpSpeed * horizontalFactor, -jumpSpeed);
        canJump = false; 
      }
    }
    _swipeStart = null;
    _swipeCurrent = null;
    _swipeTrail.clear();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _swipeCurrent = info.eventPosition.global;
    if (_swipeCurrent != null) {
      _swipeTrail.add(_swipeCurrent!);
      if (_swipeTrail.length > 20) {
        _swipeTrail.removeAt(0);
      }
    }
  }

  void generatePlatforms() {
  final cameraTop = camera.viewfinder.position.y - size.y / 2;
  while (highestPlatformY > cameraTop - 100) {
    final rand = Random();
    final double minX = 0;
    final double maxX = size.x - 80;
    final double newY = highestPlatformY - 120;
    final double newX = minX + rand.nextDouble() * (maxX - minX);

    final double r = rand.nextDouble();
    if (r < 0.20) {
      // Moving platform
      final double amplitude = min(120, (size.x - 64) / 2);
      final double safeStartX = amplitude + rand.nextDouble() * (size.x - 2 * amplitude - 64);
      world.add(MovingPlatform(Vector2(safeStartX, newY), amplitude: amplitude));
    } else if (r < 0.18) {
      // Tilting platform
      world.add(TiltingPlatform(Vector2(newX, newY)));
    } else if (r < 0.30) {
      // Booster platform
      world.add(BoosterPlatform(Vector2(newX, newY)));
    } else {
      world.add(Platform(Vector2(newX, newY)));
    }
    highestPlatformY = newY;
  }
}

  void updateCam() {
    final minCameraY = size.y/2;
    final targetY = player.y;
    camera.viewfinder.position = Vector2(size.x/2, targetY < minCameraY ? targetY : minCameraY);
  }

  void keepInBounds(double dt) {
    if (player.position.x < 0) {
      player.position.x = 0;
      player.velocity.x = 0;
    }
    if (player.position.x + player.size.x > size.x) {
      player.position.x = size.x - player.size.x;
      player.velocity.x = 0;
    }
  }

  void checkCollisions(double dt) {
    final platforms = world.children.whereType<Platform>();
    final playerRect = player.toRect();

    for (final platform in platforms) {
      final platformRect = platform.getCollisionRect();

      if (playerRect.bottom >= platformRect.top &&
          playerRect.bottom <= platformRect.top + player.velocity.y * dt + 1 &&
          playerRect.right > platformRect.left &&
          playerRect.left < platformRect.right &&
          player.velocity.y > 0) {
      
        if (platform is MovingPlatform) {
          player.position.x += platform.lastDeltaX;
        }

         // Afslijden op TiltingPlatform
        if (platform is TiltingPlatform) {
          // Hoe schuiner, hoe sneller je glijdt
          final double slideSpeed = platform.currentAngle * 400; // Pas 400 aan voor meer/minder glijden
          player.position.x += slideSpeed * dt;
        }


        player.position.y = platformRect.top - player.size.y;
        player.velocity.y = 0;
        player.velocity.x = 0;

        //Na landen kan speler terug jumpen
        canJump = true; 

        //trill platform
        platform.shake();
        
        // BOOSTER: check of het een BoosterPlatform is
        if (platform is BoosterPlatform) {
          platform.boostPlayer(player);
        } else {
           platform.highlight(skin.color); 
        }

        
        // Check of het het basisplatform is
        if (platform.isBase == true) {
          onGameOver?.call(highestscore);
          pauseEngine();
        }
      } else {
        platform.hasShaken = false;
      }
    }
  }

  void checkScore() {
    final platforms = world.children.whereType<Platform>();
    for (final platform in platforms) {
      if (!platform.hasBeenPassed && player.position.y + player.size.y < platform.position.y) {
        platform.hasBeenPassed = true;
        score++;

        scoreNotifier.value = score;

        if (score > highestscore) {
          highestscore = score; 
        }
      }
      if (platform.hasBeenPassed && player.position.y + player.size.y >= platform.position.y) {
        platform.hasBeenPassed = false;
        score = (score > 0) ? score - 1 : 0;

         scoreNotifier.value = score;
      }
    }
  }
 
}