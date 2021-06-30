import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Apply the different marker pointer.
enum ShapeMarkerType {
  /// Draw a image.
  image,

  /// ShapeMarkerType.circle points the value with circle.
  circle,

  /// ShapeMarkerType.rectangle points the value with rectangle
  rectangle,

  /// ShapeMarkerType.diamond points the value with diamond.
  diamond,

  /// ShapeMarkerType.Triangle points the value with triangle.
  triangle,

  /// ShapeMarkerType.InvertedTriangle points the value with inverted triangle.
  invertedTriangle,

  /// ShapeMarkerType.VerticalTriangle points the value with triangle.
  verticalTriangle,

  /// ShapeMarkerType.VerticalInvertedTriangle points the value with triangle.
  verticalInvertedTriangle,

  /// ShapeMarkerType.pentagon points the value with pentagon.
  pentagon,

  /// ShapeMarkerType.verticalLine points the value with vertical line.
  verticalLine,

  /// ShapeMarkerType.horizontalLine points the value with horizontal line.
  horizontalLine,

  /// ShapeMarkerType.lineSeries which draws the line series shape.
  lineSeries,

  /// ShapeMarkerType.lineSeriesWithMarker which draws the
  /// line series shape with marker.
  lineSeriesWithMarker,

  /// ShapeMarkerType.fastLineSeries which draws the fast
  /// line series shape.
  fastLineSeries,

  /// ShapeMarkerType.fastLineSeriesWithMarker which draws the fast
  /// line series marker.
  fastLineSeriesWithMarker,

  /// ShapeMarkerType.stackedLineSeries which draws the stacked
  ///  line series shape.
  stackedLineSeries,

  /// ShapeMarkerType.stackedLineSeriesMarker which draws the stacked
  ///  line series marker.
  stackedLineSeriesWithMarker,

  /// ShapeMarkerType.stackedLine100Series which draws
  /// the stacked line 100 series shape.
  stackedLine100Series,

  /// ShapeMarkerType.stackedLine100SeriesWithMarker which draws
  /// the stacked line 100 series marker.
  stackedLine100SeriesWithMarker,

  /// ShapeMarkerType.splineSeries which draws the spline series marker.
  splineSeries,

  /// ShapeMarkerType.splineAreaSeries which draws the
  /// spline area series marker.
  splineAreaSeries,

  /// ShapeMarkerType.splineRangeAreaSeries which draws the
  /// spline range area series marker.
  splineRangeAreaSeries,

  /// ShapeMarkerType.areaSeriesType which draws the area series marker.
  areaSeries,

  /// ShapeMarkerType.stackedAreaSeries which draws the
  /// stacked area series marker.
  stackedAreaSeries,

  /// ShapeMarkerType.rangeAreaSeries which draws the
  /// range area series marker.
  rangeAreaSeries,

  /// ShapeMarkerType.stackedArea100Series which draws the
  /// stacked area 100 series marker.
  stackedArea100Series,

  /// ShapeMarkerType.stepAreaSeries which draws the
  /// step area series marker.
  stepAreaSeries,

  /// ShapeMarkerType.stepLineSeries which draws the
  /// step line series marker.
  stepLineSeries,

  /// ShapeMarkerType.bubbleSeries which draws the bubble series marker.
  bubbleSeries,

  /// ShapeMarkerType.columnSeries which draws the column series marker.
  columnSeries,

  /// ShapeMarkerType.stackedColumnSeries which draws the
  /// stacked column series marker.
  stackedColumnSeries,

  /// ShapeMarkerType.stackedColumn100Series which draws the
  /// stacked column 100 series marker.
  stackedColumn100Series,

  /// ShapeMarkerType.rangeColumnSeries which draws the
  /// range column series marker.
  rangeColumnSeries,

  /// ShapeMarkerType.histogramSeries which draws the
  /// histogram series marker.
  histogramSeries,

  /// ShapeMarkerType.barSeries which draws the bar series marker.
  barSeries,

  /// ShapeMarkerType.stackedBarSeries which draws the
  /// stacked bar series marker.
  stackedBarSeries,

  /// ShapeMarkerType.stackedBar100Series which draws the
  /// stacked bar 100 series marker.
  stackedBar100Series,

  /// ShapeMarkerType.hiloSeries which draws the hilo series marker.
  hiloSeries,

  /// ShapeMarkerType.hiloOpenCloseSeries which draws the
  /// hilo open close series marker.
  hiloOpenCloseSeries,

