import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'axis.dart';
import 'multi_level_labels.dart';
import 'plot_band.dart';

/// Logarithmic axis uses logarithmic scale and displays numbers as axis labels.
///
/// Provides options to customize the range of log axis, use the [minimum],
/// [maximum], and [interval] properties. By default, the range will be
/// calculated automatically based on the provided data.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LogarithmicAxis extends ChartAxis {
  /// Creating an argument constructor of [LogarithmicAxis] class.
  const LogarithmicAxis({
    super.key,
    super.name,
    super.isVisible = true,
    super.anchorRangeToVisiblePoints = true,
    super.title,
    super.axisLine,
    super.labelIntersectAction,
    super.labelRotation,
    super.labelPosition,
    super.tickPosition,
    super.isInversed,
    super.opposedPosition,
    super.minorTicksPerInterval,
    super.maximumLabels,
    super.majorTickLines,
    super.minorTickLines,
    super.majorGridLines,
    super.minorGridLines,
    super.edgeLabelPlacement,
    super.labelStyle,
    super.plotOffset,
    super.initialZoomFactor,
    super.initialZoomPosition,
    super.enableAutoIntervalOnZooming,
    super.interactiveTooltip,
    this.minimum,
    this.maximum,
    super.interval,
    this.logBase = 10,
    this.labelFormat,
    this.numberFormat,
    this.initialVisibleMinimum,
    this.initialVisibleMaximum,
    super.labelAlignment,
    super.crossesAt,
    super.associatedAxisName,
    super.placeLabelsNearAxisLine,
    super.plotBands,
    super.desiredIntervals,
    super.rangeController,
    super.maximumLabelWidth,
    super.labelsExtent,
    super.autoScrollingDelta,
    super.borderWidth,
    super.borderColor,
    super.axisBorderType,
    super.multiLevelLabelStyle,
    super.multiLevelLabelFormatter,
    this.multiLevelLabels,
    super.autoScrollingMode,
    super.axisLabelFormatter,
    this.onRendererCreated,
  }) : assert(
            (initialVisibleMaximum == null && initialVisibleMinimum == null) ||
                autoScrollingDelta == null,
            'Both properties have the same behavior to display the visible data points, use any one of the properties');

  /// Formats the numeric axis labels.
  ///
  /// The labels can be customized by adding desired text as prefix or suffix.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(labelFormat: '{value}M'),
  ///        )
  ///    );
  /// }
  /// ```
  final String? labelFormat;

  /// Formats the logarithmic axis labels with globalized label formats.
  ///
  /// Provides the ability to format a number in a locale-specific way.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis:
  ///             LogarithmicAxis(numberFormat: NumberFormat.compactCurrency()),
  ///        )
  ///    );
  /// }
  /// ```
  final NumberFormat? numberFormat;

  /// The minimum value of the axis.
  ///
  /// The axis will start from this value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(minimum: 0),
  ///        )
  ///    );
  /// }
  /// ```
  final double? minimum;

  /// The maximum value of the axis.
  /// The axis will end at this value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(maximum: 10),
  ///        )
  ///    );
  /// }
  /// ```
  final double? maximum;

  /// The base value for logarithmic axis.
  /// The axis label will render this base value.i.e 10,100,1000 and so on.
  ///
  /// Defaults to `10`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(logBase: 10),
  ///        )
  ///    );
  /// }
  /// ```
  final double logBase;

  /// The minimum visible value of the axis. The axis is rendered from this value initially, and
  /// it applies only during load time. The value will not be updated when zooming or panning.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(initialVisibleMinimum: 0),
  ///        )
  ///    );
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// minimum value dynamically.
  ///
  /// ```dart
  /// LogarithmicAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(
  ///             initialVisibleMinimum: 0,
  ///             initialVisibleMaximum: 100,
  ///             onRendererCreated: (LogarithmicAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///             LineSeries<SalesData, num>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.visibleMinimum = 30;
  ///              axisController!.visibleMaximum = 70;
  ///            }
  ///           },
  ///           child: const Text('Update Axis Range'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final double? initialVisibleMinimum;

  /// The maximum visible value of the axis. The axis is rendered from this value initially, and
  /// it applies only during load time. The value will not be updated when zooming or panning.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(initialVisibleMaximum: 200),
  ///        )
  ///    );
  ///}
  ///```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// maximum value dynamically.
  ///
  /// ```dart
  /// LogarithmicAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(
  ///             initialVisibleMinimum: 0,
  ///             initialVisibleMaximum: 200,
  ///             onRendererCreated: (LogarithmicAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///             LineSeries<SalesData, num>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
  ///              axisController!.visibleMinimum = 10;
  ///              axisController!.visibleMaximum = 70;
  ///            }
  ///           },
  ///           child: const Text('Update Axis Range'),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final double? initialVisibleMaximum;

  /// Provides the option to group the axis labels. You can customize the start,
  /// end value of a multi-level label, text, and level of
  /// the multi-level labels.
  ///
  /// The `start` and `end` values for the category axis need to be string type,
  /// in the case of date-time or date-time category axes need to be date-time
  /// and in the case of numeric or logarithmic axes needs to be double.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: LogarithmicAxis(
  ///         multiLevelLabels: const <LogarithmicMultiLevelLabel>[
  ///           LogarithmicMultiLevelLabel(
  ///             start: 0,
  ///             end: 2,
  ///             text: 'First'
  ///           ),
  ///           LogarithmicMultiLevelLabel(
  ///             start: 2,
  ///             end: 4,
  ///             text: 'Second'
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final List<LogarithmicMultiLevelLabel>? multiLevelLabels;

  final Function(LogarithmicAxisController)? onRendererCreated;

  @override
  RenderLogarithmicAxis createRenderer() {
    return RenderLogarithmicAxis();
  }

  @override
  RenderLogarithmicAxis createRenderObject(BuildContext context) {
    final RenderLogarithmicAxis renderer =
        super.createRenderObject(context) as RenderLogarithmicAxis;
    renderer
      ..labelFormat = labelFormat
      ..numberFormat = numberFormat
      ..logBase = logBase
      ..minimum = minimum
      ..maximum = maximum
      ..initialVisibleMinimum = initialVisibleMinimum
      ..initialVisibleMaximum = initialVisibleMaximum
      ..multiLevelLabels = multiLevelLabels
      ..onRendererCreated = onRendererCreated;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLogarithmicAxis renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..labelFormat = labelFormat
      ..numberFormat = numberFormat
      ..logBase = logBase
      ..minimum = minimum
      ..maximum = maximum
      ..multiLevelLabels = multiLevelLabels;
  }
}

