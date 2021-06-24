part of charts;

class _ChartSeries {
  _ChartSeries(this._chartState);
  final SfCartesianChartState _chartState;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get chart => _chartState._chart;
  _RenderingDetails get _renderingDetails => _chartState._renderingDetails;
  bool isStacked100 = false;
  int paletteIndex = 0;
  num sumOfYvalues = 0;
  List<num> yValues = <num>[];

  /// Contains the visible series for chart
  List<CartesianSeriesRenderer> visibleSeriesRenderers =
      <CartesianSeriesRenderer>[];
  List<_ClusterStackedItemInfo> clusterStackedItemInfo =
      <_ClusterStackedItemInfo>[];

  bool _needAxisRangeAnimation = false;

  /// To get data and process data for rendering chart
  void _processData() {
    final List<CartesianSeriesRenderer> seriesRendererList =
        visibleSeriesRenderers;
    isStacked100 = false;
    paletteIndex = 0;
    _findAreaType(seriesRendererList);
    if (chart.indicators.isNotEmpty) {
      _populateDataPoints(seriesRendererList);
      _calculateIndicators();
      _chartState._chartAxis._calculateVisibleAxes();
      _findMinMax(seriesRendererList);
      _renderTrendline();
    } else {
      _chartState._chartAxis._calculateVisibleAxes();
      _populateDataPoints(seriesRendererList);
    }
    _calculateStackedValues(_findSeriesCollection(_chartState));
    _renderTrendline();
  }

  ///check whether axis animation applicable or not
  bool _needAxisAnimation(CartesianSeriesRenderer seriesRenderer,
      CartesianSeriesRenderer oldSeriesRenderer) {
    final dynamic oldAxis = oldSeriesRenderer._xAxisRenderer!._axis;
    final dynamic axis = seriesRenderer._xAxisRenderer!._axis;
    final bool needAnimation = seriesRenderer._series.animationDuration > 0 &&
        seriesRenderer._yAxisRenderer!.runtimeType ==
            oldSeriesRenderer._yAxisRenderer!.runtimeType &&
        seriesRenderer._xAxisRenderer!.runtimeType ==
            oldSeriesRenderer._xAxisRenderer!.runtimeType &&
        ((oldAxis.visibleMinimum != null &&
                oldAxis.visibleMinimum != axis.visibleMinimum) ||
            (oldAxis.visibleMaximum != null &&
                oldAxis.visibleMaximum != axis.visibleMaximum));
    _needAxisRangeAnimation = needAnimation;
    return needAnimation;
  }

