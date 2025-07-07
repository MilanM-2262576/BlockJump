import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:blockjump/game.dart' as blockjump_game;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BlockJumpApp());
}

class BlockJumpApp extends StatefulWidget {
  const BlockJumpApp({Key? key}) : super(key: key);

  @override
  State<BlockJumpApp> createState() => _BlockJumpAppState();
}

class _BlockJumpAppState extends State<BlockJumpApp> {
  bool _gameStarted = false;
  int _highScore = 0;
  
  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('highscore') ?? 0;
    });
  }

  Future<void> _onGameOver(int score) async {
    final prefs = await SharedPreferences.getInstance();
    if (score > _highScore) {
      await prefs.setInt('highscore', score);
      setState(() {
        _highScore = score; 
        _gameStarted = false;
      });
    } else {
      setState(() {
        _gameStarted = false;
      });
    }
  }
  
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
      children: [
        if (_gameStarted) ...[
          // Bovenste bar
           Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 400;
                return Container(
                  height: isSmall ? 44 : 60,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 24),
                        child: Text(
                          'BlockJump',
                          style: TextStyle(
                            fontFamily: 'RobotoMono',
                            color: Colors.white,
                            fontSize: isSmall ? 18 : 24,
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.none,
                            letterSpacing: isSmall ? 2 : 6,
                            shadows: [
                              Shadow(
                                blurRadius: 0,
                                color: Color.fromARGB(255, 249, 249, 249),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 24),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isSmall ? 100 : 180, // Limiteer breedte zodat tekst nooit uit beeld gaat
                            ),
                            child: ValueListenableBuilder<int>(
                              valueListenable: blockjump_game.Game.scoreNotifier,
                              builder: (context, score, _) => Text(
                                'Score: $score',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: isSmall ? 16 : 24,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Game zelf
          Positioned.fill(
            top: 60,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GameWidget(
                  game: blockjump_game.Game(
                    onGameOver: _onGameOver,
                  ),
                );
              },
            ),
          ),
        ] else
          StartMenu(
            onStart: () => setState(() => _gameStarted = true),
            highScore: _highScore,
          ),
      ],
    ),
    );
  }
}

class StartMenu extends StatelessWidget {
  final VoidCallback onStart;
  final int highScore;
  const StartMenu({Key? key, required this.onStart, required this.highScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'BlockJump',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
               decoration: TextDecoration.none,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black54,
                    offset: Offset(2, 4),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Highscore: $highScore',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                backgroundColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 8,
                textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              onPressed: onStart,
              child: const Text('Start'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.info_outline),
              label: const Text('Info'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF2C5364),
                    title: const Text(
                      'How to play?',
                      style: TextStyle(color: Colors.cyanAccent),
                    ),
                    content: const Text(
                      'Swipe up in any direction to jump.\n'
                      'Land on platforms to climb higher.\n'
                      'Some platforms move, some give you a boost!\n'
                      'Try to get as high as possible and beat your high score!',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Close', style: TextStyle(color: Colors.cyanAccent)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}