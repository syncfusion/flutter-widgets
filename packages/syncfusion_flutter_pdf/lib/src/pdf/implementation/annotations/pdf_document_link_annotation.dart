import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../general/enum.dart';
import '../general/pdf_destination.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'pdf_action_annotation.dart';
import 'pdf_annotation.dart';

/// Represents an annotation object with holds link on
/// another location within a document.
/// ```dart
/// //Create a new Pdf document
/// PdfDocument document = PdfDocument();
/// //Create a document link and add to the PDF page.
/// document.pages.add().annotations.add(PdfDocumentLinkAnnotation(
///     Rect.fromLTWH(10, 40, 30, 30),
///     PdfDestination(document.pages.add(), Offset(10, 0))));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfDocumentLinkAnnotation extends PdfLinkAnnotation {
  // constructor
  /// Initializes new [PdfDocumentLinkAnnotation] instance
  /// with specified bounds and destination.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create a document link and add to the PDF page.
  /// document.pages.add().annotations.add(PdfDocumentLinkAnnotation(
  ///     Rect.fromLTWH(10, 40, 30, 30),
  ///     PdfDestination(document.pages.add(), Offset(10, 0))));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocumentLinkAnnotation(Rect bounds, PdfDestination destination) {
    _helper = PdfDocumentLinkAnnotationHelper(this, bounds);
    this.destination = destination;
  }

  PdfDocumentLinkAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfDocumentLinkAnnotationHelper._(this, dictionary, crossTable);
  }

  // fields
  late PdfDocumentLinkAnnotationHelper _helper;

  // properties
  /// Gets or sets the destination of the annotation.
  ///
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create PDF page.
  /// PdfPage page = document.pages.add();
  /// //Create a document link
  /// PdfDocumentLinkAnnotation documentLinkAnnotation = PdfDocumentLinkAnnotation(
  ///     Rect.fromLTWH(10, 40, 30, 30),
  ///     PdfDestination(document.pages.add(), Offset(10, 0)));
  /// //Gets the destination and set the destination mode.
  /// documentLinkAnnotation.destination!.mode = PdfDestinationMode.fitToPage;
  /// //Add the document link to the page
  /// page.annotations.add(documentLinkAnnotation);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDestination? get destination =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _obtainDestination()
          : _helper.destination;
  set destination(PdfDestination? value) {
    if (value != null) {
      if (value != _helper.destination) {
        _helper.destination = value;
      }
      if (PdfAnnotationHelper.getHelper(this).isLoadedAnnotation) {
        PdfAnnotationHelper.getHelper(this)
            .dictionary!
            .setProperty(PdfDictionaryProperties.dest, value);
      }
    }
  }

  // Gets the destination of the document link annotation
  PdfDestination? _obtainDestination() {
    PdfDestination? dest;
    final PdfDictionary dictionary =
        PdfAnnotationHelper.getHelper(this).dictionary!;
    final PdfCrossTable crossTable =
        PdfAnnotationHelper.getHelper(this).crossTable;
    if (dictionary.containsKey(PdfDictionaryProperties.dest)) {
      final IPdfPrimitive? obj =
          crossTable.getObject(dictionary[PdfDictionaryProperties.dest]);
      PdfArray? array;
      if (obj is PdfArray) {
        array = obj;
      } else if (crossTable.document != null &&
          PdfDocumentHelper.getHelper(crossTable.document!).isLoadedDocument) {
        if (obj is PdfName || obj is PdfString) {
          array = PdfDocumentHelper.getHelper(crossTable.document!)
              .getNamedDestination(obj!);
        }
      }
      PdfPage page;
      if (array != null && array[0] is PdfReferenceHolder) {
        final PdfDictionary? dic = crossTable
            .getObject(array[0]! as PdfReferenceHolder) as PdfDictionary?;
        page = PdfPageCollectionHelper.getHelper(crossTable.document!.pages)
            .getPage(dic);
        final PdfName? mode = array[1] as PdfName?;
        if (mode != null) {
          if (mode.name == 'XYZ') {
            PdfNumber? left;
            PdfNumber? top;
            PdfNumber? zoom;
            if (array[2] is PdfNumber) {
              left = array[2]! as PdfNumber;
            }
            if (array[3] is PdfNumber) {
              top = array[3]! as PdfNumber;
            }
            if (array[4] is PdfNumber) {
              zoom = array[4]! as PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            final double leftValue =
                (left == null) ? 0 : left.value!.toDouble();
            dest = PdfDestination(page, Offset(leftValue, topValue));
            if (zoom != null) {
              dest.zoom = zoom.value!.toDouble();
            }
            dest.mode = PdfDestinationMode.location;
          } else if (mode.name == 'Fit' || mode.name == 'FitV') {
            dest = PdfDestination(page);
            dest.mode = PdfDestinationMode.fitToPage;
          } else if (mode.name == 'FitH') {
            late PdfNumber top;
            if (array[2] is PdfNumber) {
              top = array[2]! as PdfNumber;
            }
            final double topValue = page.size.height - top.value!;
            dest = PdfDestination(page, Offset(0, topValue));
            dest.mode = PdfDestinationMode.fitH;
          } else if (mode.name == 'FitR') {
            if (array.count == 6) {
              final double left = (array[2]! as PdfNumber).value!.toDouble();
              final double top = (array[3]! as PdfNumber).value!.toDouble();
              final double width = (array[4]! as PdfNumber).value!.toDouble();
              final double height = (array[5]! as PdfNumber).value!.toDouble();
              dest = PdfDestinationHelper.getDestination(
                  page, PdfRectangle(left, top, width, height));
              dest.mode = PdfDestinationMode.fitR;
            }
          }
        }
      }
    } else if (dictionary.containsKey(PdfDictionaryProperties.a)) {
      IPdfPrimitive obj =
          crossTable.getObject(dictionary[PdfDictionaryProperties.a])!;
      final PdfDictionary destDic = obj as PdfDictionary;
      obj = destDic[PdfDictionaryProperties.d]!;
      if (obj is PdfReferenceHolder) {
        obj = obj.object!;
      }
      PdfArray? array;
      if (obj is PdfArray) {
        array = obj;
      } else if (crossTable.document != null &&
          PdfDocumentHelper.getHelper(crossTable.document!).isLoadedDocument) {
        if (obj is PdfName || obj is PdfString) {
          array = PdfDocumentHelper.getHelper(crossTable.document!)
              .getNamedDestination(obj);
        }
      }
      if (array != null && array[0] is PdfReferenceHolder) {
        final PdfReferenceHolder holder = array[0]! as PdfReferenceHolder;
        PdfPage? page;
        final IPdfPrimitive? primitiveObj = PdfCrossTable.dereference(holder);
        final PdfDictionary? dic = primitiveObj as PdfDictionary?;
        if (dic != null) {
          page = PdfPageCollectionHelper.getHelper(crossTable.document!.pages)
              .getPage(dic);
        }
        if (page != null) {
          final PdfName mode = array[1]! as PdfName;
          if (mode.name == 'FitBH' || mode.name == 'FitH') {
            PdfNumber? top;
            if (array[2] is PdfNumber) {
              top = array[2]! as PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            dest = PdfDestination(page, Offset(0, topValue));
            dest.mode = PdfDestinationMode.fitH;
          } else if (mode.name == 'XYZ') {
            PdfNumber? left;
            PdfNumber? top;
            PdfNumber? zoom;
            if (array[2] is PdfNumber) {
              left = array[2]! as PdfNumber;
            }
            if (array[3] is PdfNumber) {
              top = array[3]! as PdfNumber;
            }
            if (array[4] is PdfNumber) {
              zoom = array[4]! as PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            final double leftValue =
                (left == null) ? 0 : left.value!.toDouble();
            dest = PdfDestination(page, Offset(leftValue, topValue));
            if (zoom != null) {
              dest.zoom = zoom.value!.toDouble();
            }
            dest.mode = PdfDestinationMode.location;
          } else if (mode.name == 'FitR') {
            if (array.count == 6) {
              final PdfNumber left = array[2]! as PdfNumber;
              final PdfNumber bottom = array[3]! as PdfNumber;
              final PdfNumber right = array[4]! as PdfNumber;
              final PdfNumber top = array[5]! as PdfNumber;
              dest = PdfDestinationHelper.getDestination(
                  page,
                  PdfRectangle(left.value!.toDouble(), bottom.value!.toDouble(),
                      right.value!.toDouble(), top.value!.toDouble()));
              dest.mode = PdfDestinationMode.fitR;
            }
          } else {
            if (mode.name == 'Fit' || mode.name == 'FitV') {
              dest = PdfDestination(page);
              dest.mode = PdfDestinationMode.fitToPage;
            }
          }
        }
      }
    }
    return dest;
  }
}

/// [PdfDocumentLinkAnnotation] helper
class PdfDocumentLinkAnnotationHelper extends PdfLinkAnnotationHelper {
  /// internal constructor
  PdfDocumentLinkAnnotationHelper(this.documentLinkHelper, Rect bounds)
      : super(documentLinkHelper, bounds);
  PdfDocumentLinkAnnotationHelper._(this.documentLinkHelper,
      PdfDictionary dictionary, PdfCrossTable crossTable)
      : super.load(documentLinkHelper, dictionary, crossTable);

  /// internal field
  PdfDocumentLinkAnnotation documentLinkHelper;

  /// internal field
  PdfDestination? destination;

  /// internal field
  @override
  IPdfPrimitive? element;

  /// internal method
  void save() {
    if (destination != null) {
      PdfAnnotationHelper.getHelper(base).dictionary!.setProperty(
          PdfName(PdfDictionaryProperties.dest),
          IPdfWrapper.getElement(destination!));
    }
  }

  /// internal method
  static PdfDocumentLinkAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfDocumentLinkAnnotation._(dictionary, crossTable);
  }

  /// internal method
  static PdfDocumentLinkAnnotationHelper getHelper(
      PdfDocumentLinkAnnotation annotation) {
    return annotation._helper;
  }
}
