import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../annotation/gauge_annotation.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../range/gauge_range.dart';
import '../utils/enum.dart';
import 'gauge_axis.dart';

/// The [RadialAxis] is a circular arc in which a set of values are
/// displayed along a linear or custom scale
/// based on the design requirements.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            )]
///        ));
///}
/// ```
class RadialAxis extends GaugeAxis {
  /// Create [RadialAxis] with the default or required scale range and
  /// customized axis properties.
  ///
  /// The arguments [minimum], [maximum], [startAngle], [endAngle],
  /// [radiusFactor], [centerX], [centerY],
  /// [tickOffset] and [labelOffset] must not be null.
  /// Additionally [centerX], [centerY] must be non-negative
  /// and [maximum] must be creater than [minimum].
  RadialAxis(
      {this.startAngle = 130,
      this.endAngle = 50,
      this.radiusFactor = 0.95,
      this.centerX = 0.5,
      this.onLabelCreated,
      this.onAxisTapped,
      this.canRotateLabels = false,
      this.centerY = 0.5,
      this.showFirstLabel = true,
      this.showLastLabel = false,
      this.canScaleToFit = false,
      List<GaugeRange>? ranges,
      List<GaugePointer>? pointers,
      List<GaugeAnnotation>? annotations,
      GaugeTextStyle? axisLabelStyle,
      AxisLineStyle? axisLineStyle,
      MajorTickStyle? majorTickStyle,
      MinorTickStyle? minorTickStyle,
      this.backgroundImage,
      GaugeAxisRendererFactory? onCreateAxisRenderer,
      double minimum = 0,
      double maximum = 100,
      double? interval,
      double minorTicksPerInterval = 1,
      bool showLabels = true,
      bool showAxisLine = true,
      bool showTicks = true,
      double tickOffset = 0,
      double labelOffset = 15,
      bool isInversed = false,
      GaugeSizeUnit offsetUnit = GaugeSizeUnit.logicalPixel,
      int maximumLabels = 3,
      bool useRangeColorForAxis = false,
      String? labelFormat,
      NumberFormat? numberFormat,
      ElementsPosition ticksPosition = ElementsPosition.inside,
      ElementsPosition labelsPosition = ElementsPosition.inside})
      : assert(
            radiusFactor >= 0, 'Radius factor must be a non-negative value.'),
        assert(centerX >= 0, 'Center X must be a non-negative value.'),
        assert(centerY >= 0, 'Center Y must be a non-negative value.'),
        assert(minimum < maximum, 'Maximum should be greater than minimum.'),
        super(
            ranges: ranges,
            annotations: annotations,
            pointers: pointers,
            onCreateAxisRenderer: onCreateAxisRenderer,
            minimum: minimum,
            maximum: maximum,
            interval: interval,
            minorTicksPerInterval: minorTicksPerInterval,
            showLabels: showLabels,
            showAxisLine: showAxisLine,
            showTicks: showTicks,
            tickOffset: tickOffset,
            labelOffset: labelOffset,
            isInversed: isInversed,
            maximumLabels: maximumLabels,
            useRangeColorForAxis: useRangeColorForAxis,
            labelFormat: labelFormat,
            offsetUnit: offsetUnit,
            numberFormat: numberFormat,
            ticksPosition: ticksPosition,
            labelsPosition: labelsPosition,
            axisLabelStyle: axisLabelStyle ??
                GaugeTextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Segoe UI',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal),
            axisLineStyle: axisLineStyle ??
                AxisLineStyle(
                  thickness: 10,
                ),
            majorTickStyle: majorTickStyle ?? MajorTickStyle(),
            minorTickStyle: minorTickStyle ?? MinorTickStyle());

  /// Specifies the start angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 130
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           startAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startAngle;

  /// Specifies the end angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 50
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           endAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double endAngle;

  /// The size of the axis, expressed as the radius (half the diameter)
  /// in factor.
  ///
  /// The [radiusFactor] must be between 0 and 1. Axis radius is determined
  /// by multiplying this factor
  /// value to the minimum width or height of the widget.
  ///
  /// Defaults to 0.95
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           radiusFactor: 0.8,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double radiusFactor;

  /// Left location of center axis.
  ///
  /// The [centerX] value must be between 0 to 1. Change the left position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerX: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerX;

  /// Top location of center axis.
  ///
  /// The [centerY] value must be between 0 to 1. Change the top position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerY: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerY;

  /// Whether to show the first label of the axis.
  ///
  /// When [startAngle] and [endAngle] are the same, the first and
  /// last labels are intersected.
  /// To prevent this, enable this property to be false,
  /// if [showLastLabel] is true.
  ///
  /// Defaults to true
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showFirstLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showFirstLabel;

