import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/enum.dart';

/// [RadialAxis] allows to add widgets such as text and image as
/// an annotation to a specific point of interest in the radial gauge.
///
/// [GaugeAnnotation] provides options to add any image, text or other widget
/// over a gauge widget with respect to [angle] or [axisValue].
/// Display the current progress or pointer value inside the gauge using a text
/// widget annotation.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            annotations: <GaugeAnnotation>[
///            GaugeAnnotation(widget: Text('Annotation'))
///            ]
///            )]
///        ));
///}
/// ```
class GaugeAnnotation {
  /// Create an [GaugeAnnotation] with the required properties.
  ///
  /// The arguments [positionFactor] must not be null and [positionFactor] must
  /// be non-negative.
  GaugeAnnotation(
      {required this.widget,
      this.axisValue,
      this.horizontalAlignment = GaugeAlignment.center,
      this.angle,
      this.verticalAlignment = GaugeAlignment.center,
      this.positionFactor = 0})
      : assert(
            positionFactor >= 0, 'Position factor must be greater than zero.');

  /// Specifies the annotation widget.
  ///
  /// Applied widget added over a gauge with respect to [angle] or [axisValue].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'))])]
  ///        ));
  ///}
  /// ```
  final Widget widget;

  /// Specifies the axis value for positioning annotation.
  ///
  /// The direction of placing annotation is determined by the [axisValue],
  /// if the [angle] is not specified.
  /// The distance is calculated by [positionFactor].
  /// The annotation is positioned on the basis of the calculated
  /// direction and distance.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'), axisValue: 20)])]
  ///        ));
  ///}
  /// ```
  final double? axisValue;

  /// How the annotation should be aligned horizontally in the respective
  /// position.
  ///
  /// * [GaugeAlignment.center] aligns the annotation widget to center.
  /// * [GaugeAlignment.near] aligns the annotation widget to near.
  /// * [GaugeAlignment.far] aligns the annotation widget to far.
  ///
  /// Defaults to `GaugeAlignment.center`.
  ///
  /// Also refer [GaugeAlignment]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'),
  ///            horizontalAlignment: GaugeAlignment.near)])]
  ///        ));
  ///}
  /// ```
  final GaugeAlignment horizontalAlignment;

  /// How the annotation should be aligned vertically in the
  /// respective position.
  ///
  /// * [GaugeAlignment.center] aligns the annotation widget to center.
  /// * [GaugeAlignment.near] aligns the annotation widget to near.
  /// * [GaugeAlignment.far] aligns the annotation widget to far.
  ///
  /// Defaults to `GaugeAlignment.center`.
  ///
  /// Also refer [GaugeAlignment]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'),
  ///            verticalAlignment: GaugeAlignment.far)])]
  ///        ));
  ///}
  /// ```
  final GaugeAlignment verticalAlignment;

  /// Specifies the position of annotation in radius factor.
  ///
  /// [positionFactor] value of 0 is starting from the center and
  /// 1 is ending at the edge of the radius.
  ///
  /// [positionFactor] must be between 0 to 1.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'),
  ///            positionFactor: 0.5)])]
  ///        ));
  ///}
  ///```
  final double positionFactor;

  /// Specifies the angle for positioning the annotation
  ///
  /// The direction of placing annotation is determined by the [angle],
  /// if the [axisValue] is not specified. The distance is calculated
  /// by [positionFactor]. The annotation is positioned on the basis
  /// of the calculated direction and distance.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'), angle: 190)])]
  ///        ));
  ///}
  /// ```
  final double? angle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeAnnotation &&
        other.axisValue == axisValue &&
        other.horizontalAlignment == horizontalAlignment &&
        other.angle == angle &&
        other.verticalAlignment == verticalAlignment &&
        other.positionFactor == positionFactor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      widget,
      axisValue,
      horizontalAlignment,
      angle,
      verticalAlignment,
      positionFactor
    ];
    return hashList(values);
  }
}
