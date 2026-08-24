import 'package:audioplayers/audioplayers.dart';

/// Plays the bundled beep/chime-style KDS alert tones.
class KdsTonePlayer {
  KdsTonePlayer._();

  static final instance = KdsTonePlayer._();

  final _player = AudioPlayer();

  Future<void> play(String asset) async {
    await _player.stop();
    await _player.play(AssetSource(asset));
  }
}