class RenderLogarithmicAxis extends RenderChartAxis {
  final List<AxisMultilevelLabel> _multilevelLabels = <AxisMultilevelLabel>[];
  bool _dependentIsStacked = false;

  @override
  LogarithmicAxisController get controller => _controller;
  late final LogarithmicAxisController _controller =
      LogarithmicAxisController(this);

  @override
  @nonVirtual
  bool get canAnimate =>
      super.canAnimate ||
      (initialVisibleMinimum != null && initialVisibleMaximum != null);

  String? get labelFormat => _labelFormat;
  String? _labelFormat;
  set labelFormat(String? value) {
    if (_labelFormat != value) {
      _labelFormat = value;
      markNeedsLayout();
    }
  }

  NumberFormat? get numberFormat => _numberFormat;
  NumberFormat? _numberFormat;
  set numberFormat(NumberFormat? value) {
    if (_numberFormat != value) {
      _numberFormat = value;
      markNeedsLayout();
    }
  }

  double? get minimum => _minimum;
  double? _minimum;
  set minimum(double? value) {
    if (_minimum != value) {
      _minimum = value;
      markNeedsLayout();
    }
  }

  double? get maximum => _maximum;
  double? _maximum;
  set maximum(double? value) {
    if (_maximum != value) {
      _maximum = value;
      markNeedsRangeUpdate();
    }
  }

