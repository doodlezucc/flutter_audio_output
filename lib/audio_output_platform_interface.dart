import 'package:audio_output/audio_output.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_output_method_channel.dart';

abstract class AudioOutputPlatform extends PlatformInterface {
  /// Constructs a AudioOutputPlatform.
  AudioOutputPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioOutputPlatform _instance = MethodChannelAudioOutput();

  /// The default instance of [AudioOutputPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioOutput].
  static AudioOutputPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioOutputPlatform] when
  /// they register themselves.
  static set instance(AudioOutputPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(Duration bufferDuration);
  Future<void> dispose();

  Future<void> produceAudio({required AudioProducer producer});
}
