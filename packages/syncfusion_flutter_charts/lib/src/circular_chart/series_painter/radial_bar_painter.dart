import 'package:flutter/material.dart';
import '../../common/event_args.dart';
import '../base/circular_state_properties.dart';
import '../renderer/chart_point.dart';
import '../renderer/common.dart';
import '../renderer/radial_bar_series.dart';
import '../renderer/renderer_extension.dart';
import '../utils/helper.dart';

/// Represents the pointer to draw radial bar series.
class RadialBarPainter extends CustomPainter {
  /// Creates the instance for radial bar series.
  RadialBarPainter({
    required this.stateProperties,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    ValueNotifier<num>? notifier,
  }) : super(repaint: notifier);

  /// Specifies the value of circular state properties.
  final CircularStateProperties stateProperties;

  /// Holds the index value.
  final int index;

  /// Specifies whether to repaint the series.
  final bool isRepaint;

  /// Specifies the value of animation controller.
  final AnimationController? animationController;

  /// Specifies the value of series animation.
  final Animation<double>? seriesAnimation;

  /// Holds the value of radial bar series extension.
  late RadialBarSeriesRendererExtension seriesRenderer;
  late num _length, _sum, _ringSize, _animationValue, _actualStartAngle;
  late int? _firstVisible;
  late num? _gap;
  late bool _isLegendToggle;
  late RadialBarSeriesRendererExtension? _oldSeriesRenderer;

  /// Specifies the value of actual length.
  late double actualDegree;