  double get logBase => _logBase;
  double _logBase = 10;
  set logBase(double value) {
    if (_logBase != value) {
      _logBase = value <= 0 ? 2 : value;
      markNeedsUpdate();
    }
  }

  double? get initialVisibleMinimum => _initialVisibleMinimum;
  double? _initialVisibleMinimum;
  set initialVisibleMinimum(double? value) {
    if (_initialVisibleMinimum == value) {
      return;
    }
    _initialVisibleMinimum = value;
    if (rangeController != null && rangeController!.start != null) {
      _updateVisibleMinMax(min: (rangeController!.start as num).toDouble());
    } else {
      _updateVisibleMinMax(min: initialVisibleMinimum);
    }
  }

  double? get initialVisibleMaximum => _initialVisibleMaximum;
  double? _initialVisibleMaximum;
  set initialVisibleMaximum(double? value) {
    if (_initialVisibleMaximum == value) {
      return;
    }
    _initialVisibleMaximum = value;
    if (rangeController != null && rangeController!.end != null) {
      _updateVisibleMinMax(max: (rangeController!.end as num).toDouble());
    } else {
      _updateVisibleMinMax(max: initialVisibleMaximum);
    }
  }

  List<LogarithmicMultiLevelLabel>? get multiLevelLabels => _multiLevelLabels;
  List<LogarithmicMultiLevelLabel>? _multiLevelLabels;
  set multiLevelLabels(List<LogarithmicMultiLevelLabel>? value) {
    if (_multiLevelLabels != value) {
      _multiLevelLabels = value;
      markNeedsLayout();
    }
  }

  @override
  set rangeController(RangeController? value) {
    super.rangeController = value;
    if (value == null) {
      return;
    }
    _updateVisibleMinMax(
      min: (value.start as num?)?.toDouble(),
      max: (value.end as num?)?.toDouble(),
    );
  }

  Function(LogarithmicAxisController)? get onRendererCreated =>
      _onRendererCreated;
  Function(LogarithmicAxisController)? _onRendererCreated;
  set onRendererCreated(Function(LogarithmicAxisController)? value) {
    if (_onRendererCreated != value) {
      _onRendererCreated = value;
    }
  }

  @override
  void addDependent(AxisDependent dependent, {bool isXAxis = true}) {
    super.addDependent(dependent, isXAxis: isXAxis);
    if (isVertical && dependent is Stacking100SeriesMixin) {
      _dependentIsStacked = true;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    onRendererCreated?.call(controller);
    rangeController?.addListener(_handleRangeControllerChange);
    super.attach(owner);
  }

  @override
  void detach() {
    rangeController?.removeListener(_handleRangeControllerChange);
    super.detach();
  }

  void _handleRangeControllerChange() {
    assert(rangeController != null);
    _updateVisibleMinMax(
      min: (rangeController!.start as num?)?.toDouble(),
      max: (rangeController!.end as num?)?.toDouble(),
    );
  }

  void _updateVisibleMinMax({double? min, double? max}) {
    if (min != null) {
      controller.visibleMinimum = min;
    }
    if (max != null) {
      controller.visibleMaximum = max;
    }
  }

  @override
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    return range;
  }

  @override
  num desiredNiceInterval(num delta, num intervalsCount) {
    return delta;
  }

  @override
  num actualValue(Object value) {
    final num cross = value as num;
    final num minimum = toPow(actualRange!.minimum);
    final num maximum = toPow(actualRange!.maximum);
    if (cross < minimum) {
      return minimum;
    }
    if (cross > maximum) {
      return maximum;
    }
    return cross;
  }

  @override
  DoubleRange calculateActualRange() {
    final DoubleRange range = super.calculateActualRange();
    if (minimum != null) {
      range.minimum = minimum!;
    }
    if (maximum != null) {
      range.maximum = maximum!;
    }

    return _calculateRange(range);
  }

