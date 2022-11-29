import 'dart:math';

import 'distance_counter.dart';
import 'event_args.dart';
import 'scroll_axis.dart';
import 'utility_helper.dart';

/// Returns the DefaultLineSizeChangedArgs used by the
/// [onDefaultLineSizeChanged] event.
typedef DefaultLineSizeChangedCallback = void Function(
    DefaultLineSizeChangedArgs defaultLineSizeChangedArgs);

/// Returns the LineCountChangedArgs used by the
/// [onLineCountChanged][onHeaderLineCountChanged][onFooderLineCountChanged]
/// event.
typedef LineCountChangedCallback = void Function();

/// Returns the HiddenRangeChangedArgs used by the [onLineHiddenChanged] event.
typedef LineHiddenChangedCallback = void Function(
    HiddenRangeChangedArgs hiddenRangeChangedArgs);

/// Returns the LinesInsertedArgs used by the [onLinesInserted] event.
typedef LinesInsertedCallback = void Function(
    LinesInsertedArgs linesInsertedArgs);

/// Returns the LinesRemovedArgs used by the [onLinesRemoved] event.
typedef LinesRemovedCallback = void Function(LinesRemovedArgs linesRemovedArgs);

/// Returns the RangeChangedArgs used by the [onLineSizeChanged] event.
typedef LineSizeChangedCallback = void Function(
    RangeChangedArgs rangeChangedArgs);

/// A collection that manages lines with varying height and hidden state.
///
/// It has properties for header and footer lines, total line count, default
/// size of a line and also lets you add nested collections.
///
/// _Note:_ This is common for header, footer, total line count and default
/// size of line.
abstract class LineSizeHostBase {
  /// Occurs when the default line size changed.
  DefaultLineSizeChangedCallback? onDefaultLineSizeChanged;

  /// Occurs when the footer line count was changed.
  LineCountChangedCallback? onFooterLineCountChanged;

  /// Occurs when the header line count was changed.
  LineCountChangedCallback? onHeaderLineCountChanged;

  /// Occurs when a lines size was changed.
  LineSizeChangedCallback? onLineSizeChanged;

  /// Occurs when a lines hidden state changed.
  LineHiddenChangedCallback? onLineHiddenChanged;

  /// Occurs when the line count was changed.
  LineCountChangedCallback? onLineCountChanged;

  /// Occurs when lines were inserted.
  LinesInsertedCallback? onLinesInserted;

  /// Occurs when lines were removed.
  LinesRemovedCallback? onLinesRemoved;

  /// Returns the default line size..
  double getDefaultLineSize();

  /// Gets the footer line count.
  ///
  /// Returns the footer line count.
  int getFooterLineCount();

  /// Gets the header line count.
  ///
  /// Returns the header line count.
  int getHeaderLineCount();

  /// Gets the boolean value indicating the hidden state for the line
  /// with given index.
  ///
  /// * index - _required_ - The index of the line for which the hidden state
  /// is to be obtained.
  /// * repeatValueCount - _required_ - The number of subsequent lines with
  /// same state.
  ///
  /// Returns the boolean value indicating the hidden state for a line.
  List<dynamic> getHidden(int index, int repeatValueCount);

  /// Returns the line count.
  int getLineCount();

  /// Gets the size of the line at the given index.
  ///
  /// * index - _required_ - The index of the line for which the size is to
  /// be obtained.
  /// * repeatValueCount - _required_ - The number of subsequent values
  /// with same size.
  ///
  /// Retuns the size of the line at the given index.
  List<dynamic> getSize(int index, int repeatValueCount);

  /// Initializes the scroll axis.
  ///
  /// * scrollAxis - _required_ - The scroll axis.
  void initializeScrollAxis(ScrollAxisBase scrollAxis);
}

/// An object that implements the `Distances` property.
mixin DistancesHostBase {
  /// Gets the distances of the lines.
  ///
  /// Returns the distances of the lines.
  DistanceCounterCollectionBase? get distances;
}

/// An object that implements the `GetDistances` method.
abstract class NestedDistancesHostBase {
  /// Gets the nested distances, if a line contains a nested lines collection,
  /// otherwise null.
  ///
  /// * line - _required_ - The line at which the distances is to be obtained.
  ///
  /// Returns the nested distances, if a line contains a nested lines
  /// collection, otherwise null.
  DistanceCounterCollectionBase? getDistances(int line);
}

