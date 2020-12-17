import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents a base class of PDF document provider.
/// The PDF provider can be from Asset, Memory, File and Network.
abstract class PdfProvider {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PdfProvider();

  /// Returns the path in which PDF is saved in
  /// application's temporary directory.
  Future<String> getPdfPath(BuildContext context);

  /// Returns the path defined by the user in the constructor
  String getUserPath();
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
  NetworkPdf(String url)
      : assert(url != null),
        assert(url.isNotEmpty) {
    _url = url;
  }

  /// The URL from which the PDF will be fetched.
  String _url;

  @override
  Future<String> getPdfPath(BuildContext context) async {
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(Uri.parse(_url));
      final HttpClientResponse response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      Directory directory = await path_provider.getTemporaryDirectory();
      directory = await directory.createTemp('.syncfusion');
      final filename = _url.substring(_url.lastIndexOf('/') + 1);
      File sample = File('${directory.path}/$filename');
      sample = await sample.writeAsBytes(bytes, flush: true);
      return sample.path;
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  @override
  String getUserPath() {
    return _url;
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
  MemoryPdf(Uint8List bytes) : assert(bytes != null) {
    _bytes = bytes;
  }
  Uint8List _bytes;
  Uint8List _pdfBytes;

  @override
  Future<String> getPdfPath(BuildContext context) async {
    try {
      Directory directory = await path_provider.getTemporaryDirectory();
      directory = await directory.createTemp('.syncfusion');
      final File sample = File('${directory.path}/sample.pdf');
      await sample.writeAsBytes(_bytes, flush: true);
      _pdfBytes = _bytes;
      return sample.path;
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  @override
  String getUserPath() {
    /// This variable is used to convert the bytes in collection
    /// as string for comparison
    String byteString;
    _pdfBytes?.forEach((element) {
      byteString += element.toString();
    });
    return byteString;
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
  AssetPdf(String assetName, AssetBundle bundle)
      : assert(assetName != null),
        assert(assetName.isNotEmpty) {
    _pdfPath = assetName;
    _bundle = bundle;
  }

  String _pdfPath;
  AssetBundle _bundle;

  @override
  Future<String> getPdfPath(BuildContext context) async {
    try {
      Directory directory = await path_provider.getTemporaryDirectory();
      directory = await directory.createTemp('.syncfusion');
      final filename = _pdfPath.substring(_pdfPath.lastIndexOf('/') + 1);
      final File sample = File('${directory.path}/$filename');
      final bytes = await ((_bundle != null)
          ? _bundle.load(_pdfPath)
          : DefaultAssetBundle.of(context).load(_pdfPath));
      final Uint8List pdfBytes = bytes.buffer.asUint8List();
      await sample.writeAsBytes(pdfBytes, flush: true);
      return sample.path;
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  @override
  String getUserPath() {
    return _pdfPath;
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
  FilePdf(File file) : assert(file != null) {
    _file = file;
  }
  File _file;

  @override
  Future<String> getPdfPath(BuildContext context) async {
    try {
      Directory directory = await path_provider.getTemporaryDirectory();
      directory = await directory.createTemp('.syncfusion');
      final filename = _file.path.substring(_file.path.lastIndexOf('/') + 1);
      final File sample = File('${directory.path}/$filename');
      final Uint8List bytes = File(_file.path).readAsBytesSync();
      await sample.writeAsBytes(bytes, flush: true);
      return sample.path;
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  @override
  String getUserPath() {
    return _file.path;
  }
}
