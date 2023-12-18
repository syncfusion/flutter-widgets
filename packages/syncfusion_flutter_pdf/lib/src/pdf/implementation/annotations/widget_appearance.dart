import '../../interfaces/pdf_interface.dart';
import '../graphics/pdf_color.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';

/// The Syncfusion.Pdf.Interactive namespace contains classes used to create interactive elements.
class WidgetAppearance implements IPdfWrapper {
  /// internal Constructor
  WidgetAppearance() : super() {
    dictionary!.setProperty(
        PdfDictionaryProperties.bc, PdfColorHelper.toArray(_borderColor));
  }

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();
  PdfColor _borderColor = PdfColor(0, 0, 0);
  PdfColor _backColor = PdfColor.empty;
  String? _normalCaption = '';

  //Overrides
  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  //Properties
  /// Gets or sets the color of the border.
  PdfColor get borderColor => _borderColor;
  set borderColor(PdfColor value) {
    if (_borderColor != value) {
      _borderColor = value;
      PdfColorHelper.getHelper(value).alpha == 0
          ? dictionary!
              .setProperty(PdfDictionaryProperties.bc, PdfArray(<int>[]))
          : dictionary!.setProperty(
              PdfDictionaryProperties.bc, PdfColorHelper.toArray(_borderColor));
    }
  }

  /// Gets or sets the color of the background.
  PdfColor get backColor => _backColor;
  set backColor(PdfColor value) {
    if (_backColor != value) {
      _backColor = value;
      if (PdfColorHelper.getHelper(_backColor).alpha == 0) {
        dictionary!
            .setProperty(PdfDictionaryProperties.bc, PdfArray(<int>[0, 0, 0]));
        dictionary!.remove(PdfDictionaryProperties.bg);
      } else {
        dictionary!.setProperty(
            PdfDictionaryProperties.bg, PdfColorHelper.toArray(_backColor));
      }
    }
  }

  /// internal property
  String? get normalCaption => _normalCaption;
  set normalCaption(String? value) {
    if (_normalCaption != value) {
      _normalCaption = value;
      dictionary!.setString(PdfDictionaryProperties.ca, _normalCaption);
    }
  }
}
