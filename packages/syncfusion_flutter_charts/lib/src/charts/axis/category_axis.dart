import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'axis.dart';
import 'multi_level_labels.dart';
import 'plot_band.dart';

/// This class has the properties of the category axis.
///
/// Category axis displays text labels instead of numbers. When the string
/// values are bound to x values, then the x-axis must be initialized
/// with [CategoryAxis].
///
/// Provides the options for Label placement, arrange by index and interval used
/// to customize the appearance.
class CategoryAxis extends ChartAxis {
  /// Creating an argument constructor of [CategoryAxis] class.
  const CategoryAxis({
    super.key,
    super.name,
    super.isVisible,
    super.title,
    super.axisLine,
    this.arrangeByIndex = false,
    super.rangePadding,
    this.labelPlacement = LabelPlacement.betweenTicks,
    super.edgeLabelPlacement,
    super.labelPosition,
    super.tickPosition,
    super.labelRotation,
    super.labelIntersectAction,
    super.labelAlignment,
    super.isInversed,
    super.opposedPosition,
    super.maximumLabels,
    super.majorTickLines,
    super.majorGridLines,
    super.labelStyle,
    super.plotOffset,
    super.initialZoomFactor,
    super.initialZoomPosition,
    super.interactiveTooltip,
    this.minimum,
    this.maximum,
    super.interval,
    this.initialVisibleMinimum,
    this.initialVisibleMaximum,
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
    super.multiLevelLabelFormatter,
    super.multiLevelLabelStyle,
    this.multiLevelLabels,
    super.autoScrollingMode,
    super.axisLabelFormatter,
    this.onRendererCreated,
  }) : assert(
            (initialVisibleMaximum == null && initialVisibleMinimum == null) ||
                autoScrollingDelta == null,
            'Both properties have the same behavior to display the visible data points, use any one of the properties');

  /// Position of the category axis labels.
  ///
  /// The labels can be placed either
  /// between the ticks or at the major ticks.
  ///
  /// Defaults to `LabelPlacement.betweenTicks`.
  ///
  /// Also refer [LabelPlacement].
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///        primaryXAxis: CategoryAxis(labelPlacement: LabelPlacement.onTicks),
  ///        )
  ///    );
  /// }
  /// ```
  final LabelPlacement labelPlacement;

  /// Plots the data points based on the index value.
  ///
  /// By default, data points will be
  /// grouped and plotted based on the x-value. They can also be grouped by the
  /// data point index value.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(arrangeByIndex: true),
  ///        )
  ///    );
  /// }
  /// ```
  final bool arrangeByIndex;

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
  ///           primaryYAxis: CategoryAxis(minimum: 0),
  ///        )
  ///    );
  /// }
  /// ```
  final double? minimum;

  /// The maximum value of the axis.
  ///
  /// The axis will end at this value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(maximum: 10),
  ///        )
  ///    );
  /// }
  /// ```
  final double? maximum;

  /// The minimum visible value of the axis. The axis is rendered from this value initially, and
  /// it applies only during load time. The value will not be updated when zooming or panning.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: CategoryAxis(initialVisibleMinimum: 0),
  ///        )
  ///    );
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// minimum value dynamically.
  ///
  /// ```dart
  /// CategoryAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(
  ///             initialVisibleMinimum: 0,
  ///             onRendererCreated: (CategoryAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, String>>[
  ///             LineSeries<SalesData, String>(
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
  ///           primaryYAxis: CategoryAxis(initialVisibleMaximum: 20),
  ///        ));
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// maximum value dynamically
  ///
  /// ```dart
  /// CategoryAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: CategoryAxis(
  ///             initialVisibleMaximum: 20,
  ///             onRendererCreated: (CategoryAxisController controller) {
  ///               axisController = controller;
  ///             },
  ///           ),
  ///           series: <CartesianSeries<SalesData, String>>[
  ///             LineSeries<SalesData, String>(
  ///               dataSource: data,
  ///               xValueMapper: (SalesData sales, _) => sales.year,
  ///               yValueMapper: (SalesData sales, _) => sales.sales,
  ///             ),
  ///           ],
  ///         ),
  ///         TextButton(
  ///           onPressed: () {
  ///             if (axisController != null) {
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
  ///       primaryXAxis: CategoryAxis(
  ///         multiLevelLabels: <CategoricalMultiLevelLabel>[
  ///           CategoricalMultiLevelLabel(
  ///             start: '2',
  ///             end: '4',
  ///             text: 'First'
  ///           ),
  ///           CategoricalMultiLevelLabel(
  ///             start: '5',
  ///             end: '7',
  ///             text: 'Second'
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final List<CategoricalMultiLevelLabel>? multiLevelLabels;

  final Function(CategoryAxisController)? onRendererCreated;

  @override
  RenderCategoryAxis createRenderer() {
    return RenderCategoryAxis();
  }

  @override
  RenderCategoryAxis createRenderObject(BuildContext context) {
    final RenderCategoryAxis renderer =
        super.createRenderObject(context) as RenderCategoryAxis;
    renderer
      ..labelPlacement = labelPlacement
      ..arrangeByIndex = arrangeByIndex
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
      BuildContext context, RenderCategoryAxis renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..labelPlacement = labelPlacement
      ..arrangeByIndex = arrangeByIndex
      ..minimum = minimum
      ..maximum = maximum
      ..multiLevelLabels = multiLevelLabels;
  }
}

