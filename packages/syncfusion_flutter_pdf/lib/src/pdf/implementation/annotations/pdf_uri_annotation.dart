import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../actions/pdf_action.dart';
import '../actions/pdf_uri_action.dart';
import '../graphics/pdf_color.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_string.dart';
import 'pdf_action_annotation.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_border.dart';

/// Represents the Uri annotation.
class PdfUriAnnotation extends PdfActionLinkAnnotation {
  // constructor
  /// Initializes a new instance of the
  /// [PdfUriAnnotation] class with specified bounds and Uri.
  PdfUriAnnotation({required Rect bounds, required String uri}) {
    _helper = PdfUriAnnotationHelper(this, bounds);
    this.uri = uri;
  }

  PdfUriAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    _helper = PdfUriAnnotationHelper._(this, dictionary, crossTable);
    super.text = text;
  }

  // fields
  String _uri = '';
  late PdfUriAnnotationHelper _helper;

  // properties
  /// Gets the Uri address.
  String get uri {
    if (PdfAnnotationHelper.getHelper(this).isLoadedAnnotation) {
      return _getUriText()!;
    } else {
      return _uri;
    }
  }

  /// Sets the Uri address.
  set uri(String value) {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(this);
    final PdfDictionary tempDictionary = helper.dictionary!;
    if (helper.isLoadedAnnotation) {
      if (_uri != value) {
        _uri = value;
        if (tempDictionary.containsKey(PdfDictionaryProperties.a)) {
          final PdfDictionary? dictionary = PdfCrossTable.dereference(
              tempDictionary[PdfDictionaryProperties.a]) as PdfDictionary?;
          if (dictionary != null) {
            dictionary.setString(PdfDictionaryProperties.uri, _uri);
            dictionary.modify();
          }
        }
      }
    } else {
      _uri = value;
      if (_helper._uriAction!.uri != value) {
        _helper._uriAction!.uri = value;
        if (helper.isLoadedAnnotation) {
          PdfDictionary? dictionary = tempDictionary;
          if (tempDictionary.containsKey(PdfDictionaryProperties.a)) {
            dictionary = PdfCrossTable.dereference(
                tempDictionary[PdfDictionaryProperties.a]) as PdfDictionary?;
            if (dictionary != null) {
              dictionary.setString(PdfDictionaryProperties.uri, _uri);
            }
            tempDictionary.modify();
          }
        }
      }
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

  /// Gets the action.
  @override
  PdfAction? get action => super.action;

  /// Sets the action.
  @override
  set action(PdfAction? value) {
    if (value != null) {
      super.action = value;
      _helper._uriAction!.next = value;
    }
  }

  String? _getUriText() {
    String? uriText = '';
    final PdfDictionary tempDictionary =
        PdfAnnotationHelper.getHelper(this).dictionary!;
    if (tempDictionary.containsKey(PdfDictionaryProperties.a)) {
      final PdfDictionary? dictionary =
          PdfCrossTable.dereference(tempDictionary[PdfDictionaryProperties.a])
              as PdfDictionary?;
      if (dictionary != null &&
          dictionary.containsKey(PdfDictionaryProperties.uri)) {
        final PdfString? tempText =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.uri])
                as PdfString?;
        if (tempText != null) {
          uriText = tempText.value;
        }
      }
    }
    return uriText;
  }
}

/// [PdfUriAnnotation] helper
class PdfUriAnnotationHelper extends PdfActionLinkAnnotationHelper {
  /// internal constructor
  PdfUriAnnotationHelper(this.uriAnnotation, Rect bounds)
      : super(uriAnnotation, bounds) {
    _uriAction ??= PdfUriAction();
    dictionary!.setProperty(PdfName(PdfDictionaryProperties.subtype),
        PdfName(PdfDictionaryProperties.link));
    final IPdfPrimitive? element = IPdfWrapper.getElement(_uriAction!);
    if (element == null) {
      IPdfWrapper.setElement(
          _uriAction!, PdfActionHelper.getHelper(_uriAction!).dictionary);
    }
    dictionary!.setProperty(PdfName(PdfDictionaryProperties.a), element);
  }
  PdfUriAnnotationHelper._(
      this.uriAnnotation, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super.load(uriAnnotation, dictionary, crossTable);

  /// internal field
  late PdfUriAnnotation uriAnnotation;
  PdfUriAction? _uriAction;

  /// internal field
  @override
  IPdfPrimitive? element;

  /// internal method
  static PdfUriAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfUriAnnotation._(dictionary, crossTable, text);
  }

  /// internal method
  static PdfUriAnnotationHelper getHelper(PdfUriAnnotation annotation) {
    return annotation._helper;
  }
}
