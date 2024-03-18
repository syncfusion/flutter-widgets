import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../actions/pdf_action.dart';
import '../graphics/pdf_color.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_border.dart';

/// Represents the base class for the link annotations.
abstract class PdfLinkAnnotation extends PdfAnnotation implements IPdfWrapper {
  // fields
  PdfHighlightMode _highlightMode = PdfHighlightMode.noHighlighting;
  PdfAction? _action;

  //properties
  /// Gets or sets the highlight mode of the link annotation.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create document link annotation and add to the PDF page.
  /// document.pages.add()
  ///   ..annotations.add(PdfDocumentLinkAnnotation(Rect.fromLTWH(10, 40, 30, 30),
  ///       PdfDestination(document.pages.add(), Offset(10, 0)))
  ///     ..highlightMode = PdfHighlightMode.outline);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfHighlightMode get highlightMode =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _obtainHighlightMode()
          : _highlightMode;
  set highlightMode(PdfHighlightMode value) {
    _highlightMode = value;
    final String mode = _getHighlightMode(_highlightMode);
    PdfAnnotationHelper.getHelper(this)
        .dictionary!
        .setName(PdfName(PdfDictionaryProperties.h), mode);
  }

  String _getHighlightMode(PdfHighlightMode mode) {
    String hightlightMode = 'N';
    switch (mode) {
      case PdfHighlightMode.invert:
        hightlightMode = 'I';
        break;
      case PdfHighlightMode.noHighlighting:
        hightlightMode = 'N';
        break;
      case PdfHighlightMode.outline:
        hightlightMode = 'O';
        break;
      case PdfHighlightMode.push:
        hightlightMode = 'P';
        break;
    }
    return hightlightMode;
  }

  PdfHighlightMode _obtainHighlightMode() {
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (PdfAnnotationHelper.getHelper(this)
        .dictionary!
        .containsKey(PdfDictionaryProperties.h)) {
      final PdfName name = PdfAnnotationHelper.getHelper(this)
          .dictionary![PdfDictionaryProperties.h]! as PdfName;
      switch (name.name) {
        case 'I':
          mode = PdfHighlightMode.invert;
          break;
        case 'N':
          mode = PdfHighlightMode.noHighlighting;
          break;
        case 'O':
          mode = PdfHighlightMode.outline;
          break;
        case 'P':
          mode = PdfHighlightMode.push;
          break;
      }
    }
    return mode;
  }
}

/// [PdfLinkAnnotation] helper
class PdfLinkAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  PdfLinkAnnotationHelper(
      PdfLinkAnnotation super.linkAnnotation, Rect? bounds) {
    initializeAnnotation(bounds: bounds);
    dictionary!.setProperty(PdfName(PdfDictionaryProperties.subtype),
        PdfName(PdfDictionaryProperties.link));
  }

  /// internal constructor
  PdfLinkAnnotationHelper.load(PdfLinkAnnotation super.linkAnnotation,
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    initializeExistingAnnotation(dictionary, crossTable);
  }
}

/// Represents base class for link annotations with associated action.
abstract class PdfActionLinkAnnotation extends PdfLinkAnnotation {
  // properties
  /// Gets or sets the action for the link annotation.
  PdfAction? get action => _action;
  set action(PdfAction? value) {
    if (value != null) {
      _action = value;
    }
  }
}

/// [PdfActionLinkAnnotation] helper
class PdfActionLinkAnnotationHelper extends PdfLinkAnnotationHelper {
  /// internal constructor
  PdfActionLinkAnnotationHelper(
      PdfActionLinkAnnotation actionLinkAnnotation, Rect bounds,
      [PdfAction? action])
      : super(actionLinkAnnotation, bounds) {
    if (action != null) {
      actionLinkAnnotation._action = action;
    }
  }

  /// internal constructor
  PdfActionLinkAnnotationHelper.load(
      PdfActionLinkAnnotation super.actionLinkAnnotation,
      super.dictionary,
      super.crossTable)
      : super.load();
}

/// Represents the annotation with associated action.
class PdfActionAnnotation extends PdfActionLinkAnnotation {
  // constructor
  /// Initializes a new instance of the
  /// [PdfActionAnnotation] class with specified bounds and action.
  PdfActionAnnotation(Rect bounds, PdfAction action) {
    _helper = PdfActionAnnotationHelper(this, bounds, action);
  }
  late PdfActionAnnotationHelper _helper;

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
}

/// [PdfActionAnnotation] helper
class PdfActionAnnotationHelper extends PdfActionLinkAnnotationHelper {
  /// internal method
  PdfActionAnnotationHelper(
      this.actionAnnotation, Rect bounds, PdfAction action)
      : super(actionAnnotation, bounds, action);

  /// internal method
  PdfActionAnnotation actionAnnotation;

  /// internal method
  static PdfActionAnnotationHelper getHelper(PdfActionAnnotation base) {
    return base._helper;
  }

  /// internal method
  void save() {
    dictionary!.setProperty(PdfName(PdfDictionaryProperties.a),
        IPdfWrapper.getElement(actionAnnotation.action!));
  }

  /// internal method
  @override
  IPdfPrimitive? element;
}
