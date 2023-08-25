import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/event_args.dart' show ErrorBarValues;
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/data_label.dart';
import '../common/marker.dart';
import '../trendlines/trendlines.dart';

/// Renders the xy series.
///
/// Cartesian charts uses two axis namely x and y, to render.
abstract class XyDataSeries<T, D> extends CartesianSeries<T, D> {
  /// Creating an argument constructor of XyDataSeries class.
  XyDataSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader,
      ChartValueMapper<T, D>? xValueMapper,
      ChartValueMapper<T, dynamic>? yValueMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? name,
      required List<T> dataSource,
      String? xAxisName,
      String? yAxisName,
      ChartValueMapper<T, Color>? pointColorMapper,
      String? legendItemText,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      ChartValueMapper<T, num>? sizeValueMapper,
      ChartValueMapper<T, num>? highValueMapper,
      ChartValueMapper<T, num>? lowValueMapper,
      ChartValueMapper<T, bool>? intermediateSumPredicate,
      ChartValueMapper<T, bool>? totalSumPredicate,
      List<Trendline>? trendlines,
      double? width,
      MarkerSettings? markerSettings,
      bool? isVisible,
      bool? enableTooltip,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      double? animationDuration,
      List<double>? dashArray,
      Color? borderColor,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      double? opacity,
      double? animationDelay,
      Color? color,
      List<int>? initialSelectedDataIndexes,
      SortingOrder? sortingOrder})
      : super(
            key: key,
            onRendererCreated: onRendererCreated,
            onCreateRenderer: onCreateRenderer,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            isVisible: isVisible,
            legendItemText: legendItemText,
            xAxisName: xAxisName,
            dashArray: dashArray,
            isVisibleInLegend: isVisibleInLegend,
            borderColor: borderColor,
            trendlines: trendlines,
            borderWidth: borderWidth,
            yAxisName: yAxisName,
            color: color,
            name: name,
            width: width,
            xValueMapper: xValueMapper != null
                ? (int index) => xValueMapper(dataSource[index], index)
                : null,
            yValueMapper: yValueMapper != null
                ? (int index) => yValueMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource[index], index)
                : null,
            pointColorMapper: pointColorMapper != null
                ? (int index) => pointColorMapper(dataSource[index], index)
                : null,
            dataLabelMapper: dataLabelMapper != null
                ? (int index) => dataLabelMapper(dataSource[index], index)
                : null,
            sizeValueMapper: sizeValueMapper != null
                ? (int index) => sizeValueMapper(dataSource[index], index)
                : null,
            highValueMapper: highValueMapper != null
                ? (int index) => highValueMapper(dataSource[index], index)
                : null,
            lowValueMapper: lowValueMapper != null
                ? (int index) => lowValueMapper(dataSource[index], index)
                : null,
            intermediateSumPredicate: intermediateSumPredicate != null
                ? (int index) =>
                    intermediateSumPredicate(dataSource[index], index)
                : null,
            totalSumPredicate: totalSumPredicate != null
                ? (int index) => totalSumPredicate(dataSource[index], index)
                : null,
            dataSource: dataSource,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionBehavior: selectionBehavior,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader,
            gradient: gradient,
            borderGradient: borderGradient,
            markerSettings: markerSettings,
            initialSelectedDataIndexes: initialSelectedDataIndexes);
}

/// This class has the properties of [CartesianChartPoint].
///
/// Chart point is a class that is used to store the current x and y values from the datasource.
/// Contains x and y coordinates which are converted from the x and y values.
///
class CartesianChartPoint<D> {
  /// Creating an argument constructor of CartesianChartPoint class.
  CartesianChartPoint(
      [this.x,
      this.y,
      this.dataLabelMapper,
      this.pointColorMapper,
      this.bubbleSize,
      this.high,
      this.low,
      this.open,
      this.close,
      this.volume,
      this.sortValue,
      this.minimum,
      this.maximum,
      this.isIntermediateSum,
      this.isTotalSum,
      this.maxYValue = 0,
      this.outliers,
      this.upperQuartile,
      this.lowerQuartile,
      this.mean,
      this.median,
      this.originValue,
      this.endValue]) {
    x = x;
    y = y;
    sortValue = sortValue;
    markerPoint = markerPoint;
    isEmpty = isEmpty;
    isGap = isGap;
    isVisible = isVisible;
    bubbleSize = bubbleSize;
    pointColorMapper = pointColorMapper;
    dataLabelMapper = dataLabelMapper;
    high = high;
    low = low;
    open = open;
    close = close;
    markerPoint2 = markerPoint2;
    volume = volume;
    minimum = minimum;
    maximum = maximum;
    outliers = outliers;
    upperQuartile = upperQuartile;
    lowerQuartile = lowerQuartile;
    mean = mean;
    median = median;
    isIntermediateSum = isIntermediateSum;
    isTotalSum = isTotalSum;
    originValue = originValue;
    endValue = endValue;
    maxYValue = maxYValue;
  }

