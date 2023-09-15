import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/utils/typedef.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/histogram_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../series_painter/bubble_painter.dart';
import '../series_painter/fastline_painter.dart';
import '../series_painter/histogram_painter.dart';
import '../series_painter/spline_painter.dart';
import '../series_painter/waterfall_painter.dart';
import '../technical_indicators/accumulation_distribution_indicator.dart';
import '../technical_indicators/atr_indicator.dart';
import '../technical_indicators/bollinger_bands_indicator.dart';
import '../technical_indicators/ema_indicator.dart';
import '../technical_indicators/macd_indicator.dart';
import '../technical_indicators/momentum_indicator.dart';
import '../technical_indicators/rsi_indicator.dart';
import '../technical_indicators/sma_indicator.dart';
import '../technical_indicators/stochastic_indicator.dart';
import '../technical_indicators/technical_indicator.dart';
import '../technical_indicators/tma_indicator.dart';
import '../trendlines/trendlines.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the chart series panel class
class ChartSeriesPanel {
  /// Creates an instance of chart series panel
  ChartSeriesPanel(this.stateProperties);

  /// Specifies the value of state properties
  final CartesianStateProperties stateProperties;

  /// Here, we are using get keyword in order to get the proper & updated instance of chart widget
  /// When we initialize chart widget as a property to other classes like ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get chart => stateProperties.chart;

  /// Specifies whether the series is stacked 100
  bool isStacked100 = false;

  /// Specifies the palette index value
  int paletteIndex = 0;

  /// Holds the sum of Y-values
  num sumOfYvalues = 0;

  /// Holds the list of YValues
  List<num> yValues = <num>[];

  /// Contains the visible series for chart
  List<CartesianSeriesRenderer> visibleSeriesRenderers =
      <CartesianSeriesRenderer>[];

  /// Holds the list of cluster stacked item info
  List<ClusterStackedItemInfo> clusterStackedItemInfo =
      <ClusterStackedItemInfo>[];

  /// Specifies whether axis range animation is required
  bool needAxisRangeAnimation = false;

  /// To get data and process data for rendering chart
  void processData() {
    final List<CartesianSeriesRenderer> seriesRendererList =
        visibleSeriesRenderers;
    isStacked100 = false;
    paletteIndex = 0;
    _findAreaType(seriesRendererList);
    if (chart.indicators.isNotEmpty) {
      _populateDataPoints(seriesRendererList);
      _calculateIndicators();
      stateProperties.chartAxis.calculateVisibleAxes();
      _findMinMax(seriesRendererList);
      _renderTrendline();
    } else {
      stateProperties.chartAxis.calculateVisibleAxes();
      _populateDataPoints(seriesRendererList);
    }
    calculateStackedValues(findSeriesCollection(stateProperties));
    _renderTrendline();
  }

