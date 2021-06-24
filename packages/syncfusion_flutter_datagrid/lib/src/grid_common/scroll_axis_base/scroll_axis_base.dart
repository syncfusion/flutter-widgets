part of datagrid;

/// ScrollAxisBase is an abstract base class and implements scrolling
/// logic for both horizontal and vertical scrolling in a
/// `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances`.
/// Logical units in the ScrollAxisBase are called "Lines". With the
/// `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.distances` a
/// line represents rows in a grid
/// and with `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances`
/// a line represents columns in a grid.
///
/// ScrollAxisBase has support for frozen header and footer lines, maintaining a
/// scroll position and updating and listening to scrollbars. It also maintains
/// a collection of `VisibleLineInfo` items for all the lines that are
/// visible in the viewing area. ScrollAxisBase wires itself with a
/// `ScrollLinesHost` and reacts to changes in line count,
/// line sizes, hidden state and default line size.
typedef _ChangedCallback = void Function(_ScrollChangedArgs scrollChangedArgs);

abstract class _ScrollAxisBase {
  /// Initializes a new instance of the ScrollAxisBase class.
  ///
  /// * scrollBar The scroll bar state.
  /// * scrollLinesHost The scroll lines host.
  _ScrollAxisBase(
      _ScrollBarBase? scrollBar, _LineSizeHostBase? scrollLinesHost) {
    if (scrollBar == null) {
      throw Exception();
    }
    _viewSize = 0.0;
    _headerExtent = 0.0;
    _footerExtent = 0.0;
    _isPixelScroll = false;
    this.scrollBar = scrollBar;
    _scrollLinesHost = scrollLinesHost;
    wireScrollLinesHost();
  }

  double _renderSize = 0.0;
  _ScrollBarBase? _scrollBar;
  late _LineSizeHostBase? _scrollLinesHost;
  bool _layoutDirty = false;
  int _lineResizeIndex = -1;
  double _lineResizeSize = 0;
  final _VisibleLinesCollection _visibleLines = _VisibleLinesCollection();
  double _lastScrollValue = -1;
  _DoubleSpan clip = _DoubleSpan.empty();
  bool _ignoreScrollBarPropertyChange = false;
  bool _inGetVisibleLines = false;
  bool _allBodyLinesShown = false;
  int _lastBodyLineIndex = -1;
  bool indebug = false;

  //code to handle issue in DT 77714
  static double ePSILON = 2.2204460492503131e-016;
  /* smallest such that 1.0+EPSILON != 1.0 */

  static bool strictlyLessThan(double d1, double d2) =>
      !(d1 > d2 || areClose(d1, d2));

  static bool areClose(double d1, double d2) {
    if (d1 == d2) {
      return true;
    }

    final double eps = (d1.abs() + d2.abs() + 10.0) * ePSILON;
    return (d1 - d2).abs() < eps;
  }

  /// Occurs when a scroll axis changed.
  _ChangedCallback? onChangedCallback;

  /// Gets the default size of lines.
  ///
  /// Returns the default size of lines.
  double get defaultLineSize => _defaultLineSize;
  double _defaultLineSize = 0.0;

  /// Sets the default size of lines.
  set defaultLineSize(double value) {
    if (value == _defaultLineSize) {
      return;
    }

    _defaultLineSize = value;
  }

  /// Gets the footer extent. This is total height (or width)
  /// of the footer lines.
  ///
  /// Returns the footer extent.
  double get footerExtent => _footerExtent;
  double _footerExtent = 0.0;

  /// Gets the footer line count.
  ///
  /// Returns the footer line count.
  int get footerLineCount {
    if (scrollLinesHost == null) {
      return 0;
    }

    return scrollLinesHost?.getFooterLineCount() ?? 0;
  }

  /// Gets the index of the first footer line.
  ///
  /// Returns the index of the first footer line.
  int get firstFooterLineIndex => lineCount - footerLineCount;

  /// Gets the header extent. This is total height (or width)
  /// of the header lines.
  ///
  /// Returns the header extent.
  double get headerExtent => _headerExtent;
  double _headerExtent = 0.0;

  /// Gets the header line count.
  ///
  /// Returns the header line count.
  int get headerLineCount {
    if (scrollLinesHost == null) {
      return 0;
    }

    return scrollLinesHost?.getHeaderLineCount() ?? 0;
  }

  /// Gets a value indicating whether footer lines are visible.
  ///
  /// @value
  /// true if footer lines are visible, otherwise false.
  bool get isFooterVisible {
    final _VisibleLinesCollection visibleLines = getVisibleLines();
    return visibleLines.firstFooterVisibleIndex < visibleLines.length;
  }

  /// Gets a value indicating whether this axis supports pixel scrolling.
  ///
  /// @value
  /// `true` if this instance supports pixel scrolling, otherwise `false`.
  bool get isPixelScroll => _isPixelScroll;
  late bool _isPixelScroll;

  /// Gets the last visible line.
  ///
  /// Returns the last visible line.
  _VisibleLineInfo? get lastBodyVisibleLine {
    final _VisibleLinesCollection visibleLines = getVisibleLines();
    if (visibleLines.isEmpty ||
        visibleLines.lastBodyVisibleIndex > visibleLines.length) {
      return null;
    }

    return visibleLines[visibleLines.lastBodyVisibleIndex];
  }

  /// Gets the index of the last visible line.
  ///
  /// Returns the index of the last visible line.
  int get lastBodyVisibleLineIndex {
    final _VisibleLinesCollection visibleLines = getVisibleLines();
    if (visibleLines.isEmpty ||
        visibleLines.lastBodyVisibleIndex > visibleLines.length) {
      return -1;
    }

    return visibleLines[visibleLines.lastBodyVisibleIndex].lineIndex;
  }

  /// Gets the line count.
  ///
  /// Returns the line count.
  int get lineCount => _lineCount;
  int _lineCount = 0;

  /// Sets the line count.
  set lineCount(int value) {
    if (value == _lineCount) {
      return;
    }

    _lineCount = value;
  }

  /// Gets the name.
  ///
  /// Returns the name.
  String? get name => _name;
  String? _name;

  /// Sets the name.
  set name(String? value) {
    if (value == _name) {
      return;
    }

    _name = value;
  }

  /// Sets the size (either height or width) of the parent control.
  ///
  /// Returns the size of the parent control.
  double get renderSize => _renderSize;

  /// Sets the size (either height or width) of the parent control.
  set renderSize(double value) {
    if (_renderSize != value) {
      _renderSize = value;
      markDirty();
      updateScrollBar(true);
    }
  }

