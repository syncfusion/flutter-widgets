import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_brush.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/enums.dart';
import '../../graphics/figures/base/element_layouter.dart';
import '../../graphics/figures/base/layout_element.dart';
import '../../graphics/figures/base/text_layouter.dart';
import '../../graphics/figures/enums.dart';
import '../../graphics/fonts/enums.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_standard_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../graphics/fonts/pdf_string_layout_result.dart';
import '../../graphics/fonts/pdf_string_layouter.dart';
import '../../graphics/pdf_graphics.dart';
import '../../graphics/pdf_pen.dart';
import '../../pages/enum.dart';
import '../../pages/pdf_page.dart';
import 'bullets/enums.dart';
import 'bullets/pdf_marker.dart';
import 'bullets/pdf_ordered_marker.dart';
import 'bullets/pdf_unordered_marker.dart';
import 'pdf_list.dart';
import 'pdf_list_item.dart';
import 'pdf_ordered_list.dart';
import 'pdf_unordered_list.dart';

/// Layouts list.
class PdfListLayouter extends ElementLayouter {
  /// Initializes a new instance of the [PdfListLayouter] class.
  PdfListLayouter(PdfList super.element);

  /// Current graphics for lay outing.
  PdfGraphics? graphics;

  /// Indicates end of lay outing.
  bool finish = false;

  /// List that layouts at the moment.
  PdfList? curList;

  /// List that contains ListInfo.
  List<_ListInfo> info = <_ListInfo>[];

  /// Index of item that lay outing.
  int index = 0;

  /// The indent of current list.
  double? indent;

  /// Height in which it stop lay outing.
  double? resultHeight;

  /// Lay outing bounds.
  late PdfRectangle bounds;

  /// Current page for layout.
  PdfPage? currentPage;

  /// PdfSize for item lay outing.
  PdfSize size = PdfSize.empty;

  /// If true it use paginate bounds if it is set.
  bool usePaginateBounds = true;

  /// Current brush for lay outing.
  PdfBrush? currentBrush;

  /// Current pen for layout.
  PdfPen? currentPen;

  /// Current font for layout.
  PdfFont? currentFont;

  /// Current string format.
  PdfStringFormat? currentFormat;

  /// Marker maximum width.
  num? markerMaxWidth;
  @override
  PdfList? get element => super.element as PdfList?;

  @override
  PdfLayoutResult? layoutInternal(PdfLayoutParams param) {
    currentPage = param.page;
    bounds = param.bounds!.clone();
    if (param.bounds!.height == 0 &&
        param.bounds!.width == 0 &&
        currentPage != null) {
      bounds.width = currentPage!.getClientSize().width;
      bounds.height = currentPage!.getClientSize().height;
      bounds.width = bounds.width - bounds.x;
      bounds.height = bounds.height - bounds.y;
    }

    if (currentPage != null) {
      graphics = currentPage!.graphics;
    }

    _PageLayoutResult pageResult = _PageLayoutResult();
    pageResult.broken = false;
    pageResult.y = bounds.y;
    curList = element;
    indent = element!.indent;

    _setCurrentParameters(element);

    if (element!.brush == null) {
      currentBrush = PdfBrushes.black;
    }

    if (element!.font == null) {
      currentFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
      curList!.font = currentFont;
    }

    if (curList is PdfOrderedList) {
      markerMaxWidth = _getMarkerMaxWidth(curList! as PdfOrderedList, info);
    }

    final bool useOnePage = param.format!.layoutType == PdfLayoutType.onePage;

    while (!finish) {
      bool cancel = _beforePageLayout(bounds.rect, currentPage, curList!);
      pageResult.y = bounds.y;
      ListEndPageLayoutArgs? endArgs;
      if (!cancel) {
        pageResult = _layoutOnPage(pageResult)!;
        endArgs = _afterPageLayouted(bounds.rect, currentPage, curList!);
        cancel = endArgs != null && endArgs.cancel;
      }
      if (useOnePage || cancel) {
        break;
      }
      if (currentPage != null && !finish) {
        if ((endArgs != null) && (endArgs.nextPage != null)) {
          currentPage = endArgs.nextPage;
        } else {
          currentPage = getNextPage(currentPage!);
        }
        graphics = currentPage!.graphics;
        if (param.bounds!.width == 0 && param.bounds!.height == 0) {
          bounds.width = currentPage!.getClientSize().width;
          bounds.height = currentPage!.getClientSize().height;
          bounds.width = bounds.width - bounds.x;
          bounds.height = bounds.height - bounds.y;
        }
        if ((param.format != null) &&
            PdfLayoutFormatHelper.isBoundsSet(param.format!) &&
            usePaginateBounds) {
          bounds = PdfRectangle.fromRect(param.format!.paginateBounds);
        }
      }
    }
    info.clear();
    final Rect finalBounds =
        Rect.fromLTWH(bounds.x, pageResult.y!, bounds.width, resultHeight ?? 0);
    if (currentPage != null) {
      final PdfLayoutResult result =
          PdfLayoutResultHelper.load(currentPage!, finalBounds);
      return result;
    } else {
      return null;
    }
  }

