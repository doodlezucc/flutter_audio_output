#ifndef FLUTTER_PLUGIN_AUDIO_OUTPUT_PLUGIN_H_
#define FLUTTER_PLUGIN_AUDIO_OUTPUT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace audio_output {

class AudioOutputPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AudioOutputPlugin();

  virtual ~AudioOutputPlugin();

  // Disallow copy and assign.
  AudioOutputPlugin(const AudioOutputPlugin&) = delete;
  AudioOutputPlugin& operator=(const AudioOutputPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace audio_output

#endif  // FLUTTER_PLUGIN_AUDIO_OUTPUT_PLUGIN_H_
