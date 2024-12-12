import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:uuid/uuid.dart';

/// Establishes communication between native(Android and iOS) code
/// and flutter code using [MethodChannel]
class PdfViewerPlugin {
  int _pageCount = 0;
  List<dynamic>? _originalHeight;
  List<dynamic>? _originalWidth;
  String? _documentID;

  /// Initialize the PDF renderer.
  Future<int> initializePdfRenderer(Uint8List documentBytes) async {
    _documentID = const Uuid().v1();
    final String? pageCount = await PdfViewerPlatform.instance
        .initializePdfRenderer(documentBytes, _documentID!);
    _pageCount = int.parse(pageCount!);
    return _pageCount;
  }

  /// Get the current document ID
  String get documentID => _documentID ?? '';

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

  /// Dispose the rendered pages
  Future<void> closeDocument() async {
    imageCache.clear();
    if (_documentID != null) {
      await PdfViewerPlatform.instance.closeDocument(_documentID!);
    }
    _pageCount = 0;
    _originalWidth = null;
    _originalHeight = null;
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
