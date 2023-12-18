import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// Render plot band.
///
/// Plot bands are also known as strip lines, which are used to shade the
/// different ranges in plot area with different colors to improve the
/// readability of the chart.
///
/// Plot bands are drawn based on the
/// axis, you have to add plot bands using the plotBands property of the
/// respective axis. You can also add multiple plot bands to an axis.
///
/// Provides the property of visible, opacity, start, end, color, border color,
/// and border width to customize the appearance.
@immutable
class PlotBand {
  /// Creating an argument constructor of PlotBand class.
  const PlotBand({
    this.isVisible = true,
    this.start,
    this.end,
    this.associatedAxisStart,
    this.associatedAxisEnd,
    this.color = Colors.grey,
    this.gradient,
    this.opacity = 1.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 2,
    this.dashArray = const <double>[0, 0],
    this.text,
    this.textStyle,
    this.textAngle,
    this.verticalTextPadding,
    this.horizontalTextPadding,
    this.verticalTextAlignment = TextAnchor.middle,
    this.horizontalTextAlignment = TextAnchor.middle,
    this.isRepeatable = false,
    this.repeatEvery = 1,
    this.repeatUntil,
    this.size,
    this.sizeType = DateTimeIntervalType.auto,
    this.shouldRenderAboveSeries = false,
  });

  /// Toggles the visibility of the plot band.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final bool isVisible;

  /// Specifies the start value of plot band.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                     start: 1,
  ///                     end: 5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic start;

  /// Specifies the end value of plot band.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                     start: 1,
  ///                     end: 5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic end;

  /// Text to be displayed in the plot band segment.
  ///
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    text:'Winter'
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final String? text;

  /// Customizes the text style of plot band.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    textStyle: const TextStyle(color:Colors.red)
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Color of the plot band.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    color: Colors.red
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final Color color;

  /// Color of the plot band border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    borderColor: Colors.red
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final Color borderColor;

  /// Width of the plot band border.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    borderWidth: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final double borderWidth;

  /// Opacity of the plot band. The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    opacity: 0.5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final double opacity;

  /// Specifies the plot band need to be repeated in specified interval.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    isRepeatable: true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final bool isRepeatable;

  /// Interval of the plot band need to be repeated.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    repeatEvery: 200
  ///                )
  ///              ]
  ///           )
  ///        )
  ///     );
  /// }
  /// ```
  final dynamic repeatEvery;

  /// End of the plot band need to be repeated.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    repeatUntil: 600
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic repeatUntil;

  /// Angle of the plot band text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    textAngle: 90
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final int? textAngle;

  /// Specifies whether the plot band needs to be rendered above the series.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    shouldRenderAboveSeries: true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final bool shouldRenderAboveSeries;

  /// Date time interval type of the plot band.
  ///
  /// Defaults to  `DateTimeIntervalType.auto`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    sizeType: DateTimeIntervalType.years
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final DateTimeIntervalType sizeType;

  /// Dashes of the series. Any number of values can be provided in the list.
  /// Odd value is considered as rendering size and even value is considered
  /// as gap.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    dashArray: <double>[10, 10]
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final List<double> dashArray;

  /// Size of the plot band.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    size: 20
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic size;

  /// Perpendicular axis start value.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    associatedAxisStart: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic associatedAxisStart;

  /// Perpendicular axis end value.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    associatedAxisEnd: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final dynamic associatedAxisEnd;

  /// Vertical text alignment of the plot band text.
  ///
  /// Defaults to `TextAnchor.middle`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    verticalTextAlignment: TextAnchor.start
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final TextAnchor verticalTextAlignment;

  /// Horizontal text alignment of the plot band text.
  ///
  /// Defaults to `TextAnchor.middle`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    horizontalTextAlignment: TextAnchor.end
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final TextAnchor horizontalTextAlignment;

  /// Fills the plot band with gradient color.
  ///
  /// ```dart
  /// final List <Color> color = <Color>[];
  /// final List<double> stops = <double>[];
  ///
  /// Widget build(BuildContext context) {
  ///    color.add(Colors.pink[50]!);
  ///    color.add(Colors.pink[200]!);
  ///    color.add(Colors.pink);
  ///    stops.add(0.0);
  ///    stops.add(0.5);
  ///    stops.add(1.0);
  ///
  ///    final LinearGradient gradients =
  ///        LinearGradient(colors: color, stops: stops);
  ///
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    gradient: gradients
  ///                )
  ///              ]
  ///           )
  ///        )
  ///     );
  /// }
  /// ```
  final LinearGradient? gradient;

  /// To move the plot band text vertically.
  ///
  /// Takes pixel or percentage value. For pixel, input should be like `10px`
  /// and for percentage input should be like `10%`. If no suffix is specified
  // (`10`), it will be considered as pixel value. Percentage value refers to
  // the overall height of the chart. i.e. 100% is equal to the height
  /// of the chart.
  ///
  /// This is applicable for both vertical and horizontal axis. Positive value
  /// for this property moves the text upwards and negative
  // value moves downwards.
  ///
  /// If [verticalTextAlignment] or [horizontalTextAlignment] is specified,
  /// text padding will be calculated from that modified position.
  ///
  /// Defaults to `null`.
  ///
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    verticalTextPadding:'30%',
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final String? verticalTextPadding;

  /// To move the plot band text horizontally.
  ///
  /// Takes pixel or percentage value. For pixel, input should be like `10px`
  /// and for percentage input should be like `10%`. If no suffix is specified
  /// (`10`), it will be considered as pixel value. Percentage value refers to
  /// the overall width of the chart. i.e. 100% is equal to the width
  /// of the chart.
  ///
  /// This is applicable for both vertical and horizontal axis. Positive value
  /// for this property moves the text to right and negative value
  /// moves to left.
  ///
  /// If [verticalTextAlignment] or [horizontalTextAlignment] is specified,
  /// text padding will be calculated from that modified position.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    horizontalTextPadding:'30%',
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  /// }
  /// ```
  final String? horizontalTextPadding;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PlotBand &&
        other.isVisible == isVisible &&
        other.start == start &&
        other.end == end &&
        other.color == color &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.isRepeatable == isRepeatable &&
        other.repeatEvery == repeatEvery &&
        other.verticalTextPadding == verticalTextPadding &&
        other.horizontalTextPadding == horizontalTextPadding &&
        other.repeatUntil == repeatUntil &&
        other.textAngle == textAngle &&
        other.shouldRenderAboveSeries == shouldRenderAboveSeries &&
        other.sizeType == sizeType &&
        other.dashArray == dashArray &&
        other.size == size &&
        other.associatedAxisStart == associatedAxisStart &&
        other.associatedAxisEnd == associatedAxisEnd &&
        other.verticalTextAlignment == verticalTextAlignment &&
        other.horizontalTextAlignment == horizontalTextAlignment &&
        other.gradient == gradient;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      start,
      end,
      color,
      opacity,
      borderColor,
      borderWidth,
      text,
      textStyle,
      isRepeatable,
      repeatEvery,
      verticalTextPadding,
      horizontalTextPadding,
      repeatUntil,
      textAngle,
      shouldRenderAboveSeries,
      sizeType,
      dashArray,
      size,
      associatedAxisStart,
      associatedAxisEnd,
      verticalTextAlignment,
      horizontalTextAlignment,
      gradient
    ];
    return Object.hashAll(values);
  }
}
