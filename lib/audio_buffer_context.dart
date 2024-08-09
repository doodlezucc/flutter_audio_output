import 'dart:collection';
import 'dart:typed_data';

mixin AudioBufferChannel {
  double operator [](int frame);
  operator []=(int frame, double sample);
}

class _ChannelAccess implements AudioBufferChannel {
  final AudioBuffer buffer;
  final int channelIndex;

  _ChannelAccess(this.buffer, this.channelIndex);

  @override
  double operator [](int frame) {
    return buffer._readFromChannel(channelIndex, frame);
  }

  @override
  operator []=(int frame, double sample) {
    buffer.writeToChannel(channelIndex, frame, sample);
  }
}

class AudioBuffer {
  /// Number of samples which can be written into each channel.
  final int length;
  final AudioFormat format;

  final Float32List raw;

  late final List<_ChannelAccess> _channels = List.generate(
    format.channelCount,
    (index) => _ChannelAccess(this, index),
  );

  late final channels = UnmodifiableListView<AudioBufferChannel>(_channels);

  AudioBuffer({required this.length, required this.format})
      : raw = Float32List(length * format.channelCount);

  AudioBufferChannel operator [](int channel) {
    return _channels[channel];
  }

  double _readFromChannel(int channel, int frame) {
    return raw[format.channelCount * frame + channel];
  }

  void writeToChannel(int channel, int frame, double sample) {
    raw[format.channelCount * frame + channel] = sample;
  }
}

class AudioFormat {
  final int sampleRate;
  final int channelCount;

  const AudioFormat({
    required this.sampleRate,
    required this.channelCount,
  });
}