  /// Layouts the on the page.
  _PageLayoutResult? _layoutOnPage(_PageLayoutResult? pageResult) {
    double? height = 0;
    double resultantHeight = 0;
    double? y = bounds.y;
    final double x = bounds.x;
    size = PdfSize(bounds.size.width, bounds.size.height);
    size.width = size.width - indent!;

    while (true) {
      for (; index < curList!.items.count; ++index) {
        final PdfListItem item = curList!.items[index];

        if (currentPage != null && !pageResult!.broken) {
          _beforeItemLayout(item, currentPage!);
        }
        final Map<String, dynamic> returnedValue = _drawItem(
            pageResult!, x, curList!, index, indent!, info, item, height!, y!);
        pageResult = returnedValue['pageResult'] as _PageLayoutResult?;
        height = returnedValue['height'] as double?;
        y = returnedValue['y'] as double?;
        resultantHeight += height!;
        if (pageResult!.broken) {
          return pageResult;
        }

        if (currentPage != null) {
          _afterItemLayouted(item, currentPage!);
        }
        pageResult.markerWrote = false;

        if (item.subList != null && item.subList!.items.count > 0) {
          if (curList is PdfOrderedList) {
            final PdfOrderedList oList = curList! as PdfOrderedList;
            PdfOrderedMarkerHelper.getHelper(oList.marker).currentIndex = index;
            final _ListInfo listInfo = _ListInfo(curList, index,
                PdfOrderedMarkerHelper.getHelper(oList.marker).getNumber());
            listInfo.brush = currentBrush;
            listInfo.font = currentFont;
            listInfo.format = currentFormat;
            listInfo.pen = currentPen;
            listInfo.markerWidth = markerMaxWidth as double?;
            info.add(listInfo);
          } else {
            final _ListInfo listInfo = _ListInfo(curList, index);
            listInfo.brush = currentBrush;
            listInfo.font = currentFont;
            listInfo.format = currentFormat;
            listInfo.pen = currentPen;
            info.add(listInfo);
          }
          curList = item.subList;
          if (curList is PdfOrderedList) {
            markerMaxWidth =
                _getMarkerMaxWidth(curList! as PdfOrderedList, info);
          }
          index = -1;
          indent = indent! + curList!.indent;
          size.width = size.width - curList!.indent;
          _setCurrentParameters(item);
          _setCurrentParameters(curList);
        }
      }
      if (info.isEmpty) {
        resultHeight = resultantHeight;
        finish = true;
        break;
      }
      final _ListInfo listInfo = info.last;
      info.remove(listInfo);
      index = listInfo.index + 1;
      indent = indent! - curList!.indent;
      size.width = size.width + curList!.indent;
      markerMaxWidth = listInfo.markerWidth;
      currentBrush = listInfo.brush;
      currentPen = listInfo.pen;
      currentFont = listInfo.font;
      currentFormat = listInfo.format;
      curList = listInfo.list;
    }
    return pageResult;
  }