/// A collection that manages lines with varying height and hidden state.
///
/// It has properties for header and footer lines, total line count, default
/// size of a line and also lets you add nested collections. Methods
/// are provided for changing the values and getting the total extent.
///
/// _Note:_ This is common for header, footer, total line count and default
/// size of line.
abstract class EditableLineSizeHostBase extends LineSizeHostBase {
  ///
  EditableLineSizeHostBase(
      {double defaultLineSize = 0.0,
      int footerLineCount = 0,
      int headerLineCount = 0,
      int lineCount = 0,
      bool supportsInsertRemove = false,
      bool supportsNestedLines = false,
      double totalExtent = 0.0})
      : _defaultLineSize = defaultLineSize,
        _footerLineCount = footerLineCount,
        _headerLineCount = headerLineCount,
        _lineCount = lineCount,
        _supportsInsertRemove = supportsInsertRemove,
        _supportsNestedLines = supportsNestedLines,
        _totalExtent = totalExtent;

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

  /// Gets the footer line count.
  ///
  /// Returns the footer line count.
  int get footerLineCount => _footerLineCount;
  int _footerLineCount = 0;

  /// Sets the footer line count.
  set footerLineCount(int value) {
    if (value == _footerLineCount) {
      return;
    }

    _footerLineCount = value;
  }

  /// Gets the header line count.
  ///
  /// Returns the header line count.
  int get headerLineCount => _headerLineCount;
  int _headerLineCount = 0;

  /// Sets the header line count.
  set headerLineCount(int value) {
    if (value == _headerLineCount) {
      return;
    }

    _headerLineCount = value;
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

  /// Gets a value indicating whether the host supports inserting and
  /// removing lines.
  ///
  /// Returns the boolean value indicating whether the host supports inserting
  /// and removing lines.
  bool get supportsInsertRemove => _supportsInsertRemove;
  bool _supportsInsertRemove = false;
  set supportsInsertRemove(bool value) {
    if (value == _supportsInsertRemove) {
      return;
    }
    _supportsInsertRemove = value;
  }

  /// Gets a value indicating whether the host supports nesting or not.
  ///
  /// Returns a boolean value indicating whether the host supports nesting.
  bool get supportsNestedLines => _supportsNestedLines;
  bool _supportsNestedLines = false;
  set supportsNestedLines(bool value) {
    if (value == _supportsNestedLines) {
      return;
    }

    _supportsNestedLines = value;
  }

  /// Gets the total extent which is the total of all line sizes.
  ///
  /// Returns the total extent which is the total of all line sizes
  /// or `double.NaN`.
  ///
  /// Note: This property only works if the `DistanceCounterCollection` has
  /// been setup for pixel scrolling,
  /// otherwise it returns `double.NaN`.
  double get totalExtent => _totalExtent;
  double _totalExtent = 0;
  set totalExtent(double value) {
    if (value == _totalExtent) {
      return;
    }

    _totalExtent = value;
  }

  /// Creates the object which holds temporary state when moving lines.
  ///
  /// Returns the object which holds temporary state when moving lines.
  EditableLineSizeHostBase createMoveLines();

  /// Gets the nested lines at the given index.
  ///
  /// * index - _required_ - The index at which the nested lines is to
  /// be obtained.
  ///
  /// Returns the `IEditableLineSizeHost` representing the nested lines.
  EditableLineSizeHostBase? getNestedLines(int index);

  /// Insert the given number of lines at the given index.
  ///
  /// * insertAtLine - _required_ - The index of the first line to insert.
  /// * count - _required_ - The count of the lines to be inserted.
  /// * moveLines - _required_ - A container with saved state from a preceding
  /// `RemoveLines` call when lines should be moved. When it is null,
  /// empty lines with default size are inserted.
  void insertLines(
      int insertAtLine, int count, EditableLineSizeHostBase? moveLines);

  /// Removes a number of lines at the given index.
  ///
  /// * removeAtLine - _required_ - The index of the first line to be removed.
  /// * count - _required_ - The count of the lines to be removed.
  /// * moveLines - _required_ - A container to save state for a subsequent
  /// `InsertLines` call when lines should be moved.
  void removeLines(
      int removeAtLine, int count, EditableLineSizeHostBase? moveLines);

  /// Sets the hidden state for the given range of lines.
  ///
  /// * from - _required_ - The start index of the line for which
  /// the hidden state to be set.
  /// * to - _required_ - The end index of the line for which the
  /// hidden state to be set.
  /// * hide - _required_ - A boolean value indicating whether to
  /// hide the lines. If set to true
  /// hide the lines.
  void setHidden(int from, int to, bool hide);

  /// Sets the nested lines at the given index.
  ///
  /// * index - _required_ - The index at which the nested lines is to be added.
  /// * nestedLines - _required_ - The nested lines to be added. If parameter
  /// is null the line will
  /// be converted to a normal (not nested) line with default line size.
  void setNestedLines(int index, EditableLineSizeHostBase nestedLines);

  /// Sets the line size for the range of lines.
  ///
  /// * from - _required_ - The start index of the line for which the
  /// line size is to be set.
  /// * to - _required_ - The end index of the line for which the
  /// line size is to be set.
  /// * size - _required_ - The line size to be set to the given range of lines.
  void setRange(int from, int to, double size);

  /// Gets the line size at the specified index.
  ///
  /// * index - _required_ - index value
  /// Returns the line size at the specified index.
  double operator [](int index) => this[index];

  /// Sets the line size at the specified index.
  void operator []=(int index, double value) => this[index] = value;
}

/// An object that implements the `PaddingDistance` property
/// and `DeferRefresh` method.
abstract class PaddedEditableLineSizeHostBase extends EditableLineSizeHostBase {
  ///
  PaddedEditableLineSizeHostBase(
      {double paddingDistance = 0.0,
      double defaultLineSize = 0.0,
      int footerLineCount = 0,
      int headerLineCount = 0,
      int lineCount = 0,
      bool supportsInsertRemove = false,
      bool supportsNestedLines = false,
      double totalExtent = 0.0})
      : _paddingDistance = paddingDistance,
        super(
            defaultLineSize: defaultLineSize,
            footerLineCount: footerLineCount,
            headerLineCount: headerLineCount,
            lineCount: lineCount,
            supportsInsertRemove: supportsInsertRemove,
            supportsNestedLines: supportsNestedLines,
            totalExtent: totalExtent);

