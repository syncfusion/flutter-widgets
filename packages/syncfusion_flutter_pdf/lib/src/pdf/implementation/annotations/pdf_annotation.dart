import 'dart:math';
import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_brush.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_path.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_margins.dart';
import '../graphics/pdf_pen.dart';
import '../graphics/pdf_pens.dart';
import '../graphics/pdf_transformation_matrix.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_section.dart';
import '../pages/pdf_section_collection.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_catalog.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_action_annotation.dart';
import 'pdf_annotation_border.dart';
import 'pdf_appearance.dart';
import 'pdf_document_link_annotation.dart';
import 'pdf_ellipse_annotation.dart';
import 'pdf_line_annotation.dart';
import 'pdf_polygon_annotation.dart';
import 'pdf_popup_annotation.dart';
import 'pdf_rectangle_annotation.dart';
import 'pdf_text_markup_annotation.dart';
import 'pdf_text_web_link.dart';
import 'widget_annotation.dart';

/// Represents the base class for annotation objects.
abstract class PdfAnnotation implements IPdfWrapper {
  // fields
  late PdfAnnotationHelper _helper;

  /// Set whether the annotation requires an appearance.
  bool get setAppearance => _helper.setAppearance;
  set setAppearance(bool value) {
    _helper.setAppearance = value;
  }

  // properties
  /// Gets a page of the annotation. Read-Only.
  PdfPage? get page => _helper.page;

  /// Gets annotation's bounds in the PDF page.
  Rect get bounds {
    return _helper.bounds;
  }

  /// Sets annotation's bounds in the PDF page.
  set bounds(Rect value) {
    _helper.bounds = value;
  }

  /// Gets content of the annotation.
  /// The string value specifies the text of the annotation.
  String get text {
    return _helper.text;
  }

  /// Sets content of the annotation.
  /// The string value specifies the text of the annotation.
  set text(String value) {
    _helper.text = value;
  }

  /// Gets the author of the annotation.
  String get author => _helper.author;

  /// Sets the author of the annotation.
  set author(String value) {
    _helper.author = value;
  }

  /// Gets the subject of the annotation.
  String get subject => _helper.subject;

  /// Sets the subject of the annotation.
  set subject(String value) {
    _helper.subject = value;
  }

  /// Gets the ModifiedDate of the annotation.
  DateTime? get modifiedDate => _helper.modifiedDate;

  /// Sets the ModifiedDate of the annotation.
  set modifiedDate(DateTime? value) {
    _helper.modifiedDate = value;
  }

  /// Gets the opacity of the annotation.
  double get opacity => _helper.opacity;

  /// Sets the opacity of the annotation.
  ///
  /// Opacity value should be between 0 to 1.
  set opacity(double value) {
    _helper.opacity = value;
  }

  /// Gets appearance of the annotation.
  PdfAppearance get appearance {
    _helper.appearance ??= PdfAppearance(this);
    return _helper.appearance!;
  }

  /// Sets appearance of the annotation.
  set appearance(PdfAppearance value) {
    _helper.appearance = value;
  }

  /// Gets or sets the annotation flags.
  List<PdfAnnotationFlags> get annotationFlags => _helper.annotationFlags;
  set annotationFlags(List<PdfAnnotationFlags> value) {
    _helper.annotationFlags = value;
  }

  //Public methods
  /// Flatten the annotation.
  ///
  /// The flatten will add at the time of saving the current document.
  void flatten() {
    _helper.flatten = true;
  }
}

/// [PdfAnnotation] helper
class PdfAnnotationHelper {
  /// internal constructor
  PdfAnnotationHelper(this.base);

  /// internal field
  PdfAnnotation base;

  /// internal method
  static PdfAnnotationHelper getHelper(PdfAnnotation base) {
    return base._helper;
  }

  /// internal method
  /// Initialize [PdfAnnotation] object
  void initializeAnnotation(
      {PdfPage? page,
      String? text,
      Rect? bounds,
      PdfAnnotationBorder? border,
      PdfColor? color,
      PdfColor? innerColor,
      String? author,
      double? opacity,
      String? subject,
      DateTime? modifiedDate,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance}) {
    base._helper = this;
    initializeAnnotationProperties(
        page,
        text,
        bounds,
        border,
        color,
        innerColor,
        author,
        opacity,
        subject,
        modifiedDate,
        flags,
        setAppearance);
  }