  /// Draws the item.
  Map<String, dynamic> _drawItem(
      _PageLayoutResult pageResult,
      double x,
      PdfList curList,
      int index,
      double indent,
      List<_ListInfo> listInfo,
      PdfListItem item,
      double height,
      double y) {
    final PdfStringLayouter layouter = PdfStringLayouter();
    PdfStringLayoutResult? markerResult;
    PdfStringLayoutResult? result;

    bool wroteMaker = false;
    final double textIndent = curList.textIndent;

    final double posY = height + y;
    double posX = indent + x;

    double? itemHeight = 0;
    double? markerHeight = 0;
    PdfSize itemSize = PdfSize(size.width, size.height);

    String? text = item.text;
    String? markerText;

    PdfBrush? itemBrush = currentBrush;

    if (item.brush != null) {
      itemBrush = item.brush;
    }

    PdfPen? itemPen = currentPen;

    if (item.pen != null) {
      itemPen = item.pen;
    }

    PdfFont? itemFont = currentFont;

    if (item.font != null) {
      itemFont = item.font;
    }

    PdfStringFormat? itemFormat = currentFormat;

    if (item.stringFormat != null) {
      itemFormat = item.stringFormat;
    }

    if (((size.width <= 0) || (size.width < itemFont!.size)) &&
        currentPage != null) {
      throw Exception('There is not enough space to layout list.');
    }
    size.height = size.height - height;

    PdfMarker marker;

    if (curList is PdfUnorderedList) {
      marker = curList.marker;
    } else {
      marker = (curList as PdfOrderedList).marker;
    }

    if (pageResult.broken) {
      text = pageResult.itemText;
      markerText = pageResult.markerText;
    }

    bool canDrawMarker = true;

    if (markerText != null &&
        ((marker is PdfUnorderedMarker) &&
            (marker.style == PdfUnorderedMarkerStyle.customString))) {
      markerResult = layouter.layout(markerText, _getMarkerFont(marker, item)!,
          _getMarkerFormat(marker, item),
          width: size.width, height: size.height);
      posX += markerResult.size.width;
      pageResult.markerWidth = markerResult.size.width;
      markerHeight = markerResult.size.height;
      canDrawMarker = true;
    } else {
      markerResult = _createMarkerResult(index, curList, info, item);

      if (markerResult != null) {
        if (curList is PdfOrderedList) {
          posX += markerMaxWidth!;
          pageResult.markerWidth = markerMaxWidth as double?;
        } else {
          posX += markerResult.size.width;
          pageResult.markerWidth = markerResult.size.width;
        }
        markerHeight = markerResult.size.height;

        if (currentPage != null) {
          canDrawMarker = markerHeight < size.height;
        }

        if (markerResult.isEmpty) {
          canDrawMarker = false;
        }
      } else {
        posX += PdfUnorderedMarkerHelper.getHelper(marker as PdfUnorderedMarker)
            .size!
            .width;
        pageResult.markerWidth =
            PdfUnorderedMarkerHelper.getHelper(marker).size!.width;
        markerHeight = PdfUnorderedMarkerHelper.getHelper(marker).size!.height;

        if (currentPage != null) {
          canDrawMarker = markerHeight < size.height;
        }
      }
    }

    if (markerText == null || markerText == '') {
      canDrawMarker = true;
    }

    if ((text != null) && canDrawMarker) {
      itemSize = PdfSize(size.width, size.height);
      itemSize.width = itemSize.width - pageResult.markerWidth!;

      if (item.textIndent == 0) {
        itemSize.width = itemSize.width - textIndent;
      } else {
        itemSize.width = itemSize.width - item.textIndent;
      }

      if (((itemSize.width <= 0) || (itemSize.width < itemFont!.size)) &&
          currentPage != null) {
        throw Exception(
            'There is not enough space to layout the item text. Marker is too long or there is no enough space to draw it.');
      }

      double itemX = posX;

      if (!PdfMarkerHelper.getHelper(marker).rightToLeft) {
        if (item.textIndent == 0) {
          itemX += textIndent;
        } else {
          itemX += item.textIndent;
        }
      } else {
        itemX -= pageResult.markerWidth!;

        if (itemFormat != null &&
            (itemFormat.alignment == PdfTextAlignment.right ||
                itemFormat.alignment == PdfTextAlignment.center)) {
          itemX -= indent;
        }
      }

      if (currentPage == null) {
        if (itemFormat != null) {
          itemFormat.alignment = PdfTextAlignment.left;
        }
      }

      result = layouter.layout(text, itemFont!, itemFormat,
          width: itemSize.width, height: itemSize.height);
      final PdfRectangle rect =
          PdfRectangle(itemX, posY, itemSize.width, itemSize.height);
      PdfGraphicsHelper.getHelper(graphics!).drawStringLayoutResult(
          result, itemFont, itemPen, itemBrush, rect, itemFormat);
      y = posY;
      itemHeight = result.size.height;
    }
    height = (itemHeight < markerHeight) ? markerHeight : itemHeight;
    final bool isRemainder =
        (result!.remainder == null) || (result.remainder == '');
    if (!isRemainder ||
        (markerResult != null) && !isRemainder ||
        !canDrawMarker) {
      y = 0;
      height = 0;
      pageResult.itemText = result.remainder;
      if (result.remainder == item.text) {
        canDrawMarker = false;
      }
      if (markerResult != null) {
        pageResult.markerText = markerResult.remainder;
      } else {
        pageResult.markerText = null;
      }
      pageResult.broken = true;
      pageResult.y = 0;
      bounds.y = 0;
    } else {
      pageResult.broken = false;
    }

    pageResult.markerX = posX;
    if (itemFormat != null) {
      switch (itemFormat.alignment) {
        case PdfTextAlignment.right:
          pageResult.markerX = posX + itemSize.width - result.size.width;
          break;
        case PdfTextAlignment.center:
          pageResult.markerX =
              posX + (itemSize.width / 2) - (result.size.width / 2);
          break;
        case PdfTextAlignment.left:
        case PdfTextAlignment.justify:
          break;
      }
    }

    if (PdfMarkerHelper.getHelper(marker).rightToLeft) {
      pageResult.markerX += result.size.width;

      if (item.textIndent == 0) {
        pageResult.markerX += textIndent;
      } else {
        pageResult.markerX += item.textIndent;
      }

      if (itemFormat != null &&
          (itemFormat.alignment == PdfTextAlignment.right ||
              itemFormat.alignment == PdfTextAlignment.center)) {
        pageResult.markerX -= indent;
      }
    }

    if ((marker is PdfUnorderedMarker) &&
        marker.style == PdfUnorderedMarkerStyle.customString) {
      if (markerResult != null) {
        wroteMaker =
            _drawMarker(curList, item, markerResult, posY, pageResult.markerX);
        pageResult.markerWrote = true;
        pageResult.markerWidth = markerResult.size.width;
      }
    } else {
      if (canDrawMarker && !pageResult.markerWrote) {
        wroteMaker =
            _drawMarker(curList, item, markerResult, posY, pageResult.markerX);
        pageResult.markerWrote = wroteMaker;

        if (curList is PdfOrderedList) {
          pageResult.markerWidth = markerResult!.size.width;
        } else {
          pageResult.markerWidth =
              PdfUnorderedMarkerHelper.getHelper(marker as PdfUnorderedMarker)
                  .size!
                  .width;
        }
      }
    }
    return <String, dynamic>{
      'pageResult': pageResult,
      'height': height,
      'y': y
    };
  }

