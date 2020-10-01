part of datagrid;

/// PixelScrollAxis supports pixel scrolling and calculates the total height or
/// width of all lines.
///
/// PixelScrollAxis implements scrolling logic for both horizontal and vertical
/// scrolling in a `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances`
/// Logical units in the ScrollAxisBase are called "Lines". With the
/// `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances` a line
/// represents rows in a grid
/// and with `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances` a
/// line represents columns in a grid.
class _PixelScrollAxis extends _ScrollAxisBase {
  /// Initializes a new instance of the PixelScrollAxis class which
  /// is nested as a single line in a parent scroll axis.
  ///
  /// * parentScrollAxis - _required_ - The parent scroll axis.
  /// * scrollBar - _required_ - The scrollbar state.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  /// * distancesHost - _required_ - The distances host.
  _PixelScrollAxis(_ScrollAxisBase parentScrollAxis, _ScrollBarBase scrollBar,
      _LineSizeHostBase scrollLinesHost, _DistancesHostBase distancesHost)
      : super(scrollBar, scrollLinesHost) {
    // GridCellGridRenderer passes in Distances. LineSizeCollection holds them.
    // This allows faster construction of grids when they were scrolled
    // out of view and unloaded.
    _parentScrollAxis = parentScrollAxis;
    _distancesHost = distancesHost;
    _footerExtent = 0.0;
    _headerExtent = 0.0;
    if (distances == null) {
      throw ArgumentError('Distances');
    }
  }

  /// Initializes a new instance of the PixelScrollAxis class.
  ///
  /// * scrollBar - _required_ - The scrollbar state.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  /// * distancesHost - _required_ - The distances host.
  _PixelScrollAxis.fromPixelScrollAxis(_ScrollBarBase scrollBar,
      _LineSizeHostBase scrollLinesHost, _DistancesHostBase distancesHost)
      : super(scrollBar, scrollLinesHost) {
    if (distancesHost != null) {
      _distancesHost = distancesHost;
    } else if (scrollLinesHost != null) {
      _distances = _DistanceRangeCounterCollection()
        ..defaultDistance = scrollLinesHost.getDefaultLineSize();
      scrollLinesHost.initializeScrollAxis(this);
    }

    if (distances == null) {
      throw ArgumentError('Distances');
    }
  }

  /// Distances holds the line sizes. Hidden lines
  /// have a distance of 0.0.
  _DistanceCounterCollectionBase _distances;
  _DistancesHostBase _distancesHost;
  _ScrollAxisBase _parentScrollAxis;
  bool inLineResize = false;

  /// Gets the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  ///
  /// Returns the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  _DistanceCounterCollectionBase get distances {
    if (_distancesHost != null) {
      return _distancesHost.distances;
    }

