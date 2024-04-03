import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:uuid/uuid.dart';

import 'pdfviewer_helper.dart';

/// Establishes communication between native(Android and iOS) code
/// and flutter code using [MethodChannel]
class PdfViewerPlugin {
  int _pageCount = 0;
  List<dynamic>? _originalHeight;
  List<dynamic>? _originalWidth;
  List<RenderedImage>? _renderingPages = <RenderedImage>[];
  String? _documentID;
  Map<int, List<dynamic>>? _renderedPages = <int, List<dynamic>>{};
  Map<int, double>? _pageScale = <int, double>{};
  CancelableOperation<Uint8List?>? _nativeImage;
  CancelableOperation<Uint8List?>? _tileImage;

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

  bool _hasRenderedImage(int pageIndex, double scale, bool considerScale) {
    bool hasImage = false;
    _renderingPages?.forEach((RenderedImage image) {
      if ((image.pageIndex == pageIndex && !considerScale) ||
          (image.pageIndex == pageIndex &&
              considerScale &&
              image.scale == scale)) {
        hasImage = true;
      }
    });
    return hasImage;
  }

  /// Get the specific image of PDF
  Future<Map<int, List<dynamic>>?> _getImage(int pageIndex, double currentScale,
      bool isZoomChanged, int currentPageNumber) async {
    if (_renderingPages != null &&
        (!_hasRenderedImage(pageIndex, currentScale, false) ||
            (isZoomChanged &&
                pageIndex == currentPageNumber &&
                !_hasRenderedImage(pageIndex, currentScale, true)))) {
      final RenderedImage renderedImage =
          RenderedImage(pageIndex, currentScale);
      _renderingPages!.add(renderedImage);
      _nativeImage = CancelableOperation<Uint8List?>.fromFuture(
          PdfViewerPlatform.instance
              .getImage(pageIndex, currentScale, _documentID!));
      Future<Uint8List?> imageFuture = _nativeImage!.value.whenComplete(() {
        _renderingPages?.remove(renderedImage);
      });
      if (!kIsDesktop) {
        final Future<Uint8List?> image = imageFuture;
        imageFuture = imageFuture.timeout(const Duration(milliseconds: 3000),
            onTimeout: () {
          _renderingPages?.remove(renderedImage);
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
  Future<Map<int, List<dynamic>>?> getSpecificPages(
      int startPageIndex,
      int endPageIndex,
      double currentScale,
      bool isZoomChanged,
      int currentPageNumber,
      bool canRenderImage) async {
    currentScale = currentScale > 1.75 ? 1.75 : currentScale;
    imageCache.clear();
    if (!canRenderImage) {
      _nativeImage?.cancel();
      _renderingPages?.clear();
      return _renderedPages;
    }
    for (int pageIndex = startPageIndex;
        pageIndex <= endPageIndex;
        pageIndex++) {
      if (_renderedPages != null &&
          (!_renderedPages!.containsKey(pageIndex) ||
              (isZoomChanged &&
                  pageIndex == currentPageNumber &&
                  currentScale > 1.75))) {
        currentScale = (pageIndex == currentPageNumber) ? currentScale : 1.0;
        if (_pageScale != null &&
            (!_pageScale!.containsKey(pageIndex) ||
                _pageScale![pageIndex] != currentScale)) {
          _pageScale![pageIndex] = currentScale;
          await _getImage(
              pageIndex, currentScale, isZoomChanged, currentPageNumber);
        }
      }
    }
    final List<int> pdfPage = <int>[];
    _renderedPages?.forEach((int key, List<dynamic> value) {
      if (!(key >= startPageIndex && key <= endPageIndex)) {
        pdfPage.add(key);
      }
    });
    if (_pageScale != null) {
      for (int index = _pageScale!.length - 1; index >= 0; index--) {
        if (!_renderedPages!.containsKey(_pageScale!.keys.elementAt(index))) {
          _pageScale!.remove(_pageScale!.keys.elementAt(index));
        }
      }
    }

    // ignore: avoid_function_literals_in_foreach_calls
    pdfPage.forEach((int index) {
      _renderedPages?.remove(index);
    });
    return Future<Map<int, List<dynamic>>?>.value(_renderedPages);
  }

  /// Returns the tile image of the specified page.
  Future<Uint8List?>? getTileImage(int pageNumber, double scale, double x,
      double y, double width, double height) async {
    _tileImage = CancelableOperation<Uint8List?>.fromFuture(PdfViewerPlatform
        .instance
        .getTileImage(pageNumber, scale, x, y, width, height, _documentID!));
    final Future<Uint8List?> imageFuture = _tileImage!.value;
    final Uint8List? image = await imageFuture;
    if (image != null) {
      return image;
    }
    return null;
  }

  /// Dispose the rendered pages
  Future<void> closeDocument() async {
    imageCache.clear();
    if (_documentID != null) {
      await PdfViewerPlatform.instance.closeDocument(_documentID!);
    }
    _pageCount = 0;
    _originalWidth = null;
    _originalHeight = null;
    _renderingPages = null;
    _nativeImage?.cancel();
    _nativeImage = null;
    if (_renderedPages != null) {
      _renderedPages = null;
    }
    if (_pageScale != null) {
      _pageScale = null;
    }
  }
}

/// Represents the RenderedImage.
class RenderedImage {
  /// Initializes RenderedImage properties.
  RenderedImage(int index, double currentScale) {
    pageIndex = index;
    scale = currentScale;
  }

  /// Page index of RenderedImage
  late final int pageIndex;

  /// Scale value of RenderedImage
  late final double scale;
}
