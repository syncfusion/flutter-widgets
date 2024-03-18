import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/connector_line.dart';
import '../common/core_tooltip.dart';
import '../common/element_widget.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the waterfall series.
///
/// To render a waterfall chart, create an instance of [WaterfallSeries] and
/// add to the series collection property of [SfCartesianChart].
///
/// [WaterfallSeries] is similar to range column series,
/// in range column high and low value should be there, but in waterfall
/// we have find the endValue and originValue of each data point.
@immutable
class WaterfallSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of WaterfallSeries class.
  const WaterfallSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    this.intermediateSumPredicate,
    this.totalSumPredicate,
    this.negativePointsColor,
    this.intermediateSumColor,
    this.totalSumColor,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    this.connectorLineSettings = const WaterfallConnectorLineSettings(),
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    this.width = 0.7,
    this.spacing = 0.0,
    super.markerSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.gradient,
    super.borderGradient,
    this.borderRadius = BorderRadius.zero,
    super.enableTooltip = true,
    super.animationDuration,
    this.borderColor = Colors.transparent,
    super.trendlines,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.dashArray,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.initialSelectedDataIndexes,
  });

  /// Color of the negative data points in the series.
  ///
  /// If no color is specified, then the negative data points will be rendered
  /// with the series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         negativePointsColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? negativePointsColor;

  /// Color of the intermediate sum points in the series.
  ///
  /// If no color is specified, then the intermediate sum points will be
  /// rendered with the series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         intermediateSumColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? intermediateSumColor;

  /// Color of the total sum points in the series.
  ///
  /// If no color is specified, then the total sum points will be rendered
  /// with the series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         totalSumColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? totalSumColor;

  /// Options to customize the waterfall chart connector line.
  ///
  /// Data points in waterfall chart are connected using the connector line.
  /// Provides the options to change the width, color and dash array of the
  /// connector line to customize the appearance.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         connectorLineSettings: WaterfallConnectorLineSettings(
  ///           width: 2,
  ///           color: Colors.black,
  ///           dashArray: [2,3]
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final WaterfallConnectorLineSettings connectorLineSettings;

  /// Spacing between the data points in waterfall chart.
  ///
  /// The value ranges from 0 to 1, where 1 represents 100% and 0 represents
  /// 0% of the available space.
  ///
  /// Spacing affects the width of the bars in waterfall. For example,
  /// setting 20% spacing and 100% width
  /// renders the bars with 80% of total width.
  ///
  /// Also refer [CartesianSeries.width].
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Customizes the corners of the waterfall.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  /// A boolean value, based on which the data point will be considered as
  /// intermediate sum or not.
  ///
  /// If this has true value, then that point will be considered as an
  /// intermediate sum. Else if it has false, then it will be considered as a
  /// normal data point in chart.
  ///
  /// This callback will be called for all the data points to check
  /// if the data is intermediate sum.
  ///
  /// _Note:_  This is applicable only for waterfall chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(2, 24, true),
  ///           SalesData(3, 22, false),
  ///           SalesData(4, 31, true),
  ///         ],
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         intermediateSumPredicate:
  ///           (SalesData data, _) => data.isIntermediate,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.x, this.y, this.isIntermediate);
  ///     final num x;
  ///     final num y;
  ///     final bool isIntermediate;
  /// }
  /// ```
  final ChartValueMapper<T, bool>? intermediateSumPredicate;

  /// A boolean value, based on which the data point will be considered as
  /// total sum or not.
  ///
  /// If this has true value, then that point will be considered as a total sum.
  /// Else if it has false, then it will be considered as a
  /// normal data point in chart.
  ///
  /// This callback will be called for all the data points to check
  /// if the data is total sum.
  ///
  /// _Note:_ This is applicable only for waterfall chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         dataSource: <SalesData>[
  ///           SalesData(2, 24, true),
  ///           SalesData(3, 22, true),
  ///           SalesData(4, 31, false),
  ///         ],
  ///         xValueMapper: (SalesData sales, _) => sales.x,
  ///         yValueMapper: (SalesData sales, _) => sales.y,
  ///         totalSumPredicate: (SalesData data, _) => data.isTotalSum,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// class SalesData {
  ///   SalesData(this.x, this.y, this.isTotalSum);
  ///     final num x;
  ///     final num y;
  ///     final bool isTotalSum;
  /// }
  /// ```
  final ChartValueMapper<T, bool>? totalSumPredicate;

  final double width;

  final Color borderColor;

  /// Create the waterfall series renderer.
  @override
  WaterfallSeriesRenderer<T, D> createRenderer() {
    WaterfallSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as WaterfallSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return WaterfallSeriesRenderer<T, D>();
  }

  @override
  WaterfallSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final WaterfallSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as WaterfallSeriesRenderer<T, D>;
    renderer
      ..negativePointsColor = negativePointsColor
      ..intermediateSumColor = intermediateSumColor
      ..totalSumColor = totalSumColor
      ..connectorLineSettings = connectorLineSettings
      ..width = width
      ..spacing = spacing
      ..borderRadius = borderRadius
      ..borderColor = borderColor
      ..intermediateSumPredicate = intermediateSumPredicate
      ..totalSumPredicate = totalSumPredicate;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, WaterfallSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..negativePointsColor = negativePointsColor
      ..intermediateSumColor = intermediateSumColor
      ..totalSumColor = totalSumColor
      ..connectorLineSettings = connectorLineSettings
      ..width = width
      ..spacing = spacing
      ..borderRadius = borderRadius
      ..borderColor = borderColor
      ..intermediateSumPredicate = intermediateSumPredicate
      ..totalSumPredicate = totalSumPredicate;
  }
}

