import '../../interfaces/pdf_interface.dart';
import '../general/pdf_collection.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_document_link_annotation.dart';
import 'pdf_ellipse_annotation.dart';
import 'pdf_line_annotation.dart';
import 'pdf_polygon_annotation.dart';
import 'pdf_popup_annotation.dart';
import 'pdf_rectangle_annotation.dart';
import 'pdf_text_markup_annotation.dart';
import 'pdf_text_web_link.dart';
import 'pdf_uri_annotation.dart';
import 'widget_annotation.dart';

/// Represents the collection of [PdfAnnotation] objects.
class PdfAnnotationCollection extends PdfObjectCollection
    implements IPdfWrapper {
  // constructor
  /// Initializes a new instance of the [PdfAnnotationCollection]
  /// class with the specified page.
  PdfAnnotationCollection(PdfPage page) : super() {
    _helper = PdfAnnotationCollectionHelper(this, page);
  }

  PdfAnnotationCollection._(PdfPage page) : super() {
    _helper = PdfAnnotationCollectionHelper._(this, page);
  }

  // Fields
  late PdfAnnotationCollectionHelper _helper;

  // public methods
  /// Gets the PdfAnnotation at the specified index.
  PdfAnnotation operator [](int index) => _helper.getValue(index);

  /// Adds a new annotation to the collection.
  int add(PdfAnnotation annotation) {
    return _helper._doAdd(annotation);
  }

  /// Removes the specified annotation from the collection.
  void remove(PdfAnnotation annot) {
    _helper._doRemove(annot);
  }

  /// Determines whether a specified annotation is in the annotation collection.
  bool contains(PdfAnnotation annotation) {
    return _helper.contains(annotation);
  }

  /// Flatten all the annotations.
  ///
  /// The flatten will add at the time of saving the current document.
  void flattenAllAnnotations() {
    _helper.setFlattenAll(true);
  }
}

