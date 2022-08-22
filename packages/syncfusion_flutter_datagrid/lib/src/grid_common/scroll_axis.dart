// ignore_for_file: no_default_cases, avoid_setters_without_getters

import 'dart:math';

import 'distance_counter.dart';
import 'enums.dart';
import 'event_args.dart';
import 'line_size_host.dart';
import 'scrollbar.dart';
import 'utility_helper.dart';
import 'visible_line_info.dart';

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
typedef ChangedCallback = void Function(ScrollChangedArgs scrollChangedArgs);

///
abstract class ScrollAxisBase {
  /// Initializes a new instance of the ScrollAxisBase class.
  ///
  /// * scrollBar The scroll bar state.
  /// * scrollLinesHost The scroll lines host.
  ScrollAxisBase(
    ScrollBarBase? scrollBar,
    LineSizeHostBase? scrollLinesHost, {
    double headerExtent = 0,
    double footerExtent = 0.0,
    double viewSize = 0.0,
    double defaultLineSize = 0.0,
  }) : _defaultLineSize = defaultLineSize {
    if (scrollBar == null) {
      throw Exception();
    }
    viewSize = viewSize;
    headerExtent = headerExtent;
    footerExtent = footerExtent;
    _isPixelScroll = false;
    this.scrollBar = scrollBar;
    _scrollLinesHost = scrollLinesHost;
    wireScrollLinesHost();
  }

  double _renderSize = 0.0;
  ScrollBarBase? _scrollBar;
  late LineSizeHostBase? _scrollLinesHost;
  bool _layoutDirty = false;
  int _lineResizeIndex = -1;
  double _lineResizeSize = 0;
  final VisibleLinesCollection _visibleLines = VisibleLinesCollection();
  double _lastScrollValue = -1;

  ///
  DoubleSpan clip = DoubleSpan.empty();
  bool _ignoreScrollBarPropertyChange = false;
  bool _inGetVisibleLines = false;
  bool _allBodyLinesShown = false;
  int _lastBodyLineIndex = -1;

  ///
  bool indebug = false;

  /// code to handle issue in DT 77714
  static double ePSILON = 2.2204460492503131e-016;
  /* smallest such that 1.0+EPSILON != 1.0 */

  ///
  static bool strictlyLessThan(double d1, double d2) =>
      !(d1 > d2 || areClose(d1, d2));

  ///
  static bool areClose(double d1, double d2) {
    if (d1 == d2) {
      return true;
    }

    final double eps = (d1.abs() + d2.abs() + 10.0) * ePSILON;
    return (d1 - d2).abs() < eps;
  }

  /// Occurs when a scroll axis changed.
  ChangedCallback? onChangedCallback;