/// Options to customize the waterfall chart connector line.
///
/// Data points in waterfall chart are connected using the connector line and
/// this class hold the properties to customize it.
///
/// It provides the options to change the width, color and dash array of the
/// connector line to customize the appearance.
class WaterfallConnectorLineSettings extends ConnectorLineSettings {
  /// Creating an argument constructor of WaterfallConnectorLineSettings class.
  const WaterfallConnectorLineSettings({
    double? width,
    Color? color,
    this.dashArray = const <double>[0, 0],
  }) : super(color: color, width: width ?? 1);

  /// Dashes of the waterfall chart connector line.
  ///
  /// Any number of values can be provided in the list. Odd values are
  /// considered as rendering size and even values are considered as gap.
  ///
  /// Defaults to `null.`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         connectorLineSettings: WaterfallConnectorLineSettings(
  ///           dashArray: [2,3]
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final List<double>? dashArray;
}

/// Creates series renderer for waterfall series.
class WaterfallSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with SbsSeriesMixin<T, D>, ClusterSeriesMixin, SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of WaterfallSeriesRenderer class.
  WaterfallSeriesRenderer();

  Color? get negativePointsColor => _negativePointsColor;
  Color? _negativePointsColor;
  set negativePointsColor(Color? value) {
    if (_negativePointsColor != value) {
      _negativePointsColor = value;
      markNeedsSegmentsPaint();
    }
  }

  Color? get intermediateSumColor => _intermediateSumColor;
  Color? _intermediateSumColor;
  set intermediateSumColor(Color? value) {
    if (_intermediateSumColor != value) {
      _intermediateSumColor = value;
      markNeedsSegmentsPaint();
    }
  }

  Color? get totalSumColor => _totalSumColor;
  Color? _totalSumColor;
  set totalSumColor(Color? value) {
    if (_totalSumColor != value) {
      _totalSumColor = value;
      markNeedsSegmentsPaint();
    }
  }

  WaterfallConnectorLineSettings get connectorLineSettings =>
      _connectorLineSettings;
  WaterfallConnectorLineSettings _connectorLineSettings =
      const WaterfallConnectorLineSettings();
  set connectorLineSettings(WaterfallConnectorLineSettings value) {
    if (_connectorLineSettings != value) {
      _connectorLineSettings = value;
      markNeedsLayout();
    }
  }

  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius = BorderRadius.zero;
  set borderRadius(BorderRadius value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsLayout();
    }
  }

  ChartValueMapper<T, bool>? get intermediateSumPredicate =>
      _intermediateSumPredicate;
  ChartValueMapper<T, bool>? _intermediateSumPredicate;
  set intermediateSumPredicate(ChartValueMapper<T, bool>? value) {
    if (_intermediateSumPredicate != value) {
      _intermediateSumPredicate = value;
      markNeedsLayout();
    }
  }

  ChartValueMapper<T, bool>? get totalSumPredicate => _totalSumPredicate;
  ChartValueMapper<T, bool>? _totalSumPredicate;
  set totalSumPredicate(ChartValueMapper<T, bool>? value) {
    if (_totalSumPredicate != value) {
      _totalSumPredicate = value;
      markNeedsLayout();
    }
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  final List<bool> _intermediateSumValues = <bool>[];
  final List<bool> _totalSumValues = <bool>[];
  final List<num> _highValues = <num>[];
  final List<num> _lowValues = <num>[];
  final List<num> _waterfallYValues = <num>[];

  bool? _intermediateSumPredicateMapper(T data, int index) {
    return intermediateSumPredicate!(data, index);
  }

  bool? _totalSumPredicateMapper(T data, int index) {
    return totalSumPredicate!(data, index);
  }

  bool _defaultSumPredicate(T data, int index) => false;

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    _calculateWaterfallValues();
    populateChartPoints();
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[_highValues];
      positions = <ChartDataPointType>[ChartDataPointType.y];
    } else {
      yLists.add(_highValues);
      positions!.add(ChartDataPointType.y);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
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
    _calculateWaterfallValues();
  }

  void _resetDataSourceHolders() {
    _intermediateSumValues.clear();
    _totalSumValues.clear();
    _highValues.clear();
    _lowValues.clear();
    _waterfallYValues.clear();
  }

  void _calculateWaterfallValues() {
    _resetDataSourceHolders();

    num topValue = 0;
    num bottomValue = 0;
    num intermediateOrigin = 0;
    num prevTop = 0;
    num minY = 0;
    num maxY = 0;
    bool isIntermediateSum = false;
    bool isTotalSum = false;
    final bool? Function(T data, int index) intermediateSum =
        intermediateSumPredicate != null
            ? _intermediateSumPredicateMapper
            : _defaultSumPredicate;
    final bool? Function(T data, int index) totalSum = totalSumPredicate != null
        ? _totalSumPredicateMapper
        : _defaultSumPredicate;

    for (int i = 0; i < dataCount; i++) {
      final T current = dataSource![i];
      isIntermediateSum = intermediateSum(current, i) ?? false;
      isTotalSum = totalSum(current, i) ?? false;
      _intermediateSumValues.add(isIntermediateSum);
      _totalSumValues.add(isTotalSum);
      if (!(isIntermediateSum || isTotalSum) && !yValues[i].isNaN) {
        topValue += yValues[i];
      }

      bottomValue = isIntermediateSum ? intermediateOrigin : prevTop;
      bottomValue = isTotalSum ? 0 : bottomValue;
      minY = bottomValue < minY ? bottomValue : minY;
      maxY = topValue > maxY ? topValue : maxY;
      _highValues.add(topValue);
      _lowValues.add(bottomValue);
      _waterfallYValues.add(topValue - bottomValue);
      if (isIntermediateSum) {
        intermediateOrigin = topValue;
      }
      prevTop = topValue;
    }

    yMin = minY.isNaN ? yMin : minY;
    yMax = maxY.isNaN ? yMax : maxY;
  }

  @override
  num trackballYValue(int index) => _highValues[index];

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as WaterfallSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..top = _highValues[index]
      ..bottom = _lowValues[index]
      ..isTotalSum = _totalSumValues[index]
      ..isIntermediateSum = _intermediateSumValues[index];
  }

  @override
  void performLayout() {
    super.performLayout();

    if (markerContainer != null) {
      markerContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[_highValues]
        ..animation = markerAnimation
        ..layout(constraints);
    }

    if (dataLabelContainer != null) {
      dataLabelContainer!
        ..renderer = this
        ..xRawValues = xRawValues
        ..xValues = xValues
        ..yLists = <List<num>>[_highValues]
        ..stackedYValues = _waterfallYValues
        ..sortedIndexes = sortedIndexes
        ..animation = dataLabelAnimation
        ..layout(constraints);
    }
  }

  /// Creates a segment for a data point in the series.
  @override
  WaterfallSegment<T, D> createSegment() => WaterfallSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.waterfallSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final WaterfallSegment<T, D> waterfallSegment =
        segment as WaterfallSegment<T, D>;
    final int index = waterfallSegment.currentSegmentIndex;
    Color? color;
    if (_intermediateSumValues[index] && intermediateSumColor != null) {
      color = intermediateSumColor;
    } else if (_totalSumValues[index] && totalSumColor != null) {
      color = totalSumColor;
    } else if (yValues[index] < 0 && negativePointsColor != null) {
      color = negativePointsColor;
    }

    updateSegmentColor(waterfallSegment, borderColor, borderWidth,
        fillColor: color);
    updateSegmentGradient(waterfallSegment,
        gradientBounds: waterfallSegment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);

    segment.connectorLineStrokePaint
      ..color = (connectorLineSettings.color ??
          chartThemeData!.waterfallConnectorLineColor)!
      ..strokeWidth = connectorLineSettings.width;
  }

  @override
  Offset dataLabelPosition(ChartElementParentData current,
      ChartDataLabelAlignment alignment, Size size) {
    final num x = current.x! + (sbsInfo.maximum + sbsInfo.minimum) / 2;
    num y = current.y!;
    final int dataPointIndex = current.dataPointIndex;
    final num bottom = _lowValues[dataPointIndex];
    final bool isNegative = yValues[dataPointIndex] < 0;

    if (alignment == ChartDataLabelAlignment.bottom) {
      y = bottom;
    } else if (alignment == ChartDataLabelAlignment.middle) {
      y = (y + bottom) / 2;
    }
    final EdgeInsets margin = dataLabelSettings.margin;
    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
        if (isTransposed) {
          translationX = isNegative
              ? -(dataLabelPadding + size.width + margin.horizontal)
              : dataLabelPadding;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = isNegative
              ? 0
              : -(dataLabelPadding + size.height + margin.vertical);
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.bottom:
        if (isTransposed) {
          translationX = isNegative
              ? -(dataLabelPadding + size.width + margin.horizontal)
              : dataLabelPadding;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = isNegative
              ? dataLabelPadding
              : -(dataLabelPadding + size.height + margin.vertical);
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.top:
        if (isTransposed) {
          translationX = isNegative
              ? 0
              : -(dataLabelPadding + size.width + margin.horizontal);
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = isNegative
              ? -(dataLabelPadding + size.height + margin.vertical)
              : dataLabelPadding;
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.middle:
        final WaterfallSegment<T, D> segment =
            segments[dataPointIndex] as WaterfallSegment<T, D>;
        final Offset center = segment.segmentRect!.center;
        if (isTransposed) {
          translationX = -margin.left - size.width / 2;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -margin.top - size.height / 2;
        }
        return center.translate(translationX, translationY);
    }
  }

  @override
  void dispose() {
    _resetDataSourceHolders();
    super.dispose();
  }
}

/// Creates the segments for waterfall series.
///
/// Generates the waterfall series points and has the [calculateSegmentPoints]
/// method overridden to customize the waterfall segment point calculation.
///
/// Gets the path and color from the `series`.
class WaterfallSegment<T, D> extends ChartSegment {
  late WaterfallSeriesRenderer<T, D> series;
  final Paint connectorLineStrokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  late num x;
  late num top;
  late num bottom;

  late bool isTotalSum;
  late bool isIntermediateSum;

  RRect? _oldSegmentRect;
  RRect? segmentRect;

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldSegmentRect = null;
      segmentRect = null;
      return;
    }

    if (series.animationDuration > 0) {
      _oldSegmentRect =
          RRect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (x.isNaN || top.isNaN || bottom.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      points.clear();
      return;
    }

    points.clear();
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final num left = x + series.sbsInfo.minimum;
    final num sbsMaximum = series.sbsInfo.maximum;
    final num right = x + sbsMaximum;

    final double centerY = (bottom + top) / 2;
    final double x1 = transformX(left, top);
    final double y1 = transformY(left, top);
    final double x2 = transformX(right, bottom);
    final double y2 = transformY(right, bottom);

    final BorderRadius borderRadius = series._borderRadius;
    segmentRect = toRRect(x1, y1, x2, y2, borderRadius);
    _oldSegmentRect ??= toRRect(
      transformX(left, centerY),
      transformY(left, centerY),
      transformX(right, centerY),
      transformY(right, centerY),
      borderRadius,
    );

    if (currentSegmentIndex > 0) {
      final WaterfallSegment<T, D> oldSegment =
          series.segments[currentSegmentIndex - 1] as WaterfallSegment<T, D>;
      final num oldSegmentRight = oldSegment.x + sbsMaximum;
      final num oldSegmentTop = oldSegment.top;
      points.add(Offset(
        transformX(oldSegmentRight, oldSegmentTop),
        transformY(oldSegmentRight, oldSegmentTop),
      ));

      if (isTotalSum || isIntermediateSum) {
        points.add(Offset(x1, y1));
      } else {
        series.isTransposed
            ? points.add(Offset(x2, y1))
            : points.add(Offset(x1, y2));
      }
    }
  }

  @override
  bool contains(Offset position) {
    return segmentRect != null && segmentRect!.contains(position);
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: series.xValues[currentSegmentIndex],
      y: top,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final TooltipPosition? tooltipPosition =
          series.parent?.tooltipBehavior?.tooltipPosition;
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = tooltipPosition == TooltipPosition.pointer
          ? position ?? segmentRect!.outerRect.topCenter
          : segmentRect!.outerRect.topCenter;
      return ChartTooltipInfo<T, D>(
        primaryPosition:
            series.localToGlobal(preferredPos.translate(0, -markerHeight)),
        secondaryPosition:
            series.localToGlobal(preferredPos.translate(0, markerHeight)),
        text: series.tooltipText(chartPoint),
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
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position:
            Offset(series.pointToPixelX(x, top), series.pointToPixelY(x, top)),
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

  Paint getConnectorLineStrokePaint() => connectorLineStrokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (segmentRect == null) {
      return;
    }

    final RRect? paintRRect =
        RRect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    if (paintRRect == null || paintRRect.isEmpty) {
      return;
    }

    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawRRect(paintRRect, paint);
    }

    paint = getStrokePaint();
    final double strokeWidth = paint.strokeWidth;
    if (paint.color != Colors.transparent && strokeWidth > 0) {
      final Path strokePath = strokePathFromRRect(paintRRect, strokeWidth);
      drawDashes(canvas, series.dashArray, paint, path: strokePath);
    }

    final Paint connectorLinePaint = getConnectorLineStrokePaint();
    if (animationFactor == 1 &&
        points.isNotEmpty &&
        connectorLinePaint.strokeWidth > 0) {
      drawDashes(
        canvas,
        series.connectorLineSettings.dashArray,
        connectorLinePaint,
        start: points[0],
        end: points[1],
      );
    }
  }

  @override
  void dispose() {
    segmentRect = null;
    points.clear();
    super.dispose();
  }
}