  /// Gets the scroll bar state.
  ///
  /// Returns the scroll bar state.
  _ScrollBarBase? get scrollBar => _scrollBar;
  set scrollBar(_ScrollBarBase? value) {
    if (value == _scrollBar) {
      return;
    }

    _scrollBar = value;
  }

  /// Gets the scroll lines host.
  ///
  /// Returns the scroll lines host.
  _LineSizeHostBase? get scrollLinesHost => _scrollLinesHost;

  /// Scroll = First Visible Body Line
  ///
  /// Gets the index of the first visible Line in the body region.
  ///
  /// Returns the index of the scroll line.
  int get scrollLineIndex => _scrollLineIndex;
  int _scrollLineIndex = 0;

  /// Sets the index of the first visible Line in the body region.
  set scrollLineIndex(int value) {
    if (value == _scrollLineIndex) {
      return;
    }

    _scrollLineIndex = value;
  }

  /// Support for sharing axis with a parent axis
  /// Gets the index of the first line in a parent axis.
  ///
  /// This is used for shared
  /// or nested scroll axis (e.g. a nested grid with shared axis
  /// in a covered cell).
  ///
  /// Returns the index of the first line.
  int get startLineIndex => _startLineIndex;
  int _startLineIndex = -1;

  /// Sets the index of the first line in a parent axis.
  set startLineIndex(int value) {
    if (value == _startLineIndex) {
      return;
    }

    _startLineIndex = value;
  }

  /// Gets the size (either height or width) of the parent control excluding the
  /// area occupied by Header and Footer. This size is used for scrolling down
  /// or up one page.
  ///
  /// Returns the size of the parent control.
  double get scrollPageSize => renderSize - headerExtent - footerExtent;

  /// Gets the view size of the (either height or width) of the parent control.
  /// Normally the ViewSize is the same as `RenderSize`.
  /// Only if the parent control has more space then needed to display
  /// all lines, the ViewSize will be less. In such case the ViewSize is
  /// the total height for all lines.
  ///
  /// Returns the view size of the (either height or width)
  /// of the parent control.
  double get viewSize => _viewSize;
  double _viewSize = 0.0;

  /// Adjusts the footer extent to avoid gap between last visible line
  /// of body region and first line of footer in case the view is larger
  /// than the height/width of all lines.
  ///
  /// * footerSize Size of the footer.
  /// * arrangeSize Size of the arrange.
  /// Returns the
  double adjustFooterExtentToAvoidGap(double footerSize, double arrangeSize) {
    // Adjust start of footer to avoid gap after last row.
    if (viewSize < arrangeSize) {
      footerSize += arrangeSize - viewSize;
    }

    if (footerSize + headerExtent > arrangeSize) {
      footerSize = max(0, arrangeSize - headerExtent);
    }

    return footerSize;
  }

  /// Aligns the scroll line.
  void alignScrollLine();

  /// Gets a boolean value indicating whether any of the lines with the
  /// given absolute line index are visible.
  ///
  /// * lineIndex1 The line index 1.
  /// * lineIndex2 The line index 2.
  /// A boolean value indicating whether any of the lines with
  /// the given absolute line index are visible.
  bool anyVisibleLines(int lineIndex1, int lineIndex2) =>
      _visibleLines.anyVisibleLines(lineIndex1, lineIndex2);

  void defaultLineSizeChangedCallback(
      _DefaultLineSizeChangedArgs defaultLineSizeChangedArgs) {
    if (scrollLinesHost != null) {
      defaultLineSize = scrollLinesHost!.getDefaultLineSize();
      markDirty();
      updateScrollBar(true);
      raiseChanged(_ScrollChangedAction.defaultLineSizeChanged);
    }
  }

  void footerLineChangedCallback() {
    if (scrollLinesHost != null) {
      setFooterLineCount(scrollLinesHost!.getFooterLineCount());
      markDirty();
      raiseChanged(_ScrollChangedAction.footerLineCountChanged);
    }
  }

  /// Freezes the visible lines.
  void freezeVisibleLines() {
    _inGetVisibleLines = true;
  }

  /// Gets the size from `ScrollLinesHost` or if the line is being resized
  /// then get temporary value previously set with `SetLineResize`.
  /// If size is negative then `DefaultLineSize` is returned.
  ///
  /// * index The index of the line.
  /// * repeatSizeCount The number of subsequent values with same size.
  ///
  /// The size from `ScrollLinesHost` or if the line is being resized
  /// then get temporary value previously set with `SetLineResize`.
  /// If size is negative then `DefaultLineSize` is returned.
  List<dynamic> getScrollLinesHostSize(int index, int repeatSizeCount) {
    final List<dynamic> lineSize =
        scrollLinesHost!.getSize(index, repeatSizeCount);
    double size = lineSize[0] as double;
    repeatSizeCount = lineSize[1] as int;

    if (size < 0) {
      size = defaultLineSize;
    }

    return <dynamic>[size, repeatSizeCount];
  }

  /// Gets the size from `ScrollLinesHost` or if the line is being resized
  /// then get temporary value previously set with `SetLineResize`
  ///
  /// * index The index.
  /// * repeatSizeCount The number of subsequent values with same size.
  /// Returns the size from `ScrollLinesHost` or if the line is being resized
  /// then get temporary value previously set with `SetLineResize`
  List<dynamic> getLineSizeWithTwoArgs(int index, int? repeatSizeCount) {
    repeatSizeCount = 1;
    if (index == _lineResizeIndex) {
      return <dynamic>[_lineResizeSize, repeatSizeCount];
    }

    if (scrollLinesHost == null) {
      repeatSizeCount = _MathHelper.maxvalue;
      return <dynamic>[defaultLineSize, repeatSizeCount];
    }

    return <dynamic>[
      getScrollLinesHostSize(index, repeatSizeCount)[0],
      getScrollLinesHostSize(index, repeatSizeCount)[1]
    ];
  }

  /// Gets the size of the line.
  ///
  /// * index The index of the line.
  /// Returns the size of the line.
  double getLineSize(int index) {
    int? repeatSizeCount;
    return getLineSizeWithTwoArgs(index, repeatSizeCount)[0] as double;
  }

  /// Gets the index of the next scroll line.
  ///
  /// * lineIndex The current index of the line.
  /// Returns the index of the next scroll line.
  int getNextScrollLineIndex(int lineIndex);

