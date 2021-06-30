part of datagrid;

/// The LineScrollAxis implements scrolling only for whole lines.
///
/// You can hide lines and LineScrollAxis provides a mapping mechanism between
/// the index of the line and the scroll index and vice versa. Hidden lines
/// are not be counted when the scroll index is determined for a line.
/// The LineScrollAxis does not support scrolling in between
/// lines (pixel scrolling).
/// This can be of advantage if you have a large number of lines with varying
/// line sizes. In such case the LineScrollAxis does not need to maintain
/// a collection that tracks line sizes whereas the `PixelScrollAxis`
/// does need to.
class _LineScrollAxis extends _ScrollAxisBase {
  /// Initializes a new instance of the LineScrollAxis class.
  ///
  /// * scrollBar - _required_ - The state of the scrollbar.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  _LineScrollAxis(_ScrollBarBase scrollBar, _LineSizeHostBase scrollLinesHost)
      : super(scrollBar, scrollLinesHost) {
    _viewSize = 0.0;
    _defaultLineSize = 0.0;
    _headerExtent = 0.0;
    _footerExtent = 0.0;
    final Object _distancesHost = scrollLinesHost;
    if (_distancesHost is _DistancesHostBase) {
      _distances = _distancesHost.distances;
    } else {
      _distances = _DistanceRangeCounterCollection();
    }

    scrollLinesHost.initializeScrollAxis(this);
    _distances!.defaultDistance = 1.0;
  }

  /// distances holds the visible lines. Each visible line
  /// has a distance of 1.0. Hidden lines have a distance of 0.0.
  _DistanceCounterCollectionBase? _distances;

  /// Gets the distances collection which is used internally for mapping
  /// from a point position to
  /// a line index and vice versa.
  ///
  /// Returns the distances collection which is used internally for mapping
  /// from a point position
  /// to a line index and vice versa.
  _DistanceCounterCollectionBase? get distances => _distances;

  /// Gets the total extent of all line sizes.
  ///
  /// Returns the total extent of all line sizes.
  double get totalExtent => distances?.totalDistance ?? 0.0;

  /// Sets the default size of lines.
  @override
  set defaultLineSize(double value) {
    if (defaultLineSize != value) {
      _defaultLineSize = value;
      updateDistances();
      updateScrollbar();
    }
  }

  /// Gets a value indicating whether this axis supports pixel scrolling.
  ///
  /// Returns `true` if this instance supports pixel scrolling;
  /// otherwise, `false`.
  @override
  bool get isPixelScroll => false;

  /// Gets the line count.
  ///
  /// Returns the line count.
  @override
  int get lineCount => _distances?.count ?? 0;

  /// Sets the line count.
  @override
  set lineCount(int value) {
    if (lineCount != value) {
      _distances!.count = value;
      updateScrollbar();
    }
  }

  /// Gets the index of the first visible Line in the Body region.
  ///
  /// Returns the index of the first visible Line in the Body region.
  @override
  int get scrollLineIndex => scrollBarValueToLineIndex(scrollBar!.value);

  /// Sets the index of the first visible Line in the Body region.
  set scrollLinesIndex(int value) {
    setScrollLineIndex(value, 0.0);
  }

  /// Gets the view size of the (either height or width) of the parent control.
  ///
  /// Normally the ViewSize is the same as `ScrollAxisBase.RenderSize`.
  /// Only if the parent control
  /// has more space then needed to display all lines, the ViewSize will be
  /// less. In such case the ViewSize is the total height for all lines.
  ///
  /// Returns the size of the view.
  @override
  double get viewSize {
    if (scrollBar != null &&
        scrollBar!.value + scrollBar!.largeChange > scrollBar!.maximum) {
      return _viewSize;
    } else {
      return renderSize;
    }
  }

  int determineLargeChange() {
    double sbValue = scrollBar!.maximum;
    final double abortSize = scrollPageSize;
    int count = 0;
    _viewSize = 0;

    while (sbValue >= scrollBar!.minimum) {
      final int lineIndex = scrollBarValueToLineIndex(sbValue);
      final double size = getLineSize(lineIndex);
      if (_viewSize + size > abortSize) {
        break;
      }

      count++;
      sbValue--;
      _viewSize += size;
    }

    _viewSize += footerExtent + headerExtent;

    return count;
  }