  /// Sets the current parameters.
  void _setCurrentParameters(dynamic value) {
    if (value.brush != null) {
      currentBrush = value.brush as PdfBrush?;
    }
    if (value.pen != null) {
      currentPen = value.pen as PdfPen?;
    }
    if (value.font != null) {
      currentFont = value.font as PdfFont?;
    }
    if (value.stringFormat != null) {
      currentFormat = value.stringFormat as PdfStringFormat?;
    }
  }

  /// Gets the width of the marker max.
  double? _getMarkerMaxWidth(PdfOrderedList list, List<_ListInfo> info) {
    double? width = -1;

    for (int i = 0; i < list.items.count; i++) {
      final PdfStringLayoutResult result = _createOrderedMarkerResult(
          list, list.items[i], i + list.marker.startNumber, info, true);

      if (width! < result.size.width) {
        width = result.size.width;
      }
    }
    return width;
  }

  /// Creates the ordered marker result.
  PdfStringLayoutResult _createOrderedMarkerResult(PdfList list,
      PdfListItem? item, int index, List<_ListInfo> info, bool findMaxWidth) {
    PdfOrderedList orderedList = list as PdfOrderedList;
    PdfOrderedMarker marker = orderedList.marker;
    PdfOrderedMarkerHelper.getHelper(marker).currentIndex = index;

    String text = '';

    if (orderedList.marker.style != PdfNumberStyle.none) {
      text = PdfOrderedMarkerHelper.getHelper(orderedList.marker).getNumber() +
          orderedList.marker.suffix;
    }
    if (orderedList.markerHierarchy) {
      final List<_ListInfo> listInfos = info;
      for (int i = listInfos.length - 1; i >= 0; i--) {
        final _ListInfo listInfo = listInfos[i];
        if (listInfo.list is PdfUnorderedList) {
          break;
        }
        orderedList = listInfo.list! as PdfOrderedList;
        if (orderedList.marker.style == PdfNumberStyle.none) {
          break;
        }
        marker = orderedList.marker;
        text = listInfo.number + marker.delimiter + text;
        if (!orderedList.markerHierarchy) {
          break;
        }
      }
    }
    final PdfStringLayouter layouter = PdfStringLayouter();
    orderedList = list;
    marker = orderedList.marker;
    final PdfFont markerFont = _getMarkerFont(marker, item)!;
    PdfStringFormat? markerFormat = _getMarkerFormat(marker, item);
    final PdfSize markerSize = PdfSize(size.width, size.height);
    if (!findMaxWidth) {
      markerSize.width = markerMaxWidth! as double;
      markerFormat = _setMarkerStringFormat(marker, markerFormat);
    }
    final PdfStringLayoutResult result = layouter.layout(
        text, markerFont, markerFormat,
        width: markerSize.width, height: markerSize.height);
    return result;
  }

