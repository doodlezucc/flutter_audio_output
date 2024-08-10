// import 'package:raw_audio/raw_audio_method_channel.dart';
// import 'package:raw_audio/raw_audio_platform_interface.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockRawAudioPlatform
//     with MockPlatformInterfaceMixin
//     implements RawAudioPlatform {
//   @override
//   Future<void> initialize(Duration bufferDuration) => Future.value();
// }

// void main() {
//   final RawAudioPlatform initialPlatform = RawAudioPlatform.instance;

//   test('$MethodChannelRawAudio is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelRawAudio>());
//   });

//   test('getPlatformVersion', () async {
//     RawAudio rawAudioPlugin = RawAudio();
//     MockRawAudioPlatform fakePlatform = MockRawAudioPlatform();
//     RawAudioPlatform.instance = fakePlatform;

//     expect(await rawAudioPlugin.getPlatformVersion(), '42');
//   });
// }