/// [PdfAnnotationCollection] helper
class PdfAnnotationCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfAnnotationCollectionHelper(this.base, this.page) : super(base);
  PdfAnnotationCollectionHelper._(this.base, this.page) : super(base) {
    for (int i = 0;
        i < PdfPageHelper.getHelper(page).terminalAnnotation.length;
        ++i) {
      final PdfAnnotation? annot = _getAnnotation(i);
      if (annot != null) {
        final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(annot);
        helper.isOldAnnotation = true;
        _doAdd(annot);
        helper.isOldAnnotation = false;
      }
    }
  }

  /// internal field
  IPdfPrimitive? element;

  /// internal field
  late PdfAnnotationCollection base;

  /// internal field
  PdfArray annotations = PdfArray();

  /// internal field
  bool flatten = false;

  /// internal field
  late PdfPage page;

  /// Gets the annotations array.
  PdfArray get internalAnnotations => annotations;
  set internalAnnotations(PdfArray? value) {
    if (value != null) {
      annotations = value;
    }
  }

  /// internal method
  PdfArray? rearrange(PdfReference reference, int tabIndex, int index) {
    final PdfArray? annots = PdfPageHelper.getHelper(page)
        .crossTable!
        .getObject(PdfPageHelper.getHelper(page)
            .dictionary![PdfDictionaryProperties.annots]) as PdfArray?;
    if (annots != null) {
      if (tabIndex > annots.count) {
        tabIndex = 0;
      }
      if (index >= annots.count) {
        index =
            PdfPageHelper.getHelper(page).annotsReference.indexOf(reference);
      }
      final IPdfPrimitive? annotReference = annots.elements[index];
      if (annotReference != null && annotReference is PdfReferenceHolder) {
        final IPdfPrimitive? annotObject = annotReference.object;
        if (annotObject != null &&
            annotObject is PdfDictionary &&
            annotObject.containsKey(PdfDictionaryProperties.parent)) {
          final IPdfPrimitive? annotParent =
              annotObject[PdfDictionaryProperties.parent];
          if (annotReference.reference == reference ||
              (annotParent != null &&
                  annotParent is PdfReferenceHolder &&
                  reference == annotParent.reference)) {
            final IPdfPrimitive? temp = annots[index];
            if (temp != null) {
              annots.elements[index] = annots[tabIndex];
              annots.elements[tabIndex] = temp;
            }
          }
        }
      }
    }
    return annots;
  }

  /// Sets the annotation flatten.
  void setFlattenAll(bool value) {
    flatten = value;
    if (flatten && PdfPageHelper.getHelper(page).document != null) {
      final PdfCrossTable? cross = PdfPageHelper.getHelper(page).crossTable;
      if (cross != null &&
          PdfPageHelper.getHelper(page)
              .dictionary!
              .containsKey(PdfDictionaryProperties.annots)) {
        final PdfArray? annots = cross.getObject(PdfPageHelper.getHelper(page)
            .dictionary![PdfDictionaryProperties.annots]) as PdfArray?;
        if (annots != null) {
          for (int count = 0; count < annots.count; ++count) {
            final PdfDictionary? annotDicrionary =
                cross.getObject(annots[count]) as PdfDictionary?;
            if (annotDicrionary != null) {
              if (annotDicrionary.containsKey(PdfDictionaryProperties.ft)) {
                annotDicrionary.remove(PdfDictionaryProperties.ft);
              }
              if (annotDicrionary.containsKey(PdfDictionaryProperties.v)) {
                annotDicrionary.remove(PdfDictionaryProperties.v);
              }
            }
          }
        }
      }
    }
  }

  /// internal method
  PdfAnnotation getValue(int index) {
    if (index < 0 || index >= base.count) {
      throw ArgumentError('$index, Index is out of range.');
    }
    final PdfAnnotation annotation = list[index] as PdfAnnotation;
    if (!PdfPageHelper.getHelper(page).isLoadedPage) {
      return annotation;
    } else {
      PdfAnnotationHelper.getHelper(annotation).isLoadedAnnotation
          ? PdfAnnotationHelper.getHelper(annotation).page = page
          : PdfAnnotationHelper.getHelper(annotation).setPage(page);
    }
    return annotation;
  }

  // implementation
  int _doAdd(PdfAnnotation annot) {
    if (flatten) {
      PdfAnnotationHelper.getHelper(annot).flatten = true;
    }
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    if (!PdfAnnotationHelper.getHelper(annot).isLoadedAnnotation &&
        annot is PdfTextMarkupAnnotation) {
      PdfTextMarkupAnnotationHelper.getHelper(annot).setQuadPoints(page.size);
    }
    if (PdfPageHelper.getHelper(page).isLoadedPage) {
      PdfArray? array;
      final PdfDictionary dictionary =
          PdfPageHelper.getHelper(page).dictionary!;
      if (dictionary.containsKey(PdfDictionaryProperties.annots)) {
        array = PdfCrossTable.dereference(
            dictionary[PdfDictionaryProperties.annots]) as PdfArray?;
      }
      array ??= PdfArray();
      final PdfReferenceHolder reference =
          PdfReferenceHolder(PdfAnnotationHelper.getHelper(annot).dictionary);
      if (!PdfAnnotationHelper.getHelper(annot).isOldAnnotation &&
          !_checkPresence(array, reference)) {
        array.add(reference);
        dictionary.setProperty(PdfDictionaryProperties.annots, array);
      }
    }
    final IPdfPrimitive? tempElement = IPdfWrapper.getElement(annot);
    if (tempElement == null) {
      IPdfWrapper.setElement(
          annot, PdfAnnotationHelper.getHelper(annot).dictionary);
    }
    annotations.add(PdfReferenceHolder(annot));
    list.add(annot);
    return base.count - 1;
  }

  bool _checkPresence(PdfArray array, PdfReferenceHolder reference) {
    bool result = false;
    result = array.contains(reference);
    if (!result) {
      for (int i = 0; i < array.elements.length; i++) {
        if (array.elements[i] is PdfReferenceHolder) {
          final PdfReferenceHolder holder =
              array.elements[i]! as PdfReferenceHolder;
          if (holder.object == reference.object) {
            result = true;
            break;
          }
        }
      }
    }
    return result;
  }

  void _doRemove(PdfAnnotation annot) {
    if (PdfPageHelper.getHelper(page).isLoadedPage) {
      _removeFromDictionaries(annot);
    }
    final int index = list.indexOf(annot);
    annotations.elements.removeAt(index);
    list.removeAt(index);
  }

  void _removeFromDictionaries(PdfAnnotation annot) {
    final PdfDictionary pageDic = PdfPageHelper.getHelper(page).dictionary!;
    PdfArray? annots;
    if (pageDic.containsKey(PdfDictionaryProperties.annots)) {
      annots = PdfPageHelper.getHelper(page)
          .crossTable!
          .getObject(pageDic[PdfDictionaryProperties.annots]) as PdfArray?;
    } else {
      annots = PdfArray();
    }
    if (PdfAnnotationHelper.getHelper(annot)
        .dictionary!
        .containsKey(PdfDictionaryProperties.popup)) {
      final IPdfPrimitive? popUpDictionary =
          (PdfAnnotationHelper.getHelper(annot)
                      .dictionary![PdfName(PdfDictionaryProperties.popup)]
                  is PdfReferenceHolder)
              ? (PdfAnnotationHelper.getHelper(annot)
                          .dictionary![PdfName(PdfDictionaryProperties.popup)]!
                      as PdfReferenceHolder)
                  .object
              : PdfAnnotationHelper.getHelper(annot)
                  .dictionary![PdfName(PdfDictionaryProperties.popup)];
      if (popUpDictionary is PdfDictionary) {
        for (int i = 0; i < annots!.count; i++) {
          if (popUpDictionary ==
              PdfPageHelper.getHelper(page).crossTable!.getObject(annots[i])
                  as PdfDictionary?) {
            annots.elements.removeAt(i);
            annots.changed = true;
            break;
          }
        }
        final IPdfPrimitive popUpObj = PdfPageHelper.getHelper(page)
            .crossTable!
            .getObject(popUpDictionary)!;
        final int? popUpIndex =
            PdfPageHelper.getHelper(page).crossTable!.items!.lookFor(popUpObj);
        if (popUpIndex != null && popUpIndex != -1) {
          PdfPageHelper.getHelper(page)
              .crossTable!
              .items!
              .objectCollection!
              .removeAt(popUpIndex);
        }
        _removeAllReference(popUpObj);
        PdfPageHelper.getHelper(page)
            .terminalAnnotation
            .remove(popUpDictionary);
      }
    }
    for (int i = 0; i < annots!.count; i++) {
      if (PdfAnnotationHelper.getHelper(annot).dictionary ==
          PdfPageHelper.getHelper(page).crossTable!.getObject(annots[i])
              as PdfDictionary?) {
        annots.elements.removeAt(i);
        annots.changed = true;
        break;
      }
    }
    PdfAnnotationHelper.getHelper(annot).dictionary!.changed = false;
    PdfPageHelper.getHelper(page)
        .dictionary!
        .setProperty(PdfDictionaryProperties.annots, annots);
  }

  void _removeAllReference(IPdfPrimitive obj) {
    final IPdfPrimitive? dictionary =
        obj is PdfReferenceHolder ? obj.object : obj;
    if (dictionary is PdfDictionary) {
      dictionary.items!.forEach((PdfName? k, IPdfPrimitive? v) {
        if ((v is PdfReferenceHolder || v is PdfDictionary) &&
            k!.name != PdfDictionaryProperties.p &&
            k.name != PdfDictionaryProperties.parent) {
          final IPdfPrimitive newobj =
              PdfPageHelper.getHelper(page).crossTable!.getObject(v)!;
          final int? index =
              PdfPageHelper.getHelper(page).crossTable!.items!.lookFor(newobj);
          if (index != null && index != -1) {
            PdfPageHelper.getHelper(page)
                .crossTable!
                .items!
                .objectCollection!
                .removeAt(index);
          }
          _removeAllReference(v!);
          (PdfCrossTable.dereference(v)! as PdfStream)
            ..dispose()
            ..changed = false;
        }
      });
    }
  }

  // Gets the annotation.
  PdfAnnotation? _getAnnotation(int index) {
    final PdfDictionary dictionary =
        PdfPageHelper.getHelper(page).terminalAnnotation[index];
    final PdfCrossTable? crossTable = PdfPageHelper.getHelper(page).crossTable;
    PdfAnnotation? annot;
    if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
      final PdfName name = PdfAnnotationHelper.getValue(
              dictionary, crossTable, PdfDictionaryProperties.subtype, true)!
          as PdfName;
      final PdfAnnotationTypes type =
          _getAnnotationType(name, dictionary, crossTable);
      final PdfArray? rectValue =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.rect])
              as PdfArray?;
      if (rectValue != null) {
        String text = '';
        if (dictionary.containsKey(PdfDictionaryProperties.contents)) {
          final IPdfPrimitive? str = PdfCrossTable.dereference(
              dictionary[PdfDictionaryProperties.contents]);
          if (str != null && str is PdfString) {
            text = str.value.toString();
          }
        }
        switch (type) {
          case PdfAnnotationTypes.documentLinkAnnotation:
            annot = _createDocumentLinkAnnotation(dictionary, crossTable!);
            break;
          case PdfAnnotationTypes.linkAnnotation:
            if (dictionary.containsKey(PdfDictionaryProperties.a)) {
              final PdfDictionary? remoteLinkDic = PdfCrossTable.dereference(
                  dictionary[PdfDictionaryProperties.a]) as PdfDictionary?;
              if (remoteLinkDic != null &&
                  remoteLinkDic.containsKey(PdfDictionaryProperties.s)) {
                PdfName? gotor;
                gotor = PdfCrossTable.dereference(
                    remoteLinkDic[PdfDictionaryProperties.s]) as PdfName?;
                if (gotor != null && gotor.name == 'URI') {
                  annot = _createLinkAnnotation(dictionary, crossTable!, text);
                }
              }
            } else {
              annot = _createLinkAnnotation(dictionary, crossTable!, text);
            }
            break;
          case PdfAnnotationTypes.lineAnnotation:
            annot = _createLineAnnotation(dictionary, crossTable!, text);
            break;
          case PdfAnnotationTypes.circleAnnotation:
            annot = _createEllipseAnnotation(dictionary, crossTable!, text);
            break;
          case PdfAnnotationTypes.rectangleAnnotation:
            annot = _createRectangleAnnotation(dictionary, crossTable!, text);
            break;
          case PdfAnnotationTypes.polygonAnnotation:
            annot = _createPolygonAnnotation(dictionary, crossTable!, text);
            break;
          case PdfAnnotationTypes.textWebLinkAnnotation:
            annot = _createTextWebLinkAnnotation(dictionary, crossTable!, text);
            break;
          case PdfAnnotationTypes.widgetAnnotation:
            annot = _createWidgetAnnotation(dictionary, crossTable!);
            break;
          case PdfAnnotationTypes.highlight:
          case PdfAnnotationTypes.squiggly:
          case PdfAnnotationTypes.strikeOut:
          case PdfAnnotationTypes.underline:
            annot = _createMarkupAnnotation(dictionary, crossTable!);
            break;
          case PdfAnnotationTypes.popupAnnotation:
            annot = _createPopupAnnotation(dictionary, crossTable!, text);
            break;
          // ignore: no_default_cases
          default:
            break;
        }
        return annot;
      } else {
        return annot;
      }
    }
    return annot;
  }

  /// Gets the type of the annotation.
  PdfAnnotationTypes _getAnnotationType(
      PdfName name, PdfDictionary dictionary, PdfCrossTable? crossTable) {
    final String str = name.name!;
    PdfAnnotationTypes type = PdfAnnotationTypes.noAnnotation;
    switch (str.toLowerCase()) {
      case 'link':
        PdfDictionary? linkDic;
        if (dictionary.containsKey(PdfDictionaryProperties.a)) {
          linkDic =
              PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.a])
                  as PdfDictionary?;
        }
        if (linkDic != null && linkDic.containsKey(PdfDictionaryProperties.s)) {
          name = PdfCrossTable.dereference(linkDic[PdfDictionaryProperties.s])!
              as PdfName;
          final PdfArray? border = (PdfCrossTable.dereference(
                  dictionary[PdfDictionaryProperties.border]) is PdfArray)
              ? PdfCrossTable.dereference(
                  dictionary[PdfDictionaryProperties.border]) as PdfArray?
              : null;
          final bool mType = _findAnnotation(border);
          if (name.name == 'URI') {
            type = PdfAnnotationTypes.linkAnnotation;
            if (!mType) {
              type = PdfAnnotationTypes.linkAnnotation;
            } else {
              type = PdfAnnotationTypes.textWebLinkAnnotation;
            }
          } else if (name.name == 'GoToR') {
            type = PdfAnnotationTypes.linkAnnotation;
          } else if (name.name == 'GoTo') {
            type = PdfAnnotationTypes.documentLinkAnnotation;
          }
        } else if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
          final PdfName? strText = PdfCrossTable.dereference(
              dictionary[PdfDictionaryProperties.subtype]) as PdfName?;
          if (strText != null) {
            switch (strText.name) {
              case 'Link':
                type = PdfAnnotationTypes.documentLinkAnnotation;
                break;
            }
          }
        }
        break;
      case 'line':
        type = PdfAnnotationTypes.lineAnnotation;
        break;
      case 'circle':
        type = PdfAnnotationTypes.circleAnnotation;
        break;
      case 'square':
        type = PdfAnnotationTypes.rectangleAnnotation;
        break;
      case 'polygon':
        type = PdfAnnotationTypes.polygonAnnotation;
        break;
      case 'widget':
        type = PdfAnnotationTypes.widgetAnnotation;
        break;
      case 'highlight':
        type = PdfAnnotationTypes.highlight;
        break;
      case 'underline':
        type = PdfAnnotationTypes.underline;
        break;
      case 'strikeout':
        type = PdfAnnotationTypes.strikeOut;
        break;
      case 'squiggly':
        type = PdfAnnotationTypes.squiggly;
        break;
      case 'text':
        if (!dictionary.containsKey(PdfDictionaryProperties.irt)) {
          type = PdfAnnotationTypes.popupAnnotation;
        }
        break;
      default:
        break;
    }
    return type;
  }

  // Creates the file link annotation.
  PdfAnnotation _createDocumentLinkAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfAnnotation annot =
        PdfDocumentLinkAnnotationHelper.load(dictionary, crossTable);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    PdfAnnotationHelper.getHelper(annot).page = page;
    return annot;
  }

  PdfAnnotation _createLinkAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfUriAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    return annot;
  }

  // Creates the Line Annotation.
  PdfAnnotation _createLineAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfLineAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    PdfAnnotationHelper.getHelper(annot).page = page;
    return annot;
  }

  // Creates the Ellipse Annotation.
  PdfAnnotation _createEllipseAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfEllipseAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    PdfAnnotationHelper.getHelper(annot).page = page;
    return annot;
  }

  // Creates the Rectangle Annotation.
  PdfAnnotation _createRectangleAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfRectangleAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    PdfAnnotationHelper.getHelper(annot).page = page;
    return annot;
  }

  // Creates the Polygon Annotation.
  PdfAnnotation _createPolygonAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfPolygonAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    PdfAnnotationHelper.getHelper(annot).page = page;
    return annot;
  }

  PdfAnnotation _createTextWebLinkAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfTextWebLinkHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    return annot;
  }

  //Creates the widget annotation.
  PdfAnnotation _createWidgetAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfAnnotation annot =
        WidgetAnnotationHelper.load(dictionary, crossTable);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    return annot;
  }

  /// Creates the Markup Annotation.
  PdfAnnotation _createMarkupAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfAnnotation annot =
        PdfTextMarkupAnnotationHelper.load(dictionary, crossTable);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    return annot;
  }

  PdfAnnotation _createPopupAnnotation(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfPopupAnnotationHelper.load(dictionary, crossTable, text);
    PdfAnnotationHelper.getHelper(annot).setPage(page);
    return annot;
  }

  bool _findAnnotation(PdfArray? arr) {
    if (arr == null) {
      return false;
    }
    for (int i = 0; i < arr.count; i++) {
      if (arr[i] is PdfArray) {
        final PdfArray temp = arr[i]! as PdfArray;
        for (int j = 0; j < temp.count; j++) {
          final PdfNumber? value =
              (temp[j] is PdfNumber) ? temp[j] as PdfNumber? : null;
          int? val = 0;
          if (value != null) {
            val = value.value as int?;
          }
          if (val! > 0) {
            return false;
          }
        }
      } else {
        int val = 0;
        final PdfNumber? value =
            (arr[i] is PdfNumber) ? arr[i] as PdfNumber? : null;
        if (value != null) {
          val = value.value!.toInt();
        }
        if (val > 0) {
          return false;
        }
      }
    }
    return true;
  }

  /// internal method
  bool contains(PdfAnnotation annotation) {
    return list.contains(annotation);
  }

  /// internal method
  static PdfAnnotationCollectionHelper getHelper(
      PdfAnnotationCollection annotationCollection) {
    return annotationCollection._helper;
  }

  /// internal method
  static PdfAnnotationCollection load(PdfPage page) {
    return PdfAnnotationCollection._(page);
  }
}
