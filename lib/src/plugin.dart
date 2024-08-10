import 'dart:async';

import 'audio_buffer.dart';
import 'raw_audio_platform_interface.dart';

mixin AudioProducer {
  void produce(AudioBuffer buffer);
}

class RawAudio {
  bool _isProducing = false;

  Future<void> initialize({
    Duration bufferDuration = const Duration(milliseconds: 20),
  }) {
    return RawAudioPlatform.instance.initialize(bufferDuration);
  }

  void startProduction(AudioProducer producer) async {
    if (_isProducing) {
      throw StateError('Audio is already being produced');
    }

    _isProducing = true;

    while (_isProducing) {
      await RawAudioPlatform.instance.produceAudio(producer: producer);
    }
  }

  void stopProduction() {
    _isProducing = false;
  }

  Future<void> dispose() async {
    stopProduction();

    await RawAudioPlatform.instance.dispose();
  }
}
