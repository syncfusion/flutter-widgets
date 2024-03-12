import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/enum.dart';

/// Enables and customizes the trackball.
///
/// Trackball feature displays the tooltip for the data points that are closer
/// to the point where you touch on the chart area. This feature can be enabled
/// by creating an instance of [SparkChartTrackball].
///
/// Provides option to customizes the [activationMode], [width], [color],
/// [labelStyle], [backgroundColor], [borderColor], [borderWidth].
///
@immutable
class SparkChartTrackball {
  /// Creates an instance of spark chart trackball to enable the trackball
  /// on the closest data point from the touch position.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(borderWidth: 2,
  ///      borderColor: Colors.black, activationMode: SparkChartActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )
  ///   ),
  ///  );
  /// }
  /// ```
  const SparkChartTrackball(
      {this.width = 2,
      this.color,
      this.dashArray,
      this.activationMode = SparkChartActivationMode.tap,
      this.labelStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12),
      this.tooltipFormatter,
      this.backgroundColor,
      this.shouldAlwaysShow = false,
      this.hideDelay = 0,
      this.borderColor,
      this.borderWidth = 0,
      this.borderRadius = const BorderRadius.all(Radius.circular(5))});

  /// Customizes the width of the trackball line.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///           width: 5,
  ///        )
  ///      )
  ///    ),
  ///  );
  /// }
  /// ```
  final double width;

  /// Customizes the color of the trackball line.
  /// The color is set based on the current application theme,
  /// if its value is set to null.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///      color: Colors.black,)
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Dashes of the trackball line. Any number of values can be provided on the
  /// list. Odd value is considered as rendering size and even value is
  /// considered a gap.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///         dashArray: <double>[2,2])
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final List<double>? dashArray;

  /// Defines the gesture for activating the trackball to the closest data point.
  ///
  /// * [SparkChartActivationMode.tap] allows to display the trackball on tap
  /// gesture.
  /// * [SparkChartActivationMode.doubleTap] allows to display the trackball on
  /// double tap gesture.
  /// * [SparkChartActivationMode.longPress] allows to display the trackball on
  /// long press gesture.
  ///
  /// Also refer [SparkChartActivationMode].
  ///
  /// Defaults to ` SparkChartActivationMode.tap`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.doubleTap)
  ///         )
  ///       ),
  ///     );
  ///  }
  /// ```
  final SparkChartActivationMode activationMode;

  /// Customizes the data label text style.
  ///
  /// Using the [TextStyle], add style data labels.
  ///
  /// Defaults to the [TextStyle] property with font size `12.0` and
  /// font family `Roboto`.
  ///
  ///  Also refer [TextStyle].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(labelStyle: TextStyle(fontSize: 15))
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final TextStyle labelStyle;

  /// Customizes the background color of the trackball tooltip.
  /// The color is set based on the current application theme, if its value is
  /// set to null.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:SparkChartTrackball(
  ///      backgroundColor: Colors.black)
  ///         )
  ///       ),
  ///    );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Customizes the border color of the trackball tooltip.
  /// To make border visible for plot band, need to set both the border
  /// color and border width.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///      borderColor: Colors.black)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Customizes the border width of the plot band. To make border visible for
  /// plot band, need to set both the border color and border width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///       child: SfSparkAreaChart(
  ///      trackball:
  ///          SparkChartTrackball(borderWidth: 2)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Customizes the border radius of trackball tooltip.
  ///
  /// Also refer [BorderRadius].
  ///
  /// Defaults to `BorderRadius.all(Radius.circular(5))})`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///          borderRadius: BorderRadius.all(Radius.circular(3)))
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  /// Shows or hides the trackball..
  ///
  /// By default, the trackball will be hidden on touch.
  /// To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(shouldAlwaysShow: true)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Provides the time delay to disappear the trackball on touch.
  /// The provided value will be considered as milliseconds.
  /// When [`shouldAlwaysShow`] is set as false, the value provided to this
  /// property will be considered as a delay.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball: SparkChartTrackball(
  ///        hideDelay: 200)
  ///          )
  ///       ),
  ///    );
  /// }
  /// ```
  final double hideDelay;

  /// Callback that gets triggered when a trackball tooltip text is created.
  ///
  /// The [TooltipFormatterDetails] is passed as an argument and it provides
  /// the closest data point x value, y value, and the tooltip text.
  ///
  /// The string returned from this call back will be displayed as tooltip text.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// String handleTooltipFormatter(TooltipFormatterDetails details) {
  ///  return details.y.toStringAsFixed(0) + 'cm';
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///     child: SfSparkAreaChart(
  ///       trackball:
  ///          SparkChartTrackball(tooltipFormatter: handleTooltipFormatter)
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  final SparkChartTooltipCallback<String>? tooltipFormatter;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SparkChartTrackball &&
        other.width == width &&
        other.color == color &&
        other.activationMode == activationMode &&
        other.labelStyle == labelStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.hideDelay == hideDelay &&
        other.borderRadius == borderRadius &&
        other.tooltipFormatter == tooltipFormatter &&
        listEquals(other.dashArray, dashArray);
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      width,
      color!,
      activationMode,
      labelStyle,
      backgroundColor!,
      borderColor!,
      borderWidth,
      dashArray!,
      shouldAlwaysShow,
      hideDelay,
      borderRadius,
      tooltipFormatter!
    ];
    return Object.hashAll(values);
  }
}
