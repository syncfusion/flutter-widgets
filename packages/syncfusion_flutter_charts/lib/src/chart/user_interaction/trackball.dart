import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/axis_panel.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/financial_series_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/interactive_tooltip.dart';
import '../common/renderer.dart';
import '../utils/helper.dart';
import 'trackball_painter.dart';
import 'trackball_template.dart';

/// Customizes the trackball.
///
/// Trackball feature displays the tooltip for the data points that are closer to the point where you touch on the chart area.
/// This feature can be enabled using enable property of [TrackballBehavior].
///
/// Provides options to customize the [activationMode], [tooltipDisplayMode], [lineType] and [tooltipSettings].
@immutable
// ignore: must_be_immutable
class TrackballBehavior {
  /// Creating an argument constructor of TrackballBehavior class.
  TrackballBehavior({
    this.activationMode = ActivationMode.longPress,
    this.lineType = TrackballLineType.vertical,
    this.tooltipDisplayMode = TrackballDisplayMode.floatAllPoints,
    this.tooltipAlignment = ChartAlignment.center,
    this.tooltipSettings = const InteractiveTooltip(),
    this.markerSettings,
    this.lineDashArray,
    this.enable = false,
    this.lineColor,
    this.lineWidth = 1,
    this.shouldAlwaysShow = false,
    this.builder,
    this.hideDelay = 0,
  });

  /// Toggles the visibility of the trackball.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Width of the track line.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineWidth: 5
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final double lineWidth;

  /// Color of the track line.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineColor: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final Color? lineColor;

  /// Dashes of the track line.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineDashArray: [10,10]
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final List<double>? lineDashArray;

  /// Gesture for activating the trackball.
  ///
  /// Trackball can be activated in tap, double tap and long press.
  ///
  /// Defaults to `ActivationMode.longPress`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Alignment of the trackball tooltip.
  ///
  /// The trackball tooltip can be aligned at the top, bottom, and center position of the chart.
  ///
  /// _Note:_ This is applicable only when the `tooltipDisplayMode` property is set to `TrackballDisplayMode.groupAllPoints`.
  ///
  /// Defaults to `ChartAlignment.center`
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
  ///     tooltipAlignment: ChartAlignment.far
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ChartAlignment tooltipAlignment;

  /// Type of trackball line. By default, vertical line will be displayed.
  ///
  /// You can change this by specifying values to this property.
  ///
  /// Defaults to `TrackballLineType.vertical`.
  ///
  /// Also refer [TrackballLineType]
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     lineType: TrackballLineType.vertical
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final TrackballLineType lineType;

  /// Display mode of tooltip.
  ///
  /// By default, tooltip of all the series under the current point index value will be shown.
  ///
  /// Defaults to `TrackballDisplayMode.floatAllPoints`.
  ///
  /// Also refer [TrackballDisplayMode].
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final TrackballDisplayMode tooltipDisplayMode;

  /// Shows or hides the trackball.
  ///
  /// By default, the trackball will be hidden on touch. To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Customizes the trackball tooltip.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     canShowMarker: false
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  InteractiveTooltip tooltipSettings;

  /// Giving disappear delay for trackball.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     hideDelay: 2000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior,
  ///   );
  /// }
  /// ```
  final double hideDelay;

  /// Builder of the trackball tooltip.
  ///
  /// Add any custom widget as the trackball template.
  ///
  /// If the trackball display mode is `groupAllPoints` or `nearestPoint` it will called once and if it is
  /// `floatAllPoints`, it will be called for each point.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TrackballBehavior trackballBehavior;
  ///
  /// void initState() {
  ///   trackballBehavior = TrackballBehavior(
  ///     enable: true,
  ///     builder: (BuildContext context, TrackballDetails trackballDetails) {
  ///       return Container(
  ///         width: 70,
  ///         decoration:
  ///           const BoxDecoration(color: Color.fromRGBO(66, 244, 164, 1)),
  ///         child: Text('${trackballDetails.point?.cumulativeValue}')
  ///       );
  ///     }
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     trackballBehavior: trackballBehavior
  ///   );
  /// }
  /// ```
  final ChartTrackballBuilder<dynamic>? builder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TrackballBehavior &&
        other.activationMode == activationMode &&
        other.lineType == lineType &&
        other.tooltipDisplayMode == tooltipDisplayMode &&
        other.tooltipAlignment == tooltipAlignment &&
        other.tooltipSettings == tooltipSettings &&
        other.lineDashArray == lineDashArray &&
        other.markerSettings == markerSettings &&
        other.enable == enable &&
        other.lineColor == lineColor &&
        other.lineWidth == lineWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.builder == builder &&
        other.hideDelay == hideDelay;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      activationMode,
      lineType,
      tooltipDisplayMode,
      tooltipAlignment,
      tooltipSettings,
      markerSettings,
      lineDashArray,
      enable,
      lineColor,
      lineWidth,
      shouldAlwaysShow,
      builder,
      hideDelay
    ];
    return Object.hashAll(values);
  }

  /// Holds the value of cartesian state properties
  late CartesianStateProperties _stateProperties;

  ///Options to customize the markers that are displayed when trackball is enabled.
  ///
  ///Trackball markers are used to provide information about the exact point location,
  /// when the trackball is visible. You can add a shape to adorn each data point.
  /// Trackball markers can be enabled by using the `markerVisibility` property
  /// in [TrackballMarkerSettings].
  ///
  ///Provides the options like color, border width, border color and shape of the
  /// marker to customize the appearance.
  final TrackballMarkerSettings? markerSettings;

  /// Displays the trackball at the specified x and y-positions.
  ///
  /// *x and y - x & y pixels/values at which the trackball needs to be shown.
  ///
  /// coordinateUnit - specify the type of x and y values given.
  ///
  /// `pixel` or `point` for logical pixel and chart data point respectively.
  ///
  /// Defaults to `point`.
  void show(dynamic x, double y, [String coordinateUnit = 'point']) {
    final CartesianStateProperties stateProperties = _stateProperties;
    final TrackballRenderingDetails trackballRenderingDetails =
        TrackballHelper.getRenderingDetails(
            _stateProperties.trackballBehaviorRenderer);
    final List<CartesianSeriesRenderer> visibleSeriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderer.isEmpty) {
      return;
    }
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(visibleSeriesRenderer.firstWhere(
            (CartesianSeriesRenderer element) =>
                SeriesHelper.getSeriesRendererDetails(element)
                    .visibleDataPoints !=
                null));
    if (trackballRenderingDetails.trackballPainter != null || builder != null) {
      final ChartAxisRendererDetails xAxisDetails =
          seriesRendererDetails.xAxisDetails!;
      if (coordinateUnit != 'pixel') {
        final ChartLocation location = calculatePoint(
            (x is DateTime && (xAxisDetails is! DateTimeCategoryAxisDetails))
                ? x.millisecondsSinceEpoch
                : ((x is DateTime &&
                        xAxisDetails is DateTimeCategoryAxisDetails)
                    ? xAxisDetails.labels
                        .indexOf(xAxisDetails.dateFormat.format(x))
                    : ((x is String && xAxisDetails is CategoryAxisDetails)
                        ? xAxisDetails.labels.indexOf(x)
                        : x)),
            y,
            xAxisDetails,
            seriesRendererDetails.yAxisDetails!,
            seriesRendererDetails.stateProperties.requireInvertedAxis,
            seriesRendererDetails.series,
            seriesRendererDetails.stateProperties.chartAxis.axisClipRect);
        x = location.x;
        y = location.y;
      }
      if (seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        if (trackballRenderingDetails.trackballPainter != null) {
          trackballRenderingDetails.isTrackballTemplate = false;
          trackballRenderingDetails.generateAllPoints(Offset(x.toDouble(), y));
        } else if (builder != null && (!trackballRenderingDetails.isMoving)) {
          trackballRenderingDetails
              .showTemplateTrackball(Offset(x.toDouble(), y));
        }
      }
    }

    if (trackballRenderingDetails.trackballPainter != null) {
      trackballRenderingDetails.trackballPainter!.canResetPath = false;
      stateProperties.repaintNotifiers['trackball']!.value++;
    }
  }

  /// Displays the trackball at the specified point index.
  ///
  /// * pointIndex - index of the point for which the trackball must be shown
  void showByIndex(int pointIndex) {
    final TrackballRenderingDetails trackballRenderingDetails =
        TrackballHelper.getRenderingDetails(
            _stateProperties.trackballBehaviorRenderer);
    trackballRenderingDetails.internalShowByIndex(
      pointIndex,
    );
  }

  /// Hides the trackball if it is displayed.
  void hide() {
    final CartesianStateProperties stateProperties = _stateProperties;
    final TrackballRenderingDetails trackballRenderingDetails =
        TrackballHelper.getRenderingDetails(
            _stateProperties.trackballBehaviorRenderer);
    if (trackballRenderingDetails.trackballPainter != null &&
        !trackballRenderingDetails.isTrackballTemplate) {
      if (stateProperties.chart.trackballBehavior.activationMode ==
          ActivationMode.doubleTap) {
        trackballRenderingDetails.trackballPainter!.canResetPath = false;
        ValueNotifier<int>(trackballRenderingDetails.trackballPainter!
            .stateProperties.repaintNotifiers['trackball']!.value++);
        if (trackballRenderingDetails.trackballPainter!.timer != null) {
          trackballRenderingDetails.trackballPainter!.timer?.cancel();
        }
      }
      if (!stateProperties.isTouchUp) {
        trackballRenderingDetails.trackballPainter!.stateProperties
            .repaintNotifiers['trackball']!.value++;
        trackballRenderingDetails.chartPointInfo.clear();
        trackballRenderingDetails.trackballPainter!.canResetPath = true;
      } else {
        final double duration =
            (hideDelay == 0 && stateProperties.enableDoubleTap)
                ? 200
                : hideDelay;
        if (!shouldAlwaysShow) {
          if (trackballRenderingDetails.trackballPainter!.timer != null) {
            trackballRenderingDetails.trackballPainter!.timer!.cancel();
          }
          trackballRenderingDetails.trackballPainter!.timer =
              Timer(Duration(milliseconds: duration.toInt()), () {
            trackballRenderingDetails.trackballPainter!.stateProperties
                .repaintNotifiers['trackball']!.value++;
            trackballRenderingDetails.trackballPainter!.canResetPath = true;
            trackballRenderingDetails.chartPointInfo.clear();
          });
        }
      }
    } else if (trackballRenderingDetails.trackballTemplate != null) {
      GlobalKey key =
          trackballRenderingDetails.trackballTemplate!.key as GlobalKey;
      TrackballTemplateState? trackballTemplateState =
          key.currentState as TrackballTemplateState;
      final double duration = shouldAlwaysShow ||
              (hideDelay == 0 && stateProperties.enableDoubleTap)
          ? 200
          : hideDelay;
      if (!stateProperties.isTrackballOrientationChanged) {
        stateProperties.trackballTimer =
            Timer(Duration(milliseconds: duration.toInt()), () {
          if (stateProperties.isTrackballOrientationChanged) {
            key = trackballRenderingDetails.trackballTemplate!.key as GlobalKey;
            trackballTemplateState = key.currentState as TrackballTemplateState;
          }
          trackballTemplateState!.hideTrackballTemplate();
          stateProperties.isTrackballOrientationChanged = false;
          trackballRenderingDetails.chartPointInfo.clear();
        });
      }
    }
  }
}

