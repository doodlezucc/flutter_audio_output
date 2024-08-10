import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raw_audio/raw_audio.dart';
import 'package:raw_audio_example/audio_producer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _rawAudioPlugin = RawAudio();
  final producer = MyAudioProducer();

  @override
  void initState() {
    super.initState();
    initRawAudio();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initRawAudio() async {
    await _rawAudioPlugin.initialize();

    _rawAudioPlugin.startProduction(producer);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Switch(
              value: producer.mute,
              onChanged: (doMute) => setState(() {
                producer.mute = doMute;
              }),
            ),
            GestureDetector(
              onTapDown: (_) {
                producer.playShootSound();
              },
              onTapUp: (_) {
                producer.playShootSound();
              },
              child: const TextButton(
                isSemanticButton: true,
                onPressed: null,
                child: Text('Shoot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
