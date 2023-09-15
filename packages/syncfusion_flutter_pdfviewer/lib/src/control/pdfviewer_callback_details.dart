import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../form_fields/pdf_form_field.dart';

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

/// Holds the details for the [SfPdfViewer.onTap] callback,
/// such as [pageNumber], [position] and [pagePosition].
class PdfGestureDetails {
  /// Creates details for [SfPdfViewer.onTap] callback.
  PdfGestureDetails(this._pageNumber, this._position, this._pagePosition);
  final int _pageNumber;
  final Offset _position;
  final Offset _pagePosition;

  /// Returns the number of the page on which the tap occurred.
  ///
  /// The value of this property ranges from 1 to the total page count of the PDF document.
  ///
  /// Note: The value of this property will be -1 if the tap occurred outside any PDF page bounds.
  int get pageNumber => _pageNumber;

  /// Returns the tapped position on the [SfPdfViewer]. The coordinate space starts at the top-left of the [SfPdfViewer] widget.
  Offset get position => _position;

  /// Returns the tapped position in the PDF page coordinates which have their origin at the top left corner of the page.
  ///
  /// Note: The tapped page is indicated by the [pageNumber] property. The value of this property will be (-1,-1) if the tap occurred outside page bounds.
  Offset get pagePosition => _pagePosition;
}

/// Holds the details for the [SfPdfViewer.onFormFieldValueChanged] callback,
/// such as [formField], [oldValue] and [newValue].
class PdfFormFieldValueChangedDetails {
  /// Creates details for [SfPdfViewer.onFormFieldValueChanged] callback.
  PdfFormFieldValueChangedDetails(
      this._formField, this._oldValue, this._newValue);
  final PdfFormField _formField;
  final Object? _oldValue;
  final Object? _newValue;

  /// Returns the form field object that has value changed.
  PdfFormField get formField => _formField;

  /// The old value of the form field.
  Object? get oldValue => _oldValue;

  /// The new value of the form field.
  Object? get newValue => _newValue;
}

/// Holds the details for the [SfPdfViewer.onFormFieldFocusChange] callback,
/// such as [formField] and [hasFocus].
class PdfFormFieldFocusChangeDetails {
  /// Creates details for [SfPdfViewer.onFormFieldFocusChange] callback.
  PdfFormFieldFocusChangeDetails(this._formField, this._hasFocus);
  final PdfFormField _formField;
  final bool _hasFocus;

  /// Returns the form field object that has focus changes.
  PdfFormField get formField => _formField;

  /// Indicates whether the form field has focus or not.
  bool get hasFocus => _hasFocus;
}
