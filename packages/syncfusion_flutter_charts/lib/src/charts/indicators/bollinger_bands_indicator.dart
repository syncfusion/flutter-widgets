import 'dart:math';

import 'package:flutter/material.dart';

import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'technical_indicator.dart';

/// This class has the property of bollinger band indicator.
///
/// This indicator also has [upperLineColor], [lowerLineColor] property for
/// defining the brushes for the indicator lines. Also, we can specify standard
/// deviation values for the [BollingerBandIndicator] using
/// [standardDeviation] property.
///
/// Provides options for series visible, axis name, series name, animation
/// duration, legend visibility, band color to customize the appearance.
@immutable
class BollingerBandIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of BollingerBandIndicator class.
  BollingerBandIndicator({
    super.isVisible,
    super.xAxisName,
    super.yAxisName,
    super.seriesName,
    super.dashArray,
    super.animationDuration,
    super.animationDelay,
    super.dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    super.name,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.signalLineColor,
    super.signalLineWidth,
    this.period = 14,
    this.standardDeviation = 2,
    this.upperLineColor = Colors.red,
    this.upperLineWidth = 2,
    this.lowerLineColor = Colors.green,
    this.lowerLineWidth = 2,
    this.bandColor = const Color(0x409e9e9e),
    super.onRenderDetailsUpdate,
  }) : super(
          xValueMapper: xValueMapper != null && dataSource != null
              ? (int index) => xValueMapper(dataSource[index], index)
              : null,
          closeValueMapper: closeValueMapper != null && dataSource != null
              ? (int index) => closeValueMapper(dataSource[index], index)
              : null,
        );

  /// Standard deviation value of the bollinger band.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int standardDeviation;

  /// Upper line color of the bollinger band.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3,
  ///        upperLineColor: Colors.yellow
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final Color upperLineColor;

  /// Upper line width value of the bollinger band.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3,
  ///        upperLineWidth: 3
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double upperLineWidth;

  /// Lower line color value of the bollinger band.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3,
  ///        lowerLineColor: Colors.red
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final Color lowerLineColor;

  /// Lower line width value of the bollinger band.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3,
  ///        lowerLineWidth: 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double lowerLineWidth;

  /// Band color of the bollinger band.
  ///
  /// Default is `Color(0x409e9e9e)`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period: 2,
  ///        standardDeviation: 3,
  ///        bandColor: Colors.blue
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final Color bandColor;

  /// Period determines the start point for the rendering
  /// of technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      BollingerBandIndicator<Sample, num>(
  ///        period : 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int period;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BollingerBandIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth &&
        other.standardDeviation == standardDeviation &&
        other.upperLineColor == upperLineColor &&
        other.upperLineWidth == upperLineWidth &&
        other.lowerLineColor == lowerLineColor &&
        other.lowerLineWidth == lowerLineWidth &&
        other.bandColor == bandColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      xAxisName,
      yAxisName,
      seriesName,
      dashArray,
      animationDuration,
      animationDelay,
      dataSource,
      xValueMapper,
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      period,
      standardDeviation,
      upperLineColor,
      upperLineWidth,
      lowerLineColor,
      lowerLineWidth,
      bandColor
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'Bollinger';
}

class BollingerIndicatorWidget extends IndicatorWidget {
  const BollingerIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the BollingerIndicatorRenderer renderer.
  @override
  BollingerIndicatorRenderer createRenderer() {
    return BollingerIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final BollingerIndicatorRenderer renderer =
        super.createRenderObject(context) as BollingerIndicatorRenderer;
    final BollingerBandIndicator bollinger =
        indicator as BollingerBandIndicator;

    renderer
      ..closeValueMapper = bollinger.closeValueMapper
      ..standardDeviation = bollinger.standardDeviation
      ..upperLineColor = bollinger.upperLineColor
      ..upperLineWidth = bollinger.upperLineWidth
      ..lowerLineColor = bollinger.lowerLineColor
      ..lowerLineWidth = bollinger.lowerLineWidth
      ..bandColor = bollinger.bandColor
      ..period = bollinger.period;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, BollingerIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final BollingerBandIndicator bollinger =
        indicator as BollingerBandIndicator;

    renderObject
      ..closeValueMapper = bollinger.closeValueMapper
      ..standardDeviation = bollinger.standardDeviation
      ..upperLineColor = bollinger.upperLineColor
      ..upperLineWidth = bollinger.upperLineWidth
      ..lowerLineColor = bollinger.lowerLineColor
      ..lowerLineWidth = bollinger.lowerLineWidth
      ..bandColor = bollinger.bandColor
      ..period = bollinger.period;
  }
}

class BollingerIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  final List<Offset> _signalLineActualValues = <Offset>[];
  final List<Offset> _lowerLineActualValues = <Offset>[];
  final List<Offset> _upperLineActualValues = <Offset>[];
  final List<Offset> _upperBandActualValues = <Offset>[];
  final List<Offset> _lowerBandActualValues = <Offset>[];

  final List<Offset> _upperLinePoints = <Offset>[];
  final List<Offset> _lowerLinePoints = <Offset>[];
  final Path _upperLinePath = Path();
  final Path _lowerLinePath = Path();
  final Path _bandPath = Path();
  List<num> _closeValues = <num>[];

  final List<CartesianChartPoint<D>> _upperLineChartPoints =
      <CartesianChartPoint<D>>[];
  final List<CartesianChartPoint<D>> _lowerLineChartPoints =
      <CartesianChartPoint<D>>[];

  int get standardDeviation => _standardDeviation;
  int _standardDeviation = 2;
  set standardDeviation(int value) {
    if (_standardDeviation != value) {
      _standardDeviation = value;
      markNeedsPopulateAndLayout();
    }
  }

  Color get upperLineColor => _upperLineColor;
  Color _upperLineColor = Colors.red;
  set upperLineColor(Color value) {
    if (_upperLineColor != value) {
      _upperLineColor = value;
      markNeedsPaint();
    }
  }

  double get upperLineWidth => _upperLineWidth;
  double _upperLineWidth = 2;
  set upperLineWidth(double value) {
    if (_upperLineWidth != value) {
      _upperLineWidth = value;
      markNeedsPaint();
    }
  }

  Color get lowerLineColor => _lowerLineColor;
  Color _lowerLineColor = Colors.green;
  set lowerLineColor(Color value) {
    if (_lowerLineColor != value) {
      _lowerLineColor = value;
      markNeedsPaint();
    }
  }

  double get lowerLineWidth => _lowerLineWidth;
  double _lowerLineWidth = 2;
  set lowerLineWidth(double value) {
    if (_lowerLineWidth != value) {
      _lowerLineWidth = value;
      markNeedsPaint();
    }
  }

  Color get bandColor => _bandColor;
  Color _bandColor = const Color(0x409e9e9e);
  set bandColor(Color value) {
    if (_bandColor != value) {
      _bandColor = value;
      markNeedsPaint();
    }
  }

  int get period => _period;
  int _period = 14;
  set period(int value) {
    if (_period != value) {
      _period = value;
      markNeedsPopulateAndLayout();
    }
  }

  @override
  void populateDataSource([
    List<T>? seriesDataSource,
    ChartIndexedValueMapper<D>? xPath,
    List<num>? xList,
    List<ChartIndexedValueMapper<num?>?>? yPaths,
    List<List<num>?>? yList,
  ]) {
    if (dataSource != null) {
      super.populateDataSource(
        dataSource,
        xValueMapper,
        xValues,
        <ChartIndexedValueMapper<num?>?>[closeValueMapper],
        <List<num>>[_closeValues],
      );
    } else {
      if (seriesName != null) {
        if (dependent is FinancialSeriesRendererBase<T, D>) {
          final FinancialSeriesRendererBase<T, D> series =
              dependent! as FinancialSeriesRendererBase<T, D>;
          seriesDataSource = series.dataSource;
          xValues = series.xValues;
          xRawValues = series.xRawValues;
          _closeValues = series.closeValues;
          dataCount = xValues.length;
        }
      }
    }

    if (period > 0) {
      _signalLineActualValues.clear();
      _lowerLineActualValues.clear();
      _upperLineActualValues.clear();
      _upperBandActualValues.clear();
      _lowerBandActualValues.clear();
      _calculateBollingerBandsValues();
    }

    populateChartPoints();
  }

  void _calculateBollingerBandsValues() {
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    final bool enableBand = bandColor != Colors.transparent;
    final List<num> lowBands = List<num>.filled(dataCount, -1);
    final List<num> midBands = List<num>.filled(dataCount, -1);
    final List<num> upperBands = List<num>.filled(dataCount, -1);

    if (dataCount >= period && period > 0) {
      num sum = 0;
      num deviationSum = 0;
      final num multiplier = standardDeviation;
      final int length = period;
      final List<num> smaPoints = List<num>.filled(dataCount, -1);
      final List<num> deviations = List<num>.filled(dataCount, -1);

      for (int i = 0; i < length; i++) {
        sum += _closeValues[i];
      }

      num sma = sum / period;
      for (int j = 0; j < dataCount; j++) {
        final num y = _closeValues[j];
        if (j >= length - 1 && j < dataCount) {
          if (j - period >= 0) {
            final num diff = y - _closeValues[j - length];
            sum = sum + diff;
            sma = sum / period;
            smaPoints[j] = sma;
            deviations[j] = pow(y - sma, 2);
            deviationSum += deviations[j] - deviations[j - length];
          } else {
            smaPoints[j] = sma;
            deviations[j] = pow(y - sma, 2);
            deviationSum += deviations[j];
          }

          final num range = sqrt(deviationSum / period);
          final num lowerBand = smaPoints[j] - (multiplier * range);
          final num upperBand = smaPoints[j] + (multiplier * range);
          if (j + 1 == length) {
            for (int k = 0; k < length - 1; k++) {
              midBands[k] = smaPoints[j];
              lowBands[k] = lowerBand.isNaN || lowerBand.isInfinite
                  ? smaPoints[j]
                  : lowerBand;
              upperBands[k] = upperBand.isNaN || upperBand.isInfinite
                  ? smaPoints[j]
                  : upperBand;
            }
          }
          midBands[j] = smaPoints[j];
          lowBands[j] = lowerBand.isNaN || lowerBand.isInfinite
              ? smaPoints[j]
              : lowerBand;
          upperBands[j] = upperBand.isNaN || upperBand.isInfinite
              ? smaPoints[j]
              : upperBand;
        } else {
          if (j < period - 1) {
            smaPoints[j] = sma;
            deviations[j] = pow(y - sma, 2);
            deviationSum += deviations[j];
          }
        }
      }

      int l = -1;
      int m = -1;
      for (int n = 0; n < dataCount; n++) {
        if (n >= (length - 1)) {
          final double x = xValues[n].toDouble();
          final double upper = upperBands[n].toDouble();
          final double middle = midBands[n].toDouble();
          final double lower = lowBands[n].toDouble();

          final double minY = min(middle, min(upper, lower));
          final double maxY = max(middle, max(upper, lower));

          xMinimum = min(xMinimum, x);
          xMaximum = max(xMaximum, x);
          yMinimum = min(yMinimum, minY);
          yMaximum = max(yMaximum, maxY);

          _upperLineActualValues.add(Offset(x, upper));
          _lowerLineActualValues.add(Offset(x, lower));
          _signalLineActualValues.add(Offset(x, middle));
          if (enableBand) {
            _upperBandActualValues
                .add(Offset(x, _upperLineActualValues[++l].dy));
            _lowerBandActualValues
                .add(Offset(x, _lowerLineActualValues[++m].dy));
          }
        }
      }
    }

    xMin = xMinimum.isInfinite ? xMin : xMinimum;
    xMax = xMaximum.isInfinite ? xMax : xMaximum;
    yMin = yMinimum.isInfinite ? yMin : yMinimum;
    yMax = yMaximum.isInfinite ? yMax : yMaximum;
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    yLists = <List<num>>[_closeValues];
    positions = <ChartDataPointType>[ChartDataPointType.close];

    chartPoints.clear();
    _upperLineChartPoints.clear();
    _lowerLineChartPoints.clear();

    if (parent == null || yLists.isEmpty) {
      return;
    }

    if (onRenderDetailsUpdate == null) {
      return;
    }

    final int yLength = yLists.length;
    if (positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final num xValue = xValues[i];
      final CartesianChartPoint<D> point =
          CartesianChartPoint<D>(x: xRawValues[i], xValue: xValue);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      chartPoints.add(point);
    }

    if (_upperLineActualValues.isNotEmpty) {
      final int length = _upperLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final CartesianChartPoint<D> point = CartesianChartPoint<D>(
          x: xRawValues[i],
          xValue: _upperLineActualValues[i].dx,
          y: _upperLineActualValues[i].dy,
        );
        _upperLineChartPoints.add(point);
      }
    }

    if (_lowerLineActualValues.isNotEmpty) {
      final int length = _lowerLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final CartesianChartPoint<D> point = CartesianChartPoint<D>(
          x: xRawValues[i],
          xValue: _lowerLineActualValues[i].dx,
          y: _lowerLineActualValues[i].dy,
        );
        _lowerLineChartPoints.add(point);
      }
    }
  }

  @override
  String defaultLegendItemText() => 'Bollinger';

  @override
  Color effectiveLegendIconColor() {
    return signalLineColor;
  }

  @override
  void transformValues() {
    signalLinePoints.clear();
    _upperLinePoints.clear();
    _lowerLinePoints.clear();
    _bandPath.reset();

    if (_upperLineActualValues.isNotEmpty) {
      final int length = _upperLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final Offset upper = _upperLineActualValues[i];
        _upperLinePoints.add(Offset(
          pointToPixelX(upper.dx, upper.dy),
          pointToPixelY(upper.dx, upper.dy),
        ));
      }
    }

    if (_lowerLineActualValues.isNotEmpty) {
      final int length = _lowerLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final Offset lower = _lowerLineActualValues[i];
        _lowerLinePoints.add(Offset(
          pointToPixelX(lower.dx, lower.dy),
          pointToPixelY(lower.dx, lower.dy),
        ));
      }
    }

    if (_signalLineActualValues.isNotEmpty) {
      final int length = _signalLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final Offset signal = _signalLineActualValues[i];
        signalLinePoints.add(Offset(
          pointToPixelX(signal.dx, signal.dy),
          pointToPixelY(signal.dx, signal.dy),
        ));
      }
    }

    if (bandColor != Colors.transparent && _upperBandActualValues.isNotEmpty) {
      final Offset upperStart = _upperBandActualValues[0];
      double rangeX = pointToPixelX(upperStart.dx, upperStart.dy);
      double rangeY = pointToPixelY(upperStart.dx, upperStart.dy);
      _bandPath.moveTo(rangeX, rangeY);

      final int upperLength = _upperBandActualValues.length;
      for (int i = 0; i < upperLength; i++) {
        final Offset upper = _upperBandActualValues[i];
        final num x = upper.dx;
        final num high = upper.dy;
        rangeX = pointToPixelX(x, high);
        rangeY = pointToPixelY(x, high);
        _bandPath.lineTo(rangeX, rangeY);
      }

      final int lowerLastIndex = _lowerBandActualValues.length - 1;
      for (int j = lowerLastIndex; j >= 0; j--) {
        final Offset lower = _lowerBandActualValues[j];
        final num x = lower.dx;
        final num low = lower.dy;
        rangeX = pointToPixelX(x, low);
        rangeY = pointToPixelY(x, low);
        _bandPath.lineTo(rangeX, rangeY);
      }

      _bandPath.close();
    }
  }

  @override
  List<TrackballInfo>? trackballInfo(Offset position) {
    final List<ChartTrackballInfo<T, D>> trackballInfo =
        <ChartTrackballInfo<T, D>>[];
    if (signalLineWidth > 0) {
      final int nearestPointIndex =
          _findNearestPoint(signalLinePoints, position);
      if (nearestPointIndex != -1) {
        final CartesianChartPoint<D> bollingerPoint =
            _chartPoint(nearestPointIndex, 'bollinger');
        final String bollingerText = defaultLegendItemText();
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: signalLinePoints[nearestPointIndex],
            point: bollingerPoint,
            series: this,
            pointIndex: nearestPointIndex,
            segmentIndex: nearestPointIndex,
            seriesIndex: index,
            name: bollingerText,
            header: tooltipHeaderText(bollingerPoint),
            text: trackballText(bollingerPoint, bollingerText),
            color: signalLineColor,
          ),
        );
      }
    }
    if (upperLineWidth > 0) {
      final int upperPointIndex = _findNearestPoint(_upperLinePoints, position);
      if (upperPointIndex != -1) {
        final CartesianChartPoint<D> upperPoint =
            _chartPoint(upperPointIndex, 'upper');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _upperLinePoints[upperPointIndex],
            point: upperPoint,
            series: this,
            pointIndex: upperPointIndex,
            segmentIndex: upperPointIndex,
            seriesIndex: index,
            name: trackballUpperLineText,
            header: tooltipHeaderText(upperPoint),
            text: trackballText(upperPoint, trackballUpperLineText),
            color: _upperLineColor,
          ),
        );
      }
    }
    if (lowerLineWidth > 0) {
      final int lowerPointIndex = _findNearestPoint(_lowerLinePoints, position);
      if (lowerPointIndex != -1) {
        final CartesianChartPoint<D> lowerPoint =
            _chartPoint(lowerPointIndex, 'lower');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _lowerLinePoints[lowerPointIndex],
            point: lowerPoint,
            series: this,
            pointIndex: lowerPointIndex,
            segmentIndex: lowerPointIndex,
            seriesIndex: index,
            name: trackballLowerLineText,
            header: tooltipHeaderText(lowerPoint),
            text: trackballText(lowerPoint, trackballLowerLineText),
            color: _lowerLineColor,
          ),
        );
      }
    }
    return trackballInfo;
  }

  int _findNearestPoint(List<Offset> points, Offset position) {
    double delta = 0;
    num? nearPointX;
    num? nearPointY;
    int? pointIndex;
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      nearPointX ??= points[0].dx;
      nearPointY ??= yAxis!.visibleRange!.minimum;

      final num touchXValue = position.dx;
      final num touchYValue = position.dy;
      final double curX = points[i].dx;
      final double curY = points[i].dy;
      if (isTransposed) {
        if (delta == touchYValue - curY) {
          pointIndex = i;
        } else if ((touchYValue - curY).abs() <=
            (touchYValue - nearPointY).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchYValue - curY;
          pointIndex = i;
        }
      } else {
        if (delta == touchXValue - curX) {
          pointIndex = i;
        } else if ((touchXValue - curX).abs() <=
            (touchXValue - nearPointX).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchXValue - curX;
          pointIndex = i;
        }
      }
    }
    return pointIndex ?? -1;
  }

  CartesianChartPoint<D> _chartPoint(int pointIndex, String type) {
    return CartesianChartPoint<D>(
      x: xRawValues[pointIndex + period - 1],
      xValue: xValues[pointIndex + period - 1],
      y: type == 'bollinger'
          ? _signalLineActualValues[pointIndex].dy
          : type == 'upper'
              ? _upperLineActualValues[pointIndex].dy
              : _lowerLineActualValues[pointIndex].dy,
    );
  }

  @override
  void customizeIndicator() {
    if (onRenderDetailsUpdate != null) {
      final BollingerBandIndicatorRenderParams params =
          BollingerBandIndicatorRenderParams(
        _upperLineChartPoints,
        _lowerLineChartPoints,
        chartPoints,
        legendItemText ?? name ?? defaultLegendItemText(),
        signalLineWidth,
        signalLineColor,
        dashArray,
      );
      final TechnicalIndicatorRenderDetails details =
          onRenderDetailsUpdate!(params);
      strokePaint
        ..color = details.signalLineColor
        ..strokeWidth = details.signalLineWidth;
      _dashArray = details.signalLineDashArray;
    } else {
      strokePaint
        ..color = signalLineColor
        ..strokeWidth = signalLineWidth;
      _dashArray = dashArray;
    }
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);

    if (bandColor != Colors.transparent) {
      context.canvas.drawPath(_bandPath, Paint()..color = bandColor);
    }

    int length = 0;
    if (signalLinePoints.isNotEmpty) {
      length = signalLinePoints.length - 1;
      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        for (int i = 0; i < length; i++) {
          drawDashes(
            context.canvas,
            _dashArray,
            strokePaint,
            start: signalLinePoints[i],
            end: signalLinePoints[i + 1],
          );
        }
      }
    }

    // Draw upper line.
    if (_upperLinePoints.isNotEmpty &&
        upperLineWidth > 0 &&
        upperLineColor != Colors.transparent) {
      _upperLinePath.reset();
      length = _upperLinePoints.length;

      _upperLinePath.moveTo(
          _upperLinePoints.first.dx, _upperLinePoints.first.dy);
      for (int i = 1; i < length; i++) {
        final Offset upper = _upperLinePoints[i];
        _upperLinePath.lineTo(upper.dx, upper.dy);
      }

      drawDashes(
          context.canvas,
          _dashArray,
          strokePaint
            ..color = upperLineColor
            ..strokeWidth = upperLineWidth,
          path: _upperLinePath);
    }

    // Draw lower line.
    if (_lowerLinePoints.isNotEmpty &&
        lowerLineWidth > 0 &&
        lowerLineColor != Colors.transparent) {
      _lowerLinePath.reset();
      length = _lowerLinePoints.length;

      _lowerLinePath.moveTo(
          _lowerLinePoints.first.dx, _lowerLinePoints.first.dy);
      for (int i = 1; i < length; i++) {
        final Offset lower = _lowerLinePoints[i];
        _lowerLinePath.lineTo(lower.dx, lower.dy);
      }

      drawDashes(
          context.canvas,
          _dashArray,
          strokePaint
            ..color = lowerLineColor
            ..strokeWidth = lowerLineWidth,
          path: _lowerLinePath);
    }
    context.canvas.restore();
  }

  @override
  void dispose() {
    _signalLineActualValues.clear();
    _lowerLineActualValues.clear();
    _upperLineActualValues.clear();
    _upperBandActualValues.clear();
    _lowerBandActualValues.clear();
    _closeValues.clear();
    _upperLinePoints.clear();
    _lowerLinePoints.clear();
    _upperLinePath.reset();
    _lowerLinePath.reset();
    _bandPath.reset();
    _upperLineChartPoints.clear();
    _lowerLineChartPoints.clear();
    super.dispose();
  }
}