  /// X value of the point.
  D? x;

  /// Y value of the point.
  D? y;

  /// Stores the xValues of the point.
  D? xValue;

  /// Stores the yValues of the point.
  D? yValue;

  /// Sort value of the point.
  D? sortValue;

  /// High value of the point.
  D? high;

  /// Low value of the point.
  D? low;

  /// Open value of the point.
  D? open;

  /// Close value of the point.
  D? close;

  /// Volume value of the point.
  num? volume;

  /// Marker point location.
  ChartLocation? markerPoint;

  /// Second marker point location.
  ChartLocation? markerPoint2;

  /// Size of the bubble.
  num? bubbleSize;

  /// To set empty value.
  bool? isEmpty;

  /// To set gap value.
  bool isGap = false;

  /// To set the drop value.
  bool isDrop = false;

  /// To check marker event is triggered.
  bool _isMarkerEventTriggered = false;

  /// To store the marker color when callback is triggered.
  MarkerDetails? _markerDetails;

  /// Sets the visibility of the series.
  bool isVisible = true;

  /// Used to map the color value from data points.
  Color? pointColorMapper;

  /// Maps the data label value from data points.
  String? dataLabelMapper;

  /// Stores the region rect.
  Rect? region;

  /// Stores the region of box series rect.
  Rect? boxRectRegion;

  /// Store the outliers region.
  List<Rect>? outlierRegion;

  /// Store the outliers region.
  List<dynamic>? outlierRegionPosition;

  /// Minimum value of box plot series.
  num? minimum;

  /// Maximum value of box plot series.
  num? maximum;

  /// Outlier values of box plot series.
  List<num>? outliers = <num>[];

  /// Upper quartile value of box plot series.
  double? upperQuartile;

  /// Lower quartile value of box plot series.
  double? lowerQuartile;

  /// Average value of the given data source in box plot series.
  num? mean;

  /// Median value of the given data source in box plot series.
  num? median;

  /// The intermediate sum value of the waterfall series.
  bool? isIntermediateSum;

  /// The total sum value of the waterfall series.
  bool? isTotalSum;

  /// The end value of each data point in the waterfall series.
  num? endValue;

  /// The Origin value of each data point in waterfall series.
  num? originValue;

  /// To find the maximum Y value in the waterfall series.
  num maxYValue;

  /// To execute OnDataLabelRender event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;

  /// To execute onTooltipRender event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// Stores the chart location.
  ChartLocation? openPoint,
      closePoint,
      centerOpenPoint,
      centerClosePoint,
      lowPoint,
      highPoint,
      centerLowPoint,
      centerHighPoint,
      currentPoint,
      startControl,
      endControl,
      highStartControl,
      highEndControl,
      lowStartControl,
      lowEndControl,
      minimumPoint,
      maximumPoint,
      lowerQuartilePoint,
      upperQuartilePoint,
      centerMinimumPoint,
      centerMaximumPoint,
      medianPoint,
      centerMedianPoint,
      centerMeanPoint,
      originValueLeftPoint,
      originValueRightPoint,
      endValueLeftPoint,
      endValueRightPoint,
      horizontalPositiveErrorPoint,
      horizontalNegativeErrorPoint,
      verticalPositiveErrorPoint,
      verticalNegativeErrorPoint;

  /// Stores the error values in all directions
  ErrorBarValues? errorBarValues;

  /// Stores the outliers location.
  List<ChartLocation> outliersPoint = <ChartLocation>[];

  /// Control points for spline series.
  List<Offset>? controlPoint;

  /// Control points for spline range area series.
  List<Offset>? controlPointshigh;

  /// Control points for spline range area series.
  List<Offset>? controlPointslow;

  /// Stores the list of regions.
  List<Rect>? regions;

  /// Stores the cumulative value.
  double? cumulativeValue;

  /// Stores the tracker rect region.
  Rect? trackerRectRegion;

  /// Stores the y-value/high value data label text.
  String? label;

  /// Stores the data label text of low value.
  String? label2;

  /// Stores the data label text of close value.
  String? label3;

