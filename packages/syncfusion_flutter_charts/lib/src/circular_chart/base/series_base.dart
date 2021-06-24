part of charts;

class _CircularSeries {
  _CircularSeries(this._chartState);

  final SfCircularChartState _chartState;

  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this..
  SfCircularChart get chart => _chartState._chart;

  late CircularSeries<dynamic, dynamic> currentSeries;

  late num size;

  late num sumOfGroup;

  late _Region explodedRegion;

  late _Region selectRegion;

  List<CircularSeriesRenderer> visibleSeriesRenderers =
      <CircularSeriesRenderer>[];

  /// To find the visible series
  void _findVisibleSeries() {
    CircularSeries<dynamic, dynamic> series;
    List<ChartPoint<dynamic>>? _oldPoints;
    CircularSeries<dynamic, dynamic>? oldSeries;
    int oldPointIndex = 0;
    ChartPoint<dynamic> currentPoint;
    for (final CircularSeriesRenderer seriesRenderer
        in _chartState._chartSeries.visibleSeriesRenderers) {
      _setSeriesType(seriesRenderer);
      series = seriesRenderer._series = chart.series[0];
      seriesRenderer._dataPoints = <ChartPoint<dynamic>>[];
      seriesRenderer._needsAnimation = false;
      _oldPoints = _chartState._prevSeriesRenderer?._oldRenderPoints;
      oldSeries = _chartState._prevSeriesRenderer?._series;
      oldPointIndex = 0;
      if (series.dataSource != null) {
        for (int pointIndex = 0;
            pointIndex < series.dataSource!.length;
            pointIndex++) {
          currentPoint = _getCircularPoint(seriesRenderer, pointIndex);
          if (currentPoint.x != null) {
            seriesRenderer._dataPoints.add(currentPoint);
            if (!seriesRenderer._needsAnimation) {
              if (oldSeries != null) {
                seriesRenderer._needsAnimation =
                    (oldSeries.startAngle != series.startAngle) ||
                        (oldSeries.endAngle != series.endAngle);
              }

              seriesRenderer._needsAnimation = !(_oldPoints != null &&
                      _oldPoints.isNotEmpty &&
                      !seriesRenderer._needsAnimation &&
                      oldPointIndex < _oldPoints.length) ||
                  isDataUpdated(currentPoint, _oldPoints[oldPointIndex++]);
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
                    : firstPoint.sortValue
                        .compareTo(secondPoint.sortValue))) as int;
      } else if (seriesRenderer._series.sortingOrder ==
          SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue! is String
                    ? secondPoint.sortValue!
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue!.toLowerCase())
                    : secondPoint.sortValue!
                        .compareTo(firstPoint.sortValue))) as int;
      } else {
        return 0;
      }
    });
  }

  /// To group points based on group mode
  void _findingGroupPoints() {
    final List<CircularSeriesRenderer> seriesRenderers =
        _chartState._chartSeries.visibleSeriesRenderers;
    final CircularSeriesRenderer seriesRenderer = seriesRenderers[0];
    final double? groupValue = currentSeries.groupTo;
    final CircularChartGroupMode? mode = currentSeries.groupMode;
    late bool isYText;
    final ChartIndexedValueMapper<String>? textMapping =
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
      isYText = point.text == point.y.toString();

      if (point.isVisible) {
        if (groupValue != null &&
            ((mode == CircularChartGroupMode.point && i >= groupValue) ||
                (mode == CircularChartGroupMode.value &&
                    point.y! <= groupValue))) {
          sumOfGroup += point.y!.abs();
        } else {
          seriesRenderer._renderPoints!.add(point);
        }
      }
    }

    if (sumOfGroup > 0) {
      seriesRenderer._renderPoints!
          .add(ChartPoint<dynamic>('Others', sumOfGroup));
      seriesRenderer
              ._renderPoints![seriesRenderer._renderPoints!.length - 1].text =
          isYText == true ? 'Others : ' + sumOfGroup.toString() : 'Others';
    }
    _setPointStyle(seriesRenderer);
  }

  /// To set point properties
  void _setPointStyle(CircularSeriesRenderer seriesRenderer) {
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final List<Color> palette = chart.palette;
    int i = 0;
    List<_MeasureWidgetContext> legendToggles;
    _MeasureWidgetContext item;
    _LegendRenderContext legendRenderContext;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints!) {
      // ignore: unnecessary_null_comparison
      point.fill = point.isEmpty && empty.color != null
          ? empty.color
          : point.pointColor ?? palette[i % palette.length];
      point.color = point.fill;
      // ignore: unnecessary_null_comparison
      point.strokeColor = point.isEmpty && empty.borderColor != null
          ? empty.borderColor
          : currentSeries.borderColor;
      // ignore: unnecessary_null_comparison
      point.strokeWidth = point.isEmpty && empty.borderWidth != null
          ? empty.borderWidth
          : currentSeries.borderWidth;
      point.strokeColor =
          point.strokeWidth == 0 ? Colors.transparent : point.strokeColor;

      if (chart.legend.legendItemBuilder != null) {
        legendToggles =
            _chartState._renderingDetails.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            item = legendToggles[j];
            if (i == item.pointIndex) {
              point.isVisible = false;
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
      final Rect areaRect = _chartState._renderingDetails.chartAreaRect;
      bool needExecute = true;
      double radius =
          seriesRenderer._segmentRenderingValues['currentRadius']!.toDouble();
      while (needExecute) {
        radius += 1;
        final Rect circularRect = _getArcPath(
                0.0,
                radius,
                seriesRenderer._center!,
                seriesRenderer._segmentRenderingValues['start'],
                seriesRenderer._segmentRenderingValues['end'],
                seriesRenderer._segmentRenderingValues['totalAngle'],
                chart,
                true)
            .getBounds();
        if (circularRect.width > areaRect.width ||
            circularRect.height > areaRect.height) {
          needExecute = false;
          seriesRenderer._rect = circularRect;
          break;
        }
      }
      seriesRenderer._rect = _getArcPath(
              0.0,
              seriesRenderer._segmentRenderingValues['currentRadius']!,
              seriesRenderer._center!,
              seriesRenderer._segmentRenderingValues['start'],
              seriesRenderer._segmentRenderingValues['end'],
              seriesRenderer._segmentRenderingValues['totalAngle'],
              chart,
              true)
          .getBounds();
      for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints!) {
        point.outerRadius =
            seriesRenderer._segmentRenderingValues['currentRadius'];
      }
    }
  }

  /// To calculate start and end angle of circular charts
  void _calculateStartAndEndAngle(CircularSeriesRenderer seriesRenderer) {
    int pointIndex = 0;
    num pointEndAngle;
    num pointStartAngle = seriesRenderer._segmentRenderingValues['start']!;
    final num innerRadius =
        seriesRenderer._segmentRenderingValues['currentInnerRadius']!;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints!) {
      if (point.isVisible) {
        point.innerRadius =
            (seriesRenderer._seriesType == 'doughnut') ? innerRadius : 0.0;
        point.degree = (point.y!.abs() /
                (seriesRenderer._segmentRenderingValues['sumOfPoints']! != 0
                    ? seriesRenderer._segmentRenderingValues['sumOfPoints']!
                    : 1)) *
            seriesRenderer._segmentRenderingValues['totalAngle']!;
        pointEndAngle = pointStartAngle + point.degree!;
        point.startAngle = pointStartAngle;
        point.endAngle = pointEndAngle;
        point.midAngle = (pointStartAngle + pointEndAngle) / 2;
        point.outerRadius = _calculatePointRadius(point.radius, point,
            seriesRenderer._segmentRenderingValues['currentRadius']!);
        point.center = _needExplode(pointIndex, currentSeries)
            ? _findExplodeCenter(
                point.midAngle!, seriesRenderer, point.outerRadius!)
            : seriesRenderer._center;
        // ignore: unnecessary_null_comparison
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
      if (chartState._renderingDetails.initialRender!) {
        if (pointIndex == series.explodeIndex || series.explodeAll) {
          chartState._renderingDetails.explodedPoints.add(pointIndex);
          isNeedExplode = true;
        }
      } else if (!chartState._renderingDetails.initialRender!) {
        if (!chartState._renderingDetails.explodedPoints.contains(pointIndex) &&
            !chartState._renderingDetails.isLegendToggled) {
          if (pointIndex == series.explodeIndex || series.explodeAll) {
            chartState._renderingDetails.explodedPoints.add(pointIndex);
            isNeedExplode = true;
          } else if (!series.explodeAll &&
              chartState._renderingDetails.explodedPoints.isNotEmpty &&
              pointIndex <=
                  chartState._renderingDetails.explodedPoints.length - 1) {
            chartState._renderingDetails.explodedPoints.removeAt(pointIndex);
          }
        }
        isNeedExplode =
            chartState._renderingDetails.explodedPoints.contains(pointIndex);
      }
    }
    return isNeedExplode;
  }

  /// To find sum of points in the series
  void _findSumOfPoints(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._segmentRenderingValues['sumOfPoints'] = 0;
    for (final ChartPoint<dynamic> point in seriesRenderer._renderPoints!) {
      if (point.isVisible) {
        seriesRenderer._segmentRenderingValues['sumOfPoints'] =
            seriesRenderer._segmentRenderingValues['sumOfPoints']! +
                point.y!.abs();
      }
    }
  }

  /// To calculate angle of series
  void _calculateAngle(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._segmentRenderingValues['start'] =
        currentSeries.startAngle < 0
            ? currentSeries.startAngle < -360
                ? (currentSeries.startAngle % 360) + 360
                : currentSeries.startAngle + 360
            : currentSeries.startAngle;
    seriesRenderer._segmentRenderingValues['end'] = currentSeries.endAngle < 0
        ? currentSeries.endAngle < -360
            ? (currentSeries.endAngle % 360) + 360
            : currentSeries.endAngle + 360
        : currentSeries.endAngle;
    seriesRenderer._segmentRenderingValues['start'] =
        seriesRenderer._segmentRenderingValues['start']! > 360 == true
            ? seriesRenderer._segmentRenderingValues['start']! % 360
            : seriesRenderer._segmentRenderingValues['start']!;
    seriesRenderer._segmentRenderingValues['end'] =
        seriesRenderer._segmentRenderingValues['end']! > 360 == true
            ? seriesRenderer._segmentRenderingValues['end']! % 360
            : seriesRenderer._segmentRenderingValues['end']!;
    seriesRenderer._segmentRenderingValues['start'] =
        seriesRenderer._segmentRenderingValues['start']! - 90;
    seriesRenderer._segmentRenderingValues['end'] =
        seriesRenderer._segmentRenderingValues['end']! - 90;
    seriesRenderer._segmentRenderingValues['end'] =
        seriesRenderer._segmentRenderingValues['start']! ==
                seriesRenderer._segmentRenderingValues['end']!
            ? seriesRenderer._segmentRenderingValues['start']! + 360
            : seriesRenderer._segmentRenderingValues['end']!;
    seriesRenderer._segmentRenderingValues['totalAngle'] =
        seriesRenderer._segmentRenderingValues['start']! >
                    seriesRenderer._segmentRenderingValues['end']! ==
                true
            ? (seriesRenderer._segmentRenderingValues['start']! - 360).abs() +
                seriesRenderer._segmentRenderingValues['end']!
            : (seriesRenderer._segmentRenderingValues['start']! -
                    seriesRenderer._segmentRenderingValues['end']!)
                .abs();
  }

  /// To calculate radius of circular chart
  void _calculateRadius(CircularSeriesRenderer seriesRenderer) {
    final SfCircularChartState chartState = _chartState;
    final Rect chartAreaRect = chartState._renderingDetails.chartAreaRect;
    size = min(chartAreaRect.width, chartAreaRect.height);
    seriesRenderer._segmentRenderingValues['currentRadius'] =
        _percentToValue(currentSeries.radius, size / 2)!.toDouble();
    seriesRenderer._segmentRenderingValues['currentInnerRadius'] =
        _percentToValue(currentSeries.innerRadius,
            seriesRenderer._segmentRenderingValues['currentRadius']!)!;
  }

  /// To calculate center location of chart
  void _calculateOrigin(CircularSeriesRenderer seriesRenderer) {
    final SfCircularChartState chartState = _chartState;
    final Rect chartAreaRect = chartState._renderingDetails.chartAreaRect;
    final Rect chartContainerRect =
        chartState._renderingDetails.chartContainerRect;
    seriesRenderer._center = Offset(
        _percentToValue(chart.centerX, chartAreaRect.width)!.toDouble(),
        _percentToValue(chart.centerY, chartAreaRect.height)!.toDouble());
    seriesRenderer._center = Offset(
        seriesRenderer._center!.dx +
            (chartContainerRect.width - chartAreaRect.width).abs() / 2,
        seriesRenderer._center!.dy +
            (chartContainerRect.height - chartAreaRect.height).abs() / 2);
    chartState._centerLocation = seriesRenderer._center!;
  }

  /// To find explode center position
  Offset _findExplodeCenter(
      num midAngle, CircularSeriesRenderer seriesRenderer, num currentRadius) {
    final num explodeCenter =
        _percentToValue(seriesRenderer._series.explodeOffset, currentRadius)!;
    return _degreeToPoint(midAngle, explodeCenter, seriesRenderer._center!);
  }

  /// To calculate and return point radius
  num _calculatePointRadius(
      dynamic value, ChartPoint<dynamic> point, num radius) {
    radius = value != null ? _percentToValue(value, size / 2)! : radius;
    return radius;
  }

  /// To add selection points to selection list
  void _seriesPointSelection(_Region? pointRegion, ActivationMode mode,
      [int? pointIndex, int? seriesIndex]) {
    bool isPointAlreadySelected = false;
    pointIndex = pointRegion != null ? pointRegion.pointIndex : pointIndex;
    seriesIndex = pointRegion != null ? pointRegion.seriesIndex : seriesIndex;
    final SfCircularChartState chartState = _chartState;
    final CircularSeriesRenderer seriesRenderer =
        _chartState._chartSeries.visibleSeriesRenderers[seriesIndex!];
    int? currentSelectedIndex;
    if (seriesRenderer._isSelectionEnable && mode == chart.selectionGesture) {
      if (chartState._renderingDetails.selectionData.isNotEmpty) {
        if (!chart.enableMultiSelection &&
            chartState._renderingDetails.selectionData.isNotEmpty &&
            chartState._renderingDetails.selectionData.length > 1) {
          if (chartState._renderingDetails.selectionData.contains(pointIndex)) {
            currentSelectedIndex = pointIndex!;
          }
          chartState._renderingDetails.selectionData.clear();
          if (currentSelectedIndex != null) {
            chartState._renderingDetails.selectionData.add(pointIndex!);
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
        chartState._renderingDetails.selectionData.add(pointIndex!);
        chartState._renderingDetails.seriesRepaintNotifier.value++;
        if (chart.onSelectionChanged != null) {
          chart.onSelectionChanged!(
              _getSelectionEventArgs(seriesRenderer, seriesIndex, pointIndex));
        }
      }
    }
  }

  /// To perform slection event and return Selection Args
  SelectionArgs _getSelectionEventArgs(
      dynamic seriesRenderer, int seriesIndex, int pointIndex) {
    if (seriesRenderer != null) {
      final SelectionBehavior selectionBehavior =
          seriesRenderer._selectionBehavior;
      final SelectionArgs args = SelectionArgs(
          seriesRenderer: seriesRenderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: pointIndex);
      args.selectedBorderColor = selectionBehavior.selectedBorderColor;
      args.selectedBorderWidth = selectionBehavior.selectedBorderWidth;
      args.selectedColor = selectionBehavior.selectedColor;
      args.unselectedBorderColor = selectionBehavior.unselectedBorderColor;
      args.unselectedBorderWidth = selectionBehavior.unselectedBorderWidth;
      args.unselectedColor = selectionBehavior.unselectedColor;
      seriesRenderer._selectionArgs = args;
    }
    return seriesRenderer._selectionArgs as SelectionArgs;
  }

  void _seriesPointExplosion(_Region? pointRegion) {
    bool existExplodedRegion = false;
    final SfCircularChartState chartState = _chartState;
    final CircularSeriesRenderer seriesRenderer = _chartState
        ._chartSeries.visibleSeriesRenderers[pointRegion!.seriesIndex];
    final ChartPoint<dynamic> point =
        seriesRenderer._renderPoints![pointRegion.pointIndex];
    int explodeIndex;
    if (seriesRenderer._series.explode) {
      if (chartState._renderingDetails.explodedPoints.isNotEmpty) {
        if (chartState._renderingDetails.explodedPoints.length == 1 &&
            chartState._renderingDetails.explodedPoints
                .contains(pointRegion.pointIndex)) {
          existExplodedRegion = true;
          point.center = seriesRenderer._center;
          final int index = chartState._renderingDetails.explodedPoints
              .indexOf(pointRegion.pointIndex);
          chartState._renderingDetails.explodedPoints.removeAt(index);
          chartState._renderingDetails.seriesRepaintNotifier.value++;
          chartState._renderDataLabel!.state.dataLabelRepaintNotifier.value++;
        } else if (seriesRenderer._series.explodeAll &&
            chartState._renderingDetails.explodedPoints.length > 1 &&
            chartState._renderingDetails.explodedPoints
                .contains(pointRegion.pointIndex)) {
          for (int i = 0;
              i < chartState._renderingDetails.explodedPoints.length;
              i++) {
            explodeIndex = chartState._renderingDetails.explodedPoints[i];
            seriesRenderer._renderPoints![explodeIndex].center =
                seriesRenderer._center;
            chartState._renderingDetails.explodedPoints.removeAt(i);
            i--;
          }
          existExplodedRegion = true;
          chartState._renderingDetails.seriesRepaintNotifier.value++;
          chartState._renderDataLabel!.state.dataLabelRepaintNotifier.value++;
        } else if (chartState._renderingDetails.explodedPoints.length == 1) {
          for (int i = 0;
              i < chartState._renderingDetails.explodedPoints.length;
              i++) {
            explodeIndex = chartState._renderingDetails.explodedPoints[i];
            seriesRenderer._renderPoints![explodeIndex].center =
                seriesRenderer._center;
            chartState._renderingDetails.explodedPoints.removeAt(i);
            chartState._renderingDetails.seriesRepaintNotifier.value++;
            chartState._renderDataLabel!.state.dataLabelRepaintNotifier.value++;
          }
        }
      }
      if (!existExplodedRegion) {
        point.center = _findExplodeCenter(
            point.midAngle!, seriesRenderer, point.outerRadius!);
        chartState._renderingDetails.explodedPoints.add(pointRegion.pointIndex);
        chartState._renderingDetails.seriesRepaintNotifier.value++;
        chartState._renderDataLabel!.state.dataLabelRepaintNotifier.value++;
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