  /// ShapeMarkerType.candleSeries which draws the candle series marker.
  candleSeries,

  /// ShapeMarkerType.waterfallSeries which draws the
  /// waterfall series marker.
  waterfallSeries,

  /// ShapeMarkerType.boxAndWhiskerSeries which draws the
  /// box and whisker series marker.
  boxAndWhiskerSeries,

  /// ShapeMarkerType.pieSeries which draws the pie series marker.
  pieSeries,

  /// ShapeMarkerType.doughnutSeries which draws the doughnut
  /// series marker.
  doughnutSeries,

  /// ShapeMarkerType.radialBarSeries which draws the radial bar
  /// series marker.
  radialBarSeries,

  /// ShapeMarkerType.pyramidSeries which draws the pyramid series marker.
  pyramidSeries,

  /// ShapeMarkerType.funnelSeries which draws the funnel series marker.
  funnelSeries
}

/// Represents the Shape marker painter.
class ShapePainter {
  /// Draws the different marker shapes.
  static void paint(
      {required Canvas canvas,
      required Rect rect,
      required ShapeMarkerType shapeType,
      required Paint paint,
      Path? path,
      double? elevation,
      Color? elevationColor,
      Paint? borderPaint}) {
    _processShapes(
        canvas: canvas,
        rect: rect,
        shapeType: shapeType,
        paint: paint,
        path: path ?? Path(),
        borderPaint: borderPaint,
        isNeedToReturnPath: false,
        elevation: elevation,
        elevationColor: elevationColor);
  }

  /// Get the various shape path
  static Path getShapesPath(
      {Canvas? canvas,
      Paint? paint,
      Paint? borderPaint,
      required Rect rect,
      required ShapeMarkerType shapeType,
      Path? path,
      double? pentagonRotation = -pi / 2,
      double? radius,
      double? degree,
      double? startAngle,
      double? endAngle}) {
    return _processShapes(
        canvas: canvas ?? Canvas(PictureRecorder()),
        paint: paint ?? Paint(),
        borderPaint: borderPaint,
        rect: rect,
        path: path ?? Path(),
        shapeType: shapeType,
        isNeedToReturnPath: true,
        pentagonRotation: pentagonRotation,
        radius: radius,
        degree: degree,
        startAngle: startAngle,
        endAngle: endAngle);
  }

