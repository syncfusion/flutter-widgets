part of charts;

///An axis which is used to plot date-time values. It is similar to DateTimeAxis except that it
/// excludes missing dates.
///
///This is a unique type of axis used mainly with financial series. Like [CategoryAxis], all the data
/// points are plotted with equal spaces by removing space for missing dates. Intervals and ranges
/// for the axis are calculated similar to [DateTimeAxis]. There will be no visual gaps between points
/// even when the difference between two points is more than a year.
///
///A simple use case of this axis type is when the user wishes to visualize the working hours on an
/// employee for a month by excluding the weekends.
///
///Provides options for label placement, interval, date format for customizing the appearance.
@immutable
class DateTimeCategoryAxis extends ChartAxis {
  /// Creating an argument constructor of DateTimeCategoryAxis class.
  DateTimeCategoryAxis({
    String? name,
    bool? isVisible,
    AxisTitle? title,
    AxisLine? axisLine,
    ChartRangePadding? rangePadding,
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
    this.labelPlacement = LabelPlacement.betweenTicks,
    this.dateFormat,
    this.intervalType = DateTimeIntervalType.auto,
    this.autoScrollingDeltaType = DateTimeIntervalType.auto,
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

  ///Formats the date-time category axis labels.
  ///
  ///The axis label can be formatted with various built-in [date formats](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html).
  ///
  ///By default, date format will be applied to the axis labels based on the interval between the data points.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(dateFormat: DateFormat.y()),
  ///        ));
  ///}
  ///```
  final DateFormat? dateFormat;

  ///Position of the date-time category axis labels.
  ///
  ///The labels can be placed either between the ticks or at the major ticks.
  ///
  ///Defaults to `LabelPlacement.betweenTicks`.
  ///
  ///Also refer [LabelPlacement].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        ));
  ///}
  ///```
  final LabelPlacement labelPlacement;

  ///Customizes the date-time category axis interval.
  ///
  ///Intervals can be set to days, hours, minutes, months, seconds, years, and auto. If it is set to auto,
  /// the interval type will be decided based on the data.
  ///
  ///Defaults to `DateTimeIntervalType.auto`.
  ///
  ///Also refer [DateTimeIntervalType].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(intervalType: DateTimeIntervalType.years),
  ///        ));
  ///}
  ///```
  final DateTimeIntervalType intervalType;

  ///Minimum value of the axis.
  ///
  ///The axis will start from this date and data points below this value will not be rendered.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(minimum: DateTime(2000)),
  ///        ));
  ///}
  ///```
  final DateTime? minimum;

  ///Maximum value of the axis.
  ///
  ///The axis will end at this date and data points above this value will not be rendered.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(maximum: DateTime(2019)),
  ///        ));
  ///}
  ///```
  final DateTime? maximum;

  ///The minimum visible value of the axis.
  ///
  ///The axis will start from this date and data points below this value will not be rendered initially.
  /// Further those data points can be viewed by panning from left to right direction.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(visibleMinimum: DateTime(2000)),
  ///        ));
  ///}
  ///```
  final DateTime? visibleMinimum;

  ///The maximum visible value of the axis.
  ///
  ///The axis will end at this date and data points above this value will not be rendered initially.
  /// Further those data points can be viewed by panning from right to left direction.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///          primaryXAxis: DateTimeCategoryAxis(visibleMaximum: DateTime(2019)),
  ///        ));
  ///}
  ///```
  final DateTime? visibleMaximum;

  ///Defines the type of delta value in the DateTime axis.
  ///
  ///For example, if the [autoScrollingDelta] value is 5 and [autoScrollingDeltaType] is set to
  /// `DateTimeIntervalType.days`, the data points with 5 days of values will be displayed.
  ///
  ///The value can be set to years, months, days, hours, minutes, seconds and auto.
  ///
  ///Defaults to `DateTimeIntervalType.auto` and the delta will be calculated automatically based on the data.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeCategoryAxis(autoScrollingDeltaType: DateTimeIntervalType.months),
  ///        ));
  ///}
  ///```
  final DateTimeIntervalType autoScrollingDeltaType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DateTimeCategoryAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
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
        other.autoScrollingMode == autoScrollingMode &&
        other.intervalType == intervalType &&
        other.dateFormat == dateFormat;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      name,
      isVisible,
      title,
      axisLine,
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
      autoScrollingMode,
      intervalType,
      dateFormat
    ];
    return hashList(values);
  }
}

