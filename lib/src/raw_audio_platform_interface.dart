import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'plugin.dart';
import 'raw_audio_method_channel.dart';

abstract class RawAudioPlatform extends PlatformInterface {
  /// Constructs a RawAudioPlatform.
  RawAudioPlatform() : super(token: _token);

  static final Object _token = Object();

  static RawAudioPlatform _instance = MethodChannelRawAudio();

  /// The default instance of [RawAudioPlatform] to use.
  ///
  /// Defaults to [MethodChannelRawAudio].
  static RawAudioPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RawAudioPlatform] when
  /// they register themselves.
  static set instance(RawAudioPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize(Duration bufferDuration);
  Future<void> dispose();

  Future<void> produceAudio({required AudioProducer producer});
}
