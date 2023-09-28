import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/tooltip_internal.dart';

import '../../../charts.dart';
import '../../chart/axis/axis.dart';
import '../../chart/axis/category_axis.dart';
import '../../chart/axis/datetime_axis.dart';
import '../../chart/axis/datetime_category_axis.dart';
import '../../chart/axis/logarithmic_axis.dart';
import '../../chart/axis/multi_level_labels.dart' show AxisMultiLevelLabel;
import '../../chart/axis/numeric_axis.dart';
import '../../chart/chart_series/series.dart';
import '../../chart/chart_series/series_renderer_properties.dart';
import '../../chart/common/cartesian_state_properties.dart';
import '../../chart/utils/helper.dart';
import '../../circular_chart/base/circular_state_properties.dart';
import '../../circular_chart/renderer/common.dart';
import '../../circular_chart/utils/helper.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../rendering_details.dart';
import '../utils/helper.dart';
import 'tooltip.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Represents the tooltip rendering details.
class TooltipRenderingDetails {
  /// Creates an instance of tooltip rendering details.
  TooltipRenderingDetails(this._stateProperties);
  final dynamic _stateProperties;

  /// Gets the instance of tooltip behavior.
  TooltipBehavior get tooltipBehavior =>
      _stateProperties.chart.tooltipBehavior as TooltipBehavior;

  /// Specifies the chart tooltip value.
  SfTooltip? chartTooltip;

  /// Specifies whether interaction is done.
  bool isInteraction = false;

  /// Specifies the tooltip is hovered.
  bool isHovering = false, _mouseTooltip = false;

  /// Specifies the toopltip template.
  Widget? tooltipTemplate;

  /// Specifies the value of tooltip render box.
  TooltipRenderBox? get renderBox => chartTooltipState?.renderBox;

  /// Specifies the chart tooltip state.
  SfTooltipState? get chartTooltipState {
    State? state;
    if (chartTooltip != null) {
      state = (chartTooltip?.key as GlobalKey).currentState;
    }
    //ignore: avoid_as
    return state != null ? state as SfTooltipState : null;
  }

  List<String> _textValues = <String>[];
  List<CartesianSeriesRenderer> _seriesRendererCollection =
      <CartesianSeriesRenderer>[];

  /// Specifies the previous tooltip value.
  TooltipValue? prevTooltipValue;
  TooltipValue? _presentTooltipValue;

  /// Hold the previous tooltip values and this is used to show the tooltip in dynamic update cases using the public methods.
  TooltipValue? prevTooltipData;

  /// Specifies the current tooltip value.
  TooltipValue? currentTooltipValue;

  SeriesRendererDetails? _seriesRendererDetails;

  /// Specifies the value of current series and the current data point.
  dynamic currentSeriesDetails, _dataPoint;

  /// Specifies tooltip point index.
  int? pointIndex;

  /// Holds the series index value.
  late int seriesIndex;
  late Color _markerColor;
  late DataMarkerType _markerType;

  /// Specifies the tooltip timer.
  Timer? timer;

  /// Specifies whether the tooltip is shown.
  bool show = false;

  /// Holds the offset value of show location.
  Offset? showLocation;

  /// Holds the boolean value to decide rendering position of tooltip.
  bool showTooltipPosition = false;

  /// Holds the dynamic values of the tooltip enabled data point.
  dynamic dataPointValues;

  ///  Holds the value of tooltip bounds.
  Rect? tooltipBounds;
  String? _stringVal, _header;
  // ignore: avoid_setters_without_getters
  set _stringValue(String? value) {
    _stringVal = value;
  }

  /// To render chart tooltip.
  // ignore:unused_element
  void _renderTooltipView(Offset position) {
    if (_stateProperties.chart is SfCartesianChart) {
      _renderCartesianChartTooltip(position);
    } else if (_stateProperties.chart is SfCircularChart) {
      _renderCircularChartTooltip(position);
    } else {
      _renderTriangularChartTooltip(position);
    }
  }

  /// To show tooltip with position offsets.
  void showTooltip(double? x, double? y) {
    if (x != null &&
        y != null &&
        renderBox != null &&
        chartTooltipState != null) {
      show = true;
      chartTooltipState?.needMarker = true;
      _mouseTooltip = false;
      isHovering ? _showMouseTooltip(x, y) : showTooltipView(x, y);
    }
  }

