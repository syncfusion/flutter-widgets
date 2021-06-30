part of charts;

///Logarithmic axis uses logarithmic scale and displays numbers as axis labels.
///
///provides options to customize the range of log axis, use the [minimum], [maximum], and [interval] properties.
/// By default, the range will be calculated automatically based on the provided data.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
@immutable
class LogarithmicAxis extends ChartAxis {
  /// Creating an argument constructor of LogarithmicAxis class.
  LogarithmicAxis({
    String? name,
    bool? isVisible,
    bool? anchorRangeToVisiblePoints,
    AxisTitle? title,
    AxisLine? axisLine,
    AxisLabelIntersectAction? labelIntersectAction,
    int? labelRotation,
    ChartDataLabelPosition? labelPosition,
    TickPosition? tickPosition,
    bool? isInversed,
    bool? opposedPosition,
    int? minorTicksPerInterval,
    int? maximumLabels,
    MajorTickLines? majorTickLines,
    MinorTickLines? minorTickLines,
    MajorGridLines? majorGridLines,
    MinorGridLines? minorGridLines,
    EdgeLabelPlacement? edgeLabelPlacement,
    TextStyle? labelStyle,
    double? plotOffset,
    double? zoomFactor,
    double? zoomPosition,
    bool? enableAutoIntervalOnZooming,
    InteractiveTooltip? interactiveTooltip,
    this.minimum,
    this.maximum,
    double? interval,
    this.logBase = 10,
    this.labelFormat,
    this.numberFormat,
    this.visibleMinimum,
    this.visibleMaximum,
    LabelAlignment? labelAlignment,
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
            anchorRangeToVisiblePoints: anchorRangeToVisiblePoints,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            axisLine: axisLine,
            edgeLabelPlacement: edgeLabelPlacement,
            labelAlignment: labelAlignment,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            plotOffset: plotOffset,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
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

  ///Formats the numeric axis labels.
  ///
  /// The labels can be customized by adding desired text as prefix or suffix.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogaithmicAxis(labelFormat: '{value}M'),
  ///        ));
  ///}
  ///```
  final String? labelFormat;

  ///Formats the logarithmic axis labels with globalized label formats.
  ///
  ///Provides the ability to format a number in a locale-specific way.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(numberFormat: NumberFormat.currencyCompact()),
  ///        ));
  ///}
  ///```
  final NumberFormat? numberFormat;

  ///The minimum value of the axis.
  ///
  ///The axis will start from this value.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double? minimum;

  ///The maximum value of the axis.
  ///The axis will end at this value.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(maximum: 10),
  ///        ));
  ///}
  ///```
  final double? maximum;

  ///The base value for logarithmic axis.
  ///The axislabel will render this base value.i.e 10,100,1000 and so on.
  ///
  ///Defaults to `10`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(logBase: 10),
  ///        ));
  ///}
  ///```
  final double logBase;

  ///The minimum visible value of the axis.
  ///
  ///The axis will be rendered from this value initially.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double? visibleMinimum;

  ///The minimum visible value of the axis.
  ///
  /// The axis will be rendered from this value initially.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMaximum: 200),
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

    return other is LogarithmicAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.numberFormat == numberFormat &&
        other.labelFormat == labelFormat &&
        other.rangePadding == rangePadding &&
        other.logBase == logBase &&
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
      numberFormat,
      labelFormat,
      rangePadding,
      logBase,
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

/// Creates an axis renderer for Logarithmic axis
class LogarithmicAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of LogarithmicAxisRenderer class.
  LogarithmicAxisRenderer(this._logarithmicAxis) : super(_logarithmicAxis);

  final LogarithmicAxis _logarithmicAxis;

  /// Find the series min and max values of an series
  void _findAxisMinMaxValues(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    final String seriesType = seriesRenderer._seriesType;
    point.xValue = point.x;
    point.yValue = point.y;
    seriesRenderer._minimumX ??= point.xValue;
    seriesRenderer._maximumX ??= point.xValue;
    if (!seriesType.contains('range') &&
        (!seriesType.contains('hilo')) &&
        (!seriesType.contains('candle'))) {
      seriesRenderer._minimumY ??= point.yValue;
      seriesRenderer._maximumY ??= point.yValue;
    }
    _lowMin ??= point.low;
    _lowMax ??= point.low;
    _highMin ??= point.high;
    _highMax ??= point.high;
    if (point.xValue != null) {
      seriesRenderer._minimumX =
          math.min(seriesRenderer._minimumX!, point.xValue);
      seriesRenderer._maximumX =
          math.max(seriesRenderer._maximumX!, point.xValue);
    }
    if (point.yValue != null &&
        (!seriesType.contains('range') &&
            !seriesType.contains('hilo') &&
            !seriesType.contains('candle'))) {
      seriesRenderer._minimumY =
          math.min(seriesRenderer._minimumY!, point.yValue);
      seriesRenderer._maximumY =
          math.max(seriesRenderer._maximumY!, point.yValue);
    }
    if (point.high != null) {
      _highMin = math.min(_highMin!, point.high);
      _highMax = math.max(_highMax!, point.high);
    }
    if (point.low != null) {
      _lowMin = math.min(_lowMin!, point.low);
      _lowMax = math.max(_lowMax!, point.low);
    }
    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle')) {
        _lowMin ??= 0;
        _lowMax ??= 5;
        _highMin ??= 0;
        _highMax ??= 5;
        seriesRenderer._minimumY =
            math.min(_lowMin!.toDouble(), _highMin!.toDouble());
        seriesRenderer._maximumY =
            math.max(_lowMax!.toDouble(), _highMax!.toDouble());
      }
      seriesRenderer._minimumX ??= 0;
      seriesRenderer._minimumY ??= 0;
      seriesRenderer._maximumX ??= 5;
      seriesRenderer._maximumY ??= 5;
    }
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
    if (_logarithmicAxis.rangeController != null) {
      _chartState._rangeChangeBySlider = true;
      _logarithmicAxis.rangeController!.addListener(_controlListener);
    }
    final Rect containerRect = _chartState._renderingDetails.chartContainerRect;
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    _axisSize = Size(rect.width, rect.height);
    calculateRange(this);
    _calculateActualRange();
    calculateVisibleRange(_axisSize);

    /// Setting range as visible zoomRange
    if ((_logarithmicAxis.visibleMinimum != null ||
            _logarithmicAxis.visibleMaximum != null) &&
        (_logarithmicAxis.visibleMinimum != _logarithmicAxis.visibleMaximum) &&
        (!_chartState._isRedrawByZoomPan)) {
      _chartState._isRedrawByZoomPan = false;
      _visibleRange!.minimum = _logarithmicAxis.visibleMinimum != null
          ? (math.log(_logarithmicAxis.visibleMinimum!) / (math.log(10)))
              .round()
          : _visibleRange!.minimum;
      _visibleRange!.maximum = _logarithmicAxis.visibleMaximum != null
          ? (math.log(_logarithmicAxis.visibleMaximum!) / (math.log(10)))
              .round()
          : _visibleRange!.maximum;
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _zoomFactor = _visibleRange!.delta / (_actualRange!.delta);
      _zoomPosition = (_visibleRange!.minimum - _actualRange!.minimum) /
          _actualRange!.delta;
    }

    ActualRangeChangedArgs rangeChangedArgs;
    if (_chart.onActualRangeChanged != null) {
      final _VisibleRange range = _actualRange!;
      rangeChangedArgs = ActualRangeChangedArgs(_name!, _logarithmicAxis,
          range.minimum, range.maximum, range.interval, _orientation!);
      rangeChangedArgs.visibleMin = _visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange!.interval;
      _chart.onActualRangeChanged!(rangeChangedArgs);
      _visibleRange!.minimum = rangeChangedArgs.visibleMin;
      _visibleRange!.maximum = rangeChangedArgs.visibleMax;
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval = rangeChangedArgs.visibleInterval;
      _zoomFactor = _visibleRange!.delta / range.delta;
      _zoomPosition =
          (_visibleRange!.minimum - _actualRange!.minimum) / range.delta;
    }
    if (type == null && type != 'AxisCross' && _logarithmicAxis.isVisible) {
      generateVisibleLabels();
    }
  }

