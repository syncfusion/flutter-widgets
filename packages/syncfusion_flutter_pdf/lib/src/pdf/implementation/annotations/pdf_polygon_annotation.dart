import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation_border.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
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

/// Represents a Polygon annotation.
class PdfPolygonAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfPolygonAnnotation] class.
  ///
  /// ``` dart
  /// PdfDocument document = PdfDocument();
  /// PdfPage page = document.pages.add();
  /// List<int> polypoints = <int>[
  ///   50,
  ///   298,
  ///   100,
  ///   325,
  ///   200,
  ///   355,
  ///   300,
  ///   230,
  ///   180,
  ///   230
  /// ];
  /// PdfPolygonAnnotation polygonAnnotation =
  ///     PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
  /// polygonAnnotation.color = PdfColor(255, 0, 0);
  /// polygonAnnotation.innerColor = PdfColor(255, 0, 255);
  /// page.annotations.add(polygonAnnotation);
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPolygonAnnotation(List<int> points, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance}) {
    _helper = PdfPolygonAnnotationHelper(this, points, text,
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

  PdfPolygonAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    _helper = PdfPolygonAnnotationHelper._(this, dictionary, crossTable);
    this.text = text;
  }

  // Fields
  late PdfPolygonAnnotationHelper _helper;

  /// Gets the polygon points of the annotation.
  List<int> get polygonPoints {
    if (_helper.isLoadedAnnotation) {
      final List<int> points = <int>[];
      final PdfDictionary dictionary =
          PdfAnnotationHelper.getHelper(this).dictionary!;
      if (dictionary.containsKey(PdfDictionaryProperties.vertices)) {
        final PdfArray? linePoints =
            dictionary[PdfDictionaryProperties.vertices] as PdfArray?;
        if (linePoints != null) {
          // ignore: avoid_function_literals_in_foreach_calls
          linePoints.elements.forEach((IPdfPrimitive? element) {
            if (element != null && element is PdfNumber) {
              points.add(element.value!.toInt());
            }
          });
        }
      }
      return points;
    } else {
      return _helper._polygonPoints;
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

/// [PdfPolygonAnnotation] helper
class PdfPolygonAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfPolygonAnnotationHelper(this.annotation, List<int> points, String text,
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
        PdfName(PdfDictionaryProperties.polygon));
    linePoints = PdfArray(points);
    _polygonPoints = points;
  }
  PdfPolygonAnnotationHelper._(
      this.annotation, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(annotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  late PdfPolygonAnnotation annotation;

  /// internal field
  PdfArray? linePoints;
  late List<int> _polygonPoints;

  /// internal method
  static PdfPolygonAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfPolygonAnnotation._(dictionary, crossTable, text);
  }

  /// internal property
  @override
  IPdfPrimitive? get element => annotation._element;

  @override
  set element(IPdfPrimitive? value) {
    annotation._element = value;
  }

  /// internal method
  static PdfPolygonAnnotationHelper getHelper(PdfPolygonAnnotation annotation) {
    return annotation._helper;
  }

  /// internal method
  void save() {
    if (PdfAnnotationCollectionHelper.getHelper(annotation.page!.annotations)
        .flatten) {
      PdfAnnotationHelper.getHelper(annotation).flatten = true;
    }
    if (PdfAnnotationHelper.getHelper(annotation).isLoadedAnnotation) {
      _saveOldPolygonAnnotation();
    } else {
      _saveNewPolygonAnnotation();
    }
  }

  void _saveNewPolygonAnnotation() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    final PdfDictionary dictionary = helper.dictionary!;
    Rect nativeRectangle = Rect.zero;
    if (annotation.setAppearance) {
      _getBoundsValue();
      nativeRectangle = Rect.fromLTWH(
          annotation.bounds.left - annotation.border.width,
          annotation.bounds.top - (annotation.border.width),
          annotation.bounds.width + (2 * annotation.border.width),
          annotation.bounds.height + (2 * annotation.border.width));
      dictionary.setProperty(PdfDictionaryProperties.ap, annotation.appearance);
      if (dictionary[PdfDictionaryProperties.ap] != null) {
        annotation.appearance.normal =
            PdfTemplateHelper.fromRect(nativeRectangle);
        final PdfTemplate template = annotation.appearance.normal;
        PdfTemplateHelper.getHelper(template).writeTransformation = false;
        final PdfGraphics? graphics = template.graphics;
        final PdfBrush? backBrushColor = annotation.innerColor.isEmpty
            ? null
            : PdfSolidBrush(annotation.innerColor);
        PdfPen? borderPenColor;
        if (annotation.border.width > 0 &&
            PdfColorHelper.getHelper(annotation.color).alpha != 0) {
          borderPenColor =
              PdfPen(annotation.color, width: annotation.border.width);
        }
        if (helper.flatten) {
          annotation.page!.annotations.remove(annotation);
          annotation.page!.graphics.drawPolygon(_getLinePoints()!,
              pen: borderPenColor, brush: backBrushColor);
        } else {
          graphics!.drawPolygon(_getLinePoints()!,
              pen: borderPenColor, brush: backBrushColor);
        }
      }
    }
    if (helper.flatten && !annotation.setAppearance) {
      annotation.page!.annotations.remove(annotation);
      PdfPen? borderPenColor;
      if (annotation.border.width > 0 &&
          PdfColorHelper.getHelper(annotation.color).alpha != 0) {
        borderPenColor =
            PdfPen(annotation.color, width: annotation.border.width);
      }
      final PdfBrush? backBrushColor = annotation.innerColor.isEmpty
          ? null
          : PdfSolidBrush(annotation.innerColor);
      annotation.page!.graphics.drawPolygon(_getLinePoints()!,
          pen: borderPenColor, brush: backBrushColor);
    } else if (!helper.flatten) {
      helper.saveAnnotation();
      dictionary.setProperty(
          PdfDictionaryProperties.vertices, PdfArray(linePoints));
      dictionary.setProperty(PdfDictionaryProperties.bs, annotation.border);
      _getBoundsValue();
      dictionary.setProperty(PdfDictionaryProperties.rect,
          PdfArray.fromRectangle(PdfRectangle.fromRect(annotation.bounds)));
      if (annotation.setAppearance) {
        dictionary.setProperty(PdfDictionaryProperties.rect,
            PdfArray.fromRectangle(PdfRectangle.fromRect(nativeRectangle)));
      }
    }
  }

  void _saveOldPolygonAnnotation() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    PdfGraphicsState? state;
    PdfRectangle nativeRectangle = PdfRectangle.empty;
    final PdfDictionary dictionary = helper.dictionary!;
    if (annotation.setAppearance) {
      _getBoundsValue();
      nativeRectangle = PdfRectangle(
          annotation.bounds.left - annotation.border.width,
          annotation.page!.size.height -
              annotation.bounds.top -
              (annotation.border.width) -
              annotation.bounds.height,
          annotation.bounds.width + (2 * annotation.border.width),
          annotation.bounds.height + (2 * annotation.border.width));
      dictionary.setProperty(PdfDictionaryProperties.ap, annotation.appearance);
      if (dictionary[PdfDictionaryProperties.ap] != null) {
        annotation.appearance.normal =
            PdfTemplateHelper.fromRect(nativeRectangle.rect);
        final PdfTemplate template = annotation.appearance.normal;
        PdfTemplateHelper.getHelper(template).writeTransformation = false;
        final PdfGraphics? graphics = annotation.appearance.normal.graphics;
        PdfBrush? backgroundBrush;
        if (PdfColorHelper.getHelper(annotation.innerColor).alpha != 0) {
          backgroundBrush = PdfSolidBrush(annotation.innerColor);
        }
        PdfPen? borderPenColor;
        if (annotation.border.width > 0) {
          borderPenColor =
              PdfPen(annotation.color, width: annotation.border.width);
        }
        if (dictionary.containsKey(PdfDictionaryProperties.bs)) {
          PdfDictionary? bSDictionary;
          if (dictionary.items![PdfName(PdfDictionaryProperties.bs)]
              is PdfReferenceHolder) {
            bSDictionary =
                (dictionary.items![PdfName(PdfDictionaryProperties.bs)]!
                        as PdfReferenceHolder)
                    .object as PdfDictionary?;
          } else {
            bSDictionary = dictionary
                .items![PdfName(PdfDictionaryProperties.bs)] as PdfDictionary?;
          }
          if (bSDictionary!.containsKey(PdfDictionaryProperties.d)) {
            final PdfArray? dashPatternArray = PdfCrossTable.dereference(
                    bSDictionary.items![PdfName(PdfDictionaryProperties.d)])
                as PdfArray?;
            if (dashPatternArray != null) {
              final List<double> dashPattern = List<double>.filled(
                  dashPatternArray.count, 0,
                  growable: true);
              for (int i = 0; i < dashPatternArray.count; i++) {
                final IPdfPrimitive? pdfPrimitive =
                    dashPatternArray.elements[i];
                if (pdfPrimitive != null && pdfPrimitive is PdfNumber) {
                  dashPattern[i] = pdfPrimitive.value!.toDouble();
                }
              }
              borderPenColor!.dashStyle = PdfDashStyle.dash;
              PdfPenHelper.getHelper(borderPenColor).isSkipPatternWidth = true;
              borderPenColor.dashPattern = dashPattern;
            }
          }
        }
        if (helper.flatten) {
          annotation.page!.annotations.remove(annotation);
          if (annotation.opacity < 1) {
            state = annotation.page!.graphics.save();
            annotation.page!.graphics.setTransparency(annotation.opacity);
          }
          if (dictionary.containsKey(PdfDictionaryProperties.be)) {
            final PdfDictionary beDictionary =
                dictionary[PdfName(PdfDictionaryProperties.be)]!
                    as PdfDictionary;
            final double? iNumber = (beDictionary
                    .items![PdfName(PdfDictionaryProperties.i)]! as PdfNumber)
                .value as double?;
            final double radius = iNumber == 1 ? 5 : 10;
            if (radius > 0) {
              final List<Offset> points = _getLinePoints()!;
              if (points[0].dy > points[points.length - 1].dy) {
                helper.drawCloudStyle(graphics!, backgroundBrush,
                    borderPenColor, radius, 0.833, _getLinePoints()!, false);
              }
              helper.drawCloudStyle(annotation.page!.graphics, backgroundBrush,
                  borderPenColor, radius, 0.833, _getLinePoints()!, false);
            } else {
              annotation.page!.graphics.drawPolygon(_getLinePoints()!,
                  pen: borderPenColor, brush: backgroundBrush);
            }
          } else {
            annotation.page!.graphics.drawPolygon(_getLinePoints()!,
                pen: borderPenColor, brush: backgroundBrush);
          }
          if (annotation.opacity < 1) {
            annotation.page!.graphics.restore(state);
          }
        } else {
          if (annotation.opacity < 1) {
            state = graphics!.save();
            graphics.setTransparency(annotation.opacity);
          }
          if (dictionary.containsKey(PdfDictionaryProperties.be)) {
            final PdfDictionary beDictionary =
                dictionary[PdfName(PdfDictionaryProperties.be)]!
                    as PdfDictionary;
            final double? iNumber = (beDictionary
                    .items![PdfName(PdfDictionaryProperties.i)]! as PdfNumber)
                .value as double?;
            final double radius = iNumber == 1 ? 5 : 10;
            List<Offset> points = _getLinePoints()!;
            if (points[0].dy > points[points.length - 1].dy) {
              final List<Offset> point = <Offset>[];
              for (int i = 0; i < points.length; i++) {
                point.add(Offset(points[i].dx, -points[i].dy));
              }
              points = point;
              helper.drawCloudStyle(graphics!, backgroundBrush, borderPenColor,
                  radius, 0.833, points, true);
            } else {
              helper.drawCloudStyle(graphics!, backgroundBrush, borderPenColor,
                  radius, 0.833, points, false);
            }
          } else {
            graphics!.drawPolygon(_getLinePoints()!,
                pen: borderPenColor, brush: backgroundBrush);
          }
          if (annotation.opacity < 1) {
            graphics.restore(state);
          }
        }
        dictionary.setProperty(PdfDictionaryProperties.rect,
            PdfArray.fromRectangle(nativeRectangle));
      }
    }
    if (helper.flatten && !annotation.setAppearance) {
      if (dictionary[PdfDictionaryProperties.ap] != null) {
        IPdfPrimitive? obj = dictionary[PdfDictionaryProperties.ap];
        PdfDictionary? dic = PdfCrossTable.dereference(obj) as PdfDictionary?;
        PdfTemplate? template;
        if (dic != null) {
          obj = dic[PdfDictionaryProperties.n];
          dic = PdfCrossTable.dereference(obj) as PdfDictionary?;
          if (dic != null && dic is PdfStream) {
            final PdfStream stream = dic;
            template = PdfTemplateHelper.fromPdfStream(stream);
            state = annotation.page!.graphics.save();
            if (annotation.opacity < 1) {
              annotation.page!.graphics.setTransparency(annotation.opacity);
            }
            final bool isNormalMatrix = helper.validateTemplateMatrix(dic);
            final Rect rect = helper.calculateTemplateBounds(
                annotation.bounds, annotation.page, template, isNormalMatrix);
            annotation.page!.graphics
                .drawPdfTemplate(template, rect.topLeft, rect.size);
            annotation.page!.graphics.restore(state);
            annotation.page!.annotations.remove(annotation);
          }
        }
      } else {
        annotation.page!.annotations.remove(annotation);
        final PdfPen borderPenColor =
            PdfPen(annotation.color, width: annotation.border.width);
        final PdfBrush? backgroundBrush = annotation.innerColor.isEmpty
            ? null
            : PdfSolidBrush(annotation.innerColor);
        if (annotation.opacity < 1) {
          state = annotation.page!.graphics.save();
          annotation.page!.graphics.setTransparency(annotation.opacity);
        }
        if (dictionary.containsKey(PdfDictionaryProperties.be)) {
          final IPdfPrimitive? primitive =
              dictionary[PdfName(PdfDictionaryProperties.be)];
          final PdfDictionary beDictionary = (primitive is PdfReferenceHolder
              ? primitive.object
              : primitive)! as PdfDictionary;
          final double? iNumber = (beDictionary
                  .items![PdfName(PdfDictionaryProperties.i)]! as PdfNumber)
              .value as double?;
          final double radius = iNumber == 1 ? 5 : 10;
          helper.drawCloudStyle(annotation.page!.graphics, backgroundBrush,
              borderPenColor, radius, 0.833, _getLinePoints()!, false);
        } else {
          annotation.page!.graphics.drawPolygon(_getLinePoints()!,
              pen: borderPenColor, brush: backgroundBrush);
        }
        if (annotation.opacity < 1) {
          annotation.page!.graphics.restore(state);
        }
      }
      if (helper.flattenPopups) {
        helper.flattenPopup();
      }
    }
  }

  List<Offset>? _getLinePoints() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    if (helper.isLoadedAnnotation) {
      List<Offset>? points;
      if (helper.dictionary!.containsKey(PdfDictionaryProperties.vertices)) {
        final PdfArray? linePoints =
            helper.dictionary![PdfDictionaryProperties.vertices] as PdfArray?;
        if (linePoints != null) {
          final List<double> point = <double>[];
          for (int i = 0; i < linePoints.count; i++) {
            final PdfNumber number = linePoints[i]! as PdfNumber;
            point.add(number.value!.toDouble());
          }
          points = <Offset>[];
          for (int j = 0; j < point.length; j = j + 2) {
            if (helper.flatten) {
              points.add(Offset(
                  point[j], annotation.page!.size.height - point[j + 1]));
            } else {
              points.add(Offset(point[j], -point[j + 1]));
            }
          }
        }
      }
      return points;
    } else {
      final List<Offset> points = <Offset>[];
      if (linePoints != null) {
        final List<double> pointsValue = <double>[];
        // ignore: prefer_final_in_for_each
        for (IPdfPrimitive? linePoint in linePoints!.elements) {
          if (linePoint is PdfNumber) {
            pointsValue.add(linePoint.value!.toDouble());
          }
        }
        for (int j = 0; j < pointsValue.length; j = j + 2) {
          final double pageHeight = annotation.page!.size.height;
          if (helper.flatten) {
            PdfPageHelper.getHelper(annotation.page!).isLoadedPage
                ? points.add(
                    Offset(pointsValue[j], pageHeight - pointsValue[j + 1]))
                : points.add(Offset(
                    pointsValue[j] -
                        PdfPageHelper.getHelper(annotation.page!)
                            .section!
                            .pageSettings
                            .margins
                            .left,
                    pageHeight -
                        pointsValue[j + 1] -
                        PdfPageHelper.getHelper(annotation.page!)
                            .section!
                            .pageSettings
                            .margins
                            .right));
          } else {
            points.add(Offset(pointsValue[j], -pointsValue[j + 1]));
          }
        }
      }
      return points;
    }
  }

  void _getBoundsValue() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(annotation);
    if (helper.isLoadedAnnotation) {
      final PdfArray rect =
          helper.dictionary![PdfDictionaryProperties.rect]! as PdfArray;
      annotation.bounds = rect.toRectangle().rect;
      final List<double> xval = <double>[];
      final List<double> yval = <double>[];
      if (helper.dictionary!.containsKey(PdfDictionaryProperties.vertices)) {
        final PdfArray linePoints = PdfCrossTable.dereference(
            helper.dictionary![PdfDictionaryProperties.vertices])! as PdfArray;
        if (linePoints.count > 0) {
          final List<double> points =
              List<double>.filled(linePoints.count, 0, growable: true);
          for (int j = 0; j < linePoints.count; j++) {
            final PdfNumber number = linePoints[j]! as PdfNumber;
            points[j] = number.value!.toDouble();
          }
          for (int i = 0; i < points.length; i++) {
            if (i.isEven) {
              xval.add(points[i]);
            } else {
              yval.add(points[i]);
            }
          }
        }
      }
      xval.sort();
      yval.sort();
      annotation.bounds = Rect.fromLTWH(xval[0], yval[0],
          xval[xval.length - 1] - xval[0], yval[yval.length - 1] - yval[0]);
    } else {
      final List<double> xval = <double>[];
      final List<double> yval = <double>[];
      if (linePoints!.count > 0) {
        final List<double> pointsValue = <double>[];
        // ignore: prefer_final_in_for_each
        for (IPdfPrimitive? linePoint in linePoints!.elements) {
          if (linePoint is PdfNumber) {
            pointsValue.add(linePoint.value!.toDouble());
          }
        }
        for (int i = 0; i < pointsValue.length; i++) {
          if (i.isEven) {
            xval.add(pointsValue[i]);
          } else {
            yval.add(pointsValue[i]);
          }
        }
      }
      xval.sort();
      yval.sort();
      annotation.bounds = Rect.fromLTWH(xval[0], yval[0],
          xval[xval.length - 1] - xval[0], yval[yval.length - 1] - yval[0]);
    }
  }
}
