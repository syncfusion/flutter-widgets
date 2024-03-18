import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../pages/pdf_page.dart';
import '../../fonts/enums.dart';
import '../../fonts/pdf_string_format.dart';
import '../../fonts/pdf_string_layout_result.dart';
import '../../fonts/pdf_string_layouter.dart';
import '../../pdf_graphics.dart';
import '../enums.dart';
import '../pdf_text_element.dart';
import 'element_layouter.dart';
import 'layout_element.dart';

/// internal class
class TextLayouter extends ElementLayouter {
  //Constructor
  /// internal constructor
  TextLayouter(PdfTextElement super.element);

  //Fields
  PdfStringFormat? _format;

  //Properties
  @override
  PdfTextElement? get element =>
      super.element is PdfTextElement ? super.element as PdfTextElement? : null;

  //Implementation
  _TextPageLayoutResult _layoutOnPage(String text, PdfPage currentPage,
      PdfRectangle currentBounds, PdfLayoutParams param) {
    final _TextPageLayoutResult result = _TextPageLayoutResult();
    result.remainder = text;
    result.page = currentPage;
    currentBounds = _checkCorrectBounds(currentPage, currentBounds);
    if (currentBounds.height < 0) {
      currentPage = getNextPage(currentPage)!;
      result.page = currentPage;
      currentBounds = PdfRectangle(
          currentBounds.x, 0, currentBounds.width, currentBounds.height);
    }
    final PdfStringLayouter layouter = PdfStringLayouter();
    final PdfStringLayoutResult stringResult = layouter.layout(
        text, element!.font, _format,
        bounds: currentBounds, pageHeight: currentPage.getClientSize().height);
    final bool textFinished =
        stringResult.remainder == null || stringResult.remainder!.isEmpty;
    final bool doesntFit =
        param.format!.breakType == PdfLayoutBreakType.fitElement &&
            currentPage == param.page &&
            !textFinished;
    final bool canDraw = !(doesntFit || stringResult.isEmpty);
    if (canDraw) {
      final PdfGraphics graphics = currentPage.graphics;
      PdfGraphicsHelper.getHelper(graphics).drawStringLayoutResult(
          stringResult,
          element!.font,
          element!.pen,
          PdfTextElementHelper.getHelper(element!).obtainBrush(),
          currentBounds,
          _format);
      final LineInfo lineInfo = stringResult.lines![stringResult.lineCount - 1];
      result.lastLineBounds = PdfGraphicsHelper.getHelper(graphics)
          .getLineBounds(stringResult.lineCount - 1, stringResult,
              element!.font, currentBounds, _format);
      result.bounds =
          _getTextPageBounds(currentPage, currentBounds, stringResult);
      result.remainder = stringResult.remainder;
      _checkCorectStringFormat(lineInfo);
    } else {
      result.bounds =
          _getTextPageBounds(currentPage, currentBounds, stringResult);
    }
    final bool stopLayouting = stringResult.isEmpty &&
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

  PdfRectangle _checkCorrectBounds(
      PdfPage currentPage, PdfRectangle currentBounds) {
    final Size pageSize = currentPage.graphics.clientSize;
    currentBounds.height = (currentBounds.height > 0)
        ? currentBounds.height
        : pageSize.height - currentBounds.y;
    return currentBounds;
  }

  Rect _getTextPageBounds(PdfPage currentPage, PdfRectangle currentBounds,
      PdfStringLayoutResult stringResult) {
    final PdfSize textSize = stringResult.size;
    double? x = currentBounds.x;
    double? y = currentBounds.y;
    final double width =
        (currentBounds.width > 0) ? currentBounds.width : textSize.width;
    final double height = textSize.height;
    final PdfRectangle shiftedRect =
        PdfGraphicsHelper.getHelper(currentPage.graphics)
            .checkCorrectLayoutRectangle(
                textSize, currentBounds.x, currentBounds.y, _format);
    if (currentBounds.width <= 0) {
      x = shiftedRect.x;
    }
    if (currentBounds.height <= 0) {
      y = shiftedRect.y;
    }
    final double verticalShift =
        PdfGraphicsHelper.getHelper(currentPage.graphics)
            .getTextVerticalAlignShift(
                textSize.height, currentBounds.height, _format);
    y += verticalShift;
    return Rect.fromLTWH(x, y, width, height);
  }

  void _checkCorectStringFormat(LineInfo lineInfo) {
    if (_format != null) {
      PdfStringFormatHelper.getHelper(_format!).firstLineIndent = (lineInfo
                      .lineType &
                  PdfStringLayouter.getLineTypeValue(LineType.newLineBreak)! >
              0)
          ? PdfStringFormatHelper.getHelper(element!.stringFormat!)
              .firstLineIndent
          : 0;
    }
  }

  PdfTextLayoutResult _getLayoutResult(_TextPageLayoutResult pageResult) {
    return PdfTextLayoutResult._(pageResult.page, pageResult.bounds,
        pageResult.remainder, pageResult.lastLineBounds);
  }

  bool _raiseBeforePageLayout(PdfPage? currentPage, Rect currentBounds) {
    bool cancel = false;
    if (PdfLayoutElementHelper.getHelper(element!).raiseBeginPageLayout) {
      final BeginPageLayoutArgs args =
          BeginPageLayoutArgs(currentBounds, currentPage!);
      PdfLayoutElementHelper.getHelper(element!).onBeginPageLayout(args);
      cancel = args.cancel;
      currentBounds = args.bounds;
    }
    return cancel;
  }

  EndTextPageLayoutArgs? _raisePageLayouted(_TextPageLayoutResult pageResult) {
    EndTextPageLayoutArgs? args;
    if (PdfLayoutElementHelper.getHelper(element!).raisePageLayouted) {
      args = EndTextPageLayoutArgs(_getLayoutResult(pageResult));
      PdfLayoutElementHelper.getHelper(element!).onEndPageLayout(args);
    }
    return args;
  }

  //Override methods
  @override
  PdfLayoutResult layoutInternal(PdfLayoutParams param) {
    if (element != null) {
      _format = (element!.stringFormat != null) ? element!.stringFormat : null;
      PdfPage? currentPage = param.page;
      PdfRectangle? currentBounds = param.bounds;
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
          if (PdfTextElementHelper.getHelper(element!).isPdfTextElement) {
            result = _getLayoutResult(pageResult);
            break;
          }
          currentBounds = getPaginateBounds(param);
          text = pageResult.remainder;
          currentPage = endArgs == null || endArgs.nextPage == null
              ? getNextPage(currentPage!)
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

/// Represents the layouting result format.
class PdfLayoutResult {
  //Constructors
  /// Represents the layouting result format
  /// including bounds and resultant page.
  PdfLayoutResult._(PdfPage page, Rect bounds) {
    _page = page;
    _bounds = bounds;
  }

  //Fields
  /// The last page where the element was drawn.
  late PdfPage _page;

  /// The bounds of the element on the last page where it was drawn.
  late Rect _bounds;

  //Properties
  /// Gets the last page where the element was drawn.
  PdfPage get page => _page;

  /// Gets the bounds of the element on the last page where it was drawn.
  Rect get bounds => _bounds;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfLayoutResult] helper
class PdfLayoutResultHelper {
  /// internal method
  static PdfLayoutResult load(PdfPage page, Rect bounds) {
    return PdfLayoutResult._(page, bounds);
  }
}

class _TextPageLayoutResult {
  _TextPageLayoutResult() {
    bounds = Rect.zero;
    end = false;
    lastLineBounds = Rect.zero;
  }
  PdfPage? page;
  late Rect bounds;
  late bool end;
  String? remainder;
  late Rect lastLineBounds;
}
