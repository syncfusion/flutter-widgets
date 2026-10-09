import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../pdfviewer.dart';

/// Represents a base class of PDF document source.
///
/// This abstract class defines the interface for various sources of PDF documents,
/// such as network, asset, file, or memory. Subclasses should implement the
/// [getBytes] method to provide the specific logic for retrieving the PDF data.
///
/// See also:
///  * [URLPDFSource], for fetching a PDF from a URL.
///  * [AssetPDFSource], for loading a PDF from app assets.
///  * [FilePDFSource], for loading a PDF from a local file.
///  * [BytePDFSource], for loading a PDF stored in memory.
abstract class PDFSource {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PDFSource();

  /// Retrieves the byte data of the PDF document.
  /// This method should be implemented by subclasses to provide the specific logic for obtaining the PDF data from their respective sources.
  ///
  /// The [context] parameter can be used if needed for asset resolution or other context-dependent operations.
  /// Returns a [Future] that completes with a [Uint8List] containing the PDF document bytes.
  Future<Uint8List> getBytes(BuildContext context);
}

/// Fetches the given PDF document URL from the network.
///
/// This class provides functionality to load a PDF document from a remote URL.
/// The PDF will be downloaded and won’t be stored in memory for viewing.
///
/// See also:
///  * [SfPdfViewer.network], which provides a convenient way to display a PDF from a URL.
@immutable
class URLPDFSource extends PDFSource {
  /// Creates a [URLPDFSource] that fetches a PDF document from the specified URL.
  ///
  /// The [url] parameter must not be null or empty.
  /// The [headers] parameter can be used to add custom HTTP headers to the request.
  URLPDFSource(String url, {Map<String, String>? headers})
    : assert(url.isNotEmpty),
      _url = url,
      _headers = headers;

  /// The URL from which the PDF will be fetched.
  final String _url;

  /// The document headers
  final Map<String, String>? _headers;

  /// Retrieves the bytes of the PDF document from the network.
  @override
  Future<Uint8List> getBytes(BuildContext context) async {
    return http.readBytes(Uri.parse(_url), headers: _headers);
  }

  @override
  bool operator ==(Object other) {
    return other is URLPDFSource &&
        _url == other._url &&
        mapEquals(_headers, other._headers);
  }

  @override
  int get hashCode => Object.hash(_url, _headers);
}

/// Decodes the given [Uint8List] buffer as a PDF document.
///
/// This class provides functionality to load a PDF document directly from memory using a [Uint8List] buffer containing the PDF data.
///
/// See also:
///  * [SfPdfViewer.memory], which provides a convenient way to display a PDF using a [Uint8List].
@immutable
class BytePDFSource extends PDFSource {
  /// Creates a [BytePDFSource] that decodes the specified [Uint8List] as a PDF document.
  const BytePDFSource(this._pdfBytes);

  final Uint8List _pdfBytes;

  /// Retrieves the bytes of the PDF document from memory.
  @override
  Future<Uint8List> getBytes(BuildContext context) async {
    return Future<Uint8List>.value(_pdfBytes);
  }
}

/// Fetches a PDF document from an [AssetBundle].
///
/// This class provides functionality to load a PDF document from an asset specified by [assetPath].
/// It can use either a provided [AssetBundle] or the default asset bundle of the current [BuildContext].
///
/// See also:
///  * [SfPdfViewer.asset], which provides a convenient way to display a PDF viewer widget using an asset.
@immutable
class AssetPDFSource extends PDFSource {
  /// Creates an [AssetPDFSource] that fetches the PDF document from the specified asset.
  ///
  /// The [assetPath] parameter must not be null or empty.
  /// The [bundle] parameter is optional. If not provided, the default asset bundle will be used.
  AssetPDFSource(String assetPath, {AssetBundle? bundle})
    : assert(assetPath.isNotEmpty),
      _pdfPath = assetPath,
      _bundle = bundle;

  final String _pdfPath;
  final AssetBundle? _bundle;

  /// Retrieves the bytes of the PDF document from the asset.
  @override
  Future<Uint8List> getBytes(BuildContext context) async {
    final ByteData bytes = await ((_bundle != null)
        ? _bundle.load(_pdfPath)
        : DefaultAssetBundle.of(context).load(_pdfPath));
    return bytes.buffer.asUint8List();
  }

  @override
  bool operator ==(Object other) {
    return other is AssetPDFSource &&
        _pdfPath == other._pdfPath &&
        _bundle == other._bundle;
  }

  @override
  int get hashCode => Object.hash(_pdfPath, _bundle);
}

/// Decodes a [File] object as a PDF document.
///
/// This class provides functionality to load a PDF document from a [File] on the local file system.
///
/// See also:
///
/// *	[SfPdfViewer.file], which provides a convenient way to display a PDF using a file.
@immutable
class FilePDFSource extends PDFSource {
  /// Creates a [FilePDFSource] that decodes the specified [File] as a PDF document.
  const FilePDFSource(this._file);

  final File _file;

  /// Retrieves the bytes of the PDF document from the file.
  @override
  Future<Uint8List> getBytes(BuildContext context) async {
    return _file.readAsBytes();
  }

  @override
  bool operator ==(Object other) {
    return other is FilePDFSource && _file.path == other._file.path;
  }

  @override
  int get hashCode => _file.path.hashCode;
}