  /// Gets the markers font.
  PdfFont? _getMarkerFont(PdfMarker marker, PdfListItem? item) {
    PdfFont? markerFont = marker.font;
    if (marker.font == null) {
      markerFont = item!.font;
      if (item.font == null) {
        markerFont = currentFont;
      }
    }
    marker.font = markerFont;
    return markerFont;
  }

  /// Gets the marker format.
  PdfStringFormat? _getMarkerFormat(PdfMarker marker, PdfListItem? item) {
    PdfStringFormat? markerFormat = marker.stringFormat;
    if (marker.stringFormat == null) {
      markerFormat = item!.stringFormat;
      if (item.stringFormat == null) {
        markerFormat = currentFormat;
      }
    }
    return markerFormat;
  }

  /// Sets the marker alingment.
  PdfStringFormat _setMarkerStringFormat(
      PdfOrderedMarker marker, PdfStringFormat? markerFormat) {
    markerFormat = markerFormat == null
        ? PdfStringFormat()
        : _markerFormatClone(markerFormat);
    if (marker.stringFormat == null) {
      markerFormat.alignment = PdfTextAlignment.right;
      if (PdfMarkerHelper.getHelper(marker).rightToLeft) {
        markerFormat.alignment = PdfTextAlignment.left;
      }
    }
    if (currentPage == null) {
      markerFormat.alignment = PdfTextAlignment.left;
    }
    return markerFormat;
  }

