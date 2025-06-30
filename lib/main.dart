import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:mygame/player.dart';
import 'package:mygame/platform.dart';
import 'package:flame/components.dart';
import 'dart:math';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with PanDetector {
  late Player player;
  late World world;

  Vector2? _swipeStart;
  Vector2? _swipeCurrent;
  List<Vector2> _swipeTrail = [];

  double highestPlatformY = 200;

  int score = 0;
  
  @override
  Future<void> onLoad() async {
    world = World();
    add(world);

    player = Player();
    await world.add(player);

    await world.add(
      Platform(Vector2(0, size.y - 80))..size = Vector2(size.x, 80) // basisplatform, 40 pixels hoog
    );
    // Vaste startplatformen
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
    super.render(canvas);

    //swipe trail
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

    // Score rechtsboven tonen
    TextPainter(
      text: TextSpan(
        text: 'Score: $score',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2,2))]
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(size.x - 180, 20));
  }

   @override
  void onPanStart(DragStartInfo info) {
    _swipeStart = info.eventPosition.global;
    _swipeCurrent = info.eventPosition.global;
     _swipeTrail = [_swipeCurrent!];
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_swipeStart != null && _swipeCurrent != null) {
      final swipeVector = _swipeCurrent! - _swipeStart!;
      if (swipeVector.length > 30) { // minimale swipe-afstand, pas aan naar wens
        final direction = swipeVector.normalized();
        const double jumpSpeed = 1020;
        const double horizontalFactor = 0.3;
        player.velocity = Vector2(direction.x * jumpSpeed * horizontalFactor, -jumpSpeed);
      }
    }
    _swipeStart = null;
    _swipeCurrent = null;
    _swipeTrail.clear();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // swipe wordt nu alleen gebruikt voor springen, dus hier niets doen
    _swipeCurrent = info.eventPosition.global;
    if (_swipeCurrent != null) {
      _swipeTrail.add(_swipeCurrent!);
      if (_swipeTrail.length > 20) { // max trail lengte
        _swipeTrail.removeAt(0);
      }
    }
  }

  void generatePlatforms() {
    // Platformen genereren tot boven het zichtbare camerabeeld
    final cameraTop = camera.viewfinder.position.y - size.y / 2;
    while (highestPlatformY > cameraTop - 100) {
      final rand = Random();
      final double minX = 0;
      final double maxX = size.x - 80; // platform breedte
      final double newY = highestPlatformY - 120; // afstand tussen platforms
      final double newX = minX + rand.nextDouble() * (maxX - minX);

      world.add(Platform(Vector2(newX, newY)));
      highestPlatformY = newY;
    }
  }

  void updateCam() {
    final minCameraY = size.y/2;
    final targetY = player.y;
    camera.viewfinder.position = Vector2(size.x/2, targetY < minCameraY ? targetY : minCameraY);
  }

  void keepInBounds(double dt) {
    // Houd speler binnen de linker- en rechterrand van het scherm
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
        // Zet speler precies op het platform
        player.position.y = platformRect.top - player.size.y;
        player.velocity.y = 0; // Zet zowel x als y op 0
        player.velocity.x = 0;

  
      }
    }

  }

  void checkScore() {
    // Score updaten: tel hoeveel platformen de speler is gepasseerd (bovenlangs of onderlangs)
    final platforms = world.children.whereType<Platform>();
    for (final platform in platforms) {
      // Als speler bovenlangs passeert
      if (!platform.hasBeenPassed && player.position.y + player.size.y < platform.position.y) {
        platform.hasBeenPassed = true;
        score++;
      }
      // Als speler weer onder het platform komt (dus terugvalt)
      if (platform.hasBeenPassed && player.position.y + player.size.y >= platform.position.y) {
        platform.hasBeenPassed = false;
        score = (score > 0) ? score - 1 : 0; // score mag niet negatief worden
      }
  }
  }
}

