part of charts;

class _CircularSeries {
  _CircularSeries(this._chartState);

  final SfCircularChartState _chartState;

  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this..
  SfCircularChart get chart => _chartState._chart;

  CircularSeries<dynamic, dynamic> currentSeries;

  num size;

  num sumOfGroup;

  _Region explodedRegion;

  _Region selectRegion;

  List<CircularSeriesRenderer> visibleSeriesRenderers =
      <CircularSeriesRenderer>[];

  /// To find the visible series
  void _findVisibleSeries() {
    CircularSeries<dynamic, dynamic> series;
    for (final CircularSeriesRenderer seriesRenderer
        in _chartState._chartSeries.visibleSeriesRenderers) {
      _setSeriesType(seriesRenderer);
      series = seriesRenderer._series = chart.series[0];
      seriesRenderer._dataPoints = <ChartPoint<dynamic>>[];
      seriesRenderer._needsAnimation = false;
      final List<ChartPoint<dynamic>> _oldPoints =
          _chartState._prevSeriesRenderer?._oldRenderPoints;
      final CircularSeries<dynamic, dynamic> oldSeries =
          _chartState._prevSeriesRenderer?._series;
      int oldPointIndex = 0;
      if (series.dataSource != null) {
        for (int pointIndex = 0;
            pointIndex < series.dataSource.length;
            pointIndex++) {
          final ChartPoint<dynamic> currentPoint =
              _getCircularPoint(seriesRenderer, pointIndex);
          if (currentPoint.x != null) {
            seriesRenderer._dataPoints.add(currentPoint);
            if (!seriesRenderer._needsAnimation) {
              if (oldSeries != null) {
                seriesRenderer._needsAnimation =
                    (oldSeries.startAngle != series.startAngle) ||
                        (oldSeries.endAngle != series.endAngle);
              }
              if (_oldPoints != null &&
                  _oldPoints.isNotEmpty &&
                  !seriesRenderer._needsAnimation &&
                  oldPointIndex < _oldPoints.length) {
                seriesRenderer._needsAnimation =
                    isDataUpdated(currentPoint, _oldPoints[oldPointIndex++]);
              } else {
                seriesRenderer._needsAnimation = true;
              }
            }
          }
        }
      }
      if (series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null) {
        _sortDataSource(seriesRenderer);
      }
      visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
      break;
    }
  }

  bool isDataUpdated(ChartPoint<dynamic> point, ChartPoint<dynamic> oldPoint) {
    return point.x != oldPoint.x ||
        point.y != oldPoint.y ||
        point.sortValue != oldPoint.sortValue;
  }

  /// To calculate circular empty points in chart
  void _calculateCircularEmptyPoints(CircularSeriesRenderer seriesRenderer) {
    final List<ChartPoint<dynamic>> points = seriesRenderer._dataPoints;
    for (int i = 0; i < points.length; i++) {
      if (points[i].y == null) {
        seriesRenderer._series
            .calculateEmptyPointValue(i, points[i], seriesRenderer);
      }
    }
  }

  /// To process data points from series
  void _processDataPoints(CircularSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    _calculateCircularEmptyPoints(seriesRenderer);
    _findingGroupPoints();
  }

