import '../../../interfaces/pdf_interface.dart';
import '../../graphics/figures/pdf_template.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_reference_holder.dart';

/// Represents the states of an annotation's appearance.
class PdfAppearanceState implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfAppearanceState] class.
  PdfAppearanceState() : super() {
    dictionary = PdfDictionary();
    dictionary!.beginSave = _dictionaryBeginSave;
  }

  //Fields
  /// internal fields
  PdfDictionary? dictionary;
  PdfTemplate? _on;
  PdfTemplate? _off;

  /// internal fields
  // ignore: prefer_final_fields
  String onMappingName = PdfDictionaryProperties.yes;
  static const String _offMappingName = PdfDictionaryProperties.off;

  //Properties
  /// Gets the active state template.
  PdfTemplate? get activate => _on;

  /// Sets the active state template.
  set activate(PdfTemplate? value) {
    if (value != _on) {
      _on = value;
    }
  }

  /// Gets or sets the inactive state.
  PdfTemplate? get off => _off;
  set off(PdfTemplate? value) {
    if (value != _off) {
      _off = value;
    }
  }

  //Implementation
  void _dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (_on != null) {
      dictionary!.setProperty(onMappingName, PdfReferenceHolder(_on));
    }
    if (_off != null) {
      dictionary!.setProperty(_offMappingName, PdfReferenceHolder(_off));
    }
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }
}
