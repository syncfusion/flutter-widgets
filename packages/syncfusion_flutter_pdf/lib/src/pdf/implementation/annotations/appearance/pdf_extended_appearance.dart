import '../../../interfaces/pdf_interface.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_reference_holder.dart';
import 'pdf_appearance_state.dart';

/// Represents extended appearance of the annotation. It has two states such as On state and Off state.
class PdfExtendedAppearance implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfExtendedAppearance] class.
  PdfExtendedAppearance() : super();

  //Fields
  PdfDictionary? _dictionary = PdfDictionary();
  PdfAppearanceState? _normal;
  PdfAppearanceState? _pressed;
  PdfAppearanceState? _mouseHover;

  //Properties
  /// Gets the normal appearance of the annotation.
  PdfAppearanceState get normal {
    if (_normal == null) {
      _normal = PdfAppearanceState();
      _dictionary!
          .setProperty(PdfDictionaryProperties.n, PdfReferenceHolder(_normal));
    }
    return _normal!;
  }

  /// Gets the appearance when mouse is hovered.
  PdfAppearanceState get mouseHover {
    if (_mouseHover == null) {
      _mouseHover = PdfAppearanceState();
      _dictionary!.setProperty(
          PdfDictionaryProperties.r, PdfReferenceHolder(_mouseHover));
    }
    return _mouseHover!;
  }

  /// Gets the pressed state annotation.
  PdfAppearanceState get pressed {
    if (_pressed == null) {
      _pressed = PdfAppearanceState();
      _dictionary!
          .setProperty(PdfDictionaryProperties.d, PdfReferenceHolder(_pressed));
    }
    return _pressed!;
  }

  /// internal property
  IPdfPrimitive? get element => _dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      _dictionary = value;
    }
  }
}