  /// Stores the data label text of open value.
  String? label4;

  /// Stores the median data label text.
  String? label5;

  /// Stores the outliers data label text.
  List<String> outliersLabel = <String>[];

  /// Stores the yValue/high value data label Rect.
  RRect? labelFillRect;

  /// Stores the data label text of low value Rect.
  RRect? labelFillRect2;

  /// Stores the data label text of close value Rect.
  RRect? labelFillRect3;

  /// Stores the data label text of open value Rect.
  RRect? labelFillRect4;

  /// Stores the median data label Rect.
  RRect? labelFillRect5;

  /// Stores the outliers data label Rect.
  List<RRect> outliersFillRect = <RRect>[];

  /// Stores the data label location.
  ChartLocation? labelLocation;

  /// Stores the second data label location.
  ChartLocation? labelLocation2;

  /// Stores the third data label location.
  ChartLocation? labelLocation3;

  /// Stores the fourth data label location.
  ChartLocation? labelLocation4;

  /// Stores the median data label location.
  ChartLocation? labelLocation5;

  /// Stores the outliers data label location.
  List<ChartLocation> outliersLocation = <ChartLocation>[];

  /// Data label region saturation.
  bool dataLabelSaturationRegionInside = false;

  /// Stores the data label region.
  Rect? dataLabelRegion;

  /// Stores the second data label region.
  Rect? dataLabelRegion2;

  /// Stores the third data label region.
  Rect? dataLabelRegion3;

  /// Stores the forth data label region.
  Rect? dataLabelRegion4;

  /// Stores the median data label region.
  Rect? dataLabelRegion5;

  /// Stores the outliers data label region.
  List<Rect> outliersDataLabelRegion = <Rect>[];

  /// Stores the data point index.
  int? index;

  /// Stores the data index.
  int? overallDataPointIndex;

  /// Stores the region data of the data point.
  List<String>? regionData;

  /// Stores the visible point index.
  int? visiblePointIndex;

  TextStyle? _dataLabelTextStyle;

  Color? _dataLabelColor;

  bool _isCustomTextColor = false;
}

// ignore: avoid_classes_with_only_static_members
/// Helper class for Cartesian chart point.
class CartesianPointHelper {
  /// Returns the datalabel text style for a given point.
  static TextStyle? getDataLabelTextStyle(CartesianChartPoint<dynamic> point) {
    return point._dataLabelTextStyle;
  }

  /// Sets the datalabel text style in a given point.
  static void setDataLabelTextStyle(
      CartesianChartPoint<dynamic> point, TextStyle? style) {
    point._dataLabelTextStyle = style;
  }

  /// Returns the datalabel color for a given point.
  static Color? getDataLabelColor(CartesianChartPoint<dynamic> point) {
    return point._dataLabelColor;
  }

  /// Sets the datalabel color in a given point.
  static void setDataLabelColor(
      CartesianChartPoint<dynamic> point, Color? color) {
    point._dataLabelColor = color;
  }

  /// Returns the custom color is true or not for a given point.
  static bool getCustomTextColor(CartesianChartPoint<dynamic> point) {
    return point._isCustomTextColor;
  }

  /// Sets the custom color is true or not in a given point.
  static void setCustomTextColor(
      CartesianChartPoint<dynamic> point, bool isCustomTextColor) {
    point._isCustomTextColor = isCustomTextColor;
  }

  /// Returns the marker event triggered flag for a given point.
  static bool getIsMarkerEventTriggered(CartesianChartPoint<dynamic> point) {
    return point._isMarkerEventTriggered;
  }

  /// Sets the marker event triggered flag for a given point.
  static void setIsMarkerEventTriggered(
      CartesianChartPoint<dynamic> point, bool isMarkerEventTriggered) {
    point._isMarkerEventTriggered = isMarkerEventTriggered;
  }

  /// Returns the MarkerDetails for a given point.
  static MarkerDetails? getMarkerDetails(CartesianChartPoint<dynamic> point) {
    return point._markerDetails;
  }

  /// Sets the MarkerDetails for a given point.
  static void setMarkerDetails(
      CartesianChartPoint<dynamic> point, MarkerDetails? details) {
    point._markerDetails = details;
  }
}

/// Represents the chart location.
class ChartLocation {
  /// Creates an instance of chart location.
  ChartLocation(this.x, this.y);

  /// Specifies the value of x.
  double x;

  /// Specifies the value of y.
  double y;
}