  /// Whether to show the last label of the axis.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showLastLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showLastLabel;

  /// Callback that gets triggered when an axis label is created.
  ///
  /// The [RadialAxis] passes the [AxisLabelCreatedArgs] to the callback
  /// used to change text value and rotate the
  /// text based on angle.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelCreated: _handleAxisLabelCreated,
  ///            )]
  ///        ));
  ///}
  ///
  ///   void _handleAxisLabelCreated(AxisLabelCreatedArgs args){
  //    if(args.text == '100'){
  //      args.text = 'Completed';
  //      args.canRotate = true;
  //    }
  //  }
  /// ```
  final ValueChanged<AxisLabelCreatedArgs>? onLabelCreated;

  ///  Callback, which is triggered by tapping an axis.
  ///
  /// [RadialAxis] returns the tapped axis value to the callback.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           onAxisTapped: (double value) {
  ///             print('Axis tapped on $value');
  ///            })]
  ///        ));
  ///}
  ///
  /// ```
  final ValueChanged<double>? onAxisTapped;

  /// whether to rotate the labels based on angle.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canRotateLabels: true,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool canRotateLabels;

  /// The background image of the [RadialAxis]. Changing the image
  /// will set the background to the new image.
  ///
  /// The [backgroundImage] applied for the [RadialAxis] boundary.
  ///
  /// This property is a type of [ImageProvider]. Therefore, you can set
  /// the following types of image on this.
  ///
  /// * [AssetImage]
  /// * [NetworkImage]
  /// * [FileImage]
  /// * [MemoryImage]
  ///
  /// Defaults to null.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           backgroundImage: AssetImage('images/dark_background.png')
  ///            )]
  ///        ));
  ///}
  ///```
  final ImageProvider? backgroundImage;

  /// Adjust the half or quarter gauge to fit the axis boundary.
  ///
  /// if [canScaleToFit] true, the center and radius position of the axis
  /// will be modified on the basis of the angle value.
  ///
  /// Defaults to false
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canScaleToFit : true
  ///            )]
  ///        ));
  ///}
  ///```
  final bool canScaleToFit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RadialAxis &&
        other.startAngle == startAngle &&
        other.endAngle == endAngle &&
        other.minimum == minimum &&
        other.maximum == maximum &&
        other.axisLineStyle == axisLineStyle &&
        other.labelOffset == labelOffset &&
        other.tickOffset == tickOffset &&
        other.showLabels == showLabels &&
        other.showTicks == showTicks &&
        other.showAxisLine == showAxisLine &&
        other.showLastLabel == showLastLabel &&
        other.showFirstLabel == showFirstLabel &&
        other.interval == interval &&
        other.minorTicksPerInterval == minorTicksPerInterval &&
        other.maximumLabels == maximumLabels &&
        other.isInversed == isInversed &&
        other.labelFormat == labelFormat &&
        other.numberFormat == numberFormat &&
        other.radiusFactor == radiusFactor &&
        other.ticksPosition == ticksPosition &&
        other.labelsPosition == labelsPosition &&
        other.onLabelCreated == onLabelCreated &&
        other.centerX == centerX &&
        other.centerY == centerY &&
        other.canScaleToFit == canScaleToFit &&
        other.onAxisTapped == onAxisTapped &&
        other.canRotateLabels == canRotateLabels &&
        other.majorTickStyle == majorTickStyle &&
        other.minorTickStyle == minorTickStyle &&
        other.useRangeColorForAxis == useRangeColorForAxis &&
        other.axisLabelStyle == axisLabelStyle &&
        other.onCreateAxisRenderer == other.onCreateAxisRenderer &&
        other.backgroundImage == backgroundImage;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      startAngle,
      endAngle,
      hashList(ranges),
      hashList(pointers),
      hashList(annotations),
      minimum,
      maximum,
      axisLineStyle,
      labelOffset,
      tickOffset,
      offsetUnit,
      showLabels,
      showTicks,
      showAxisLine,
      showLastLabel,
      showFirstLabel,
      interval,
      minorTicksPerInterval,
      maximumLabels,
      isInversed,
      labelFormat,
      numberFormat,
      radiusFactor,
      ticksPosition,
      labelsPosition,
      onLabelCreated,
      centerX,
      centerY,
      canScaleToFit,
      onAxisTapped,
      canRotateLabels,
      majorTickStyle,
      minorTickStyle,
      useRangeColorForAxis,
      axisLabelStyle,
      backgroundImage,
      onCreateAxisRenderer
    ];
    return hashList(values);
  }
}
