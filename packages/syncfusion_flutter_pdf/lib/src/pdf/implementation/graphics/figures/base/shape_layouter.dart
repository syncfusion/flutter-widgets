import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../pages/pdf_page.dart';
import '../../images/pdf_image.dart';
import '../../pdf_graphics.dart';
import '../enums.dart';
import 'element_layouter.dart';
import 'layout_element.dart';
import 'pdf_shape_element.dart';
import 'text_layouter.dart';

/// internal class
class ShapeLayouter extends ElementLayouter {
  // constructor
  /// internal constructor
  ShapeLayouter(PdfShapeElement super.element);

  // properties
  /// Gets shape element.
  @override
  PdfShapeElement? get element => super.element as PdfShapeElement?;

  // implementation
  @override
  PdfLayoutResult? layoutInternal(PdfLayoutParams param) {
    PdfPage? currentPage = param.page;
    PdfRectangle? currentBounds = param.bounds;
    PdfRectangle? shapeLayoutBounds = PdfRectangle.empty;
    if (element is PdfImage) {
      shapeLayoutBounds = PdfShapeElementHelper.getBoundsInternal(element!);
    }
    PdfLayoutResult result;
    _ShapeLayoutResult pageResult = _ShapeLayoutResult();
    pageResult._page = currentPage;
    while (true) {
      // ref is there so implement in proper way
      final Map<String, dynamic> returnedValue =
          _raiseBeforePageLayout(currentPage, currentBounds!.rect);
      bool cancel = returnedValue['cancel'] as bool;
      currentBounds = PdfRectangle.fromRect(returnedValue['bounds']);
      EndPageLayoutArgs? endArgs;
      if (!cancel) {
        pageResult = _layoutOnPage(
            currentPage!, currentBounds, shapeLayoutBounds!, param);
        endArgs = _raiseEndPageLayout(pageResult);
        cancel = endArgs != null && endArgs.cancel;
      }
      if (!pageResult._end && !cancel) {
        currentBounds = getPaginateBounds(param);
        shapeLayoutBounds = _getNextShapeBounds(shapeLayoutBounds!, pageResult);
        currentPage = (endArgs == null || endArgs.nextPage == null)
            ? getNextPage(currentPage!)
            : endArgs.nextPage;
      } else {
        result = _getLayoutResult(pageResult);
        break;
      }
    }
    return result;
  }

  Map<String, dynamic> _raiseBeforePageLayout(
      PdfPage? currentPage, Rect currentBounds) {
    bool cancel = false;
    if (PdfLayoutElementHelper.getHelper(element!).raiseBeginPageLayout) {
      final BeginPageLayoutArgs args =
          BeginPageLayoutArgs(currentBounds, currentPage!);
      PdfLayoutElementHelper.getHelper(element!).onBeginPageLayout(args);
      cancel = args.cancel;
      currentBounds = args.bounds;
    }
    return <String, dynamic>{'cancel': cancel, 'bounds': currentBounds};
  }

  _ShapeLayoutResult _layoutOnPage(
      PdfPage currentPage,
      PdfRectangle currentBounds,
      PdfRectangle shapeLayoutBounds,
      PdfLayoutParams param) {
    final _ShapeLayoutResult result = _ShapeLayoutResult();
    currentBounds = _checkCorrectCurrentBounds(
        currentPage, currentBounds, shapeLayoutBounds, param);
    final bool fitToPage = _fitsToBounds(currentBounds, shapeLayoutBounds);
    final bool canDraw =
        !(param.format!.breakType == PdfLayoutBreakType.fitElement &&
            !fitToPage &&
            currentPage == param.page);
    bool shapeFinished = false;
    if (canDraw) {
      final PdfRectangle drawRectangle =
          _getDrawBounds(currentBounds, shapeLayoutBounds);
      _drawShape(currentPage.graphics, currentBounds.rect, drawRectangle);
      result._bounds =
          _getPageResultBounds(currentBounds, shapeLayoutBounds).rect;
      shapeFinished =
          currentBounds.height.toInt() >= shapeLayoutBounds.height.toInt();
    }
    result._end =
        shapeFinished || param.format!.layoutType == PdfLayoutType.onePage;
    result._page = currentPage;
    return result;
  }

  PdfRectangle _checkCorrectCurrentBounds(
      PdfPage currentPage,
      PdfRectangle currentBounds,
      PdfRectangle shapeLayoutBounds,
      PdfLayoutParams param) {
    final Size pageSize = currentPage.graphics.clientSize;
    currentBounds.width = (currentBounds.width > 0)
        ? currentBounds.width
        : pageSize.width - currentBounds.x;
    currentBounds.height = (currentBounds.height > 0)
        ? currentBounds.height
        : pageSize.height - currentBounds.y;
    return currentBounds;
  }

  bool _fitsToBounds(
      PdfRectangle currentBounds, PdfRectangle shapeLayoutBounds) {
    final bool fits = shapeLayoutBounds.height <= currentBounds.height;
    return fits;
  }

  PdfRectangle _getDrawBounds(
      PdfRectangle currentBounds, PdfRectangle shapeLayoutBounds) {
    final PdfRectangle result = PdfRectangle(currentBounds.x, currentBounds.y,
        currentBounds.width, currentBounds.height);
    result.y -= shapeLayoutBounds.y;
    result.height += shapeLayoutBounds.y;
    return result;
  }

  void _drawShape(
      PdfGraphics g, Rect currentBounds, PdfRectangle drawRectangle) {
    final PdfGraphicsState gState = g.save();
    try {
      g.setClip(bounds: currentBounds);
      element!.draw(
          graphics: g,
          bounds: Rect.fromLTWH(drawRectangle.x, drawRectangle.y, 0, 0));
    } finally {
      g.restore(gState);
    }
  }

  PdfRectangle _getPageResultBounds(
      PdfRectangle currentBounds, PdfRectangle shapeLayoutBounds) {
    final PdfRectangle result = currentBounds;
    result.height = (result.height > shapeLayoutBounds.height)
        ? shapeLayoutBounds.height
        : result.height;
    return result;
  }

  PdfRectangle _getNextShapeBounds(
      PdfRectangle shapeLayoutBounds, _ShapeLayoutResult pageResult) {
    shapeLayoutBounds.y += pageResult._bounds!.height;
    shapeLayoutBounds.height -= pageResult._bounds!.height;
    return shapeLayoutBounds;
  }

  EndPageLayoutArgs? _raiseEndPageLayout(_ShapeLayoutResult pageResult) {
    EndPageLayoutArgs? args;
    if (PdfLayoutElementHelper.getHelper(element!).raisePageLayouted) {
      final PdfLayoutResult res = _getLayoutResult(pageResult);
      args = EndPageLayoutArgs(res);
      PdfLayoutElementHelper.getHelper(element!).onEndPageLayout(args);
    }
    return args;
  }

  PdfLayoutResult _getLayoutResult(_ShapeLayoutResult pageResult) {
    final PdfLayoutResult result =
        PdfLayoutResultHelper.load(pageResult._page!, pageResult._bounds!);
    return result;
  }
}

class _ShapeLayoutResult {
  //Constructor
  _ShapeLayoutResult() {
    _bounds = Rect.zero;
    _end = false;
  }
  //Fields
  PdfPage? _page;
  Rect? _bounds;
  late bool _end;
}
