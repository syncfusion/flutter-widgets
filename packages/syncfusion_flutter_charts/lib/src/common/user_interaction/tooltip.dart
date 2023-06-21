import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/tooltip_internal.dart';

import '../../../charts.dart';
import '../../chart/axis/axis.dart';
import '../../chart/axis/category_axis.dart';
import '../../chart/axis/datetime_category_axis.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/chart_series/xy_data_series.dart';
import '../../chart/utils/helper.dart';
import '../rendering_details.dart';
import 'tooltip_rendering_details.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Customizes the tooltip.
///
/// This class provides options for customizing the properties of the tooltip.
class TooltipBehavior {
  /// Creating an argument constructor of TooltipBehavior class.
  TooltipBehavior(
      {this.textStyle,
      ActivationMode? activationMode,
      int? animationDuration,
      bool? enable,
      double? opacity,
      Color? borderColor,
      double? borderWidth,
      double? duration,
      bool? shouldAlwaysShow,
      double? elevation,
      bool? canShowMarker,
      ChartAlignment? textAlignment,
      int? decimalPlaces,
      TooltipPosition? tooltipPosition,
      bool? shared,
      this.color,
      this.header,
      this.format,
      this.builder,
      this.shadowColor})
      : animationDuration = animationDuration ?? 350,
        textAlignment = textAlignment ?? ChartAlignment.center,
        activationMode = activationMode ?? ActivationMode.singleTap,
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0,
        duration = duration ?? 3000,
        enable = enable ?? false,
        opacity = opacity ?? 1,
        shouldAlwaysShow = shouldAlwaysShow ?? false,
        canShowMarker = canShowMarker ?? true,
        tooltipPosition = tooltipPosition ?? TooltipPosition.auto,
        elevation = elevation ?? 2.5,
        decimalPlaces = decimalPlaces ?? 3,
        shared = shared ?? false;

  /// Toggles the visibility of the tooltip.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Color of the tooltip.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     color: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Header of the tooltip. By default, the series name will be displayed in the header.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     header: 'Default'
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final String? header;

  /// Opacity of the tooltip.
  ///
  /// The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     opacity: 0.7
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double opacity;

  /// Customizes the tooltip text.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     textStyle: TextStyle(
  ///       color: Colors.green
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Specifies the number decimals to be displayed in tooltip text.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     decimalPlaces: 1
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final int decimalPlaces;

  /// Formats the tooltip text.
  ///
  /// By default, the tooltip will be rendered with x and y-values.
  ///
  /// You can add prefix or suffix to x, y, and series name values in the
  /// tooltip by formatting them.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     format:'point.y %'
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final String? format;

  /// Duration for animating the tooltip.
  ///
  /// Defaults to `350`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     animationDuration: 1000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final int animationDuration;

  /// Toggles the visibility of the marker in the tooltip.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     canShowMarker: false
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool canShowMarker;

  /// Gesture for activating the tooltip.
  ///
  /// Tooltip can be activated in tap, double tap, and long press.
  ///
  /// Defaults to `ActivationMode.tap`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Border color of the tooltip.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     borderColor: Colors.red,
  ///     borderWidth: 3
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the tooltip.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     borderColor: Colors.red,
  ///     borderWidth: 3
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Builder of the tooltip.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
  ///       return Container(
  ///         height: 50,
  ///         width: 100,
  ///         decoration: const BoxDecoration(
  ///           color: Color.fromRGBO(66, 244, 164, 1),
  ///           child: Text('$pointIndex')
  ///         )
  ///       );
  ///     }
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  ///```
  final ChartWidgetBuilder<dynamic>? builder;

  /// Color of the tooltip shadow.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shadowColor: Colors.green
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color? shadowColor;

  /// Elevation of the tooltip.
  ///
  /// Defaults to `2.5`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     elevation: 10
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double elevation;

  /// Shows or hides the tooltip.
  ///
  /// By default, the tooltip will be hidden on touch. To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Duration for displaying the tooltip.
  ///
  /// Defaults to `3000`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     duration: 1000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double duration;

