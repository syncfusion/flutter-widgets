import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import 'enums.dart';

/// internal class
class PdfTransparency implements IPdfWrapper {
  //Constructor
  /// internal constructor
  PdfTransparency(double stroke, double fill, PdfBlendMode mode,
      {bool conformance = false}) {
    dictionary = PdfDictionary();
    if (stroke < 0) {
      throw ArgumentError.value(
          stroke, 'stroke', 'The value cannot be less then zero.');
    }
    if (fill < 0) {
      throw ArgumentError.value(
          fill, 'fill', 'The value cannot be less then zero.');
    }
    //NOTE : This is needed to attain PDF/A conformance. Since PDF/A1B
    //does not support transparency key.
    if (conformance) {
      stroke = 1;
      fill = 1;
      mode = (mode != PdfBlendMode.normal) ? PdfBlendMode.normal : mode;
    }
    dictionary![PdfDictionaryProperties.stroke] = PdfNumber(stroke);
    dictionary![PdfDictionaryProperties.fill] = PdfNumber(fill);
    dictionary![PdfDictionaryProperties.bm] = PdfName(_getBlendMode(mode));
  }

  //Fields
  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  //Properties
  /// internal property
  double? get stroke => _getNumber(PdfDictionaryProperties.stroke);

  /// internal property
  double? get fill => _getNumber(PdfDictionaryProperties.fill);

  //Implementation
  double? _getNumber(String keyName) {
    double? result = 0;
    if (dictionary!.containsKey(keyName) && dictionary![keyName] is PdfNumber) {
      final PdfNumber numb = dictionary![keyName]! as PdfNumber;
      result = numb.value as double?;
    }
    return result;
  }

  String _getBlendMode(PdfBlendMode mode) {
    switch (mode) {
      case PdfBlendMode.multiply:
        return 'Multiply';
      case PdfBlendMode.screen:
        return 'Screen';
      case PdfBlendMode.overlay:
        return 'Overlay';
      case PdfBlendMode.darken:
        return 'Darken';
      case PdfBlendMode.lighten:
        return 'Lighten';
      case PdfBlendMode.colorDodge:
        return 'ColorDodge';
      case PdfBlendMode.colorBurn:
        return 'ColorBurn';
      case PdfBlendMode.hardLight:
        return 'HardLight';
      case PdfBlendMode.softLight:
        return 'SoftLight';
      case PdfBlendMode.difference:
        return 'Difference';
      case PdfBlendMode.exclusion:
        return 'Exclusion';
      case PdfBlendMode.hue:
        return 'Hue';
      case PdfBlendMode.saturation:
        return 'Saturation';
      case PdfBlendMode.color:
        return 'Color';
      case PdfBlendMode.luminosity:
        return 'Luminosity';
      case PdfBlendMode.normal:
        return 'Normal';
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
