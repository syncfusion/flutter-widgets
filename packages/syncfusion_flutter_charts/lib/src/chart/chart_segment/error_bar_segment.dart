import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import 'chart_segment.dart';

/// Segment class for error bar.
class ErrorBarSegment extends ChartSegment {
  final double _effectiveAnimationFactor = 0.05;
  late SegmentProperties _segmentProperties;
  bool _isInitialize = false;
  late double _errorBarMidPointX;
  late double _errorBarMidPointY;
  late double _capPointValue;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    strokePaint = Paint()
      ..color = _segmentProperties.color!
          .withOpacity(_segmentProperties.series.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _segmentProperties.series.width!;
    _segmentProperties.defaultStrokeColor = strokePaint;
    setShader(_segmentProperties, strokePaint!);
    return strokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final ErrorBarSeries<dynamic, dynamic> errorBarSeries =
        _segmentProperties.series as ErrorBarSeries<dynamic, dynamic>;
    _animateErrorBar(
        canvas,
        strokePaint!,
        _segmentProperties.currentPoint!,
        animationFactor,
        _segmentProperties.seriesRenderer,
        errorBarSeries.capLength!,
        errorBarSeries.dashArray);
  }

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }

  /// To animate error bar.
  void _animateErrorBar(
      Canvas canvas,
      Paint errorBarPaint,
      CartesianChartPoint<dynamic> point,
      double animationFactor,
      CartesianSeriesRenderer seriesRenderer,
      double capLength,
      List<double> dashArray) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (animationFactor != 0) {
      animationFactor = (!seriesRendererDetails.reAnimate &&
              !seriesRendererDetails
                  .stateProperties.renderingDetails.initialRender! &&
              seriesRendererDetails.series.key != null &&
              seriesRendererDetails.stateProperties.oldSeriesKeys
                  .contains(seriesRendererDetails.series.key))
          ? 1
          : animationFactor;

      final bool isTransposedChart = seriesRendererDetails.chart.isTransposed;
      _errorBarMidPointX = point.currentPoint!.x;
      _errorBarMidPointY = point.currentPoint!.y;

      double animatingPoint;
      if (point.verticalPositiveErrorPoint != null) {
        animatingPoint = isTransposedChart
            ? _errorBarMidPointX +
                ((point.verticalPositiveErrorPoint!.x - _errorBarMidPointX) *
                    _effectiveAnimationFactor)
            : _errorBarMidPointY -
                ((_errorBarMidPointY - point.verticalPositiveErrorPoint!.y) *
                    _effectiveAnimationFactor);

        _capPointValue = animatingPoint -
            ((animatingPoint -
                    (isTransposedChart
                        ? point.verticalPositiveErrorPoint!.x
                        : point.verticalPositiveErrorPoint!.y)) *
                animationFactor);

        _verticalErrorBarRendering(canvas, errorBarPaint, _capPointValue,
            animationFactor, capLength, dashArray, isTransposedChart);
      }
      if (point.verticalNegativeErrorPoint != null) {
        animatingPoint = isTransposedChart
            ? _errorBarMidPointX +
                ((point.verticalNegativeErrorPoint!.x - _errorBarMidPointX) *
                    _effectiveAnimationFactor)
            : _errorBarMidPointY +
                ((point.verticalNegativeErrorPoint!.y - _errorBarMidPointY) *
                    _effectiveAnimationFactor);

        _capPointValue = animatingPoint +
            (((isTransposedChart
                        ? point.verticalNegativeErrorPoint!.x
                        : point.verticalNegativeErrorPoint!.y) -
                    animatingPoint) *
                animationFactor);

        _verticalErrorBarRendering(canvas, errorBarPaint, _capPointValue,
            animationFactor, capLength, dashArray, isTransposedChart);
      }
      if (point.horizontalPositiveErrorPoint != null) {
        animatingPoint = isTransposedChart
            ? _errorBarMidPointY -
                ((_errorBarMidPointY - point.horizontalPositiveErrorPoint!.y) *
                    _effectiveAnimationFactor)
            : _errorBarMidPointX +
                ((point.horizontalPositiveErrorPoint!.x - _errorBarMidPointX) *
                    _effectiveAnimationFactor);

        _capPointValue = animatingPoint +
            (((isTransposedChart
                        ? point.horizontalPositiveErrorPoint!.y
                        : point.horizontalPositiveErrorPoint!.x) -
                    animatingPoint) *
                animationFactor);

        _horizontalErrorBarRendering(canvas, errorBarPaint, _capPointValue,
            animationFactor, capLength, dashArray, isTransposedChart);
      }
      if (point.horizontalNegativeErrorPoint != null) {
        animatingPoint = isTransposedChart
            ? _errorBarMidPointY +
                ((point.horizontalNegativeErrorPoint!.y - _errorBarMidPointY) *
                    _effectiveAnimationFactor)
            : _errorBarMidPointX -
                ((_errorBarMidPointX - point.horizontalNegativeErrorPoint!.x) *
                    _effectiveAnimationFactor);

        _capPointValue = animatingPoint -
            ((animatingPoint -
                    (isTransposedChart
                        ? point.horizontalNegativeErrorPoint!.y
                        : point.horizontalNegativeErrorPoint!.x)) *
                animationFactor);

        _horizontalErrorBarRendering(canvas, errorBarPaint, _capPointValue,
            animationFactor, capLength, dashArray, isTransposedChart);
      }
    }
  }

  /// Animating vertical error bar.
  void _verticalErrorBarRendering(
      Canvas canvas,
      Paint errorBarPaint,
      double capPointValue,
      double animationFactor,
      double capLength,
      List<double> dashArray,
      bool isTransposedChart) {
    final Path verticalPath = Path();
    final Path capPath = Path();
    if (isTransposedChart) {
      verticalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      verticalPath.lineTo(capPointValue, _errorBarMidPointY);
      capPath.moveTo(capPointValue, _errorBarMidPointY - (capLength / 2));
      capPath.lineTo(capPointValue, _errorBarMidPointY + (capLength / 2));
    } else {
      verticalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      verticalPath.lineTo(_errorBarMidPointX, capPointValue);
      capPath.moveTo(_errorBarMidPointX - (capLength / 2), capPointValue);
      capPath.lineTo(_errorBarMidPointX + (capLength / 2), capPointValue);
    }
    verticalPath.close();
    capPath.close();

    // ignore: unnecessary_null_comparison
    if (dashArray != null) {
      // Draws vertical line of the error bar.
      drawDashedLine(canvas, dashArray, errorBarPaint, verticalPath);
      // Draws cap of the error bar.
      drawDashedLine(canvas, dashArray, errorBarPaint, capPath);
    } else {
      canvas.drawPath(verticalPath, errorBarPaint);
      canvas.drawPath(capPath, errorBarPaint);
    }
  }

  /// Animating horizontal error bar.
  void _horizontalErrorBarRendering(
      Canvas canvas,
      Paint errorBarPaint,
      double capPointValue,
      double animationFactor,
      double capLength,
      List<double> dashArray,
      bool isTransposedChart) {
    final Path horizontalPath = Path();
    final Path horizontalCapPath = Path();
    if (isTransposedChart) {
      horizontalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      horizontalPath.lineTo(_errorBarMidPointX, capPointValue);
      horizontalCapPath.moveTo(
          _errorBarMidPointX - (capLength / 2), capPointValue);
      horizontalCapPath.lineTo(
          _errorBarMidPointX + (capLength / 2), capPointValue);
    } else {
      horizontalPath.moveTo(_errorBarMidPointX, _errorBarMidPointY);
      horizontalPath.lineTo(capPointValue, _errorBarMidPointY);
      horizontalCapPath.moveTo(
        capPointValue,
        _errorBarMidPointY - (capLength / 2),
      );
      horizontalCapPath.lineTo(
        capPointValue,
        _errorBarMidPointY + (capLength / 2),
      );
    }
    horizontalPath.close();
    horizontalCapPath.close();

    // ignore: unnecessary_null_comparison
    if (dashArray != null) {
      // Draws horizontal line of the error bar.
      drawDashedLine(canvas, dashArray, errorBarPaint, horizontalPath);
      // Draws cap of the error bar.
      drawDashedLine(canvas, dashArray, errorBarPaint, horizontalCapPath);
    } else {
      canvas.drawPath(horizontalPath, errorBarPaint);
      canvas.drawPath(horizontalCapPath, errorBarPaint);
    }
  }
}