  /// Gets the origin and corner points of body region.
  ///
  /// * origin The origin.
  /// * corner The corner.
  void getOriginAndCornerOfBodyRegion(double origin, double corner) {
    int scrollLineIndex = 0;
    double scrollOffset = 0.0;
    final List<dynamic> lineInfo =
        getScrollLineIndex(scrollLineIndex, scrollOffset);
    scrollLineIndex = lineInfo[0] as int;
    scrollOffset = lineInfo[1] as double;
    final double arrangeSize = renderSize;
    final double adjustedFooterExtent =
        adjustFooterExtentToAvoidGap(footerExtent, arrangeSize);
    origin = headerExtent - scrollOffset;
    corner = arrangeSize - adjustedFooterExtent;
  }

  /// Gets the index of the previous scroll line.
  ///
  /// * lineIndex The current index of the line.
  /// Returns the index of the previous scroll line.
  int getPreviousScrollLineIndex(int lineIndex);

  /// Gets the index of the scroll line in RTL Mode
  ///
  /// * scrollLineIndex Index of the scroll line.
  /// * scrollLineOffset The scroll line offset.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  List<dynamic> getScrollLineIndex(int scrollLineIndex, double scrollLineOffset,
      [bool isRightToLeft = false]);

  /// Gets the maximum range
  ///
  /// * n start index
  /// * to end index
  /// * repeatSizeCount repeat count value
  /// Returns the minimum index value
  int getRangeToHelper(int n, int to, int repeatSizeCount) {
    if (repeatSizeCount == _MathHelper.maxvalue) {
      return to;
    }

    return min(to, n + repeatSizeCount - 1);
  }

  /// Gets the visible lines collection.
  ///
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the visible lines collection.
  _VisibleLinesCollection getVisibleLines([bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      if (_inGetVisibleLines) {
        return _visibleLines;
      }

      _inGetVisibleLines = true;
      try {
        if (_layoutDirty) {
          setHeaderLineCount(headerLineCount);
          setFooterLineCount(footerLineCount);

          _lastScrollValue = -1;
          _layoutDirty = false;
          updateScrollBar(true);
        }
        if (_visibleLines.isEmpty || _lastScrollValue != scrollBar!.value) {
          _visibleLines.clear();

          int visibleIndex = 0;
          int scrollLineIndex = 0;
          double scrollOffset = 0.0;
          final int headerLineCount = this.headerLineCount;
          final List<dynamic> scrollLineValues =
              getScrollLineIndex(scrollLineIndex, scrollOffset);
          scrollLineIndex = scrollLineValues[0] as int;
          scrollOffset = scrollLineValues[1] as double;
          final int firstFooterLine = lineCount - footerLineCount;
          final double footerStartPoint = renderSize - footerExtent;
          int index;

          // Header
          double point = 0;
          int lastHeaderLineIndex = -1;
          for (index = 0;
              index != -1 &&
                  strictlyLessThan(point, headerExtent) &&
                  index < firstFooterLine &&
                  index < headerLineCount;
              index = getNextScrollLineIndex(index)) {
            final double size = getLineSize(index);
            final _VisibleLineInfo line = _VisibleLineInfo(
                visibleIndex++, index, size, point, 0, true, false);
            _visibleLines.add(line);
            point += size;
            lastHeaderLineIndex = index;
          }

          _visibleLines.firstBodyVisibleIndex = _visibleLines.length;

          _VisibleLineInfo? lastScrollableLine;
          // Body
          point = headerExtent;
          final int firstBodyLineIndex =
              max(scrollLineIndex, lastHeaderLineIndex + 1);
          for (index = firstBodyLineIndex;
              index != -1 &&
                  strictlyLessThan(point, footerStartPoint) &&
                  index < firstFooterLine;
              index = getNextScrollLineIndex(index)) {
            final double size = getLineSize(index);
            _visibleLines.add(lastScrollableLine = _VisibleLineInfo(
                visibleIndex++,
                index,
                size,
                point,
                scrollOffset,
                false,
                false));
            point += size - scrollOffset;
            scrollOffset = 0; // reset scrollOffset after first line.
            // Subsequent lines will start at given point.
          }

          if (lastScrollableLine == null) {
            _allBodyLinesShown = true;
            _lastBodyLineIndex = -1;
          } else {
            _allBodyLinesShown = index >= firstFooterLine;
            _lastBodyLineIndex = lastScrollableLine.lineIndex;
          }

          _visibleLines.firstFooterVisibleIndex = _visibleLines.length;

          // Footer
          point = max(headerExtent, viewSize - footerExtent);
          for (index = firstFooterLine;
              index != -1 &&
                  strictlyLessThan(point, renderSize) &&
                  index < lineCount;
              index = getNextScrollLineIndex(index)) {
            if (lastScrollableLine != null) {
              lastScrollableLine.clippedCornerExtent =
                  lastScrollableLine.corner - point;
              lastScrollableLine = null;
            }

            final double size = getLineSize(index);
            _visibleLines.add(_VisibleLineInfo(
                visibleIndex++, index, size, point, 0, false, true));
            point += size;
          }

          if (lastScrollableLine != null) {
            lastScrollableLine.clippedCornerExtent =
                lastScrollableLine.corner - point;
            lastScrollableLine = null;
          }

          _lastScrollValue = scrollBar!.value;

          if (_visibleLines.isNotEmpty) {
            _visibleLines[_visibleLines.length - 1].isLastLine = true;
          }
          try {
            // throws exception when a line is duplicate
            _visibleLines.getVisibleLineAtLineIndex(0);
          } on Exception {
            if (!indebug) {
              indebug = true;
              _visibleLines.clear();
              try {
                getVisibleLines();
              } finally {
                indebug = false;
              }
            }
          }
        }
      } finally {
        _inGetVisibleLines = false;
      }
      return _visibleLines;
    } else {
      if (_inGetVisibleLines) {
        return _visibleLines;
      }

      _inGetVisibleLines = true;
      try {
        if (_layoutDirty) {
          setHeaderLineCount(headerLineCount);
          setFooterLineCount(footerLineCount);
          _lastScrollValue = -1;
          _layoutDirty = false;
          updateScrollBar(true);
        }

        if (_visibleLines.isEmpty || _lastScrollValue != scrollBar!.value) {
          _visibleLines.clear();
          int visibleIndex = 0;
          int scrollLineIndex = 0;
          double scrollOffset = 0.0;
          final int _headerLineCount = headerLineCount;
          final List<dynamic> scrollLineValues =
              getScrollLineIndex(scrollLineIndex, scrollOffset, true);
          scrollLineIndex = scrollLineValues[0] as int;
          scrollOffset = scrollLineValues[1] as double;
          final int firstFooterLine = lineCount - footerLineCount;
          int index;
          double footerStartPoint = renderSize + clip.start;

          // Header
          double point = 0;
          int lastHeaderLineIndex = -1;
          for (index = 0;
              index != -1 &&
                  strictlyLessThan(point, headerExtent) &&
                  index < firstFooterLine &&
                  index < _headerLineCount;
              index = getNextScrollLineIndex(index)) {
            final double size = getLineSize(index);
            _visibleLines.add(_VisibleLineInfo(visibleIndex++, index, size,
                footerStartPoint - size - point, 0, true, false));
            footerStartPoint -= size;
            lastHeaderLineIndex = index;
          }

          _visibleLines.firstBodyVisibleIndex = _visibleLines.length;
          _VisibleLineInfo? lastScrollableLine;

          // Body
          point = headerExtent;
          int firstBodyLineIndex =
              max(scrollLineIndex, lastHeaderLineIndex + 1);

          point = footerStartPoint - clip.start;

          if (clip.start > 0 && scrollOffset < clip.start) {
            scrollOffset =
                getLineSize(scrollLineIndex - 1) - (clip.start - scrollOffset);
            scrollLineIndex -= 1;
            point += clip.start;
          }

          firstBodyLineIndex = max(scrollLineIndex, lastHeaderLineIndex + 1);
          for (index = firstBodyLineIndex;
              index != -1 &&
                  strictlyLessThan(
                      point - 1, renderSize + clip.start - headerExtent) &&
                  (point > footerExtent) &&
                  (index < firstFooterLine && index >= headerLineCount);
              index = getNextScrollLineIndex(index)) {
            final double size = getLineSize(index);
            _visibleLines.add(lastScrollableLine = _VisibleLineInfo(
                visibleIndex++,
                index,
                size,
                point - size + scrollOffset,
                scrollOffset,
                false,
                false));
            point -= size - scrollOffset;
            scrollOffset = 0;
          }

          if (lastScrollableLine == null) {
            _allBodyLinesShown = true;
            _lastBodyLineIndex = -1;
          } else {
            _allBodyLinesShown = index >= firstFooterLine;
            _lastBodyLineIndex = lastScrollableLine.lineIndex;
          }

          _visibleLines.firstFooterVisibleIndex = _visibleLines.length;

          if (footerLineCount > 0) {
            if (renderSize < scrollBar!.maximum + footerExtent) {
              point = min(renderSize + clip.start - headerExtent,
                  clip.start + footerExtent);
              for (index = firstFooterLine;
                  index != -1 &&
                      strictlyLessThan(
                          point - 1,
                          renderSize < scrollBar!.maximum
                              ? clip.start + footerExtent
                              : renderSize - headerExtent) &&
                      index < lineCount;
                  index = getNextScrollLineIndex(index)) {
                if (lastScrollableLine != null) {
                  lastScrollableLine.clippedCornerExtent =
                      lastScrollableLine.corner - point;
                  lastScrollableLine = null;
                }

                final double size = getLineSize(index);
                _visibleLines.add(_VisibleLineInfo(
                    visibleIndex++, index, size, point - size, 0, false, true));
                point -= size;
              }
            } else {
              for (index = firstFooterLine;
                  index != -1 &&
                      strictlyLessThan(
                          point - 1,
                          renderSize < scrollBar!.maximum
                              ? clip.start + footerExtent
                              : renderSize - headerExtent) &&
                      index < lineCount;
                  index = getNextScrollLineIndex(index)) {
                if (lastScrollableLine != null) {
                  lastScrollableLine.clippedCornerExtent =
                      lastScrollableLine.corner - point;
                  lastScrollableLine = null;
                }

                final double size = getLineSize(index);
                _visibleLines.add(_VisibleLineInfo(
                    visibleIndex++, index, size, point - size, 0, false, true));
                point -= size;
              }
            }
          }

          if (lastScrollableLine != null) {
            lastScrollableLine.clippedCornerExtent =
                lastScrollableLine.corner - point;
            lastScrollableLine = null;
          }

          _lastScrollValue = scrollBar!.value;
          if (_visibleLines.isNotEmpty) {
            _visibleLines[_visibleLines.length - 1].isLastLine = true;
          }

          try {
            // throws exception when a line is duplicate
            _visibleLines.getVisibleLineAtLineIndex(0);
          } on Exception {
            if (!indebug) {
              indebug = true;
              _visibleLines.clear();
              try {
                getVisibleLines(true);
              } finally {
                indebug = false;
              }
            }
          }
        }
      } finally {
        _inGetVisibleLines = false;
      }
      return _visibleLines;
    }
  }

  /// Gets the visible line for a point in the display.
  ///
  /// * point The point in the display for which the visible line
  /// is to be obtained.
  /// * allowOutSideLines boolean value
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the visible line for a point in the display.
  _VisibleLineInfo? getVisibleLineAtPoint(double point,
      [bool allowOutSideLines = false, bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      if (allowOutSideLines) {
        point = max(point, 0);
      }

      final _VisibleLineInfo? lineInfo =
          getVisibleLines().getVisibleLineAtPoint(point);
      if (lineInfo != null && (allowOutSideLines || point <= lineInfo.corner)) {
        return lineInfo;
      }
    } else {
      if (allowOutSideLines) {
        point = max(point, 0);
      }

      final _VisibleLinesCollection collection = getVisibleLines(true);
      final _VisibleLinesCollection reversedCollection = collection.reversed;
      final _VisibleLineInfo? lineInfo =
          reversedCollection.getVisibleLineAtPoint(point);
      if (lineInfo != null && (allowOutSideLines || point <= lineInfo.corner)) {
        return lineInfo;
      }
    }

    return null;
  }

  /// Gets the visible line that displays the line with the
  /// given absolute line index.
  ///
  /// * lineIndex Index of the line.
  /// The visible line that displays the line with the given
  /// absolute line index.

  _VisibleLineInfo? getVisibleLineAtLineIndex(int lineIndex) =>
      getVisibleLines().getVisibleLineAtLineIndex(lineIndex);

  /// Gets the visible line that displays the line with the given absolute
  /// line index. If the line is outside the view and you specify
  /// `allowCreateEmptyLineIfNotVisible` then the method will create an empty
  /// line and initializes its line index and line size.
  ///
  /// * lineIndex Index of the line.
  /// * allowCreateEmptyLineIfNotVisible if set to true and if the
  /// line is outside the view then the method will create an empty
  /// line and initializes its LineIndex and LineSize.
  /// Returns the visible line that displays the line with the given
  /// absolute line index.
  _VisibleLineInfo? getVisibleLineAtLineIndexWithTwoArgs(
      int lineIndex, bool allowCreateEmptyLineIfNotVisible) {
    _VisibleLineInfo? line = getVisibleLineAtLineIndex(lineIndex);
    if (line == null && allowCreateEmptyLineIfNotVisible) {
      final double size = getLineSize(lineIndex);
      line = _VisibleLineInfo(_MathHelper.maxvalue, lineIndex, size,
          renderSize + 1, size, false, false);
    }

    return line;
  }

  /// Returns the first and last VisibleLine.LineIndex for area identified
  /// by section.
  ///
  /// * section The integer value indicating the section : 0 - Header,
  /// 1 - Body, 2 - Footer
  /// Returns the first and last VisibleLine.LineIndex for area identified
  /// by section.
  _Int32Span getVisibleLinesRange(_ScrollAxisRegion section) {
    final _VisibleLinesCollection visibleLines = getVisibleLines();
    int start = 0;
    int end = 0;
    final List<int> visibleSection = getVisibleSection(section, start, end);
    start = visibleSection[0];
    end = visibleSection[1];
    return _Int32Span(
        visibleLines[start].lineIndex, visibleLines[end].lineIndex);
  }

  /// Return indexes for VisibleLinesCollection for area identified by section.
  ///
  /// * section The integer value indicating the section : 0 - Header,
  /// 1 - Body, 2 - Footer
  /// * start The start index.
  /// * end The end index.
  void getVisibleSectionWithThreeArgs(
      _ScrollAxisRegion section, int start, int end) {
    getVisibleSection(section, start, end);
  }

  /// Return indexes for VisibleLinesCollection for area identified by section.
  ///
  /// * section The integer value indicating the section : 0 - Header,
  /// 1 - Body, 2 - Footer
  /// * start The start index.
  /// * end The end index.
  List<int> getVisibleSection(_ScrollAxisRegion section, int start, int end) {
    final _VisibleLinesCollection visibleLines = getVisibleLines();
    switch (section) {
      case _ScrollAxisRegion.header:
        start = 0;
        end = visibleLines.firstBodyVisibleIndex - 1;
        break;
      case _ScrollAxisRegion.body:
        start = visibleLines.firstBodyVisibleIndex;
        end = visibleLines.firstFooterVisibleIndex - 1;
        break;
      case _ScrollAxisRegion.footer:
        start = visibleLines.firstFooterVisibleIndex;
        end = visibleLines.length - 1;
        break;
      default:
        start = end = -1;
        break;
    }
    return <int>[start, end];
  }

  /// Returns the clipping area for the specified visible lines.
  /// Only if `VisibleLineInfo.IsClippedOrigin` is true for first line or
  /// if `VisibleLineInfo.IsClippedCorner` is true for last line then the
  /// area will be clipped. Otherwise, the whole area from 0 to `RenderSize`
  /// is returned.
  ///
  /// * firstLine The first visible line.
  /// * lastLine The last visible line.
  /// Returns the clipping area for the specified visible lines.
  _DoubleSpan getBorderRangeClipPoints(
      _VisibleLineInfo firstLine, _VisibleLineInfo lastLine) {
    if (!firstLine.isClippedOrigin && !lastLine.isClippedCorner) {
      return _DoubleSpan(0, renderSize);
    }

    if (firstLine.isClippedOrigin && !lastLine.isClippedCorner) {
      return firstLine.clippedOrigin < renderSize
          ? _DoubleSpan(firstLine.clippedOrigin, renderSize)
          : _DoubleSpan(renderSize, firstLine.clippedOrigin);
    }

    if (!firstLine.isClippedOrigin && lastLine.isClippedCorner) {
      return _DoubleSpan(0, lastLine.clippedCorner);
    }

    return _DoubleSpan(firstLine.clippedOrigin, lastLine.clippedCorner);
  }

  /// Gets the line near the given corner point. Use this method
  /// for hit-testing row or column lines for resizing cells.
  ///
  /// * point The point.
  /// * hitTestPrecision The hit test precision in points.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the visible line.
  _VisibleLineInfo? getLineNearCorner(
          double point, double hitTestPrecision, _CornerSide side,
          {bool isRightToLeft = false}) =>
      getLineNearCornerWithFourArgs(
          point, hitTestPrecision, _CornerSide.both, isRightToLeft);

  /// Gets the line near the given corner point. Use this method
  /// for hit-testing row or column lines for resizing cells.
  ///
  /// * point The point.
  /// * hitTestPrecision The hit test precision in points.
  /// * side The hit test corner.
  /// * isRightToLeft The boolean value indicates the right to left mode.
  /// Returns the visible line.
  _VisibleLineInfo? getLineNearCornerWithFourArgs(
      double point, double hitTestPrecision, _CornerSide side,
      [bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      final _VisibleLinesCollection lines = getVisibleLines();
      _VisibleLineInfo? visibleLine = lines.getVisibleLineAtPoint(point);
      if (visibleLine != null) {
        double d;

        // Close to
        for (int n = max(0, visibleLine.visibleIndex); n < lines.length; n++) {
          visibleLine = lines[n];

          d = visibleLine.clippedOrigin - point;

          if ((d > hitTestPrecision) ||
              (d > 0 &&
                  (side == _CornerSide.right || side == _CornerSide.bottom))) {
            return null;
          } else if (d.abs() <= hitTestPrecision && side != _CornerSide.left) {
            if (visibleLine.visibleIndex == 0) {
              return null;
            } else {
              return lines[visibleLine.visibleIndex - 1];
            }
          } else if (visibleLine.size - d.abs() <= hitTestPrecision &&
              side == _CornerSide.left) {
            return lines[visibleLine.visibleIndex];
          }
        }

        // last line - check corner instead of origin.
        d = visibleLine!.clippedCorner - point;
        if (d.abs() <= hitTestPrecision) {
          return lines[visibleLine.visibleIndex];
        }
      }
    } else {
      final _VisibleLinesCollection lines = getVisibleLines(true);
      _VisibleLineInfo? visibleLine =
          getVisibleLineAtPoint(point, false, isRightToLeft);

      if (visibleLine != null) {
        double d;
        // Close to
        for (int n = max(0, visibleLine.visibleIndex); n < lines.length; n++) {
          visibleLine = lines[n];

          d = point - visibleLine.clippedOrigin;

          if ((d > hitTestPrecision &&
                  d < visibleLine.size - hitTestPrecision) ||
              (d > 0 &&
                  d < visibleLine.size - hitTestPrecision &&
                  (side == _CornerSide.right || side == _CornerSide.bottom)) ||
              (d < 0 && (side == _CornerSide.left))) {
            return null;
          }

          if (d > visibleLine.size - hitTestPrecision &&
              visibleLine.visibleIndex > 0) {
            return lines[visibleLine.visibleIndex - 1];
          }

          if (d.abs() <= hitTestPrecision) {
            return lines[visibleLine.visibleIndex];
          }

          if ((d.abs() + hitTestPrecision) >= visibleLine.clippedSize) {
            return visibleLine;
          }
        }
        // last line - check corner instead of origin.
        d = visibleLine!.clippedCorner - point;
        if (d.abs() <= hitTestPrecision) {
          return lines[visibleLine.visibleIndex];
        }
      }
    }
    return null;
  }

  /// Returns points for given absolute line indexes.
  ///
  /// * firstIndex The first index.
  /// * lastIndex The last index.
  /// * allowAdjust if set to true return the first visible line if firstIndex
  /// is above viewable area or return last visible line if lastIndex
  /// is after viewable area (works also for header and footer).
  ///
  /// * firstVisible if set to true indicates the line with index
  /// firstIndex is visible in viewable area.
  /// * lastVisible if set to true indicates the line with index
  /// lastIndex is visible in viewable area..
  /// * firstLine The first line or null if allowAdjust is false and line
  /// is not in viewable area.
  /// * lastLine The last line or null if allowAdjust is false and line
  /// is not in viewable area.
  List<dynamic> getLinesAndVisibility(
      int firstIndex,
      int lastIndex,
      bool allowAdjust,
      bool firstVisible,
      bool lastVisible,
      _VisibleLineInfo? firstLine,
      _VisibleLineInfo? lastLine) {
    final _VisibleLinesCollection visibleLines = getVisibleLines();

    if (firstIndex < 0) {
      firstIndex = 0;
    }

    // Invalid Line
    if (firstIndex < 0 || firstIndex >= lineCount) {
      firstVisible = false;
      firstLine = null;
    }

    // Header
    else if (firstIndex < headerLineCount) {
      firstVisible = true;
      firstLine = visibleLines.getVisibleLineNearLineIndex(firstIndex);
    }

    // Footer
    else if (firstIndex >= firstFooterLineIndex) {
      firstVisible = true;
      firstLine = visibleLines.getVisibleLineNearLineIndex(firstIndex);
    }

    // After Header and Before Scroll Position
    else if (firstIndex < scrollLineIndex) {
      firstVisible = false;
      firstLine =
          allowAdjust ? getVisibleLineAtLineIndex(scrollLineIndex) : null;
    }

    // After Scroll Position and Before Footer
    else if (firstIndex > lastBodyVisibleLineIndex) {
      firstVisible = false;
      if (allowAdjust && isFooterVisible) {
        firstLine = visibleLines[visibleLines.firstFooterVisibleIndex];
      } else {
        firstLine = null;
      }
    }
    // Regular line (Body) - Visible and not a Header or Footer.
    else {
      firstVisible = true;
      firstLine = visibleLines.getVisibleLineNearLineIndex(firstIndex);
    }

    if (lastIndex >= lineCount) {
      lastIndex = lineCount - 1;
    }

    // Invalid Line
    if (lastIndex < 0 || lastIndex >= lineCount) {
      lastVisible = false;
      lastLine = null;
    }

    // Header
    else if (lastIndex < headerLineCount) {
      lastVisible = true;
      lastLine = visibleLines.getVisibleLineNearLineIndex(lastIndex);
    }

    // Footer
    else if (lastIndex >= firstFooterLineIndex) {
      lastVisible = true;
      lastLine = visibleLines.getVisibleLineNearLineIndex(lastIndex);
    }

    // After Header and Before Scroll Position
    else if (lastIndex < scrollLineIndex) {
      lastVisible = false;
      if (!firstVisible &&
          firstIndex < scrollLineIndex) // maybe - in case you want right
      // border to look through ...: && lastIndex+1 < ScrollLineIndex)
      {
        firstLine = null;
        lastLine = null;
      } else {
        if (allowAdjust && headerLineCount > 0) {
          lastLine = visibleLines[visibleLines.firstBodyVisibleIndex - 1];
        } else {
          lastLine = null;
        }
      }
    }

    // After Scroll Position and Before Footer
    else if (lastIndex > lastBodyVisibleLineIndex) {
      lastVisible = false;
      if (!firstVisible && firstIndex > lastBodyVisibleLineIndex) {
        firstLine = null;
        lastLine = null;
      } else {
        lastLine = allowAdjust ? lastBodyVisibleLine : null;
      }
    }

    // Regular line (Body) - Visible and not a Header or Footer.
    else {
      lastVisible = true;
      lastLine = visibleLines.getVisibleLineNearLineIndex(lastIndex);
    }
    return <dynamic>[firstVisible, lastVisible, firstLine, lastLine];
  }

  /// Gets the visible lines clip points (clipped origin of first line
  /// and clipped corner of last line). If both lines are above or below
  /// viewable area an empty span is returned. If lines are both above and below
  /// viewable are then the range for all viewable lines is returned.
  ///
  /// * firstIndex The first index.
  /// * lastIndex The last index.
  ///
  /// The visible lines clip points (clipped origin of first line and clipped
  /// corner of last line).

  _DoubleSpan getVisibleLinesClipPoints(int firstIndex, int lastIndex) {
    const bool firstVisible = false;
    const bool lastVisible = false;
    _VisibleLineInfo? firstLine, lastLine;

    getLinesAndVisibility(firstIndex, lastIndex, true, firstVisible,
        lastVisible, firstLine, lastLine);
    if (firstLine == null || lastLine == null) {
      return _DoubleSpan.empty();
    }

    return _DoubleSpan(firstLine.clippedOrigin, lastLine.clippedCorner);
  }

  /// Gets the clip points for a region.
  ///
  /// * region The region for which the clip points is to be obtained.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the clip points for a region.
  _DoubleSpan getClipPoints(_ScrollAxisRegion region,
      {bool isRightToLeft = false}) {
    final _VisibleLinesCollection lines = getVisibleLines();
    int start = -1;
    int end = -1;
    final List<int> visibleLineSection = getVisibleSection(region, start, end);
    start = visibleLineSection[0];
    end = visibleLineSection[1];
    if (start == end &&
        region == _ScrollAxisRegion.body &&
        lines[end].clippedOrigin > 0 &&
        lines[start].clippedCorner > 0) {
      return _DoubleSpan(lines[start].clippedOrigin, lines[end].clippedCorner);
    }

    if (end < start) {
      return _DoubleSpan.empty();
    }
    if (isRightToLeft) {
      return _DoubleSpan(lines[start].clippedCorner, lines[end].clippedOrigin);
    } else {
      return _DoubleSpan(lines[start].clippedOrigin, lines[end].clippedCorner);
    }
  }

  /// Determines the line one page down from the given line.
  ///
  /// * lineIndex The index of the current line.
  /// Returns the line index of the line one page down from the given line.
  int getNextPage(int lineIndex) {
    double extent = 0;
    final double pageExtent = scrollPageSize - getLineSize(lineIndex);
    final int count = lineCount;
    while (extent < pageExtent && lineIndex < count && lineIndex != -1) {
      final int index = getNextScrollLineIndex(lineIndex);
      if (index < 0) {
        break;
      }

      lineIndex = index;
      extent += getLineSize(index);
    }

    return lineIndex;
  }

  /// Determines the line one page up from the given line.
  ///
  /// * lineIndex The index of the current line.
  /// Returns the line index of the line one page up from the given line.
  int getPreviousPage(int lineIndex) {
    double extent = 0;
    final double pageExtent = scrollPageSize - getLineSize(lineIndex);
    while (extent < pageExtent && lineIndex > 0) {
      lineIndex = getPreviousScrollLineIndex(lineIndex);
      extent += getLineSize(lineIndex);
    }

    return lineIndex;
  }

  void headerLineChangedCallback() {
    setFooterLineCount(scrollLinesHost!.getFooterLineCount());
    markDirty();
    raiseChanged(_ScrollChangedAction.footerLineCountChanged);
  }

  void hiddenRangeChangedCallback(
      _HiddenRangeChangedArgs hiddenRangeChangedArgs) {
    for (int n = hiddenRangeChangedArgs.from;
        n <= hiddenRangeChangedArgs.to;
        n++) {
      int repeatSizeCount = 0;
      final List<dynamic> hiddenValue =
          scrollLinesHost!.getHidden(n, repeatSizeCount);
      final bool hide = hiddenValue[0] as bool;
      repeatSizeCount = hiddenValue[1] as int;
      final int rangeTo =
          getRangeToHelper(n, hiddenRangeChangedArgs.to, repeatSizeCount);
      setLineHiddenState(n, rangeTo, hide);
      n = rangeTo;
    }

    markDirty();
    updateScrollBar(true);
    raiseChanged(_ScrollChangedAction.hiddenLineChanged);
  }

  /// Gets a boolean value indicating whether the line with the
  /// given absolute line index is visible.
  ///
  /// * lineIndex The index of the line.
  /// A boolean value indicating whether the line with the given absolute
  /// line index is visible.

  bool isLineVisible(int lineIndex) =>
      getVisibleLines().getVisibleLineAtLineIndex(lineIndex) != null ||
      ((lineIndex > _lastBodyLineIndex) && _allBodyLinesShown);

  void linesRemovedCallback(_LinesRemovedArgs linesRemovedArgs) {
    onLinesRemoved(linesRemovedArgs.removeAt, linesRemovedArgs.count);
    raiseChanged(_ScrollChangedAction.linesRemoved);
  }

  void linesInsertedCallback(_LinesInsertedArgs linesInsertedArgs) {
    onLinesInserted(linesInsertedArgs.insertAt, linesInsertedArgs.count);
    raiseChanged(_ScrollChangedAction.linesInserted);
  }

  void lineCountChangedCallback() {
    lineCount = scrollLinesHost!.getLineCount();
    markDirty();
    updateScrollBar(true);
    raiseChanged(_ScrollChangedAction.lineCountChanged);
  }

  /// Makes the layout dirty.
  ///
  void markDirty() {
    _layoutDirty = true;
  }

  /// This method is called in response to a MouseWheel event.
  ///
  /// * delta The delta.
  void mouseWheel(int delta);

  /// Called when lines were removed in ScrollLinesHost.
  ///
  /// * removeAt Index of the first removed line.
  /// * count The count.
  void onLinesRemoved(int removeAt, int count) {}

  /// Called when lines were inserted in ScrollLinesHost.
  ///
  /// * insertAt Index of the first inserted line.
  /// * count The count.
  void onLinesInserted(int insertAt, int count) {}

  /// Resets temporary value for line size after a resize operation.
  void resetLineResize() {
    const int repeatSizeCount = 0;
    if (_lineResizeIndex >= 0 && _scrollLinesHost != null) {
      setLineSize(_lineResizeIndex, _lineResizeIndex,
          getScrollLinesHostSize(_lineResizeIndex, repeatSizeCount)[0]);
    }

    _lineResizeIndex = -1;
    _lineResizeSize = 0;
    markDirty();
    raiseChanged(_ScrollChangedAction.lineResized);
  }

  void rangeChangedCallback(_RangeChangedArgs rangeChangedArgs) {
    for (int n = rangeChangedArgs.from; n <= rangeChangedArgs.to; n++) {
      int repeatSizeCount = 0;
      final List<dynamic> lineSize = getScrollLinesHostSize(n, repeatSizeCount);
      final double size = lineSize[0] as double;
      repeatSizeCount = lineSize[1] as int;
      final int rangeTo =
          getRangeToHelper(n, rangeChangedArgs.to, repeatSizeCount);
      setLineSize(n, rangeTo, size);
      n = rangeTo;
    }
    // Also check whether I need to re-hide any of the rows.
    hiddenRangeChangedCallback(_HiddenRangeChangedArgs.fromArgs(
        rangeChangedArgs.from, rangeChangedArgs.to, false));
    markDirty();
    raiseChanged(_ScrollChangedAction.lineResized);
  }

  /// Resets the visible lines collection.
  void resetVisibleLines() {
    _visibleLines.clear();
  }

  /// Returns an array with 3 ranges indicating the first and last point
  /// for the given lines in each region.
  ///
  /// * first The index of the first line.
  /// * last The index of the last line.
  /// * allowEstimatesForOutOfViewLines if set to true allow estimates
  /// for out of view lines.
  /// Returns An array with 3 ranges indicating the first and last point
  /// for the given lines in each region.
  List<_DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines);

  /// Gets the first and last point for the given lines in a region.
  ///
  /// * region The region.
  /// * first The index of the first line.
  /// * last The index of the last line.
  /// * allowEstimatesForOutOfViewLines if set to true allow estimates
  /// for out of view lines.
  /// Returns the first and last point for the given lines in a region.
  _DoubleSpan rangeToPoints(_ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines);

  /// Raises the `Changed` event.
  ///
  /// * action scroll action
  void raiseChanged(_ScrollChangedAction action) {
    if (onChangedCallback != null) {
      final _ScrollChangedArgs scrollChangedArgs =
          _ScrollChangedArgs.fromArgs(action);
      onChangedCallback!(scrollChangedArgs);
    }
  }

  void scrollChangedCallback(_ScrollChangedArgs scrollChangedArgs) {}

  /// Scrolls the line into viewable area.
  /// * lineIndex Index of the line.
  /// * lineSize Size of the line.
  /// * isRightToLeft The boolean value indicates the right to left mode.
  void scrollInView(int lineIndex, double lineSize, bool isRightToLeft) {}

  /// Scrolls the line into viewable area.
  ///
  /// * lineIndex The index of the line.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.s
  void scrollInViewwithTwoArgs(int lineIndex, bool isRightToLeft) {
    scrollInView(lineIndex, getLineSize(lineIndex), isRightToLeft);
  }

  /// Sets the footer line count.
  ///
  /// * value The value.
  void setFooterLineCount(int value);

  /// Sets the header line count.
  ///
  /// * value The value.
  void setHeaderLineCount(int value);

  /// Sets the hidden state of the lines.
  ///
  /// * from The start index of the line.
  /// * to The end index of the line.
  /// * hide A boolean value indicating whether to hide the lines.
  /// if set to true - [hide].
  void setLineHiddenState(int from, int to, bool hide);

  /// Sets the size of the lines for the given range of lines.
  /// Will do nothing for a [LineScrollAxis].
  ///
  /// * from The start index of the line.
  /// * to The end index of the line.
  /// * size The line size.
  void setLineSize(int from, int to, double size);

  /// Set temporary value for a line size during a resize operation
  /// without committing value to ScrollLinesHost.
  ///
  /// * index The index of the line.
  /// * size The size of the line.
  void setLineResize(int index, double size) {
    _lineResizeIndex = index;
    _lineResizeSize = size;
    setLineSize(index, index, size);
    markDirty();
    raiseChanged(_ScrollChangedAction.lineResized);
  }

  /// Sets the index of the scroll line.
  ///
  /// * scrollLineIndex The index of the scroll line.
  /// * scrollLineOffset The scroll line offset.
  void setScrollLineIndex(int scrollLineIndex, double scrollLineOffset);

  /// Scrolls to next page.
  void scrollToNextPage();

  /// Scrolls to next line.
  void scrollToNextLine();

  /// Scrolls to previous page.
  void scrollToPreviousPage();

  /// Scrolls to previous line.
  void scrollToPreviousLine();

  void updateScrollbar();

  /// Updates the scroll bar.
  ///
  /// * ignorePropertyChange A boolean value indicating whether to ignore the
  /// property change.
  void updateScrollBar(bool ignorePropertyChange) {
    final bool b = _ignoreScrollBarPropertyChange;
    _ignoreScrollBarPropertyChange |= ignorePropertyChange;
    try {
      updateScrollbar();
    } finally {
      _ignoreScrollBarPropertyChange = b;
    }
  }

  /// Unfreezes the visible lines.
  void unfreezeVisibleLines() {
    _inGetVisibleLines = false;
  }

  void unwireScrollLinesHost() {
    if (scrollLinesHost == null) {
      return;
    }
    scrollLinesHost!
      ..onDefaultLineSizeChanged = defaultLineSizeChangedCallback
      ..onLineHiddenChanged = hiddenRangeChangedCallback
      ..onLineSizeChanged = rangeChangedCallback
      ..onLinesInserted = linesInsertedCallback
      ..onLinesRemoved = linesRemovedCallback
      ..onFooterLineCountChanged = headerLineChangedCallback
      ..onFooterLineCountChanged = footerLineChangedCallback
      ..onLineCountChanged = lineCountChangedCallback;
  }

  /// Gets the view corner which is the point after the last visible line
  /// of the body region.
  ///
  /// Returns the view corner which is the point after the last visible line
  /// of the body region.
  double get viewCorner {
    int scrollLineIndex = 0;
    double scrollOffset = 0.0;
    final List<dynamic> lineSize =
        getScrollLineIndex(scrollLineIndex, scrollOffset);
    scrollLineIndex = lineSize[0] as int;
    scrollOffset = lineSize[1] as double;
    final double arrangeSize = renderSize;
    final double adjustedFooterExtent =
        adjustFooterExtentToAvoidGap(footerExtent, arrangeSize);

    return arrangeSize - adjustedFooterExtent;
  }

  /// Gets the visible line index for a point in the display.
  ///
  /// * point The point.
  /// * allowOutsideLines Set this true if point can be below corner
  /// of last line.
  /// Returns the visible line index for a point in the display.
  int visiblePointToLineIndexWithTwoArgs(double point, bool allowOutsideLines) {
    if (allowOutsideLines) {
      point = max(point, 0);
    }

    final _VisibleLineInfo? line =
        getVisibleLines().getVisibleLineAtPoint(point);
    if (line != null && (allowOutsideLines || point <= line.corner)) {
      return line.lineIndex;
    }

    return -1;
  }

  /// Gets the visible line index for a point in the display.
  ///
  /// * point The point in the display for which the line index
  /// is to be obtained.
  /// Returns the visible line index for a point in the display.
  int visiblePointToLineIndex(double point) =>
      visiblePointToLineIndexWithTwoArgs(point, true);

  void wireScrollLinesHost() {
    if (scrollLinesHost == null) {
      return;
    }

    scrollLinesHost!
      ..onDefaultLineSizeChanged = defaultLineSizeChangedCallback
      ..onLineHiddenChanged = hiddenRangeChangedCallback
      ..onLineSizeChanged = rangeChangedCallback
      ..onLinesInserted = linesInsertedCallback
      ..onLinesRemoved = linesRemovedCallback
      ..onFooterLineCountChanged = headerLineChangedCallback
      ..onFooterLineCountChanged = footerLineChangedCallback
      ..onLineCountChanged = lineCountChangedCallback;
  }
}

/// Corner side enumeration.
enum _CornerSide {
  /// Includes both Left and right side or top and bottom side.
  both,

  /// Left side alone.
  left,

  /// Right side alone.
  right,

  /// Bottom side alone.
  bottom
}
