import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';

import './../../common/event_args.dart' show MarkerRenderArgs;
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/waterfall_series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/data_label_renderer.dart';
import '../utils/helper.dart';
import 'common.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Customizes the markers.
///
/// Markers are used to provide information about the exact point location. You can add a shape to adorn each data point.
/// Markers can be enabled by using the [isVisible] property of [MarkerSettings].
///
/// Provides the options of [color], border width, border color and [shape] of the marker to customize the appearance.
///
@immutable
class MarkerSettings {
  /// Creating an argument constructor of MarkerSettings class.
  const MarkerSettings(
      {bool? isVisible,
      double? height = 8,
      double? width = 8,
      this.color,
      DataMarkerType? shape,
      double? borderWidth,
      this.borderColor,
      this.image})
      : isVisible = isVisible ?? false,
        height = height ?? 8,
        width = width ?? 8,
        shape = shape ?? DataMarkerType.circle,
        borderWidth = borderWidth ?? 2;

  /// Toggles the visibility of the marker.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(isVisible: true),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Height of the marker shape.
  ///
  /// Defaults to `4`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           height: 6
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double height;

  /// Width of the marker shape.
  ///
  /// Defaults to `4`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           width: 10
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double width;

  /// Color of the marker shape.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           color: Colors.red
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Shape of the marker.
  ///
  /// Defaults to `DataMarkerType.circle`.
  ///
  /// Also refer [DataMarkerType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           shape: DataMarkerType.rectangle
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final DataMarkerType shape;

  /// Border color of the marker.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 3
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Border width of the marker.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 3
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Image to be used as marker.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           shape: DataMarkerType.rectangle,
  ///           image: const AssetImage('images/bike.png')
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ImageProvider? image;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MarkerSettings &&
        other.isVisible == isVisible &&
        other.height == height &&
        other.width == width &&
        other.color == color &&
        other.shape == shape &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      height,
      width,
      color,
      shape,
      borderWidth,
      borderColor,
      image
    ];
    return Object.hashAll(values);
  }
}

/// To hold the individual point's marker details for the onMarkerRender event.
class MarkerDetails {
  /// Creates an argument constructor for MarkerDetails class.
  const MarkerDetails(
      {this.markerType,
      this.color,
      this.borderColor,
      this.borderWidth,
      this.size});

  /// Shape of the marker which is obtained from callback.
  final DataMarkerType? markerType;

  /// Color of the marker which is obtained from callback.
  final Color? color;

  /// Border color of the marker which is obtained from callback.
  final Color? borderColor;

  /// Border width of the marker which is obtained from callback.
  final double? borderWidth;

  /// Size of the marker which is obtained from callback.
  final Size? size;
}

/// Marker settings renderer class for mutable fields and methods.
class MarkerSettingsRenderer {
  /// Creates an argument constructor for MarkerSettings renderer class.
  MarkerSettingsRenderer(this.markerSettings) {
    color = markerSettings.color;

    borderColor = markerSettings.borderColor;

    borderWidth = markerSettings.borderWidth;
  }

  /// Holds the marker settings value.
  final MarkerSettings markerSettings;

  /// Holds the color value.
  // ignore: prefer_final_fields
  Color? color;

  /// Holds the value of border color
  Color? borderColor;

  /// Holds the value of border width.
  late double borderWidth;

  /// Holds the value of image.
  dart_ui.Image? image;

  /// Specifies the image drawn in the marker or not.
  bool isImageDrawn = false;