  int intPreviousPageLineIndex(double p, int index) {
    int result = index;
    while (p > 0) {
      result = index;
      index = getPreviousScrollLineIndex(index);
      if (index == -1) {
        return -1;
      }

      p -= getLineSize(index);
    }

    return result;
  }

  double lineIndexToScrollBarValue(int lineIndex) =>
      _distances?.getCumulatedDistanceAt(lineIndex) ?? 0.0;

  int scrollBarValueToLineIndex(double sbValue) =>
      _distances?.indexOfCumulatedDistance(sbValue) ?? 0;

  /// Updates the line size for visible lines to be "1" for LineScrollAxis
  void updateDistances() {
    int repeatSizeCount = -1;

    for (int index = 0; index < lineCount; index++) {
      final List<dynamic> hiddenValue =
          scrollLinesHost!.getHidden(index, repeatSizeCount);
      final bool hide = hiddenValue[0] as bool;
      repeatSizeCount = hiddenValue[1] as int;
      final double value = hide == true ? 0.0 : 1.0;
      final int rangeTo =
          getRangeToHelper(index, lineCount - 1, repeatSizeCount);
      _distances!.setRange(index, rangeTo, value);
      index = rangeTo;
    }
  }

  /// Aligns the scroll line.
  @override
  void alignScrollLine() {}

  /// Gets the index of the next scroll line.
  ///
  /// * index - _required_ - The current index of the scroll line.
  /// Returns the index of the next scroll line.
  @override
  int getNextScrollLineIndex(int index) {
    if (_distances != null && _distances!.count > index) {
      return _distances!.getNextVisibleIndex(index);
    } else {
      return 0;
    }
  }

  /// Gets the index of the previous scroll line.
  ///
  /// * index - _required_ - The current index of the scroll line.
  /// Returns the index of the previous scroll line.
  @override
  int getPreviousScrollLineIndex(int index) {
    if (_distances != null && _distances!.count > index) {
      return _distances!.getPreviousVisibleIndex(index);
    } else {
      return 0;
    }
  }

  /// Gets the index of the scroll line.
  ///
  /// * scrollLineIndex - _required_ - Index of the scroll line.
  /// * scrollLineDelta - _required_ - The scroll line delta.
  /// * isRightToLeft - _required_ - The boolean value used to calculate visible
  /// columns in right to left mode.
  @override
  List<dynamic> getScrollLineIndex(int scrollLineIndex, double scrollLineDelta,
      [bool isRightToLeft = false]) {
    scrollLineIndex = scrollBarValueToLineIndex(scrollBar!.value);
    scrollLineDelta = 0.0;
    return <dynamic>[scrollLineIndex, scrollLineDelta];
  }

  /// This method is called in response to a MouseWheel event.
  ///
  /// * delta - _required_ - The delta.
  @override
  void mouseWheel(int delta) {
    if (delta > 0) {
      scrollToPreviousLine();
    } else {
      scrollToNextLine();
    }
  }

  /// Called when lines were inserted in ScrollLinesHost.
  ///
  /// * insertAt - _required_ - Index of the first inserted line.
  /// * count - _required_ - The count.
  @override
  void onLinesInserted(int insertAt, int count) {
    final int to = insertAt + count - 1;
    int repeatSizeCount = -1;
    for (int index = insertAt; index <= to; index++) {
      final List<dynamic> hiddenValue =
          scrollLinesHost!.getHidden(index, repeatSizeCount);
      final bool hide = hiddenValue[0] as bool;
      repeatSizeCount = hiddenValue[1] as int;
      final double value = hide == true ? 0.0 : 1.0;
      final int rangeTo = getRangeToHelper(index, to, repeatSizeCount);
      distances!.setRange(index, rangeTo, value);
      index = rangeTo;
    }
  }

