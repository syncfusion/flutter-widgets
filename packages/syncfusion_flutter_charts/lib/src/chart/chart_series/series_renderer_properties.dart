import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../charts.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/data_label.dart';
import '../common/marker.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../trendlines/trendlines.dart';
import '../utils/helper.dart';
import 'financial_series_base.dart';
import 'histogram_series.dart';

/// Represents the series renderer details.
class SeriesRendererDetails {
  /// Argument constructor for SeriesRendererDetails class.
  SeriesRendererDetails(this.renderer);

  /// Specifies the value of Cartesian series renderer.
  final CartesianSeriesRenderer renderer;

  /// Specifies the value of series name.
  String? seriesName;

  /// Holds whether the series is visible.
  bool? visible;

  /// Specifies whether to repaint the series.
  bool needsRepaint = true;

  /// Holds the value of Cartesian chart.
  late SfCartesianChart chart;

  /// Stores the series type.
  late String seriesType;

  /// Whether to check the series is rect series or not.
  // ignore: prefer_final_fields
  bool isRectSeries = false;

  /// Specifies whether the current point types series
  bool isPointSeries = false;

  /// Specifies whether the series has side by side info
  bool hasSideBySideInfo = false;

  /// Specifies whether the series has tooltip behavior
  bool isCalculateRegion = false;

  /// Specifies whether to calculate region for the waterfall/ stacked bar/ stacked column
  bool needsToCalculateRegion = false;

  /// Specifies the histogram values
  late HistogramValues histogramValues;

  /// Specifies the list of draw control points.
  final List<List<Offset>> drawControlPoints = <List<Offset>>[];

  /// Specifies the list of low control points.
  final List<List<Offset>> drawLowControlPoints = <List<Offset>>[];

  /// Specifies the list of high control points.
  final List<List<Offset>> drawHighControlPoints = <List<Offset>>[];

  /// Specifies the segment path value.
  Path? segmentPath;

  /// Gets the Segments collection variable declarations.
  // ignore: prefer_final_fields
  List<ChartSegment> segments = <ChartSegment>[];

  /// Maintain the old series state.
  CartesianSeries<dynamic, dynamic>? oldSeries;

  /// Store the current series state
  late CartesianSeries<dynamic, dynamic> series;

  /// Holds the collection of Cartesian data points.
  // ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>> dataPoints =
      <CartesianChartPoint<dynamic>>[];

  /// Holds the sampled data points of the fast line series. In
  /// fast line series with updateDataSource method the data will not be updated
  /// with the sampled data, so added new list to maintain that data.
  // ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>> sampledDataPoints =
      <CartesianChartPoint<dynamic>>[];

  /// Holds the collection of Cartesian visible data points.
  List<CartesianChartPoint<dynamic>>? visibleDataPoints;

  /// Holds the collection of old data points.
  List<CartesianChartPoint<dynamic>>? oldDataPoints;

  /// Holds the old series initial selected data indexes.
  List<int>? oldSelectedIndexes;

  /// Holds the information for x Axis.
  ChartAxisRendererDetails? xAxisDetails;

  /// Holds the information for y Axis.
  ChartAxisRendererDetails? yAxisDetails;

  /// Minimum x value for Series.
  num? minimumX;

  /// Maximum x value for Series.
  num? maximumX;

  /// Minimum y value for Series.
  num? minimumY;

  /// Maximum y value for Series.
  num? maximumY;

  /// Hold the data about point regions.
  Map<dynamic, dynamic>? regionalData;

  /// Color for the series based on color palette.
  Color? seriesColor;

  /// Specifies the list of x-values.
  List<dynamic>? xValues;

  /// Holds the Cartesian state properties.
  late CartesianStateProperties stateProperties;

  /// Contains the collection of path for markers.
  late List<Path?> markerShapes;

  /// Specifies the value of marker shapes.
  late List<Path?> markerShapes2;

  /// Specifies whether the region is outer.
  // ignore: prefer_final_fields
  bool isOuterRegion = false;

  /// Used to differentiate indicator from series.
  // ignore: prefer_final_fields
  bool isIndicator = false;

  /// Storing mindelta for rect series.
  num? minDelta;

  /// Repaint notifier for series.
  late ValueNotifier<int> repaintNotifier;

  /// Specifies whether the series elements need to animate.
  // ignore: prefer_final_fields
  bool needAnimateSeriesElements = false;

  /// Specifies whether needs to animate.
  bool needsAnimation = false;

  /// Specifies whether to reanimate the elements.
  bool reAnimate = false;

  /// Specifies whether to calculate the region.
  bool calculateRegion = false;

