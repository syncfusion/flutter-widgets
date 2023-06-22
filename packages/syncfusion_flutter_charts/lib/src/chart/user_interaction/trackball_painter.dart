import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../axis/axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/interactive_tooltip.dart';
import '../common/renderer.dart';
import '../utils/helper.dart';
import 'trackball.dart';
import 'trackball_template.dart';

/// Represents the Trackline painter.
class TracklinePainter extends CustomPainter {
  /// Creates constructor of TracklinePainter class.
  TracklinePainter(this.trackballBehavior, this.stateProperties,
      this.chartPointInfo, this.markerShapes);

  /// Represents the value trackball behavior.
  TrackballBehavior trackballBehavior;

  /// Represents the cartesian state properties.
  CartesianStateProperties stateProperties;

  /// Specifies the list of chart point information of data points.
  List<ChartPointInfo>? chartPointInfo;

  /// Specifies the list of maker shape paths.
  List<Path>? markerShapes;

  /// Specifies whether the trackline is drawn or not.
  bool isTrackLineDrawn = false;

  @override
  void paint(Canvas canvas, Size size) {
    final Path dashArrayPath = Path();
    final Paint trackballLinePaint = Paint();
    trackballLinePaint.color = trackballBehavior.lineColor ??
        stateProperties.renderingDetails.chartTheme.crosshairLineColor;
    trackballLinePaint.strokeWidth = trackballBehavior.lineWidth;
    trackballLinePaint.style = PaintingStyle.stroke;
    trackballBehavior.lineWidth == 0
        ? trackballLinePaint.color = Colors.transparent
        : trackballLinePaint.color = trackballLinePaint.color;
    final Rect boundaryRect = stateProperties.chartAxis.axisClipRect;

    if (chartPointInfo != null && chartPointInfo!.isNotEmpty) {
      for (int index = 0; index < chartPointInfo!.length; index++) {
        if (index == 0) {
          if (chartPointInfo![index]
                      .seriesRendererDetails!
                      .seriesType
                      .contains('bar') ==
                  true
              ? stateProperties.requireInvertedAxis
              : stateProperties.requireInvertedAxis) {
            dashArrayPath.moveTo(
                boundaryRect.left, chartPointInfo![index].yPosition!);
            dashArrayPath.lineTo(
                boundaryRect.right, chartPointInfo![index].yPosition!);
          } else {
            dashArrayPath.moveTo(
                chartPointInfo![index].xPosition!, boundaryRect.top);
            dashArrayPath.lineTo(
                chartPointInfo![index].xPosition!, boundaryRect.bottom);
          }
          trackballBehavior.lineDashArray != null
              ? drawDashedLine(canvas, trackballBehavior.lineDashArray!,
                  trackballLinePaint, dashArrayPath)
              : canvas.drawPath(dashArrayPath, trackballLinePaint);
        }
        if (markerShapes != null &&
            markerShapes!.isNotEmpty &&
            markerShapes!.length > index) {
          TrackballHelper.getRenderingDetails(
                  stateProperties.trackballBehaviorRenderer)
              .renderTrackballMarker(
                  chartPointInfo![index].seriesRendererDetails!,
                  canvas,
                  trackballBehavior,
                  index);
        }
      }
    }
  }

  @override
  bool shouldRepaint(TracklinePainter oldDelegate) => true;
}

/// Represents the trackball painter.
class TrackballPainter extends CustomPainter {
  /// Calling the default constructor of TrackballPainter class.
  TrackballPainter({required this.stateProperties, required this.valueNotifier})
      : chart = stateProperties.chart,
        super(repaint: valueNotifier);

  /// Represents the cartesian chart properties.
  final CartesianStateProperties stateProperties;

  /// Represents the value of cartesian chart.
  final SfCartesianChart chart;

  /// Specifies the value of timer.
  Timer? timer;

  /// Repaint notifier for trackball.
  ValueNotifier<int> valueNotifier;

  /// Represents the value of pointer length.
  late double pointerLength;

  /// Represents the value of pointer width.
  late double pointerWidth;

  /// Specifies the value of nose point y value.
  double nosePointY = 0;

  /// Specifies the value of nose point x value.
  double nosePointX = 0;

  /// Specifies the value of total width.
  double totalWidth = 0;

  /// Represents the value of x value.
  double? x;

  /// Represents the value of y value.
  double? y;

  /// Represents the value of x position.
  double? xPos;

  /// Represents the value of y position.
  double? yPos;

  /// Represents the value of isTop.
  bool isTop = false;

  /// Represents the value of border radius.
  late double borderRadius;

  /// Represents the value of background path.
  Path backgroundPath = Path();

  /// Represents the value for canResetPath for trackball.
  bool canResetPath = true;

  /// Represents the value of isleft.
  bool isLeft = false;

  /// Represents the value of isright.
  bool isRight = false;

  /// Specifies the padding value for group all dispaly mode.
  double groupAllPadding = 10;

  /// Specifies the list of string values for the trackball.
  List<TrackballElement> stringValue = <TrackballElement>[];

  /// Represents the boundary rect for trackball.
  Rect boundaryRect = Rect.zero;

  /// Represents the value of left padding.
  double leftPadding = 0;

  /// Represents the value of top padding.
  double topPadding = 0;

  /// Specifies whether the orientation is horizontal or not.
  bool isHorizontalOrientation = false;

  /// Specifies whether the series is rect type or not.
  bool isRectSeries = false;

  /// Specifies the text style for label.
  late TextStyle labelStyle;

  /// Specifies whether the divider is needed or not.
  bool divider = true;

  /// Specifies the list of marker shaper paths.
  List<Path>? _markerShapes;

  /// Specifies the list of tooltip top values.
  List<num> tooltipTop = <num>[];

  /// Specifies the list of tooltip bottom values.
  List<num> tooltipBottom = <num>[];

  final List<ChartAxisRenderer> _xAxesInfo = <ChartAxisRenderer>[];

  final List<ChartAxisRenderer> _yAxesInfo = <ChartAxisRenderer>[];

  /// Specifies the list of chart point infos
  late List<ChartPointInfo> chartPointInfo;

  late List<ClosestPoints> _visiblePoints;

  TooltipPositions? _tooltipPosition;

  num _padding = 5;

  late num _tooltipPadding;

  ///Specifies whether the series is range type or not.
  bool isRangeSeries = false;

  ///Specifies whether the series is box and whishers series or not.
  bool isBoxSeries = false;

  /// Represents the rect value of label.
  late Rect labelRect;

  /// Represents the value of marker size and padding.
  late num markerSize, markerPadding;

  /// Specifies whether the group mode is enabled or not.
  bool isGroupMode = false;

  /// Represents the value of last marker result height.
  late double lastMarkerResultHeight;

  ChartLocation? _minLocation, _maxLocation;

  /// Trackball rendering details
  TrackballRenderingDetails get trackballRenderingDetails =>
      TrackballHelper.getRenderingDetails(
          stateProperties.trackballBehaviorRenderer);

  @override
  void paint(Canvas canvas, Size size) {
    stateProperties.trackballBehaviorRenderer.onPaint(canvas);
  }

  /// To get the paint for trackball line painter.
  Paint getLinePainter(Paint trackballLinePaint) => trackballLinePaint;

