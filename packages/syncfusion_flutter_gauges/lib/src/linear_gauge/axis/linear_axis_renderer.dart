import 'dart:math' as math;
import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';

import '../../linear_gauge/axis/linear_axis_label.dart';
import '../../linear_gauge/axis/linear_axis_track_style.dart';
import '../../linear_gauge/gauge/linear_gauge.dart';
import '../../linear_gauge/pointers/linear_shape_renderer.dart';
import '../../linear_gauge/pointers/linear_widget_renderer.dart';
import '../../linear_gauge/range/linear_gauge_range.dart';
import '../../linear_gauge/utils/enum.dart';
import '../../linear_gauge/utils/linear_gauge_helper.dart';
import '../../linear_gauge/utils/linear_gauge_typedef.dart';

/// Represents the renderer of linear axis.
class LinearAxisRenderObjectWidget extends LeafRenderObjectWidget {
  /// Creates the axis render with required properties.
  const LinearAxisRenderObjectWidget(
      {Key? key, required this.linearGauge, this.fadeAnimation})
      : super(key: key);

  /// Holds the linear axis.
  final SfLinearGauge linearGauge;

  ///Axis scale animation.
  final Animation<double>? fadeAnimation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final LinearAxisTrackStyle style = linearGauge.axisTrackStyle;
    final Color? majorTickColor = linearGauge.majorTickStyle.color;
    final Color? minorTickColor = linearGauge.minorTickStyle.color;
    final ThemeData theme = Theme.of(context);
    final SfGaugeThemeData gaugeThemeData = SfGaugeTheme.of(context)!;
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);
    final Color axisLineColor = colorScheme.onSurface[35]!;
    final Color axisBorderColor = colorScheme.onSurface[76]!;
    final Color majorTick = colorScheme.onSurface[61]!;
    final Color minorTick = colorScheme.onSurface[61]!;
    return RenderLinearAxis(
      orientation: linearGauge.orientation,
      showAxisTrack: linearGauge.showAxisTrack,
      thickness: style.thickness,
      color: style.color ?? axisLineColor,
      borderWidth: style.borderWidth,
      borderColor: style.borderColor ?? axisBorderColor,
      gradient: style.gradient,
      edgeStyle: style.edgeStyle,
      minimum: linearGauge.minimum,
      maximum: linearGauge.maximum,
      interval: linearGauge.interval,
      minorTicksPerInterval: linearGauge.minorTicksPerInterval,
      numberFormat: linearGauge.numberFormat,
      labelOffset: linearGauge.labelOffset,
      labelPosition: linearGauge.labelPosition,
      tickPosition: linearGauge.tickPosition,
      tickOffset: linearGauge.tickOffset,
      isMirrored: linearGauge.isMirrored,
      textStyle: theme.textTheme.bodySmall!
          .copyWith(
              color:
                  gaugeThemeData.axisLabelColor ?? colorScheme.onSurface[223])
          .merge(gaugeThemeData.axisLabelTextStyle)
          .merge(linearGauge.axisLabelStyle),
      showLabels: linearGauge.showLabels,
      showTicks: linearGauge.showTicks,
      isAxisInversed: linearGauge.isAxisInversed,
      useRangeColorForAxis: linearGauge.useRangeColorForAxis,
      majorTickLength: linearGauge.majorTickStyle.length,
      majorTickThickness: linearGauge.majorTickStyle.thickness,
      majorTickColor: majorTickColor ?? majorTick,
      minorTickLength: linearGauge.minorTickStyle.length,
      minorTickThickness: linearGauge.minorTickStyle.thickness,
      minorTickColor: minorTickColor ?? minorTick,
      maximumLabels: linearGauge.maximumLabels,
      axisTrackExtent: linearGauge.axisTrackExtent,
      fadeAnimation: fadeAnimation,
      onGenerateLabels: linearGauge.onGenerateLabels,
      ranges: linearGauge.ranges,
      valueToFactorCallback: linearGauge.valueToFactorCallback,
      factorToValueCallback: linearGauge.factorToValueCallback,
      labelFormatterCallback: linearGauge.labelFormatterCallback,
      context: context,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderLinearAxis renderObject) {
    final LinearAxisTrackStyle style = linearGauge.axisTrackStyle;
    final Color? majorTickColor = linearGauge.majorTickStyle.color;
    final Color? minorTickColor = linearGauge.minorTickStyle.color;
    final ThemeData theme = Theme.of(context);
    final SfGaugeThemeData gaugeThemeData = SfGaugeTheme.of(context)!;
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);
    final Color axisLabelColor = colorScheme.onSurface[223]!;
    final Color axisLineColor = colorScheme.onSurface[35]!;
    final Color axisBorderColor = colorScheme.onSurface[76]!;
    final Color majorTick = colorScheme.onSurface[61]!;
    final Color minorTick = colorScheme.onSurface[61]!;
    renderObject
      ..orientation = linearGauge.orientation
      ..showAxisTrack = linearGauge.showAxisTrack
      ..thickness = style.thickness
      ..color = style.color ?? axisLineColor
      ..borderColor = style.borderColor ?? axisBorderColor
      ..borderWidth = style.borderWidth
      ..gradient = style.gradient
      ..edgeStyle = style.edgeStyle
      ..minimum = linearGauge.minimum
      ..maximum = linearGauge.maximum
      ..interval = linearGauge.interval
      ..minorTicksPerInterval = linearGauge.minorTicksPerInterval
      ..numberFormat = linearGauge.numberFormat
      ..labelOffset = linearGauge.labelOffset
      ..labelPosition = linearGauge.labelPosition
      ..tickPosition = linearGauge.tickPosition
      ..majorTickLength = linearGauge.majorTickStyle.length
      ..majorTickThickness = linearGauge.majorTickStyle.thickness
      ..majorTickColor = majorTickColor ?? majorTick
      ..minorTickLength = linearGauge.minorTickStyle.length
      ..minorTickThickness = linearGauge.minorTickStyle.thickness
      ..minorTickColor = minorTickColor ?? minorTick
      ..tickOffset = linearGauge.tickOffset
      ..isMirrored = linearGauge.isMirrored
      ..textStyle = theme.textTheme.bodySmall!
          .copyWith(color: gaugeThemeData.axisLabelColor ?? axisLabelColor)
          .merge(gaugeThemeData.axisLabelTextStyle)
          .merge(linearGauge.axisLabelStyle)
      ..showLabels = linearGauge.showLabels
      ..showTicks = linearGauge.showTicks
      ..useRangeColorForAxis = linearGauge.useRangeColorForAxis
      ..majorTickLength = linearGauge.majorTickStyle.length
      ..isAxisInversed = linearGauge.isAxisInversed
      ..maximumLabels = linearGauge.maximumLabels
      ..axisTrackExtent = linearGauge.axisTrackExtent
      ..onGenerateLabels = linearGauge.onGenerateLabels
      ..valueToFactorCallback = linearGauge.valueToFactorCallback
      ..factorToValueCallback = linearGauge.factorToValueCallback
      ..labelFormatterCallback = linearGauge.labelFormatterCallback
      ..fadeAnimation = fadeAnimation
      ..ranges = linearGauge.ranges;

    super.updateRenderObject(context, renderObject);
  }
}

