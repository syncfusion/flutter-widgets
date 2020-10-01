part of charts;

class _PyramidSeries {
  _PyramidSeries(this._chartState);

  final SfPyramidChartState _chartState;

  PyramidSeries<dynamic, dynamic> currentSeries;

  List<PyramidSeriesRenderer> visibleSeriesRenderers =
      <PyramidSeriesRenderer>[];
  SelectionArgs _selectionArgs;

  /// To find the visible series
  void _findVisibleSeries() {
    _chartState._chartSeries.visibleSeriesRenderers[0]._dataPoints =
        <PointInfo<dynamic>>[];

    //Considered the first series, since in triangular series one series will be considered for rendering
    final PyramidSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    currentSeries = seriesRenderer._series;
    //Setting seriestype
    seriesRenderer._seriesType = 'pyramid';
    final ChartIndexedValueMapper<dynamic> xValue = currentSeries.xValueMapper;
    final ChartIndexedValueMapper<dynamic> yValue = currentSeries.yValueMapper;
    for (int pointIndex = 0;
        pointIndex < currentSeries.dataSource.length;
        pointIndex++) {
      if (xValue(pointIndex) != null) {
        seriesRenderer._dataPoints
            .add(PointInfo<dynamic>(xValue(pointIndex), yValue(pointIndex)));
      }
    }
    visibleSeriesRenderers
      ..clear()
      ..add(seriesRenderer);
  }

