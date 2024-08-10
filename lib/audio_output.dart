import 'dart:async';

import 'package:audio_output/audio_buffer_context.dart';

import 'audio_output_platform_interface.dart';

mixin AudioProducer {
  void produce(AudioBuffer buffer);
}

class AudioOutput {
  bool _isProducing = false;

  Future<void> initialize({
    Duration bufferDuration = const Duration(milliseconds: 20),
  }) {
    return AudioOutputPlatform.instance.initialize(bufferDuration);
  }

  void startProduction(AudioProducer producer) async {
    if (_isProducing) {
      throw StateError('Audio is already being produced');
    }

    _isProducing = true;

    while (_isProducing) {
      await AudioOutputPlatform.instance.produceAudio(producer: producer);
    }
  }

  void stopProduction() {
    _isProducing = false;
  }

  Future<void> dispose() async {
    stopProduction();

    await AudioOutputPlatform.instance.dispose();
  }
}
