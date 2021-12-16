import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:uuid/uuid.dart';

/// Establishes communication between native(Android and iOS) code
/// and flutter code using [MethodChannel]
class PdfViewerPlugin {
  int _pageCount = 0;
  int _startPageIndex = 0;
  int _endPageIndex = 0;
  List<dynamic>? _originalHeight;
  List<dynamic>? _originalWidth;
  List<int>? _renderingPages = <int>[];
  String? _documentID;
  Map<int, List<dynamic>>? _renderedPages = <int, List<dynamic>>{};

  /// Initialize the PDF renderer.
  Future<int> initializePdfRenderer(Uint8List documentBytes) async {
    _documentID = const Uuid().v1();
    final String? pageCount = await PdfViewerPlatform.instance
        .initializePdfRenderer(documentBytes, _documentID!);
    _pageCount = int.parse(pageCount!);
    return _pageCount;
  }

  /// Retrieves original height of PDF pages.
  Future<List<dynamic>?> getPagesHeight() async {
    _originalHeight =
        await PdfViewerPlatform.instance.getPagesHeight(_documentID!);
    return _originalHeight;
  }

  /// Retrieves original width of PDF pages.
  Future<List<dynamic>?> getPagesWidth() async {
    _originalWidth =
        await PdfViewerPlatform.instance.getPagesWidth(_documentID!);
    return _originalWidth;
  }

  /// Get the specific image of PDF
  Future<Map<int, List<dynamic>>?> _getImage(
      int pageIndex, double currentScale, bool isZoomChanged) async {
    if (_renderingPages != null && !_renderingPages!.contains(pageIndex) ||
        isZoomChanged) {
      _renderingPages!.add(pageIndex);
      Future<Uint8List?> imageFuture = PdfViewerPlatform.instance
          .getImage(pageIndex, currentScale, _documentID!)
          .whenComplete(() {
        _renderingPages?.remove(pageIndex);
      });
      if (!kIsDesktop) {
        final Future<Uint8List?> image = imageFuture;
        imageFuture = imageFuture.timeout(const Duration(milliseconds: 1000),
            onTimeout: () {
          _renderingPages?.remove(pageIndex);
          return null;
        });
        imageFuture = image;
      }
      final Uint8List? image = await imageFuture;
      if (_renderedPages != null && image != null) {
        if (kIsDesktop) {
          _renderedPages![pageIndex] = Uint8List.fromList(image);
        } else {
          _renderedPages![pageIndex] = image;
        }
      }
    }
    return _renderedPages;
  }

  ///  Retrieves PDF pages as image collection for specified pages.
  Future<Map<int, List<dynamic>>?> getSpecificPages(int startPageIndex,
      int endPageIndex, double currentScale, bool isZoomChanged) async {
    imageCache!.clear();
    _startPageIndex = startPageIndex;
    _endPageIndex = endPageIndex;
    for (int pageIndex = _startPageIndex;
        pageIndex <= _endPageIndex;
        pageIndex++) {
      if (_renderedPages != null && !_renderedPages!.containsKey(pageIndex) ||
          isZoomChanged) {
        await _getImage(pageIndex, currentScale, isZoomChanged);
      }
    }
    final List<int> pdfPage = <int>[];
    _renderedPages?.forEach((int key, List<dynamic> value) {
      if (!(key >= _startPageIndex && key <= _endPageIndex)) {
        pdfPage.add(key);
      }
    });

    // ignore: avoid_function_literals_in_foreach_calls
    pdfPage.forEach((int index) {
      _renderedPages?.remove(index);
    });
    return _renderedPages;
  }

  /// Dispose the rendered pages
  Future<void> closeDocument() async {
    imageCache!.clear();
    if (_documentID != null) {
      await PdfViewerPlatform.instance.closeDocument(_documentID!);
    }
    _pageCount = 0;
    _originalWidth = null;
    _originalHeight = null;
    _renderingPages = null;
    if (_renderedPages != null) {
      _renderedPages = null;
    }
  }
}