  PdfStringFormat _markerFormatClone(PdfStringFormat format) {
    final PdfStringFormat markerFormat = PdfStringFormat(
        alignment: format.alignment, lineAlignment: format.lineAlignment);
    markerFormat.lineSpacing = format.lineSpacing;
    markerFormat.characterSpacing = format.characterSpacing;
    markerFormat.clipPath = format.clipPath;
    markerFormat.lineLimit = format.lineLimit;
    markerFormat.measureTrailingSpaces = format.measureTrailingSpaces;
    markerFormat.noClip = format.noClip;
    markerFormat.paragraphIndent = format.paragraphIndent;
    markerFormat.subSuperscript = format.subSuperscript;
    markerFormat.textDirection = format.textDirection;
    markerFormat.wordSpacing = format.wordSpacing;
    markerFormat.wordWrap = format.wordWrap;
    PdfStringFormatHelper.getHelper(markerFormat).firstLineIndent =
        PdfStringFormatHelper.getHelper(format).firstLineIndent;
    return markerFormat;
  }

  /// Before the page layout.
  bool _beforePageLayout(
      Rect currentBounds, PdfPage? currentPage, PdfList list) {
    bool cancel = false;
    if (PdfLayoutElementHelper.getHelper(element!).raiseBeginPageLayout &&
        currentPage != null) {
      final ListBeginPageLayoutArgs args =
          ListBeginPageLayoutArgs._(currentBounds, currentPage, list);

      PdfLayoutElementHelper.getHelper(element!).onBeginPageLayout(args);
      cancel = args.cancel;
      bounds = PdfRectangle.fromRect(args.bounds);
      usePaginateBounds = false;
    }
    return cancel;
  }

  /// After the page layouted.
  ListEndPageLayoutArgs? _afterPageLayouted(
      Rect bounds, PdfPage? currentPage, PdfList list) {
    ListEndPageLayoutArgs? args;
    if (PdfLayoutElementHelper.getHelper(element!).raisePageLayouted &&
        currentPage != null) {
      final PdfLayoutResult result =
          PdfLayoutResultHelper.load(currentPage, bounds);
      args = ListEndPageLayoutArgs._internal(result, list);
      PdfLayoutElementHelper.getHelper(element!).onEndPageLayout(args);
    }
    return args;
  }

  /// Before the item layout.
  void _beforeItemLayout(PdfListItem item, PdfPage page) {
    final BeginItemLayoutArgs args =
        BeginItemLayoutArgsHelper.internal(item, page);
    PdfListHelper.getHelper(element!).onBeginItemLayout(args);
  }

  /// Afters the item layouted.
  void _afterItemLayouted(PdfListItem item, PdfPage page) {
    final EndItemLayoutArgs args = EndItemLayoutArgsHelper.internal(item, page);
    PdfListHelper.getHelper(element!).onEndItemLayout(args);
  }

  /// Draws the marker.
  bool _drawMarker(PdfList curList, PdfListItem item,
      PdfStringLayoutResult? markerResult, double posY, double posX) {
    if (curList is PdfOrderedList) {
      if (markerResult != null) {
        if (curList.font != null &&
            curList.font!.size > markerResult.size.height) {
          posY += (curList.font!.size / 2) - (markerResult.size.height / 2);
          markerResult.size.height = markerResult.size.height + posY;
        }
      }
      _drawOrderedMarker(curList, markerResult!, item, posX, posY);
    } else if (curList is PdfUnorderedList) {
      if (curList.marker.font != null && markerResult != null) {
        final PdfFont font = curList.font != null &&
                curList.font!.size > curList.marker.font!.size
            ? curList.font!
            : curList.marker.font!;
        if (font.size > markerResult.size.height) {
          posY += (font.height / 2) - (markerResult.size.height / 2);
          markerResult.size.height = markerResult.size.height + posY;
        }
      }
      _drawUnorderedMarker(curList, markerResult, item, posX, posY);
    }
    return true;
  }

