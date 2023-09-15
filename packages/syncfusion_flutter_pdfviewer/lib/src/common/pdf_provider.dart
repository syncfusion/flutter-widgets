// ignore_for_file: only_throw_errors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../pdfviewer.dart';

/// Represents a base class of PDF document provider.
/// The PDF provider can be from Asset, Memory, File and Network.
abstract class PdfProvider {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PdfProvider();

  /// Returns the byte information of PDF document.
  Future<Uint8List> getPdfBytes(BuildContext context);
}

/// Fetches the given PDF URL from the network.
///
/// The PDF will be fetched and saved in local temporary directory for PDF
/// manipulation.
///
/// See also:
///
///  * [SfPdfViewer.network] for a shorthand of an [SfPdfViewer] widget backed by [NetworkPdf].
class NetworkPdf extends PdfProvider {
  /// Creates an object that fetches the PDF at the given URL.
  ///
  /// The arguments [url] must not be null.
  NetworkPdf(String url, Map<String, String>? headers)
      : assert(url.isNotEmpty) {
    _url = url;
    _headers = headers;
  }

  /// The URL from which the PDF will be fetched.
  late String _url;

  /// The document headers
  Map<String, String>? _headers;

  /// The document bytes
  Uint8List? _documentBytes;

  @override
  Future<Uint8List> getPdfBytes(BuildContext context) async {
    if (_documentBytes == null) {
      try {
        _documentBytes =
            await http.readBytes(Uri.parse(_url), headers: _headers);
      } on Exception catch (e) {
        throw e.toString();
      }
    }
    return Future<Uint8List>.value(_documentBytes);
  }
}

/// Decodes the given [Uint8List] buffer as an image
///
/// The provided [bytes] buffer should not be changed after it is provided
/// to a [MemoryPdf].
///
/// See also:
///
///  * [SfPdfViewer.memory] for a shorthand of an [SfPdfViewer] widget backed by [MemoryPdf].
class MemoryPdf extends PdfProvider {
  /// Creates an object that decodes a [Uint8List] buffer as a PDF.
  ///
  /// The arguments must not be null.
  MemoryPdf(Uint8List bytes) {
    _pdfBytes = bytes;
  }

  late Uint8List _pdfBytes;

  @override
  Future<Uint8List> getPdfBytes(BuildContext context) async {
    return Future<Uint8List>.value(_pdfBytes);
  }
}

/// Fetches a PDF from an [AssetBundle]
///
/// This class behaves like similar to [Image.asset].
///
/// See also:
///
///  * [SfPdfViewer.asset] for a shorthand of an [SfPdfViewer] widget backed by
///    [AssetPdf].
class AssetPdf extends PdfProvider {
  /// Creates an object that fetches the given PDF from an asset bundle.
  ///
  /// [assetName] must not be null.
  AssetPdf(String assetName, AssetBundle? bundle)
      : assert(assetName.isNotEmpty) {
    _pdfPath = assetName;
    _bundle = bundle;
  }

  late String _pdfPath;
  AssetBundle? _bundle;
  Uint8List? _documentBytes;

  @override
  Future<Uint8List> getPdfBytes(BuildContext context) async {
    if (_documentBytes == null) {
      try {
        final ByteData bytes = await ((_bundle != null)
            ? _bundle!.load(_pdfPath)
            : DefaultAssetBundle.of(context).load(_pdfPath));
        _documentBytes = bytes.buffer.asUint8List();
      } on Exception catch (e) {
        throw e.toString();
      }
    }
    return Future<Uint8List>.value(_documentBytes);
  }
}

/// Decodes the given [File] object as a PDF.
///
/// See also:
///
///  * [SfPdfViewer.file] for a shorthand of an [SfPdfViewer] widget backed by [FilePdf].
class FilePdf extends PdfProvider {
  /// Creates an object that decodes a [File] as a PDF.
  ///
  /// The [file] must not be null.
  FilePdf(File file) {
    _file = file;
  }

  late File _file;

  /// The document bytes
  Uint8List? _documentBytes;

  @override
  Future<Uint8List> getPdfBytes(BuildContext context) async {
    if (_documentBytes == null) {
      try {
        _documentBytes = await _file.readAsBytes();
      } on Exception catch (e) {
        throw e.toString();
      }
    }
    return Future<Uint8List>.value(_documentBytes);
  }
}