  /// internal method
  /// Initialize [PdfAnnotation] object
  void initializeExistingAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    base._helper = this;
    this.dictionary = dictionary;
    this.crossTable = crossTable;
    isLoadedAnnotation = true;
    PdfName? name;
    if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
      name = dictionary.items![PdfName(PdfDictionaryProperties.subtype)]
          as PdfName?;
    }
    if (name != null) {
      if (name.name == PdfDictionaryProperties.circle ||
          name.name == PdfDictionaryProperties.square ||
          name.name == PdfDictionaryProperties.line ||
          name.name == PdfDictionaryProperties.polygon ||
          name.name == PdfDictionaryProperties.highlight ||
          name.name == PdfDictionaryProperties.underline ||
          name.name == PdfDictionaryProperties.squiggly ||
          name.name == PdfDictionaryProperties.strikeOut ||
          name.name == PdfDictionaryProperties.text) {
        PdfDocumentHelper.getHelper(crossTable.document!).catalog.beginSave =
            dictionaryBeginSave;
        PdfDocumentHelper.getHelper(crossTable.document!).catalog.modify();
      }
    }
  }

  /// internal field
  PdfPage? page;

  /// internal field
  String? textValue = '';

  /// internal field
  PdfRectangle rectangle = PdfRectangle.empty;

  /// internal field
  PdfColor? annotationInnerColor;

  /// internal field
  PdfAnnotationBorder? annotationBorder;

  /// internal field
  bool isLoadedAnnotation = false;

  /// internal field
  PdfColor annotationColor = PdfColor.empty;

  /// internal field
  PdfMargins? margins = PdfMargins();

  /// internal field
  String? annotationAuthor = '';

  /// internal field
  String? annotationSubject = '';

  /// internal field
  DateTime? annotationModifiedDate;

  /// internal field
  double annotationOpacity = 1.0;

  /// internal field
  PdfAppearance? appearance;

  /// internal field
  bool saved = false;

  /// internal field
  bool isBounds = false;

  /// internal field
  PdfCrossTable? cTable;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  bool setAppearance = false;

  /// internal field
  bool isOldAnnotation = false;

  /// internal field
  List<PdfAnnotationFlags>? flag;

  ///Gets or sets the boolean flag to flatten the annotation,
  ///by default, its become false.
  bool flatten = false;

  /// Gets or sets flatten annotations popup.
  // ignore: prefer_final_fields
  bool flattenPopups = false;

  /// internal property
  PdfCrossTable get crossTable => cTable!;
  set crossTable(PdfCrossTable value) {
    if (value != cTable) {
      cTable = value;
    }
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// Gets annotation's bounds in the PDF page.
  Rect get bounds {
    if (!isLoadedAnnotation) {
      return rectangle.rect;
    } else {
      final PdfRectangle rect = _getBounds(dictionary!, crossTable);
      rect.y = page != null
          ? rect.y == 0 && rect.height == 0
              ? rect.y + rect.height
              : page!.size.height - (rect.y + rect.height)
          : rect.y - rect.height;
      return rect.rect;
    }
  }

  /// Sets annotation's bounds in the PDF page.
  set bounds(Rect value) {
    if (!isLoadedAnnotation) {
      final PdfRectangle rect = PdfRectangle.fromRect(value);
      if (rectangle != rect) {
        rectangle = rect;
        dictionary!.setProperty(PdfName(PdfDictionaryProperties.rect),
            PdfArray.fromRectangle(rect));
      }
    } else {
      isBounds = true;
      if (value == Rect.zero) {
        throw ArgumentError('rectangle');
      }
      final double height = page!.size.height;
      final List<PdfNumber> values = <PdfNumber>[
        PdfNumber(value.left),
        PdfNumber(height - (value.top + value.height)),
        PdfNumber(value.left + value.width),
        PdfNumber(height - value.top)
      ];
      final PdfDictionary dic = dictionary!;
      dic.setArray(PdfDictionaryProperties.rect, values);
    }
  }

  /// Gets annotation's border properties like width, horizontal radius etc.
  PdfAnnotationBorder get border {
    if (!isLoadedAnnotation) {
      annotationBorder ??= PdfAnnotationBorder();
    } else {
      annotationBorder ??= _obtainBorder();
      if (!isLineBorder()) {
        dictionary!
            .setProperty(PdfDictionaryProperties.border, annotationBorder);
      }
    }
    PdfAnnotationBorderHelper.getHelper(annotationBorder!).isLineBorder =
        isLineBorder();
    return annotationBorder!;
  }

  /// Sets annotation's border properties like width, horizontal radius etc.
  set border(PdfAnnotationBorder value) {
    annotationBorder = value;
    if (isLineBorder()) {
      dictionary!.setProperty(PdfName(PdfDictionaryProperties.bs), border);
    } else {
      dictionary!.setProperty(
          PdfName(PdfDictionaryProperties.border), annotationBorder);
    }
  }

  /// Gets content of the annotation.
  /// The string value specifies the text of the annotation.
  String get text {
    if (!isLoadedAnnotation) {
      if (dictionary!.containsKey(PdfDictionaryProperties.contents)) {
        textValue =
            (dictionary![PdfDictionaryProperties.contents]! as PdfString).value;
      }
      return textValue!;
    } else {
      return textValue == null || textValue!.isEmpty
          ? _obtainText()!
          : textValue!;
    }
  }

  /// Sets content of the annotation.
  /// The string value specifies the text of the annotation.
  set text(String value) {
    if (textValue != value) {
      textValue = value;
      dictionary!.setString(PdfDictionaryProperties.contents, textValue);
    }
  }

  /// Gets the annotation color.
  PdfColor get color => isLoadedAnnotation ? _obtainColor() : annotationColor;

  /// Sets the annotation color.
  set color(PdfColor value) {
    if (annotationColor != value) {
      annotationColor = value;
      PdfColorSpace? cs = PdfColorSpace.rgb;
      if (page != null && !PdfPageHelper.getHelper(page!).isLoadedPage) {
        cs = PdfSectionCollectionHelper.getHelper(PdfSectionHelper.getHelper(
                    PdfPageHelper.getHelper(page!).section!)
                .parent!)
            .document!
            .colorSpace;
      }
      final PdfArray colours = PdfColorHelper.toArray(annotationColor, cs);
      dictionary!.setProperty(PdfDictionaryProperties.c, colours);
    }
  }

  /// Gets the inner color of the annotation.
  PdfColor get innerColor {
    if (!isLoadedAnnotation) {
      annotationInnerColor ??= PdfColor(0, 0, 0, 0);
    } else {
      annotationInnerColor = _obtainInnerColor();
    }
    return annotationInnerColor!;
  }

  /// Sets the inner color of the annotation.
  set innerColor(PdfColor value) {
    annotationInnerColor = value;
    if (isLoadedAnnotation) {
      if (PdfColorHelper.getHelper(annotationInnerColor!).alpha != 0) {
        dictionary!.setProperty(PdfDictionaryProperties.iC,
            PdfColorHelper.toArray(annotationInnerColor!));
      } else if (dictionary!.containsKey(PdfDictionaryProperties.iC)) {
        dictionary!.remove(PdfDictionaryProperties.iC);
      }
    }
  }

  /// Gets the author of the annotation.
  String get author {
    if (!isLoadedAnnotation) {
      if (dictionary!.containsKey(PdfDictionaryProperties.author)) {
        annotationAuthor =
            (dictionary![PdfDictionaryProperties.author]! as PdfString).value;
      } else if (dictionary!.containsKey(PdfDictionaryProperties.t)) {
        annotationAuthor =
            (dictionary![PdfDictionaryProperties.t]! as PdfString).value;
      }
    } else {
      annotationAuthor = _obtainAuthor();
    }
    return annotationAuthor!;
  }

  /// Sets the author of the annotation.
  set author(String value) {
    if (annotationAuthor != value) {
      annotationAuthor = value;
      dictionary!.setString(PdfDictionaryProperties.t, annotationAuthor);
    }
  }

  /// Gets the subject of the annotation.
  String get subject {
    if (isLoadedAnnotation) {
      annotationSubject = _obtainSubject();
    } else {
      if (dictionary!.containsKey(PdfDictionaryProperties.subject)) {
        annotationSubject =
            (dictionary![PdfDictionaryProperties.subject]! as PdfString).value;
      } else if (dictionary!.containsKey(PdfDictionaryProperties.subj)) {
        annotationSubject =
            (dictionary![PdfDictionaryProperties.subj]! as PdfString).value;
      }
    }
    return annotationSubject!;
  }

  /// Sets the subject of the annotation.
  set subject(String value) {
    if (subject != value) {
      annotationSubject = value;
      dictionary!.setString(PdfDictionaryProperties.subj, annotationSubject);
    }
  }

  /// Gets the ModifiedDate of the annotation.
  DateTime? get modifiedDate =>
      isLoadedAnnotation ? _obtainModifiedDate() : annotationModifiedDate;

  /// Sets the ModifiedDate of the annotation.
  set modifiedDate(DateTime? value) {
    if (annotationModifiedDate != value) {
      annotationModifiedDate = value;
      dictionary!
          .setDateTime(PdfDictionaryProperties.m, annotationModifiedDate!);
    }
  }

  /// Gets the opacity of the annotation.
  double get opacity {
    if (isLoadedAnnotation) {
      return _obtainOpacity()!;
    }
    if (dictionary!.items!.containsKey(PdfName('CA'))) {
      final PdfNumber ca = dictionary!.items![PdfName('CA')]! as PdfNumber;
      annotationOpacity = ca.value!.toDouble();
    }
    return annotationOpacity;
  }

  /// Sets the opacity of the annotation.
  ///
  /// Opacity value should be between 0 to 1.
  set opacity(double value) {
    if (value < 0 || value > 1) {
      throw ArgumentError.value('Valid value should be between 0 to 1.');
    }
    if (annotationOpacity != value) {
      annotationOpacity = value;
      dictionary!.setProperty(
          PdfDictionaryProperties.ca, PdfNumber(annotationOpacity));
    }
  }

  /// Sets the annotation flags.
  set annotationFlags(List<PdfAnnotationFlags> value) {
    flag = value;
  }

  /// Gets the annotation flags.
  List<PdfAnnotationFlags> get annotationFlags {
    if (isLoadedAnnotation && flag == null) {
      flag ??= obtainAnnotationFlags(getFlagValue());
    }
    return flag ??= <PdfAnnotationFlags>[];
  }

  /// internal method
  bool isLineBorder() {
    if (base is PdfRectangleAnnotation ||
        base is PdfPolygonAnnotation ||
        base is PdfEllipseAnnotation ||
        base is PdfLineAnnotation) {
      return true;
    } else {
      return false;
    }
  }

  /// internal method
  void initializeAnnotationProperties(
      PdfPage? page,
      String? annotText,
      Rect? bounds,
      PdfAnnotationBorder? border,
      PdfColor? color,
      PdfColor? innerColor,
      String? author,
      double? opacity,
      String? subject,
      DateTime? modifiedDate,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance) {
    dictionary!.beginSave = dictionaryBeginSave;
    dictionary!.setProperty(PdfName(PdfDictionaryProperties.type),
        PdfName(PdfDictionaryProperties.annot));
    if (page != null) {
      this.page = page;
    }
    if (bounds != null) {
      this.bounds = bounds;
    }
    if (annotText != null) {
      text = annotText;
      dictionary!.setProperty(
          PdfName(PdfDictionaryProperties.contents), PdfString(text));
    }
    if (border != null) {
      this.border = border;
    }
    if (color != null) {
      this.color = color;
    }
    if (innerColor != null) {
      this.innerColor = innerColor;
    }
    if (author != null) {
      this.author = author;
    }
    if (opacity != null) {
      this.opacity = opacity;
    }
    if (subject != null) {
      this.subject = subject;
    }
    if (modifiedDate != null) {
      this.modifiedDate = modifiedDate;
    }
    if (setAppearance != null) {
      this.setAppearance = setAppearance;
    }
    if (flags != null) {
      annotationFlags = flags;
    }
  }

  /// internal method
  void dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (_isContainsAnnotation()) {
      if (!saved) {
        PdfAnnotationHelper.save(base);
        saved = true;
      }
    }
  }

  bool _isContainsAnnotation() {
    bool contains = false;
    PdfArray? annotation;
    if (page != null &&
        PdfPageHelper.getHelper(page!)
            .dictionary!
            .containsKey(PdfDictionaryProperties.annots)) {
      annotation = PdfCrossTable.dereference(PdfPageHelper.getHelper(page!)
          .dictionary![PdfDictionaryProperties.annots]) as PdfArray?;
      if (annotation != null &&
          annotation.elements.isNotEmpty &&
          annotation.contains(annotation.elements[0]!)) {
        contains = true;
      }
    }
    return contains;
  }

  /// internal method
  void saveAnnotation() {
    final PdfDocument? document = PdfPageHelper.getHelper(page!).document;
    if (document != null &&
        PdfDocumentHelper.getHelper(document).conformanceLevel !=
            PdfConformanceLevel.none) {
      if (base is PdfActionAnnotation &&
          PdfDocumentHelper.getHelper(document).conformanceLevel ==
              PdfConformanceLevel.a1b) {
        throw ArgumentError(
            'The specified annotation type is not supported by PDF/A1-B or PDF/A1-A standard documents.');
      }
      //This is needed to attain specific PDF/A conformance.
      if (base is! PdfLinkAnnotation &&
          !setAppearance &&
          (PdfDocumentHelper.getHelper(document).conformanceLevel ==
                  PdfConformanceLevel.a2b ||
              PdfDocumentHelper.getHelper(document).conformanceLevel ==
                  PdfConformanceLevel.a3b)) {
        throw ArgumentError(
            "The appearance dictionary doesn't contain an entry. Enable setAppearance in PdfAnnotation class to overcome this error.");
      }
      dictionary!.setNumber(PdfDictionaryProperties.f, 4);
    }
    if (annotationBorder != null) {
      if (isLineBorder()) {
        dictionary!.setProperty(PdfDictionaryProperties.bs, border);
      } else {
        dictionary!
            .setProperty(PdfName(PdfDictionaryProperties.border), border);
      }
    }
    if ((base is! PdfLinkAnnotation && base is! PdfTextWebLink) ||
        ((base is PdfLinkAnnotation || base is PdfTextWebLink) &&
            !isLoadedAnnotation)) {
      final PdfRectangle nativeRectangle = _obtainNativeRectangle();
      if (annotationInnerColor != null &&
          !annotationInnerColor!.isEmpty &&
          PdfColorHelper.getHelper(annotationInnerColor!).alpha != 0.0) {
        dictionary!.setProperty(PdfName(PdfDictionaryProperties.ic),
            PdfColorHelper.toArray(annotationInnerColor!));
      }
      dictionary!.setProperty(PdfName(PdfDictionaryProperties.rect),
          PdfArray.fromRectangle(nativeRectangle));
    }
  }

  PdfRectangle _obtainNativeRectangle() {
    final PdfRectangle nativeRectangle =
        PdfRectangle(bounds.left, bounds.bottom, bounds.width, bounds.height);
    Size? size;
    PdfArray? cropOrMediaBox;
    if (page != null) {
      if (!PdfPageHelper.getHelper(page!).isLoadedPage) {
        final PdfSection section = PdfPageHelper.getHelper(page!).section!;
        nativeRectangle.location = PdfSectionHelper.getHelper(section)
            .pointToNativePdf(page!, nativeRectangle.location);
      } else {
        size = page!.size;
        nativeRectangle.y = size.height - rectangle.bottom;
      }
      cropOrMediaBox = _getCropOrMediaBox(page!, cropOrMediaBox);
    }
    if (cropOrMediaBox != null) {
      if (cropOrMediaBox.count > 2) {
        if ((cropOrMediaBox[0]! as PdfNumber).value != 0 ||
            (cropOrMediaBox[1]! as PdfNumber).value != 0) {
          nativeRectangle.x = nativeRectangle.x +
              (cropOrMediaBox[0]! as PdfNumber).value!.toDouble();
          nativeRectangle.y = nativeRectangle.y +
              (cropOrMediaBox[1]! as PdfNumber).value!.toDouble();
        }
      }
    }
    return nativeRectangle;
  }

  PdfArray? _getCropOrMediaBox(PdfPage page, PdfArray? cropOrMediaBox) {
    final PdfDictionary dictionary = PdfPageHelper.getHelper(page).dictionary!;
    if (dictionary.containsKey(PdfDictionaryProperties.cropBox)) {
      cropOrMediaBox =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.cropBox])
              as PdfArray?;
    } else if (dictionary.containsKey(PdfDictionaryProperties.mediaBox)) {
      cropOrMediaBox = PdfCrossTable.dereference(
          dictionary[PdfDictionaryProperties.mediaBox]) as PdfArray?;
    }
    return cropOrMediaBox;
  }

  /// internal method
  void setPage(PdfPage pdfPage) {
    page = pdfPage;
    final PdfDocument? document = PdfPageHelper.getHelper(page!).document;
    if (!PdfPageHelper.getHelper(pdfPage).isLoadedPage) {
      if (document != null) {
        final PdfCatalog catalog =
            PdfDocumentHelper.getHelper(document).catalog;
        catalog.beginSaveList ??= <SavePdfPrimitiveCallback>[];
        final PdfGraphics graphics =
            pdfPage.graphics; //Accessed for creating page content.
        ArgumentError.checkNotNull(graphics);
        if (dictionary!.containsKey(PdfDictionaryProperties.subtype)) {
          final PdfName? name = dictionary!
              .items![PdfName(PdfDictionaryProperties.subtype)] as PdfName?;
          if (name != null) {
            if (name.name == PdfDictionaryProperties.text ||
                name.name == PdfDictionaryProperties.square ||
                name.name == PdfDictionaryProperties.highlight ||
                name.name == PdfDictionaryProperties.squiggly ||
                name.name == PdfDictionaryProperties.underline ||
                name.name == PdfDictionaryProperties.strikeOut ||
                flatten) {
              catalog.beginSaveList!.add(dictionaryBeginSave);
              catalog.modify();
            }
          }
        } else if (flatten) {
          catalog.beginSaveList!.add(dictionaryBeginSave);
          catalog.modify();
        }
      }
    } else {
      if (document != null) {
        final PdfCatalog catalog =
            PdfDocumentHelper.getHelper(document).catalog;
        if (dictionary!.containsKey(PdfDictionaryProperties.subtype)) {
          final PdfName? name = dictionary!
              .items![PdfName(PdfDictionaryProperties.subtype)] as PdfName?;
          catalog.beginSaveList ??= <SavePdfPrimitiveCallback>[];
          if (name != null) {
            if (name.name == PdfDictionaryProperties.circle ||
                name.name == PdfDictionaryProperties.square ||
                name.name == PdfDictionaryProperties.line ||
                name.name == PdfDictionaryProperties.polygon ||
                name.name == PdfDictionaryProperties.highlight ||
                name.name == PdfDictionaryProperties.squiggly ||
                name.name == PdfDictionaryProperties.underline ||
                name.name == PdfDictionaryProperties.strikeOut ||
                name.name == PdfDictionaryProperties.text ||
                name.name == PdfDictionaryProperties.link) {
              catalog.beginSaveList!.add(dictionaryBeginSave);
              catalog.modify();
            }
          }
        } else if (flatten) {
          catalog.beginSaveList!.add(dictionaryBeginSave);
          catalog.modify();
        }
      }
    }
    if (page != null && !PdfPageHelper.getHelper(page!).isLoadedPage) {
      dictionary!.setProperty(
          PdfName(PdfDictionaryProperties.p), PdfReferenceHolder(page));
    }
  }

  /// Gets the bounds.
  PdfRectangle _getBounds(PdfDictionary dictionary, PdfCrossTable crossTable) {
    PdfArray? array;
    if (dictionary.containsKey(PdfDictionaryProperties.rect)) {
      array = crossTable.getObject(dictionary[PdfDictionaryProperties.rect])
          as PdfArray?;
    }
    return array!.toRectangle();
  }

  // Gets the border.
  PdfAnnotationBorder _obtainBorder() {
    final PdfAnnotationBorder border = PdfAnnotationBorder();
    if (dictionary!.containsKey(PdfDictionaryProperties.border)) {
      final PdfArray? borderArray =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.border])
              as PdfArray?;
      if (borderArray != null && borderArray.count >= 2) {
        if (borderArray[0] is PdfNumber &&
            borderArray[1] is PdfNumber &&
            borderArray[2] is PdfNumber) {
          final double width = (borderArray[0]! as PdfNumber).value!.toDouble();
          final double hRadius =
              (borderArray[1]! as PdfNumber).value!.toDouble();
          final double vRadius =
              (borderArray[2]! as PdfNumber).value!.toDouble();
          border.width = vRadius;
          border.horizontalRadius = width;
          border.verticalRadius = hRadius;
        }
      }
    } else if (dictionary!.containsKey(PdfDictionaryProperties.bs)) {
      final PdfDictionary lbDic = crossTable
          .getObject(dictionary![PdfDictionaryProperties.bs])! as PdfDictionary;
      if (lbDic.containsKey(PdfDictionaryProperties.w)) {
        final PdfNumber? value = lbDic[PdfDictionaryProperties.w] as PdfNumber?;
        if (value != null) {
          border.width = value.value!.toDouble();
        }
      }
      if (lbDic.containsKey(PdfDictionaryProperties.s)) {
        final PdfName bstr =
            PdfCrossTable.dereference(lbDic[PdfDictionaryProperties.s])!
                as PdfName;
        border.borderStyle = _getBorderStyle(bstr.name.toString());
      }
      if (lbDic.containsKey(PdfDictionaryProperties.d)) {
        final PdfArray? dasharray =
            PdfCrossTable.dereference(lbDic[PdfDictionaryProperties.d])
                as PdfArray?;
        if (dasharray != null) {
          final PdfNumber dashArray = dasharray[0]! as PdfNumber;
          final int dashArrayValue = dashArray.value!.toInt();
          dasharray.clear();
          dasharray.insert(0, PdfNumber(dashArrayValue));
          dasharray.insert(1, PdfNumber(dashArrayValue));
          border.dashArray = dashArrayValue;
        }
      }
    }
    return border;
  }

  // Gets the text.
  String? _obtainText() {
    String tempText;
    if (dictionary!.containsKey(PdfDictionaryProperties.contents)) {
      final PdfString? mText = PdfCrossTable.dereference(
          dictionary![PdfDictionaryProperties.contents]) as PdfString?;
      if (mText != null) {
        textValue = mText.value.toString();
      }
      return textValue;
    } else {
      tempText = '';
      return tempText;
    }
  }

  // Gets the color.
  PdfColor _obtainColor() {
    PdfColor color = PdfColor.empty;
    PdfArray? colours;
    if (dictionary!.containsKey(PdfDictionaryProperties.c)) {
      colours = dictionary![PdfDictionaryProperties.c] as PdfArray?;
    }
    if (colours != null && colours.elements.length == 1) {
      //Convert the float color values into bytes
      final PdfNumber? color0 = crossTable.getObject(colours[0]) as PdfNumber?;
      if (color0 != null) {
        color = PdfColorHelper.fromGray(color0.value! as double);
      }
    } else if (colours != null && colours.elements.length == 3) {
      final PdfNumber color0 = colours[0]! as PdfNumber;
      final PdfNumber color1 = colours[1]! as PdfNumber;
      final PdfNumber color2 = colours[2]! as PdfNumber;
      //Convert the float color values into bytes
      final int red = (color0.value! * 255).round().toUnsigned(8);
      final int green = (color1.value! * 255).round().toUnsigned(8);
      final int blue = (color2.value! * 255).round().toUnsigned(8);
      color = PdfColor(red, green, blue);
    } else if (colours != null && colours.elements.length == 4) {
      final PdfNumber? color0 = crossTable.getObject(colours[0]) as PdfNumber?;
      final PdfNumber? color1 = crossTable.getObject(colours[1]) as PdfNumber?;
      final PdfNumber? color2 = crossTable.getObject(colours[2]) as PdfNumber?;
      final PdfNumber? color3 = crossTable.getObject(colours[3]) as PdfNumber?;
      if (color0 != null &&
          color1 != null &&
          color2 != null &&
          color3 != null) {
        //Convert the float color values into bytes
        final double cyan = color0.value! as double;
        final double magenta = color1.value! as double;
        final double yellow = color2.value! as double;
        final double black = color3.value! as double;
        color = PdfColor.fromCMYK(cyan, magenta, yellow, black);
      }
    }
    return color;
  }

  // Gets the Opacity.
  double? _obtainOpacity() {
    if (dictionary!.containsKey(PdfDictionaryProperties.ca)) {
      annotationOpacity = _getNumber(PdfDictionaryProperties.ca)!;
    }
    return annotationOpacity;
  }

  // Gets the number value.
  double? _getNumber(String keyName) {
    double? result = 0;
    final PdfNumber? numb = dictionary![keyName] as PdfNumber?;
    if (numb != null) {
      result = numb.value as double?;
    }
    return result;
  }

  // Gets the Author.
  String _obtainAuthor() {
    String author = '';
    if (dictionary!.containsKey(PdfDictionaryProperties.author)) {
      final IPdfPrimitive? tempAuthor = PdfCrossTable.dereference(
          dictionary![PdfDictionaryProperties.author]);
      if (tempAuthor != null &&
          tempAuthor is PdfString &&
          tempAuthor.value != null) {
        author = tempAuthor.value!;
      }
    } else if (dictionary!.containsKey(PdfDictionaryProperties.t)) {
      final IPdfPrimitive? tempAuthor =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.t]);
      if (tempAuthor != null &&
          tempAuthor is PdfString &&
          tempAuthor.value != null) {
        author = tempAuthor.value!;
      }
    }
    return author;
  }

  // Gets the Subject.
  String _obtainSubject() {
    String subject = '';
    if (dictionary!.containsKey(PdfDictionaryProperties.subject)) {
      final IPdfPrimitive? tempSubject = PdfCrossTable.dereference(
          dictionary![PdfDictionaryProperties.subject]);
      if (tempSubject != null &&
          tempSubject is PdfString &&
          tempSubject.value != null) {
        subject = tempSubject.value!;
      }
    } else if (dictionary!.containsKey(PdfDictionaryProperties.subj)) {
      final IPdfPrimitive? tempSubject =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.subj]);
      if (tempSubject != null &&
          tempSubject is PdfString &&
          tempSubject.value != null) {
        subject = tempSubject.value!;
      }
    }
    return subject;
  }

  // Gets the ModifiedDate.
  DateTime? _obtainModifiedDate() {
    if (dictionary!.containsKey(PdfDictionaryProperties.modificationDate) ||
        dictionary!.containsKey(PdfDictionaryProperties.m)) {
      PdfString? modifiedDate =
          dictionary![PdfDictionaryProperties.modificationDate] as PdfString?;
      modifiedDate ??= dictionary![PdfDictionaryProperties.m] as PdfString?;
      annotationModifiedDate = dictionary!.getDateTime(modifiedDate!);
    }
    return annotationModifiedDate;
  }

  /// internal method
  String getEnumName(dynamic annotText) {
    final int index = annotText.toString().indexOf('.');
    final String name = annotText.toString().substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  //Get the inner line color
  PdfColor _obtainInnerColor() {
    PdfColor color = PdfColor.empty;
    PdfArray? colours;
    if (dictionary!.containsKey(PdfDictionaryProperties.iC)) {
      colours =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.iC])
              as PdfArray?;
      if (colours != null && colours.count > 0) {
        final int red =
            ((colours[0]! as PdfNumber).value! * 255).round().toUnsigned(8);
        final int green =
            ((colours[1]! as PdfNumber).value! * 255).round().toUnsigned(8);
        final int blue =
            ((colours[2]! as PdfNumber).value! * 255).round().toUnsigned(8);
        color = PdfColor(red, green, blue);
      }
    }
    return color;
  }

  /// internal method
  PdfMargins? obtainMargin() {
    if (page != null && PdfPageHelper.getHelper(page!).section != null) {
      margins = PdfPageHelper.getHelper(page!).section!.pageSettings.margins;
    }
    return margins;
  }

  /// internal method
  void flattenPopup() {
    if (page != null && !isLoadedAnnotation) {
      _flattenAnnotationPopups(
          page!, color, bounds, border, author, subject, text);
    }
  }

  void _flattenAnnotationPopups(PdfPage page, PdfColor color, Rect annotBounds,
      PdfAnnotationBorder border, String author, String subject, String text) {
    final Size clientSize = PdfPageHelper.getHelper(page).isLoadedPage
        ? page.size
        : page.getClientSize();
    final double x = clientSize.width - 180;
    final double y = (annotBounds.top + 142) < clientSize.height
        ? annotBounds.top
        : clientSize.height - 142;
    Rect bounds = Rect.fromLTWH(x, y, 180, 142);
    // Draw annotation based on bounds
    if (dictionary![PdfDictionaryProperties.popup] != null) {
      final IPdfPrimitive? obj = dictionary![PdfDictionaryProperties.popup];
      final PdfDictionary? tempDictionary =
          PdfCrossTable.dereference(obj) as PdfDictionary?;
      if (tempDictionary != null) {
        final PdfArray? rectValue = PdfCrossTable.dereference(
            tempDictionary[PdfDictionaryProperties.rect]) as PdfArray?;
        final PdfCrossTable? crosstable =
            PdfPageHelper.getHelper(page).crossTable;
        if (rectValue != null) {
          final PdfNumber left =
              crosstable!.getReference(rectValue[0]) as PdfNumber;
          final PdfNumber top =
              crosstable.getReference(rectValue[1]) as PdfNumber;
          final PdfNumber width =
              crosstable.getReference(rectValue[2]) as PdfNumber;
          final PdfNumber height =
              crosstable.getReference(rectValue[3]) as PdfNumber;
          bounds = Rect.fromLTWH(
              left.value! as double,
              top.value! as double,
              width.value! - (left.value! as double),
              height.value! - (top.value! as double));
        }
      }
    }
    final PdfBrush backBrush = PdfSolidBrush(color);
    final double borderWidth = border.width / 2;
    double? trackingHeight = 0;
    final PdfBrush aBrush = PdfSolidBrush(_getForeColor(color));
    if (author != '') {
      final Map<String, double?> returnedValue = _drawAuthor(author, subject,
          bounds, backBrush, aBrush, page, trackingHeight, border);
      trackingHeight = returnedValue['height'];
    } else if (subject != '') {
      final Rect titleRect = Rect.fromLTWH(bounds.left + borderWidth,
          bounds.top + borderWidth, bounds.width - border.width, 40);
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect);
      page.graphics.restore();
      Rect contentRect = Rect.fromLTWH(titleRect.left + 11, titleRect.top,
          titleRect.width, titleRect.height / 2);
      contentRect = Rect.fromLTWH(
          contentRect.left,
          contentRect.top + contentRect.height - 2,
          contentRect.width,
          titleRect.height / 2);
      _saveGraphics(page, PdfBlendMode.normal);
      _drawSubject(subject, contentRect, page);
      page.graphics.restore();
      trackingHeight = 40;
    } else {
      _saveGraphics(page, PdfBlendMode.hardLight);
      final Rect titleRect = Rect.fromLTWH(bounds.left + borderWidth,
          bounds.top + borderWidth, bounds.width - border.width, 20);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect);
      trackingHeight = 20;
      page.graphics.restore();
    }
    Rect cRect = Rect.fromLTWH(
        bounds.left + borderWidth,
        bounds.top + borderWidth + trackingHeight!,
        bounds.width - border.width,
        bounds.height - (trackingHeight + border.width));
    _saveGraphics(page, PdfBlendMode.hardLight);
    page.graphics.drawRectangle(
        pen: PdfPens.black, brush: PdfBrushes.white, bounds: cRect);
    cRect = Rect.fromLTWH(
        cRect.left + 11, cRect.top + 5, cRect.width - 22, cRect.height);
    page.graphics.restore();
    _saveGraphics(page, PdfBlendMode.normal);
    page.graphics.drawString(
        text, PdfStandardFont(PdfFontFamily.helvetica, 10.5),
        brush: PdfBrushes.black, bounds: cRect);
    page.graphics.restore();
  }

  void _drawSubject(String subject, Rect bounds, PdfPage page) {
    page.graphics.drawString(
        subject,
        PdfStandardFont(PdfFontFamily.helvetica, 10.5,
            style: PdfFontStyle.bold),
        brush: PdfBrushes.black,
        bounds: bounds,
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
  }

  void _saveGraphics(PdfPage page, PdfBlendMode mode) {
    page.graphics.save();
    PdfGraphicsHelper.getHelper(page.graphics)
        .applyTransparency(0.8, 8.0, mode);
  }

  PdfColor _getForeColor(PdfColor c) {
    return (((c.r + c.b + c.g) / 3) > 128)
        ? PdfColor(0, 0, 0)
        : PdfColor(255, 255, 255);
  }

  Map<String, double?> _drawAuthor(
      String author,
      String subject,
      Rect bounds,
      PdfBrush backBrush,
      PdfBrush aBrush,
      PdfPage page,
      double? trackingHeight,
      PdfAnnotationBorder border) {
    final double borderWidth = border.width / 2;
    final PdfRectangle titleRect = PdfRectangle.fromRect(Rect.fromLTWH(
        bounds.left + borderWidth,
        bounds.top + borderWidth,
        bounds.width - border.width,
        20));
    if (subject != '') {
      titleRect.height += 20;
      trackingHeight = titleRect.height;
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect.rect);
      page.graphics.restore();
      Rect contentRect = Rect.fromLTWH(
          titleRect.x + 11, titleRect.y, titleRect.width, titleRect.height / 2);
      _saveGraphics(page, PdfBlendMode.normal);
      page.graphics.drawString(
          author,
          PdfStandardFont(PdfFontFamily.helvetica, 10.5,
              style: PdfFontStyle.bold),
          brush: aBrush,
          bounds: contentRect,
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      contentRect = Rect.fromLTWH(
          contentRect.left,
          contentRect.top + contentRect.height - 2,
          contentRect.width,
          titleRect.height / 2);
      _drawSubject(subject, contentRect, page);
      page.graphics.restore();
    } else {
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect.rect);
      page.graphics.restore();
      final Rect contentRect = Rect.fromLTWH(
          titleRect.x + 11, titleRect.y, titleRect.width, titleRect.height);
      _saveGraphics(page, PdfBlendMode.normal);
      page.graphics.drawString(
          author, PdfStandardFont(PdfFontFamily.helvetica, 10.5),
          brush: aBrush,
          bounds: contentRect,
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      trackingHeight = titleRect.height;
      page.graphics.restore();
    }
    return <String, double?>{'height': trackingHeight};
  }

  /// internal method
  Rect calculateTemplateBounds(
      Rect bounds, PdfPage? page, PdfTemplate? template, bool isNormalMatrix) {
    double x = bounds.left,
        y = bounds.top,
        width = bounds.width,
        height = bounds.height;
    if (page != null) {
      final int graphicsRotation = _obtainGraphicsRotation(
          PdfGraphicsHelper.getHelper(page.graphics).matrix);
      if (graphicsRotation == 0 && !isNormalMatrix) {
        x = bounds.left;
        y = bounds.top + bounds.height - bounds.width;
        width = bounds.height;
        height = bounds.width;
      }
    }
    return Rect.fromLTWH(x, y, width, height);
  }

  int _obtainGraphicsRotation(PdfTransformationMatrix matrix) {
    int angle = 0;
    final double radians =
        atan2(matrix.matrix.elements[2], matrix.matrix.elements[0]);
    angle = (radians * 180 / pi).round();
    switch (angle) {
      case -90:
        angle = 90;
        break;
      case -180:
        angle = 180;
        break;
      case 90:
        angle = 270;
        break;
    }
    return angle;
  }

  /// internal method
  static void setMatrixToZeroRotation(PdfDictionary template) {
    final PdfArray? bbox = template[PdfDictionaryProperties.bBox] as PdfArray?;
    if (bbox != null) {
      final List<double> elements = <double>[
        1,
        0,
        0,
        1,
        -(bbox[0]! as PdfNumber).value! as double,
        -(bbox[1]! as PdfNumber).value! as double
      ];
      template[PdfDictionaryProperties.matrix] = PdfArray(elements);
    }
  }

  PdfBorderStyle _getBorderStyle(String bstyle) {
    PdfBorderStyle style = PdfBorderStyle.solid;
    switch (bstyle) {
      case 'S':
        style = PdfBorderStyle.solid;
        break;
      case 'D':
        style = PdfBorderStyle.dashed;
        break;
      case 'B':
        style = PdfBorderStyle.beveled;
        break;
      case 'I':
        style = PdfBorderStyle.inset;
        break;
      case 'U':
        style = PdfBorderStyle.underline;
        break;
    }
    return style;
  }

  /// internal method
  PdfRectangle calculateLineBounds(
      List<int> linePoints,
      int leaderLineExt,
      int leaderLineValue,
      int leaderOffset,
      PdfArray lineStyle,
      double borderLength) {
    PdfRectangle tempBounds = PdfRectangle.fromRect(bounds);
    final PdfPath path = PdfPath();
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
        angle = getAngle(x1, y1, x2, y2);
      }
      int leaderLine = 0;
      double lineAngle = 0;
      if (leaderLineValue < 0) {
        leaderLine = leaderLineValue * -1;
        lineAngle = angle + 180;
      } else {
        leaderLine = leaderLineValue;
        lineAngle = angle;
      }
      final List<double> x1y1 = <double>[x1, y1];
      final List<double> x2y2 = <double>[x2, y2];
      if (leaderOffset != 0) {
        final List<double> offsetPoint1 =
            getAxisValue(x1y1, lineAngle + 90, leaderOffset.toDouble());
        final List<double> offsetPoint2 =
            getAxisValue(x2y2, lineAngle + 90, leaderOffset.toDouble());
        linePoints[0] = offsetPoint1[0].toInt();
        linePoints[1] = offsetPoint1[1].toInt();
        linePoints[2] = offsetPoint2[0].toInt();
        linePoints[3] = offsetPoint2[1].toInt();
      }

      final List<double> startingPoint = getAxisValue(
          x1y1, lineAngle + 90, (leaderLine + leaderOffset).toDouble());
      final List<double> endingPoint = getAxisValue(
          x2y2, lineAngle + 90, (leaderLine + leaderOffset).toDouble());

      final List<double> beginLineLeader = getAxisValue(x1y1, lineAngle + 90,
          (leaderLineExt + leaderLine + leaderOffset).toDouble());

      final List<double> endLineLeader = getAxisValue(x2y2, lineAngle + 90,
          (leaderLineExt + leaderLine + leaderOffset).toDouble());

      final List<PdfPoint> stylePoint = <PdfPoint>[];

      for (int i = 0; i < lineStyle.count; i++) {
        final PdfName lineEndingStyle = lineStyle[i]! as PdfName;
        final PdfPoint point = PdfPoint.empty;
        switch (getEnumName(lineEndingStyle.name)) {
          case 'Square':
          case 'Circle':
          case 'Diamond':
            {
              point.x = 3;
              point.y = 3;
            }
            break;
          case 'OpenArrow':
          case 'ClosedArrow':
            {
              point.x = 1;
              point.y = 5;
            }
            break;
          case 'ROpenArrow':
          case 'RClosedArrow':
            {
              point.x = 9 + (borderLength / 2);
              point.y = 5 + (borderLength / 2);
            }
            break;
          case 'Slash':
            {
              point.x = 5;
              point.y = 9;
            }
            break;
          case 'Butt':
            {
              point.x = 1;
              point.y = 3;
            }
            break;
          default:
            {
              point.x = 0;
              point.y = 0;
            }
            break;
        }
        stylePoint.add(point);
      }
      final List<double> widthX = List<double>.filled(2, 0);
      final List<double> heightY = List<double>.filled(2, 0);

      if ((lineAngle >= 45 && lineAngle <= 135) ||
          (lineAngle >= 225 && lineAngle <= 315)) {
        widthX[0] = stylePoint[0].y;
        heightY[0] = stylePoint[0].x;
        widthX[1] = stylePoint[1].y;
        heightY[1] = stylePoint[1].x;
      } else {
        widthX[0] = stylePoint[0].x;
        heightY[0] = stylePoint[0].y;
        widthX[1] = stylePoint[1].x;
        heightY[1] = stylePoint[1].y;
      }

      final double height = max(heightY[0], heightY[1]);
      if (startingPoint[0] ==
          <double>[startingPoint[0], endingPoint[0]].reduce(min)) {
        startingPoint[0] -= widthX[0] * borderLength;
        endingPoint[0] += widthX[1] * borderLength;
        startingPoint[0] =
            <double>[startingPoint[0], linePoints[0].toDouble()].reduce(min);
        startingPoint[0] = min(startingPoint[0], beginLineLeader[0]);
        endingPoint[0] = max(endingPoint[0], linePoints[2].toDouble());
        endingPoint[0] = max(endingPoint[0], endLineLeader[0]);
      } else {
        startingPoint[0] += widthX[0] * borderLength;
        endingPoint[0] -= widthX[1] * borderLength;
        startingPoint[0] = max(startingPoint[0], linePoints[0].toDouble());
        startingPoint[0] = max(startingPoint[0], beginLineLeader[0]);
        endingPoint[0] = min(endingPoint[0], linePoints[2].toDouble());
        endingPoint[0] = min(endingPoint[0], endLineLeader[0]);
      }
      if (startingPoint[1] == min(startingPoint[1], endingPoint[1])) {
        startingPoint[1] -= height * borderLength;
        endingPoint[1] += height * borderLength;
        startingPoint[1] = min(startingPoint[1], linePoints[1].toDouble());
        startingPoint[1] = min(startingPoint[1], beginLineLeader[1]);
        endingPoint[1] = max(endingPoint[1], linePoints[3].toDouble());
        endingPoint[1] = max(endingPoint[1], endLineLeader[1]);
      } else {
        startingPoint[1] += height * borderLength;
        endingPoint[1] -= height * borderLength;
        startingPoint[1] = max(startingPoint[1], linePoints[1].toDouble());
        startingPoint[1] = max(startingPoint[1], beginLineLeader[1]);
        endingPoint[1] = min(endingPoint[1], linePoints[3].toDouble());
        endingPoint[1] = min(endingPoint[1], endLineLeader[1]);
      }
      path.addLine(Offset(startingPoint[0], startingPoint[1]),
          Offset(endingPoint[0], endingPoint[1]));
      tempBounds = PdfPathHelper.getHelper(path).getBoundsInternal();
    }
    return tempBounds;
  }

  /// internal method
  List<double> getAxisValue(List<double> value, double angle, double length) {
    const double degToRad = pi / 180.0;
    final List<double> xy = List<double>.filled(2, 0);
    xy[0] = value[0] + cos(angle * degToRad) * length;
    xy[1] = value[1] + sin(angle * degToRad) * length;

    return xy;
  }

  /// internal method
  double getAngle(double x1, double y1, double x2, double y2) {
    double angle = 0;
    final double angleRatio = (y2 - y1) / (x2 - x1);
    final double radians = atan(angleRatio);
    angle = radians * (180 / pi);

    if ((x2 - x1) < 0 || (y2 - y1) < 0) {
      angle += 180;
    }
    if ((x2 - x1) > 0 && (y2 - y1) < 0) {
      angle -= 180;
    }
    if (angle < 0) {
      angle += 360;
    }

    return angle;
  }

  /// internal method
  void setLineEndingStyles(
      List<double> startingPoint,
      List<double> endingPoint,
      PdfGraphics? graphics,
      double angle,
      PdfPen? borderPen,
      PdfBrush? backBrush,
      PdfArray lineStyle,
      double borderLength) {
    List<double> axisPoint;
    if (borderLength == 0) {
      borderLength = 1;
      borderPen = null;
    }
    if (backBrush is PdfSolidBrush) {
      if (backBrush.color.isEmpty) {
        backBrush = null;
      }
    }
    for (int i = 0; i < lineStyle.count; i++) {
      final PdfName lineEndingStyle = lineStyle[i]! as PdfName;
      if (i == 0) {
        axisPoint = startingPoint;
      } else {
        axisPoint = endingPoint;
      }
      switch (lineEndingStyle.name) {
        case 'Square':
          {
            final Rect rect = Rect.fromLTWH(
                axisPoint[0] - (3 * borderLength),
                -(axisPoint[1] + (3 * borderLength)),
                6 * borderLength,
                6 * borderLength);
            graphics!
                .drawRectangle(bounds: rect, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Circle':
          {
            final Rect rect = Rect.fromLTWH(
                axisPoint[0] - (3 * borderLength),
                -(axisPoint[1] + (3 * borderLength)),
                6 * borderLength,
                6 * borderLength);
            graphics!.drawEllipse(rect, pen: borderPen, brush: backBrush);
          }
          break;
        case 'OpenArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 30;
            } else {
              arraowAngle = 150;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = getAxisValue(axisPoint, angle, borderLength);
            } else {
              startPoint = getAxisValue(axisPoint, angle, -borderLength);
            }
            final List<double> point1 =
                getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                getAxisValue(startPoint, angle - arraowAngle, length);

            final PdfPath path = PdfPath(pen: borderPen);
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point1[0], -point1[1]));
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point2[0], -point2[1]));
            graphics!.drawPath(path, pen: borderPen);
          }
          break;
        case 'ClosedArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 30;
            } else {
              arraowAngle = 150;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = getAxisValue(axisPoint, angle, borderLength);
            } else {
              startPoint = getAxisValue(axisPoint, angle, -borderLength);
            }
            final List<double> point1 =
                getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                getAxisValue(startPoint, angle - arraowAngle, length);
            final List<Offset> points = <Offset>[
              Offset(startPoint[0], -startPoint[1]),
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'ROpenArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 150;
            } else {
              arraowAngle = 30;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = getAxisValue(axisPoint, angle, -borderLength);
            } else {
              startPoint = getAxisValue(axisPoint, angle, borderLength);
            }
            final List<double> point1 =
                getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                getAxisValue(startPoint, angle - arraowAngle, length);

            final PdfPath path = PdfPath(pen: borderPen);
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point1[0], -point1[1]));
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point2[0], -point2[1]));
            graphics!.drawPath(path, pen: borderPen);
          }
          break;
        case 'RClosedArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 150;
            } else {
              arraowAngle = 30;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = getAxisValue(axisPoint, angle, -borderLength);
            } else {
              startPoint = getAxisValue(axisPoint, angle, borderLength);
            }

            final List<double> point1 =
                getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                getAxisValue(startPoint, angle - arraowAngle, length);
            final List<Offset> points = <Offset>[
              Offset(startPoint[0], -startPoint[1]),
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Slash':
          {
            final double length = 9 * borderLength;
            final List<double> point1 =
                getAxisValue(axisPoint, angle + 60, length);
            final List<double> point2 =
                getAxisValue(axisPoint, angle - 120, length);
            graphics!.drawLine(borderPen!, Offset(axisPoint[0], -axisPoint[1]),
                Offset(point1[0], -point1[1]));
            graphics.drawLine(borderPen, Offset(axisPoint[0], -axisPoint[1]),
                Offset(point2[0], -point2[1]));
          }
          break;
        case 'Diamond':
          {
            final double length = 3 * borderLength;
            final List<double> point1 = getAxisValue(axisPoint, 180, length);
            final List<double> point2 = getAxisValue(axisPoint, 90, length);
            final List<double> point3 = getAxisValue(axisPoint, 0, length);
            final List<double> point4 = getAxisValue(axisPoint, -90, length);
            final List<Offset> points = <Offset>[
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1]),
              Offset(point3[0], -point3[1]),
              Offset(point4[0], -point4[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Butt':
          {
            final double length = 3 * borderLength;
            final List<double> point1 =
                getAxisValue(axisPoint, angle + 90, length);
            final List<double> point2 =
                getAxisValue(axisPoint, angle - 90, length);

            graphics!.drawLine(borderPen!, Offset(point1[0], -point1[1]),
                Offset(point2[0], -point2[1]));
          }
          break;
      }
    }
  }

  /// Returns the appearance matrix is rotated or not
  bool validateTemplateMatrix(PdfDictionary dictionary) {
    bool isRotatedMatrix = false;
    if (dictionary.containsKey(PdfDictionaryProperties.matrix)) {
      final PdfArray? matrix =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.matrix])
              as PdfArray?;
      if (matrix != null && matrix.count > 3) {
        if ((matrix[0]! as PdfNumber).value == 1 &&
            (matrix[1]! as PdfNumber).value == 0 &&
            (matrix[2]! as PdfNumber).value == 0 &&
            (matrix[3]! as PdfNumber).value == 1) {
          isRotatedMatrix = true;
        }
      }
    } else {
      isRotatedMatrix = true;
    }
    return isRotatedMatrix;
  }

  /// Returns the boolean if the template matrix is valid or not
  bool isValidTemplateMatrix(
      PdfDictionary dictionary, Offset bounds, PdfTemplate template) {
    bool isValidMatrix = true;
    Offset point = bounds;
    if (dictionary.containsKey(PdfDictionaryProperties.matrix)) {
      final IPdfPrimitive? bbox =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.bBox]);
      final IPdfPrimitive? matrix =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.matrix]);
      if (matrix != null &&
          bbox != null &&
          matrix is PdfArray &&
          bbox is PdfArray &&
          matrix.count > 3 &&
          bbox.count > 2) {
        if ((matrix[0]! as PdfNumber).value == 1 &&
            (matrix[1]! as PdfNumber).value == 0 &&
            (matrix[2]! as PdfNumber).value == 0 &&
            (matrix[3]! as PdfNumber).value == 1) {
          if ((((bbox[0]! as PdfNumber).value!.toDouble() !=
                      -(matrix[4]! as PdfNumber).value!.toDouble()) &&
                  ((bbox[1]! as PdfNumber).value!.toDouble() !=
                      -(matrix[5]! as PdfNumber).value!.toDouble())) ||
              ((bbox[0]! as PdfNumber).value!.toDouble() == 0 &&
                  -(matrix[4]! as PdfNumber).value!.toDouble() == 0)) {
            final PdfGraphics pageGraphics = page!.graphics;
            final PdfGraphicsState state = pageGraphics.save();
            if (opacity < 1) {
              pageGraphics.setTransparency(opacity);
            }
            point = Offset(point.dx - (bbox[0]! as PdfNumber).value!.toDouble(),
                point.dy + (bbox[1]! as PdfNumber).value!.toDouble());
            pageGraphics.drawPdfTemplate(template, point);
            pageGraphics.restore(state);
            page!.annotations.remove(base);
            isValidMatrix = false;
          }
        } else if ((matrix[0]! as PdfNumber).value == 0 &&
            (matrix[1]! as PdfNumber).value == -1 &&
            (matrix[2]! as PdfNumber).value == 1 &&
            (matrix[3]! as PdfNumber).value == 0) {
          if ((bbox[0]! as PdfNumber).value! > 0) {
            isValidMatrix = false;
          }
        } else {
          if ((bbox[0]! as PdfNumber).value! > 0) {
            isValidMatrix = false;
          }
        }
      }
    }
    return isValidMatrix;
  }

  /// Flatten annotation template
  void flattenAnnotationTemplate(PdfTemplate appearance, bool isNormalMatrix) {
    final PdfGraphicsState state = page!.graphics.save();
    if (opacity < 1) {
      page!.graphics.setTransparency(opacity);
    }
    final Rect bound =
        calculateTemplateBounds(bounds, page, appearance, isNormalMatrix);
    page!.graphics.drawPdfTemplate(appearance, bound.topLeft, bounds.size);
    page!.graphics.restore(state);
    page!.annotations.remove(base);
  }

  /// Draw CloudStye to the Shapes
  void drawCloudStyle(PdfGraphics graphics, PdfBrush? brush, PdfPen? pen,
      double radius, double overlap, List<Offset> points, bool isAppearance) {
    if (_isClockWise(points)) {
      points = List<Offset>.generate(
          points.length, (int i) => points[points.length - (i + 1)]);
    }

    // Create a list of circles
    final List<_CloudStyleArc> circles = <_CloudStyleArc>[];
    final double circleOverlap = 2 * radius * overlap;
    Offset previousPoint = points[points.length - 1];
    for (int i = 0; i < points.length; i++) {
      final Offset currentPoint = points[i];
      double dx = currentPoint.dx - previousPoint.dx;
      double dy = currentPoint.dy - previousPoint.dy;
      final double len = sqrt(dx * dx + dy * dy);
      dx = dx / len;
      dy = dy / len;
      final double d = circleOverlap;
      for (double a = 0; a + 0.1 * d < len; a += d) {
        final _CloudStyleArc cur = _CloudStyleArc();
        cur.point =
            Offset(previousPoint.dx + a * dx, previousPoint.dy + a * dy);
        circles.add(cur);
      }
      previousPoint = currentPoint;
    }
    final PdfPath gpath = PdfPath();
    gpath.addPolygon(points);

    // Determine intersection angles of circles
    _CloudStyleArc previousCurvedStyleArc = circles[circles.length - 1];
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc currentCurvedStyleArc = circles[i];
      final Offset angle = _getIntersectionDegrees(
          previousCurvedStyleArc.point, currentCurvedStyleArc.point, radius);
      previousCurvedStyleArc.endAngle = angle.dx;
      currentCurvedStyleArc.startAngle = angle.dy;
      previousCurvedStyleArc = currentCurvedStyleArc;
    }

    // Draw the cloud
    PdfPath path = PdfPath();
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc curr = circles[i];
      final double angle = curr.startAngle < 0
          ? ((curr.startAngle * -1) % 360) * -1
          : curr.startAngle % 360;
      final double angle1 = curr.endAngle < 0
          ? ((curr.endAngle * -1) % 360) * -1
          : curr.endAngle % 360;
      double sweepAngel = 0;
      if (angle > 0 && angle1 < 0) {
        sweepAngel = (180 - angle) + (180 - (angle1 < 0 ? -angle1 : angle1));
      } else if (angle < 0 && angle1 > 0) {
        sweepAngel = -angle + angle1;
      } else if (angle > 0 && angle1 > 0) {
        double difference = 0;
        if (angle > angle1) {
          difference = angle - angle1;
          sweepAngel = 360 - difference;
        } else {
          sweepAngel = angle1 - angle;
        }
      } else if (angle < 0 && angle1 < 0) {
        double difference = 0;
        if (angle > angle1) {
          difference = angle - angle1;
          sweepAngel = 360 - difference;
        } else {
          sweepAngel = -(angle + (-angle1));
        }
      }
      if (sweepAngel < 0) {
        sweepAngel = -sweepAngel;
      }
      curr.endAngle = sweepAngel;
      path.addArc(
          Rect.fromLTWH(curr.point.dx - radius, curr.point.dy - radius,
              2 * radius, 2 * radius),
          angle,
          sweepAngel);
    }
    path.closeFigure();
    PdfPath pdfPath = PdfPath();
    if (isAppearance) {
      for (int i = 0; i < PdfPathHelper.getHelper(path).points.length; i++) {
        PdfPathHelper.getHelper(pdfPath).points.add(Offset(
            PdfPathHelper.getHelper(path).points[i].dx,
            -PdfPathHelper.getHelper(path).points[i].dy));
      }
    } else {
      PdfPathHelper.getHelper(pdfPath)
          .points
          .addAll(PdfPathHelper.getHelper(path).points);
    }
    PdfPathHelper.getHelper(pdfPath)
        .pathTypes
        .addAll(PdfPathHelper.getHelper(path).pathTypes);
    if (brush != null) {
      graphics.drawPath(pdfPath, brush: brush);
    }
    const double incise = 180 / (pi * 3);
    path = PdfPath();
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc curr = circles[i];
      path.addArc(
          Rect.fromLTWH(curr.point.dx - radius, curr.point.dy - radius,
              2 * radius, 2 * radius),
          curr.startAngle,
          curr.endAngle + incise);
    }
    path.closeFigure();
    pdfPath = PdfPath();
    if (isAppearance) {
      for (int i = 0; i < PdfPathHelper.getHelper(path).points.length; i++) {
        PdfPathHelper.getHelper(pdfPath).points.add(Offset(
            PdfPathHelper.getHelper(path).points[i].dx,
            -PdfPathHelper.getHelper(path).points[i].dy));
      }
    } else {
      PdfPathHelper.getHelper(pdfPath)
          .points
          .addAll(PdfPathHelper.getHelper(path).points);
    }
    PdfPathHelper.getHelper(pdfPath)
        .pathTypes
        .addAll(PdfPathHelper.getHelper(path).pathTypes);
    graphics.drawPath(pdfPath, pen: pen);
  }

  bool _isClockWise(List<Offset> points) {
    double sum = 0.0;
    for (int i = 0; i < points.length; i++) {
      final Offset v1 = points[i];
      final Offset v2 = points[(i + 1) % points.length];
      sum += (v2.dx - v1.dx) * (v2.dy + v1.dy);
    }
    return sum > 0.0;
  }

  Offset _getIntersectionDegrees(Offset point1, Offset point2, double radius) {
    final double dx = point2.dx - point1.dx;
    final double dy = point2.dy - point1.dy;
    final double len = sqrt(dx * dx + dy * dy);
    double a = 0.5 * len / radius;
    if (a < -1) {
      a = -1;
    }
    if (a > 1) {
      a = 1;
    }
    final double radian = atan2(dy, dx);
    final double cosvalue = acos(a);
    return Offset((radian - cosvalue) * (180 / pi),
        (pi + radian + cosvalue) * (180 / pi));
  }

  // Searches the in parents.
  static IPdfPrimitive? _searchInParents(
      PdfDictionary dictionary, PdfCrossTable? crossTable, String value) {
    IPdfPrimitive? primitive;
    PdfDictionary? dic = dictionary;
    while ((primitive == null) && (dic != null)) {
      if (dic.containsKey(value)) {
        primitive = crossTable!.getObject(dic[value]);
      } else {
        if (dic.containsKey(PdfDictionaryProperties.parent)) {
          dic = crossTable!.getObject(dic[PdfDictionaryProperties.parent])
              as PdfDictionary?;
        } else {
          dic = null;
        }
      }
    }
    return primitive;
  }

  /// internal method
  static IPdfPrimitive? getValue(PdfDictionary dictionary,
      PdfCrossTable? crossTable, String value, bool inheritable) {
    IPdfPrimitive? primitive;
    if (dictionary.containsKey(value)) {
      primitive = crossTable!.getObject(dictionary[value]);
    } else {
      if (inheritable) {
        primitive = _searchInParents(dictionary, crossTable, value);
      }
    }
    return primitive;
  }

  /// internal method
  static void save(PdfAnnotation annotation) {
    bool isSaveComplete = false;
    if (annotation is PdfActionAnnotation) {
      PdfActionAnnotationHelper.getHelper(annotation).save();
    } else if (annotation is PdfDocumentLinkAnnotation) {
      PdfDocumentLinkAnnotationHelper.getHelper(annotation).save();
    } else if (annotation is PdfEllipseAnnotation) {
      PdfEllipseAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is PdfLineAnnotation) {
      PdfLineAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is PdfPolygonAnnotation) {
      PdfPolygonAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is PdfRectangleAnnotation) {
      PdfRectangleAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is WidgetAnnotation) {
      WidgetAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is PdfTextMarkupAnnotation) {
      PdfTextMarkupAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    } else if (annotation is PdfPopupAnnotation) {
      PdfPopupAnnotationHelper.getHelper(annotation).save();
      isSaveComplete = true;
    }
    if (!PdfAnnotationHelper.getHelper(annotation).flatten) {
      final PdfAnnotationHelper helper =
          PdfAnnotationHelper.getHelper(annotation);
      if (helper.flag != null) {
        int flagValue = 0;
        for (int i = 0; i < helper.flag!.length; i++) {
          flagValue |= getAnnotationFlagsValue(helper.flag![i]);
        }
        helper.dictionary!.setNumber(PdfDictionaryProperties.f, flagValue);
      }
    }
    if (!isSaveComplete) {
      PdfAnnotationHelper.getHelper(annotation).saveAnnotation();
    }
  }

  /// Internal method.
  int? getFlagValue() {
    if (dictionary!.containsKey(PdfDictionaryProperties.f)) {
      final IPdfPrimitive? annotFlags =
          getValue(dictionary!, crossTable, PdfDictionaryProperties.f, false);
      if (annotFlags != null &&
          annotFlags is PdfNumber &&
          annotFlags.value != null) {
        return annotFlags.value!.toInt();
      }
    }
    return null;
  }

  /// Internal method.
  static List<PdfAnnotationFlags> obtainAnnotationFlags(int? flagValue) {
    final List<PdfAnnotationFlags> flags = <PdfAnnotationFlags>[];
    if (flagValue != null) {
      for (final PdfAnnotationFlags flag in PdfAnnotationFlags.values) {
        if (flagValue == 0) {
          return flags..add(flag);
        }
        if (getAnnotationFlagsValue(flag) & flagValue != 0) {
          flags.add(flag);
        }
      }
    }
    return flags;
  }

  /// internal method
  static int getAnnotationFlagsValue(PdfAnnotationFlags value) {
    switch (value) {
      case PdfAnnotationFlags.defaultFlag:
        return 0;
      case PdfAnnotationFlags.invisible:
        return 1;
      case PdfAnnotationFlags.hidden:
        return 2;
      case PdfAnnotationFlags.print:
        return 4;
      case PdfAnnotationFlags.noZoom:
        return 8;
      case PdfAnnotationFlags.noRotate:
        return 16;
      case PdfAnnotationFlags.noView:
        return 32;
      case PdfAnnotationFlags.readOnly:
        return 64;
      case PdfAnnotationFlags.locked:
        return 128;
      case PdfAnnotationFlags.toggleNoView:
        return 256;
    }
  }
}

class _CloudStyleArc {
  late Offset point;
  double endAngle = 0;
  double startAngle = 0;
}