  /// Gets the padding distance for the line.
  ///
  /// Returns the padding distance for the line.
  double get paddingDistance => _paddingDistance;
  double _paddingDistance = 0.0;

  /// Sets the padding distance for the line.
  set paddingDistance(double value) {
    if (value == _paddingDistance) {
      return;
    }

    _paddingDistance = value;
  }
}

/// A collection that manages lines with varying height and hidden state.
///
/// It has properties for header and footer lines, total line count, default
/// size of a line and also lets you add nested collections.
///
/// _Note:_ This is common for header, footer, total line count and
/// default size of line.
class LineSizeCollection extends PaddedEditableLineSizeHostBase
    with DistancesHostBase, NestedDistancesHostBase {
  ///Initializes a new instance of the [LineSizeCollection] class.
  LineSizeCollection()
      : super(
            headerLineCount: 0,
            footerLineCount: 0,
            lineCount: 0,
            defaultLineSize: 1.0,
            paddingDistance: 0.0);

  final SortedRangeValueList<double> _lineSizes =
      SortedRangeValueList<double>.from(-1);
  DistanceCounterCollectionBase? _distances;
  int _isSuspendUpdates = 0;
  SortedRangeValueList<bool> _lineHidden =
      SortedRangeValueList<bool>.from(false);
  Map<int, LineSizeCollection> _lineNested = <int, LineSizeCollection>{};

  set distances(DistanceCounterCollectionBase? newValue) {
    if (_distances == newValue) {
      return;
    }

    _distances = newValue;
  }

  /// Gets the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  ///
  /// Returns the distances collection which is used internally for mapping
  /// from a point position to a line index and vice versa.
  @override
  DistanceCounterCollectionBase? get distances {
    if (_distances == null) {
      _distances =
          DistanceRangeCounterCollection.fromPaddingDistance(paddingDistance);
      initializeDistances();
    }

    return _distances;
  }

  /// Sets the default size of lines.
  @override
  set defaultLineSize(double value) {
    if (defaultLineSize != value) {
      final double savedValue = defaultLineSize;
      super.defaultLineSize = value;

      if (isSuspendUpdates) {
        return;
      }

      if (_distances != null) {
        initializeDistances();
      }

      if (onDefaultLineSizeChanged != null) {
        final DefaultLineSizeChangedArgs defaultLineSizeChangedArgs =
            DefaultLineSizeChangedArgs.fromArgs(savedValue, defaultLineSize);
        onDefaultLineSizeChanged!(defaultLineSizeChangedArgs);
      }
    }
  }

  /// Sets the footer line count.
  @override
  set footerLineCount(int value) {
    if (footerLineCount != value) {
      super.footerLineCount = value;
      if (onFooterLineCountChanged != null) {
        onFooterLineCountChanged!();
      }
    }
  }

  /// Sets the header line count.
  @override
  set headerLineCount(int value) {
    if (headerLineCount != value) {
      super.headerLineCount = value;
      if (onHeaderLineCountChanged != null) {
        onHeaderLineCountChanged!();
      }
    }
  }

  ///
  bool get isSuspendUpdates => _isSuspendUpdates > 0;

  /// Sets the line count.
  @override
  set lineCount(int value) {
    if (lineCount != value) {
      super.lineCount = value;

      if (isSuspendUpdates) {
        return;
      }

      if (_distances != null) {
        _distances!.count = lineCount;
      }
    }
  }

  /// sets the padding distance for the line.
  @override
  set paddingDistance(double value) {
    if (paddingDistance != value) {
      super.paddingDistance = value;

      if (isSuspendUpdates) {
        return;
      }

      _distances =
          DistanceRangeCounterCollection.fromPaddingDistance(paddingDistance);
      initializeDistances();
    }
  }

  /// Gets a value indicating whether the host supports nesting.
  ///
  /// Returns a boolean value indicating whether the host supports nesting.
  @override
  bool get supportsNestedLines => true;

  /// Gets a value indicating whether the host supports inserting and
  /// removing lines or not.
  ///
  /// Returns the boolean value indicating whether the host supports inserting
  /// and removing lines.
  @override
  bool get supportsInsertRemove => true;

  /// Gets the total extent which is the total of all line sizes.
  ///
  /// Returns the total extent which is the total of all
  /// line sizes or [double.nan].
  ///
  /// _Note:_ This property only
  /// works if the [DistanceCounterCollection] has been setup
  /// for pixel scrolling,
  /// otherwise it returns [double.nan].
  @override
  double get totalExtent {
    // This only works if the DistanceCollection has been
    // setup for pixel scrolling.
    if (distances != null && distances!.defaultDistance == defaultLineSize) {
      return _distances!.totalDistance;
    }
    return double.nan;
  }

  /// Creates the object which holds temporary state when moving lines.
  ///
  /// Returns the object which holds temporary state when moving lines.
  @override
  EditableLineSizeHostBase createMoveLines() => LineSizeCollection();

  /// Gets the default line size.
  ///
  /// Returns the default line size.
  @override
  double getDefaultLineSize() => defaultLineSize;

  /// Gets the nested distances, if a line contains a nested lines collection,
  /// otherwise null.
  ///
  /// * line - _required_ - The line at which the distances is to be obtained.
  ///
  /// Returns the nested distances, if a line contains a nested lines
  /// collection, otherwise null.
  @override
  DistanceCounterCollectionBase? getDistances(int line) {
    final Object? nestedLines = getNestedLines(line);
    if (nestedLines is DistancesHostBase) {
      return nestedLines.distances;
    } else {
      return null;
    }
  }

  /// Gets the footer line count.
  ///
  /// Returns the footer line count.
  @override
  int getFooterLineCount() => footerLineCount;

  /// Gets the header line count.
  ///
  /// Returns the header line count.
  @override
  int getHeaderLineCount() => headerLineCount;

  /// Gets the line count.
  ///
  /// Returns the line count.
  @override
  int getLineCount() => lineCount;

  /// Gets the nested lines at the given index.
  ///
  /// * index - _required_ - The index at which the nested lines is to
  /// be obtained.
  ///
  /// Returns the [IEditableLineSizeHost] representing the nested lines.
  @override
  EditableLineSizeHostBase? getNestedLines(int index) {
    if (_lineNested.containsKey(index)) {
      return _lineNested[index];
    }

    return null;
  }

  /// Gets the size of the line at the given index.
  ///
  /// * index - _required_ - The index of the line for which the
  /// size is to be obtained.
  /// * repeatValueCount - _required_ - The number of subsequent
  /// values with same size.
  ///
  /// Returns the size of the line at the given index.
  @override
  List<dynamic> getSize(int index, int repeatValueCount) {
    repeatValueCount = 1;
    final EditableLineSizeHostBase? nested = getNestedLines(index);
    if (nested != null) {
      return <dynamic>[nested.totalExtent, repeatValueCount];
    }

    return getRange(index, repeatValueCount);
  }

  /// Gets the boolean value indicating the hidden state for the
  /// line with given index.
  ///
  /// * index - _required_ - The index of the line for which the hidden
  /// state is to be obtained.
  /// * repeatValueCount - _required_ - The number of subsequent
  /// lines with same state.
  ///
  /// Returns the boolean value indicating the hidden state for a line.
  @override
  List<dynamic> getHidden(int index, int repeatValueCount) {
    final List<dynamic> rangeValue =
        _lineHidden.getRange(index, repeatValueCount);
    return <dynamic>[rangeValue[0], rangeValue[1]];
  }

  ///
  List<dynamic> getRange(int index, int repeatValueCount) {
    repeatValueCount = 1;

    if (_lineNested.containsKey(index)) {
      return <dynamic>[_lineNested[index]?.totalExtent, repeatValueCount];
    }
    final List<dynamic> hiddenValue =
        _lineHidden.getRange(index, repeatValueCount);
    final bool hide = hiddenValue[0] as bool;
    repeatValueCount = hiddenValue[1] as int;
    if (hide) {
      return <dynamic>[0.0, repeatValueCount];
    }

    final List<dynamic> rangeValue =
        _lineSizes.getRange(index, repeatValueCount);
    final double size = rangeValue[0] as double;
    repeatValueCount = rangeValue[1] as int;
    if (size >= 0) {
      return <dynamic>[size, repeatValueCount];
    }
    return <dynamic>[defaultLineSize, repeatValueCount];
  }

  ///
  void initializeDistances() {
    if (distances != null) {
      distances!
        ..clear()
        ..count = getLineCount()
        ..defaultDistance = defaultLineSize;
      _lineNested.forEach((int key, LineSizeCollection value) {
        int repeatSizeCount = -1;
        final List<dynamic> hiddenValue = getHidden(key, repeatSizeCount);
        final bool hide = hiddenValue[0] as bool;
        repeatSizeCount = hiddenValue[1] as int;
        if (hide) {
          _distances!.setNestedDistances(key, null);
        } else {
          _distances!.setNestedDistances(key, value.distances);
        }
      });

      for (final RangeValuePair<double> entry in _lineSizes.rangeValues) {
        final double entryValue = entry.value as double;
        if (entryValue != -2) {
          _distances!.setRange(entry.start, entry.end,
              entryValue < 0.0 ? defaultLineSize : entryValue);
        }
      }

      for (final RangeValuePair<bool> entry in _lineHidden.rangeValues) {
        final bool entryValue = entry.value as bool;
        if (entryValue) {
          _distances!.setRange(entry.start, entry.end, 0.0);
        }
      }
    }
  }

  /// Inserts lines in the collection and raises the [LinesInserted] event.
  ///
  /// * insertAtLine - _required_ - The index of the first line to insert.
  /// * count - _required_ - The count of the lines to be inserted.
  void insertLinesBase(int insertAtLine, int count) {
    insertLines(insertAtLine, count, null);
  }

  /// Insert the given number of lines at the given index.
  ///
  /// * insertAtLine - _required_ - The index of the first line to insert.
  /// * count - _required_ - The count of the lines to be inserted.
  /// * movelines - _required_ - A container with saved state from a preceding
  /// Syncfusion.GridCommon.ScrollAxis.LineSizeCollection.InsertLines(int, int)
  /// call when lines should be moved. When it is null, empty lines with default
  /// size are inserted.
  @override
  void insertLines(
      int insertAtLine, int count, EditableLineSizeHostBase? moveLines) {
    final LineSizeCollection? moveLine =
        moveLines != null ? moveLines as LineSizeCollection : null;
    _lineSizes.insertWithThreeArgs(insertAtLine, count, moveLine?._lineSizes);
    _lineHidden.insertWithThreeArgs(insertAtLine, count, moveLine?._lineHidden);
    _lineNested = <int, LineSizeCollection>{};

    _lineNested.forEach((int key, LineSizeCollection value) {
      if (key >= insertAtLine) {
        _lineNested.putIfAbsent(key + count, () => value);
      } else {
        _lineNested.putIfAbsent(key, () => value);
      }
    });

    if (moveLine != null) {
      for (int i = 0; i < moveLine._lineNested.length; i++) {
        moveLine._lineNested.forEach((int key, LineSizeCollection value) {
          _lineNested.putIfAbsent(key + insertAtLine, () => value);
        });
      }
    }

    super.lineCount += count;

    if (isSuspendUpdates) {
      return;
    }

    if (_distances != null) {
      DistancesUtil.onInserted(_distances!, this, insertAtLine, count);
    }

    if (onLinesInserted != null) {
      final LinesInsertedArgs linesInsertedArgs =
          LinesInsertedArgs.fromArgs(insertAtLine, count);
      onLinesInserted!(linesInsertedArgs);
    }
  }

  /// Initializes the scroll axis.
  ///
  /// * scrollAxis - _required_ - The scroll axis.
  @override
  void initializeScrollAxis(ScrollAxisBase scrollAxis) {
    final PixelScrollAxis pixelScrollAxis = scrollAxis as PixelScrollAxis;
    if (_lineNested.isNotEmpty) {
      throw Exception(
          'When you have nested line collections you need to use PixelScrolling!');
    }
    scrollAxis
      ..defaultLineSize = defaultLineSize
      ..lineCount = lineCount;

    for (final RangeValuePair<double> entry in _lineSizes) {
      if (entry.value != -2) {
        final double entryValue = entry.value as double;
        scrollAxis.setLineSize(entry.start, entry.end,
            entryValue < 0 ? defaultLineSize : entry.value);
      }
    }

    for (final MapEntry<int, LineSizeCollection> entry in _lineNested.entries) {
      pixelScrollAxis.setNestedLines(entry.key, entry.value.distances);
    }

    for (final RangeValuePair<bool> entry in _lineHidden) {
      scrollAxis.setLineHiddenState(entry.start, entry.end, entry.value);
    }
  }

  /// Resets the hidden state of the line.
  void resetHiddenState() {
    _lineHidden = SortedRangeValueList<bool>();
  }

  /// Reset the lines with default line size.
  void resetLines() {
    _lineSizes.clear();
  }

  /// Removes a number of lines at the given index.
  ///
  /// * removeAtLine - _required_ - The index of the first line to be removed.
  /// * count - _required_ - The count of the lines to be removed.
  /// * movelines - _required_ - A container to save state for a subsequent
  /// Syncfusion.GridCommon.ScrollAxis.LineSizeCollection.RemoveLines(int, int)
  /// call when lines should be moved.
  @override
  void removeLines(
      int removeAtLine, int count, EditableLineSizeHostBase? moveLines) {
    final LineSizeCollection? removeLines =
        moveLines != null ? moveLines as LineSizeCollection : null;
    _lineSizes.removeWithThreeArgs(
        removeAtLine, count, removeLines?._lineSizes);
    _lineHidden.removeWithThreeArgs(
        removeAtLine, count, removeLines?._lineHidden);

    final Map<int, LineSizeCollection> lineNested = _lineNested;
    _lineNested = <int, LineSizeCollection>{};

    for (int i = 0; i < lineNested.length; i++) {
      lineNested.forEach((int key, LineSizeCollection value) {
        if (key >= removeAtLine) {
          if (key >= removeAtLine + count) {
            _lineNested.putIfAbsent(key - count, () => value);
          } else if (removeLines != null) {
            removeLines._lineNested
                .putIfAbsent(key - removeAtLine, () => value);
          }
        } else {
          _lineNested.putIfAbsent(key, () => value);
        }
      });
    }

    super.lineCount -= count;

    if (isSuspendUpdates) {
      return;
    }

    if (_distances != null) {
      _distances!.remove(removeAtLine, count);
    }

    if (onLinesRemoved != null) {
      final LinesRemovedArgs linesRemovedArgs =
          LinesRemovedArgs.fromArgs(removeAtLine, count);
      onLinesRemoved!(linesRemovedArgs);
    }
  }

  /// Removes lines from the collection and raises the [LinesRemoved] event.
  ///
  /// * removeAtLine - _required_ - The index of the first line to be removed.
  /// * count - _required_ - The count of the lines to be removed.
  void removeLinesBase(int removeAtLine, int count) {
    removeLines(removeAtLine, count, null);
  }

  /// Reset the line to become a normal (not nested) line with
  /// default line size.
  void resetNestedLines() {
    for (int i = 0; i < _lineNested.length; i++) {
      _lineNested.forEach((int key, LineSizeCollection value) {
        _lineSizes[key] = -1;
      });
    }

    _lineNested.clear();
  }

  /// Reset the line to become a normal (not nested) line
  /// with default line size.
  ///
  /// * index - _required_ - The index of the line to be reset.
  void resetNestedLinesWithArgs(int index) {
    setNestedLines(index, null);
  }

  /// Resumes the update in the view.
  void resumeUpdates() {
    _isSuspendUpdates--;
    if (_isSuspendUpdates == 0) {
      if (_distances != null) {
        initializeDistances();
      }

      if (onLineHiddenChanged != null) {
        final HiddenRangeChangedArgs hiddenRangeChangedArgs =
            HiddenRangeChangedArgs.fromArgs(0, lineCount - 1, false);
        onLineHiddenChanged!(hiddenRangeChangedArgs);
      }
    }
  }

  /// Sets the hidden state for the given range of lines.
  ///
  /// * from - _required_ - The start index of the line for which the hidden
  /// state to be set.
  /// * to - _required_ - The end index of the line for which the hidden state
  /// to be set.
  /// * hide - _required_ - A boolean value indicating whether to hide
  /// the lines. If set to true hide the lines.
  @override
  void setHidden(int from, int to, bool hide) {
    _lineHidden.setRange(from, to - from + 1, hide, false);

    if (isSuspendUpdates) {
      return;
    }
    // DistancesLineHiddenChanged checks both hidden state and sizes together...
    if (_distances != null) {
      DistancesUtil.distancesLineHiddenChanged(distances!, this, from, to);
    }
    HiddenRangeChangedArgs hiddenRangeChangedArgs;
    if (onLineHiddenChanged != null) {
      hiddenRangeChangedArgs = HiddenRangeChangedArgs.fromArgs(from, to, hide);
      onLineHiddenChanged!(hiddenRangeChangedArgs);
    }
  }

  /// Initialize the collection with a pattern of hidden lines with state.
  ///
  /// * start - _required_ - The index of the first line where the pattern
  /// should be started to be applied.
  /// * lineCount - _required_ - The pattern is applied up to until the
  /// lineCount given. The last initialized line is at index lineCount-1.
  /// * values - _required_ - The pattern that is applied repeatedly.
  void setHiddenIntervalWithState(int start, int lineCount, List<bool> values) {
    suspendUpdates();

    for (int index = start; index < lineCount; index += values.length) {
      for (int n = 0; n < values.length; n++) {
        if (n + index < lineCount) {
          _lineHidden[index + n] = values[n];
        }
      }
    }

    resumeUpdates();
  }

  /// Set the hidden state all at once in one operation.
  ///
  /// Use this method if you want to change the hidden
  /// state of many rows at once since this will be much faster instead of
  /// individually setting rows hidden.
  ///
  /// * values - _required_ - The new hidden state for rows.
  void setHiddenState(List<bool> values) {
    suspendUpdates();

    _lineHidden = SortedRangeValueList<bool>();

    final int count = min(lineCount, values.length);
    for (int index = 0; index < count; index++) {
      _lineHidden[index] = values[index];
    }

    resumeUpdates();
  }

  /// Initialize the collection with a pattern of hidden lines.
  ///
  /// * start - _required_ - The index of the first line where the pattern
  /// should be started to be applied.
  /// * lineCount - _required_ - The pattern is applied up to until
  /// the lineCount given. The last initialized line is at index lineCount-1.
  /// * values - _required_ - The pattern that is applied repeatedly.
  void setHiddenInterval(int start, int lineCount, List<bool> values) {
    suspendUpdates();

    _lineHidden = SortedRangeValueList<bool>();

    for (int index = start; index < lineCount; index += values.length) {
      for (int n = 0; n < values.length; n++) {
        if (n + index < lineCount) {
          _lineHidden[index + n] = values[n];
        }
      }
    }

    resumeUpdates();
  }

  /// Sets the nested lines at the given index.
  ///
  /// * index - _required_ - The index at which the nested lines is to be added.
  /// * nestedLines - _required_ - The nested lines to be added. If parameter
  /// is null the line will be converted to a normal (not nested) line with
  /// default line size.
  @override
  void setNestedLines(int index, EditableLineSizeHostBase? nestedLines) {
    if (nestedLines != null) {
      _lineSizes[index] =
          -2; // -1 indicates default value, -2 indicates nested.
      _lineNested[index] = nestedLines as LineSizeCollection;
    } else {
      _lineSizes[index] =
          -1; // -1 indicates default value, -2 indicates nested.
      _lineNested.remove(index);
    }
    if (isSuspendUpdates) {
      return;
    }

    if (_distances != null) {
      DistancesUtil.distancesLineSizeChanged(distances!, this, index, index);
    }

    if (onLineSizeChanged != null) {
      onLineSizeChanged!(RangeChangedArgs.fromArgs(index, index));
    }
  }

  /// Sets the line size for the range of lines.
  ///
  /// * from - _required_ - The start index of the line for which the line
  /// size is to be set.
  /// * to - _required_ - The end index of the line for which the line size
  /// is to be set.
  /// * size - _required_ - The line size to be set to the given range of lines.
  @override
  void setRange(int from, int to, double size) {
    int count = 0;
    final List<dynamic> rangeValue = getRange(from, count);
    final double saveValue = rangeValue[0] as double;
    count = rangeValue[1] as int;
    _lineSizes.setRange(from, to - from + 1, size);

    if (isSuspendUpdates) {
      return;
    }

    if (_distances != null) {
      DistancesUtil.distancesLineHiddenChanged(_distances!, this, from, to);
    }
    RangeChangedArgs rangeChangedArgs;
    if (onLineSizeChanged != null) {
      rangeChangedArgs =
          RangeChangedArgs.fromRangeChangedArgs(from, to, saveValue, size);
      onLineSizeChanged!(rangeChangedArgs);
    }
  }

  /// Suspends the updates in the view.
  void suspendUpdates() {
    _isSuspendUpdates++;
  }

  /// Gets the line size at the specified index.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the line size at the specified index.
  @override
  double operator [](int index) {
    return getRange(index, -1)[0] as double;
  }

  /// Sets the line size at the specified index.
  @override
  void operator []=(int index, double value) {
    setRange(index, index, value);
  }
}

/// Initializes a new instance of the DistanceLineCounterTree class.
class DistancesUtil {
  /// Prevents a default instance of the DistancesUtil class from being created.
  DistancesUtil();

