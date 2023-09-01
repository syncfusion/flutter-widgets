import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../axis/axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/box_and_whisker_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/marker.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for box and whisker series.
class BoxAndWhiskerSeriesRenderer extends XyDataSeriesRenderer {
  /// Calling the default constructor of BoxAndWhiskerSeriesRenderer class.
  BoxAndWhiskerSeriesRenderer();

  late BoxAndWhiskerSegment _segment;
  late SeriesRendererDetails _currentSeriesDetails;
  late SeriesRendererDetails _segmentSeriesDetails;
  late SeriesRendererDetails _oldSeriesDetails;

  /// Range box plot _segment is created here.
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    _currentSeriesDetails = SeriesHelper.getSeriesRendererDetails(this);
    _segment = createSegment();
    SegmentHelper.setSegmentProperties(_segment,
        SegmentProperties(_currentSeriesDetails.stateProperties, _segment));
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(_segment);
    _currentSeriesDetails.oldSeriesRenderers =
        _currentSeriesDetails.stateProperties.oldSeriesRenderers;
    _currentSeriesDetails.isRectSeries = false;
    segmentProperties.seriesIndex = seriesIndex;
    _segment.currentSegmentIndex = pointIndex;
    segmentProperties.seriesRenderer = this;
    segmentProperties.series =
        _currentSeriesDetails.series as XyDataSeries<dynamic, dynamic>;
    _segment.animationFactor = animateFactor;
    segmentProperties.pointColorMapper = currentPoint.pointColorMapper;
    segmentProperties.currentPoint = currentPoint;
    _segmentSeriesDetails =
        SeriesHelper.getSeriesRendererDetails(segmentProperties.seriesRenderer);
    if (_currentSeriesDetails.stateProperties.renderingDetails.widgetNeedUpdate ==
            true &&
        _currentSeriesDetails
                .stateProperties.renderingDetails.isLegendToggled ==
            false &&
        _currentSeriesDetails.oldSeriesRenderers != null &&
        _currentSeriesDetails.oldSeriesRenderers!.isNotEmpty == true &&
        (_currentSeriesDetails.oldSeriesRenderers!.length - 1 >=
                segmentProperties.seriesIndex) ==
            true) {
      _oldSeriesDetails = SeriesHelper.getSeriesRendererDetails(
          _currentSeriesDetails
              .oldSeriesRenderers![segmentProperties.seriesIndex]);
      if (_oldSeriesDetails.seriesName == _segmentSeriesDetails.seriesName) {
        segmentProperties.oldSeriesRenderer = _currentSeriesDetails
            .oldSeriesRenderers![segmentProperties.seriesIndex];
        segmentProperties.oldSegmentIndex = getOldSegmentIndex(_segment);
      }
    }
    _segment.calculateSegmentPoints();
    // Stores the points for rendering box and whisker - high, low and rect points.
    _segment.points
      ..add(Offset(currentPoint.markerPoint!.x, segmentProperties.maxPoint.y))
      ..add(Offset(currentPoint.markerPoint!.x, segmentProperties.minPoint.y))
      ..add(Offset(segmentProperties.lowerX, segmentProperties.topRectY))
      ..add(Offset(segmentProperties.upperX, segmentProperties.topRectY))
      ..add(Offset(segmentProperties.upperX, segmentProperties.bottomRectY))
      ..add(Offset(segmentProperties.lowerX, segmentProperties.bottomRectY));
    customizeSegment(_segment);
    _segment.strokePaint = _segment.getStrokePaint();
    _segment.fillPaint = _segment.getFillPaint();
    _currentSeriesDetails.segments.add(_segment);
    return _segment;
  }

  late BoxPlotQuartileValues _boxPlotQuartileValues;

  /// To find the minimum, maximum, quartile and median value
  /// of a box plot series.
  void _findBoxPlotValues(List<num?> yValues,
      CartesianChartPoint<dynamic> point, BoxPlotMode mode) {
    final int yCount = yValues.length;
    _boxPlotQuartileValues = BoxPlotQuartileValues();
    _boxPlotQuartileValues.average =
        (yValues.fold(0, (num x, num? y) => (x.toDouble()) + y!)) / yCount;
    if (mode == BoxPlotMode.exclusive) {
      _boxPlotQuartileValues.lowerQuartile =
          _getExclusiveQuartileValue(yValues, yCount, 0.25);
      _boxPlotQuartileValues.upperQuartile =
          _getExclusiveQuartileValue(yValues, yCount, 0.75);
      _boxPlotQuartileValues.median =
          _getExclusiveQuartileValue(yValues, yCount, 0.5);
    } else if (mode == BoxPlotMode.inclusive) {
      _boxPlotQuartileValues.lowerQuartile =
          _getInclusiveQuartileValue(yValues, yCount, 0.25);
      _boxPlotQuartileValues.upperQuartile =
          _getInclusiveQuartileValue(yValues, yCount, 0.75);
      _boxPlotQuartileValues.median =
          _getInclusiveQuartileValue(yValues, yCount, 0.5);
    } else {
      _boxPlotQuartileValues.median = _getMedian(yValues);
      _getQuartileValues(yValues, yCount, _boxPlotQuartileValues);
    }
    _getMinMaxOutlier(yValues, yCount, _boxPlotQuartileValues);
    point.minimum = _boxPlotQuartileValues.minimum;
    point.maximum = _boxPlotQuartileValues.maximum;
    point.lowerQuartile = _boxPlotQuartileValues.lowerQuartile;
    point.upperQuartile = _boxPlotQuartileValues.upperQuartile;
    point.median = _boxPlotQuartileValues.median;
    point.outliers = _boxPlotQuartileValues.outliers;
    point.mean = _boxPlotQuartileValues.average;
  }

  /// To find exclusive quartile values.
  double _getExclusiveQuartileValue(
      List<num?> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0]!.toDouble();
    }
    num value = 0;
    final num rank = percentile * (count + 1);
    final int integerRank = rank.abs().floor();
    final num fractionRank = rank - integerRank;
    if (integerRank == 0) {
      value = yValues[0]!;
    } else if (integerRank > count - 1) {
      value = yValues[count - 1]!;
    } else {
      value =
          fractionRank * (yValues[integerRank]! - yValues[integerRank - 1]!) +
              yValues[integerRank - 1]!;
    }
    return value.toDouble();
  }

  /// To find inclusive quartile values.
  double _getInclusiveQuartileValue(
      List<num?> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0]!.toDouble();
    }
    num value = 0;
    final num rank = percentile * (count - 1);
    final int integerRank = rank.abs().floor();
    final num fractionRank = rank - integerRank;
    value = fractionRank * (yValues[integerRank + 1]! - yValues[integerRank]!) +
        yValues[integerRank]!;
    return value.toDouble();
  }

  /// To find a median value of each box plot point.
  double _getMedian(List<num?> values) {
    final int half = (values.length / 2).floor();
    return (values.length % 2 != 0
            ? values[half]!
            : ((values[half - 1]! + values[half]!) / 2.0))
        .toDouble();
  }

  /// To get the quartile values.
  void _getQuartileValues(
      dynamic yValues, num count, BoxPlotQuartileValues boxPlotQuartileValues) {
    if (count == 1) {
      boxPlotQuartileValues.lowerQuartile = yValues[0];
      boxPlotQuartileValues.upperQuartile = yValues[0];
    }
    final bool isEvenList = count % 2 == 0;
    final num halfLength = count ~/ 2;
    final List<num?> lowerQuartileArray = yValues.sublist(0, halfLength);
    final List<num?> upperQuartileArray =
        yValues.sublist(isEvenList ? halfLength : halfLength + 1, count);
    boxPlotQuartileValues.lowerQuartile = _getMedian(lowerQuartileArray);
    boxPlotQuartileValues.upperQuartile = _getMedian(upperQuartileArray);
  }

  /// To get the outliers values of box plot series.
  void _getMinMaxOutlier(List<num?> yValues, int count,
      BoxPlotQuartileValues boxPlotQuartileValues) {
    final double interquartile = boxPlotQuartileValues.upperQuartile! -
        boxPlotQuartileValues.lowerQuartile!;
    final num rangeIQR = 1.5 * interquartile;
    for (int i = 0; i < count; i++) {
      if (yValues[i]! < _boxPlotQuartileValues.lowerQuartile! - rangeIQR) {
        boxPlotQuartileValues.outliers!.add(yValues[i]!);
      } else {
        boxPlotQuartileValues.minimum = yValues[i];
        break;
      }
    }
    for (int i = count - 1; i >= 0; i--) {
      if (yValues[i]! > _boxPlotQuartileValues.upperQuartile! + rangeIQR) {
        boxPlotQuartileValues.outliers!.add(yValues[i]!);
      } else {
        boxPlotQuartileValues.maximum = yValues[i];
        break;
      }
    }
  }

  @override
  BoxAndWhiskerSegment createSegment() => BoxAndWhiskerSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BoxAndWhiskerSegment boxSegment = segment as BoxAndWhiskerSegment;
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(boxSegment);
    segmentProperties.color =
        segmentProperties.currentPoint!.pointColorMapper ??
            _segmentSeriesDetails.seriesColor;
    segmentProperties.strokeColor = segmentProperties.series.borderColor;
    segmentProperties.strokeWidth = segmentProperties.series.borderWidth;
    boxSegment.strokePaint = boxSegment.getStrokePaint();
    boxSegment.fillPaint = boxSegment.getFillPaint();
  }

  /// Draws outlier with different shape and color of the appropriate
  /// data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the box and whisker painter
