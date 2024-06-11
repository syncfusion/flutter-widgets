import 'dart:math';
import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_path.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_margins.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/enum.dart';
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

/// Represents the text markup annotation.
class PdfTextMarkupAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of [PdfTextMarkupAnnotation] class with bounds, text, color, author, subject, modifiedDate, boundsCollection, flags and textMarkupAnnotationType.
  /// ``` dart
  /// //Create a new PDF document.
  /// final PdfDocument document = PdfDocument();
  /// //Create a new page.
  /// final PdfPage page = document.pages.add();
  /// //Create PDF font with font style.
  /// final PdfFont font =
  ///     PdfStandardFont(PdfFontFamily.courier, 10, style: PdfFontStyle.bold);
  /// const String markupText = 'Text Markup';
  /// final Size textSize = font.measureString(markupText);
  /// page.graphics.drawString(markupText, font,
  ///     brush: PdfBrushes.black, bounds: const Rect.fromLTWH(175, 40, 0, 0));
  /// //Create a text markup annotation.
  /// final PdfTextMarkupAnnotation markupAnnotation = PdfTextMarkupAnnotation(
  ///     Rect.fromLTWH(175, 40, textSize.width, textSize.height),
  ///     'Markup annotation',
  ///     PdfColor(128, 43, 226));
  /// markupAnnotation.author = 'MarkUp';
  /// markupAnnotation.textMarkupAnnotationType =
  ///     PdfTextMarkupAnnotationType.highlight;
  /// //Adds the annotation to the page
  /// page.annotations.add(markupAnnotation);
  /// final List<int> bytes = document.saveSync();
  /// document.dispose();
  /// ```
  PdfTextMarkupAnnotation(Rect bounds, String text, PdfColor color,
      {String? author,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      bool? setAppearance,
      List<Rect>? boundsCollection,
      List<PdfAnnotationFlags>? flags,
      PdfTextMarkupAnnotationType? textMarkupAnnotationType}) {
    _helper = PdfTextMarkupAnnotationHelper(
        this,
        bounds,
        text,
        color,
        author,
        subject,
        opacity,
        modifiedDate,
        setAppearance,
        flags,
        textMarkupAnnotationType);
    if (boundsCollection != null) {
      this.boundsCollection = boundsCollection;
    }
  }

  PdfTextMarkupAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfTextMarkupAnnotationHelper._(this, dictionary, crossTable);
  }

  // Fields
  late PdfTextMarkupAnnotationHelper _helper;

  // Properties
  /// Gets the text markup annotation bounds collection.
  List<Rect> get boundsCollection => _helper.boundsCollection;

  /// Sets the text markup annotation bounds collection.
  set boundsCollection(List<Rect> value) {
    _helper.boundsCollection = value;
  }

  /// Gets text markup annotation Type.
  PdfTextMarkupAnnotationType get textMarkupAnnotationType =>
      _helper.textMarkupAnnotationType;

  /// Sets text markup annotation Type.
  set textMarkupAnnotationType(PdfTextMarkupAnnotationType value) {
    _helper.textMarkupAnnotationType = value;
  }

  /// Gets the annotation color.
  PdfColor get color => _helper.color;

  /// Sets the annotation color.
  set color(PdfColor value) {
    _helper.color = value;
  }
}

/// [PdfTextMarkupAnnotation] helper
class PdfTextMarkupAnnotationHelper extends PdfAnnotationHelper {
  //Constructor
  /// internal constructor
  PdfTextMarkupAnnotationHelper(
      this.textMarkupAnnotation,
      Rect bounds,
      String text,
      PdfColor color,
      String? author,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      bool? setAppearance,
      List<PdfAnnotationFlags>? flags,
      PdfTextMarkupAnnotationType? textMarkupAnnotationType)
      : super(textMarkupAnnotation) {
    initializeAnnotation(
        bounds: bounds,
        text: text,
        color: color,
        author: author,
        subject: subject,
        modifiedDate: modifiedDate,
        opacity: opacity,
        flags: flags,
        setAppearance: setAppearance);
    this.textMarkupAnnotationType =
        textMarkupAnnotationType ?? PdfTextMarkupAnnotationType.highlight;
    dictionary!.setProperty(PdfDictionaryProperties.subtype,
        PdfName(getEnumName(this.textMarkupAnnotationType.toString())));
  }