  /// The first and last point for the given lines in a region.
  ///
  /// * region - _required_ - The scroll axis region.
  /// * first - _required_ - The index of the first line.
  /// * last - _required_ - The index of the last line.
  /// * allowEstimatesForOutOfViewLines - _required_ - if set to true
  /// allow estimates for out of view lines.
  ///
  /// Returns the first and last point for the given lines in a region.
  @override
  _DoubleSpan rangeToPoints(_ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines) {
    bool firstVisible = false;
    bool lastVisible = false;
    _VisibleLineInfo? firstLine, lastLine;

    final List<dynamic> lineValues = getLinesAndVisibility(
        first, last, true, firstVisible, lastVisible, firstLine, lastLine);
    firstVisible = lineValues[0] as bool;
    lastVisible = lineValues[1] as bool;
    firstLine = lineValues[2] as _VisibleLineInfo?;
    lastLine = lineValues[3] as _VisibleLineInfo?;
    if (firstLine == null || lastLine == null) {
      return _DoubleSpan.empty();
    }

    if (allowEstimatesForOutOfViewLines) {
      switch (region) {
        case _ScrollAxisRegion.header:
          if (!firstLine.isHeader) {
            return _DoubleSpan.empty();
          }

          break;
        case _ScrollAxisRegion.footer:
          if (!lastLine.isFooter) {
            return _DoubleSpan.empty();
          }

          break;
        case _ScrollAxisRegion.body:
          if (firstLine.isFooter || lastLine.isHeader) {
            return _DoubleSpan.empty();
          }

          break;
      }

      return _DoubleSpan(firstLine.origin, lastLine.corner);
    } else {
      switch (region) {
        case _ScrollAxisRegion.header:
          {
            if (!firstLine.isHeader) {
              return _DoubleSpan.empty();
            }

            if (!lastVisible || !lastLine.isHeader) {
              double corner = firstLine.corner;
              for (int n = firstLine.lineIndex + 1; n <= last; n++) {
                corner += getLineSize(n);
              }

              return _DoubleSpan(firstLine.origin, corner);
            }

            return _DoubleSpan(firstLine.origin, lastLine.corner);
          }

        case _ScrollAxisRegion.footer:
          {
            if (!lastLine.isFooter) {
              return _DoubleSpan.empty();
            }

            if (!firstVisible || !firstLine.isFooter) {
              double origin = lastLine.origin;
              for (int n = lastLine.lineIndex - 1; n >= first; n--) {
                origin -= getLineSize(n);
              }

              return _DoubleSpan(origin, lastLine.corner);
            }

            return _DoubleSpan(firstLine.origin, lastLine.corner);
          }

        case _ScrollAxisRegion.body:
          {
            if (firstLine.isFooter || lastLine.isHeader) {
              return _DoubleSpan.empty();
            }

            double origin = firstLine.origin;
            if (!firstVisible || firstLine.region != _ScrollAxisRegion.body) {
              origin = headerExtent;
              for (int n = scrollLineIndex - 1; n >= first; n--) {
                origin -= getLineSize(n);
              }
            }

            double corner = lastLine.corner;
            if (!lastVisible || lastLine.region != _ScrollAxisRegion.body) {
              corner = lastBodyVisibleLine!.corner;
              for (int n = lastBodyVisibleLine!.lineIndex + 1; n <= last; n++) {
                corner += getLineSize(n);
              }
            }

            return _DoubleSpan(origin, corner);
          }
      }
    }
  }

