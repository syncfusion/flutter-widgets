import '../../drawing/drawing.dart';
import 'pdf_automatic_field.dart';

/// internal class
class PdfAutomaticFieldInfo {
  // constructor
  /// internal constructor
  PdfAutomaticFieldInfo(this.field,
      [PdfPoint? location, double scalingX = 1, double scalingY = 1]) {
    this.location = location ?? PdfPoint.empty;
    scalingX = scalingX;
    scalingY = scalingY;
  }

  /// internal field
  double scalingX = 1;

  /// internal field
  double scalingY = 1;

  /// internal field
  late PdfAutomaticField field;

  /// internal field
  late PdfPoint location;
}
