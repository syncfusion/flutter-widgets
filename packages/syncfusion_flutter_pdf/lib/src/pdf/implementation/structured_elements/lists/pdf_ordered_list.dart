import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../pages/enum.dart';
import 'bullets/pdf_ordered_marker.dart';
import 'pdf_list.dart';
import 'pdf_list_item_collection.dart';

/// Represents the ordered list.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     items: PdfListItemCollection(['PDF', 'XlsIO', 'DocIO', 'PPT']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20),
///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
///     style: PdfNumberStyle.numeric,
///     indent: 15,
///     textIndent: 10)
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfOrderedList extends PdfList {
  //Constructor
  /// Initialize a new instance of the [PdfOrderedList] class.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfOrderedList(
      {PdfOrderedMarker? marker,
      PdfListItemCollection? items,
      String? text,
      PdfFont? font,
      PdfNumberStyle style = PdfNumberStyle.numeric,
      PdfStringFormat? format,
      this.markerHierarchy = false,
      double indent = 10,
      double textIndent = 5})
      : super() {
    final PdfListHelper helper = PdfListHelper(this);
    this.marker = marker ?? _createMarker(style);
    stringFormat = format;
    super.indent = indent;
    super.textIndent = textIndent;
    if (font != null) {
      helper.font = font;
    }
    if (items != null) {
      helper.items = items;
    } else if (text != null) {
      helper.items = PdfListHelper.createItems(text);
    }
  }

  /// True if user want to use numbering hierarchy, otherwise false.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///             items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///             font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///                 style: PdfFontStyle.italic))
  ///         .items[0]
  ///         .subList =
  ///     PdfOrderedList(
  ///         items: PdfListItemCollection(['PDF', 'XlsIO', 'DocIO', 'PPT'])
  ///         markerHierarchy: true)
  ///       ..draw(
  ///           page: document.pages.add(),
  ///           bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool markerHierarchy;

  /// Gets or sets marker of the list items.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late PdfOrderedMarker marker;

  //Static methods.
  //Creates the marker.
  static PdfOrderedMarker _createMarker(PdfNumberStyle style) {
    return PdfOrderedMarker(style: style);
  }
}
