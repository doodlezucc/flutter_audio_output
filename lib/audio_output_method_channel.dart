import 'package:audio_output/audio_buffer_context.dart';
import 'package:audio_output/audio_output.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'audio_output_platform_interface.dart';

/// An implementation of [AudioOutputPlatform] that uses method channels.
class MethodChannelAudioOutput extends AudioOutputPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_output');

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
    producer.produce(buffer);
    await write(buffer);
  }
}
