part of charts;

/// This class has the properties of the category axis.
///
/// Category axis displays text labels instead of numbers. When the string values are bound to x values, then the x-axis
/// must be initialized with CategoryAxis.
///
/// Provides the options for Label placement, arrange by index and interval are used to customize the appearance.
///
class CategoryAxis extends ChartAxis {
  /// Creating an argument constructor of CategoryAxis class.
  CategoryAxis(
      {String name,
      bool isVisible,
      AxisTitle title,
      AxisLine axisLine,
      bool arrangeByIndex,
      ChartRangePadding rangePadding,
      LabelPlacement labelPlacement,
      EdgeLabelPlacement edgeLabelPlacement,
      ChartDataLabelPosition labelPosition,
      TickPosition tickPosition,
      int labelRotation,
      AxisLabelIntersectAction labelIntersectAction,
      LabelAlignment labelAlignment,
      bool isInversed,
      bool opposedPosition,
      int minorTicksPerInterval,
      int maximumLabels,
      MajorTickLines majorTickLines,
      MinorTickLines minorTickLines,
      MajorGridLines majorGridLines,
      MinorGridLines minorGridLines,
      TextStyle labelStyle,
      double plotOffset,
      double zoomFactor,
      double zoomPosition,
      InteractiveTooltip interactiveTooltip,
      this.minimum,
      this.maximum,
      double interval,
      this.visibleMinimum,
      this.visibleMaximum,
      dynamic crossesAt,
      String associatedAxisName,
      bool placeLabelsNearAxisLine,
      List<PlotBand> plotBands,
      int desiredIntervals,
      RangeController rangeController})
      : arrangeByIndex = arrangeByIndex ?? false,
        labelPlacement = labelPlacement ?? LabelPlacement.betweenTicks,
        super(
          name: name,
          isVisible: isVisible,
          isInversed: isInversed,
          plotOffset: plotOffset,
          rangePadding: rangePadding,
          opposedPosition: opposedPosition,
          edgeLabelPlacement: edgeLabelPlacement,
          labelRotation: labelRotation,
          labelPosition: labelPosition,
          tickPosition: tickPosition,
          labelIntersectAction: labelIntersectAction,
          minorTicksPerInterval: minorTicksPerInterval,
          maximumLabels: maximumLabels,
          labelAlignment: labelAlignment,
          labelStyle: labelStyle,
          title: title,
          axisLine: axisLine,
          majorTickLines: majorTickLines,
          minorTickLines: minorTickLines,
          majorGridLines: majorGridLines,
          minorGridLines: minorGridLines,
          zoomFactor: zoomFactor,
          zoomPosition: zoomPosition,
          interactiveTooltip: interactiveTooltip,
          interval: interval,
          crossesAt: crossesAt,
          associatedAxisName: associatedAxisName,
          placeLabelsNearAxisLine: placeLabelsNearAxisLine,
          plotBands: plotBands,
          desiredIntervals: desiredIntervals,
          rangeController: rangeController,
        );

  ///Position of the category axis labels.
  ///
  ///The labels can be placed either
  ///between the ticks or at the major ticks.
  ///
  ///Defaults to `LabelPlacement.betweenTicks`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        ));
  ///}
  ///```
  final LabelPlacement labelPlacement;

  ///Plots the data points based on the index value.
  ///
  ///By default, data points will be
  ///grouped and plotted based on the x-value. They can also be grouped by the data
  ///point index value.
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(arrangeByIndex: true),
  ///        ));
  ///}
  ///```
  final bool arrangeByIndex;

  ///The minimum value of the axis.
  ///
  ///The axis will start from this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double minimum;

  ///The maximum value of the axis.
  ///
  /// The axis will end at this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(maximum: 10),
  ///        ));
  ///}
  ///```
  final double maximum;

  ///The minimum visible value of the axis. The axis is rendered from this value
  ///initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double visibleMinimum;

  ///The maximum visible value of the axis.
  ///
  /// The axis is rendered to this value initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(visibleMaximum: 20),
  ///        ));
  ///}
  ///```
  final double visibleMaximum;
}