    return _distances;
  }

  /// Gets the total extent of all line sizes.
  ///
  /// Returns the total extent of all line sizes.
  double get totalExtent => distances.totalDistance;

  /// Gets the default size of lines.
  ///
  /// Returns the default size of lines.
  @override
  double get defaultLineSize => _distances.defaultDistance;

  /// Sets the default size of lines.
  @override
  set defaultLineSize(double value) {
    if (_defaultLineSize != value) {
      if (_distances != null) {
        _distances
          ..defaultDistance = value
          ..clear();

        if (scrollLinesHost != null) {
          scrollLinesHost.initializeScrollAxis(this);
        }
      }

      updateScrollbar();

      if (_parentScrollAxis != null) {
        _parentScrollAxis.setLineSize(
            startLineIndex, startLineIndex, distances.totalDistance);
      }
    }
  }

  /// Gets the footer extent. This is total height (or width) of the
  /// footer lines.
  ///
  /// Returns the footer extent.
  @override
  double get footerExtent {
    getVisibleLines();
    return _footerExtent;
  }

  /// Gets the header extent. This is total height (or width) of the
  /// header lines.
  ///
  /// Returns the header extent.
  @override
  double get headerExtent {
    getVisibleLines();
    return _headerExtent;
  }

  /// Gets a value indicating whether this axis supports pixel scrolling.
  ///
  /// Returns true if this instance supports pixel scrolling, otherwise false.
  @override
  bool get isPixelScroll => true;

  /// Gets the line count.
  ///
  /// Returns the line count.
  @override
  int get lineCount => distances.count;

  /// Sets the line count.
  @override
  set lineCount(int value) {
    if (lineCount != value) {
      if (_distances != null) {
        _distances.count = value;
      }
      updateScrollbar();
    }
  }

  /// Gets the index of the first visible Line in the Body region.
  ///
  /// Returns the index of the scroll line.
  @override
  int get scrollLineIndex =>
      distances.indexOfCumulatedDistance(scrollBar.value);

  /// Sets the index of the first visible Line in the Body region.
  @override
  set scrollLineIndex(int value) {
    setScrollLineIndex(value, 0.0);
  }

  /// Gets the view size of the (either height or width) of the parent control.
  ///
  /// Normally the ViewSize is the same as `ScrollAxisBase.RenderSize`.
  /// Only if the parent control has more space then needed to display
  /// all lines, the ViewSize will be less. In such case the ViewSize is
  /// the total height for all lines.
  ///
  /// Returns the size of the view.
  @override
  double get viewSize => min(renderSize, distances.totalDistance);

  /// Aligns the scroll line.
  @override
  void alignScrollLine() {
    final double d = distances.getAlignedScrollValue(scrollBar.value);
    if (!(d == double.nan)) {
      scrollBar.value = d;
    }
  }

  /// Gets the index of the next scroll line.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the index of the next scroll line.
  @override
  int getNextScrollLineIndex(int index) => distances.getNextVisibleIndex(index);

  /// Gets the index of the previous scroll line.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the index of the previous scroll line.
  @override
  int getPreviousScrollLineIndex(int index) {
    double point = distances.getCumulatedDistanceAt(index);
    point--;
    if (point > -1) {
      return distances.indexOfCumulatedDistance(point);
    }
    return -1;
  }

  /// Gets the index of the scroll line.
  ///
  /// * scrollLineIndex - _required_ - Index of the scroll line.
  /// * scrollLineDelta - _required_ - The scroll line offset.
  /// * isRightToLeft - _optional_ - The boolean value used to calculate
  /// visible columns in right to left mode.
  @override
  List getScrollLineIndex(int scrollLineIndex, double scrollLineDelta,
      [bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      scrollLineIndex =
          max(0, distances.indexOfCumulatedDistance(scrollBar.value));
      if (scrollLineIndex >= lineCount) {
        scrollLineDelta = 0.0;
      } else {
        scrollLineDelta = (scrollBar.value -
                distances.getCumulatedDistanceAt(scrollLineIndex))
            .toDouble();
      }
    } else {
      scrollLineIndex = max(
          0,
          distances.indexOfCumulatedDistance(scrollBar.maximum -
              scrollBar.largeChange -
              scrollBar.value +
              (headerLineCount == 0 ? clip.start : clip.start + headerExtent) +
              (renderSize > scrollBar.maximum + footerExtent
                  ? renderSize - scrollBar.maximum - footerExtent - headerExtent
                  : 0)));

      if (scrollLineIndex >= lineCount) {
        scrollLineDelta = 0.0;
      } else {
        scrollLineDelta = (scrollBar.maximum -
                scrollBar.largeChange -
                scrollBar.value +
                (headerLineCount == 0
                    ? clip.start
                    : (scrollBar.maximum -
                                scrollBar.largeChange -
                                scrollBar.value !=
                            -1
                        ? clip.start + headerExtent
                        : (clip.start > 0
                            ? clip.start + headerExtent + 1
                            : 1))) +
                (renderSize > scrollBar.maximum + footerExtent
                    ? renderSize -
                        scrollBar.maximum -
                        footerExtent -
                        headerExtent
                    : 0) -
                distances.getCumulatedDistanceAt(scrollLineIndex))
            .toDouble();
      }
    }
    return [scrollLineIndex, scrollLineDelta];
  }

  /// Gets the cumulated origin taking scroll position into account.
  ///
  ///
  /// Returned value of this is between `ScrollBar.Minimum` and
  /// `ScrollBar.Maximum`.
  ///
  /// * line - _required_ - The line.
  ///
  /// Returns the cumulated origin
  double getCumulatedOrigin(_VisibleLineInfo line) {
    final _VisibleLinesCollection lines = getVisibleLines();
    if (line.isHeader) {
      return line.origin;
    } else if (line.isFooter) {
      return scrollBar.maximum -
          lines[lines.firstFooterVisibleIndex].origin +
          line.origin;
    }

    return line.origin - scrollBar.minimum + scrollBar.value;
  }

  /// Gets the cumulated corner taking scroll position into account.
  ///
  /// Returned value of this is between `ScrollBar.Minimum`
  /// and `ScrollBar.Maximum`.
  ///
  /// * line - _required_ - The line.
  ///
  /// Returns the cumulated corner
  double getCumulatedCorner(_VisibleLineInfo line) {
    final _VisibleLinesCollection lines = getVisibleLines();
    if (line.isHeader) {
      return line.corner;
    } else if (line.isFooter) {
      return scrollBar.maximum -
          lines[lines.firstFooterVisibleIndex].origin +
          line.corner;
    }

    return line.corner - scrollBar.minimum + scrollBar.value;
  }

  /// This method is called in response to a MouseWheel event.
  ///
  /// * delta - _required_ - The delta.
  @override
  void mouseWheel(int delta) {
    scrollBar.value -= delta;
  }

  /// Called when lines were removed in ScrollLinesHost.
  ///
  /// * removeAt - _required_ - Index of the first removed line.
  /// * count - _required_ - The count.
  @override
  void onLinesRemoved(int removeAt, int count) {
    if (distances != null) {
      distances.remove(removeAt, count);
    }
  }

  /// Called when lines were inserted in ScrollLinesHost.
  ///
  /// * insertAt - _required_ - Index of the first inserted line.
  /// * count - _required_ - The count.
  @override
  void onLinesInserted(int insertAt, int count) {
    if (distances != null) {
      _DistancesUtil.onInserted(distances, scrollLinesHost, insertAt, count);
    }
  }

  /// Returns an array with 3 ranges indicating the first and last point
  /// for the given lines in each region.
  ///
  /// * first - _required_ - The index of the first line.
  /// * last - _required_ - The index of the last line.
  /// * allowEstimatesForOutOfViewLines - _required_ - if set to true allow
  /// estimates for out of view lines.
  ///
  /// Returns An array with 3 ranges indicating the first and last point for
  /// the given lines in each region.
  @override
  List<_DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines) {
    double p1, p2;
    p1 = distances.getCumulatedDistanceAt(first);
    p2 = last >= distances.count - 1
        ? distances.totalDistance
        : distances.getCumulatedDistanceAt(last + 1);

    final List<_DoubleSpan> result = [];
    for (int n = 0; n < 3; n++) {
      _ScrollAxisRegion region;
      if (n == 0) {
        region = _ScrollAxisRegion.header;
      } else if (n == 1) {
        region = _ScrollAxisRegion.body;
      } else if (n == 2) {
        region = _ScrollAxisRegion.footer;
      }
      result.insert(n, rangeToPointsHelper(region, p1, p2));
    }
    return result;
  }

  /// Resets temporary value for line size after a resize operation.
  @override
  void resetLineResize() {
    inLineResize = true;
    super.resetLineResize();
    if (_parentScrollAxis != null) {
      _parentScrollAxis.resetLineResize();
    }

    inLineResize = false;
  }

  /// Returns the first and last point for the given lines in a region.
  ///
  /// * region - _required_ - The region.
  /// * first - _required_ - The index of the first line.
  /// * last - _required_ - The index of the last line.
  /// * allowEstimatesForOutOfViewLines - _required_ - if set to true allow
  /// estimates for out of view lines.
  ///
  /// Returns the first and last point for the given lines in a region.
  @override
  _DoubleSpan rangeToPoints(_ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines) {
    final _VisibleLinesCollection lines = getVisibleLines();

    // If line is visible use already calculated values,
    // otherwise get value from Distances
    final _VisibleLineInfo line1 = lines.getVisibleLineAtLineIndex(first);
    final _VisibleLineInfo line2 = lines.getVisibleLineAtLineIndex(last);

    double p1, p2;
    p1 = line1 == null
        ? distances.getCumulatedDistanceAt(first)
        : getCumulatedOrigin(line1);

    p2 = line2 == null
        ? distances.getCumulatedDistanceAt(last + 1)
        : getCumulatedCorner(line2);

    return rangeToPointsHelper(region, p1, p2);
  }

  _DoubleSpan rangeToPointsHelper(
      _ScrollAxisRegion region, double p1, double p2) {
    final _VisibleLinesCollection lines = getVisibleLines();
    switch (region) {
      case _ScrollAxisRegion.header:
        if (headerLineCount > 0) {
          return _DoubleSpan(p1, p2);
        } else {
          return _DoubleSpan.empty();
        }
        break;
      case _ScrollAxisRegion.footer:
        if (isFooterVisible) {
          final _VisibleLineInfo l = lines[lines.firstFooterVisibleIndex];
          final double p3 = distances.totalDistance - footerExtent;
          p1 += l.origin - p3;
          p2 += l.origin - p3;
          return _DoubleSpan(p1, p2);
        } else {
          return _DoubleSpan.empty();
        }
        break;
      case _ScrollAxisRegion.body:
        p1 += headerExtent - scrollBar.value;
        p2 += headerExtent - scrollBar.value;
        return _DoubleSpan(p1, p2);
        break;
    }

    return _DoubleSpan.empty();
  }

  /// Sets the index of the scroll line.
  ///
  /// * scrollLineIndex - _required_ - Index of the scroll line.
  /// * scrollLineDelta - _required_ - The scroll line delta.
  @override
  void setScrollLineIndex(int scrollLineIndex, double scrollLineDelta) {
    scrollLineIndex = min(lineCount, max(0, scrollLineIndex));
    scrollBar.value =
        distances.getCumulatedDistanceAt(scrollLineIndex) + scrollLineDelta;
    resetVisibleLines();
  }

  /// Scrolls to next page.
  @override
  void scrollToNextPage() {
    scrollBar.value += max(
        scrollBar.smallChange, scrollBar.largeChange - scrollBar.smallChange);
    scrollToNextLine();
  }

  /// Scrolls to next line.
  @override
  void scrollToNextLine() {
    final double d = distances.getNextScrollValue(scrollBar.value);
    if (!(d == double.nan)) {
      scrollBar.value = d <= scrollBar.value
          ? distances.getNextScrollValue(scrollBar.value + 1)
          : d;
    } else {
      scrollBar.value += scrollBar.smallChange;
    }
  }

  /// Scrolls to previous line.
  @override
  void scrollToPreviousLine() {
    final double d = distances.getPreviousScrollValue(scrollBar.value);
    if (!(d == double.nan)) {
      scrollBar.value = d;
    }
  }

  /// Scrolls to previous page.
  @override
  void scrollToPreviousPage() {
    scrollBar.value -= max(
        scrollBar.smallChange, scrollBar.largeChange - scrollBar.smallChange);
    alignScrollLine();
  }

  /// Scrolls the line into viewable area.
  ///
  /// * lineIndex - _required_ - Index of the line.
  /// * lineSize - _required_ - Size of the line.
  /// * isRightToLeft - _required_ - The boolean value used to calculate
  /// visible columns in right to left mode.
  @override
  void scrollInView(int lineIndex, double lineSize, bool isRightToLeft) {
    final _VisibleLinesCollection lines = getVisibleLines();
    final _VisibleLineInfo line = lines.getVisibleLineAtLineIndex(lineIndex);
    double delta = 0;

    if (line != null) {
      if (!line.isClipped || line.isFooter || line.isHeader) {
        return;
      }

      if (line.isClippedOrigin && !line.isClippedCorner) {
        delta = -(lineSize - line.clippedSize);
      } else if (!line.isClippedOrigin && line.isClippedCorner) {
        //Following code prevent the horizontal auto scrolling when column
        // size is bigger than viewPort size.
        if (line.clippedOrigin < line.clippedSize) {
          delta = 0;
        } else {
          delta = lineSize - line.clippedSize;
        }
      } else {
        delta = lineSize - line.clippedSize;
      }
    } else {
      double d = distances.getCumulatedDistanceAt(lineIndex);

      if (d > scrollBar.value) {
        d = d + lineSize - scrollBar.largeChange;
      }

      delta = d - scrollBar.value;
    }

    if (delta != 0) {
      scrollBar.value += delta;
    }
  }

  /// Sets the footer line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setFooterLineCount(int value) {
    if (value == 0) {
      _footerExtent = 0;
    } else {
      if (distances.count <= value) {
        _footerExtent = 0;
        return;
      }

      final int n = distances.count - value;

      // The Total distance must be reduced by the padding size of the Distance
      // total size. Then it should be calculated. This issue is occured in
      // Nested Grid. SD 9312. this will give the exact size of the footer
      // Extent when padding distance is reduced from total distance.
      final isDistanceCounterSubset = distances is _DistanceCounterSubset;
      if (!isDistanceCounterSubset) {
        // Nested Grid cells in GridControl is not
        // DistanceRangeCounterCollection type.
        final _DistanceRangeCounterCollection _distances = distances;
        _footerExtent = distances.totalDistance -
            _distances.paddingDistance -
            distances.getCumulatedDistanceAt(n);
      } else {
        _footerExtent =
            distances.totalDistance - distances.getCumulatedDistanceAt(n);
      }
    }
  }

  /// Sets the header line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setHeaderLineCount(int value) {
    _headerExtent =
        distances.getCumulatedDistanceAt(min(value, distances.count));
  }

  /// Sets the hidden state of the lines.
  ///
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  /// * hide - _required_ - A boolean value indicating whether to hide the
  /// lines. if set to true - [hide].
  @override
  void setLineHiddenState(int from, int to, bool hide) {
    if (hide) {
      setLineSize(from, to, 0.0);
    } else {
      for (int n = from; n <= to; n++) {
        int repeatSizeCount;
        final double size = getLineSizeWithTwoArgs(n, repeatSizeCount)[0];
        repeatSizeCount = getLineSizeWithTwoArgs(n, repeatSizeCount)[1];
        final int rangeTo = getRangeToHelper(n, to, repeatSizeCount);
        setLineSize(n, rangeTo, size);
        n = rangeTo;
      }
    }
  }

  /// Sets the size of the lines for the given range of lines. Will do nothing
  /// for a `LineScrollAxis`.
  ///
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  /// * size - _required_ - The line size.
  @override
  void setLineSize(int from, int to, double size) {
    if (_distances != null) {
      _distances.setRange(from, to, size);
    }

    // special case for SetLineResize when axis is nested. Parent Scroll
    // Axis relies on Distances.TotalDistance and this only gets updated if
    // we temporarily set the value in the collection.
    else if (_distancesHost != null && inLineResize) {
      _distancesHost.distances.setRange(from, to, size);
    }
  }

  /// Set temporary value for a line size during a resize operation
  /// without committing value to ScrollLinesHost.
  ///
  /// * index - _required_ - The index of the line.
  /// * size - _required_ - The size of the line.
  @override
  void setLineResize(int index, double size) {
    inLineResize = true;
    if (distances.getNestedDistances(index) == null) {
      super.setLineResize(index, size);
    } else {
      markDirty();
      raiseChanged(_ScrollChangedAction.lineResized);
    }

    if (_parentScrollAxis != null) {
      _parentScrollAxis.setLineResize(startLineIndex, distances.totalDistance);
    }

    inLineResize = false;
  }

  /// Associates a collection of nested lines with a line in this axis.
  ///
  /// * index - _required_ - The index.
  /// * nestedLines - _required_ - The nested lines.
  void setNestedLines(int index, _DistanceCounterCollectionBase nestedLines) {
    if (distances != null) {
      distances.setNestedDistances(index, nestedLines);
    }
  }

  /// Initialize scrollbar properties from header and footer size and
  /// total size of lines in body.
  @override
  void updateScrollbar() {
    final _ScrollBarBase sb = scrollBar;
    setHeaderLineCount(headerLineCount);
    setFooterLineCount(footerLineCount);

    final double delta = headerExtent - sb.minimum;
    final double oldValue = sb.value;

    sb
      ..minimum = headerExtent
      ..maximum = distances.totalDistance - footerExtent
      ..smallChange = distances.defaultDistance;
    final double proposeLargeChange = scrollPageSize;
    sb.largeChange = proposeLargeChange;

    // SH - Added check for delta != 0 to avoid value being reset when
    // you resize grid such that only header columns are visible and then
    // resize back to larger size.
    // SH 6/22 - Commented out change to sb.Value and also modified
    // ScrollInfo.Value to return Math.Max(minimum,
    // Math.Min(maximum - largeChange, value)); instead.
    if (proposeLargeChange >= 0 && delta != 0) {
      sb.value = oldValue + delta;
    }
  }
}
