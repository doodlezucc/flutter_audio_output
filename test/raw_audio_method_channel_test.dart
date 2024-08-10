import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raw_audio/src/raw_audio_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelRawAudio platform = MethodChannelRawAudio();
  const MethodChannel channel = MethodChannel('raw_audio');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize', () async {
    await platform.initialize(const Duration(milliseconds: 1000));
  });
}
