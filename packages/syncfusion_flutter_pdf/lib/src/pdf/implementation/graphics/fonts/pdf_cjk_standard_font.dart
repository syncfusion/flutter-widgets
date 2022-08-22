import '../../../interfaces/pdf_interface.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import 'enums.dart';
import 'pdf_cid_font.dart';
import 'pdf_cjk_standard_font_metrics_factory.dart';
import 'pdf_font.dart';
import 'pdf_string_format.dart';

/// Represents the standard CJK fonts.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'こんにちは世界',
///       PdfCjkStandardFont(
///           PdfCjkFontFamily.heiseiMinchoW3, 20),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
class PdfCjkStandardFont extends PdfFont {
  //Constructors
  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with font family, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'こんにちは世界',
  ///       PdfCjkStandardFont(
  ///           PdfCjkFontFamily.heiseiMinchoW3, 20),
  ///       brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkStandardFont(PdfCjkFontFamily fontFamily, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _helper = PdfCjkStandardFontHelper(this);
    PdfFontHelper.getHelper(this)
        .initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = fontFamily;
    _initializeInternals();
  }

  /// Initializes a new instance of the [PdfCjkStandardFont] class
  /// with [PdfCjkStandardFont] as prototype, size and font style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     PdfCjkStandardFont.prototype(
  ///         PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12), 12),
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkStandardFont.protoType(PdfCjkStandardFont prototype, double size,
      {PdfFontStyle? style, List<PdfFontStyle>? multiStyle}) {
    _helper = PdfCjkStandardFontHelper(this);
    PdfFontHelper.getHelper(this)
        .initialize(size, style: style, multiStyle: multiStyle);
    _fontFamily = prototype.fontFamily;
    if (style == null && (multiStyle == null || multiStyle.isEmpty)) {
      PdfFontHelper.getHelper(this).setStyle(prototype.style, null);
    }
    _initializeInternals();
  }

  //Fields
  late PdfCjkStandardFontHelper _helper;

  /// FontFamily of the font.
  PdfCjkFontFamily _fontFamily = PdfCjkFontFamily.heiseiKakuGothicW5;

  //Properties
  /// Gets the font family
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create PDF cjk font.
  /// PdfCjkStandardFont font =
  ///     PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 12);
  /// //Draw the text.
  /// document.pages.add().graphics.drawString(
  ///     '"The CJK font family name is ${font.fontFamily}', font,
  ///     brush: PdfBrushes.black);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfCjkFontFamily get fontFamily => _fontFamily;

  void _initializeInternals() {
    PdfFontHelper.getHelper(this).metrics =
        PdfCjkStandardFontMetricsFactory.getMetrics(
            _fontFamily, PdfFontHelper.getHelper(this).fontStyle, size);
    PdfFontHelper.getHelper(this).fontInternals = _createInternals();
  }

  /// Creates font's dictionary.
  PdfDictionary _createInternals() {
    final PdfDictionary dictionary = PdfDictionary();

    dictionary[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.font);
    dictionary[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.type0);
    dictionary[PdfDictionaryProperties.baseFont] =
        PdfName(PdfFontHelper.getHelper(this).metrics!.postScriptName);

    dictionary[PdfDictionaryProperties.encoding] = _getEncoding(_fontFamily);
    dictionary[PdfDictionaryProperties.descendantFonts] = _getDescendantFont();

    return dictionary;
  }

  /// Gets the prope CJK encoding.
  static PdfName _getEncoding(PdfCjkFontFamily? fontFamily) {
    String encoding = 'Unknown';

    switch (fontFamily) {
      case PdfCjkFontFamily.hanyangSystemsGothicMedium:
      case PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium:
        encoding = 'UniKS-UCS2-H';
        break;
      case PdfCjkFontFamily.heiseiKakuGothicW5:
      case PdfCjkFontFamily.heiseiMinchoW3:
        encoding = 'UniJIS-UCS2-H';
        break;
      case PdfCjkFontFamily.monotypeHeiMedium:
      case PdfCjkFontFamily.monotypeSungLight:
        encoding = 'UniCNS-UCS2-H';
        break;
      case PdfCjkFontFamily.sinoTypeSongLight:
        encoding = 'UniGB-UCS2-H';
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    final PdfName name = PdfName(encoding);
    return name;
  }

  /// Returns descendant font.
  PdfArray _getDescendantFont() {
    final PdfArray df = PdfArray();
    final PdfCidFont cidFont = PdfCidFont(
        _fontFamily,
        PdfFontHelper.getHelper(this).fontStyle,
        PdfFontHelper.getHelper(this).metrics!);
    df.add(cidFont);
    return df;
  }

  IPdfPrimitive? get _element => PdfFontHelper.getHelper(this).fontInternals;
  set _element(IPdfPrimitive? value) {
    PdfFontHelper.getHelper(this).fontInternals = value;
  }
}

/// [PdfCjkStandardFont] element
class PdfCjkStandardFontHelper {
  /// internal constructor
  PdfCjkStandardFontHelper(this.base);

  /// internal field
  PdfCjkStandardFont base;

  /// internal method
  static PdfCjkStandardFontHelper getHelper(PdfCjkStandardFont base) {
    return base._helper;
  }

  /// internal method
  IPdfPrimitive? get element => base._element;
  set element(IPdfPrimitive? value) {
    base._element = value;
  }

  /// internal method
  double getLineWidth(String line, PdfStringFormat? format) {
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      final String ch = line[i];
      final double charWidth = getCharWidthInternal(ch);
      width += charWidth;
    }
    final double size = PdfFontHelper.getHelper(base).metrics!.getSize(format)!;
    width *= PdfFontHelper.characterSizeMultiplier * size;
    width = PdfFontHelper.applyFormatSettings(base, line, format, width);
    return width;
  }

  /// Gets the char width internal.
  double getCharWidthInternal(String charCode) {
    int code = charCode.codeUnitAt(0);
    code = (code >= 0) ? code : 0;
    return PdfFontHelper.getHelper(base).metrics!.widthTable![code]!.toDouble();
  }
}