  /// This method fires when distances line hidden changed.
  ///
  /// * distances - _required_ - The distances
  /// * linesHost - _required_ - The line host.
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  static void distancesLineHiddenChanged(
      DistanceCounterCollectionBase distances,
      LineSizeHostBase linesHost,
      int from,
      int to) {
    final Object ndh = linesHost;
    for (int n = from; n <= to; n++) {
      int repeatSizeCount = -1;
      final List<dynamic> hiddenLine = linesHost.getHidden(n, repeatSizeCount);
      final bool hide = hiddenLine[0] as bool;
      repeatSizeCount = hiddenLine[1] as int;

      void setRange() {
        final int rangeTo = getRangeToHelper(n, to, repeatSizeCount);
        if (hide) {
          distances.setRange(n, rangeTo, 0.0);
        } else {
          distancesLineSizeChanged(distances, linesHost, n, rangeTo);
        }

        n = rangeTo;
      }

      if (ndh is NestedDistancesHostBase) {
        if (ndh.getDistances(n) == null) {
          setRange();
        } else {
          distances.setNestedDistances(n, hide ? null : ndh.getDistances(n));
        }
      } else {
        setRange();
      }
    }
  }

  /// This method fires when the distances line size changed.
  ///
  /// * distances - _required_ - The distances
  /// * linesHost - _required_ - The line host.
  /// * from - _required_ - The start index of the line.
  /// * to - _required_ - The end index of the line.
  static void distancesLineSizeChanged(DistanceCounterCollectionBase distances,
      LineSizeHostBase linesHost, int from, int to) {
    final Object ndh = linesHost;

    for (int n = from; n <= to; n++) {
      void setRange() {
        int repeatSizeCount = -1;
        final List<dynamic> lineSize = linesHost.getSize(n, repeatSizeCount);
        final double size = lineSize[0] as double;
        repeatSizeCount = lineSize[1] as int;
        final int rangeTo = getRangeToHelper(n, to, repeatSizeCount);
        distances.setRange(n, rangeTo, size);
        n = rangeTo;
      }

      if (ndh is NestedDistancesHostBase) {
        if (ndh.getDistances(n) == null) {
          setRange();
        } else {
          distances.setNestedDistances(n, ndh.getDistances(n));
        }
      } else {
        setRange();
      }
    }
  }

