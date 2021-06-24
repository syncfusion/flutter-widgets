part of pdf;

class _ShapeLayouter extends _ElementLayouter {
  // constructor
  _ShapeLayouter(PdfShapeElement element) : super(element);

  // properties
  /// Gets shape element.
  @override
  PdfShapeElement? get element => super.element as PdfShapeElement?;

  // implementation
  @override
  PdfLayoutResult? _layoutInternal(_PdfLayoutParams param) {
    PdfPage? currentPage = param.page;
    _Rectangle? currentBounds = param.bounds;
    _Rectangle? shapeLayoutBounds = _Rectangle.empty;
    if (element is PdfImage) {
      shapeLayoutBounds = element!._getBoundsInternal();
    }
    PdfLayoutResult result;
    _ShapeLayoutResult pageResult = _ShapeLayoutResult();
    pageResult._page = currentPage;
    while (true) {
      // ref is there so implement in proper way
      final Map<String, dynamic> returnedValue =
          _raiseBeforePageLayout(currentPage, currentBounds!.rect);
      bool cancel = returnedValue['cancel'] as bool;
      currentBounds = _Rectangle.fromRect(returnedValue['bounds']);
      EndPageLayoutArgs? endArgs;
      if (!cancel) {
        pageResult = _layoutOnPage(
            currentPage!, currentBounds, shapeLayoutBounds!, param);
        endArgs = _raiseEndPageLayout(pageResult);
        cancel = endArgs != null && endArgs.cancel;
      }
      if (!pageResult._end && !cancel) {
        currentBounds = _getPaginateBounds(param);
        shapeLayoutBounds = _getNextShapeBounds(shapeLayoutBounds!, pageResult);
        currentPage = (endArgs == null || endArgs.nextPage == null)
            ? _getNextPage(currentPage!)
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
    if (element!._raiseBeginPageLayout) {
      final BeginPageLayoutArgs args =
          BeginPageLayoutArgs(currentBounds, currentPage!);
      element!._onBeginPageLayout(args);
      cancel = args.cancel;
      currentBounds = args.bounds;
    }
    return <String, dynamic>{'cancel': cancel, 'bounds': currentBounds};
  }

  _ShapeLayoutResult _layoutOnPage(
      PdfPage currentPage,
      _Rectangle currentBounds,
      _Rectangle shapeLayoutBounds,
      _PdfLayoutParams param) {
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
      final _Rectangle drawRectangle =
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

  _Rectangle _checkCorrectCurrentBounds(
      PdfPage currentPage,
      _Rectangle currentBounds,
      _Rectangle shapeLayoutBounds,
      _PdfLayoutParams param) {
    final Size pageSize = currentPage.graphics.clientSize;
    currentBounds.width = (currentBounds.width > 0)
        ? currentBounds.width
        : pageSize.width - currentBounds.x;
    currentBounds.height = (currentBounds.height > 0)
        ? currentBounds.height
        : pageSize.height - currentBounds.y;
    return currentBounds;
  }

  bool _fitsToBounds(_Rectangle currentBounds, _Rectangle shapeLayoutBounds) {
    final bool fits = shapeLayoutBounds.height <= currentBounds.height;
    return fits;
  }

  _Rectangle _getDrawBounds(
      _Rectangle currentBounds, _Rectangle shapeLayoutBounds) {
    final _Rectangle result = _Rectangle(currentBounds.x, currentBounds.y,
        currentBounds.width, currentBounds.height);
    result.y -= shapeLayoutBounds.y;
    result.height += shapeLayoutBounds.y;
    return result;
  }

  void _drawShape(PdfGraphics g, Rect currentBounds, _Rectangle drawRectangle) {
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

  _Rectangle _getPageResultBounds(
      _Rectangle currentBounds, _Rectangle shapeLayoutBounds) {
    final _Rectangle result = currentBounds;
    result.height = (result.height > shapeLayoutBounds.height)
        ? shapeLayoutBounds.height
        : result.height;
    return result;
  }

  _Rectangle _getNextShapeBounds(
      _Rectangle shapeLayoutBounds, _ShapeLayoutResult pageResult) {
    shapeLayoutBounds.y += pageResult._bounds!.height;
    shapeLayoutBounds.height -= pageResult._bounds!.height;
    return shapeLayoutBounds;
  }

  EndPageLayoutArgs? _raiseEndPageLayout(_ShapeLayoutResult pageResult) {
    EndPageLayoutArgs? args;
    if (element!._raisePageLayouted) {
      final PdfLayoutResult res = _getLayoutResult(pageResult);
      args = EndPageLayoutArgs(res);
      element!._onEndPageLayout(args);
    }
    return args;
  }

  PdfLayoutResult _getLayoutResult(_ShapeLayoutResult pageResult) {
    final PdfLayoutResult result =
        PdfLayoutResult._(pageResult._page!, pageResult._bounds!);
    return result;
  }
}

class _ShapeLayoutResult {
  //Constructor
  _ShapeLayoutResult() {
    _bounds = const Rect.fromLTWH(0, 0, 0, 0);
    _end = false;
  }
  //Fields
  PdfPage? _page;
  Rect? _bounds;
  late bool _end;
}
