#pragma once
#include <audioclient.h>
#include <mmdeviceapi.h>
#include <mmeapi.h>

#include "audio_writing_context.h"

namespace audio_output {
	class AudioWriter
	{
	private:
		IMMDeviceEnumerator* deviceEnumerator = nullptr;
		IMMDevice* defaultDevice = nullptr;
		IAudioClient* audioClient = nullptr;
		IAudioRenderClient* renderClient = nullptr;
		WAVEFORMATEX* waveFormat = nullptr;

		UINT32 bufferSizeInFrames;

	public:
		int Initialize(int bufferDurationMs);
		int Dispose();

		AudioWritingContext RequestWritingContext();
		int Write(const float* sampleData, const UINT32 length);
	};

}