  DoubleRange _calculateRange(DoubleRange range) {
    final DoubleRange rangeCopy = range.copyWith();
    num max = rangeCopy.maximum;
    num min = rangeCopy.minimum;
    if (min < 0) {
      min = 0;
    }
    num start = toLog(min);
    start = start.isFinite ? start : min;
    num end = toLog(max);
    end = end.isFinite ? end : max;
    min = (start / 1).floor();
    max = (end / 1).ceil();
    if (min == max) {
      max = max + 1;
    }

    return rangeCopy
      ..minimum = min
      ..maximum = max;
  }

  @override
  DoubleRange updateAutoScrollingDelta(
      int scrollingDelta, DoubleRange actualRange, DoubleRange visibleRange) {
    if (initialVisibleMaximum != null || initialVisibleMinimum != null) {
      return visibleRange;
    }
    return super
        .updateAutoScrollingDelta(scrollingDelta, actualRange, visibleRange);
  }

  @override
  DoubleRange defaultRange() => DoubleRange(1, 10);

  @override
  num calculateNiceInterval(num delta, Size availableSize) {
    num niceInterval;

    final num intervalsCount = desiredIntervalsCount(availableSize);
    niceInterval = desiredNiceInterval(delta, intervalsCount);

    final List<num> divisions = <num>[10, 5, 2, 1];
    final num minimumInterval =
        niceInterval == 0 ? 0 : pow(10, (log(niceInterval) / log(10)).floor());
    for (int i = 0; i < divisions.length; i++) {
      final num interval = divisions[i];
      final num currentInterval = minimumInterval * interval;
      if (intervalsCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }

    return niceInterval;
  }

  @override
  void generateVisibleLabels() {
    hasTrimmedAxisLabel = false;
    if (visibleRange == null || visibleInterval == 0) {
      return;
    }

    final double extent =
        labelsExtent ?? (maximumLabelWidth ?? double.maxFinite);
    final bool isRtl = textDirection == TextDirection.rtl;
    num current = visibleRange!.minimum;
    final num visibleMinimum = visibleRange!.minimum;
    final num visibleMaximum = visibleRange!.maximum;
    while (current <= visibleMaximum) {
      if (current < visibleMinimum ||
          !effectiveVisibleRange!.contains(current)) {
        current += visibleInterval;
        continue;
      }

      final num currentValue = toPow(current);
      String text = currentValue < 1
          ? currentValue.toString()
          : currentValue.floor().toString();
      if (numberFormat != null) {
        text = numberFormat!.format(toPow(current));
      }

      if (labelFormat != null && labelFormat != '') {
        text = labelFormat!.replaceAll(RegExp('{value}'), text);
      }

      if (_dependentIsStacked) {
        text = '$text%';
      }
      String callbackText = text;
      TextStyle callbackTextStyle =
          chartThemeData!.axisLabelTextStyle!.merge(labelStyle);
      if (axisLabelFormatter != null) {
        final AxisLabelRenderDetails details = AxisLabelRenderDetails(
            current, callbackText, callbackTextStyle, this, null, null);
        final ChartAxisLabel label = axisLabelFormatter!(details);
        callbackText = label.text;
        callbackTextStyle = callbackTextStyle.merge(label.textStyle);
      }

      Size textSize = measureText(callbackText, callbackTextStyle, 0);
      String textAfterTrimming = callbackText;
      if (extent.isFinite && textSize.width > extent) {
        textAfterTrimming = trimmedText(
          callbackText,
          callbackTextStyle,
          extent,
          labelRotation,
          isRtl: isRtl,
        );
      }

      textSize =
          measureText(textAfterTrimming, callbackTextStyle, labelRotation);
      final bool isTextTrimmed = callbackText != textAfterTrimming;
      final AxisLabel label = AxisLabel(
        callbackTextStyle,
        textSize,
        callbackText,
        currentValue,
        isTextTrimmed ? textAfterTrimming : null,
        textAfterTrimming,
      );
      visibleLabels.add(label);
      if (isTextTrimmed) {
        hasTrimmedAxisLabel = true;
      }
      current += visibleInterval;
    }

    super.generateVisibleLabels();
  }

  @override
  void calculateTickPositions(
    LabelPlacement placement, {
    List<double>? source,
    bool canCalculateMinorTick = false,
    bool canCalculateMajorTick = true,
  }) {
    int length = visibleLabels.length;
    if (length == 0) {
      return;
    }

    final bool isBetweenTicks = placement == LabelPlacement.betweenTicks;
    final num tickBetweenLabel = isBetweenTicks ? visibleInterval / 2 : 0;
    length += isBetweenTicks ? 1 : 0;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      num current;
      if (isBetweenTicks) {
        if (i < lastIndex) {
          current = toLog(visibleLabels[i].value) - tickBetweenLabel;
        } else {
          current = (toLog(visibleLabels[i - 1].value) + visibleInterval) -
              tickBetweenLabel;
        }
      } else {
        current = toLog(visibleLabels[i].value);
      }

      source!.add(pointToPixel(toPow(current)));

      if (canCalculateMinorTick) {
        final num start = current;
        final num end = start + visibleInterval;
        final double minorTickInterval =
            visibleInterval / (minorTicksPerInterval + 1);
        for (int j = 1; j <= minorTicksPerInterval; j++) {
          final double tickValue = start + minorTickInterval * j;
          if (tickValue < end && tickValue < visibleRange!.maximum) {
            minorTickPositions.add(pointToPixel(toPow(tickValue)));
          }
        }
      }
    }
  }

