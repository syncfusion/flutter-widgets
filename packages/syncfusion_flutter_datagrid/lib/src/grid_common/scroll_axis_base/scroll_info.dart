part of datagrid;

/// Returns the valueChangeArgs by used the [onValueChanged] event.
typedef _ValueChangedCallback = void Function();

/// Returns the ValueChangingArgs by used the [onValueChanging] event.
typedef _ValueChangingCallback = void Function(
    _ValueChangingArgs valueChangingArgs);

/// Returns the PropertyChangedArgs by used the [onPropertyChanged] event.
typedef _PropertyChangedCallback = void Function(
    _PropertyChangedArgs propertyChangedArgs);

/// Provides all properties to configure a scrollbar.
class _ScrollInfo extends _ScrollBarBase {
  ///Initializes a new instance of the [_ScrollInfo] class.
  _ScrollInfo() {
    _value = 0;
    _minimum = 0;
    _maximum = 100;
    _largeChange = 10;
    _smallChange = 1;
    _proposedLargeChange = 10;
    _enabled = true;
  }

  double _proposedLargeChange;
  List list;

  /// Occurs when a property value changes.
  _PropertyChangedCallback onPropertyChangedEvent;

  /// Occurs when the current position of the scroll box on the scroll bar
  /// has changed.
  _ValueChangedCallback onValueChanged;

  /// Occurs when the current position of the scroll box on the scroll bar
  /// is being changed.
  _ValueChangingCallback onValueChanging;

  /// Gets a value to be added to or subtracted from the value of the property
  /// when the scroll box is moved a large distance.
  ///
  /// Returns a value to be added to or subtracted from the value of the
  /// property when the scroll box is moved a large distance.
  @override
  double get largeChange => _largeChange;

  /// Sets a value to be added to or subtracted from the value of the property
  /// when the scroll box is moved a large distance.
  @override
  set largeChange(double value) {
    _proposedLargeChange = value;
    if (value < 0) {
      value = maximum - minimum;
    }

    if (_largeChange != value) {
      _largeChange = value;
    }
  }

  /// Gets a numeric value that represents the current position of the
  /// scroll box on the scroll bar control.
  ///
  /// Returns a numeric value that represents the current position of the
  /// scroll box on the scroll bar control.
  @override
  double get value {
    if (_proposedLargeChange < 0) {
      return _minimum;
    }
    return max(_minimum, min(_maximum - _largeChange + 1, _value));
  }

  /// Sets a numeric value that represents the current position of the
  /// scroll box on the scroll bar control.
  @override
  set value(double value) {
    if (this.value != value) {
      final e = _ValueChangingArgs(value, this.value);
      if (onValueChanging != null) {
        onValueChanging(e);
      }

      if (!e.cancel) {
        double offset = e.newValue;

        if (offset < minimum || largeChange >= maximum - minimum) {
          offset = minimum;
        } else {
          if (offset + largeChange > maximum) {
            offset = max(minimum, maximum - largeChange);
          }
        }

        _value = offset;
      }
    }
  }

  /// Clones this instance.
  ///
  /// Returns the cloned instance.
  _ScrollInfo clone() {
    final sb = _ScrollInfo();
    copyTo(sb);
    return sb;
  }

  /// Copies current settings to another object.
  ///
  /// * scrollBar - _required_ - The object to which the settings
  /// is to be copied.
  void copyTo(_ScrollInfo scrollBar) {
    scrollBar
      ..value = _value
      ..minimum = _minimum
      ..maximum = _maximum
      ..largeChange = _largeChange
      ..smallChange = _smallChange
      ..enabled = _enabled;
  }

  /// Determines whether the specified `ScrollInfo` is equal
  /// to the current `ScrollInfo`.
  ///
  /// * obj - _required_ - The `ScrollInfo` to compare with
  /// the current `ScrollInfo`.
  ///
  /// Returns `True` if the specified `ScrollInfo` is equal
  /// to the current `ScrollInfo`, otherwise `false`.
  bool equals(Object obj) {
    final _ScrollInfo sb = obj;
    if (sb == null && this == null) {
      return true;
    } else if (this == null || sb == null) {
      return false;
    }

    return sb.value == _value &&
        sb.minimum == _minimum &&
        sb.maximum == _maximum &&
        sb.largeChange == _largeChange &&
        sb.smallChange == _smallChange &&
        sb.enabled == _enabled;
  }

  /// Serves as a hash function for a particular type.
  ///
  /// returns a hash code for the current `ScrollInfo`.
  int getHashCode() => value.hashCode;

  /// Called when a property is changed and raises the [PropertyChanged] event.
  ///
  /// * propertyName - _required_ - Name of the property.
  void onPropertyChanged(String propertyName) {
    if (onPropertyChangedEvent != null) {
      final propertyChangedArgs = _PropertyChangedArgs(propertyName);
      onPropertyChangedEvent(propertyChangedArgs);
    }
  }

  /// A `string` that represents the current `object`.
  ///
  /// Returns a `string` that represents the current `object`.
  @override
  String toString() =>
      'ScrollInfo ( Value = $value, Minimum = $minimum, Maximum = $maximum, LargeChange = $largeChange, Enabled = $enabled )';
}

/// Provides data for the `ScrollInfo.ValueChanging` event.
class _ValueChangingArgs {
  /// Initializes a new instance of the ValueChangingArgs class.
  ///
  /// * newValue - _required_ - The new value.
  /// * oldValue - _required_ - The old value.
  _ValueChangingArgs(double newValue, double oldValue) {
    _newValue = newValue;
    _oldValue = oldValue;
  }

  double _newValue = 0.0;
  double _oldValue = 0.0;

  /// Gets a value indicating whether to cancel the value change in scroll bar.
  ///
  /// Returns a boolean value indicating whether to cancel
  /// the value change in scroll bar.
  bool get cancel => _cancel;
  bool _cancel = false;

  /// Sets a value indicating whether to cancel the value change in scroll bar.
  set cancel(bool value) {
    if (value == _cancel) {
      return;
    }

    _cancel = value;
  }

  /// Gets the new value.
  ///
  /// Returns the new value.
  double get newValue => _newValue;

  /// Gets the old value.
  ///
  /// Returns the old value.
  double get oldValue => _oldValue;
}

class _PropertyChangedArgs {
  ///  Occurs when name of the property was changed.
  _PropertyChangedArgs(String propertyName) {
    _propertyName = propertyName;
  }

  /// Gets the name of the property that changed.
  ///
  /// Returns the property name.
  String get propertyName => _propertyName;
  String _propertyName;
}
