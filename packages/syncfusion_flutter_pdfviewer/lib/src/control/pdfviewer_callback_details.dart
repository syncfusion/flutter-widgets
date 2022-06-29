import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Holds the details for the [SfPdfViewer.onPageChanged] callback,
/// such as [newPageNumber], [oldPageNumber], [isFirstPage] and [isLastPage].
class PdfPageChangedDetails {
  /// Creates details for [SfPdfViewer.onPageChanged] callback.
  PdfPageChangedDetails(int newPage, int oldPage, bool isFirst, bool isLast) {
    _newPageNumber = newPage;
    _oldPageNumber = oldPage;
    _isFirstPage = isFirst;
    _isLastPage = isLast;
  }

  late bool _isFirstPage;

  /// Indicates whether the new page in the [SfPdfViewer] is the first page or not.
  bool get isFirstPage {
    return _isFirstPage;
  }

  late bool _isLastPage;

  /// Indicates whether the new page in the [SfPdfViewer] is the last page or not.
  bool get isLastPage {
    return _isLastPage;
  }

  int _newPageNumber = 0;

  /// The current page number to which the document is navigated to.
  int get newPageNumber {
    return _newPageNumber;
  }

  int _oldPageNumber = 0;

  /// The page number from which the navigation was initiated.
  int get oldPageNumber {
    return _oldPageNumber;
  }
}

/// Holds the details for the [SfPdfViewer.onZoomLevelChanged] callback,
/// such as [newZoomLevel] and [oldZoomLevel].
class PdfZoomDetails {
  /// Creates details for [SfPdfViewer.onZoomLevelChanged] callback.
  PdfZoomDetails(double newZoomLevel, double oldZoomLevel) {
    _newZoomLevel = newZoomLevel;
    _oldZoomLevel = oldZoomLevel;
  }

  late double _newZoomLevel;

  /// Current zoom level to which the document is zoomed to.
  double get newZoomLevel {
    return _newZoomLevel;
  }

  late double _oldZoomLevel;

  /// Zoom level from which the zooming was initiated.
  double get oldZoomLevel {
    return _oldZoomLevel;
  }
}

/// Holds the details for the [SfPdfViewer.onDocumentLoaded] callback,
/// such as [document].
class PdfDocumentLoadedDetails {
  /// Creates details for [SfPdfViewer.onDocumentLoaded] callback.
  PdfDocumentLoadedDetails(PdfDocument document) {
    _document = document;
  }

  late PdfDocument _document;

  /// Loaded [PdfDocument] instance.
  PdfDocument get document {
    return _document;
  }
}

/// Holds the details for the [SfPdfViewer.onDocumentLoadFailed] callback,
/// such as [error] and [description].
class PdfDocumentLoadFailedDetails {
  /// Creates details for [SfPdfViewer.onDocumentLoadFailed] callback.
  PdfDocumentLoadFailedDetails(String error, String description) {
    _error = error;
    _description = description;
  }

  late String _error;

  /// Error title of the document load failed condition.
  String get error {
    return _error;
  }

  late String _description;

  /// Error description of the document load failed condition.
  String get description {
    return _description;
  }
}

/// Holds the details for the [SfPdfViewer.onTextSelectionChanged] callback,
/// such as [globalSelectedRegion] and [selectedText].
class PdfTextSelectionChangedDetails {
  ///
  PdfTextSelectionChangedDetails(
      String? selectedText, Rect? globalSelectedRegion) {
    _selectedText = selectedText;
    _globalSelectedRegion = globalSelectedRegion;
  }

  String? _selectedText;

  /// Selected text value.
  String? get selectedText {
    return _selectedText;
  }

  Rect? _globalSelectedRegion;

  /// The global bounds information of the selected text region.
  Rect? get globalSelectedRegion {
    return _globalSelectedRegion;
  }
}

/// Holds the details for the [SfPdfViewer.onHyperlinkClicked] callback,
/// such as [uri].
class PdfHyperlinkClickedDetails {
  /// Creates details for [SfPdfViewer.onHyperlinkClicked] callback.
  PdfHyperlinkClickedDetails(
    String uri,
  ) {
    _uri = uri;
  }

  late String _uri;

  /// Holds the uri of the selected text
  String get uri {
    return _uri;
  }
}
