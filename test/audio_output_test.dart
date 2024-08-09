// import 'package:audio_output/audio_output_method_channel.dart';
// import 'package:audio_output/audio_output_platform_interface.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAudioOutputPlatform
//     with MockPlatformInterfaceMixin
//     implements AudioOutputPlatform {
//   @override
//   Future<void> initialize(Duration bufferDuration) => Future.value();
// }

// void main() {
//   final AudioOutputPlatform initialPlatform = AudioOutputPlatform.instance;

//   test('$MethodChannelAudioOutput is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAudioOutput>());
//   });

//   test('getPlatformVersion', () async {
//     AudioOutput audioOutputPlugin = AudioOutput();
//     MockAudioOutputPlatform fakePlatform = MockAudioOutputPlatform();
//     AudioOutputPlatform.instance = fakePlatform;

//     expect(await audioOutputPlugin.getPlatformVersion(), '42');
//   });
// }
