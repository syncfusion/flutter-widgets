part of gauges;

/// [GaugePointer] has properties for customizing gauge pointers.
abstract class GaugePointer {
  /// Create a pointer with the default or required properties.
  GaugePointer(
      {this.value = 0,
      this.enableDragging = false,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChanging,
      this.onValueChangeEnd,
      this.enableAnimation = false,
      this.animationType = AnimationType.ease,
      this.animationDuration = 1000});

  /// Specifies the value to the pointer.
  ///
  /// Changing the pointer value will cause the pointer to animate to the
  /// new value.
  ///
  /// Defaults to 0
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double value;

  /// Whether to allow the pointer dragging.
  ///
  /// It provides an option to drag a pointer from one value to another.
  /// It is used to change the value at run time.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableDragging: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool enableDragging;

  /// Called during a drag when the user is selecting a new value for the
  /// pointer by dragging.
  ///
  /// The pointer passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the pointer
  /// with the new value.
  ///
  /// The callback provided to onValueChanged should update the state
  /// of the parent [StatefulWidget] using the [State.setState] method,
  /// so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: _currentValue,
  ///            onValueChanged: (double newValue) {
  ///              setState(() {
  ///                _currentValue = newValue;
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double> onValueChanged;

  /// Called when the user starts selecting a new value of pointer by dragging.
  ///
  /// This callback shouldn't be used to update the pointer value
  /// (use onValueChanged for that), but rather to be notified  when the user
  /// has started selecting a new value by starting a drag.

  /// The value passed will be the last value that the pointer had before
  /// the change began.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: 50,
  ///            onValueChangeStart: (double startValue) {
  ///              setState(() {
  ///                print('Started change at $startValue');
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double> onValueChangeStart;

  /// Called when the user is done selecting a new value of the pointer
  /// by dragging.
  ///
  /// This callback shouldn't be used to update the pointer
  /// value (use onValueChanged for that),
  /// but rather to know when the user has completed selecting a new value
  /// by ending a drag.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: 50,
  ///            onValueChangeStart: (double newValue) {
  ///              setState(() {
  ///                print('Ended change on $newValue');
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double> onValueChangeEnd;

  /// Called during a drag when the user is selecting before a new value
  /// for the pointer by dragging.
  ///
  /// This callback shouldn't be used to update the pointer value
  /// (use onValueChanged for that), but rather to know the new value before
  /// when the user has completed selecting a new value by drag.
  ///
  /// To restrict the update of current drag pointer value,
  /// set [ValueChangingArgs.cancel] is true.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///       child: SfRadialGauge(axes: <RadialAxis>[
  ///     RadialAxis(
  ///       pointers: <GaugePointer>[
  ///         MarkerPointer(
  ///             value: 50,
  ///             onValueChanging: (ValueChangingArgs args) {
  ///               setState(() {
  ///                 if (args.value > 10) {
  ///                   args.cancel = false;
  ///                 }
  ///               });
  ///             })
  ///       ],
  ///     )
  ///   ]));
  /// }
  /// ```
  final ValueChanged<ValueChangingArgs> onValueChanging;

  /// Whether to enable the pointer animation.
  ///
  /// Set [enableAnimation] is true, the pointer value will cause the pointer
  /// to animate to the new value.
  /// The animation duration is specified by [animationDuration].
  ///
  /// Defaults to false
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableAnimation: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool enableAnimation;

  /// Specifies the duration of the pointer animation.
  ///
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double animationDuration;

  /// Specifies the different type of animation for pointer.
  ///
  /// Different type of animation provides visually appealing way
  /// when the pointer moves from one value to another.
  ///
  /// Defaults to [AnimationType.linear]
  ///
  /// Also refer [AnimationType]
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             animationType: AnimationType.ease
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  ///```
  final AnimationType animationType;
}

/// This class has the methods for customizing the default gauge axis
abstract class _GaugePointerRenderer {
  _GaugePointerRenderer() {
    _needsRepaintPointer = true;
    _isDragStarted = false;
    _animationEndValue = 0;
  }

  /// Holds the corresponding  gauge pointer
  GaugePointer _gaugePointer;

  ///Holds the correponding axis renderer
  RadialAxisRenderer _axisRenderer;

