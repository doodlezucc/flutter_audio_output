#include "include/audio_output/audio_output_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "audio_output_plugin.h"

void AudioOutputPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  audio_output::AudioOutputPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
