part of charts;

/// This class has the properties of the category axis.
///
/// Category axis displays text labels instead of numbers. When the string values are bound to x values, then the x-axis
/// must be initialized with CategoryAxis.
///
/// Provides the options for Label placement, arrange by index and interval used to customize the appearance.
@immutable
class CategoryAxis extends ChartAxis {
  /// Creating an argument constructor of CategoryAxis class.
  CategoryAxis({
    String? name,
    bool? isVisible,
    AxisTitle? title,
    AxisLine? axisLine,
    this.arrangeByIndex = false,
    ChartRangePadding? rangePadding,
    this.labelPlacement = LabelPlacement.betweenTicks,
    EdgeLabelPlacement? edgeLabelPlacement,
    ChartDataLabelPosition? labelPosition,
    TickPosition? tickPosition,
    int? labelRotation,
    AxisLabelIntersectAction? labelIntersectAction,
    LabelAlignment? labelAlignment,
    bool? isInversed,
    bool? opposedPosition,
    int? minorTicksPerInterval,
    int? maximumLabels,
    MajorTickLines? majorTickLines,
    MinorTickLines? minorTickLines,
    MajorGridLines? majorGridLines,
    MinorGridLines? minorGridLines,
    TextStyle? labelStyle,
    double? plotOffset,
    double? zoomFactor,
    double? zoomPosition,
    InteractiveTooltip? interactiveTooltip,
    this.minimum,
    this.maximum,
    double? interval,
    this.visibleMinimum,
    this.visibleMaximum,
    dynamic crossesAt,
    String? associatedAxisName,
    bool? placeLabelsNearAxisLine,
    List<PlotBand>? plotBands,
    int? desiredIntervals,
    RangeController? rangeController,
    double? maximumLabelWidth,
    double? labelsExtent,
    int? autoScrollingDelta,
    AutoScrollingMode? autoScrollingMode,
  }) : super(
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
            maximumLabelWidth: maximumLabelWidth,
            labelsExtent: labelsExtent,
            autoScrollingDelta: autoScrollingDelta,
            autoScrollingMode: autoScrollingMode);

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
  final double? minimum;

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
  final double? maximum;

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
  final double? visibleMinimum;

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
  final double? visibleMaximum;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CategoryAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.arrangeByIndex == arrangeByIndex &&
        other.rangePadding == rangePadding &&
        other.labelPlacement == labelPlacement &&
        other.edgeLabelPlacement == edgeLabelPlacement &&
        other.labelPosition == labelPosition &&
        other.tickPosition == tickPosition &&
        other.labelRotation == labelRotation &&
        other.labelIntersectAction == labelIntersectAction &&
        other.labelAlignment == labelAlignment &&
        other.isInversed == isInversed &&
        other.opposedPosition == opposedPosition &&
        other.minorTicksPerInterval == minorTicksPerInterval &&
        other.maximumLabels == maximumLabels &&
        other.majorTickLines == majorTickLines &&
        other.minorTickLines == minorTickLines &&
        other.majorGridLines == majorGridLines &&
        other.minorGridLines == minorGridLines &&
        other.labelStyle == labelStyle &&
        other.plotOffset == plotOffset &&
        other.zoomFactor == zoomFactor &&
        other.zoomPosition == zoomPosition &&
        other.interactiveTooltip == interactiveTooltip &&
        other.minimum == minimum &&
        other.maximum == maximum &&
        other.interval == interval &&
        other.visibleMinimum == visibleMinimum &&
        other.visibleMaximum == visibleMaximum &&
        other.crossesAt == crossesAt &&
        other.associatedAxisName == associatedAxisName &&
        other.placeLabelsNearAxisLine == placeLabelsNearAxisLine &&
        other.plotBands == plotBands &&
        other.desiredIntervals == desiredIntervals &&
        other.rangeController == rangeController &&
        other.maximumLabelWidth == maximumLabelWidth &&
        other.labelsExtent == labelsExtent &&
        other.autoScrollingDelta == autoScrollingDelta &&
        other.autoScrollingMode == autoScrollingMode;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      name,
      isVisible,
      title,
      axisLine,
      arrangeByIndex,
      rangePadding,
      labelPlacement,
      edgeLabelPlacement,
      labelPosition,
      tickPosition,
      labelRotation,
      labelIntersectAction,
      labelAlignment,
      isInversed,
      opposedPosition,
      minorTicksPerInterval,
      maximumLabels,
      majorTickLines,
      minorTickLines,
      majorGridLines,
      minorGridLines,
      labelStyle,
      plotOffset,
      zoomFactor,
      zoomPosition,
      interactiveTooltip,
      minimum,
      maximum,
      interval,
      visibleMinimum,
      visibleMaximum,
      crossesAt,
      associatedAxisName,
      placeLabelsNearAxisLine,
      plotBands,
      desiredIntervals,
      rangeController,
      maximumLabelWidth,
      labelsExtent,
      autoScrollingDelta,
      autoScrollingMode
    ];
    return hashList(values);
  }
}

