#include "include/raw_audio/raw_audio_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "raw_audio_plugin.h"

void RawAudioPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  raw_audio::RawAudioPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
