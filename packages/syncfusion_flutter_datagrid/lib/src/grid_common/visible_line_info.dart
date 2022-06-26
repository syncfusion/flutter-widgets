import 'dart:collection';
import 'dart:math';

import 'enums.dart';
import 'utility_helper.dart' hide ListBase;

/// VisibleLines Information
///
/// Contains information about a visible line (can also be a row or column).
class VisibleLineInfo extends Comparable<VisibleLineInfo> {
  /// Initializes a new instance of the VisibleLineInfo class.
  ///
  /// * visibleIndex - _required_ - Visible index of the line.
  /// * lineIndex - _required_ - Absolute index of the line.
  /// * size - _required_ - The size.
  /// * clippedOrigin - _required_ - The clipped origin.
  /// * scrollOffset - _required_ - The scroll offset.
  /// * isHeader - _required_ - if set to true line is a header.
  /// * isFooter - _required_ - if set to true line is a footer.
  VisibleLineInfo(int visibleIndex, this.lineIndex, double size,
      double clippedOrigin, double scrollOffset, bool isHeader, bool isFooter) {
    _visibleIndex = visibleIndex;
    _size = size;
    _clippedOrigin = clippedOrigin;
    _scrollOffset = scrollOffset;
    _isHeader = isHeader;
    _isFooter = isFooter;
  }

  /// Initializes a new instance of the [VisibleLineInfo] class.
  /// Used for BinarySearch.
  ///
  /// * clippedOrigin - _required_ - The clipped origin.
  VisibleLineInfo.fromClippedOrigin(double clippedOrigin) {
    _clippedOrigin = clippedOrigin;
  }

  /// Initializes a new instance of the [VisibleLineInfo] class.
  /// Used for BinarySearch.
  ///
  /// * lineIndex - _required_ - Index of the line.
  VisibleLineInfo.fromLineIndex(this.lineIndex);

  double _clippedOrigin = 0.0;
  bool _isHeader = false;
  bool _isFooter = false;
  int _visibleIndex = 0;
  double _size = 0.0;
  double _scrollOffset = 0.0;

  ///
  double clippedCornerExtent = 0.0;

  ///
  int lineIndex = 0;

  /// A boolean value indicating whether the visible line is the last line.
  bool isLastLine = false;

  /// Gets the size of the clipped area.
  ///
  /// Returns the size of the clipped area.
  double get clippedSize =>
      max(0.0, _size - _scrollOffset - clippedCornerExtent);

  /// Gets the clipped corner.
  ///
  /// Returns the clipped corner.
  double get clippedCorner => origin + _size - clippedCornerExtent;

  /// Gets the clipped origin.
  ///
  /// Returns the clipped origin.
  double get clippedOrigin => _clippedOrigin;

  /// Gets the corner.
  ///
  /// Returns the corner.
  double get corner => origin + _size;

  /// Gets a value indicating whether this instance is clipped.
  ///
  /// @value
  /// `True` if this instance is clipped, otherwise `false`.
  bool get isClipped => _scrollOffset + clippedCornerExtent > 0;

  /// Gets a value indicating whether this instance is clipped
  /// taking into consideration, whether it is the first or last visible line
  /// and no clipping is needed for these cases.
  ///
  /// Returns a boolean value indicating whether this instance is
  /// clipped taking into consideration, whether it is the first or
  /// last visible line
  /// and no clipping is needed for these cases.
  bool get isClippedBody =>
      (visibleIndex > 0 && isClippedOrigin) || (!isLastLine && isClippedCorner);

  /// Gets a value indicating whether this instance corner is clipped.
  ///
  /// @value
  /// True if this instance corner is clipped, otherwise false.
  bool get isClippedCorner => clippedCornerExtent > 0;

  /// Gets a value indicating whether this instance origin is clipped.
  ///
  /// @value
  /// True if this instance origin is clipped, otherwise false.
  bool get isClippedOrigin => _scrollOffset > 0;

  /// Gets a value indicating whether this instance is a footer.
  ///
  /// Returns true if this instance is a footer, otherwise false.
  bool get isFooter => _isFooter;

  /// Gets a value indicating whether this instance is a header.
  ///
  /// Returns true if this instance is a header, otherwise false.
  bool get isHeader => _isHeader;

  /// Gets a value indicating whether the line is visible.
  ///
  /// Returns a boolean value indicating whether the line is visible.
  bool get isVisible => _visibleIndex != maxvalue;