  /// Calculate the required values of the actual range for logarithmic axis
  void _calculateActualRange() {
    num logStart, logEnd;
    _min ??= 0;
    _max ??= 5;
    _min = _logarithmicAxis.minimum ?? _min;
    _max = _logarithmicAxis.maximum ?? _max;
    if (_axis.anchorRangeToVisiblePoints &&
        _needCalculateYrange(_logarithmicAxis.minimum, _logarithmicAxis.maximum,
            _chartState, _orientation!)) {
      final _VisibleRange range = _calculateYRangeOnZoomX(_actualRange!, this);
      _min = range.minimum;
      _max = range.maximum;
    }
    _min = _min! < 0 ? 0 : _min;
    logStart = _calculateLogBaseValue(_min!, _logarithmicAxis.logBase);
    logStart = logStart.isFinite ? logStart : _min!;
    logEnd = _calculateLogBaseValue(_max!, _logarithmicAxis.logBase);
    logEnd = logEnd.isFinite ? logEnd : _max!;
    _min = (logStart / 1).floor();
    _max = (logEnd / 1).ceil();
    if (_min == _max) {
      _max = _max! + 1;
    }
    _actualRange = _VisibleRange(_min, _max);
    _actualRange!.delta = _actualRange!.maximum - _actualRange!.minimum;
    _actualRange!.interval = _logarithmicAxis.interval ??
        calculateLogNiceInterval(_actualRange!.delta);
  }