  /// Alignment of the text in the tooltip.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     textAlignment : ChartAlignment.near
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final ChartAlignment textAlignment;

  /// Show tooltip at tapped position.
  ///
  /// Defaults to `TooltipPosition.auto`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     tooltipPosition: TooltipPosition.pointer
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final TooltipPosition tooltipPosition;

  /// Share the tooltip with same index points.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shared: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool shared;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is TooltipBehavior &&
        other.textStyle == textStyle &&
        other.activationMode == activationMode &&
        other.animationDuration == animationDuration &&
        other.enable == enable &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.duration == duration &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.elevation == elevation &&
        other.canShowMarker == canShowMarker &&
        other.textAlignment == textAlignment &&
        other.decimalPlaces == decimalPlaces &&
        other.tooltipPosition == tooltipPosition &&
        other.shared == shared &&
        other.color == color &&
        other.header == header &&
        other.format == format &&
        other.builder == builder &&
        other.shadowColor == shadowColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      textStyle,
      activationMode,
      animationDuration,
      enable,
      opacity,
      borderColor,
      borderWidth,
      duration,
      shouldAlwaysShow,
      elevation,
      canShowMarker,
      textAlignment,
      decimalPlaces,
      tooltipPosition,
      shared,
      color,
      header,
      format,
      builder,
      shadowColor
    ];
    return Object.hashAll(values);
  }

  /// Holds the state properties value.
  dynamic _stateProperties;

  /// Displays the tooltip at the specified x and y-positions.
  ///
  /// * x & y - logical pixel values to position the tooltip.
  void showByPixel(double x, double y) {
    if (_stateProperties != null) {
      final TooltipRenderingDetails renderingDetails =
          TooltipHelper.getRenderingDetails(
              _stateProperties.renderingDetails.tooltipBehaviorRenderer);
      renderingDetails.internalShowByPixel(x, y);
    }
  }

  /// Displays the tooltip at the specified x and y-values.
  ///
  ///
  /// *x & y - x & y point values at which the tooltip needs to be shown.
  ///
  /// * xAxisName - name of the x axis the given point must be bind to.
  ///
  /// * yAxisName - name of the y axis the given point must be bind to.
  void show(dynamic x, double y, [String? xAxisName, String? yAxisName]) {
    if (_stateProperties != null &&
        _stateProperties.chart is SfCartesianChart) {
      final dynamic chart = _stateProperties.chart;
      final RenderingDetails renderingDetails =
          _stateProperties.renderingDetails;
      final TooltipBehaviorRenderer tooltipBehaviorRenderer =
          renderingDetails.tooltipBehaviorRenderer;
      bool? isInsidePointRegion = false;
      ChartAxisRendererDetails? xAxisDetails, yAxisDetails;
      if (xAxisName != null && yAxisName != null) {
        for (final ChartAxisRenderer axisRenderer
            in _stateProperties.chartAxis.axisRenderersCollection) {
          final ChartAxisRendererDetails axisDetails =
              AxisHelper.getAxisRendererDetails(axisRenderer);
          if (axisDetails.name == xAxisName) {
            xAxisDetails = axisDetails;
          } else if (axisDetails.name == yAxisName) {
            yAxisDetails = axisDetails;
          }
        }
      } else {
        xAxisDetails = _stateProperties.chartAxis.primaryXAxisDetails;
        yAxisDetails = _stateProperties.chartAxis.primaryYAxisDetails;
      }
      final ChartLocation position = calculatePoint(
          (x is DateTime &&
                  (xAxisDetails! is DateTimeCategoryAxisDetails) == false)
              ? x.millisecondsSinceEpoch
              : ((x is DateTime && xAxisDetails! is DateTimeCategoryAxisDetails)
                  ? (xAxisDetails as DateTimeCategoryAxisDetails)
                      .labels
                      .indexOf(xAxisDetails.dateFormat.format(x))
                  : ((x is String && xAxisDetails is CategoryAxisDetails)
                      ? xAxisDetails.labels.indexOf(x)
                      : x)),
          y,
          xAxisDetails!,
          yAxisDetails!,
          _stateProperties.requireInvertedAxis,
          null,
          _stateProperties.chartAxis.axisClipRect);
      for (int i = 0;
          i < _stateProperties.chartSeries.visibleSeriesRenderers.length;
          i++) {
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(
                _stateProperties.chartSeries.visibleSeriesRenderers[i]);
        if (seriesRendererDetails.visible! == true &&
            seriesRendererDetails.series.enableTooltip == true &&
            seriesRendererDetails.regionalData != null) {
          final double padding = (seriesRendererDetails.seriesType ==
                      'bubble' ||
                  seriesRendererDetails.seriesType == 'scatter' ||
                  seriesRendererDetails.seriesType.contains('column') == true ||
                  seriesRendererDetails.seriesType.contains('bar') == true)
              ? 0
              : 15; // regional padding to detect smooth touch
          seriesRendererDetails.regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final Rect region = regionRect[0];
            final Rect paddedRegion = Rect.fromLTRB(
                region.left - padding,
                region.top - padding,
                region.right + padding,
                region.bottom + padding);
            if (paddedRegion.contains(Offset(position.x, position.y))) {
              isInsidePointRegion = true;
            }
          });
        }
      }
      if (chart.tooltipBehavior.builder != null && x != null) {
        renderingDetails.tooltipBehaviorRenderer._tooltipRenderingDetails
            .showTemplateTooltip(Offset(position.x, position.y));
      } else if (renderingDetails.tooltipBehaviorRenderer
              ._tooltipRenderingDetails.tooltipTemplate ==
          null) {
        final SfTooltipState? tooltipState =
            tooltipBehaviorRenderer._tooltipRenderingDetails.chartTooltipState;
        if (isInsidePointRegion ?? false) {
          tooltipBehaviorRenderer._tooltipRenderingDetails
              .showTooltip(position.x, position.y);
        } else {
          // To show tooltip when the position is out of point region.
          tooltipBehaviorRenderer._tooltipRenderingDetails.show = true;
          tooltipState?.needMarker = false;
          renderingDetails.tooltipBehaviorRenderer._tooltipRenderingDetails
              .showChartAreaTooltip(Offset(position.x, position.y),
                  xAxisDetails, yAxisDetails, chart);
        }
      }
      tooltipBehaviorRenderer._tooltipRenderingDetails.isInteraction = false;
    }
  }

  /// Displays the tooltip at the specified series and point index.
  ///
  /// * seriesIndex - index of the series for which the pointIndex is specified
  ///
  /// * pointIndex - index of the point for which the tooltip should be shown
  void showByIndex(int seriesIndex, int pointIndex) {
    if (_stateProperties != null) {
      final TooltipRenderingDetails renderingDetails =
          TooltipHelper.getRenderingDetails(
              _stateProperties.renderingDetails.tooltipBehaviorRenderer);
      renderingDetails.internalShowByIndex(seriesIndex, pointIndex);
    }
  }

  /// Hides the tooltip if it is displayed.
  void hide() {
    if (_stateProperties != null) {
      final TooltipBehaviorRenderer tooltipBehaviorRenderer =
          _stateProperties.renderingDetails.tooltipBehaviorRenderer;
      // ignore: unnecessary_null_comparison
      if (tooltipBehaviorRenderer != null) {
        tooltipBehaviorRenderer._tooltipRenderingDetails.showLocation = null;
        tooltipBehaviorRenderer._tooltipRenderingDetails.show = false;
      }
      if (builder != null) {
        // Hides tooltip template.
        tooltipBehaviorRenderer._tooltipRenderingDetails.chartTooltipState
            ?.hide(hideDelay: 0);
      } else {
        // Hides default tooltip.
        tooltipBehaviorRenderer._tooltipRenderingDetails.currentTooltipValue =
            tooltipBehaviorRenderer._tooltipRenderingDetails.prevTooltipValue =
                null;

        tooltipBehaviorRenderer._tooltipRenderingDetails.chartTooltipState
            ?.hide(hideDelay: 0);
      }
    }
  }
}