  ///check whether axis animation applicable or not
  bool _needAxisAnimation(CartesianSeriesRenderer seriesRenderer,
      CartesianSeriesRenderer oldSeriesRenderer) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final SeriesRendererDetails oldSeriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer);
    final dynamic oldAxis = oldSeriesRendererDetails.xAxisDetails!.axis;
    final dynamic axis = seriesRendererDetails.xAxisDetails!.axis;
    final bool needAnimation =
        seriesRendererDetails.series.animationDuration > 0 == true &&
            seriesRendererDetails.yAxisDetails!.runtimeType ==
                oldSeriesRendererDetails.yAxisDetails!.runtimeType &&
            seriesRendererDetails.xAxisDetails!.runtimeType ==
                oldSeriesRendererDetails.xAxisDetails!.runtimeType &&
            ((oldAxis.visibleMinimum != null &&
                    oldAxis.visibleMinimum != axis.visibleMinimum) ||
                (oldAxis.visibleMaximum != null &&
                    oldAxis.visibleMaximum != axis.visibleMaximum));
    needAxisRangeAnimation = needAnimation;
    return needAnimation;
  }

  /// Find the data points for each series
  void _populateDataPoints(List<CartesianSeriesRenderer> seriesRendererList) {
    stateProperties.totalAnimatingSeries = 0;
    bool isSelectionRangeChangeByEvent = false;
    for (final CartesianSeriesRenderer seriesRenderer in seriesRendererList) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      final CartesianSeries<dynamic, dynamic> series =
          seriesRendererDetails.series;
      final ChartIndexedValueMapper<num>? bubbleSizeValueMapper =
          series.sizeValueMapper;
      seriesRendererDetails.minimumX = seriesRendererDetails.minimumY =
          seriesRendererDetails.minDelta = seriesRendererDetails.maximumX =
              seriesRendererDetails.maximumY = null;
      if (seriesRenderer is BubbleSeriesRenderer) {
        seriesRendererDetails.maxSize = seriesRendererDetails.minSize = null;
      }
      seriesRendererDetails.needAnimateSeriesElements = false;
      seriesRendererDetails.needsAnimation = false;
      seriesRendererDetails.reAnimate = false;
      CartesianChartPoint<dynamic>? currentPoint;
      yValues = <num>[];
      sumOfYvalues = 0;
      seriesRendererDetails.dataPoints = <CartesianChartPoint<dynamic>>[];
      if (seriesRenderer is FastLineSeriesRenderer) {
        seriesRendererDetails.overallDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }
      seriesRendererDetails.xValues = <dynamic>[];
      if (!isStacked100 &&
          seriesRendererDetails.seriesType.contains('100') == true) {
        isStacked100 = true;
      }
      if (seriesRendererDetails.visible! == true) {
        stateProperties.totalAnimatingSeries++;
      }
      if (seriesRenderer is HistogramSeriesRenderer) {
        final HistogramSeries<dynamic, dynamic> series =
            seriesRendererDetails.series as HistogramSeries<dynamic, dynamic>;
        for (int pointIndex = 0;
            pointIndex < series.dataSource.length;
            pointIndex++) {
          yValues.add(series.yValueMapper!(pointIndex) ?? 0);
          sumOfYvalues += yValues[pointIndex];
        }
        seriesRendererDetails.processData(series, yValues, sumOfYvalues);
        seriesRendererDetails.histogramValues.minValue =
            seriesRendererDetails.histogramValues.yValues!.reduce(math.min);
        seriesRendererDetails.histogramValues.binWidth = series.binInterval ??
            (3.5 * seriesRendererDetails.histogramValues.sDValue!) /
                math.pow(seriesRendererDetails.histogramValues.yValues!.length,
                    1 / 3);
      }
      final String seriesType = seriesRendererDetails.seriesType;
      final bool needSorting = series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null;
      // ignore: unnecessary_null_comparison
      if (series.dataSource != null) {
        dynamic previousX, currentX, nextX;
        dynamic yVal;
        num? low, high;
        num maxYValue = 0;
        seriesRendererDetails.overAllDataPoints =
            <CartesianChartPoint<dynamic>?>[];
        CartesianChartPoint<dynamic>? nextPoint;
        CartesianChartPoint<dynamic>? prevPoint;
        for (int pointIndex = 0; pointIndex < series.dataSource.length;) {
          currentPoint = getChartPoint(
              seriesRenderer, series.dataSource[pointIndex], pointIndex);
          if (pointIndex < series.dataSource.length - 1 &&
              seriesRendererDetails.seriesType != 'histogram') {
            nextPoint = getChartPoint(seriesRenderer,
                series.dataSource[pointIndex + 1], pointIndex + 1);
          } else {
            nextPoint = currentPoint;
          }
          currentX = currentPoint?.x;
          nextX = nextPoint?.x;
          previousX = pointIndex == 0 ? currentPoint?.x : prevPoint?.x;
          yVal = currentPoint?.y;
          high = currentPoint?.high;
          low = currentPoint?.low;
          currentPoint?.overallDataPointIndex = pointIndex;

          seriesRendererDetails.overAllDataPoints.add(currentPoint);
          if (seriesRenderer is WaterfallSeriesRenderer) {
            yVal ??= 0;
            maxYValue += yVal;
            currentPoint!.maxYValue = maxYValue;
          }

          if (currentX != null) {
            num bubbleSize;
            final dynamic xAxis = seriesRendererDetails.xAxisDetails?.axis;
            final dynamic yAxis = seriesRendererDetails.yAxisDetails?.axis;
            dynamic xMin = xAxis?.visibleMinimum;
            dynamic xMax = xAxis?.visibleMaximum;
            final dynamic yMin = yAxis?.visibleMinimum;
            final dynamic yMax = yAxis?.visibleMaximum;
            dynamic xPointValue = currentX;
            bool isXVisibleRange = true;
            bool isYVisibleRange = true;
            if (xAxis is DateTimeAxis) {
              xMin = xMin != null ? xMin.millisecondsSinceEpoch : xMin;
              xMax = xMax != null ? xMax.millisecondsSinceEpoch : xMax;
              xPointValue = xPointValue?.millisecondsSinceEpoch;
              nextX = nextX?.millisecondsSinceEpoch;
              previousX = previousX?.millisecondsSinceEpoch;
            } else if (xAxis is CategoryAxis) {
              xPointValue = pointIndex;
              nextX = pointIndex + 1;
              previousX = pointIndex - 1;
            } else if (xAxis is DateTimeCategoryAxis) {
              xMin = xMin != null ? xMin.millisecondsSinceEpoch : xMin;
              xMax = xMax != null ? xMax.millisecondsSinceEpoch : xMax;
              xPointValue = xPointValue?.millisecondsSinceEpoch;
              nextX = nextX?.millisecondsSinceEpoch;
              previousX = previousX?.millisecondsSinceEpoch;
            }
            if (xMin != null || xMax != null) {
              isXVisibleRange = false;
            }
            if (yMin != null || yMax != null) {
              isYVisibleRange = false;
            }

            if ((xMin != null ||
                    xMax != null ||
                    yMin != null ||
                    yMax != null) &&
                // ignore: unnecessary_null_comparison
                stateProperties.oldSeriesRenderers != null &&
                stateProperties.oldSeriesRenderers.isNotEmpty) {
              final int seriesIndex = stateProperties
                  .chartSeries.visibleSeriesRenderers
                  .indexOf(seriesRenderer);
              final CartesianSeriesRenderer? oldSeriesRenderer =
                  stateProperties.oldSeriesRenderers.length - 1 >= seriesIndex
                      ? stateProperties.oldSeriesRenderers[seriesIndex]
                      : null;
              if (oldSeriesRenderer != null &&
                  (stateProperties.chart.onSelectionChanged != null ||
                      _needAxisAnimation(seriesRenderer, oldSeriesRenderer))) {
                final SeriesRendererDetails oldSeriesRendererDetails =
                    SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer);
                isSelectionRangeChangeByEvent =
                    oldSeriesRendererDetails.minimumX != xMin ||
                        oldSeriesRendererDetails.maximumX != xMax ||
                        oldSeriesRendererDetails.minimumY != yMin ||
                        oldSeriesRendererDetails.maximumY != yMax;
              }
            }

            if (!(!(isSelectionRangeChangeByEvent ||
                        stateProperties.rangeChangeBySlider ||
                        (stateProperties.zoomedState ?? false) ||
                        stateProperties.renderingDetails.didSizeChange ||
                        stateProperties.zoomProgress) &&
                    (xMin != null ||
                        xMax != null ||
                        yMin != null ||
                        yMax != null) &&
                    (yVal != null || (low != null && high != null))) ||
                ((xMin != null && xMax != null)
                        ? (xPointValue >= xMin) == true &&
                            (xPointValue <= xMax) == true
                        : xMin != null
                            ? xPointValue >= xMin
                            : xMax != null
                                ? xPointValue <= xMax
                                : false) ==
                    true ||
                ((yMin != null && yMax != null)
                        ? ((yVal ?? low) >= yMin) == true &&
                            ((yVal ?? high) <= yMax) == true
                        : yMin != null
                            ? (yVal ?? low) >= yMin
                            : yMax != null
                                ? (yVal ?? high) <= yMax
                                : false) ==
                    true ||
                // If the data points present between the range the following conditions are working.

                // This condition will works when having a range between the data points and data points between the given range.
                // Also works when having a visible minimum value alone and data point outside the range this is for left side point.
                ((xMin != null && xPointValue <= xMin && nextX > xMin) ||
                    // This condition will work when having data points outside the given range and nearest to the given range and don't have a points between th range.
                    ((xMin != null && xMax != null) &&
                        ((xPointValue <= xMin && nextX >= xMax) ||
                            (previousX <= xMin && xPointValue >= xMax))) ||
                    // This condition will works when having a range between the data points and data points between the given range.
                    // Also works when having a visible maximum value and data point outside the range this is for right side point.
                    (xMax != null &&
                        (previousX < xMax && xPointValue >= xMax)))) {
              isXVisibleRange = true;
              isYVisibleRange = true;
              seriesRendererDetails.dataPoints.add(currentPoint!);
              seriesRendererDetails.xValues!.add(currentX);
              if (seriesRenderer is BubbleSeriesRenderer) {
                bubbleSize = series.sizeValueMapper == null
                    ? 4
                    : bubbleSizeValueMapper!(pointIndex) ?? 4;
                currentPoint.bubbleSize = bubbleSize.toDouble();
                seriesRendererDetails.maxSize ??=
                    currentPoint.bubbleSize!.toDouble();
                seriesRendererDetails.minSize ??=
                    currentPoint.bubbleSize!.toDouble();
                seriesRendererDetails.maxSize = math.max(
                    seriesRendererDetails.maxSize!,
                    currentPoint.bubbleSize!.toDouble());
                seriesRendererDetails.minSize = math.min(
                    seriesRendererDetails.minSize!,
                    currentPoint.bubbleSize!.toDouble());
              }

              if (seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType.contains('candle') ||
                      seriesType == 'boxandwhisker'
                  ? seriesType == 'hiloopenclose' ||
                          seriesType.contains('candle')
                      ? (currentPoint.low == null ||
                          currentPoint.high == null ||
                          currentPoint.open == null ||
                          currentPoint.close == null)
                      : seriesType == 'boxandwhisker'
                          ? (currentPoint.minimum == null ||
                              currentPoint.maximum == null ||
                              currentPoint.lowerQuartile == null ||
                              currentPoint.upperQuartile == null)
                          : (currentPoint.low == null ||
                              currentPoint.high == null)
                  : currentPoint.y == null) {
                if (seriesRenderer is XyDataSeriesRenderer &&
                    seriesType != 'waterfall') {
                  if (seriesRenderer is FastLineSeriesRenderer &&
                      !seriesRendererDetails.containsEmptyPoints) {
                    seriesRendererDetails.containsEmptyPoints = true;
                  }
                  seriesRenderer.calculateEmptyPointValue(
                      pointIndex, currentPoint, seriesRenderer);
                }
              }

              // Below lines for changing high, low values based on input
              if ((seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType.contains('candle') ||
                      seriesType == 'boxandwhisker') &&
                  currentPoint.isVisible) {
                if (seriesType == 'boxandwhisker') {
                  final num max = currentPoint.maximum!;
                  final num min = currentPoint.minimum!;
                  currentPoint.maximum = math.max<num>(max, min);
                  currentPoint.minimum = math.min<num>(max, min);
                } else {
                  final num high = currentPoint.high;
                  final num low = currentPoint.low;
                  currentPoint.high = math.max<num>(high, low);
                  currentPoint.low = math.min<num>(high, low);
                }
              }
              //determines whether the data source has been changed in-order to perform dynamic animation
              if (seriesRendererDetails.needsAnimation == false &&
                  needAxisRangeAnimation != true) {
                if (seriesRendererDetails.oldSeries == null ||
                    seriesRendererDetails.oldDataPoints!.length <
                            seriesRendererDetails.dataPoints.length ==
                        true) {
                  seriesRendererDetails.needAnimateSeriesElements = true;
                  seriesRendererDetails.needsAnimation =
                      seriesRendererDetails.visible!;
                } else {
                  seriesRendererDetails.needsAnimation = (seriesRendererDetails
                                  .dataPoints.length <=
                              seriesRendererDetails.oldDataPoints!.length) ==
                          true
                      ? seriesRendererDetails.visible! == true &&
                          findChangesInPoint(
                            currentPoint,
                            seriesRendererDetails.oldDataPoints![
                                seriesRendererDetails.dataPoints.length - 1],
                            seriesRendererDetails,
                          )
                      : seriesRendererDetails.visible!;
                }
              }
            }
            if (seriesRendererDetails.xAxisDetails != null &&
                seriesRendererDetails.yAxisDetails != null &&
                !needSorting &&
                chart.indicators.isEmpty) {
              _findMinMaxValue(
                  seriesRendererDetails.xAxisDetails!.axisRenderer,
                  seriesRenderer,
                  currentPoint!,
                  pointIndex,
                  series.dataSource.length,
                  isXVisibleRange,
                  isYVisibleRange);
            }
            if (seriesRenderer is SplineSeriesRenderer && !needSorting) {
              if (pointIndex == 0) {
                seriesRendererDetails.xValueList.clear();
                seriesRendererDetails.yValueList.clear();
              }
              if (!currentPoint!.isDrop) {
                seriesRendererDetails.xValueList.add(currentPoint.xValue);
                seriesRendererDetails.yValueList.add(currentPoint.yValue);
              }
            }
          }
          pointIndex = seriesRendererDetails.seriesType != 'histogram'
              ? pointIndex + 1
              : pointIndex + yVal as int;
          prevPoint = currentPoint;
        }
        if (seriesRendererDetails.xAxisDetails
            is DateTimeCategoryAxisRenderer) {
          _sortDateTimeCategoryDetails(seriesRendererDetails);
        }
        if (needSorting) {
          _sortDataSource(seriesRendererDetails);
          if (chart.indicators.isEmpty) {
            findSeriesMinMax(seriesRendererDetails);
          }
        }
      }
      if (seriesRenderer is FastLineSeriesRenderer) {
        seriesRendererDetails.sampledDataPoints =
            seriesRendererDetails.dataPoints;
        seriesRendererDetails.overallDataPoints
            .addAll(seriesRendererDetails.dataPoints);
      }
    }
  }

  /// To find the minimum and maximum values for axis
  void _findMinMaxValue(
      ChartAxisRenderer axisRenderer,
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      int dataLength,
      [bool? isXVisibleRange,
      bool? isYVisibleRange]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesRendererDetails.visible! == true) {
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      if (axisDetails is NumericAxisDetails) {
        axisDetails.findAxisMinMaxValues(seriesRendererDetails, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisDetails is CategoryAxisDetails) {
        axisDetails.findAxisMinMaxValues(seriesRendererDetails, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisDetails is DateTimeAxisDetails) {
        axisDetails.findAxisMinMaxValues(seriesRendererDetails, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisDetails is LogarithmicAxisDetails) {
        axisDetails.findAxisMinMaxValues(seriesRendererDetails, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisDetails is DateTimeCategoryAxisDetails) {
        axisDetails.findAxisMinMaxValues(seriesRendererDetails, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      }
    }
  }

  /// To find minimum and maximum series values
  void findSeriesMinMax(SeriesRendererDetails seriesRendererDetails) {
    final ChartAxisRenderer axisRenderer =
        seriesRendererDetails.xAxisDetails!.axisRenderer;
    if (seriesRendererDetails.visible! == true) {
      if (seriesRendererDetails.renderer is SplineSeriesRenderer) {
        seriesRendererDetails.xValueList.clear();
        seriesRendererDetails.yValueList.clear();
      }
      for (int pointIndex = 0;
          pointIndex < seriesRendererDetails.dataPoints.length;
          pointIndex++) {
        _findMinMaxValue(
            axisRenderer,
            seriesRendererDetails.renderer,
            seriesRendererDetails.dataPoints[pointIndex],
            pointIndex,
            seriesRendererDetails.dataPoints.length,
            true,
            true);
        if (seriesRendererDetails.renderer is SplineSeriesRenderer) {
          if (seriesRendererDetails.dataPoints[pointIndex].isDrop == false) {
            seriesRendererDetails.xValueList
                .add(seriesRendererDetails.dataPoints[pointIndex].xValue);
            seriesRendererDetails.yValueList
                .add(seriesRendererDetails.dataPoints[pointIndex].yValue);
          }
        }
      }
    }
  }

  /// To find minimum and maximum in series collection
  void _findMinMax(List<CartesianSeriesRenderer> seriesCollection) {
    SeriesRendererDetails seriesRendererDetails;
    for (int seriesIndex = 0;
        seriesIndex < seriesCollection.length;
        seriesIndex++) {
      seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesCollection[seriesIndex]);
      findSeriesMinMax(seriesRendererDetails);
    }
  }

  /// To render a trendline
  void _renderTrendline() {
    for (final CartesianSeriesRenderer seriesRenderer
        in visibleSeriesRenderers) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      if (seriesRendererDetails.series.trendlines != null) {
        TrendlineRenderer trendlineRenderer;
        Trendline trendline;
        for (int i = 0;
            i < seriesRendererDetails.series.trendlines!.length;
            i++) {
          trendline = seriesRendererDetails.series.trendlines![i];
          trendlineRenderer = seriesRendererDetails.trendlineRenderer[i];
          trendlineRenderer.isNeedRender = trendlineRenderer.visible == true &&
              seriesRendererDetails.visible! == true &&
              (trendline.type == TrendlineType.polynomial
                  ? (trendline.polynomialOrder >= 2 &&
                      trendline.polynomialOrder <= 6)
                  : !(trendline.type == TrendlineType.movingAverage) ||
                      (trendline.period >= 2 &&
                          trendline.period <=
                              seriesRendererDetails.series.dataSource.length -
                                  1));
          trendlineRenderer.animationController =
              AnimationController(vsync: stateProperties.chartState)
                ..addListener(stateProperties.repaintTrendlines);
          stateProperties
                  .controllerList[trendlineRenderer.animationController] =
              stateProperties.repaintTrendlines;
          if (trendlineRenderer.isNeedRender) {
            trendlineRenderer.setDataSource(seriesRendererDetails, chart);
          }
        }
      }
    }
  }

  /// Sort the dataSource
  void _sortDataSource(SeriesRendererDetails seriesRendererDetails) {
    seriesRendererDetails.dataPoints.sort(
        // ignore: missing_return
        (CartesianChartPoint<dynamic> firstPoint,
            CartesianChartPoint<dynamic> secondPoint) {
      if (seriesRendererDetails.series.sortingOrder == SortingOrder.ascending) {
        return ((firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue
                        .compareTo(secondPoint.sortValue)))) as int;
      } else if (seriesRendererDetails.series.sortingOrder ==
          SortingOrder.descending) {
        return ((firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue
                        .compareTo(firstPoint.sortValue)))) as int;
      } else {
        return 0;
      }
    });
  }

  /// To calculate stacked values of a stacked series
  void calculateStackedValues(
      List<CartesianSeriesRenderer> seriesRendererCollection) {
    StackedItemInfo stackedItemInfo;
    ClusterStackedItemInfo clusterStackedItemInfo;
    String groupName = '';
    List<StackingInfo>? positiveValues;
    List<StackingInfo>? negativeValues;
    CartesianSeriesRenderer seriesRenderer;
    if (isStacked100) {
      _calculateStackingPercentage(seriesRendererCollection);
    }

    stateProperties.chartSeries.clusterStackedItemInfo =
        <ClusterStackedItemInfo>[];
    for (int i = 0; i < seriesRendererCollection.length; i++) {
      seriesRenderer = seriesRendererCollection[i];
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      if (seriesRenderer is StackedSeriesRenderer &&
          seriesRendererDetails.series is StackedSeriesBase) {
        final StackedSeriesBase<dynamic, dynamic> stackedSeriesBase =
            seriesRendererDetails.series as StackedSeriesBase<dynamic, dynamic>;
        if (seriesRendererDetails.dataPoints.isNotEmpty == true) {
          groupName =
              (seriesRendererDetails.seriesType.contains('stackedarea') == true)
                  ? 'stackedareagroup'
                  // ignore: unnecessary_null_comparison
                  : stackedSeriesBase.groupName;
          // : (stackedSeriesBase.groupName ?? ('series ' + i.toString()));
          stackedItemInfo = StackedItemInfo(i, seriesRenderer);
          if (stateProperties.chartSeries.clusterStackedItemInfo.isNotEmpty) {
            for (int k = 0;
                k < stateProperties.chartSeries.clusterStackedItemInfo.length;
                k++) {
              clusterStackedItemInfo =
                  stateProperties.chartSeries.clusterStackedItemInfo[k];
              if (clusterStackedItemInfo.stackName == groupName) {
                clusterStackedItemInfo.stackedItemInfo.add(stackedItemInfo);
                break;
              } else if (k ==
                  stateProperties.chartSeries.clusterStackedItemInfo.length -
                      1) {
                stateProperties.chartSeries.clusterStackedItemInfo.add(
                    ClusterStackedItemInfo(
                        groupName, <StackedItemInfo>[stackedItemInfo]));
                break;
              }
            }
          } else {
            stateProperties.chartSeries.clusterStackedItemInfo.add(
                ClusterStackedItemInfo(
                    groupName, <StackedItemInfo>[stackedItemInfo]));
          }

          seriesRendererDetails.stackingValues = <StackedValues>[];
          StackingInfo? currentPositiveStackInfo;

          if (positiveValues == null || negativeValues == null) {
            positiveValues = <StackingInfo>[];
            currentPositiveStackInfo = StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
            negativeValues = <StackingInfo>[];
            negativeValues.add(StackingInfo(groupName, <double>[]));
          }
          _addStackingValues(
              seriesRendererDetails,
              isStacked100,
              positiveValues,
              negativeValues,
              currentPositiveStackInfo,
              groupName);
        }
      }
    }
  }

  /// To add the values of stacked series
  void _addStackingValues(
      SeriesRendererDetails seriesRendererDetails,
      bool isStacked100,
      List<StackingInfo> positiveValues,
      List<StackingInfo> negativeValues,
      StackingInfo? currentPositiveStackInfo,
      String groupName) {
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    StackingInfo? currentNegativeStackInfo;
    final List<double> startValues = <double>[];
    final List<double> endValues = <double>[];
    final List<CartesianChartPoint<dynamic>?> dataPoints =
        (seriesRendererDetails.yAxisDetails?.axis.anchorRangeToVisiblePoints ??
                    false) ||
                isStacked100
            ? seriesRendererDetails.dataPoints
            : seriesRendererDetails.overAllDataPoints;
    for (int j = 0; j < dataPoints.length; j++) {
      point = dataPoints[j]!;
      value = point.y;
      if (positiveValues.isNotEmpty) {
        for (int k = 0; k < positiveValues.length; k++) {
          if (groupName == positiveValues[k].groupName) {
            currentPositiveStackInfo = positiveValues[k];
            break;
          } else if (k == positiveValues.length - 1) {
            currentPositiveStackInfo = StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
          }
        }
      }
      if (negativeValues.isNotEmpty) {
        for (int k = 0; k < negativeValues.length; k++) {
          if (groupName == negativeValues[k].groupName) {
            currentNegativeStackInfo = negativeValues[k];
            break;
          } else if (k == negativeValues.length - 1) {
            currentNegativeStackInfo = StackingInfo(groupName, <double>[]);
            negativeValues.add(currentNegativeStackInfo);
          }
        }
      }
      if (currentPositiveStackInfo?.stackingValues != null) {
        final int length = currentPositiveStackInfo!.stackingValues!.length;
        if (length == 0 || j > length - 1) {
          currentPositiveStackInfo.stackingValues!.add(0);
        }
      }
      if (currentNegativeStackInfo?.stackingValues != null) {
        final int length = currentNegativeStackInfo!.stackingValues!.length;
        if (length == 0 || j > length - 1) {
          currentNegativeStackInfo.stackingValues!.add(0);
        }
      }
      if (isStacked100 &&
          seriesRendererDetails.renderer is StackedSeriesRenderer) {
        value = value / seriesRendererDetails.percentageValues[j] * 100;
        value = value.isNaN ? 0 : value;
      }
      if (seriesRendererDetails.seriesType.contains('stackedarea') == true ||
          value >= 0) {
        lastValue = currentPositiveStackInfo!.stackingValues![j];
        currentPositiveStackInfo.stackingValues![j] =
            (lastValue + value).toDouble();
      } else {
        lastValue = currentNegativeStackInfo!.stackingValues![j];
        currentNegativeStackInfo.stackingValues![j] =
            (lastValue + value).toDouble();
      }
      startValues.add(lastValue.toDouble());
      endValues.add((value + lastValue).toDouble());
      if (isStacked100 && endValues[j] > 100) {
        endValues[j] = 100;
      }
      point.cumulativeValue =
          seriesRendererDetails.seriesType.contains('100') == false
              ? endValues[j]
              : endValues[j].truncateToDouble();
    }
    if (seriesRendererDetails.renderer is StackedSeriesRenderer) {
      seriesRendererDetails.stackingValues
          .add(StackedValues(startValues, endValues));
    }
    seriesRendererDetails.minimumY = startValues.reduce(math.min);
    seriesRendererDetails.maximumY = endValues.reduce(math.max);

    if (seriesRendererDetails.minimumY! > endValues.reduce(math.min) == true) {
      seriesRendererDetails.minimumY =
          isStacked100 ? -100 : endValues.reduce(math.min);
    }
    if (seriesRendererDetails.maximumY! < startValues.reduce(math.max) ==
        true) {
      seriesRendererDetails.maximumY = 0;
    }
  }

  /// To find the percentage of stacked series
  void _calculateStackingPercentage(
      List<CartesianSeriesRenderer> seriesRendererCollection) {
    List<StackingInfo>? percentageValues;
    CartesianSeriesRenderer seriesRenderer;
    SeriesRendererDetails seriesRendererDetails;
    String groupName;
    StackingInfo? stackingInfo;
    int length;
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    for (int i = 0; i < seriesRendererCollection.length; i++) {
      seriesRenderer = seriesRendererCollection[i];
      seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      seriesRendererDetails.yAxisDetails!.isStack100 = true;
      if (seriesRenderer is StackedSeriesRenderer &&
          seriesRendererDetails.series is StackedSeriesBase) {
        final StackedSeriesBase<dynamic, dynamic> stackedSeriesBase =
            seriesRendererDetails.series as StackedSeriesBase<dynamic, dynamic>;
        if (seriesRendererDetails.dataPoints.isNotEmpty == true) {
          groupName = (seriesRendererDetails.seriesType == 'stackedarea100')
              ? 'stackedareagroup'
              : stackedSeriesBase.groupName;

          if (percentageValues == null) {
            percentageValues = <StackingInfo>[];
            stackingInfo = StackingInfo(groupName, <double>[]);
          }
          for (int j = 0; j < seriesRendererDetails.dataPoints.length; j++) {
            point = seriesRendererDetails.dataPoints[j];
            value = point.y;
            if (percentageValues.isNotEmpty) {
              for (int k = 0; k < percentageValues.length; k++) {
                if (groupName == percentageValues[k].groupName) {
                  stackingInfo = percentageValues[k];
                  break;
                } else if (k == percentageValues.length - 1) {
                  stackingInfo = StackingInfo(groupName, <double>[]);
                  percentageValues.add(stackingInfo);
                }
              }
            }
            if (stackingInfo?.stackingValues != null) {
              length = stackingInfo!.stackingValues!.length;
              if (length == 0 || j > length - 1) {
                stackingInfo.stackingValues!.add(0);
              }
            }
            if (seriesRendererDetails.seriesType.contains('stackedarea') ==
                    true ||
                value >= 0) {
              lastValue = stackingInfo!.stackingValues![j];
              stackingInfo.stackingValues![j] = (lastValue + value).toDouble();
            } else {
              lastValue = stackingInfo!.stackingValues![j];
              stackingInfo.stackingValues![j] = (lastValue - value).toDouble();
            }
            if (j == seriesRendererDetails.dataPoints.length - 1) {
              percentageValues.add(stackingInfo);
            }
          }
        }
        if (percentageValues != null) {
          for (int i = 0; i < percentageValues.length; i++) {
            if (seriesRendererDetails.seriesType == 'stackedarea100') {
              seriesRendererDetails.percentageValues =
                  percentageValues[i].stackingValues!;
            } else {
              if (stackedSeriesBase.groupName ==
                  percentageValues[i].groupName) {
                seriesRendererDetails.percentageValues =
                    percentageValues[i].stackingValues!;
              }
            }
          }
        }
      }
    }
  }

  /// Calculate area type
  void _findAreaType(List<CartesianSeriesRenderer> seriesRendererList) {
    if (visibleSeriesRenderers.isNotEmpty) {
      int index = -1;
      for (final CartesianSeriesRenderer series in seriesRendererList) {
        _setSeriesType(series, index += 1);
      }
    }
  }

  /// To find and set the series type
  void _setSeriesType(CartesianSeriesRenderer seriesRenderer, int index) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesRendererDetails.series.color == null) {
      seriesRendererDetails.seriesColor =
          chart.palette[paletteIndex % chart.palette.length];
      paletteIndex++;
    } else {
      seriesRendererDetails.seriesColor = seriesRendererDetails.series.color;
    }

    seriesRendererDetails.seriesType = getSeriesType(seriesRenderer);

    if (index == 0) {
      final String seriesType = seriesRendererDetails.seriesType;
      stateProperties.requireInvertedAxis = chart.isTransposed ^
          ((seriesType.toLowerCase().contains('bar')) &&
              (!seriesType.toLowerCase().contains('errorbar')));
    }
  }

  ///below method is for indicator rendering
  void _calculateIndicators() {
    // ignore: unnecessary_null_comparison
    if (chart.indicators != null && chart.indicators.isNotEmpty) {
      dynamic indicator;
      bool existField;
      Map<String, int> map = <String, int>{};
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer;
      if (!chart.legend.isVisible!) {
        final List<String> textCollection = <String>[];
        for (int i = 0; i < chart.indicators.length; i++) {
          final TechnicalIndicators<dynamic, dynamic> indicator =
              chart.indicators[i];
          technicalIndicatorsRenderer =
              stateProperties.technicalIndicatorRenderer[i];
          setIndicatorType(indicator, technicalIndicatorsRenderer);
          textCollection.add(technicalIndicatorsRenderer.indicatorType);
        }
        //ignore: prefer_collection_literals
        map = Map<String, int>();
        //ignore: avoid_function_literals_in_foreach_calls
        textCollection.forEach((String str) =>
            map[str] = !map.containsKey(str) ? (1) : (map[str]! + 1));
      }

      final List<String> indicatorTextCollection = <String>[];
      for (int i = 0; i < chart.indicators.length; i++) {
        indicator = chart.indicators[i];
        technicalIndicatorsRenderer =
            stateProperties.technicalIndicatorRenderer[i];
        technicalIndicatorsRenderer.dataPoints =
            <CartesianChartPoint<dynamic>>[];
        technicalIndicatorsRenderer.index = i;
        if (!chart.legend.isVisible!) {
          final int count = indicatorTextCollection
                  .contains(technicalIndicatorsRenderer.indicatorType)
              ? getIndicatorId(indicatorTextCollection,
                  technicalIndicatorsRenderer.indicatorType)
              : 0;
          indicatorTextCollection
              .add(technicalIndicatorsRenderer.indicatorType);
          technicalIndicatorsRenderer.name = indicator.name ??
              (technicalIndicatorsRenderer.indicatorType +
                  (map[technicalIndicatorsRenderer.indicatorType] == 1
                      ? ''
                      : ' $count'));
        }
        if (indicator != null &&
            indicator.isVisible == true &&
            (indicator.dataSource != null || indicator.seriesName != null)) {
          if (indicator.dataSource != null &&
              indicator.dataSource.isNotEmpty == true) {
            existField = technicalIndicatorsRenderer.indicatorType == 'SMA' ||
                technicalIndicatorsRenderer.indicatorType == 'TMA' ||
                technicalIndicatorsRenderer.indicatorType == 'EMA';
            final String valueField =
                existField ? _getFieldType(indicator).toLowerCase() : '';
            CartesianChartPoint<dynamic> currentPoint;
            for (int pointIndex = 0;
                pointIndex < indicator.dataSource.length;
                pointIndex++) {
              if (indicator.xValueMapper != null) {
                final dynamic xVal = indicator.xValueMapper(pointIndex);
                num? highValue, lowValue, openValue, closeValue, volumeValue;
                technicalIndicatorsRenderer.dataPoints!
                    .add(CartesianChartPoint<dynamic>(xVal));
                currentPoint = technicalIndicatorsRenderer.dataPoints![
                    technicalIndicatorsRenderer.dataPoints!.length - 1];
                if (indicator.highValueMapper != null) {
                  highValue = indicator.highValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      .dataPoints![
                          technicalIndicatorsRenderer.dataPoints!.length - 1]
                      .high = highValue;
                }
                if (indicator.lowValueMapper != null) {
                  lowValue = indicator.lowValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      .dataPoints![
                          technicalIndicatorsRenderer.dataPoints!.length - 1]
                      .low = lowValue;
                }

                // changing high,low value
                if (currentPoint.high != null && currentPoint.low != null) {
                  final num high = currentPoint.high;
                  final num low = currentPoint.low;
                  currentPoint.high = math.max<num>(high, low);
                  currentPoint.low = math.min<num>(high, low);
                }
                if (indicator.openValueMapper != null) {
                  openValue = indicator.openValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      .dataPoints![
                          technicalIndicatorsRenderer.dataPoints!.length - 1]
                      .open = openValue;
                }
                if (indicator.closeValueMapper != null) {
                  closeValue = indicator.closeValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      .dataPoints![
                          technicalIndicatorsRenderer.dataPoints!.length - 1]
                      .close = closeValue;
                }
                if (indicator is AccumulationDistributionIndicator &&
                    indicator.volumeValueMapper != null) {
                  volumeValue = indicator.volumeValueMapper!(pointIndex);
                  technicalIndicatorsRenderer
                      .dataPoints![
                          technicalIndicatorsRenderer.dataPoints!.length - 1]
                      .volume = volumeValue;
                }

                if ((closeValue == null &&
                        (!existField || valueField == 'close')) ||
                    (highValue == null &&
                        (valueField == 'high' ||
                            technicalIndicatorsRenderer.indicatorType == 'AD' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'ATR' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'RSI' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'Stochastic')) ||
                    (lowValue == null &&
                        (valueField == 'low' ||
                            technicalIndicatorsRenderer.indicatorType == 'AD' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'ATR' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'RSI' ||
                            technicalIndicatorsRenderer.indicatorType ==
                                'Stochastic')) ||
                    (openValue == null && valueField == 'open') ||
                    (volumeValue == null &&
                        technicalIndicatorsRenderer.indicatorType == 'AD')) {
                  technicalIndicatorsRenderer.dataPoints!.removeAt(
                      technicalIndicatorsRenderer.dataPoints!.length - 1);
                }
              }
            }
          } else if (indicator.seriesName != null) {
            CartesianSeriesRenderer? seriesRenderer;

            for (int i = 0;
                i < stateProperties.chartSeries.visibleSeriesRenderers.length;
                i++) {
              if (indicator.seriesName ==
                  SeriesHelper.getSeriesRendererDetails(
                          stateProperties.chartSeries.visibleSeriesRenderers[i])
                      .series
                      .name) {
                seriesRenderer =
                    stateProperties.chartSeries.visibleSeriesRenderers[i];
                break;
              }
            }
            final SeriesRendererDetails? seriesRendererDetails =
                seriesRenderer != null
                    ? SeriesHelper.getSeriesRendererDetails(seriesRenderer)
                    : null;
            technicalIndicatorsRenderer.dataPoints = (seriesRendererDetails !=
                        null &&
                    (seriesRendererDetails.seriesType == 'hiloopenclose' ||
                        seriesRendererDetails.seriesType == 'candle' ||
                        seriesRendererDetails.seriesType == 'boxandwhisker'))
                ? seriesRendererDetails.dataPoints
                : null;
          }
          if (technicalIndicatorsRenderer.dataPoints != null &&
              technicalIndicatorsRenderer.dataPoints!.isNotEmpty) {
            technicalIndicatorsRenderer.initDataSource(
                indicator, technicalIndicatorsRenderer, chart);
            if (technicalIndicatorsRenderer.renderPoints.isNotEmpty) {
              stateProperties.chartSeries.visibleSeriesRenderers
                  .addAll(technicalIndicatorsRenderer.targetSeriesRenderers);
            }
          }
        }
      }
    }
  }

  /// To get the field type of an indicator
  String _getFieldType(TechnicalIndicators<dynamic, dynamic> indicator) {
    String valueField = '';
    if (indicator is EmaIndicator) {
      valueField = indicator.valueField;
    } else if (indicator is TmaIndicator) {
      valueField = indicator.valueField;
    } else if (indicator is SmaIndicator) {
      valueField = indicator.valueField;
    }
    return valueField;
  }

  /// To return the indicator id
  int getIndicatorId(List<String> list, String str) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == str) {
        count++;
      }
    }
    return count;
  }

  /// Setting indicator type
  void setIndicatorType(TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    if (indicator is AtrIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'ATR';
    } else if (indicator is AccumulationDistributionIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'AD';
    } else if (indicator is BollingerBandIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'Bollinger';
    } else if (indicator is EmaIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'EMA';
    } else if (indicator is MacdIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'MACD';
    } else if (indicator is MomentumIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'Momentum';
    } else if (indicator is RsiIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'RSI';
    } else if (indicator is SmaIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'SMA';
    } else if (indicator is StochasticIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'Stochastic';
    } else if (indicator is TmaIndicator) {
      technicalIndicatorsRenderer.indicatorType = 'TMA';
    }
  }

  /// This function sorts the details available based on the x which is of date time type
  void _sortDateTimeCategoryDetails(
      SeriesRendererDetails seriesRendererDetails) {
    final DateTimeCategoryAxisDetails axisDetails =
        seriesRendererDetails.xAxisDetails as DateTimeCategoryAxisDetails;
    seriesRendererDetails.dataPoints.sort((CartesianChartPoint<dynamic> point1,
        CartesianChartPoint<dynamic> point2) {
      return point2.x.isAfter(point1.x) == true ? -1 : 1;
    });
    axisDetails.labels.sort((String first, String second) {
      return int.parse(first) < int.parse(second) ? -1 : 1;
    });
    seriesRendererDetails.xValues?.sort();
    for (final CartesianChartPoint<dynamic> point
        in seriesRendererDetails.dataPoints) {
      point.xValue =
          axisDetails.labels.indexOf(point.x.microsecondsSinceEpoch.toString());
    }
  }
}
