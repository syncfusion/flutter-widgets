part of charts;

class _PyramidSeries {
  _PyramidSeries(this._chartState);

  final SfPyramidChartState _chartState;

  late PyramidSeries<dynamic, dynamic> currentSeries;

  List<PyramidSeriesRenderer> visibleSeriesRenderers =
      <PyramidSeriesRenderer>[];
  SelectionArgs? _selectionArgs;

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
    final ChartIndexedValueMapper<dynamic>? xValue = currentSeries.xValueMapper;
    final ChartIndexedValueMapper<dynamic>? yValue = currentSeries.yValueMapper;
    for (int pointIndex = 0;
        pointIndex < currentSeries.dataSource!.length;
        pointIndex++) {
      if (xValue!(pointIndex) != null) {
        seriesRenderer._dataPoints
            .add(PointInfo<dynamic>(xValue(pointIndex), yValue!(pointIndex)));
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
        seriesRenderer._renderPoints!.add(points[i]);
      }
    }
  }

  /// To set style properties for current point
  void _setPointStyle(PyramidSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    final List<Color> palette = _chartState._chart.palette;
    final ChartIndexedValueMapper<Color>? pointColor =
        currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final ChartIndexedValueMapper<String>? textMapping =
        currentSeries.textFieldMapper;
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints!;
    PointInfo<dynamic> currentPoint;
    List<_MeasureWidgetContext> legendToggles;
    _MeasureWidgetContext item;
    _LegendRenderContext legendRenderContext;
    for (int i = 0; i < points.length; i++) {
      currentPoint = points[i];
      currentPoint.fill = currentPoint.isEmpty &&
              empty.color != null // ignore: unnecessary_null_comparison
          ? empty.color
          : pointColor!(i) ?? palette[i % palette.length];
      currentPoint.color = currentPoint.fill;
      currentPoint.borderColor = currentPoint.isEmpty &&
              empty.borderColor != null // ignore: unnecessary_null_comparison
          ? empty.borderColor
          : currentSeries.borderColor;
      currentPoint.borderWidth = currentPoint.isEmpty &&
              empty.borderWidth != null // ignore: unnecessary_null_comparison
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
        legendToggles =
            _chartState._renderingDetails.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            item = legendToggles[j];
            if (i == item.pointIndex) {
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      } else {
        if (_chartState._renderingDetails.legendToggleStates.isNotEmpty) {
          for (int j = 0;
              j < _chartState._renderingDetails.legendToggleStates.length;
              j++) {
            legendRenderContext =
                _chartState._renderingDetails.legendToggleStates[j];
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
    for (final PointInfo<dynamic> point in seriesRenderer._renderPoints!) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y!.abs();
      }
    }
  }

  /// To initialise the series properties in chart
  void _initializeSeriesProperties(PyramidSeriesRenderer seriesRenderer) {
    final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
    final Rect chartAreaRect = _chartState._renderingDetails.chartAreaRect;
    final bool reverse = seriesRenderer._seriesType == 'pyramid';
    seriesRenderer._triangleSize = Size(
        _percentToValue(series.width, chartAreaRect.width)!.toDouble(),
        _percentToValue(series.height, chartAreaRect.height)!.toDouble());
    seriesRenderer._explodeDistance =
        _percentToValue(series.explodeOffset, chartAreaRect.width)!;
    if (series.pyramidMode == PyramidMode.linear) {
      _initializeSizeRatio(seriesRenderer, reverse);
    } else {
      _initializeSurfaceSizeRatio(seriesRenderer);
    }
  }

  /// To intialize the surface size ratio in chart
  void _initializeSurfaceSizeRatio(PyramidSeriesRenderer seriesRenderer) {
    final num count = seriesRenderer._renderPoints!.length;
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
    for (int i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints![i];
      if (point.isVisible) {
        y.add(currY);
        height.add(_getSurfaceHeight(currY, point.y!.abs()));
        currY += height[i] + gapHeight * preSum;
      }
    }
    final num coef = 1 / (currY - gapHeight * preSum);
    for (int i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints![i];
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
      [bool? reverse]) {
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints!;
    double y;
    assert(
        // ignore: unnecessary_null_comparison
        !(seriesRenderer._series.gapRatio != null) ||
            seriesRenderer._series.gapRatio >= 0 &&
                seriesRenderer._series.gapRatio <= 1,
        'The gap ratio for the pyramid chart must be between 0 and 1.');
    final double gapRatio = min(max(seriesRenderer._series.gapRatio, 0), 1);
    final double coEff =
        1 / (seriesRenderer._sumOfPoints * (1 + gapRatio / (1 - gapRatio)));
    final double spacing = gapRatio / (points.length - 1);
    y = 0;
    int index;
    num height;
    for (int i = points.length - 1; i >= 0; i--) {
      index = reverse! ? points.length - 1 - i : i;
      if (points[index].isVisible) {
        height = coEff * points[index].y!;
        points[index].yRatio = y;
        points[index].heightRatio = height;
        y += height + spacing;
      }
    }
  }

  /// To explode current point index
  void _pointExplode(int pointIndex) {
    bool existExplodedRegion = false;
    final PyramidSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    final SfPyramidChartState chartState = _chartState;
    final PointInfo<dynamic> point = seriesRenderer._renderPoints![pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState._renderingDetails.explodedPoints.isNotEmpty) {
        existExplodedRegion = true;
        final int previousIndex =
            chartState._renderingDetails.explodedPoints[0];
        seriesRenderer._renderPoints![previousIndex].explodeDistance = 0;
        point.explodeDistance =
            previousIndex == pointIndex ? 0 : seriesRenderer._explodeDistance;
        chartState._renderingDetails.explodedPoints[0] = pointIndex;
        if (previousIndex == pointIndex) {
          chartState._renderingDetails.explodedPoints = <int>[];
        }
        chartState._renderingDetails.seriesRepaintNotifier.value++;
      }
      if (!existExplodedRegion) {
        point.explodeDistance = seriesRenderer._explodeDistance;
        chartState._renderingDetails.explodedPoints.add(pointIndex);
        chartState._renderingDetails.seriesRepaintNotifier.value++;
      }
      _calculatePathRegion(pointIndex, seriesRenderer);
    }
  }

  /// To calculate region path for rendering chart
  void _calculatePathRegion(
      int pointIndex, PyramidSeriesRenderer seriesRenderer) {
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints![pointIndex];
    currentPoint.pathRegion = <Offset>[];
    final SfPyramidChartState chartState = _chartState;
    final Size area = seriesRenderer._triangleSize;
    final Rect rect = chartState._renderingDetails.chartContainerRect;
    final num seriesTop = rect.top + (rect.height - area.height) / 2;
    const num offset = 0;
    // ignore: prefer_if_null_operators
    final num extraSpace = (currentPoint.explodeDistance != null
            ? currentPoint.explodeDistance!
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
    currentPoint.pathRegion.add(Offset(line1X.toDouble(), line1Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line2X.toDouble(), line2Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line3X.toDouble(), line3Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line4X.toDouble(), line4Y.toDouble()));
    _calculatePathSegment(seriesRenderer._seriesType, currentPoint);
  }

  /// To calculate pyramid segments
  void _calculatePyramidSegments(
      Canvas canvas, int pointIndex, PyramidSeriesRenderer seriesRenderer) {
    _calculatePathRegion(pointIndex, seriesRenderer);
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints![pointIndex];
    final Path path = Path();
    path.moveTo(currentPoint.pathRegion[0].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[1].dy);
    path.lineTo(currentPoint.pathRegion[2].dx, currentPoint.pathRegion[2].dy);
    path.lineTo(currentPoint.pathRegion[3].dx, currentPoint.pathRegion[3].dy);
    path.close();
    if (pointIndex == seriesRenderer._renderPoints!.length - 1) {
      seriesRenderer._maximumDataLabelRegion = path.getBounds();
    }
    _segmentPaint(canvas, path, pointIndex, seriesRenderer);
  }

  /// To paint the funnel segments
  void _segmentPaint(Canvas canvas, Path path, int pointIndex,
      PyramidSeriesRenderer seriesRenderer) {
    final PointInfo<dynamic> point = seriesRenderer._renderPoints![pointIndex];
    final _StyleOptions? style =
        _getPointStyle(pointIndex, seriesRenderer, _chartState._chart, point);

    final Color fillColor =
        style != null && style.fill != null ? style.fill! : point.fill;

    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor!
        : point.borderColor;

    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth!.toDouble()
        : point.borderWidth.toDouble();

    final double opacity = style != null && style.opacity != null
        ? style.opacity!
        : currentSeries.opacity;

    _drawPath(
        canvas,
        _StyleOptions(
            fill: fillColor,
            strokeWidth: _chartState._renderingDetails.animateCompleted
                ? strokeWidth
                : 0,
            strokeColor: strokeColor,
            opacity: opacity),
        path);
  }

  /// To calculate the segment path
  void _calculatePathSegment(String seriesType, PointInfo<dynamic> point) {
    final List<Offset> pathRegion = point.pathRegion;
    final int bottom =
        seriesType == 'funnel' ? pathRegion.length - 2 : pathRegion.length - 1;
    final num x = (pathRegion[0].dx + pathRegion[bottom].dx) / 2;
    final num right = (pathRegion[1].dx + pathRegion[bottom - 1].dx) / 2;
    point.region = Rect.fromLTWH(x.toDouble(), pathRegion[0].dy,
        (right - x).toDouble(), pathRegion[bottom].dy - pathRegion[0].dy);
    point.symbolLocation = Offset(point.region!.left + point.region!.width / 2,
        point.region!.top + point.region!.height / 2);
  }

  /// To add selection points to selection list
  void _seriesPointSelection(int pointIndex, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final SfPyramidChart chart = _chartState._chart;
    final PyramidSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    final SfPyramidChartState chartState = _chartState;
    int? currentSelectedIndex;
    const int seriesIndex = 0;
    if (seriesRenderer._isSelectionEnable && mode == chart.selectionGesture) {
      if (chartState._renderingDetails.selectionData.isNotEmpty) {
        if (!chart.enableMultiSelection &&
            _chartState._renderingDetails.selectionData.isNotEmpty &&
            _chartState._renderingDetails.selectionData.length > 1) {
          if (_chartState._renderingDetails.selectionData
              .contains(pointIndex)) {
            currentSelectedIndex = pointIndex;
          }
          _chartState._renderingDetails.selectionData.clear();
          if (currentSelectedIndex != null) {
            _chartState._renderingDetails.selectionData.add(pointIndex);
          }
        }

        int selectionIndex;
        for (int i = 0;
            i < chartState._renderingDetails.selectionData.length;
            i++) {
          selectionIndex = chartState._renderingDetails.selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected =
                chartState._renderingDetails.selectionData.length == 1 &&
                    pointIndex == selectionIndex;
            if (seriesRenderer._selectionBehavior.toggleSelection == true ||
                !isPointAlreadySelected) {
              chartState._renderingDetails.selectionData.removeAt(i);
            }
            chartState._renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
          } else if (pointIndex == selectionIndex) {
            if (seriesRenderer._selectionBehavior.toggleSelection == true) {
              chartState._renderingDetails.selectionData.removeAt(i);
            }
            isPointAlreadySelected = true;
            chartState._renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        chartState._renderingDetails.selectionData.add(pointIndex);
        chartState._renderingDetails.seriesRepaintNotifier.value++;
        if (chart.onSelectionChanged != null) {
          chart.onSelectionChanged!(
              _getSelectionEventArgs(seriesRenderer, seriesIndex, pointIndex));
        }
      }
    }
  }

  /// To return style options for the point on selection
  _StyleOptions? _getPointStyle(
      int currentPointIndex,
      PyramidSeriesRenderer seriesRenderer,
      SfPyramidChart chart,
      PointInfo<dynamic> point) {
    _StyleOptions? pointStyle;
    final dynamic selection = seriesRenderer._series.selectionBehavior;
    if (selection.enable == true) {
      if (_chartState._renderingDetails.selectionData.isNotEmpty) {
        int selectionIndex;
        for (int i = 0;
            i < _chartState._renderingDetails.selectionData.length;
            i++) {
          selectionIndex = _chartState._renderingDetails.selectionData[i];
          if (currentPointIndex == selectionIndex) {
            pointStyle = _StyleOptions(
                fill: _selectionArgs != null
                    ? _selectionArgs!.selectedColor
                    : selection!.selectedColor,
                strokeWidth: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderWidth
                    : selection!.selectedBorderWidth,
                strokeColor: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderColor
                    : selection!.selectedBorderColor,
                opacity: selection.selectedOpacity);
            break;
          } else if (i ==
              _chartState._renderingDetails.selectionData.length - 1) {
            pointStyle = _StyleOptions(
                fill: _selectionArgs != null
                    ? _selectionArgs!.unselectedColor
                    : selection.unselectedColor,
                strokeWidth: _selectionArgs != null
                    ? _selectionArgs!.unselectedBorderWidth
                    : selection.unselectedBorderWidth,
                strokeColor: _selectionArgs != null
                    ? _selectionArgs!.unselectedBorderColor
                    : selection.unselectedBorderColor,
                opacity: selection.unselectedOpacity);
          }
        }
      }
    }
    return pointStyle;
  }

  /// To perform selection event and return selectionArgs
  SelectionArgs _getSelectionEventArgs(
      PyramidSeriesRenderer seriesRenderer, int seriesIndex, int pointIndex) {
    final SfPyramidChart chart = seriesRenderer._chartState._chart;
    // ignore: unnecessary_null_comparison
    if (seriesRenderer != null &&
        //ignore: unnecessary_null_comparison
        chart.series != null &&
        pointIndex < chart.series.dataSource!.length) {
      final dynamic selectionBehavior = seriesRenderer._selectionBehavior;
      _selectionArgs = SelectionArgs(
          seriesRenderer: seriesRenderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: pointIndex);
      _selectionArgs!.selectedBorderColor =
          selectionBehavior.selectedBorderColor;
      _selectionArgs!.selectedBorderWidth =
          selectionBehavior.selectedBorderWidth;
      _selectionArgs!.selectedColor = selectionBehavior.selectedColor;
      _selectionArgs!.unselectedBorderColor =
          selectionBehavior.unselectedBorderColor;
      _selectionArgs!.unselectedBorderWidth =
          selectionBehavior.unselectedBorderWidth;
      _selectionArgs!.unselectedColor = selectionBehavior.unselectedColor;
    }
    return _selectionArgs!;
  }
}