/// Creates an axis renderer for Category axis
class CategoryAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of CategoryAxisRenderer class.
  CategoryAxisRenderer(this._categoryAxis) : super(_categoryAxis) {
    _labels = <String>[];
  }
  late List<String> _labels;
  late Rect _rect;
  final CategoryAxis _categoryAxis;

  void _findAxisMinMaxValues(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    if (_categoryAxis.arrangeByIndex) {
      // ignore: unnecessary_null_comparison
      pointIndex < _labels.length && _labels[pointIndex] != null
          ? _labels[pointIndex] += ', ' + point.x
          : _labels.add(point.x.toString());
      point.xValue = pointIndex;
    } else {
      if (!_labels.contains(point.x.toString())) {
        _labels.add(point.x.toString());
      }
      point.xValue = _labels.indexOf(point.x.toString());
    }
    point.yValue = point.y;
    _setCategoryMinMaxValues(this, isXVisibleRange!, isYVisibleRange!, point,
        pointIndex, dataLength, seriesRenderer);
  }

  /// Listener for range controller
  void _controlListener() {
    _chartState._canSetRangeController = false;
    if (_axis.rangeController != null && !_chartState._rangeChangedByChart) {
      _updateRangeControllerValues(this);
      _chartState._rangeChangeBySlider = true;
      _chartState._redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void _calculateRangeAndInterval(SfCartesianChartState chartState,
      [String? type]) {
    _chartState = chartState;
    _chart = chartState._chart;
    if (_axis.rangeController != null) {
      _chartState._rangeChangeBySlider = true;
      _axis.rangeController!.addListener(_controlListener);
    }
    final Rect containerRect = _chartState._renderingDetails.chartContainerRect;
    _rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    _axisSize = Size(_rect.width, _rect.height);
    calculateRange(this);
    _calculateActualRange();
    if (_actualRange != null) {
      applyRangePadding(_actualRange!, _actualRange!.interval);
      if (type == null && type != 'AxisCross' && _categoryAxis.isVisible) {
        generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the category axis
  void _calculateActualRange() {
    if (_min != null && _max != null) {
      _actualRange = _VisibleRange(
          _categoryAxis.minimum ?? _min, _categoryAxis.maximum ?? _max);
      final List<CartesianSeriesRenderer> seriesRenderers = _seriesRenderers;
      CartesianSeriesRenderer seriesRenderer;
      for (int i = 0; i < seriesRenderers.length; i++) {
        seriesRenderer = seriesRenderers[i];
        if ((_actualRange!.maximum > seriesRenderer._dataPoints.length - 1) ==
            true) {
          for (int i = _labels.length; i < _actualRange!.maximum + 1; i++) {
            _labels.add(i.toString());
          }
        }
      }
      _actualRange = _VisibleRange(
          _categoryAxis.minimum ?? _min, _categoryAxis.maximum ?? _max);

      ///Below condition is for checking the min, max value is equal
      if ((_actualRange!.minimum == _actualRange!.maximum) &&
          (_categoryAxis.labelPlacement == LabelPlacement.onTicks)) {
        _actualRange!.maximum += 1;
      }
      _actualRange!.delta = _actualRange!.maximum - _actualRange!.minimum;
      _actualRange!.interval = _categoryAxis.interval ??
          calculateInterval(_actualRange!, Size(_rect.width, _rect.height));
      _actualRange!.delta = _actualRange!.maximum - _actualRange!.minimum;
    }
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _setOldRangeFromRangeController();
    _visibleRange = _chartState._rangeChangeBySlider &&
            _rangeMinimum != null &&
            _rangeMaximum != null
        ? _VisibleRange(_rangeMinimum, _rangeMaximum)
        : _VisibleRange(_actualRange!.minimum, _actualRange!.maximum);
    _visibleRange!.delta = _actualRange!.delta;
    _visibleRange!.interval = _actualRange!.interval;
    bool canAutoScroll = false;
    if (_categoryAxis.autoScrollingDelta != null &&
        _categoryAxis.autoScrollingDelta! > 0 &&
        !_chartState._isRedrawByZoomPan) {
      canAutoScroll = true;
      super._updateAutoScrollingDelta(_categoryAxis.autoScrollingDelta!, this);
    }
    if ((!canAutoScroll || _chartState._zoomedState == true) &&
        !(_chartState._rangeChangeBySlider &&
            !_chartState._canSetRangeController)) {
      _setZoomFactorAndPosition(this, _chartState._zoomedAxisRendererStates);
    }
    if (_zoomFactor < 1 ||
        _zoomPosition > 0 ||
        (_axis.rangeController != null &&
            !_chartState._renderingDetails.initialRender!)) {
      _chartState._zoomProgress = true;
      _calculateZoomRange(this, availableSize);
      if (_axis.rangeController != null &&
          _chartState._isRedrawByZoomPan &&
          _chartState._canSetRangeController &&
          _chartState._zoomProgress) {
        _chartState._rangeChangedByChart = true;
        _setRangeControllerValues(this);
      }
    }
    _setZoomValuesFromRangeController();
  }

  /// Applies range padding
  @override
  void applyRangePadding(_VisibleRange range, num? interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (_categoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (!(_categoryAxis.minimum != null && _categoryAxis.maximum != null)) {
      ///Calculating range padding
      _applyRangePadding(this, _chartState, range, interval!);
    }

    calculateVisibleRange(Size(_rect.width, _rect.height));

    /// Setting range as visible zoomRange
    if ((_categoryAxis.visibleMinimum != null ||
            _categoryAxis.visibleMaximum != null) &&
        (_categoryAxis.visibleMinimum != _categoryAxis.visibleMaximum) &&
        (!_chartState._isRedrawByZoomPan)) {
      _chartState._isRedrawByZoomPan = false;
      _visibleRange!.minimum = _visibleMinimum ??
          _categoryAxis.visibleMinimum ??
          _visibleRange!.minimum;
      _visibleRange!.maximum = _visibleMaximum ??
          _categoryAxis.visibleMaximum ??
          _visibleRange!.maximum;
      if (_categoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
        _visibleRange!.minimum = _categoryAxis.visibleMinimum != null
            ? (_visibleMinimum ?? _categoryAxis.visibleMinimum!) - 0.5
            : _visibleRange!.minimum;
        _visibleRange!.maximum = _categoryAxis.visibleMaximum != null
            ? (_visibleMaximum ?? _categoryAxis.visibleMaximum!) + 0.5
            : _visibleRange!.maximum;
      }
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval = interval == null
          ? calculateInterval(_visibleRange!, _axisSize)
          : _visibleRange!.interval;
      _zoomFactor = _visibleRange!.delta / (range.delta);
      _zoomPosition =
          (_visibleRange!.minimum - _actualRange!.minimum) / range.delta;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs(_name!, _categoryAxis,
          range.minimum, range.maximum, range.interval, _orientation!);
      rangeChangedArgs.visibleMin = _visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange!.interval;
      _chart.onActualRangeChanged!(rangeChangedArgs);
      _visibleRange!.minimum = rangeChangedArgs.visibleMin;
      _visibleRange!.maximum = rangeChangedArgs.visibleMax;
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval = rangeChangedArgs.visibleInterval;
      _zoomFactor = _visibleRange!.delta / (range.delta);
      _zoomPosition =
          (_visibleRange!.minimum - _actualRange!.minimum) / range.delta;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange!.minimum.ceil();
    int position;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _visibleRange!.maximum;
        tempInterval += _visibleRange!.interval) {
      if (_withInRange(tempInterval, _visibleRange!)) {
        position = tempInterval.round();
        if (position <= -1 ||
            (_labels.isNotEmpty && position >= _labels.length)) {
          continue;
          // ignore: unnecessary_null_comparison
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
          (_actualRange!.delta /
                  _calculateDesiredIntervalCount(
                      Size(_rect.width, _rect.height), this))
              .floor())
      .toInt();
}