/// Tooltip behavior renderer class for mutable fields and methods.
class TooltipBehaviorRenderer with ChartBehavior {
  /// Creates an argument constructor for Tooltip renderer class.
  TooltipBehaviorRenderer(this._stateProperties) {
    _tooltipRenderingDetails = TooltipRenderingDetails(_stateProperties);
  }

  final dynamic _stateProperties;

  /// Specifies the rendering details of tooltip.
  late TooltipRenderingDetails _tooltipRenderingDetails;

  /// Hides the Mouse tooltip if it is displayed.
  void _hideMouseTooltip() => _tooltipRenderingDetails.hide();

  /// Draws tooltip.
  ///
  /// * canvas -Canvas used to draw tooltip
  @override
  void onPaint(Canvas canvas) {}

  /// Performs the double-tap action of appropriate point.
  ///
  /// Hits while double tapping on the chart.
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onDoubleTap(double xPos, double yPos) =>
      _tooltipRenderingDetails.tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the double-tap action of appropriate point.
  ///
  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onLongPress(double xPos, double yPos) =>
      _tooltipRenderingDetails.tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the touch-down action of appropriate point.
  ///
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchDown(double xPos, double yPos) =>
      _tooltipRenderingDetails.tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the touch move action of chart.
  ///
  /// Hits while tap and moving on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// *  yPos - Y value of the touch position.
  @override
  void onTouchMove(double xPos, double yPos) {
    // Not valid for tooltip
  }

