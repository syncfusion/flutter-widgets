import 'package:flutter/material.dart';

/// This class has the property of the guage text style.
///
/// Provides the options of color, font family, font style, font size, and
/// font-weight to customize the appearance.
@immutable
class GaugeTextStyle {
  /// Creates a gauge text style with default or required properties.
  const GaugeTextStyle(
      {this.color,
      this.fontFamily,
      this.fontStyle,
      this.fontWeight,
      this.fontSize});

  /// To set the color of guage text.
  final Color? color;

  /// To set the font family to guage text.
  ///
  ///Defaults to `Roboto`.
  final String? fontFamily;

  /// To set the font style to guage text.
  final FontStyle? fontStyle;

  /// To set the font weight to gauge text.
  ///
  /// Defaults to FontWeight.normal
  final FontWeight? fontWeight;

  /// To set the font size to gauge text
  ///
  /// Defaults to `12`.
  final double? fontSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeTextStyle &&
        other.color == color &&
        other.fontFamily == fontFamily &&
        other.fontStyle == fontStyle &&
        other.fontWeight == fontWeight &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      color,
      fontFamily,
      fontStyle,
      fontWeight,
      fontSize
    ];
    return Object.hashAll(values);
  }
}
