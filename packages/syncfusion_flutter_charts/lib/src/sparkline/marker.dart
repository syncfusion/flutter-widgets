import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'utils/enum.dart';

/// Represents the marker settings of spark chart
class SparkChartMarker {
  /// Creates the marker settings for spark chart
  SparkChartMarker(
      {this.displayMode = SparkChartMarkerDisplayMode.none,
      this.borderColor,
      this.borderWidth = 2,
      this.color,
      this.size = 5,
      this.shape = SparkChartMarkerShape.circle});

  /// Toggles the visibility of the marker.
  final SparkChartMarkerDisplayMode displayMode;

  /// Represents the border color of the marker.
  final Color borderColor;

  /// Represents the border width of the marker
  final double borderWidth;

  /// Represents the color of the marker
  final Color color;

  /// Represents the size of the marker
  final double size;

  /// Represents the shape of the marker
  final SparkChartMarkerShape shape;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SparkChartMarker &&
        other.displayMode == displayMode &&
        other.shape == shape &&
        other.color == color &&
        other.size == size &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      displayMode,
      shape,
      color,
      size,
      borderColor,
      borderWidth,
    ];
    return hashList(values);
  }
}
