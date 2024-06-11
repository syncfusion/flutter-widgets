import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation_border.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_path.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_collection.dart';
import 'pdf_paintparams.dart';

/// Represents a PDF rectangle annotation
class PdfRectangleAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfRectangleAnnotation] with bounds, text, border, color, innerColor, author, rotate, subject, modifiedDate, and flags.
  /// ``` dart
  /// PdfDocument document = PdfDocument();
  /// PdfPage page = document.pages.add();
  /// PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
  ///     const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation',
  ///     innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
  /// page.annotations.add(rectangleAnnotation);
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfRectangleAnnotation(Rect bounds, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance}) {
    _helper = PdfRectangleAnnotationHelper(this, bounds, text,
        color: color,
        innerColor: innerColor,
        border: border,
        author: author,
        subject: subject,
        modifiedDate: modifiedDate,
        opacity: opacity,
        flags: flags,
        setAppearance: setAppearance);
  }

  PdfRectangleAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    _helper = PdfRectangleAnnotationHelper._(this, dictionary, crossTable);
    this.text = text;
  }

  // Fields
  late PdfRectangleAnnotationHelper _helper;

  // Properites
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

/// [PdfRectangleAnnotation] helper
class PdfRectangleAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfRectangleAnnotationHelper(
      this.rectangleAnnotation, Rect bounds, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance})
      : super(rectangleAnnotation) {
    initializeAnnotation(
        bounds: bounds,
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
    dictionary!.setProperty(PdfDictionaryProperties.subtype,
        PdfName(PdfDictionaryProperties.square));
  }
  PdfRectangleAnnotationHelper._(this.rectangleAnnotation,
      PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(rectangleAnnotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  late PdfRectangleAnnotation rectangleAnnotation;

  /// internal method
  static PdfRectangleAnnotationHelper getHelper(
      PdfRectangleAnnotation annotation) {
    return annotation._helper;
  }

  /// internal method
  static PdfRectangleAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfRectangleAnnotation._(dictionary, crossTable, text);
  }

  /// internal method
  @override
  IPdfPrimitive? get element => rectangleAnnotation._element;
  @override
  set element(IPdfPrimitive? value) {
    rectangleAnnotation._element = value;
  }

  /// internal method
  void save() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(rectangleAnnotation);
    if (PdfAnnotationCollectionHelper.getHelper(
            rectangleAnnotation.page!.annotations)
        .flatten) {
      helper.flatten = true;
    }
    if (helper.flatten ||
        rectangleAnnotation.setAppearance ||
        helper.appearance != null) {
      PdfTemplate? appearance;
      if (helper.appearance != null) {
        appearance = helper.appearance!.normal;
      } else {
        appearance = _createAppearance();
      }
      if (helper.flatten) {
        if (appearance != null || helper.isLoadedAnnotation) {
          if (rectangleAnnotation.page != null) {
            _flattenAnnotation(rectangleAnnotation.page, appearance);
          }
        }
      } else {
        if (appearance != null) {
          rectangleAnnotation.appearance.normal = appearance;
          helper.dictionary!.setProperty(PdfDictionaryProperties.ap,
              PdfReferenceHolder(rectangleAnnotation.appearance));
        }
      }
    }
    if (!helper.flatten && !helper.isLoadedAnnotation) {
      helper.saveAnnotation();
      helper.dictionary!
          .setProperty(PdfDictionaryProperties.bs, rectangleAnnotation.border);
    }
    if (helper.flattenPopups) {
      helper.flattenPopup();
    }
  }

  PdfTemplate? _createAppearance() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(rectangleAnnotation);
    if (helper.isLoadedAnnotation) {
      if (rectangleAnnotation.setAppearance) {
        final PaintParams paintParams = PaintParams();
        final double borderWidth = rectangleAnnotation.border.width / 2;
        final PdfPen mBorderPen = PdfPen(rectangleAnnotation.color,
            width: rectangleAnnotation.border.width);
        PdfBrush? mBackBrush;
        final Map<String, dynamic> result = _calculateCloudBorderBounds();
        final double borderIntensity = result['borderIntensity'] as double;
        final String? borderStyle = result['borderStyle'] as String?;
        final PdfRectangle nativeRectangle = PdfRectangle(
            0,
            0,
            rectangleAnnotation.bounds.width,
            rectangleAnnotation.bounds.height);
        final PdfTemplate template =
            PdfTemplateHelper.fromRect(nativeRectangle.rect);
        PdfAnnotationHelper.setMatrixToZeroRotation(
            PdfTemplateHelper.getHelper(template).content);
        if (borderIntensity > 0 && borderStyle == 'C') {
          PdfTemplateHelper.getHelper(template).writeTransformation = false;
        }
        final PdfGraphics? graphics = template.graphics;
        if (PdfColorHelper.getHelper(rectangleAnnotation.innerColor).alpha !=
            0) {
          mBackBrush = PdfSolidBrush(rectangleAnnotation.innerColor);
        }
        if (rectangleAnnotation.border.width > 0) {
          paintParams.borderPen = mBorderPen;
        }
        paintParams.foreBrush = PdfSolidBrush(rectangleAnnotation.color);
        paintParams.backBrush = mBackBrush;
        final PdfRectangle rectangle = _obtainStyle(
            mBorderPen, nativeRectangle, borderWidth,
            borderIntensity: borderIntensity, borderStyle: borderStyle);
        if (rectangleAnnotation.opacity < 1) {
          graphics!.save();
          graphics.setTransparency(rectangleAnnotation.opacity);
        }
        if (borderIntensity > 0 && borderStyle == 'C') {
          _drawAppearance(
              rectangle, borderWidth, graphics, paintParams, borderIntensity);
        } else {
          graphics!.drawRectangle(
              pen: paintParams.borderPen,
              brush: paintParams.backBrush,
              bounds: Rect.fromLTWH(
                  rectangle.x, rectangle.y, rectangle.width, rectangle.height));
        }
        if (rectangleAnnotation.opacity < 1) {
          graphics!.restore();
        }
        return template;
      }
      return null;
    } else {
      final Rect nativeRectangle = Rect.fromLTWH(0, 0,
          rectangleAnnotation.bounds.width, rectangleAnnotation.bounds.height);
      final PdfTemplate template = PdfTemplate(
          rectangleAnnotation.bounds.width, rectangleAnnotation.bounds.height);
      PdfAnnotationHelper.setMatrixToZeroRotation(
          PdfTemplateHelper.getHelper(template).content);
      final PaintParams paintParams = PaintParams();
      final PdfGraphics graphics = template.graphics!;
      if (rectangleAnnotation.border.width > 0 &&
          PdfColorHelper.getHelper(rectangleAnnotation.color).alpha != 0) {
        final PdfPen mBorderPen = PdfPen(rectangleAnnotation.color,
            width: rectangleAnnotation.border.width);
        paintParams.borderPen = mBorderPen;
      }
      PdfBrush? mBackBrush;
      if (PdfColorHelper.getHelper(rectangleAnnotation.innerColor).alpha != 0) {
        mBackBrush = PdfSolidBrush(rectangleAnnotation.innerColor);
      }
      final double width = rectangleAnnotation.border.width / 2;

      paintParams.backBrush = mBackBrush;
      if (paintParams.foreBrush != PdfSolidBrush(rectangleAnnotation.color)) {
        paintParams.foreBrush = PdfSolidBrush(rectangleAnnotation.color);
      }
      final Rect rect = Rect.fromLTWH(nativeRectangle.left, nativeRectangle.top,
          nativeRectangle.width, nativeRectangle.height);
      if (rectangleAnnotation.opacity < 1) {
        graphics.save();
        graphics.setTransparency(rectangleAnnotation.opacity);
      }
      graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              rect.left + width,
              rect.top + width,
              rect.width - rectangleAnnotation.border.width,
              rect.height - rectangleAnnotation.border.width),
          pen: paintParams.borderPen,
          brush: paintParams.backBrush);
      if (rectangleAnnotation.opacity < 1) {
        graphics.restore();
      }
      return template;
    }
  }

  Map<String, dynamic> _calculateCloudBorderBounds() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(rectangleAnnotation);
    double borderIntensity = 0;
    String borderStyle = '';
    final PdfDictionary dictionary = helper.dictionary!;
    if (!dictionary.containsKey(PdfDictionaryProperties.rd) &&
        dictionary.containsKey(PdfDictionaryProperties.be)) {
      final PdfDictionary dict =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.be])!
              as PdfDictionary;
      if (dict.containsKey(PdfDictionaryProperties.s)) {
        borderStyle = helper
            .getEnumName((dict[PdfDictionaryProperties.s]! as PdfName).name);
      }
      if (dict.containsKey(PdfDictionaryProperties.i)) {
        borderIntensity =
            (dict[PdfDictionaryProperties.i]! as PdfNumber).value!.toDouble();
      }
      if (borderIntensity != 0 && borderStyle == 'C') {
        final Rect cloudRectangle = Rect.fromLTWH(
            rectangleAnnotation.bounds.left -
                borderIntensity * 5 -
                rectangleAnnotation.border.width / 2,
            rectangleAnnotation.bounds.top -
                borderIntensity * 5 -
                rectangleAnnotation.border.width / 2,
            rectangleAnnotation.bounds.width +
                borderIntensity * 10 +
                rectangleAnnotation.border.width,
            rectangleAnnotation.bounds.height +
                borderIntensity * 10 +
                rectangleAnnotation.border.width);
        final double radius = borderIntensity * 5;
        final List<double> arr = <double>[
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2
        ];
        dictionary.setProperty(PdfDictionaryProperties.rd, PdfArray(arr));
        rectangleAnnotation.bounds = cloudRectangle;
      }
    }
    if (!helper.isBounds && dictionary[PdfDictionaryProperties.rd] != null) {
      final PdfArray mRdArray =
          dictionary[PdfDictionaryProperties.rd]! as PdfArray;
      final PdfNumber num1 = mRdArray.elements[0]! as PdfNumber;
      final PdfNumber num2 = mRdArray.elements[1]! as PdfNumber;
      final PdfNumber num3 = mRdArray.elements[2]! as PdfNumber;
      final PdfNumber num4 = mRdArray.elements[3]! as PdfNumber;
      Rect cloudRectangle = Rect.fromLTWH(
          rectangleAnnotation.bounds.left + num1.value!.toDouble(),
          rectangleAnnotation.bounds.top + num2.value!.toDouble(),
          rectangleAnnotation.bounds.width - num3.value!.toDouble() * 2,
          rectangleAnnotation.bounds.height - num4.value!.toDouble() * 2);
      if (borderIntensity != 0 && borderStyle == 'C') {
        cloudRectangle = Rect.fromLTWH(
            cloudRectangle.left -
                borderIntensity * 5 -
                rectangleAnnotation.border.width / 2,
            cloudRectangle.top -
                borderIntensity * 5 -
                rectangleAnnotation.border.width / 2,
            cloudRectangle.width +
                borderIntensity * 10 +
                rectangleAnnotation.border.width,
            cloudRectangle.height +
                borderIntensity * 10 +
                rectangleAnnotation.border.width);
        final double radius = borderIntensity * 5;
        final List<double> arr = <double>[
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2,
          radius + rectangleAnnotation.border.width / 2
        ];
        dictionary.setProperty(PdfDictionaryProperties.rd, PdfArray(arr));
      } else {
        dictionary.remove(PdfDictionaryProperties.rd);
      }
      rectangleAnnotation.bounds = cloudRectangle;
    }
    return <String, dynamic>{
      'borderIntensity': borderIntensity,
      'borderStyle': borderStyle
    };
  }

  void _flattenAnnotation(PdfPage? page, PdfTemplate? appearance) {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(rectangleAnnotation);
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
            rectangleAnnotation.setAppearance = true;
            appearance = _createAppearance();
            if (appearance != null) {
              final bool isNormalMatrix = helper.validateTemplateMatrix(
                  PdfTemplateHelper.getHelper(appearance).content);
              helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
            }
          }
        }
      } else if (!isContainsAP && appearance == null) {
        rectangleAnnotation.setAppearance = true;
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
          rectangleAnnotation.bounds, page, appearance, true);

      if (rectangleAnnotation.opacity < 1) {
        page.graphics.setTransparency(rectangleAnnotation.opacity);
      }
      page.graphics.drawPdfTemplate(
          appearance!, Offset(rectangle.left, rectangle.top), rectangle.size);
      page.annotations.remove(rectangleAnnotation);
      page.graphics.restore();
    }
  }

  // Obtain Style from annotation
  PdfRectangle _obtainStyle(
      PdfPen mBorderPen, PdfRectangle rectangle, double borderWidth,
      {double? borderIntensity, String? borderStyle}) {
    if (PdfAnnotationHelper.getHelper(rectangleAnnotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.bs)) {
      final PdfDictionary? bSDictionary = PdfCrossTable.dereference(
          PdfAnnotationHelper.getHelper(rectangleAnnotation)
              .dictionary![PdfDictionaryProperties.bs]) as PdfDictionary?;
      if (bSDictionary != null &&
          bSDictionary.containsKey(PdfDictionaryProperties.d)) {
        final PdfArray dashPatternArray =
            PdfCrossTable.dereference(bSDictionary[PdfDictionaryProperties.d])!
                as PdfArray;
        final List<double> dashPattern = <double>[];
        for (int i = 0; i < dashPatternArray.count; i++) {
          dashPattern.add(
              (dashPatternArray.elements[i]! as PdfNumber).value!.toDouble());
        }
        mBorderPen.dashStyle = PdfDashStyle.dash;
        mBorderPen.dashPattern = dashPattern;
      }
    }
    if (borderIntensity != null &&
        borderIntensity > 0 &&
        borderStyle != null &&
        borderStyle == 'C') {
      final double radius = borderIntensity * 5;
      rectangle.x = rectangle.x + radius + borderWidth;
      rectangle.y = rectangle.y + radius + borderWidth;
      rectangle.width = rectangle.width - (2 * radius) - 2 * borderWidth;
      rectangle.height = rectangle.height - (2 * radius) - 2 * borderWidth;
    } else {
      rectangle.x += borderWidth;
      rectangle.y += borderWidth;
      rectangle.width -= rectangleAnnotation.border.width;
      rectangle.height -= rectangleAnnotation.border.width;
    }
    return rectangle;
  }

  // Draw appearance for annotation
  void _drawAppearance(PdfRectangle rectangle, double borderWidth,
      PdfGraphics? graphics, PaintParams paintParams, double borderIntensity) {
    final PdfPath graphicsPath = PdfPath();
    graphicsPath.addRectangle(rectangle.rect);
    final double radius = borderIntensity * 4.25;
    if (radius > 0) {
      if (PdfPathHelper.getHelper(graphicsPath).points.length == 5 &&
          PdfPathHelper.getHelper(graphicsPath).points[4] == Offset.zero) {
        PdfPathHelper.getHelper(graphicsPath).points.removeAt(4);
      }
      final List<Offset> points = <Offset>[];
      for (int i = 0;
          i < PdfPathHelper.getHelper(graphicsPath).points.length;
          i++) {
        points.add(Offset(PdfPathHelper.getHelper(graphicsPath).points[i].dx,
            -PdfPathHelper.getHelper(graphicsPath).points[i].dy));
      }
      PdfAnnotationHelper.getHelper(rectangleAnnotation).drawCloudStyle(
          graphics!,
          paintParams.backBrush,
          paintParams.borderPen,
          radius,
          0.833,
          points,
          false);
    } else {
      graphics!.drawRectangle(
          pen: paintParams.borderPen,
          brush: paintParams.backBrush,
          bounds: Rect.fromLTWH(
              rectangle.x + borderWidth,
              rectangle.y,
              rectangle.width - rectangleAnnotation.border.width,
              rectangle.height));
    }
  }
}