///Trackball behavior renderer class for mutable fields and methods
class TrackballBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for trackball renderer class
  TrackballBehaviorRenderer(this._stateProperties) {
    _trackballRenderingDetails = TrackballRenderingDetails(_stateProperties);
  }
  final CartesianStateProperties _stateProperties;

  /// Specifies the value of trackball rendering details
  late TrackballRenderingDetails _trackballRenderingDetails;

  /// Performs the double-tap action.
  ///
  /// Hits while double tapping on the chart.
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the long press action.
  ///
  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onLongPress(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-down action.
  ///
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-move action.
  ///
  /// Hits while tap and moving on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// *  yPos - Y value of the touch position.
  @override
  void onTouchMove(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the touch-up action.
  ///
  /// Hits while release tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchUp(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.hide();

  /// Performs the mouse-hover action.
  ///
  /// Hits while enter tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onEnter(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.show(xPos, yPos, 'pixel');

  /// Performs the mouse-exit action.
  ///
  /// Hits while exit tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onExit(double xPos, double yPos) =>
      _trackballRenderingDetails.trackballBehavior.hide();

  /// Draws trackball
  ///
  /// * canvas - Canvas used to draw the track line on the chart.
  @override
  void onPaint(Canvas canvas) {
    if (_trackballRenderingDetails.trackballPainter != null &&
        !_trackballRenderingDetails.trackballPainter!.canResetPath) {
      _trackballRenderingDetails.trackballPainter!.drawTrackball(canvas);
    }
  }
}

/// Represents the class that holds the rendering details of trackball
class TrackballRenderingDetails {
  /// Creates an instance of trackball rendering details
  TrackballRenderingDetails(this._stateProperties);
  final CartesianStateProperties _stateProperties;
  SfCartesianChart get _chart => _stateProperties.chart;

  /// Specifies the trackball behavior
  TrackballBehavior get trackballBehavior => _chart.trackballBehavior;

  /// Check whether long press activated or not.
  // ignore: prefer_final_fields
  bool isLongPressActivated = false;

  /// Check whether onPointerMove or not.
  // ignore: prefer_final_fields
  bool isMoving = false;

  /// Touch position
  late Offset tapPosition;

  /// Holds the instance of trackball painter.
  TrackballPainter? trackballPainter;

  /// Specifies the trackball template
  TrackballTemplate? trackballTemplate;
  List<num> _visibleLocation = <num>[];

  /// Specifies the marker shape
  final List<Path> markerShapes = <Path>[];
  late Rect _axisClipRect;

  //ignore: unused_field
  late double _xPos;
  //ignore: unused_field
  late double _yPos;
  List<CartesianChartPoint<dynamic>> _points = <CartesianChartPoint<dynamic>>[];
  List<int> _currentPointIndices = <int>[];
  List<int> _visibleSeriesIndices = <int>[];
  List<CartesianSeries<dynamic, dynamic>> _visibleSeriesList =
      <CartesianSeries<dynamic, dynamic>>[];
  late TrackballGroupingModeInfo _groupingModeInfo;

  /// Specifies the chart point info
  List<ChartPointInfo> chartPointInfo = <ChartPointInfo>[];

  /// Specifies the tooltip top
  List<num> tooltipTop = <num>[];

  /// Specifies the tooltip bottom
  List<num> tooltipBottom = <num>[];

  /// Specifies the xAxesInfo
  final List<ChartAxisRenderer> xAxesInfo = <ChartAxisRenderer>[];

  /// Specifies the yAxesInfo
  final List<ChartAxisRenderer> yAxesInfo = <ChartAxisRenderer>[];

  /// Specifies the visible points
  List<ClosestPoints> visiblePoints = <ClosestPoints>[];

  /// Specifies the tooltip position
  TooltipPositions? tooltipPosition;

  late num _tooltipPadding;

  /// Specifies whether it is range series
  bool isRangeSeries = false;

  /// Specifies whether it is box series
  bool isBoxSeries = false;

  /// Specifies whether the trackball has template
  bool isTrackballTemplate = false;

  /// To render the trackball marker for both tooltip and template
  void trackballMarker(int index) {
    if (trackballBehavior.markerSettings != null &&
        (trackballBehavior.markerSettings!.markerVisibility ==
                TrackballVisibilityMode.auto
            ? (chartPointInfo[index]
                    .seriesRendererDetails!
                    .series
                    .markerSettings
                    .isVisible ==
                true)
            : trackballBehavior.markerSettings!.markerVisibility ==
                TrackballVisibilityMode.visible)) {
      final MarkerSettings markerSettings = trackballBehavior.markerSettings!;
      final DataMarkerType markerType = markerSettings.shape;
      final Size size = Size(markerSettings.width, markerSettings.height);
      final String seriesType =
          chartPointInfo[index].seriesRendererDetails!.seriesType;
      markerShapes.add(getMarkerShapesPath(
          markerType,
          Offset(
              chartPointInfo[index].xPosition!,
              seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType == 'candle'
                  ? chartPointInfo[index].highYPosition!
                  : seriesType == 'boxandwhisker'
                      ? chartPointInfo[index].maxYPosition!
                      : chartPointInfo[index].yPosition!),
          size,
          chartPointInfo[index].seriesRendererDetails!,
          null,
          trackballBehavior));
    }
  }

  /// To show trackball based on point index
  void showTrackball(List<CartesianSeriesRenderer> visibleSeriesRenderers,
      int pointIndex, TrackballBehaviorRenderer trackballBehaviorRenderer) {
    ChartLocation position;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(visibleSeriesRenderers[0]);
    final Rect rect =
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> data =
        getSampledData(seriesRendererDetails);
    for (int i = 0; i < seriesRendererDetails.dataPoints.length; i++) {
      if (seriesRendererDetails.dataPoints[i].isGap != true) {
        dataPoints.add(seriesRendererDetails.dataPoints[i]);
      }
    }
    // ignore: unnecessary_null_comparison
    assert(pointIndex != null, 'Point index must not be null');
// ignore: unnecessary_null_comparison
    if (pointIndex != null && pointIndex.abs() < data.length) {
      final int index = pointIndex;
      final num xValue = data[index].xValue;
      final num yValue = seriesRendererDetails.series
                  is FinancialSeriesBase<dynamic, dynamic> ||
              seriesRendererDetails.seriesType.contains('range') == true
          ? data[index].high
          : data[index].yValue;
      position = calculatePoint(
          xValue,
          yValue,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      if (trackballPainter != null) {
        generateAllPoints(Offset(position.x, position.y));
      } else if (trackballBehavior.builder != null) {
        showTemplateTrackball(Offset(position.x, position.y));
      }
    }
  }

  /// Method to show the trackball with template
  void showTemplateTrackball(Offset position) {
    final GlobalKey key = trackballTemplate!.key as GlobalKey;
    final TrackballTemplateState trackballTemplateState =
        key.currentState as TrackballTemplateState;
    tapPosition = position;
    trackballTemplateState.alwaysShow = trackballBehavior.shouldAlwaysShow;
    trackballTemplateState.duration =
        trackballBehavior.hideDelay == 0 ? 200 : trackballBehavior.hideDelay;
    isTrackballTemplate = true;
    generateAllPoints(position);
    CartesianChartPoint<dynamic> dataPoint;
    for (int index = 0; index < chartPointInfo.length; index++) {
      dataPoint = chartPointInfo[index]
          .seriesRendererDetails!
          .dataPoints[chartPointInfo[index].dataPointIndex!];
      if (trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints) {
        _points.add(dataPoint);
        _currentPointIndices.add(chartPointInfo[index].dataPointIndex!);
        _visibleSeriesIndices.add(_stateProperties
            .chartSeries.visibleSeriesRenderers
            .indexOf(chartPointInfo[index].seriesRendererDetails!.renderer));
        _visibleSeriesList
            .add(chartPointInfo[index].seriesRendererDetails!.series);
      }
      trackballMarker(index);
    }
    _groupingModeInfo = TrackballGroupingModeInfo(_points, _currentPointIndices,
        _visibleSeriesIndices, _visibleSeriesList);
    assert(trackballTemplateState.mounted,
        'Template state which must be mounted before accessing to avoid rebuilding');
    if (trackballTemplateState.mounted &&
        trackballBehavior.tooltipDisplayMode ==
            TrackballDisplayMode.groupAllPoints) {
      trackballTemplateState.chartPointInfo = chartPointInfo;
      trackballTemplateState.groupingModeInfo = _groupingModeInfo;
      trackballTemplateState.markerShapes = markerShapes;
      trackballTemplateState.refresh();
    } else if (trackballTemplateState.mounted) {
      trackballTemplateState.chartPointInfo = chartPointInfo;
      trackballTemplateState.markerShapes = markerShapes;
      trackballTemplateState.refresh();
    }
    _points = <CartesianChartPoint<dynamic>>[];
    _currentPointIndices = <int>[];
    _visibleSeriesIndices = <int>[];
    _visibleSeriesList = <CartesianSeries<dynamic, dynamic>>[];
    tooltipTop.clear();
    tooltipBottom.clear();
  }

  /// Calculate trackball points
  void generateAllPoints(Offset position) {
    _axisClipRect = _stateProperties.chartAxis.axisClipRect;
    _tooltipPadding = _stateProperties.requireInvertedAxis ? 8 : 5;
    chartPointInfo = <ChartPointInfo>[];
    visiblePoints = <ClosestPoints>[];
    markerShapes.clear();
    tooltipTop = tooltipBottom = _visibleLocation = <num>[];
    trackballPainter?.tooltipTop = <num>[];
    trackballPainter?.tooltipBottom = <num>[];
    final Rect seriesBounds = _axisClipRect;
    tapPosition = position;
    double? xPos = 0,
        yPos = 0,
        leastX = 0,
        openXPos,
        openYPos,
        closeXPos,
        closeYPos,
        highXPos,
        cummulativePos,
        lowerXPos,
        lowerYPos,
        upperXPos,
        upperYPos,
        lowYPos,
        highYPos,
        minYPos,
        maxYPos,
        maxXPos;
    int seriesIndex = 0, index;
    late SeriesRendererDetails cartesianSeriesRendererDetails;
    ChartAxisRendererDetails chartAxisDetails, xAxisDetails, yAxisDetails;
    CartesianChartPoint<dynamic> chartDataPoint;
    ChartAxisPanel chartAxis;
    String seriesType, labelValue, seriesName;
    bool invertedAxis = _stateProperties.requireInvertedAxis;
    CartesianSeries<dynamic, dynamic> series;
    num? xValue,
        yValue,
        minimumValue,
        maximumValue,
        lowerQuartileValue,
        upperQuartileValue,
        meanValue,
        highValue,
        lowValue,
        openValue,
        closeValue,
        bubbleSize,
        cumulativeValue;
    Rect axisClipRect;
    final TrackballDisplayMode tooltipDisplayMode =
        _stateProperties.chart.trackballBehavior.tooltipDisplayMode;
    ChartLocation highLocation, maxLocation;
    chartAxisDetails = SeriesHelper.getSeriesRendererDetails(
            _stateProperties.seriesRenderers[0])
        .xAxisDetails!;
    for (final CartesianSeriesRenderer axisSeriesRenderer
        in chartAxisDetails.seriesRenderers) {
      cartesianSeriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(axisSeriesRenderer);
      seriesType = cartesianSeriesRendererDetails.seriesType;
      isRangeSeries = seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType == 'candle';
      isBoxSeries = seriesType == 'boxandwhisker';
      final List<CartesianChartPoint<dynamic>> dataPoints =
          getSampledData(cartesianSeriesRendererDetails);
      if (cartesianSeriesRendererDetails.visible == false ||
          (dataPoints.isEmpty == true &&
              cartesianSeriesRendererDetails.isRectSeries == false)) {
        continue;
      }
      if (dataPoints.isNotEmpty == true) {
        final List<CartesianChartPoint<dynamic>>? nearestDataPoints =
            getNearestChartPoints(
                position.dx,
                position.dy,
                cartesianSeriesRendererDetails.xAxisDetails!.axisRenderer,
                cartesianSeriesRendererDetails.yAxisDetails!.axisRenderer,
                cartesianSeriesRendererDetails);
        for (final CartesianChartPoint<dynamic> dataPoint
            in nearestDataPoints!) {
          index = dataPoints.indexOf(dataPoint);
          if (index >= 0) {
            chartDataPoint = dataPoints[index];
            xAxisDetails = cartesianSeriesRendererDetails.xAxisDetails!;
            yAxisDetails = cartesianSeriesRendererDetails.yAxisDetails!;
            chartAxis =
                cartesianSeriesRendererDetails.stateProperties.chartAxis;
            invertedAxis = _stateProperties.requireInvertedAxis;
            series = cartesianSeriesRendererDetails.series;
            xValue = chartDataPoint.xValue;
            if (seriesType != 'boxandwhisker') {
              yValue = chartDataPoint.yValue;
            }
            minimumValue = chartDataPoint.minimum;
            maximumValue = chartDataPoint.maximum;
            lowerQuartileValue = chartDataPoint.lowerQuartile;
            upperQuartileValue = chartDataPoint.upperQuartile;
            meanValue = chartDataPoint.mean;
            highValue = chartDataPoint.high;
            lowValue = chartDataPoint.low;
            openValue = chartDataPoint.open;
            closeValue = chartDataPoint.close;
            seriesName = cartesianSeriesRendererDetails.series.name ??
                'Series $seriesIndex';
            bubbleSize = chartDataPoint.bubbleSize;
            cumulativeValue = chartDataPoint.cumulativeValue;
            axisClipRect = calculatePlotOffset(
                chartAxis.axisClipRect,
                Offset(xAxisDetails.axis.plotOffset,
                    yAxisDetails.axis.plotOffset));
            cummulativePos = calculatePoint(
                    xValue!,
                    cumulativeValue,
                    xAxisDetails,
                    yAxisDetails,
                    invertedAxis,
                    series,
                    axisClipRect)
                .y;
            xPos = calculatePoint(
                    xValue,
                    seriesType.contains('stacked') ? cumulativeValue : yValue,
                    xAxisDetails,
                    yAxisDetails,
                    invertedAxis,
                    series,
                    axisClipRect)
                .x;
            if (!xPos.toDouble().isNaN) {
              if (seriesIndex == 0 ||
                  ((leastX! - position.dx).abs() >
                      (xPos - position.dx).abs())) {
                leastX = xPos;
              }
              labelValue = _getTrackballLabelText(
                  cartesianSeriesRendererDetails,
                  xValue,
                  yValue,
                  lowValue,
                  highValue,
                  openValue,
                  closeValue,
                  minimumValue,
                  maximumValue,
                  lowerQuartileValue,
                  upperQuartileValue,
                  meanValue,
                  seriesName,
                  bubbleSize,
                  cumulativeValue,
                  dataPoint);
              yPos = seriesType.contains('stacked')
                  ? cummulativePos
                  : calculatePoint(xValue, yValue, xAxisDetails, yAxisDetails,
                          invertedAxis, series, axisClipRect)
                      .y;
              if (isRangeSeries) {
                lowYPos = calculatePoint(xValue, lowValue, xAxisDetails,
                        yAxisDetails, invertedAxis, series, axisClipRect)
                    .y;
                highLocation = calculatePoint(xValue, highValue, xAxisDetails,
                    yAxisDetails, invertedAxis, series, axisClipRect);
                highYPos = highLocation.y;
                highXPos = highLocation.x;
                if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
                  openXPos = dataPoint.openPoint!.x;
                  openYPos = dataPoint.openPoint!.y;
                  closeXPos = dataPoint.closePoint!.x;
                  closeYPos = dataPoint.closePoint!.y;
                }
              } else if (seriesType == 'boxandwhisker') {
                minYPos = calculatePoint(xValue, minimumValue, xAxisDetails,
                        yAxisDetails, invertedAxis, series, axisClipRect)
                    .y;
                maxLocation = calculatePoint(xValue, maximumValue, xAxisDetails,
                    yAxisDetails, invertedAxis, series, axisClipRect);
                maxXPos = maxLocation.x;
                maxYPos = maxLocation.y;
                lowerXPos = dataPoint.lowerQuartilePoint!.x;
                lowerYPos = dataPoint.lowerQuartilePoint!.y;
                upperXPos = dataPoint.upperQuartilePoint!.x;
                upperYPos = dataPoint.upperQuartilePoint!.y;
              }
              final Rect rect = seriesBounds.intersect(Rect.fromLTWH(
                  xPos - 1,
                  isRangeSeries
                      ? highYPos! - 1
                      : isBoxSeries
                          ? maxYPos! - 1
                          : yPos - 1,
                  2,
                  2));
              if (seriesBounds.contains(Offset(
                      xPos,
                      isRangeSeries
                          ? highYPos!
                          : isBoxSeries
                              ? maxYPos!
                              : yPos)) ||
                  seriesBounds.overlaps(rect)) {
                visiblePoints.add(ClosestPoints(
                    closestPointX: !isRangeSeries
                        ? xPos
                        : isBoxSeries
                            ? maxXPos!
                            : highXPos!,
                    closestPointY: isRangeSeries
                        ? highYPos!
                        : isBoxSeries
                            ? maxYPos!
                            : yPos));
                _addChartPointInfo(
                    cartesianSeriesRendererDetails,
                    xPos,
                    yPos,
                    index,
                    !isTrackballTemplate ? labelValue : null,
                    seriesIndex,
                    lowYPos,
                    highXPos,
                    highYPos,
                    openXPos,
                    openYPos,
                    closeXPos,
                    closeYPos,
                    minYPos,
                    maxXPos,
                    maxYPos,
                    lowerXPos,
                    lowerYPos,
                    upperXPos,
                    upperYPos);
                if (tooltipDisplayMode == TrackballDisplayMode.groupAllPoints &&
                    leastX >= seriesBounds.left) {
                  invertedAxis ? yPos = leastX : xPos = leastX;
                }
              }
            }
          }
        }
        seriesIndex++;
      }
      _validateNearestXValue(
          leastX!, cartesianSeriesRendererDetails, position.dx, position.dy);
      _validatePointsWithSeries(leastX);
    }
    if (visiblePoints.isNotEmpty) {
      invertedAxis
          ? visiblePoints.sort((ClosestPoints a, ClosestPoints b) =>
              a.closestPointX.compareTo(b.closestPointX))
          : visiblePoints.sort((ClosestPoints a, ClosestPoints b) =>
              a.closestPointY.compareTo(b.closestPointY));
    }
    if (chartPointInfo.isNotEmpty) {
      if (tooltipDisplayMode != TrackballDisplayMode.groupAllPoints) {
        invertedAxis
            ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                a.xPosition!.compareTo(b.xPosition!))
            : tooltipDisplayMode == TrackballDisplayMode.floatAllPoints
                ? chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    a.yPosition!.compareTo(b.yPosition!))
                : chartPointInfo.sort((ChartPointInfo a, ChartPointInfo b) =>
                    b.yPosition!.compareTo(a.yPosition!));
      }
      if (tooltipDisplayMode == TrackballDisplayMode.nearestPoint ||
          (cartesianSeriesRendererDetails.isRectSeries == true &&
              tooltipDisplayMode != TrackballDisplayMode.groupAllPoints)) {
        _validateNearestPointForAllSeries(
            leastX!, chartPointInfo, position.dx, position.dy);
      }
    }
    _triggerTrackballRenderCallback();
  }

  /// Event for trackball render
  void _triggerTrackballRenderCallback() {
    if (_chart.onTrackballPositionChanging != null) {
      _stateProperties.chartPointInfo = chartPointInfo;
      int index;
      for (index = _stateProperties.chartPointInfo.length - 1;
          index >= 0;
          index--) {
        TrackballArgs chartPoint;
        chartPoint = TrackballArgs();
        chartPoint.chartPointInfo = _stateProperties.chartPointInfo[index];
        _chart.onTrackballPositionChanging!(chartPoint);
        _stateProperties.chartPointInfo[index].label =
            chartPoint.chartPointInfo.label;
        _stateProperties.chartPointInfo[index].header =
            chartPoint.chartPointInfo.header;
        if (!isTrackballTemplate &&
                _stateProperties.chartPointInfo[index].label == null ||
            _stateProperties.chartPointInfo[index].label == '') {
          _stateProperties.chartPointInfo.removeAt(index);
          visiblePoints.removeAt(index);
        }
      }
    }
  }

  /// To validate the nearest point in all series for trackball
  void _validateNearestPointForAllSeries(double leastX,
      List<ChartPointInfo> trackballInfo, double touchXPos, double touchYPos) {
    double xPos = 0, yPos;
    final List<ChartPointInfo> tempTrackballInfo =
        List<ChartPointInfo>.from(trackballInfo);
    ChartPointInfo pointInfo;
    num? yValue;
    num xValue;
    Rect axisClipRect;
    CartesianChartPoint<dynamic> dataPoint;
    ChartAxisRendererDetails xAxisDetails, yAxisDetails;
    int i;
    late List<CartesianChartPoint<dynamic>> data;
    for (i = 0; i < tempTrackballInfo.length; i++) {
      pointInfo = tempTrackballInfo[i];
      data = getSampledData(pointInfo.seriesRendererDetails!);
      dataPoint = data[pointInfo.dataPointIndex!];
      xAxisDetails = pointInfo.seriesRendererDetails!.xAxisDetails!;
      yAxisDetails = pointInfo.seriesRendererDetails!.yAxisDetails!;
      xValue = dataPoint.xValue;
      if (pointInfo.seriesRendererDetails!.seriesType != 'boxandwhisker') {
        yValue = dataPoint.yValue;
      }
      axisClipRect = calculatePlotOffset(
          pointInfo
              .seriesRendererDetails!.stateProperties.chartAxis.axisClipRect,
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));
      final ChartLocation chartPointOffset = calculatePoint(
          xValue,
          yValue,
          xAxisDetails,
          yAxisDetails,
          _stateProperties.requireInvertedAxis,
          pointInfo.seriesRendererDetails!.series,
          axisClipRect);

      xPos = chartPointOffset.x;
      yPos = chartPointOffset.y;
      if (_stateProperties.chart.trackballBehavior.tooltipDisplayMode !=
          TrackballDisplayMode.floatAllPoints) {
        final bool isTransposed = pointInfo
            .seriesRendererDetails!.stateProperties.requireInvertedAxis;
        if (leastX != xPos && !isTransposed) {
          trackballInfo.remove(pointInfo);
        }
        yPos = touchYPos;
        xPos = touchXPos;
        if (_stateProperties.chart.trackballBehavior.tooltipDisplayMode !=
                TrackballDisplayMode.floatAllPoints &&
            trackballInfo.isNotEmpty) {
          ChartPointInfo point = trackballInfo[0];
          for (i = 1; i < trackballInfo.length; i++) {
            final bool isXYPositioned = !isTransposed
                ? (((point.yPosition! - yPos).abs() >
                        (trackballInfo[i].yPosition! - yPos).abs()) &&
                    point.xPosition == trackballInfo[i].xPosition)
                : (((point.xPosition! - xPos).abs() >
                        (trackballInfo[i].xPosition! - xPos).abs()) &&
                    point.yPosition == trackballInfo[i].yPosition);
            if (isXYPositioned) {
              point = trackballInfo[i];
            }
          }
          trackballInfo
            ..clear()
            ..add(point);
        }
      }
    }
  }

  /// To find the nearest x value to render a trackball
  void _validateNearestXValue(
      double leastX,
      SeriesRendererDetails seriesRendererDetails,
      double touchXPos,
      double touchYPos) {
    final List<ChartPointInfo> leastPointInfo = <ChartPointInfo>[];
    final Rect axisClipRect = calculatePlotOffset(
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    final bool invertedAxis =
        seriesRendererDetails.stateProperties.requireInvertedAxis;
    double nearPointX = invertedAxis ? axisClipRect.top : axisClipRect.left;
    final double touchXValue = invertedAxis ? touchYPos : touchXPos;
    double delta = 0, currX;
    num xValue;
    num? yValue;
    CartesianChartPoint<dynamic> dataPoint;
    CartesianSeries<dynamic, dynamic> series;
    ChartAxisRendererDetails xAxisDetails, yAxisDetails;
    ChartLocation currXLocation;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        getSampledData(seriesRendererDetails);
    for (final ChartPointInfo pointInfo in chartPointInfo) {
      if (pointInfo.dataPointIndex! < dataPoints.length) {
        dataPoint = dataPoints[pointInfo.dataPointIndex!];
        xAxisDetails = pointInfo.seriesRendererDetails!.xAxisDetails!;
        yAxisDetails = pointInfo.seriesRendererDetails!.yAxisDetails!;
        xValue = dataPoint.xValue;
        if (seriesRendererDetails.seriesType != 'boxandwhisker') {
          yValue = dataPoint.yValue;
        }
        series = pointInfo.seriesRendererDetails!.series;
        currXLocation = calculatePoint(xValue, yValue, xAxisDetails,
            yAxisDetails, invertedAxis, series, axisClipRect);
        currX = invertedAxis ? currXLocation.y : currXLocation.x;

        if (delta == touchXValue - currX) {
          leastPointInfo.add(pointInfo);
        } else if ((touchXValue - currX).toDouble().abs() <=
            (touchXValue - nearPointX).toDouble().abs()) {
          nearPointX = currX;
          delta = touchXValue - currX;
          leastPointInfo.clear();
          leastPointInfo.add(pointInfo);
        }
      }
      if (chartPointInfo.isNotEmpty) {
        final List<CartesianChartPoint<dynamic>> dataPoints =
            getSampledData(seriesRendererDetails);
        if (chartPointInfo[0].dataPointIndex! < dataPoints.length) {
          leastX = _getLeastX(dataPoints, chartPointInfo[0],
              seriesRendererDetails, axisClipRect);
        }
      }

      if (pointInfo.seriesRendererDetails!.seriesType.contains('bar') == true
          ? invertedAxis
          : invertedAxis) {
        _yPos = leastX;
      } else {
        _xPos = leastX;
      }
    }
  }

  void _validatePointsWithSeries(double leastX) {
    final List<num> xValueList = <num>[];
    for (final ChartPointInfo pointInfo in chartPointInfo) {
      xValueList.add(pointInfo.chartDataPoint?.xValue);
    }
    String seriesType;
    bool isRangeTypeSeries;
    if (xValueList.isNotEmpty) {
      for (int count = 0; count < xValueList.length; count++) {
        if (xValueList[0] != xValueList[count]) {
          final List<ChartPointInfo> leastPointInfo = <ChartPointInfo>[];
          for (final ChartPointInfo pointInfo in chartPointInfo) {
            if (pointInfo.xPosition == leastX) {
              leastPointInfo.add(pointInfo);
              if (!(trackballBehavior.tooltipDisplayMode ==
                      TrackballDisplayMode.floatAllPoints &&
                  leastPointInfo.length > 1 &&
                  pointInfo.seriesIndex !=
                      leastPointInfo[leastPointInfo.length - 2].seriesIndex))
                visiblePoints.clear();
              seriesType = pointInfo.seriesRendererDetails!.seriesType;
              isRangeTypeSeries = seriesType.contains('range') ||
                  seriesType.contains('hilo') ||
                  seriesType == 'candle';
              visiblePoints.add(ClosestPoints(
                  closestPointX: !isRangeTypeSeries
                      ? pointInfo.xPosition!
                      : seriesType == 'boxandwhisker'
                          ? pointInfo.maxXPosition!
                          : pointInfo.highXPosition!,
                  closestPointY: isRangeTypeSeries
                      ? pointInfo.highYPosition!
                      : seriesType == 'boxandwhisker'
                          ? pointInfo.maxYPosition!
                          : pointInfo.yPosition!));
            }
          }
          chartPointInfo.clear();
          chartPointInfo = leastPointInfo;
        }
      }
    }
  }

  /// To get the lowest x value to render trackball
  double _getLeastX(
      List<CartesianChartPoint<dynamic>> dataPoints,
      ChartPointInfo pointInfo,
      SeriesRendererDetails seriesRendererDetails,
      Rect axisClipRect) {
    return calculatePoint(
            dataPoints[pointInfo.dataPointIndex!].xValue,
            0,
            seriesRendererDetails.xAxisDetails!,
            seriesRendererDetails.yAxisDetails!,
            _stateProperties.requireInvertedAxis,
            seriesRendererDetails.series,
            axisClipRect)
        .x;
  }

  /// To render the trackball marker
  void renderTrackballMarker(SeriesRendererDetails seriesRendererDetails,
      Canvas canvas, TrackballBehavior trackballBehavior, int index) {
    final CartesianChartPoint<dynamic> point = trackballBehavior
        ._stateProperties
        .trackballBehaviorRenderer
        ._trackballRenderingDetails
        .chartPointInfo[index]
        .chartDataPoint!;
    final TrackballMarkerSettings markerSettings =
        trackballBehavior.markerSettings!;
    final RenderingDetails renderingDetails =
        seriesRendererDetails.stateProperties.renderingDetails;
    if (markerSettings.shape == DataMarkerType.image) {
      drawImageMarker(null, canvas, chartPointInfo[index].markerXPos!,
          chartPointInfo[index].markerYPos!, markerSettings, _stateProperties);
    }
    final Paint strokePaint = Paint()
      ..color = trackballBehavior.markerSettings!.borderWidth == 0
          ? Colors.transparent
          : ((point.pointColorMapper != null)
              ? point.pointColorMapper!
              : markerSettings.borderColor ??
                  seriesRendererDetails.seriesColor!)
      ..strokeWidth = markerSettings.borderWidth
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = markerSettings.color ??
          (renderingDetails.chartTheme.brightness == Brightness.light
              ? Colors.white
              : Colors.black)
      ..style = PaintingStyle.fill;
    canvas.drawPath(markerShapes[index], strokePaint);
    canvas.drawPath(markerShapes[index], fillPaint);
  }

  /// To add chart point info
  void _addChartPointInfo(
      SeriesRendererDetails seriesRendererDetails,
      double xPos,
      double yPos,
      int dataPointIndex,
      String? label,
      int seriesIndex,
      [double? lowYPos,
      double? highXPos,
      double? highYPos,
      double? openXPos,
      double? openYPos,
      double? closeXPos,
      double? closeYPos,
      double? minYPos,
      double? maxXPos,
      double? maxYPos,
      double? lowerXPos,
      double? lowerYPos,
      double? upperXPos,
      double? upperYPos]) {
    final ChartPointInfo pointInfo = ChartPointInfo();

    pointInfo.seriesRendererDetails = seriesRendererDetails;
    pointInfo.series = seriesRendererDetails.series;
    pointInfo.markerXPos = xPos;
    pointInfo.markerYPos = yPos;
    pointInfo.xPosition = xPos;
    pointInfo.yPosition = yPos;
    pointInfo.seriesIndex = seriesIndex;

    if (seriesRendererDetails.seriesType.contains('hilo') == true ||
        seriesRendererDetails.seriesType.contains('range') == true ||
        seriesRendererDetails.seriesType == 'candle') {
      pointInfo.lowYPosition = lowYPos!;
      pointInfo.highXPosition = highXPos!;
      pointInfo.highYPosition = highYPos!;
      if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
          seriesRendererDetails.seriesType == 'candle') {
        pointInfo.openXPosition = openXPos!;
        pointInfo.openYPosition = openYPos!;
        pointInfo.closeXPosition = closeXPos!;
        pointInfo.closeYPosition = closeYPos!;
      }
    } else if (seriesRendererDetails.seriesType.contains('boxandwhisker') ==
        true) {
      pointInfo.minYPosition = minYPos!;
      pointInfo.maxYPosition = maxYPos!;
      pointInfo.maxXPosition = maxXPos!;
      pointInfo.lowerXPosition = lowerXPos!;
      pointInfo.lowerYPosition = lowerYPos!;
      pointInfo.upperXPosition = upperXPos!;
      pointInfo.upperYPosition = upperYPos!;
    }

    if (seriesRendererDetails.segments.length > dataPointIndex) {
      pointInfo.color = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[dataPointIndex])
          .color!;
    } else if (seriesRendererDetails.segments.length > 1) {
      pointInfo.color = SegmentHelper.getSegmentProperties(seriesRendererDetails
              .segments[seriesRendererDetails.segments.length - 1])
          .color!;
    }
    final List<CartesianChartPoint<dynamic>> dataPoints =
        getSampledData(seriesRendererDetails);
    pointInfo.chartDataPoint = dataPoints[dataPointIndex];
    pointInfo.dataPointIndex = dataPointIndex;
    if (!isTrackballTemplate) {
      pointInfo.label = label!;
      pointInfo.header =
          _getHeaderText(dataPoints[dataPointIndex], seriesRendererDetails);
    }
    chartPointInfo.add(pointInfo);
  }

  /// Method to place the collided tooltips properly
  TooltipPositions smartTooltipPositions(
      List<num> tooltipTop,
      List<num> tooltipBottom,
      List<ChartAxisRenderer> xAxesInfo,
      List<ChartAxisRenderer> yAxesInfo,
      List<ChartPointInfo> chartPointInfo,
      bool requireInvertedAxis,
      [bool? isPainterTooltip]) {
    _tooltipPadding = _stateProperties.requireInvertedAxis ? 8 : 5;
    num tooltipWidth = 0;
    TooltipPositions tooltipPosition;
    for (int i = 0; i < chartPointInfo.length; i++) {
      requireInvertedAxis
          ? _visibleLocation.add(chartPointInfo[i].xPosition!)
          : _visibleLocation.add((chartPointInfo[i]
                          .seriesRendererDetails!
                          .seriesType
                          .contains('range') ==
                      true ||
                  chartPointInfo[i]
                          .seriesRendererDetails!
                          .seriesType
                          .contains('hilo') ==
                      true ||
                  chartPointInfo[i].seriesRendererDetails!.seriesType ==
                      'candle')
              ? chartPointInfo[i].highYPosition!
              : chartPointInfo[i].seriesRendererDetails!.seriesType ==
                      'boxandwhisker'
                  ? chartPointInfo[i].maxYPosition!
                  : chartPointInfo[i].yPosition!);

      tooltipWidth += tooltipBottom[i] - tooltipTop[i] + _tooltipPadding;
    }
    tooltipPosition = _continuousOverlappingPoints(
        tooltipTop, tooltipBottom, _visibleLocation);

    if (!requireInvertedAxis
        ? tooltipWidth < (_axisClipRect.bottom - _axisClipRect.top)
        : tooltipWidth < (_axisClipRect.right - _axisClipRect.left)) {
      tooltipPosition =
          _verticalArrangements(tooltipPosition, xAxesInfo, yAxesInfo);
    }
    return tooltipPosition;
  }

  TooltipPositions _verticalArrangements(TooltipPositions tooltipPPosition,
      List<ChartAxisRenderer> xAxesInfo, List<ChartAxisRenderer> yAxesInfo) {
    final TooltipPositions tooltipPosition = tooltipPPosition;
    num? startPos, chartHeight;
    final bool isTransposed = _stateProperties.requireInvertedAxis;
    num secWidth, width;
    final int length = tooltipPosition.tooltipTop.length;
    ChartAxisRenderer yAxisRenderer;
    final int axesLength =
        _stateProperties.chartAxis.axisRenderersCollection.length;
    for (int i = length - 1; i >= 0; i--) {
      yAxisRenderer = yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            _stateProperties.chartAxis.axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = _axisClipRect.right;
            startPos = _axisClipRect.left;
          } else {
            chartHeight = _axisClipRect.bottom - _axisClipRect.top;
            startPos = _axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (chartHeight != null &&
          chartHeight < tooltipPosition.tooltipBottom[i]) {
        tooltipPosition.tooltipBottom[i] = chartHeight - 2;
        tooltipPosition.tooltipTop[i] =
            tooltipPosition.tooltipBottom[i] - width;
        for (int j = i - 1; j >= 0; j--) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipBottom[j] >
                  tooltipPosition.tooltipTop[j + 1] &&
              (tooltipPosition.tooltipTop[j + 1] > startPos! &&
                  tooltipPosition.tooltipBottom[j + 1] < chartHeight)) {
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j + 1] - _tooltipPadding;
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j] - secWidth;
          }
        }
      }
    }
    for (int i = 0; i < length; i++) {
      yAxisRenderer = yAxesInfo[i];
      for (int k = 0; k < axesLength; k++) {
        if (yAxisRenderer ==
            _stateProperties.chartAxis.axisRenderersCollection[k]) {
          if (isTransposed) {
            chartHeight = _axisClipRect.right;
            startPos = _axisClipRect.left;
          } else {
            chartHeight = _axisClipRect.bottom - _axisClipRect.top;
            startPos = _axisClipRect.top;
          }
        }
      }
      width = tooltipPosition.tooltipBottom[i] - tooltipPosition.tooltipTop[i];
      if (startPos != null && tooltipPosition.tooltipTop[i] < startPos) {
        tooltipPosition.tooltipTop[i] = startPos + 1;
        tooltipPosition.tooltipBottom[i] =
            tooltipPosition.tooltipTop[i] + width;
        for (int j = i + 1; j <= (length - 1); j++) {
          secWidth =
              tooltipPosition.tooltipBottom[j] - tooltipPosition.tooltipTop[j];
          if (tooltipPosition.tooltipTop[j] <
                  tooltipPosition.tooltipBottom[j - 1] &&
              (tooltipPosition.tooltipTop[j - 1] > startPos &&
                  tooltipPosition.tooltipBottom[j - 1] < chartHeight!)) {
            tooltipPosition.tooltipTop[j] =
                tooltipPosition.tooltipBottom[j - 1] + _tooltipPadding;
            tooltipPosition.tooltipBottom[j] =
                tooltipPosition.tooltipTop[j] + secWidth;
          }
        }
      }
    }
    return tooltipPosition;
  }

  // Method to identify the colliding trackball tooltips and return the new tooltip positions
  TooltipPositions _continuousOverlappingPoints(List<num> tooltipTop,
      List<num> tooltipBottom, List<num> visibleLocation) {
    num temp,
        count = 0,
        start = 0,
        halfHeight,
        midPos,
        tempTooltipHeight,
        temp1TooltipHeight;
    int startPoint = 0, i, j, k;
    final num endPoint = tooltipBottom.length - 1;
    num tooltipHeight = (tooltipBottom[0] - tooltipTop[0]) + _tooltipPadding;
    temp = tooltipTop[0] + tooltipHeight;
    start = tooltipTop[0];
    for (i = 0; i < endPoint; i++) {
      // To identify that tooltip collides or not
      if (temp >= tooltipTop[i + 1]) {
        tooltipHeight =
            tooltipBottom[i + 1] - tooltipTop[i + 1] + _tooltipPadding;
        temp += tooltipHeight;
        count++;
        // This condition executes when the tooltip count is half of the total number of tooltips
        if (count - 1 == endPoint - 1 || i == endPoint - 1) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i + 1]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }
          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
        }
      } else {
        count = i > 0 ? count : 0;
        // This exectutes when any of the middle tooltip collides
        if (count > 0) {
          halfHeight = (temp - start) / 2;
          midPos = (visibleLocation[startPoint] + visibleLocation[i]) / 2;
          tempTooltipHeight =
              tooltipBottom[startPoint] - tooltipTop[startPoint];
          tooltipTop[startPoint] = midPos - halfHeight;
          tooltipBottom[startPoint] =
              tooltipTop[startPoint] + tempTooltipHeight;
          for (k = startPoint; k > 0; k--) {
            if (tooltipTop[k] <= tooltipBottom[k - 1] + _tooltipPadding) {
              temp1TooltipHeight = tooltipBottom[k - 1] - tooltipTop[k - 1];
              tooltipTop[k - 1] =
                  tooltipTop[k] - temp1TooltipHeight - _tooltipPadding;
              tooltipBottom[k - 1] = tooltipTop[k - 1] + temp1TooltipHeight;
            } else {
              break;
            }
          }

          // To set tool tip positions based on the half height and other tooltip height
          for (j = startPoint + 1; j <= startPoint + count; j++) {
            tempTooltipHeight = tooltipBottom[j] - tooltipTop[j];
            tooltipTop[j] = tooltipBottom[j - 1] + _tooltipPadding;
            tooltipBottom[j] = tooltipTop[j] + tempTooltipHeight;
          }
          count = 0;
        }
        tooltipHeight =
            (tooltipBottom[i + 1] - tooltipTop[i + 1]) + _tooltipPadding;
        temp = tooltipTop[i + 1] + tooltipHeight;
        start = tooltipTop[i + 1];
        startPoint = i + 1;
      }
    }
    return TooltipPositions(tooltipTop, tooltipBottom);
  }

  /// To get and return label text of the trackball
  String _getTrackballLabelText(
      SeriesRendererDetails seriesRendererDetails,
      num? xValue,
      num? yValue,
      num? lowValue,
      num? highValue,
      num? openValue,
      num? closeValue,
      num? minValue,
      num? maxValue,
      num? lowerQuartileValue,
      num? upperQuartileValue,
      num? meanValue,
      String seriesName,
      num? bubbleSize,
      num? cumulativeValue,
      CartesianChartPoint<dynamic> dataPoint) {
    String labelValue;
    final int digits = trackballBehavior.tooltipSettings.decimalPlaces;
    final ChartAxis yAxis = seriesRendererDetails.yAxisDetails!.axis;
    if (trackballBehavior.tooltipSettings.format != null) {
      dynamic x;
      final ChartAxisRendererDetails axisDetails =
          seriesRendererDetails.xAxisDetails!;
      if (axisDetails is DateTimeAxisDetails) {
        final num interval = axisDetails.visibleRange!.minimum.ceil();
        final num prevInterval = (axisDetails.visibleLabels.isNotEmpty)
            ? axisDetails
                .visibleLabels[axisDetails.visibleLabels.length - 1].value
            : interval;
        final DateFormat dateFormat =
            (axisDetails.axis as DateTimeAxis).dateFormat ??
                getDateTimeLabelFormat(axisDetails.axisRenderer,
                    interval.toInt(), prevInterval.toInt());
        x = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(xValue! as int));
      } else if (axisDetails is CategoryAxisDetails) {
        x = dataPoint.x;
      } else if (axisDetails is DateTimeCategoryAxisDetails) {
        final num interval = axisDetails.visibleRange!.minimum.ceil();
        final num prevInterval = (axisDetails.visibleLabels.isNotEmpty)
            ? axisDetails
                .visibleLabels[axisDetails.visibleLabels.length - 1].value
            : interval;
        final DateFormat dateFormat =
            (axisDetails.axis as DateTimeCategoryAxis).dateFormat ??
                getDateTimeLabelFormat(axisDetails.axisRenderer,
                    interval.toInt(), prevInterval.toInt());
        x = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
            (dataPoint.x).millisecondsSinceEpoch));
      }
      labelValue = seriesRendererDetails.seriesType.contains('hilo') == true ||
              seriesRendererDetails.seriesType.contains('range') == true ||
              seriesRendererDetails.seriesType.contains('candle') == true ||
              seriesRendererDetails.seriesType.contains('boxandwhisker') == true
          ? seriesRendererDetails.seriesType.contains('boxandwhisker') == true
              ? (trackballBehavior.tooltipSettings.format!
                  .replaceAll('point.x', (x ?? xValue).toString())
                  .replaceAll('point.minimum', minValue.toString())
                  .replaceAll('point.maximum', maxValue.toString())
                  .replaceAll(
                      'point.lowerQuartile', lowerQuartileValue.toString())
                  .replaceAll(
                      'point.upperQuartile', upperQuartileValue.toString())
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', seriesName))
              : seriesRendererDetails.seriesType == 'hilo' ||
                      seriesRendererDetails.seriesType.contains('range') == true
                  ? (trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.high', highValue.toString())
                      .replaceAll('point.low', lowValue.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName))
                  : (trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.high', highValue.toString())
                      .replaceAll('point.low', lowValue.toString())
                      .replaceAll('point.open', openValue.toString())
                      .replaceAll('point.close', closeValue.toString())
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName))
          : seriesRendererDetails.seriesType == 'bubble'
              ? (trackballBehavior.tooltipSettings.format!
                  .replaceAll('point.x', (x ?? xValue).toString())
                  .replaceAll(
                      'point.y',
                      getLabelValue(yValue,
                          seriesRendererDetails.yAxisDetails!.axis, digits))
                  .replaceAll('{', '')
                  .replaceAll('}', '')
                  .replaceAll('series.name', seriesName)
                  .replaceAll('point.size', bubbleSize.toString()))
              : seriesRendererDetails.seriesType.contains('stacked') == true
                  ? (trackballBehavior.tooltipSettings.format!
                      .replaceAll('point.x', (x ?? xValue).toString())
                      .replaceAll('point.y', getLabelValue(yValue, seriesRendererDetails.yAxisDetails!.axis, digits))
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('series.name', seriesName)
                      .replaceAll('point.cumulativeValue', cumulativeValue.toString()))
                  : (trackballBehavior.tooltipSettings.format!.replaceAll('point.x', (x ?? xValue).toString()).replaceAll('point.y', getLabelValue(yValue, seriesRendererDetails.yAxisDetails!.axis, digits)).replaceAll('{', '').replaceAll('}', '').replaceAll('series.name', seriesName));
    } else {
      labelValue = seriesRendererDetails.seriesType.contains('range') ==
                  false &&
              seriesRendererDetails.seriesType.contains('candle') == false &&
              seriesRendererDetails.seriesType.contains('hilo') == false &&
              seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                  false
          ? getLabelValue(yValue, yAxis, digits)
          : seriesRendererDetails.seriesType == 'hiloopenclose' ||
                  seriesRendererDetails.seriesType.contains('candle') == true ||
                  seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                      true
              ? seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                      true
                  ? 'Maximum : ${getLabelValue(maxValue, yAxis)}\nMinimum : ${getLabelValue(minValue, yAxis)}\nLowerQuartile : ${getLabelValue(lowerQuartileValue, yAxis)}\nUpperQuartile : ${getLabelValue(upperQuartileValue, yAxis)}'
                  : 'High : ${getLabelValue(highValue, yAxis)}\nLow : ${getLabelValue(lowValue, yAxis)}\nOpen : ${getLabelValue(openValue, yAxis)}\nClose : ${getLabelValue(closeValue, yAxis)}'
              : 'High : ${getLabelValue(highValue, yAxis)}\nLow : ${getLabelValue(lowValue, yAxis)}';
    }
    return labelValue;
  }

  /// To get header text of trackball
  String _getHeaderText(CartesianChartPoint<dynamic> point,
      SeriesRendererDetails seriesRendererDetails) {
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    String headerText;
    String? date;
    if (xAxisDetails is DateTimeAxisDetails) {
      final DateTimeAxis xAxis = xAxisDetails.axis as DateTimeAxis;
      final num interval = xAxisDetails.visibleRange!.minimum.ceil();
      final num prevInterval = (xAxisDetails.visibleLabels.isNotEmpty)
          ? xAxisDetails
              .visibleLabels[xAxisDetails.visibleLabels.length - 1].value
          : interval;
      final DateFormat dateFormat = xAxis.dateFormat ??
          getDateTimeLabelFormat(xAxisDetails.axisRenderer, interval.toInt(),
              prevInterval.toInt());
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    }
    headerText = xAxisDetails is CategoryAxisDetails
        ? point.x.toString()
        : xAxisDetails is DateTimeAxisDetails
            ? date!.toString()
            : (xAxisDetails is DateTimeCategoryAxisDetails
                ? xAxisDetails.getFormattedLabel(
                    '${point.x.microsecondsSinceEpoch}',
                    xAxisDetails.dateFormat)
                : getLabelValue(point.xValue, xAxisDetails.axis,
                    _chart.tooltipBehavior.decimalPlaces));
    return headerText;
  }

  /// To draw trackball line
  void drawLine(Canvas canvas, Paint? paint, int seriesIndex) {
    assert(trackballBehavior.lineWidth >= 0,
        'Line width value of trackball should be greater than 0.');
    if (trackballPainter != null && paint != null) {
      trackballPainter!.drawTrackBallLine(canvas, paint, seriesIndex);
    }
  }

  /// Returns the track line painter
  Paint? linePainter(Paint paint) => trackballPainter?.getLinePainter(paint);

  /// Trackball show by index
  void internalShowByIndex(
    int pointIndex,
  ) {
    final CartesianStateProperties stateProperties = _stateProperties;
    final TrackballRenderingDetails trackballRenderingDetails =
        TrackballHelper.getRenderingDetails(
            _stateProperties.trackballBehaviorRenderer);
    if (trackballRenderingDetails.trackballPainter != null ||
        _chart.trackballBehavior.builder != null) {
      if (validIndex(pointIndex, 0, stateProperties.chart)) {
        trackballRenderingDetails.showTrackball(
            stateProperties.chartSeries.visibleSeriesRenderers,
            pointIndex,
            _stateProperties.trackballBehaviorRenderer);
      }
      if (trackballRenderingDetails.trackballPainter != null) {
        trackballRenderingDetails.trackballPainter!.canResetPath = false;
        trackballRenderingDetails.trackballPainter!.stateProperties
            .repaintNotifiers['trackball']!.value++;
      }
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the trackball rendering details instance from its renderer
class TrackballHelper {
  /// Returns the trackball rendering details instance from its renderer
  static TrackballRenderingDetails getRenderingDetails(
      TrackballBehaviorRenderer renderer) {
    return renderer._trackballRenderingDetails;
  }

  /// Returns the cartesian state properties from its instance
  static CartesianStateProperties getStateProperties(
      TrackballBehavior trackballBehavior) {
    return trackballBehavior._stateProperties;
  }

  /// Method to set the cartesian state properties
  static void setStateProperties(TrackballBehavior trackballBehavior,
      CartesianStateProperties stateProperties) {
    trackballBehavior._stateProperties = stateProperties;
  }
}
