import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../common/event_args.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/waterfall_series.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/data_label.dart';
import '../utils/helper.dart';

/// Calculating the label location based on alignment value.
List<ChartLocation?> _getAlignedLabelLocations(
    CartesianStateProperties stateProperties,
    SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    ChartLocation chartLocation,
    ChartLocation? chartLocation2,
    Size textSize) {
  final SfCartesianChart chart = stateProperties.chart;
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  final bool transposed = stateProperties.requireInvertedAxis;
  final bool isRangeSeries =
      seriesRendererDetails.seriesType.contains('range') == true ||
          seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType.contains('candle') == true;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  final double alignmentValue = textSize.height +
      (series.markerSettings.isVisible
          ? ((series.markerSettings.borderWidth * 2) +
              series.markerSettings.height)
          : 0);
  if ((seriesRendererDetails.seriesType.contains('bar') == true &&
          !chart.isTransposed) ||
      (seriesRendererDetails.seriesType.contains('column') == true &&
          chart.isTransposed) ||
      (seriesRendererDetails.seriesType.contains('waterfall') == true &&
          chart.isTransposed) ||
      seriesRendererDetails.seriesType.contains('hilo') == true ||
      seriesRendererDetails.seriesType.contains('candle') == true ||
      isBoxSeries) {
    chartLocation.x = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.x
        : _calculateAlignment(
            alignmentValue,
            chartLocation.x,
            dataLabel.alignment,
            (isRangeSeries
                    ? point.high
                    : isBoxSeries
                        ? point.maximum
                        : point.yValue) <
                0,
            transposed);
    if (isRangeSeries || isBoxSeries) {
      chartLocation2!.x =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.x
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.x,
                  dataLabel.alignment,
                  (isRangeSeries
                          ? point.low
                          : isBoxSeries
                              ? point.minimum
                              : point.yValue) <
                      0,
                  transposed);
    }
  } else {
    chartLocation.y = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.y
        : _calculateAlignment(
            alignmentValue,
            chartLocation.y,
            dataLabel.alignment,
            (isRangeSeries
                    ? point.high
                    : isBoxSeries
                        ? point.maximum
                        : point.yValue) <
                0,
            transposed);
    if (isRangeSeries || isBoxSeries) {
      chartLocation2!.y =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.y
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.y,
                  dataLabel.alignment,
                  (isRangeSeries
                          ? point.low
                          : isBoxSeries
                              ? point.minimum
                              : point.yValue) <
                      0,
                  transposed);
    }
  }
  return <ChartLocation?>[chartLocation, chartLocation2];
}

/// Calculating the label location based on dataLabel position value
/// (for range and rect series only).
List<ChartLocation?> _getLabelLocations(
    int index,
    CartesianStateProperties stateProperties,
    SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    ChartLocation? chartLocation,
    ChartLocation? chartLocation2,
    Size textSize,
    Size? textSize2) {
  final bool transposed = stateProperties.requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool isRangeSeries =
      seriesRendererDetails.seriesType.contains('range') == true ||
          seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType.contains('candle') == true;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  final bool inversed = seriesRendererDetails.yAxisDetails!.axis.isInversed;
  final num value = isRangeSeries
      ? point.high
      : isBoxSeries
          ? point.maximum
          : point.yValue;
  final bool minus = (value < 0 && !inversed) || (!(value < 0) && inversed);
  if (!stateProperties.requireInvertedAxis) {
    chartLocation!.y = !isBoxSeries
        ? _calculateRectPosition(
            chartLocation.y,
            point.region!,
            minus,
            isRangeSeries
                ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                        dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                    ? dataLabel.labelAlignment
                    : ChartDataLabelAlignment.auto)
                : dataLabel.labelAlignment,
            seriesRendererDetails,
            textSize,
            dataLabel.borderWidth,
            index,
            chartLocation,
            stateProperties,
            transposed,
            margin)
        : chartLocation.y;
  } else {
    chartLocation!.x = !isBoxSeries
        ? _calculateRectPosition(
            chartLocation.x,
            point.region!,
            minus,
            seriesRendererDetails.seriesType.contains('hilo') == true ||
                    seriesRendererDetails.seriesType.contains('candle') ==
                        true ||
                    isBoxSeries
                ? ChartDataLabelAlignment.auto
                : isRangeSeries
                    ? ((dataLabel.labelAlignment ==
                                ChartDataLabelAlignment.outer ||
                            dataLabel.labelAlignment ==
                                ChartDataLabelAlignment.top)
                        ? dataLabel.labelAlignment
                        : ChartDataLabelAlignment.auto)
                    : dataLabel.labelAlignment,
            seriesRendererDetails,
            textSize,
            dataLabel.borderWidth,
            index,
            chartLocation,
            stateProperties,
            transposed,
            margin)
        : chartLocation.x;
  }
  chartLocation2 = isRangeSeries
      ? _getSecondLabelLocation(index, stateProperties, seriesRendererDetails,
          point, dataLabel, chartLocation, chartLocation2!, textSize)
      : chartLocation2;
  return <ChartLocation?>[chartLocation, chartLocation2];
}

/// Finding range series second label location.
ChartLocation _getSecondLabelLocation(
    int index,
    CartesianStateProperties stateProperties,
    SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    ChartLocation chartLocation,
    ChartLocation chartLocation2,
    Size textSize) {
  final bool inversed = seriesRendererDetails.yAxisDetails!.axis.isInversed;
  final bool transposed = stateProperties.requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  bool minus;

  minus = (seriesRendererDetails.seriesType == 'boxandwhisker')
      ? (point.minimum! < 0 && !inversed) || (!(point.minimum! < 0) && inversed)
      : ((point.low < 0) == true && !inversed) ||
          ((point.low < 0) == false && inversed);

  if (!stateProperties.requireInvertedAxis) {
    chartLocation2.y = _calculateRectPosition(
        chartLocation2.y,
        point.region!,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRendererDetails,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        stateProperties,
        transposed,
        margin);
  } else {
    chartLocation2.x = _calculateRectPosition(
        chartLocation2.x,
        point.region!,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRendererDetails,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        stateProperties,
        transposed,
        margin);
  }
  return chartLocation2;
}