  /// Specifies the series animation.
  Animation<double>? seriesAnimation;

  /// Specifies the series element animation.
  Animation<double>? seriesElementAnimation;

  /// Controls the animation of the corresponding series.
  late AnimationController animationController;

  ///We can redraw the series with updating or creating new points by using this controller.If we need to access the redrawing methods
  ///in this before we must get the ChartSeriesController onRendererCreated event.
  ChartSeriesController? controller;

  /// Specifies the trendline renderer
  List<TrendlineRenderer> trendlineRenderer = <TrendlineRenderer>[];

  /// Specifies the value of data label setting renderer
  late DataLabelSettingsRenderer dataLabelSettingsRenderer;

  /// Specifies the marker setting renderer
  MarkerSettingsRenderer? markerSettingsRenderer;

  /// Specifies whether the selection is enabled
  // ignore: prefer_final_fields
  bool isSelectionEnable = false;

  /// Specifies the value of selection behavior renderer
  SelectionBehaviorRenderer? selectionBehaviorRenderer;

  /// Specifies the selection behavior
  dynamic selectionBehavior;

  /// Specifies whether the marker is rendered
  // ignore: prefer_final_fields
  bool isMarkerRenderEvent = false;

  /// bool for animation status
  late bool animationCompleted;

  /// Specifies whether the series has data label templates
  // ignore: prefer_final_fields
  bool hasDataLabelTemplate = false;

  // ignore: prefer_final_fields
  /// It specifies the side by side information of the visible range.
  VisibleRange? sideBySideInfo;

  /// Store the rect position
  late num rectPosition;

  /// Represents the old series renderer
  List<CartesianSeriesRenderer>? oldSeriesRenderers;

  /// Represents the maximum size
  double? maxSize;

  /// Represents the minimum size
  double? minSize;

  /// Represents the index value of the series corresponding to this renderer
  int? seriesIndex;

  /// Represents the candle series renderer
  late CandleSeries<dynamic, dynamic> candleSeries;

  /// Specifies the over all data points
  List<CartesianChartPoint<dynamic>> overallDataPoints =
      <CartesianChartPoint<dynamic>>[];

  /// Specifies the hilo open close series
  late HiloOpenCloseSeries<dynamic, dynamic> hiloOpenCloseSeries;

  /// Store the stacking values
  List<StackedValues> stackingValues = <StackedValues>[];

  /// Store the percentage values
  List<num> percentageValues = <num>[];

  /// Specifies the list of xValue
  final List<num?> xValueList = <num?>[];

  /// Specifies the list of yValue
  final List<num?> yValueList = <num?>[];

  /// Specifies whether the series is line type
  final bool isLineType = false;

  /// Specifies the dashArray for the series
  List<double>? dashArray;

  /// Specifies whether the fast line series data points contains null or empty points
  bool containsEmptyPoints = false;

  /// Holds the collection of Cartesian overall data points
  // ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>?> overAllDataPoints =
      <CartesianChartPoint<dynamic>?>[];