  @override
  void generatePlotBands() {
    if (plotBands.isNotEmpty &&
        associatedAxis != null &&
        associatedAxis!.visibleRange != null) {
      visiblePlotBands ??= <AxisPlotBand>[];
      final int length = plotBands.length;
      final Rect Function(PlotBand plotBand, num start, num end) bounds =
          isVertical ? verticalPlotBandBounds : horizontalPlotBandBounds;

      for (int i = 0; i < length; i++) {
        final PlotBand plotBand = plotBands[i];
        if (plotBand.isVisible) {
          final num min = plotBand.start != null
              ? actualValue(plotBand.start)
              : toPow(visibleRange!.minimum);
          num max = plotBand.end != null
              ? actualValue(plotBand.end)
              : toPow(visibleRange!.maximum);

          num extent;
          if (plotBand.isRepeatable) {
            extent = plotBand.repeatEvery;
            if (plotBand.repeatUntil != null) {
              max = actualValue(plotBand.repeatUntil);
              final num actualMax = toPow(actualRange!.maximum);
              if (max > actualMax) {
                max = actualMax;
              }
            } else {
              max = toPow(actualRange!.maximum);
            }
          } else {
            extent = max - min;
          }

          num current = min;
          if (plotBand.isRepeatable) {
            while (current < max) {
              current =
                  formPlotBandFrame(plotBand, current, extent, max, bounds);
            }
          } else {
            formPlotBandFrame(plotBand, current, extent, max, bounds);
          }
        }
      }
    }
  }

  @override
  num formPlotBandFrame(PlotBand plotBand, num current, num extent, num max,
      Rect Function(PlotBand plotBand, num start, num end) bounds) {
    num end = plotBandExtent(
        plotBand, current, plotBand.isRepeatable ? plotBand.size : extent);
    if (end > max) {
      end = max;
    }
    final DoubleRange logRange = visibleRange!.copyWith();
    final DoubleRange powRange =
        DoubleRange(toPow(logRange.minimum), toPow(logRange.maximum));
    if (powRange.lies(current, end)) {
      final Rect frame = bounds(plotBand, current, end);
      addPlotBand(frame, plotBand);
      current = plotBand.size != null
          ? plotBandExtent(plotBand, current,
              plotBand.isRepeatable ? plotBand.repeatEvery : end)
          : end;
    }
    return current;
  }

