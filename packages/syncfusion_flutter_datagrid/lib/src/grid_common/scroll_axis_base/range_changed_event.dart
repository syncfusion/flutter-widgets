part of datagrid;

/// Provides data for the [ILineSizeHost.LineSizeChanged] event.
class _RangeChangedArgs {
  _RangeChangedArgs();

  /// Initializes a new instance of the RangeChangedArgs class.
  ///
  /// * from - _required_ - The start index.
  /// * to - _required_ - The end index.
  _RangeChangedArgs.fromArgs(int from, int to) {
    _from = from;
    _to = to;
  }

  /// Initializes a new instance of the RangeChangedArgs class.
  ///
  /// * from - _required_ - The start index.
  /// * to - _required_ - The end index.
  /// * oldSize - _required_ - The old size.
  /// * newSize - _required_ - The new size.
  _RangeChangedArgs.fromRangeChangedArgs(
      int from, int to, double oldSize, double newSize) {
    _from = from;
    _to = to;
    _oldSize = oldSize;
    _newSize = newSize;
  }

  int _from = 0;
  int _to = 0;
  double _oldSize = 0.0;
  double _newSize = 0.0;

  /// Gets the start index.
  ///
  /// Returns the start index.
  int get from => _from;

  /// Gets the end index.
  ///
  /// Returns the end index.
  int get to => _to;

  /// Gets the old size.
  ///
  /// Returns the old size.
  double get oldSize => _oldSize;

  /// Gets the new size.
  ///
  /// Returns the new size.
  double get newSize => _newSize;
}

/// Provides data for the [ILineSizeHost.LinesRemoved] event.
class _LinesRemovedArgs {
  _LinesRemovedArgs();

  /// Initializes a new instance of the [LinesRemovedArgs] class.
  ///
  /// * removeAt - _required_ - The index to remove.
  /// * count - _required_ - The count of the lines.
  _LinesRemovedArgs.fromArgs(int removeAt, int count) {
    _removeAt = removeAt;
    _count = count;
  }

  int _removeAt = 0;
  int _count = 0;

  /// Gets the index to remove.
  ///
  /// Returns the index to remove.
  int get removeAt => _removeAt;

  /// Gets the count of items to be removed.
  ///
  /// Returns the count of items to be removed.
  int get count => _count;
}

/// Provides data for the [ILineSizeHost.LinesInserted] event.
class _LinesInsertedArgs {
  _LinesInsertedArgs();

  /// Initializes a new instance of the [_LinesInsertedArgs] class.
  ///
  /// * insertAt - _required_ - The index to insert.
  /// * count - _required_ - The count of the items to be inserted.
  _LinesInsertedArgs.fromArgs(int insertAt, int count) {
    _insertAt = insertAt;
    _count = count;
  }

  int _insertAt = 0;
  int _count = 0;

  /// Gets the index to insert.
  ///
  /// Returns the index to insert.
  int get insertAt => _insertAt;

  /// Gets the count of the items to be inserted.
  ///
  /// Returns the count of the items to be inserted.
  int get count => _count;
}

/// Provides data for the [ILineSizeHost.DefaultLineSizeChanged] event.
class _DefaultLineSizeChangedArgs {
  /// Initializes a new instance of the DefaultLineSizeChangedArgs class.
  _DefaultLineSizeChangedArgs();

  /// Initializes a new instance of the DefaultLineSizeChangedArgs class.
  ///
  /// * oldValue - _required_ - The old line size.
  /// * name - _required_ - newValue The new line size.
  _DefaultLineSizeChangedArgs.fromArgs(double oldValue, double newValue) {
    _oldValue = oldValue;
    _newValue = newValue;
  }

  double _oldValue = 0.0;
  double _newValue = 0.0;

  /// Gets the old line size.
  ///
  /// Returns the old line size.
  double get oldValue => _oldValue;

  /// Gets the new line size.
  ///
  /// Returns the new line size.
  double get newValue => _newValue;
}

/// Provides data for the [ILineSizeHost.LineHiddenChanged] event.
class _HiddenRangeChangedArgs {
  _HiddenRangeChangedArgs();

  /// Initializes a new instance of the [HiddenRangeChangedArgs] class.
  ///
  /// * from - _required_ - The start index of the hidden range.
  /// * to - _required_ - The end index of the hidden range.
  /// * hide - _required_ - hide value
  _HiddenRangeChangedArgs.fromArgs(int from, int to, bool hide) {
    _from = from;
    _to = to;
    _hide = hide;
  }

  int _from = 0;
  int _to = 0;
  bool _hide;

  /// Gets the start index of the hidden range.
  ///
  ///  Returns the start index of the hidden range.
  int get from => _from;

  /// Gets the end index of the hidden range.
  ///
  /// Returns the end index of the hidden range.
  int get to => _to;

  /// Gets a value indicating whether to hide the lines in the given
  /// range or not.
  ///
  /// Returns a boolean value indicating whether to hide the lines
  /// in the given range.
  bool get hide => _hide;
}

/// Defines the various constants for the scroll changed action.
enum _ScrollChangedAction {
  /// - ScrollChangedAction.linesInserted, Specifies that the scroll is
  /// changed as the lines are inserted.
  linesInserted,

  /// - ScrollChangedAction.linesRemoved, Specifies that the scroll is
  /// changed as the lines are removed.
  linesRemoved,

  /// - ScrollChangedAction.footerLineCountChanged, Specifies that the scroll is
  /// changed as the footer line count is changed.
  footerLineCountChanged,

  /// - ScrollChangedAction.defaultLineSizeChanged, Specifies that the scroll is
  /// changed as the default line size is changed.
  defaultLineSizeChanged,

  /// - ScrollChangedAction.lineCountChanged, Specifies that the scroll is
  /// changed as the line count is changed.
  lineCountChanged,

  /// - ScrollChangedAction.hiddenLineChanged, Specifies that the scroll is
  /// changed as the header line is changed.
  hiddenLineChanged,

  /// - ScrollChangedAction.lineResized, Specifies that the scroll is changed
  /// as the lines are resized.
  lineResized,
}

/// Provides data for the `ScrollAxisBase.Changed` event.
class _ScrollChangedArgs {
  _ScrollChangedArgs();

  /// Initializes a new instance of the ScrollChangedArgs class.
  ///
  /// * action - _required_ - The `ScrollChangedAction`.
  _ScrollChangedArgs.fromArgs(_ScrollChangedAction action) {
    _scrollChangedAction = action;
  }

  _ScrollChangedAction _scrollChangedAction;

  /// Gets the scroll changed action.
  ///
  /// Returns the `ScrollChangedAction`.
  _ScrollChangedAction get action => _scrollChangedAction;
}
