import '../graphics/enums.dart';
import '../graphics/pdf_color.dart';

/// Represents default appearance string.
class PdfDefaultAppearance {
  //Constructor
  /// initialize [PdfDefaultAppearance] object
  PdfDefaultAppearance();

  //Fields
  /// Internal variable to store fore color.
  PdfColor foreColor = PdfColor(0, 0, 0);

  /// Internal variable to store font name.
  String? fontName = '';

  /// Internal variable to store font size.
  double? fontSize = 0;

  //Implementation
  /// internal method
  String getString() {
    return '/$fontName ${fontSize! % 1 == 0 ? fontSize!.toInt() : fontSize} Tf ${PdfColorHelper.getHelper(foreColor).getString(PdfColorSpace.rgb, false)}';
  }
}