class RenderCategoryAxis extends RenderChartAxis {
  final List<String?> labels = <String>[];
  final List<AxisMultilevelLabel> _multilevelLabels = <AxisMultilevelLabel>[];

  @override
  CategoryAxisController get controller => _controller;
  late final CategoryAxisController _controller = CategoryAxisController(this);

  @override
  @nonVirtual
  bool get canAnimate =>
      super.canAnimate ||
      (initialVisibleMinimum != null && initialVisibleMaximum != null);

  bool get arrangeByIndex => _arrangeByIndex;
  bool _arrangeByIndex = false;
  set arrangeByIndex(bool value) {
    if (_arrangeByIndex != value) {
      _arrangeByIndex = value;
      markNeedsUpdate();
    }
  }

  double? get minimum => _minimum;
  double? _minimum;
  set minimum(double? value) {
    if (_minimum != value) {
      _minimum = value;
      markNeedsRangeUpdate();
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

  List<CategoricalMultiLevelLabel>? get multiLevelLabels => _multiLevelLabels;
  List<CategoricalMultiLevelLabel>? _multiLevelLabels;
  set multiLevelLabels(List<CategoricalMultiLevelLabel>? value) {
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

  Function(CategoryAxisController)? get onRendererCreated => _onRendererCreated;
  Function(CategoryAxisController)? _onRendererCreated;
  set onRendererCreated(Function(CategoryAxisController)? value) {
    if (_onRendererCreated != value) {
      _onRendererCreated = value;
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
  num actualValue(Object value) {
    if (value is String) {
      return super
          .actualValue(_toIndex(value, defaultIndex: visibleRange!.minimum));
    }

    return super.actualValue(value);
  }

  @override
  DoubleRange calculateActualRange() {
    if (minimum != null && maximum != null) {
      return DoubleRange(minimum!, maximum!);
    }

    final DoubleRange range = super.calculateActualRange();
    if (minimum != null) {
      range.minimum = minimum!;
    } else if (maximum != null) {
      range.maximum = maximum!;
    }

    if (range.minimum == range.maximum &&
        labelPlacement == LabelPlacement.onTicks) {
      range.maximum += 1;
    }

    return range.copyWith();
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
  DoubleRange defaultRange() => DoubleRange.zero();

  @override
  num calculateNiceInterval(num delta, Size availableSize) {
    final num intervalsCount = desiredIntervalsCount(availableSize);
    final num niceInterval = desiredNiceInterval(delta, intervalsCount);
    return max(1, niceInterval.floor());
  }

  @override
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    if (labelPlacement == LabelPlacement.betweenTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
    }

    if (minimum == null || maximum == null) {
      range = super.applyRangePadding(range, interval, availableSize);

      if (minimum != null) {
        range.minimum = minimum!;
      }
      if (maximum != null) {
        range.maximum = maximum!;
      }
    }

    if (range.minimum == range.maximum) {
      return _handleEqualRange(range);
    }

    return range.copyWith();
  }

  DoubleRange _handleEqualRange(DoubleRange range) {
    if (labelPlacement == LabelPlacement.onTicks) {
      return DoubleRange(range.minimum, range.maximum + 1);
    } else if (labelPlacement == LabelPlacement.betweenTicks) {
      return DoubleRange(range.minimum - 0.5, range.maximum + 0.5);
    }

    return range;
  }

  @override
  void addNormalRange(DoubleRange range, num interval, Size availableSize) {
    if (labelPlacement == LabelPlacement.onTicks) {
      range.minimum -= 0.5;
      range.maximum += 0.5;
      if (range.minimum == 0) {
        updateNormalRangePadding(range, availableSize);
      }
    } else {
      super.addNormalRange(range, interval, availableSize);
    }
  }

  @override
  void generateVisibleLabels() {
    hasTrimmedAxisLabel = false;
    if (visibleRange == null || visibleInterval == 0) {
      return;
    }

    final double extent =
        labelsExtent ?? (maximumLabelWidth ?? double.maxFinite);
    labels.clear();
    for (final AxisDependent dependent in dependents) {
      if (dependent is CartesianSeriesRenderer) {
        if (dependent.controller.isVisible) {
          final List actualXValues = dependent.xRawValues;
          final int actualXValuesLength = actualXValues.length;
          for (int i = 0; i < actualXValuesLength; i++) {
            final String rawX = actualXValues[i].toString();
            if (arrangeByIndex) {
              final int length = labels.length;
              if (i < length && labels[i] != null) {
                labels[i] = '${labels[i]}, $rawX';
              } else {
                labels.add(rawX);
              }
            } else {
              if (!labels.contains(rawX)) {
                labels.add(rawX);
              }
            }
          }
        }
      }
    }

    final num visibleMinimum = visibleRange!.minimum;
    final num visibleMaximum = visibleRange!.maximum;
    int length = labels.length;
    // Calculate the labels until the maximum visible range.
    if (length > 0 && visibleMaximum > length) {
      for (int i = length; i <= visibleMaximum; i++) {
        labels.add(i.toString());
      }
    }

    length = labels.length;
    if (length == 0) {
      return;
    }

    final bool isRtl = textDirection == TextDirection.rtl;
    num current = visibleRange!.minimum.ceil();
    while (current <= visibleMaximum) {
      if (current < visibleMinimum ||
          !effectiveVisibleRange!.contains(current)) {
        current += visibleInterval;
        continue;
      }

      final int currentValue = current.round();
      String text = '';
      if (currentValue <= -1 || currentValue >= length) {
        current += visibleInterval;
        continue;
      } else {
        text = labels[currentValue]!;
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

      Size textSize =
          measureText(callbackText, callbackTextStyle, labelRotation);
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
        current,
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
    if (length == 0 || effectiveVisibleRange == null) {
      return;
    }

    bool isBetweenTicks = placement == LabelPlacement.betweenTicks;
    if (!isBetweenTicks && !canCalculateMajorTick) {
      isBetweenTicks = !isBetweenTicks;
    }

    final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
    length += isBetweenTicks ? 1 : 0;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      num current;
      if (isBetweenTicks) {
        if (i < lastIndex) {
          current = visibleLabels[i].value - tickBetweenLabel;
        } else {
          current =
              (visibleLabels[i - 1].value + visibleInterval) - tickBetweenLabel;
        }
      } else {
        current = visibleLabels[i].value;
      }

      source!.add(pointToPixel(current));
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
          final dynamic actualStart = plotBand.start;
          final dynamic actualEnd = plotBand.end;
          final num min = actualStart != null
              ? actualValue(
                  _toIndex(actualStart, defaultIndex: visibleRange!.minimum))
              : visibleRange!.minimum;
          num max = actualEnd != null
              ? actualValue(
                  _toIndex(actualEnd, defaultIndex: visibleRange!.maximum))
              : visibleRange!.maximum;

          num extent;
          if (plotBand.isRepeatable) {
            extent = plotBand.repeatEvery;
            final dynamic actualRepeatUntil = plotBand.repeatUntil;
            if (actualRepeatUntil != null) {
              max = actualValue(_toIndex(actualRepeatUntil,
                  defaultIndex: visibleRange!.maximum));
              if (max > actualRange!.maximum) {
                max = actualRange!.maximum;
              }
            } else {
              max = actualRange!.maximum;
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

  // Find index, if the plot band [start,end,repeatUntil] value has string.
  // Find index, if crossesAt have a string value.
  num _toIndex(dynamic value, {num? defaultIndex}) {
    if (value is String) {
      final num index = labels.indexOf(value);
      return index != -1 ? index : defaultIndex!;
    }
    return value;
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
      final CategoricalMultiLevelLabel label = multiLevelLabels![i];
      _multilevelLabels.add(AxisMultilevelLabel(label.text, label.level,
          labels.indexOf(label.start), labels.indexOf(label.end)));
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

    final bool isRtl = textDirection == TextDirection.rtl;
    final bool isBetweenTicks = labelPlacement == LabelPlacement.betweenTicks;
    final num betweenTicksInterval = isBetweenTicks ? 0.5 : 0;

    for (final AxisMultilevelLabel label in visibleMultilevelLabels) {
      final num startValue = label.start - betweenTicksInterval;
      final num endValue = label.end + betweenTicksInterval;
      final double start = pointToPixel(startValue);
      final double end = pointToPixel(endValue);
      final double extent = (end - start - textPadding).abs();

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
  void performUpdate() {
    updateXValuesWithArrangeByIndex();
    super.performUpdate();
  }

  void updateXValuesWithArrangeByIndex() {
    if (!arrangeByIndex) {
      final List<String> groupedRawValues = <String>[];
      for (final AxisDependent dependent in dependents) {
        if (dependent is CartesianSeriesRenderer &&
            dependent.controller.isVisible) {
          final List xRawValues = dependent.xRawValues;
          final int length = xRawValues.length;
          if (length > 0) {
            num minValue = 0;
            num maxValue = 0;
            for (int i = 0; i < length; i++) {
              final String rawX = xRawValues[i].toString();
              if (!groupedRawValues.contains(rawX)) {
                groupedRawValues.add(rawX);
              }

              final int index = groupedRawValues.indexOf(rawX);
              dependent.xValues[i] = index;
              minValue = min(minValue, index);
              maxValue = max(maxValue, index);
            }
            dependent.xMin = minValue;
            dependent.xMax = maxValue;
          }
        }
      }
    } else {
      for (final AxisDependent dependent in dependents) {
        if (dependent is CartesianSeriesRenderer &&
            dependent.controller.isVisible) {
          final int length = dependent.dataCount;
          if (length > 0) {
            dependent.xValues.clear();
            for (int i = 0; i < length; i++) {
              dependent.xValues.add(i);
            }
            dependent.xMin = 0;
            dependent.xMax = length - 1;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _multilevelLabels.clear();
    labels.clear();
    controller.dispose();
    super.dispose();
  }
}