  PdfTextMarkupAnnotationHelper._(this.textMarkupAnnotation,
      PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(textMarkupAnnotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  //Fields
  /// internal field
  late PdfTextMarkupAnnotation textMarkupAnnotation;
  List<Rect> _boundsCollection = <Rect>[];

  /// internal field
  PdfArray? points;

  /// internal field
  PdfTextMarkupAnnotationType? _textMarkupAnnotationType;

  /// internal method
  static PdfTextMarkupAnnotationHelper getHelper(
      PdfTextMarkupAnnotation annotation) {
    return annotation._helper;
  }

  /// internal method
  static PdfTextMarkupAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfTextMarkupAnnotation._(dictionary, crossTable);
  }

  //Properties
  /// Gets the text markup annotation bounds collection.
  List<Rect> get boundsCollection {
    if (isLoadedAnnotation) {
      _boundsCollection = _obtainBoundsValue();
    }
    return _boundsCollection;
  }

  /// Sets the text markup annotation bounds collection.
  set boundsCollection(List<Rect> value) {
    if (!isLoadedAnnotation) {
      if (_boundsCollection.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          _boundsCollection.add(value[i]);
        }
      } else {
        _boundsCollection = value;
      }
    } else {
      _boundsCollection = value;
      setQuadPoints(page!.size);
    }
  }

  /// Gets text markup annotation Type.
  PdfTextMarkupAnnotationType get textMarkupAnnotationType => isLoadedAnnotation
      ? _obtainTextMarkupAnnotationType()
      : _textMarkupAnnotationType!;

  /// Sets text markup annotation Type.
  set textMarkupAnnotationType(PdfTextMarkupAnnotationType value) {
    _textMarkupAnnotationType = value;
    if (isLoadedAnnotation) {
      dictionary![PdfDictionaryProperties.subtype] =
          PdfName(getEnumName(_textMarkupAnnotationType));
    }
  }

