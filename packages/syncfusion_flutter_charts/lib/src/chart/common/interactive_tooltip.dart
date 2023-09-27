import 'package:flutter/material.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Customizes the interactive tooltip.
///
/// Shows the information about the segments. To enable the interactive tooltip, set that [enable] property to true.
///
/// By using this,to customize the [color], [borderWidth], [borderRadius],
/// [format] and so on.
///
/// _Note:_ Intereactive tooltip applicable for axis types and trackball.

@immutable
class InteractiveTooltip {
  /// Creating an argument constructor of InteractiveTooltip class.
  const InteractiveTooltip(
      {this.enable = true,
      this.color,
      this.borderColor,
      this.borderWidth = 0,
      this.borderRadius = 5,
      this.arrowLength = 7,
      this.arrowWidth = 5,
      this.format,
      this.connectorLineColor,
      this.connectorLineWidth = 1.5,
      this.connectorLineDashArray,
      this.decimalPlaces = 3,
      this.canShowMarker = true,
      this.textStyle});

  /// Toggles the visibility of the interactive tooltip in an axis.
  ///
  /// This tooltip will be displayed at the axis for crosshair and
  /// will be displayed near to the trackline for trackball.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(enable: false)
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final bool enable;

  /// Color of the interactive tooltip.
  ///
  /// Used to change the [color] of the tooltip text.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       color: Colors.grey
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final Color? color;

  /// Border color of the interactive tooltip.
  ///
  /// Used to change the stroke color of the axis tooltip.
  ///
  /// Defaults to `Colors.black`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       borderColor: Colors.red,
  ///       borderWidth: 3
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final Color? borderColor;

  /// Border width of the interactive tooltip.
  ///
  /// Used to change the stroke width of the axis tooltip.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       borderColor: Colors.red,
  ///       borderWidth: 3
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final double borderWidth;

  /// Customizes the text in the interactive tooltip.
  ///
  /// Used to change the text color, size, font family, font style, etc.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       textStyle: TextStyle(
  ///         fontSize: 14
  ///       )
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final TextStyle? textStyle;

  /// Customizes the corners of the interactive tooltip.
  ///
  /// Each corner can be customized with a desired value or a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       borderColor: Colors.red,
  ///       borderWidth: 3,
  ///       borderRadius: 2
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final double borderRadius;

  /// It Specifies the length of the tooltip.
  ///
  /// Defaults to `7`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       arrowLength: 5
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior:trackballBehavior
  ///   );
  /// }
  ///```
  final double arrowLength;

  /// It specifies the width of the tooltip arrow.
  ///
  /// Defaults to `5`.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       arrowWidth: 4
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final double arrowWidth;

  /// Text format of the interactive tooltip.
  ///
  /// By default, axis value will be displayed in the tooltip, and it can be customized by
  /// adding desired text as prefix or suffix.
  ///
  ///```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior: TrackballBehavior(
  ///     enable: true,
  ///     tooltipSettings: InteractiveTooltip(
  ///       format: 'point.y %'
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  ///```
  final String? format;

  /// Width of the selection zooming tooltip connector line.
  ///
  /// Defaults to `1.5`.
  ///
  ///```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior: ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior,
  ///     primaryXAxis: NumericAxis(
  ///       interactiveTooltip: InteractiveTooltip(
  ///         connectorLineWidth: 2
  ///       )
  ///     ),
  ///   );
  /// }
  ///```
  final double connectorLineWidth;

  /// Color of the selection zooming tooltip connector line.
  ///
  ///```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior: ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior,
  ///     primaryXAxis: NumericAxis(
  ///       interactiveTooltip: InteractiveTooltip(
  ///         connectorLineColor: Colors.red
  ///       )
  ///     ),
  ///   );
  /// }
  ///```
  final Color? connectorLineColor;

