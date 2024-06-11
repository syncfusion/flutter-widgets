import 'dart:async';
import 'package:flutter/services.dart';
import 'package:syncfusion_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';

class MethodChannelPdfViewer extends PdfViewerPlatform {
  final MethodChannel _channel = MethodChannel('syncfusion_flutter_pdfviewer');

  /// Initializes the PDF renderer instance in respective platform by loading the PDF from the provided byte information.
  /// If success, returns page count else returns error message from respective platform
  @override
  Future<String?> initializePdfRenderer(
      Uint8List documentBytes, String documentID) async {
    return _channel.invokeMethod('initializePdfRenderer', <String, dynamic>{
      'documentBytes': documentBytes,
      'documentID': documentID
    });
  }

  /// Gets the height of all pages in the document.
  @override
  Future<List?> getPagesHeight(String documentID) async {
    return _channel.invokeMethod('getPagesHeight', documentID);
  }

  /// Gets the width of all pages in the document.
  @override
  Future<List?> getPagesWidth(String documentID) async {
    return _channel.invokeMethod('getPagesWidth', documentID);
  }

  /// Gets the image bytes of the specified page from the document at the specified width and height.
  @override
  Future<Uint8List?> getPage(
      int pageNumber, int width, int height, String documentID) async {
    return _channel.invokeMethod<Uint8List>('getPage', <String, dynamic>{
      'index': pageNumber,
      'width': width,
      'height': height,
      'documentID': documentID
    });
  }

  /// Gets the image's bytes information of the specified portion of the page
  @override
  Future<Uint8List?> getTileImage(int pageNumber, double currentScale, double x,
      double y, double width, double height, String documentID) async {
    return _channel.invokeMethod<Uint8List>('getTileImage', <String, dynamic>{
      'pageNumber': pageNumber,
      'scale': currentScale,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'documentID': documentID
    });
  }

  /// Closes the PDF document.
  @override
  Future<void> closeDocument(String documentID) async {
    return _channel.invokeMethod('closeDocument', documentID);
  }
}
