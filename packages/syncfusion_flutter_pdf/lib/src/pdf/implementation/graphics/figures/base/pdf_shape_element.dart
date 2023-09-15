import '../../../drawing/drawing.dart';
import '../../brushes/pdf_solid_brush.dart';
import '../../images/pdf_bitmap.dart';
import '../../images/pdf_image.dart';
import '../../pdf_pen.dart';
import '../../pdf_pens.dart';
import '../pdf_bezier_curve.dart';
import '../pdf_path.dart';
import 'element_layouter.dart';
import 'layout_element.dart';
import 'shape_layouter.dart';
import 'text_layouter.dart';

/// Base class for the main shapes.
abstract class PdfShapeElement extends PdfLayoutElement {
  // fields
  final PdfShapeElementHelper _helper = PdfShapeElementHelper();

  // properties
  /// Gets a pen that will be used to draw the element.
  PdfPen get pen {
    _helper.pen ??= PdfPens.black;
    return _helper.pen!;
  }

  /// Sets a pen that will be used to draw the element.
  set pen(PdfPen value) {
    _helper.pen = value;
  }

  // implementation
  PdfPen _obtainPen() {
    return (_helper.pen == null) ? PdfPens.black : _helper.pen!;
  }

  PdfLayoutResult? _layout(PdfLayoutParams param) {
    final ShapeLayouter layouter = ShapeLayouter(this);
    final PdfLayoutResult? result = layouter.layout(param);
    return result;
  }

  PdfRectangle? _getBoundsInternal() {
    if (this is PdfBezierCurve) {
      return PdfBezierCurveHelper.getHelper(this as PdfBezierCurve)
          .getBoundsInternal();
    } else if (this is PdfPath) {
      return PdfPathHelper.getHelper(this as PdfPath).getBoundsInternal();
    } else if (this is PdfImage) {
      return PdfBitmapHelper.getHelper(this as PdfBitmap).getBoundsInternal();
    }
    return null;
  }
}

/// [PdfShapeElement] helper
class PdfShapeElementHelper {
  /// internal constructor
  PdfShapeElementHelper();

  /// internal method
  static PdfShapeElementHelper getHelper(PdfShapeElement base) {
    return base._helper;
  }

  /// internal field
  PdfPen? pen;

  /// internal field
  PdfBrush? brush;

  /// internal method
  static PdfPen obtainPen(PdfShapeElement element) {
    return element._obtainPen();
  }

  /// internal method
  static PdfLayoutResult? layout(
      PdfShapeElement element, PdfLayoutParams param) {
    return element._layout(param);
  }

  /// internal method
  static PdfRectangle? getBoundsInternal(PdfShapeElement element) {
    return element._getBoundsInternal();
  }
}
