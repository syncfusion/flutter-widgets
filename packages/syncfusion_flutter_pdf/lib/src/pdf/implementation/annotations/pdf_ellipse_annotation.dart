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
import 'pdf_appearance.dart';
import 'pdf_paintparams.dart';

/// Represents a PDF ellipse annotation
class PdfEllipseAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfEllipseAnnotation] class.
  /// ``` dart
  /// //Create a  PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a  page.
  /// PdfPage page = document.pages.add();
  /// //Create a PDF Ellipse annotation.
  /// PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
  ///     const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
  ///     innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
  /// //Add annotation to the page.
  /// page.annotations.add(ellipseAnnotation);
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfEllipseAnnotation(Rect bounds, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance}) {
    _helper = PdfEllipseAnnotationHelper(this, bounds, text,
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

  PdfEllipseAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    _helper = PdfEllipseAnnotationHelper._(this, dictionary, crossTable);
    this.text = text;
  }

  // fields
  late PdfEllipseAnnotationHelper _helper;

  // properties
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

/// [PdfEllipseAnnotation] helper
class PdfEllipseAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfEllipseAnnotationHelper(this.annotation, Rect bounds, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance})
      : super(annotation) {
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
        PdfName(PdfDictionaryProperties.circle));
  }

  PdfEllipseAnnotationHelper._(
      this.annotation, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(annotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  late PdfEllipseAnnotation annotation;

  /// internal method
  void save() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    if (PdfAnnotationCollectionHelper.getHelper(annotation.page!.annotations)
        .flatten) {
      helper.flatten = true;
    }
    final PdfAppearance? pdfAppearance = helper.appearance;
    final bool isLoadedAnnotation = helper.isLoadedAnnotation;
    if (helper.flatten || annotation.setAppearance || pdfAppearance != null) {
      PdfTemplate? appearance;
      if (pdfAppearance != null) {
        appearance = pdfAppearance.normal;
      } else {
        appearance = _createAppearance();
      }
      if (helper.flatten) {
        if (appearance != null || isLoadedAnnotation) {
          if (annotation.page != null) {
            _flattenAnnotation(annotation.page, appearance);
          }
        }
      } else {
        if (appearance != null) {
          annotation.appearance.normal = appearance;
          helper.dictionary!.setProperty(PdfDictionaryProperties.ap,
              PdfReferenceHolder(annotation.appearance));
        }
      }
    }
    if (!helper.flatten && !isLoadedAnnotation) {
      helper.saveAnnotation();
      helper.dictionary!
          .setProperty(PdfDictionaryProperties.bs, annotation.border);
    }
    if (helper.flattenPopups) {
      helper.flattenPopup();
    }
  }

  void _flattenAnnotation(PdfPage? page, PdfTemplate? appearance) {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    if (helper.isLoadedAnnotation) {
      final bool isContainsAP =
          helper.dictionary!.containsKey(PdfDictionaryProperties.ap);
      if (appearance == null) {
        if (isContainsAP) {
          PdfDictionary? appearanceDictionary = PdfCrossTable.dereference(
              helper.dictionary![PdfDictionaryProperties.ap]) as PdfDictionary?;
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
              annotation.setAppearance = true;
              appearance = _createAppearance();
              if (appearance != null) {
                final bool isNormalMatrix = helper.validateTemplateMatrix(
                    PdfTemplateHelper.getHelper(appearance).content);
                helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
              }
            }
          }
        } else {
          annotation.setAppearance = true;
          appearance = _createAppearance();
          if (appearance != null) {
            final bool isNormalMatrix = helper.validateTemplateMatrix(
                PdfTemplateHelper.getHelper(appearance).content);
            helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
          }
        }
      } else {
        final bool isNormalMatrix = helper.validateTemplateMatrix(
            PdfTemplateHelper.getHelper(appearance).content);
        helper.flattenAnnotationTemplate(appearance, isNormalMatrix);
      }
    } else {
      page!.graphics.save();
      final Rect rectangle = helper.calculateTemplateBounds(
          annotation.bounds, page, appearance, true);
      if (annotation.opacity < 1) {
        page.graphics.setTransparency(annotation.opacity);
      }
      page.graphics.drawPdfTemplate(
          appearance!, Offset(rectangle.left, rectangle.top), rectangle.size);
      page.annotations.remove(annotation);
      page.graphics.restore();
    }
  }

  PdfTemplate? _createAppearance() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    final bool isLoadedAnnotation = helper.isLoadedAnnotation;
    if (isLoadedAnnotation && !annotation.setAppearance) {
      return null;
    }
    final PdfRectangle nativeRectangle =
        PdfRectangle(0, 0, annotation.bounds.width, annotation.bounds.height);
    final PdfTemplate template =
        PdfTemplateHelper.fromRect(nativeRectangle.rect);
    PdfAnnotationHelper.setMatrixToZeroRotation(
        PdfTemplateHelper.getHelper(template).content);
    if (isLoadedAnnotation &&
        helper.dictionary!.containsKey(PdfDictionaryProperties.be)) {
      PdfTemplateHelper.getHelper(template).writeTransformation = false;
    }
    final PaintParams paintParams = PaintParams();
    final double borderWidth = annotation.border.width / 2;
    final PdfPen mBorderPen =
        PdfPen(annotation.color, width: annotation.border.width);
    if (annotation.border.width > 0 &&
        PdfColorHelper.getHelper(annotation.color).alpha != 0) {
      paintParams.borderPen = mBorderPen;
    }
    PdfBrush? mBackBrush;
    if (PdfColorHelper.getHelper(annotation.color).alpha != 0) {
      mBackBrush = PdfSolidBrush(annotation.innerColor);
    }
    paintParams.foreBrush = PdfSolidBrush(annotation.color);
    paintParams.backBrush = mBackBrush;
    final PdfGraphics? graphics = template.graphics;
    if (annotation.opacity < 1) {
      graphics!.save();
      graphics.setTransparency(annotation.opacity);
    }
    if (isLoadedAnnotation) {
      final PdfRectangle rectangle =
          _obtainStyle(mBorderPen, nativeRectangle, borderWidth);
      if (helper.dictionary!.containsKey(PdfDictionaryProperties.be)) {
        _drawAppearance(rectangle, borderWidth, graphics, paintParams);
      } else {
        graphics!.drawEllipse(
            Rect.fromLTWH(rectangle.x + borderWidth, rectangle.y,
                rectangle.width - annotation.border.width, rectangle.height),
            pen: paintParams.borderPen,
            brush: paintParams.backBrush);
      }
    } else {
      final Rect rect = Rect.fromLTWH(nativeRectangle.left, nativeRectangle.top,
          nativeRectangle.width, nativeRectangle.height);
      graphics!.drawEllipse(
          Rect.fromLTWH(
              rect.left + borderWidth,
              rect.top + borderWidth,
              rect.width - annotation.border.width,
              rect.height - annotation.border.width),
          pen: paintParams.borderPen,
          brush: paintParams.backBrush);
    }
    if (annotation.opacity < 1) {
      graphics!.restore();
    }
    return template;
  }

  // Obtain Style for annotation
  PdfRectangle _obtainStyle(
      PdfPen mBorderPen, PdfRectangle rectangle, double borderWidth) {
    final PdfDictionary dictionary =
        PdfAnnotationHelper.getHelper(annotation).dictionary!;
    if (dictionary.containsKey(PdfDictionaryProperties.bs)) {
      final PdfDictionary? bSDictionary =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.bs])
              as PdfDictionary?;

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
    if (!PdfAnnotationHelper.getHelper(annotation).isBounds &&
        dictionary[PdfDictionaryProperties.rd] != null) {
      final PdfArray? mRdArray =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.rd])
              as PdfArray?;
      if (mRdArray != null) {
        final PdfNumber num1 = mRdArray.elements[0]! as PdfNumber;
        final PdfNumber num2 = mRdArray.elements[1]! as PdfNumber;
        final PdfNumber num3 = mRdArray.elements[2]! as PdfNumber;
        final PdfNumber num4 = mRdArray.elements[3]! as PdfNumber;
        rectangle.x += num1.value!;
        rectangle.y += borderWidth + num2.value!;
        rectangle.width = rectangle.width - (2 * num3.value!);
        rectangle.height = rectangle.height - annotation.border.width;
        rectangle.height = rectangle.height - (2 * num4.value!);
      }
    } else {
      rectangle.y += borderWidth;
      rectangle.height = annotation.bounds.height - annotation.border.width;
    }
    return rectangle;
  }

  // Draw appearance for annotation
  void _drawAppearance(PdfRectangle rectangle, double borderWidth,
      PdfGraphics? graphics, PaintParams paintParams) {
    final PdfPath graphicsPath = PdfPath();
    graphicsPath.addEllipse(Rect.fromLTWH(
        rectangle.x + borderWidth,
        -rectangle.y - rectangle.height,
        rectangle.width - annotation.border.width,
        rectangle.height));
    double? radius = 0;
    if (PdfAnnotationHelper.getHelper(annotation)
        .dictionary!
        .containsKey(PdfDictionaryProperties.rd)) {
      final PdfArray? rdArray = PdfCrossTable.dereference(
          PdfAnnotationHelper.getHelper(annotation)
              .dictionary!
              .items![PdfName(PdfDictionaryProperties.rd)]) as PdfArray?;
      if (rdArray != null) {
        radius = (rdArray.elements[0]! as PdfNumber).value as double?;
      }
    }
    if (radius! > 0) {
      final PdfRectangle rect = PdfRectangle(
          rectangle.x + borderWidth,
          -rectangle.y - rectangle.height,
          rectangle.width - annotation.border.width,
          rectangle.height);
      final List<Offset> startPointList = <Offset>[];
      final List<Offset> controlPointList = <Offset>[];
      final List<Offset> endPointList = <Offset>[];
      final List<Offset> points = <Offset>[];

      controlPointList.add(Offset(rect.right, rect.bottom));
      controlPointList.add(Offset(rect.left, rect.bottom));
      controlPointList.add(Offset(rect.left, rect.top));
      controlPointList.add(Offset(rect.right, rect.top));

      startPointList.add(Offset(rect.right, rect.top + (rect.height / 2)));
      startPointList.add(Offset(rect.left + rect.width / 2, rect.bottom));
      startPointList.add(Offset(rect.left, rect.top + (rect.height / 2)));
      startPointList.add(Offset(rect.left + (rect.width / 2), rect.top));

      endPointList.add(Offset(rect.left + rect.width / 2, rect.bottom));
      endPointList.add(Offset(rect.left, rect.top + (rect.height / 2)));
      endPointList.add(Offset(rect.left + (rect.width / 2), rect.top));
      endPointList.add(Offset(rect.right, rect.top + (rect.height / 2)));

      for (int i = 0; i < controlPointList.length; i++) {
        _createBezier(
            startPointList[i], controlPointList[i], endPointList[i], points);
      }
      PdfAnnotationHelper.getHelper(annotation).drawCloudStyle(
          graphics!,
          paintParams.backBrush,
          paintParams.borderPen,
          radius,
          0.833,
          points,
          false);
      startPointList.clear();
      controlPointList.clear();
      endPointList.clear();
      points.clear();
    } else {
      graphics!.drawEllipse(
          Rect.fromLTWH(rectangle.x + borderWidth, -rectangle.y,
              rectangle.width - annotation.border.width, -rectangle.height),
          pen: paintParams.borderPen,
          brush: paintParams.backBrush);
    }
  }

  // Create bezier curve
  void _createBezier(
      Offset ctrl1, Offset ctrl2, Offset ctrl3, List<Offset> bezierPoints) {
    bezierPoints.add(ctrl1); // add the first control point
    _populateBezierPoints(ctrl1, ctrl2, ctrl3, 0, bezierPoints);
    bezierPoints.add(ctrl3); // add the last control point
  }

  // calculate bezier points
  void _populateBezierPoints(Offset ctrl1, Offset ctrl2, Offset ctrl3,
      int currentIteration, List<Offset> bezierPoints) {
    if (currentIteration < 2) {
      //calculate next mid points
      final Offset midPoint1 =
          Offset((ctrl1.dx + ctrl2.dx) / 2, (ctrl1.dy + ctrl2.dy) / 2);
      final Offset midPoint2 =
          Offset((ctrl2.dx + ctrl3.dx) / 2, (ctrl2.dy + ctrl3.dy) / 2);
      final Offset midPoint3 = Offset(
          (midPoint1.dx + midPoint2.dx) / 2, (midPoint1.dy + midPoint2.dy) / 2);
      //the next control point
      currentIteration++;
      _populateBezierPoints(ctrl1, midPoint1, midPoint3, currentIteration,
          bezierPoints); //left branch
      bezierPoints.add(midPoint3);
      //add the next control point
      _populateBezierPoints(midPoint3, midPoint2, ctrl3, currentIteration,
          bezierPoints); //right branch
    }
  }

  /// internal property
  @override
  IPdfPrimitive? get element {
    return annotation._element;
  }

  @override
  set element(IPdfPrimitive? element) {
    annotation._element = element;
  }

  /// internal method
  static PdfEllipseAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfEllipseAnnotation._(dictionary, crossTable, text);
  }

  /// internal method
  static PdfEllipseAnnotationHelper getHelper(PdfEllipseAnnotation annotation) {
    return annotation._helper;
  }
}
