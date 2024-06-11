import 'dart:math';

import 'package:flutter/material.dart';

import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'technical_indicator.dart';

/// This class holds the properties of the accumulation distribution indicator.
///
/// Accumulation distribution indicator is a volume-based indicator designed to
/// measure the accumulative flow of money into and out of a security.
/// It requires [volumeValueMapper] property additionally with the data source
/// to calculate the signal line.
///
/// It provides options for series visible, axis name, series name, animation
/// duration, legend visibility, signal line width, and color.
@immutable
class AccumulationDistributionIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of
  /// [AccumulationDistributionIndicator] class.
  AccumulationDistributionIndicator({
    super.isVisible,
    super.xAxisName,
    super.yAxisName,
    super.seriesName,
    super.dashArray,
    super.animationDuration,
    super.animationDelay,
    super.dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? highValueMapper,
    ChartValueMapper<T, num>? lowValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    ChartValueMapper<T, num>? volumeValueMapper,
    super.name,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.signalLineColor,
    super.signalLineWidth,
    super.onRenderDetailsUpdate,
  }) : super(
          xValueMapper: xValueMapper != null && dataSource != null
              ? (int index) => xValueMapper(dataSource[index], index)
              : null,
          highValueMapper: highValueMapper != null && dataSource != null
              ? (int index) => highValueMapper(dataSource[index], index)
              : null,
          lowValueMapper: lowValueMapper != null && dataSource != null
              ? (int index) => lowValueMapper(dataSource[index], index)
              : null,
          closeValueMapper: closeValueMapper != null && dataSource != null
              ? (int index) => closeValueMapper(dataSource[index], index)
              : null,
          volumeValueMapper: volumeValueMapper != null && dataSource != null
              ? (int index) => volumeValueMapper(dataSource[index], index)
              : null,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AccumulationDistributionIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.volumeValueMapper == volumeValueMapper &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth;
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
      highValueMapper,
      lowValueMapper,
      closeValueMapper,
      volumeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'AD';
}

class ADIndicatorWidget extends IndicatorWidget {
  const ADIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  /// Create the ADIndicatorRenderer renderer.
  @override
  ADIndicatorRenderer createRenderer() {
    return ADIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final ADIndicatorRenderer renderer =
        super.createRenderObject(context) as ADIndicatorRenderer;
    final AccumulationDistributionIndicator adi =
        indicator as AccumulationDistributionIndicator;

    renderer
      ..highValueMapper = adi.highValueMapper
      ..lowValueMapper = adi.lowValueMapper
      ..closeValueMapper = adi.closeValueMapper
      ..volumeValueMapper = adi.volumeValueMapper;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, ADIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final AccumulationDistributionIndicator adi =
        indicator as AccumulationDistributionIndicator;

    renderObject
      ..highValueMapper = adi.highValueMapper
      ..lowValueMapper = adi.lowValueMapper
      ..closeValueMapper = adi.closeValueMapper
      ..volumeValueMapper = adi.volumeValueMapper;
  }
}

class ADIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  final List<Offset> _signalLineActualValues = <Offset>[];
  List<num> _highValues = <num>[];
  List<num> _lowValues = <num>[];
  List<num> _closeValues = <num>[];
  List<num> _volumeValues = <num>[];

  ChartIndexedValueMapper<num?>? get volumeValueMapper => _volumeValueMapper;
  ChartIndexedValueMapper<num?>? _volumeValueMapper;
  set volumeValueMapper(ChartIndexedValueMapper<num?>? value) {
    if (_volumeValueMapper != value) {
      _volumeValueMapper = value;
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
        <ChartIndexedValueMapper<num?>?>[
          highValueMapper,
          lowValueMapper,
          closeValueMapper,
          volumeValueMapper,
        ],
        <List<num>>[_highValues, _lowValues, _closeValues, _volumeValues],
      );
    } else {
      if (seriesName != null) {
        if (dependent is FinancialSeriesRendererBase<T, D>) {
          final FinancialSeriesRendererBase<T, D> series =
              dependent! as FinancialSeriesRendererBase<T, D>;
          seriesDataSource = series.dataSource;
          xValues = series.xValues;
          xRawValues = series.xRawValues;
          _highValues = series.highValues;
          _lowValues = series.lowValues;
          _closeValues = series.closeValues;
          _volumeValues = series.volumeValues;
          dataCount = xValues.length;
        }
      }
    }

    _signalLineActualValues.clear();
    if (signalLineWidth > 0 &&
        _highValues.isNotEmpty &&
        _lowValues.isNotEmpty &&
        _closeValues.isNotEmpty) {
      _calculateSignalLineValues();
    }

    populateChartPoints();
  }

  void _calculateSignalLineValues() {
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;
    num sum = 0;
    for (int i = 0; i < dataCount; i++) {
      final num high = _highValues[i].isNaN ? 0 : _highValues[i];
      final num low = _lowValues[i].isNaN ? 0 : _lowValues[i];
      final num close = _closeValues[i].isNaN ? 0 : _closeValues[i];
      num value = ((close - low) - (high - close)) / (high - low);
      if (value.isNaN) {
        value = 0;
      }

      if (_volumeValues.isNotEmpty) {
        value *= _volumeValues[i];
      }
      sum += value;

      final double x = xValues[i].toDouble();
      final double y = sum.toDouble();
      xMinimum = min(xMinimum, x);
      xMaximum = max(xMaximum, x);
      yMinimum = min(yMinimum, y);
      yMaximum = max(yMaximum, y);
      _signalLineActualValues.add(Offset(x, y));
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
    yLists = <List<num>>[_highValues, _lowValues, _closeValues, _volumeValues];
    positions = <ChartDataPointType>[
      ChartDataPointType.high,
      ChartDataPointType.low,
      ChartDataPointType.close,
      ChartDataPointType.volume,
    ];
    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  String defaultLegendItemText() => 'AD';

  @override
  Color effectiveLegendIconColor() => signalLineColor;

  @override
  void transformValues() {
    signalLinePoints.clear();
    if (_signalLineActualValues.isNotEmpty) {
      final int length = _signalLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final num x = _signalLineActualValues[i].dx;
        final num y = _signalLineActualValues[i].dy;
        signalLinePoints.add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
      }
    }
  }

  @override
  List<TrackballInfo>? trackballInfo(Offset position) {
    final int nearestPointIndex = _findNearestPoint(signalLinePoints, position);
    if (nearestPointIndex != -1) {
      final CartesianChartPoint<D> chartPoint = _chartPoint(nearestPointIndex);
      final String text = defaultLegendItemText();
      return <ChartTrackballInfo<T, D>>[
        ChartTrackballInfo<T, D>(
          position: signalLinePoints[nearestPointIndex],
          point: chartPoint,
          series: this,
          seriesIndex: index,
          segmentIndex: nearestPointIndex,
          pointIndex: nearestPointIndex,
          name: text,
          header: tooltipHeaderText(chartPoint),
          text: trackballText(chartPoint, text),
          color: signalLineColor,
        ),
      ];
    }
    return null;
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

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: xRawValues[pointIndex],
      xValue: xValues[pointIndex],
      y: _signalLineActualValues[pointIndex].dy,
    );
  }

  @override
  void customizeIndicator() {
    if (onRenderDetailsUpdate != null) {
      final IndicatorRenderParams params = IndicatorRenderParams(
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
    if (signalLinePoints.isNotEmpty) {
      context.canvas.save();
      final Rect clip = clipRect(paintBounds, animationFactor,
          isInversed: xAxis!.isInversed, isTransposed: isTransposed);
      context.canvas.clipRect(clip);

      final int length = signalLinePoints.length - 1;
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

      context.canvas.restore();
    }
  }

  @override
  void dispose() {
    _highValues.clear();
    _lowValues.clear();
    _closeValues.clear();
    _volumeValues.clear();
    _signalLineActualValues.clear();
    super.dispose();
  }
}