  /// To show the chart tooltip.
  void showTooltipView(double x, double y) {
    if (tooltipBehavior.enable &&
        renderBox != null &&
        _stateProperties.animationCompleted == true) {
      _renderTooltipView(Offset(x, y));
      if (_presentTooltipValue != null &&
          tooltipBehavior.tooltipPosition != TooltipPosition.pointer) {
        chartTooltipState!.boundaryRect = tooltipBounds!;
        if (showLocation != null) {
          chartTooltipState?.needMarker =
              _stateProperties.chart is SfCartesianChart;
          _resolveLocation();
          chartTooltipState?.show(
              tooltipHeader: _header,
              tooltipContent: _stringVal,
              tooltipData: _presentTooltipValue,
              position: showLocation,
              duration: _stateProperties.isTooltipOrientationChanged == true
                  ? 0
                  : tooltipBehavior.animationDuration);
        }
      } else {
        if (tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
            ((_stateProperties.chart is SfCartesianChart) == false ||
                currentSeriesDetails.isRectSeries == true)) {
          _presentTooltipValue?.pointerPosition = showLocation;
          chartTooltipState!.boundaryRect = tooltipBounds!;
          if (showLocation != null) {
            chartTooltipState?.needMarker =
                _stateProperties.chart is SfCartesianChart;
            chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: showLocation,
                duration: _stateProperties.isTooltipOrientationChanged == true
                    ? 0
                    : tooltipBehavior.animationDuration);
          }
          currentTooltipValue = _presentTooltipValue;
        }
      }
      assert(
          // ignore: unnecessary_null_comparison
          !(tooltipBehavior.duration != null) || tooltipBehavior.duration >= 0,
          'The duration time for the tooltip must not be less than 0.');
      if (!tooltipBehavior.shouldAlwaysShow) {
        show = false;
        currentTooltipValue = _presentTooltipValue = null;
        if (chartTooltipState != null && renderBox != null) {
          if (_stateProperties.isTooltipOrientationChanged == false) {
            // Cancelled timer as we have used timer in chart now.
            if (timer != null) {
              timer?.cancel();
            }
            timer = Timer(
                Duration(milliseconds: tooltipBehavior.duration.toInt()), () {
              chartTooltipState?.hide(hideDelay: 0);
              _stateProperties.isTooltipHidden = true;
              if (_stateProperties.isTooltipOrientationChanged == true) {
                _stateProperties.isTooltipOrientationChanged = false;
              }
            });
          }
        }
      }
    }
  }

  /// This method resolves the position issue when the markerPoint is residing.
  /// out of the axis cliprect
  void _resolveLocation() {
    if (_stateProperties.chart is SfCartesianChart &&
        tooltipBehavior.tooltipPosition == TooltipPosition.auto &&
        (_seriesRendererDetails!.isRectSeries == true ||
            _seriesRendererDetails!.seriesType.contains('bubble') == true ||
            _seriesRendererDetails!.seriesType.contains('candle') == true ||
            _seriesRendererDetails!.seriesType.contains('boxandwhisker') ==
                true ||
            _seriesRendererDetails!.seriesType.contains('waterfall') == true)) {
      Offset position = showLocation!;
      final CartesianStateProperties cartesianStateProperties =
          _stateProperties as CartesianStateProperties;
      final Rect bounds = cartesianStateProperties.chartAxis.axisClipRect;
      if (!_isPointWithInRect(position, bounds)) {
        if (position.dy < bounds.top) {
          position = Offset(position.dx, bounds.top);
        }
        if (position.dx < bounds.left) {
          position = Offset(bounds.left, position.dy);
        } else if (position.dx > bounds.right) {
          position = Offset(bounds.right, position.dy);
        }
      }
      showLocation = position;
    }
  }

  /// This method shows the tooltip for any logical pixel outside point region.
  //ignore: unused_element
  void showChartAreaTooltip(
      Offset position,
      ChartAxisRendererDetails xAxisDetails,
      ChartAxisRendererDetails yAxisDetails,
      dynamic chart) {
    showLocation = position;
    final CartesianStateProperties cartesianStateProperties =
        _stateProperties as CartesianStateProperties;
    final ChartAxis xAxis = xAxisDetails.axis, yAxis = yAxisDetails.axis;
    if (tooltipBehavior.enable &&
        renderBox != null &&
        cartesianStateProperties.animationCompleted == true) {
      tooltipBounds = cartesianStateProperties.chartAxis.axisClipRect;
      chartTooltipState!.boundaryRect = tooltipBounds!;
      if (_isPointWithInRect(
          position, cartesianStateProperties.chartAxis.axisClipRect)) {
        currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(
            cartesianStateProperties.chartSeries.visibleSeriesRenderers[0]);
        renderBox!.normalPadding = 5;
        renderBox!.inversePadding = 5;
        _header = '';
        dynamic xValue = pointToXValue(
            cartesianStateProperties.requireInvertedAxis,
            xAxisDetails.axisRenderer,
            xAxisDetails.bounds,
            position.dx -
                (cartesianStateProperties.chartAxis.axisClipRect.left +
                    xAxis.plotOffset),
            position.dy -
                (cartesianStateProperties.chartAxis.axisClipRect.top +
                    xAxis.plotOffset));
        dynamic yValue = pointToYValue(
            cartesianStateProperties.requireInvertedAxis,
            yAxisDetails.axisRenderer,
            yAxisDetails.bounds,
            position.dx -
                (cartesianStateProperties.chartAxis.axisClipRect.left +
                    yAxis.plotOffset),
            position.dy -
                (cartesianStateProperties.chartAxis.axisClipRect.top +
                    yAxis.plotOffset));
        if (xAxisDetails is DateTimeAxisDetails) {
          final DateTimeAxis xAxis = xAxisDetails.axis as DateTimeAxis;
          final num interval = xAxisDetails.visibleRange!.minimum.ceil();
          final num prevInterval = (xAxisDetails.visibleLabels.isNotEmpty)
              ? xAxisDetails
                  .visibleLabels[xAxisDetails.visibleLabels.length - 1].value
              : interval;
          xValue = (xAxis.dateFormat ??
                  getDateTimeLabelFormat(xAxisDetails.axisRenderer,
                      interval.toInt(), prevInterval.toInt()))
              .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        } else if (xAxisDetails is DateTimeCategoryAxisDetails) {
          final DateTimeCategoryAxis xAxis =
              xAxisDetails.axis as DateTimeCategoryAxis;
          final num interval = xAxisDetails.visibleRange!.minimum.ceil();
          final num prevInterval = (xAxisDetails.visibleLabels.isNotEmpty)
              ? xAxisDetails
                  .visibleLabels[xAxisDetails.visibleLabels.length - 1].value
              : interval;
          xValue = (xAxis.dateFormat ??
                  getDateTimeLabelFormat(xAxisDetails.axisRenderer,
                      interval.toInt(), prevInterval.toInt()))
              .format(DateTime.fromMillisecondsSinceEpoch(xValue.floor()));
        } else if (xAxisDetails is CategoryAxisDetails) {
          xValue = xAxisDetails.visibleLabels[xValue.toInt()].text;
        } else if (xAxisDetails is NumericAxisDetails) {
          xValue = xValue.toStringAsFixed(2).contains('.00') == true
              ? xValue.floor()
              : xValue.toStringAsFixed(2);
        }
        if (yAxisDetails is NumericAxisDetails ||
            yAxisDetails is LogarithmicAxisDetails) {
          yValue = yValue.toStringAsFixed(2).contains('.00') == true
              ? yValue.floor()
              : yValue.toStringAsFixed(2);
        }
        _stringValue = ' $xValue :  $yValue ';
        showLocation = position;
      }
      if (_isPointWithInRect(
          position, cartesianStateProperties.chartAxis.axisClipRect)) {
        if (showLocation != null &&
            _stringVal != null &&
            tooltipBounds != null) {
          chartTooltipState?.needMarker = false;
          chartTooltipState?.show(
              tooltipHeader: _header,
              tooltipContent: _stringVal,
              tooltipData: _presentTooltipValue,
              position: showLocation,
              duration: _stateProperties.isTooltipOrientationChanged == true
                  ? 0
                  : tooltipBehavior.animationDuration);
        }
      }

      if (!tooltipBehavior.shouldAlwaysShow) {
        show = false;
        if (chartTooltipState != null && renderBox != null) {
          chartTooltipState?.hide();
        }
      }
    }
  }

  /// Method to show the tooltip with template.
  void showTemplateTooltip(Offset position, [dynamic xValue, dynamic yValue]) {
    _stateProperties.isTooltipHidden = false;
    final CartesianStateProperties cartesianStateProperties =
        _stateProperties as CartesianStateProperties;
    final dynamic chart = cartesianStateProperties.chart;
    _presentTooltipValue = null;
    tooltipBounds = cartesianStateProperties.chartAxis.axisClipRect;
    dynamic series;
    double yPadding = 0;
    if (_isPointWithInRect(
            position, cartesianStateProperties.chartAxis.axisClipRect) &&
        cartesianStateProperties.animationCompleted == true) {
      int? seriesIndex;
      int outlierIndex = -1;
      bool isTooltipRegion = false;
      if (!isHovering) {
        // Assigning null for the previous and current tooltip values in case of mouse not hovering.
        prevTooltipValue = null;
        currentTooltipValue = null;
      }
      for (int i = 0;
          i <
              cartesianStateProperties
                  .chartSeries.visibleSeriesRenderers.length;
          i++) {
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(
                cartesianStateProperties.chartSeries.visibleSeriesRenderers[i]);
        series = seriesRendererDetails.series;

        int j = 0;
        if (seriesRendererDetails.visible! == true &&
            series.enableTooltip == true &&
            seriesRendererDetails.regionalData != null) {
          seriesRendererDetails.regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final bool isTrendLine = values[values.length - 1].contains('true');
            final double padding = ((seriesRendererDetails.seriesType ==
                            'bubble' ||
                        seriesRendererDetails.seriesType == 'scatter' ||
                        seriesRendererDetails.seriesType.contains('column') ==
                            true ||
                        seriesRendererDetails.seriesType.contains('bar') ==
                            true ||
                        seriesRendererDetails.seriesType == 'histogram') &&
                    !isTrendLine)
                ? 0
                : isHovering
                    ? 0
                    : 15;
            final Rect region = regionRect[0];
            final double left = region.left - padding;
            final double right = region.right + padding;
            final double top = region.top - padding;
            final double bottom = region.bottom + padding;
            Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            final List<Rect>? outlierRegion = regionRect[5];

            if (outlierRegion != null) {
              for (int rectIndex = 0;
                  rectIndex < outlierRegion.length;
                  rectIndex++) {
                if (outlierRegion[rectIndex].contains(position)) {
                  paddedRegion = outlierRegion[rectIndex];
                  outlierIndex = rectIndex;
                }
              }
            }

            if (paddedRegion.contains(position)) {
              seriesIndex = seriesIndex = i;
              currentSeriesDetails = seriesRendererDetails;
              pointIndex =
                  seriesRendererDetails.dataPoints.indexOf(regionRect[4]);
              Offset tooltipPosition = !(seriesRendererDetails.isRectSeries ==
                          true &&
                      tooltipBehavior.tooltipPosition != TooltipPosition.auto)
                  ? ((outlierIndex >= 0)
                      ? regionRect[6][outlierIndex]
                      : regionRect[1])
                  : position;
              final List<Offset?> paddingData = getTooltipPaddingData(
                  seriesRendererDetails,
                  isTrendLine,
                  region,
                  paddedRegion,
                  tooltipPosition);
              yPadding = paddingData[0]!.dy;
              tooltipPosition = paddingData[1] ?? tooltipPosition;
              showLocation = tooltipPosition;
              _seriesRendererDetails = seriesRendererDetails;
              renderBox!.normalPadding =
                  _seriesRendererDetails!.renderer is BubbleSeriesRenderer
                      ? 0
                      : yPadding;
              renderBox!.inversePadding = yPadding;
              tooltipTemplate = chart.tooltipBehavior.builder(
                  series.dataSource[j], regionRect[4], series, pointIndex, i);
              isTooltipRegion = true;
            }
            j++;
          });
        }
      }
      if (isHovering && isTooltipRegion) {
        prevTooltipValue = currentTooltipValue;
        currentTooltipValue =
            TooltipValue(seriesIndex, pointIndex!, outlierIndex);
      }
      final TooltipValue? presentTooltip = _presentTooltipValue;
      if (presentTooltip == null ||
          seriesIndex != presentTooltip.seriesIndex ||
          outlierIndex != presentTooltip.outlierIndex ||
          (currentSeriesDetails != null &&
              currentSeriesDetails.isRectSeries == true &&
              tooltipBehavior.tooltipPosition != TooltipPosition.auto)) {
        // Current point is different than previous one so tooltip re-renders.
        if (seriesIndex != null && pointIndex != null) {
          _presentTooltipValue =
              TooltipValue(seriesIndex, pointIndex!, outlierIndex);
        }

        if (isTooltipRegion && tooltipTemplate != null) {
          show = isTooltipRegion;
          performTooltip();
          if (!isHovering && renderBox != null) {
            hideTooltipTemplate();
          }
        }
      } else {
        // Current point is same as previous one so timer is reset and tooltip is not re-rendered.
        if (!isHovering) {
          hideTooltipTemplate();
        }
      }

      if (!isTooltipRegion &&
          !isInteraction &&
          chart.series.isNotEmpty == true) {
        // To show tooltip template when the position resides outside point region.
        final dynamic x = xValue ??
            pointToXValue(
                cartesianStateProperties.requireInvertedAxis,
                cartesianStateProperties
                    .chartAxis.primaryXAxisDetails.axisRenderer,
                cartesianStateProperties.chartAxis.primaryXAxisDetails.bounds,
                position.dx -
                    (cartesianStateProperties.chartAxis.axisClipRect.left +
                        chart.primaryXAxis.plotOffset),
                position.dy -
                    (cartesianStateProperties.chartAxis.axisClipRect.top +
                        chart.primaryXAxis.plotOffset));
        final dynamic y = yValue ??
            pointToYValue(
                cartesianStateProperties.requireInvertedAxis,
                cartesianStateProperties
                    .chartAxis.primaryYAxisDetails.axisRenderer,
                cartesianStateProperties.chartAxis.primaryYAxisDetails.bounds,
                position.dx -
                    (cartesianStateProperties.chartAxis.axisClipRect.left +
                        chart.primaryYAxis.plotOffset),
                position.dy -
                    (cartesianStateProperties.chartAxis.axisClipRect.top +
                        chart.primaryYAxis.plotOffset));
        renderBox!.normalPadding = 5;
        renderBox!.inversePadding = 5;
        showLocation = position;
        tooltipTemplate = chart.tooltipBehavior.builder(
            null, CartesianChartPoint<dynamic>(x, y), null, null, null);
        isTooltipRegion = true;
        show = isTooltipRegion;
        performTooltip();
      }
      if (!isTooltipRegion) {
        hideTooltipTemplate();
      }
    }
    isInteraction = false;
  }

  /// Tooltip show by Index.
  void internalShowByIndex(int seriesIndex, int pointIndex) {
    final dynamic chart = _stateProperties.chart;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
    dynamic x, y;
    if (chart is SfCartesianChart) {
      if (validIndex(pointIndex, seriesIndex, chart)) {
        final CartesianSeriesRenderer currentSeriesRenderer =
            _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
        final SeriesRendererDetails cartesianSeriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(_stateProperties
                .chartSeries.visibleSeriesRenderers[seriesIndex]);
        // ignore: unnecessary_null_comparison
        if (pointIndex != null &&
            pointIndex.abs() <
                cartesianSeriesRendererDetails.dataPoints.length) {
          if (cartesianSeriesRendererDetails.visible! == true) {
            if ((currentSeriesRenderer is BarSeriesRenderer ||
                    currentSeriesRenderer is StackedBarSeriesRenderer ||
                    currentSeriesRenderer is StackedBar100SeriesRenderer &&
                        !chart.isTransposed) ||
                (currentSeriesRenderer is ColumnSeriesRenderer ||
                    currentSeriesRenderer is StackedColumnSeriesRenderer ||
                    currentSeriesRenderer is StackedColumn100SeriesRenderer &&
                        chart.isTransposed) ||
                currentSeriesRenderer is RangeColumnSeriesRenderer &&
                    chart.isTransposed ||
                currentSeriesRenderer is BoxAndWhiskerSeriesRenderer) {
              if (currentSeriesRenderer is BoxAndWhiskerSeriesRenderer) {
                x = cartesianSeriesRendererDetails
                    .dataPoints[pointIndex].region?.centerRight.dx;
                y = cartesianSeriesRendererDetails
                    .dataPoints[pointIndex].region?.centerRight.dy;
              } else {
                x = cartesianSeriesRendererDetails
                    .dataPoints[pointIndex].region?.topCenter.dx;
                y = cartesianSeriesRendererDetails
                    .dataPoints[pointIndex].region?.topCenter.dy;
              }
            } else {
              x = cartesianSeriesRendererDetails
                  .dataPoints[pointIndex].markerPoint!.x;
              y = cartesianSeriesRendererDetails
                  .dataPoints[pointIndex].markerPoint!.y;
            }
          }
        }
      }
      if (x != null && y != null && chart.series[seriesIndex].enableTooltip) {
        if (chart.tooltipBehavior.builder != null) {
          tooltipRenderingDetails.showTemplateTooltip(Offset(x, y));
        } else if (chart.series[seriesIndex].enableTooltip) {
          tooltipRenderingDetails.showTooltip(x, y);
        }
      }
    } else if (chart is SfCircularChart) {
      if (chart.tooltipBehavior.builder != null &&
          seriesIndex < chart.series.length &&
          pointIndex <
              _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
                  .dataPoints.length &&
          chart.series[seriesIndex].enableTooltip) {
        // To show the tooltip template when the provided indices are valid.
        _stateProperties.circularArea
            .showCircularTooltipTemplate(seriesIndex, pointIndex);
      } else if (chart.tooltipBehavior.builder == null &&
          _stateProperties.animationCompleted == true &&
          pointIndex >= 0 &&
          (pointIndex + 1 <=
              _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
                  .renderPoints.length)) {
        final ChartPoint<dynamic> chartPoint = _stateProperties.chartSeries
            .visibleSeriesRenderers[seriesIndex].renderPoints[pointIndex];
        if (chartPoint.isVisible) {
          final Offset position = degreeToPoint(
              chartPoint.midAngle!,
              (chartPoint.innerRadius! + chartPoint.outerRadius!) / 2,
              chartPoint.center!);
          x = position.dx;
          y = position.dy;
          tooltipRenderingDetails.showTooltip(x, y);
        }
      }
    } else if (pointIndex != null && // ignore: unnecessary_null_comparison
        pointIndex <
            _stateProperties
                .chartSeries.visibleSeriesRenderers[0].dataPoints.length) {
      // This shows the tooltip for triangular type of charts (funnel and pyramid).
      if (chart.tooltipBehavior.builder == null) {
        _stateProperties.tooltipPointIndex = pointIndex;
        final Offset? position = _stateProperties.chartSeries
            .visibleSeriesRenderers[0].dataPoints[pointIndex].region?.center;
        x = position?.dx;
        y = position?.dy;
        tooltipRenderingDetails.showTooltip(x, y);
      } else {
        if (chart is SfFunnelChart &&
            _stateProperties.animationCompleted == true) {
          _stateProperties.funnelplotArea.showFunnelTooltipTemplate(pointIndex);
        } else if (chart is SfPyramidChart &&
            _stateProperties.animationCompleted == true) {
          _stateProperties.chartPlotArea.showPyramidTooltipTemplate(pointIndex);
        }
      }
    }
    tooltipRenderingDetails.isInteraction = false;
  }

  /// Tooltip show by pixel.
  void internalShowByPixel(double x, double y) {
    prevTooltipData = null;
    showTooltipPosition = true;
    _stateProperties.isTooltipHidden = false;
    final dynamic chart = _stateProperties.chart;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        _stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
    bool? isInsidePointRegion;
    String text = '';
    String trimmedText = '';
    Offset? axisLabelPosition;
    if (chart is SfCartesianChart) {
      _stateProperties.requireAxisTooltip = false;
      for (int i = 0;
          i < _stateProperties.chartAxis.axisRenderersCollection.length;
          i++) {
        final ChartAxisRendererDetails axisDetails =
            AxisHelper.getAxisRendererDetails(
                _stateProperties.chartAxis.axisRenderersCollection[i]);
        final List<AxisLabel> labels = axisDetails.visibleLabels;
        for (int k = 0; k < labels.length; k++) {
          if (axisDetails.axis.isVisible == true &&
              AxisHelper.getLabelRegion(labels[k]) != null &&
              AxisHelper.getLabelRegion(labels[k])!.contains(Offset(x, y))) {
            _stateProperties.requireAxisTooltip = true;
            text = labels[k].text;
            trimmedText = labels[k].renderText ?? '';
            tooltipRenderingDetails.prevTooltipValue =
                tooltipRenderingDetails.currentTooltipValue;
            axisLabelPosition = AxisHelper.getLabelRegion(labels[k])!.center;
            // -3 to indicate axis tooltip
            tooltipRenderingDetails.currentTooltipValue =
                TooltipValue(null, k, 0);
          }
        }
        if (axisDetails.visibleAxisMultiLevelLabels.isNotEmpty) {
          final List<AxisMultiLevelLabel> multiLabelList =
              axisDetails.visibleAxisMultiLevelLabels;
          for (int k = 0; k < multiLabelList.length; k++) {
            if (axisDetails.axis.isVisible == true &&
                multiLabelList[k].multiLabelRegion != null) {
              final Rect labelRect = multiLabelList[k].multiLabelRegion!;
              final Offset rectCenter = labelRect.center;
              final Rect rectRegion = Rect.fromLTWH(
                  rectCenter.dx - labelRect.width.abs() / 2,
                  rectCenter.dy - labelRect.height.abs() / 2,
                  labelRect.width.abs(),
                  labelRect.height.abs());
              if (rectRegion.contains(Offset(x, y))) {
                _stateProperties.requireAxisTooltip = true;
                text = multiLabelList[k].text!;
                trimmedText = multiLabelList[k].renderText ?? '';
                tooltipRenderingDetails.prevTooltipValue =
                    tooltipRenderingDetails.currentTooltipValue;
                axisLabelPosition = multiLabelList[k].multiLabelRegion!.center;
                tooltipRenderingDetails.currentTooltipValue =
                    TooltipValue(null, k, 0);
              }
            }
          }
        }
      }
    }
    if (chart is SfCartesianChart &&
        _stateProperties.requireAxisTooltip == false) {
      for (int i = 0;
          i < _stateProperties.chartSeries.visibleSeriesRenderers.length;
          i++) {
        final SeriesRendererDetails seriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(
                _stateProperties.chartSeries.visibleSeriesRenderers[i]);
        if (seriesRendererDetails.visible! == true &&
            seriesRendererDetails.series.enableTooltip == true &&
            seriesRendererDetails.regionalData != null) {
          final String seriesType = seriesRendererDetails.seriesType;
          seriesRendererDetails.regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            final Rect region = regionRect[0];
            final bool isTrendLine = values[values.length - 1].contains('true');
            final double padding = ((seriesType == 'bubble' ||
                        seriesType == 'scatter' ||
                        seriesType.contains('column') ||
                        seriesType.contains('bar')) &&
                    !isTrendLine)
                ? 0
                : tooltipRenderingDetails.isHovering == true
                    ? 0
                    : 15; // regional padding to detect smooth touch
            final Rect paddedRegion = Rect.fromLTRB(
                region.left - padding,
                region.top - padding,
                region.right + padding,
                region.bottom + padding);
            bool outlierTooltip = false;
            if (seriesRendererDetails.seriesType == 'boxandwhisker') {
              final List<Rect>? outlierRegion = regionRect[5];
              if (outlierRegion != null) {
                for (int rectIndex = 0;
                    rectIndex < outlierRegion.length;
                    rectIndex++) {
                  if (outlierRegion[rectIndex].contains(Offset(x, y))) {
                    outlierTooltip = true;
                    break;
                  }
                }
              }
            }
            if (paddedRegion.contains(Offset(x, y)) || outlierTooltip) {
              isInsidePointRegion = true;
              return;
            }
          });
        }
        if (isInsidePointRegion != null && isInsidePointRegion!) {
          break;
        }
      }
    }
    if (chart is SfCartesianChart &&
        chart.tooltipBehavior.activationMode != ActivationMode.none &&
        // ignore: unnecessary_null_comparison
        x != null &&
        // ignore: unnecessary_null_comparison
        y != null &&
        _stateProperties.requireAxisTooltip == true) {
      final SfTooltipState? tooltipState =
          tooltipRenderingDetails.chartTooltipState;
      if (trimmedText.contains('...')) {
        tooltipRenderingDetails.show = true;
        tooltipState?.needMarker = false;
        tooltipRenderingDetails.showTrimmedTooltip(
            axisLabelPosition!, chart, text);
      } else {
        tooltipRenderingDetails.show = false;
        if (!chart.tooltipBehavior.shouldAlwaysShow) {
          if (_stateProperties.isTooltipOrientationChanged == false) {
            // Cancelled timer as we have used timer in chart now.
            if (timer != null) {
              timer?.cancel();
            }
            timer = Timer(
                Duration(milliseconds: chart.tooltipBehavior.duration.toInt()),
                () {
              tooltipRenderingDetails.chartTooltipState?.hide(hideDelay: 0);
              _stateProperties.isTooltipHidden = true;
              if (_stateProperties.isTooltipOrientationChanged == true) {
                _stateProperties.isTooltipOrientationChanged = false;
              }
            });
          }
        }
      }
    } else if (chart is SfCircularChart &&
        _stateProperties.requireDataLabelTooltip == true) {
      final List<ChartPoint<dynamic>> renderPoints =
          _stateProperties.chartSeries.visibleSeriesRenderers[0].renderPoints;
      final SfTooltipState? tooltipState =
          tooltipRenderingDetails.chartTooltipState;
      for (int i = 0; i < renderPoints.length; i++) {
        if (renderPoints[i].labelRect.contains(Offset(x, y)) &&
            renderPoints[i].trimmedText != null &&
            renderPoints[i].trimmedText!.contains('...')) {
          Offset position;
          final num textWidth = measureText(
                  renderPoints[i].overflowTrimmedText ??
                      renderPoints[i].trimmedText!,
                  _stateProperties.chartSeries.visibleSeriesRenderers[0]
                      .dataLabelSettingsRenderer.textStyle)
              .width;
          if (renderPoints[i].dataLabelPosition == Position.left) {
            position = Offset(renderPoints[i].labelRect.right - textWidth / 2,
                renderPoints[i].labelRect.center.dy);
          } else {
            position = Offset(renderPoints[i].labelRect.left + textWidth / 2,
                renderPoints[i].labelRect.center.dy);
          }
          if ((chart.tooltipBehavior.enable != true &&
                  _stateProperties
                          .chartSeries
                          .visibleSeriesRenderers[0]
                          .dataLabelSettingsRenderer
                          .dataLabelSettings
                          .labelPosition ==
                      ChartDataLabelPosition.inside) ||
              renderPoints[i].renderPosition ==
                  ChartDataLabelPosition.outside) {
            tooltipRenderingDetails.show = true;
            tooltipState?.needMarker = false;
            tooltipRenderingDetails.showTrimmedTooltip(position, chart,
                renderPoints[i].overflowTrimmedText ?? renderPoints[i].text!);
          }
        }
      }
    } else if (tooltipRenderingDetails.chartTooltip != null &&
        // ignore: unnecessary_null_comparison
        x != null &&
        // ignore: unnecessary_null_comparison
        y != null) {
      final SfTooltipState? tooltipState =
          tooltipRenderingDetails.chartTooltipState;
      if ((chart is SfCartesianChart) == false ||
          tooltipRenderingDetails.isInteraction == true ||
          (isInsidePointRegion ?? false)) {
        final bool isHovering = tooltipRenderingDetails.isHovering;
        if ((isInsidePointRegion ?? false) ||
            isHovering ||
            (chart is SfCartesianChart) == false) {
          tooltipRenderingDetails.showTooltip(x, y);
        } else {
          tooltipRenderingDetails.show = false;
          if (chart.tooltipBehavior.shouldAlwaysShow == false) {
            hide();
          }
        }
      } else if (tooltipRenderingDetails.renderBox != null) {
        tooltipRenderingDetails.show = true;
        tooltipState?.needMarker = false;
        tooltipRenderingDetails.showChartAreaTooltip(
            Offset(x, y),
            _stateProperties.chartAxis.primaryXAxisDetails,
            _stateProperties.chartAxis.primaryYAxisDetails,
            chart);
      }
    }
    if (chart is SfCartesianChart &&
        chart.tooltipBehavior.builder != null &&
        x != null && // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        y != null) {
      tooltipRenderingDetails.showTemplateTooltip(Offset(x, y));
    }
    // ignore: unnecessary_null_comparison
    if (tooltipBehaviorRenderer != null) {
      tooltipRenderingDetails.isInteraction = false;
    }
  }

  /// To hide the tooltip when the timer ends.
  void hide() {
    if (!tooltipBehavior.shouldAlwaysShow) {
      show = false;
      currentTooltipValue = _presentTooltipValue = null;
      if (chartTooltipState != null && renderBox != null) {
        if (_stateProperties.isTooltipOrientationChanged == false) {
          // Cancelled timer as we have used timer in chart now.
          if (timer != null) {
            timer?.cancel();
          }
          timer = Timer(
              Duration(milliseconds: tooltipBehavior.duration.toInt()), () {
            chartTooltipState?.hide(hideDelay: 0);
            _stateProperties.isTooltipHidden = true;
            if (_stateProperties.isTooltipOrientationChanged == true) {
              _stateProperties.isTooltipOrientationChanged = false;
            }
          });
        }
      }
    }
  }

  /// To hide tooltip template with timer
  // void hideOnTimer() {
  //   if (prevTooltipValue == null && currentTooltipValue == null) {
  //     hideTooltipTemplate();
  //   } else {
  //     timer?.cancel();
  //     timer = Timer(Duration(milliseconds: tooltipBehavior.duration.toInt()),
  //         hideTooltipTemplate);
  //   }
  // }

  /// To hide tooltip templates.
  void hideTooltipTemplate() {
    if (tooltipBehavior.shouldAlwaysShow == false) {
      show = false;
      if (_stateProperties.isTooltipOrientationChanged == false) {
        // Cancelled timer as we have used timer in chart now.
        if (timer != null) {
          timer?.cancel();
        }
        timer =
            Timer(Duration(milliseconds: tooltipBehavior.duration.toInt()), () {
          chartTooltipState?.hide(hideDelay: 0);
          _stateProperties.isTooltipHidden = true;
          if (_stateProperties.isTooltipOrientationChanged == true) {
            _stateProperties.isTooltipOrientationChanged = false;
          }
        });
      }
      prevTooltipValue = null;
      currentTooltipValue = null;
      _presentTooltipValue = null;
    }
  }

  /// To perform rendering of tooltip.
  void performTooltip() {
    // For mouse hover the tooltip is redrawn only when the current tooltip value differs from the previous one.
    if (show &&
        ((prevTooltipValue == null && currentTooltipValue == null) ||
            (_stateProperties.chartState is SfCartesianChartState &&
                (currentSeriesDetails?.isRectSeries ?? false) == true &&
                tooltipBehavior.tooltipPosition != TooltipPosition.auto) ||
            (prevTooltipValue?.seriesIndex !=
                    currentTooltipValue?.seriesIndex ||
                prevTooltipValue?.outlierIndex !=
                    currentTooltipValue?.outlierIndex ||
                prevTooltipValue?.pointIndex !=
                    currentTooltipValue?.pointIndex))) {
      final bool reRender = isHovering &&
          prevTooltipValue != null &&
          currentTooltipValue != null &&
          prevTooltipValue!.seriesIndex == currentTooltipValue!.seriesIndex &&
          prevTooltipValue!.pointIndex == currentTooltipValue!.pointIndex &&
          prevTooltipValue!.outlierIndex == currentTooltipValue!.outlierIndex;
      if (tooltipBehavior.builder != null && tooltipBounds != null) {
        chartTooltipState!.boundaryRect = tooltipBounds!;
        if (tooltipBehavior.tooltipPosition != TooltipPosition.auto)
          _presentTooltipValue!.pointerPosition = showLocation;
        if (showLocation != null) {
          _resolveLocation();
          chartTooltipState?.show(
              tooltipData: _presentTooltipValue,
              position: showLocation,
              duration: _stateProperties.isTooltipOrientationChanged == true
                  ? 0
                  : ((!reRender)
                      ? tooltipBehavior.animationDuration.toInt()
                      : 0),
              template: tooltipTemplate);
        }
      }
    }
  }

  /// To show tooltip on mouse pointer actions.
  void _showMouseTooltip(double x, double y) {
    if (tooltipBehavior.enable &&
        renderBox != null &&
        _stateProperties.animationCompleted == true) {
      _renderTooltipView(Offset(x, y));
      if (!_mouseTooltip) {
        if (_stateProperties.isTooltipOrientationChanged == false) {
          // Cancelled timer as we have used timer in chart now.
          if (timer != null) {
            timer?.cancel();
          }
          timer = Timer(
              Duration(milliseconds: tooltipBehavior.duration.toInt()), () {
            chartTooltipState?.hide(hideDelay: 0);
            _stateProperties.isTooltipHidden = true;
            if (_stateProperties.isTooltipOrientationChanged == true) {
              _stateProperties.isTooltipOrientationChanged = false;
            }
          });
        }

        currentTooltipValue = null;
      } else {
        if (_presentTooltipValue != null &&
            (currentTooltipValue == null ||
                tooltipBehavior.tooltipPosition == TooltipPosition.auto)) {
          chartTooltipState!.boundaryRect = tooltipBounds!;
          if (tooltipBehavior.tooltipPosition != TooltipPosition.auto)
            _presentTooltipValue!.pointerPosition = showLocation;
          if (showLocation != null) {
            chartTooltipState?.needMarker =
                _stateProperties.chart is SfCartesianChart;
            _resolveLocation();
            chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: showLocation,
                duration: _stateProperties.isTooltipOrientationChanged == true
                    ? 0
                    : tooltipBehavior.animationDuration);
          }
          currentTooltipValue = _presentTooltipValue;
        } else if (_presentTooltipValue != null &&
            currentTooltipValue != null &&
            tooltipBehavior.tooltipPosition != TooltipPosition.auto &&
            ((_seriesRendererDetails != null &&
                        // ignore: unnecessary_type_check
                        _seriesRendererDetails!.renderer
                            is CartesianSeriesRenderer) ==
                    false ||
                _seriesRendererDetails!.isRectSeries == true)) {
          _presentTooltipValue!.pointerPosition = showLocation;
          chartTooltipState!.boundaryRect = tooltipBounds!;
          if (showLocation != null) {
            chartTooltipState?.needMarker =
                _stateProperties.chart is SfCartesianChart;
            _resolveLocation();
            chartTooltipState?.show(
                tooltipHeader: _header,
                tooltipContent: _stringVal,
                tooltipData: _presentTooltipValue,
                position: showLocation,
                duration: 0);
          }
        }
      }
    }
  }

  /// Method to trigger the tooltip rendering event.
  void tooltipRenderingEvent(TooltipRenderArgs args) {
    String? header = args.header;
    String? stringValue = args.text;
    double? x = args.location?.dx, y = args.location?.dy;
    String? tooltipHeaderText, tooltipLabelText;
    TooltipArgs tooltipArgs;
    if (x != null &&
        y != null &&
        stringValue != null &&
        currentSeriesDetails != null &&
        pointIndex != null) {
      final int seriesIndex = _stateProperties.chart is SfCartesianChart
          ? currentSeriesDetails.seriesIndex
          : 0;
      if ((_stateProperties.chart is SfCartesianChart &&
              _stateProperties.requireAxisTooltip == false) ||
          (_stateProperties.chart is SfCartesianChart) == false) {
        if (_stateProperties.chart.onTooltipRender != null &&
            _dataPoint != null &&
            (_dataPoint.isTooltipRenderEvent ?? false) == false) {
          _dataPoint.isTooltipRenderEvent = true;
          final bool isCartesian = _stateProperties.chart is SfCartesianChart;
          late SeriesRendererDetails seriesRendererDetails;
          if (isCartesian) {
            seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
                _stateProperties
                    .chartSeries.visibleSeriesRenderers[seriesIndex]);
          }

          tooltipArgs = TooltipArgs(
              seriesIndex,
              isCartesian
                  ? seriesRendererDetails.dataPoints
                  : _stateProperties.chartSeries
                      .visibleSeriesRenderers[seriesIndex].dataPoints,
              pointIndex,
              isCartesian
                  ? seriesRendererDetails
                      .visibleDataPoints![pointIndex!].overallDataPointIndex
                  : pointIndex);

          tooltipArgs.text = stringValue;
          tooltipArgs.header = header;
          tooltipLabelText = stringValue;
          tooltipHeaderText = header;
          tooltipArgs.locationX = x;
          tooltipArgs.locationY = y;
          _stateProperties.chart.onTooltipRender(tooltipArgs);
          stringValue = tooltipArgs.text;
          header = tooltipArgs.header;
          x = tooltipArgs.locationX;
          y = tooltipArgs.locationY;
          tooltipLabelText = tooltipArgs.text;
          tooltipHeaderText = tooltipArgs.header;
          _dataPoint.isTooltipRenderEvent = false;
          args.text = stringValue!;
          args.header = header;
          args.location = Offset(x!, y!);
        } else if (_stateProperties.chart.onTooltipRender != null) {
          //Fires the on tooltip render event when the tooltip is shown outside point region
          tooltipArgs = TooltipArgs();
          tooltipArgs.text = stringValue;
          tooltipArgs.header = header;
          tooltipArgs.locationX = x;
          tooltipArgs.locationY = y;
          _stateProperties.chart.onTooltipRender(tooltipArgs);
          args.text = tooltipArgs.text;
          args.header = tooltipArgs.header;
          args.location =
              Offset(tooltipArgs.locationX!, tooltipArgs.locationY!);
        }
        if (_stateProperties.chart.onTooltipRender != null &&
            _dataPoint != null) {
          stringValue = tooltipLabelText;
          header = tooltipHeaderText;
        }
      }
    }
  }

  /// To render a chart tooltip for circular series.
  void _renderCircularChartTooltip(Offset position) {
    final CircularStateProperties circularStateProperties =
        _stateProperties as CircularStateProperties;
    final SfCircularChart chart = circularStateProperties.chart;
    tooltipBounds = circularStateProperties.renderingDetails.chartContainerRect;
    final bool isRtl = circularStateProperties.isRtl;
    bool isContains = false;
    final Region? pointRegion = getCircularPointRegion(chart, position,
        circularStateProperties.chartSeries.visibleSeriesRenderers[0]);
    if (pointRegion != null &&
        circularStateProperties
                .chartSeries
                .visibleSeriesRenderers[pointRegion.seriesIndex]
                .series
                .enableTooltip ==
            true) {
      prevTooltipValue =
          TooltipValue(pointRegion.seriesIndex, pointRegion.pointIndex);
      _presentTooltipValue = prevTooltipValue;
      if (prevTooltipValue != null &&
          currentTooltipValue != null &&
          prevTooltipValue!.pointIndex != currentTooltipValue!.pointIndex) {
        currentTooltipValue = null;
      }
      final ChartPoint<dynamic> chartPoint = circularStateProperties
          .chartSeries
          .visibleSeriesRenderers[pointRegion.seriesIndex]
          .renderPoints![pointRegion.pointIndex];
      final Offset location =
          chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer
              ? position
              : degreeToPoint(
                  chartPoint.midAngle!,
                  (chartPoint.innerRadius! + chartPoint.outerRadius!) / 2,
                  chartPoint.center!);
      currentSeriesDetails = pointRegion.seriesIndex;
      pointIndex = pointRegion.pointIndex;
      _dataPoint = circularStateProperties
          .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex!];
      final int digits = chart.tooltipBehavior.decimalPlaces;
      String? header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? circularStateProperties
                      .chartSeries
                      .visibleSeriesRenderers[pointRegion.seriesIndex]
                      .series
                      .name !=
                  null
              ? circularStateProperties.chartSeries
                  .visibleSeriesRenderers[pointRegion.seriesIndex].series.name
              : null
          : header;
      _header = header ?? '';
      _header = isRtl ? _getRtlFormattedText(_header!) : _header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format!
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                circularStateProperties
                        .chartSeries
                        .visibleSeriesRenderers[pointRegion.seriesIndex]
                        .series
                        .name ??
                    'series.name');
        _stringValue =
            isRtl ? _getRtlFormattedText(resultantString) : resultantString;
        showLocation = location;
      } else {
        _stringValue = isRtl
            ? '${getDecimalLabelValue(chartPoint.y, digits)} : ${chartPoint.x}'
            : '${chartPoint.x} : ${getDecimalLabelValue(chartPoint.y, digits)}';
        showLocation = location;
      }
      if (chart.series[0].explode) {
        _presentTooltipValue!.pointerPosition = showLocation;
      }
      isContains = true;
    } else {
      isContains = false;
    }
    _mouseTooltip = isContains;
    if (!isContains) {
      prevTooltipValue = currentTooltipValue = null;
    }
  }

  /// To render a chart tooltip for triangular series.
  void _renderTriangularChartTooltip(Offset position) {
    final dynamic chart = _stateProperties.chart;
    final bool isRtl = _stateProperties.renderingDetails.isRtl == true;
    tooltipBounds = _stateProperties.renderingDetails.chartContainerRect;
    bool isContains = false;
    const int seriesIndex = 0;
    pointIndex = _stateProperties.tooltipPointIndex;
    if (pointIndex == null &&
        _stateProperties.renderingDetails.currentActive == null) {
      int? pointIndex;
      bool isPoint;
      final dynamic seriesRenderer =
          _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
      for (int j = 0; j < seriesRenderer.renderPoints.length; j++) {
        if (seriesRenderer.renderPoints[j].isVisible == true) {
          isPoint = isPointInPolygon(
              seriesRenderer.renderPoints[j].pathRegion, position);
          if (isPoint) {
            pointIndex = j;
            break;
          }
        }
      }
      _stateProperties.renderingDetails.currentActive = ChartInteraction(
        seriesIndex,
        pointIndex,
        seriesRenderer.series,
        seriesRenderer.renderPoints[pointIndex],
      );
    }
    pointIndex ??= _stateProperties.renderingDetails.currentActive!.pointIndex;
    _dataPoint = _stateProperties
        .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex];
    _stateProperties.tooltipPointIndex = null;
    final int digits = chart.tooltipBehavior.decimalPlaces;
    if (chart.tooltipBehavior.enable == true) {
      prevTooltipValue = TooltipValue(seriesIndex, pointIndex!);
      _presentTooltipValue = prevTooltipValue;
      if (prevTooltipValue != null &&
          currentTooltipValue != null &&
          prevTooltipValue!.pointIndex != currentTooltipValue!.pointIndex) {
        currentTooltipValue = null;
      }
      final PointInfo<dynamic> chartPoint = _stateProperties.chartSeries
          .visibleSeriesRenderers[seriesIndex].renderPoints[pointIndex];
      final Offset location = chart.tooltipBehavior.tooltipPosition ==
                  TooltipPosition.pointer &&
              _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
                      .series.explode ==
                  true
          ? chartPoint.symbolLocation
          : chart.tooltipBehavior.tooltipPosition == TooltipPosition.pointer &&
                  _stateProperties.chartSeries
                          .visibleSeriesRenderers[seriesIndex].series.explode ==
                      false
              ? position
              : chartPoint.symbolLocation;
      currentSeriesDetails = seriesIndex;
      String? header = chart.tooltipBehavior.header;
      header = (header == null)
          // ignore: prefer_if_null_operators
          ? _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
                      .series.name !=
                  null
              ? _stateProperties
                  .chartSeries.visibleSeriesRenderers[seriesIndex].series.name
              : null
          : header;
      _header = header ?? '';
      _header = isRtl ? _getRtlFormattedText(_header!) : header;
      if (chart.tooltipBehavior.format != null) {
        final String resultantString = chart.tooltipBehavior.format
            .replaceAll('point.x', chartPoint.x.toString())
            .replaceAll('point.y', getDecimalLabelValue(chartPoint.y, digits))
            .replaceAll(
                'series.name',
                _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex]
                        .series.name ??
                    'series.name');
        _stringValue =
            isRtl ? _getRtlFormattedText(resultantString) : resultantString;
        showLocation = location;
      } else {
        _stringValue = isRtl
            ? '${getDecimalLabelValue(chartPoint.y, digits)} : ${chartPoint.x}'
            : '${chartPoint.x} : ${getDecimalLabelValue(chartPoint.y, digits)}';
        showLocation = location;
      }
      isContains = true;
    } else {
      isContains = false;
    }
    if (chart.series.explode == true) {
      _presentTooltipValue!.pointerPosition = showLocation;
    }
    _mouseTooltip = isContains;
    if (!isContains) {
      prevTooltipValue = currentTooltipValue = null;
    }
  }

  /// To show the axis label tooltip for trimmed axes label texts.
  void showTrimmedTooltip(Offset position, dynamic chart, String text) {
    final RenderingDetails renderingDetails = _stateProperties.renderingDetails;
    if (renderBox != null) {
      _header = '';
      _stringValue = text;
      showLocation = position;
      tooltipBounds = renderingDetails.chartContainerRect;
      renderBox!.inversePadding = 0;
      chartTooltipState!.boundaryRect = tooltipBounds!;
      if (showLocation != null) {
        chartTooltipState?.needMarker = false;
        chartTooltipState?.show(
            tooltipHeader: _header,
            tooltipContent: _stringVal,
            tooltipData: currentTooltipValue,
            position: showLocation,
            duration: 0);
      }
      if (!isHovering) {
        if (_stateProperties.isTooltipOrientationChanged == false) {
          // Cancelled timer as we have used timer in chart now.
          if (timer != null) {
            timer?.cancel();
          }
          timer = Timer(
              Duration(milliseconds: tooltipBehavior.duration.toInt()), () {
            chartTooltipState?.hide(hideDelay: 0);
            _stateProperties.isTooltipHidden = true;
            if (_stateProperties.isTooltipOrientationChanged == true) {
              _stateProperties.isTooltipOrientationChanged = false;
            }
          });
        }
      }
    }
  }

  /// To render a chart tooltip for Cartesian series.
  void _renderCartesianChartTooltip(Offset position) {
    final CartesianStateProperties stateProperties =
        _stateProperties as CartesianStateProperties;
    bool isContains = false;
    //To hide the tooltip on dynamic update when the point is not in viewport,
    if (!_isPointWithInRect(position, stateProperties.chartAxis.axisClipRect)) {
      chartTooltipState?.hide(hideDelay: 0);
    }
    if (_isPointWithInRect(position, stateProperties.chartAxis.axisClipRect)) {
      Offset? tooltipPosition;
      double touchPadding;
      Offset? padding;
      bool? isTrendLine;
      dynamic dataRect;
      dynamic dataValues;
      bool outlierTooltip = false;
      int outlierTooltipIndex = -1;
      bool isInsidePointRegion = false;
      final List<LinearGradient?> markerGradients = <LinearGradient?>[];
      final List<Paint?> markerPaints = <Paint?>[];
      final List<DataMarkerType?> markerTypes = <DataMarkerType?>[];
      final List<dynamic> markerImages = <dynamic>[];
      for (int i = 0;
          i < stateProperties.chartSeries.visibleSeriesRenderers.length;
          i++) {
        _seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
            stateProperties.chartSeries.visibleSeriesRenderers[i]);
        final CartesianSeries<dynamic, dynamic> series =
            _seriesRendererDetails!.series;
        if (_seriesRendererDetails!.visible! == true &&
            series.enableTooltip &&
            _seriesRendererDetails?.regionalData != null) {
          int count = 0;
          _seriesRendererDetails!.regionalData!
              .forEach((dynamic regionRect, dynamic values) {
            isTrendLine = values[values.length - 1].contains('true');
            touchPadding = ((_seriesRendererDetails!.seriesType == 'bubble' ||
                        _seriesRendererDetails!.seriesType == 'scatter' ||
                        _seriesRendererDetails!.seriesType.contains('column') ==
                            true ||
                        _seriesRendererDetails!.seriesType.contains('bar') ==
                            true ||
                        _seriesRendererDetails!.seriesType == 'histogram') &&
                    !isTrendLine!)
                ? 0
                : isHovering
                    ? 0
                    : 15; // regional padding to detect smooth touch
            final Rect region = regionRect[0];
            final List<Rect>? outlierRegion = regionRect[5];
            final double left = region.left - touchPadding;
            final double right = region.right + touchPadding;
            final double top = region.top - touchPadding;
            final double bottom = region.bottom + touchPadding;
            Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
            if (outlierRegion != null) {
              for (int rectIndex = 0;
                  rectIndex < outlierRegion.length;
                  rectIndex++) {
                if (outlierRegion[rectIndex].contains(position)) {
                  paddedRegion = outlierRegion[rectIndex];
                  outlierTooltipIndex = rectIndex;
                  outlierTooltip = true;
                }
              }
            }

            if (paddedRegion.contains(position) &&
                (isTrendLine! ? regionRect[4].isVisible : true) == true &&
                !isInsidePointRegion) {
              tooltipBounds = stateProperties.chartAxis.axisClipRect;
              if (_seriesRendererDetails!.seriesType != 'boxandwhisker'
                  ? !region.contains(position)
                  : (paddedRegion.contains(position) ||
                      !region.contains(position))) {
                tooltipBounds = stateProperties.chartAxis.axisClipRect;
              }
              _presentTooltipValue =
                  TooltipValue(i, count, outlierTooltipIndex);
              currentSeriesDetails = _seriesRendererDetails;
              _dataPoint = regionRect[4];
              _markerType = _seriesRendererDetails!.series.markerSettings.shape;
              Color? seriesColor = _seriesRendererDetails!.seriesColor;
              if (_seriesRendererDetails!.seriesType == 'waterfall') {
                pointIndex = _stateProperties.chart is SfCartesianChart
                    ? (isTrendLine ?? false)
                        ? regionRect[4].index
                        : regionRect[4].visiblePointIndex
                    : count;
                seriesColor = getWaterfallSeriesColor(
                    _seriesRendererDetails!.series
                        as WaterfallSeries<dynamic, dynamic>,
                    _seriesRendererDetails!.dataPoints[pointIndex!],
                    seriesColor)!;
              }
              _markerColor = regionRect[2] ??
                  _seriesRendererDetails!.series.markerSettings.borderColor ??
                  seriesColor!;
              tooltipPosition = (outlierTooltipIndex >= 0)
                  ? regionRect[6][outlierTooltipIndex]
                  : regionRect[1];
              final Paint markerPaint = Paint();
              markerPaint.color = (!tooltipBehavior.shared
                      ? _markerColor
                      : _seriesRendererDetails!
                              .series.markerSettings.borderColor ??
                          _seriesRendererDetails!.seriesColor ??
                          _seriesRendererDetails!.series.color)!
                  .withOpacity(tooltipBehavior.opacity);
              if (!tooltipBehavior.shared) {
                markerGradients
                  ..clear()
                  ..add(_seriesRendererDetails!.series.gradient);
                markerImages
                  ..clear()
                  ..add(_seriesRendererDetails!.markerSettingsRenderer?.image);
                markerPaints
                  ..clear()
                  ..add(markerPaint);
                markerTypes
                  ..clear()
                  ..add(_markerType);
              }
              final List<Offset?> paddingData =
                  !(_seriesRendererDetails!.isRectSeries == true &&
                          tooltipBehavior.tooltipPosition !=
                              TooltipPosition.auto)
                      ? getTooltipPaddingData(_seriesRendererDetails!,
                          isTrendLine!, region, paddedRegion, tooltipPosition)
                      : <Offset?>[const Offset(2, 2), tooltipPosition];
              padding = paddingData[0];
              tooltipPosition = paddingData[1];
              showLocation = tooltipPosition;
              if (prevTooltipData == null ||
                  prevTooltipData!.pointIndex ==
                      _presentTooltipValue!.pointIndex ||
                  prevTooltipData!.seriesIndex !=
                      _presentTooltipValue!.seriesIndex) {
                dataValues = values;
                pointIndex = _stateProperties.chart is SfCartesianChart
                    ? (isTrendLine ?? false)
                        ? regionRect[4].index
                        : regionRect[4].visiblePointIndex
                    : count;

                showTooltipPosition = prevTooltipData != null &&
                    prevTooltipData!.pointIndex ==
                        _presentTooltipValue!.pointIndex;
              }
              dataPointValues = dataValues ?? dataPointValues;
              dataRect = regionRect;
              isContains = _mouseTooltip = true;
              prevTooltipData = prevTooltipData ?? _presentTooltipValue;
              if (isTrendLine!) {
                isInsidePointRegion = true;
                return;
              }
            }
            count++;
          });
          if (tooltipBehavior.shared) {
            int indexValue = 0;
            int tooltipElementsLength = 0;
            if ((_seriesRendererDetails!.seriesType.contains('range') == true ||
                    _seriesRendererDetails!.seriesType == 'hilo') &&
                !isTrendLine!) {
              // Assigned value '2' for this variable because for range and
              // hilo series there will be two display value types
              // such as high and low.
              tooltipElementsLength = 2;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else if (_seriesRendererDetails!.seriesType == 'hiloopenclose' ||
                _seriesRendererDetails!.seriesType == 'candle') {
              // Assigned value '4' for this variable because for hiloopenclose
              // and candle series there will be four display values
              // such as high, low, open and close.
              tooltipElementsLength = 4;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else if (_seriesRendererDetails!.seriesType == 'boxandwhisker') {
              // Assigned value '1' or '6' this variable field because for the
              // box and whiskers series there will be one display values if
              // the outlier's tooltip is activated otherwise there will be
              // six display values such as maximum, minimum, mean, median,
              // lowerQuartile and upperQuartile.
              tooltipElementsLength = outlierTooltip ? 1 : 6;
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            } else {
              indexValue = _getTooltipNewLineLength(tooltipElementsLength);
            }
            for (int j = 0; j < indexValue; j++) {
              markerTypes.add(null);
              markerImages.add(null);
              markerGradients.add(null);
              markerPaints.add(null);
            }
          }
        }
        if (isInsidePointRegion) {
          break;
        }
      }
      if (isContains) {
        renderBox!.markerGradients = markerGradients;
        renderBox!.markerImages = markerImages;
        renderBox!.markerPaints = markerPaints;
        renderBox!.markerTypes = markerTypes;
        _seriesRendererDetails = currentSeriesDetails ?? _seriesRendererDetails;
        if (currentSeriesDetails.isRectSeries == true &&
            tooltipBehavior.tooltipPosition == TooltipPosition.pointer) {
          tooltipPosition = position;
          showLocation = tooltipPosition;
        }
        renderBox!.normalPadding =
            _seriesRendererDetails!.renderer is BubbleSeriesRenderer
                ? 0
                : padding!.dy;
        renderBox!.inversePadding = padding!.dy;
        String? header = tooltipBehavior.header;
        header = (header == null)
            ? (tooltipBehavior.shared
                ? dataValues[0]
                : (isTrendLine!
                    ? dataValues[dataValues.length - 2]
                    : currentSeriesDetails.series.name ??
                        currentSeriesDetails.seriesName))
            : header;
        _header = header ?? '';
        _header = stateProperties.renderingDetails.isRtl
            ? _getRtlFormattedText(_header!)
            : _header;
        _stringValue = '';
        if (tooltipBehavior.shared) {
          _textValues = <String>[];
          _seriesRendererCollection = <CartesianSeriesRenderer>[];
          for (int j = 0;
              j < stateProperties.chartSeries.visibleSeriesRenderers.length;
              j++) {
            final SeriesRendererDetails seriesRendererDetails =
                SeriesHelper.getSeriesRendererDetails(
                    stateProperties.chartSeries.visibleSeriesRenderers[j]);
            if (seriesRendererDetails.visible! == true &&
                seriesRendererDetails.series.enableTooltip == true) {
              final int index =
                  seriesRendererDetails.xValues!.indexOf(dataRect[4].x);
              if (index > -1) {
                final Paint markerPaint = Paint();
                markerPaint.color =
                    seriesRendererDetails.series.markerSettings.borderColor ??
                        seriesRendererDetails.seriesColor ??
                        seriesRendererDetails.series.color!
                            .withOpacity(tooltipBehavior.opacity);
                markerGradients.add(seriesRendererDetails.series.gradient);
                markerImages
                    .add(seriesRendererDetails.markerSettingsRenderer?.image);
                markerTypes
                    .add(seriesRendererDetails.series.markerSettings.shape);
                markerPaints.add(markerPaint);

                final String text = (_stringVal != '' ? '\n' : '') +
                    _calculateCartesianTooltipText(
                        seriesRendererDetails,
                        seriesRendererDetails.dataPoints[index],
                        dataValues,
                        tooltipPosition!,
                        outlierTooltip,
                        outlierTooltipIndex);
                _stringValue = _stringVal! + text;
                _textValues.add(text);
                _seriesRendererCollection.add(seriesRendererDetails.renderer);
              }
            }
          }
        } else {
          _stringValue = _calculateCartesianTooltipText(
              currentSeriesDetails,
              dataRect[4],
              dataValues ?? dataPointValues,
              !showTooltipPosition ? tooltipPosition! : position,
              outlierTooltip,
              outlierTooltipIndex);
        }
        showLocation = !showTooltipPosition ? tooltipPosition : position;
      } else {
        _stringValue = null;
        if (!isHovering) {
          _presentTooltipValue = currentTooltipValue = null;
        } else {
          _mouseTooltip = isContains;
        }
      }
    }
  }

  /// It returns the tooltip text of Cartesian series.
  String _calculateCartesianTooltipText(
      SeriesRendererDetails seriesRendererDetails,
      CartesianChartPoint<dynamic> point,
      dynamic values,
      Offset tooltipPosition,
      bool outlierTooltip,
      int outlierTooltipIndex) {
    final bool isRtl =
        seriesRendererDetails.stateProperties.renderingDetails.isRtl == true;
    final bool isTrendLine = values[values.length - 1].contains('true');
    String resultantString;
    final ChartAxisRendererDetails axisRenderer =
        seriesRendererDetails.yAxisDetails!;
    final TooltipBehavior tooltip = tooltipBehavior;
    final int digits =
        seriesRendererDetails.chart.tooltipBehavior.decimalPlaces;
    String? minimumValue,
        maximumValue,
        lowerQuartileValue,
        upperQuartileValue,
        medianValue,
        meanValue,
        outlierValue,
        highValue,
        lowValue,
        openValue,
        closeValue,
        cumulativeValue,
        boxPlotString;
    if (seriesRendererDetails.seriesType == 'boxandwhisker') {
      minimumValue = getLabelValue(point.minimum, axisRenderer.axis, digits);
      maximumValue = getLabelValue(point.maximum, axisRenderer.axis, digits);
      lowerQuartileValue =
          getLabelValue(point.lowerQuartile, axisRenderer.axis, digits);
      upperQuartileValue =
          getLabelValue(point.upperQuartile, axisRenderer.axis, digits);
      medianValue = getLabelValue(point.median, axisRenderer.axis, digits);
      meanValue = getLabelValue(point.mean, axisRenderer.axis, digits);
      outlierValue = (point.outliers!.isNotEmpty && outlierTooltipIndex >= 0)
          ? getLabelValue(
              point.outliers![outlierTooltipIndex], axisRenderer.axis, digits)
          : null;
      boxPlotString = isRtl
          ? '\n$minimumValue : Minimum\n$maximumValue : Maximum\n$medianValue : Median\n$meanValue : Mean\n$lowerQuartileValue : LQ\n$upperQuartileValue : HQ'
          : '\nMinimum : $minimumValue\nMaximum : $maximumValue\nMedian : $medianValue\nMean : $meanValue\nLQ : $lowerQuartileValue\nHQ : $upperQuartileValue';
    } else if (seriesRendererDetails.seriesType.contains('range') == true ||
        seriesRendererDetails.seriesType == 'hilo' ||
        seriesRendererDetails.seriesType == 'hiloopenclose' ||
        seriesRendererDetails.seriesType == 'candle') {
      highValue = getLabelValue(point.high, axisRenderer.axis, digits);
      lowValue = getLabelValue(point.low, axisRenderer.axis, digits);
      if (seriesRendererDetails.seriesType == 'candle' ||
          seriesRendererDetails.seriesType == 'hiloopenclose') {
        openValue = getLabelValue(point.open, axisRenderer.axis, digits);
        closeValue = getLabelValue(point.close, axisRenderer.axis, digits);
      }
    } else if (seriesRendererDetails.seriesType.contains('stacked') == true) {
      cumulativeValue =
          getLabelValue(point.cumulativeValue, axisRenderer.axis, digits);
    }
    if (tooltipBehavior.format != null) {
      resultantString = (seriesRendererDetails.seriesType.contains('range') == true ||
                  seriesRendererDetails.seriesType == 'hilo') &&
              !isTrendLine
          ? (tooltip.format!
              .replaceAll('point.x', values[0])
              .replaceAll('point.high', highValue!)
              .replaceAll('point.low', lowValue!)
              .replaceAll(
                  'series.name',
                  seriesRendererDetails.series.name ??
                      seriesRendererDetails.seriesName!))
          : (seriesRendererDetails.seriesType.contains('hiloopenclose') == true ||
                      seriesRendererDetails.seriesType.contains('candle') ==
                          true) &&
                  !isTrendLine
              ? (tooltip.format!
                  .replaceAll('point.x', values[0])
                  .replaceAll('point.high', highValue!)
                  .replaceAll('point.low', lowValue!)
                  .replaceAll('point.open', openValue!)
                  .replaceAll('point.close', closeValue!)
                  .replaceAll(
                      'series.name',
                      seriesRendererDetails.series.name ??
                          seriesRendererDetails.seriesName!))
              : (seriesRendererDetails.seriesType.contains('boxandwhisker') == true) &&
                      !isTrendLine
                  ? (tooltip.format!
                      .replaceAll('point.x', values[0])
                      .replaceAll('point.minimum', minimumValue!)
                      .replaceAll('point.maximum', maximumValue!)
                      .replaceAll('point.lowerQuartile', lowerQuartileValue!)
                      .replaceAll('point.upperQuartile', upperQuartileValue!)
                      .replaceAll('point.mean', meanValue!)
                      .replaceAll('point.median', medianValue!)
                      .replaceAll(
                          'series.name', seriesRendererDetails.series.name ?? seriesRendererDetails.seriesName!))
                  : seriesRendererDetails.seriesType.contains('stacked') == true
                      ? tooltip.format!.replaceAll('point.cumulativeValue', cumulativeValue!)
                      : seriesRendererDetails.seriesType == 'bubble'
                          ? tooltip.format!.replaceAll('point.x', values[0]).replaceAll('point.y', getLabelValue(point.y, axisRenderer.axis, digits)).replaceAll('series.name', seriesRendererDetails.series.name ?? seriesRendererDetails.seriesName!).replaceAll('point.size', getLabelValue(point.bubbleSize, axisRenderer.axis, digits))
                          : tooltip.format!.replaceAll('point.x', values[0]).replaceAll('point.y', getLabelValue(point.y, axisRenderer.axis, digits)).replaceAll('series.name', seriesRendererDetails.series.name ?? seriesRendererDetails.seriesName!);
      resultantString =
          isRtl ? _getRtlFormattedText(resultantString) : resultantString;
    } else {
      final String xValue =
          '${tooltipBehavior.shared ? seriesRendererDetails.series.name ?? seriesRendererDetails.seriesName : values[0]}';
      String result = '';
      if ((seriesRendererDetails.seriesType.contains('range') == true ||
              seriesRendererDetails.seriesType == 'hilo') &&
          !isTrendLine) {
        result = xValue +
            (isRtl
                ? '\n${highValue!} : High\n${lowValue!} : Low'
                : '\nHigh : ${highValue!}\nLow : ${lowValue!}');
      } else if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
          seriesRendererDetails.seriesType == 'candle') {
        result = xValue +
            (isRtl
                ? '\n${highValue!} : High\n${lowValue!} : Low\n${openValue!} : Open\n${closeValue!} : Close'
                : '\nHigh : ${highValue!}\nLow : ${lowValue!}\nOpen : ${openValue!}\nClose : ${closeValue!}');
      } else if (seriesRendererDetails.seriesType == 'boxandwhisker') {
        result = xValue +
            (outlierValue != null
                ? isRtl
                    ? '\n$outlierValue : Outliers'
                    : '\nOutliers : $outlierValue'
                : boxPlotString!);
      } else {
        final String yValue = getLabelValue(point.y, axisRenderer.axis, digits);
        result = isRtl ? '$yValue : $xValue' : '$xValue : $yValue';
      }
      resultantString = result;
    }
    return resultantString;
  }

  String _getRtlFormattedText(String formattedText) {
    String resultantString = '';
    List<String> textCollection = <String>[];
    final List<String> firstStringCollection = <String>[];
    if (formattedText.contains('\n')) {
      textCollection = formattedText.split('\n');
      for (int j = 0; j < textCollection.length; j++) {
        if (textCollection[j].contains(':')) {
          final List<String> secondStringCollection =
              textCollection[j].split(':');
          firstStringCollection
              .add(_getRtlStringWithColon(secondStringCollection));
        } else {
          firstStringCollection.add(textCollection[j]);
        }
      }
    } else if (formattedText.contains(':')) {
      textCollection = formattedText.split(':');
      formattedText = _getRtlStringWithColon(textCollection);
    }
    if (firstStringCollection.isNotEmpty) {
      for (int i = 0; i < firstStringCollection.length; i++) {
        resultantString =
            resultantString + (i == 0 ? '' : '\n') + firstStringCollection[i];
      }
    } else {
      resultantString = formattedText;
    }
    return resultantString;
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

  /// Returns the cumulative length of the number of new line character '\n'
  /// available in series name and tooltip format string.
  int _getTooltipNewLineLength(int value) {
    value += _seriesRendererDetails!.series.name != null
        ? '\n'.allMatches(_seriesRendererDetails!.series.name!).length
        : 0;
    if (tooltipBehavior.format != null) {
      value += '\n'.allMatches(tooltipBehavior.format!).length;
    }
    return value;
  }

  /// Finds whether the point resides inside the given rect including its edges.
  bool _isPointWithInRect(Offset point, Rect rect) {
    // ignore: unnecessary_null_comparison
    return point != null &&
        point.dx >= rect.left &&
        point.dx <= rect.right &&
        point.dy <= rect.bottom &&
        point.dy >= rect.top;
  }
}