  /// Gets the range to helper.
  ///
  /// * n - _required_ - The index.
  /// * to - _required_ - The end index.
  /// * repeatSizeCount - _required_ - The count of repeated sizes.
  ///
  /// Returns the minimum index value
  static int getRangeToHelper(int n, int to, int repeatSizeCount) {
    if (repeatSizeCount == maxvalue) {
      return to;
    }

    return min(to, n + repeatSizeCount - 1);
  }

  /// This method fires when the lines is inserted.
  ///
  /// * distances - _required_ - The distances
  /// * linesHost - _required_ - The line host.
  /// * insertAt - _required_ - The index to insert.
  /// * count - _required_ - The count of the lines inserted.
  static void onInserted(DistanceCounterCollectionBase distances,
      LineSizeHostBase linesHost, int insertAt, int count) {
    distances.insert(insertAt, count);
    final int to = insertAt + count - 1;
    int repeatSizeCount = -1;

    // Set line sizes
    for (int index = insertAt; index <= to; index++) {
      final List<dynamic> lineSize = linesHost.getSize(index, repeatSizeCount);
      final double size = lineSize[0] as double;
      repeatSizeCount = lineSize[1] as int;
      if (size != distances.defaultDistance) {
        final int rangeTo = getRangeToHelper(index, to, repeatSizeCount);
        distances.setRange(index, rangeTo, size);
        index = rangeTo;
      }
    }

    // Also check for hidden rows and reset line sizes for them.
    for (int index = insertAt; index <= to; index++) {
      final bool hide = linesHost.getHidden(index, repeatSizeCount)[0] as bool;
      if (hide) {
        final int rangeTo = getRangeToHelper(index, to, repeatSizeCount);
        distances.setRange(index, rangeTo, 0.0);
        index = rangeTo;
      }
    }
  }
}
