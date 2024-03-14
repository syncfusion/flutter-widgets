import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../pages/pdf_page.dart';
import '../../../structured_elements/grid/pdf_grid.dart';
import '../../../structured_elements/lists/pdf_list.dart';
import '../../images/pdf_bitmap.dart';
import '../../images/pdf_image.dart';
import '../../pdf_graphics.dart';
import '../pdf_bezier_curve.dart';
import '../pdf_path.dart';
import '../pdf_text_element.dart';
import 'element_layouter.dart';
import 'pdf_shape_element.dart';
import 'text_layouter.dart';

/// Represents the base class for all elements that can be layout on the pages.
abstract class PdfLayoutElement {
  //Constructor
  /// Initializes a insteace of the [PdfLayoutElement] class.
  PdfLayoutElement() {
    _helper = PdfLayoutElementHelper(this);
  }

  //Properties
  late PdfLayoutElementHelper _helper;

  //Public methods
  /// Draws an element on the graphics or page.
  ///
  /// If both graphics and page provide in the arguments
  /// then page takes more precedence than graphics
  PdfLayoutResult? draw(
      {PdfGraphics? graphics,
      PdfPage? page,
      Rect? bounds,
      PdfLayoutFormat? format}) {
    return _draw(graphics, page, bounds, format);
  }

  //Implementation

  PdfLayoutResult? _draw(PdfGraphics? graphics, PdfPage? page, Rect? bounds,
      PdfLayoutFormat? format) {
    if (page != null) {
      final PdfLayoutParams param = PdfLayoutParams();
      param.page = page;
      param.bounds =
          bounds != null ? PdfRectangle.fromRect(bounds) : PdfRectangle.empty;
      param.format = (format != null) ? format : PdfLayoutFormat();
      return _helper.layout(param);
    } else if (graphics != null) {
      final PdfRectangle rectangle =
          bounds != null ? PdfRectangle.fromRect(bounds) : PdfRectangle.empty;
      if (rectangle.x != 0 || rectangle.y != 0) {
        final PdfGraphicsState gState = graphics.save();
        graphics.translateTransform(rectangle.x, rectangle.y);
        rectangle.x = 0;
        rectangle.y = 0;
        _helper.drawInternal(graphics, rectangle);
        graphics.restore(gState);
      } else {
        _helper.drawInternal(graphics, rectangle);
      }
      return null;
    } else {
      return null;
    }
  }

  //Events
  /// Raises before the element should be printed on the page.
  BeginPageLayoutCallback? beginPageLayout;

  /// Raises after the element was printed on the page.
  EndPageLayoutCallback? endPageLayout;
}

/// [PdfLayoutElement] helper
class PdfLayoutElementHelper {
  /// internal constructor
  PdfLayoutElementHelper(this.base);

  /// internal field
  PdfLayoutElement base;

  /// internal method
  static PdfLayoutElementHelper getHelper(PdfLayoutElement base) {
    return base._helper;
  }

  /// internal property
  bool get raiseBeginPageLayout => base.beginPageLayout != null;

  /// internal property
  bool get raisePageLayouted => base.endPageLayout != null;

  /// internal method
  PdfLayoutResult? layout(PdfLayoutParams param) {
    if (base is PdfShapeElement) {
      return PdfShapeElementHelper.layout(base as PdfShapeElement, param);
    } else if (base is PdfTextElement) {
      return PdfTextElementHelper.getHelper(base as PdfTextElement)
          .layout(param);
    } else if (base is PdfList) {
      return PdfListHelper.getHelper(base as PdfList).layout(param);
    } else if (base is PdfGrid) {
      return PdfGridHelper.getHelper(base as PdfGrid).layout(param);
    }
    return null;
  }

  /// internal method
  void onBeginPageLayout(BeginPageLayoutArgs e) {
    if (base.beginPageLayout != null) {
      base.beginPageLayout!(base, e);
    }
  }

  /// internal method
  void onEndPageLayout(EndPageLayoutArgs e) {
    if (base.endPageLayout != null) {
      base.endPageLayout!(base, e);
    }
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    if (base is PdfBezierCurve) {
      PdfBezierCurveHelper.getHelper(base as PdfBezierCurve)
          .drawInternal(graphics, bounds);
    } else if (base is PdfPath) {
      PdfPathHelper.getHelper(base as PdfPath).drawInternal(graphics, bounds);
    } else if (base is PdfTextElement) {
      PdfTextElementHelper.getHelper(base as PdfTextElement)
          .drawInternal(graphics, bounds);
    } else if (base is PdfImage) {
      PdfBitmapHelper.getHelper(base as PdfBitmap)
          .drawInternal(graphics, bounds);
    } else if (base is PdfList) {
      PdfListHelper.getHelper(base as PdfList).drawInternal(graphics, bounds);
    } else if (base is PdfGrid) {
      PdfGridHelper.getHelper(base as PdfGrid).drawInternal(graphics, bounds);
    }
  }
}

/// Represents the base class for classes that contain event data, and provides
/// a value to use for events, once completed the text lay outing on the page.
class EndTextPageLayoutArgs extends EndPageLayoutArgs {
  /// Initializes a new instance of the [EndTextPageLayoutArgs] class
  /// with the specified [PdfTextLayoutResult].
  EndTextPageLayoutArgs(PdfTextLayoutResult super.result);
}

/// Provides data for event once lay outing completed on the new page.
class EndPageLayoutArgs extends PdfCancelArgs {
  //Constructor
  /// Initialize an instance of [EndPageLayoutArgs].
  EndPageLayoutArgs(PdfLayoutResult result) {
    _result = result;
  }

  //Fields
  /// The next page for lay outing.
  PdfPage? nextPage;
  late PdfLayoutResult _result;

  //Properties
  /// Gets the lay outing result of the page.
  PdfLayoutResult get result => _result;
}

/// Provides data for event before lay outing the new page.
class BeginPageLayoutArgs extends PdfCancelArgs {
  //Constructor
  /// Initialize an instance of [BeginPageLayoutArgs].
  BeginPageLayoutArgs(Rect bounds, PdfPage page) {
    _bounds = PdfRectangle.fromRect(bounds);
    _page = page;
  }

  //Fields
  /// The bounds of the lay outing on the page.
  late PdfRectangle _bounds;
  late PdfPage _page;

  //Properties
  /// Gets the page where the lay outing should start.
  PdfPage get page => _page;

  /// The bounds of the lay outing on the page.
  Rect get bounds => _bounds.rect;

  /// Sets value that indicates the lay outing bounds on the page.
  set bounds(Rect value) {
    _bounds = PdfRectangle.fromRect(value);
  }
}

/// Provides the data for a cancelable event.
class PdfCancelArgs {
  ///The value indicating whether this [PdfCancelArgs] is cancel.
  bool cancel = false;
}

/// Represents the method that will handle an event
/// that before lay outing on the page.
typedef BeginPageLayoutCallback = void Function(
    Object sender, BeginPageLayoutArgs args);

/// Represents the method that will handle an event,
/// once completed the lay outing on the page.
typedef EndPageLayoutCallback = void Function(
    Object sender, EndPageLayoutArgs args);