  /// An array with 3 ranges indicating the first and last point
  /// for the given lines in each region.
  ///
  /// * first - _required_ - The index of the first line.
  /// * last - _required_ - The index of the last line.
  /// * allowEstimatesForOutOfViewLines - _required_ - if set to true
  /// allow estimates for out of view lines.
  ///
  /// Returns An array with 3 ranges indicating the first and last point
  /// for the given lines in each region.
  @override
  List<_DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines) {
    final List<_DoubleSpan> result = <_DoubleSpan>[];
    for (int n = 0; n < 3; n++) {
      late _ScrollAxisRegion region;
      if (n == 0) {
        region = _ScrollAxisRegion.header;
      } else if (n == 1) {
        region = _ScrollAxisRegion.body;
      } else if (n == 2) {
        region = _ScrollAxisRegion.footer;
      }

      result.insert(n,
          rangeToPoints(region, first, last, allowEstimatesForOutOfViewLines));
    }

    return result;
  }

  /// Scrolls the line into viewable area.
  ///
  /// * lineIndex - _required_ - The index of the line.
  /// * lineSize - _required_ - The size of the line.
  /// * isRightToLeft - _required_ - The boolean value used to calculate
  /// visible columns in right to left mode.
  @override
  void scrollInView(int lineIndex, double lineSize, bool isRightToLeft) {
    final _VisibleLinesCollection lines = getVisibleLines();
    final _VisibleLineInfo? line = lines.getVisibleLineAtLineIndex(lineIndex);
    double delta = 0;

    if (line != null) {
      if (!line.isClipped || line.isFooter || line.isHeader) {
        return;
      }

      if (line.isClippedOrigin && !line.isClippedCorner) {
        delta = -1;
      } else if (!line.isClippedOrigin && line.isClippedCorner) {
        double y = line.size - line.clippedSize;
        double visibleScrollIndex = scrollBar!.value;
        while (y > 0 && visibleScrollIndex < scrollBar!.maximum) {
          delta++;
          visibleScrollIndex++;
          y -= getLineSize(scrollBarValueToLineIndex(visibleScrollIndex));
        }
      }
    } else {
      double visibleScrollIndex = lineIndexToScrollBarValue(lineIndex);

      if (visibleScrollIndex > scrollBar!.value) {
        final int scrollIndexLinex = intPreviousPageLineIndex(
            scrollPageSize - getLineSize(lineIndex), lineIndex);
        visibleScrollIndex = lineIndexToScrollBarValue(scrollIndexLinex);
      }

      delta = visibleScrollIndex - scrollBar!.value;
    }

    if (delta != 0) {
      scrollBar!.value += delta;
    }

    super.scrollInView(lineIndex, lineSize, isRightToLeft);
  }

  /// Scrolls to next line.
  @override
  void scrollToNextLine() {
    scrollLineIndex = getNextScrollLineIndex(scrollLineIndex);
  }

  /// Scrolls to next page.
  @override
  void scrollToNextPage() {
    int index = visiblePointToLineIndexWithTwoArgs(scrollPageSize, true);
    if (index == scrollLineIndex) {
      index = getNextScrollLineIndex(index);
    }

    scrollLineIndex = index;
  }

  /// Scrolls to previous line.
  @override
  void scrollToPreviousLine() {
    scrollLineIndex = getPreviousScrollLineIndex(scrollLineIndex);
  }

  /// Scrolls to previous page.
  @override
  void scrollToPreviousPage() {
    int index = intPreviousPageLineIndex(scrollPageSize, scrollLineIndex);
    if (index == scrollLineIndex) {
      index = getPreviousScrollLineIndex(index);
    }

    scrollLineIndex = index;
  }

  /// Sets the index of the scroll line.
  ///
  /// * scrollLineIndex - _required_ - The index of the scroll line.
  /// * scrollLineDelta - _required_ - The scroll line delta.
  @override
  void setScrollLineIndex(int scrollLineIndex, double scrollLineDelta) {
    scrollLineIndex =
        min(max(_distances!.count - 1, 0), max(0, scrollLineIndex));
    scrollBar!.value = lineIndexToScrollBarValue(scrollLineIndex);
    resetVisibleLines();
  }

  /// Sets the footer line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setFooterLineCount(int value) {
    double size = 0.0;
    int lines = 0;
    int index = lineCount - 1;
    while (lines < value) {
      size += getLineSize(index--);
      lines++;
    }

    _footerExtent = size;
  }

  /// Sets the header line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setHeaderLineCount(int value) {
    double size = 0.0;
    int lines = 0;
    while (lines < value) {
      size += getLineSize(lines++);
    }
    _headerExtent = size;
  }

  /// Sets the hidden state of the lines.
  ///
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  /// * hide - _required_ - A boolean value indicating whether to hide the
  /// lines. if set to true - [hide].
  @override
  void setLineHiddenState(int from, int to, bool hide) {
    _distances!.setRange(from, to, hide ? 0.0 : 1.0);
  }

  /// Sets the size of the lines for the given range of lines. Will do nothing
  /// for a `LineScrollAxis`.
  ///
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  /// * size - _required_ - The line size.
  @override
  void setLineSize(int from, int to, double size) {}

  /// Initialize scrollbar properties from line count in header,
  /// footer and body.
  @override
  void updateScrollbar() {
    setHeaderLineCount(headerLineCount);
    setFooterLineCount(footerLineCount);

    final _ScrollBarBase sb = scrollBar!;
    final bool isMinimum = sb.minimum == sb.value;
    sb.minimum = headerLineCount.toDouble();
    final double maximum = _distances!.totalDistance - footerLineCount;
    sb
      ..maximum = max(maximum, 0)
      ..smallChange = 1
      ..largeChange = determineLargeChange().toDouble()
      ..value =
          isMinimum ? sb.minimum : max(sb.minimum, min(sb.maximum, sb.value));
  }
}