  /// To draw area segments
  //ignore: unused_element
  void drawSegment(Canvas canvas, ChartSegment segment) {
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    if (SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer)
            .isSelectionEnable ==
        true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          SeriesHelper.getSeriesRendererDetails(
                  segmentProperties.seriesRenderer)
              .selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              segments[segment.currentSegmentIndex!], stateProperties.chart);
    }
    segment.onPaint(canvas);
  }

  /// To render a series of elements for all series
  void renderSeriesElements(SfCartesianChart chart, Canvas canvas,
      Animation<double>? animationController) {
    markerShapes = <Path?>[];
    markerShapes2 = <Path?>[];
    assert(
        // ignore: unnecessary_null_comparison
        !(series.markerSettings.height != null) ||
            series.markerSettings.height >= 0,
        'The height of the marker should be greater than or equal to 0.');
    assert(
        // ignore: unnecessary_null_comparison
        !(series.markerSettings.width != null) ||
            series.markerSettings.width >= 0,
        'The width of the marker must be greater than or equal to 0.');
    final List<CartesianChartPoint<dynamic>> data =
        seriesType == 'fastline' ? sampledDataPoints : dataPoints;
    for (int pointIndex = 0; pointIndex < data.length; pointIndex++) {
      final CartesianChartPoint<dynamic> point = data[pointIndex];
      if ((series.markerSettings.isVisible &&
              renderer is! BoxAndWhiskerSeriesRenderer) ||
          renderer is ScatterSeriesRenderer) {
        markerSettingsRenderer?.renderMarker(
            this, point, animationController, canvas, pointIndex);
      }
    }
  }

  /// Method to repaint the series element
  void repaintSeriesElement() {
    repaintNotifier.value++;
  }

  /// Method to listen the animation status
  void animationStatusListener(AnimationStatus status) {
    // ignore: unnecessary_null_comparison
    if (stateProperties != null && status == AnimationStatus.completed) {
      reAnimate = false;
      animationCompleted = true;
      stateProperties.animationCompleteCount++;
      setAnimationStatus(stateProperties);
      // ignore: unnecessary_null_comparison
    } else if (stateProperties != null && status == AnimationStatus.forward) {
      stateProperties.renderingDetails.animateCompleted = false;
      animationCompleted = false;
    }
  }

  /// To store the series properties
  void storeSeriesProperties(
      CartesianStateProperties stateProperties, int index) {
    this.stateProperties = stateProperties;
    chart = stateProperties.chart;
    isRectSeries = seriesType.contains('column') ||
        (seriesType.contains('bar') && !seriesType.contains('errorbar')) ||
        seriesType == 'histogram';
    regionalData = <dynamic, dynamic>{};
    segmentPath = Path();
    segments = <ChartSegment>[];
    seriesColor = series.color ?? chart.palette[index % chart.palette.length];

    // calculates the tooltip region for trenlines in this series
    final List<Trendline>? trendlines = series.trendlines;
    if (trendlines != null &&
        // ignore: unnecessary_null_comparison
        chart.tooltipBehavior != null &&
        chart.tooltipBehavior.enable) {
      for (int j = 0; j < trendlines.length; j++) {
        if (trendlineRenderer[j].isNeedRender) {
          if (trendlineRenderer[j].pointsData != null) {
            for (int k = 0; k < trendlineRenderer[j].pointsData!.length; k++) {
              final CartesianChartPoint<dynamic> trendlinePoint =
                  trendlineRenderer[j].pointsData![k];
              calculateTooltipRegion(trendlinePoint, index, this,
                  stateProperties, trendlines[j], trendlineRenderer[j], j);
            }
          }
        }
      }
    }
  }

  /// To get the proper data for histogram series
  void processData(HistogramSeries<dynamic, dynamic> series, List<num> yValues,
      num yValuesCount) {
    histogramValues = HistogramValues();
    histogramValues.yValues = yValues;
    final num mean = yValuesCount / histogramValues.yValues!.length;
    histogramValues.mean = mean;
    num sumValue = 0;
    num sDValue;
    for (int value = 0; value < histogramValues.yValues!.length; value++) {
      sumValue += (histogramValues.yValues![value] - histogramValues.mean!) *
          (histogramValues.yValues![value] - histogramValues.mean!);
    }
    sDValue = math.sqrt(sumValue / (histogramValues.yValues!.length - 1));
    histogramValues.sDValue = sDValue;
  }

  /// method to set the bool variables based on the series type
  void setSeriesProperties(SeriesRendererDetails seriesRendererDetails) {
    if (seriesType.contains('column') ||
        seriesType.contains('stackedbar') ||
        seriesType == 'bar' ||
        seriesType == 'histogram' ||
        seriesType == 'waterfall') {
      isRectSeries = true;
      needsToCalculateRegion = seriesType.contains('waterfall') ||
          seriesType.contains('stackedcolumn') ||
          seriesType.contains('stackedbar');
    } else if (seriesType == 'scatter' || seriesType == 'bubble') {
      isPointSeries = true;
    }

    hasSideBySideInfo = isRectSeries ||
        (seriesType.contains('candle') ||
            seriesType.contains('hilo') ||
            seriesType.contains('histogram') ||
            seriesType.contains('box'));

    // ignore: unnecessary_null_comparison
    isCalculateRegion = seriesType != 'errorbar' &&
        seriesType != 'boxandwhisker' &&
        ((chart.tooltipBehavior.enable) ||
            (seriesRendererDetails.series.onPointTap != null ||
                seriesRendererDetails.series.onPointDoubleTap != null ||
                seriesRendererDetails.series.onPointLongPress != null));
  }

  /// To find the region data of a series
  void calculateRegionData(
      CartesianStateProperties stateProperties,
      SeriesRendererDetails seriesRendererDetails,
      int seriesIndex,
      CartesianChartPoint<dynamic> point,
      int pointIndex,
      [VisibleRange? sideBySideInfo,
      CartesianChartPoint<dynamic>? nextPoint,
      num? midX,
      num? midY]) {
    if (withInRange(seriesRendererDetails.dataPoints[pointIndex].xValue,
        seriesRendererDetails.xAxisDetails!)) {
      seriesRendererDetails.visibleDataPoints!
          .add(seriesRendererDetails.dataPoints[pointIndex]);
      seriesRendererDetails.dataPoints[pointIndex].visiblePointIndex =
          seriesRendererDetails.visibleDataPoints!.length - 1;
    }
    chart = stateProperties.chart;
    final Rect rect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(xAxisDetails!.axis.plotOffset, yAxisDetails!.axis.plotOffset));

    CartesianChartPoint<dynamic> point;
    if (visible!) {
      point = dataPoints[pointIndex];
      if (point.region == null ||
          seriesRendererDetails.calculateRegion == true ||
          needsToCalculateRegion) {
        if (seriesRendererDetails.calculateRegion == true &&
            dataPoints.length == pointIndex - 1) {
          seriesRendererDetails.calculateRegion = false;
        }

        /// side by side range calculated
        seriesRendererDetails.sideBySideInfo = hasSideBySideInfo
            ? calculateSideBySideInfo(
                seriesRendererDetails.renderer, stateProperties)
            : seriesRendererDetails.sideBySideInfo;
        if (isRectSeries) {
          calculateRectSeriesRegion(
              point, pointIndex, seriesRendererDetails, stateProperties);
        } else if (isPointSeries) {
          calculatePointSeriesRegion(
              point, pointIndex, seriesRendererDetails, stateProperties, rect);
        } else if (seriesType == 'errorbar') {
          calculateErrorBarSeriesRegion(
              point, pointIndex, seriesRendererDetails, stateProperties, rect);
        } else {
          calculatePathSeriesRegion(
              point,
              pointIndex,
              this,
              stateProperties,
              rect,
              series.markerSettings.height,
              series.markerSettings.width,
              sideBySideInfo,
              nextPoint,
              midX,
              midY);
        }
      }
      // ignore: unnecessary_null_comparison
      if (isCalculateRegion) {
        calculateTooltipRegion(
            point, seriesIndex, seriesRendererDetails, stateProperties);
      }
    }
  }

  /// To find the region data of chart tooltip
  void calculateTooltipRegionUsingIndex(SfCartesianChart chart, int seriesIndex,
      CartesianChartPoint<dynamic> point, int pointIndex) {
    /// For tooltip implementation
    // ignore: unnecessary_null_comparison
    if (series.enableTooltip != null &&
        series.enableTooltip &&
        // ignore: unnecessary_null_comparison
        point != null &&
        !point.isGap &&
        !point.isDrop) {
      final List<String> regionData = <String>[];
      String? date;
      final List<dynamic> regionRect = <dynamic>[];
      final dynamic primaryAxisDetails = xAxisDetails;
      if (primaryAxisDetails is DateTimeAxisDetails) {
        final DateTimeAxis axis = primaryAxisDetails.axis as DateTimeAxis;
        final num interval = primaryAxisDetails.visibleRange!.minimum.ceil();
        final num prevInterval = (primaryAxisDetails.visibleLabels.isNotEmpty)
            ? primaryAxisDetails
                .visibleLabels[primaryAxisDetails.visibleLabels.length - 1]
                .value
            : interval;
        final DateFormat dateFormat = axis.dateFormat ??
            getDateTimeLabelFormat(xAxisDetails!.axisRenderer, interval.toInt(),
                prevInterval.toInt());
        date = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(point.xValue));
      } else if (primaryAxisDetails is DateTimeCategoryAxisDetails) {
        date = primaryAxisDetails.dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
      }
      xAxisDetails is CategoryAxisDetails
          ? regionData.add(point.x.toString())
          : xAxisDetails is DateTimeAxisDetails ||
                  xAxisDetails is DateTimeCategoryAxisDetails
              ? regionData.add(date.toString())
              : regionData.add(getLabelValue(point.xValue, xAxisDetails!.axis,
                      chart.tooltipBehavior.decimalPlaces)
                  .toString());
      if (seriesType.contains('range')) {
        regionData.add(getLabelValue(point.high, yAxisDetails!.axis,
                chart.tooltipBehavior.decimalPlaces)
            .toString());
        regionData.add(getLabelValue(point.low, yAxisDetails!.axis,
                chart.tooltipBehavior.decimalPlaces)
            .toString());
      } else {
        regionData.add(getLabelValue(point.yValue, yAxisDetails!.axis,
                chart.tooltipBehavior.decimalPlaces)
            .toString());
      }
      regionData.add(series.name ?? 'series $seriesIndex');
      regionRect.add(point.region);
      regionRect.add(isRectSeries
          ? seriesType == 'column' || seriesType.contains('stackedcolumn')
              ? (point.yValue > 0) == true
                  ? point.region!.topCenter
                  : point.region!.bottomCenter
              : point.region!.topCenter
          : (seriesType == 'rangearea'
              ? Offset(point.markerPoint!.x,
                  (point.markerPoint!.y + point.markerPoint2!.y) / 2)
              : point.region!.center));
      regionRect.add(point.pointColorMapper);
      regionRect.add(point.bubbleSize);
      if (seriesType.contains('stacked')) {
        regionData.add((point.cumulativeValue).toString());
      }
      regionalData![regionRect] = regionData;
    }
  }

  /// To calculate the empty point average mode value
  void calculateAverageModeValue(
      int pointIndex,
      int pointLength,
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> prevPoint) {
    final List<dynamic> dataSource = series.dataSource;
    final CartesianChartPoint<dynamic> nextPoint = getPointFromData(
        this,
        pointLength < dataSource.length - 1
            ? dataSource.indexOf(dataSource[pointLength + 1])
            : dataSource.indexOf(dataSource[pointLength]));
    if (seriesType.contains('range') ||
        seriesType.contains('hilo') ||
        seriesType.contains('candle')) {
      final CartesianSeries<dynamic, dynamic> cartesianSeries = series;
      if (cartesianSeries is FinancialSeriesBase &&
          cartesianSeries.showIndicationForSameValues) {
        if (currentPoint.low != null || currentPoint.high != null) {
          currentPoint.low = currentPoint.low ?? currentPoint.high;
          currentPoint.high = currentPoint.high ?? currentPoint.low;
        } else {
          currentPoint.low = 0;
          currentPoint.high = 0;
          currentPoint.open = 0;
          currentPoint.close = 0;
          currentPoint.isGap = true;
        }
        if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
          if (currentPoint.open != null || currentPoint.close != null) {
            currentPoint.open = currentPoint.open ?? currentPoint.close;
            currentPoint.close = currentPoint.close ?? currentPoint.open;
          } else {
            currentPoint.low = 0;
            currentPoint.high = 0;
            currentPoint.open = 0;
            currentPoint.close = 0;
            currentPoint.isGap = true;
          }
        }
      } else {
        if (pointIndex == 0) {
          if (currentPoint.low == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.low = 0
                : currentPoint.low = ((nextPoint.low) ?? 0) / 2;
          }
          if (currentPoint.high == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.high = 0
                : currentPoint.high = ((nextPoint.high) ?? 0) / 2;
          }
          if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
            if (currentPoint.open == null) {
              pointIndex == dataSource.length - 1
                  ? currentPoint.open = 0
                  : currentPoint.open = ((nextPoint.open) ?? 0) / 2;
            }
            if (currentPoint.close == null) {
              pointIndex == dataSource.length - 1
                  ? currentPoint.close = 0
                  : currentPoint.close = ((nextPoint.close) ?? 0) / 2;
            }
          }
        } else if (pointIndex == dataSource.length - 1) {
          currentPoint.low = currentPoint.low ?? ((prevPoint.low) ?? 0) / 2;
          currentPoint.high = currentPoint.high ?? ((prevPoint.high) ?? 0) / 2;

          if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
            currentPoint.open =
                currentPoint.open ?? ((prevPoint.open) ?? 0) / 2;
            currentPoint.close =
                currentPoint.close ?? ((prevPoint.close) ?? 0) / 2;
          }
        } else {
          currentPoint.low = currentPoint.low ??
              (((prevPoint.low) ?? 0) + ((nextPoint.low) ?? 0)) / 2;
          currentPoint.high = currentPoint.high ??
              (((prevPoint.high) ?? 0) + ((nextPoint.high) ?? 0)) / 2;

          if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
            currentPoint.open = currentPoint.open ??
                (((prevPoint.open) ?? 0) + ((nextPoint.open) ?? 0)) / 2;
            currentPoint.close = currentPoint.close ??
                (((prevPoint.close) ?? 0) + ((nextPoint.close) ?? 0)) / 2;
          }
        }
      }
    } else {
      if (pointIndex == 0) {
        ///Check the first point is null
        pointIndex == dataSource.length - 1
            ?

            ///Check the series contains single point with null value
            currentPoint.y = 0
            : currentPoint.y = ((nextPoint.y) ?? 0) / 2;
      } else if (pointIndex == dataSource.length - 1) {
        ///Check the last point is null
        currentPoint.y = ((prevPoint.y) ?? 0) / 2;
      } else {
        currentPoint.y = (((prevPoint.y) ?? 0) + ((nextPoint.y) ?? 0)) / 2;
      }
    }
  }

  /// To dispose the objects.
  void dispose() {
    for (final ChartSegment segment in segments) {
      segment.dispose();
    }

    segments.clear();
  }
}