/// Represents the render object of linear axis.
class RenderLinearAxis extends RenderBox {
  /// Creates a instance for [RenderLinearAxis].
  RenderLinearAxis({
    required LinearGaugeOrientation orientation,
    required bool showAxisTrack,
    required double thickness,
    required Color color,
    required Color borderColor,
    required double borderWidth,
    required LinearEdgeStyle edgeStyle,
    required double minimum,
    required double maximum,
    required int minorTicksPerInterval,
    required NumberFormat? numberFormat,
    required double labelOffset,
    required LinearLabelPosition labelPosition,
    required LinearElementPosition tickPosition,
    required double tickOffset,
    required TextStyle textStyle,
    required bool showLabels,
    required bool showTicks,
    required bool isAxisInversed,
    required bool isMirrored,
    required bool useRangeColorForAxis,
    required int maximumLabels,
    required double majorTickLength,
    required double majorTickThickness,
    required Color majorTickColor,
    required double minorTickLength,
    required double minorTickThickness,
    required Color minorTickColor,
    required double axisTrackExtent,
    Gradient? gradient,
    double? interval,
    Animation<double>? fadeAnimation,
    GenerateLabelsCallback? onGenerateLabels,
    LabelFormatterCallback? labelFormatterCallback,
    ValueToFactorCallback? valueToFactorCallback,
    FactorToValueCallback? factorToValueCallback,
    List<LinearGaugeRange>? ranges,
    required BuildContext context,
  })  : _orientation = orientation,
        _showAxisTrack = showAxisTrack,
        _thickness = thickness,
        _color = color,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _gradient = gradient,
        _edgeStyle = edgeStyle,
        _minimum = minimum,
        _maximum = maximum,
        _interval = interval,
        _minorTicksPerInterval = minorTicksPerInterval,
        _numberFormat = numberFormat,
        _labelOffset = labelOffset,
        _labelPosition = labelPosition,
        _tickPosition = tickPosition,
        _tickOffset = tickOffset,
        _textStyle = textStyle,
        _showLabels = showLabels,
        _isMirrored = isMirrored,
        _majorTickLength = majorTickLength,
        _majorTickThickness = majorTickThickness,
        _majorTickColor = majorTickColor,
        _minorTickLength = minorTickLength,
        _minorTickThickness = minorTickThickness,
        _minorTickColor = minorTickColor,
        _showTicks = showTicks,
        _isAxisInversed = isAxisInversed,
        _maximumLabels = maximumLabels,
        _onGenerateLabels = onGenerateLabels,
        _axisTrackExtent = axisTrackExtent,
        _fadeAnimation = fadeAnimation,
        _labelFormatterCallback = labelFormatterCallback,
        _ranges = ranges,
        _useRangeColorForAxis = useRangeColorForAxis,
        _factorToValueCallback = factorToValueCallback,
        _valueToFactorCallback = valueToFactorCallback {
    _axisPaint = Paint()
      ..color = Theme.of(context).colorScheme.onSurface.withOpacity(0.12);
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _visibleLabels = <LinearAxisLabel>[];
    _isHorizontalOrientation = orientation == LinearGaugeOrientation.horizontal;
    _labelMap = <double?, String?>{};
    _path = Path();
  }

  late Paint _axisPaint;
  late TextPainter _textPainter;
  late double _tickTop, _labelTop;
  late List<LinearAxisLabel> _visibleLabels;
  late Map<double?, String?> _labelMap;
  late Size _axisActualSize, _minLabelSize, _maxLabelSize;
  late bool _isHorizontalOrientation;
  late Path _path;

  Rect _axisLineRect = Rect.zero;

  double _maxLabelHeight = 0;
  double _maxLabelWidth = 0;

  /// Gets the axis Top assigned to [RenderLinearAxis].
  late double axisOffset;

  /// Gets or sets the pointer start padding assigned to [RenderLinearAxis].
  double? pointerStartPadding;

  /// Gets or sets the pointer start padding assigned to [RenderLinearAxis].
  double? pointerEndPadding;

  /// Gets the offset assigned to [RenderLinearAxis].
  double get labelOffset => _labelOffset;
  double _labelOffset;

  /// Sets the offset for [RenderLinearAxis].
  set labelOffset(double value) {
    if (value == _labelOffset) {
      return;
    }
    _labelOffset = value;
    markNeedsLayout();
  }

  /// Gets the useRangeColorForAxis assigned to [RenderLinearAxis].
  bool get useRangeColorForAxis => _useRangeColorForAxis;
  bool _useRangeColorForAxis;

  /// Sets the useRangeForAxis for [RenderLinearAxis].
  set useRangeColorForAxis(bool value) {
    if (value == _useRangeColorForAxis) {
      return;
    }
    _useRangeColorForAxis = value;
    markNeedsPaint();
  }

  /// Gets the generateLabels callback assigned to [RenderLinearAxis].
  GenerateLabelsCallback? get onGenerateLabels => _onGenerateLabels;
  GenerateLabelsCallback? _onGenerateLabels;

  /// Sets the generateLabels callback for [RenderLinearAxis].
  set onGenerateLabels(GenerateLabelsCallback? value) {
    if (value == _onGenerateLabels) {
      return;
    }
    _onGenerateLabels = value;
    markNeedsLayout();
  }

  /// Gets the valueToFactorCallback assigned to [RenderLinearAxis].
  ValueToFactorCallback? get valueToFactorCallback => _valueToFactorCallback;
  ValueToFactorCallback? _valueToFactorCallback;

  /// Sets the valueToFactorCallback for [RenderLinearAxis].
  set valueToFactorCallback(ValueToFactorCallback? value) {
    if (value == _valueToFactorCallback) {
      return;
    }
    _valueToFactorCallback = value;
    markNeedsLayout();
  }

  /// Gets the valueToFactorCallback assigned to [RenderLinearAxis].
  FactorToValueCallback? get factorToValueCallback => _factorToValueCallback;
  FactorToValueCallback? _factorToValueCallback;

