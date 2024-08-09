#pragma once

#include <flutter/event_channel.h>
#include <flutter/standard_method_codec.h>

using flutter::EncodableMap;
using flutter::EncodableList;
using flutter::EncodableValue;

// Looks for |key| in |map|, returning the associated value if it is present, or
// a nullptr if not.
//
// The variant types are mapped with Dart types in following ways:
// std::monostate       -> null
// bool                 -> bool
// int32_t              -> int
// int64_t              -> int
// double               -> double
// std::string          -> String
// std::vector<uint8_t> -> Uint8List
// std::vector<int32_t> -> Int32List
// std::vector<int64_t> -> Int64List
// std::vector<float>   -> Float32List
// std::vector<double>  -> Float64List
// EncodableList        -> List
// EncodableMap         -> Map
const EncodableValue* ValueOrNull(const flutter::EncodableMap& map, const char* key) {
	auto it = map.find(EncodableValue(key));
	if (it == map.end()) {
		return nullptr;
	}
	return &(it->second);
}