import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

/// Converts the given source file to future string based on source type.
abstract class MapProvider {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const MapProvider();

  /// Returns the json file as future string value.
  Future<String> loadString();

  /// Returns shape path which is given.
  String? get shapePath;

  /// Returns shape bytes which is given.
  Uint8List? get bytes;
}

/// Decodes the given json file as a map.
///
/// This class behaves like similar to [Image.asset].
///
/// See also:
///
/// [MapShapeSource.asset] for the [SfMaps] widget shorthand,
/// backed up by [AssetMapProvider].
@immutable
class AssetMapProvider extends MapProvider {
  /// Creates an object that decodes a [String] buffer as a map.
  AssetMapProvider(String assetName) : assert(assetName.isNotEmpty) {
    _shapePath = assetName;
  }

  late final String _shapePath;

  @override
  Future<String> loadString() async {
    return rootBundle.loadString(_shapePath);
  }

  @override
  String? get shapePath => _shapePath;

  @override
  Uint8List? get bytes => null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AssetMapProvider && other.shapePath == shapePath;
  }

  @override
  int get hashCode => Object.hash(shapePath, bytes);
}

// Decodes the given map URL from the network.
///
/// The map will be fetched and saved in local temporary directory for map
/// manipulation.
///
/// This class behaves like similar to [Image.network].
///
/// See also:
///
/// [MapShapeSource.network] for the [SfMaps] widget shorthand,
/// backed up by [NetworkMapProvider].
@immutable
class NetworkMapProvider extends MapProvider {
  /// Creates an object that decodes the map at the given URL.
  NetworkMapProvider(String url) : assert(url.isNotEmpty) {
    _url = url;
  }

  late final String _url;

  @override
  Future<String> loadString() async {
    final http.Response response = await http.get(Uri.tryParse(_url)!);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load JSON');
    }
  }

  @override
  String? get shapePath => _url;

  @override
  Uint8List? get bytes => null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is NetworkMapProvider && other.shapePath == shapePath;
  }

  @override
  int get hashCode => Object.hash(shapePath, bytes);
}

/// Decodes the given [Uint8List] buffer as an map.
///
/// The provided [bytes] buffer should not be changed after it is provided
/// to a [MemoryMapProvider].
///
/// This class behaves like similar to [Image.memory].
///
/// See also:
///
/// [MapShapeSource.memory] for the [SfMaps] widget shorthand,
/// backed up by [MemoryMapProvider].
@immutable
class MemoryMapProvider extends MapProvider {
  /// Creates an object that decodes a [Uint8List] buffer as a map.
  MemoryMapProvider(Uint8List bytes) {
    _mapBytes = bytes;
  }

  late final Uint8List _mapBytes;

  @override
  Future<String> loadString() async {
    return utf8.decode(_mapBytes);
  }

  @override
  String? get shapePath => null;

  @override
  Uint8List? get bytes => _mapBytes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MemoryMapProvider && other.bytes == bytes;
  }

  @override
  int get hashCode => Object.hash(shapePath, bytes);
}
