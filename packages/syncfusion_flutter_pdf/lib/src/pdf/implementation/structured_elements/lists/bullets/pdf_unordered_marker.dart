import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../graphics/brushes/pdf_solid_brush.dart';
import '../../../graphics/figures/pdf_template.dart';
import '../../../graphics/fonts/pdf_font.dart';
import '../../../graphics/pdf_graphics.dart';
import '../../../graphics/pdf_pen.dart';
import '../bullets/enums.dart';
import '../pdf_list.dart';
import 'pdf_marker.dart';

/// Represents bullet for the list.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new unordered list.
/// PdfUnorderedList uList = PdfUnorderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     marker: //Create an unordered marker.
///         PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfUnorderedMarker extends PdfMarker {
  //Constructor
  /// Initializes a new instance of the [PdfUnorderedMarker] class
  /// with Pdf unordered marker style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList uList = PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: //Create an unordered marker.
  ///         PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfUnorderedMarker(
      {this.style = PdfUnorderedMarkerStyle.none,
      PdfFont? font,
      String? text,
      PdfTemplate? template}) {
    _helper = PdfUnorderedMarkerHelper(this);
    if (font != null) {
      this.font = font;
    }
    if (text != null) {
      this.text = text;
      style = PdfUnorderedMarkerStyle.customString;
    } else if (template != null) {
      _template = template;
      style = PdfUnorderedMarkerStyle.customTemplate;
    }
  }

  //Fields
  /// Gets and sets the marker style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfUnorderedMarkerStyle style = PdfUnorderedMarkerStyle.none;

  /// Holds the marker text.
  String? _text;

  // /// Holds the marker image.
  // PdfImage _image;

  /// Marker temlapte.
  PdfTemplate? _template;
  late PdfUnorderedMarkerHelper _helper;

  //Properties
  /// Gets or sets template of the marker.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(template: (PdfTemplate(100, 100)
  ///         ..graphics!.drawRectangle(
  ///             brush: PdfBrushes.red,
  ///             bounds: const Rect.fromLTWH(0, 0, 100, 100)))))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTemplate? get template => _template;
  set template(PdfTemplate? value) {
    if (value != null) {
      _template = value;
      style = PdfUnorderedMarkerStyle.customTemplate;
    }
  }

  /// Gets marker text.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(text: 'Text'))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String? get text => _text;
  set text(String? value) {
    if (value != null) {
      _text = value;
      style = PdfUnorderedMarkerStyle.customString;
    }
  }
}

/// [PdfUnorderedMarker] helper
class PdfUnorderedMarkerHelper extends PdfMarkerHelper {
  /// internal constructor
  PdfUnorderedMarkerHelper(this.base) : super(base);

  /// internal field
  PdfUnorderedMarker base;

  /// internal method
  static PdfUnorderedMarkerHelper getHelper(PdfUnorderedMarker base) {
    return base._helper;
  }

  /// Marker size.
  PdfSize? size;

  /// Font used when draws styled marker
  late PdfFont unicodeFont;

  /// Draws the specified graphics.
  void draw(PdfGraphics? graphics, Offset point, PdfBrush? brush, PdfPen? pen,
      [PdfList? curList]) {
    final PdfTemplate templete = PdfTemplate(size!.width, size!.height);
    Offset offset = Offset(point.dx, point.dy);
    switch (base.style) {
      case PdfUnorderedMarkerStyle.customTemplate:
        templete.graphics!
            .drawPdfTemplate(base._template!, Offset.zero, size!.size);
        offset = Offset(
            point.dx,
            point.dy +
                ((curList!.font!.height > base.font!.height
                        ? curList.font!.height
                        : base.font!.height) /
                    2) -
                (size!.height / 2));
        break;
      case PdfUnorderedMarkerStyle.customImage:
        //  templete.graphics.drawImage(
        //      _image, 1, 1, _size.width - 2, _size.height - 2);
        break;
      // ignore: no_default_cases
      default:
        final PdfPoint location = PdfPoint.empty;
        if (pen != null) {
          location.x = location.x + pen.width;
          location.y = location.y + pen.width;
        }
        templete.graphics!.drawString(getStyledText(), unicodeFont,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(location.x, location.y, 0, 0));
        break;
    }
    graphics!.drawPdfTemplate(templete, offset);
  }

  /// Gets the styled text.
  String getStyledText() {
    String text = '';
    switch (base.style) {
      case PdfUnorderedMarkerStyle.disk:
        text = '\x6C';
        break;
      case PdfUnorderedMarkerStyle.square:
        text = '\x6E';
        break;
      case PdfUnorderedMarkerStyle.asterisk:
        text = '\x5D';
        break;
      case PdfUnorderedMarkerStyle.circle:
        text = '\x6D';
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return text;
  }
}
