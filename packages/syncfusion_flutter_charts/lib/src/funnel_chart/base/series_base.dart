part of charts;

class _FunnelSeries {
  _FunnelSeries(this._chartState);

  final SfFunnelChartState _chartState;

  late _FunnelSeriesBase<dynamic, dynamic> currentSeries;

  List<FunnelSeriesRenderer> visibleSeriesRenderers = <FunnelSeriesRenderer>[];
  SelectionArgs? _selectionArgs;

  /// To find the visible series
  void _findVisibleSeries() {
    _chartState._chartSeries.visibleSeriesRenderers[0]._dataPoints =
        <PointInfo<dynamic>>[];

    //Considered the first series, since in triangular series one series will be considered for rendering
    final FunnelSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    currentSeries = seriesRenderer._series;
    //Setting series type
    seriesRenderer._seriesType = 'funnel';
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

  /// To calculate empty point values for null values in chart
  void _calculateFunnelEmptyPoints(FunnelSeriesRenderer seriesRenderer) {
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      if (seriesRenderer._dataPoints[i].y == null) {
        seriesRenderer._series.calculateEmptyPointValue(
            i, seriesRenderer._dataPoints[i], seriesRenderer);
      }
    }
  }

  /// To process the data points for series render.
  void _processDataPoints(FunnelSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    _calculateFunnelEmptyPoints(seriesRenderer);
    _calculateVisiblePoints(seriesRenderer);
    _setPointStyle(seriesRenderer);
    _findSumOfPoints(seriesRenderer);
  }

  /// To calculate the visible points in the series
  void _calculateVisiblePoints(FunnelSeriesRenderer seriesRenderer) {
    final List<PointInfo<dynamic>> points = seriesRenderer._dataPoints;
    seriesRenderer._renderPoints = <PointInfo<dynamic>>[];
    for (int i = 0; i < points.length; i++) {
      if (points[i].isVisible) {
        seriesRenderer._renderPoints.add(points[i]);
      }
    }
  }