  /// Gets the origin.
  ///
  /// Returns the origin.
  double get origin => _clippedOrigin - _scrollOffset;

  /// Gets the size.
  ///
  /// Returns the size.
  double get size => _size;

  /// Gets the scroll offset.
  ///
  /// Returns the scroll offset.
  double get scrollOffset => _scrollOffset;

  /// Gets the visible index of the line.
  ///
  /// Returns the visible index of the line.
  int get visibleIndex => _visibleIndex;

  /// Gets the axis region this line belongs to.
  ///
  /// Returns the axis region this line belongs to.
  ScrollAxisRegion get region {
    if (_isHeader) {
      return ScrollAxisRegion.header;
    } else if (_isFooter) {
      return ScrollAxisRegion.footer;
    }

    return ScrollAxisRegion.body;
  }

  ///
  bool isClippedBodyAny(bool hasOriginMargin, bool hasCornerMargin) =>
      ((hasOriginMargin || visibleIndex > 0) && isClippedOrigin) ||
      ((hasCornerMargin || !isLastLine) && isClippedCorner);

  ///
  bool isClippedBodyCorner(bool hasCornerMargin) =>
      (hasCornerMargin || !isLastLine) && isClippedCorner;

  ///
  bool isClippedBodyOrigin(bool hasOriginMargin) =>
      (hasOriginMargin || visibleIndex > 0) && isClippedOrigin;

  /// Compares the current object with another object of the same type.
  ///
  /// * other - _required_ - An object to compare with this object.
  @override
  int compareTo(VisibleLineInfo other) =>
      ((clippedOrigin - other.clippedOrigin).sign).toInt();

  /// A string describing the state of the object.
  ///
  /// Returns a string describing the state of the object.
  @override
  String toString() {
    final String sb = '''
            VisibleLineInfo {
            visibleIndex = ${_visibleIndex.toString()}
            lineIndex =  ${lineIndex.toString()}
            size =  ${_size.toString()}
            origin = ${origin.toString()}
            clippedOrigin = ${_clippedOrigin.toString()}
            scrollOffset =  ${_scrollOffset.toString()}
            region = ${region.toString()}
            }''';

    return sb;
  }
}

/// Collection of VisibleLineInfo items.
///
/// A strong-typed collection of `VisibleLineInfo` items.
class VisibleLinesCollection extends ListBase<VisibleLineInfo> {
  ///
  List<VisibleLineInfo?> visibleLines =
      List<VisibleLineInfo?>.empty(growable: true);

  ///
  VisibleLineInfoLineIndexComparer lineIndexComparer =
      VisibleLineInfoLineIndexComparer();

  ///
  Map<int, VisibleLineInfo>? lineIndexes = <int, VisibleLineInfo>{};

  /// Gets the first visible index of the body.
  int firstBodyVisibleIndex = 0;

  /// Gets the first visible index of the footer.
  int firstFooterVisibleIndex = 0;

  /// Gets the index of the last visible line in the body region.
  ///
  /// Returns the index of the last visible line in the body region.
  int get lastBodyVisibleIndex => firstFooterVisibleIndex - 1;

  /// Gets the visible line indexes.
  ///
  /// Returns the visible line indexes.
  Map<int, VisibleLineInfo>? get visibleLineIndexes => lineIndexes;

  @override
  int get length => visibleLines.length;

  @override
  set length(int length) {
    visibleLines.length = length;
  }

  /// Gets a boolean value indicating whether any of the lines with
  /// the given absolute line index are visible.
  ///
  /// A boolean value indicating whether any of the lines with the
  /// given absolute line index are visible.
  ///
  /// * lineIndex1 - _required_ - The line index 1.
  /// * lineIndex2 - _required_ - The line index 2.
  bool anyVisibleLines(int lineIndex1, int lineIndex2) {
    if (lineIndex1 == lineIndex2) {
      return getVisibleLineAtLineIndex(lineIndex1) != null;
    }

    for (int n = 0; n < length; n++) {
      final VisibleLineInfo line = this[n];
      if (line.lineIndex >= lineIndex1 && line.lineIndex <= lineIndex2) {
        return true;
      }
    }
    return false;
  }

