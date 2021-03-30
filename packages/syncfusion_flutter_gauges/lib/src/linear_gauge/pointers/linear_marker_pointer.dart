import 'package:flutter/material.dart';

import '../../../gauges.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearGaugePointer] has properties for customizing linear gauge pointers.
abstract class LinearMarkerPointer {
  /// Creates a pointer for linear axis with the default or required properties.
  LinearMarkerPointer(
      {required this.value,
      this.onValueChanged,
      this.enableAnimation = false,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.offset = 0.0,
      this.markerAlignment = LinearMarkerAlignment.center,
      this.position = LinearElementPosition.cross,
      this.onAnimationCompleted});

  /// Specifies the linear axis value to place the pointer.
  ///
  /// Defaults to 0.
  final double value;

  /// Specifies whether to enable animation or not, when the pointer moves.
  ///
  /// Defaults to false.
  final bool enableAnimation;

  /// Specifies the animation duration for the pointer.
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000.
  final int animationDuration;

  /// Specifies the type of the animation for the pointer.
  ///
  /// Defaults to [LinearAnimationType.ease].
  final LinearAnimationType animationType;

  /// Specifies the offset value which represent the gap from the linear axis.
  /// Origin of this property will be relates to [LinearGaugePointer.position].
  ///
  /// Defaults to 0.
  final double offset;

  /// Specifies the annotation position with respect to linear axis.
  ///
  final LinearElementPosition position;

  /// Signature for callbacks that report that an underlying value has changed.
  ///
  final ValueChanged? onValueChanged;

  /// Specifies the marker alignment.
  ///
  /// Defaults to center.
  final LinearMarkerAlignment markerAlignment;

  /// Specifies the animation completed callback.
  ///
  final VoidCallback? onAnimationCompleted;
}
