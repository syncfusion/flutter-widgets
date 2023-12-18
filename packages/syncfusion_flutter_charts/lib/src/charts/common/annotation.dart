import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// This class has the properties of cartesian chart annotation.
///
/// Chart supports annotations that allow you to mark the specific area of
/// interest in the chart area. You can add the custom widgets using this
/// annotation feature as depicted below.
///
/// The x and y values can be specified with axis units or pixel units, and
/// these can be identified by using coordinateUnit property. When the logical
/// pixel is specified, the annotation will be placed to pixel values whereas
/// the point is specified, then the annotation will be placed to series
/// point values.
///
/// Provides the options x, y, coordinateUnit, and widget to customize the
/// cartesian chart annotation.
@immutable
class CartesianChartAnnotation {
  /// Creating an argument constructor of [CartesianChartAnnotation] class.
  const CartesianChartAnnotation({
    required this.widget,
    required this.x,
    required this.y,
    this.coordinateUnit = CoordinateUnit.logicalPixel,
    this.xAxisName,
    this.yAxisName,
    this.region = AnnotationRegion.chart,
    this.clip = ChartClipBehavior.clip,
    this.horizontalAlignment = ChartAlignment.center,
    this.verticalAlignment = ChartAlignment.center,
  });

  /// Considers any widget as annotation.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chart,
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final Widget widget;

  /// Specifies the coordinate units for placing the annotation in either
  /// logicalPixel or point.
  ///
  /// Defaults to `CoordinateUnit.logicalPixel`
  ///
  /// Also refer [CoordinateUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final CoordinateUnit coordinateUnit;

  /// Annotations can be placed with respect to either plotArea or chart.
  ///
  /// Defaults to `AnnotationRegion.chart`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    region: AnnotationRegion.chart,
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final AnnotationRegion region;

  /// Clip or hide the annotation when it exceeds the chart area or plot area
  /// based on [region] provided.
  ///
  /// Defaults to `ChartClipBehavior.clip`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    clip: ChartClipBehavior.hide,
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final ChartClipBehavior clip;

  /// Specifies the x-values as pixel, point or percentage values based on the
  /// coordinateUnit.
  ///
  /// Percentage value refers to the overall width of the chart. i.e. 100% is
  /// equal to the width of the chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic x;

  /// Specifies the y-values as pixel, point or percentage values based on the
  /// coordinateUnit.
  ///
  /// Percentage value refers to the overall height of the chart. i.e. 100% is
  /// equal to the height of the chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic y;

  /// Specifies the x-axis name to the annotation that should be bound.
  ///
  /// Defaults to `‘’`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartesianSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    xAxisName: 'Gold'
  ///                ),
  ///              ],
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60,
  ///                    xAxisName: 'Gold'
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final String? xAxisName;

  /// Specifies the y-axis name to the annotation that should  be bound.
  ///
  /// Defaults to `‘’`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartesianSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    yAxisName: 'Gold'
  ///                ),
  ///              ],
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60,
  ///                    yAxisName: 'Gold'
  ///              ),
  ///        )
  ///    );
  /// }
  /// ```
  final String? yAxisName;

  /// Aligns the annotations horizontally.
  ///
  /// Alignment can be set to `ChartAlignment.near`, `ChartAlignment.far`, or
  /// `ChartAlignment.center`.
  ///
  /// Defaults to `ChartAlignment.center`
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60,
  ///                    horizontalAlignment: ChartAlignment.near
  ///                 )
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final ChartAlignment horizontalAlignment;

  /// Aligns the annotations vertically.
  ///
  /// Alignment can be set to `ChartAlignment.near`, `ChartAlignment.far`, or
  /// `ChartAlignment.center`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    x: 3,
  ///                    y: 60,
  ///                    verticalAlignment: ChartAlignment.near
  ///                 )
  ///             ],
  ///         )
  ///     );
  /// }
  /// ```
  final ChartAlignment verticalAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CartesianChartAnnotation &&
        other.widget == widget &&
        other.coordinateUnit == coordinateUnit &&
        other.region == region &&
        other.clip == clip &&
        other.horizontalAlignment == horizontalAlignment &&
        other.verticalAlignment == verticalAlignment &&
        other.x == x &&
        other.y == y &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      widget,
      coordinateUnit,
      region,
      clip,
      horizontalAlignment,
      verticalAlignment,
      x,
      y,
      xAxisName,
      yAxisName
    ];
    return Object.hashAll(values);
  }
}

/// Customizes the annotation of the circular chart.
///
/// Circular chart allows you to mark the specific area of interest in the
/// chart area. You can add the custom widgets using this annotation feature,
/// It has the properties for customizing the appearance.
///
/// The angle, orientation, height, and width of the inserted annotation can all
/// be customized.
///
/// It provides options for angle, height, width, vertical and horizontal
/// alignment to customize the appearance.
@immutable
class CircularChartAnnotation {
  /// Creating an argument constructor of CircularChartAnnotation class.
  const CircularChartAnnotation({
    this.angle = 0,
    this.radius = '0%',
    required this.widget,
    this.height = '0%',
    this.width = '0%',
    this.horizontalAlignment = ChartAlignment.center,
    this.verticalAlignment = ChartAlignment.center,
  });

  /// Angle to rotate the annotation.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    angle: 40,
  ///                    widget: const Text('Circular'),
  ///               ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final int angle;

  /// Radius for placing the annotation. The value ranges from 0% to 100% and
  /// also if values are
  /// mentioned in pixel then the annotation will moved accordingly.
  ///
  /// For example, if set `50%` means the annotation starting text will be
  /// placed from the `50%`
  /// chart area or we set `50` means the annotation starting text will be
  /// placed from 50 pixels.
  ///
  /// Defaults to `0%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    radius: '10%'
  ///                    widget: const Text('Circular'),
  ///              ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final String radius;

  /// Considers any widget as annotation.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    widget: const Text('Circular'),
  ///              ),
  ///            ],
  ///         )
  ///    );
  /// }
  /// ```
  final Widget widget;

  /// Height of the annotation.
  ///
  /// Defaults to `0%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    height: '10%',
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final String height;

  /// Width of the annotation.
  ///
  /// Defaults to `0%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    width: '10%',
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///            ],
  ///        )
  ///    );
  /// }
  /// ```
  final String width;

  /// Aligns the annotation horizontally.
  ///
  /// Alignment can be set to `ChartAlignment.center`, `ChartAlignment.far`, or
  /// `ChartAlignment.near`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    horizontalAlignment: ChartAlignment.near
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final ChartAlignment horizontalAlignment;

  /// Aligns the annotation vertically.
  ///
  /// Alignment can be set to `ChartAlignment.center`, `ChartAlignment.far`, or
  /// `ChartAlignment.near`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    verticalAlignment: ChartAlignment.near
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///   );
  /// }
  /// ```
  final ChartAlignment verticalAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CircularChartAnnotation &&
        other.widget == widget &&
        other.radius == radius &&
        other.angle == angle &&
        other.horizontalAlignment == horizontalAlignment &&
        other.verticalAlignment == verticalAlignment &&
        other.height == height &&
        other.width == width;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      widget,
      radius,
      angle,
      horizontalAlignment,
      verticalAlignment,
      height,
      width
    ];
    return Object.hashAll(values);
  }
}
