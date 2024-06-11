import 'dart:math';
import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation_border.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_margins.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_collection.dart';
import 'pdf_paintparams.dart';

/// Represents a line annotation.
class PdfLineAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of [PdfLineAnnotation] class.
  /// ``` dart
  /// PdfDocument document = PdfDocument();
  /// PdfPage page = document.pages.add();
  /// List<int> points = <int>[80, 420, 250, 420];
  /// PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
  ///     points, 'Line Annotation',
  ///     opacity: 0.95,
  ///     border: PdfAnnotationBorder(1),
  ///     lineIntent: PdfLineIntent.lineDimension,
  ///     beginLineStyle: PdfLineEndingStyle.butt,
  ///     endLineStyle: PdfLineEndingStyle.none,
  ///     innerColor: PdfColor(0, 255, 0),
  ///     color: PdfColor(0, 255, 255),
  ///     leaderLineExt: 10,
  ///     leaderLine: 2,
  ///     lineCaption: true,
  ///     captionType: PdfLineCaptionType.top);
  /// page.annotations.add(lineAnnotation);
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfLineAnnotation(List<int> linePoints, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      bool? setAppearance,
      PdfLineEndingStyle beginLineStyle = PdfLineEndingStyle.none,
      PdfLineEndingStyle endLineStyle = PdfLineEndingStyle.none,
      PdfLineCaptionType captionType = PdfLineCaptionType.inline,
      PdfLineIntent lineIntent = PdfLineIntent.lineArrow,
      int? leaderLine,
      int? leaderLineExt,
      bool lineCaption = false,
      List<PdfAnnotationFlags>? flags}) {
    _helper = PdfLineAnnotationHelper(this, linePoints, text,
        color: color,
        innerColor: innerColor,
        border: border,
        author: author,
        subject: subject,
        modifiedDate: modifiedDate,
        opacity: opacity,
        flags: flags,
        setAppearance: setAppearance);
    this.beginLineStyle = beginLineStyle;
    this.endLineStyle = endLineStyle;
    this.captionType = captionType;
    this.lineIntent = lineIntent;
    this.lineCaption = lineCaption;
    if (leaderLine != null) {
      this.leaderLine = leaderLine;
    }
    if (leaderLineExt != null) {
      this.leaderLineExt = leaderLineExt;
    }
  }

  PdfLineAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String annotText) {
    _helper = PdfLineAnnotationHelper._(this, dictionary, crossTable);
    text = annotText;
  }

  // Fields
  late PdfLineAnnotationHelper _helper;
  late PdfLineEndingStyle _beginLineStyle;
  late PdfLineEndingStyle _endLineStyle;
  int _leaderLineExt = 0;
  late bool _lineCaption;
  late PdfLineIntent _lineIntent;
  late PdfLineCaptionType _captionType;

  // Properties
  /// Gets the leader line.
  int get leaderLine => PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
      ? _helper._obtainLeaderLine()
      : _helper.leaderLine;

  /// Sets the leader line.
  set leaderLine(int value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    final bool isLoadedAnnotation = helper.isLoadedAnnotation;
    if (value != 0 && !isLoadedAnnotation) {
      _helper.leaderLine = value;
    } else if (isLoadedAnnotation) {
      helper.dictionary!.setNumber(PdfDictionaryProperties.ll, value);
    }
  }

  /// Gets the line points of the annotation.
  List<int> get linePoints =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._obtainLinePoints()
          : _helper.points;

  /// Sets the line points of the annotation.
  set linePoints(List<int> value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    _helper.points = value;
    _helper.linePoints = PdfArray(_helper.points);
    if (helper.isLoadedAnnotation) {
      helper.dictionary!
          .setProperty(PdfDictionaryProperties.l, _helper.linePoints);
    }
  }

  /// Gets the line intent of the annotation.
  PdfLineIntent get lineIntent =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._obtainLineIntent()
          : _lineIntent;

  /// Sets the line intent of the annotation.
  set lineIntent(PdfLineIntent value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _lineIntent = value;
    } else {
      helper.dictionary!.setName(
          PdfName(PdfDictionaryProperties.it), helper.getEnumName(value));
    }
  }

  /// Gets the line caption of the annotation.
  bool get lineCaption => PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
      ? _helper._obtainLineCaption()
      : _lineCaption;

  /// Sets the line caption of the annotation.
  set lineCaption(bool value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _lineCaption = value;
    } else {
      helper.dictionary!.setBoolean(PdfDictionaryProperties.cap, value);
    }
  }

  /// Gets the leader line extension.
  int get leaderLineExt =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._obtainLeaderExt()
          : _leaderLineExt;

  /// Sets the leader line extension.
  set leaderLineExt(int value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _leaderLineExt = value;
    } else {
      helper.dictionary!.setNumber(PdfDictionaryProperties.lle, value);
    }
  }

  /// Gets the begin line style of the annotation.
  PdfLineEndingStyle get beginLineStyle =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._getLineStyle(0)
          : _beginLineStyle;

  /// Sets the end line style of the annotation.
  set beginLineStyle(PdfLineEndingStyle value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _beginLineStyle = value;
    } else {
      PdfArray? lineStyle = _helper._obtainLineStyle();
      if (lineStyle == null) {
        lineStyle = PdfArray();
      } else {
        lineStyle.elements.removeAt(0);
      }
      lineStyle.insert(
          0,
          PdfName(helper.getEnumName(
              _helper._getLineStyle(helper.getEnumName(value.toString())))));
      helper.dictionary!.setProperty(PdfDictionaryProperties.le, lineStyle);
    }
  }

  /// Gets the end line style of the annotation.
  PdfLineEndingStyle get endLineStyle =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._getLineStyle(1)
          : _endLineStyle;

  /// Sets the end line style of the annotation.
  set endLineStyle(PdfLineEndingStyle value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _endLineStyle = value;
    } else {
      PdfArray? lineStyle = _helper._obtainLineStyle();
      if (lineStyle == null) {
        lineStyle = PdfArray();
      } else {
        lineStyle.elements.removeAt(1);
      }
      lineStyle.insert(
          1,
          PdfName(helper.getEnumName(
              _helper._getLineStyle(helper.getEnumName(value.toString())))));
      helper.dictionary!.setProperty(PdfDictionaryProperties.le, lineStyle);
    }
  }

  /// Gets the caption type of the annotation.
  PdfLineCaptionType get captionType =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._obtainCaptionType()
          : _captionType;

  /// Sets the caption type of the annotation.
  set captionType(PdfLineCaptionType value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (!helper.isLoadedAnnotation) {
      _captionType = value;
    } else {
      helper.dictionary!.setProperty(
          PdfDictionaryProperties.cp,
          PdfName(helper.getEnumName(
              _helper._getCaptionType(helper.getEnumName(value.toString())))));
    }
  }

  /// Gets or sets the content of the annotation.
  ///
  /// The string value specifies the text of the annotation.
  @override
  String get text => super.text;
  @override
  set text(String value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    if (helper.textValue != value) {
      helper.textValue = value;
      helper.dictionary!
          .setString(PdfDictionaryProperties.contents, helper.textValue);
    }
  }

  /// Gets annotation's border properties like width, horizontal radius etc.
  PdfAnnotationBorder get border {
    return _helper.border;
  }

  /// Sets annotation's border properties like width, horizontal radius etc.
  set border(PdfAnnotationBorder value) {
    _helper.border = value;
  }

  /// Gets the annotation color.
  PdfColor get color => _helper.color;

  /// Sets the annotation color.
  set color(PdfColor value) {
    _helper.color = value;
  }

  /// Gets the inner color of the annotation.
  PdfColor get innerColor => _helper.innerColor;

  /// Sets the inner color of the annotation.
  set innerColor(PdfColor value) {
    _helper.innerColor = value;
  }

  IPdfPrimitive? get _element => PdfAnnotationHelper.getHelper(this).dictionary;

  set _element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      PdfAnnotationHelper.getHelper(this).dictionary = value;
    }
  }
}