  /// To draw the trackball for all series.
  void drawTrackball(Canvas canvas) {
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    if (!_isSeriesAnimating()) {
      chartPointInfo = trackballRenderingDetails.chartPointInfo;
      _markerShapes = trackballRenderingDetails.markerShapes;
      _visiblePoints = trackballRenderingDetails.visiblePoints;
      isRangeSeries = trackballRenderingDetails.isRangeSeries;
      isBoxSeries = trackballRenderingDetails.isBoxSeries;
      _tooltipPadding = stateProperties.requireInvertedAxis ? 8 : 5;
      borderRadius = chart.trackballBehavior.tooltipSettings.borderRadius;
      pointerLength = chart.trackballBehavior.tooltipSettings.arrowLength;
      pointerWidth = chart.trackballBehavior.tooltipSettings.arrowWidth;
      isGroupMode = chart.trackballBehavior.tooltipDisplayMode ==
          TrackballDisplayMode.groupAllPoints;
      isLeft = false;
      isRight = false;
      double height = 0, width = 0;
      boundaryRect = stateProperties.chartAxis.axisClipRect;
      totalWidth = boundaryRect.left + boundaryRect.width;
      labelStyle =
          stateProperties.renderingDetails.chartTheme.trackballTextStyle!;
      ChartPointInfo? trackLinePoint =
          chartPointInfo.isNotEmpty ? chartPointInfo[0] : null;
      for (int index = 0; index < chartPointInfo.length; index++) {
        if (!canResetPath &&
            trackLinePoint != null &&
            chart.trackballBehavior.lineType != TrackballLineType.none) {
          final Paint trackballLinePaint = Paint();
          trackballLinePaint.color = chart.trackballBehavior.lineColor ??
              renderingDetails.chartTheme.crosshairLineColor;
          trackballLinePaint.strokeWidth = chart.trackballBehavior.lineWidth;
          trackballLinePaint.style = PaintingStyle.stroke;
          chart.trackballBehavior.lineWidth == 0
              ? trackballLinePaint.color = Colors.transparent
              : trackballLinePaint.color = trackballLinePaint.color;
          trackballRenderingDetails.drawLine(
              canvas,
              trackballRenderingDetails.linePainter(trackballLinePaint),
              chartPointInfo.indexOf(trackLinePoint));
        }
        final ChartPointInfo next = chartPointInfo[index];
        final ChartPointInfo pres = trackLinePoint!;
        final Offset pos = trackballRenderingDetails.tapPosition;
        if (stateProperties.requireInvertedAxis
            ? ((pos.dy - pres.yPosition!).abs() >=
                (pos.dy - next.yPosition!).abs())
            : ((pos.dx - pres.xPosition!).abs() >=
                (pos.dx - next.xPosition!).abs())) {
          trackLinePoint = chartPointInfo[index];
        }
        final bool isRectTypeSeries = chartPointInfo[index]
                    .seriesRendererDetails!
                    .seriesType
                    .contains('column') ==
                true ||
            chartPointInfo[index].seriesRendererDetails!.seriesType ==
                'candle' ||
            chartPointInfo[index]
                    .seriesRendererDetails!
                    .seriesType
                    .contains('boxandwhisker') ==
                true ||
            chartPointInfo[index]
                    .seriesRendererDetails!
                    .seriesType
                    .contains('hilo') ==
                true;
        if ((isRectTypeSeries && !stateProperties.requireInvertedAxis) ||
            (chartPointInfo[index]
                        .seriesRendererDetails!
                        .seriesType
                        .contains('bar') ==
                    true &&
                stateProperties.requireInvertedAxis)) {
          isHorizontalOrientation = true;
        }
        isRectSeries = false;
        if ((isRectTypeSeries && stateProperties.requireInvertedAxis) ||
            (chartPointInfo[index]
                        .seriesRendererDetails!
                        .seriesType
                        .contains('bar') ==
                    true &&
                !stateProperties.requireInvertedAxis)) {
          isRectSeries = true;
        }

        final Size size = _getTooltipSize(height, width, index);
        height = size.height;
        width = size.width;
        if (width < 10) {
          width = 10; // minimum width for tooltip to render
          borderRadius = borderRadius > 5 ? 5 : borderRadius;
        }
        borderRadius = borderRadius > 15 ? 15 : borderRadius;
        // Padding added for avoid tooltip and the data point are too close and
        // extra padding based on trackball marker and width
        _padding = (chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (chartPointInfo[index]
                        .seriesRendererDetails!
                        .series
                        .markerSettings
                        .isVisible ==
                    true)
                : chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (chart.trackballBehavior.markerSettings!.width / 2) + 5
            : _padding;
        if (x != null &&
            y != null &&
            chart.trackballBehavior.tooltipSettings.enable) {
          if (isGroupMode &&
              ((chartPointInfo[index].header != null &&
                      chartPointInfo[index].header != '') ||
                  (chartPointInfo[index].label != null &&
                      chartPointInfo[index].label != ''))) {
            for (int markerIndex = 0;
                markerIndex < chartPointInfo.length;
                markerIndex++) {
              _renderEachMarkers(canvas, markerIndex);
            }
            _calculateTrackballRect(
                canvas, width, height, index, chartPointInfo);
          } else {
            if (!canResetPath &&
                chartPointInfo[index].label != null &&
                chartPointInfo[index].label != '') {
              tooltipTop.add(stateProperties.requireInvertedAxis
                  ? _visiblePoints[index].closestPointX -
                      _tooltipPadding -
                      (width / 2)
                  : _visiblePoints[index].closestPointY -
                      _tooltipPadding -
                      height / 2);
              tooltipBottom.add(stateProperties.requireInvertedAxis
                  ? (_visiblePoints[index].closestPointX +
                          _tooltipPadding +
                          (width / 2)) +
                      (chart.trackballBehavior.tooltipSettings.canShowMarker
                          ? 20
                          : 0)
                  : _visiblePoints[index].closestPointY +
                      _tooltipPadding +
                      height / 2);
              _xAxesInfo.add(chartPointInfo[index]
                  .seriesRendererDetails!
                  .xAxisDetails!
                  .axisRenderer);
              _yAxesInfo.add(chartPointInfo[index]
                  .seriesRendererDetails!
                  .yAxisDetails!
                  .axisRenderer);
            }
          }
        }

        if (isGroupMode) {
          break;
        }
      }

// ignore: unnecessary_null_comparison
      if (tooltipTop != null && tooltipTop.isNotEmpty) {
        _tooltipPosition = trackballRenderingDetails.smartTooltipPositions(
            tooltipTop,
            tooltipBottom,
            _xAxesInfo,
            _yAxesInfo,
            chartPointInfo,
            stateProperties.requireInvertedAxis,
            true);
      }

      for (int index = 0; index < chartPointInfo.length; index++) {
        if (!isGroupMode) {
          _renderEachMarkers(canvas, index);
        }

        // Padding added for avoid tooltip and the data point are too close and
        // extra padding based on trackball marker and width
        _padding = (chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.auto
                ? (chartPointInfo[index]
                        .seriesRendererDetails!
                        .series
                        .markerSettings
                        .isVisible ==
                    true)
                : chart.trackballBehavior.markerSettings != null &&
                    chart.trackballBehavior.markerSettings!.markerVisibility ==
                        TrackballVisibilityMode.visible)
            ? (chart.trackballBehavior.markerSettings!.width / 2) + 5
            : _padding;
        if (chart.trackballBehavior.tooltipSettings.enable &&
            !isGroupMode &&
            chartPointInfo[index].label != null &&
            chartPointInfo[index].label != '') {
          final Size size = _getTooltipSize(height, width, index);
          height = size.height;
          width = size.width;
          if (width < 10) {
            width = 10; // minimum width for tooltip to render
            borderRadius = borderRadius > 5 ? 5 : borderRadius;
          }
          _calculateTrackballRect(
              canvas, width, height, index, chartPointInfo, _tooltipPosition!);
          if (index == chartPointInfo.length - 1) {
            tooltipTop.clear();
            tooltipBottom.clear();
            _tooltipPosition!.tooltipTop.clear();
            _tooltipPosition!.tooltipBottom.clear();
            _xAxesInfo.clear();
            _yAxesInfo.clear();
          }
        }
      }
    }
  }

  void _renderEachMarkers(Canvas canvas, int markerIndex) {
    trackballRenderingDetails.trackballMarker(markerIndex);
    if (_markerShapes != null &&
        _markerShapes!.isNotEmpty &&
        _markerShapes!.length > markerIndex) {
      trackballRenderingDetails.renderTrackballMarker(
          chartPointInfo[markerIndex].seriesRendererDetails!,
          canvas,
          chart.trackballBehavior,
          markerIndex);
    }
  }

  bool _isSeriesAnimating() {
    for (int i = 0;
        i < stateProperties.chartSeries.visibleSeriesRenderers.length;
        i++) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              stateProperties.chartSeries.visibleSeriesRenderers[i]);
      if (!(seriesRendererDetails.animationCompleted == true ||
              seriesRendererDetails.series.animationDuration == 0 ||
              !stateProperties.renderingDetails.initialRender!) &&
          seriesRendererDetails.series.isVisible == true) {
        return true;
      }
    }
    return false;
  }

  /// Specifies whether the trackball header text is to be rendered or not.
  bool headerText = false;

  /// Specifies the value for formatting x value.
  bool xFormat = false;

  /// Specifies whether the labelFormat contains colon or not.
  bool isColon = true;

  /// To get tooltip size.
  Size _getTooltipSize(double height, double width, int index) {
    final Offset position = Offset(
        chartPointInfo[index].xPosition!, chartPointInfo[index].yPosition!);
    Offset pos;
    ChartAxisRendererDetails xAxisDetails, yAxisDetails;
    SeriesRendererDetails? seriesRendererDetails;
    num? minX, maxX;
    stringValue = <TrackballElement>[];
    final String? format = chartPointInfo[index]
        .seriesRendererDetails!
        .chart
        .trackballBehavior
        .tooltipSettings
        .format;
    if (format != null &&
        format.contains('point.x') &&
        !format.contains('point.y')) {
      xFormat = true;
    }
    if (format != null &&
        format.contains('point.x') &&
        format.contains('point.y') &&
        !format.contains(':')) {
      isColon = false;
    }
    if (chartPointInfo[index].header != null &&
        chartPointInfo[index].header != '') {
      stringValue.add(TrackballElement(chartPointInfo[index].header!, null));
    }
    if (isGroupMode) {
      String str1 = '';
      for (int i = 0; i < chartPointInfo.length; i++) {
        pos = trackballRenderingDetails.tapPosition;
        xAxisDetails = chartPointInfo[i].seriesRendererDetails!.xAxisDetails!;
        seriesRendererDetails = chartPointInfo[i].seriesRendererDetails;
        yAxisDetails = chartPointInfo[i].seriesRendererDetails!.yAxisDetails!;
        minX = seriesRendererDetails!.minimumX;
        maxX = seriesRendererDetails.maximumX;
        _minLocation = calculatePoint(
            minX!,
            seriesRendererDetails.minimumY!,
            xAxisDetails,
            yAxisDetails,
            stateProperties.requireInvertedAxis,
            chartPointInfo[index].series,
            stateProperties.chartAxis.axisClipRect);
        _maxLocation = calculatePoint(
            maxX!,
            seriesRendererDetails.maximumY!,
            xAxisDetails,
            yAxisDetails,
            stateProperties.requireInvertedAxis,
            chartPointInfo[index].series,
            stateProperties.chartAxis.axisClipRect);
        if (chartPointInfo[i].header != null &&
            chartPointInfo[i].header!.contains(':')) {
          headerText = true;
        }
        bool isHeader =
            chartPointInfo[i].header != null && chartPointInfo[i].header != '';
        bool isLabel =
            chartPointInfo[i].label != null && chartPointInfo[i].label != '';
        if (chartPointInfo[i].seriesRendererDetails!.isIndicator == true) {
          isHeader = chartPointInfo[0].header != null &&
              chartPointInfo[0].header != '';
          isLabel =
              chartPointInfo[0].label != null && chartPointInfo[0].label != '';
        }
        divider = isHeader && isLabel;
        final String seriesType =
            chartPointInfo[i].seriesRendererDetails!.seriesType;
        if (chartPointInfo[i].seriesRendererDetails!.isIndicator == true &&
            chartPointInfo[i]
                    .seriesRendererDetails!
                    .series
                    .name!
                    .contains('rangearea') ==
                true) {
          if (i == 0) {
            stringValue.add(TrackballElement('', null));
          } else {
            str1 = '';
          }
          continue;
        } else if ((seriesType.contains('hilo') ||
                seriesType.contains('candle') ||
                seriesType.contains('range') ||
                seriesType == 'boxandwhisker') &&
            chartPointInfo[i]
                    .seriesRendererDetails!
                    .chart
                    .trackballBehavior
                    .tooltipSettings
                    .format ==
                null &&
            isLabel) {
          stringValue.add(TrackballElement(
              '${(chartPointInfo[index].header == null || chartPointInfo[index].header == '') ? '' : i == 0 ? '\n' : ''}${chartPointInfo[i].seriesRendererDetails!.seriesName}\n${chartPointInfo[i].label}',
              chartPointInfo[i].seriesRendererDetails!.renderer));
        } else if (chartPointInfo[i].seriesRendererDetails!.series.name !=
            null) {
          if (chartPointInfo[i]
                  .seriesRendererDetails!
                  .chart
                  .trackballBehavior
                  .tooltipSettings
                  .format !=
              null) {
            if (isHeader && isLabel && i == 0) {
              stringValue.add(TrackballElement('', null));
            }
            if (isLabel) {
              stringValue.add(TrackballElement(chartPointInfo[i].label!,
                  chartPointInfo[i].seriesRendererDetails!.renderer));
            }
          } else if (isLabel &&
              chartPointInfo[i].label!.contains(':') &&
              (chartPointInfo[i].header == null ||
                  chartPointInfo[i].header == '')) {
            stringValue.add(TrackballElement(chartPointInfo[i].label!,
                chartPointInfo[i].seriesRendererDetails!.renderer));
            divider = false;
          } else {
            if (isHeader && isLabel && i == 0) {
              stringValue.add(TrackballElement('', null));
            }
            if (isLabel) {
              final CartesianStateProperties stateProperties =
                  chartPointInfo[i].seriesRendererDetails!.stateProperties;
              //ignore: avoid_bool_literals_in_conditional_expressions
              if (chartPointInfo[i].seriesRendererDetails!.isIndicator ==
                          true &&
                      stateProperties
                          .renderingDetails.legendToggleStates.isEmpty
                  ? pos.dx >= _minLocation!.x && pos.dx <= _maxLocation!.x
                  : true) {
                stringValue.add(TrackballElement(
                    '$str1${chartPointInfo[i].seriesRendererDetails!.series.name!}: ${chartPointInfo[i].label!}',
                    chartPointInfo[i].seriesRendererDetails!.renderer));
              }
            }
            divider = (chartPointInfo[0].header != null &&
                    chartPointInfo[0].header != '') &&
                isLabel;
          }
          if (str1 != '') {
            str1 = '';
          }
        } else {
          if (isLabel) {
            if (isHeader && i == 0) {
              stringValue.add(TrackballElement('', null));
            }
            stringValue.add(TrackballElement(chartPointInfo[i].label!,
                chartPointInfo[i].seriesRendererDetails!.renderer));
          }
        }
      }
      for (int i = 0; i < stringValue.length; i++) {
        String measureString = stringValue[i].label;
        if (measureString.contains('<b>') && measureString.contains('</b>')) {
          measureString =
              measureString.replaceAll('<b>', '').replaceAll('</b>', '');
        }
        if (measureText(measureString, labelStyle).width > width) {
          width = measureText(measureString, labelStyle).width;
        }
        height += measureText(measureString, labelStyle).height;
      }
      if (stateProperties.requireInvertedAxis) {
        y = position.dy;
        x = (chart.trackballBehavior.tooltipAlignment == ChartAlignment.center)
            ? boundaryRect.center.dx
            : (chart.trackballBehavior.tooltipAlignment == ChartAlignment.near)
                ? boundaryRect.top
                : boundaryRect.bottom;
      } else {
        x = position.dx;
        y = (chart.trackballBehavior.tooltipAlignment == ChartAlignment.center)
            ? boundaryRect.center.dy
            : (chart.trackballBehavior.tooltipAlignment == ChartAlignment.near)
                ? boundaryRect.top
                : boundaryRect.bottom;
      }
    } else {
      stringValue = <TrackballElement>[];
      if (chartPointInfo[index].label != null &&
          chartPointInfo[index].label != '') {
        stringValue.add(TrackballElement(chartPointInfo[index].label!,
            chartPointInfo[index].seriesRendererDetails!.renderer));
      }

      String? measureString =
          stringValue.isNotEmpty ? stringValue[0].label : null;
      if (measureString != null &&
          measureString.contains('<b>') &&
          measureString.contains('</b>')) {
        measureString =
            measureString.replaceAll('<b>', '').replaceAll('</b>', '');
      }
      final Size size = measureText(measureString!, labelStyle);
      width = size.width;
      height = size.height;

      if (chartPointInfo[index]
                  .seriesRendererDetails!
                  .seriesType
                  .contains('column') ==
              true ||
          chartPointInfo[index]
                  .seriesRendererDetails!
                  .seriesType
                  .contains('bar') ==
              true ||
          chartPointInfo[index].seriesRendererDetails!.seriesType == 'candle' ||
          chartPointInfo[index]
                  .seriesRendererDetails!
                  .seriesType
                  .contains('boxandwhisker') ==
              true ||
          chartPointInfo[index]
                  .seriesRendererDetails!
                  .seriesType
                  .contains('hilo') ==
              true) {
        x = position.dx;
        y = position.dy;
      } else if (chartPointInfo[index].seriesRendererDetails!.seriesType ==
          'rangearea') {
        x = chartPointInfo[index].chartDataPoint!.markerPoint!.x;
        y = (chartPointInfo[index].chartDataPoint!.markerPoint!.y +
                chartPointInfo[index].chartDataPoint!.markerPoint2!.y) /
            2;
      } else {
        x = position.dx;
        y = position.dy;
      }
    }
    return Size(width, height);
  }

  /// To find the rect location of the trackball.
  void _calculateTrackballRect(
      Canvas canvas, double width, double height, int index,
      [List<ChartPointInfo>? chartPointInfo,
      TooltipPositions? tooltipPosition]) {
    final String seriesType =
        chartPointInfo![index].seriesRendererDetails!.seriesType;
    const double widthPadding = 17;
    markerSize = 10;
    if (!chart.trackballBehavior.tooltipSettings.canShowMarker) {
      labelRect = Rect.fromLTWH(x!, y!, width + 15, height + 10);
    } else {
      labelRect = Rect.fromLTWH(
          x!, y!, width + (2 * markerSize) + widthPadding, height + 10);
    }

    if (y! > pointerLength + labelRect.height) {
      _calculateTooltipSize(labelRect, chartPointInfo, tooltipPosition, index);
    } else {
      isTop = false;
      if (seriesType.contains('bar')
          ? stateProperties.requireInvertedAxis
          : stateProperties.requireInvertedAxis) {
        xPos = x! - (labelRect.width / 2);
        yPos = (y! + pointerLength) + _padding;
        nosePointX = labelRect.left;
        nosePointY = labelRect.top + _padding;
        final double tooltipRightEnd = x! + (labelRect.width / 2);
        xPos = xPos! < boundaryRect.left
            ? boundaryRect.left
            : tooltipRightEnd > totalWidth
                ? totalWidth - labelRect.width
                : xPos;
      } else {
        if (isGroupMode) {
          xPos = x! - labelRect.width / 2;
          yPos = y;
        } else {
          xPos = x!;
          yPos = (y! + pointerLength / 2) + _padding;
        }
        nosePointX = labelRect.left;
        nosePointY = labelRect.top;
        if (!stateProperties.renderingDetails.isRtl) {
          if ((isGroupMode
                  ? (xPos! + (labelRect.width / 2) + groupAllPadding)
                  : xPos! + labelRect.width + _padding + pointerLength) >
              boundaryRect.right) {
            xPos = isGroupMode
                ? (xPos! - (labelRect.width / 2) - groupAllPadding)
                : xPos! - labelRect.width - _padding - pointerLength;
            isLeft = true;
          } else {
            xPos = isGroupMode
                ? x! + groupAllPadding
                : x! + _padding + pointerLength;
          }
        } else {
          if (x! - labelRect.width - _padding - pointerLength >
              boundaryRect.left) {
            xPos = isGroupMode
                ? (xPos! - (labelRect.width / 2) - groupAllPadding)
                : xPos! - labelRect.width - _padding - pointerLength;
            isLeft = true;
          } else {
            xPos = isGroupMode
                ? x! + groupAllPadding
                : x! + _padding + pointerLength;
            isRight = true;
          }
        }

        if (isGroupMode && (yPos! + labelRect.height) >= boundaryRect.bottom) {
          yPos = boundaryRect.bottom - labelRect.height;
        }

        if (isGroupMode && yPos! <= boundaryRect.top) {
          yPos = boundaryRect.top;
        }
      }
    }

    labelRect = isGroupMode ||
            chart.trackballBehavior.tooltipDisplayMode ==
                TrackballDisplayMode.nearestPoint
        ? Rect.fromLTWH(xPos!, yPos!, labelRect.width, labelRect.height)
        : Rect.fromLTWH(
            stateProperties.requireInvertedAxis
                ? tooltipPosition!.tooltipTop[index].toDouble()
                : xPos!,
            !stateProperties.requireInvertedAxis
                ? tooltipPosition!.tooltipTop[index].toDouble()
                : yPos!,
            labelRect.width,
            labelRect.height);
    if (isGroupMode) {
      _drawTooltipBackground(
          canvas,
          labelRect,
          nosePointX,
          nosePointY,
          borderRadius,
          isTop,
          backgroundPath,
          isLeft,
          isRight,
          index,
          null,
          null);
    } else {
      if (stateProperties.requireInvertedAxis
          ? tooltipPosition!.tooltipTop[index] >= boundaryRect.left &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.right
          : tooltipPosition!.tooltipTop[index] >= boundaryRect.top &&
              tooltipPosition.tooltipBottom[index] <= boundaryRect.bottom) {
        _drawTooltipBackground(
            canvas,
            labelRect,
            nosePointX,
            nosePointY,
            borderRadius,
            isTop,
            backgroundPath,
            isLeft,
            isRight,
            index,
            seriesType.contains('range') ||
                    seriesType.contains('hilo') ||
                    seriesType == 'candle'
                ? chartPointInfo[index].highXPosition
                : seriesType.contains('box')
                    ? chartPointInfo[index].maxXPosition
                    : chartPointInfo[index].xPosition,
            seriesType.contains('range') ||
                    seriesType.contains('hilo') ||
                    seriesType == 'candle'
                ? chartPointInfo[index].highYPosition
                : seriesType.contains('box')
                    ? chartPointInfo[index].maxYPosition
                    : chartPointInfo[index].yPosition);
      }
    }
  }

  /// To find the trackball tooltip size.
  void _calculateTooltipSize(
      Rect labelRect,
      List<ChartPointInfo>? chartPointInfo,
      TooltipPositions? tooltipPositions,
      int index) {
    isTop = true;
    isRight = false;
    if (chartPointInfo![index]
                .seriesRendererDetails!
                .seriesType
                .contains('bar') ==
            true
        ? stateProperties.requireInvertedAxis
        : stateProperties.requireInvertedAxis) {
      xPos = x! - (labelRect.width / 2);
      yPos = (y! - labelRect.height) - _padding;
      nosePointY = labelRect.top - _padding;
      nosePointX = labelRect.left;
      final double tooltipRightEnd = x! + (labelRect.width / 2);
      xPos = xPos! < boundaryRect.left
          ? boundaryRect.left
          : tooltipRightEnd > totalWidth
              ? totalWidth - labelRect.width
              : xPos;
      yPos = yPos! - pointerLength;
      if (yPos! + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    } else {
      xPos = x!;
      yPos = y! - labelRect.height / 2;
      nosePointY = yPos!;
      nosePointX = labelRect.left;
      if (!stateProperties.renderingDetails.isRtl) {
        if (xPos! + labelRect.width + _padding + pointerLength >
            boundaryRect.right) {
          xPos = isGroupMode
              ? xPos! - labelRect.width - groupAllPadding
              : xPos! - labelRect.width - _padding - pointerLength;
          isLeft = true;
        } else {
          xPos = isGroupMode
              ? x! + groupAllPadding
              : x! + _padding + pointerLength;
          isLeft = false;
          isRight = true;
        }
      } else {
        xPos = isGroupMode
            ? xPos! - labelRect.width - groupAllPadding
            : xPos! - labelRect.width - _padding - pointerLength;
        if (xPos! < boundaryRect.left) {
          xPos = isGroupMode
              ? x! + groupAllPadding
              : x! + _padding + pointerLength;
          isRight = true;
        } else {
          isLeft = true;
        }
      }
      if (yPos! + labelRect.height >= boundaryRect.bottom) {
        yPos = boundaryRect.bottom - labelRect.height;
      }
    }
  }

  /// To draw the line for the trackball.
  void drawTrackBallLine(Canvas canvas, Paint paint, int index) {
    final Path dashArrayPath = Path();
    if (chartPointInfo[index]
                .seriesRendererDetails!
                .seriesType
                .contains('bar') ==
            true
        ? stateProperties.requireInvertedAxis
        : stateProperties.requireInvertedAxis) {
      dashArrayPath.moveTo(boundaryRect.left, chartPointInfo[index].yPosition!);
      dashArrayPath.lineTo(
          boundaryRect.right, chartPointInfo[index].yPosition!);
    } else {
      dashArrayPath.moveTo(chartPointInfo[index].xPosition!, boundaryRect.top);
      dashArrayPath.lineTo(
          chartPointInfo[index].xPosition!, boundaryRect.bottom);
    }
    chart.trackballBehavior.lineDashArray != null
        ? drawDashedLine(canvas, chart.trackballBehavior.lineDashArray!, paint,
            dashArrayPath)
        : canvas.drawPath(dashArrayPath, paint);
  }

  /// To draw background of trackball tooltip.
  void _drawTooltipBackground(
      Canvas canvas,
      Rect labelRect,
      double xPos,
      double yPos,
      double borderRadius,
      bool isTop,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      double? xPosition,
      double? yPosition) {
    final double startArrow = pointerLength;
    final double endArrow = pointerLength;
    if (isTop) {
      _drawTooltip(
          canvas,
          labelRect,
          xPos,
          yPos,
          xPos - startArrow,
          yPos - startArrow,
          xPos + endArrow,
          yPos - endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          index,
          xPosition,
          yPosition);
    } else {
      _drawTooltip(
          canvas,
          labelRect,
          xPos,
          yPos,
          xPos - startArrow,
          yPos + startArrow,
          xPos + endArrow,
          yPos + endArrow,
          borderRadius,
          backgroundPath,
          isLeft,
          isRight,
          index,
          xPosition,
          yPosition);
    }
  }

  /// To draw the tooltip on the trackball.
  void _drawTooltip(
      Canvas canvas,
      Rect tooltipRect,
      double? xPos,
      double? yPos,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      int index,
      double? xPosition,
      double? yPosition) {
    backgroundPath.reset();
    final Rect axisClipRect = stateProperties.chartAxis.axisClipRect;
    if (!canResetPath &&
        chart.trackballBehavior.tooltipDisplayMode !=
            TrackballDisplayMode.none) {
      if (!isGroupMode &&
          !(xPosition == null || yPosition == null) &&
          (tooltipRect.left > axisClipRect.left &&
              tooltipRect.right < axisClipRect.right &&
              tooltipRect.top > axisClipRect.top &&
              tooltipRect.bottom < axisClipRect.bottom)) {
        if (stateProperties.requireInvertedAxis) {
          if (isLeft) {
            startX = tooltipRect.left + borderRadius;
            endX = startX + pointerWidth;
          } else if (isRight) {
            endX = tooltipRect.right - borderRadius;
            startX = endX - pointerWidth;
          }
          backgroundPath.moveTo(
              (tooltipRect.left + tooltipRect.width / 2) - pointerWidth,
              startY);
          backgroundPath.lineTo(xPosition, yPosition);
          backgroundPath.lineTo(
              (tooltipRect.right - tooltipRect.width / 2) + pointerWidth, endY);
        } else {
          if (isLeft) {
            backgroundPath.moveTo(tooltipRect.right,
                tooltipRect.top + tooltipRect.height / 2 - pointerWidth);
            backgroundPath.lineTo(tooltipRect.right,
                tooltipRect.bottom - tooltipRect.height / 2 + pointerWidth);
            backgroundPath.lineTo(tooltipRect.right + pointerLength, yPosition);
            backgroundPath.lineTo(tooltipRect.right + pointerLength, yPosition);
            backgroundPath.lineTo(tooltipRect.right,
                tooltipRect.top + tooltipRect.height / 2 - pointerWidth);
          } else {
            backgroundPath.moveTo(tooltipRect.left,
                tooltipRect.top + tooltipRect.height / 2 - pointerWidth);
            backgroundPath.lineTo(tooltipRect.left,
                tooltipRect.bottom - tooltipRect.height / 2 + pointerWidth);
            backgroundPath.lineTo(tooltipRect.left - pointerLength, yPosition);
            backgroundPath.lineTo(tooltipRect.left,
                tooltipRect.top + tooltipRect.height / 2 - pointerWidth);
          }
        }
      }

      double rectLeft = tooltipRect.left;
      double rectRight = tooltipRect.right;

      if (tooltipRect.width < axisClipRect.width &&
          tooltipRect.height < axisClipRect.height) {
        if (tooltipRect.left < axisClipRect.left) {
          rectLeft = rectLeft + (axisClipRect.left - tooltipRect.left);
          rectRight = rectRight + (axisClipRect.left - tooltipRect.left);
        } else if (tooltipRect.right > axisClipRect.right) {
          rectLeft = rectLeft - (tooltipRect.right - axisClipRect.right);
          rectRight = rectRight - (tooltipRect.right - axisClipRect.right);
        }
        tooltipRect = Rect.fromLTRB(
            rectLeft, tooltipRect.top, rectRight, tooltipRect.bottom);
        if ((tooltipRect.left < axisClipRect.left) ||
            tooltipRect.right > axisClipRect.right) {
          tooltipRect = Rect.zero;
        }

        if (tooltipRect != Rect.zero) {
          _drawRectandText(canvas, backgroundPath, tooltipRect, index);
        }
      } else {
        tooltipRect = Rect.zero;
      }

      xPos = null;
      yPos = null;
    }
  }

  TextStyle _getLabelStyle(FontWeight fontWeight, TextStyle labelStyle) {
    return TextStyle(
        fontWeight: fontWeight,
        color: labelStyle.color,
        fontSize: labelStyle.fontSize,
        fontFamily: labelStyle.fontFamily,
        fontStyle: labelStyle.fontStyle,
        inherit: labelStyle.inherit,
        backgroundColor: labelStyle.backgroundColor,
        letterSpacing: labelStyle.letterSpacing,
        wordSpacing: labelStyle.wordSpacing,
        textBaseline: labelStyle.textBaseline,
        height: labelStyle.height,
        locale: labelStyle.locale,
        foreground: labelStyle.foreground,
        background: labelStyle.background,
        shadows: labelStyle.shadows,
        fontFeatures: labelStyle.fontFeatures,
        decoration: labelStyle.decoration,
        decorationColor: labelStyle.decorationColor,
        decorationStyle: labelStyle.decorationStyle,
        decorationThickness: labelStyle.decorationThickness,
        debugLabel: labelStyle.debugLabel,
        fontFamilyFallback: labelStyle.fontFamilyFallback);
  }

  double _getMultiLineTextOffset(RRect tooltipRect, String text, int index,
      double totalLabelWidth, TextStyle style,
      [double? previousWidth]) {
    final double textOffsetX =
        tooltipRect.left + tooltipRect.width / 2 + totalLabelWidth / 2;
    final Size currentTextSize = measureText(text, style);
    return textOffsetX -
        currentTextSize.width -
        (index == 0 ? 0 : previousWidth!);
  }

  /// Draw trackball tooltip rect and text.
  void _drawRectandText(
      Canvas canvas, Path backgroundPath, Rect rect, int index) {
    const double textOffsetPadding = 4;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final RRect tooltipRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );
    const double padding = 10;

    final Paint fillPaint = Paint()
      ..color = chart.trackballBehavior.tooltipSettings.color ??
          renderingDetails.chartTheme.crosshairBackgroundColor
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    if (chart.trackballBehavior.tooltipSettings.borderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = chart.trackballBehavior.tooltipSettings.borderColor ??
            renderingDetails.chartTheme.crosshairBackgroundColor
        ..strokeWidth = chart.trackballBehavior.tooltipSettings.borderWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = false
        ..style = PaintingStyle.stroke;
      canvas.drawPath(backgroundPath, strokePaint);
      canvas.drawRRect(tooltipRect, strokePaint);
    }
    canvas.drawPath(backgroundPath, fillPaint);
    canvas.drawRRect(tooltipRect, fillPaint);
    final Paint dividerPaint = Paint();
    dividerPaint.color = renderingDetails.chartTheme.tooltipSeparatorColor;
    dividerPaint.strokeWidth = 1;
    dividerPaint.style = PaintingStyle.stroke;
    if (isGroupMode && divider) {
      final Size headerResult = measureText(stringValue[0].label, labelStyle);
      canvas.drawLine(
          Offset(tooltipRect.left + padding,
              tooltipRect.top + headerResult.height + padding),
          Offset(tooltipRect.right - padding,
              tooltipRect.top + headerResult.height + padding),
          dividerPaint);
    }
    double eachTextHeight = 0;
    Size labelSize;
    double totalHeight = 0;
    final bool isRtl = stateProperties.renderingDetails.isRtl;

    for (int i = 0; i < stringValue.length; i++) {
      labelSize = measureText(stringValue[i].label, labelStyle);
      totalHeight += labelSize.height;
    }

    eachTextHeight =
        (tooltipRect.top + tooltipRect.height / 2) - totalHeight / 2;

    for (int i = 0; i < stringValue.length; i++) {
      markerPadding = 0;
      if (chart.trackballBehavior.tooltipSettings.canShowMarker) {
        if (isGroupMode && i == 0) {
          markerPadding = 0;
        } else {
          markerPadding = 10 - markerSize + 5;
        }
      }
      const double animationFactor = 1;
      labelStyle = _getLabelStyle(FontWeight.normal, labelStyle);
      labelSize = measureText(stringValue[i].label, labelStyle);
      eachTextHeight += labelSize.height;
      if (!stringValue[i].label.contains(':') &&
          !stringValue[i].label.contains('<b>') &&
          !stringValue[i].label.contains('</b>')) {
        labelStyle = _getLabelStyle(FontWeight.bold, labelStyle);
        _drawTooltipMarker(
            stringValue[i].label,
            canvas,
            tooltipRect,
            animationFactor,
            labelSize,
            chartPointInfo[index].seriesRendererDetails!,
            i,
            null,
            null,
            eachTextHeight,
            index);
        drawText(
            canvas,
            stringValue[i].label,
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2 +
                    (isRtl ? -markerPadding : markerPadding),
                eachTextHeight - labelSize.height),
            labelStyle,
            0);
      } else {
        // ignore: unnecessary_null_comparison
        if (stringValue[i].label != null) {
          final List<String> str = stringValue[i].label.split('\n');
          double padding = 0;
          if (str.length > 1) {
            for (int j = 0; j < str.length; j++) {
              final List<String> str1 = str[j].split(':');
              if (str1.length > 1) {
                for (int k = 0; k < str1.length; k++) {
                  double width = 0.0;
                  if (isRtl) {
                    str1[k] = k == 0 ? ': ${str1[k]}'.trim() : '${str1[k]} ';
                    width = measureText(str1[0], labelStyle).width;
                  } else {
                    width =
                        k > 0 ? measureText(str1[k - 1], labelStyle).width : 0;
                    str1[k] = k == 1 ? ':${str1[k]}' : str1[k];
                  }
                  labelStyle = _getLabelStyle(
                      k > 0 ? FontWeight.bold : FontWeight.normal, labelStyle);

                  if (k == 0) {
                    _drawTooltipMarker(
                        str1[k],
                        canvas,
                        tooltipRect,
                        animationFactor,
                        labelSize,
                        chartPointInfo[index].seriesRendererDetails!,
                        i,
                        null,
                        width,
                        eachTextHeight,
                        index);
                  }
                  drawText(
                      canvas,
                      str1[k],
                      isRtl
                          ? Offset(
                              _getMultiLineTextOffset(
                                    tooltipRect,
                                    str1[k],
                                    k,
                                    labelSize.width,
                                    labelStyle,
                                    width,
                                  ) -
                                  ((!isGroupMode &&
                                          chart.trackballBehavior
                                              .tooltipSettings.canShowMarker)
                                      ? markerPadding
                                      : textOffsetPadding),
                              (eachTextHeight - labelSize.height) + padding)
                          : Offset(
                              (((!isGroupMode &&
                                              chart
                                                  .trackballBehavior
                                                  .tooltipSettings
                                                  .canShowMarker)
                                          ? (tooltipRect.left +
                                              tooltipRect.width / 2 -
                                              labelSize.width / 2)
                                          : (tooltipRect.left +
                                              textOffsetPadding)) +
                                      markerPadding) +
                                  width,
                              (eachTextHeight - labelSize.height) + padding),
                      labelStyle,
                      0);

                  padding = k > 0
                      ? padding +
                          (labelStyle.fontSize! + (labelStyle.fontSize! * 0.15))
                      : padding;
                }
              } else {
                labelStyle = _getLabelStyle(FontWeight.bold, labelStyle);

                _drawTooltipMarker(
                    str1[str1.length - 1],
                    canvas,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    chartPointInfo[index].seriesRendererDetails!,
                    i,
                    null,
                    null,
                    eachTextHeight,
                    index,
                    measureText(str1[str1.length - 1], labelStyle));
                markerPadding =
                    chart.trackballBehavior.tooltipSettings.canShowMarker
                        ? markerPadding +
                            (j == 0 && !isGroupMode
                                ? 13
                                : j == 0 && isGroupMode
                                    ? 7
                                    : 0)
                        : 0;
                drawText(
                    canvas,
                    str1[str1.length - 1],
                    isRtl
                        ? Offset(
                            tooltipRect.right -
                                measureText(str1[str1.length - 1], labelStyle)
                                    .width -
                                markerPadding -
                                textOffsetPadding,
                            eachTextHeight - labelSize.height + padding)
                        : Offset(
                            markerPadding +
                                tooltipRect.left +
                                textOffsetPadding,
                            eachTextHeight - labelSize.height + padding),
                    labelStyle,
                    0);
                padding = padding +
                    (labelStyle.fontSize! + (labelStyle.fontSize! * 0.15));
              }
            }
          } else {
            final bool hasFormat =
                chart.trackballBehavior.tooltipSettings.format != null;
            List<String> str1 = str[str.length - 1].split(':');
            final List<String> boldString = <String>[];
            if (str[str.length - 1].contains('<b>')) {
              str1 = <String>[];
              final List<String> boldSplit = str[str.length - 1].split('</b>');
              for (int i = 0; i < boldSplit.length; i++) {
                if (boldSplit[i] != '') {
                  boldString.add(boldSplit[i].substring(
                      boldSplit[i].indexOf('<b>') + 3, boldSplit[i].length));
                  final List<String> str2 = boldSplit[i].split('<b>');
                  for (int s = 0; s < str2.length; s++) {
                    str1.add(str2[s]);
                  }
                }
              }
            } else if (str1.length > 2 || xFormat || !isColon || headerText) {
              str1 = <String>[];
              str1.add(str[str.length - 1]);
            }
            double previousWidth = 0.0;
            for (int j = 0; j < str1.length; j++) {
              bool isBold = false;
              for (int i = 0; i < boldString.length; i++) {
                if (str1[j] == boldString[i]) {
                  isBold = true;
                  break;
                }
              }
              final double width =
                  j > 0 ? measureText(str1[j - 1], labelStyle).width : 0;
              previousWidth += width;
              String colon = boldString.isNotEmpty
                  ? ''
                  : j > 0
                      ? ' :'
                      : '';
              if (isRtl & !hasFormat) {
                colon = boldString.isNotEmpty
                    ? ''
                    : j > 0
                        ? ' : '
                        : '';
              }
              labelStyle = _getLabelStyle(
                  ((headerText && boldString.isEmpty) || xFormat || isBold)
                      ? FontWeight.bold
                      : j > 0
                          ? boldString.isNotEmpty
                              ? FontWeight.normal
                              : FontWeight.bold
                          : FontWeight.normal,
                  labelStyle);

              if (j == 0) {
                _drawTooltipMarker(
                    str1[j],
                    canvas,
                    tooltipRect,
                    animationFactor,
                    labelSize,
                    chartPointInfo[index].seriesRendererDetails!,
                    i,
                    previousWidth,
                    width,
                    eachTextHeight,
                    index);
              }
              markerPadding =
                  chart.trackballBehavior.tooltipSettings.canShowMarker
                      ? markerPadding +
                          (j == 0 && !isGroupMode
                              ? 13
                              : j == 0 && isGroupMode
                                  ? 7
                                  : 0)
                      : 0;
              final Offset textEndPoint = Offset(
                  isRtl
                      ? tooltipRect.right - textOffsetPadding - markerPadding
                      : markerPadding +
                          (tooltipRect.left + textOffsetPadding) +
                          (previousWidth > width ? previousWidth : width),
                  eachTextHeight - labelSize.height);

              if (!isRtl || (isRtl && !hasFormat)) {
                drawText(
                    canvas,
                    isRtl ? str1[j] + colon : colon + str1[j],
                    isRtl
                        ? Offset(
                            textEndPoint.dx -
                                (previousWidth > width
                                    ? previousWidth
                                    : width) -
                                measureText(str1[j] + colon, labelStyle).width,
                            textEndPoint.dy)
                        : textEndPoint,
                    labelStyle,
                    0);
              } else {
                _drawTextWithFormat(canvas, str1, labelStyle, textEndPoint);
                break;
              }
              headerText = false;
            }
          }
        }
      }
    }
  }

  void _drawTextWithFormat(Canvas canvas, List<String> textCollection,
      TextStyle labelStyle, Offset textEndPoint) {
    final String arrangedText = _getRtlStringWithColon(textCollection);
    final List<String> strings = arrangedText.split(':');
    double previousWidth = 0.0;
    for (int textCount = 0; textCount < strings.length; textCount++) {
      final bool containsBackSpace = strings[textCount].endsWith(' ');
      final bool containsFrontSpace = strings[textCount].startsWith(' ');
      strings[textCount] = strings[textCount].trim();
      if (containsFrontSpace) {
        strings[textCount] = '${strings[textCount]} ';
      }
      if (containsBackSpace) {
        strings[textCount] = ' ${strings[textCount]}';
      }
      final String currentText =
          textCount > 0 ? '${strings[textCount]}:' : (strings[textCount]);
      final Size currentTextSize = measureText(currentText, labelStyle);
      previousWidth += currentTextSize.width;
      drawText(
          canvas,
          currentText,
          Offset(textEndPoint.dx - previousWidth, textEndPoint.dy),
          labelStyle,
          0);
    }
  }

  String _getRtlStringWithColon(List<String> textCollection) {
    String string = '';
    for (int i = textCollection.length - 1; i >= 0; i--) {
      final bool containsBackSpace = textCollection[i].endsWith(' ');
      final bool containsFrontSpace = textCollection[i].startsWith(' ');
      textCollection[i] = textCollection[i].trim();
      if (containsFrontSpace) {
        textCollection[i] = '${textCollection[i]} ';
      }
      if (containsBackSpace) {
        textCollection[i] = ' ${textCollection[i]}';
      }
      string = string +
          (i == textCollection.length - 1
              ? textCollection[i]
              : ':${textCollection[i]}');
    }
    return string;
  }

  /// Draw marker inside the trackball tooltip.
  void _drawTooltipMarker(
      String labelValue,
      Canvas canvas,
      RRect tooltipRect,
      double animationFactor,
      Size tooltipMarkerResult,
      SeriesRendererDetails? seriesRendererDetails,
      int i,
      double? previousWidth,
      double? width,
      double eachTextHeight,
      int index,
      [Size? headerSize]) {
    final Size tooltipStringResult = tooltipMarkerResult;
    markerSize = 5;
    Offset markerPoint;
    final bool isRtl = stateProperties.renderingDetails.isRtl;
    if (chart.trackballBehavior.tooltipSettings.canShowMarker) {
      if (!isGroupMode) {
        if (seriesRendererDetails!.seriesType.contains('hilo') == true ||
            seriesRendererDetails.seriesType.contains('candle') == true ||
            seriesRendererDetails.seriesType.contains('boxandwhisker') ==
                true) {
          final double markerStartPoint = isRtl
              ? tooltipStringResult.width / 2 + markerSize
              : -tooltipMarkerResult.width / 2 - markerSize;
          markerPoint = Offset(
              tooltipRect.left + tooltipRect.width / 2 + markerStartPoint,
              (eachTextHeight - tooltipStringResult.height / 2) + 0.0);
          _renderMarker(markerPoint, seriesRendererDetails, animationFactor,
              canvas, index);
        } else {
          final double markerStartPoint = isRtl
              ? tooltipStringResult.width / 2 + markerSize
              : -tooltipMarkerResult.width / 2 - markerSize;
          markerPoint = Offset(
              tooltipRect.left + tooltipRect.width / 2 + markerStartPoint,
              ((tooltipRect.top + tooltipRect.height) -
                      tooltipStringResult.height / 2) -
                  markerSize);
        }
        _renderMarker(
            markerPoint, seriesRendererDetails, animationFactor, canvas, index);
      } else {
        if (i > 0 && labelValue != '') {
          seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
              stringValue[i].seriesRenderer!);
          // ignore: unnecessary_null_comparison
          if (seriesRendererDetails != null &&
              seriesRendererDetails.series.name != null &&
              seriesRendererDetails
                      .chart.trackballBehavior.tooltipSettings.format ==
                  null) {
            if (previousWidth != null && width != null) {
              final double markerStartPoint =
                  isRtl ? (tooltipRect.right - 10) : (tooltipRect.left + 10);
              markerPoint = Offset(
                  markerStartPoint +
                      (previousWidth > width ? previousWidth : width),
                  eachTextHeight - tooltipMarkerResult.height / 2);
              _renderMarker(markerPoint, seriesRendererDetails, animationFactor,
                  canvas, index);
            } else if (stringValue[i].needRender) {
              markerPoint = Offset(
                  isRtl ? tooltipRect.right - 10 : tooltipRect.left + 10,
                  (headerSize!.height * 2 +
                          tooltipRect.top +
                          markerSize +
                          headerSize.height / 2) +
                      (i == 1
                          ? 0
                          : lastMarkerResultHeight - headerSize.height));
              lastMarkerResultHeight = tooltipMarkerResult.height;
              stringValue[i].needRender = false;
              _renderMarker(markerPoint, seriesRendererDetails, animationFactor,
                  canvas, index);
            }
          } else {
            final double markerStartPoint = isRtl
                ? tooltipStringResult.width / 2 + markerSize
                : -tooltipMarkerResult.width / 2 - markerSize;
            markerPoint = Offset(
                (tooltipRect.left + tooltipRect.width / 2) + markerStartPoint,
                eachTextHeight - tooltipMarkerResult.height / 2);
            _renderMarker(markerPoint, seriesRendererDetails, animationFactor,
                canvas, index);
          }
        }
      }
    }
  }

  // To render marker for the chart tooltip.
  void _renderMarker(
      Offset markerPoint,
      SeriesRendererDetails seriesRendererDetails,
      double animationFactor,
      Canvas canvas,
      int index) {
    final MarkerSettings markerSettings =
        chart.trackballBehavior.markerSettings == null
            ? seriesRendererDetails.series.markerSettings
            : chart.trackballBehavior.markerSettings!;
    final Path markerPath = getMarkerShapesPath(
        markerSettings.shape,
        markerPoint,
        Size((2 * markerSize) * animationFactor,
            (2 * markerSize) * animationFactor),
        seriesRendererDetails,
        index,
        chart.trackballBehavior);

    if (markerSettings.shape == DataMarkerType.image) {
      drawImageMarker(null, canvas, markerPoint.dx, markerPoint.dy,
          chart.trackballBehavior.markerSettings, stateProperties);
    }

    Color? seriesColor;
    if (seriesRendererDetails.seriesType.contains('candle') == true) {
      seriesColor = SegmentHelper.getSegmentProperties(
              seriesRendererDetails.segments[
                  chartPointInfo[index].chartDataPoint!.visiblePointIndex!])
          .color;
    } else if (seriesRendererDetails.seriesType.contains('hiloopenclose') ==
        true) {
      seriesColor = SegmentHelper.getSegmentProperties(seriesRendererDetails
                          .segments[
                      chartPointInfo[index].chartDataPoint!.visiblePointIndex!])
                  .isBull ==
              true
          ? seriesRendererDetails.hiloOpenCloseSeries.bullColor
          : seriesRendererDetails.hiloOpenCloseSeries.bearColor;
    } else {
      final List<CartesianChartPoint<dynamic>> dataPoints =
          getSampledData(seriesRendererDetails);
      seriesColor = (chartPointInfo[index].dataPointIndex! < dataPoints.length
              ? dataPoints[
                      chartPointInfo[index].chartDataPoint!.visiblePointIndex!]
                  .pointColorMapper
              : null) ??
          seriesRendererDetails.seriesColor;
    }

    Paint markerPaint = Paint();
    markerPaint.color = markerSettings.color ?? seriesColor ?? Colors.white;
    if (seriesRendererDetails.series.gradient != null) {
      markerPaint = getLinearGradientPaint(
          seriesRendererDetails.series.gradient!,
          getMarkerShapesPath(
                  markerSettings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  seriesRendererDetails)
              .getBounds(),
          seriesRendererDetails.stateProperties.requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerPaint);
    Paint markerBorderPaint = Paint();
    markerBorderPaint.color = markerSettings.borderColor ??
        seriesColor ??
        seriesRendererDetails
            .stateProperties.renderingDetails.chartTheme.tooltipLabelColor;
    markerBorderPaint.strokeWidth = 1;
    markerBorderPaint.style = PaintingStyle.stroke;

    if (seriesRendererDetails.series.gradient != null) {
      markerBorderPaint = getLinearGradientPaint(
          seriesRendererDetails.series.gradient!,
          getMarkerShapesPath(
                  markerSettings.shape,
                  Offset(markerPoint.dx, markerPoint.dy),
                  Size((2 * markerSize) * animationFactor,
                      (2 * markerSize) * animationFactor),
                  seriesRendererDetails)
              .getBounds(),
          seriesRendererDetails.stateProperties.requireInvertedAxis);
    }
    canvas.drawPath(markerPath, markerBorderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Return value as string.
  String getFormattedValue(num value) => value.toString();
}
