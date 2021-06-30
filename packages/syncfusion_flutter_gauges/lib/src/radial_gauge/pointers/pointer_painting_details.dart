import 'package:flutter/material.dart';

/// Details for the drawPointer method, such as the location of the pointer,
/// the angle, and the radius needed to draw the pointer.
@immutable
class PointerPaintingDetails {
  /// Creates the details which are required to paint the pointer
  const PointerPaintingDetails(
      {required this.startOffset,
      required this.endOffset,
      required this.pointerAngle,
      required this.axisRadius,
      required this.axisCenter});

  /// Specifies the starting position of the pointer in the logical pixels.
  final Offset startOffset;

  /// Specifies the ending position of the pointer in the logical pixels.
  final Offset endOffset;

  /// Specifies the angle of the current pointer value.
  final double pointerAngle;

  /// Specifies the axis radius in logical pixels.
  final double axisRadius;

  /// Specifies the center position of the axis in the logical pixels.
  final Offset axisCenter;
}
