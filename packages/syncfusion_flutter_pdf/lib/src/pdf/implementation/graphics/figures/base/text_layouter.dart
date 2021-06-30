part of pdf;

class _TextLayouter extends _ElementLayouter {
  //Constructor
  _TextLayouter(PdfTextElement element) : super(element);

  //Fields
  PdfStringFormat? _format;

  //Properties
  @override
  PdfTextElement? get element =>
      super.element is PdfTextElement ? super.element as PdfTextElement? : null;

  //Implementation
  _TextPageLayoutResult _layoutOnPage(String text, PdfPage currentPage,
      _Rectangle currentBounds, _PdfLayoutParams param) {
    final _TextPageLayoutResult result = _TextPageLayoutResult();
    result.remainder = text;
    result.page = currentPage;
    currentBounds = _checkCorrectBounds(currentPage, currentBounds);
    if (currentBounds.height < 0) {
      currentPage = _getNextPage(currentPage)!;
      result.page = currentPage;
      currentBounds = _Rectangle(
          currentBounds.x, 0, currentBounds.width, currentBounds.height);
    }
    final _PdfStringLayouter layouter = _PdfStringLayouter();
    final _PdfStringLayoutResult stringResult = layouter._layout(
        text, element!.font, _format,
        bounds: currentBounds, pageHeight: currentPage.getClientSize().height);
    final bool textFinished =
        stringResult._remainder == null || stringResult._remainder!.isEmpty;
    final bool doesntFit =
        param.format!.breakType == PdfLayoutBreakType.fitElement &&
            currentPage == param.page &&
            !textFinished;
    final bool canDraw = !(doesntFit || stringResult._isEmpty);
    if (canDraw) {
      final PdfGraphics graphics = currentPage.graphics;
      graphics._drawStringLayoutResult(stringResult, element!.font,
          element!.pen, element!._obtainBrush(), currentBounds, _format);
      final _LineInfo lineInfo =
          stringResult._lines![stringResult._lineCount - 1];
      result.lastLineBounds = graphics._getLineBounds(
          stringResult._lineCount - 1,
          stringResult,
          element!.font,
          currentBounds,
          _format);
      result.bounds =
          _getTextPageBounds(currentPage, currentBounds, stringResult);
      result.remainder = stringResult._remainder;
      _checkCorectStringFormat(lineInfo);
    } else {
      result.bounds =
          _getTextPageBounds(currentPage, currentBounds, stringResult);
    }
    final bool stopLayouting = stringResult._isEmpty &&
            ((param.format!.breakType != PdfLayoutBreakType.fitElement) &&
                (param.format!.layoutType != PdfLayoutType.paginate) &&
                canDraw) ||
        (param.format!.breakType == PdfLayoutBreakType.fitElement &&
            currentPage != param.page);
    result.end = textFinished ||
        stopLayouting ||
        param.format!.layoutType == PdfLayoutType.onePage;
    return result;
  }

  _Rectangle _checkCorrectBounds(
      PdfPage currentPage, _Rectangle currentBounds) {
    final Size pageSize = currentPage.graphics.clientSize;
    currentBounds.height = (currentBounds.height > 0)
        ? currentBounds.height
        : pageSize.height - currentBounds.y;
    return currentBounds;
  }

  Rect _getTextPageBounds(PdfPage currentPage, _Rectangle currentBounds,
      _PdfStringLayoutResult stringResult) {
    final _Size textSize = stringResult._size;
    double? x = currentBounds.x;
    double? y = currentBounds.y;
    final double width =
        (currentBounds.width > 0) ? currentBounds.width : textSize.width;
    final double height = textSize.height;
    final _Rectangle shiftedRect = currentPage.graphics
        ._checkCorrectLayoutRectangle(
            textSize, currentBounds.x, currentBounds.y, _format);
    if (currentBounds.width <= 0) {
      x = shiftedRect.x;
    }
    if (currentBounds.height <= 0) {
      y = shiftedRect.y;
    }
    final double verticalShift = currentPage.graphics
        ._getTextVerticalAlignShift(
            textSize.height, currentBounds.height, _format);
    y += verticalShift;
    return Rect.fromLTWH(x, y, width, height);
  }

