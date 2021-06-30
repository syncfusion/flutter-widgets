part of charts;

/// This class holds the properties of the DateTime axis.
///
/// The date-time axis uses a date-time scale and displays date-time values as axis labels in the specified format.
///
/// The range of the Date time can be customized by [minimum] and [maximum] properties, also change data label format by the [dateFormat].
///
/// Provides the options for range padding, interval, date format for customizing the appearance.
///
@immutable
class DateTimeAxis extends ChartAxis {
  /// Creating an argument constructor of DateTimeAxis class.
  DateTimeAxis({
    String? name,
    bool? isVisible,
    AxisTitle? title,
    AxisLine? axisLine,
    ChartRangePadding? rangePadding,
    AxisLabelIntersectAction? labelIntersectAction,
    ChartDataLabelPosition? labelPosition,
    TickPosition? tickPosition,
    EdgeLabelPlacement? edgeLabelPlacement,
    double? zoomFactor,
    double? zoomPosition,
    bool? enableAutoIntervalOnZooming,
    int? labelRotation,
    bool? isInversed,
    bool? opposedPosition,
    int? minorTicksPerInterval,
    int? maximumLabels,
    double? plotOffset,
    MajorTickLines? majorTickLines,
    MinorTickLines? minorTickLines,
    MajorGridLines? majorGridLines,
    MinorGridLines? minorGridLines,
    TextStyle? labelStyle,
    this.dateFormat,
    this.intervalType = DateTimeIntervalType.auto,
    InteractiveTooltip? interactiveTooltip,
    this.labelFormat,
    this.minimum,
    this.maximum,
    LabelAlignment? labelAlignment,
    double? interval,
    this.visibleMinimum,
    this.visibleMaximum,
    dynamic crossesAt,
    String? associatedAxisName,
    bool? placeLabelsNearAxisLine,
    List<PlotBand>? plotBands,
    RangeController? rangeController,
    int? desiredIntervals,
    double? maximumLabelWidth,
    double? labelsExtent,
    this.autoScrollingDeltaType = DateTimeIntervalType.auto,
    int? autoScrollingDelta,
    AutoScrollingMode? autoScrollingMode,
  }) : super(
            name: name,
            isVisible: isVisible,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            rangePadding: rangePadding,
            plotOffset: plotOffset,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            labelAlignment: labelAlignment,
            axisLine: axisLine,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            edgeLabelPlacement: edgeLabelPlacement,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
            interactiveTooltip: interactiveTooltip,
            interval: interval,
            crossesAt: crossesAt,
            associatedAxisName: associatedAxisName,
            placeLabelsNearAxisLine: placeLabelsNearAxisLine,
            plotBands: plotBands,
            rangeController: rangeController,
            desiredIntervals: desiredIntervals,
            maximumLabelWidth: maximumLabelWidth,
            labelsExtent: labelsExtent,
            autoScrollingDelta: autoScrollingDelta,
            autoScrollingMode: autoScrollingMode);

  ///Formats the date-time axis labels. The default data-time axis label can be formatted
  ///with various built-in date formats.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(dateFormat: DateFormat.y()),
  ///        ));
  ///}
  ///```
  final DateFormat? dateFormat;

  ///Formats the date time-axis labels. The labels can be customized by adding desired
  ///text to prefix or suffix.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(labelFormat: '{value}M'),
  ///        ));
  ///}
  ///```
  final String? labelFormat;

  ///Customizes the date-time axis intervals. Intervals can be set to days, hours,
  ///milliseconds, minutes, months, seconds, years, and auto. If it is set to auto,
  ///interval type will be decided based on the data.
  ///
  ///Defaults to `DateTimeIntervalType.auto`
  ///
  ///Also refer [DateTimeIntervalType]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.years),
  ///        ));
  ///}
  ///```
  final DateTimeIntervalType intervalType;

  ///Minimum value of the axis. The axis will start from this date.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(minimum: DateTime(2000)),
  ///        ));
  ///}
  ///```
  final DateTime? minimum;

  ///Maximum value of the axis. The axis will end at this date.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(maximum: DateTime(2019)),
  ///        ));
  ///}
  ///```
  final DateTime? maximum;

  ///The minimum visible value of the axis. The axis will be rendered from this date initially.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: DateTimeAxis(visibleMinimum: DateTime(2000)),
  ///        ));
  ///}
  ///```
  final DateTime? visibleMinimum;

