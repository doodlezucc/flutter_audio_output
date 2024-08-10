import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'audio_buffer.dart';
import 'plugin.dart';
import 'raw_audio_platform_interface.dart';

/// An implementation of [RawAudioPlatform] that uses method channels.
class MethodChannelRawAudio extends RawAudioPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('raw_audio');

  @override
  Future<void> initialize(Duration bufferDuration) async {
    await methodChannel.invokeMethod<void>('initialize', {
      'bufferDurationMs': bufferDuration.inMilliseconds,
    });
  }

  @override
  Future<void> dispose() async {
    await methodChannel.invokeMethod<void>('dispose');
  }

  Future<void> write(AudioBuffer buffer) async {
    await methodChannel.invokeMethod<void>('write', {
      'channelSampleData': buffer.raw,
    });
  }

  Future<AudioBuffer> requestContext() async {
    final result = await methodChannel.invokeMethod<Map>('requestContext');

    if (result == null) {
      throw "Failed to request context - platform didn't respond";
    }

    final int bufferLengthInSamples = result['length'];
    final int sampleRate = result['sampleRate'];
    final int channelCount = result['channelCount'];

    return AudioBuffer(
      length: bufferLengthInSamples,
      format: AudioFormat(sampleRate: sampleRate, channelCount: channelCount),
    );
  }

  @override
  Future<void> produceAudio({required AudioProducer producer}) async {
    final buffer = await requestContext();
    if (buffer.length > 0) {
      producer.produce(buffer);
      await write(buffer);
    }
  }
}