  void _checkCorectStringFormat(_LineInfo lineInfo) {
    if (_format != null) {
      _format!._firstLineIndent = lineInfo._lineType &
                  _PdfStringLayouter._getLineTypeValue(
                      _LineType.newLineBreak)! >
              0
          ? element!.stringFormat!._firstLineIndent
          : 0;
    }
  }

  PdfTextLayoutResult _getLayoutResult(_TextPageLayoutResult pageResult) {
    return PdfTextLayoutResult._(pageResult.page, pageResult.bounds,
        pageResult.remainder, pageResult.lastLineBounds);
  }

  bool _raiseBeforePageLayout(PdfPage? currentPage, Rect currentBounds) {
    bool cancel = false;
    if (element!._raiseBeginPageLayout) {
      final BeginPageLayoutArgs args =
          BeginPageLayoutArgs(currentBounds, currentPage!);
      element!._onBeginPageLayout(args);
      cancel = args.cancel;
      currentBounds = args.bounds;
    }
    return cancel;
  }

  EndTextPageLayoutArgs? _raisePageLayouted(_TextPageLayoutResult pageResult) {
    EndTextPageLayoutArgs? args;
    if (element!._raisePageLayouted) {
      args = EndTextPageLayoutArgs(_getLayoutResult(pageResult));
      element!._onEndPageLayout(args);
    }
    return args;
  }

  //Override methods
  @override
  PdfLayoutResult _layoutInternal(_PdfLayoutParams param) {
    if (element != null) {
      _format = (element!.stringFormat != null) ? element!.stringFormat : null;
      PdfPage? currentPage = param.page;
      _Rectangle? currentBounds = param.bounds;
      String? text = element!.text;
      PdfTextLayoutResult result;
      _TextPageLayoutResult pageResult = _TextPageLayoutResult();
      pageResult.page = currentPage;
      pageResult.remainder = text;
      while (true) {
        bool cancel = _raiseBeforePageLayout(currentPage, currentBounds!.rect);
        EndTextPageLayoutArgs? endArgs;
        if (!cancel) {
          pageResult = _layoutOnPage(text!, currentPage!, currentBounds, param);
          endArgs = _raisePageLayouted(pageResult);
          cancel = endArgs != null && endArgs.cancel;
        }
        if (!pageResult.end && !cancel) {
          if (element!._isPdfTextElement) {
            result = _getLayoutResult(pageResult);
            break;
          }
          currentBounds = _getPaginateBounds(param);
          text = pageResult.remainder;
          currentPage = endArgs == null || endArgs.nextPage == null
              ? _getNextPage(currentPage!)
              : endArgs.nextPage;
        } else {
          result = _getLayoutResult(pageResult);
          break;
        }
      }
      return result;
    } else {
      throw ArgumentError.value(element, 'text element cannot be null');
    }
  }
}

/// Represents the text lay outing result settings.
class PdfTextLayoutResult extends PdfLayoutResult {
  //Contructor
  PdfTextLayoutResult._(
      PdfPage? page, Rect? bounds, String? remainder, Rect? lastLineBounds)
      : super._(page!, bounds!) {
    _remainder = remainder;
    _lastLineBounds = lastLineBounds;
  }

  //Fields
  String? _remainder;
  Rect? _lastLineBounds;

  //Properties
  /// Gets a value that contains the text that was not printed.
  String? get remainder => _remainder;

  /// Gets a value that indicates the bounds of the last line
  /// that was printed on the page.
  Rect? get lastLineBounds => _lastLineBounds;
}

class _TextPageLayoutResult {
  _TextPageLayoutResult() {
    bounds = const Rect.fromLTWH(0, 0, 0, 0);
    end = false;
    lastLineBounds = const Rect.fromLTWH(0, 0, 0, 0);
  }
  PdfPage? page;
  late Rect bounds;
  late bool end;
  String? remainder;
  late Rect lastLineBounds;
}
