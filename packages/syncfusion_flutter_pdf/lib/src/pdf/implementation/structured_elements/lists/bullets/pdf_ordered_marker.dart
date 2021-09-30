part of pdf;

/// Represents marker for ordered list.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     marker: //Create a new ordered marker.
///         PdfOrderedMarker(style: PdfNumberStyle.numeric))
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfOrderedMarker extends PdfMarker {
  //Constructor
  /// Initializes a new instance of the [PdfOrderedMarker] class.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: //Create a new ordered marker.
  ///         PdfOrderedMarker(style: PdfNumberStyle.numeric))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfOrderedMarker(
      {this.style = PdfNumberStyle.none,
      PdfFont? font,
      String suffix = '',
      String delimiter = ''}) {
    _delimiter = delimiter;
    _suffix = suffix;
    this.font = font;
  }

  //Fields
  /// Holds numbering style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: //Create a new ordered marker.
  ///         PdfOrderedMarker(style: PdfNumberStyle.numeric))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfNumberStyle style = PdfNumberStyle.none;

  /// Start number for ordered list.
  int _startNumber = 1;

  /// Delimiter for numbers.
  String? _delimiter;

  /// Finalizer for numbers.
  String? _suffix;

  /// Current index of item.
  late int _currentIndex;

  //Properties
  /// Gets or sets start number for ordered list. Default value is 1.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric)
  ///       //Set the start number.
  ///       ..startNumber = 2)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get startNumber => _startNumber;
  set startNumber(int value) {
    if (value <= 0) {
      throw ArgumentError('Start number should be greater than 0');
    }
    _startNumber = value;
  }

  /// Gets or sets the delimiter.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..items[0].subList = PdfOrderedList(
  ///       items: PdfListItemCollection(['PDF', 'DocIO']),
  ///       marker: PdfOrderedMarker(
  ///           style: PdfNumberStyle.numeric, delimiter: ',', suffix: ')'))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get delimiter {
    if (_delimiter == '' || _delimiter == null) {
      return '.';
    }
    return _delimiter!;
  }

  set delimiter(String value) => _delimiter = value;

  /// Gets or sets the suffix of the marker.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..items[0].subList = PdfOrderedList(
  ///       items: PdfListItemCollection(['PDF', 'DocIO']),
  ///       marker: PdfOrderedMarker(
  ///           style: PdfNumberStyle.numeric, delimiter: ',', suffix: ')'))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get suffix {
    if (_suffix == null || _suffix == '') {
      return '.';
    }
    return _suffix!;
  }

  set suffix(String value) => _suffix = value;

  //Implementation
  /// Gets the marker number.
  String _getNumber() {
    return PdfAutomaticField._convert(_startNumber + _currentIndex, style);
  }
}