  /// Giving dash array to the selection zooming tooltip connector line.
  ///
  ///```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior: ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior,
  ///     primaryXAxis: NumericAxis(
  ///       interactiveTooltip: InteractiveTooltip(
  ///         connectorLineDashArray: <double>[10,10]
  ///       )
  ///     ),
  ///   );
  /// }
  ///```
  final List<double>? connectorLineDashArray;

  /// Rounding decimal places of the selection zooming tooltip or trackball tooltip label.
  ///
  /// Defaults to `3`.
  ///
  ///```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior: ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior,
  ///     primaryXAxis: NumericAxis(
  ///       interactiveTooltip: InteractiveTooltip(
  ///         decimalPlaces: 4
  ///       )
  ///     ),
  ///   );
  /// }
  ///```
  final int decimalPlaces;

  /// Toggles the visibility of the marker in the trackball tooltip.
  ///
  /// Markers are rendered with the series color and placed near the value in trackball
  /// tooltip to convey which value belongs to which series.
  ///
  /// Trackball tooltip marker uses the same shape specified for the series marker. But
  /// trackball tooltip marker will render based on the value specified to this property
  /// irrespective of considering the series marker's visibility.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  /// late ZoomPanBehavior zoomPanBehavior;
  ///
  /// void initState() {
  ///   zoomPanBehavior: ZoomPanBehavior(
  ///     enableSelectionZooming: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     zoomPanBehavior: zoomPanBehavior,
  ///     primaryXAxis: NumericAxis(
  ///       interactiveTooltip: InteractiveTooltip(
  ///         canShowMarker: false
  ///       )
  ///     ),
  ///   );
  /// }
  ///```
  final bool canShowMarker;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is InteractiveTooltip &&
        other.enable == enable &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.arrowLength == arrowLength &&
        other.arrowWidth == arrowWidth &&
        other.format == format &&
        other.connectorLineColor == connectorLineColor &&
        other.connectorLineWidth == connectorLineWidth &&
        other.connectorLineDashArray == connectorLineDashArray &&
        other.decimalPlaces == decimalPlaces &&
        other.canShowMarker == canShowMarker &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      enable,
      color,
      borderColor,
      borderWidth,
      borderRadius,
      arrowLength,
      arrowWidth,
      format,
      connectorLineColor,
      connectorLineWidth,
      connectorLineDashArray,
      decimalPlaces,
      canShowMarker,
      textStyle
    ];
    return Object.hashAll(values);
  }
}

/// Represents the class of chart point info
class ChartPointInfo {
  /// Marker x position
  double? markerXPos;

  /// Marker y position
  double? markerYPos;

  /// label for trackball and cross hair
  String? label;

  /// Data point index
  int? dataPointIndex;

  /// Instance of chart series
  CartesianSeries<dynamic, dynamic>? series;

  /// Instance of SeriesRendererDetails
  SeriesRendererDetails? seriesRendererDetails;

  /// Chart data point
  CartesianChartPoint<dynamic>? chartDataPoint;

  /// X position of the label
  double? xPosition;

  /// Y position of the label
  double? yPosition;

  /// Color of the segment
  Color? color;

  /// header text
  String? header;

  /// Low Y position of financial series
  double? lowYPosition;

  /// High X position of financial series
  double? highXPosition;

  /// High Y position of financial series
  double? highYPosition;

  /// Open y position of financial series
  double? openYPosition;

  /// close y position of financial series
  double? closeYPosition;

  /// open x position of financial series
  double? openXPosition;

  /// close x position of financial series
  double? closeXPosition;

  /// Minimum Y position of box plot series
  double? minYPosition;

  /// Maximum Y position of box plot series
  double? maxYPosition;

  /// Lower y position of box plot series
  double? lowerXPosition;

  /// Upper y position of box plot series
  double? upperXPosition;

  /// Lower x position of box plot series
  double? lowerYPosition;

  /// Upper x position of box plot series
  double? upperYPosition;

  /// Maximum x position for box plot series
  double? maxXPosition;

  /// series index value
  late int seriesIndex;
}
