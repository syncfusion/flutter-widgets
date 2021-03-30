part of datagrid;

/// Defines an interface that provides all properties to configure a scrollbar.
class _ScrollBarBase extends ChangeNotifier {
  ///  Gets a value indicating whether the scroll bar is enabled or not.
  ///
  /// Returns a number that represents the current position of the
  /// scroll box on the scroll bar control.
  bool get enabled => _enabled;
  bool _enabled = false;
  set enabled(bool value) {
    if (value == _enabled) {
      return;
    }

    _enabled = value;
  }

  /// Gets the upper limit of values of the scrollable range.
  ///
  /// Returns the upper limit of values of the scrollable range.
  double get maximum => _maximum;
  double _maximum = 0.0;
  set maximum(double value) {
    if (value == _maximum) {
      return;
    }

    _maximum = value;
  }

  /// Gets the lower limit of values of the scrollable range.
  ///
  /// Returns the lower limit of values of the scrollable range.
  double get minimum => _minimum;
  double _minimum = 0.0;
  set minimum(double value) {
    if (value == _minimum) {
      return;
    }

    _minimum = value;
  }

  /// Gets a value to be added to or subtracted from the value of the property
  /// when the scroll box is moved a large distance.
  ///
  /// Returns the value to be added to or subtracted from the value
  /// of the property when the scroll box is moved a large distance.
  double get largeChange => _largeChange;
  double _largeChange = 0.0;
  set largeChange(double value) {
    if (value == _largeChange) {
      return;
    }

    _largeChange = value;
  }

  /// Gets the value to be added to or subtracted from the value of the
  /// property when the scroll box is moved a small distance.
  ///
  /// Returns the value to be added to or subtracted from the value
  /// of the property when the scroll box is moved a small distance.
  double get smallChange => _smallChange;
  double _smallChange = 0.0;
  set smallChange(double value) {
    if (value == _smallChange) {
      return;
    }

    _smallChange = value;
  }

  /// Gets a numeric value that represents the current position of the
  /// scroll box on the scroll bar control.
  ///
  /// Returns a numeric value that represents the current position of
  /// the scroll box on the scroll
  /// bar control.
  double get value => _value;
  double _value = 0.0;
  set value(double value) {
    if (value == _value) {
      return;
    }

    _value = value;
  }
}
