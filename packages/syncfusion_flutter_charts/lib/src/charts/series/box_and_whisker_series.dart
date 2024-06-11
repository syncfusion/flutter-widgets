import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/element_widget.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../trendline/trendline.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class holds the properties of the box and whisker series.
///
/// To render a box and whisker chart, create an instance of
/// [BoxAndWhiskerSeries], and add it to the `series` collection property
///  of [SfCartesianChart].
/// The box and whisker chart represents the hollow rectangle with the
/// lower quartile, upper quartile, maximum and minimum value in the given data.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
@immutable
class BoxAndWhiskerSeries<T, D> extends CartesianSeries<T, D> {
  /// Creating an argument constructor of BoxAndWhiskerSeries class.
  const BoxAndWhiskerSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required this.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    this.width = 0.7,
    this.spacing = 0.0,
    super.markerSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.animationDuration,
    this.borderColor,
    super.borderWidth = 1.0,
    super.gradient,
    super.borderGradient,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.dashArray,
    super.opacity,
    super.animationDelay,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.trendlines,
    this.boxPlotMode = BoxPlotMode.normal,
    this.showMean = true,
  });

  final ChartValueMapper<T, List<num?>>? yValueMapper;

  /// To change the box plot rendering mode.
  ///
  /// The box plot series rendering mode can be changed by
  /// using [BoxPlotMode] property. The below values are applicable for this,
  ///
  /// * `BoxPlotMode.normal` - The quartile values are calculated by splitting
  /// the list and by getting the median values.
  /// * `BoxPlotMode.exclusive` - The quartile values are calculated by using
  /// the formula (N+1) * P (N count, P percentile), and their index value
  /// starts from 1 in the list.
  /// * `BoxPlotMode.inclusive` - The quartile values are calculated by using
  /// the formula (N−1) * P (N count, P percentile), and their index value
  /// starts from 0 in the list.
  ///
  /// Also refer [BoxPlotMode].
  ///
  /// Defaults to `BoxPlotMode.normal`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         boxPlotMode: BoxPlotMode.normal
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BoxPlotMode boxPlotMode;

  /// Indication for mean value in box plot.
  ///
  /// If [showMean] property value is set to true, a cross symbol will be
  /// displayed at the mean value, for each data point in box plot. Else,
  /// it will not be displayed.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         showMean: false
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showMean;

  /// Spacing between the box plots.
  ///
  /// The value ranges from 0 to 1, where 1 represents 100% and 0 represents 0%
  /// of the available space.
  ///
  /// Spacing affects the width of the box plots. For example, setting 20%
  /// spacing and 100% width renders the box plots with 80% of total width.
  ///
  /// Also refer [CartesianSeries.width].
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  final double width;

  final Color? borderColor;

  @override
  Widget? childForSlot(SeriesSlot slot) {
    if (dataSource == null) {
      return null;
    }
    switch (slot) {
      case SeriesSlot.dataLabel:
        return dataLabelSettings.isVisible
            ? CartesianDataLabelContainer<T, D>(
                series: this,
                dataSource: dataSource!,
                mapper: dataLabelMapper,
                builder: dataLabelSettings.builder,
                settings: dataLabelSettings,
                positions: positions,
              )
            : null;

      case SeriesSlot.marker:
        // TODO(VijayakumarM): Check bang operator.
        return MarkerContainer<T, D>(
          series: this,
          dataSource: dataSource!,
          settings: markerSettings.copyWith(isVisible: true),
        );

      case SeriesSlot.trendline:
        return trendlines != null
            ? TrendlineContainer(trendlines: trendlines!)
            : null;
    }
  }

  @override
  List<ChartDataPointType> get positions => <ChartDataPointType>[
        ChartDataPointType.high,
        ChartDataPointType.low,
        ChartDataPointType.open,
        ChartDataPointType.close,
        ChartDataPointType.median,
        ChartDataPointType.outliers,
      ];

  /// Create the Box and Whisker series renderer.
  @override
  BoxAndWhiskerSeriesRenderer<T, D> createRenderer() {
    BoxAndWhiskerSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(this) as BoxAndWhiskerSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return BoxAndWhiskerSeriesRenderer<T, D>();
  }

  @override
  BoxAndWhiskerSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final BoxAndWhiskerSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as BoxAndWhiskerSeriesRenderer<T, D>;
    renderer
      ..yValueMapper = yValueMapper
      ..boxPlotMode = boxPlotMode
      ..showMean = showMean
      ..spacing = spacing
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, BoxAndWhiskerSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..yValueMapper = yValueMapper
      ..boxPlotMode = boxPlotMode
      ..showMean = showMean
      ..spacing = spacing
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for box and whisker series.
class BoxAndWhiskerSeriesRenderer<T, D>
    extends BoxAndWhiskerSeriesRendererBase<T, D>
    with SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of [BoxAndWhiskerSeriesRenderer] class.
  BoxAndWhiskerSeriesRenderer();

  final List<num> minimumValues = <num>[];
  final List<num> maximumValues = <num>[];
  final List<num> upperValues = <num>[];
  final List<num> lowerValues = <num>[];

  final List<num> medianValues = <num>[];
  final List<num> meanValues = <num>[];
  final List<List<num>> outliersValues = <List<num>>[];

  @override
  set color(Color? value) {
    markerSettings =
        markerSettings.copyWith(borderColor: value ?? paletteColor);
    super.color = value;
  }

  @override
  set paletteColor(Color value) {
    markerSettings = markerSettings.copyWith(borderColor: color ?? value);
    super.paletteColor = value;
  }

  bool get showMean => _showMean;
  bool _showMean = true;
  set showMean(bool value) {
    if (_showMean != value) {
      _showMean = value;
    }
  }

  BoxPlotMode get boxPlotMode => _boxPlotMode;
  BoxPlotMode _boxPlotMode = BoxPlotMode.normal;
  set boxPlotMode(BoxPlotMode value) {
    if (_boxPlotMode != value) {
      _boxPlotMode = value;
    }
  }

  Color? get borderColor => _borderColor;
  Color? _borderColor = Colors.transparent;
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  @override
  set markerSettings(MarkerSettings value) {
    super.markerSettings = value.copyWith(isVisible: true);
  }

  @override
  double legendIconBorderWidth() {
    return 2;
  }

  void _resetDataSourceHolders() {
    minimumValues.clear();
    maximumValues.clear();
    upperValues.clear();
    lowerValues.clear();
    medianValues.clear();
    meanValues.clear();
    outliersValues.clear();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataSourceHolders();
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    populateChartPoints();
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    outliersValues.clear();
    super.updateDataPoints(
      removedIndexes,
      addedIndexes,
      replacedIndexes,
      yPaths,
      chaoticYLists,
      yLists,
      fPaths,
      chaoticFLists,
      fLists,
    );
  }

  @override
  num trackballYValue(int index) => maximumValues[index];

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    chartPoints.clear();
    if (parent == null || yLists == null || yLists.isEmpty) {
      return;
    }

    if (parent!.onDataLabelRender == null &&
        parent!.onTooltipRender == null &&
        dataLabelSettings.builder == null) {
      return;
    }

    yLists = <List<num>>[
      minimumValues,
      maximumValues,
      lowerValues,
      upperValues,
      medianValues,
      meanValues,
    ];
    positions = <ChartDataPointType>[
      ChartDataPointType.low,
      ChartDataPointType.high,
      ChartDataPointType.open,
      ChartDataPointType.close,
      ChartDataPointType.median,
      ChartDataPointType.mean,
    ];
    final int yLength = yLists.length;
    if (positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final num xValue = xValues[i];
      final CartesianChartPoint<D> point =
          CartesianChartPoint<D>(x: xRawValues[index], xValue: xValue);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      point[ChartDataPointType.outliers] = outliersValues[i];
      chartPoints.add(point);
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    final BoxPlotQuartileValues boxPlotValues = BoxPlotQuartileValues();
    _findBoxPlotValues(yValues[index], boxPlotMode, boxPlotValues);

    final num minimum = boxPlotValues.minimum ?? double.nan;
    final num maximum = boxPlotValues.maximum ?? double.nan;
    final num lowerQuartile = boxPlotValues.lowerQuartile ?? double.nan;
    final num upperQuartile = boxPlotValues.upperQuartile ?? double.nan;
    final num mean = boxPlotValues.average ?? double.nan;
    final num median = boxPlotValues.median ?? double.nan;

    maximumValues.add(maximum);
    minimumValues.add(minimum);
    lowerValues.add(lowerQuartile);
    upperValues.add(upperQuartile);
    meanValues.add(mean);
    medianValues.add(median);

    if (boxPlotValues.outliers != null) {
      if (boxPlotValues.outliers!.isEmpty) {
        outliersValues.add(<num>[double.nan]);
      } else {
        outliersValues.add(boxPlotValues.outliers!);
      }
    }

    segment as BoxAndWhiskerSegment<T, D>
      ..series = this
      ..x = xValues[index]
      .._minimum = minimum
      .._maximum = maximum
      .._lowerQuartile = lowerQuartile
      .._upperQuartile = upperQuartile
      .._median = median
      .._mean = mean
      ..outliers = boxPlotValues.outliers;
  }

  @override
  void performLayout() {
    super.performLayout();

    final List<num> dataLabelMaximumValues = <num>[];
    final List<num> dataLabelMinimumValues = <num>[];
    final List<num> dataLabelLowerValues = <num>[];
    final List<num> dataLabelUpperValues = <num>[];
    final List<num> dataLabelMedianValues = <num>[];
    final List<num> dataLabelXValues = <num>[];
    final List<num> dataLabelOutliersValues = <num>[];
    final int length = outliersValues.length;
    for (int i = 0; i < length; i++) {
      final List<num> outliers = outliersValues[i];
      final num currentXValue = xValues[i];
      final int outliersLength = outliers.length;
      for (int j = 0; j < outliersLength; j++) {
        dataLabelXValues.add(currentXValue);
        dataLabelOutliersValues.add(outliers[j]);
        if (j == 0) {
          dataLabelMaximumValues.add(maximumValues[i]);
          dataLabelMinimumValues.add(minimumValues[i]);
          dataLabelLowerValues.add(lowerValues[i]);
          dataLabelUpperValues.add(upperValues[i]);
          dataLabelMedianValues.add(medianValues[i]);
        } else {
          dataLabelMaximumValues.add(double.nan);
          dataLabelMinimumValues.add(double.nan);
          dataLabelLowerValues.add(double.nan);
          dataLabelUpperValues.add(double.nan);
          dataLabelMedianValues.add(double.nan);
        }
      }
    }

    if (markerContainer != null) {
      markerContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = dataLabelXValues
        ..yLists = <List<num>>[dataLabelOutliersValues]
        ..animation = markerAnimation
        ..layout(constraints);
    }

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = dataLabelXValues
        ..yLists = <List<num>>[
          dataLabelMaximumValues,
          dataLabelMinimumValues,
          dataLabelLowerValues,
          dataLabelUpperValues,
          dataLabelMedianValues,
          dataLabelOutliersValues,
        ]
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  @override
  ChartDataLabelAlignment effectiveDataLabelAlignment(
    ChartDataLabelAlignment alignment,
    ChartDataPointType position,
    ChartElementParentData? previous,
    ChartElementParentData current,
    ChartElementParentData? next,
  ) {
    final int index = current.dataPointIndex;
    if (position == ChartDataPointType.open) {
      final num lower = lowerValues[index];
      final num upper = upperValues[index];

      return lower >= upper
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (position == ChartDataPointType.close) {
      final num lower = lowerValues[index];
      final num upper = upperValues[index];
      return upper <= lower
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (position == ChartDataPointType.outliers) {
      return ChartDataLabelAlignment.bottom;
    } else if (position == ChartDataPointType.median) {
      return ChartDataLabelAlignment.middle;
    }

    return alignment == ChartDataLabelAlignment.auto
        ? ChartDataLabelAlignment.outer
        : alignment;
  }

  void _findBoxPlotValues(List<num> yValues, BoxPlotMode mode,
      BoxPlotQuartileValues boxPlotValues) {
    final int yCount = yValues.length;
    if (yCount == 0) {
      return;
    }

    boxPlotValues.average =
        (yValues.fold(0, (num x, num? y) => (x.toDouble()) + y!)) / yCount;
    if (mode == BoxPlotMode.exclusive) {
      boxPlotValues.lowerQuartile =
          _exclusiveQuartileValue(yValues, yCount, 0.25);
      boxPlotValues.upperQuartile =
          _exclusiveQuartileValue(yValues, yCount, 0.75);
      boxPlotValues.median = _exclusiveQuartileValue(yValues, yCount, 0.5);
    } else if (mode == BoxPlotMode.inclusive) {
      boxPlotValues.lowerQuartile =
          _inclusiveQuartileValue(yValues, yCount, 0.25);
      boxPlotValues.upperQuartile =
          _inclusiveQuartileValue(yValues, yCount, 0.75);
      boxPlotValues.median = _inclusiveQuartileValue(yValues, yCount, 0.5);
    } else {
      boxPlotValues.median = _median(yValues);
      _quartileValues(yValues, yCount, boxPlotValues);
    }
    _minMaxOutlier(yValues, yCount, boxPlotValues);
  }

  double _exclusiveQuartileValue(List<num> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0].toDouble();
    }
    num value = 0;
    final num rank = percentile * (count + 1);
    final int integerRank = rank.abs().floor();
    final num fractionRank = rank - integerRank;
    if (integerRank == 0) {
      value = yValues[0];
    } else if (integerRank > count - 1) {
      value = yValues[count - 1];
    } else {
      value = fractionRank * (yValues[integerRank] - yValues[integerRank - 1]) +
          yValues[integerRank - 1];
    }
    return value.toDouble();
  }

  double _inclusiveQuartileValue(List<num> yValues, int count, num percentile) {
    if (count == 0) {
      return 0;
    } else if (count == 1) {
      return yValues[0].toDouble();
    }
    num value = 0;
    final num rank = percentile * (count - 1);
    final int integerRank = rank.abs().floor();
    final num fractionRank = rank - integerRank;
    value = fractionRank * (yValues[integerRank + 1] - yValues[integerRank]) +
        yValues[integerRank];
    return value.toDouble();
  }

  double _median(List<num> values) {
    final int yLength = values.length;
    if (yLength == 0) {
      return 0;
    }

    final int half = (yLength / 2).floor();
    return (yLength % 2 != 0
            ? values[half]
            : ((values[half - 1] + values[half]) / 2.0))
        .toDouble();
  }

  void _quartileValues(List<num> yValues, int count,
      BoxPlotQuartileValues boxPlotQuartileValues) {
    if (count == 1) {
      boxPlotQuartileValues.lowerQuartile = yValues[0].toDouble();
      boxPlotQuartileValues.upperQuartile = yValues[0].toDouble();
    }
    final int halfLength = count ~/ 2;
    final List<num> lowerQuartileArray = yValues.sublist(0, halfLength);
    final List<num> upperQuartileArray =
        yValues.sublist(count.isEven ? halfLength : halfLength + 1, count);
    boxPlotQuartileValues.lowerQuartile = _median(lowerQuartileArray);
    boxPlotQuartileValues.upperQuartile = _median(upperQuartileArray);
  }

  void _minMaxOutlier(List<num> yValues, int count,
      BoxPlotQuartileValues boxPlotQuartileValues) {
    final double interQuartile = boxPlotQuartileValues.upperQuartile! -
        boxPlotQuartileValues.lowerQuartile!;
    final num rangeIQR = 1.5 * interQuartile;
    for (int i = 0; i < count; i++) {
      if (yValues[i] < boxPlotQuartileValues.lowerQuartile! - rangeIQR) {
        boxPlotQuartileValues.outliers!.add(yValues[i]);
      } else {
        boxPlotQuartileValues.minimum = yValues[i];
        break;
      }
    }
    for (int i = count - 1; i >= 0; i--) {
      if (yValues[i] > boxPlotQuartileValues.upperQuartile! + rangeIQR) {
        boxPlotQuartileValues.outliers!.add(yValues[i]);
      } else {
        boxPlotQuartileValues.maximum = yValues[i];
        break;
      }
    }
  }

  @override
  BoxAndWhiskerSegment<T, D> createSegment() => BoxAndWhiskerSegment<T, D>();

  @override
  void customizeSegment(ChartSegment segment) {
    final BoxAndWhiskerSegment<T, D> boxAndWhiskerSegment =
        segment as BoxAndWhiskerSegment<T, D>;
    final Color? customBorderColor =
        borderColor == Colors.transparent || borderColor == null
            ? Colors.black
            : borderColor;
    updateSegmentColor(boxAndWhiskerSegment, customBorderColor, borderWidth);
    updateSegmentGradient(boxAndWhiskerSegment,
        gradientBounds: boxAndWhiskerSegment.segmentRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.boxAndWhiskerSeries;

  @override
  void dispose() {
    _resetDataSourceHolders();
    super.dispose();
  }
}

/// Creates the segments for box and whisker series.
///
/// Generates the box and whisker series points
/// and has the [calculateSegmentPoints] override method
/// used to customize the box and whisker series segment point calculation.
///
/// Gets the path and fill color from the `series`
/// to render the box and whisker segment.
class BoxAndWhiskerSegment<T, D> extends ChartSegment {
  final List<Offset> _medianLinePoints = <Offset>[];
  final List<Offset> _meanLinePoints = <Offset>[];
  final List<Offset> _outlierPoints = <Offset>[];

  Rect? _oldSegmentRect;
  Rect? segmentRect;

  final List<Offset> _oldPoints = <Offset>[];

  late BoxAndWhiskerSeriesRenderer<T, D> series;
  List<num>? outliers = <num>[];

  late num x;

  num get lowerQuartile => _lowerQuartile;
  num _lowerQuartile = double.nan;

  num get upperQuartile => _upperQuartile;
  num _upperQuartile = double.nan;

  num get minimum => _minimum;
  num _minimum = double.nan;

  num get maximum => _maximum;
  num _maximum = double.nan;

  num get median => _median;
  num _median = double.nan;

  num get mean => _mean;
  num _mean = double.nan;

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldSegmentRect = null;
      _oldPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldPoints.clear();
        return;
      }

      final int newPointsLength = points.length;
      final int oldPointsLength = _oldPoints.length;
      if (oldPointsLength == newPointsLength) {
        for (int i = 0; i < newPointsLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }
      } else {
        final int minLength = min(oldPointsLength, newPointsLength);
        for (int i = 0; i < minLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }

        if (newPointsLength > oldPointsLength) {
          _oldPoints.addAll(points.sublist(oldPointsLength));
        } else {
          _oldPoints.removeRange(minLength, oldPointsLength);
        }
      }

      _oldSegmentRect =
          Rect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldPoints.clear();
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (x.isNaN ||
        lowerQuartile.isNaN ||
        upperQuartile.isNaN ||
        minimum.isNaN ||
        maximum.isNaN ||
        median.isNaN ||
        mean.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      _oldPoints.clear();
      points.clear();
      return;
    }

    points.clear();
    _medianLinePoints.clear();
    _meanLinePoints.clear();
    _outlierPoints.clear();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final num left = x + series.sbsInfo.minimum;
    final num right = x + series.sbsInfo.maximum;

    final double centerY = lowerQuartile + (upperQuartile - lowerQuartile) / 2;
    if (!lowerQuartile.isNaN && !upperQuartile.isNaN) {
      double x1 = transformX(left, upperQuartile);
      double y1 = transformY(left, upperQuartile);
      double x2 = transformX(right, lowerQuartile);
      double y2 = transformY(right, lowerQuartile);

      if (y1 > y2) {
        final double temp = y1;
        y1 = y2;
        y2 = temp;
      }

      if (x1 > x2) {
        final double temp = x1;
        x1 = x2;
        x2 = temp;
      }

      segmentRect = Rect.fromLTRB(x1, y1, x2, y2);
      _oldSegmentRect ??= Rect.fromLTRB(
        transformX(left, centerY),
        transformY(left, centerY),
        transformX(right, centerY),
        transformY(right, centerY),
      );
    }

    if (segmentRect == null) {
      return;
    }

    final double centerX = (right + left) / 2;
    _addMinMaxPoints(transformX, transformY, centerX, centerY, left, right);

    if (!median.isNaN) {
      _medianLinePoints
          .add(Offset(transformX(left, median), transformY(left, median)));
      _medianLinePoints
          .add(Offset(transformX(right, median), transformY(right, median)));
    }

    if (series.showMean && !mean.isNaN) {
      final double meanX = transformX(centerX, mean);
      final double meanY = transformY(centerX, mean);

      final double markerHeight = series.markerSettings.height;
      final double markerWidth = series.markerSettings.width;
      _meanLinePoints
          .add(Offset(meanX + markerWidth / 2, meanY - markerHeight / 2));
      _meanLinePoints
          .add(Offset(meanX - markerWidth / 2, meanY + markerHeight / 2));

      _meanLinePoints
          .add(Offset(meanX + markerWidth / 2, meanY + markerHeight / 2));
      _meanLinePoints
          .add(Offset(meanX - markerWidth / 2, meanY - markerHeight / 2));
    }

    if (outliers != null && outliers!.isNotEmpty) {
      final int length = outliers!.length;
      for (int i = 0; i < length; i++) {
        final num outlier = outliers![i];
        final double outlierX = transformX(centerX, outlier);
        final double outlierY = transformY(centerX, outlier);
        _outlierPoints.add(Offset(outlierX, outlierY));
      }
    }
  }

  void _addMinMaxPoints(
      PointToPixelCallback transformX,
      PointToPixelCallback transformY,
      double centerX,
      double centerY,
      num left,
      num right) {
    if (!minimum.isNaN && !maximum.isNaN) {
      final Offset maxStart =
          Offset(transformX(left, maximum), transformY(left, maximum));
      final Offset maxEnd =
          Offset(transformX(right, maximum), transformY(right, maximum));
      points.add(maxStart);
      points.add(maxEnd);

      final Offset maxConnectorStart =
          Offset(transformX(x, upperQuartile), transformY(x, upperQuartile));
      final Offset maxConnectorEnd =
          Offset(transformX(x, maximum), transformY(x, maximum));
      points.add(maxConnectorStart);
      points.add(maxConnectorEnd);

      final Offset minStart =
          Offset(transformX(left, minimum), transformY(left, minimum));
      final Offset minEnd =
          Offset(transformX(right, minimum), transformY(right, minimum));
      points.add(minStart);
      points.add(minEnd);

      final Offset minConnectorStart =
          Offset(transformX(x, lowerQuartile), transformY(x, lowerQuartile));
      final Offset minConnectorEnd =
          Offset(transformX(x, minimum), transformY(x, minimum));
      points.add(minConnectorStart);
      points.add(minConnectorEnd);

      if (_oldPoints.isEmpty) {
        // Max points.
        final Offset start =
            Offset(transformX(left, centerY), transformY(left, centerY));
        final Offset end =
            Offset(transformX(right, centerY), transformY(right, centerY));
        _oldPoints.add(start);
        _oldPoints.add(end);

        final Offset center =
            Offset(transformX(centerX, centerY), transformY(centerX, centerY));
        _oldPoints.add(center);
        _oldPoints.add(center);

        // Min points.
        _oldPoints.add(start);
        _oldPoints.add(end);
        _oldPoints.add(center);
        _oldPoints.add(center);
      }

      if (points.length > _oldPoints.length) {
        _oldPoints.addAll(points.sublist(_oldPoints.length));
      }
    }
  }

  @override
  bool contains(Offset position) {
    if (_outlierPoints.isNotEmpty) {
      final MarkerSettings marker = series.markerSettings;
      final int length = _outlierPoints.length;
      for (int i = 0; i < length; i++) {
        if (tooltipTouchBounds(_outlierPoints[i], marker.width, marker.height)
            .contains(position)) {
          return true;
        }
      }
    }

    return segmentRect != null && segmentRect!.contains(position);
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: series.xValues[currentSegmentIndex],
      maximum: maximum,
      minimum: minimum,
      median: median,
      mean: mean,
      upperQuartile: upperQuartile,
      lowerQuartile: lowerQuartile,
      outliers: outliers,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      Rect outlierBounds = Rect.zero;
      int outlierIndex = -1;

      if (position != null) {
        final int length = _outlierPoints.length;
        for (int i = 0; i < length; i++) {
          final ChartMarker marker = series.markerAt(i);
          final Rect outlierRect = Rect.fromCenter(
              center: _outlierPoints[i],
              width: marker.width,
              height: marker.height);
          if (outlierRect.contains(position)) {
            outlierBounds = outlierRect;
            outlierIndex = i;
            break;
          }
        }
      }

      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final TooltipPosition? tooltipPosition =
          series.parent?.tooltipBehavior?.tooltipPosition;
      Offset primaryPos;
      Offset secondaryPos;
      if (outlierIndex != -1) {
        primaryPos = series.localToGlobal(outlierBounds.topCenter);
        secondaryPos = series.localToGlobal(outlierBounds.bottomCenter);
      } else {
        if (points.isNotEmpty && points.length == 8) {
          primaryPos = secondaryPos = series.localToGlobal(points[3]);
        } else {
          primaryPos = tooltipPosition == TooltipPosition.pointer
              ? series.localToGlobal(position ?? segmentRect!.topCenter)
              : series.localToGlobal(segmentRect!.topCenter);
          secondaryPos = primaryPos;
        }
      }
      return ChartTooltipInfo<T, D>(
        primaryPosition: primaryPos,
        secondaryPosition: secondaryPos,
        text: series.tooltipText(chartPoint, outlierIndex),
        header: series.parent!.tooltipBehavior!.shared
            ? series.tooltipHeaderText(chartPoint)
            : series.name,
        data: series.dataSource![pointIndex],
        point: chartPoint,
        series: series.widget,
        renderer: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: pointIndex,
        markerColors: <Color?>[fillPaint.color],
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      Offset primaryPos;
      if (points.isNotEmpty && points.length == 8) {
        primaryPos = points[3];
      } else {
        primaryPos = Offset(series.pointToPixelX(x, chartPoint.upperQuartile!),
            series.pointToPixelY(x, chartPoint.upperQuartile!));
      }

      return ChartTrackballInfo<T, D>(
        position: primaryPos,
        maxYPos: series.pointToPixelY(x, chartPoint.maximum!),
        point: chartPoint,
        series: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: pointIndex,
        text: series.trackballText(chartPoint, series.name),
        header: series.tooltipHeaderText(chartPoint),
        color: fillPaint.color,
      );
    }
    return null;
  }

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => fillPaint;

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Paint strokePaint = getStrokePaint();
    if (points.isNotEmpty &&
        points.length == 8 &&
        strokePaint.strokeWidth > 0 &&
        strokePaint.color != Colors.transparent) {
      final Offset? maxStart =
          Offset.lerp(_oldPoints[0], points[0], animationFactor);
      final Offset? maxEnd =
          Offset.lerp(_oldPoints[1], points[1], animationFactor);
      if (maxStart != null && maxEnd != null) {
        drawDashes(canvas, series.dashArray, strokePaint,
            start: maxStart, end: maxEnd);
      }

      final Offset? maxConnectorStart =
          Offset.lerp(_oldPoints[2], points[2], animationFactor);
      final Offset? maxConnectorEnd =
          Offset.lerp(_oldPoints[3], points[3], animationFactor);
      if (maxConnectorStart != null && maxConnectorEnd != null) {
        drawDashes(canvas, series.dashArray, strokePaint,
            start: maxConnectorStart, end: maxConnectorEnd);
      }

      final Offset? minStart =
          Offset.lerp(_oldPoints[4], points[4], animationFactor);
      final Offset? minEnd =
          Offset.lerp(_oldPoints[5], points[5], animationFactor);
      if (minStart != null && minEnd != null) {
        drawDashes(canvas, series.dashArray, strokePaint,
            start: minStart, end: minEnd);
      }

      final Offset? minConnectorStart =
          Offset.lerp(_oldPoints[6], points[6], animationFactor);
      final Offset? minConnectorEnd =
          Offset.lerp(_oldPoints[7], points[7], animationFactor);
      if (minConnectorStart != null && minConnectorEnd != null) {
        drawDashes(canvas, series.dashArray, strokePaint,
            start: minConnectorStart, end: minConnectorEnd);
      }
    }

    if (segmentRect == null) {
      return;
    }

    final Rect? paintRect =
        Rect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    if (paintRect == null || paintRect.isEmpty) {
      return;
    }

    final Paint fillPaint = getFillPaint();
    if (fillPaint.color != Colors.transparent) {
      canvas.drawRect(paintRect, fillPaint);
    }

    final double strokeWidth = strokePaint.strokeWidth;
    if (strokeWidth > 0 && strokePaint.color != Colors.transparent) {
      final Path strokePath = strokePathFromRRect(
          RRect.fromRectAndRadius(paintRect, Radius.zero), strokeWidth);
      drawDashes(canvas, series.dashArray, strokePaint, path: strokePath);
    }

    if (_medianLinePoints.isNotEmpty) {
      drawDashes(canvas, series.dashArray, strokePaint,
          start: _medianLinePoints[0], end: _medianLinePoints[1]);
    }

    if (animationFactor > 0.75 && _meanLinePoints.isNotEmpty) {
      // Mean animation starts at 0.75 and ends at 1.0. So, the animation falls
      // only 0.25. So, 0.25 * 4 = 1.0. So, the animation factor is multiplied
      // by 4 to get the animation factor for mean line.
      final double opacity = (animationFactor - 0.75) * 4.0;
      final Paint meanPaint = Paint()
        ..color = strokePaint.color.withOpacity(opacity)
        ..strokeWidth = strokePaint.strokeWidth
        ..shader = strokePaint.shader
        ..style = strokePaint.style
        ..strokeCap = strokePaint.strokeCap
        ..strokeJoin = strokePaint.strokeJoin
        ..strokeMiterLimit = strokePaint.strokeMiterLimit;
      drawDashes(canvas, series.dashArray, meanPaint,
          start: _meanLinePoints[0], end: _meanLinePoints[1]);
      drawDashes(canvas, series.dashArray, meanPaint,
          start: _meanLinePoints[2], end: _meanLinePoints[3]);
    }
  }

  @override
  void dispose() {
    points.clear();
    _oldPoints.clear();
    _medianLinePoints.clear();
    _meanLinePoints.clear();
    _outlierPoints.clear();
    segmentRect = null;
    super.dispose();
  }
}

/// Represents the class for box plot quartile values.
class BoxPlotQuartileValues {
  /// Creates an instance of box plot quartile values.
  BoxPlotQuartileValues({
    this.minimum,
    this.maximum,
    this.upperQuartile,
    this.lowerQuartile,
    this.average,
    this.median,
    this.mean,
  });

  /// Specifies the value of minimum.
  num? minimum;

  /// Specifies the value of maximum.
  num? maximum;

  /// Specifies the list of outliers.
  List<num>? outliers = <num>[];

  /// Specifies the value of the upper quartiles.
  double? upperQuartile;

  /// Specifies the value of lower quartiles.
  double? lowerQuartile;

  /// Specifies the value of average.
  num? average;

  /// Specifies the value of median.
  num? median;

  /// Specifies the mean value.
  num? mean;
}
