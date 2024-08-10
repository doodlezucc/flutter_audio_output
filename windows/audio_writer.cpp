#include "audio_writer.h"
#include "audio_writing_context.h"
#include <iostream>
#include <mmdeviceapi.h>
#include <Audioclient.h>
#include <comdef.h>

void PrintHResultError(HRESULT hr) {
	auto err = _com_error(hr);
	std::cerr << "Error in audio_writer.cpp, line " << __LINE__ << ": " << err.ErrorMessage() << " (" << err.Description() << ")" << std::endl;
}

#define CHECK_HR(hr) if (FAILED(hr)) { PrintHResultError(hr); return -1; }

enum class OutputFormatType {
	FLOAT,
	INT,
	UNSUPPORTED
};

OutputFormatType getWaveFormatType(WAVEFORMATEX* waveFormat) {
	WORD baseFormat = waveFormat->wFormatTag;

	if (baseFormat == WAVE_FORMAT_EXTENSIBLE) {
		GUID subFormat = reinterpret_cast<WAVEFORMATEXTENSIBLE*>(waveFormat)->SubFormat;

		if (subFormat == KSDATAFORMAT_SUBTYPE_IEEE_FLOAT) {
			return OutputFormatType::FLOAT;
		}
		else if (subFormat == KSDATAFORMAT_SUBTYPE_PCM) {
			return OutputFormatType::INT;
		}
	}
	else {
		switch (baseFormat) {
		case WAVE_FORMAT_IEEE_FLOAT:
			return OutputFormatType::FLOAT;
		case WAVE_FORMAT_PCM:
			return OutputFormatType::INT;
		}
	}

	return OutputFormatType::UNSUPPORTED;
}

namespace audio_output {
	int AudioWriter::Initialize(int bufferDurationMs) {
		// Initialization of Windows "COM" componentry
		CHECK_HR(CoInitialize(nullptr));
		CHECK_HR(CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL, __uuidof(IMMDeviceEnumerator), (void**)&deviceEnumerator));

		// Get default audio playback device
		CHECK_HR(deviceEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &defaultDevice));

		// Activate audio client
		CHECK_HR(defaultDevice->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr, (void**)&audioClient));

		CHECK_HR(audioClient->GetMixFormat(&waveFormat));

		// OutputFormatType outputFormatType = getWaveFormatType(waveFormat);

		REFERENCE_TIME bufferDuration = bufferDurationMs * 10000;

		CHECK_HR(audioClient->Initialize(AUDCLNT_SHAREMODE_SHARED, 0, bufferDuration, 0, waveFormat, nullptr));

		// Get the size of the allocated buffer
		CHECK_HR(audioClient->GetBufferSize(&bufferSizeInFrames));

		// Get the render client
		CHECK_HR(audioClient->GetService(__uuidof(IAudioRenderClient), (void**)&renderClient));

		// Start the audio client
		CHECK_HR(audioClient->Start());

		return 0;
	}

	int AudioWriter::Dispose() {
		// Stop and clean up
		CHECK_HR(audioClient->Stop());

		CoTaskMemFree(waveFormat);
		renderClient->Release();
		audioClient->Release();
		defaultDevice->Release();
		deviceEnumerator->Release();
		CoUninitialize();

		return 0;
	}

	int AudioWriter::RequestWritingContext(AudioWritingContext** context)
	{
		UINT32 numFramesPadding;

		CHECK_HR(audioClient->GetCurrentPadding(&numFramesPadding));

		UINT32 numFramesAvailable = bufferSizeInFrames - numFramesPadding;

		*context = new AudioWritingContext(this, numFramesAvailable, waveFormat->nChannels, waveFormat->nSamplesPerSec);
		return 0;
	}

	int AudioWriter::Write(const float* sampleData, const UINT32 length)
	{
		BYTE* bufferAddress;
		CHECK_HR(renderClient->GetBuffer(length, &bufferAddress));

		int bytesPerSample = waveFormat->wBitsPerSample / 8;

		for (UINT32 frame = 0; frame < length; frame++) {
			const float* frameAddress = sampleData + frame * waveFormat->nChannels;
			int blockOffset = frame * waveFormat->nBlockAlign;

			for (int channel = 0; channel < waveFormat->nChannels; channel++) {
				const float* sampleValueAddress = frameAddress + channel;

				void* destinationAddress = bufferAddress + blockOffset + (channel * bytesPerSample);
				memcpy(destinationAddress, sampleValueAddress, bytesPerSample);
			}
		}

		CHECK_HR(renderClient->ReleaseBuffer(length, 0));

		return 0;
	}
}