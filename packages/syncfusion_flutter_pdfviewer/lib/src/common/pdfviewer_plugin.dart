import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Establishes communication between native(Android and iOS) code
/// and flutter code using [MethodChannel]
class PdfViewerPlugin {
  int _pageCount = 0;
  int _startPageIndex = 0;
  int _endPageIndex = 0;
  List? _originalHeight;
  List? _originalWidth;
  List? _renderingPages = [];
  Map<int, List>? _renderedPages = {};

  /// Initialize the PDF renderer.
  Future<int> initializePdfRenderer(Uint8List documentBytes) async {
    final pageCount =
        await PdfViewerPlatform.instance.initializePdfRenderer(documentBytes);
    _pageCount = int.parse(pageCount!);
    return _pageCount;
  }

  /// Retrieves original height of PDF pages.
  Future<List?> getPagesHeight() async {
    _originalHeight = await PdfViewerPlatform.instance.getPagesHeight();
    return _originalHeight;
  }

  /// Retrieves original width of PDF pages.
  Future<List?> getPagesWidth() async {
    _originalWidth = await PdfViewerPlatform.instance.getPagesWidth();
    return _originalWidth;
  }

  /// Get the specific image of PDF
  Future<Map<int, List>?> _getImage(int pageIndex) async {
    if (_renderingPages != null && !_renderingPages!.contains(pageIndex)) {
      _renderingPages!.add(pageIndex);
      Future<Uint8List?> imageFuture =
          PdfViewerPlatform.instance.getImage(pageIndex).whenComplete(() {
        _renderingPages?.remove(pageIndex);
      });
      if (!kIsWeb) {
        imageFuture =
            imageFuture.timeout(Duration(milliseconds: 1000), onTimeout: () {
          _renderingPages?.remove(pageIndex);
          return null;
        });
      }
      final Uint8List? image = await imageFuture;
      if (_renderedPages != null && image != null) {
        if (kIsWeb) {
          _renderedPages![pageIndex] = Uint8List.fromList(image);
        } else {
          _renderedPages![pageIndex] = image;
        }
      }
    }
    return _renderedPages;
  }

  ///  Retrieves PDF pages as image collection for specified pages.
  Future<Map<int, List>?> getSpecificPages(
      int startPageIndex, int endPageIndex) async {
    imageCache!.clear();
    _startPageIndex = startPageIndex;
    _endPageIndex = endPageIndex;
    for (int pageIndex = _startPageIndex;
        pageIndex <= _endPageIndex;
        pageIndex++) {
      if (_renderedPages != null && !_renderedPages!.containsKey(pageIndex)) {
        await _getImage(pageIndex);
      }
    }
    final pdfPage = [];
    _renderedPages?.forEach((key, value) {
      if (!(key >= _startPageIndex && key <= _endPageIndex)) {
        pdfPage.add(key);
      }
    });
    pdfPage.forEach((index) {
      _renderedPages?.remove(index);
    });
    return _renderedPages;
  }

  /// Dispose the rendered pages
  Future<void> closeDocument() async {
    imageCache!.clear();
    await PdfViewerPlatform.instance.closeDocument();
    _pageCount = 0;
    _originalWidth = null;
    _originalHeight = null;
    _renderingPages = null;
    if (_renderedPages != null) {
      _renderedPages = null;
    }
  }
}
