import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_string.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_border.dart';
import 'pdf_uri_annotation.dart';

/// Represents the class for text web link annotation.
/// ``` dart
/// //Create a new Pdf document
/// PdfDocument document = PdfDocument();
/// //Create and draw the web link in the PDF page
/// PdfTextWebLink(
///         url: 'www.google.co.in',
///         text: 'google',
///         font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
///         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///         pen: PdfPens.brown,
///         format: PdfStringFormat(
///             alignment: PdfTextAlignment.center,
///             lineAlignment: PdfVerticalAlignment.middle))
///     .draw(document.pages.add(), Offset(50, 40));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfTextWebLink extends PdfAnnotation {
  // Constructor
  /// Initializes a new instance of the [PdfTextWebLink] class.
  /// ``` dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create and draw the web link in the PDF page
  /// PdfTextWebLink(
  ///         url: 'www.google.co.in',
  ///         text: 'google',
  ///         font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///         pen: PdfPens.brown,
  ///         format: PdfStringFormat(
  ///             alignment: PdfTextAlignment.center,
  ///             lineAlignment: PdfVerticalAlignment.middle))
  ///     .draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTextWebLink(
      {required String url,
      String? text,
      PdfBrush? brush,
      PdfFont? font,
      PdfPen? pen,
      PdfStringFormat? format}) {
    _helper = PdfTextWebLinkHelper(this);
    _initializeWebLink(text, font, pen, brush, format);
    this.url = url;
  }

  PdfTextWebLink._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String? annotText) {
    _helper = PdfTextWebLinkHelper._(this, dictionary, crossTable);
    text = annotText != null && annotText.isNotEmpty ? annotText : '';
  }

  // fields
  String? _url;
  late PdfUriAnnotation _uriAnnotation;
  late PdfTextWebLinkHelper _helper;

  /// Get or sets the font.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the font
  /// textWebLink.font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfFont? font;

  /// Get or sets the pen.
  ///```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the pen
  /// textWebLink.pen = PdfPens.brown;
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPen? pen;

  /// Get or sets the brush.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Gets or sets the brush
  /// textWebLink.brush = PdfSolidBrush(PdfColor(0, 0, 0));
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBrush? brush;

  /// Get or sets the stringFormat.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown);
  /// //Gets or sets the stringFormat
  /// textWebLink.stringFormat  = PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle);
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat? stringFormat;

  // properties
  /// Gets or sets the Uri address.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Sets the url
  /// textWebLink.url = 'www.google.co.in';
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get url {
    if (PdfAnnotationHelper.getHelper(this).isLoadedAnnotation) {
      return _obtainUrl()!;
    } else {
      return _url!;
    }
  }

  set url(String value) {
    if (value == '') {
      throw ArgumentError.value('Url - string can not be empty');
    }
    _url = value;
    if (PdfAnnotationHelper.getHelper(this).isLoadedAnnotation) {
      final PdfDictionary tempDictionary =
          PdfAnnotationHelper.getHelper(this).dictionary!;
      if (tempDictionary.containsKey(PdfDictionaryProperties.a)) {
        final PdfDictionary? dictionary =
            PdfCrossTable.dereference(tempDictionary[PdfDictionaryProperties.a])
                as PdfDictionary?;
        if (dictionary != null) {
          dictionary.setString(PdfDictionaryProperties.uri, _url);
        }
        tempDictionary.modify();
      }
    }
  }

  // implementation
  void _initializeWebLink(String? annotText, PdfFont? font, PdfPen? pen,
      PdfBrush? brush, PdfStringFormat? format) {
    text = annotText != null && annotText.isNotEmpty ? annotText : '';
    if (font != null) {
      this.font = font;
    }
    if (brush != null) {
      this.brush = brush;
    }
    if (pen != null) {
      this.pen = pen;
    }
    if (format != null) {
      stringFormat = format;
    }
  }

  /// Draws a text web link on the PDF page.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create the web link in the PDF page
  /// PdfTextWebLink textWebLink = PdfTextWebLink(
  ///     url: 'www.google.co.in',
  ///     text: 'google',
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     pen: PdfPens.brown,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.middle));
  /// //Draw the web link in the PDF page
  /// textWebLink.draw(document.pages.add(), Offset(50, 40));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void draw(PdfPage page, Offset location) {
    if (!PdfAnnotationHelper.getHelper(this).isLoadedAnnotation) {
      final PdfFont pdfFont =
          font != null ? font! : PdfStandardFont(PdfFontFamily.helvetica, 8);
      final Size textSize = pdfFont.measureString(text);
      final Rect rect = Rect.fromLTWH(
          location.dx, location.dy, textSize.width, textSize.height);
      _uriAnnotation = PdfUriAnnotation(bounds: rect, uri: url);
      _uriAnnotation.border = PdfAnnotationBorder(0, 0, 0);
      page.annotations.add(_uriAnnotation);
      _drawInternal(page.graphics, rect, pdfFont);
    }
  }

  void _drawInternal(PdfGraphics graphics, Rect bounds, PdfFont pdfFont) {
    graphics.drawString(text, pdfFont,
        pen: pen, brush: brush, bounds: bounds, format: stringFormat);
  }

  String? _obtainUrl() {
    String? url = '';
    final PdfDictionary tempDictionary =
        PdfAnnotationHelper.getHelper(this).dictionary!;
    if (tempDictionary.containsKey(PdfDictionaryProperties.a)) {
      final PdfDictionary? dictionary =
          PdfCrossTable.dereference(tempDictionary[PdfDictionaryProperties.a])
              as PdfDictionary?;
      if (dictionary != null &&
          dictionary.containsKey(PdfDictionaryProperties.uri)) {
        final PdfString? uriText =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.uri])
                as PdfString?;
        if (uriText != null) {
          url = uriText.value;
        }
      }
    }
    return url;
  }
}

/// [PdfTextWebLink] helper
class PdfTextWebLinkHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfTextWebLinkHelper(this.webLinkHelper) : super(webLinkHelper) {
    initializeAnnotation();
  }

  /// internal constructor
  PdfTextWebLinkHelper._(
      this.webLinkHelper, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(webLinkHelper) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  late PdfTextWebLink webLinkHelper;

  /// internal field
  @override
  IPdfPrimitive? element;

  /// internal method
  static PdfTextWebLink load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfTextWebLink._(dictionary, crossTable, text);
  }

  /// internal method
  static PdfTextWebLinkHelper getHelper(PdfTextWebLink annotation) {
    return annotation._helper;
  }
}