class BoxAndWhiskerPainter extends CustomPainter {
  /// Creates an instance of box and whisker painter
  BoxAndWhiskerPainter(
      {required this.stateProperties,
      required this.seriesRenderer,
      required this.isRepaint,
      required this.animationController,
      required ValueNotifier<num> notifier,
      required this.painterKey})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  /// Represents the Cartesian chart state properties
  final CartesianStateProperties stateProperties;

  /// Represents the Cartesian chart value
  final SfCartesianChart chart;

  /// Specifies whether to repaint the segment
  final bool isRepaint;

  /// Represents the animation controller value
  final AnimationController animationController;

  /// Specifies the list of current chart location
  List<ChartLocation> currentChartLocations = <ChartLocation>[];

  /// Specifies the box and whisker series renderer
  BoxAndWhiskerSeriesRenderer seriesRenderer;

  /// Specifies the value of painter key
  final PainterKey painterKey;

  /// Painter method for box and whisker series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);

    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final List<CartesianChartPoint<dynamic>> dataPoints =
        seriesRendererDetails.dataPoints;
    assert(dataPoints.isNotEmpty,
        'The data points should be available to render the box and whisker series.');
    Rect clipRect;
    double animationFactor;
    final BoxAndWhiskerSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as BoxAndWhiskerSeries<dynamic, dynamic>;
    CartesianChartPoint<dynamic>? point;
    if (seriesRendererDetails.visible! == true) {
      canvas.save();
      assert(
          // ignore: unnecessary_null_comparison
          !(series.animationDuration != null) || series.animationDuration >= 0,
          'The animation duration of the bar series must be greater than or equal to 0.');
      final int seriesIndex = painterKey.index;
      seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
      final Rect axisClipRect = calculatePlotOffset(
          stateProperties.chartAxis.axisClipRect,
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesRendererDetails.seriesAnimation != null
          ? seriesRendererDetails.seriesAnimation!.value
          : 1;
      stateProperties.shader = null;
      if (series.onCreateShader != null) {
        stateProperties.shader = series.onCreateShader!(
            ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
      }
      int segmentIndex = -1;
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        assert(point.y != null,
            'The yValues of the box and whisker series should not be null.');
        (point.y).remove(null);
        (point.y).sort();
        seriesRenderer._findBoxPlotValues(point.y, point, series.boxPlotMode);
        seriesRendererDetails.calculateRegionData(
            seriesRendererDetails.stateProperties,
            seriesRendererDetails,
            painterKey.index,
            point,
            pointIndex,
            seriesRendererDetails.sideBySideInfo);
        if (point.isVisible && !point.isGap) {
          seriesRendererDetails.drawSegment(
              canvas,
              seriesRenderer._createSegments(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
        }
        if (point.outliers!.isNotEmpty) {
          final MarkerSettingsRenderer markerSettingsRenderer =
              MarkerSettingsRenderer(series.markerSettings);
          seriesRendererDetails.markerShapes = <Path?>[];
          point.outlierRegion = <Rect>[];
          point.outlierRegionPosition = <dynamic>[];
          for (int outlierIndex = 0;
              outlierIndex < point.outliers!.length;
              outlierIndex++) {
            point.outliersPoint.add(calculatePoint(
                point.xValue,
                point.outliers![outlierIndex],
                seriesRendererDetails.xAxisDetails!,
                seriesRendererDetails.yAxisDetails!,
                seriesRendererDetails.stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                axisClipRect));
            calculateOutlierRegion(point, point.outliersPoint[outlierIndex],
                series.markerSettings.width);
            point.outlierRegionPosition!.add(Offset(
                point.outliersPoint[outlierIndex].x,
                point.outliersPoint[outlierIndex].y));
            markerSettingsRenderer.renderMarker(
                seriesRendererDetails,
                point,
                seriesRendererDetails.seriesElementAnimation,
                canvas,
                pointIndex,
                outlierIndex);
          }
        }
        // ignore: unnecessary_null_comparison
        if (chart.tooltipBehavior != null && chart.tooltipBehavior.enable) {
          calculateTooltipRegion(
              point, seriesIndex, seriesRendererDetails, stateProperties);
        }
      }
      clipRect = calculatePlotOffset(
          Rect.fromLTWH(
              stateProperties.chartAxis.axisClipRect.left -
                  series.markerSettings.width,
              stateProperties.chartAxis.axisClipRect.top -
                  series.markerSettings.height,
              stateProperties.chartAxis.axisClipRect.right +
                  series.markerSettings.width,
              stateProperties.chartAxis.axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));

      canvas.restore();
      if ((series.animationDuration <= 0 ||
              animationFactor >= stateProperties.seriesDurationFactor) &&
          series.dataLabelSettings.isVisible) {
        // ignore: unnecessary_null_comparison
        assert(seriesRenderer != null,
            'The box and whisker series should be available to render a data label on it.');
        canvas.clipRect(clipRect);
        seriesRendererDetails.renderSeriesElements(
            chart, canvas, seriesRendererDetails.seriesElementAnimation);
      }
      if (seriesRendererDetails.visible! == true && animationFactor >= 1) {
        stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(BoxAndWhiskerPainter oldDelegate) => isRepaint;
}
