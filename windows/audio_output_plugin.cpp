#include "audio_output_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

#include "audio_writer.h"
#include "util.h"

namespace audio_output {

	AudioWriter audioWriter;
	int availableSampleLength;

	// static
	void AudioOutputPlugin::RegisterWithRegistrar(
		flutter::PluginRegistrarWindows* registrar) {
		auto channel =
			std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
				registrar->messenger(), "audio_output",
				&flutter::StandardMethodCodec::GetInstance());

		auto plugin = std::make_unique<AudioOutputPlugin>();

		channel->SetMethodCallHandler(
			[plugin_pointer = plugin.get()](const auto& call, auto result) {
			plugin_pointer->HandleMethodCall(call, std::move(result));
		});

		registrar->AddPlugin(std::move(plugin));
	}

	AudioOutputPlugin::AudioOutputPlugin() {}

	AudioOutputPlugin::~AudioOutputPlugin() {}

	void AudioOutputPlugin::HandleMethodCall(
		const flutter::MethodCall<flutter::EncodableValue>& method_call,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

		std::string method_name = method_call.method_name();
		const auto* args = std::get_if<flutter::EncodableMap>(method_call.arguments());

		if (method_name.compare("initialize") == 0) {
			const auto* bufferDurationMs = std::get_if<int>(ValueOrNull(*args, "bufferDurationMs"));

			if (!bufferDurationMs) {
				return result->Error("argument_error", "bufferDurationMs argument missing");
			}

			audioWriter.Initialize(*bufferDurationMs);
			return result->Success();
		}
		else if (method_name.compare("dispose") == 0) {
			audioWriter.Dispose();
			return result->Success();
		}
		else if (method_name.compare("requestContext") == 0) {
			auto writingContext = audioWriter.RequestWritingContext();
			availableSampleLength = writingContext.availableLength;

			auto response = EncodableMap({
				{EncodableValue("length"), EncodableValue(availableSampleLength)},
				{EncodableValue("sampleRate"), EncodableValue(writingContext.sampleRate)},
				{EncodableValue("channelCount"), EncodableValue(writingContext.channelCount)},
				});

			return result->Success(response);
		}
		else if (method_name.compare("write") == 0) {
			const auto* sampleData = std::get_if<std::vector<float>>(ValueOrNull(*args, "channelSampleData"));

			if (!sampleData) {
				return result->Error("argument_error", "sampleData argument missing");
			}

			audioWriter.Write(sampleData->data(), availableSampleLength);

			return result->Success();
		}
		else {
			result->NotImplemented();
		}
	}

}  // namespace audio_output
