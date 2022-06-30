import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../graphics/pdf_pen.dart';
import 'pdf_list.dart';

/// Represents list item of the list.
///
/// ```dart
/// //Create a new instance of PdfDocument class.
/// PdfDocument document = PdfDocument();
/// //Create a new list.
/// PdfOrderedList(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
///         style: PdfFontStyle.italic))
///   ..items.add(
///       //Create list item.
///       PdfListItem(text: 'PDF'))
///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfListItem {
  //Constructor
  /// Initializes a new instance of the [PdfListItem] class.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
  ///         style: PdfFontStyle.italic))
  ///   ..items.add(
  ///       //Create list item.
  ///       PdfListItem(text: 'PDF'))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItem(
      {this.text = '',
      this.font,
      PdfStringFormat? format,
      this.pen,
      this.brush,
      this.subList}) {
    stringFormat = format;
  }

  //Fields
  /// Holds item font.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfFont? font;

  /// Holds text format.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat? stringFormat;

  /// Holds pen.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPen? pen;

  /// Holds brush.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBrush? brush;

  /// Adds the Sub list.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(text: 'Essential tools')
  ///     //Add sub list.
  ///     ..subList = PdfOrderedList(items: PdfListItemCollection(['PDF'])))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfList? subList;

  /// Text indent for current item.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red)
  ///         ..textIndent = 10)
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double textIndent = 0;

  //Properties
  /// Gets or sets item text.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList()
  ///   ..items.add(PdfListItem(
  ///       text: 'PDF',
  ///       font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left),
  ///       pen: PdfPens.green,
  ///       brush: PdfBrushes.red))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String text = '';
}