  /// Find the data points for each series
  void _populateDataPoints(List<CartesianSeriesRenderer> seriesRendererList) {
    _chartState._totalAnimatingSeries = 0;
    bool isSelectionRangeChangeByEvent = false;
    for (final CartesianSeriesRenderer seriesRenderer in seriesRendererList) {
      final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
      final ChartIndexedValueMapper<num>? _bubbleSize = series.sizeValueMapper;
      seriesRenderer._minimumX = seriesRenderer._minimumY =
          seriesRenderer._minDelta =
              seriesRenderer._maximumX = seriesRenderer._maximumY = null;
      if (seriesRenderer is BubbleSeriesRenderer) {
        seriesRenderer._maxSize = seriesRenderer._minSize = null;
      }
      seriesRenderer._needAnimateSeriesElements = false;
      seriesRenderer._needsAnimation = false;
      seriesRenderer._reAnimate = false;
      CartesianChartPoint<dynamic>? currentPoint;
      yValues = <num>[];
      sumOfYvalues = 0;
      seriesRenderer._dataPoints = <CartesianChartPoint<dynamic>>[];
      if (seriesRenderer is FastLineSeriesRenderer) {
        seriesRenderer._overallDataPoints = <CartesianChartPoint<dynamic>>[];
      }
      seriesRenderer._xValues = <dynamic>[];
      if (!isStacked100 && seriesRenderer._seriesType.contains('100')) {
        isStacked100 = true;
      }
      if (seriesRenderer._visible!) {
        _chartState._totalAnimatingSeries++;
      }
      if (seriesRenderer is HistogramSeriesRenderer) {
        final HistogramSeries<dynamic, dynamic> series =
            seriesRenderer._series as HistogramSeries<dynamic, dynamic>;
        for (int pointIndex = 0;
            pointIndex < series.dataSource.length;
            pointIndex++) {
          yValues.add(series.yValueMapper!(pointIndex) ?? 0);
          sumOfYvalues += yValues[pointIndex];
        }
        seriesRenderer._processData(series, yValues, sumOfYvalues);
        seriesRenderer._histogramValues.minValue =
            seriesRenderer._histogramValues.yValues!.reduce(min);
        seriesRenderer._histogramValues.binWidth = series.binInterval ??
            ((3.5 * seriesRenderer._histogramValues.sDValue!) /
                    math.pow(
                        seriesRenderer._histogramValues.yValues!.length, 1 / 3))
                .round();
      }
      final String seriesType = seriesRenderer._seriesType;
      final bool needSorting = series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null;
      // ignore: unnecessary_null_comparison
      if (series.dataSource != null) {
        dynamic xVal;
        dynamic yVal;
        num? low, high;
        num maxYValue = 0;
        seriesRenderer._overAllDataPoints = <CartesianChartPoint<dynamic>?>[];
        for (int pointIndex = 0; pointIndex < series.dataSource.length;) {
          currentPoint = _getChartPoint(
              seriesRenderer, series.dataSource[pointIndex], pointIndex);
          xVal = currentPoint?.x;
          yVal = currentPoint?.y;
          high = currentPoint?.high;
          low = currentPoint?.low;
          currentPoint?.overallDataPointIndex = pointIndex;

          seriesRenderer._overAllDataPoints.add(currentPoint);
          if (seriesRenderer is WaterfallSeriesRenderer) {
            yVal ??= 0;
            maxYValue += yVal;
            currentPoint!.maxYValue = maxYValue;
          }

          if (xVal != null) {
            num bubbleSize;
            final dynamic xAxis = seriesRenderer._xAxisRenderer?._axis;
            final dynamic yAxis = seriesRenderer._yAxisRenderer?._axis;
            dynamic xMin = xAxis?.visibleMinimum;
            dynamic xMax = xAxis?.visibleMaximum;
            final dynamic yMin = yAxis?.visibleMinimum;
            final dynamic yMax = yAxis?.visibleMaximum;
            dynamic xPointValue = xVal;
            bool _isXVisibleRange = true;
            bool _isYVisibleRange = true;
            if (xAxis is DateTimeAxis) {
              xMin = xMin != null ? xMin.millisecondsSinceEpoch : xMin;
              xMax = xMax != null ? xMax.millisecondsSinceEpoch : xMax;
              xPointValue = xPointValue?.millisecondsSinceEpoch;
            } else if (xAxis is CategoryAxis) {
              xPointValue = pointIndex;
            } else if (xAxis is DateTimeCategoryAxis) {
              xMin = xMin != null ? xMin.millisecondsSinceEpoch : xMin;
              xMax = xMax != null ? xMax.millisecondsSinceEpoch : xMax;
              xPointValue = xPointValue?.millisecondsSinceEpoch;
            }
            if (xMin != null || xMax != null) {
              _isXVisibleRange = false;
            }
            if (yMin != null || yMax != null) {
              _isYVisibleRange = false;
            }

            if ((xMin != null ||
                    xMax != null ||
                    yMin != null ||
                    yMax != null) &&
                // ignore: unnecessary_null_comparison
                _chartState._oldSeriesRenderers != null &&
                _chartState._oldSeriesRenderers.isNotEmpty) {
              final int seriesIndex = _chartState
                  ._chartSeries.visibleSeriesRenderers
                  .indexOf(seriesRenderer);
              final CartesianSeriesRenderer? _oldSeriesRenderer =
                  _chartState._oldSeriesRenderers.length - 1 >= seriesIndex
                      ? _chartState._oldSeriesRenderers[seriesIndex]
                      : null;
              if (_oldSeriesRenderer != null &&
                  (_chartState._chart.onSelectionChanged != null ||
                      _needAxisAnimation(seriesRenderer, _oldSeriesRenderer))) {
                isSelectionRangeChangeByEvent =
                    _oldSeriesRenderer._minimumX != xMin ||
                        _oldSeriesRenderer._maximumX != xMax ||
                        _oldSeriesRenderer._minimumY != yMin ||
                        _oldSeriesRenderer._maximumY != yMax;
              }
            }

            if (!(!(isSelectionRangeChangeByEvent ||
                        _chartState._rangeChangeBySlider ||
                        _chartState._zoomedState == true ||
                        _chartState._zoomProgress) &&
                    (xMin != null ||
                        xMax != null ||
                        yMin != null ||
                        yMax != null) &&
                    (yVal != null || (low != null && high != null))) ||
                ((xMin != null && xMax != null)
                        ? (xPointValue >= xMin) == true &&
                            (xPointValue <= xMax) == true
                        : xMin != null
                            ? xPointValue >= xMin
                            : xMax != null
                                ? xPointValue <= xMax
                                : false) ==
                    true ||
                ((yMin != null && yMax != null)
                        ? ((yVal ?? low) >= yMin) == true &&
                            ((yVal ?? high) <= yMax) == true
                        : yMin != null
                            ? (yVal ?? low) >= yMin
                            : yMax != null
                                ? (yVal ?? high) <= yMax
                                : false) ==
                    true) {
              _isXVisibleRange = true;
              _isYVisibleRange = true;
              seriesRenderer._dataPoints.add(currentPoint!);
              seriesRenderer._xValues!.add(xVal);
              if (seriesRenderer is BubbleSeriesRenderer) {
                bubbleSize = series.sizeValueMapper == null
                    ? 4
                    : _bubbleSize!(pointIndex) ?? 4;
                currentPoint.bubbleSize = bubbleSize.toDouble();
                seriesRenderer._maxSize ??= currentPoint.bubbleSize!.toDouble();
                seriesRenderer._minSize ??= currentPoint.bubbleSize!.toDouble();
                seriesRenderer._maxSize = math.max(seriesRenderer._maxSize!,
                    currentPoint.bubbleSize!.toDouble());
                seriesRenderer._minSize = math.min(seriesRenderer._minSize!,
                    currentPoint.bubbleSize!.toDouble());
              }

              if (seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType.contains('candle') ||
                      seriesType == 'boxandwhisker'
                  ? seriesType == 'hiloopenclose' ||
                          seriesType.contains('candle')
                      ? (currentPoint.low == null ||
                          currentPoint.high == null ||
                          currentPoint.open == null ||
                          currentPoint.close == null)
                      : seriesType == 'boxandwhisker'
                          ? (currentPoint.minimum == null ||
                              currentPoint.maximum == null ||
                              currentPoint.lowerQuartile == null ||
                              currentPoint.upperQuartile == null)
                          : (currentPoint.low == null ||
                              currentPoint.high == null)
                  : currentPoint.y == null) {
                if (seriesRenderer is XyDataSeriesRenderer &&
                    seriesType != 'waterfall') {
                  seriesRenderer.calculateEmptyPointValue(
                      pointIndex, currentPoint, seriesRenderer);
                }
              }

              /// Below lines for changing high, low values based on input
              if ((seriesType.contains('range') ||
                      seriesType.contains('hilo') ||
                      seriesType.contains('candle') ||
                      seriesType == 'boxandwhisker') &&
                  currentPoint.isVisible) {
                if (seriesType == 'boxandwhisker') {
                  final num max = currentPoint.maximum!;
                  final num min = currentPoint.minimum!;
                  currentPoint.maximum = math.max<num>(max, min);
                  currentPoint.minimum = math.min<num>(max, min);
                } else {
                  final num high = currentPoint.high;
                  final num low = currentPoint.low;
                  currentPoint.high = math.max<num>(high, low);
                  currentPoint.low = math.min<num>(high, low);
                }
              }
              //determines whether the data source has been changed in-order to perform dynamic animation
              if (!seriesRenderer._needsAnimation &&
                  _needAxisRangeAnimation != true) {
                if (seriesRenderer._oldSeries == null ||
                    seriesRenderer._oldDataPoints!.length <
                        seriesRenderer._dataPoints.length) {
                  seriesRenderer._needAnimateSeriesElements = true;
                  seriesRenderer._needsAnimation = seriesRenderer._visible!;
                } else {
                  seriesRenderer._needsAnimation =
                      (seriesRenderer._dataPoints.length <=
                              seriesRenderer._oldDataPoints!.length)
                          ? seriesRenderer._visible! &&
                              _findChangesInPoint(
                                currentPoint,
                                seriesRenderer._oldDataPoints![
                                    seriesRenderer._dataPoints.length - 1],
                                seriesRenderer,
                              )
                          : seriesRenderer._visible!;
                }
              }
            }
            if (seriesRenderer._xAxisRenderer != null &&
                seriesRenderer._yAxisRenderer != null &&
                !needSorting &&
                chart.indicators.isEmpty) {
              _findMinMaxValue(
                  seriesRenderer._xAxisRenderer!,
                  seriesRenderer,
                  currentPoint!,
                  pointIndex,
                  series.dataSource.length,
                  _isXVisibleRange,
                  _isYVisibleRange);
            }
            if (seriesRenderer is SplineSeriesRenderer && !needSorting) {
              if (pointIndex == 0) {
                seriesRenderer._xValueList.clear();
                seriesRenderer._yValueList.clear();
              }
              if (!currentPoint!.isDrop) {
                seriesRenderer._xValueList.add(currentPoint.xValue);
                seriesRenderer._yValueList.add(currentPoint.yValue);
              }
            }
          }
          pointIndex = seriesRenderer._seriesType != 'histogram'
              ? pointIndex + 1
              : pointIndex + yVal as int;
        }
        if (seriesRenderer._xAxisRenderer is DateTimeCategoryAxisRenderer) {
          _sortDateTimeCategoryDetails(seriesRenderer);
        }
        if (needSorting) {
          _sortDataSource(seriesRenderer);
          if (chart.indicators.isEmpty) {
            _findSeriesMinMax(seriesRenderer);
          }
        }
      }
      if (seriesRenderer is FastLineSeriesRenderer) {
        seriesRenderer._overallDataPoints.addAll(seriesRenderer._dataPoints);
      }
    }
  }