  /// Get visibleLine
  VisibleLinesCollection get visibleLines {
    return _visibleLines;
  }

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
  double footerExtent = 0.0;

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
  double headerExtent = 0.0;

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
    final VisibleLinesCollection visibleLines = getVisibleLines();
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
  VisibleLineInfo? get lastBodyVisibleLine {
    final VisibleLinesCollection visibleLines = getVisibleLines();
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
    final VisibleLinesCollection visibleLines = getVisibleLines();
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
  ScrollBarBase? get scrollBar => _scrollBar;
  set scrollBar(ScrollBarBase? value) {
    if (value == _scrollBar) {
      return;
    }

    _scrollBar = value;
  }

  /// Gets the scroll lines host.
  ///
  /// Returns the scroll lines host.
  LineSizeHostBase? get scrollLinesHost => _scrollLinesHost;

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
  double viewSize = 0.0;

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

  ///
  void defaultLineSizeChangedCallback(
      DefaultLineSizeChangedArgs defaultLineSizeChangedArgs) {
    if (scrollLinesHost != null) {
      defaultLineSize = scrollLinesHost!.getDefaultLineSize();
      markDirty();
      updateScrollBar(true);
      raiseChanged(ScrollChangedAction.defaultLineSizeChanged);
    }
  }

  ///
  void footerLineChangedCallback() {
    if (scrollLinesHost != null) {
      setFooterLineCount(scrollLinesHost!.getFooterLineCount());
      markDirty();
      raiseChanged(ScrollChangedAction.footerLineCountChanged);
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
      repeatSizeCount = maxvalue;
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
    if (repeatSizeCount == maxvalue) {
      return to;
    }

    return min(to, n + repeatSizeCount - 1);
  }

  /// Gets the visible lines collection.
  ///
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the visible lines collection.
  VisibleLinesCollection getVisibleLines([bool isRightToLeft = false]) {
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
            final VisibleLineInfo line = VisibleLineInfo(
                visibleIndex++, index, size, point, 0, true, false);
            _visibleLines.add(line);
            point += size;
            lastHeaderLineIndex = index;
          }

          _visibleLines.firstBodyVisibleIndex = _visibleLines.length;

          VisibleLineInfo? lastScrollableLine;
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
            _visibleLines.add(lastScrollableLine = VisibleLineInfo(
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
            _visibleLines.add(VisibleLineInfo(
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
          final int headerLineCounts = headerLineCount;
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
                  index < headerLineCounts;
              index = getNextScrollLineIndex(index)) {
            final double size = getLineSize(index);
            _visibleLines.add(VisibleLineInfo(visibleIndex++, index, size,
                footerStartPoint - size - point, 0, true, false));
            footerStartPoint -= size;
            lastHeaderLineIndex = index;
          }

          _visibleLines.firstBodyVisibleIndex = _visibleLines.length;
          VisibleLineInfo? lastScrollableLine;

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
            _visibleLines.add(lastScrollableLine = VisibleLineInfo(
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
                _visibleLines.add(VisibleLineInfo(
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
                _visibleLines.add(VisibleLineInfo(
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
  VisibleLineInfo? getVisibleLineAtPoint(double point,
      [bool allowOutSideLines = false, bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      if (allowOutSideLines) {
        point = max(point, 0);
      }

      final VisibleLineInfo? lineInfo =
          getVisibleLines().getVisibleLineAtPoint(point);
      if (lineInfo != null && (allowOutSideLines || point <= lineInfo.corner)) {
        return lineInfo;
      }
    } else {
      if (allowOutSideLines) {
        point = max(point, 0);
      }

      final VisibleLinesCollection collection = getVisibleLines(true);
      final VisibleLinesCollection reversedCollection = collection.reversed;
      final VisibleLineInfo? lineInfo =
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

  VisibleLineInfo? getVisibleLineAtLineIndex(int lineIndex,
          {bool isRightToLeft = false}) =>
      getVisibleLines(isRightToLeft).getVisibleLineAtLineIndex(lineIndex);

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
  VisibleLineInfo? getVisibleLineAtLineIndexWithTwoArgs(
      int lineIndex, bool allowCreateEmptyLineIfNotVisible) {
    VisibleLineInfo? line = getVisibleLineAtLineIndex(lineIndex);
    if (line == null && allowCreateEmptyLineIfNotVisible) {
      final double size = getLineSize(lineIndex);
      line = VisibleLineInfo(
          maxvalue, lineIndex, size, renderSize + 1, size, false, false);
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
  Int32Span getVisibleLinesRange(ScrollAxisRegion section) {
    final VisibleLinesCollection visibleLines = getVisibleLines();
    int start = 0;
    int end = 0;
    final List<int> visibleSection = getVisibleSection(section, start, end);
    start = visibleSection[0];
    end = visibleSection[1];
    return Int32Span(
        visibleLines[start].lineIndex, visibleLines[end].lineIndex);
  }

  /// Return indexes for VisibleLinesCollection for area identified by section.
  ///
  /// * section The integer value indicating the section : 0 - Header,
  /// 1 - Body, 2 - Footer
  /// * start The start index.
  /// * end The end index.
  void getVisibleSectionWithThreeArgs(
      ScrollAxisRegion section, int start, int end) {
    getVisibleSection(section, start, end);
  }

  /// Return indexes for VisibleLinesCollection for area identified by section.
  ///
  /// * section The integer value indicating the section : 0 - Header,
  /// 1 - Body, 2 - Footer
  /// * start The start index.
  /// * end The end index.
  List<int> getVisibleSection(ScrollAxisRegion section, int start, int end) {
    final VisibleLinesCollection visibleLines = getVisibleLines();
    switch (section) {
      case ScrollAxisRegion.header:
        start = 0;
        end = visibleLines.firstBodyVisibleIndex - 1;
        break;
      case ScrollAxisRegion.body:
        start = visibleLines.firstBodyVisibleIndex;
        end = visibleLines.firstFooterVisibleIndex - 1;
        break;
      case ScrollAxisRegion.footer:
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
  DoubleSpan getBorderRangeClipPoints(
      VisibleLineInfo firstLine, VisibleLineInfo lastLine) {
    if (!firstLine.isClippedOrigin && !lastLine.isClippedCorner) {
      return DoubleSpan(0, renderSize);
    }

    if (firstLine.isClippedOrigin && !lastLine.isClippedCorner) {
      return firstLine.clippedOrigin < renderSize
          ? DoubleSpan(firstLine.clippedOrigin, renderSize)
          : DoubleSpan(renderSize, firstLine.clippedOrigin);
    }

    if (!firstLine.isClippedOrigin && lastLine.isClippedCorner) {
      return DoubleSpan(0, lastLine.clippedCorner);
    }

    return DoubleSpan(firstLine.clippedOrigin, lastLine.clippedCorner);
  }

  /// Gets the line near the given corner point. Use this method
  /// for hit-testing row or column lines for resizing cells.
  ///
  /// * point The point.
  /// * hitTestPrecision The hit test precision in points.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the visible line.
  VisibleLineInfo? getLineNearCorner(
          double point, double hitTestPrecision, CornerSide side,
          {bool isRightToLeft = false}) =>
      getLineNearCornerWithFourArgs(
          point, hitTestPrecision, CornerSide.both, isRightToLeft);

  /// Gets the line near the given corner point. Use this method
  /// for hit-testing row or column lines for resizing cells.
  ///
  /// * point The point.
  /// * hitTestPrecision The hit test precision in points.
  /// * side The hit test corner.
  /// * isRightToLeft The boolean value indicates the right to left mode.
  /// Returns the visible line.
  VisibleLineInfo? getLineNearCornerWithFourArgs(
      double point, double hitTestPrecision, CornerSide side,
      [bool isRightToLeft = false]) {
    if (!isRightToLeft) {
      final VisibleLinesCollection lines = getVisibleLines();
      VisibleLineInfo? visibleLine = lines.getVisibleLineAtPoint(point);
      if (visibleLine != null) {
        double d;

        // Close to
        for (int n = max(0, visibleLine.visibleIndex); n < lines.length; n++) {
          visibleLine = lines[n];

          d = visibleLine.clippedOrigin - point;

          if ((d > hitTestPrecision) ||
              (d > 0 &&
                  (side == CornerSide.right || side == CornerSide.bottom))) {
            return null;
          } else if (d.abs() <= hitTestPrecision && side != CornerSide.left) {
            if (visibleLine.visibleIndex == 0) {
              return null;
            } else {
              return lines[visibleLine.visibleIndex - 1];
            }
          } else if (visibleLine.size - d.abs() <= hitTestPrecision &&
              side == CornerSide.left) {
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
      final VisibleLinesCollection lines = getVisibleLines(true);
      VisibleLineInfo? visibleLine =
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
                  (side == CornerSide.right || side == CornerSide.bottom)) ||
              (d < 0 && (side == CornerSide.left))) {
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
      VisibleLineInfo? firstLine,
      VisibleLineInfo? lastLine) {
    final VisibleLinesCollection visibleLines = getVisibleLines();

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

  DoubleSpan getVisibleLinesClipPoints(int firstIndex, int lastIndex) {
    const bool firstVisible = false;
    const bool lastVisible = false;
    VisibleLineInfo? firstLine, lastLine;

    getLinesAndVisibility(firstIndex, lastIndex, true, firstVisible,
        lastVisible, firstLine, lastLine);
    if (firstLine == null || lastLine == null) {
      return DoubleSpan.empty();
    }

    return DoubleSpan(firstLine.clippedOrigin, lastLine.clippedCorner);
  }

  /// Gets the clip points for a region.
  ///
  /// * region The region for which the clip points is to be obtained.
  /// * isRightToLeft The boolean value used to calculate visible columns
  /// in right to left mode.
  /// Returns the clip points for a region.
  DoubleSpan getClipPoints(ScrollAxisRegion region,
      {bool isRightToLeft = false}) {
    final VisibleLinesCollection lines = getVisibleLines();
    int start = -1;
    int end = -1;
    final List<int> visibleLineSection = getVisibleSection(region, start, end);
    start = visibleLineSection[0];
    end = visibleLineSection[1];
    if (start == end &&
        region == ScrollAxisRegion.body &&
        lines[end].clippedOrigin > 0 &&
        lines[start].clippedCorner > 0) {
      return DoubleSpan(lines[start].clippedOrigin, lines[end].clippedCorner);
    }

    if (end < start) {
      return DoubleSpan.empty();
    }
    if (isRightToLeft) {
      return DoubleSpan(lines[start].clippedCorner, lines[end].clippedOrigin);
    } else {
      return DoubleSpan(lines[start].clippedOrigin, lines[end].clippedCorner);
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

  ///
  void headerLineChangedCallback() {
    setFooterLineCount(scrollLinesHost!.getFooterLineCount());
    markDirty();
    raiseChanged(ScrollChangedAction.footerLineCountChanged);
  }

  ///
  void hiddenRangeChangedCallback(
      HiddenRangeChangedArgs hiddenRangeChangedArgs) {
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
    raiseChanged(ScrollChangedAction.hiddenLineChanged);
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

  ///
  void linesRemovedCallback(LinesRemovedArgs linesRemovedArgs) {
    onLinesRemoved(linesRemovedArgs.removeAt, linesRemovedArgs.count);
    raiseChanged(ScrollChangedAction.linesRemoved);
  }

  ///
  void linesInsertedCallback(LinesInsertedArgs linesInsertedArgs) {
    onLinesInserted(linesInsertedArgs.insertAt, linesInsertedArgs.count);
    raiseChanged(ScrollChangedAction.linesInserted);
  }

  ///
  void lineCountChangedCallback() {
    lineCount = scrollLinesHost!.getLineCount();
    markDirty();
    updateScrollBar(true);
    raiseChanged(ScrollChangedAction.lineCountChanged);
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
    raiseChanged(ScrollChangedAction.lineResized);
  }

  ///
  void rangeChangedCallback(RangeChangedArgs rangeChangedArgs) {
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
    hiddenRangeChangedCallback(HiddenRangeChangedArgs.fromArgs(
        rangeChangedArgs.from, rangeChangedArgs.to, false));
    markDirty();
    raiseChanged(ScrollChangedAction.lineResized);
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
  List<DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines);

  /// Gets the first and last point for the given lines in a region.
  ///
  /// * region The region.
  /// * first The index of the first line.
  /// * last The index of the last line.
  /// * allowEstimatesForOutOfViewLines if set to true allow estimates
  /// for out of view lines.
  /// Returns the first and last point for the given lines in a region.
  DoubleSpan rangeToPoints(ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines);

  /// Raises the `Changed` event.
  ///
  /// * action scroll action
  void raiseChanged(ScrollChangedAction action) {
    if (onChangedCallback != null) {
      final ScrollChangedArgs scrollChangedArgs =
          ScrollChangedArgs.fromArgs(action);
      onChangedCallback!(scrollChangedArgs);
    }
  }

  ///
  void scrollChangedCallback(ScrollChangedArgs scrollChangedArgs) {}

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
    raiseChanged(ScrollChangedAction.lineResized);
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

  ///
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

  ///
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

    final VisibleLineInfo? line =
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

  ///
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
class PixelScrollAxis extends ScrollAxisBase {
  /// Initializes a new instance of the PixelScrollAxis class which
  /// is nested as a single line in a parent scroll axis.
  ///
  /// * parentScrollAxis - _required_ - The parent scroll axis.
  /// * scrollBar - _required_ - The scrollbar state.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  /// * distancesHost - _required_ - The distances host.
  PixelScrollAxis(ScrollAxisBase parentScrollAxis, ScrollBarBase scrollBar,
      LineSizeHostBase scrollLinesHost, DistancesHostBase distancesHost)
      : super(scrollBar, scrollLinesHost,
            headerExtent: 0.0, footerExtent: 0.0) {
    // GridCellGridRenderer passes in Distances. LineSizeCollection holds them.
    // This allows faster construction of grids when they were scrolled
    // out of view and unloaded.
    _parentScrollAxis = parentScrollAxis;
    _distancesHost = distancesHost;
    if (distances == null) {
      throw ArgumentError('Distances');
    }
  }

  /// Initializes a new instance of the PixelScrollAxis class.
  ///
  /// * scrollBar - _required_ - The scrollbar state.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  /// * distancesHost - _required_ - The distances host.
  PixelScrollAxis.fromPixelScrollAxis(ScrollBarBase scrollBar,
      LineSizeHostBase? scrollLinesHost, DistancesHostBase? distancesHost)
      : super(scrollBar, scrollLinesHost) {
    if (distancesHost != null) {
      _distancesHost = distancesHost;
    } else if (scrollLinesHost != null) {
      _distances = DistanceRangeCounterCollection()
        ..defaultDistance = scrollLinesHost.getDefaultLineSize();
      scrollLinesHost.initializeScrollAxis(this);
    }

    if (distances == null) {
      throw ArgumentError('Distances');
    }
  }

  /// Distances holds the line sizes. Hidden lines
  /// have a distance of 0.0.
  DistanceCounterCollectionBase? _distances;
  DistancesHostBase? _distancesHost;
  ScrollAxisBase? _parentScrollAxis;

  ///
  bool inLineResize = false;

  /// Gets the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  ///
  /// Returns the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  DistanceCounterCollectionBase? get distances {
    if (_distancesHost != null) {
      return _distancesHost!.distances;
    }

    return _distances;
  }

  /// Gets the total extent of all line sizes.
  ///
  /// Returns the total extent of all line sizes.
  double get totalExtent => distances?.totalDistance ?? 0.0;

  /// Gets the default size of lines.
  ///
  /// Returns the default size of lines.
  @override
  double get defaultLineSize => _distances?.defaultDistance ?? 0.0;

  /// Sets the default size of lines.
  @override
  set defaultLineSize(double value) {
    if (defaultLineSize != value) {
      if (_distances != null) {
        _distances!
          ..defaultDistance = value
          ..clear();

        if (scrollLinesHost != null) {
          scrollLinesHost!.initializeScrollAxis(this);
        }
      }

      updateScrollbar();

      if (_parentScrollAxis != null) {
        _parentScrollAxis!.setLineSize(
            startLineIndex, startLineIndex, distances?.totalDistance ?? 0);
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
    return super.footerExtent;
  }

  /// Gets the header extent. This is total height (or width) of the
  /// header lines.
  ///
  /// Returns the header extent.
  @override
  double get headerExtent {
    getVisibleLines();
    return super.headerExtent;
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
  int get lineCount => distances?.count ?? 0;

  /// Sets the line count.
  @override
  set lineCount(int value) {
    if (lineCount != value) {
      if (_distances != null) {
        _distances!.count = value;
      }
      updateScrollbar();
    }
  }

  /// Gets the index of the first visible Line in the Body region.
  ///
  /// Returns the index of the scroll line.
  @override
  int get scrollLineIndex =>
      distances?.indexOfCumulatedDistance(scrollBar?.value ?? 0.0) ?? -1;

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
  double get viewSize => min(renderSize, distances?.totalDistance ?? 0.0);

  /// Aligns the scroll line.
  @override
  void alignScrollLine() {
    final double d =
        distances?.getAlignedScrollValue(scrollBar?.value ?? 0.0) ?? 0.0;
    if (!(d == double.nan)) {
      scrollBar!.value = d;
    }
  }

  /// Gets the index of the next scroll line.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the index of the next scroll line.
  @override
  int getNextScrollLineIndex(int index) =>
      distances?.getNextVisibleIndex(index) ?? -1;

  /// Gets the index of the previous scroll line.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the index of the previous scroll line.
  @override
  int getPreviousScrollLineIndex(int index) {
    double point = distances?.getCumulatedDistanceAt(index) ?? 0.0;
    point--;
    if (point > -1) {
      return distances?.indexOfCumulatedDistance(point) ?? 0;
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
  List<dynamic> getScrollLineIndex(int scrollLineIndex, double scrollLineDelta,
      [bool isRightToLeft = false]) {
    if (!isRightToLeft && scrollBar != null && distances != null) {
      scrollLineIndex =
          max(0, distances!.indexOfCumulatedDistance(scrollBar!.value));
      if (scrollLineIndex >= lineCount) {
        scrollLineDelta = 0.0;
      } else {
        scrollLineDelta = scrollBar!.value -
            distances!.getCumulatedDistanceAt(scrollLineIndex);
      }
    } else {
      scrollLineIndex = max(
          0,
          distances!.indexOfCumulatedDistance(scrollBar!.maximum -
              scrollBar!.largeChange -
              scrollBar!.value +
              (headerLineCount == 0 ? clip.start : clip.start + headerExtent) +
              (renderSize > scrollBar!.maximum + footerExtent
                  ? renderSize -
                      scrollBar!.maximum -
                      footerExtent -
                      headerExtent
                  : 0)));

      if (scrollLineIndex >= lineCount) {
        scrollLineDelta = 0.0;
      } else {
        scrollLineDelta = scrollBar!.maximum -
            scrollBar!.largeChange -
            scrollBar!.value +
            (headerLineCount == 0
                ? clip.start
                : (scrollBar!.maximum -
                            scrollBar!.largeChange -
                            scrollBar!.value !=
                        -1
                    ? clip.start + headerExtent
                    : (clip.start > 0 ? clip.start + headerExtent + 1 : 1))) +
            (renderSize > scrollBar!.maximum + footerExtent
                ? renderSize - scrollBar!.maximum - footerExtent - headerExtent
                : 0) -
            distances!.getCumulatedDistanceAt(scrollLineIndex);
      }
    }
    return <dynamic>[scrollLineIndex, scrollLineDelta];
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
  double getCumulatedOrigin(VisibleLineInfo line) {
    final VisibleLinesCollection lines = getVisibleLines();
    if (line.isHeader) {
      return line.origin;
    } else if (line.isFooter) {
      return scrollBar!.maximum -
          lines[lines.firstFooterVisibleIndex].origin +
          line.origin;
    }

    return line.origin - scrollBar!.minimum + scrollBar!.value;
  }

  /// Gets the cumulated corner taking scroll position into account.
  ///
  /// Returned value of this is between `ScrollBar.Minimum`
  /// and `ScrollBar.Maximum`.
  ///
  /// * line - _required_ - The line.
  ///
  /// Returns the cumulated corner
  double getCumulatedCorner(VisibleLineInfo line) {
    final VisibleLinesCollection lines = getVisibleLines();
    if (line.isHeader) {
      return line.corner;
    } else if (line.isFooter) {
      return scrollBar!.maximum -
          lines[lines.firstFooterVisibleIndex].origin +
          line.corner;
    }

    return line.corner - scrollBar!.minimum + scrollBar!.value;
  }

  /// This method is called in response to a MouseWheel event.
  ///
  /// * delta - _required_ - The delta.
  @override
  void mouseWheel(int delta) {
    scrollBar!.value -= delta;
  }

  /// Called when lines were removed in ScrollLinesHost.
  ///
  /// * removeAt - _required_ - Index of the first removed line.
  /// * count - _required_ - The count.
  @override
  void onLinesRemoved(int removeAt, int count) {
    if (distances != null) {
      distances!.remove(removeAt, count);
    }
  }

  /// Called when lines were inserted in ScrollLinesHost.
  ///
  /// * insertAt - _required_ - Index of the first inserted line.
  /// * count - _required_ - The count.
  @override
  void onLinesInserted(int insertAt, int count) {
    if (distances != null) {
      DistancesUtil.onInserted(distances!, scrollLinesHost!, insertAt, count);
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
  List<DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines) {
    double p1, p2;
    p1 = distances!.getCumulatedDistanceAt(first);
    p2 = last >= distances!.count - 1
        ? distances!.totalDistance
        : distances!.getCumulatedDistanceAt(last + 1);

    final List<DoubleSpan> result = <DoubleSpan>[];
    for (int n = 0; n < 3; n++) {
      late ScrollAxisRegion region;
      if (n == 0) {
        region = ScrollAxisRegion.header;
      } else if (n == 1) {
        region = ScrollAxisRegion.body;
      } else if (n == 2) {
        region = ScrollAxisRegion.footer;
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
      _parentScrollAxis!.resetLineResize();
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
  DoubleSpan rangeToPoints(ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines) {
    final VisibleLinesCollection lines = getVisibleLines();

    // If line is visible use already calculated values,
    // otherwise get value from Distances
    final VisibleLineInfo? line1 = lines.getVisibleLineAtLineIndex(first);
    final VisibleLineInfo? line2 = lines.getVisibleLineAtLineIndex(last);

    double p1, p2;
    p1 = line1 == null
        ? distances!.getCumulatedDistanceAt(first)
        : getCumulatedOrigin(line1);

    p2 = line2 == null
        ? distances!.getCumulatedDistanceAt(last + 1)
        : getCumulatedCorner(line2);

    return rangeToPointsHelper(region, p1, p2);
  }

  ///
  DoubleSpan rangeToPointsHelper(
      ScrollAxisRegion region, double p1, double p2) {
    final VisibleLinesCollection lines = getVisibleLines();
    DoubleSpan doubleSpan = DoubleSpan.empty();
    switch (region) {
      case ScrollAxisRegion.header:
        if (headerLineCount > 0) {
          doubleSpan = DoubleSpan(p1, p2);
        }
        break;
      case ScrollAxisRegion.footer:
        if (isFooterVisible) {
          final VisibleLineInfo l = lines[lines.firstFooterVisibleIndex];
          final double p3 = distances!.totalDistance - footerExtent;
          p1 += l.origin - p3;
          p2 += l.origin - p3;
          doubleSpan = DoubleSpan(p1, p2);
        }
        break;
      case ScrollAxisRegion.body:
        p1 += headerExtent - scrollBar!.value;
        p2 += headerExtent - scrollBar!.value;
        doubleSpan = DoubleSpan(p1, p2);
        break;
      default:
        doubleSpan = DoubleSpan.empty();
        break;
    }

    return doubleSpan;
  }

  /// Sets the index of the scroll line.
  ///
  /// * scrollLineIndex - _required_ - Index of the scroll line.
  /// * scrollLineDelta - _required_ - The scroll line delta.
  @override
  void setScrollLineIndex(int scrollLineIndex, double scrollLineDelta) {
    scrollLineIndex = min(lineCount, max(0, scrollLineIndex));
    scrollBar!.value =
        distances!.getCumulatedDistanceAt(scrollLineIndex) + scrollLineDelta;
    resetVisibleLines();
  }

  /// Scrolls to next page.
  @override
  void scrollToNextPage() {
    scrollBar!.value += max(scrollBar!.smallChange,
        scrollBar!.largeChange - scrollBar!.smallChange);
    scrollToNextLine();
  }

  /// Scrolls to next line.
  @override
  void scrollToNextLine() {
    final double d = distances!.getNextScrollValue(scrollBar!.value);
    if (!(d == double.nan)) {
      scrollBar!.value = d <= scrollBar!.value
          ? distances!.getNextScrollValue(scrollBar!.value + 1)
          : d;
    } else {
      scrollBar!.value += scrollBar!.smallChange;
    }
  }

  /// Scrolls to previous line.
  @override
  void scrollToPreviousLine() {
    final double d = distances!.getPreviousScrollValue(scrollBar!.value);
    if (!(d == double.nan)) {
      scrollBar!.value = d;
    }
  }

  /// Scrolls to previous page.
  @override
  void scrollToPreviousPage() {
    scrollBar!.value -= max(scrollBar!.smallChange,
        scrollBar!.largeChange - scrollBar!.smallChange);
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
    final VisibleLinesCollection lines = getVisibleLines();
    final VisibleLineInfo? line = lines.getVisibleLineAtLineIndex(lineIndex);
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
      double d = distances!.getCumulatedDistanceAt(lineIndex);

      if (d > scrollBar!.value) {
        d = d + lineSize - scrollBar!.largeChange;
      }

      delta = d - scrollBar!.value;
    }

    if (delta != 0) {
      scrollBar!.value += delta;
    }
  }

  /// Sets the footer line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setFooterLineCount(int value) {
    if (value == 0) {
      super.footerExtent = 0;
    } else {
      if (distances!.count <= value) {
        super.footerExtent = 0;
        return;
      }

      final int n = distances!.count - value;

      // The Total distance must be reduced by the padding size of the Distance
      // total size. Then it should be calculated. This issue is occured in
      // Nested Grid. SD 9312. this will give the exact size of the footer
      // Extent when padding distance is reduced from total distance.
      final bool isDistanceCounterSubset = distances is DistanceCounterSubset;
      if (!isDistanceCounterSubset) {
        // Nested Grid cells in GridControl is not
        // DistanceRangeCounterCollection type.
        final DistanceRangeCounterCollection distance =
            distances! as DistanceRangeCounterCollection;
        super.footerExtent = distances!.totalDistance -
            distance.paddingDistance -
            distances!.getCumulatedDistanceAt(n);
      } else {
        super.footerExtent =
            distances!.totalDistance - distances!.getCumulatedDistanceAt(n);
      }
    }
  }

  /// Sets the header line count.
  ///
  /// * value - _required_ - The value.
  @override
  void setHeaderLineCount(int value) {
    super.headerExtent =
        distances!.getCumulatedDistanceAt(min(value, distances!.count));
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
        int repeatSizeCount = -1;
        final List<dynamic> lineSize =
            getLineSizeWithTwoArgs(n, repeatSizeCount);
        final double size = lineSize[0] as double;
        repeatSizeCount = lineSize[1] as int;
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
      _distances!.setRange(from, to, size);
    }

    // special case for SetLineResize when axis is nested. Parent Scroll
    // Axis relies on Distances.TotalDistance and this only gets updated if
    // we temporarily set the value in the collection.
    else if (_distancesHost != null && inLineResize) {
      _distancesHost!.distances?.setRange(from, to, size);
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
    if (distances!.getNestedDistances(index) == null) {
      super.setLineResize(index, size);
    } else {
      markDirty();
      raiseChanged(ScrollChangedAction.lineResized);
    }

    if (_parentScrollAxis != null) {
      _parentScrollAxis!
          .setLineResize(startLineIndex, distances!.totalDistance);
    }

    inLineResize = false;
  }

  /// Associates a collection of nested lines with a line in this axis.
  ///
  /// * index - _required_ - The index.
  /// * nestedLines - _required_ - The nested lines.
  void setNestedLines(int index, DistanceCounterCollectionBase? nestedLines) {
    if (distances != null) {
      distances!.setNestedDistances(index, nestedLines);
    }
  }

  /// Initialize scrollbar properties from header and footer size and
  /// total size of lines in body.
  @override
  void updateScrollbar() {
    final ScrollBarBase? sb = scrollBar;
    setHeaderLineCount(headerLineCount);
    setFooterLineCount(footerLineCount);

    final double delta = headerExtent - sb!.minimum;
    final double oldValue = sb.value;

    sb
      ..minimum = headerExtent
      ..maximum = distances!.totalDistance - footerExtent
      ..smallChange = distances!.defaultDistance;
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
class LineScrollAxis extends ScrollAxisBase {
  /// Initializes a new instance of the LineScrollAxis class.
  ///
  /// * scrollBar - _required_ - The state of the scrollbar.
  /// * scrollLinesHost - _required_ - The scroll lines host.
  LineScrollAxis(ScrollBarBase scrollBar, LineSizeHostBase scrollLinesHost)
      : super(scrollBar, scrollLinesHost,
            headerExtent: 0.0,
            footerExtent: 0.0,
            defaultLineSize: 0.0,
            viewSize: 0.0) {
    final Object distancesHost = scrollLinesHost;
    if (distancesHost is DistancesHostBase) {
      _distances = distancesHost.distances;
    } else {
      _distances = DistanceRangeCounterCollection();
    }

    scrollLinesHost.initializeScrollAxis(this);
    _distances!.defaultDistance = 1.0;
  }

  /// distances holds the visible lines. Each visible line
  /// has a distance of 1.0. Hidden lines have a distance of 0.0.
  DistanceCounterCollectionBase? _distances;

  /// Gets the distances collection which is used internally for mapping
  /// from a point position to
  /// a line index and vice versa.
  ///
  /// Returns the distances collection which is used internally for mapping
  /// from a point position
  /// to a line index and vice versa.
  DistanceCounterCollectionBase? get distances => _distances;

  /// Gets the total extent of all line sizes.
  ///
  /// Returns the total extent of all line sizes.
  double get totalExtent => distances?.totalDistance ?? 0.0;

  /// Sets the default size of lines.
  @override
  set defaultLineSize(double value) {
    if (defaultLineSize != value) {
      super.defaultLineSize = value;
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
      return super.viewSize;
    } else {
      return renderSize;
    }
  }

  ///
  int determineLargeChange() {
    double sbValue = scrollBar!.maximum;
    final double abortSize = scrollPageSize;
    int count = 0;
    super.viewSize = 0;

    while (sbValue >= scrollBar!.minimum) {
      final int lineIndex = scrollBarValueToLineIndex(sbValue);
      final double size = getLineSize(lineIndex);
      if (super.viewSize + size > abortSize) {
        break;
      }

      count++;
      sbValue--;
      super.viewSize += size;
    }

    super.viewSize += footerExtent + headerExtent;

    return count;
  }

  ///
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

  ///
  double lineIndexToScrollBarValue(int lineIndex) =>
      _distances?.getCumulatedDistanceAt(lineIndex) ?? 0.0;

  ///
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
  DoubleSpan rangeToPoints(ScrollAxisRegion region, int first, int last,
      bool allowEstimatesForOutOfViewLines) {
    bool firstVisible = false;
    bool lastVisible = false;
    VisibleLineInfo? firstLine, lastLine;

    final List<dynamic> lineValues = getLinesAndVisibility(
        first, last, true, firstVisible, lastVisible, firstLine, lastLine);
    firstVisible = lineValues[0] as bool;
    lastVisible = lineValues[1] as bool;
    firstLine = lineValues[2] as VisibleLineInfo?;
    lastLine = lineValues[3] as VisibleLineInfo?;
    if (firstLine == null || lastLine == null) {
      return DoubleSpan.empty();
    }

    if (allowEstimatesForOutOfViewLines) {
      switch (region) {
        case ScrollAxisRegion.header:
          if (!firstLine.isHeader) {
            return DoubleSpan.empty();
          }

          break;
        case ScrollAxisRegion.footer:
          if (!lastLine.isFooter) {
            return DoubleSpan.empty();
          }

          break;
        case ScrollAxisRegion.body:
          if (firstLine.isFooter || lastLine.isHeader) {
            return DoubleSpan.empty();
          }

          break;
      }

      return DoubleSpan(firstLine.origin, lastLine.corner);
    } else {
      switch (region) {
        case ScrollAxisRegion.header:
          {
            if (!firstLine.isHeader) {
              return DoubleSpan.empty();
            }

            if (!lastVisible || !lastLine.isHeader) {
              double corner = firstLine.corner;
              for (int n = firstLine.lineIndex + 1; n <= last; n++) {
                corner += getLineSize(n);
              }

              return DoubleSpan(firstLine.origin, corner);
            }

            return DoubleSpan(firstLine.origin, lastLine.corner);
          }

        case ScrollAxisRegion.footer:
          {
            if (!lastLine.isFooter) {
              return DoubleSpan.empty();
            }

            if (!firstVisible || !firstLine.isFooter) {
              double origin = lastLine.origin;
              for (int n = lastLine.lineIndex - 1; n >= first; n--) {
                origin -= getLineSize(n);
              }

              return DoubleSpan(origin, lastLine.corner);
            }

            return DoubleSpan(firstLine.origin, lastLine.corner);
          }

        case ScrollAxisRegion.body:
          {
            if (firstLine.isFooter || lastLine.isHeader) {
              return DoubleSpan.empty();
            }

            double origin = firstLine.origin;
            if (!firstVisible || firstLine.region != ScrollAxisRegion.body) {
              origin = headerExtent;
              for (int n = scrollLineIndex - 1; n >= first; n--) {
                origin -= getLineSize(n);
              }
            }

            double corner = lastLine.corner;
            if (!lastVisible || lastLine.region != ScrollAxisRegion.body) {
              corner = lastBodyVisibleLine!.corner;
              for (int n = lastBodyVisibleLine!.lineIndex + 1; n <= last; n++) {
                corner += getLineSize(n);
              }
            }

            return DoubleSpan(origin, corner);
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
  List<DoubleSpan> rangeToRegionPoints(
      int first, int last, bool allowEstimatesForOutOfViewLines) {
    final List<DoubleSpan> result = <DoubleSpan>[];
    for (int n = 0; n < 3; n++) {
      late ScrollAxisRegion region;
      if (n == 0) {
        region = ScrollAxisRegion.header;
      } else if (n == 1) {
        region = ScrollAxisRegion.body;
      } else if (n == 2) {
        region = ScrollAxisRegion.footer;
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
    final VisibleLinesCollection lines = getVisibleLines();
    final VisibleLineInfo? line = lines.getVisibleLineAtLineIndex(lineIndex);
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

    super.footerExtent = size;
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
    super.headerExtent = size;
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

    final ScrollBarBase sb = scrollBar!;
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