  /// Sets the valueToFactorCallback for [RenderLinearAxis].
  set factorToValueCallback(FactorToValueCallback? value) {
    if (value == _factorToValueCallback) {
      return;
    }

    _factorToValueCallback = value;
    markNeedsLayout();
  }

  /// Gets the labelFormatterCallback assigned to [RenderLinearAxis].
  LabelFormatterCallback? get labelFormatterCallback => _labelFormatterCallback;
  LabelFormatterCallback? _labelFormatterCallback;

  /// Sets the labelFormatterCallback for [RenderLinearAxis].
  set labelFormatterCallback(LabelFormatterCallback? value) {
    if (value == _labelFormatterCallback) {
      return;
    }
    _labelFormatterCallback = value;
    markNeedsLayout();
  }

  /// Gets the isAxisInversed assigned to [RenderLinearAxis].
  bool get isAxisInversed => _isAxisInversed;
  bool _isAxisInversed;

  /// Sets the isInverse for [RenderLinearAxis].
  set isAxisInversed(bool value) {
    if (value == _isAxisInversed) {
      return;
    }

    _isAxisInversed = value;
    markNeedsPaint();
  }

  /// Gets the maximum labels assigned to [RenderLinearAxis].
  int get maximumLabels => _maximumLabels;
  int _maximumLabels;

  /// Sets the maximum labels for [RenderLinearAxis].
  set maximumLabels(int value) {
    if (value == _maximumLabels) {
      return;
    }
    _maximumLabels = value;
    markNeedsPaint();
  }

  /// Gets the orientation assigned to [RenderLinearAxis].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  ///
  LinearGaugeOrientation get orientation => _orientation;
  LinearGaugeOrientation _orientation;

  /// Sets the orientation for [RenderLinearAxis].
  ///
  /// Default value is [GaugeOrientation.horizontal].
  set orientation(LinearGaugeOrientation value) {
    if (value == _orientation) {
      return;
    }
    _orientation = value;
    _isHorizontalOrientation = orientation == LinearGaugeOrientation.horizontal;
    markNeedsLayout();
  }

  /// Gets the maximum assigned to [RenderLinearAxis].
  ///
  /// Default value is 100.
  ///
  double get maximum => _maximum;
  double _maximum;

  /// Sets the maximum for [RenderLinearAxis].
  ///
  /// Default value is 100.
  set maximum(double value) {
    if (value == _maximum) {
      return;
    }
    _maximum = value;
    markNeedsLayout();
  }

  /// Gets the minimum assigned to [RenderLinearAxis].
  ///
  /// Default value is 0.
  ///
  double get minimum => _minimum;
  double _minimum;

  /// Sets the minimum for [RenderLinearAxis].
  ///
  /// Default value is 0.
  set minimum(double value) {
    if (value == _minimum) {
      return;
    }
    _minimum = value;
    markNeedsLayout();
  }

  /// Gets the showAxisLine assigned to [RenderLinearAxis].
  bool get showAxisTrack => _showAxisTrack;
  bool _showAxisTrack;

  /// Sets the showAxisLine for [RenderLinearAxis]..
  set showAxisTrack(bool value) {
    if (value == _showAxisTrack) {
      return;
    }
    _showAxisTrack = value;
    markNeedsLayout();
  }

  /// Gets the thickness assigned to [RenderLinearAxis].
  double get thickness => _thickness;
  double _thickness;

  /// Sets the axisLineThickness for [RenderLinearAxis]..
  set thickness(double value) {
    if (value == _thickness) {
      return;
    }
    _thickness = value;
    markNeedsLayout();
  }

  /// Gets the color assigned to [RenderLinearAxis].
  Color get color => _color;
  Color _color;

  /// Sets the color for [RenderLinearAxis]..
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  /// Gets the borderColor assigned to [RenderLinearAxis].
  Color get borderColor => _borderColor;
  Color _borderColor;

  /// Sets the borderColor for [RenderLinearAxis]..
  set borderColor(Color value) {
    if (value == _borderColor) {
      return;
    }
    _borderColor = value;
    markNeedsPaint();
  }

  /// Gets the borderWidth assigned to [RenderLinearAxis].
  double get borderWidth => _borderWidth;
  double _borderWidth;

  /// Sets the borderWidth for [RenderLinearAxis]..
  set borderWidth(double value) {
    if (value == _borderWidth) {
      return;
    }
    _borderWidth = value;
    markNeedsPaint();
  }

  /// Gets the gradient assigned to [RenderLinearAxis].
  Gradient? get gradient => _gradient;
  Gradient? _gradient;

  /// Sets the gradient for [RenderLinearAxis].
  set gradient(Gradient? value) {
    if (value == _gradient) {
      return;
    }
    _gradient = value;
    markNeedsPaint();
  }

  /// Gets the edgeStyle assigned to [RenderLinearAxis].
  LinearEdgeStyle get edgeStyle => _edgeStyle;
  LinearEdgeStyle _edgeStyle;

  /// Sets the edgeStyle for [RenderLinearAxis].
  set edgeStyle(LinearEdgeStyle value) {
    if (value == _edgeStyle) {
      return;
    }
    _edgeStyle = value;
    markNeedsPaint();
  }

  /// Gets the interval assigned to [RenderLinearAxis].
  double? get interval => _interval;
  double? _interval;

  /// Sets the interval for [RenderLinearAxis].
  set interval(double? value) {
    if (value == _interval) {
      return;
    }
    _interval = value;
    markNeedsPaint();
  }

  /// Gets the minorTicksPerInterval assigned to [RenderLinearAxis].
  int get minorTicksPerInterval => _minorTicksPerInterval;
  int _minorTicksPerInterval;

  /// Sets the minorTicksPerInterval for [RenderLinearAxis].
  set minorTicksPerInterval(int value) {
    if (value == _minorTicksPerInterval) {
      return;
    }
    _minorTicksPerInterval = value;
    markNeedsPaint();
  }

  /// Gets the numberFormat assigned to [RenderLinearAxis].
  NumberFormat? get numberFormat => _numberFormat;
  NumberFormat? _numberFormat;

  /// Sets the numberFormat for [RenderLinearAxis].
  set numberFormat(NumberFormat? value) {
    if (_numberFormat == value) {
      return;
    }
    _numberFormat = value;
    markNeedsPaint();
  }

  /// Gets the majorTickLength assigned to [RenderLinearAxis].
  double get majorTickLength => _majorTickLength;
  double _majorTickLength;

  /// Sets the majorTickLength for [RenderLinearAxis].
  set majorTickLength(double value) {
    if (value == _majorTickLength) {
      return;
    }
    _majorTickLength = value;
    markNeedsLayout();
  }

  /// Gets the majorTickThickness assigned to [RenderLinearAxis].
  double get majorTickThickness => _majorTickThickness;
  double _majorTickThickness;