  ///The maximum visible value of the axis. The axis will be rendered from this date initially.
  ///
  /// Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///          primaryXAxis: DateTimeAxis(visibleMaximum: DateTime(2019)),
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
  ///           primaryXAxis: DateTimeAxis(autoScrollingDeltaType: DateTimeIntervalType.months),
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

    return other is DateTimeAxis &&
        other.name == name &&
        other.isVisible == isVisible &&
        other.title == title &&
        other.axisLine == axisLine &&
        other.rangePadding == rangePadding &&
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
        other.dateFormat == dateFormat &&
        other.intervalType == intervalType &&
        other.autoScrollingDelta == autoScrollingDelta &&
        other.enableAutoIntervalOnZooming == enableAutoIntervalOnZooming &&
        other.autoScrollingMode == autoScrollingMode;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      name,
      isVisible,
      title,
      axisLine,
      rangePadding,
      labelIntersectAction,
      labelPosition,
      tickPosition,
      edgeLabelPlacement,
      zoomFactor,
      zoomPosition,
      enableAutoIntervalOnZooming,
      labelRotation,
      isInversed,
      opposedPosition,
      minorTicksPerInterval,
      maximumLabels,
      plotOffset,
      majorTickLines,
      minorTickLines,
      majorGridLines,
      minorGridLines,
      labelStyle,
      dateFormat,
      intervalType,
      interactiveTooltip,
      labelFormat,
      minimum,
      maximum,
      labelAlignment,
      interval,
      visibleMinimum,
      visibleMaximum,
      crossesAt,
      associatedAxisName,
      placeLabelsNearAxisLine,
      plotBands,
      rangeController,
      desiredIntervals,
      maximumLabelWidth,
      labelsExtent,
      autoScrollingDeltaType,
      autoScrollingDelta,
      autoScrollingMode
    ];
    return hashList(values);
  }
}

/// Creates an axis renderer for Datetime axis
class DateTimeAxisRenderer extends ChartAxisRenderer {
  /// Creating an argument constructor of DateTimeAxisRenderer class.
  DateTimeAxisRenderer(this._dateTimeAxis) : super(_dateTimeAxis);
  late DateTimeIntervalType _actualIntervalType;
  late int _dateTimeInterval;

  @override
  late SfCartesianChart _chart;
  @override
  late Size _axisSize;

  final DateTimeAxis _dateTimeAxis;

