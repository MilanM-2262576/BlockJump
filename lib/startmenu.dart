import 'package:flutter/material.dart';
import 'apptheme.dart';

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
              onPressed: () => _showTutorial(context),
            ),
          ],
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
                            "Swipe omhoog of schuin om te springen.",
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
                            "Land op platforms om hoger te komen.",
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
                            "Sommige platforms geven je een boost!",
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
                            "Pas op voor bewegende en schuine platforms!",
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                        if (controller.page! < 3) {
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
}