  /// Performs the touch move action of chart.
  ///
  /// Hits while release tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onTouchUp(double xPos, double yPos) =>
      _tooltipRenderingDetails.tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the mouse hover action of chart.
  ///
  /// Hits while enter tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onEnter(double xPos, double yPos) =>
      _tooltipRenderingDetails.tooltipBehavior.showByPixel(xPos, yPos);

  /// Performs the mouse exit action of chart.
  ///
  /// Hits while exit tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  @override
  void onExit(double xPos, double yPos) {
    if (_tooltipRenderingDetails.renderBox != null &&
        _tooltipRenderingDetails.tooltipBehavior.builder != null) {
      _hideMouseTooltip();
    } else if (_tooltipRenderingDetails.tooltipTemplate != null) {
      //ignore: unused_local_variable
      _tooltipRenderingDetails.timer?.cancel();
      _tooltipRenderingDetails.timer = Timer(
          Duration(
              milliseconds:
                  _tooltipRenderingDetails.tooltipBehavior.duration.toInt()),
          () {});
    }
  }
}

/// Holds the tooltip series and point index.
///
/// This class is used to provide the [seriesIndex] and [pointIndex] for the Tooltip.
class TooltipValue {
  /// Creating an argument constructor of TooltipValue class.
  TooltipValue(this.seriesIndex, this.pointIndex, [this.outlierIndex]);

  /// Index of the series.
  final int? seriesIndex;

  /// Index of data points.
  final int pointIndex;

  /// Index of outlier points.
  final int? outlierIndex;

  /// Position of the pointer when the tooltip position mode is set as pointer.
  Offset? pointerPosition;

  @override
  //ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is TooltipValue) {
      return seriesIndex == other.seriesIndex &&
          pointIndex == other.pointIndex &&
          outlierIndex == other.outlierIndex &&
          (pointerPosition == null || pointerPosition == other.pointerPosition);
    } else {
      return false;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to get the cross hair rendering details instance from its renderer.
class TooltipHelper {
  /// Returns the cross hair rendering details instance from its renderer.
  static TooltipRenderingDetails getRenderingDetails(
      TooltipBehaviorRenderer renderer) {
    return renderer._tooltipRenderingDetails;
  }

  // /// Returns the Cartesian state properties from its instance
  // static CartesianStateProperties getStateProperties(
  //     CrosshairBehavior crosshairBehavior) {
  //   return crosshairBehavior._stateProperties;
  // }

  /// Method to set the Cartesian state properties.
  static void setStateProperties(
      TooltipBehavior tooltipBehavior, dynamic stateProperties) {
    tooltipBehavior._stateProperties = stateProperties;
  }
}
