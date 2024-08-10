import 'dart:math';

import 'package:raw_audio/raw_audio.dart';

class MyAudioProducer implements AudioProducer {
  final List<ShootSound> activeShootSounds = [];

  int offset = 0;
  bool mute = false;

  @override
  void produce(AudioBuffer buffer) {
    if (mute) return;

    for (var frame = 0; frame < buffer.length; frame++) {
      final tInSeconds = (offset + frame) / buffer.format.sampleRate;

      final panPhase = tInSeconds / 3 * 2 * pi;
      final volumeLeft = (sin(panPhase) + 1) / 2;
      final volumeRight = 1 - volumeLeft;

      final phase = tInSeconds * 220 * 2 * pi;
      final sample = 0.1 * sin(phase);

      buffer[0][frame] = sample * volumeLeft;
      buffer[1][frame] = sample * volumeRight;
    }

    for (var sound in activeShootSounds) {
      sound.mixInto(buffer);
    }

    offset += buffer.length;
  }

  void playShootSound() {
    activeShootSounds.add(ShootSound());
  }
}

class ShootSound {
  static const frequency = 110;
  static const decay = Duration(milliseconds: 50);

  bool disposed = false;
  int offset = 0;

  void mixInto(AudioBuffer buffer) {
    if (disposed) return;

    for (var frame = 0; frame < buffer.length; frame++) {
      final tInSeconds = (offset + frame) / buffer.format.sampleRate;

      final progressInLife = (tInSeconds * 1000) / decay.inMilliseconds;

      if (progressInLife >= 1.0) {
        disposed = true;
        break;
      }

      final volume = 1 - progressInLife;

      final phase = tInSeconds * frequency * 2 * pi;
      final sample = 0.3 * volume * sin(phase);

      for (var channel in buffer.channels) {
        channel[frame] += sample;
      }
    }

    offset += buffer.length;
  }
}