  /// Sets the majorTickThickness for [RenderLinearAxis].
  set majorTickThickness(double value) {
    if (value == _majorTickThickness) {
      return;
    }

    _majorTickThickness = value;
    markNeedsPaint();
  }

  /// Gets the majorTickColor assigned to [RenderLinearAxis].
  Color get majorTickColor => _majorTickColor;
  Color _majorTickColor;

  /// Sets the majorTickColor for [RenderLinearAxis].
  set majorTickColor(Color value) {
    if (value == _majorTickColor) {
      return;
    }
    _majorTickColor = value;
    markNeedsPaint();
  }

  /// Gets the majorTickLength assigned to [RenderLinearAxis].
  double get minorTickLength => _minorTickLength;
  double _minorTickLength;

  /// Sets the majorTickLength for [RenderLinearAxis].
  set minorTickLength(double value) {
    if (value == _minorTickLength) {
      return;
    }
    _minorTickLength = value;
    markNeedsLayout();
  }

  /// Gets the majorTickThickness assigned to [RenderLinearAxis].
  double get minorTickThickness => _minorTickThickness;
  double _minorTickThickness;

  /// Sets the majorTickThickness for [RenderLinearAxis].
  set minorTickThickness(double value) {
    if (value == _minorTickThickness) {
      return;
    }

    _minorTickThickness = value;
    markNeedsPaint();
  }

  /// Gets the majorTickColor assigned to [RenderLinearAxis].
  Color get minorTickColor => _minorTickColor;
  Color _minorTickColor;

  /// Sets the majorTickColor for [RenderLinearAxis].
  set minorTickColor(Color value) {
    if (value == _minorTickColor) {
      return;
    }
    _minorTickColor = value;
    markNeedsPaint();
  }

  /// Gets the textStyle assigned to [RenderLinearAxis].
  TextStyle get textStyle => _textStyle;
  TextStyle _textStyle;

  /// Sets the textStyle for [RenderLinearAxis].
  set textStyle(TextStyle value) {
    if (value == _textStyle) {
      return;
    }
    _textStyle = value;
    markNeedsLayout();
  }

  /// Gets the labelPosition assigned to [RenderLinearAxis].
  LinearLabelPosition get labelPosition => _labelPosition;
  LinearLabelPosition _labelPosition;

  /// Sets the labelPosition for [RenderLinearAxis].
  set labelPosition(LinearLabelPosition value) {
    if (value == _labelPosition) {
      return;
    }
    _labelPosition = value;
    markNeedsLayout();
  }

  /// Gets the tickPosition assigned to [RenderLinearAxis].
  LinearElementPosition get tickPosition => _tickPosition;
  LinearElementPosition _tickPosition;

  /// Sets the tickPosition for [RenderLinearAxis].
  set tickPosition(LinearElementPosition value) {
    if (value == _tickPosition) {
      return;
    }
    _tickPosition = value;
    markNeedsLayout();
  }

  /// Gets the majorTickOffset assigned to [RenderLinearAxis].
  double get tickOffset => _tickOffset;
  double _tickOffset;

  /// Sets the majorTickOffset for [RenderLinearAxis].
  set tickOffset(double value) {
    if (value == _tickOffset) {
      return;
    }

    _tickOffset = value;
    markNeedsLayout();
  }

  /// Gets the showLabels assigned to [RenderLinearAxis].
  bool get showLabels => _showLabels;
  bool _showLabels;

  /// Sets the showLabels for [RenderLinearAxis].
  set showLabels(bool value) {
    if (value == _showLabels) {
      return;
    }
    _showLabels = value;
    markNeedsLayout();
  }

  /// Gets the showTicks assigned to [RenderLinearAxis].
  bool get showTicks => _showTicks;
  bool _showTicks;

  /// Sets the showTicks for [RenderLinearAxis].
  set showTicks(bool value) {
    if (value == _showTicks) {
      return;
    }
    _showTicks = value;
    markNeedsLayout();
  }

  /// Gets the isMirrored assigned to [_RenderLinearGaugeRenderObject].
  bool get isMirrored => _isMirrored;
  bool _isMirrored;

  /// Sets the isMirrored for [_RenderLinearGaugeRenderObject].
  set isMirrored(bool value) {
    if (value == _isMirrored) {
      return;
    }

    _isMirrored = value;
    markNeedsLayout();
  }

  /// Gets the axis extent assigned to [_RenderLinearGaugeRenderObject].
  double get axisTrackExtent => _axisTrackExtent;
  double _axisTrackExtent;

  /// Sets the axis extent for [_RenderLinearGaugeRenderObject].
  set axisTrackExtent(double value) {
    if (value == _axisTrackExtent) {
      return;
    }

    _axisTrackExtent = value;
    markNeedsLayout();
  }

  /// Get the ranges assigned to [_RenderLinearGaugeRenderObject].
  List<LinearGaugeRange>? get ranges => _ranges;
  List<LinearGaugeRange>? _ranges;

  /// Sets the ranges for [_RenderLinearGaugeRenderObject].
  set ranges(List<LinearGaugeRange>? value) {
    if (value == _ranges) {
      return;
    }

    _ranges = value;
    if (useRangeColorForAxis) {
      markNeedsPaint();
    }
  }

  /// Gets the fade animation assigned to [RenderLinearRange].
  Animation<double>? get fadeAnimation => _fadeAnimation;
  Animation<double>? _fadeAnimation;

  /// Gets the fade animation assigned to [RenderLinearRange].
  set fadeAnimation(Animation<double>? value) {
    if (value == _fadeAnimation) {
      return;
    }

    _removeAnimationListener();
    _fadeAnimation = value;
    _addAnimationListener();
  }

  void _addAnimationListener() {
    if (_fadeAnimation != null) {
      _fadeAnimation!.addListener(markNeedsPaint);
    }
  }

