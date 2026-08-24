import '../utils/constants/kds_sounds.dart';
import 'kds_tone_player.dart';
import 'kds_tts.dart';

/// Plays a [KdsSound], whether it's a spoken phrase or a bundled tone.
Future<void> playKdsSound(KdsSound sound) async {
  switch (sound.kind) {
    case KdsSoundKind.phrase:
      await KdsTts.instance.speak(sound.value);
    case KdsSoundKind.tone:
      await KdsTonePlayer.instance.play(sound.value);
  }
}
