import '../../interfaces/pdf_interface.dart';
import '../graphics/figures/pdf_template.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import 'pdf_annotation.dart';

/// Represents the appearance of an annotation.
class PdfAppearance implements IPdfWrapper {
  // Constructor
  /// Initializes a instance of the [PdfAppearance] class.
  PdfAppearance(PdfAnnotation annotation) : super() {
    _annotation = annotation;
  }

  // Fields
  final PdfAppearanceHelper _helper = PdfAppearanceHelper();
  late PdfAnnotation _annotation;

  // Properties
  /// Gets PdfTmplate object which applied to annotation in normal state.
  PdfTemplate get normal {
    if (_helper.templateNormal == null) {
      _helper.templateNormal = PdfTemplate(
          _annotation.bounds.size.width, _annotation.bounds.size.height);
      _helper.dictionary!.setProperty(PdfDictionaryProperties.n,
          PdfReferenceHolder(_helper.templateNormal));
    }
    return _helper.templateNormal!;
  }

  /// Sets PdfTmplate object which applied to annotation in normal state.
  set normal(PdfTemplate value) {
    if (_helper.templateNormal != value) {
      _helper.templateNormal = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.n,
          PdfReferenceHolder(_helper.templateNormal));
    }
  }

  /// Gets or sets [PdfTemplate] object which applied to an annotation when mouse button is pressed.
  PdfTemplate get pressed {
    if (_helper.templatePressed == null) {
      _helper.templatePressed =
          PdfTemplate(_annotation.bounds.width, _annotation.bounds.height);
      _helper.dictionary!.setProperty(PdfDictionaryProperties.d,
          PdfReferenceHolder(_helper.templatePressed));
    }
    return _helper.templatePressed!;
  }

  set pressed(PdfTemplate value) {
    if (value != _helper.templatePressed) {
      _helper.templatePressed = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.d,
          PdfReferenceHolder(_helper.templatePressed));
    }
  }
}

/// [PdfAppearance] helper
class PdfAppearanceHelper {
  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  PdfTemplate? templateNormal;

  /// internal field
  PdfTemplate? templatePressed;

  /// internal property
  IPdfPrimitive? get element => dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }

  /// internal method
  static PdfAppearanceHelper getHelper(PdfAppearance appearance) {
    return appearance._helper;
  }
}