  /// To calculate empty point values if null values are provided
  void _calculatePyramidEmptyPoints(PyramidSeriesRenderer seriesRenderer) {
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      if (seriesRenderer._dataPoints[i].y == null) {
        seriesRenderer._series.calculateEmptyPointValue(
            i, seriesRenderer._dataPoints[i], seriesRenderer);
      }
    }
  }

  /// To process the data points for series render
  void _processDataPoints() {
    for (final PyramidSeriesRenderer seriesRenderer in visibleSeriesRenderers) {
      currentSeries = seriesRenderer._series;
      _calculatePyramidEmptyPoints(seriesRenderer);
      _calculateVisiblePoints(seriesRenderer);
      _setPointStyle(seriesRenderer);
      _findSumOfPoints(seriesRenderer);
    }
  }

  /// To calculate the visible points in a series
  void _calculateVisiblePoints(PyramidSeriesRenderer seriesRenderer) {
    final List<PointInfo<dynamic>> points = seriesRenderer._dataPoints;
    seriesRenderer._renderPoints = <PointInfo<dynamic>>[];
    for (int i = 0; i < points.length; i++) {
      if (points[i].isVisible) {
        seriesRenderer._renderPoints.add(points[i]);
      }
    }
  }

  /// To set style properties for current point
  void _setPointStyle(PyramidSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    final List<Color> palette = _chartState._chart.palette;
    final ChartIndexedValueMapper<Color> pointColor =
        currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final ChartIndexedValueMapper<String> textMapping =
        currentSeries.textFieldMapper;
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    for (int i = 0; i < points.length; i++) {
      PointInfo<dynamic> currentPoint;
      currentPoint = points[i];
      currentPoint.fill = currentPoint.isEmpty && empty.color != null
          ? empty.color
          : pointColor(i) ?? palette[i % palette.length];
      currentPoint.color = currentPoint.fill;
      currentPoint.borderColor =
          currentPoint.isEmpty && empty.borderColor != null
              ? empty.borderColor
              : currentSeries.borderColor;
      currentPoint.borderWidth =
          currentPoint.isEmpty && empty.borderWidth != null
              ? empty.borderWidth
              : currentSeries.borderWidth;
      currentPoint.borderColor = currentPoint.borderWidth == 0
          ? Colors.transparent
          : currentPoint.borderColor;

      currentPoint.text = currentPoint.text ??
          (textMapping != null
              ? textMapping(i) ?? currentPoint.y.toString()
              : currentPoint.y.toString());

      if (_chartState._chart.legend.legendItemBuilder != null) {
        final List<_MeasureWidgetContext> legendToggles =
            _chartState._legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            final _MeasureWidgetContext item = legendToggles[j];
            if (i == item.pointIndex) {
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      } else {
        if (_chartState._legendToggleStates.isNotEmpty) {
          for (int j = 0; j < _chartState._legendToggleStates.length; j++) {
            final _LegendRenderContext legendRenderContext =
                _chartState._legendToggleStates[j];
            if (i == legendRenderContext.seriesIndex) {
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      }
    }
  }

  /// To find the sum of points
  void _findSumOfPoints(PyramidSeriesRenderer seriesRenderer) {
    seriesRenderer._sumOfPoints = 0;
    for (final PointInfo<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y.abs();
      }
    }
  }

  /// To initialise the series properties in chart
  void _initializeSeriesProperties(PyramidSeriesRenderer seriesRenderer) {
    final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
    final Rect chartAreaRect = _chartState._chartAreaRect;
    final bool reverse = seriesRenderer._seriesType == 'pyramid' ? true : false;
    seriesRenderer._triangleSize = Size(
        _percentToValue(series.width, chartAreaRect.width).toDouble(),
        _percentToValue(series.height, chartAreaRect.height).toDouble());
    seriesRenderer._explodeDistance =
        _percentToValue(series.explodeOffset, chartAreaRect.width);
    if (series.pyramidMode == PyramidMode.linear) {
      _initializeSizeRatio(seriesRenderer, reverse);
    } else {
      _initializeSurfaceSizeRatio(seriesRenderer);
    }
  }

  /// To intialize the surface size ratio in chart
  void _initializeSurfaceSizeRatio(PyramidSeriesRenderer seriesRenderer) {
    final num count = seriesRenderer._renderPoints.length;
    final num sumOfValues = seriesRenderer._sumOfPoints;
    List<num> y;
    List<num> height;
    y = <num>[];
    height = <num>[];
    final num gapRatio = min(max(seriesRenderer._series.gapRatio, 0), 1);
    final num gapHeight = gapRatio / (count - 1);
    final num preSum = _getSurfaceHeight(0, sumOfValues);
    num currY = 0;
    PointInfo<dynamic> point;
    for (num i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints[i];
      if (point.isVisible) {
        y.add(currY);
        height.add(_getSurfaceHeight(currY, point.y.abs()));
        currY += height[i] + gapHeight * preSum;
      }
    }
    final num coef = 1 / (currY - gapHeight * preSum);
    for (num i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints[i];
      if (point.isVisible) {
        point.yRatio = coef * y[i];
        point.heightRatio = coef * height[i];
      }
    }
  }

  /// To get the surface height
  num _getSurfaceHeight(num y, num surface) =>
      _solveQuadraticEquation(1, 2 * y, -surface);

  /// To solve quadratic equations
  num _solveQuadraticEquation(num a, num b, num c) {
    num root1;
    num root2;
    final num d = b * b - 4 * a * c;
    if (d >= 0) {
      final num sd = sqrt(d);
      root1 = (-b - sd) / (2 * a);
      root2 = (-b + sd) / (2 * a);
      return max(root1, root2);
    }
    return 0;
  }

  /// To initialise size ratio for the pyramid
  void _initializeSizeRatio(PyramidSeriesRenderer seriesRenderer,
      [bool reverse]) {
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    double y;
    assert(
        seriesRenderer._series.gapRatio != null
            ? seriesRenderer._series.gapRatio >= 0 &&
                seriesRenderer._series.gapRatio <= 1
            : true,
        'The gap ratio for the pyramid chart must be between 0 and 1.');
    final double gapRatio = min(max(seriesRenderer._series.gapRatio, 0), 1);
    final double coEff =
        1 / (seriesRenderer._sumOfPoints * (1 + gapRatio / (1 - gapRatio)));
    final double spacing = gapRatio / (points.length - 1);
    y = 0;
    num index;
    num height;
    for (num i = points.length - 1; i >= 0; i--) {
      index = reverse ? points.length - 1 - i : i;
      if (points[index].isVisible) {
        height = coEff * points[index].y;
        points[index].yRatio = y;
        points[index].heightRatio = height;
        y += height + spacing;
      }
    }
  }

  /// To explode current point index
  void _pointExplode(num pointIndex) {
    bool existExplodedRegion = false;
    final PyramidSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    final SfPyramidChartState chartState = _chartState;
    final PointInfo<dynamic> point = seriesRenderer._renderPoints[pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState._explodedPoints.isNotEmpty) {
        existExplodedRegion = true;
        final int previousIndex = chartState._explodedPoints[0];
        seriesRenderer._renderPoints[previousIndex].explodeDistance = 0;
        point.explodeDistance =
            previousIndex == pointIndex ? 0 : seriesRenderer._explodeDistance;
        chartState._explodedPoints[0] = pointIndex;
        if (previousIndex == pointIndex) {
          chartState._explodedPoints = <int>[];
        }
        chartState._seriesRepaintNotifier.value++;
      }
      if (!existExplodedRegion) {
        point.explodeDistance = seriesRenderer._explodeDistance;
        chartState._explodedPoints.add(pointIndex);
        chartState._seriesRepaintNotifier.value++;
      }
      _calculatePathRegion(pointIndex, seriesRenderer);
    }
  }

  /// To calculate region path for rendering chart
  void _calculatePathRegion(
      num pointIndex, PyramidSeriesRenderer seriesRenderer) {
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints[pointIndex];
    currentPoint.pathRegion = <Offset>[];
    final SfPyramidChartState chartState = _chartState;
    final Size area = seriesRenderer._triangleSize;
    final Rect rect = chartState._chartContainerRect;
    final num seriesTop = rect.top + (rect.height - area.height) / 2;
    const num offset = 0;
    // ignore: prefer_if_null_operators
    final num extraSpace = (currentPoint.explodeDistance != null
            ? currentPoint.explodeDistance
            : _isNeedExplode(pointIndex, currentSeries, _chartState)
                ? seriesRenderer._explodeDistance
                : 0) +
        (rect.width - seriesRenderer._triangleSize.width) / 2;
    final num emptySpaceAtLeft = extraSpace + rect.left;
    num top = currentPoint.yRatio;
    num bottom = currentPoint.yRatio + currentPoint.heightRatio;
    final num topRadius = 0.5 * (1 - currentPoint.yRatio);
    final num bottomRadius = 0.5 * (1 - bottom);
    top += seriesTop / area.height;
    bottom += seriesTop / area.height;
    num line1X, line1Y, line2X, line2Y, line3X, line3Y, line4X, line4Y;
    line1X = emptySpaceAtLeft + offset + topRadius * area.width;
    line1Y = top * area.height;
    line2X = emptySpaceAtLeft + offset + (1 - topRadius) * area.width;
    line2Y = top * area.height;
    line3X = emptySpaceAtLeft + offset + (1 - bottomRadius) * area.width;
    line3Y = bottom * area.height;
    line4X = emptySpaceAtLeft + offset + bottomRadius * area.width;
    line4Y = bottom * area.height;
    currentPoint.pathRegion.add(Offset(line1X, line1Y));
    currentPoint.pathRegion.add(Offset(line2X, line2Y));
    currentPoint.pathRegion.add(Offset(line3X, line3Y));
    currentPoint.pathRegion.add(Offset(line4X, line4Y));
    _calculatePathSegment(seriesRenderer._seriesType, currentPoint);
  }

  /// To calculate pyramid segments
  void _calculatePyramidSegments(
      Canvas canvas, num pointIndex, PyramidSeriesRenderer seriesRenderer) {
    _calculatePathRegion(pointIndex, seriesRenderer);
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints[pointIndex];
    final Path path = Path();
    path.moveTo(currentPoint.pathRegion[0].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[1].dy);
    path.lineTo(currentPoint.pathRegion[2].dx, currentPoint.pathRegion[2].dy);
    path.lineTo(currentPoint.pathRegion[3].dx, currentPoint.pathRegion[3].dy);
    path.close();
    if (pointIndex == seriesRenderer._renderPoints.length - 1) {
      seriesRenderer._maximumDataLabelRegion = path.getBounds();
    }
    _segmentPaint(canvas, path, pointIndex, seriesRenderer);
  }

  /// To paint the funnel segments
  void _segmentPaint(Canvas canvas, Path path, num pointIndex,
      PyramidSeriesRenderer seriesRenderer) {
    final PointInfo<dynamic> point = seriesRenderer._renderPoints[pointIndex];
    final _StyleOptions style =
        _getPointStyle(pointIndex, seriesRenderer, _chartState._chart, point);

    final Color fillColor =
        style != null && style.fill != null ? style.fill : point.fill;

    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor
        : point.borderColor;

    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth
        : point.borderWidth;

    final double opacity = style != null && style.opacity != null
        ? style.opacity
        : currentSeries.opacity;

    _drawPath(
        canvas,
        _StyleOptions(
            fillColor,
            _chartState._animateCompleted ? strokeWidth : 0,
            strokeColor,
            opacity),
        path);
  }

  /// To calculate the segment path
  void _calculatePathSegment(String seriesType, PointInfo<dynamic> point) {
    final List<Offset> pathRegion = point.pathRegion;
    final num bottom =
        seriesType == 'funnel' ? pathRegion.length - 2 : pathRegion.length - 1;
    final num x = (pathRegion[0].dx + pathRegion[bottom].dx) / 2;
    final num right = (pathRegion[1].dx + pathRegion[bottom - 1].dx) / 2;
    point.region = Rect.fromLTWH(x, pathRegion[0].dy, right - x,
        pathRegion[bottom].dy - pathRegion[0].dy);
    point.symbolLocation = Offset(point.region.left + point.region.width / 2,
        point.region.top + point.region.height / 2);
  }

  /// To add selection points to selection list
  void _seriesPointSelection(num pointIndex, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final SfPyramidChart chart = _chartState._chart;
    final PyramidSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    // final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
    final SfPyramidChartState chartState = _chartState;
    if (seriesRenderer._isSelectionEnable && mode == chart.selectionGesture) {
      if (chartState._selectionData.isNotEmpty) {
        for (int i = 0; i < chartState._selectionData.length; i++) {
          final int selectionIndex = chartState._selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected = chartState._selectionData.length == 1 &&
                pointIndex == selectionIndex;
            chartState._selectionData.removeAt(i);
            chartState._seriesRepaintNotifier.value++;
          } else if (pointIndex == selectionIndex) {
            chartState._selectionData.removeAt(i);
            isPointAlreadySelected = true;
            chartState._seriesRepaintNotifier.value++;
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        chartState._selectionData.add(pointIndex);
        chartState._seriesRepaintNotifier.value++;
      }
    }
  }

  /// To return style options for the point on selection
  _StyleOptions _getPointStyle(
      int currentPointIndex,
      PyramidSeriesRenderer seriesRenderer,
      SfPyramidChart chart,
      PointInfo<dynamic> point) {
    _StyleOptions pointStyle;
    final dynamic selection = seriesRenderer._series.selectionBehavior.enable
        ? seriesRenderer._series.selectionBehavior
        : seriesRenderer._series.selectionSettings;
    const num seriesIndex = 0;
    if (selection.enable) {
      if (_chartState._selectionData.isNotEmpty) {
        for (int i = 0; i < _chartState._selectionData.length; i++) {
          final int selectionIndex = _chartState._selectionData[i];
          if (chart.onSelectionChanged != null &&
              selectionIndex == currentPointIndex) {
            chart.onSelectionChanged(_getSelectionEventArgs(
                seriesRenderer, seriesIndex, currentPointIndex));
          }
          if (currentPointIndex == selectionIndex) {
            pointStyle = _StyleOptions(
                _selectionArgs != null
                    ? _selectionArgs.selectedColor
                    : selection.selectedColor,
                _selectionArgs != null
                    ? _selectionArgs.selectedBorderWidth
                    : selection.selectedBorderWidth,
                _selectionArgs != null
                    ? _selectionArgs.selectedBorderColor
                    : selection.selectedBorderColor,
                selection.selectedOpacity);
            break;
          } else if (i == _chartState._selectionData.length - 1) {
            pointStyle = _StyleOptions(
                _selectionArgs != null
                    ? _selectionArgs.unselectedColor
                    : selection.unselectedColor,
                _selectionArgs != null
                    ? _selectionArgs.unselectedBorderWidth
                    : selection.unselectedBorderWidth,
                _selectionArgs != null
                    ? _selectionArgs.unselectedBorderColor
                    : selection.unselectedBorderColor,
                selection.unselectedOpacity);
          }
        }
      }
    }
    return pointStyle;
  }

  /// To perform selection event and return selectionArgs
  SelectionArgs _getSelectionEventArgs(
      dynamic seriesRenderer, num seriesIndex, num pointIndex) {
    if (seriesRenderer != null) {
      final dynamic selectionBehavior = seriesRenderer._selectionBehavior;
      _selectionArgs =
          SelectionArgs(seriesRenderer, seriesIndex, pointIndex, pointIndex);
      _selectionArgs.selectedBorderColor =
          selectionBehavior.selectedBorderColor;
      _selectionArgs.selectedBorderWidth =
          selectionBehavior.selectedBorderWidth;
      _selectionArgs.selectedColor = selectionBehavior.selectedColor;
      _selectionArgs.unselectedBorderColor =
          selectionBehavior.unselectedBorderColor;
      _selectionArgs.unselectedBorderWidth =
          selectionBehavior.unselectedBorderWidth;
      _selectionArgs.unselectedColor = selectionBehavior.unselectedColor;
    }
    return _selectionArgs;
  }
}
