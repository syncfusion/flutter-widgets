import '../../../graphics/fonts/pdf_font.dart';
import '../../../pages/enum.dart';
import '../../../pdf_document/automatic_fields/pdf_automatic_field.dart';
import 'pdf_marker.dart';

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
/// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfOrderedMarker(
      {this.style = PdfNumberStyle.none,
      PdfFont? font,
      String suffix = '',
      String delimiter = ''}) {
    _helper = PdfOrderedMarkerHelper(this);
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfNumberStyle style = PdfNumberStyle.none;

  /// Delimiter for numbers.
  String? _delimiter;

  /// Finalizer for numbers.
  String? _suffix;
  late PdfOrderedMarkerHelper _helper;

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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get startNumber => _helper._startNumber;
  set startNumber(int value) {
    if (value <= 0) {
      throw ArgumentError('Start number should be greater than 0');
    }
    _helper._startNumber = value;
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
  /// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
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
}

/// [PdfOrderedMarker] helper
class PdfOrderedMarkerHelper extends PdfMarkerHelper {
  /// internal constructor
  PdfOrderedMarkerHelper(this.base) : super(base);

  /// internal field
  PdfOrderedMarker base;

  /// internal method
  static PdfOrderedMarkerHelper getHelper(PdfOrderedMarker base) {
    return base._helper;
  }

  /// Current index of item.
  late int currentIndex;

  /// Start number for ordered list.
  int _startNumber = 1;

  /// Gets the marker number.
  String getNumber() {
    return PdfAutomaticFieldHelper.convert(
        _startNumber + currentIndex, base.style);
  }
}