  /// Method to get length of the visible point.
  num _getLength(Canvas canvas) {
    num length = 0;
    seriesRenderer = stateProperties.chartSeries.visibleSeriesRenderers[index]
        as RadialBarSeriesRendererExtension;
    seriesRenderer.pointRegions = <Region>[];
    seriesRenderer.innerRadius =
        seriesRenderer.segmentRenderingValues['currentInnerRadius']!;
    seriesRenderer.radius =
        seriesRenderer.segmentRenderingValues['currentRadius']!;
    seriesRenderer.center = seriesRenderer.center!;
    canvas.clipRect(stateProperties.renderingDetails.chartAreaRect);

    // finding visible points count
    for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
      length += seriesRenderer.renderPoints![i].isVisible ? 1 : 0;
    }
    return length;
  }

  /// Method to initialize the values to draw the radial bar series.
  void _initializeValues(Canvas canvas) {
    _length = _getLength(canvas);
    _sum = seriesRenderer.segmentRenderingValues['sumOfPoints']!;
    _actualStartAngle = seriesRenderer.segmentRenderingValues['start']!;

    // finding first visible point
    _firstVisible = seriesRenderer.getFirstVisiblePointIndex(seriesRenderer);
    _ringSize = (seriesRenderer.segmentRenderingValues['currentRadius']! -
                seriesRenderer.segmentRenderingValues['currentInnerRadius']!)
            .abs() /
        _length;
    _gap = percentToValue(
        seriesRenderer.series.gap,
        (seriesRenderer.segmentRenderingValues['currentRadius']! -
                seriesRenderer.segmentRenderingValues['currentInnerRadius']!)
            .abs());
    _animationValue = seriesAnimation?.value ?? 1;
    _isLegendToggle = stateProperties.renderingDetails.isLegendToggled;
    _oldSeriesRenderer = (stateProperties.renderingDetails.widgetNeedUpdate &&
            !stateProperties.renderingDetails.isLegendToggled &&
            stateProperties.prevSeriesRenderer!.seriesType == 'radialbar')
        ? stateProperties.prevSeriesRenderer!
            as RadialBarSeriesRendererExtension
        : null;
    seriesRenderer.renderPaths.clear();
  }

  /// Method to paint radial bar series.
  @override
  void paint(Canvas canvas, Size size) {
    num? pointStartAngle, pointEndAngle, degree;
    ChartPoint<dynamic>? oldPoint;
    late ChartPoint<dynamic> point;
    _initializeValues(canvas);
    late RadialBarSeries<dynamic, dynamic> series;
    num? oldStart, oldEnd, oldRadius, oldInnerRadius;
    late bool isDynamicUpdate, hide;
    seriesRenderer.shadowPaths.clear();
    seriesRenderer.overFilledPaths.clear();
    for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
      num? value;
      point = seriesRenderer.renderPoints![i];
      if (seriesRenderer.series is RadialBarSeries) {
        series = seriesRenderer.series as RadialBarSeries<dynamic, dynamic>;
      }
      oldPoint = (_oldSeriesRenderer != null &&
              _oldSeriesRenderer!.oldRenderPoints != null &&
              (_oldSeriesRenderer!.oldRenderPoints!.length - 1 >= i))
          ? _oldSeriesRenderer!.oldRenderPoints![i]
          : (_isLegendToggle ? stateProperties.oldPoints![i] : null);
      pointStartAngle = _actualStartAngle;
      isDynamicUpdate = oldPoint != null;
      hide = false;
      actualDegree = 0;
      if (!isDynamicUpdate ||
          ((oldPoint.isVisible && point.isVisible) ||
              (oldPoint.isVisible && !point.isVisible) ||
              (!oldPoint.isVisible && point.isVisible))) {
        if (point.isVisible) {
          hide = false;
          if (isDynamicUpdate && !_isLegendToggle) {
            value = (point.y! > oldPoint.y!)
                ? oldPoint.y! + (point.y! - oldPoint.y!) * _animationValue
                : oldPoint.y! - (oldPoint.y! - point.y!) * _animationValue;
          }
          degree = (value ?? point.y!).abs() / (series.maximumValue ?? _sum);
          degree = degree * (360 - 0.001);
          actualDegree = degree.toDouble();
          degree = isDynamicUpdate ? degree : degree * _animationValue;
          pointEndAngle = pointStartAngle + degree;
          point.midAngle = (pointStartAngle + pointEndAngle) / 2;
          point.startAngle = pointStartAngle;
          point.endAngle = pointEndAngle;
          point.center = seriesRenderer.center!;
          point.innerRadius = seriesRenderer.innerRadius =
              seriesRenderer.innerRadius +
                  ((i == _firstVisible) ? 0 : _ringSize) -
                  (series.trackBorderWidth / 2) / series.dataSource!.length;
          point.outerRadius = seriesRenderer.radius = _ringSize < _gap!
              ? 0
              : seriesRenderer.innerRadius +
                  _ringSize -
                  _gap! -
                  (series.trackBorderWidth / 2) / series.dataSource!.length;
          if (_isLegendToggle) {
            seriesRenderer.calculateVisiblePointLegendToggleAnimation(
                point, oldPoint, i, _animationValue);
          }
        } //animate on hiding
        else if (_isLegendToggle && !point.isVisible && oldPoint!.isVisible) {
          hide = true;
          oldEnd = oldPoint.endAngle;
          oldStart = oldPoint.startAngle;
          degree = oldPoint.y!.abs() / (series.maximumValue ?? _sum);
          degree = degree * (360 - 0.001);
          actualDegree = degree.toDouble();
          oldInnerRadius = oldPoint.innerRadius! +
              ((oldPoint.outerRadius! + oldPoint.innerRadius!) / 2 -
                      oldPoint.innerRadius!) *
                  _animationValue;
          oldRadius = oldPoint.outerRadius! -
              (oldPoint.outerRadius! -
                      (oldPoint.outerRadius! + oldPoint.innerRadius!) / 2) *
                  _animationValue;
        }
        // ignore: unnecessary_type_check
        if (seriesRenderer is RadialBarSeriesRendererExtension) {
          seriesRenderer.drawDataPoint(
              point,
              degree,
              pointStartAngle,
              pointEndAngle,
              seriesRenderer,
              hide,
              oldRadius,
              oldInnerRadius,
              oldPoint,
              oldStart,
              oldEnd,
              i,
              canvas,
              index,
              stateProperties.chart,
              actualDegree);
        }
      }
    }

    _renderRadialBarSeries(canvas);
  }

  /// Method to render the radial bar series.
  void _renderRadialBarSeries(Canvas canvas) {
    if (seriesRenderer.renderList.isNotEmpty) {
      Shader? chartShader;
      if (stateProperties.chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails = ChartShaderDetails(seriesRenderer.renderList[1],
            seriesRenderer.renderList[2], 'series');
        chartShader = stateProperties.chart.onCreateShader!(chartShaderDetails);
      }

      for (int k = 0; k < seriesRenderer.renderPaths.length; k++) {
        drawPath(
            canvas,
            seriesRenderer.renderList[0],
            seriesRenderer.renderPaths[k],
            seriesRenderer.renderList[1],
            chartShader!);
      }

      for (int k = 0; k < seriesRenderer.shadowPaths.length; k++) {
        canvas.drawPath(
            seriesRenderer.shadowPaths[k], seriesRenderer.shadowPaint);
      }

      if (chartShader != null && seriesRenderer.overFilledPaint != null) {
        seriesRenderer.overFilledPaint!.shader = chartShader;
      }
      for (int k = 0; k < seriesRenderer.overFilledPaths.length; k++) {
        canvas.drawPath(
            seriesRenderer.overFilledPaths[k], seriesRenderer.overFilledPaint!);
      }

      if (seriesRenderer.renderList[0].strokeColor != null &&
          seriesRenderer.renderList[0].strokeWidth != null &&
          (seriesRenderer.renderList[0].strokeWidth > 0) == true) {
        final Paint paint = Paint();
        paint.color = seriesRenderer.renderList[0].strokeColor;
        paint.strokeWidth = seriesRenderer.renderList[0].strokeWidth;
        paint.style = PaintingStyle.stroke;
        for (int k = 0; k < seriesRenderer.renderPaths.length; k++) {
          canvas.drawPath(seriesRenderer.renderPaths[k], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
