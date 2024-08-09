import 'dart:async';

import 'package:audio_output/audio_buffer_context.dart';

import 'audio_output_platform_interface.dart';

mixin AudioProducer {
  void produce(AudioBuffer buffer);
}

class AudioOutput {
  Timer? _productionTimer;

  Future<void> initialize({
    Duration bufferDuration = const Duration(milliseconds: 50),
  }) {
    return AudioOutputPlatform.instance.initialize(bufferDuration);
  }

  void startProduction(
    AudioProducer producer, {
    Duration refreshRate = const Duration(milliseconds: 5),
  }) {
    _productionTimer?.cancel();

    _productionTimer = Timer.periodic(refreshRate, (_) async {
      AudioOutputPlatform.instance.produceAudio(producer: producer);
    });
  }

  Future<void> dispose() async {
    _productionTimer?.cancel();

    await AudioOutputPlatform.instance.dispose();
  }
}