  /// To paint the marker here.
  void renderMarker(
      SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point,
      Animation<double>? animationController,
      Canvas canvas,
      int markerIndex,
      [int? outlierIndex]) {
    final List<CartesianChartPoint<dynamic>> dataPoints =
        getSampledData(seriesRendererDetails);
    final bool isDataPointVisible =
        isLabelWithinRange(seriesRendererDetails, dataPoints[markerIndex]);
    Paint strokePaint, fillPaint;
    final XyDataSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
    Size size = Size(series.markerSettings.width, series.markerSettings.height);
    CartesianChartPoint<dynamic> point;
    DataMarkerType markerType = series.markerSettings.shape;
    Color? seriesColor = seriesRendererDetails.seriesColor;
    point = dataPoints[markerIndex];
    if (seriesRendererDetails.seriesType == 'waterfall') {
      seriesColor = getWaterfallSeriesColor(
          seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>,
          point,
          seriesColor);
    }
    MarkerRenderArgs? event;
    borderColor = series.markerSettings.borderColor ?? seriesColor;
    color = series.markerSettings.color;
    borderWidth = series.markerSettings.borderWidth;
    final bool isMarkerEventTriggered =
        CartesianPointHelper.getIsMarkerEventTriggered(point);
    if (isDataPointVisible &&
        seriesRendererDetails.chart.onMarkerRender != null &&
        seriesRendererDetails.isMarkerRenderEvent == false) {
      if (animationController == null ||
          ((animationController.value == 0.0 &&
                  !isMarkerEventTriggered &&
                  animationController.status == AnimationStatus.forward) ||
              (seriesRendererDetails
                          .animationController.duration!.inMilliseconds ==
                      0 &&
                  !isMarkerEventTriggered))) {
        CartesianPointHelper.setIsMarkerEventTriggered(point, true);
        event = triggerMarkerRenderEvent(
            seriesRendererDetails,
            size,
            markerType,
            dataPoints[markerIndex].visiblePointIndex!,
            animationController)!;
        markerType = event.shape;
        borderColor = event.borderColor;
        color = event.color;
        borderWidth = event.borderWidth;
        size = Size(event.markerHeight, event.markerWidth);
        CartesianPointHelper.setMarkerDetails(
            point,
            MarkerDetails(
                markerType: markerType,
                borderColor: borderColor,
                color: color,
                borderWidth: borderWidth,
                size: size));
      }
    }
    final bool hasPointColor = series.pointColorMapper != null;
    final bool isBoxSeries =
        seriesRendererDetails.seriesType.contains('boxandwhisker');
    final double opacity = (animationController != null &&
            (seriesRendererDetails
                        .stateProperties.renderingDetails.initialRender! ==
                    true ||
                seriesRendererDetails.needAnimateSeriesElements == true))
        ? animationController.value
        : 1;
    final MarkerDetails? pointMarkerDetails =
        CartesianPointHelper.getMarkerDetails(point);
    !isBoxSeries
        ? seriesRendererDetails.markerShapes.add(isDataPointVisible
            ? getMarkerShapesPath(
                pointMarkerDetails?.markerType ?? markerType,
                Offset(point.markerPoint!.x, point.markerPoint!.y),
                pointMarkerDetails?.size ?? size,
                seriesRendererDetails,
                markerIndex,
                null,
                animationController)
            : null)
        : seriesRendererDetails.markerShapes.add(isDataPointVisible
            ? getMarkerShapesPath(
                pointMarkerDetails?.markerType ?? markerType,
                Offset(point.outliersPoint[outlierIndex!].x,
                    point.outliersPoint[outlierIndex].y),
                pointMarkerDetails?.size ?? size,
                seriesRendererDetails,
                markerIndex,
                null,
                animationController)
            : null);
    if (seriesRendererDetails.seriesType.contains('range') == true) {
      seriesRendererDetails.markerShapes2.add(isDataPointVisible
          ? getMarkerShapesPath(
              pointMarkerDetails?.markerType ?? markerType,
              Offset(point.markerPoint2!.x, point.markerPoint2!.y),
              pointMarkerDetails?.size ?? size,
              seriesRendererDetails,
              markerIndex,
              null,
              animationController)
          : null);
    }
    strokePaint = getStrokePaint(
        point,
        series,
        pointMarkerDetails,
        opacity,
        hasPointColor,
        seriesColor,
        markerType,
        seriesRendererDetails,
        animationController,
        size);

    fillPaint = getFillPaint(
        point, series, seriesRendererDetails, pointMarkerDetails, opacity);
    final bool isScatter = seriesRendererDetails.seriesType == 'scatter';
    final Rect axisClipRect =
        seriesRendererDetails.stateProperties.chartAxis.axisClipRect;

    // Render marker points.
    if ((series.markerSettings.isVisible || isScatter || isBoxSeries) &&
        point.isVisible &&
        withInRect(seriesRendererDetails, point.markerPoint, axisClipRect) &&
        (point.markerPoint != null ||
            // ignore: unnecessary_null_comparison
            point.outliersPoint[outlierIndex!] != null) &&
        point.isGap != true &&
        (!isScatter || series.markerSettings.shape == DataMarkerType.image) &&
        seriesRendererDetails
                .markerShapes[isBoxSeries ? outlierIndex! : markerIndex] !=
            null) {
      seriesRendererDetails.renderer.drawDataMarker(
          isBoxSeries ? outlierIndex! : markerIndex,
          canvas,
          fillPaint,
          strokePaint,
          isBoxSeries
              ? point.outliersPoint[outlierIndex!].x
              : point.markerPoint!.x,
          isBoxSeries
              ? point.outliersPoint[outlierIndex!].y
              : point.markerPoint!.y,
          seriesRendererDetails.renderer);
      if (series.markerSettings.shape == DataMarkerType.image) {
        drawImageMarker(
            seriesRendererDetails,
            canvas,
            isBoxSeries
                ? point.outliersPoint[outlierIndex!].x
                : point.markerPoint!.x,
            isBoxSeries
                ? point.outliersPoint[outlierIndex!].y
                : point.markerPoint!.y);
        if (seriesRendererDetails.seriesType.contains('range') == true ||
            seriesRendererDetails.seriesType == 'hilo') {
          drawImageMarker(seriesRendererDetails, canvas, point.markerPoint2!.x,
              point.markerPoint2!.y);
        }
      }
    }
    setMarkerEventTrigged(point, seriesRendererDetails, animationController);
  }