  /// Specifies the axis for this pointer
  RadialAxis _axis;

  /// Specifies whether to repaint the marker
  bool _needsRepaintPointer;

  /// Specifies the current value of the point
  double _currentValue;

  /// Specifies the pointer rect
  Rect _pointerRect;

  /// Specifies the value whether the pointer is dragged
  bool _isDragStarted;

  /// Holds the end value of pointer animation
  double _animationEndValue;

  /// Holds the animation start value;
  double _animationStartValue;

  /// Holds the value whether to animate the pointer
  bool _needsAnimate;

  /// Method to calculates the pointer position
  void _calculatePosition();

  /// Method to update the drag value
  void _updateDragValue(
      double x, double y, _RenderingDetails animationDetails) {
    final double actualCenterX = _axisRenderer._axisSize.width * _axis.centerX;
    final double actualCenterY = _axisRenderer._axisSize.height * _axis.centerY;
    double angle =
        math.atan2(y - actualCenterY, x - actualCenterX) * (180 / math.pi) +
            360;
    final double endAngle = _axis.startAngle + _axisRenderer._sweepAngle;
    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > endAngle) {
      angle %= 360;
    }

    if (angle >= _axis.startAngle && angle <= endAngle) {
      double dragValue = 0;

      /// The current pointer value is calculated from the angle
      if (!_axis.isInversed) {
        dragValue = _axis.minimum +
            (angle - _axis.startAngle) *
                ((_axis.maximum - _axis.minimum) / _axisRenderer._sweepAngle);
      } else {
        dragValue = _axis.maximum -
            (angle - _axis.startAngle) *
                ((_axis.maximum - _axis.minimum) / _axisRenderer._sweepAngle);
      }

      if (this is RangePointer) {
        final num calculatedInterval = _axisRenderer._calculateAxisInterval(3);
        // Restricts the dragging of range pointer from the minimum value
        // of axis
        if (dragValue < _axis.minimum + calculatedInterval / 2) {
          return;
        }
      }

      _setCurrentPointerValue(dragValue, animationDetails);
    }
  }

  /// Method to set the current pointer value
  void _setCurrentPointerValue(
      double dragValue, _RenderingDetails animationDetails) {
    final double actualValue =
        _getMinMax(dragValue, _axis.minimum, _axis.maximum);
    const int maximumLabel = 3;
    final int niceInterval =
        _axisRenderer._calculateAxisInterval(maximumLabel).toInt();

    // Restricts the dragging of pointer once the maximum value of axis
    // is reached
    if (_axisRenderer._sweepAngle != 360 &&
        ((actualValue.round() <= niceInterval &&
                _currentValue >= _axis.maximum - niceInterval) ||
            (actualValue.round() >= _axis.maximum - niceInterval &&
                _currentValue <= niceInterval))) {
      _isDragStarted = false;
      return;
    }

    if (_gaugePointer.onValueChanging != null) {
      final ValueChangingArgs args = ValueChangingArgs()..value = actualValue;
      _gaugePointer.onValueChanging(args);
      if (args.cancel != null && args.cancel) {
        return;
      }
    }

    _currentValue = actualValue;
    _calculatePosition();
    _createPointerValueChangedArgs();
    animationDetails.pointerRepaintNotifier.value++;
  }

  /// Method to fire the on value change end event
  void _createPointerValueChangeEndArgs() {
    if (_gaugePointer.onValueChangeEnd != null) {
      _gaugePointer.onValueChangeEnd(_currentValue);
    }
  }

  /// Method to fire the on value changed event
  void _createPointerValueChangedArgs() {
    if (_gaugePointer.onValueChanged != null) {
      _gaugePointer.onValueChanged(_currentValue);
    }
  }

  /// Method to fire the on value change start event
  void _createPointerValueChangeStartArgs() {
    if (_gaugePointer.onValueChangeStart != null) {
      _gaugePointer.onValueChangeStart(_currentValue);
    }
  }

  /// Specifies whether the pointer animation is enabled
  bool _getIsPointerAnimationEnabled() {
    return _gaugePointer.enableAnimation &&
        _gaugePointer.animationDuration > 0 &&
        _needsAnimate != null &&
        _needsAnimate;
  }
}
