import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:blockjump/game.dart' as blockjump_game;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'apptheme.dart';
import 'startmenu.dart';
import 'skins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MaterialApp(
    home: BlockJumpApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class BlockJumpApp extends StatefulWidget {
  const BlockJumpApp({Key? key}) : super(key: key);

  @override
  State<BlockJumpApp> createState() => _BlockJumpAppState();
}

class _BlockJumpAppState extends State<BlockJumpApp> {
  bool _gameStarted = false;
  int _highScore = 0;
  Skin _selectedSkin = availableSkins[0];
  
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
  bool isHighScore = false;
  if (score > _highScore) {
    await prefs.setInt('highscore', score);
    setState(() {
      _highScore = score;
    });
    isHighScore = true;
  }

  // Game Over popup
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Game Over",
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 350,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: AppTheme.mainBoxDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sentiment_very_dissatisfied, color: Colors.cyanAccent, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Game Over',
                  style: AppTheme.titleStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: $score${isHighScore ? "\nNew Highscore!" : ""}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.cyanAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.home),
                        label: const Text('To Menu'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _gameStarted = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 2,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Play Again'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _gameStarted = true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: child,
      );
    },
  );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                    decoration: AppTheme.mainBoxDecoration.copyWith(
                      border: null,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
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
                                maxWidth: isSmall ? 100 : 180,
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
                      skin: _selectedSkin,
                    ),
                  );
                },
              ),
            ),
          ] else
            StartMenu(
              onStart: (skin) {
                setState(() {
                  _selectedSkin = skin;
                  _gameStarted = true;
                });
              },
              highScore: _highScore,
            ),
        ],
      ),
    );
  }
}

