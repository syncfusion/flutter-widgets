import 'package:flutter/material.dart';

/// The class PdfTextLine represents the selected text line
/// which contains the text and the bounding rectangular size relative to the page dimension
/// and page number in which text selection is happened.
class PdfTextLine {
  /// Constructor of PdfTextLine.
  PdfTextLine(Rect bounds, String text, int pageNumber) {
    _bounds = bounds;
    _text = text;
    _pageNumber = pageNumber;
  }

  late Rect _bounds;

  /// Gets the bounds of the selected region line relative to the page dimension.
  Rect get bounds {
    return _bounds;
  }

  late String _text;

  /// Gets the text of the selected region line.
  String get text {
    return _text;
  }

  late int _pageNumber;

  /// Gets the page number in which text is selected.
  int get pageNumber {
    return _pageNumber;
  }
}