/// Creates an axis renderer for Category axis
class DateTimeCategoryAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of CategoryAxisRenderer class.
  DateTimeCategoryAxisRenderer(this._dateTimeCategoryAxis)
      : super(_dateTimeCategoryAxis) {
    _labels = <String>[];
  }
  late List<String> _labels;
  late Rect _rect;
  final DateTimeCategoryAxis _dateTimeCategoryAxis;
  late DateTimeIntervalType _actualIntervalType;
  DateFormat? _dateTimeFormat;
  DateFormat get _dateFormat =>
      _dateTimeFormat ?? _getDateTimeLabelFormat(this);

  /// Find the series min and max values of an series
  void _findAxisMinMaxValues(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    final bool _anchorRangeToVisiblePoints =
        seriesRenderer._yAxisRenderer!._axis.anchorRangeToVisiblePoints;
    final String seriesType = seriesRenderer._seriesType;

    if (!_labels.contains('${point.x.microsecondsSinceEpoch}')) {
      _labels.add('${point.x.microsecondsSinceEpoch}');
    }
    point.xValue = _labels.indexOf('${point.x.microsecondsSinceEpoch}');
    point.yValue = point.y;
    if (isYVisibleRange!) {
      seriesRenderer._minimumX ??= point.xValue;
      seriesRenderer._maximumX ??= point.xValue;
    }
    if ((isXVisibleRange! || !_anchorRangeToVisiblePoints) &&
        !seriesType.contains('range') &&
        !seriesType.contains('hilo') &&
        !seriesType.contains('candle') &&
        seriesType != 'boxandwhisker' &&
        seriesType != 'waterfall') {
      seriesRenderer._minimumY ??= point.yValue;
      seriesRenderer._maximumY ??= point.yValue;
    }
    _setCategoryMinMaxValues(this, isXVisibleRange, isYVisibleRange, point,
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

  /// Calculate axis range and interval
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
      if (type == null &&
          type != 'AxisCross' &&
          _dateTimeCategoryAxis.isVisible) {
        generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the date-time axis
  void _calculateActualRange() {
    ///When chart series is empty, Rendering default chart with below min, max
    _min ??= 0;
    _max ??= 5;
    _actualRange = _VisibleRange(
        _dateTimeCategoryAxis.minimum != null
            ? _getEffectiveRange(_dateTimeCategoryAxis.minimum, true)
            : _min,
        _dateTimeCategoryAxis.maximum != null
            ? _getEffectiveRange(_dateTimeCategoryAxis.maximum, false)
            : _max);

    ///Below condition is for checking the min, max value is equal
    if ((_actualRange!.minimum == _actualRange!.maximum) &&
        (_dateTimeCategoryAxis.labelPlacement == LabelPlacement.onTicks)) {
      _actualRange!.maximum += 1;
    }
    if (_labels.isNotEmpty) {
      final List<DateTime> startAndEnd = _getStartAndEndDate(_labels);
      _calculateDateTimeNiceInterval(
              this, _axisSize, _actualRange!, startAndEnd[0], startAndEnd[1])
          .floor();
    } else {
      _actualIntervalType = DateTimeIntervalType.days;
    }
    _actualRange!.delta = _actualRange!.maximum - _actualRange!.minimum;
    _actualRange!.interval = _dateTimeCategoryAxis.interval ??
        calculateInterval(_actualRange!, Size(_rect.width, _rect.height));
  }

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num? interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (_dateTimeCategoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      range.delta = range.maximum - range.minimum;
    }

    if (_dateTimeCategoryAxis.isVisible &&
        !(_dateTimeCategoryAxis.minimum != null &&
            _dateTimeCategoryAxis.maximum != null)) {
      ///Calculating range padding
      _applyRangePadding(this, _chartState, range, interval!);
    }

    calculateVisibleRange(Size(_rect.width, _rect.height));

    /// Setting range as visible zoomRange
    if ((_dateTimeCategoryAxis.visibleMinimum != null ||
            _dateTimeCategoryAxis.visibleMaximum != null) &&
        (_dateTimeCategoryAxis.visibleMinimum !=
            _dateTimeCategoryAxis.visibleMaximum) &&
        _chartState._zoomedAxisRendererStates.isEmpty) {
      _visibleRange!.minimum = _visibleMinimum != null
          ? _getEffectiveRange(
              DateTime.fromMillisecondsSinceEpoch(_visibleMinimum!.toInt()),
              true)
          : _getEffectiveRange(_dateTimeCategoryAxis.visibleMinimum, true) ??
              _visibleRange!.minimum;
      _visibleRange!.maximum = _visibleMaximum != null
          ? _getEffectiveRange(
              DateTime.fromMillisecondsSinceEpoch(_visibleMaximum!.toInt()),
              false)
          : _getEffectiveRange(_dateTimeCategoryAxis.visibleMaximum, false) ??
              _visibleRange!.maximum;
      if (_dateTimeCategoryAxis.labelPlacement == LabelPlacement.betweenTicks) {
        _visibleRange!.minimum = _visibleMinimum != null
            ? _getEffectiveRange(
                    DateTime.fromMillisecondsSinceEpoch(
                        _visibleMinimum!.toInt()),
                    true)! -
                0.5
            : (_dateTimeCategoryAxis.visibleMinimum != null
                ? _getEffectiveRange(
                        _dateTimeCategoryAxis.visibleMinimum, true)! -
                    0.5
                : _visibleRange!.minimum);
        _visibleRange!.maximum = _visibleMaximum != null
            ? _getEffectiveRange(
                    DateTime.fromMillisecondsSinceEpoch(
                        _visibleMaximum!.toInt()),
                    false)! +
                0.5
            : (_dateTimeCategoryAxis.visibleMaximum != null
                ? _getEffectiveRange(
                        _dateTimeCategoryAxis.visibleMaximum, false)! +
                    0.5
                : _visibleRange!.maximum);
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
      rangeChangedArgs = ActualRangeChangedArgs(_name!, _dateTimeCategoryAxis,
          range.minimum, range.maximum, range.interval, _orientation!);
      rangeChangedArgs.visibleMin = _visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange!.interval;
      _chart.onActualRangeChanged!(rangeChangedArgs);
      _visibleRange!.minimum = rangeChangedArgs.visibleMin is DateTime
          ? _getEffectiveRange(rangeChangedArgs.visibleMin, true)
          : rangeChangedArgs.visibleMin;
      _visibleRange!.maximum = rangeChangedArgs.visibleMax is DateTime
          ? _getEffectiveRange(rangeChangedArgs.visibleMax, false)
          : rangeChangedArgs.visibleMax;
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval = rangeChangedArgs.visibleInterval;
      _zoomFactor = _visibleRange!.delta / (range.delta);
      _zoomPosition =
          (_visibleRange!.minimum - _actualRange!.minimum) / range.delta;
    }
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _calculateDateTimeVisibleRange(availableSize, this);
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange!.minimum.ceil();
    int position;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    _dateTimeFormat =
        _dateTimeCategoryAxis.dateFormat ?? _getDateTimeLabelFormat(this);
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
          labelText = _getFormattedLabel(_labels[position], _dateFormat);
          _labels[position] = labelText;
        } else {
          continue;
        }
        _triggerLabelRenderEvent(labelText, tempInterval);
      }
    }
    _calculateMaximumLabelSize(this, _chartState);
  }

  String _getFormattedLabel(String label, DateFormat dateFormat) {
    return dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(label)));
  }

  List<DateTime> _getStartAndEndDate(List<String> labels) {
    final List<String> values = <String>[...labels]
      ..sort((String first, String second) {
        return int.parse(first) < int.parse(second) ? -1 : 1;
      });
    return <DateTime>[
      DateTime.fromMicrosecondsSinceEpoch(int.parse(values.first)),
      DateTime.fromMicrosecondsSinceEpoch(int.parse(values.last))
    ];
  }

  num? _getEffectiveRange(DateTime? rangeDate, bool needMin) {
    num index = 0;
    if (rangeDate == null) {
      return null;
    }
    for (final String label in _labels) {
      final int value = int.parse(label);
      if (needMin) {
        if (value > rangeDate.microsecondsSinceEpoch) {
          if (!(_labels.first == label)) {
            index++;
          }
          break;
        } else if (value < rangeDate.microsecondsSinceEpoch) {
          index = _labels.indexOf(label);
        } else {
          index = _labels.indexOf(label);
          break;
        }
      } else {
        if (value <= rangeDate.microsecondsSinceEpoch) {
          index = _labels.indexOf(label);
        }
        if (value >= rangeDate.microsecondsSinceEpoch) {
          break;
        }
      }
    }
    return index;
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
