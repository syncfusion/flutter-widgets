import 'dart:convert';

import '../../../interfaces/pdf_interface.dart';
import '../enums.dart';
import 'enums.dart';
import 'pdf_font.dart';
import 'pdf_string_format.dart';
import 'rtl/arabic_shape_renderer.dart';
import 'unicode_true_type_font.dart';

/// Represents TrueType font.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new PDF true type font instance and draw string to PDF page.
/// document.pages.add().graphics.drawString(
///     'Hello World!',
///     PdfTrueTypeFont(fontStream, 12),
///     brush: PdfBrushes.black,
///     bounds: Rect.fromLTWH(0, 0, 100, 50));
/// //Saves the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfTrueTypeFont extends PdfFont {
  /// Initializes a new instance of the [PdfTrueTypeFont] class.
  ///
  /// fontData represents the font sream formated as list of bytes.
  /// size represents the font size to draw the text.
  /// style and multistyle are used to set font styles.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF true type font instance and draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     PdfTrueTypeFont(fontStream, 12),
  ///     brush: PdfBrushes.black,
  ///     bounds: Rect.fromLTWH(0, 0, 100, 50));
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTrueTypeFont(List<int> fontData, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _helper = PdfTrueTypeFontHelper(this);
    _initializeFont(fontData, size, style, multiStyle);
  }

  /// Initializes a new instance of the [PdfTrueTypeFont] class.
  ///
  /// fontdata represents the font stream as base64 string format.
  /// size represents the font size to draw the text.
  /// style and multistyle are used to set font styles.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Font stream in base64 string format
  /// String base64 = 'AAEAAAATAQAABAAwRFNJRzlPG+EAASMQAAAdgKMbEAAAAAy/k2Tw==';
  /// //Create a new PDF true type font instance with font data as base64 string.
  /// PdfFont font = PdfTrueTypeFont(base64, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     font,
  ///     brush: PdfBrushes.black,
  ///     bounds: Rect.fromLTWH(0, 0, 100, 50));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  PdfTrueTypeFont.fromBase64String(String fontData, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _helper = PdfTrueTypeFontHelper(this);
    if (fontData.isEmpty) {
      throw ArgumentError.value(fontData, 'fontData', 'Invalid font data');
    }
    _initializeFont(base64.decode(fontData), size, style, multiStyle);
  }

  //Fields
  late PdfTrueTypeFontHelper _helper;

  //Implementation
  void _initializeFont(List<int> fontData, double size, PdfFontStyle? style,
      List<PdfFontStyle>? multiStyle) {
    PdfFontHelper.getHelper(this)
        .initialize(size, style: style, multiStyle: multiStyle);
    _helper.unicode = true;
    _createFontInternals(fontData);
  }

  void _createFontInternals(List<int> fontData) {
    _helper.fontInternal = UnicodeTrueTypeFont(fontData, size);
    _calculateStyle(style);
    _initializeInternals();
  }

  void _calculateStyle(PdfFontStyle style) {
    int? iStyle = _helper.fontInternal.ttfMetrics!.macStyle;
    if (PdfFontHelper.getHelper(this).isUnderline) {
      iStyle = iStyle! | PdfFontHelper.getPdfFontStyle(PdfFontStyle.underline);
    }
    if (PdfFontHelper.getHelper(this).isStrikeout) {
      iStyle =
          iStyle! | PdfFontHelper.getPdfFontStyle(PdfFontStyle.strikethrough);
    }
    PdfFontHelper.getHelper(this).fontStyle = iStyle!;
  }

  void _initializeInternals() {
    _helper.fontInternal.createInternals();
    final IPdfPrimitive? internals = _helper.fontInternal.fontDictionary;
    PdfFontHelper.getHelper(this).metrics = _helper.fontInternal.metrics;
    if (internals == null) {
      throw ArgumentError.value(internals, 'font internal cannot be null');
    }
    PdfFontHelper.getHelper(this).fontInternals = internals;
  }
}

/// [PdfTrueTypeFont] helper
class PdfTrueTypeFontHelper {
  /// internal constructor
  PdfTrueTypeFontHelper(this.base);

  /// internal field
  PdfTrueTypeFont base;

  /// internal field
  late UnicodeTrueTypeFont fontInternal;

  /// internal field
  bool? unicode;

  /// internal method
  static PdfTrueTypeFontHelper getHelper(PdfTrueTypeFont base) {
    return base._helper;
  }

  /// internal property
  IPdfPrimitive? get element => PdfFontHelper.getHelper(base).fontInternals;

  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    PdfFontHelper.getHelper(base).fontInternals = value;
  }

  /// internal method
  double getLineWidth(String line, PdfStringFormat? format) {
    double width = 0;
    String text = line;
    if (format != null && format.textDirection != PdfTextDirection.none) {
      final ArabicShapeRenderer renderer = ArabicShapeRenderer();
      text = renderer.shape(line.split(''), 0);
    }
    width = fontInternal.getLineWidth(text);
    final double size = PdfFontHelper.getHelper(base).metrics!.getSize(format)!;
    width *= 0.001 * size;
    width = PdfFontHelper.applyFormatSettings(base, text, format, width);
    return width;
  }

  /// internal method
  void setSymbols(String text, List<String>? internalUsedChars) {
    fontInternal.setSymbols(text, internalUsedChars);
  }

  /// internal method
  double getCharWidth(String charCode, PdfStringFormat? format) {
    double codeWidth = fontInternal.getCharWidth(charCode);
    codeWidth *=
        0.001 * PdfFontHelper.getHelper(base).metrics!.getSize(format)!;
    return codeWidth;
  }
}