/// Creates an axis renderer for Category axis
class CategoryAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of CategoryAxisRenderer class.
  CategoryAxisRenderer(this._categoryAxis) : super(_categoryAxis) {
    _labels = <dynamic>[];
  }
  dynamic _labels;
  Rect _rect;
  final CategoryAxis _categoryAxis;

  void _findAxisMinMaxValues(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool isXVisibleRange, bool isYVisibleRange]) {
    final String seriesType = seriesRenderer._seriesType;
    final bool _anchorRangeToVisiblePoints =
        seriesRenderer._yAxisRenderer._axis.anchorRangeToVisiblePoints;
    if (_categoryAxis.arrangeByIndex) {
      pointIndex < _labels.length && _labels[pointIndex] != null
          ? _labels[pointIndex] += ', ' + point.x
          : _labels.add(point.x.toString());
      point.xValue = pointIndex;
    } else {
      if (_labels.indexOf(point.x.toString()) < 0) {
        _labels.add(point.x.toString());
      }
      point.xValue = _labels.indexOf(point.x.toString());
    }
    point.yValue = point.y;
    if (isYVisibleRange) {
      seriesRenderer._minimumX ??= point.xValue;
      seriesRenderer._maximumX ??= point.xValue;
    }
    if ((isXVisibleRange || !_anchorRangeToVisiblePoints) &&
        !seriesType.contains('range') &&
        !seriesType.contains('hilo') &&
        !seriesType.contains('candle') &&
        !seriesType.contains('boxandwhisker') &&
        !seriesType.contains('waterfall')) {
      seriesRenderer._minimumY ??= point.yValue;
      seriesRenderer._maximumY ??= point.yValue;
    }
    if (isYVisibleRange && point.xValue != null) {
      seriesRenderer._minimumX =
          math.min(seriesRenderer._minimumX, point.xValue);
      seriesRenderer._maximumX =
          math.max(seriesRenderer._maximumX, point.xValue);
    }
    if (isXVisibleRange || !_anchorRangeToVisiblePoints) {
      if (point.yValue != null &&
          (!seriesType.contains('range') &&
              !seriesType.contains('hilo') &&
              !seriesType.contains('candle') &&
              !seriesType.contains('boxandwhisker') &&
              !seriesType.contains('waterfall'))) {
        seriesRenderer._minimumY =
            math.min(seriesRenderer._minimumY, point.yValue);
        seriesRenderer._maximumY =
            math.max(seriesRenderer._maximumY, point.yValue);
      }
      if (point.high != null) {
        _highMin = _findMinValue(_highMin ?? point.high, point.high);
        _highMax = _findMaxValue(_highMax ?? point.high, point.high);
      }
      if (point.low != null) {
        _lowMin = _findMinValue(_lowMin ?? point.low, point.low);
        _lowMax = _findMaxValue(_lowMax ?? point.low, point.low);
      }
      if (point.maximum != null) {
        _highMin = _findMinValue(_highMin ?? point.maximum, point.maximum);
        _highMax = _findMaxValue(_highMax ?? point.minimum, point.maximum);
      }
      if (point.minimum != null) {
        _lowMin = _findMinValue(_lowMin ?? point.minimum, point.minimum);
        _lowMax = _findMaxValue(_lowMax ?? point.minimum, point.minimum);
      }
      if (seriesType.contains('waterfall')) {
        /// Empty point is not applicable for Waterfall series.
        point.yValue ??= 0;
        seriesRenderer._minimumY = _findMinValue(
            seriesRenderer._minimumY ?? point.yValue, point.yValue);
        seriesRenderer._maximumY = _findMaxValue(
            seriesRenderer._maximumY ?? point.maxYValue, point.maxYValue);
      }
    }

    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle') ||
          seriesType.contains('boxandwhisker')) {
        _lowMin ??= 0;
        _lowMax ??= 5;
        _highMin ??= 0;
        _highMax ??= 5;
        seriesRenderer._minimumY = math.min(_lowMin, _highMin);
        seriesRenderer._maximumY = math.max(_lowMax, _highMax);
      }
      seriesRenderer._minimumY ??= 0;
      seriesRenderer._maximumY ??= 5;
    }
  }

  /// Listener for range controller
  void _controlListener() {
    if (_axis.rangeController != null && !_chartState._rangeChangedByChart) {
      _updateRangeControllerValues(this);
      _chartState._redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void _calculateRangeAndInterval(SfCartesianChartState chartState,
      [String type]) {
    _chartState = chartState;
    _chart = chartState._chart;
    if (_axis.rangeController != null) {
      _chartState._rangeChangeBySlider = true;
      _axis.rangeController.addListener(_controlListener);
    }
    final Rect containerRect = _chartState._containerRect;
    _rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    calculateRange(this);
    _calculateActualRange();
    if (_actualRange != null) {
      applyRangePadding(_actualRange, _actualRange.interval);
      if (type == null && type != 'AxisCross') {
        generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the category axis
  void _calculateActualRange() {
    if (_min != null && _max != null) {
      _actualRange = _VisibleRange(
          _chartState._rangeChangeBySlider &&
                  _categoryAxis.rangeController != null
              ? _rangeMinimum ?? _categoryAxis.rangeController.start
              : _categoryAxis.minimum ?? _min,
          _chartState._rangeChangeBySlider &&
                  _categoryAxis.rangeController != null
              ? _rangeMaximum ?? _categoryAxis.rangeController.end
              : _categoryAxis.maximum ?? _max);
      final List<CartesianSeriesRenderer> seriesRenderers = _seriesRenderers;
      CartesianSeriesRenderer seriesRenderer;
      for (int i = 0; i < seriesRenderers.length; i++) {
        seriesRenderer = seriesRenderers[i];
        if (_actualRange.maximum > seriesRenderer._dataPoints.length - 1) {
          for (int i = _labels.length; i < _actualRange.maximum + 1; i++) {
            _labels.add(i.toString());
          }
        }
      }
      _actualRange = _VisibleRange(
          _categoryAxis.minimum ?? _min, _categoryAxis.maximum ?? _max);

      ///Below condition is for checking the min, max value is equal
      if ((_actualRange.minimum == _actualRange.maximum) &&
          (_categoryAxis.labelPlacement == LabelPlacement.onTicks)) {
        _actualRange.maximum += 1;
      }
      _actualRange.delta = _actualRange.maximum - _actualRange.minimum;
      _actualRange.interval = _categoryAxis.interval ??
          calculateInterval(_actualRange, Size(_rect.width, _rect.height));
      _actualRange.delta = _actualRange.maximum - _actualRange.minimum;
    }
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _visibleRange = _VisibleRange(_actualRange.minimum, _actualRange.maximum);
    _visibleRange.delta = _actualRange.delta;
    _visibleRange.interval = _actualRange.interval;
    _checkWithZoomState(this, _chartState._zoomedAxisRendererStates);
    if (_zoomFactor < 1 || _zoomPosition > 0) {
      _chartState._zoomProgress = true;
      _calculateZoomRange(this, availableSize);
      if (_axis.rangeController != null) {
        _chartState._rangeChangedByChart = true;
        _setRangeControllerValues(this);
      }
    }
  }

  /// Applies range padding
  @override
  void applyRangePadding(_VisibleRange range, num interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (_categoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (!(_categoryAxis.minimum != null && _categoryAxis.maximum != null)) {
      ///Calculating range padding
      _applyRangePadding(this, _chartState, range, interval);
    }

    calculateVisibleRange(Size(_rect.width, _rect.height));

    /// Setting range as visible zoomRange
    if ((_categoryAxis.visibleMinimum != null ||
            _categoryAxis.visibleMaximum != null) &&
        (_categoryAxis.visibleMinimum != _categoryAxis.visibleMaximum) &&
        _chartState._zoomedAxisRendererStates != null &&
        _chartState._zoomedAxisRendererStates.isEmpty) {
      _visibleRange.minimum =
          _categoryAxis.visibleMinimum ?? _visibleRange.minimum;
      _visibleRange.maximum =
          _categoryAxis.visibleMaximum ?? _visibleRange.maximum;
      if (_categoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
        _visibleRange.minimum = _categoryAxis.visibleMinimum != null
            ? _categoryAxis.visibleMinimum - 0.5
            : _visibleRange.minimum;
        _visibleRange.maximum = _categoryAxis.visibleMaximum != null
            ? _categoryAxis.visibleMaximum + 0.5
            : _visibleRange.maximum;
      }
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
      _visibleRange.interval = interval == null
          ? calculateInterval(_visibleRange, _axisSize)
          : _visibleRange.interval;
      _zoomFactor = _visibleRange.delta / (range.delta);
      _zoomPosition =
          (_visibleRange.minimum - _actualRange.minimum) / range.delta;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs(_name, _categoryAxis,
          range.minimum, range.maximum, range.interval, _orientation);
      rangeChangedArgs.visibleMin = _visibleRange.minimum;
      rangeChangedArgs.visibleMax = _visibleRange.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange.interval;
      _chart.onActualRangeChanged(rangeChangedArgs);
      _visibleRange.minimum = rangeChangedArgs.visibleMin;
      _visibleRange.maximum = rangeChangedArgs.visibleMax;
      _visibleRange.interval = rangeChangedArgs.visibleInterval;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange.minimum.ceil();
    num position;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _visibleRange.maximum;
        tempInterval += _visibleRange.interval) {
      if (_withInRange(tempInterval, _visibleRange)) {
        position = tempInterval.round();
        if (position <= -1 ||
            (_labels.isNotEmpty && position >= _labels.length)) {
          continue;
        } else if (_labels.isNotEmpty && _labels[position] != null) {
          labelText = _labels[position];
        } else {
          continue;
        }
        _triggerLabelRenderEvent(labelText, tempInterval);
      }
    }
    _calculateMaximumLabelSize(this, _chartState);
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) => math
      .max(
          1,
          (_actualRange.delta /
                  _calculateDesiredIntervalCount(
                      Size(_rect.width, _rect.height), this))
              .floor())
      .toInt();
}
