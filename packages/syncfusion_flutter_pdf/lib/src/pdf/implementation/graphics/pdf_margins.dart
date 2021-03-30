part of pdf;

/// A class representing PDF page margins.
///
/// ```dart
/// //Creates a new PDF document.
/// PdfDocument document = PdfDocument()
///   //Create and set new PDF margin.
///   ..pageSettings.margins = (PdfMargins()..all = 20)
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
/// //Saves the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfMargins {
  //Constructor
  /// Initializes a new instance of the [PdfMargins] class.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()..all = 20)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfMargins();

  //Fields
  double _left = 0;
  double _top = 0;
  double _right = 0;
  double _bottom = 0;
  bool _isPageAdded = false;

  //Properties
  /// Gets or sets the left margin size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()
  ///     ..left = 20
  ///     ..right = 40
  ///     ..top = 100
  ///     ..bottom = 100)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get left => _left;
  set left(double value) {
    if (_left != value && !_isPageAdded) {
      _left = value;
    }
  }

  /// Gets or sets the top margin size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()
  ///     ..left = 20
  ///     ..right = 40
  ///     ..top = 100
  ///     ..bottom = 100)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get top => _top;
  set top(double value) {
    if (_top != value && !_isPageAdded) {
      _top = value;
    }
  }

  /// Gets or sets the right margin size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()
  ///     ..left = 20
  ///     ..right = 40
  ///     ..top = 100
  ///     ..bottom = 100)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get right => _right;
  set right(double value) {
    if (_right != value && !_isPageAdded) {
      _right = value;
    }
  }

  /// Gets or sets the bottom margin size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()
  ///     ..left = 20
  ///     ..right = 40
  ///     ..top = 100
  ///     ..bottom = 100)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get bottom => _bottom;
  set bottom(double value) {
    if (_bottom != value && !_isPageAdded) {
      _bottom = value;
    }
  }

  /// Sets the margins of all side.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   //Create and set new PDF margin.
  ///   ..pageSettings.margins = (PdfMargins()..all = 20)
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  /// //Saves the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  set all(double value) {
    if (!_isPageAdded) {
      _setMargins(value);
    }
  }

  //Implementation
  void _setMargins(double margin) {
    left = top = right = bottom = margin;
  }

  void _setMarginsLT(double leftRight, double topBottom) {
    left = right = leftRight;
    top = bottom = topBottom;
  }

  void _setMarginsAll(double l, double t, double r, double b) {
    left = l;
    right = r;
    top = t;
    bottom = b;
  }

  bool _equals(PdfMargins margins) {
    return _left == margins.left &&
        _top == margins._top &&
        _right == margins._right &&
        _bottom == margins._bottom;
  }

  PdfMargins _clone() {
    final PdfMargins result = PdfMargins();
    result.left = left.toDouble();
    result.right = right.toDouble();
    result.top = top.toDouble();
    result.bottom = bottom.toDouble();
    return result;
  }
}
