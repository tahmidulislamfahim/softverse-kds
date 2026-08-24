import 'package:flutter_tts/flutter_tts.dart';

/// Speaks short alert phrases (e.g. "Order Paid") for KDS event sounds.
class KdsTts {
  KdsTts._();

  static final instance = KdsTts._();

  final _tts = FlutterTts();
  bool _ready = false;

  Future<void> speak(String phrase) async {
    if (!_ready) {
      await _tts.awaitSpeakCompletion(true);
      _ready = true;
    }
    await _tts.stop();
    await _tts.speak(phrase);
  }
}
