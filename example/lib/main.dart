import 'dart:async';

import 'package:audio_output/audio_output.dart';
import 'package:audio_output_example/audio_producer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _audioOutputPlugin = AudioOutput();
  final producer = MyAudioProducer();

  @override
  void initState() {
    super.initState();
    initAudioOutput();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAudioOutput() async {
    await _audioOutputPlugin.initialize();

    _audioOutputPlugin.startProduction(producer);
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
