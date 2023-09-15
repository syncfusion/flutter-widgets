import 'dart:ui';

import '../../../interfaces/pdf_interface.dart';
import 'enums.dart';
import 'pdf_cjk_standard_font.dart';
import 'pdf_font_metrics.dart';
import 'pdf_standard_font.dart';
import 'pdf_string_format.dart';
import 'pdf_string_layout_result.dart';
import 'pdf_string_layouter.dart';
import 'pdf_true_type_font.dart';
import 'string_tokenizer.dart';

/// Defines a particular format for text, including font face, size,
/// and style attributes.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString('Hello World!',
///       PdfStandardFont(PdfFontFamily.helvetica, 12),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
abstract class PdfFont implements IPdfWrapper {
  final PdfFontHelper _helper = PdfFontHelper();

  //Properties
  /// Gets style of the font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfFontStyle get style => _helper.style;

  /// Gets the font name.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  String get name => _helper.metrics!.name;

  /// Gets the font size.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get size => _helper.size;

  /// Gets the height of the font in points.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// //Draw string to PDF page.
  /// document.pages.add().graphics.drawString(
  ///     'Font Name: ${font.name}\nFont Size: ${font.size}\nFont Height: ${font.height}\nFont Style: ${font.style}',
  ///     font);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get height => _helper.metrics!.getHeight(null);

  //Public methods
  /// Measures a string by using this font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Add a page to the document.
  /// PdfPage page = document.pages.add();
  /// //Create PDF graphics for the page.
  /// PdfGraphics graphics = page.graphics;
  /// //Create a new PDF font instance.
  /// PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  /// String text = "Hello World!";
  /// //Measure the text.
  /// Size size = font.measureString(text);
  /// //Draw string to PDF page.
  /// graphics.drawString(text, font,
  ///     brush: PdfBrushes.black,
  ///     bounds: Rect.fromLTWH(0, 0, size.width, size.height));
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size measureString(String text, {Size? layoutArea, PdfStringFormat? format}) {
    layoutArea ??= Size.zero;
    final PdfStringLayouter layouter = PdfStringLayouter();
    final PdfStringLayoutResult result = layouter.layout(text, this, format,
        width: layoutArea.width, height: layoutArea.height);
    return result.size.size;
  }

  //Implementation

  /// Returns width of the line.
  double _getLineWidth(String line, PdfStringFormat? format);

  /// Applies settings to the default line width.
  double _applyFormatSettings(
      String line, PdfStringFormat? format, double width) {
    double realWidth = width;
    if (format != null && width > 0) {
      if (format.characterSpacing != 0) {
        realWidth += (line.length - 1) * format.characterSpacing;
      }
      if (format.wordSpacing != 0) {
        final int whitespacesCount =
            StringTokenizer.getCharacterCount(line, StringTokenizer.spaces);
        realWidth += whitespacesCount * format.wordSpacing;
      }
    }
    return realWidth;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfFont] helper
class PdfFontHelper {
  /// internal method
  static PdfFontHelper getHelper(PdfFont font) {
    return font._helper;
  }

  /// internal field
  static const double characterSizeMultiplier = 0.001;

  /// internal field
  static const List<String> standardFontNames = <String>[
    'Helvetica',
    'courier',
    'TimesRoman',
    'Symbol',
    'ZapfDingbats'
  ];

  /// internal field
  static const List<String> standardCjkFontNames = <String>[
    'HanyangSystemsGothicMedium',
    'HanyangSystemsShinMyeongJoMedium',
    'HeiseiKakuGothicW5',
    'HeiseiMinchoW3',
    'MonotypeHeiMedium',
    'MonotypeSungLight',
    'SinoTypeSongLight'
  ];

  /// internal field
  late double size;

  /// internal field
  PdfFontMetrics? metrics;

  /// internal field
  IPdfPrimitive? fontInternals;

  /// internal field
  int fontStyle = 0;

  /// internal field
  PdfFontStyle style = PdfFontStyle.regular;

  /// internal field
  bool isBold = false;

  /// internal field
  bool isItalic = false;

  /// internal field
  //ignore:unused_element
  bool get isUnderline =>
      fontStyle & getPdfFontStyle(PdfFontStyle.underline) > 0;

  /// internal field
  //ignore:unused_element
  bool get isStrikeout =>
      fontStyle & getPdfFontStyle(PdfFontStyle.strikethrough) > 0;

  /// Initializes a new instance of the [PdfFont] class
  /// with font size and style.
  void initialize(double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    setSize(size);
    setStyle(style, multiStyle);
  }

  ///Sets the font size.
  void setSize(double value) {
    if (metrics != null) {
      metrics!.size = value;
    }
    size = value;
  }

  ///Sets the style.
  void setStyle(PdfFontStyle? style, List<PdfFontStyle>? multiStyle) {
    if (style != null) {
      this.style = style;
      fontStyle = getPdfFontStyle(style);
      if (style == PdfFontStyle.bold) {
        isBold = true;
      } else if (style == PdfFontStyle.italic) {
        isItalic = true;
      }
    }
    if (multiStyle != null && multiStyle.isNotEmpty) {
      for (int i = 0; i < multiStyle.length; i++) {
        fontStyle = fontStyle | getPdfFontStyle(multiStyle[i]);
        if (multiStyle[i] == PdfFontStyle.bold) {
          isBold = true;
        } else if (multiStyle[i] == PdfFontStyle.italic) {
          isItalic = true;
        }
      }
    } else if (style == null) {
      this.style = PdfFontStyle.regular;
    }
  }

  /// internal method
  /// Gets the value for PdfFontStyle.
  static int getPdfFontStyle(PdfFontStyle value) {
    switch (value) {
      case PdfFontStyle.bold:
        return 1;
      case PdfFontStyle.italic:
        return 2;
      case PdfFontStyle.underline:
        return 4;
      case PdfFontStyle.strikethrough:
        return 8;
      case PdfFontStyle.regular:
        return 0;
    }
  }

  /// internal method
  static double getLineWidth(
      PdfFont font, String line, PdfStringFormat? format) {
    if (font is PdfCjkStandardFont) {
      return PdfCjkStandardFontHelper.getHelper(font)
          .getLineWidth(line, format);
    } else if (font is PdfStandardFont) {
      return PdfStandardFontHelper.getHelper(font).getLineWidth(line, format);
    } else if (font is PdfTrueTypeFont) {
      return PdfTrueTypeFontHelper.getHelper(font).getLineWidth(line, format);
    }
    return font._getLineWidth(line, format);
  }

  /// internal method
  static double applyFormatSettings(
      PdfFont font, String line, PdfStringFormat? format, double width) {
    return font._applyFormatSettings(line, format, width);
  }
}
