import '../../../graphics/brushes/pdf_solid_brush.dart';
import '../../../graphics/fonts/pdf_font.dart';
import '../../../graphics/fonts/pdf_string_format.dart';
import '../../../graphics/pdf_pen.dart';
import 'enums.dart';

/// Represents base class for markers.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic))
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
abstract class PdfMarker {
  //Fields
  /// Marker font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfFont? font;

  /// Marker brush.
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
  ///       ..brush = PdfBrushes.red)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBrush? brush;

  /// Marker pen.
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
  ///       //Set the marker pen.
  ///       ..pen = PdfPens.red)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPen? pen;

  /// The string format of the marker.
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
  ///       //Set the marker format.
  ///       ..stringFormat = PdfStringFormat(alignment: PdfTextAlignment.left))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat? stringFormat;

  /// Marker alignment.
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
  ///       //Set the marker alignment.
  ///       ..alignment = PdfListMarkerAlignment.right)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListMarkerAlignment alignment = PdfListMarkerAlignment.left;

  //Properties
  /// Indicates is alignment right.
  bool get _rightToLeft => alignment == PdfListMarkerAlignment.right;

  late PdfMarkerHelper _helper;
}

/// [PdfMarker] helper
class PdfMarkerHelper {
  /// internal constructor
  PdfMarkerHelper(this.marker) {
    marker._helper = this;
  }

  /// internal field
  late PdfMarker marker;

  /// internal method
  static PdfMarkerHelper getHelper(PdfMarker marker) {
    return marker._helper;
  }

  /// internal property
  bool get rightToLeft => marker._rightToLeft;
}