  /// To find the minimum and maximum values for axis
  void _findMinMaxValue(
      ChartAxisRenderer axisRenderer,
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      int dataLength,
      [bool? isXVisibleRange,
      bool? isYVisibleRange]) {
    if (seriesRenderer._visible!) {
      if (axisRenderer is NumericAxisRenderer) {
        axisRenderer._findAxisMinMaxValues(seriesRenderer, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisRenderer is CategoryAxisRenderer) {
        axisRenderer._findAxisMinMaxValues(seriesRenderer, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisRenderer is DateTimeAxisRenderer) {
        axisRenderer._findAxisMinMaxValues(seriesRenderer, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisRenderer is LogarithmicAxisRenderer) {
        axisRenderer._findAxisMinMaxValues(seriesRenderer, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
        axisRenderer._findAxisMinMaxValues(seriesRenderer, currentPoint,
            pointIndex, dataLength, isXVisibleRange, isYVisibleRange);
      }
    }
  }

  /// To find minimum and maximum series values
  void _findSeriesMinMax(CartesianSeriesRenderer seriesRenderer) {
    final ChartAxisRenderer axisRenderer = seriesRenderer._xAxisRenderer!;
    if (seriesRenderer._visible!) {
      if (seriesRenderer is SplineSeriesRenderer) {
        seriesRenderer._xValueList.clear();
        seriesRenderer._yValueList.clear();
      }
      for (int pointIndex = 0;
          pointIndex < seriesRenderer._dataPoints.length;
          pointIndex++) {
        _findMinMaxValue(
            axisRenderer,
            seriesRenderer,
            seriesRenderer._dataPoints[pointIndex],
            pointIndex,
            seriesRenderer._dataPoints.length,
            true,
            true);
        if (seriesRenderer is SplineSeriesRenderer) {
          if (!seriesRenderer._dataPoints[pointIndex].isDrop) {
            seriesRenderer._xValueList
                .add(seriesRenderer._dataPoints[pointIndex].xValue);
            seriesRenderer._yValueList
                .add(seriesRenderer._dataPoints[pointIndex].yValue);
          }
        }
      }
    }
  }

  /// To find minimum and maximum in series collection
  void _findMinMax(List<CartesianSeriesRenderer> seriesCollection) {
    for (int seriesIndex = 0;
        seriesIndex < seriesCollection.length;
        seriesIndex++) {
      _findSeriesMinMax(seriesCollection[seriesIndex]);
    }
  }

  /// To render a trendline
  void _renderTrendline() {
    for (final CartesianSeriesRenderer seriesRenderer
        in visibleSeriesRenderers) {
      if (seriesRenderer._series.trendlines != null) {
        TrendlineRenderer trendlineRenderer;
        Trendline trendline;
        for (int i = 0; i < seriesRenderer._series.trendlines!.length; i++) {
          trendline = seriesRenderer._series.trendlines![i];
          trendlineRenderer = seriesRenderer._trendlineRenderer[i];
          trendlineRenderer._isNeedRender = trendlineRenderer._visible ==
                  true &&
              seriesRenderer._visible! &&
              (trendline.type == TrendlineType.polynomial
                  ? (trendline.polynomialOrder >= 2 &&
                      trendline.polynomialOrder <= 6)
                  : !(trendline.type == TrendlineType.movingAverage) ||
                      (trendline.period >= 2 &&
                          trendline.period <=
                              seriesRenderer._series.dataSource.length - 1));
          trendlineRenderer._animationController =
              AnimationController(vsync: _chartState)
                ..addListener(_chartState._repaintTrendlines);
          _chartState._controllerList[trendlineRenderer._animationController] =
              _chartState._repaintTrendlines;
          if (trendlineRenderer._isNeedRender) {
            trendlineRenderer._setDataSource(seriesRenderer, chart);
          }
        }
      }
    }
  }

  /// Sort the dataSource
  void _sortDataSource(CartesianSeriesRenderer seriesRenderer) {
    seriesRenderer._dataPoints.sort(
        // ignore: missing_return
        (CartesianChartPoint<dynamic> firstPoint,
            CartesianChartPoint<dynamic> secondPoint) {
      if (seriesRenderer._series.sortingOrder == SortingOrder.ascending) {
        return ((firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue
                        .compareTo(secondPoint.sortValue)))) as int;
      } else if (seriesRenderer._series.sortingOrder ==
          SortingOrder.descending) {
        return ((firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue
                        .compareTo(firstPoint.sortValue)))) as int;
      } else {
        return 0;
      }
    });
  }

  /// To calculate stacked values of a stacked series
  void _calculateStackedValues(
      List<CartesianSeriesRenderer> seriesRendererCollection) {
    _StackedItemInfo stackedItemInfo;
    _ClusterStackedItemInfo clusterStackedItemInfo;
    String groupName = '';
    List<_StackingInfo>? positiveValues;
    List<_StackingInfo>? negativeValues;
    CartesianSeriesRenderer seriesRenderer;
    if (isStacked100) {
      _calculateStackingPercentage(seriesRendererCollection);
    }

    _chartState._chartSeries.clusterStackedItemInfo =
        <_ClusterStackedItemInfo>[];
    for (int i = 0; i < seriesRendererCollection.length; i++) {
      seriesRenderer = seriesRendererCollection[i];
      if (seriesRenderer is _StackedSeriesRenderer &&
          seriesRenderer._series is _StackedSeriesBase) {
        final _StackedSeriesBase<dynamic, dynamic> stackedSeriesBase =
            seriesRenderer._series as _StackedSeriesBase<dynamic, dynamic>;
        if (seriesRenderer._dataPoints.isNotEmpty) {
          groupName = (seriesRenderer._seriesType.contains('stackedarea'))
              ? 'stackedareagroup'
              // ignore: unnecessary_null_comparison
              : stackedSeriesBase.groupName;
          // : (stackedSeriesBase.groupName ?? ('series ' + i.toString()));
          stackedItemInfo = _StackedItemInfo(i, seriesRenderer);
          if (_chartState._chartSeries.clusterStackedItemInfo.isNotEmpty) {
            for (int k = 0;
                k < _chartState._chartSeries.clusterStackedItemInfo.length;
                k++) {
              clusterStackedItemInfo =
                  _chartState._chartSeries.clusterStackedItemInfo[k];
              if (clusterStackedItemInfo.stackName == groupName) {
                clusterStackedItemInfo.stackedItemInfo.add(stackedItemInfo);
                break;
              } else if (k ==
                  _chartState._chartSeries.clusterStackedItemInfo.length - 1) {
                _chartState._chartSeries.clusterStackedItemInfo.add(
                    _ClusterStackedItemInfo(
                        groupName, <_StackedItemInfo>[stackedItemInfo]));
                break;
              }
            }
          } else {
            _chartState._chartSeries.clusterStackedItemInfo.add(
                _ClusterStackedItemInfo(
                    groupName, <_StackedItemInfo>[stackedItemInfo]));
          }

          seriesRenderer._stackingValues = <_StackedValues>[];
          _StackingInfo? currentPositiveStackInfo;

          if (positiveValues == null || negativeValues == null) {
            positiveValues = <_StackingInfo>[];
            currentPositiveStackInfo = _StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
            negativeValues = <_StackingInfo>[];
            negativeValues.add(_StackingInfo(groupName, <double>[]));
          }
          _addStackingValues(seriesRenderer, isStacked100, positiveValues,
              negativeValues, currentPositiveStackInfo, groupName);
        }
      }
    }
  }

  /// To add the values of stacked series
  void _addStackingValues(
      CartesianSeriesRenderer seriesRenderer,
      bool isStacked100,
      List<_StackingInfo> positiveValues,
      List<_StackingInfo> negativeValues,
      _StackingInfo? currentPositiveStackInfo,
      String groupName) {
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    _StackingInfo? currentNegativeStackInfo;
    final List<double> startValues = <double>[];
    final List<double> endValues = <double>[];
    for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
      point = seriesRenderer._dataPoints[j];
      value = point.y;
      if (positiveValues.isNotEmpty) {
        for (int k = 0; k < positiveValues.length; k++) {
          if (groupName == positiveValues[k].groupName) {
            currentPositiveStackInfo = positiveValues[k];
            break;
          } else if (k == positiveValues.length - 1) {
            currentPositiveStackInfo = _StackingInfo(groupName, <double>[]);
            positiveValues.add(currentPositiveStackInfo);
          }
        }
      }
      if (negativeValues.isNotEmpty) {
        for (int k = 0; k < negativeValues.length; k++) {
          if (groupName == negativeValues[k].groupName) {
            currentNegativeStackInfo = negativeValues[k];
            break;
          } else if (k == negativeValues.length - 1) {
            currentNegativeStackInfo = _StackingInfo(groupName, <double>[]);
            negativeValues.add(currentNegativeStackInfo);
          }
        }
      }
      if (currentPositiveStackInfo?._stackingValues != null) {
        final int length = currentPositiveStackInfo!._stackingValues!.length;
        if (length == 0 || j > length - 1) {
          currentPositiveStackInfo._stackingValues!.add(0);
        }
      }
      if (currentNegativeStackInfo?._stackingValues != null) {
        final int length = currentNegativeStackInfo!._stackingValues!.length;
        if (length == 0 || j > length - 1) {
          currentNegativeStackInfo._stackingValues!.add(0);
        }
      }
      if (isStacked100 && seriesRenderer is _StackedSeriesRenderer) {
        value = value / seriesRenderer._percentageValues[j] * 100;
        value = value.isNaN ? 0 : value;
      }
      if (seriesRenderer._seriesType.contains('stackedarea') || value >= 0) {
        lastValue = currentPositiveStackInfo!._stackingValues![j];
        currentPositiveStackInfo._stackingValues![j] =
            (lastValue + value).toDouble();
      } else {
        lastValue = currentNegativeStackInfo!._stackingValues![j];
        currentNegativeStackInfo._stackingValues![j] =
            (lastValue + value).toDouble();
      }
      startValues.add(lastValue.toDouble());
      endValues.add((value + lastValue).toDouble());
      if (isStacked100 && endValues[j] > 100) {
        endValues[j] = 100;
      }
      point.cumulativeValue = !seriesRenderer._seriesType.contains('100')
          ? endValues[j]
          : endValues[j].truncateToDouble();
    }
    if (seriesRenderer is _StackedSeriesRenderer) {
      seriesRenderer._stackingValues
          .add(_StackedValues(startValues, endValues));
    }
    seriesRenderer._minimumY = startValues.reduce(min);
    seriesRenderer._maximumY = endValues.reduce(max);

    if (seriesRenderer._minimumY! > endValues.reduce(min)) {
      seriesRenderer._minimumY = isStacked100 ? -100 : endValues.reduce(min);
    }
    if (seriesRenderer._maximumY! < startValues.reduce(max)) {
      seriesRenderer._maximumY = 0;
    }
  }

  /// To find the percentage of stacked series
  void _calculateStackingPercentage(
      List<CartesianSeriesRenderer> seriesRendererCollection) {
    List<_StackingInfo>? percentageValues;
    CartesianSeriesRenderer seriesRenderer;
    String groupName;
    _StackingInfo? stackingInfo;
    int length;
    num lastValue, value;
    CartesianChartPoint<dynamic> point;
    for (int i = 0; i < seriesRendererCollection.length; i++) {
      seriesRenderer = seriesRendererCollection[i];
      seriesRenderer._yAxisRenderer!._isStack100 = true;
      if (seriesRenderer is _StackedSeriesRenderer &&
          seriesRenderer._series is _StackedSeriesBase) {
        final _StackedSeriesBase<dynamic, dynamic> stackedSeriesBase =
            seriesRenderer._series as _StackedSeriesBase<dynamic, dynamic>;
        if (seriesRenderer._dataPoints.isNotEmpty) {
          groupName = (seriesRenderer._seriesType == 'stackedarea100')
              ? 'stackedareagroup'
              : stackedSeriesBase.groupName;

          if (percentageValues == null) {
            percentageValues = <_StackingInfo>[];
            stackingInfo = _StackingInfo(groupName, <double>[]);
          }
          for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
            point = seriesRenderer._dataPoints[j];
            value = point.y;
            if (percentageValues.isNotEmpty) {
              for (int k = 0; k < percentageValues.length; k++) {
                if (groupName == percentageValues[k].groupName) {
                  stackingInfo = percentageValues[k];
                  break;
                } else if (k == percentageValues.length - 1) {
                  stackingInfo = _StackingInfo(groupName, <double>[]);
                  percentageValues.add(stackingInfo);
                }
              }
            }
            if (stackingInfo?._stackingValues != null) {
              length = stackingInfo!._stackingValues!.length;
              if (length == 0 || j > length - 1) {
                stackingInfo._stackingValues!.add(0);
              }
            }
            if (seriesRenderer._seriesType.contains('stackedarea') ||
                value >= 0) {
              lastValue = stackingInfo!._stackingValues![j];
              stackingInfo._stackingValues![j] = (lastValue + value).toDouble();
            } else {
              lastValue = stackingInfo!._stackingValues![j];
              stackingInfo._stackingValues![j] = (lastValue - value).toDouble();
            }
            if (j == seriesRenderer._dataPoints.length - 1) {
              percentageValues.add(stackingInfo);
            }
          }
        }
        if (percentageValues != null) {
          for (int i = 0; i < percentageValues.length; i++) {
            if (seriesRenderer._seriesType == 'stackedarea100') {
              seriesRenderer._percentageValues =
                  percentageValues[i]._stackingValues!;
            } else {
              if (stackedSeriesBase.groupName ==
                  percentageValues[i].groupName) {
                seriesRenderer._percentageValues =
                    percentageValues[i]._stackingValues!;
              }
            }
          }
        }
      }
    }
  }

