import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playButton() async {
    await _player.play(AssetSource('sounds/buttonsound.mp3'), volume: 0.5);
  }
}