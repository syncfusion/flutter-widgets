import 'dart:math';

import 'package:flutter/material.dart';

import 'event_args.dart';

/// Returns the valueChangeArgs by used the [onValueChanged] event.
typedef ValueChangedCallback = void Function();

/// Returns the ValueChangingArgs by used the [onValueChanging] event.
typedef ValueChangingCallback = void Function(
    ValueChangingArgs valueChangingArgs);

/// Returns the PropertyChangedArgs by used the [onPropertyChanged] event.
typedef PropertyChangedCallback = void Function(
    PropertyChangedArgs propertyChangedArgs);

/// Defines an interface that provides all properties to configure a scrollbar.
class ScrollBarBase extends ChangeNotifier {
  ///
  ScrollBarBase(
      {required bool enabled,
      required double maximum,
      required double minimum,
      required double largeChange,
      required double smallChange,
      required double value})
      : _enabled = enabled,
        _maximum = maximum,
        _minimum = minimum,
        _largeChange = largeChange,
        _smallChange = smallChange,
        _value = value;

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

/// Provides all properties to configure a scrollbar.
class ScrollInfo extends ScrollBarBase {
  ///Initializes a new instance of the [ScrollInfo] class.
  ScrollInfo()
      : super(
            value: 0,
            minimum: 0,
            maximum: 100,
            smallChange: 1,
            enabled: true,
            largeChange: 10) {
    _proposedLargeChange = 10;
  }

  late double _proposedLargeChange;

  /// Occurs when a property value changes.
  PropertyChangedCallback? onPropertyChangedEvent;

  /// Occurs when the current position of the scroll box on the scroll bar
  /// has changed.
  ValueChangedCallback? onValueChanged;

  /// Occurs when the current position of the scroll box on the scroll bar
  /// is being changed.
  ValueChangingCallback? onValueChanging;

  /// Sets a value to be added to or subtracted from the value of the property
  /// when the scroll box is moved a large distance.
  @override
  set largeChange(double value) {
    _proposedLargeChange = value;
    if (value < 0) {
      value = maximum - minimum;
    }

    if (largeChange != value) {
      super.largeChange = value;
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
      return minimum;
    }
    return max(minimum, min(maximum - largeChange + 1, super.value));
  }

  /// Sets a numeric value that represents the current position of the
  /// scroll box on the scroll bar control.
  @override
  set value(double value) {
    if (this.value != value) {
      final ValueChangingArgs e = ValueChangingArgs(value, this.value);
      if (onValueChanging != null) {
        onValueChanging!(e);
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

        super.value = offset;
      }
    }
  }

  /// Clones this instance.
  ///
  /// Returns the cloned instance.
  ScrollInfo clone() {
    final ScrollInfo sb = ScrollInfo();
    copyTo(sb);
    return sb;
  }

  /// Copies current settings to another object.
  ///
  /// * scrollBar - _required_ - The object to which the settings
  /// is to be copied.
  void copyTo(ScrollInfo scrollBar) {
    scrollBar
      ..value = value
      ..minimum = minimum
      ..maximum = maximum
      ..largeChange = largeChange
      ..smallChange = smallChange
      ..enabled = enabled;
  }

  /// Determines whether the specified `ScrollInfo` is equal
  /// to the current `ScrollInfo`.
  ///
  /// * obj - _required_ - The `ScrollInfo` to compare with
  /// the current `ScrollInfo`.
  ///
  /// Returns `True` if the specified `ScrollInfo` is equal
  /// to the current `ScrollInfo`, otherwise `false`.
  bool equals(ScrollInfo? obj) {
    final ScrollInfo? sb = obj;
    if (sb == null) {
      return true;
    }

    return sb.value == value &&
        sb.minimum == minimum &&
        sb.maximum == maximum &&
        sb.largeChange == largeChange &&
        sb.smallChange == smallChange &&
        sb.enabled == enabled;
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
      final PropertyChangedArgs propertyChangedArgs =
          PropertyChangedArgs(propertyName);
      onPropertyChangedEvent!(propertyChangedArgs);
    }
  }

  /// A `string` that represents the current `object`.
  ///
  /// Returns a `string` that represents the current `object`.
  @override
  String toString() =>
      'ScrollInfo ( Value = $value, Minimum = $minimum, Maximum = $maximum, LargeChange = $largeChange, Enabled = $enabled )';
}