  /// Draws the ordered marker.
  PdfStringLayoutResult _drawOrderedMarker(
      PdfList curList,
      PdfStringLayoutResult markerResult,
      PdfListItem item,
      double posX,
      double posY) {
    final PdfOrderedList oList = curList as PdfOrderedList;
    final PdfOrderedMarker marker = oList.marker;
    final PdfFont markerFont = _getMarkerFont(marker, item)!;
    PdfStringFormat? markerFormat = _getMarkerFormat(marker, item);
    final PdfPen? markerPen = _getMarkerPen(marker, item);
    final PdfBrush? markerBrush = _getMarkerBrush(marker, item);
    final PdfRectangle rect = PdfRectangle(posX - markerMaxWidth!, posY,
        markerResult.size.width, markerResult.size.height);
    rect.width = markerMaxWidth! as double;
    markerFormat = _setMarkerStringFormat(marker, markerFormat);
    PdfGraphicsHelper.getHelper(graphics!).drawStringLayoutResult(
        markerResult, markerFont, markerPen, markerBrush, rect, markerFormat);
    return markerResult;
  }

  /// Draws the unordered marker.
  PdfStringLayoutResult? _drawUnorderedMarker(
      PdfList curList,
      PdfStringLayoutResult? markerResult,
      PdfListItem item,
      double posX,
      double posY) {
    final PdfUnorderedList uList = curList as PdfUnorderedList;
    final PdfUnorderedMarker marker = uList.marker;
    final PdfFont? markerFont = _getMarkerFont(marker, item);
    final PdfPen? markerPen = _getMarkerPen(marker, item);
    final PdfBrush? markerBrush = _getMarkerBrush(marker, item);
    final PdfStringFormat? markerFormat = _getMarkerFormat(marker, item);
    if (markerResult != null) {
      final PdfPoint location = PdfPoint(posX - markerResult.size.width, posY);
      PdfUnorderedMarkerHelper.getHelper(marker).size = markerResult.size;
      if (marker.style == PdfUnorderedMarkerStyle.customString) {
        final PdfRectangle rect = PdfRectangle(location.x, location.y,
            markerResult.size.width, markerResult.size.height);
        PdfGraphicsHelper.getHelper(graphics!).drawStringLayoutResult(
            markerResult,
            markerFont!,
            markerPen,
            markerBrush,
            rect,
            markerFormat);
      } else {
        PdfUnorderedMarkerHelper.getHelper(marker).unicodeFont =
            PdfStandardFont(PdfFontFamily.zapfDingbats, markerFont!.size);
        PdfUnorderedMarkerHelper.getHelper(marker)
            .draw(graphics, location.offset, markerBrush, markerPen);
      }
    } else {
      PdfUnorderedMarkerHelper.getHelper(marker).size =
          PdfSize(markerFont!.size, markerFont.size);
      final PdfPoint location = PdfPoint(posX - markerFont.size, posY);
      PdfUnorderedMarkerHelper.getHelper(marker)
          .draw(graphics, location.offset, markerBrush, markerPen, curList);
    }
    return null;
  }

  /// Gets the marker pen.
  PdfPen? _getMarkerPen(PdfMarker marker, PdfListItem item) {
    PdfPen? markerPen = marker.pen;
    if (marker.pen == null) {
      markerPen = item.pen;
      if (item.pen == null) {
        markerPen = currentPen;
      }
    }
    return markerPen;
  }

  /// Gets the marker brush.
  PdfBrush? _getMarkerBrush(PdfMarker marker, PdfListItem item) {
    PdfBrush? markerBrush = marker.brush;
    if (marker.brush == null) {
      markerBrush = item.brush;
      if (item.brush == null) {
        markerBrush = currentBrush;
      }
    }
    return markerBrush;
  }

  /// Creates the marker result.
  PdfStringLayoutResult? _createMarkerResult(
      int index, PdfList curList, List<_ListInfo> listInfo, PdfListItem item) {
    PdfStringLayoutResult? markerResult;
    if (curList is PdfOrderedList) {
      markerResult =
          _createOrderedMarkerResult(curList, item, index, info, false);
    } else {
      final PdfSize markerSize = PdfSize.empty;
      markerResult = _createUnorderedMarkerResult(curList, item, markerSize);
    }
    return markerResult;
  }