/// Creates series renderer for xy data series.
abstract class XyDataSeriesRenderer extends CartesianSeriesRenderer {
  /// To calculate empty point value for the specific mode.
  @override
  void calculateEmptyPointValue(
      int pointIndex, CartesianChartPoint<dynamic> currentPoint,
      [CartesianSeriesRenderer? seriesRenderer]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer!);
    final int pointLength = seriesRendererDetails.dataPoints.length - 1;
    final String seriesType = seriesRendererDetails.seriesType;
    final CartesianChartPoint<dynamic> prevPoint =
        seriesRendererDetails.dataPoints[
            seriesRendererDetails.dataPoints.length >= 2 == true
                ? pointLength - 1
                : pointLength];
    if (seriesType.contains('range') ||
            seriesType.contains('hilo') ||
            seriesType == 'candle'
        ? seriesType == 'hiloopenclose' || seriesType == 'candle'
            ? (currentPoint.low == null ||
                currentPoint.high == null ||
                currentPoint.open == null ||
                currentPoint.close == null)
            : (currentPoint.low == null || currentPoint.high == null)
        : currentPoint.y == null) {
      switch (seriesRendererDetails.series.emptyPointSettings.mode) {
        case EmptyPointMode.zero:
          currentPoint.isEmpty = true;
          if (seriesType.contains('range') ||
              seriesType.contains('hilo') ||
              seriesType.contains('candle')) {
            currentPoint.high = 0;
            currentPoint.low = 0;
            if (seriesType == 'hiloopenclose' || seriesType == 'candle') {
              currentPoint.open = 0;
              currentPoint.close = 0;
            }
          } else {
            currentPoint.y = 0;
          }
          break;

        case EmptyPointMode.average:
          if (seriesRenderer is XyDataSeriesRenderer) {
            seriesRendererDetails.calculateAverageModeValue(
                pointIndex, pointLength, currentPoint, prevPoint);
          }
          currentPoint.isEmpty = true;
          break;

        case EmptyPointMode.gap:
          if (seriesType == 'scatter' ||
              seriesType == 'column' ||
              seriesType == 'bar' ||
              seriesType == 'bubble' ||
              seriesType == 'splinearea' ||
              seriesType == 'rangecolumn' ||
              seriesType.contains('hilo') ||
              seriesType.contains('candle') ||
              seriesType == 'rangearea' ||
              seriesType.contains('stacked')) {
            currentPoint.y = pointIndex != 0 &&
                    (!seriesType.contains('stackedcolumn') &&
                        !seriesType.contains('stackedbar'))
                ? prevPoint.y ?? 0
                : 0;
            currentPoint.open = currentPoint.open ?? 0;
            currentPoint.close = currentPoint.close ?? 0;
            currentPoint.isVisible = false;
          } else if (seriesType.contains('line') ||
              seriesType == 'area' ||
              seriesType == 'steparea') {
            if (seriesType == 'splinerangearea') {
              // ignore: prefer_if_null_operators
              currentPoint.low = currentPoint.low == null
                  ? pointIndex != 0
                      ? prevPoint.low ?? 0
                      : 0
                  : currentPoint.low;
              // ignore: prefer_if_null_operators
              currentPoint.high = currentPoint.high == null
                  ? pointIndex != 0
                      ? prevPoint.high ?? 0
                      : 0
                  : currentPoint.high;
            } else {
              currentPoint.y = pointIndex != 0 ? prevPoint.y ?? 0 : 0;
            }
          }
          currentPoint.isVisible = false;
          currentPoint.isGap = true;
          break;
        case EmptyPointMode.drop:
          if (seriesType == 'splinerangearea') {
            // ignore: prefer_if_null_operators
            currentPoint.low = currentPoint.low == null
                ? pointIndex != 0
                    ? prevPoint.low ?? 0
                    : 0
                : currentPoint.low;
            // ignore: prefer_if_null_operators
            currentPoint.high = currentPoint.high == null
                ? pointIndex != 0
                    ? prevPoint.high ?? 0
                    : 0
                : currentPoint.high;
          }
          currentPoint.y = pointIndex != 0 &&
                  (seriesType != 'area' &&
                      seriesType != 'splinearea' &&
                      seriesType != 'splinerangearea' &&
                      seriesType != 'steparea' &&
                      !seriesType.contains('stackedcolumn') &&
                      !seriesType.contains('stackedbar'))
              ? prevPoint.y ?? 0
              : 0;
          currentPoint.isDrop = true;
          currentPoint.isVisible = false;
          break;
        // ignore: no_default_cases
        default:
          currentPoint.y = 0;
          break;
      }
    }
  }
}