  /// Calculate area type
  void _findAreaType(List<CartesianSeriesRenderer> seriesRendererList) {
    if (visibleSeriesRenderers.isNotEmpty) {
      int index = -1;
      for (final CartesianSeriesRenderer series in seriesRendererList) {
        _setSeriesType(series, index += 1);
      }
    }
  }

  /// To find and set the series type
  void _setSeriesType(CartesianSeriesRenderer seriesRenderer, int index) {
    if (seriesRenderer._series.color == null) {
      seriesRenderer._seriesColor =
          chart.palette[paletteIndex % chart.palette.length];
      paletteIndex++;
    } else {
      seriesRenderer._seriesColor = seriesRenderer._series.color;
    }
    if (seriesRenderer is AreaSeriesRenderer) {
      seriesRenderer._seriesType = 'area';
    } else if (seriesRenderer is BarSeriesRenderer) {
      seriesRenderer._seriesType = 'bar';
    } else if (seriesRenderer is BubbleSeriesRenderer) {
      seriesRenderer._seriesType = 'bubble';
    } else if (seriesRenderer is ColumnSeriesRenderer) {
      seriesRenderer._seriesType = 'column';
    } else if (seriesRenderer is FastLineSeriesRenderer) {
      seriesRenderer._seriesType = 'fastline';
    } else if (seriesRenderer is LineSeriesRenderer) {
      seriesRenderer._seriesType = 'line';
    } else if (seriesRenderer is ScatterSeriesRenderer) {
      seriesRenderer._seriesType = 'scatter';
    } else if (seriesRenderer is SplineSeriesRenderer) {
      seriesRenderer._seriesType = 'spline';
    } else if (seriesRenderer is StepLineSeriesRenderer) {
      seriesRenderer._seriesType = 'stepline';
    } else if (seriesRenderer is StackedColumnSeriesRenderer) {
      seriesRenderer._seriesType = 'stackedcolumn';
    } else if (seriesRenderer is StackedBarSeriesRenderer) {
      seriesRenderer._seriesType = 'stackedbar';
    } else if (seriesRenderer is StackedAreaSeriesRenderer) {
      seriesRenderer._seriesType = 'stackedarea';
    } else if (seriesRenderer is StackedArea100SeriesRenderer) {
      seriesRenderer._seriesType = 'stackedarea100';
    } else if (seriesRenderer is StackedLineSeriesRenderer) {
      seriesRenderer._seriesType = 'stackedline';
    } else if (seriesRenderer is StackedLine100SeriesRenderer) {
      seriesRenderer._seriesType = 'stackedline100';
    } else if (seriesRenderer is RangeColumnSeriesRenderer) {
      seriesRenderer._seriesType = 'rangecolumn';
    } else if (seriesRenderer is RangeAreaSeriesRenderer) {
      seriesRenderer._seriesType = 'rangearea';
    } else if (seriesRenderer is StackedColumn100SeriesRenderer) {
      seriesRenderer._seriesType = 'stackedcolumn100';
    } else if (seriesRenderer is StackedBar100SeriesRenderer) {
      seriesRenderer._seriesType = 'stackedbar100';
    } else if (seriesRenderer is SplineAreaSeriesRenderer) {
      seriesRenderer._seriesType = 'splinearea';
    } else if (seriesRenderer is StepAreaSeriesRenderer) {
      seriesRenderer._seriesType = 'steparea';
    } else if (seriesRenderer is HiloSeriesRenderer) {
      seriesRenderer._seriesType = 'hilo';
    } else if (seriesRenderer is HiloOpenCloseSeriesRenderer) {
      seriesRenderer._seriesType = 'hiloopenclose';
    } else if (seriesRenderer is CandleSeriesRenderer) {
      seriesRenderer._seriesType = 'candle';
    } else if (seriesRenderer is HistogramSeriesRenderer) {
      seriesRenderer._seriesType = 'histogram';
    } else if (seriesRenderer is SplineRangeAreaSeriesRenderer) {
      seriesRenderer._seriesType = 'splinerangearea';
    } else if (seriesRenderer is BoxAndWhiskerSeriesRenderer) {
      seriesRenderer._seriesType = 'boxandwhisker';
    } else if (seriesRenderer is WaterfallSeriesRenderer) {
      seriesRenderer._seriesType = 'waterfall';
    }

    if (index == 0) {
      _chartState._requireInvertedAxis = (!chart.isTransposed &&
              seriesRenderer._seriesType.toLowerCase().contains('bar')) ||
          (chart.isTransposed &&
              !seriesRenderer._seriesType.toLowerCase().contains('bar'));
    }
  }

