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
  bool _paused = false;
  int _highScore = 0;
  Skin _selectedSkin = availableSkins[0];
  blockjump_game.Game? _gameInstance;

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
                      Expanded(
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
                              _paused = false;
                              _gameInstance = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
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
                            _startGame();
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

  void _startGame() {
    _gameInstance = blockjump_game.Game(
      onGameOver: _onGameOver,
      skin: _selectedSkin,
    );
    setState(() {
      _gameStarted = true;
      _paused = false;
    });
  }

  void _onPause() {
    _gameInstance?.pauseEngine();
    setState(() {
      _paused = true;
    });
    _showPauseDialog();
  }

  Future<void> _showPauseDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Pause",
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
                  const Icon(Icons.pause_circle_outline, color: Colors.cyanAccent, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Pauze',
                    style: AppTheme.titleStyle,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                          label: const Text('Menu'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _onBackToMenu();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
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
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Verder'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _onResume();
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
    
    // Als de dialog wordt gesloten, controleer of we nog steeds in pauze-modus zijn
    if (_paused) {
      _onResume();
    }
  }

  void _onResume() {
    _gameInstance?.resumeEngine();
    setState(() {
      _paused = false;
    });
  }

  void _onBackToMenu() {
    setState(() {
      _gameStarted = false;
      _paused = false;
      _gameInstance = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          if (_gameStarted) ...[
            // Game zelf
            Positioned.fill(
              child: _gameInstance != null
                  ? GameWidget(game: _gameInstance!)
                  : Container(color: Colors.black),
            ),
            
            // Pauzeknop linksboven
            if (!_paused)
              Positioned(
                top: 24,
                left: 18,
                child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 32),
                  onPressed: _onPause,
                  tooltip: 'Pauze',
                ),
              ),
              
            // Score rechtsboven in neon stijl
            if (!_paused)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, right: 18),
                  child: ValueListenableBuilder<int>(
                    valueListenable: blockjump_game.Game.scoreNotifier,
                    builder: (context, score, _) => Text(
                      '$score',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        letterSpacing: 2,
                        decoration: TextDecoration.none,
                        shadows: [
                          Shadow(
                            blurRadius: 16,
                            color: Colors.cyanAccent.withOpacity(0.8),
                            offset: Offset(0, 0),
                          ),
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ] else
            StartMenu(
              onStart: (skin) {
                _selectedSkin = skin;
                _startGame();
              },
              highScore: _highScore,
            ),
        ],
      ),
    );
  }
}