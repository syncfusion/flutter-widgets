part of datagrid;

/// A collection that manages lines with varying height and hidden state.
///
/// It has properties for header and footer lines, total line count, default
/// size of a line and also lets you add nested collections. Methods
/// are provided for changing the values and getting the total extent.
///
/// _Note:_ This is common for header, footer, total line count and default
/// size of line.
abstract class _EditableLineSizeHostBase extends _LineSizeHostBase {
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
  _EditableLineSizeHostBase createMoveLines();

  /// Gets the nested lines at the given index.
  ///
  /// * index - _required_ - The index at which the nested lines is to
  /// be obtained.
  ///
  /// Returns the `IEditableLineSizeHost` representing the nested lines.
  _EditableLineSizeHostBase? getNestedLines(int index);

  /// Insert the given number of lines at the given index.
  ///
  /// * insertAtLine - _required_ - The index of the first line to insert.
  /// * count - _required_ - The count of the lines to be inserted.
  /// * moveLines - _required_ - A container with saved state from a preceding
  /// `RemoveLines` call when lines should be moved. When it is null,
  /// empty lines with default size are inserted.
  void insertLines(
      int insertAtLine, int count, _EditableLineSizeHostBase? moveLines);

  /// Removes a number of lines at the given index.
  ///
  /// * removeAtLine - _required_ - The index of the first line to be removed.
  /// * count - _required_ - The count of the lines to be removed.
  /// * moveLines - _required_ - A container to save state for a subsequent
  /// `InsertLines` call when lines should be moved.
  void removeLines(
      int removeAtLine, int count, _EditableLineSizeHostBase? moveLines);

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
  void setNestedLines(int index, _EditableLineSizeHostBase nestedLines);

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
abstract class _PaddedEditableLineSizeHostBase
    extends _EditableLineSizeHostBase {
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