  ///below method is for indicator rendering
  void _calculateIndicators() {
    // ignore: unnecessary_null_comparison
    if (chart.indicators != null && chart.indicators.isNotEmpty) {
      dynamic indicator;
      bool existField;
      Map<String, int> _map = <String, int>{};
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer;
      if (!chart.legend.isVisible!) {
        final List<String> textCollection = <String>[];
        for (int i = 0; i < chart.indicators.length; i++) {
          final TechnicalIndicators<dynamic, dynamic> indicator =
              chart.indicators[i];
          technicalIndicatorsRenderer =
              _chartState._technicalIndicatorRenderer[i];
          _setIndicatorType(indicator, technicalIndicatorsRenderer);
          textCollection.add(technicalIndicatorsRenderer._indicatorType);
        }
        //ignore: prefer_collection_literals
        _map = Map<String, int>();
        //ignore: avoid_function_literals_in_foreach_calls
        textCollection.forEach((String str) =>
            _map[str] = !_map.containsKey(str) ? (1) : (_map[str]! + 1));
      }

      final List<String> indicatorTextCollection = <String>[];
      for (int i = 0; i < chart.indicators.length; i++) {
        indicator = chart.indicators[i];
        technicalIndicatorsRenderer =
            _chartState._technicalIndicatorRenderer[i];
        technicalIndicatorsRenderer._dataPoints =
            <CartesianChartPoint<dynamic>>[];
        technicalIndicatorsRenderer._index = i;
        if (!chart.legend.isVisible!) {
          final int count = indicatorTextCollection
                  .contains(technicalIndicatorsRenderer._indicatorType)
              ? _getIndicatorId(indicatorTextCollection,
                  technicalIndicatorsRenderer._indicatorType)
              : 0;
          indicatorTextCollection
              .add(technicalIndicatorsRenderer._indicatorType);
          technicalIndicatorsRenderer._name = indicator.name ??
              (technicalIndicatorsRenderer._indicatorType +
                  (_map[technicalIndicatorsRenderer._indicatorType] == 1
                      ? ''
                      : ' ' + count.toString()));
        }
        if (indicator != null &&
            indicator.isVisible == true &&
            (indicator.dataSource != null || indicator.seriesName != null)) {
          if (indicator.dataSource != null &&
              indicator.dataSource.isNotEmpty == true) {
            existField = technicalIndicatorsRenderer._indicatorType == 'SMA' ||
                technicalIndicatorsRenderer._indicatorType == 'TMA' ||
                technicalIndicatorsRenderer._indicatorType == 'EMA';
            final String valueField =
                existField ? _getFieldType(indicator).toLowerCase() : '';
            CartesianChartPoint<dynamic> currentPoint;
            for (int pointIndex = 0;
                pointIndex < indicator.dataSource.length;
                pointIndex++) {
              if (indicator.xValueMapper != null) {
                final dynamic xVal = indicator.xValueMapper(pointIndex);
                num? highValue, lowValue, openValue, closeValue, volumeValue;
                technicalIndicatorsRenderer._dataPoints!
                    .add(CartesianChartPoint<dynamic>(xVal, null));
                currentPoint = technicalIndicatorsRenderer._dataPoints![
                    technicalIndicatorsRenderer._dataPoints!.length - 1];
                if (indicator.highValueMapper != null) {
                  highValue = indicator.highValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      ._dataPoints![
                          technicalIndicatorsRenderer._dataPoints!.length - 1]
                      .high = highValue;
                }
                if (indicator.lowValueMapper != null) {
                  lowValue = indicator.lowValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      ._dataPoints![
                          technicalIndicatorsRenderer._dataPoints!.length - 1]
                      .low = lowValue;
                }

                ///changing high,low value
                if (currentPoint.high != null && currentPoint.low != null) {
                  final num high = currentPoint.high;
                  final num low = currentPoint.low;
                  currentPoint.high = math.max<num>(high, low);
                  currentPoint.low = math.min<num>(high, low);
                }
                if (indicator.openValueMapper != null) {
                  openValue = indicator.openValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      ._dataPoints![
                          technicalIndicatorsRenderer._dataPoints!.length - 1]
                      .open = openValue;
                }
                if (indicator.closeValueMapper != null) {
                  closeValue = indicator.closeValueMapper(pointIndex);
                  technicalIndicatorsRenderer
                      ._dataPoints![
                          technicalIndicatorsRenderer._dataPoints!.length - 1]
                      .close = closeValue;
                }
                if (indicator is AccumulationDistributionIndicator &&
                    indicator.volumeValueMapper != null) {
                  volumeValue = indicator.volumeValueMapper!(pointIndex);
                  technicalIndicatorsRenderer
                      ._dataPoints![
                          technicalIndicatorsRenderer._dataPoints!.length - 1]
                      .volume = volumeValue;
                }

                if ((closeValue == null &&
                        (!existField || valueField == 'close')) ||
                    (highValue == null &&
                        (valueField == 'high' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'AD' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'ATR' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'RSI' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'Stochastic')) ||
                    (lowValue == null &&
                        (valueField == 'low' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'AD' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'ATR' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'RSI' ||
                            technicalIndicatorsRenderer._indicatorType ==
                                'Stochastic')) ||
                    (openValue == null && valueField == 'open') ||
                    (volumeValue == null &&
                        technicalIndicatorsRenderer._indicatorType == 'AD')) {
                  technicalIndicatorsRenderer._dataPoints!.removeAt(
                      technicalIndicatorsRenderer._dataPoints!.length - 1);
                }
              }
            }
          } else if (indicator.seriesName != null) {
            CartesianSeriesRenderer? seriesRenderer;
            for (int i = 0;
                i < _chartState._chartSeries.visibleSeriesRenderers.length;
                i++) {
              if (indicator.seriesName ==
                  _chartState
                      ._chartSeries.visibleSeriesRenderers[i]._series.name) {
                seriesRenderer =
                    _chartState._chartSeries.visibleSeriesRenderers[i];
                break;
              }
            }
            technicalIndicatorsRenderer._dataPoints = (seriesRenderer != null &&
                    (seriesRenderer._seriesType == 'hiloopenclose' ||
                        seriesRenderer._seriesType == 'candle' ||
                        seriesRenderer._seriesType == 'boxandwhisker'))
                ? seriesRenderer._dataPoints
                : null;
          }
          if (technicalIndicatorsRenderer._dataPoints != null &&
              technicalIndicatorsRenderer._dataPoints!.isNotEmpty) {
            indicator._initSeriesCollection(
                indicator, chart, technicalIndicatorsRenderer);
            indicator._initDataSource(
                indicator, technicalIndicatorsRenderer, chart);
            if (technicalIndicatorsRenderer._renderPoints.isNotEmpty) {
              _chartState._chartSeries.visibleSeriesRenderers
                  .addAll(technicalIndicatorsRenderer._targetSeriesRenderers);
            }
          }
        }
      }
    }
  }