  void _removeAnimationListener() {
    if (_fadeAnimation != null) {
      _fadeAnimation!.addListener(markNeedsPaint);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addAnimationListener();
  }

  @override
  void detach() {
    _removeAnimationListener();
    super.detach();
  }

  /// Returns the corresponding range color for the value
  Color? _getRangeColor(double value) {
    Color? color;
    if (ranges != null && ranges!.isNotEmpty) {
      for (int i = 0; i < ranges!.length; i++) {
        if (ranges![i].startValue <= value && ranges![i].endValue >= value) {
          color = ranges![i].color;
          break;
        }
      }
    }

    return color;
  }

  /// Returns the measured the label size.
  Size _measureLabelSize(double? value) {
    final String? label = _labelMap[value];
    final TextSpan textSpan = TextSpan(
      text: label,
      style: textStyle,
    );

    _textPainter.text = textSpan;
    _textPainter.layout();

    return Size(_textPainter.width, _textPainter.height);
  }

  /// Returns the tick size.
  double getTickSize() =>
      showTicks ? (math.max(majorTickLength, minorTickLength) + tickOffset) : 0;

  /// Returns the axis line size.
  double getAxisLineThickness() => showAxisTrack ? thickness : 0;

  /// Returns the label size.
  double getEffectiveLabelSize() {
    _maxLabelHeight = 0;
    _maxLabelWidth = 0;

    if (showLabels) {
      for (final LinearAxisLabel element in _visibleLabels) {
        final Size labelSize = _measureLabelSize(element.value);
        _maxLabelHeight = math.max(_maxLabelHeight, labelSize.height);
        _maxLabelWidth = math.max(_maxLabelWidth, labelSize.width);
      }

      return (_isHorizontalOrientation ? _maxLabelHeight : _maxLabelWidth) +
          labelOffset;
    }

    return 0;
  }

  /// Measures the axis element size.
  double _measureAxisSize() {
    // ignore: no_leading_underscores_for_local_identifiers
    late double _axisWidgetThickness;
    final double tickMarginSize = showTicks ? tickOffset : 0;
    final double labelSize = getEffectiveLabelSize();
    final double tickSize = getTickSize() - tickMarginSize;
    final double axisSize = getAxisLineThickness();
    final LinearElementPosition position =
        getEffectiveElementPosition(tickPosition, isMirrored);
    final LinearLabelPosition labelPlacement =
        getEffectiveLabelPosition(labelPosition, isMirrored);

    switch (position) {
      case LinearElementPosition.inside:
        if (labelPlacement == LinearLabelPosition.inside) {
          _axisWidgetThickness = axisSize + tickSize + labelSize;

          if (tickMarginSize > labelSize) {
            _axisWidgetThickness += tickMarginSize - labelSize;
          }
        } else {
          _axisWidgetThickness =
              axisSize + tickSize + labelSize + tickMarginSize;
        }
        break;
      case LinearElementPosition.outside:
        if (labelPlacement == LinearLabelPosition.inside) {
          _axisWidgetThickness =
              axisSize + tickSize + labelSize + tickMarginSize;
        } else {
          _axisWidgetThickness = axisSize + tickSize + labelSize;

          if (tickMarginSize > labelSize) {
            _axisWidgetThickness += tickMarginSize - labelSize;
          }
        }
        break;
      case LinearElementPosition.cross:
        _axisWidgetThickness = axisSize +
            ((axisSize < tickSize) ? tickSize - axisSize : 0.0) +
            labelSize;
        break;
      // ignore: no_default_cases
      default:
        break;
    }

    return _axisWidgetThickness;
  }

  /// Calculates the axis elements position.
  void _calculateAxisElementPositions() {
    final double tickMarginSize = showTicks ? tickOffset : 0;
    final double labelMarginSize = showLabels ? labelOffset : 0;
    final double tickSize = getTickSize() - tickMarginSize;
    final double labelSize = getEffectiveLabelSize() - labelMarginSize;
    final double axisSize = getAxisLineThickness();
    final LinearElementPosition position =
        getEffectiveElementPosition(tickPosition, isMirrored);
    final LinearLabelPosition labelPlacement =
        getEffectiveLabelPosition(labelPosition, isMirrored);

    switch (position) {
      case LinearElementPosition.inside:
        switch (labelPlacement) {
          case LinearLabelPosition.inside:
            axisOffset = 0;
            _tickTop = showTicks ? axisSize + tickMarginSize : 0;
            _labelTop =
                showLabels ? (axisSize + tickSize + labelMarginSize) : 0;
            break;
          case LinearLabelPosition.outside:
            _labelTop = 0;
            axisOffset = showAxisTrack ? labelSize + labelMarginSize : 0;
            _tickTop = showTicks
                ? labelSize + labelMarginSize + axisSize + tickMarginSize
                : 0;
            break;
          // ignore: no_default_cases
          default:
            break;
        }
        break;
      case LinearElementPosition.outside:
        switch (labelPlacement) {
          case LinearLabelPosition.inside:
            _tickTop = 0;
            axisOffset = showAxisTrack ? tickSize + tickMarginSize : 0;
            _labelTop = showLabels
                ? axisSize + tickSize + labelMarginSize + tickMarginSize
                : 0;
            break;
          case LinearLabelPosition.outside:
            _labelTop = 0;
            _tickTop =
                showTicks ? (labelSize + labelMarginSize - tickMarginSize) : 0;
            axisOffset =
                showAxisTrack ? (labelSize + tickSize + labelMarginSize) : 0;

            if (tickMarginSize > labelSize + labelMarginSize) {
              _labelTop = tickMarginSize - (labelSize + labelMarginSize);
              _tickTop = 0;
              axisOffset += tickMarginSize - (labelSize + labelMarginSize);
            }
            break;
          // ignore: no_default_cases
          default:
            break;
        }
        break;
      case LinearElementPosition.cross:
        switch (labelPlacement) {
          case LinearLabelPosition.inside:
            if (axisSize < tickSize && tickSize > 0) {
              _tickTop = 0;
              axisOffset = showAxisTrack ? (tickSize - axisSize) / 2 : 0;
              _labelTop = showLabels
                  ? (axisSize + (tickSize - axisSize) + labelMarginSize)
                  : 0;
            } else if (axisSize > tickSize && tickSize > 0) {
              axisOffset = 0;
              _tickTop = showTicks ? (axisSize - tickSize) / 2 : 0;
              _labelTop = showLabels ? axisSize + labelMarginSize : 0;
            } else {
              axisOffset = 0;
              _tickTop = 0;
              _labelTop = showLabels ? axisSize + labelMarginSize : 0;
            }
            break;
          case LinearLabelPosition.outside:
            if (axisSize < tickSize && tickSize > 0) {
              _labelTop = 0;
              _tickTop = showTicks ? labelSize + labelMarginSize : 0;
              axisOffset = showAxisTrack
                  ? labelSize + labelMarginSize + (tickSize - axisSize) / 2
                  : 0;
            } else if (axisSize > tickSize && tickSize > 0) {
              _labelTop = 0;
              axisOffset = showAxisTrack ? labelSize + labelMarginSize : 0;
              _tickTop = showTicks
                  ? labelSize + labelMarginSize + (axisSize - tickSize) / 2
                  : 0;
            } else {
              _labelTop = 0;
              axisOffset = showAxisTrack ? labelSize + labelMarginSize : 0;
              _tickTop = showTicks ? labelSize + labelMarginSize : 0;
            }
            break;
          // ignore: no_default_cases
          default:
            break;
        }
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }

  double _getStartLabelPadding() {
    if (showLabels) {
      if (_isHorizontalOrientation) {
        return isAxisInversed
            ? _maxLabelSize.width / 2
            : _minLabelSize.width / 2;
      } else {
        return isAxisInversed
            ? _maxLabelSize.height / 2
            : _minLabelSize.height / 2;
      }
    } else {
      return 0;
    }
  }

  double _getEndLabelPadding() {
    if (showLabels) {
      if (_isHorizontalOrientation) {
        return isAxisInversed
            ? _minLabelSize.width / 2
            : _maxLabelSize.width / 2;
      } else {
        return isAxisInversed
            ? _minLabelSize.height / 2
            : _maxLabelSize.height / 2;
      }
    } else {
      return 0;
    }
  }

  /// Return the axis layout padding.
  double getAxisLayoutPadding() {
    double layoutStartPadding = 0;
    double layoutEndPadding = 0;

    final double labelStartPadding = _getStartLabelPadding();
    final double labelEndPadding = _getEndLabelPadding();

    if (axisTrackExtent == 0) {
      if (pointerStartPadding! > labelStartPadding) {
        layoutStartPadding = pointerStartPadding! - labelStartPadding;
      }

      if (pointerEndPadding! > labelEndPadding) {
        layoutEndPadding = pointerEndPadding! - labelEndPadding;
      }
    } else {
      layoutStartPadding = 0;
      layoutEndPadding = 0;

      /// Measure the layout start padding based on axis track extent.
      if (pointerStartPadding! > axisTrackExtent) {
        layoutStartPadding = pointerStartPadding! - axisTrackExtent;

        if (labelStartPadding > axisTrackExtent) {
          layoutStartPadding -= labelStartPadding - axisTrackExtent;
        }
      }

      if (pointerStartPadding! < labelStartPadding) {
        layoutStartPadding = 0;
      }

      /// Measure the layout end padding based on axis track extent.
      if (pointerEndPadding! > axisTrackExtent) {
        layoutEndPadding = pointerEndPadding! - axisTrackExtent;

        if (labelEndPadding > axisTrackExtent) {
          layoutEndPadding -= labelEndPadding - axisTrackExtent;
        }
      }

      if (pointerEndPadding! < labelEndPadding) {
        layoutEndPadding = 0;
      }
    }

    return layoutStartPadding + layoutEndPadding;
  }

  /// Return the axis position padding.
  double getAxisPositionPadding() {
    final double axisStartPadding = _getStartLabelPadding();
    double padding = 0;

    if (axisTrackExtent == 0) {
      if (pointerStartPadding! > axisStartPadding) {
        padding = pointerStartPadding! - _getStartLabelPadding();
      }
    } else {
      if (pointerStartPadding! < axisTrackExtent) {
        padding = 0;
      } else if (axisTrackExtent <= pointerStartPadding!) {
        padding = pointerStartPadding! - axisTrackExtent;

        if (axisStartPadding > axisTrackExtent) {
          padding -= axisStartPadding - axisTrackExtent;
        }
      }

      if (pointerStartPadding! < axisStartPadding) {
        padding = 0;
      }
    }

    return padding;
  }

  /// Get the child padding for positioning.
  double getChildPadding({dynamic child}) {
    double paddingSize = math.max(
        math.max(axisTrackExtent, pointerStartPadding!),
        _getStartLabelPadding());

    if (child != null &&
        (child is RenderLinearWidgetPointer ||
            child is RenderLinearShapePointer)) {
      final double childSize = _isHorizontalOrientation
          ? child.size.width as double
          : child.size.height as double;

      if (child.markerAlignment == LinearMarkerAlignment.start) {
        return paddingSize;
      } else if (child.markerAlignment == LinearMarkerAlignment.center) {
        return paddingSize -= childSize / 2;
      } else {
        return paddingSize -= childSize;
      }
    }

    return paddingSize;
  }

  /// Calculates the visible labels based on interval and range.
  void _generateVisibleLabels(Size size) {
    _visibleLabels.clear();
    if (onGenerateLabels == null) {
      final double actualInterval = interval ?? _calculateAxisInterval(size);

      if (actualInterval != 0 && minimum != maximum) {
        for (double i = minimum; i <= maximum; i += actualInterval) {
          final LinearAxisLabel currentLabel = _getAxisLabel(i);
          _visibleLabels.add(currentLabel);
        }

        final LinearAxisLabel label = _visibleLabels[_visibleLabels.length - 1];
        if (label.value != maximum && label.value < maximum) {
          final LinearAxisLabel currentLabel = _getAxisLabel(maximum);
          _visibleLabels.add(currentLabel);
        }
      }
    } else {
      _visibleLabels = onGenerateLabels!();
    }

    _labelMap.clear();
    for (final LinearAxisLabel element in _visibleLabels) {
      _labelMap[element.value] = element.text;
    }
  }

  LinearAxisLabel _getAxisLabel(double value) {
    String labelText = value.toString();

    if (numberFormat != null) {
      labelText = numberFormat!.format(value);
    }

    if (labelFormatterCallback != null) {
      labelText = labelFormatterCallback!(labelText);
    }

    return LinearAxisLabel(value: value, text: labelText);
  }

  /// Generates the labels based on area.
  void generateLabels(BoxConstraints constraints) {
    final double actualParentWidth = constraints.maxWidth;
    final double actualParentHeight = constraints.maxHeight;

    /// Creates the axis labels.
    _generateVisibleLabels(Size(actualParentWidth, actualParentHeight));

    _minLabelSize = _measureLabelSize(minimum);
    _maxLabelSize = _measureLabelSize(maximum);
  }

  @override
  void performLayout() {
    double parentWidgetSize;

    final double actualParentWidth = constraints.maxWidth;
    final double actualParentHeight = constraints.maxHeight;

    if (_isHorizontalOrientation) {
      parentWidgetSize = actualParentWidth;
    } else {
      parentWidgetSize = actualParentHeight;
    }

    final double axisWidgetThickness = _measureAxisSize();

    /// Calculates the axis, tick and label elements top position.
    ///
    /// Depending on the axis top value, the location of the range and pointer
    /// elements will be changed.
    _calculateAxisElementPositions();

    if (_isHorizontalOrientation) {
      _axisActualSize = Size(parentWidgetSize, axisWidgetThickness);
    } else {
      _axisActualSize = Size(axisWidgetThickness, parentWidgetSize);
    }

    size = _axisActualSize;
  }

  /// To calculate the axis interval based on the maximum axis label count.
  double _calculateAxisInterval(Size size) {
    final double delta = (maximum - minimum).abs();
    final double area = _isHorizontalOrientation ? size.width : size.height;
    final double actualDesiredIntervalsCount =
        math.max((area * maximumLabels) / 100, 1.0);
    double niceInterval = delta / actualDesiredIntervalsCount;
    final num minInterval =
        math.pow(10, (math.log(niceInterval) / math.log(10)).floor());
    final List<double> intervalDivisions = <double>[10, 5, 2, 1];
    for (final double intervalDivision in intervalDivisions) {
      final double currentInterval = minInterval * intervalDivision;
      if (actualDesiredIntervalsCount < (delta / currentInterval)) {
        break;
      }

      niceInterval = currentInterval;
    }

    return niceInterval;
  }

  ///Converts the value to factor.
  double valueToFactor(double value, {bool isTickPositionCalculation = false}) {
    if (value > maximum) {
      value = maximum;
    } else if (value < minimum) {
      value = minimum;
    }

    double factor;
    if (valueToFactorCallback != null && !isTickPositionCalculation) {
      factor = valueToFactorCallback!(value);
    } else {
      factor = (value - minimum) / (maximum - minimum);
    }

    if (_isHorizontalOrientation) {
      factor = isAxisInversed ? 1 - factor : factor;
    } else {
      factor = !isAxisInversed ? 1 - factor : factor;
    }

    return factor;
  }

  ///Converts the factor to value.
  double factorToValue(double factor) {
    if (_isHorizontalOrientation) {
      factor = isAxisInversed ? 1 - factor : factor;
    } else {
      factor = !isAxisInversed ? 1 - factor : factor;
    }

    if (factorToValueCallback != null) {
      return factorToValueCallback!(factor);
    } else {
      return (factor * (maximum - minimum)) + minimum;
    }
  }

  /// Returns the pixel position based on value.
  double valueToPixel(double value, {bool isTickPositionCalculation = false}) {
    final double factor = valueToFactor(value,
        isTickPositionCalculation: isTickPositionCalculation);

    double? labelStartPadding = _getStartLabelPadding();
    double? labelEndPadding = _getEndLabelPadding();

    if (axisTrackExtent > 0) {
      if (axisTrackExtent >= labelStartPadding) {
        labelStartPadding = axisTrackExtent;
      }

      if (axisTrackExtent >= labelEndPadding) {
        labelEndPadding = axisTrackExtent;
      }
    }

    return factor *
        ((_isHorizontalOrientation
                ? _axisActualSize.width
                : _axisActualSize.height) -
            (labelStartPadding + labelEndPadding));
  }

  void _drawTickLine(double x1, double y1, double x2, double y2, Canvas canvas,
      bool isMajorTick) {
    final Offset majorTickStartOffset = Offset(x1, y1);
    final Offset majorTickEndOffset = Offset(x2, y2);
    canvas.drawLine(majorTickStartOffset, majorTickEndOffset, _axisPaint);
  }

  double? _getMinorTickGap(int index) {
    double endValuePosition;
    if (_visibleLabels.length - 1 == index) {
      return null;
    } else {
      endValuePosition = valueToPixel(_visibleLabels[index + 1].value,
          isTickPositionCalculation: true);
    }

    final double width = (endValuePosition -
                valueToPixel(_visibleLabels[index].value,
                    isTickPositionCalculation: true))
            .abs() /
        (minorTicksPerInterval + 1);

    if (_isHorizontalOrientation) {
      return width * (isAxisInversed ? -1 : 1);
    } else {
      return width * (isAxisInversed ? 1 : -1);
    }
  }

  double? _getMinorTickValueGap(int index) {
    if (_visibleLabels.length - 1 == index) {
      return null;
    } else {
      return (_visibleLabels[index + 1].value - _visibleLabels[index].value) /
          minorTicksPerInterval;
    }
  }

  void _setPaintColor(Color paintColor) {
    double animationValue = 1;
    if (_fadeAnimation != null) {
      animationValue = _fadeAnimation!.value;
    }

    _axisPaint.color =
        paintColor.withOpacity(animationValue * paintColor.opacity);
  }

  ///Draws minor tick elements.
  void _drawMinorTicks(double minorTickLeftPosition, double top,
      int majorTickIndex, Canvas canvas) {
    final LinearElementPosition position =
        getEffectiveElementPosition(tickPosition, isMirrored);

    if (_isHorizontalOrientation) {
      if (position == LinearElementPosition.outside) {
        top = top + majorTickLength - minorTickLength;
      } else if (position == LinearElementPosition.cross) {
        top = top + (majorTickLength - minorTickLength) / 2;
      }
    } else {
      if (position == LinearElementPosition.outside) {
        minorTickLeftPosition =
            minorTickLeftPosition + majorTickLength - minorTickLength;
      } else if (position == LinearElementPosition.cross) {
        minorTickLeftPosition =
            minorTickLeftPosition + (majorTickLength - minorTickLength) / 2;
      }
    }

    final double? minorTickGap = _getMinorTickGap(majorTickIndex);
    final double? valueGap = _getMinorTickValueGap(majorTickIndex);

    if (minorTickGap != null) {
      for (int minorTickIndex = 1;
          minorTickIndex <= minorTicksPerInterval;
          minorTickIndex++) {
        if (_isHorizontalOrientation) {
          minorTickLeftPosition += minorTickGap;
        } else {
          top += minorTickGap;
        }

        _setPaintColor(useRangeColorForAxis
            ? _getRangeColor(_visibleLabels[majorTickIndex].value +
                    (valueGap! * minorTickIndex)) ??
                minorTickColor
            : minorTickColor);

        _axisPaint.strokeWidth = minorTickThickness;

        _drawTickLine(
            minorTickLeftPosition,
            top,
            minorTickLeftPosition +
                (!_isHorizontalOrientation ? minorTickLength : 0),
            top + (_isHorizontalOrientation ? minorTickLength : 0),
            canvas,
            false);
      }
    }
  }

  /// The style information for text runs, encoded for use by `dart:ui`.
  dart_ui.TextStyle _getTextStyle(
      {double textScaleFactor = 1.0, required TextStyle style, Color? color}) {
    double animationValue = 1;

    if (_fadeAnimation != null) {
      animationValue = _fadeAnimation!.value;
    }

    if (color != null) {
      color = color.withOpacity(animationValue * color.opacity);
    }

    return dart_ui.TextStyle(
      color: color,
      decoration: style.decoration,
      decorationColor: style.decorationColor,
      decorationStyle: style.decorationStyle,
      decorationThickness: style.decorationThickness,
      fontWeight: style.fontWeight,
      fontStyle: style.fontStyle,
      textBaseline: style.textBaseline,
      fontFamily: style.fontFamily,
      fontFamilyFallback: style.fontFamilyFallback,
      fontSize:
          style.fontSize == null ? null : style.fontSize! * textScaleFactor,
      letterSpacing: style.letterSpacing,
      wordSpacing: style.wordSpacing,
      height: style.height,
      locale: style.locale,
      foreground: style.foreground,
      background: style.background ??
          (style.backgroundColor != null
              ? (Paint()..color = style.backgroundColor!)
              : null),
      shadows: style.shadows,
      fontFeatures: style.fontFeatures,
    );
  }

  ///Draws axis label elements.
  void _drawLabels(Canvas canvas, int majorTickIndex,
      double majorTickLeftPosition, double top) {
    final dart_ui.ParagraphStyle paragraphStyle = dart_ui.ParagraphStyle(
        textDirection: TextDirection.ltr, textAlign: TextAlign.left);
    final String labelText = _labelMap[_visibleLabels[majorTickIndex].value]!;
    final double value = _visibleLabels[majorTickIndex].value;
    final dart_ui.TextStyle labelTextStyle = _getTextStyle(
        style: textStyle,
        color: useRangeColorForAxis
            ? _getRangeColor(_visibleLabels[majorTickIndex].value) ??
                textStyle.color
            : textStyle.color);
    final dart_ui.ParagraphBuilder paragraphBuilder =
        dart_ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(labelTextStyle)
          ..addText(labelText);
    final dart_ui.Paragraph paragraph = paragraphBuilder.build();
    final Size labelSize = _measureLabelSize(value);
    paragraph.layout(dart_ui.ParagraphConstraints(width: labelSize.width));

    Offset labelOffset;

    if (_isHorizontalOrientation) {
      final double labelLeftPosition =
          majorTickLeftPosition - (labelSize.width / 2);
      labelOffset = Offset(labelLeftPosition, _labelTop);
    } else {
      final double labelLeftPosition = top - (labelSize.height / 2);

      if (_labelTop == 0 && _maxLabelWidth > labelSize.width) {
        labelOffset =
            Offset(_maxLabelWidth - labelSize.width, labelLeftPosition);
      } else {
        labelOffset = Offset(_labelTop, labelLeftPosition);
      }
    }

    canvas.drawParagraph(paragraph, labelOffset);
  }

  /// Draws the axis line.
  void _drawAxisLine(Canvas canvas, Offset offset) {
    double startLabelPadding = _getStartLabelPadding();
    double endLabelPadding = _getEndLabelPadding();

    if (startLabelPadding > axisTrackExtent) {
      startLabelPadding = startLabelPadding - axisTrackExtent;
    } else {
      startLabelPadding = 0;
    }

    if (endLabelPadding > axisTrackExtent) {
      endLabelPadding = endLabelPadding - axisTrackExtent;
    } else {
      endLabelPadding = 0;
    }

    if (_isHorizontalOrientation) {
      _axisLineRect = Rect.fromLTWH(
          offset.dx + startLabelPadding,
          offset.dy + axisOffset,
          size.width - (startLabelPadding + endLabelPadding),
          thickness);
    } else {
      _axisLineRect = Rect.fromLTWH(
          offset.dx + axisOffset,
          offset.dy + startLabelPadding,
          thickness,
          size.height - (startLabelPadding + endLabelPadding));
    }

    _axisLineRect = Rect.fromLTWH(
        _axisLineRect.left + borderWidth / 2,
        _axisLineRect.top + borderWidth / 2,
        _axisLineRect.width - borderWidth,
        _axisLineRect.height - borderWidth);

    if (showAxisTrack) {
      _axisPaint.style = PaintingStyle.fill;
      _setPaintColor(color);

      if (gradient != null) {
        _axisPaint.shader = gradient!.createShader(_axisLineRect);
      }

      _path.reset();
      switch (edgeStyle) {
        case LinearEdgeStyle.bothFlat:
          _path.addRect(_axisLineRect);
          break;
        case LinearEdgeStyle.bothCurve:
          _path.addRRect(RRect.fromRectAndRadius(
              _axisLineRect, Radius.circular(thickness)));
          break;
        case LinearEdgeStyle.startCurve:
          _path.addRRect(getStartCurve(
              isHorizontal: _isHorizontalOrientation,
              isAxisInversed: isAxisInversed,
              rect: _axisLineRect,
              radius: thickness / 2));
          break;
        case LinearEdgeStyle.endCurve:
          _path.addRRect(getEndCurve(
              isHorizontal: _isHorizontalOrientation,
              isAxisInversed: isAxisInversed,
              rect: _axisLineRect,
              radius: thickness / 2));
          break;
        // ignore: no_default_cases
        default:
          break;
      }

      canvas.drawPath(_path, _axisPaint);

      if (borderWidth > 0) {
        _axisPaint.shader = null;
        _axisPaint.style = PaintingStyle.stroke;
        _axisPaint.strokeWidth = borderWidth;
        _setPaintColor(borderColor);
        canvas.drawPath(_path, _axisPaint);
      }
    }
  }

  void _drawTicksAndLabels(Canvas canvas, Offset offset) {
    final double majorTickLeftPosition =
        math.max(_getStartLabelPadding(), axisTrackExtent);

    Offset tickStartPoint, tickEndPoint;

    for (int index = 0; index < _visibleLabels.length; index++) {
      _axisPaint.shader = null;
      _setPaintColor(useRangeColorForAxis
          ? _getRangeColor(_visibleLabels[index].value) ?? majorTickColor
          : majorTickColor);
      _axisPaint.strokeWidth = majorTickThickness;
      final double calculatedPosition = valueToPixel(
              _visibleLabels[index].value,
              isTickPositionCalculation: true) +
          majorTickLeftPosition;

      tickStartPoint = Offset(calculatedPosition, _tickTop);
      tickEndPoint = Offset(calculatedPosition, _tickTop + majorTickLength);

      if (orientation == LinearGaugeOrientation.vertical) {
        tickStartPoint = Offset(tickStartPoint.dy, tickStartPoint.dx);
        tickEndPoint = Offset(tickEndPoint.dy, tickEndPoint.dx);
      }

      if (showTicks) {
        /// Drawing the major ticks.
        _drawTickLine(tickStartPoint.dx, tickStartPoint.dy, tickEndPoint.dx,
            tickEndPoint.dy, canvas, true);
        _drawMinorTicks(tickStartPoint.dx, tickStartPoint.dy, index, canvas);
      }

      if (showLabels) {
        _drawLabels(canvas, index, tickStartPoint.dx, tickStartPoint.dy);
      }
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _drawAxisLine(canvas, offset);

    if (showTicks || showLabels) {
      _drawTicksAndLabels(canvas, offset);
    }
  }
}