  /// To get the axis interval for logarithmic axis
  num calculateLogNiceInterval(num delta) {
    final List<num> intervalDivisions = <num>[10, 5, 2, 1];
    final num actualDesiredIntervalCount =
        _calculateDesiredIntervalCount(_axisSize, this);
    num niceInterval = delta;
    final num minInterval =
        math.pow(10, _calculateLogBaseValue(niceInterval, 10).floor());
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num interval = intervalDivisions[i];
      final num currentInterval = minInterval * interval;
      if (actualDesiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }
    return niceInterval;
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
    if (_logarithmicAxis.autoScrollingDelta != null &&
        _logarithmicAxis.autoScrollingDelta! > 0 &&
        !_chartState._isRedrawByZoomPan) {
      canAutoScroll = true;
      super._updateAutoScrollingDelta(
          _logarithmicAxis.autoScrollingDelta!, this);
    }
    if ((!canAutoScroll || _chartState._zoomedState == true) &&
        !(_chartState._rangeChangeBySlider &&
            !_chartState._canSetRangeController)) {
      _setZoomFactorAndPosition(this, _chartState._zoomedAxisRendererStates);
    }
    if (_zoomFactor < 1 ||
        _zoomPosition > 0 ||
        (_axis.rangeController != null &&
                !_chartState._renderingDetails.initialRender!) &&
            !(_chartState._rangeChangeBySlider ||
                !_chartState._canSetRangeController)) {
      _chartState._zoomProgress = true;
      _calculateZoomRange(this, availableSize);
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval =
          _axis.enableAutoIntervalOnZooming && _chartState._zoomProgress
              ? calculateLogNiceInterval(_visibleRange!.delta)
              : _visibleRange!.interval;
      _visibleRange!.interval = _visibleRange!.interval.floor() == 0
          ? 1
          : _visibleRange!.interval.floor();
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

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num interval) {}

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange!.minimum;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _visibleRange!.maximum;
        tempInterval += _visibleRange!.interval) {
      labelText =
          pow(_logarithmicAxis.logBase, tempInterval).floor().toString();
      if (_logarithmicAxis.numberFormat != null) {
        labelText = _logarithmicAxis.numberFormat!
            .format(pow(_logarithmicAxis.logBase, tempInterval).floor());
      }
      if (_logarithmicAxis.labelFormat != null &&
          _logarithmicAxis.labelFormat != '') {
        labelText = _logarithmicAxis.labelFormat!
            .replaceAll(RegExp('{value}'), labelText);
      }
      _triggerLabelRenderEvent(labelText, tempInterval);
    }

    /// Get the maximum label of width and height in axis.
    _calculateMaximumLabelSize(this, _chartState);
  }

  /// Finds the interval of an axis.
  @override
  num? calculateInterval(_VisibleRange range, Size availableSize) => null;
}