/// Setting data label region.
void _calculateDataLabelRegion(
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    CartesianStateProperties stateProperties,
    ChartLocation chartLocation,
    ChartLocation? chartLocation2,
    bool isRangeSeries,
    Rect clipRect,
    Size textSize,
    Size? textSize2,
    ChartLocation? chartLocation3,
    ChartLocation? chartLocation4,
    ChartLocation? chartLocation5,
    Size? textSize3,
    Size? textSize4,
    Size? textSize5,
    SeriesRendererDetails seriesRendererDetails,
    int index) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRendererDetails.dataLabelSettingsRenderer;
  Rect? rect, rect2, rect3, rect4, rect5;
  final EdgeInsets margin = dataLabel.margin;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  rect = _calculateLabelRect(chartLocation, textSize, margin,
      dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor);
  // if angle is given label will
  rect =
      ((index == 0 || index == seriesRendererDetails.dataPoints.length - 1) &&
              (dataLabelSettingsRenderer.angle / 90) % 2 == 1 &&
              !stateProperties.requireInvertedAxis)
          ? rect
          : (dataLabelSettingsRenderer.angle / 90) % 2 == 1
              ? rect
              : _validateRect(rect, clipRect);
  if (isRangeSeries || isBoxSeries) {
    rect2 = _calculateLabelRect(chartLocation2!, textSize2!, margin,
        dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor);
    rect2 = _validateRect(rect2, clipRect);
  }
  if ((seriesRendererDetails.seriesType.contains('candle') == true ||
          seriesRendererDetails.seriesType.contains('hilo') == true ||
          isBoxSeries) &&
      (chartLocation3 != null ||
          chartLocation4 != null ||
          chartLocation5 != null)) {
    rect3 = _calculateLabelRect(chartLocation3!, textSize3!, margin,
        dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor);
    rect3 = _validateRect(rect3, clipRect);

    rect4 = _calculateLabelRect(chartLocation4!, textSize4!, margin,
        dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor);
    rect4 = _validateRect(rect4, clipRect);

    if (isBoxSeries) {
      rect5 = _calculateLabelRect(chartLocation5!, textSize5!, margin,
          dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor);
      rect5 = _validateRect(rect5, clipRect);
    }
  }
  if (dataLabelSettingsRenderer.color != null ||
      dataLabel.useSeriesColor ||
      // ignore: unnecessary_null_comparison
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect =
        _calculatePaddedFillRect(rect, dataLabel.borderRadius, margin);
    point.labelLocation = ChartLocation(fillRect.center.dx - textSize.width / 2,
        fillRect.center.dy - textSize.height / 2);
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
        point.labelLocation!.y, textSize.width, textSize.height);
    if (margin == EdgeInsets.zero) {
      point.labelFillRect = fillRect;
    } else {
      final Rect rect = fillRect.middleRect;
      if (seriesRendererDetails.seriesType == 'candle' &&
          stateProperties.requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation = ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (isBoxSeries &&
          stateProperties.requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation = ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (seriesRendererDetails.seriesType == 'candle' &&
          !stateProperties.requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation = ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else if (isBoxSeries &&
          !stateProperties.requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation = ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else {
        point.labelLocation = ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height / 2 - textSize.height / 2);
      }
      point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
          point.labelLocation!.y, textSize.width, textSize.height);
      point.labelFillRect = _rectToRrect(rect, dataLabel.borderRadius);
    }
    if (isRangeSeries || isBoxSeries) {
      final RRect fillRect2 =
          _calculatePaddedFillRect(rect2!, dataLabel.borderRadius, margin);
      point.labelLocation2 = ChartLocation(
          fillRect2.center.dx - textSize2!.width / 2,
          fillRect2.center.dy - textSize2.height / 2);
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
          point.labelLocation2!.y, textSize2.width, textSize2.height);
      if (margin == EdgeInsets.zero) {
        point.labelFillRect2 = fillRect2;
      } else {
        final Rect rect2 = fillRect2.middleRect;
        point.labelLocation2 = ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
        point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
            point.labelLocation2!.y, textSize2.width, textSize2.height);
        point.labelFillRect2 = _rectToRrect(rect2, dataLabel.borderRadius);
      }
    }
    if (seriesRendererDetails.seriesType.contains('candle') == true ||
        seriesRendererDetails.seriesType.contains('hilo') == true ||
        isBoxSeries && (rect3 != null || rect4 != null || rect5 != null)) {
      final RRect fillRect3 =
          _calculatePaddedFillRect(rect3!, dataLabel.borderRadius, margin);
      point.labelLocation3 = ChartLocation(
          fillRect3.center.dx - textSize3!.width / 2,
          fillRect3.center.dy - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
          point.labelLocation3!.y, textSize3.width, textSize3.height);
      if (margin == EdgeInsets.zero) {
        point.labelFillRect3 = fillRect3;
      } else {
        final Rect rect3 = fillRect3.middleRect;
        point.labelLocation3 = ChartLocation(
            rect3.left + rect3.width / 2 - textSize3.width / 2,
            rect3.top + rect3.height / 2 - textSize3.height / 2);
        point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
            point.labelLocation3!.y, textSize3.width, textSize3.height);
        point.labelFillRect3 = _rectToRrect(rect3, dataLabel.borderRadius);
      }
      final RRect fillRect4 =
          _calculatePaddedFillRect(rect4!, dataLabel.borderRadius, margin);
      point.labelLocation4 = ChartLocation(
          fillRect4.center.dx - textSize4!.width / 2,
          fillRect4.center.dy - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
          point.labelLocation4!.y, textSize4.width, textSize4.height);
      if (margin == EdgeInsets.zero) {
        point.labelFillRect4 = fillRect4;
      } else {
        final Rect rect4 = fillRect4.middleRect;
        point.labelLocation4 = ChartLocation(
            rect4.left + rect4.width / 2 - textSize4.width / 2,
            rect4.top + rect4.height / 2 - textSize4.height / 2);
        point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
            point.labelLocation4!.y, textSize4.width, textSize4.height);
        point.labelFillRect4 = _rectToRrect(rect4, dataLabel.borderRadius);
      }
      if (isBoxSeries) {
        final RRect fillRect5 =
            _calculatePaddedFillRect(rect5!, dataLabel.borderRadius, margin);
        point.labelLocation5 = ChartLocation(
            fillRect5.center.dx - textSize5!.width / 2,
            fillRect5.center.dy - textSize5.height / 2);
        point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
            point.labelLocation5!.y, textSize5.width, textSize5.height);
        if (margin == EdgeInsets.zero) {
          point.labelFillRect5 = fillRect5;
        } else {
          final Rect rect5 = fillRect5.middleRect;
          point.labelLocation5 = ChartLocation(
              rect5.left + rect5.width / 2 - textSize5.width / 2,
              rect5.top + rect5.height / 2 - textSize5.height / 2);
          point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
              point.labelLocation5!.y, textSize5.width, textSize5.height);
          point.labelFillRect5 = _rectToRrect(rect5, dataLabel.borderRadius);
        }
      }
    }
  } else {
    if (seriesRendererDetails.seriesType == 'candle' &&
        stateProperties.requireInvertedAxis &&
        (point.close > point.high) == true) {
      point.labelLocation = ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (isBoxSeries &&
        stateProperties.requireInvertedAxis &&
        point.upperQuartile! > point.maximum!) {
      point.labelLocation = ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (seriesRendererDetails.seriesType == 'candle' &&
        !stateProperties.requireInvertedAxis &&
        (point.close > point.high) == true) {
      point.labelLocation = ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else if (isBoxSeries &&
        !stateProperties.requireInvertedAxis &&
        point.upperQuartile! > point.maximum!) {
      point.labelLocation = ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else {
      point.labelLocation = ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    }
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation!.x,
        point.labelLocation!.y, textSize.width, textSize.height);
    if (isRangeSeries || isBoxSeries) {
      if (seriesRendererDetails.seriesType == 'candle' &&
          stateProperties.requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation2 = ChartLocation(
            rect2!.left + rect2.width + textSize2!.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (isBoxSeries &&
          stateProperties.requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation2 = ChartLocation(
            rect2!.left + rect2.width + textSize2!.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (seriesRendererDetails.seriesType == 'candle' &&
          !stateProperties.requireInvertedAxis &&
          (point.close > point.high) == true) {
        point.labelLocation2 = ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else if (isBoxSeries &&
          !stateProperties.requireInvertedAxis &&
          point.upperQuartile! > point.maximum!) {
        point.labelLocation2 = ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else {
        point.labelLocation2 = ChartLocation(
            rect2!.left + rect2.width / 2 - textSize2!.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      }
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2!.x,
          point.labelLocation2!.y, textSize2.width, textSize2.height);
    }
    if ((seriesRendererDetails.seriesType.contains('candle') == true ||
            seriesRendererDetails.seriesType.contains('hilo') == true ||
            isBoxSeries) &&
        (rect3 != null || rect4 != null)) {
      point.labelLocation3 = ChartLocation(
          rect3!.left + rect3.width / 2 - textSize3!.width / 2,
          rect3.top + rect3.height / 2 - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3!.x,
          point.labelLocation3!.y, textSize3.width, textSize3.height);
      point.labelLocation4 = ChartLocation(
          rect4!.left + rect4.width / 2 - textSize4!.width / 2,
          rect4.top + rect4.height / 2 - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4!.x,
          point.labelLocation4!.y, textSize4.width, textSize4.height);
      if (rect5 != null) {
        point.labelLocation5 = ChartLocation(
            rect5.left + rect5.width / 2 - textSize5!.width / 2,
            rect5.top + rect5.height / 2 - textSize5.height / 2);
        point.dataLabelRegion5 = Rect.fromLTWH(point.labelLocation5!.x,
            point.labelLocation5!.y, textSize5.width, textSize5.height);
      }
    }
  }
}

/// To find the position of a series to render.
double _calculatePathPosition(
    double labelLocation,
    ChartDataLabelAlignment position,
    Size size,
    double borderWidth,
    SeriesRendererDetails seriesRendererDetails,
    int index,
    bool inverted,
    ChartLocation point,
    CartesianStateProperties stateProperties,
    CartesianChartPoint<dynamic> currentPoint,
    Size markerSize) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  const double padding = 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final num fillSpace = needFill ? padding : 0;
  if (seriesRendererDetails.seriesType.contains('area') == true &&
      seriesRendererDetails.seriesType.contains('rangearea') == false &&
      seriesRendererDetails.yAxisDetails!.axis.isInversed == true) {
    position = position == ChartDataLabelAlignment.top
        ? ChartDataLabelAlignment.bottom
        : (position == ChartDataLabelAlignment.bottom
            ? ChartDataLabelAlignment.top
            : position);
  }
  position = (stateProperties.chartSeries.visibleSeriesRenderers.length == 1 &&
          (seriesRendererDetails.seriesType == 'stackedarea100' ||
              seriesRendererDetails.seriesType == 'stackedline100') &&
          position == ChartDataLabelAlignment.auto)
      ? ChartDataLabelAlignment.bottom
      : position;
  switch (position) {
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = labelLocation -
          markerSize.height -
          borderWidth -
          (size.height / 2) -
          padding -
          fillSpace;
      break;
    case ChartDataLabelAlignment.bottom:
      labelLocation = labelLocation +
          markerSize.height +
          borderWidth +
          (size.height / 2) +
          padding +
          fillSpace;
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculatePathActualPosition(
          seriesRendererDetails,
          size,
          index,
          inverted,
          borderWidth,
          point,
          stateProperties,
          currentPoint,
          seriesRendererDetails.yAxisDetails!.axis.isInversed);
      break;
    case ChartDataLabelAlignment.middle:
      break;
  }
  return labelLocation;
}

/// Below method is for dataLabel alignment calculation.
double _calculateAlignment(double value, double labelLocation,
    ChartAlignment alignment, bool isMinus, bool inverted) {
  switch (alignment) {
    case ChartAlignment.far:
      labelLocation = !inverted
          ? (isMinus ? labelLocation + value : labelLocation - value)
          : (isMinus ? labelLocation - value : labelLocation + value);
      break;
    case ChartAlignment.near:
      labelLocation = !inverted
          ? (isMinus ? labelLocation - value : labelLocation + value)
          : (isMinus ? labelLocation + value : labelLocation - value);
      break;
    case ChartAlignment.center:
      labelLocation = labelLocation;
      break;
  }
  return labelLocation;
}

/// Calculate label position for non rect series.
double _calculatePathActualPosition(
    SeriesRendererDetails seriesRendererDetails,
    Size size,
    int index,
    bool inverted,
    double borderWidth,
    ChartLocation point,
    CartesianStateProperties stateProperties,
    CartesianChartPoint<dynamic> currentPoint,
    bool inversed) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  late double yLocation;
  bool isBottom, isOverLap = true;
  Rect labelRect;
  int positionIndex;
  final ChartDataLabelAlignment position =
      _getActualPathDataLabelAlignment(seriesRendererDetails, index, inversed);
  isBottom = position == ChartDataLabelAlignment.bottom;
  final List<String?> dataLabelPosition = List<String?>.filled(5, null);
  dataLabelPosition[0] = 'DataLabelPosition.Outer';
  dataLabelPosition[1] = 'DataLabelPosition.Top';
  dataLabelPosition[2] = 'DataLabelPosition.Bottom';
  dataLabelPosition[3] = 'DataLabelPosition.Middle';
  dataLabelPosition[4] = 'DataLabelPosition.Auto';
  positionIndex = dataLabelPosition.indexOf(position.toString()).toInt();
  while (isOverLap && positionIndex < 4) {
    yLocation = _calculatePathPosition(
        point.y.toDouble(),
        position,
        size,
        borderWidth,
        seriesRendererDetails,
        index,
        inverted,
        point,
        stateProperties,
        currentPoint,
        Size(
            series.markerSettings.width / 2, series.markerSettings.height / 2));
    labelRect = _calculateLabelRect(
        ChartLocation(point.x, yLocation),
        size,
        series.dataLabelSettings.margin,
        series.dataLabelSettings.color != null ||
            series.dataLabelSettings.useSeriesColor);
    isOverLap = labelRect.top < 0 ||
        ((labelRect.top + labelRect.height) >
            stateProperties.chartAxis.axisClipRect.height) ||
        findingCollision(labelRect, stateProperties.renderDatalabelRegions);
    positionIndex = isBottom ? positionIndex - 1 : positionIndex + 1;
    isBottom = false;
  }
  return yLocation;
}

/// Finding the label position for non rect series.
ChartDataLabelAlignment _getActualPathDataLabelAlignment(
    SeriesRendererDetails seriesRendererDetails, int index, bool inversed) {
  final List<CartesianChartPoint<dynamic>> points =
      seriesRendererDetails.dataPoints;
  final num yValue = points[index].yValue;
  final CartesianChartPoint<dynamic>? nextPoint =
      points.length - 1 > index ? points[index + 1] : null;
  final CartesianChartPoint<dynamic>? previousPoint =
      index > 0 ? points[index - 1] : null;
  ChartDataLabelAlignment position;
  if (seriesRendererDetails.seriesType == 'bubble' ||
      index == points.length - 1) {
    position = ChartDataLabelAlignment.top;
  } else {
    if (index == 0) {
      position = (!nextPoint!.isVisible ||
              yValue > nextPoint.yValue ||
              (yValue < nextPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (index == points.length - 1) {
      position = (!previousPoint!.isVisible ||
              yValue > previousPoint.yValue ||
              (yValue < previousPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else {
      if (!nextPoint!.isVisible && !previousPoint!.isVisible) {
        position = ChartDataLabelAlignment.top;
      } else if (!nextPoint.isVisible) {
        position = ((nextPoint.yValue > yValue) == true ||
                (previousPoint!.yValue > yValue) == true)
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else {
        final num slope = (nextPoint.yValue - previousPoint!.yValue) / 2;
        final num intersectY =
            (slope * index) + (nextPoint.yValue - (slope * (index + 1)));
        position = !inversed
            ? intersectY < yValue
                ? ChartDataLabelAlignment.top
                : ChartDataLabelAlignment.bottom
            : intersectY < yValue
                ? ChartDataLabelAlignment.bottom
                : ChartDataLabelAlignment.top;
      }
    }
  }
  return position;
}

/// To get the data label position.
ChartDataLabelAlignment _getPosition(int position) {
  late ChartDataLabelAlignment dataLabelPosition;
  switch (position) {
    case 0:
      dataLabelPosition = ChartDataLabelAlignment.outer;
      break;
    case 1:
      dataLabelPosition = ChartDataLabelAlignment.top;
      break;
    case 2:
      dataLabelPosition = ChartDataLabelAlignment.bottom;
      break;
    case 3:
      dataLabelPosition = ChartDataLabelAlignment.middle;
      break;
    case 4:
      dataLabelPosition = ChartDataLabelAlignment.auto;
      break;
  }
  return dataLabelPosition;
}

/// Getting label rect.
Rect _calculateLabelRect(
    ChartLocation location, Size textSize, EdgeInsets margin, bool needRect) {
  return needRect
      ? Rect.fromLTWH(
          location.x - (textSize.width / 2) - margin.left,
          location.y - (textSize.height / 2) - margin.top,
          textSize.width + margin.left + margin.right,
          textSize.height + margin.top + margin.bottom)
      : Rect.fromLTWH(location.x - (textSize.width / 2),
          location.y - (textSize.height / 2), textSize.width, textSize.height);
}

bool _isCustomTextColor(TextStyle? textStyle, TextStyle? themeStyle) {
  return textStyle?.color != null || themeStyle?.color != null;
}

/// Below method is for rendering data label.
void drawDataLabel(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    int index,
    Animation<double> dataLabelAnimation,
    DataLabelSettingsRenderer dataLabelSettingsRenderer) {
  double x = 0;
  double y = 0;
  if (dataLabelSettingsRenderer.offset != null) {
    x = dataLabelSettingsRenderer.offset!.dx;
    y = dataLabelSettingsRenderer.offset!.dy;
  }
  final double opacity =
      seriesRendererDetails.needAnimateSeriesElements == true &&
              // ignore: unnecessary_null_comparison
              dataLabelAnimation != null
          ? dataLabelAnimation.value
          : 1;
  final String? label = point.label;
  final TextStyle dataLabelStyle = dataLabelSettingsRenderer.textStyle!;

  if (label != null &&
      // ignore: unnecessary_null_comparison
      point != null &&
      point.isVisible &&
      point.isGap != true &&
      isLabelWithinRange(seriesRendererDetails, point)) {
    final Color fontColor = dataLabelSettingsRenderer.isCustomTextColor
        ? dataLabelStyle.color!
        : getDataLabelSaturationColor(point, seriesRendererDetails,
            stateProperties, dataLabelSettingsRenderer);
    final Rect labelRect = (point.labelFillRect != null)
        ? Rect.fromLTWH(point.labelFillRect!.left, point.labelFillRect!.top,
            point.labelFillRect!.width, point.labelFillRect!.height)
        : Rect.fromLTWH(point.labelLocation!.x, point.labelLocation!.y,
            point.dataLabelRegion!.width, point.dataLabelRegion!.height);
    final bool isDatalabelCollide = (stateProperties.requireInvertedAxis ||
            (dataLabelSettingsRenderer.angle / 90) % 2 != 1) &&
        findingCollision(labelRect, stateProperties.renderDatalabelRegions);
    if (!(label.isNotEmpty && isDatalabelCollide) ||
        // ignore: unnecessary_null_comparison
        dataLabel.labelIntersectAction == null) {
      final TextStyle textStyle = dataLabelStyle.copyWith(
        color: fontColor.withOpacity(opacity),
      );
      _drawDataLabelRectAndText(
          canvas,
          seriesRendererDetails,
          index,
          dataLabel,
          point,
          textStyle,
          opacity,
          label,
          x,
          y,
          stateProperties,
          stateProperties.chart);
      stateProperties.renderDatalabelRegions.add(labelRect);
    }
  }
}

/// Method to trigger the data label event.
void triggerDataLabelEvent(SfCartesianChart chart,
    List<CartesianSeriesRenderer> visibleSeriesRenderer, Offset position) {
  SeriesRendererDetails seriesRendererDetails;
  for (int seriesIndex = 0;
      seriesIndex < visibleSeriesRenderer.length;
      seriesIndex++) {
    final CartesianSeriesRenderer seriesRenderer =
        visibleSeriesRenderer[seriesIndex];
    seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final List<CartesianChartPoint<dynamic>>? dataPoints =
        seriesRendererDetails.visibleDataPoints;
    late CartesianChartPoint<dynamic> currentPoint;
    ChartLocation? dataLabelLocation;
    final String seriesType = seriesRendererDetails.seriesType;
    for (int pointIndex = 0; pointIndex < dataPoints!.length; pointIndex++) {
      currentPoint = dataPoints[pointIndex];
      dataLabelLocation = (currentPoint.dataLabelRegion != null &&
              currentPoint.dataLabelRegion!.contains(position))
          ? currentPoint.labelLocation
          : (currentPoint.dataLabelRegion2 != null &&
                  currentPoint.dataLabelRegion2!.contains(position))
              ? currentPoint.labelLocation2
              : (seriesType == 'hiloopenclose' ||
                          seriesType == 'candle' ||
                          seriesType == 'boxandwhisker') &&
                      (currentPoint.dataLabelRegion3 != null &&
                          currentPoint.dataLabelRegion3!.contains(position))
                  ? currentPoint.labelLocation3
                  : (seriesType == 'hiloopenclose' ||
                              seriesType == 'candle' ||
                              seriesType == 'boxandwhisker') &&
                          (currentPoint.dataLabelRegion4 != null &&
                              currentPoint.dataLabelRegion4!.contains(position))
                      ? currentPoint.labelLocation4
                      : (seriesRendererDetails.seriesType == 'boxandwhisker' &&
                              currentPoint.dataLabelRegion5 != null &&
                              currentPoint.dataLabelRegion5!.contains(position))
                          ? currentPoint.labelLocation5
                          : null;
      if (seriesRendererDetails.series.dataLabelSettings.isVisible == true &&
          dataLabelLocation != null) {
        final Offset position =
            Offset(dataLabelLocation.x, dataLabelLocation.y);
        dataLabelTapEvent(chart, seriesRendererDetails.series.dataLabelSettings,
            pointIndex, currentPoint, position, seriesIndex);
        break;
      }
    }
  }
}

/// Draw the data label text and data label rect.
void _drawDataLabelRectAndText(
    Canvas canvas,
    SeriesRendererDetails seriesRendererDetails,
    int index,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    TextStyle textStyle,
    double opacity,
    String label,
    double x,
    double y,
    CartesianStateProperties stateProperties,
    [SfCartesianChart? chart]) {
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRendererDetails.dataLabelSettingsRenderer;
  final String? label2 = point.dataLabelMapper ?? point.label2;
  final String? label3 = point.dataLabelMapper ?? point.label3;
  final String? label4 = point.dataLabelMapper ?? point.label4;
  final String? label5 = point.dataLabelMapper ?? point.label5;
  final bool isRangeSeries =
      seriesRendererDetails.seriesType.contains('range') == true ||
          seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType.contains('candle') == true;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  double padding = 0.0;
  // ignore: unnecessary_null_comparison
  if (dataLabelSettingsRenderer.angle != null &&
      dataLabelSettingsRenderer.angle > 0) {
    final Rect rect = rotatedTextSize(
        Size(point.dataLabelRegion!.width, point.dataLabelRegion!.height),
        dataLabelSettingsRenderer.angle);
    if (stateProperties.chartAxis.axisClipRect.top >
        point.dataLabelRegion!.center.dy + rect.top) {
      padding = (point.dataLabelRegion!.center.dy + rect.top) -
          stateProperties.chartAxis.axisClipRect.top;
    } else if (stateProperties.chartAxis.axisClipRect.bottom <
        point.dataLabelRegion!.center.dy + rect.bottom) {
      padding = (point.dataLabelRegion!.center.dy + rect.bottom) -
          stateProperties.chartAxis.axisClipRect.bottom;
    }
  }
  if (dataLabelSettingsRenderer.color != null ||
      dataLabel.useSeriesColor ||
      // ignore: unnecessary_null_comparison
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect = point.labelFillRect!;
    final Path path = Path();
    path.addRRect(fillRect);
    final RRect? fillRect2 = point.labelFillRect2;
    final Path path2 = Path();
    if (isRangeSeries || isBoxSeries) {
      path2.addRRect(fillRect2!);
    }
    final RRect? fillRect3 = point.labelFillRect3;
    final Path path3 = Path();
    final RRect? fillRect4 = point.labelFillRect4;
    final Path path4 = Path();
    final RRect? fillRect5 = point.labelFillRect5;
    final Path path5 = Path();
    if (seriesRendererDetails.seriesType.contains('hilo') == true ||
        seriesRendererDetails.seriesType.contains('candle') == true ||
        isBoxSeries) {
      path3.addRRect(fillRect3!);
      path4.addRRect(fillRect4!);
      if (isBoxSeries) {
        path5.addRRect(fillRect5!);
      }
    }
    // ignore: unnecessary_null_comparison
    if (dataLabel.borderColor != null && dataLabel.borderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = dataLabel.borderColor.withOpacity(
            (opacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : opacity - (1 - dataLabel.opacity))
        ..strokeWidth = dataLabel.borderWidth
        ..style = PaintingStyle.stroke;
      dataLabel.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color = strokePaint.color;
      canvas.save();
      canvas.translate(point.dataLabelRegion!.center.dx + x,
          point.dataLabelRegion!.center.dy - padding);
      // ignore: unnecessary_null_comparison
      if (dataLabelSettingsRenderer.angle != null &&
          dataLabelSettingsRenderer.angle > 0) {
        canvas.rotate((dataLabelSettingsRenderer.angle * math.pi) / 180);
      }
      canvas.translate(-point.dataLabelRegion!.center.dx,
          -point.dataLabelRegion!.center.dy - y);
      if (point.label!.isNotEmpty) {
        canvas.drawPath(path, strokePaint);
      }
      canvas.restore();
      if (isRangeSeries || isBoxSeries) {
        if (point.label2!.isNotEmpty) {
          canvas.drawPath(path2, strokePaint);
        }
        if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
            seriesRendererDetails.seriesType.contains('candle') == true ||
            isBoxSeries) {
          if (point.label3!.isNotEmpty) {
            canvas.drawPath(path3, strokePaint);
          }
          if (point.label4!.isNotEmpty) {
            canvas.drawPath(path4, strokePaint);
          }
        }
        if (isBoxSeries) {
          if (point.label5!.isNotEmpty) {
            canvas.drawPath(path5, strokePaint);
          }
        }
      }
    }
    if (dataLabelSettingsRenderer.color != null || dataLabel.useSeriesColor) {
      Color? seriesColor = seriesRendererDetails.seriesColor!;
      if (seriesRendererDetails.seriesType == 'waterfall') {
        seriesColor = getWaterfallSeriesColor(
            seriesRendererDetails.series as WaterfallSeries<dynamic, dynamic>,
            point,
            seriesColor);
      }
      final Paint paint = Paint()
        ..color = dataLabelSettingsRenderer.color != Colors.transparent
            ? ((dataLabelSettingsRenderer.color ??
                    (point.pointColorMapper ?? seriesColor!))
                .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : opacity - (1 - dataLabel.opacity)))
            : Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(point.dataLabelRegion!.center.dx + x,
          point.dataLabelRegion!.center.dy - padding);
      // ignore: unnecessary_null_comparison
      if (dataLabelSettingsRenderer.angle != null &&
          dataLabelSettingsRenderer.angle > 0) {
        canvas.rotate((dataLabelSettingsRenderer.angle * math.pi) / 180);
      }
      canvas.translate(-point.dataLabelRegion!.center.dx,
          -point.dataLabelRegion!.center.dy - y);
      if (point.label!.isNotEmpty) {
        canvas.drawPath(path, paint);
      }
      canvas.restore();
      if (isRangeSeries || isBoxSeries) {
        if (point.label2!.isNotEmpty) {
          canvas.drawPath(path2, paint);
        }
        if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
            seriesRendererDetails.seriesType.contains('candle') == true ||
            isBoxSeries) {
          if (point.label3!.isNotEmpty) {
            canvas.drawPath(path3, paint);
          }
          if (point.label4!.isNotEmpty) {
            canvas.drawPath(path4, paint);
          }
        }
        if (isBoxSeries) {
          if (point.label5!.isNotEmpty) {
            canvas.drawPath(path5, paint);
          }
        }
      }
    }
  }

  seriesRendererDetails.renderer.drawDataLabel(
      index,
      canvas,
      label,
      dataLabelSettingsRenderer.angle != 0
          ? point.dataLabelRegion!.center.dx + x
          : point.labelLocation!.x + x,
      dataLabelSettingsRenderer.angle != 0
          ? point.dataLabelRegion!.center.dy - y - padding
          : point.labelLocation!.y - y,
      dataLabelSettingsRenderer.angle,
      textStyle);

  if (isRangeSeries || isBoxSeries) {
    if (withInRange(isBoxSeries ? point.minimum : point.low,
        seriesRendererDetails.yAxisDetails!)) {
      seriesRendererDetails.renderer.drawDataLabel(
          index,
          canvas,
          label2!,
          point.labelLocation2!.x + x,
          point.labelLocation2!.y - y,
          dataLabelSettingsRenderer.angle,
          textStyle);
    }
    if (seriesRendererDetails.seriesType == 'hiloopenclose' &&
        (label3 != null &&
                label4 != null &&
                (point.labelLocation3!.y - point.labelLocation4!.y).round() >=
                    8 ||
            (point.labelLocation4!.x - point.labelLocation3!.x).round() >=
                15)) {
      seriesRendererDetails.renderer.drawDataLabel(
          index,
          canvas,
          label3!,
          point.labelLocation3!.x + x,
          point.labelLocation3!.y + y,
          dataLabelSettingsRenderer.angle,
          textStyle);
      seriesRendererDetails.renderer.drawDataLabel(
          index,
          canvas,
          label4!,
          point.labelLocation4!.x + x,
          point.labelLocation3!.y + y,
          dataLabelSettingsRenderer.angle,
          textStyle);
    } else if (label3 != null &&
        label4 != null &&
        ((point.labelLocation3!.y - point.labelLocation4!.y).round() >= 8 ||
            (point.labelLocation4!.x - point.labelLocation3!.x).round() >=
                15)) {
      final Color fontColor =
          getOpenCloseDataLabelColor(point, seriesRendererDetails, chart!);
      final TextStyle textStyleOpenClose = TextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: textStyle.fontSize,
          fontFamily: textStyle.fontFamily,
          fontStyle: textStyle.fontStyle,
          fontWeight: textStyle.fontWeight,
          inherit: textStyle.inherit,
          backgroundColor: textStyle.backgroundColor,
          letterSpacing: textStyle.letterSpacing,
          wordSpacing: textStyle.wordSpacing,
          textBaseline: textStyle.textBaseline,
          height: textStyle.height,
          locale: textStyle.locale,
          foreground: textStyle.foreground,
          background: textStyle.background,
          shadows: textStyle.shadows,
          fontFeatures: textStyle.fontFeatures,
          decoration: textStyle.decoration,
          decorationColor: textStyle.decorationColor,
          decorationStyle: textStyle.decorationStyle,
          decorationThickness: textStyle.decorationThickness,
          debugLabel: textStyle.debugLabel,
          fontFamilyFallback: textStyle.fontFamilyFallback);
      if ((point.labelLocation2!.y - point.labelLocation3!.y).abs() >= 8 ||
          (point.labelLocation2!.x - point.labelLocation3!.x).abs() >= 8) {
        seriesRendererDetails.renderer.drawDataLabel(
            index,
            canvas,
            label3,
            point.labelLocation3!.x + x,
            point.labelLocation3!.y + y,
            dataLabelSettingsRenderer.angle,
            textStyleOpenClose);
      }
      if ((point.labelLocation!.y - point.labelLocation4!.y).abs() >= 8 ||
          (point.labelLocation!.x - point.labelLocation4!.x).abs() >= 8) {
        seriesRendererDetails.renderer.drawDataLabel(
            index,
            canvas,
            label4,
            point.labelLocation4!.x + x,
            point.labelLocation4!.y + y,
            dataLabelSettingsRenderer.angle,
            textStyleOpenClose);
      }
      if (label5 != null && point.labelLocation5 != null) {
        seriesRendererDetails.renderer.drawDataLabel(
            index,
            canvas,
            label5,
            point.labelLocation5!.x + x,
            point.labelLocation5!.y + y,
            dataLabelSettingsRenderer.angle,
            textStyleOpenClose);
      }

      if (isBoxSeries) {
        if (point.outliers!.isNotEmpty) {
          final List<ChartLocation> outliersLocation = <ChartLocation>[];
          final List<Size> outliersTextSize = <Size>[];
          final List<Rect> outliersRect = <Rect>[];
          const int outlierPadding = 12;
          for (int outlierIndex = 0;
              outlierIndex < point.outliers!.length;
              outlierIndex++) {
            point.outliersLabel.add(point.dataLabelMapper ??
                _getLabelText(
                    point.outliers![outlierIndex], seriesRendererDetails));
            outliersTextSize.add(measureText(
                point.outliersLabel[outlierIndex],
                dataLabelSettingsRenderer.textStyle == null
                    ? const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 12)
                    : dataLabelSettingsRenderer.originalStyle!));
            outliersLocation.add(ChartLocation(
                point.outliersPoint[outlierIndex].x,
                point.outliersPoint[outlierIndex].y + outlierPadding));
            // ignore: unnecessary_null_comparison
            if (outliersLocation[outlierIndex] != null) {
              outliersRect.add(_calculateLabelRect(
                  outliersLocation[outlierIndex],
                  outliersTextSize[outlierIndex],
                  dataLabel.margin,
                  dataLabelSettingsRenderer.color != null ||
                      dataLabel.useSeriesColor));
              outliersRect[outlierIndex] = _validateRect(
                  outliersRect[outlierIndex],
                  calculatePlotOffset(
                      stateProperties.chartAxis.axisClipRect,
                      Offset(
                          seriesRendererDetails.xAxisDetails!.axis.plotOffset,
                          seriesRendererDetails
                              .yAxisDetails!.axis.plotOffset)));
            }
            if (dataLabelSettingsRenderer.color != null ||
                dataLabel.useSeriesColor ||
                // ignore: unnecessary_null_comparison
                (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
              // ignore: unnecessary_null_comparison
              if (outliersRect[outlierIndex] != null) {
                final RRect outliersFillRect = _calculatePaddedFillRect(
                    outliersRect[outlierIndex],
                    dataLabel.borderRadius,
                    dataLabel.margin);
                if (dataLabel.margin == EdgeInsets.zero) {
                  point.outliersFillRect.add(outliersFillRect);
                } else {
                  final Rect outliersRect = outliersFillRect.middleRect;
                  point.outliersLocation.add(ChartLocation(
                      outliersRect.left +
                          outliersRect.width / 2 -
                          outliersTextSize[outlierIndex].width / 2,
                      outliersRect.top +
                          outliersRect.height / 2 -
                          outliersTextSize[outlierIndex].height / 2));
                  point.outliersDataLabelRegion.add(Rect.fromLTWH(
                      point.outliersLocation[outlierIndex].x,
                      point.outliersLocation[outlierIndex].y,
                      outliersTextSize[outlierIndex].width,
                      outliersTextSize[outlierIndex].height));
                  point.outliersFillRect
                      .add(_rectToRrect(outliersRect, dataLabel.borderRadius));
                }
                final RRect fillOutlierRect =
                    point.outliersFillRect[outlierIndex];
                final Path outlierPath = Path();
                outlierPath.addRRect(fillOutlierRect);
                final Paint paint = Paint()
                  ..color = (dataLabelSettingsRenderer.color ??
                          (point.pointColorMapper ??
                              seriesRendererDetails.seriesColor!))
                      .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                          ? 0
                          : opacity - (1 - dataLabel.opacity))
                  ..style = PaintingStyle.fill;
                canvas.drawPath(outlierPath, paint);
                final Paint strokePaint = Paint()
                  ..color = dataLabel.borderColor.withOpacity(
                      (opacity - (1 - dataLabel.opacity)) < 0
                          ? 0
                          : opacity - (1 - dataLabel.opacity))
                  ..strokeWidth = dataLabel.borderWidth
                  ..style = PaintingStyle.stroke;
                dataLabel.borderWidth == 0
                    ? strokePaint.color = Colors.transparent
                    : strokePaint.color = strokePaint.color;
                canvas.drawPath(outlierPath, strokePaint);
              }
            } else {
              // ignore: unnecessary_null_comparison
              if (outliersRect[outlierIndex] != null) {
                point.outliersLocation.add(ChartLocation(
                    outliersRect[outlierIndex].left +
                        outliersRect[outlierIndex].width / 2 -
                        outliersTextSize[outlierIndex].width / 2,
                    outliersRect[outlierIndex].top +
                        outliersRect[outlierIndex].height / 2 -
                        outliersTextSize[outlierIndex].height / 2));
                point.outliersDataLabelRegion.add(Rect.fromLTWH(
                    point.outliersLocation[outlierIndex].x,
                    point.outliersLocation[outlierIndex].y,
                    outliersTextSize[outlierIndex].width,
                    outliersTextSize[outlierIndex].height));
              }
            }
            final String outlierLabel =
                point.dataLabelMapper ?? point.outliersLabel[outlierIndex];
            seriesRendererDetails.renderer.drawDataLabel(
                index,
                canvas,
                outlierLabel,
                point.outliersLocation[outlierIndex].x + x,
                point.outliersLocation[outlierIndex].y + y,
                dataLabelSettingsRenderer.angle,
                textStyle);
          }
        }
      }
    }
  }
}

/// Following method returns the data label text.
String _getLabelText(
    dynamic labelValue, SeriesRendererDetails seriesRendererDetails) {
  if (labelValue.toString().split('.').length > 1) {
    final String str = labelValue.toString();
    final List<String> list = str.split('.');
    labelValue = double.parse(labelValue.toStringAsFixed(6));
    if (list[1] == '0' ||
        list[1] == '00' ||
        list[1] == '000' ||
        list[1] == '0000' ||
        list[1] == '00000' ||
        list[1] == '000000') {
      labelValue = labelValue.round();
    }
  }
  final dynamic yAxis = seriesRendererDetails.yAxisDetails!.axis;
  if (yAxis is NumericAxis || yAxis is LogarithmicAxis) {
    final dynamic value = yAxis?.numberFormat != null
        ? yAxis.numberFormat.format(labelValue)
        : labelValue;
    return ((yAxis.labelFormat != null && yAxis.labelFormat != '')
        ? yAxis.labelFormat.replaceAll(RegExp('{value}'), value.toString())
        : value.toString()) as String;
  } else {
    return labelValue.toString();
  }
}

/// Calculating rect position for dataLabel.
double _calculateRectPosition(
    double labelLocation,
    Rect rect,
    bool isMinus,
    ChartDataLabelAlignment position,
    SeriesRendererDetails seriesRendererDetails,
    Size textSize,
    double borderWidth,
    int index,
    ChartLocation point,
    CartesianStateProperties stateProperties,
    bool inverted,
    EdgeInsets margin) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  double padding;
  padding = seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType.contains('candle') == true ||
          seriesRendererDetails.seriesType.contains('rangecolumn') == true ||
          seriesRendererDetails.seriesType.contains('boxandwhisker') == true
      ? 2
      : 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final double textLength = !inverted ? textSize.height : textSize.width;
  final double extraSpace =
      borderWidth + textLength / 2 + padding + (needFill ? padding : 0);
  if (seriesRendererDetails.seriesType.contains('stack') == true) {
    position = position == ChartDataLabelAlignment.outer
        ? ChartDataLabelAlignment.top
        : position;
  }

  /// Locating the data label based on position.
  switch (position) {
    case ChartDataLabelAlignment.bottom:
      labelLocation = !inverted
          ? (isMinus
              ? (labelLocation - rect.height + extraSpace)
              : (labelLocation + rect.height - extraSpace))
          : (isMinus
              ? (labelLocation + rect.width - extraSpace)
              : (labelLocation - rect.width + extraSpace));
      break;
    case ChartDataLabelAlignment.middle:
      labelLocation = !inverted
          ? (isMinus
              ? labelLocation - (rect.height / 2)
              : labelLocation + (rect.height / 2))
          : (isMinus
              ? labelLocation + (rect.width / 2)
              : labelLocation - (rect.width / 2));
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculateRectActualPosition(
          labelLocation,
          rect,
          isMinus,
          seriesRendererDetails,
          textSize,
          index,
          point,
          inverted,
          borderWidth,
          stateProperties,
          margin);
      break;
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = _calculateTopAndOuterPosition(
          textSize,
          labelLocation,
          rect,
          position,
          seriesRendererDetails,
          index,
          extraSpace,
          isMinus,
          point,
          inverted,
          borderWidth);
      break;
  }
  return labelLocation;
}

/// Calculating the label location if position is given as auto.
double _calculateRectActualPosition(
    double labelLocation,
    Rect rect,
    bool minus,
    SeriesRendererDetails seriesRendererDetails,
    Size textSize,
    int index,
    ChartLocation point,
    bool inverted,
    double borderWidth,
    CartesianStateProperties stateProperties,
    EdgeInsets margin) {
  late double location;
  Rect labelRect;
  bool isOverLap = true;
  int position = 0;
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  final int finalPosition =
      seriesRendererDetails.seriesType.contains('range') == true ? 2 : 4;
  while (isOverLap && position < finalPosition) {
    location = _calculateRectPosition(
        labelLocation,
        rect,
        minus,
        _getPosition(position),
        seriesRendererDetails,
        textSize,
        borderWidth,
        index,
        point,
        stateProperties,
        inverted,
        margin);
    if (!inverted) {
      labelRect = _calculateLabelRect(
          ChartLocation(point.x, location),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.top < 0 ||
          labelRect.top > stateProperties.chartAxis.axisClipRect.height ||
          ((series.dataLabelSettings.angle / 90) % 2 != 1 &&
              findingCollision(
                  labelRect, stateProperties.renderDatalabelRegions));
    } else {
      labelRect = _calculateLabelRect(
          ChartLocation(location, point.y),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.left < 0 ||
          labelRect.left + labelRect.width >
              stateProperties.chartAxis.axisClipRect.right ||
          (series.dataLabelSettings.angle % 180 != 0 &&
              findingCollision(
                  labelRect, stateProperties.renderDatalabelRegions));
    }
    final List<CartesianChartPoint<dynamic>> dataPoints =
        getSampledData(seriesRendererDetails);
    dataPoints[index].dataLabelSaturationRegionInside =
        isOverLap || dataPoints[index].dataLabelSaturationRegionInside == true;
    position++;
  }
  return location;
}

/// Calculation for top and outer position of data label for rect series.
double _calculateTopAndOuterPosition(
    Size textSize,
    double location,
    Rect rect,
    ChartDataLabelAlignment position,
    SeriesRendererDetails seriesRendererDetails,
    int index,
    double extraSpace,
    bool isMinus,
    ChartLocation point,
    bool inverted,
    double borderWidth) {
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  final num markerHeight =
      series.markerSettings.isVisible ? series.markerSettings.height / 2 : 0;
  if (((isMinus &&
              seriesRendererDetails.seriesType.contains('range') == false) &&
          position == ChartDataLabelAlignment.top) ||
      ((!isMinus ||
              seriesRendererDetails.seriesType.contains('range') == true) &&
          position == ChartDataLabelAlignment.outer)) {
    location = !inverted
        ? location - extraSpace - markerHeight
        : location + extraSpace + markerHeight;
  } else {
    location = !inverted
        ? location + extraSpace + markerHeight
        : location - extraSpace - markerHeight;
  }
  return location;
}

/// Add padding for fill rect (if data label fill color is given).
RRect _calculatePaddedFillRect(Rect rect, double radius, EdgeInsets margin) {
  rect = Rect.fromLTRB(rect.left - margin.left, rect.top - margin.top,
      rect.right + margin.right, rect.bottom + margin.bottom);

  return _rectToRrect(rect, radius);
}

/// Converting rect into rounded rect.
RRect _rectToRrect(Rect rect, double radius) => RRect.fromRectAndCorners(rect,
    topLeft: Radius.elliptical(radius, radius),
    topRight: Radius.elliptical(radius, radius),
    bottomLeft: Radius.elliptical(radius, radius),
    bottomRight: Radius.elliptical(radius, radius));

/// Checking the condition whether data Label has been exist in the clip rect.
Rect _validateRect(Rect rect, Rect clipRect) {
  /// please don't add padding here
  double left, top;
  left = rect.left < clipRect.left ? clipRect.left : rect.left;
  top = double.parse(rect.top.toStringAsFixed(2)) < clipRect.top
      ? clipRect.top
      : rect.top;
  left -= ((double.parse(left.toStringAsFixed(2)) + rect.width) >
          clipRect.right)
      ? (double.parse(left.toStringAsFixed(2)) + rect.width) - clipRect.right
      : 0;
  top -= (double.parse(top.toStringAsFixed(2)) + rect.height) > clipRect.bottom
      ? (double.parse(top.toStringAsFixed(2)) + rect.height) - clipRect.bottom
      : 0;
  left = left < clipRect.left ? clipRect.left : left;
  rect = Rect.fromLTWH(left, top, rect.width, rect.height);
  return rect;
}

/// It returns a boolean value that labels within range or not.
bool isLabelWithinRange(SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point) {
  bool isWithInRange = true;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  if (seriesRendererDetails.yAxisDetails is! LogarithmicAxisDetails) {
    isWithInRange = withInRange(
            point.xValue, seriesRendererDetails.xAxisDetails!) &&
        (seriesRendererDetails.seriesType.contains('range') ||
                seriesRendererDetails.seriesType == 'hilo'
            ? (isBoxSeries && point.minimum != null && point.maximum != null) ||
                (!isBoxSeries && point.low != null && point.high != null) &&
                    (withInRange(isBoxSeries ? point.minimum : point.low,
                            seriesRendererDetails.yAxisDetails!) ||
                        withInRange(isBoxSeries ? point.maximum : point.high,
                            seriesRendererDetails.yAxisDetails!))
            : seriesRendererDetails.seriesType == 'hiloopenclose' ||
                    seriesRendererDetails.seriesType.contains('candle') ||
                    isBoxSeries
                ? (withInRange(isBoxSeries ? point.minimum : point.low,
                        seriesRendererDetails.yAxisDetails!) &&
                    withInRange(isBoxSeries ? point.maximum : point.high,
                        seriesRendererDetails.yAxisDetails!) &&
                    withInRange(isBoxSeries ? point.lowerQuartile : point.open,
                        seriesRendererDetails.yAxisDetails!) &&
                    withInRange(isBoxSeries ? point.upperQuartile : point.close,
                        seriesRendererDetails.yAxisDetails!))
                : withInRange(
                    seriesRendererDetails.seriesType.contains('100')
                        ? point.cumulativeValue
                        : seriesRendererDetails.seriesType == 'waterfall'
                            ? point.endValue ?? 0
                            : point.yValue,
                    seriesRendererDetails.yAxisDetails!));
  }
  return isWithInRange;
}

/// Calculating data label position and updating the label region for current data point.
void calculateDataLabelPosition(
    SeriesRendererDetails seriesRendererDetails,
    CartesianChartPoint<dynamic> point,
    int index,
    CartesianStateProperties stateProperties,
    DataLabelSettingsRenderer dataLabelSettingsRenderer,
    Animation<double> dataLabelAnimation,
    [Size? templateSize,
    Offset? templateLocation]) {
  final SfCartesianChart chart = stateProperties.chart;
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  if (dataLabelSettingsRenderer.angle.isNegative) {
    final int angle = dataLabelSettingsRenderer.angle + 360;
    dataLabelSettingsRenderer.angle = angle;
  }
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  Size? textSize, textSize2, textSize3, textSize4, textSize5;
  double? value1, value2;
  const int boxPlotPadding = 8;
  final Rect rect = calculatePlotOffset(
      stateProperties.chartAxis.axisClipRect,
      Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
          seriesRendererDetails.yAxisDetails!.axis.plotOffset));
  if (seriesRendererDetails.seriesType.contains('hilo') == true ||
      seriesRendererDetails.seriesType.contains('candle') == true) {
    value1 = ((point.open != null &&
                point.close != null &&
                (point.close < point.open) == true)
            ? point.close
            : point.open)
        ?.toDouble();
    value2 = ((point.open != null &&
                point.close != null &&
                (point.close > point.open) == true)
            ? point.close
            : point.open)
        ?.toDouble();
  }
  final bool transposed = stateProperties.requireInvertedAxis;
  final bool inversed = seriesRendererDetails.yAxisDetails!.axis.isInversed;
  final Rect clipRect = calculatePlotOffset(
      stateProperties.chartAxis.axisClipRect,
      Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
          seriesRendererDetails.yAxisDetails!.axis.plotOffset));
  final bool isRangeSeries =
      seriesRendererDetails.seriesType.contains('range') == true ||
          seriesRendererDetails.seriesType.contains('hilo') == true ||
          seriesRendererDetails.seriesType.contains('candle') == true;
  final bool isBoxSeries =
      seriesRendererDetails.seriesType.contains('boxandwhisker');
  if (isBoxSeries) {
    value1 = (point.upperQuartile != null &&
            point.lowerQuartile != null &&
            point.upperQuartile! < point.lowerQuartile!)
        ? point.upperQuartile!
        : point.lowerQuartile!;
    value2 = (point.upperQuartile != null &&
            point.lowerQuartile != null &&
            point.upperQuartile! > point.lowerQuartile!)
        ? point.upperQuartile!
        : point.lowerQuartile!;
  }
  // ignore: prefer_final_locals
  List<String> labelList = <String>[];
  // ignore: prefer_final_locals
  String label = point.dataLabelMapper ??
      point.label ??
      _getLabelText(
          isRangeSeries
              ? (!inversed ? point.high : point.low)
              : isBoxSeries
                  ? (!inversed ? point.maximum : point.minimum)
                  : ((dataLabel.showCumulativeValues &&
                          point.cumulativeValue != null)
                      ? point.cumulativeValue
                      : point.yValue),
          seriesRendererDetails);
  if (isRangeSeries) {
    point.label2 = point.dataLabelMapper ??
        point.label2 ??
        _getLabelText(
            !inversed ? point.low : point.high, seriesRendererDetails);
    if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
        seriesRendererDetails.seriesType.contains('candle') == true) {
      point.label3 = point.dataLabelMapper ??
          point.label3 ??
          _getLabelText(
              (point.open > point.close) == true
                  ? !inversed
                      ? point.close
                      : point.open
                  : !inversed
                      ? point.open
                      : point.close,
              seriesRendererDetails);
      point.label4 = point.dataLabelMapper ??
          point.label4 ??
          _getLabelText(
              (point.open > point.close) == true
                  ? !inversed
                      ? point.open
                      : point.close
                  : !inversed
                      ? point.close
                      : point.open,
              seriesRendererDetails);
    }
  } else if (isBoxSeries) {
    point.label2 = point.dataLabelMapper ??
        point.label2 ??
        _getLabelText(
            !inversed ? point.minimum : point.maximum, seriesRendererDetails);
    point.label3 = point.dataLabelMapper ??
        point.label3 ??
        _getLabelText(
            point.lowerQuartile! > point.upperQuartile!
                ? !inversed
                    ? point.upperQuartile
                    : point.lowerQuartile
                : !inversed
                    ? point.lowerQuartile
                    : point.upperQuartile,
            seriesRendererDetails);
    point.label4 = point.dataLabelMapper ??
        point.label4 ??
        _getLabelText(
            point.lowerQuartile! > point.upperQuartile!
                ? !inversed
                    ? point.lowerQuartile
                    : point.upperQuartile
                : !inversed
                    ? point.upperQuartile
                    : point.lowerQuartile,
            seriesRendererDetails);
    point.label5 = point.dataLabelMapper ??
        point.label5 ??
        _getLabelText(point.median, seriesRendererDetails);
  }
  DataLabelRenderArgs dataLabelArgs;
  TextStyle? dataLabelStyle = dataLabelSettingsRenderer.textStyle;
  //ignore: prefer_conditional_assignment
  if (dataLabelSettingsRenderer.originalStyle == null) {
    dataLabelSettingsRenderer.originalStyle = stateProperties
        .renderingDetails.themeData.textTheme.bodySmall!
        .merge(stateProperties.renderingDetails.chartTheme.dataLabelTextStyle)
        .merge(dataLabel.textStyle);
  }
  dataLabelStyle = dataLabelSettingsRenderer.originalStyle;
  final bool isCustomTextColor = _isCustomTextColor(dataLabel.textStyle,
      stateProperties.renderingDetails.chartTheme.dataLabelTextStyle);
  if (chart.onDataLabelRender == null) {
    dataLabelSettingsRenderer.isCustomTextColor = isCustomTextColor;
    CartesianPointHelper.setCustomTextColor(
        point, dataLabelSettingsRenderer.isCustomTextColor);
  }
  dataLabelStyle = dataLabelStyle!.copyWith(
      color: isCustomTextColor
          ? dataLabelStyle.color
          : getDataLabelSaturationColor(point, seriesRendererDetails,
              stateProperties, dataLabelSettingsRenderer));
  TextStyle? textStyle = dataLabelStyle.copyWith();

  if (chart.onDataLabelRender != null &&
      seriesRendererDetails.visibleDataPoints![index].labelRenderEvent ==
          false) {
    labelList.add(label);
    if (isRangeSeries) {
      labelList.add(point.label2!);
      if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
          seriesRendererDetails.seriesType.contains('candle') == true) {
        labelList.add(point.label3!);
        labelList.add(point.label4!);
      }
    } else if (isBoxSeries) {
      labelList.add(point.label2!);
      labelList.add(point.label3!);
      labelList.add(point.label4!);
      labelList.add(point.label5!);
    }
    seriesRendererDetails.visibleDataPoints![index].labelRenderEvent = true;
    for (int i = 0; i < labelList.length; i++) {
      dataLabelArgs = DataLabelRenderArgs(
          seriesRendererDetails.series,
          seriesRendererDetails.dataPoints,
          index,
          seriesRendererDetails
              .visibleDataPoints![index].overallDataPointIndex);
      dataLabelArgs.text = labelList[i];
      dataLabelSettingsRenderer.isCustomTextColor = false;
      final bool isSaturationColor = !isCustomTextColor;
      textStyle = dataLabelStyle.copyWith(
          color: (isSaturationColor
              ? getDataLabelSaturationColor(point, seriesRendererDetails,
                  stateProperties, dataLabelSettingsRenderer)
              : dataLabelStyle.color));
      dataLabelArgs.textStyle = textStyle.copyWith();
      dataLabelArgs.color =
          seriesRendererDetails.series.dataLabelSettings.color;
      chart.onDataLabelRender!(dataLabelArgs);
      labelList[i] = dataLabelArgs.text;
      index = dataLabelArgs.viewportPointIndex!;

      final bool backgroundColorChanged =
          seriesRendererDetails.series.dataLabelSettings.color !=
              dataLabelArgs.color;
      dataLabelSettingsRenderer.color = dataLabelArgs.color;
      CartesianPointHelper.setDataLabelColor(point, dataLabelArgs.color);

      final bool argsTextColorChanged =
          textStyle.color != dataLabelArgs.textStyle?.color;
      if (backgroundColorChanged) {
        if (argsTextColorChanged) {
          dataLabelSettingsRenderer.isCustomTextColor = true;
        } else {
          if (isSaturationColor) {
            textStyle = textStyle.copyWith(
                color: getDataLabelSaturationColor(point, seriesRendererDetails,
                    stateProperties, dataLabelSettingsRenderer));
          } else {
            dataLabelSettingsRenderer.isCustomTextColor = true;
          }
        }
      } else {
        if (argsTextColorChanged) {
          dataLabelSettingsRenderer.isCustomTextColor = true;
        } else {
          dataLabelSettingsRenderer.isCustomTextColor = isSaturationColor;
        }
      }
      textStyle = textStyle.merge(dataLabelArgs.textStyle);
      dataLabelSettingsRenderer.textStyle = textStyle;
      CartesianPointHelper.setDataLabelTextStyle(point, textStyle);
      CartesianPointHelper.setCustomTextColor(
          point, dataLabelSettingsRenderer.isCustomTextColor);
      dataLabelSettingsRenderer.offset = dataLabelArgs.offset;
    }
  }
  dataLabelSettingsRenderer.textStyle = textStyle;
  if (chart.onDataLabelRender != null) {
    dataLabelSettingsRenderer.color =
        CartesianPointHelper.getDataLabelColor(point);
    dataLabelSettingsRenderer.textStyle =
        CartesianPointHelper.getDataLabelTextStyle(point);
    textStyle = dataLabelSettingsRenderer.textStyle;
    dataLabelSettingsRenderer.isCustomTextColor =
        CartesianPointHelper.getCustomTextColor(point);
  }
  // ignore: unnecessary_null_comparison
  if (point != null &&
      point.isVisible &&
      point.isGap != true &&
      (point.y != 0 || dataLabel.showZeroValue)) {
    final double markerPointX =
        (seriesRendererDetails.seriesType.contains('hilo') == true ||
                seriesRendererDetails.seriesType == 'candle' ||
                isBoxSeries)
            ? seriesRendererDetails.stateProperties.requireInvertedAxis == true
                ? point.region!.centerRight.dx
                : point.region!.topCenter.dx
            : point.markerPoint!.x;
    final double markerPointY =
        seriesRendererDetails.seriesType.contains('hilo') == true ||
                seriesRendererDetails.seriesType == 'candle' ||
                isBoxSeries
            ? seriesRendererDetails.stateProperties.requireInvertedAxis == true
                ? point.region!.centerRight.dy
                : point.region!.topCenter.dy
            : point.markerPoint!.y;
    final ChartLocation markerPoint2 = calculatePoint(
        point.xValue,
        seriesRendererDetails.yAxisDetails!.axis.isInversed == true
            ? value2
            : value1,
        seriesRendererDetails.xAxisDetails!,
        seriesRendererDetails.yAxisDetails!,
        stateProperties.requireInvertedAxis,
        series,
        rect);
    final ChartLocation markerPoint3 = calculatePoint(
        point.xValue,
        seriesRendererDetails.yAxisDetails!.axis.isInversed == true
            ? value1
            : value2,
        seriesRendererDetails.xAxisDetails!,
        seriesRendererDetails.yAxisDetails!,
        stateProperties.requireInvertedAxis,
        series,
        rect);
    final TextStyle font = dataLabelSettingsRenderer.textStyle ?? textStyle!;
    point.label = labelList.isNotEmpty ? labelList[0] : label;
    if (point.label != null) {
      ChartLocation? chartLocation,
          chartLocation2,
          chartLocation3,
          chartLocation4,
          chartLocation5;
      textSize = dataLabel.builder == null
          ? measureText(point.label!, font)
          : templateSize!;
      chartLocation = ChartLocation(markerPointX, markerPointY);
      if (isRangeSeries || isBoxSeries) {
        point.label2 = labelList.isNotEmpty ? labelList[1] : point.label2;
        textSize2 = dataLabel.builder == null
            ? measureText(point.label2!, font)
            : templateSize!;
        chartLocation2 = ChartLocation(
            seriesRendererDetails.seriesType.contains('hilo') == true ||
                    seriesRendererDetails.seriesType == 'candle' ||
                    isBoxSeries
                ? seriesRendererDetails.stateProperties.requireInvertedAxis ==
                        true
                    ? point.region!.centerLeft.dx
                    : point.region!.bottomCenter.dx
                : point.markerPoint2!.x,
            seriesRendererDetails.seriesType.contains('hilo') == true ||
                    seriesRendererDetails.seriesType == 'candle' ||
                    isBoxSeries
                ? seriesRendererDetails.stateProperties.requireInvertedAxis ==
                        true
                    ? point.region!.centerLeft.dy
                    : point.region!.bottomCenter.dy
                : point.markerPoint2!.y);
        if (isBoxSeries) {
          if (seriesRendererDetails.stateProperties.requireInvertedAxis ==
              false) {
            chartLocation.y = chartLocation.y - boxPlotPadding;
            chartLocation2.y = chartLocation2.y + boxPlotPadding;
          } else {
            chartLocation.x = chartLocation.x + boxPlotPadding;
            chartLocation2.x = chartLocation2.x - boxPlotPadding;
          }
        }
      }
      final List<ChartLocation?> alignedLabelLocations =
          _getAlignedLabelLocations(stateProperties, seriesRendererDetails,
              point, dataLabel, chartLocation, chartLocation2, textSize);
      chartLocation = alignedLabelLocations[0];
      chartLocation2 = alignedLabelLocations[1];
      if (seriesRendererDetails.seriesType.contains('column') == false &&
          seriesRendererDetails.seriesType.contains('waterfall') == false &&
          seriesRendererDetails.seriesType.contains('bar') == false &&
          seriesRendererDetails.seriesType.contains('histogram') == false &&
          seriesRendererDetails.seriesType.contains('rangearea') == false &&
          seriesRendererDetails.seriesType.contains('hilo') == false &&
          seriesRendererDetails.seriesType.contains('candle') == false &&
          !isBoxSeries) {
        chartLocation!.y = _calculatePathPosition(
            chartLocation.y,
            dataLabel.labelAlignment,
            textSize,
            dataLabel.borderWidth,
            seriesRendererDetails,
            index,
            transposed,
            chartLocation,
            stateProperties,
            point,
            Size(
                series.markerSettings.isVisible
                    ? series.markerSettings.width / 2
                    : 0,
                series.markerSettings.isVisible
                    ? series.markerSettings.height / 2
                    : 0));
      } else {
        final List<ChartLocation?> locations = _getLabelLocations(
            index,
            stateProperties,
            seriesRendererDetails,
            point,
            dataLabel,
            chartLocation,
            chartLocation2,
            textSize,
            textSize2);
        chartLocation = locations[0];
        chartLocation2 = locations[1];
      }
      if (seriesRendererDetails.seriesType == 'hiloopenclose' ||
          seriesRendererDetails.seriesType.contains('candle') == true ||
          isBoxSeries) {
        if (!isBoxSeries) {
          point.label3 = labelList.isNotEmpty ? labelList[2] : point.label3;
          point.label4 = labelList.isNotEmpty ? labelList[3] : point.label4;
          // point.label3 = point.dataLabelMapper ??
          //     _getLabelText(
          //         (point.open > point.close) == true
          //             ? !inversed
          //                 ? point.close
          //                 : point.open
          //             : !inversed
          //                 ? point.open
          //                 : point.close,
          //         seriesRenderer);
          // point.label4 = point.dataLabelMapper ??
          //     _getLabelText(
          //         (point.open > point.close) == true
          //             ? !inversed
          //                 ? point.open
          //                 : point.close
          //             : !inversed
          //                 ? point.close
          //                 : point.open,
          //         seriesRenderer);
        } else {
          point.label3 = labelList.isNotEmpty ? labelList[2] : point.label3;
          point.label4 = labelList.isNotEmpty ? labelList[3] : point.label4;
          point.label5 = labelList.isNotEmpty ? labelList[4] : point.label5;
          // point.label3 = point.dataLabelMapper ??
          //     _getLabelText(
          //         point.lowerQuartile! > point.upperQuartile!
          //             ? !inversed
          //                 ? point.upperQuartile
          //                 : point.lowerQuartile
          //             : !inversed
          //                 ? point.lowerQuartile
          //                 : point.upperQuartile,
          //         seriesRenderer);
          // point.label4 = point.dataLabelMapper ??
          //     _getLabelText(
          //         point.lowerQuartile! > point.upperQuartile!
          //             ? !inversed
          //                 ? point.lowerQuartile
          //                 : point.upperQuartile
          //             : !inversed
          //                 ? point.upperQuartile
          //                 : point.lowerQuartile,
          //         seriesRenderer);
          // point.label5 = point.dataLabelMapper ??
          //     _getLabelText(point.median, seriesRenderer);
        }
        textSize3 = dataLabel.builder == null
            ? measureText(point.label3!, font)
            : templateSize;
        if (seriesRendererDetails.seriesType.contains('hilo') == true) {
          chartLocation3 = (point.open > point.close) == true
              ? ChartLocation(point.centerClosePoint!.x + textSize3!.width,
                  point.closePoint!.y)
              : ChartLocation(point.centerOpenPoint!.x - textSize3!.width,
                  point.openPoint!.y);
        } else if (seriesRendererDetails.seriesType == 'candle' &&
            seriesRendererDetails.stateProperties.requireInvertedAxis == true) {
          chartLocation3 = (point.open > point.close) == true
              ? ChartLocation(point.closePoint!.x, markerPoint2.y + 1)
              : ChartLocation(point.openPoint!.x, markerPoint2.y + 1);
        } else if (isBoxSeries) {
          chartLocation3 = (seriesRendererDetails
                      .stateProperties.requireInvertedAxis ==
                  true)
              ? ChartLocation(point.lowerQuartilePoint!.x + boxPlotPadding,
                  markerPoint2.y + 1)
              : ChartLocation(
                  point.region!.topCenter.dx, markerPoint2.y - boxPlotPadding);
        } else {
          chartLocation3 =
              ChartLocation(point.region!.topCenter.dx, markerPoint2.y);
        }
        textSize4 = dataLabel.builder == null
            ? measureText(point.label4!, font)
            : templateSize;
        if (seriesRendererDetails.seriesType.contains('hilo') == true) {
          chartLocation4 = (point.open > point.close) == true
              ? ChartLocation(point.centerOpenPoint!.x - textSize4!.width,
                  point.openPoint!.y)
              : ChartLocation(point.centerClosePoint!.x + textSize4!.width,
                  point.closePoint!.y);
        } else if (seriesRendererDetails.seriesType == 'candle' &&
            seriesRendererDetails.stateProperties.requireInvertedAxis == true) {
          chartLocation4 = (point.open > point.close) == true
              ? ChartLocation(point.openPoint!.x, markerPoint3.y + 1)
              : ChartLocation(point.closePoint!.x, markerPoint3.y + 1);
        } else if (isBoxSeries) {
          chartLocation4 =
              (seriesRendererDetails.stateProperties.requireInvertedAxis ==
                      true)
                  ? ChartLocation(point.upperQuartilePoint!.x - boxPlotPadding,
                      markerPoint3.y + 1)
                  : ChartLocation(point.region!.bottomCenter.dx,
                      markerPoint3.y + boxPlotPadding);
        } else {
          chartLocation4 =
              ChartLocation(point.region!.bottomCenter.dx, markerPoint3.y + 1);
        }
        if (isBoxSeries) {
          textSize5 = measureText(point.label5!, font);
          chartLocation5 =
              (seriesRendererDetails.stateProperties.requireInvertedAxis ==
                      false)
                  ? ChartLocation(
                      point.centerMedianPoint!.x, point.centerMedianPoint!.y)
                  : ChartLocation(
                      point.centerMedianPoint!.x, point.centerMedianPoint!.y);
        }
        final List<ChartLocation?> alignedLabelLocations2 =
            _getAlignedLabelLocations(stateProperties, seriesRendererDetails,
                point, dataLabel, chartLocation3, chartLocation4, textSize3!);
        chartLocation3 = alignedLabelLocations2[0];
        chartLocation4 = alignedLabelLocations2[1];
        final List<ChartLocation?> locations = _getLabelLocations(
            index,
            stateProperties,
            seriesRendererDetails,
            point,
            dataLabel,
            chartLocation3,
            chartLocation4,
            textSize3,
            textSize4!);
        chartLocation3 = locations[0];
        chartLocation4 = locations[1];
      }
      _calculateDataLabelRegion(
          point,
          dataLabel,
          stateProperties,
          chartLocation!,
          chartLocation2,
          isRangeSeries,
          clipRect,
          textSize,
          textSize2,
          chartLocation3,
          chartLocation4,
          chartLocation5,
          textSize3,
          textSize4,
          textSize5,
          seriesRendererDetails,
          index);
    }
  }
}
