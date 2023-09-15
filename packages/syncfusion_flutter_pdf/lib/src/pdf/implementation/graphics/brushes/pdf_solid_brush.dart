import '../../io/pdf_stream_writer.dart';
import '../enums.dart';
import '../pdf_color.dart';

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
      PdfStreamWriter? streamWriter,
      Function? getResources,
      bool saveChanges,
      PdfColorSpace? currentColorSpace) {
    bool diff = false;
    if (getResources != null && streamWriter != null) {
      if (brush == null) {
        diff = true;
        streamWriter.setColorAndSpace(color, currentColorSpace, false);
      } else if (brush != this && brush is PdfSolidBrush) {
        if (brush.color != color || brush._colorSpace != currentColorSpace) {
          diff = true;
          streamWriter.setColorAndSpace(color, currentColorSpace, false);
        } else if (brush._colorSpace == currentColorSpace &&
            currentColorSpace == PdfColorSpace.rgb) {
          diff = true;
          streamWriter.setColorAndSpace(color, currentColorSpace, false);
        }
      }
    }
    return diff;
  }
}

/// Provides objects used to fill the interiors of graphical shapes
/// such as rectangles, ellipses, pies, polygons, and paths.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument doc = PdfDocument();
/// //Create a new PDF solid brush.
/// PdfBrush solidBrush = PdfSolidBrush(PdfColor(1, 0, 0));
/// //Add a page and draw a rectangle using the brush.
/// doc.pages
///     .add()
///     .graphics
///     .drawRectangle(brush: solidBrush,
///     bounds: Rect.fromLTWH(0, 0, 200, 100));
/// //Save the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
abstract class PdfBrush {
  bool _monitorChanges(
      PdfBrush? brush,
      PdfStreamWriter? streamWriter,
      Function? getResources,
      bool saveChanges,
      PdfColorSpace? currentColorSpace);
}

// ignore: avoid_classes_with_only_static_members
/// [PdfBrush] helper
class PdfBrushHelper {
  /// internal method
  static bool monitorChanges(
      PdfBrush base,
      PdfBrush? brush,
      PdfStreamWriter? streamWriter,
      Function? getResources,
      bool saveChanges,
      PdfColorSpace? currentColorSpace) {
    return base._monitorChanges(
        brush, streamWriter, getResources, saveChanges, currentColorSpace);
  }
}
