part of datagrid;

/// Returns the DefaultLineSizeChangedArgs used by the
/// [onDefaultLineSizeChanged] event.
typedef _DefaultLineSizeChangedCallback = void Function(
    _DefaultLineSizeChangedArgs _defaultLineSizeChangedArgs);

/// Returns the LineCountChangedArgs used by the
/// [onLineCountChanged][onHeaderLineCountChanged][onFooderLineCountChanged]
/// event.
typedef _LineCountChangedCallback = void Function();

/// Returns the HiddenRangeChangedArgs used by the [onLineHiddenChanged] event.
typedef _LineHiddenChangedCallback = void Function(
    _HiddenRangeChangedArgs _hiddenRangeChangedArgs);

/// Returns the LinesInsertedArgs used by the [onLinesInserted] event.
typedef _LinesInsertedCallback = void Function(
    _LinesInsertedArgs _linesInsertedArgs);

/// Returns the LinesRemovedArgs used by the [onLinesRemoved] event.
typedef _LinesRemovedCallback = void Function(
    _LinesRemovedArgs _linesRemovedArgs);

/// Returns the RangeChangedArgs used by the [onLineSizeChanged] event.
typedef _LineSizeChangedCallback = void Function(
    _RangeChangedArgs _rangeChangedArgs);

/// A collection that manages lines with varying height and hidden state.
///
/// It has properties for header and footer lines, total line count, default
/// size of a line and also lets you add nested collections.
///
/// _Note:_ This is common for header, footer, total line count and default
/// size of line.
abstract class _LineSizeHostBase {
  /// Occurs when the default line size changed.
  _DefaultLineSizeChangedCallback onDefaultLineSizeChanged;

  /// Occurs when the footer line count was changed.
  _LineCountChangedCallback onFooterLineCountChanged;

  /// Occurs when the header line count was changed.
  _LineCountChangedCallback onHeaderLineCountChanged;

  /// Occurs when a lines size was changed.
  _LineSizeChangedCallback onLineSizeChanged;

  /// Occurs when a lines hidden state changed.
  _LineHiddenChangedCallback onLineHiddenChanged;

  /// Occurs when the line count was changed.
  _LineCountChangedCallback onLineCountChanged;

  /// Occurs when lines were inserted.
  _LinesInsertedCallback onLinesInserted;

  /// Occurs when lines were removed.
  _LinesRemovedCallback onLinesRemoved;

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
  List getHidden(int index, int repeatValueCount);

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
  List getSize(int index, int repeatValueCount);

  /// Initializes the scroll axis.
  ///
  /// * scrollAxis - _required_ - The scroll axis.
  void initializeScrollAxis(_ScrollAxisBase scrollAxis);
}

/// An object that implements the `Distances` property.
mixin _DistancesHostBase {
  /// Gets the distances of the lines.
  ///
  /// Returns the distances of the lines.
  _DistanceCounterCollectionBase get distances;
}

/// An object that implements the `GetDistances` method.
abstract class _NestedDistancesHostBase {
  /// Gets the nested distances, if a line contains a nested lines collection,
  /// otherwise null.
  ///
  /// * line - _required_ - The line at which the distances is to be obtained.
  ///
  /// Returns the nested distances, if a line contains a nested lines
  /// collection, otherwise null.
  _DistanceCounterCollectionBase getDistances(int line);
}