  //Implementation
  /// Internal method.
  void setQuadPoints(Size pageSize) {
    if (!isLoadedAnnotation) {
      final double pageHeight = pageSize.height;
      final PdfMargins margins = obtainMargin()!;
      if (bounds.width == 0 && bounds.height == 0) {
        bounds =
            Rect.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height);
      }
      if (_boundsCollection.isEmpty && !_boundsCollection.contains(bounds)) {
        _boundsCollection.add(bounds);
      }
      final int length = _boundsCollection.length * 8;
      final List<double> textQuadLocation = List<double>.filled(length, 0);
      final int noofRect = length ~/ 8;
      for (int i = 0; i < noofRect; i++) {
        final double locationX = _boundsCollection[i].left,
            locationY = _boundsCollection[i].top;
        textQuadLocation[0 + (i * 8)] = locationX + margins.left;
        textQuadLocation[1 + (i * 8)] = (pageHeight - locationY) - margins.top;
        textQuadLocation[2 + (i * 8)] =
            (locationX + _boundsCollection[i].width) + margins.left;
        textQuadLocation[3 + (i * 8)] = (pageHeight - locationY) - margins.top;
        textQuadLocation[4 + (i * 8)] = locationX + margins.left;
        textQuadLocation[5 + (i * 8)] =
            textQuadLocation[1 + (i * 8)] - _boundsCollection[i].height;
        textQuadLocation[6 + (i * 8)] =
            (locationX + _boundsCollection[i].width) + margins.left;
        textQuadLocation[7 + (i * 8)] = textQuadLocation[5 + (i * 8)];
      }
      points = PdfArray(textQuadLocation);
      dictionary!.setProperty(PdfDictionaryProperties.quadPoints, points);
    } else {
      final List<double> textQuadLocation =
          List<double>.filled(_boundsCollection.length * 8, 0);
      final double pageHeight = pageSize.height;
      for (int i = 0; i < _boundsCollection.length; i++) {
        final double locationX = _boundsCollection[i].left,
            locationY = _boundsCollection[i].top;
        textQuadLocation[0 + (i * 8)] = locationX;
        textQuadLocation[1 + (i * 8)] = pageHeight - locationY;
        textQuadLocation[2 + (i * 8)] = locationX + _boundsCollection[i].width;
        textQuadLocation[3 + (i * 8)] = pageHeight - locationY;
        textQuadLocation[4 + (i * 8)] = locationX;
        textQuadLocation[5 + (i * 8)] =
            textQuadLocation[1 + (i * 8)] - _boundsCollection[i].height;
        textQuadLocation[6 + (i * 8)] = locationX + _boundsCollection[i].width;
        textQuadLocation[7 + (i * 8)] = textQuadLocation[5 + (i * 8)];
      }
      dictionary!.setProperty(
          PdfDictionaryProperties.quadPoints, PdfArray(textQuadLocation));
    }
  }

  List<Rect> _obtainBoundsValue() {
    final List<Rect> collection = <Rect>[];
    if (dictionary!.containsKey(PdfDictionaryProperties.quadPoints)) {
      final IPdfPrimitive? points = PdfCrossTable.dereference(
          dictionary![PdfDictionaryProperties.quadPoints]);
      double x, y, width, height;
      if (points != null && points is PdfArray) {
        for (int i = 0; i < (points.count / 8).round(); i++) {
          x = ((points[4 + (i * 8)]! as PdfNumber).value! -
                  (points[0 + (i * 8)]! as PdfNumber).value!)
              .toDouble();
          y = ((points[5 + (i * 8)]! as PdfNumber).value! -
                  (points[1 + (i * 8)]! as PdfNumber).value!)
              .toDouble();
          height = sqrt((x * x) + (y * y));
          x = ((points[6 + (i * 8)]! as PdfNumber).value! -
                  (points[4 + (i * 8)]! as PdfNumber).value!)
              .toDouble();
          y = ((points[7 + (i * 8)]! as PdfNumber).value! -
                  (points[5 + (i * 8)]! as PdfNumber).value!)
              .toDouble();
          width = sqrt((x * x) + (y * y));
          final double m =
              (points[0 + (i * 8)]! as PdfNumber).value!.toDouble();
          final double n = page!.size.height -
              (points[1 + (i * 8)]! as PdfNumber).value!.toDouble();
          final Rect rect = Rect.fromLTWH(m, n, width, height);
          collection.add(rect);
        }
      }
    }
    return collection;
  }

  PdfTextMarkupAnnotationType _getTextMarkupAnnotation(String aType) {
    PdfTextMarkupAnnotationType annotType =
        PdfTextMarkupAnnotationType.highlight;
    switch (aType) {
      case 'Highlight':
        annotType = PdfTextMarkupAnnotationType.highlight;
        break;
      case 'Squiggly':
        annotType = PdfTextMarkupAnnotationType.squiggly;
        break;
      case 'StrikeOut':
        annotType = PdfTextMarkupAnnotationType.strikethrough;
        break;
      case 'Underline':
        annotType = PdfTextMarkupAnnotationType.underline;
        break;
    }
    return annotType;
  }

  /// internal method
  void save() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(textMarkupAnnotation);
    if (PdfAnnotationCollectionHelper.getHelper(
            textMarkupAnnotation.page!.annotations)
        .flatten) {
      helper.flatten = true;
    }
    if (!helper.isLoadedAnnotation) {
      final PdfArray textMarkupColor = PdfArray();
      if (!color.isEmpty) {
        final double red = color.r / 255;
        final double green = color.g / 255;
        final double blue = color.b / 255;
        if (textMarkupColor.elements.isEmpty) {
          textMarkupColor.add(PdfNumber(red));
          textMarkupColor.add(PdfNumber(green));
          textMarkupColor.add(PdfNumber(blue));
        } else {
          textMarkupColor.insert(0, PdfNumber(red));
          textMarkupColor.insert(1, PdfNumber(green));
          textMarkupColor.insert(2, PdfNumber(blue));
        }
        dictionary!.setProperty(PdfDictionaryProperties.c, textMarkupColor);
      } else {
        throw ArgumentError.value('TextMarkupColor is not null');
      }
    }
    if (helper.flatten || helper.setAppearance) {
      final PdfTemplate? appearance = _createAppearance();
      if (helper.flatten) {
        if (textMarkupAnnotation.page != null) {
          _flattenAnnotation(textMarkupAnnotation.page!, appearance);
        }
      } else {
        if (appearance != null) {
          textMarkupAnnotation.appearance.normal = appearance;
          dictionary!.setProperty(PdfDictionaryProperties.ap,
              PdfReferenceHolder(textMarkupAnnotation.appearance));
        }
      }
    }
    if (!helper.flatten && !helper.isLoadedAnnotation) {
      super.saveAnnotation();
      _saveTextMarkUpDictionary();
    }
    if (helper.flattenPopups) {
      helper.flattenPopup();
    }
  }

  String _getMarkupAnnotationType() {
    switch (textMarkupAnnotationType) {
      case PdfTextMarkupAnnotationType.highlight:
        return 'Highlight';
      case PdfTextMarkupAnnotationType.underline:
        return 'Underline';
      case PdfTextMarkupAnnotationType.squiggly:
        return 'Squiggly';
      case PdfTextMarkupAnnotationType.strikethrough:
        return 'StrikeOut';
    }
  }

  void _saveTextMarkUpDictionary() {
    dictionary!.setProperty(
        PdfDictionaryProperties.subtype, PdfName(_getMarkupAnnotationType()));
  }

  PdfTemplate? _createAppearance() {
    if (!isLoadedAnnotation || (isLoadedAnnotation && setAppearance)) {
      double x, y;
      double width = 0, height = 0;
      PdfRectangle? rectangle;
      if (boundsCollection.length > 1) {
        final PdfPath pdfPath = PdfPath();
        for (int i = 0; i < boundsCollection.length; i++) {
          pdfPath.addRectangle(boundsCollection[i]);
        }
        rectangle = PdfPathHelper.getHelper(pdfPath).getBoundsInternal();
        bounds = rectangle.rect;
        width = rectangle.width;
        height = rectangle.height;
      } else {
        if (dictionary!.containsKey(PdfDictionaryProperties.quadPoints)) {
          final IPdfPrimitive? mQuadPoints = PdfCrossTable.dereference(
              dictionary![PdfDictionaryProperties.quadPoints]);
          if (mQuadPoints != null && mQuadPoints is PdfArray) {
            for (int i = 0; i < (mQuadPoints.count / 8); i++) {
              if (isLoadedAnnotation) {
                final List<Offset> quadPoints =
                    List<Offset>.filled(mQuadPoints.count ~/ 2, Offset.zero);
                int j = 0;
                for (int k = 0; k < mQuadPoints.count;) {
                  final double x1 =
                      (mQuadPoints[k]! as PdfNumber).value!.toDouble();
                  final double y1 =
                      (mQuadPoints[k + 1]! as PdfNumber).value!.toDouble();
                  quadPoints[j] = Offset(x1, y1);
                  k = k + 2;
                  j++;
                }
                final PdfPath path = PdfPath();
                PdfPathHelper.getHelper(path).addLines(quadPoints);
                rectangle = PdfPathHelper.getHelper(path).getBoundsInternal();
                height = rectangle.height;
                width = rectangle.width;
              } else {
                x = ((mQuadPoints[4 + (i * 8)]! as PdfNumber).value! -
                        (mQuadPoints[0 + (i * 8)]! as PdfNumber).value!)
                    .toDouble();
                y = ((mQuadPoints[5 + (i * 8)]! as PdfNumber).value! -
                        (mQuadPoints[1 + (i * 8)]! as PdfNumber).value!)
                    .toDouble();
                height = sqrt((x * x) + (y * y));
                x = ((mQuadPoints[6 + (i * 8)]! as PdfNumber).value! -
                        (mQuadPoints[4 + (i * 8)]! as PdfNumber).value!)
                    .toDouble();
                y = ((mQuadPoints[7 + (i * 8)]! as PdfNumber).value! -
                        (mQuadPoints[5 + (i * 8)]! as PdfNumber).value!)
                    .toDouble();
                width = sqrt((x * x) + (y * y));
                bounds = Rect.fromLTWH(bounds.left, bounds.top, width, height);
              }
            }
          }
        }
      }
      final PdfTemplate template = PdfTemplate(width, height);
      PdfAnnotationHelper.setMatrixToZeroRotation(
          PdfTemplateHelper.getHelper(template).content);
      final PdfGraphics graphics = template.graphics!;
      graphics.setTransparency(opacity, mode: PdfBlendMode.multiply);
      if (boundsCollection.length > 1) {
        for (int i = 0; i < boundsCollection.length; i++) {
          if (textMarkupAnnotationType ==
              PdfTextMarkupAnnotationType.highlight) {
            graphics.drawRectangle(
                brush: PdfSolidBrush(color),
                bounds: Rect.fromLTWH(
                    boundsCollection[i].left - rectangle!.x,
                    boundsCollection[i].top - rectangle.y,
                    boundsCollection[i].width,
                    boundsCollection[i].height));
          } else if (textMarkupAnnotationType ==
              PdfTextMarkupAnnotationType.underline) {
            graphics.drawLine(
                PdfPen(color, width: boundsCollection[i].height * 0.05),
                Offset(
                    boundsCollection[i].left - rectangle!.x,
                    (boundsCollection[i].top - rectangle.y) +
                        (boundsCollection[i].height -
                            ((boundsCollection[i].height / 2) / 3))),
                Offset(
                    boundsCollection[i].width +
                        (boundsCollection[i].left - rectangle.x),
                    (boundsCollection[i].top - rectangle.y) +
                        (boundsCollection[i].height -
                            ((boundsCollection[i].height / 2) / 3))));
          } else if (textMarkupAnnotationType ==
              PdfTextMarkupAnnotationType.strikethrough) {
            graphics.drawLine(
                PdfPen(color, width: boundsCollection[i].height * 0.05),
                Offset(
                    boundsCollection[i].left - rectangle!.x,
                    (boundsCollection[i].top - rectangle.y) +
                        (boundsCollection[i].height -
                            (boundsCollection[i].height / 2))),
                Offset(
                    boundsCollection[i].width +
                        (boundsCollection[i].left - rectangle.x),
                    (boundsCollection[i].top - rectangle.y) +
                        (boundsCollection[i].height -
                            (boundsCollection[i].height / 2))));
          } else if (textMarkupAnnotationType ==
              PdfTextMarkupAnnotationType.squiggly) {
            final PdfPen pdfPen =
                PdfPen(color, width: boundsCollection[i].height * 0.02);
            graphics.save();
            graphics.translateTransform(boundsCollection[i].left - rectangle!.x,
                boundsCollection[i].top - rectangle.y);
            graphics.setClip(
                bounds: Rect.fromLTWH(0, 0, boundsCollection[i].width,
                    boundsCollection[i].height));
            graphics.drawPath(
                _drawSquiggly(
                    boundsCollection[i].width, boundsCollection[i].height),
                pen: pdfPen);
            graphics.restore();
          }
        }
      } else {
        if (textMarkupAnnotationType == PdfTextMarkupAnnotationType.highlight) {
          graphics.drawRectangle(
              brush: PdfSolidBrush(color),
              bounds: Rect.fromLTWH(0, 0, width, height));
        } else if (textMarkupAnnotationType ==
            PdfTextMarkupAnnotationType.underline) {
          graphics.drawLine(
              PdfPen(color, width: height * 0.05),
              Offset(0, height - ((height / 2) / 3)),
              Offset(width, height - ((height / 2) / 3)));
        } else if (textMarkupAnnotationType ==
            PdfTextMarkupAnnotationType.strikethrough) {
          graphics.drawLine(PdfPen(color, width: height * 0.05),
              Offset(0, height / 2), Offset(width, height / 2));
        } else if (textMarkupAnnotationType ==
            PdfTextMarkupAnnotationType.squiggly) {
          final PdfPen pdfPen = PdfPen(color, width: height * 0.02);
          graphics.drawPath(_drawSquiggly(width, height), pen: pdfPen);
        }
        if (isLoadedAnnotation) {
          dictionary![PdfDictionaryProperties.rect] =
              PdfArray.fromRectangle(rectangle!);
        }
      }
      return template;
    }
    return null;
  }

  PdfPath _drawSquiggly(double width, double height) {
    if (width.toInt() % 2 != 0 || width.round() > width) {
      width = width + 1;
    }
    final PdfPath path = PdfPath();
    final List<Offset> mPathPoints =
        List<Offset>.filled(((width / height) * 16).ceil(), Offset.zero);
    final double length = width / (mPathPoints.length / 2);
    final double location = (length + length) * 0.6;
    double zigZag = location;
    double x = 0;
    for (int i = 0; i < mPathPoints.length; i++, x += length) {
      mPathPoints[i] =
          Offset(x, ((height - location) + zigZag) - (height * 0.02));
      if (zigZag == 0) {
        zigZag = location;
      } else {
        zigZag = 0;
      }
    }
    PdfPathHelper.getHelper(path).addLines(mPathPoints);
    return path;
  }

  void _flattenAnnotation(PdfPage page, PdfTemplate? appearance) {
    if (!isLoadedAnnotation) {
      if (appearance != null) {
        page.graphics.save();
        final Rect rectangle =
            calculateTemplateBounds(bounds, page, appearance, true);
        if (opacity < 1) {
          page.graphics.setTransparency(opacity);
        }
        page.graphics.drawPdfTemplate(
            appearance, Offset(rectangle.left, rectangle.top), rectangle.size);
        page.annotations.remove(textMarkupAnnotation);
        page.graphics.restore();
      }
    } else {
      if (dictionary != null &&
          dictionary!.containsKey(PdfDictionaryProperties.ap) &&
          appearance == null) {
        IPdfPrimitive? appearanceDictionary =
            PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.ap]);
        if (appearanceDictionary != null &&
            appearanceDictionary is PdfDictionary) {
          appearanceDictionary = PdfCrossTable.dereference(
              appearanceDictionary[PdfDictionaryProperties.n]);
          if (appearanceDictionary != null &&
              appearanceDictionary is PdfStream) {
            appearance = PdfTemplateHelper.fromPdfStream(appearanceDictionary);
            final bool isNormalMatrix =
                validateTemplateMatrix(appearanceDictionary);
            if (isNormalMatrix &&
                page.rotation != PdfPageRotateAngle.rotateAngle0) {
              flattenAnnotationTemplate(appearance, isNormalMatrix);
            } else if (isNormalMatrix &&
                isValidTemplateMatrix(
                    appearanceDictionary, bounds.topLeft, appearance)) {
              flattenAnnotationTemplate(appearance, isNormalMatrix);
            }
          } else {
            setAppearance = true;
            appearance = _createAppearance();
            if (appearance != null) {
              final bool isNormalMatrix = validateTemplateMatrix(
                  PdfTemplateHelper.getHelper(appearance).content);
              flattenAnnotationTemplate(appearance, isNormalMatrix);
            }
          }
        }
      } else if (!dictionary!.containsKey(PdfDictionaryProperties.ap) &&
          appearance == null) {
        setAppearance = true;
        appearance = _createAppearance();
        if (appearance != null) {
          final bool isNormalMatrix = validateTemplateMatrix(
              PdfTemplateHelper.getHelper(appearance).content);
          flattenAnnotationTemplate(appearance, isNormalMatrix);
        }
      } else if (!dictionary!.containsKey(PdfDictionaryProperties.ap) &&
          appearance != null) {
        final bool isNormalMatrix = validateTemplateMatrix(
            PdfTemplateHelper.getHelper(appearance).content);
        flattenAnnotationTemplate(appearance, isNormalMatrix);
      } else if (dictionary!.containsKey(PdfDictionaryProperties.ap) &&
          appearance != null) {
        final bool isNormalMatrix = validateTemplateMatrix(
            PdfTemplateHelper.getHelper(appearance).content);
        flattenAnnotationTemplate(appearance, isNormalMatrix);
      }
    }
  }

  PdfTextMarkupAnnotationType _obtainTextMarkupAnnotationType() {
    final IPdfPrimitive? annotType =
        PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.subtype]);
    if (annotType != null && annotType is PdfName) {
      final String aType = annotType.name.toString();
      return _getTextMarkupAnnotation(aType);
    }
    return PdfTextMarkupAnnotationType.highlight;
  }

  /// internal method
  @override
  IPdfPrimitive? get element => dictionary;
  @override
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }
}