  /// Creates the unordered marker result.
  PdfStringLayoutResult? _createUnorderedMarkerResult(
      PdfList curList, PdfListItem item, PdfSize markerSize) {
    final PdfUnorderedMarker marker = (curList as PdfUnorderedList).marker;
    PdfStringLayoutResult? result;
    final PdfFont? markerFont = _getMarkerFont(marker, item);
    final PdfStringFormat? markerFormat = _getMarkerFormat(marker, item);
    final PdfStringLayouter layouter = PdfStringLayouter();
    switch (marker.style) {
      case PdfUnorderedMarkerStyle.customImage:
        // markerSize = PdfSize(markerFont.size, markerFont.size);
        // marker._size = markerSize;
        break;
      case PdfUnorderedMarkerStyle.customTemplate:
        markerSize = PdfSize(markerFont!.size, markerFont.size);
        PdfUnorderedMarkerHelper.getHelper(marker).size = markerSize;
        break;
      case PdfUnorderedMarkerStyle.customString:
        result = layouter.layout(marker.text!, markerFont!, markerFormat,
            width: size.width, height: size.height);
        break;
      // ignore: no_default_cases
      default:
        final PdfStandardFont uFont =
            PdfStandardFont(PdfFontFamily.zapfDingbats, markerFont!.size);
        result = layouter.layout(
            PdfUnorderedMarkerHelper.getHelper(marker).getStyledText(),
            uFont,
            null,
            width: size.width,
            height: size.height);
        PdfUnorderedMarkerHelper.getHelper(marker).size = result.size;
        if (marker.pen != null) {
          result.size = PdfSize(result.size.width + 2 * marker.pen!.width,
              result.size.height + 2 * marker.pen!.width);
        }
        break;
    }
    return result;
  }
}

/// Represents Page Layout result.
class _PageLayoutResult {
  /// If true item finished layout on page.
  bool broken = false;

  /// Y-ordinate of broken item of marker.
  double? y = 0;

  /// Text of item that was not draw.
  String? itemText;

  /// Text of marker that was not draw.
  String? markerText;

  /// If true marker start draw.
  bool markerWrote = false;

  /// Width of marker.
  double? markerWidth = 0;

  /// X-coordinate of marker.
  double markerX = 0;
}

/// Represents information about list.
class _ListInfo {
  /// Initializes a new instance of the [_ListInfo] class.
  _ListInfo(this.list, this.index, [this.number = '']);

  /// Index of list.
  int index;

  /// Represents list.
  PdfList? list;

  /// The number of item at specified index.
  String number;

  /// Lists brush.
  PdfBrush? brush;

  /// Lists pen.
  PdfPen? pen;

  /// Lists font.
  PdfFont? font;

  /// Lists format.
  PdfStringFormat? format;

  /// Marker width;
  double? markerWidth;
}

/// Represents begin page layout event arguments.
class ListBeginPageLayoutArgs extends BeginPageLayoutArgs {
  /// Initializes a new instance of the [ListBeginPageLayoutArgs] class.
  ListBeginPageLayoutArgs._(super.bounds, super.page, this.list);

  /// Gets the ended layout
  late PdfList list;
}

// ignore: avoid_classes_with_only_static_members
/// [ListBeginPageLayoutArgs] helper
class ListBeginPageLayoutArgsHelper {
  /// internal method
  static ListBeginPageLayoutArgs internal(
      Rect bounds, PdfPage page, PdfList list) {
    return ListBeginPageLayoutArgs._(bounds, page, list);
  }
}

/// Represents begin page layout event arguments.
class ListEndPageLayoutArgs extends EndPageLayoutArgs {
  /// Initializes a new instance of the [ListEndPageLayoutArgs] class.
  ListEndPageLayoutArgs._internal(super.result, this.list);

  /// Gets the ended layout
  PdfList list;
}

// ignore: avoid_classes_with_only_static_members
/// [ListEndPageLayoutArgs] helper
class ListEndPageLayoutArgsHelper {
  /// internal method
  static ListEndPageLayoutArgs internal(PdfLayoutResult result, PdfList list) {
    return ListEndPageLayoutArgs._internal(result, list);
  }
}