  /// Find the series min and max values of an series
  void _findAxisMinMaxValues(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool? isXVisibleRange, bool? isYVisibleRange]) {
    if (point.x != null) {
      point.xValue = (point.x).millisecondsSinceEpoch;
    }
    final bool _anchorRangeToVisiblePoints =
        seriesRenderer._yAxisRenderer!._axis.anchorRangeToVisiblePoints;
    final String seriesType = seriesRenderer._seriesType;
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
    if (isYVisibleRange && point.xValue != null) {
      seriesRenderer._minimumX =
          math.min(seriesRenderer._minimumX!, point.xValue);
      seriesRenderer._maximumX =
          math.max(seriesRenderer._maximumX!, point.xValue);
    }
    if (isXVisibleRange || !_anchorRangeToVisiblePoints) {
      if (point.yValue != null &&
          (!seriesType.contains('range') &&
              !seriesType.contains('hilo') &&
              !seriesType.contains('candle') &&
              seriesType != 'boxandwhisker' &&
              seriesType != 'waterfall')) {
        seriesRenderer._minimumY =
            math.min(seriesRenderer._minimumY!, point.yValue);
        seriesRenderer._maximumY =
            math.max(seriesRenderer._maximumY!, point.yValue);
      }
      if (point.high != null) {
        _highMin = math.min(_highMin ?? point.high, point.high);
        _highMax = math.max(_highMax ?? point.high, point.high);
      }
      if (point.low != null) {
        _lowMin = math.min(_lowMin ?? point.low, point.low);
        _lowMax = math.max(_lowMax ?? point.low, point.low);
      }
      if (point.maximum != null) {
        _highMin = _findMinValue(_highMin ?? point.maximum!, point.maximum!);
        _highMax = _findMaxValue(_highMax ?? point.maximum!, point.maximum!);
      }
      if (point.minimum != null) {
        _lowMin = _findMinValue(_lowMin ?? point.minimum!, point.minimum!);
        _lowMax = _findMaxValue(_lowMax ?? point.minimum!, point.minimum!);
      }
      if (seriesType == 'waterfall') {
        /// Empty point is not applicable for Waterfall series.
        point.yValue ??= 0;
        seriesRenderer._minimumY =
            math.min(seriesRenderer._minimumY ?? point.yValue, point.yValue);
        seriesRenderer._maximumY = math.max(
            seriesRenderer._maximumY ?? point.maxYValue, point.maxYValue);
      }
    }
    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle') ||
          seriesType == 'boxandwhisker') {
        _lowMin ??= 0;
        _lowMax ??= 5;
        _highMin ??= 0;
        _highMax ??= 5;
        seriesRenderer._minimumY = math.min(_lowMin!, _highMin!);
        seriesRenderer._maximumY = math.max(_lowMax!, _highMax!);
      }
      seriesRenderer._minimumX ??= 2717008000;
      seriesRenderer._maximumX ??= 13085008000;
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
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    _axisSize = Size(rect.width, rect.height);
    calculateRange(this);
    _calculateActualRange();
    if (_actualRange != null) {
      applyRangePadding(_actualRange!, _actualRange!.interval);
      if (type == null && type != 'AxisCross' && _dateTimeAxis.isVisible) {
        generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for the date-time axis
  void _calculateActualRange() {
    ///When chart series is empty, Rendering default chart with below min, max
    _min ??= 2717008000;
    _max ??= 13085008000;
    _actualRange = _VisibleRange(
        _dateTimeAxis.minimum != null
            ? _dateTimeAxis.minimum!.millisecondsSinceEpoch
            : _min,
        _dateTimeAxis.maximum != null
            ? _dateTimeAxis.maximum!.millisecondsSinceEpoch
            : _max);
    if (_actualRange!.minimum == _actualRange!.maximum) {
      _actualRange!.minimum = _actualRange!.minimum - 2592000000;
      _actualRange!.maximum = _actualRange!.maximum + 2592000000;
    }
    _dateTimeInterval =
        _calculateDateTimeNiceInterval(this, _axisSize, _actualRange!).floor();
    _actualRange!.interval = _dateTimeAxis.interval ?? _dateTimeInterval;
    _actualRange!.delta = _actualRange!.maximum - _actualRange!.minimum;
  }

  /// Returns the range start values based on actual interval type
  int _alignRangeStart(
      DateTimeAxisRenderer axisRenderer, int startDate, num interval) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startDate);
    switch (axisRenderer._actualIntervalType) {
      case DateTimeIntervalType.years:
        final int year =
            ((dateTime.year / interval).floor() * interval).floor();
        dateTime = DateTime(year, dateTime.month, dateTime.day, 0, 0, 0, 0);
        break;
      case DateTimeIntervalType.months:
        final int month = ((dateTime.month / interval) * interval).floor();
        dateTime = DateTime(dateTime.year, month, dateTime.day, 0, 0, 0, 0);
        break;
      case DateTimeIntervalType.days:
        final int day = ((dateTime.day / interval) * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, day, 0, 0, 0, 0);
        break;
      case DateTimeIntervalType.hours:
        final int hour =
            ((dateTime.hour / interval).floor() * interval).floor();
        dateTime = DateTime(
            dateTime.year, dateTime.month, dateTime.day, hour, 0, 0, 0);
        break;
      case DateTimeIntervalType.minutes:
        final int minute =
            ((dateTime.minute / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, minute, 0, 0);
        break;
      case DateTimeIntervalType.seconds:
        final int second =
            ((dateTime.second / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, second, 0);
        break;
      case DateTimeIntervalType.milliseconds:
        final int millisecond =
            ((dateTime.millisecond / interval).floor() * interval).floor();
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second, millisecond, 0);
        break;
      case DateTimeIntervalType.auto:
        break;
    }
    return dateTime.millisecondsSinceEpoch;
  }

  /// Increase the range interval based on actual interval type
  DateTime _increaseDateTimeInterval(
      DateTimeAxisRenderer axisRenderer, int value, num dateInterval) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    axisRenderer._visibleRange!.interval = dateInterval;
    final bool isIntervalDecimal = dateInterval % 1 == 0;
    final num interval = dateInterval;
    if (isIntervalDecimal) {
      final int interval = dateInterval.floor();
      switch (axisRenderer._actualIntervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(dateTime.year + interval, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, 0);
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(dateTime.year, dateTime.month + interval,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, 0);
          break;
        case DateTimeIntervalType.days:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day + interval,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              0);
          break;
        case DateTimeIntervalType.hours:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour + interval, dateTime.minute, dateTime.second, 0);
          break;
        case DateTimeIntervalType.minutes:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour, dateTime.minute + interval, dateTime.second, 0);
          break;
        case DateTimeIntervalType.seconds:
          dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour, dateTime.minute, dateTime.second + interval, 0);
          break;
        case DateTimeIntervalType.milliseconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond + interval);
          break;
        case DateTimeIntervalType.auto:
          break;
      }
    } else {
      switch (axisRenderer._actualIntervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month + (interval * 12).floor(),
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              0);
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day + (interval * 30).floor(),
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              0);
          break;
        case DateTimeIntervalType.days:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour + (interval * 24).floor(),
              dateTime.minute,
              dateTime.second,
              0);
          break;
        case DateTimeIntervalType.hours:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute + (interval * 60).floor(),
              dateTime.second,
              0);
          break;
        case DateTimeIntervalType.minutes:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second + (interval * 60).floor(),
              0);
          break;
        case DateTimeIntervalType.seconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              (interval * 1000).floor());
          break;
        case DateTimeIntervalType.milliseconds:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond + interval.floor());
          break;
        case DateTimeIntervalType.auto:
          break;
      }
    }
    return dateTime;
  }

  /// Calculate year
  void _calculateYear(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startYear = minimum.year;
    final int endYear = maximum.year;
    if (rangePadding == ChartRangePadding.additional) {
      _min =
          DateTime(startYear - interval, 1, 1, 0, 0, 0).millisecondsSinceEpoch;
      _max = DateTime(endYear + interval, 1, 1, 0, 0, 0).millisecondsSinceEpoch;
    } else {
      _min = DateTime(startYear, 0, 0, 0, 0, 0).millisecondsSinceEpoch;
      _max = DateTime(endYear, 11, 30, 23, 59, 59).millisecondsSinceEpoch;
    }
  }

  /// Calculate month
  void _calculateMonth(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMonth = minimum.month;
    final int endMonth = maximum.month;
    if (rangePadding == ChartRangePadding.round) {
      _min =
          DateTime(minimum.year, startMonth, 0, 0, 0, 0).millisecondsSinceEpoch;
      _max = DateTime(maximum.year, endMonth,
              DateTime(maximum.year, maximum.month, 0).day, 23, 59, 59)
          .millisecondsSinceEpoch;
    } else {
      _min = DateTime(minimum.year, startMonth + (-interval), 1, 0, 0, 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, endMonth + interval,
              endMonth == 2 ? 28 : 30, 0, 0, 0)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate day
  void _calculateDay(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startDay = minimum.day;
    final int endDay = maximum.day;
    if (rangePadding == ChartRangePadding.round) {
      _min = DateTime(minimum.year, minimum.month, startDay, 0, 0, 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, endDay, 23, 59, 59)
          .millisecondsSinceEpoch;
    } else {
      _min =
          DateTime(minimum.year, minimum.month, startDay + (-interval), 0, 0, 0)
              .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, endDay + interval, 0, 0, 0)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate hour
  void _calculateHour(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startHour = ((minimum.hour / interval) * interval).toInt();
    final int endHour = maximum.hour + (minimum.hour - startHour).toInt();
    if (rangePadding == ChartRangePadding.round) {
      _min = DateTime(minimum.year, minimum.month, minimum.day, startHour, 0, 0)
          .millisecondsSinceEpoch;
      _max =
          DateTime(maximum.year, maximum.month, maximum.day, startHour, 59, 59)
              .millisecondsSinceEpoch;
    } else {
      _min = DateTime(minimum.year, minimum.month, minimum.day,
              startHour + (-interval), 0, 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day,
              endHour + interval, 0, 0)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate minute
  void _calculateMinute(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMinute = ((minimum.minute / interval) * interval).toInt();
    final int endMinute =
        maximum.minute + (minimum.minute - startMinute).toInt();
    if (rangePadding == ChartRangePadding.round) {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              startMinute, 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              endMinute, 59)
          .millisecondsSinceEpoch;
    } else {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              startMinute + (-interval), 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              endMinute + interval, 0)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate second
  void _calculateSecond(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startSecond = ((minimum.second / interval) * interval).toInt();
    final int endSecond =
        maximum.second + (minimum.second - startSecond).toInt();
    if (rangePadding == ChartRangePadding.round) {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, startSecond, 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, endSecond, 0)
          .millisecondsSinceEpoch;
    } else {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, startSecond + (-interval), 0)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, endSecond + interval, 0)
          .millisecondsSinceEpoch;
    }
  }

  /// Calculate millisecond
  void _calculateMilliSecond(DateTime minimum, DateTime maximum,
      ChartRangePadding rangePadding, int interval) {
    final int startMilliSecond =
        ((minimum.millisecond / interval) * interval).toInt();
    final int endMilliSecond =
        maximum.millisecond + (minimum.millisecond - startMilliSecond).toInt();
    if (rangePadding == ChartRangePadding.round) {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, minimum.second, startMilliSecond)
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, maximum.second, endMilliSecond)
          .millisecondsSinceEpoch;
    } else {
      _min = DateTime(minimum.year, minimum.month, minimum.day, minimum.hour,
              minimum.minute, minimum.second, startMilliSecond + (-interval))
          .millisecondsSinceEpoch;
      _max = DateTime(maximum.year, maximum.month, maximum.day, maximum.hour,
              maximum.minute, maximum.second, endMilliSecond + interval)
          .millisecondsSinceEpoch;
    }
  }

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num? interval) {
    _min = range.minimum.toInt();
    _max = range.maximum.toInt();
    ActualRangeChangedArgs rangeChangedArgs;
    if (_dateTimeAxis.minimum == null && _dateTimeAxis.maximum == null) {
      final ChartRangePadding rangePadding =
          _calculateRangePadding(this, _chart);
      final DateTime minimum =
          DateTime.fromMillisecondsSinceEpoch(_min!.toInt());
      final DateTime maximum =
          DateTime.fromMillisecondsSinceEpoch(_max!.toInt());
      if (rangePadding == ChartRangePadding.none) {
        _min = minimum.millisecondsSinceEpoch;
        _max = maximum.millisecondsSinceEpoch;
      } else if (rangePadding == ChartRangePadding.additional ||
          rangePadding == ChartRangePadding.round) {
        switch (_actualIntervalType) {
          case DateTimeIntervalType.years:
            _calculateYear(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.months:
            _calculateMonth(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.days:
            _calculateDay(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.hours:
            _calculateHour(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.minutes:
            _calculateMinute(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.seconds:
            _calculateSecond(minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.milliseconds:
            _calculateMilliSecond(
                minimum, maximum, rangePadding, interval!.toInt());
            break;
          case DateTimeIntervalType.auto:
            break;
        }
      }
    }
    range.minimum = _min;
    range.maximum = _max;
    range.delta = range.maximum - range.minimum;

    calculateVisibleRange(_axisSize);

    /// Setting range as visible zoomRange
    if ((_dateTimeAxis.visibleMinimum != null ||
            _dateTimeAxis.visibleMaximum != null) &&
        (_dateTimeAxis.visibleMinimum != _dateTimeAxis.visibleMaximum) &&
        (!_chartState._isRedrawByZoomPan)) {
      _chartState._isRedrawByZoomPan = false;
      _visibleRange!.minimum = _visibleMinimum ??
          (_dateTimeAxis.visibleMinimum != null
              ? _dateTimeAxis.visibleMinimum!.millisecondsSinceEpoch
              : _visibleRange!.minimum);
      _visibleRange!.maximum = _visibleMaximum ??
          (_dateTimeAxis.visibleMaximum != null
              ? _dateTimeAxis.visibleMaximum!.millisecondsSinceEpoch
              : _visibleRange!.maximum);
      _visibleRange!.delta = _visibleRange!.maximum - _visibleRange!.minimum;
      _visibleRange!.interval = calculateInterval(_visibleRange!, _axisSize);
      _visibleRange!.interval = interval != null && interval % 1 != 0
          ? interval
          : _visibleRange!.interval;
      _zoomFactor = _visibleRange!.delta / (range.delta);
      _zoomPosition =
          (_visibleRange!.minimum - _actualRange!.minimum) / range.delta;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs(_name!, _dateTimeAxis,
          range.minimum, range.maximum, range.interval, _orientation!);
      rangeChangedArgs.visibleMin = _visibleRange!.minimum;
      rangeChangedArgs.visibleMax = _visibleRange!.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange!.interval;
      _chart.onActualRangeChanged!(rangeChangedArgs);
      _visibleRange!.minimum = rangeChangedArgs.visibleMin is DateTime
          ? rangeChangedArgs.visibleMin.millisecondsSinceEpoch
          : rangeChangedArgs.visibleMin;
      _visibleRange!.maximum = rangeChangedArgs.visibleMax is DateTime
          ? rangeChangedArgs.visibleMax.millisecondsSinceEpoch
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
    _visibleLabels = <AxisLabel>[];
    int interval = _visibleRange!.minimum;
    interval = _alignRangeStart(this, interval, _visibleRange!.interval);
    while (interval <= _visibleRange!.maximum) {
      if (_withInRange(interval, _visibleRange!)) {
        final DateFormat format =
            _dateTimeAxis.dateFormat ?? _getDateTimeLabelFormat(this);
        String labelText =
            format.format(DateTime.fromMillisecondsSinceEpoch(interval));
        if (_dateTimeAxis.labelFormat != null &&
            _dateTimeAxis.labelFormat != '') {
          labelText = _dateTimeAxis.labelFormat!
              .replaceAll(RegExp('{value}'), labelText);
        }
        _triggerLabelRenderEvent(labelText, interval);
      }
      interval =
          _increaseDateTimeInterval(this, interval, _visibleRange!.interval)
              .millisecondsSinceEpoch;
    }
    _calculateMaximumLabelSize(this, _chartState);
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) =>
      _calculateDateTimeNiceInterval(this, _axisSize, range).floor();

  ///Auto Scrolling feature
  void _updateScrollingDelta() {
    if (_dateTimeAxis.autoScrollingDelta != null &&
        _dateTimeAxis.autoScrollingDelta! > 0) {
      final DateTimeIntervalType intervalType =
          _dateTimeAxis.autoScrollingDeltaType == DateTimeIntervalType.auto
              ? _actualIntervalType
              : _dateTimeAxis.autoScrollingDeltaType;
      int scrollingDelta;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(_visibleRange!.maximum);
      switch (intervalType) {
        case DateTimeIntervalType.years:
          dateTime = DateTime(
              dateTime.year - _dateTimeAxis.autoScrollingDelta!,
              dateTime.month,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond,
              dateTime.microsecond);
          scrollingDelta =
              _visibleRange!.maximum - dateTime.millisecondsSinceEpoch;
          break;
        case DateTimeIntervalType.months:
          dateTime = DateTime(
              dateTime.year,
              dateTime.month - _dateTimeAxis.autoScrollingDelta!,
              dateTime.day,
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond,
              dateTime.microsecond);
          scrollingDelta =
              _visibleRange!.maximum - dateTime.millisecondsSinceEpoch;
          break;
        case DateTimeIntervalType.days:
          scrollingDelta =
              Duration(days: _dateTimeAxis.autoScrollingDelta!).inMilliseconds;
          break;
        case DateTimeIntervalType.hours:
          scrollingDelta =
              Duration(hours: _dateTimeAxis.autoScrollingDelta!).inMilliseconds;
          break;
        case DateTimeIntervalType.minutes:
          scrollingDelta = Duration(minutes: _dateTimeAxis.autoScrollingDelta!)
              .inMilliseconds;
          break;
        case DateTimeIntervalType.seconds:
          scrollingDelta = Duration(seconds: _dateTimeAxis.autoScrollingDelta!)
              .inMilliseconds;
          break;
        case DateTimeIntervalType.milliseconds:
          scrollingDelta =
              Duration(milliseconds: _dateTimeAxis.autoScrollingDelta!)
                  .inMilliseconds;
          break;
        case DateTimeIntervalType.auto:
          scrollingDelta = _dateTimeAxis.autoScrollingDelta!;
          break;
      }
      super._updateAutoScrollingDelta(scrollingDelta, this);
    }
  }
}
