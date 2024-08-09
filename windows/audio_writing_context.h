#pragma once

namespace audio_output {

	class AudioWriter;
	class AudioWritingContext {
	private:
		AudioWriter* writer = nullptr;

	public:
		int availableLength;
		int channelCount;
		int sampleRate;

		AudioWritingContext(AudioWriter* writer, int availableLength, int channelCount, int sampleRate) {
			this->writer = writer;
			this->availableLength = availableLength;
			this->channelCount = channelCount;
			this->sampleRate = sampleRate;
		}
	};
}