  /// To set point style properties
  void _setPointStyle(FunnelSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    final List<Color> palette = _chartState._chart.palette;
    final ChartIndexedValueMapper<Color>? pointColor =
        currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final ChartIndexedValueMapper<String>? textMapping =
        currentSeries.textFieldMapper;
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    PointInfo<dynamic> currentPoint;
    List<_MeasureWidgetContext> legendToggles;
    _MeasureWidgetContext item;
    _LegendRenderContext legendRenderContext;
    for (int i = 0; i < points.length; i++) {
      currentPoint = points[i];
      // ignore: unnecessary_null_comparison
      currentPoint.fill = currentPoint.isEmpty && empty.color != null
          ? empty.color
          : pointColor!(i) ?? palette[i % palette.length];
      currentPoint.color = currentPoint.fill;
      currentPoint.borderColor =
          // ignore: unnecessary_null_comparison
          currentPoint.isEmpty && empty.borderColor != null
              ? empty.borderColor
              : currentSeries.borderColor;
      currentPoint.borderWidth =
          // ignore: unnecessary_null_comparison
          currentPoint.isEmpty && empty.borderWidth != null
              ? empty.borderWidth
              : currentSeries.borderWidth;
      currentPoint.borderColor = currentPoint.borderWidth == 0
          ? Colors.transparent
          : currentPoint.borderColor;

      currentPoint.text = currentPoint.text ??
          (textMapping != null
              ? textMapping(i) ?? currentPoint.y!.toString()
              : currentPoint.y!.toString());

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

  /// To find the sum of data points
  void _findSumOfPoints(FunnelSeriesRenderer seriesRenderer) {
    seriesRenderer._sumOfPoints = 0;
    for (final PointInfo<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y!.abs();
      }
    }
  }

  /// To initialise series properties
  void _initializeSeriesProperties(FunnelSeriesRenderer seriesRenderer) {
    final Rect chartAreaRect = _chartState._renderingDetails.chartAreaRect;
    final FunnelSeries<dynamic, dynamic> series = seriesRenderer._series;
    final bool reverse = seriesRenderer._seriesType == 'pyramid';
    seriesRenderer._triangleSize = Size(
        _percentToValue(series.width, chartAreaRect.width)!.toDouble(),
        _percentToValue(series.height, chartAreaRect.height)!.toDouble());
    seriesRenderer._neckSize = Size(
        _percentToValue(series.neckWidth, chartAreaRect.width)!.toDouble(),
        _percentToValue(series.neckHeight, chartAreaRect.height)!.toDouble());
    seriesRenderer._explodeDistance =
        _percentToValue(series.explodeOffset, chartAreaRect.width)!;
    _initializeSizeRatio(seriesRenderer, reverse);
  }

  /// To initialise size ratio for the funnel
  void _initializeSizeRatio(FunnelSeriesRenderer seriesRenderer,
      [bool? reverse]) {
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    double y;
    assert(
        // ignore: unnecessary_null_comparison
        !(seriesRenderer._series.gapRatio != null) ||
            seriesRenderer._series.gapRatio >= 0 &&
                seriesRenderer._series.gapRatio <= 1,
        'The gap ratio for the funnel chart must be between 0 and 1.');
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

  /// To perform point explode
  void _pointExplode(int pointIndex) {
    bool existExplodedRegion = false;
    final FunnelSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    final SfFunnelChartState chartState = _chartState;
    final PointInfo<dynamic> point = seriesRenderer._renderPoints[pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState._renderingDetails.explodedPoints.isNotEmpty) {
        existExplodedRegion = true;
        final int previousIndex =
            chartState._renderingDetails.explodedPoints[0];
        seriesRenderer._renderPoints[previousIndex].explodeDistance = 0;
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
      _calculateFunnelPathRegion(pointIndex, seriesRenderer);
    }
  }

  /// To calculate Path for the segemnt regions
  void _calculateFunnelPathRegion(
      int pointIndex, FunnelSeriesRenderer seriesRenderer) {
    num lineWidth, topRadius, bottomRadius, endTop, endBottom, top, bottom;
    num? minRadius, bottomY;
    num endMin = 0;
    final Size area = seriesRenderer._triangleSize;
    const num offset = 0;
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints[pointIndex];
    currentPoint.pathRegion = <Offset>[];
    final Rect rect = _chartState._renderingDetails.chartContainerRect;
    //ignore: prefer_if_null_operators
    final num extraSpace = (currentPoint.explodeDistance != null
            ? currentPoint.explodeDistance!
            : _isNeedExplode(pointIndex, currentSeries, _chartState)
                ? seriesRenderer._explodeDistance
                : 0) +
        (rect.width - seriesRenderer._triangleSize.width) / 2;
    final num emptySpaceAtLeft = extraSpace + rect.left;
    final num seriesTop = rect.top + (rect.height - area.height) / 2;
    top = currentPoint.yRatio * area.height;
    bottom = top + currentPoint.heightRatio * area.height;
    final Size neckSize = seriesRenderer._neckSize;
    lineWidth = neckSize.width +
        (area.width - neckSize.width) *
            ((area.height - neckSize.height - top) /
                (area.height - neckSize.height));
    topRadius = (area.width / 2) - lineWidth / 2;
    endTop = topRadius + lineWidth;
    lineWidth = (bottom > area.height - neckSize.height ||
            area.height == neckSize.height)
        ? neckSize.width
        : neckSize.width +
            (area.width - neckSize.width) *
                ((area.height - neckSize.height - bottom) /
                    (area.height - neckSize.height));

    bottomRadius = (area.width / 2) - (lineWidth / 2);
    endBottom = bottomRadius + lineWidth;
    if (top >= area.height - neckSize.height) {
      topRadius =
          bottomRadius = minRadius = (area.width / 2) - neckSize.width / 2;
      endTop = endBottom = endMin = (area.width / 2) + neckSize.width / 2;
    } else if (bottom > (area.height - neckSize.height)) {
      minRadius = bottomRadius = (area.width / 2) - lineWidth / 2;
      endMin = endBottom = minRadius + lineWidth;
      bottomY = area.height - neckSize.height;
    }
    top += seriesTop;
    bottom += seriesTop;
    bottomY = (bottomY != null) ? (bottomY + seriesTop) : null;
    final List<num> values = <num>[
      emptySpaceAtLeft,
      offset,
      topRadius,
      endTop,
      endBottom,
      bottomRadius,
      endMin,
      top,
      bottom
    ];
    _addPathToCurrentPoint(currentPoint, values, minRadius, bottomY);
    _calculatePathSegment(seriesRenderer._seriesType, currentPoint);
  }

  void _addPathToCurrentPoint(PointInfo<dynamic> currentPoint, List<num> values,
      num? minRadius, num? bottomY) {
    late num line1X,
        line1Y,
        line2X,
        line2Y,
        line3X,
        line3Y,
        line4X,
        line4Y,
        line5X,
        line5Y,
        line6X,
        line6Y;
    line1X = values[0] + values[1] + values[2];
    line1Y = values[7];
    line2X = values[0] + values[1] + values[3];
    line2Y = values[7];
    line4X = values[0] + values[1] + values[4];
    line4Y = values[8];
    line5X = values[0] + values[1] + values[5];
    line5Y = values[8];
    line3X = values[0] + values[1] + values[4];
    line3Y = values[8];
    line6X = values[0] + values[1] + values[5];
    line6Y = values[8];
    if (bottomY != null) {
      line3X = values[0] + values[1] + values[6];
      line3Y = bottomY;
      line6X = values[0] + values[1] + ((minRadius != null) ? minRadius : 0);
      line6Y = bottomY;
    }
    currentPoint.pathRegion.add(Offset(line1X.toDouble(), line1Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line2X.toDouble(), line2Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line3X.toDouble(), line3Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line4X.toDouble(), line4Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line5X.toDouble(), line5Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line6X.toDouble(), line6Y.toDouble()));
  }

  /// To calculate the funnel segments and render path
  void _calculateFunnelSegments(
      Canvas canvas, int pointIndex, FunnelSeriesRenderer seriesRenderer) {
    _calculateFunnelPathRegion(pointIndex, seriesRenderer);
    final PointInfo<dynamic> currentPoint =
        seriesRenderer._renderPoints[pointIndex];
    final Path path = Path();
    path.moveTo(currentPoint.pathRegion[0].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[1].dy);
    path.lineTo(currentPoint.pathRegion[2].dx, currentPoint.pathRegion[2].dy);
    path.lineTo(currentPoint.pathRegion[3].dx, currentPoint.pathRegion[3].dy);
    path.lineTo(currentPoint.pathRegion[4].dx, currentPoint.pathRegion[4].dy);
    path.lineTo(currentPoint.pathRegion[5].dx, currentPoint.pathRegion[5].dy);
    path.close();
    if (pointIndex == seriesRenderer._renderPoints.length - 1) {
      seriesRenderer._maximumDataLabelRegion = path.getBounds();
    }
    _segmentPaint(canvas, path, pointIndex, seriesRenderer);
  }

  /// To paint the funnel segments
  void _segmentPaint(Canvas canvas, Path path, int pointIndex,
      FunnelSeriesRenderer seriesRenderer) {
    final PointInfo<dynamic> point = seriesRenderer._renderPoints[pointIndex];
    final _StyleOptions? style =
        _getPointStyle(pointIndex, seriesRenderer, _chartState, point);

    final Color fillColor =
        style != null && style.fill != null ? style.fill! : point.fill;

    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor!
        : point.borderColor;

    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth!.toDouble()
        : point.borderWidth.toDouble();

    final double opacity = style != null && style.opacity != null
        ? style.opacity!.toDouble()
        : currentSeries.opacity.toDouble();

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

  /// To add selection points to selection list
  void _seriesPointSelection(int pointIndex, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final SfFunnelChart chart = _chartState._chart;
    final FunnelSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[0];
    final List<int> selectionData = _chartState._renderingDetails.selectionData;
    int? currentSelectedIndex;
    const int seriesIndex = 0;
    if (seriesRenderer._isSelectionEnable && mode == chart.selectionGesture) {
      if (selectionData.isNotEmpty) {
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
        for (int i = 0; i < selectionData.length; i++) {
          selectionIndex = selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected =
                selectionData.length == 1 && pointIndex == selectionIndex;
            if (seriesRenderer._selectionBehavior.toggleSelection == true ||
                !isPointAlreadySelected) {
              selectionData.removeAt(i);
            }
            _chartState._renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
          } else if (pointIndex == selectionIndex) {
            if (seriesRenderer._selectionBehavior.toggleSelection == true) {
              selectionData.removeAt(i);
            }
            isPointAlreadySelected = true;
            _chartState._renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        selectionData.add(pointIndex);
        _chartState._renderingDetails.seriesRepaintNotifier.value++;
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
      FunnelSeriesRenderer seriesRenderer,
      SfFunnelChartState _chartState,
      PointInfo<dynamic> point) {
    _StyleOptions? pointStyle;
    final dynamic selection = seriesRenderer._series.selectionBehavior;
    final List<int> selectionData = _chartState._renderingDetails.selectionData;
    if (selection.enable == true) {
      if (selectionData.isNotEmpty) {
        int selectionIndex;
        for (int i = 0; i < selectionData.length; i++) {
          selectionIndex = selectionData[i];
          if (currentPointIndex == selectionIndex) {
            pointStyle = _StyleOptions(
                fill: _selectionArgs != null
                    ? _selectionArgs!.selectedColor
                    : selection.selectedColor,
                strokeWidth: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderWidth
                    : selection.selectedBorderWidth,
                strokeColor: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderColor
                    : selection.selectedBorderColor,
                opacity: selection.selectedOpacity);
            break;
          } else if (i == selectionData.length - 1) {
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
      FunnelSeriesRenderer seriesRenderer, int seriesIndex, int pointIndex) {
    final SfFunnelChart chart = seriesRenderer._chartState._chart;
    if (pointIndex < chart.series.dataSource!.length) {
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
      _selectionArgs!.unselectedBorderColor =
          selectionBehavior.unselectedBorderColor;
      _selectionArgs!.unselectedBorderWidth =
          selectionBehavior.unselectedBorderWidth;
      _selectionArgs!.selectedColor = selectionBehavior.selectedColor;
      _selectionArgs!.unselectedColor = selectionBehavior.unselectedColor;
    }
    return _selectionArgs!;
  }
}
