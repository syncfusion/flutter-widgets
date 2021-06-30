part of pdf;

/// Represents a brush that fills any object with a solid color.
class PdfSolidBrush implements PdfBrush {
  //Constructor
  /// Initializes a new instance of the [PdfSolidBrush] class.
  PdfSolidBrush(this.color);

  //Fields
  final PdfColorSpace _colorSpace = PdfColorSpace.rgb;

  /// Indicates the color of the [PdfSolidBrush].
  late PdfColor color;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfSolidBrush && color == other.color;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => color.hashCode;

  @override
  bool _monitorChanges(
      PdfBrush? brush,
      _PdfStreamWriter? streamWriter,
      Function? getResources,
      bool saveChanges,
      PdfColorSpace? currentColorSpace) {
    bool diff = false;
    if (getResources != null && streamWriter != null) {
      if (brush == null) {
        diff = true;
        streamWriter._setColorAndSpace(color, currentColorSpace, false);
      } else if (brush != this) {
        final PdfSolidBrush solidBrush = brush as PdfSolidBrush;
        if (brush is PdfSolidBrush) {
          if (solidBrush.color != color ||
              solidBrush._colorSpace != currentColorSpace) {
            diff = true;
            streamWriter._setColorAndSpace(color, currentColorSpace, false);
          } else if (solidBrush._colorSpace == currentColorSpace &&
              currentColorSpace == PdfColorSpace.rgb) {
            diff = true;
            streamWriter._setColorAndSpace(color, currentColorSpace, false);
          }
        } else {
          brush._resetChanges(streamWriter);
          streamWriter._setColorAndSpace(color, currentColorSpace, false);
          diff = true;
        }
      }
    }
    return diff;
  }

  void _resetChanges(_PdfStreamWriter streamWriter) {
    streamWriter._setColorAndSpace(PdfColor(0, 0, 0), PdfColorSpace.rgb, false);
  }
}
