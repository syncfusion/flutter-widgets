import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_core/core.dart';

import '../common/callbacks.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'axis.dart';
import 'multi_level_labels.dart';

/// This class has the properties of the numeric axis.
///
/// Numeric axis uses a numerical scale and displays numbers as labels.
/// By default, [NumericAxis] is set to both horizontal axis and vertical axis.
///
/// Provides the options of [name], axis line, label rotation, label format,
/// alignment and label position are used to customize the appearance.
class NumericAxis extends ChartAxis {
  /// Creating an argument constructor of [NumericAxis] class.
  const NumericAxis({
    super.key,
    super.name,
    super.isVisible = true,
    super.anchorRangeToVisiblePoints = true,
    super.title,
    super.axisLine,
    super.rangePadding,
    super.labelIntersectAction,
    super.labelRotation,
    this.labelFormat,
    this.numberFormat,
    super.labelAlignment,
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
    this.initialVisibleMinimum,
    this.initialVisibleMaximum,
    super.crossesAt,
    super.associatedAxisName,
    super.placeLabelsNearAxisLine,
    super.plotBands,
    this.decimalPlaces = 3,
    super.desiredIntervals,
    super.rangeController,
    super.maximumLabelWidth,
    super.labelsExtent,
    super.autoScrollingDelta,
    super.autoScrollingMode,
    super.borderWidth,
    super.borderColor,
    super.axisBorderType,
    this.multiLevelLabels,
    super.multiLevelLabelFormatter,
    super.multiLevelLabelStyle,
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
  ///           primaryXAxis: NumericAxis(labelFormat: '{value}M'),
  ///        )
  ///    );
  /// }
  /// ```
  final String? labelFormat;

  /// Formats the numeric axis labels with globalized label formats.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(numberFormat:
  ///             NumberFormat.compactCurrency()),
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
  ///           primaryXAxis: NumericAxis(minimum: 0),
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
  ///           primaryXAxis: NumericAxis(maximum: 200),
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
  /// NumericAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             initialVisibleMinimum: 0,
  ///             initialVisibleMaximum: 100,
  ///             onRendererCreated: (NumericAxisController controller) {
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
  ///           primaryXAxis: NumericAxis(initialVisibleMaximum: 200),
  ///        )
  ///    );
  /// }
  /// ```
  ///
  /// Use the [onRendererCreated] callback, as shown in the code below, to update the visible
  /// maximum value dynamically.
  ///
  /// ```dart
  /// NumericAxisController? axisController;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             initialVisibleMinimum: 0,
  ///             initialVisibleMaximum: 200,
  ///             onRendererCreated: (NumericAxisController controller) {
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

  /// The rounding decimal value of the label.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(decimalPlaces: 3),
  ///        )
  ///    );
  /// }
  /// ```
  final int decimalPlaces;

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
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 2,
  ///             text: 'First'
  ///           ),
  ///           NumericMultiLevelLabel(
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
  final List<NumericMultiLevelLabel>? multiLevelLabels;

  final Function(NumericAxisController)? onRendererCreated;

  @override
  RenderChartAxis createRenderer() {
    return RenderNumericAxis();
  }

  @override
  RenderNumericAxis createRenderObject(BuildContext context) {
    final RenderNumericAxis renderer =
        super.createRenderObject(context) as RenderNumericAxis;
    renderer
      ..labelFormat = labelFormat
      ..numberFormat = numberFormat
      ..minimum = minimum
      ..maximum = maximum
      ..initialVisibleMinimum = initialVisibleMinimum
      ..initialVisibleMaximum = initialVisibleMaximum
      ..decimalPlaces = decimalPlaces
      ..multiLevelLabels = multiLevelLabels
      ..onRendererCreated = onRendererCreated;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderNumericAxis renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..labelFormat = labelFormat
      ..numberFormat = numberFormat
      ..minimum = minimum
      ..maximum = maximum
      ..decimalPlaces = decimalPlaces
      ..multiLevelLabels = multiLevelLabels;
  }
}

class RenderNumericAxis extends RenderChartAxis {
  final List<AxisMultilevelLabel> _multilevelLabels = <AxisMultilevelLabel>[];
  bool _dependentIsStacked = false;

  @override
  NumericAxisController get controller => _controller;
  late final NumericAxisController _controller = NumericAxisController(this);

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

  int get decimalPlaces => _decimalPlaces;
  int _decimalPlaces = 3;
  set decimalPlaces(int value) {
    if (_decimalPlaces != value) {
      _decimalPlaces = value;
      markNeedsLayout();
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

  List<NumericMultiLevelLabel>? get multiLevelLabels => _multiLevelLabels;
  List<NumericMultiLevelLabel>? _multiLevelLabels;
  set multiLevelLabels(List<NumericMultiLevelLabel>? value) {
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

  Function(NumericAxisController)? get onRendererCreated => _onRendererCreated;
  Function(NumericAxisController)? _onRendererCreated;
  set onRendererCreated(Function(NumericAxisController)? value) {
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
  DoubleRange updateAutoScrollingDelta(
      int scrollingDelta, DoubleRange actualRange, DoubleRange visibleRange) {
    if (initialVisibleMaximum != null || initialVisibleMinimum != null) {
      return visibleRange;
    }
    return super
        .updateAutoScrollingDelta(scrollingDelta, actualRange, visibleRange);
  }

  @override
  DoubleRange defaultRange() => DoubleRange(0, 5);

  @override
  DoubleRange calculateActualRange() {
    if (minimum != null && maximum != null) {
      if (minimum == maximum) {
        return DoubleRange(minimum!, maximum! + 1);
      }
      return DoubleRange(minimum!, maximum!);
    }

    final DoubleRange range = super.calculateActualRange();
    if (minimum != null) {
      range.minimum = minimum!;
    } else if (maximum != null) {
      range.maximum = maximum!;
    }

    if (range.minimum == range.maximum) {
      range.maximum += 1;
    }

    return range.copyWith();
  }

  @override
  DoubleRange applyRangePadding(
      DoubleRange range, num interval, Size availableSize) {
    if (minimum != null && maximum != null) {
      return range;
    }

    range = super.applyRangePadding(range, interval, availableSize);
    if (minimum != null) {
      range.minimum = minimum!;
    } else if (maximum != null) {
      range.maximum = maximum!;
    }

    return range.copyWith();
  }

  num _visibleStart() {
    if (minimum != null && controller.zoomFactor == 1) {
      return visibleRange!.minimum;
    }

    if (edgeLabelPlacement == EdgeLabelPlacement.shift) {
      return visibleRange!.minimum;
    }

    return visibleRange!.minimum - (visibleRange!.minimum % visibleInterval);
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
    num current = _visibleStart();
    final num visibleMinimum = visibleRange!.minimum;
    final num visibleMaximum = visibleRange!.maximum;
    while (current <= visibleMaximum) {
      if (current < visibleMinimum ||
          !effectiveVisibleRange!.contains(current)) {
        current += visibleInterval;
        continue;
      }

      num currentValue = current;
      final String currentText = currentValue.toString();
      final List<String> pieces = currentText.split('.');
      final int piecesLength = pieces.length;
      int digits = piecesLength >= 2 ? pieces[1].length : 0;
      digits = digits > 20 ? 20 : digits;
      currentValue = currentText.contains('e')
          ? currentValue
          : num.tryParse(currentValue.toStringAsFixed(digits))!;

      String text = numericAxisLabel(this, currentValue, decimalPlaces);
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
  void generateMultiLevelLabels() {
    _multilevelLabels.clear();
    visibleMultilevelLabels.clear();

    // TODO(VijayakumarM): Move multilevelLabels to property setter.
    final int length = multiLevelLabels?.length ?? 0;
    if (length == 0) {
      return;
    }

    for (int i = 0; i < length; i++) {
      final NumericMultiLevelLabel label = multiLevelLabels![i];
      assert(label.start <= label.end);
      _multilevelLabels.add(
          AxisMultilevelLabel(label.text, label.level, label.start, label.end));
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
    for (final AxisMultilevelLabel label in visibleMultilevelLabels) {
      final double start = pointToPixel(label.start);
      final double end = pointToPixel(label.end);
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
  void dispose() {
    _multilevelLabels.clear();
    controller.dispose();
    super.dispose();
  }
}