/// [PdfLineAnnotation] helper
class PdfLineAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfLineAnnotationHelper(
      this.lineAnnotation, List<int> linePoints, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance})
      : super(lineAnnotation) {
    initializeAnnotation(
        text: text,
        color: color,
        innerColor: innerColor,
        border: border,
        author: author,
        subject: subject,
        modifiedDate: modifiedDate,
        opacity: opacity,
        flags: flags,
        setAppearance: setAppearance);
    this.linePoints = PdfArray(linePoints);
    points = linePoints;
    dictionary!.setProperty(
        PdfDictionaryProperties.subtype, PdfName(PdfDictionaryProperties.line));
  }
  PdfLineAnnotationHelper._(
      this.lineAnnotation, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(lineAnnotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  late PdfLineAnnotation lineAnnotation;

  /// internal field
  PdfArray? lineStyle;

  /// internal field
  PdfArray? linePoints;

  /// internal field
  int leaderLine = 0;

  /// internal field
  List<int> points = <int>[];

  /// internal property
  @override
  IPdfPrimitive? get element => lineAnnotation._element;

  @override
  set element(IPdfPrimitive? value) {
    lineAnnotation._element = value;
  }

  /// internal method
  void save() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    if (PdfAnnotationCollectionHelper.getHelper(
            lineAnnotation.page!.annotations)
        .flatten) {
      helper.flatten = true;
    }
    if (helper.flatten || lineAnnotation.setAppearance) {
      final PdfTemplate? appearance = _createAppearance();
      if (helper.flatten) {
        if (appearance != null || helper.isLoadedAnnotation) {
          if (lineAnnotation.page != null) {
            _flattenAnnotation(lineAnnotation.page, appearance);
          }
        }
      } else {
        if (appearance != null) {
          lineAnnotation.appearance.normal = appearance;
          helper.dictionary!.setProperty(PdfDictionaryProperties.ap,
              PdfReferenceHolder(lineAnnotation.appearance));
        }
      }
    }
    if (!helper.flatten && !helper.isLoadedAnnotation) {
      helper.saveAnnotation();
      _savePdfLineDictionary();
    }
    if (helper.flattenPopups) {
      helper.flattenPopup();
    }
  }

  void _savePdfLineDictionary() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    helper.saveAnnotation();
    lineStyle = PdfArray();
    if (lineStyle!.elements.isNotEmpty) {
      lineStyle!.insert(
          0, PdfName(helper.getEnumName(lineAnnotation.beginLineStyle)));
      lineStyle!
          .insert(1, PdfName(helper.getEnumName(lineAnnotation.endLineStyle)));
    } else {
      lineStyle!
          .add(PdfName(helper.getEnumName(lineAnnotation.beginLineStyle)));
      lineStyle!.add(PdfName(helper.getEnumName(lineAnnotation.endLineStyle)));
    }
    final PdfDictionary dictionary = helper.dictionary!;
    dictionary.setProperty(PdfDictionaryProperties.le, lineStyle);
    if (linePoints != null) {
      dictionary.setProperty(PdfDictionaryProperties.l, linePoints);
    } else {
      throw ArgumentError.value('LinePoints cannot be null');
    }
    if (lineAnnotation.border.dashArray == 0) {
      if (lineAnnotation.border.borderStyle == PdfBorderStyle.dashed) {
        lineAnnotation.border.dashArray = 4;
      } else if (lineAnnotation.border.borderStyle == PdfBorderStyle.dot) {
        lineAnnotation.border.dashArray = 2;
      }
    }
    dictionary.setProperty(PdfDictionaryProperties.bs, lineAnnotation.border);
    if (!lineAnnotation.innerColor.isEmpty &&
        PdfColorHelper.getHelper(lineAnnotation.innerColor).alpha != 0) {
      dictionary.setProperty(PdfDictionaryProperties.ic,
          PdfColorHelper.toArray(lineAnnotation.innerColor));
    }
    dictionary[PdfDictionaryProperties.c] =
        PdfColorHelper.toArray(lineAnnotation.color);

    dictionary.setProperty(PdfDictionaryProperties.it,
        PdfName(helper.getEnumName(lineAnnotation.lineIntent)));

    dictionary.setProperty(
        PdfDictionaryProperties.lle, PdfNumber(lineAnnotation.leaderLineExt));

    dictionary.setProperty(PdfDictionaryProperties.ll, PdfNumber(leaderLine));

    dictionary.setProperty(PdfDictionaryProperties.cp,
        PdfName(helper.getEnumName(lineAnnotation.captionType)));

    dictionary.setProperty(
        PdfDictionaryProperties.cap, PdfBoolean(lineAnnotation.lineCaption));

    dictionary.setProperty(PdfDictionaryProperties.rect,
        PdfArray.fromRectangle(_obtainLineBounds()));
  }

  void _flattenAnnotation(PdfPage? page, PdfTemplate? appearance) {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    final PdfDictionary dictionary = helper.dictionary!;
    if (helper.isLoadedAnnotation) {
      final bool isContainsAP =
          dictionary.containsKey(PdfDictionaryProperties.ap);
      if (isContainsAP && appearance == null) {
        PdfDictionary? appearanceDictionary =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.ap])
                as PdfDictionary?;
        if (appearanceDictionary != null) {
          appearanceDictionary = PdfCrossTable.dereference(
                  appearanceDictionary[PdfDictionaryProperties.n])
              as PdfDictionary?;
          if (appearanceDictionary != null) {
            final PdfStream appearanceStream =
                appearanceDictionary as PdfStream;
            appearance = PdfTemplateHelper.fromPdfStream(appearanceStream);
            final bool isNormalMatrix =
                helper.validateTemplateMatrix(appearanceDictionary);
            helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
          } else {
            lineAnnotation.setAppearance = true;
            appearance = _createAppearance();
            if (appearance != null) {
              final bool isNormalMatrix = helper.validateTemplateMatrix(
                  PdfTemplateHelper.getHelper(appearance).content);
              helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
            }
          }
        }
      } else if (!isContainsAP && appearance == null) {
        lineAnnotation.setAppearance = true;
        appearance = _createAppearance();
        if (appearance != null) {
          final bool isNormalMatrix = helper.validateTemplateMatrix(
              PdfTemplateHelper.getHelper(appearance).content);
          helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
        }
      } else {
        final bool isNormalMatrix = helper.validateTemplateMatrix(
            PdfTemplateHelper.getHelper(appearance!).content);
        helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
      }
    } else {
      page!.graphics.save();
      final Rect rectangle = helper.calculateTemplateBounds(
          lineAnnotation.bounds, page, appearance, true);
      if (lineAnnotation.opacity < 1) {
        page.graphics.setTransparency(lineAnnotation.opacity);
      }
      page.graphics.drawPdfTemplate(
          appearance!, Offset(rectangle.left, rectangle.top), rectangle.size);
      page.annotations.remove(lineAnnotation);
      page.graphics.restore();
    }
  }

  PdfTemplate? _createAppearance() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    final bool isLoadedAnnotation = helper.isLoadedAnnotation;
    if (isLoadedAnnotation && !lineAnnotation.setAppearance) {
      return null;
    }
    final Rect nativeRectangle = _obtainLineBounds().rect;
    final PdfTemplate template = PdfTemplateHelper.fromRect(nativeRectangle);
    PdfAnnotationHelper.setMatrixToZeroRotation(
        PdfTemplateHelper.getHelper(template).content);
    PdfTemplateHelper.getHelper(template).writeTransformation = false;
    final PaintParams paintParams = PaintParams();
    final PdfGraphics? graphics = template.graphics;
    final PdfPen mBorderPen =
        PdfPen(lineAnnotation.color, width: lineAnnotation.border.width);
    if (lineAnnotation.border.borderStyle == PdfBorderStyle.dashed) {
      mBorderPen.dashStyle = PdfDashStyle.dash;
    } else if (lineAnnotation.border.borderStyle == PdfBorderStyle.dot) {
      mBorderPen.dashStyle = PdfDashStyle.dot;
    }
    paintParams.borderPen = mBorderPen;
    paintParams.foreBrush = PdfSolidBrush(lineAnnotation.color);
    final PdfFont mFont = PdfStandardFont(
        PdfFontFamily.helvetica, isLoadedAnnotation ? 10 : 9,
        style: PdfFontStyle.regular);
    final PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;
    final double lineWidth =
        mFont.measureString(lineAnnotation.text, format: format).width;
    final List<int> linePoints = _obtainLinePoints();
    if (linePoints.length == 4) {
      final double x1 = linePoints[0].toDouble();
      final double y1 = linePoints[1].toDouble();
      final double x2 = linePoints[2].toDouble();
      final double y2 = linePoints[3].toDouble();
      double angle = 0;
      if (x2 - x1 == 0) {
        if (y2 > y1) {
          angle = 90;
        } else {
          angle = 270;
        }
      } else {
        angle = helper.getAngle(x1, y1, x2, y2);
      }
      double leadLine = 0;
      double lineAngle = 0;
      if (lineAnnotation.leaderLine < 0) {
        leadLine = -lineAnnotation.leaderLine.toDouble();
        lineAngle = angle + 180;
      } else {
        leadLine = lineAnnotation.leaderLine.toDouble();
        lineAngle = angle;
      }
      final List<double> x1y1 = <double>[x1, y1];
      final List<double> x2y2 = <double>[x2, y2];
      final double line = leadLine +
          (isLoadedAnnotation ? _obtainLeaderOffset().toDouble() : 0);
      final List<double> startingPoint =
          helper.getAxisValue(x1y1, lineAngle + 90, line);
      final List<double> endingPoint =
          helper.getAxisValue(x2y2, lineAngle + 90, line);
      final double lineDistance = sqrt(
          pow(endingPoint[0] - startingPoint[0], 2) +
              pow(endingPoint[1] - startingPoint[1], 2));
      final double centerWidth =
          lineDistance / 2 - ((lineWidth / 2) + lineAnnotation.border.width);
      final List<double> middlePoint1 =
          helper.getAxisValue(startingPoint, angle, centerWidth);
      final List<double> middlePoint2 =
          helper.getAxisValue(endingPoint, angle + 180, centerWidth);
      List<double> lineStartingPoint;
      List<double> lineEndingPoint;
      if (lineAnnotation.beginLineStyle == PdfLineEndingStyle.openArrow ||
          lineAnnotation.beginLineStyle == PdfLineEndingStyle.closedArrow) {
        lineStartingPoint = helper.getAxisValue(
            startingPoint, angle, lineAnnotation.border.width);
      } else {
        lineStartingPoint = startingPoint;
      }
      if (lineAnnotation.endLineStyle == PdfLineEndingStyle.openArrow ||
          lineAnnotation.endLineStyle == PdfLineEndingStyle.closedArrow) {
        lineEndingPoint = helper.getAxisValue(
            endingPoint, angle, -lineAnnotation.border.width);
      } else {
        lineEndingPoint = endingPoint;
      }
      final String caption = helper.getEnumName(lineAnnotation.captionType);
      if (lineAnnotation.opacity < 1) {
        graphics!.save();
        graphics.setTransparency(lineAnnotation.opacity);
      }
      if (lineAnnotation.text.isEmpty ||
          caption == 'Top' ||
          !lineAnnotation.lineCaption) {
        graphics!.drawLine(
            mBorderPen,
            Offset(lineStartingPoint[0], -lineStartingPoint[1]),
            Offset(lineEndingPoint[0], -lineEndingPoint[1]));
      } else {
        graphics!.drawLine(
            mBorderPen,
            Offset(lineStartingPoint[0], -lineStartingPoint[1]),
            Offset(middlePoint1[0], -middlePoint1[1]));
        graphics.drawLine(
            mBorderPen,
            Offset(lineEndingPoint[0], -lineEndingPoint[1]),
            Offset(middlePoint2[0], -middlePoint2[1]));
      }
      if (lineAnnotation.opacity < 1) {
        graphics.restore();
      }
      //Set begin and end line style.
      final PdfBrush backBrush = PdfSolidBrush(lineAnnotation.innerColor);
      final PdfArray lineStyle = PdfArray();
      lineStyle.insert(
          0, PdfName(helper.getEnumName(lineAnnotation.beginLineStyle)));
      lineStyle.insert(
          1, PdfName(helper.getEnumName(lineAnnotation.endLineStyle)));
      final double borderLength = lineAnnotation.border.width;
      helper.setLineEndingStyles(startingPoint, endingPoint, graphics, angle,
          mBorderPen, backBrush, lineStyle, borderLength);
      //Set leader extension.
      final List<double> beginLineExt = helper.getAxisValue(startingPoint,
          lineAngle + 90, lineAnnotation.leaderLineExt.toDouble());
      graphics.drawLine(mBorderPen, Offset(startingPoint[0], -startingPoint[1]),
          Offset(beginLineExt[0], -beginLineExt[1]));
      final List<double> endLineExt = helper.getAxisValue(
          endingPoint, lineAngle + 90, lineAnnotation.leaderLineExt.toDouble());
      graphics.drawLine(mBorderPen, Offset(endingPoint[0], -endingPoint[1]),
          Offset(endLineExt[0], -endLineExt[1]));
      //Set leader line
      final List<double> beginLeaderLine =
          helper.getAxisValue(startingPoint, lineAngle - 90, leadLine);
      graphics.drawLine(mBorderPen, Offset(startingPoint[0], -startingPoint[1]),
          Offset(beginLeaderLine[0], -beginLeaderLine[1]));
      final List<double> endLeaderLine =
          helper.getAxisValue(endingPoint, lineAngle - 90, leadLine);
      graphics.drawLine(mBorderPen, Offset(endingPoint[0], -endingPoint[1]),
          Offset(endLeaderLine[0], -endLeaderLine[1]));
      //Set caption Type.
      if (lineAnnotation.lineCaption) {
        final double midpoint = lineDistance / 2;
        final List<double> centerPoint =
            helper.getAxisValue(startingPoint, angle, midpoint);
        final List<double> captionPosition =
            _getCaptionPosition(caption, centerPoint, angle, mFont);
        graphics.translateTransform(captionPosition[0], -captionPosition[1]);
        graphics.rotateTransform(-angle);
        graphics.drawString(lineAnnotation.text, mFont,
            brush: backBrush, bounds: Rect.fromLTWH(-lineWidth / 2, 0, 0, 0));
      }
    }
    if (isLoadedAnnotation) {
      helper.dictionary!.setProperty(PdfDictionaryProperties.rect,
          PdfArray.fromRectangle(_obtainLineBounds()));
    }
    if (!isLoadedAnnotation && helper.flatten) {
      final double pageHeight = lineAnnotation.page!.size.height;
      final PdfMargins? margins = helper.obtainMargin();
      if (lineAnnotation.page != null) {
        lineAnnotation.bounds = Rect.fromLTWH(
            nativeRectangle.left - margins!.left,
            pageHeight -
                (nativeRectangle.top + nativeRectangle.height) -
                margins.top,
            nativeRectangle.width,
            nativeRectangle.height);
      } else {
        lineAnnotation.bounds = Rect.fromLTWH(
            nativeRectangle.left,
            pageHeight - (nativeRectangle.top + nativeRectangle.height),
            nativeRectangle.width,
            nativeRectangle.height);
      }
    }
    return template;
  }

  List<double> _getCaptionPosition(
      String caption, List<double> centerPoint, double angle, PdfFont font) {
    List<double> captionPosition = List<double>.filled(2, 0);
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    if (helper.isLoadedAnnotation) {
      final bool isContainsMeasure = helper.dictionary!.items!
          .containsKey(PdfName(PdfDictionaryProperties.measure));
      final double length = caption == 'Top'
          ? isContainsMeasure
              ? 2 * font.height
              : font.height
          : isContainsMeasure
              ? 3 * (font.height / 2)
              : font.height / 2;
      captionPosition = helper.getAxisValue(centerPoint, angle + 90, length);
    } else {
      captionPosition = helper.getAxisValue(centerPoint, angle + 90,
          caption == 'Top' ? font.height : font.height / 2);
    }
    return captionPosition;
  }

  // Gets leader line of the lineAnnotation.
  int _obtainLeaderLine() {
    int lLine = 0;
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    if (helper.dictionary!.containsKey(PdfDictionaryProperties.ll)) {
      final PdfNumber ll =
          helper.dictionary![PdfDictionaryProperties.ll]! as PdfNumber;
      lLine = ll.value!.toInt();
    }
    return lLine;
  }

  // Gets the line intent of the annotation.
  PdfLineIntent _obtainLineIntent() {
    PdfLineIntent lineintentValue = PdfLineIntent.lineArrow;
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    if (helper.dictionary!.containsKey(PdfDictionaryProperties.it)) {
      final PdfName lineintent = helper.crossTable
              .getObject(helper.dictionary![PdfDictionaryProperties.it])!
          as PdfName;
      lineintentValue = _getLineIntentText(lineintent.name.toString());
    }
    return lineintentValue;
  }

  // Get the Line Intent Text.
  PdfLineIntent _getLineIntentText(String lintent) {
    PdfLineIntent lineintent = PdfLineIntent.lineArrow;
    switch (lintent) {
      case 'LineArrow':
        lineintent = PdfLineIntent.lineArrow;
        break;
      case 'LineDimension':
        lineintent = PdfLineIntent.lineDimension;
        break;
    }
    return lineintent;
  }

  List<int> _obtainLinePoints() {
    List<int> points = <int>[];
    if (!PdfAnnotationHelper.getHelper(lineAnnotation).isLoadedAnnotation) {
      if (linePoints != null) {
        // ignore: prefer_final_in_for_each
        for (IPdfPrimitive? linePoint in linePoints!.elements) {
          if (linePoint is PdfNumber) {
            points.add(linePoint.value!.toInt());
          }
        }
      }
    } else {
      if (PdfAnnotationHelper.getHelper(lineAnnotation)
          .dictionary!
          .containsKey(PdfDictionaryProperties.l)) {
        linePoints = PdfCrossTable.dereference(
            PdfAnnotationHelper.getHelper(lineAnnotation)
                .dictionary![PdfDictionaryProperties.l]) as PdfArray?;
        if (linePoints != null) {
          points = <int>[];
          // ignore: prefer_final_in_for_each
          for (IPdfPrimitive? value in linePoints!.elements) {
            if (value is PdfNumber) {
              points.add(value.value!.toInt());
            }
          }
        }
      }
    }
    return points;
  }

  // Gets line caption of the annotation.
  bool _obtainLineCaption() {
    bool lCaption = false;
    if (PdfAnnotationHelper.getHelper(lineAnnotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.cap)) {
      final PdfBoolean lCap = PdfAnnotationHelper.getHelper(lineAnnotation)
          .dictionary![PdfDictionaryProperties.cap]! as PdfBoolean;
      lCaption = lCap.value!;
    }
    return lCaption;
  }

  // Gets leader ext of the annotation.
  int _obtainLeaderExt() {
    int lLineExt = 0;
    if (PdfAnnotationHelper.getHelper(lineAnnotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.lle)) {
      final PdfNumber lExt = PdfAnnotationHelper.getHelper(lineAnnotation)
          .dictionary![PdfDictionaryProperties.lle]! as PdfNumber;
      lLineExt = lExt.value!.toInt();
    }
    return lLineExt;
  }

  // Gets line style of the annotation.
  PdfLineEndingStyle _getLineStyle(dynamic value) {
    PdfLineEndingStyle linestyle = PdfLineEndingStyle.none;
    if (value is int) {
      final PdfArray? array = _obtainLineStyle();
      if (array != null) {
        final PdfName style = array[value]! as PdfName;
        linestyle = _getLineStyle(style.name);
      }
    } else if (value is String) {
      switch (value) {
        case 'Square':
          linestyle = PdfLineEndingStyle.square;
          break;
        case 'Circle':
          linestyle = PdfLineEndingStyle.circle;
          break;
        case 'Diamond':
          linestyle = PdfLineEndingStyle.diamond;
          break;
        case 'OpenArrow':
          linestyle = PdfLineEndingStyle.openArrow;
          break;
        case 'ClosedArrow':
          linestyle = PdfLineEndingStyle.closedArrow;
          break;
        case 'None':
          linestyle = PdfLineEndingStyle.none;
          break;
        case 'ROpenArrow':
          linestyle = PdfLineEndingStyle.rOpenArrow;
          break;
        case 'Butt':
          linestyle = PdfLineEndingStyle.butt;
          break;
        case 'RClosedArrow':
          linestyle = PdfLineEndingStyle.rClosedArrow;
          break;
        case 'Slash':
          linestyle = PdfLineEndingStyle.slash;
          break;
      }
    }
    return linestyle;
  }

  PdfRectangle _obtainLineBounds() {
    PdfRectangle bounds = PdfRectangle.fromRect(lineAnnotation.bounds);
    if (points.length == 4 ||
        PdfAnnotationHelper.getHelper(lineAnnotation).isLoadedAnnotation) {
      final List<int> lPoints = _obtainLinePoints();
      if (lPoints.length == 4) {
        final PdfArray lineStyle = PdfArray();
        if (lineStyle.elements.isNotEmpty) {
          lineStyle.insert(
              0,
              PdfName(PdfAnnotationHelper.getHelper(lineAnnotation)
                  .getEnumName(lineAnnotation.beginLineStyle)));
          lineStyle.insert(
              1,
              PdfName(PdfAnnotationHelper.getHelper(lineAnnotation)
                  .getEnumName(lineAnnotation.endLineStyle)));
        } else {
          lineStyle.add(PdfName(lineAnnotation.beginLineStyle.toString()));
          lineStyle.add(PdfName(lineAnnotation.endLineStyle.toString()));
        }
        bounds = PdfAnnotationHelper.getHelper(lineAnnotation)
                .isLoadedAnnotation
            ? PdfAnnotationHelper.getHelper(lineAnnotation).calculateLineBounds(
                lPoints,
                lineAnnotation.leaderLineExt,
                lineAnnotation.leaderLine,
                _obtainLeaderOffset(),
                lineStyle,
                lineAnnotation.border.width)
            : PdfAnnotationHelper.getHelper(lineAnnotation).calculateLineBounds(
                lPoints,
                lineAnnotation.leaderLineExt,
                leaderLine,
                0,
                lineStyle,
                lineAnnotation.border.width);
        bounds = PdfRectangle(bounds.left - 8, bounds.top - 8,
            bounds.width + 2 * 8, bounds.height + 2 * 8);
      }
    }
    return bounds;
  }

  // Gets leader offset of the annotation.
  int _obtainLeaderOffset() {
    int lLineOffset = 0;
    if (PdfAnnotationHelper.getHelper(lineAnnotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.llo)) {
      final PdfNumber lOffset = PdfAnnotationHelper.getHelper(lineAnnotation)
          .dictionary![PdfDictionaryProperties.llo]! as PdfNumber;
      lLineOffset = lOffset.value!.toInt();
    }
    return lLineOffset;
  }

  // Gets line style of the annotation.
  PdfArray? _obtainLineStyle() {
    PdfArray? array;
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(lineAnnotation);
    if (helper.dictionary!.containsKey(PdfDictionaryProperties.le)) {
      array = helper.crossTable
              .getObject(helper.dictionary![PdfDictionaryProperties.le])
          as PdfArray?;
    }
    return array;
  }

  // Gets caption type of the annotation.
  PdfLineCaptionType _obtainCaptionType() {
    PdfLineCaptionType captiontypeValue = PdfLineCaptionType.inline;
    if (PdfAnnotationHelper.getHelper(lineAnnotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.cp)) {
      final PdfName cType = PdfAnnotationHelper.getHelper(lineAnnotation)
          .dictionary![PdfDictionaryProperties.cp]! as PdfName;
      captiontypeValue = _getCaptionType(cType.name.toString());
    }
    return captiontypeValue;
  }

  // Gets caption type of the annotation.
  PdfLineCaptionType _getCaptionType(String cType) {
    PdfLineCaptionType captiontype = PdfLineCaptionType.inline;
    if (cType == 'Inline') {
      captiontype = PdfLineCaptionType.inline;
    } else {
      captiontype = PdfLineCaptionType.top;
    }
    return captiontype;
  }

  /// internal method
  static PdfLineAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfLineAnnotation._(dictionary, crossTable, text);
  }

  /// internal method
  static PdfLineAnnotationHelper getHelper(PdfLineAnnotation annotation) {
    return annotation._helper;
  }
}
