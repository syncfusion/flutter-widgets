import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';

class MethodChannelPdfViewer extends PdfViewerPlatform {
  final MethodChannel _channel = MethodChannel('syncfusion_flutter_pdfviewer');

  /// Initializes the PDF renderer instance in respective platform by loading the PDF from the provided byte information.
  /// If success, returns page count else returns error message from respective platform
  @override
  Future<String?> initializePdfRenderer(Uint8List documentBytes) async {
    return _channel.invokeMethod('initializePdfRenderer', documentBytes);
  }

  /// Gets the height of all pages in the document.
  @override
  Future<List?> getPagesHeight() async {
    return _channel.invokeMethod('getPagesHeight');
  }

  /// Gets the width of all pages in the document.
  @override
  Future<List?> getPagesWidth() async {
    return _channel.invokeMethod('getPagesWidth');
  }

  /// Gets the image's bytes information of the specified page.
  @override
  Future<Uint8List?> getImage(int pageNumber) async {
    return _channel.invokeMethod<Uint8List>(
        'getImage', <String, dynamic>{'index': pageNumber});
  }

  /// Closes the PDF document.
  @override
  Future<void> closeDocument() async {
    return _channel.invokeMethod('closeDocument');
  }
}