  @override
  void generateMultiLevelLabels() {
    _multilevelLabels.clear();
    visibleMultilevelLabels.clear();

    final int length = multiLevelLabels?.length ?? 0;
    if (length == 0) {
      return;
    }

    for (int i = 0; i < length; i++) {
      final LogarithmicMultiLevelLabel label = multiLevelLabels![i];
      assert(label.start <= label.end);
      _multilevelLabels.add(AxisMultilevelLabel(
          label.text, label.level, toLog(label.start), toLog(label.end)));
    }

    _multilevelLabels.sort((AxisMultilevelLabel a, AxisMultilevelLabel b) =>
        a.level.compareTo(b.level));

    final void Function(AxisMultilevelLabel label) add = invertElementsOrder
        ? (AxisMultilevelLabel label) =>
            visibleMultilevelLabels.insert(0, label)
        : (AxisMultilevelLabel label) => visibleMultilevelLabels.add(label);

    final int labelsLength = _multilevelLabels.length;
    final TextStyle textStyle = chartThemeData!.axisMultiLevelLabelTextStyle!
        .merge(multiLevelLabelStyle.textStyle);
    for (int i = 0; i < labelsLength; i++) {
      final AxisMultilevelLabel current = _multilevelLabels[i];
      if (isLies(current.start, current.end, visibleRange!)) {
        String desiredText = current.text;
        TextStyle desiredTextStyle = textStyle;
        if (multiLevelLabelFormatter != null) {
          final MultiLevelLabelRenderDetails details =
              MultiLevelLabelRenderDetails(
                  current.level, desiredText, desiredTextStyle, i, name);
          final ChartAxisLabel label = multiLevelLabelFormatter!(details);
          desiredText = label.text;
          desiredTextStyle = textStyle.merge(label.textStyle);
        }

        current
          ..actualTextSize = measureText(desiredText, desiredTextStyle, 0)
          ..renderText = desiredText
          ..style = desiredTextStyle;
        add(current);
      }
    }
  }

  @override
  void updateMultiLevelLabels() {
    late Rect Function(double start, double end, Size size) labelBounds;
    labelBounds = isVertical ? _verticalLabelBounds : _horizontalLabelBounds;

    const double padding = 12.0;
    final bool isRtl = textDirection == TextDirection.rtl;
    for (final AxisMultilevelLabel label in visibleMultilevelLabels) {
      final double start = pointToPixel(toPow(label.start));
      final double end = pointToPixel(toPow(label.end));
      final double extent = (end - start - padding).abs();

      String renderText = label.renderText;
      final TextStyle style = label.style;
      if (label.actualTextSize.width > extent) {
        renderText = trimmedText(renderText, style, extent, 0, isRtl: isRtl);
      }

      label.trimmedText = renderText;
      label
        ..transformStart = start
        ..transformEnd = end
        ..region = labelBounds(start, end, measureText(renderText, style, 0));
    }
  }

  Rect _horizontalLabelBounds(double start, double end, Size labelSize) {
    double height = labelSize.height;
    if (multiLevelLabelStyle.borderType == MultiLevelBorderType.curlyBrace) {
      height += 2 * textPaddingOfCurlyBrace;
    } else {
      height += 2 * textPadding;
    }

    return Rect.fromLTRB(start, 0, end, height);
  }

  Rect _verticalLabelBounds(double start, double end, Size labelSize) {
    double width = labelSize.width;
    if (multiLevelLabelStyle.borderType == MultiLevelBorderType.curlyBrace) {
      width += 2 * textPaddingOfCurlyBrace;
    } else {
      width += 2 * textPadding;
    }

    return Rect.fromLTRB(0, start, width, end);
  }

  @override
  double pointToPixel(num dataPoint, {DoubleRange? range}) {
    return super.pointToPixel(toLog(dataPoint));
  }

  num toPow(num value) => pow(_logBase, value);

  num toLog(num value) {
    if (value <= 0) {
      return 0;
    }

    final num logValue = _log(value);
    if (logValue.isInfinite || logValue.isNaN) {
      return 0;
    }

    return logValue;
  }

  num _log(num value) => log(value) / log(_logBase);

  @override
  void dispose() {
    _multilevelLabels.clear();
    controller.dispose();
    super.dispose();
  }
}