  /// To get the field type of an indicator
  String _getFieldType(TechnicalIndicators<dynamic, dynamic> indicator) {
    String valueField = '';
    if (indicator is EmaIndicator) {
      valueField = indicator.valueField;
    } else if (indicator is TmaIndicator) {
      valueField = indicator.valueField;
    } else if (indicator is SmaIndicator) {
      valueField = indicator.valueField;
    }
    return valueField;
  }

  /// To return the indicator id
  int _getIndicatorId(List<String> list, String str) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == str) {
        count++;
      }
    }
    return count;
  }

  /// Setting indicator type
  void _setIndicatorType(TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    if (indicator is AtrIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'ATR';
    } else if (indicator is AccumulationDistributionIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'AD';
    } else if (indicator is BollingerBandIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'Bollinger';
    } else if (indicator is EmaIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'EMA';
    } else if (indicator is MacdIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'MACD';
    } else if (indicator is MomentumIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'Momentum';
    } else if (indicator is RsiIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'RSI';
    } else if (indicator is SmaIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'SMA';
    } else if (indicator is StochasticIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'Stochastic';
    } else if (indicator is TmaIndicator) {
      technicalIndicatorsRenderer._indicatorType = 'TMA';
    }
  }

  //this function sorts the details available based on the x which is of datetime type
  void _sortDateTimeCategoryDetails(CartesianSeriesRenderer seriesRenderer) {
    final DateTimeCategoryAxisRenderer axisRenderer =
        seriesRenderer._xAxisRenderer as DateTimeCategoryAxisRenderer;
    seriesRenderer._dataPoints.sort((CartesianChartPoint<dynamic> point1,
        CartesianChartPoint<dynamic> point2) {
      return point2.x.isAfter(point1.x) == true ? -1 : 1;
    });
    axisRenderer._labels.sort((String first, String second) {
      return int.parse(first) < int.parse(second) ? -1 : 1;
    });
    seriesRenderer._xValues?.sort();
    for (final CartesianChartPoint<dynamic> point
        in seriesRenderer._dataPoints) {
      point.xValue = axisRenderer._labels
          .indexOf(point.x.microsecondsSinceEpoch.toString());
    }
  }
}