  static Path _processShapes(
      {required Canvas canvas,
      required Rect rect,
      required ShapeMarkerType shapeType,
      required Paint paint,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      Paint? borderPaint,
      double? pentagonRotation = -pi / 2,
      double? radius,
      double? degree,
      double? startAngle,
      double? endAngle}) {
    switch (shapeType) {
      case ShapeMarkerType.circle:
        return _processCircleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.rectangle:
        return _processRectangleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.diamond:
        return _processDiamondShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.triangle:
        return _processTriangleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.invertedTriangle:
        return _processInvertedTriangleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.verticalTriangle:
        return _processVerticalTriangleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.verticalInvertedTriangle:
        return _processVerticalInvertedTriangleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.pentagon:
        return _processPentagonShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            rotation: pentagonRotation,
            elevation: elevation,
            elevationColor: elevationColor,
            paint: paint,
            borderPaint: borderPaint);
      case ShapeMarkerType.verticalLine:
        return _processVerticalLineShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            borderPaint: borderPaint);
      case ShapeMarkerType.horizontalLine:
        return _processHorizontalLineShape(
            canvas: canvas,
            rect: rect,
            path: path,
            isNeedToReturnPath: isNeedToReturnPath,
            borderPaint: borderPaint);
      case ShapeMarkerType.lineSeries:
      case ShapeMarkerType.fastLineSeries:
      case ShapeMarkerType.stackedLineSeries:
      case ShapeMarkerType.stackedLine100Series:
        return _processLineShape(
            canvas: canvas,
            path: path,
            rect: rect,
            borderPaint: paint,
            isNeedToReturnPath: isNeedToReturnPath,
            isNeedMarker: false);
      case ShapeMarkerType.lineSeriesWithMarker:
      case ShapeMarkerType.fastLineSeriesWithMarker:
      case ShapeMarkerType.stackedLineSeriesWithMarker:
      case ShapeMarkerType.stackedLine100SeriesWithMarker:
        return _processLineShape(
            canvas: canvas,
            path: path,
            rect: rect,
            borderPaint: paint,
            isNeedToReturnPath: isNeedToReturnPath,
            isNeedMarker: true);
      case ShapeMarkerType.splineSeries:
        return _processSplineShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.splineAreaSeries:
      case ShapeMarkerType.splineRangeAreaSeries:
        return _processSplineAreaShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.areaSeries:
      case ShapeMarkerType.stackedAreaSeries:
      case ShapeMarkerType.rangeAreaSeries:
      case ShapeMarkerType.stackedArea100Series:
        return _processAreaShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.stepAreaSeries:
        return _processStepAreaShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.stepLineSeries:
        return _processStepLineShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.bubbleSeries:
        return _processBubbleShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.columnSeries:
      case ShapeMarkerType.stackedColumnSeries:
      case ShapeMarkerType.stackedColumn100Series:
      case ShapeMarkerType.rangeColumnSeries:
      case ShapeMarkerType.histogramSeries:
        return _processColumnShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.barSeries:
      case ShapeMarkerType.stackedBarSeries:
      case ShapeMarkerType.stackedBar100Series:
        return _processBarShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.hiloSeries:
        return _processHiloShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.hiloOpenCloseSeries:
      case ShapeMarkerType.candleSeries:
        return _processHiloOpenCloseShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.waterfallSeries:
      case ShapeMarkerType.boxAndWhiskerSeries:
        return _processWaterfallShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.pieSeries:
        return _processPieShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.doughnutSeries:
        return _processDoughnutShape(
            canvas: canvas,
            rect: rect,
            radius: radius!,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.radialBarSeries:
        return _processRadialBarShape(
            rect: rect,
            canvas: canvas,
            radius: radius,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            degree: degree,
            isNeedToReturnPath: isNeedToReturnPath,
            startAngle: startAngle,
            endAngle: endAngle);
      case ShapeMarkerType.pyramidSeries:
        return _processPyramidShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.funnelSeries:
        return _processFunnelShape(
            canvas: canvas,
            rect: rect,
            path: path,
            paint: paint,
            borderPaint: borderPaint,
            isNeedToReturnPath: isNeedToReturnPath);
      case ShapeMarkerType.image:
        return Path();
    }
  }

  /// Draw the circle shape marker.
  static Path _processCircleShape(
      {required Canvas canvas,
      required Rect rect,
      required Paint paint,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      Paint? borderPaint}) {
    path.addOval(rect);

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the rectangle shape marker.
  static Path _processRectangleShape(
      {required Canvas canvas,
      required Rect rect,
      required Paint paint,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      Paint? borderPaint}) {
    path.addRect(rect);

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the inverted triangle shape marker.
  static Path _processInvertedTriangleShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint}) {
    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left + rect.width, rect.top);
    path.lineTo(rect.left + (rect.width / 2), rect.top + rect.height);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the triangle shape marker.
  static Path _processTriangleShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint}) {
    path.moveTo(rect.left + (rect.width / 2), rect.top);
    path.lineTo(rect.left, rect.top + rect.height);
    path.lineTo(rect.left + rect.width, rect.top + rect.height);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  ///Draw the triangle shape marker
  static Path _processVerticalTriangleShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint}) {
    path.moveTo(rect.left, rect.top + (rect.height / 2));
    path.lineTo(rect.left + rect.width, rect.top);
    path.lineTo(rect.left + rect.width, rect.top + rect.height);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  ///Draw the vertical inverted triangle shape marker
  static Path _processVerticalInvertedTriangleShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint}) {
    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left + rect.width, rect.top + (rect.height / 2));
    path.lineTo(rect.left, rect.top + rect.height);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the diamond shape marker.
  static Path _processDiamondShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint}) {
    path.moveTo(rect.left + rect.width / 2.0, rect.top);
    path.lineTo(rect.left, rect.top + rect.height / 2.0);
    path.lineTo(rect.left + rect.width / 2.0, rect.top + rect.height);
    path.lineTo(rect.left + rect.width, rect.top + rect.height / 2.0);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }

    canvas.drawPath(path, paint);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  ///Draw the pentagon shape marker
  static Path _processPentagonShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? elevation,
      Color? elevationColor,
      required Paint paint,
      Paint? borderPaint,
      double? rotation}) {
    const int numberOfSides = 5;
    final double left = rect.left + rect.width / 2;
    final double top = rect.top + rect.height / 2;
    final double radius = rect.width / 2;

    for (int i = 0; i <= numberOfSides; i++) {
      final double angle = ((i / 5) * pi * 2 + rotation!).toDouble();
      i == 0
          ? path.moveTo(cos(angle) * radius + left, sin(angle) * radius + top)
          : path.lineTo(cos(angle) * radius + left, sin(angle) * radius + top);
    }

    if (isNeedToReturnPath) {
      return path;
    }

    if (elevation != null && elevation > 0 && elevationColor != null) {
      canvas.drawShadow(path, elevationColor, elevation, true);
    }
    canvas.drawPath(path, paint);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the vertical line shape marker.
  static Path _processVerticalLineShape(
      {required Canvas canvas,
      required bool isNeedToReturnPath,
      required Path path,
      required Rect rect,
      required Paint? borderPaint}) {
    final double left = rect.left + rect.width / 2;
    final double top = rect.top + rect.height / 2;

    path.moveTo(left, top + rect.height / 2);
    path.lineTo(left, top - rect.height / 2);

    if (isNeedToReturnPath) {
      return path;
    }

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the horizontal line shape marker.
  static Path _processHorizontalLineShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      required Paint? borderPaint}) {
    final double left = rect.left + rect.width / 2;
    final double top = rect.top + rect.height / 2;

    path.moveTo(left - rect.width / 2, top);
    path.lineTo(left + rect.width / 2, top);

    if (isNeedToReturnPath) {
      return path;
    }

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the step line series type.
  static Path _processStepLineShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    const num padding = 10;
    path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
    path.lineTo(x - (width / 2) + (width / 10), y + (height / 2));
    path.lineTo(x - (width / 2) + (width / 10), y);
    path.lineTo(x - (width / 10), y);
    path.lineTo(x - (width / 10), y + (height / 2));
    path.lineTo(x + (width / 5), y + (height / 2));
    path.lineTo(x + (width / 5), y - (height / 2));
    path.lineTo(x + (width / 2), y - (height / 2));
    path.lineTo(x + (width / 2), y + (height / 2));
    path.lineTo(x + (width / 2) + (padding / 4), y + (height / 2));

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the pie series type.
  static Path _processPieShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    final double r = min(height, width) / 2;
    path.moveTo(x, y);
    path.lineTo(x + r, y);
    path.arcTo(
        Rect.fromCircle(center: Offset(x, y), radius: r),
        _degreesToRadians(0).toDouble(),
        _degreesToRadians(270).toDouble(),
        false);
    path.close();
    path.moveTo(x + width / 10, y - height / 10);
    path.lineTo(x + r, y - height / 10);
    path.arcTo(
        Rect.fromCircle(center: Offset(x + 2, y - 2), radius: r),
        _degreesToRadians(-5).toDouble(),
        _degreesToRadians(-80).toDouble(),
        false);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the doughnut series type.
  static Path _processDoughnutShape(
      {required Canvas canvas,
      required Rect rect,
      required double radius,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    late Path path1, path2;
    if (borderPaint != null) {
      path1 = _getArcPath(
          path, radius / 4, radius / 2, Offset(x, y), 0, 270, 270, true);
    } else {
      path2 = _getArcPath(path, radius / 4, radius / 2, Offset(x + 1, y - 1),
          -5, -85, -85, true);
    }

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path1, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path1, borderPaint);
    }
    canvas.drawPath(path2, paint);
    if (borderPaint != null) {
      canvas.drawPath(path2, borderPaint);
    }

    return path;
  }

  /// Draw the radial bar series type.
  static Path _processRadialBarShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      double? degree,
      double? startAngle,
      double? endAngle,
      double? radius,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;

    late Path path1, path2;

    radius ??= (rect.width + rect.height) / 2;

    if (borderPaint != null) {
      path1 = _getArcPath(path, (radius / 2) - 2, radius / 2, Offset(x, y), 0,
          360 - 0.01, 360 - 0.01, true);
    } else {
      path2 = _getArcPath(path, (radius / 2) - 2, radius / 2, Offset(x, y),
          startAngle!, endAngle!, degree!, true);
    }

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path1, paint!);

    if (borderPaint != null) {
      canvas.drawPath(path1, borderPaint);
    }

    canvas.drawPath(path2, paint);

    if (borderPaint != null) {
      canvas.drawPath(path2, borderPaint);
    }

    return path;
  }

  /// Get the path of arc
  static Path _getArcPath(
      Path path,
      double innerRadius,
      double radius,
      Offset center,
      double startAngle,
      double endAngle,
      double degree,
      bool isAnimate) {
    startAngle = _degreesToRadians(startAngle);
    endAngle = _degreesToRadians(endAngle);
    degree = _degreesToRadians(degree);

    final Point<double> innerRadiusStartPoint = Point<double>(
        innerRadius * cos(startAngle) + center.dx,
        innerRadius * sin(startAngle) + center.dy);
    final Point<double> innerRadiusEndPoint = Point<double>(
        innerRadius * cos(endAngle) + center.dx,
        innerRadius * sin(endAngle) + center.dy);

    final Point<double> radiusStartPoint = Point<double>(
        radius * cos(startAngle) + center.dx,
        radius * sin(startAngle) + center.dy);

    if (isAnimate) {
      path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
    }

    final bool isFullCircle =
        // ignore: unnecessary_null_comparison
        startAngle != null &&
            // ignore: unnecessary_null_comparison
            endAngle != null &&
            endAngle - startAngle == 2 * pi;

    final num midpointAngle = (endAngle + startAngle) / 2;

    if (isFullCircle) {
      path.arcTo(
          Rect.fromCircle(center: center, radius: radius.toDouble()),
          startAngle.toDouble(),
          midpointAngle.toDouble() - startAngle.toDouble(),
          true);
      path.arcTo(
          Rect.fromCircle(center: center, radius: radius.toDouble()),
          midpointAngle.toDouble(),
          endAngle.toDouble() - midpointAngle.toDouble(),
          true);
    } else {
      path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
      path.arcTo(Rect.fromCircle(center: center, radius: radius.toDouble()),
          startAngle.toDouble(), degree.toDouble(), true);
    }

    if (isFullCircle) {
      path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
          endAngle.toDouble(),
          midpointAngle.toDouble() - endAngle.toDouble(),
          true);
      path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
          midpointAngle.toDouble(),
          startAngle - midpointAngle.toDouble(),
          true);
    } else {
      path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);
      path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
          endAngle.toDouble(),
          startAngle.toDouble() - endAngle.toDouble(),
          true);
      path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
    }
    return path;
  }

  /// Convert degree to radian
  static double _degreesToRadians(double deg) => deg * (pi / 180);

  /// Draw the hilo series type.
  static Path _processHiloShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double height = rect.height;

    path.moveTo(x, y + height / 2);
    path.lineTo(x, y - height / 2);

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the hilo open close series type.
  static Path _processHiloOpenCloseShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;

    path.moveTo(x - width / 2, y);
    path.lineTo(x + width / 2, y);

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the waterfall series type.
  static Path _processWaterfallShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;
    path.addRect(Rect.fromLTRB(
        x - width / 2, y - height / 2, x + width / 2, y + height / 2));

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the pyramid series type.
  static Path _processPyramidShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    path.moveTo(x - width / 2, y + height / 2);
    path.lineTo(x + width / 2, y + height / 2);
    path.lineTo(x, y - height / 2);
    path.lineTo(x - width / 2, y + height / 2);
    path.close();
    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the funnel series type.
  static Path _processFunnelShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    path.moveTo(x + width / 2, y - height / 2);
    path.lineTo(x, y + height / 2);
    path.lineTo(x - width / 2, y - height / 2);
    path.lineTo(x + width / 2, y - height / 2);
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the bubble series type.
  static Path _processBubbleShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    path.addArc(Rect.fromLTWH(x - width / 2, y - height / 2, width, height),
        0.0, 2 * pi);

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the step are series type.
  static Path _processStepAreaShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    const num padding = 10;
    path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
    path.lineTo(x - (width / 2) - (padding / 4), y - (height / 4));
    path.lineTo(x - (width / 2) + (width / 10), y - (height / 4));
    path.lineTo(x - (width / 2) + (width / 10), y - (height / 2));
    path.lineTo(x - (width / 10), y - (height / 2));
    path.lineTo(x - (width / 10), y);
    path.lineTo(x + (width / 5), y);
    path.lineTo(x + (width / 5), y - (height / 3));
    path.lineTo(x + (width / 2), y - (height / 3));
    path.lineTo(x + (width / 2), y + (height / 2));
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the spline area series type.
  static Path _processSplineAreaShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    path.moveTo(x - width / 2, y + height / 2);
    path.quadraticBezierTo(x, y - height, x, y + height / 5);
    path.quadraticBezierTo(
        x + width / 2, y - height / 2, x + width / 2, y + height / 2);

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the line series type.
  static Path _processLineShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? borderPaint,
      bool? isNeedMarker}) {
    final double left = rect.left + rect.width / 2;
    final double top = rect.top + rect.height / 2;

    path.moveTo(left - rect.width / 1.5, top);
    path.lineTo(left + rect.width / 1.5, top);

    if (isNeedToReturnPath) {
      return path;
    }
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint..style = PaintingStyle.stroke);
    }

    if (isNeedMarker! && borderPaint != null) {
      path.close();
      path.addOval(Rect.fromCenter(
          center: Offset(left, top),
          width: rect.width / 1.5,
          height: rect.height / 1.5));
      canvas.drawPath(path, borderPaint..style = PaintingStyle.fill);
    }
    return path;
  }

  /// Draw the column series type.
  static Path _processColumnShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double left = rect.left + rect.width / 2;
    final double top = rect.top + rect.height / 2;

    const num padding = 10;
    const num temp = padding / 2;
    const num space = 3;

    path.moveTo(left - space * (rect.width / temp), top - (rect.height / temp));
    path.lineTo(
        left + space * (-rect.width / padding), top - (rect.height / temp));
    path.lineTo(
        left + space * (-rect.width / padding), top + (rect.height / 2));
    path.lineTo(left - space * (rect.width / temp), top + (rect.height / 2));
    path.close();

    path.moveTo(left - (rect.width / padding) - (rect.width / (padding * 2)),
        top - (rect.height / 4) - (padding / 2));
    path.lineTo(left + (rect.width / padding) + (rect.width / (padding * 2)),
        top - (rect.height / 4) - (padding / 2));
    path.lineTo(left + (rect.width / padding) + (rect.width / (padding * 2)),
        top + (rect.height / 2));
    path.lineTo(left - (rect.width / padding) - (rect.width / (padding * 2)),
        top + (rect.height / 2));
    path.close();

    path.moveTo(left + space * (rect.width / padding), top);
    path.lineTo(left + space * (rect.width / temp), top);
    path.lineTo(left + space * (rect.width / temp), top + (rect.height / 2));
    path.lineTo(left + space * (rect.width / padding), top + (rect.height / 2));
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
    return path;
  }

  /// Draw the area series type.
  static Path _processAreaShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    const num padding = 10;
    path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
    path.lineTo(x - (width / 4) - (padding / 8), y - (height / 2));
    path.lineTo(x, y + (height / 4));
    path.lineTo(
        x + (width / 4) + (padding / 8), y - (height / 2) + (height / 4));
    path.lineTo(x + (height / 2) + (padding / 4), y + (height / 2));
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the bar series type.
  static Path _processBarShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    const num padding = 10;

    path.moveTo(x - (width / 2) - padding / 4, y - 3 * (height / 5));
    path.lineTo(x + 3 * (width / 10), y - 3 * (height / 5));
    path.lineTo(x + 3 * (width / 10), y - 3 * (height / 10));
    path.lineTo(x - (width / 2) - padding / 4, y - 3 * (height / 10));
    path.close();
    path.moveTo(
        x - (width / 2) - (padding / 4), y - (height / 5) + (padding / 20));
    path.lineTo(
        x + (width / 2) + (padding / 4), y - (height / 5) + (padding / 20));
    path.lineTo(
        x + (width / 2) + (padding / 4), y + (height / 10) + (padding / 20));
    path.lineTo(
        x - (width / 2) - (padding / 4), y + (height / 10) + (padding / 20));
    path.close();
    path.moveTo(
        x - (width / 2) - (padding / 4), y + (height / 5) + (padding / 10));
    path.lineTo(x - width / 4, y + (height / 5) + (padding / 10));
    path.lineTo(x - width / 4, y + (height / 2) + (padding / 10));
    path.lineTo(
        x - (width / 2) - (padding / 4), y + (height / 2) + (padding / 10));
    path.close();

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }

  /// Draw the spline series type.
  static Path _processSplineShape(
      {required Canvas canvas,
      required Rect rect,
      required bool isNeedToReturnPath,
      required Path path,
      Paint? paint,
      Paint? borderPaint}) {
    final double x = rect.left + rect.width / 2;
    final double y = rect.top + rect.height / 2;
    final double width = rect.width;
    final double height = rect.height;

    path.moveTo(x - width / 2, y + height / 5);
    path.quadraticBezierTo(x, y - height, x, y + height / 5);
    path.moveTo(x, y + height / 5);
    path.quadraticBezierTo(
        x + width / 2, y + height / 2, x + width / 2, y - height / 2);

    if (isNeedToReturnPath) {
      return path;
    }

    canvas.drawPath(path, paint!);

    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }

    return path;
  }
}