  ///  Method to set whether the marker is triggered
  void setMarkerEventTrigged(
    CartesianChartPoint<dynamic> point,
    SeriesRendererDetails seriesRendererDetails,
    Animation<double>? animationController,
  ) {
    if (seriesRendererDetails.chart.onMarkerRender != null &&
        seriesRendererDetails.isMarkerRenderEvent == false) {
      if (animationController == null ||
          ((animationController.value == 1.0 &&
                  animationController.status == AnimationStatus.completed) ||
              (seriesRendererDetails
                      .animationController.duration!.inMilliseconds ==
                  0))) {
        CartesianPointHelper.setIsMarkerEventTriggered(point, false);
      }
    }
  }

  /// To get the marker fill paint
  Paint getFillPaint(
      CartesianChartPoint<dynamic> point,
      XyDataSeries<dynamic, dynamic> series,
      SeriesRendererDetails seriesRendererDetails,
      MarkerDetails? pointMarkerDetails,
      double opacity) {
    return Paint()
      ..color = (point.isEmpty ?? false)
          ? series.emptyPointSettings.color
          : color != Colors.transparent
              ? (pointMarkerDetails?.color ??
                      color ??
                      (seriesRendererDetails.stateProperties.renderingDetails
                                  .chartTheme.brightness ==
                              Brightness.light
                          ? Colors.white
                          : Colors.black))
                  .withOpacity(opacity)
              : color!
      ..style = PaintingStyle.fill;
  }

  /// To get the marker stroke paint
  Paint getStrokePaint(
      CartesianChartPoint<dynamic> point,
      XyDataSeries<dynamic, dynamic> series,
      MarkerDetails? pointMarkerDetails,
      double opacity,
      bool hasPointColor,
      Color? seriesColor,
      DataMarkerType markerType,
      SeriesRendererDetails seriesRendererDetails,
      Animation<double>? animationController,
      Size size) {
    Paint strokePaint = Paint()
      ..color = (point.isEmpty ?? false)
          ? (series.emptyPointSettings.borderWidth == 0
              ? Colors.transparent
              : series.emptyPointSettings.borderColor.withOpacity(opacity))
          : (series.markerSettings.borderWidth == 0
              ? Colors.transparent
              : (pointMarkerDetails?.borderColor != null
                  ? pointMarkerDetails!.borderColor!.withOpacity(opacity)
                  : (hasPointColor && point.pointColorMapper != null)
                      ? point.pointColorMapper!.withOpacity(opacity)
                      : (borderColor != null
                          ? borderColor!.withOpacity(opacity)
                          : seriesColor!.withOpacity(opacity))))
      ..style = PaintingStyle.stroke
      ..strokeWidth = (point.isEmpty ?? false)
          ? series.emptyPointSettings.borderWidth
          : pointMarkerDetails?.borderWidth ?? borderWidth;

    if (series.gradient != null &&
        series.markerSettings.borderColor == null &&
        ((pointMarkerDetails == null) ||
            // ignore: unnecessary_null_comparison
            (pointMarkerDetails != null &&
                pointMarkerDetails.borderColor == null))) {
      strokePaint = getLinearGradientPaint(
          series.gradient!,
          getMarkerShapesPath(
                  pointMarkerDetails?.markerType ?? markerType,
                  Offset(point.markerPoint!.x, point.markerPoint!.y),
                  pointMarkerDetails?.size ?? size,
                  seriesRendererDetails,
                  null,
                  null,
                  animationController)
              .getBounds(),
          seriesRendererDetails.stateProperties.requireInvertedAxis);
      strokePaint.style = PaintingStyle.stroke;
      strokePaint.strokeWidth = (point.isEmpty ?? false)
          ? series.emptyPointSettings.borderWidth
          : pointMarkerDetails?.borderWidth ??
              series.markerSettings.borderWidth;
    }

    return strokePaint;
  }

  /// To determine if the marker is within axis clip rect.
  bool withInRect(SeriesRendererDetails seriesRendererDetails,
      ChartLocation? markerPoint, Rect axisClipRect) {
    bool withInRect = false;

    withInRect = markerPoint != null &&
        markerPoint.x >= axisClipRect.left &&
        markerPoint.x <= axisClipRect.right &&
        markerPoint.y <= axisClipRect.bottom &&
        markerPoint.y >= axisClipRect.top;

    return withInRect;
  }

  /// Paint the image marker.
  void drawImageMarker(SeriesRendererDetails seriesRendererDetails,
      Canvas canvas, double pointX, double pointY) {
    if (seriesRendererDetails.markerSettingsRenderer!.image != null) {
      final double imageWidth =
          2 * seriesRendererDetails.series.markerSettings.width;
      final double imageHeight =
          2 * seriesRendererDetails.series.markerSettings.height;
      final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
          pointY - imageHeight / 2, imageWidth, imageHeight);
      paintImage(
          canvas: canvas, rect: positionRect, image: image!, fit: BoxFit.fill);
    }
  }
}
