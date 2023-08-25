import 'package:flutter/material.dart';

///This class represents the linear axis label.
@immutable
class LinearAxisLabel {
  ///Creates a linear axis label.
  const LinearAxisLabel({required this.text, required this.value});

  /// An axis value as a text
  ///
  /// Defaults to [String.isEmpty].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// onGenerateLabels: () {
  /// return <LinearAxisLabel>[
  /// LinearAxisLabel(text: 'Start', value: 0),
  /// LinearAxisLabel(text: 'End', value: 100),];
  /// })
  /// ```
  ///
  final String text;

  /// The position of an axis value to get a string.
  ///
  /// Defaults to 0.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// onGenerateLabels: () {
  /// return <LinearAxisLabel>[
  /// LinearAxisLabel(text: 'R', value: 0),
  /// LinearAxisLabel(text: 'M', value: 10),
  /// LinearAxisLabel(text: 'L', value: 20),];
  /// })
  /// ```
  ///
  final double value;

  @override
  bool operator ==(Object other) {
    late LinearAxisLabel otherStyle;

    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is LinearAxisLabel) {
      otherStyle = other;
    }

    return otherStyle.text == text && otherStyle.value == value;
  }

  @override
  int get hashCode {
    return Object.hash(text, value);
  }
}