  /// Sort the dataSource
  void _sortDataSource(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._dataPoints.sort(
        // ignore: missing_return
        (ChartPoint<dynamic> firstPoint, ChartPoint<dynamic> secondPoint) {
      if (seriesRenderer._series.sortingOrder == SortingOrder.ascending) {
        return (firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue.compareTo(secondPoint.sortValue)));
      } else if (seriesRenderer._series.sortingOrder ==
          SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue.compareTo(firstPoint.sortValue)));
      }
    });
  }

  /// To group points based on group mode
  void _findingGroupPoints() {
    final List<CircularSeriesRenderer> seriesRenderers =
        _chartState._chartSeries.visibleSeriesRenderers;
    final CircularSeriesRenderer seriesRenderer = seriesRenderers[0];
    final num groupValue = currentSeries.groupTo;
    final CircularChartGroupMode mode = currentSeries.groupMode;
    bool isYText;
    final ChartIndexedValueMapper<String> textMapping =
        currentSeries.dataLabelMapper;
    ChartPoint<dynamic> point;
    sumOfGroup = 0;
    seriesRenderer._renderPoints = <ChartPoint<dynamic>>[];
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      point = seriesRenderer._dataPoints[i];
      //ignore: prefer_if_null_operators
      point.text = point.text == null
          ? textMapping != null
              ? textMapping(i) ?? point.y.toString()
              : point.y.toString()
          : point.text;
      isYText = point.text == point.y.toString() ? true : false;

      if (point.isVisible) {
        if (mode == CircularChartGroupMode.point &&
            groupValue != null &&
            i >= groupValue) {
          sumOfGroup += point.y.abs();
        } else if (mode == CircularChartGroupMode.value &&
            groupValue != null &&
            point.y <= groupValue) {
          sumOfGroup += point.y.abs();
        } else {
          seriesRenderer._renderPoints.add(point);
        }
      }
    }

    if (sumOfGroup > 0) {
      seriesRenderer._renderPoints
          .add(ChartPoint<dynamic>('Others', sumOfGroup));
      seriesRenderer
              ._renderPoints[seriesRenderer._renderPoints.length - 1].text =
          isYText == true ? 'Others : ' + sumOfGroup.toString() : 'Others';
    }
    _setPointStyle(seriesRenderer);
  }

  /// To set point properties
  void _setPointStyle(CircularSeriesRenderer seriesRenderer) {
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final List<Color> palette = chart.palette;
    int i = 0;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      point.fill = point.isEmpty && empty.color != null
          ? empty.color
          : point.pointColor ?? palette[i % palette.length];
      point.color = point.fill;
      point.strokeColor = point.isEmpty && empty.borderColor != null
          ? empty.borderColor
          : currentSeries.borderColor;
      point.strokeWidth = point.isEmpty && empty.borderWidth != null
          ? empty.borderWidth
          : currentSeries.borderWidth;
      point.strokeColor =
          point.strokeWidth == 0 ? Colors.transparent : point.strokeColor;

      if (chart.legend.legendItemBuilder != null) {
        final List<_MeasureWidgetContext> legendToggles =
            _chartState._legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            final _MeasureWidgetContext item = legendToggles[j];
            if (i == item.pointIndex) {
              point.isVisible = false;
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
              point.isVisible = false;
              break;
            }
          }
        }
      }
      i++;
    }
  }

  /// To calculate angle, radius and center positions of circular charts
  void _calculateAngleAndCenterPositions(
      CircularSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    _findSumOfPoints(seriesRenderer);
    _calculateAngle(seriesRenderer);
    _calculateRadius(seriesRenderer);
    _calculateOrigin(seriesRenderer);
    _calculateStartAndEndAngle(seriesRenderer);
    _calculateCenterPosition(seriesRenderer);
  }

  /// To calculate circular rect position  for  rendering chart
  void _calculateCenterPosition(CircularSeriesRenderer seriesRenderer) {
    if (_chartState._needToMoveFromCenter &&
        currentSeries.pointRadiusMapper == null &&
        (seriesRenderer._seriesType == 'pie' ||
            seriesRenderer._seriesType == 'doughnut')) {
      final Rect areaRect = _chartState._chartAreaRect;
      bool needExecute = true;
      double radius = seriesRenderer._currentRadius;
      while (needExecute) {
        radius += 1;
        final Rect circularRect = _getArcPath(
                0.0,
                radius,
                seriesRenderer._center,
                seriesRenderer._start,
                seriesRenderer._end,
                seriesRenderer._totalAngle,
                chart,
                true)
            .getBounds();
        if (circularRect.width > areaRect.width) {
          needExecute = false;
          seriesRenderer._rect = circularRect;
          break;
        }
        if (circularRect.height > areaRect.height) {
          needExecute = false;
          seriesRenderer._rect = circularRect;
          break;
        }
      }
      seriesRenderer._rect = _getArcPath(
              0.0,
              seriesRenderer._currentRadius,
              seriesRenderer._center,
              seriesRenderer._start,
              seriesRenderer._end,
              seriesRenderer._totalAngle,
              chart,
              true)
          .getBounds();
      for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
        point.outerRadius = seriesRenderer._currentRadius;
      }
    }
  }

  /// To calculate start and end angle of circular charts
  void _calculateStartAndEndAngle(CircularSeriesRenderer seriesRenderer) {
    int pointIndex = 0;
    num pointEndAngle;
    num pointStartAngle = seriesRenderer._start;
    final num innerRadius = seriesRenderer._currentInnerRadius;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        point.innerRadius =
            (seriesRenderer._seriesType == 'doughnut') ? innerRadius : 0.0;
        point.degree = (point.y.abs() /
                (seriesRenderer._sumOfPoints != 0
                    ? seriesRenderer._sumOfPoints
                    : 1)) *
            seriesRenderer._totalAngle;
        pointEndAngle = pointStartAngle + point.degree;
        point.startAngle = pointStartAngle;
        point.endAngle = pointEndAngle;
        point.midAngle = (pointStartAngle + pointEndAngle) / 2;
        point.outerRadius = _calculatePointRadius(
            point.radius, point, seriesRenderer._currentRadius);
        point.center = _needExplode(pointIndex, currentSeries)
            ? _findExplodeCenter(
                point.midAngle, seriesRenderer, point.outerRadius)
            : seriesRenderer._center;
        if (currentSeries.dataLabelSettings != null) {
          _findDataLabelPosition(point);
        }
        pointStartAngle = pointEndAngle;
      }
      pointIndex++;
    }
  }

  /// To check need for explode
  bool _needExplode(int pointIndex, CircularSeries<dynamic, dynamic> series) {
    bool isNeedExplode = false;
    final SfCircularChartState chartState = _chartState;
    if (series.explode) {
      if (chartState._initialRender) {
        if (pointIndex == series.explodeIndex || series.explodeAll) {
          chartState._explodedPoints.add(pointIndex);
          isNeedExplode = true;
        }
      } else if (chartState._widgetNeedUpdate || chartState._isLegendToggled) {
        isNeedExplode = chartState._explodedPoints.contains(pointIndex);
      }
    }
    return isNeedExplode;
  }

  /// To find sum of points in the series
  void _findSumOfPoints(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._sumOfPoints = 0;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y.abs();
      }
    }
  }

  /// To calculate angle of series
  void _calculateAngle(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._start = currentSeries.startAngle < 0
        ? currentSeries.startAngle < -360
            ? (currentSeries.startAngle % 360) + 360
            : currentSeries.startAngle + 360
        : currentSeries.startAngle;
    seriesRenderer._end = currentSeries.endAngle < 0
        ? currentSeries.endAngle < -360
            ? (currentSeries.endAngle % 360) + 360
            : currentSeries.endAngle + 360
        : currentSeries.endAngle;
    seriesRenderer._start = seriesRenderer._start > 360
        ? seriesRenderer._start % 360
        : seriesRenderer._start;
    seriesRenderer._end = seriesRenderer._end > 360
        ? seriesRenderer._end % 360
        : seriesRenderer._end;
    seriesRenderer._start -= 90;
    seriesRenderer._end -= 90;
    seriesRenderer._end = seriesRenderer._start == seriesRenderer._end
        ? seriesRenderer._start + 360
        : seriesRenderer._end;
    seriesRenderer._totalAngle = seriesRenderer._start > seriesRenderer._end
        ? (seriesRenderer._start - 360).abs() + seriesRenderer._end
        : (seriesRenderer._start - seriesRenderer._end).abs();
  }

  /// To calculate radius of circular chart
  void _calculateRadius(CircularSeriesRenderer seriesRenderer) {
    final SfCircularChartState chartState = _chartState;
    final Rect chartAreaRect = chartState._chartAreaRect;
    size = min(chartAreaRect.width, chartAreaRect.height);
    seriesRenderer._currentRadius =
        _percentToValue(currentSeries.radius, size / 2).toDouble();
    seriesRenderer._currentInnerRadius = _percentToValue(
        currentSeries.innerRadius, seriesRenderer._currentRadius);
  }

  /// To calculate center location of chart
  void _calculateOrigin(CircularSeriesRenderer seriesRenderer) {
    final SfCircularChartState chartState = _chartState;
    final Rect chartAreaRect = chartState._chartAreaRect;
    final Rect chartContainerRect = chartState._chartContainerRect;
    seriesRenderer._center = Offset(
        _percentToValue(chart.centerX, chartAreaRect.width).toDouble(),
        _percentToValue(chart.centerY, chartAreaRect.height).toDouble());
    seriesRenderer._center = Offset(
        seriesRenderer._center.dx +
            (chartContainerRect.width - chartAreaRect.width).abs() / 2,
        seriesRenderer._center.dy +
            (chartContainerRect.height - chartAreaRect.height).abs() / 2);
    chartState._centerLocation = seriesRenderer._center;
  }

  /// To find explode center position
  Offset _findExplodeCenter(
      num midAngle, CircularSeriesRenderer seriesRenderer, num currentRadius) {
    final num explodeCenter =
        _percentToValue(seriesRenderer._series.explodeOffset, currentRadius);
    return _degreeToPoint(midAngle, explodeCenter, seriesRenderer._center);
  }

  /// To calculate and return point radius
  num _calculatePointRadius(
      dynamic value, ChartPoint<dynamic> point, num radius) {
    if (value != null) {
      radius = value != null ? _percentToValue(value, size / 2) : radius;
    }
    return radius;
  }

  /// To add selection points to selection list
  void _seriesPointSelection(_Region pointRegion, ActivationMode mode,
      [int pointIndex, int seriesIndex]) {
    bool isPointAlreadySelected = false;
    pointIndex = pointRegion != null ? pointRegion.pointIndex : pointIndex;
    seriesIndex = pointRegion != null ? pointRegion.seriesIndex : seriesIndex;
    final SfCircularChartState chartState = _chartState;
    final CircularSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[seriesIndex];
    int currentSelectedIndex;
    if (seriesRenderer._isSelectionEnable && mode == chart.selectionGesture) {
      if (chartState._selectionData.isNotEmpty) {
        if (!chart.enableMultiSelection &&
            chartState._selectionData.isNotEmpty &&
            chartState._selectionData.length > 1) {
          if (chartState._selectionData.contains(pointIndex)) {
            currentSelectedIndex = pointIndex;
          }
          chartState._selectionData.clear();
          if (currentSelectedIndex != null) {
            chartState._selectionData.add(pointIndex);
          }
        }
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

  void _seriesPointExplosion(_Region pointRegion) {
    bool existExplodedRegion = false;
    final SfCircularChartState chartState = _chartState;
    final CircularSeriesRenderer seriesRenderer = _chartState
        ._chartSeries.visibleSeriesRenderers[pointRegion.seriesIndex];
    final ChartPoint<dynamic> point =
        seriesRenderer._renderPoints[pointRegion.pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState._explodedPoints.isNotEmpty) {
        if (chartState._explodedPoints.length == 1 &&
            chartState._explodedPoints.contains(pointRegion.pointIndex)) {
          existExplodedRegion = true;
          point.center = seriesRenderer._center;
          final int index =
              chartState._explodedPoints.indexOf(pointRegion.pointIndex);
          chartState._explodedPoints.removeAt(index);
          chartState._seriesRepaintNotifier.value++;
        } else if (seriesRenderer._series.explodeAll &&
            chartState._explodedPoints.length > 1 &&
            chartState._explodedPoints.contains(pointRegion.pointIndex)) {
          for (int i = 0; i < chartState._explodedPoints.length; i++) {
            final int explodeIndex = chartState._explodedPoints[i];
            seriesRenderer._renderPoints[explodeIndex].center =
                seriesRenderer._center;
            chartState._explodedPoints.removeAt(i);
            i--;
          }
          existExplodedRegion = true;
          chartState._seriesRepaintNotifier.value++;
        } else if (chartState._explodedPoints.length == 1) {
          for (int i = 0; i < chartState._explodedPoints.length; i++) {
            final int explodeIndex = chartState._explodedPoints[i];
            seriesRenderer._renderPoints[explodeIndex].center =
                seriesRenderer._center;
            chartState._explodedPoints.removeAt(i);
            chartState._seriesRepaintNotifier.value++;
          }
        }
      }
      if (!existExplodedRegion) {
        point.center = _findExplodeCenter(
            point.midAngle, seriesRenderer, point.outerRadius);
        chartState._explodedPoints.add(pointRegion.pointIndex);
        chartState._seriesRepaintNotifier.value++;
      }
    }
  }

  /// Setting series type
  void _setSeriesType(CircularSeriesRenderer seriesRenderer) {
    if (seriesRenderer is PieSeriesRenderer) {
      seriesRenderer._seriesType = 'pie';
    } else if (seriesRenderer is DoughnutSeriesRenderer) {
      seriesRenderer._seriesType = 'doughnut';
    } else if (seriesRenderer is RadialBarSeriesRenderer) {
      seriesRenderer._seriesType = 'radialbar';
    }
  }
}
