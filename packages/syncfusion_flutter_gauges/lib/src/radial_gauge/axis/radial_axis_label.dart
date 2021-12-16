import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../radial_gauge/styles/radial_text_style.dart';

/// Holds the axis label information.
class CircularAxisLabel {
  /// Creates the axis label with default or required properties.
  CircularAxisLabel(
      this.labelStyle, this.text, this.index, this.needsRotateLabel);

  /// Style for axis label text.
  late GaugeTextStyle labelStyle;

  /// Holds the size of axis label
  late Size labelSize;

  /// Text to display
  late String text;

  /// Specifies the axis index position
  late num index;

  ///Specifies the value of the labels
  late num value;

  /// Holds the label position
  late Offset position;

  /// Holds the corresponding angle for the label
  late double angle;

  /// Specifies whether to rotate the corresponding labels
  final bool needsRotateLabel;
}
