import 'package:flutter/material.dart';
import 'apptheme.dart';
import 'soundmanager.dart';
import 'skins.dart';

class StartMenu extends StatefulWidget {
  final void Function(Skin) onStart;
  final int highScore;
  const StartMenu({Key? key, required this.onStart, required this.highScore}) : super(key: key);

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  int selectedSkin = 0;

  void _showSkinsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: AppTheme.mainBoxDecoration,
          padding: const EdgeInsets.all(24),
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Kies je skin", style: TextStyle(fontSize: 28, color: Colors.cyanAccent)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                children: List.generate(availableSkins.length, (i) {
                  final skin = availableSkins[i];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedSkin = i);
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        SkinPreview(skin: skin, size: 48),
                        Text(
                          skin.name,
                          style: TextStyle(
                            color: i == selectedSkin ? Colors.cyanAccent : Colors.white,
                            fontWeight: i == selectedSkin ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = PageController();
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: AppTheme.mainBoxDecoration,
            padding: const EdgeInsets.all(24),
            width: 340,
            height: 420,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.swipe, size: 64, color: Colors.cyanAccent),
                          SizedBox(height: 16),
                          Text(
                            "Swipe up or diagonally to jump.",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.stairs, size: 64, color: Colors.cyanAccent),
                          SizedBox(height: 16),
                          Text(
                            "Land on platforms to climb higher.",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.flash_on, size: 64, color: Colors.yellowAccent),
                          SizedBox(height: 16),
                          Text(
                            "Some platforms give you a boost!",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning, size: 64, color: Colors.redAccent),
                          SizedBox(height: 16),
                          Text(
                            "Watch out for moving and tilting platforms!",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Booster-powerup uitleg
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.arrow_upward, size: 64, color: Colors.cyanAccent),
                          SizedBox(height: 16),
                          Text(
                            "Booster-powerups launch you upwards",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "They spawn randomly during your ascend",
                            style: TextStyle(color: Colors.cyanAccent, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('Vorige', style: TextStyle(color: Colors.cyanAccent)),
                      onPressed: () {
                        if (controller.page! > 0) {
                          controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('Sluiten', style: TextStyle(color: Colors.cyanAccent)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Volgende', style: TextStyle(color: Colors.cyanAccent)),
                      onPressed: () {
                        if (controller.page! < 4) {
                          controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      child: Stack(
        children: [
          // Skin linksboven
          Positioned(
            top: 32,
            left: 24,
            child: Column(
              children: [
                SkinPreview(skin: availableSkins[selectedSkin], size: 48),
                Text(
                  availableSkins[selectedSkin].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          // Hoofdmenu gecentreerd
          Center(
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
                  'Highscore: ${widget.highScore}',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 24),
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
                  onPressed: () {
                    SoundManager().playButton();
                    widget.onStart(availableSkins[selectedSkin]);
                  },
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
                  icon: const Icon(Icons.palette),
                  label: const Text('Skins'),
                  onPressed: _showSkinsDialog,
                ),
                const SizedBox(height: 24),
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
                    SoundManager().playButton();
                    _showTutorial(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}