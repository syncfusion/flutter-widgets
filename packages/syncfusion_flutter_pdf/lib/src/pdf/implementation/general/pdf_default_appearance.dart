part of pdf;

/// Represents default appearance string.
class _PdfDefaultAppearance {
  //Constructor
  _PdfDefaultAppearance();

  //Fields
  /// Internal variable to store fore color.
  PdfColor foreColor = PdfColor(0, 0, 0);

  /// Internal variable to store font name.
  String? fontName = '';

  /// Internal variable to store font size.
  double? fontSize = 0;

  //Implementation
  String _toString() {
    return '/$fontName ${fontSize! % 1 == 0 ? fontSize!.toInt() : fontSize} Tf ${foreColor._toString(PdfColorSpace.rgb, false)}';
  }
}
