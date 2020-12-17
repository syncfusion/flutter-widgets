import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Establishes communication between native(Android and iOS) code
/// and flutter code using [MethodChannel]
class PdfViewerPlugin {
  /// Creates a instance of [PdfViewerPlugin]
  PdfViewerPlugin(String path) {
    _pdfPath = path;
  }

  final MethodChannel _channel = MethodChannel('syncfusion_flutter_pdfviewer');
  int _pageCount = 0;
  List _originalHeight;
  List _originalWidth;
  Map<int, List> _renderedPages = {};
  String _pdfPath;

  /// Initialize the PDF renderer.
  Future<int> initializePdfRenderer() async {
    final String pageCount =
        await _channel.invokeMethod('initializepdfrenderer', _pdfPath);
    _pageCount = int.parse(pageCount);
    return _pageCount;
  }

  /// Retrieves original height of PDF pages.
  Future<List> getPagesHeight() async {
    _originalHeight = await _channel.invokeMethod('getpagesheight', _pdfPath);
    return _originalHeight;
  }

  /// Retrieves original width of PDF pages.
  Future<List> getPagesWidth() async {
    _originalWidth = await _channel.invokeMethod('getpageswidth', _pdfPath);
    return _originalWidth;
  }

  /// Get the specific image of PDF
  Future<Map<int, List>> _getImage(int pageIndex) async {
    final List images = await _channel.invokeMethod(
        'getimage', <String, dynamic>{'index': pageIndex, 'path': _pdfPath});
    if (_renderedPages != null) {
      _renderedPages[pageIndex] = images[0];
    }
    return _renderedPages;
  }

  ///  Retrieves PDF pages as image collection for specified pages.
  Future<Map<int, List>> getSpecificPages(
      int startPageIndex, int endPageIndex) async {
    imageCache.clear();
    for (int pageIndex = startPageIndex;
        pageIndex <= endPageIndex;
        pageIndex++) {
      if (_renderedPages != null && !_renderedPages.containsKey(pageIndex)) {
        await _getImage(pageIndex);
      }
    }
    final pdfPage = [];
    _renderedPages?.forEach((key, value) {
      if (!(key >= startPageIndex && key <= endPageIndex)) {
        pdfPage.add(key);
      }
    });
    pdfPage.forEach((index) {
      _renderedPages?.remove(index);
    });
    return _renderedPages;
  }

  /// Dispose the rendered pages
  void disposePages() async {
    imageCache.clear();
    await _channel.invokeMethod('dispose');
    _pageCount = null;
    _originalWidth = null;
    _originalHeight = null;
    if (_renderedPages != null) {
      _renderedPages = null;
    }
  }
}
