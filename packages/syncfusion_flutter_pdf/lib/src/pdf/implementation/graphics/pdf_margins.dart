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
/// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfMargins() {
    _helper = PdfMarginsHelper(this);
  }

  //Fields
  late PdfMarginsHelper _helper;
  double _left = 0;
  double _top = 0;
  double _right = 0;
  double _bottom = 0;

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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get left => _left;
  set left(double value) {
    if (_left != value && !_helper.isPageAdded) {
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get top => _top;
  set top(double value) {
    if (_top != value && !_helper.isPageAdded) {
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get right => _right;
  set right(double value) {
    if (_right != value && !_helper.isPageAdded) {
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get bottom => _bottom;
  set bottom(double value) {
    if (_bottom != value && !_helper.isPageAdded) {
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  // ignore: avoid_setters_without_getters
  set all(double value) {
    if (!_helper.isPageAdded) {
      _helper.setMargins(value);
    }
  }
}

/// [PdfMargins] helper
class PdfMarginsHelper {
  /// internal constructor
  PdfMarginsHelper(this.base);

  /// internal field
  late PdfMargins base;

  /// internal field
  // ignore: prefer_final_fields
  bool isPageAdded = false;

  /// internal method
  static PdfMarginsHelper getHelper(PdfMargins base) {
    return base._helper;
  }

  /// internal method
  void setMargins(double margin) {
    base.left = base.top = base.right = base.bottom = margin;
  }

  /// internal method
  void setMarginsLT(double leftRight, double topBottom) {
    base.left = base.right = leftRight;
    base.top = base.bottom = topBottom;
  }

  /// internal method
  void setMarginsAll(double l, double t, double r, double b) {
    base.left = l;
    base.right = r;
    base.top = t;
    base.bottom = b;
  }

  /// internal method
  bool equals(PdfMargins margins) {
    return base._left == margins.left &&
        base._top == margins._top &&
        base._right == margins._right &&
        base._bottom == margins._bottom;
  }

  /// internal method
  PdfMargins clone() {
    final PdfMargins result = PdfMargins();
    result.left = base.left;
    result.right = base.right;
    result.top = base.top;
    result.bottom = base.bottom;
    return result;
  }
}