  /// Gets the visible line at line index.
  ///
  /// * lineIndex - _required_ - Index of the line.
  ///
  /// Returns the visible line at line index.
  VisibleLineInfo? getVisibleLineAtLineIndex(int lineIndex) {
    if (lineIndexes != null && lineIndexes!.isEmpty) {
      for (int i = 0; i < length; i++) {
        lineIndexes!.putIfAbsent(this[i].lineIndex, () => this[i]);
      }
      //this.shadowedLineIndexes = this.lineIndexes;
    }
    VisibleLineInfo? lineInfo;
    if (lineIndexes != null && lineIndexes!.containsKey(lineIndex)) {
      return lineInfo = lineIndexes![lineIndex];
    }
    return lineInfo;
  }

  /// Gets the visible line for a line index.
  ///
  /// If the specified line is hidden the next visible line is returned.
  ///
  /// * lineIndex - _required_ - Index of the line.
  ///
  /// Returns the first visible line for a line index that is not hidden.
  VisibleLineInfo? getVisibleLineNearLineIndex(int lineIndex) {
    final List<VisibleLineInfo> visibleLineInfo =
        visibleLines as List<VisibleLineInfo>;
    int index = binarySearch<VisibleLineInfo>(
        visibleLineInfo, VisibleLineInfo.fromLineIndex(lineIndex));
    index = (index < 0) ? (~index) - 1 : index;
    if (index >= 0) {
      return this[index];
    }
    return null;
  }

  /// Gets the visible line at point.
  ///
  /// * point - _required_ - The point at which the visible line is
  /// to be obtained.
  ///
  /// Returns the visible line at point.
  VisibleLineInfo? getVisibleLineAtPoint(double point) {
    final List<VisibleLineInfo> visibleLineInfo = visibleLines.cast();
    int index = binarySearch<VisibleLineInfo>(
        visibleLineInfo, VisibleLineInfo.fromClippedOrigin(point));
    index = (index < 0) ? (~index) - 1 : index;
    if (index >= 0) {
      return this[index];
    }
    return null;
  }

  /// Used to insert lines internally
  ///
  /// * lineIndex - _required_ - Index for inserting line
  /// * count - _required_ - Number of lines need to insert
  ///
  /// Returns the boolean value
  bool insertLinesInternal(int lineIndex, int count) {
    bool visibleLinesAffected = false;
    for (int n = 0; n < length; n++) {
      final VisibleLineInfo line = this[n];
      if (line.lineIndex >= lineIndex) {
        if (line.lineIndex == lineIndex) {
          visibleLinesAffected = true;
        }

        line.lineIndex += count;
      }
    }
    return visibleLinesAffected;
  }

  /// Used to remove lines internally
  ///
  /// * lineIndex - _required_ - Index for removing line
  /// * count - _required_ - Number of lines needs to be remove
  ///
  /// Returns the boolean value
  bool removeLinesInternal(int lineIndex, int count) {
    bool visibleLinesAffected = false;
    for (int n = 0; n < length; n++) {
      final VisibleLineInfo line = this[n];
      if (line.lineIndex >= lineIndex) {
        if (line.lineIndex < lineIndex + count) {
          visibleLinesAffected = true;
        } else {
          line.lineIndex -= count;
        }
      }
    }

    return visibleLinesAffected;
  }

  /// Removes all elements from the collection.
  @override
  void clear() {
    lineIndexes?.clear();
    lineIndexes = null;
    visibleLines.clear();
    //this.shadowedLineIndexes = null;
    lineIndexes = <int, VisibleLineInfo>{};
  }

  @override
  VisibleLinesCollection get reversed {
    final VisibleLinesCollection reverseCollection = VisibleLinesCollection();
    for (int i = length - 1; i >= 0; i--) {
      reverseCollection.add(this[i]);
    }
    return reverseCollection;
  }

  @override
  void operator []=(int index, VisibleLineInfo value) {
    visibleLines[index] = value;
  }

  @override
  VisibleLineInfo operator [](int index) => visibleLines[index]!;
}

/// Initializes a new instance of the `VisibleLineInfoLineIndexComparer` class.
class VisibleLineInfoLineIndexComparer extends Comparable<VisibleLineInfo> {
  /// Compares the given visible lines.
  ///
  /// * x - _required_ - The visible line-1.
  /// * y - _required_ - The visible line-2.
  ///
  /// Returns a integer value indicating the comparison of the
  /// given visible lines.
  int compare(VisibleLineInfo x, VisibleLineInfo y) =>
      (x.lineIndex - y.lineIndex).sign;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
