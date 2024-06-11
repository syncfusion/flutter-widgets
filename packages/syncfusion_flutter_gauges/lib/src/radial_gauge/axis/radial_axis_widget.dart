import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as init;
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis.dart';
import '../../radial_gauge/axis/radial_axis_label.dart';
import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/pointers/range_pointer_renderer.dart';
import '../../radial_gauge/range/gauge_range.dart';
import '../../radial_gauge/renderers/radial_axis_renderer.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';
import '../styles/radial_tick_style.dart';

/// Radial Axis widget.
class RadialAxisRenderObjectWidget extends LeafRenderObjectWidget {
  ///Creates a object for [RadialAxisWidget].
  const RadialAxisRenderObjectWidget({required this.axis});

  /// Radial axis widget.
  final RadialAxis axis;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final RadialAxisScope radialGaugeScope = RadialAxisScope.of(context);
    final AxisLineStyle axisLineStyle = axis.axisLineStyle;
    final MajorTickStyle majorTickStyle = axis.majorTickStyle;
    final MinorTickStyle minorTickStyle = axis.minorTickStyle;
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final ThemeData themeData = Theme.of(context);
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);

    RadialAxisRenderer? renderer;

    if (axis.onCreateAxisRenderer != null) {
      renderer = axis.onCreateAxisRenderer!() as RadialAxisRenderer?;
      renderer!.axis = axis;
    }

    return RenderRadialAxisWidget(
        startAngle: axis.startAngle,
        endAngle: axis.endAngle,
        radiusFactor: axis.radiusFactor,
        centerX: axis.centerX,
        centerY: axis.centerY,
        canRotateLabels: axis.canRotateLabels,
        canScaleToFit: axis.canScaleToFit,
        showFirstLabel: axis.showFirstLabel,
        showLastLabel: axis.showLastLabel,
        onLabelCreated: axis.onLabelCreated,
        onAxisTapped: axis.onAxisTapped,
        minimum: axis.minimum,
        maximum: axis.maximum,
        interval: axis.interval,
        isInversed: axis.isInversed,
        minorTicksPerInterval: axis.minorTicksPerInterval,
        showAxisLine: axis.showAxisLine,
        showLabels: axis.showLabels,
        showTicks: axis.showTicks,
        tickOffset: axis.tickOffset,
        numberFormat: axis.numberFormat,
        labelFormat: axis.labelFormat,
        maximumLabels: axis.maximumLabels,
        labelOffset: axis.labelOffset,
        useRangeColorForAxis: axis.useRangeColorForAxis,
        labelPosition: axis.labelsPosition,
        tickPosition: axis.ticksPosition,
        offsetUnit: axis.offsetUnit,
        thickness: axisLineStyle.thickness,
        thicknessUnit: axisLineStyle.thicknessUnit,
        axisLineColor: axisLineStyle.color,
        axisLineGradient: axisLineStyle.gradient,
        axisLineCornerStyle: axisLineStyle.cornerStyle,
        axisLineDashArray: axisLineStyle.dashArray,
        gaugeTextStyle: axis.axisLabelStyle,
        majorTickLength: majorTickStyle.length,
        majorTickThickness: majorTickStyle.thickness,
        majorTickLengthUnit: majorTickStyle.lengthUnit,
        majorTickColor: majorTickStyle.color,
        majorTickDashArray: majorTickStyle.dashArray,
        minorTickLength: minorTickStyle.length,
        minorTickThickness: minorTickStyle.thickness,
        minorTickLengthUnit: minorTickStyle.lengthUnit,
        minorTickColor: minorTickStyle.color,
        minorTickDashArray: minorTickStyle.dashArray,
        axisLineAnimation: radialGaugeScope.animation,
        axisElementsAnimation: radialGaugeScope.animation1,
        repaintNotifier: radialGaugeScope.repaintNotifier,
        gaugeThemeData: gaugeTheme,
        themeData: themeData,
        colorScheme: colorScheme,
        ranges: axis.ranges,
        renderer: renderer,
        backgroundImage: axis.backgroundImage,
        imageStream: axis.backgroundImage
            ?.resolve(createLocalImageConfiguration(context)));
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderRadialAxisWidget renderObject) {
    final RadialAxisScope radialGaugeScope = RadialAxisScope.of(context);
    final AxisLineStyle axisLineStyle = axis.axisLineStyle;
    final MajorTickStyle majorTickStyle = axis.majorTickStyle;
    final MinorTickStyle minorTickStyle = axis.minorTickStyle;
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final ThemeData themeData = Theme.of(context);
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);

    RadialAxisRenderer? renderer;

    if (axis.onCreateAxisRenderer != null) {
      renderer = axis.onCreateAxisRenderer!() as RadialAxisRenderer?;
      renderer!.axis = axis;
    }

    renderObject
      ..startAngle = axis.startAngle
      ..endAngle = axis.endAngle
      ..radiusFactor = axis.radiusFactor
      ..centerX = axis.centerX
      ..centerY = axis.centerY
      ..canRotateLabels = axis.canRotateLabels
      ..canScaleToFit = axis.canScaleToFit
      ..showFirstLabel = axis.showFirstLabel
      ..showLastLabel = axis.showLastLabel
      ..onLabelCreated = axis.onLabelCreated
      ..onAxisTapped = axis.onAxisTapped
      ..minimum = axis.minimum
      ..maximum = axis.maximum
      ..interval = axis.interval
      ..isInversed = axis.isInversed
      ..minorTicksPerInterval = axis.minorTicksPerInterval
      ..showAxisLine = axis.showAxisLine
      ..showLabels = axis.showLabels
      ..showTicks = axis.showTicks
      ..tickOffset = axis.tickOffset
      ..numberFormat = axis.numberFormat
      ..labelFormat = axis.labelFormat
      ..maximumLabels = axis.maximumLabels
      ..labelOffset = axis.labelOffset
      ..useRangeColorForAxis = axis.useRangeColorForAxis
      ..labelPosition = axis.labelsPosition
      ..tickPosition = axis.ticksPosition
      ..offsetUnit = axis.offsetUnit
      ..thickness = axisLineStyle.thickness
      ..thicknessUnit = axisLineStyle.thicknessUnit
      ..axisLineColor = axisLineStyle.color
      ..axisLineGradient = axisLineStyle.gradient
      ..axisLineCornerStyle = axisLineStyle.cornerStyle
      ..axisLineDashArray = axisLineStyle.dashArray
      ..gaugeTextStyle = axis.axisLabelStyle
      ..majorTickLength = majorTickStyle.length
      ..majorTickThickness = majorTickStyle.thickness
      ..majorTickLengthUnit = majorTickStyle.lengthUnit
      ..majorTickColor = majorTickStyle.color
      ..majorTickDashArray = majorTickStyle.dashArray
      ..minorTickLength = minorTickStyle.length
      ..minorTickThickness = minorTickStyle.thickness
      ..minorTickLengthUnit = minorTickStyle.lengthUnit
      ..minorTickColor = minorTickStyle.color
      ..minorTickDashArray = minorTickStyle.dashArray
      ..ranges = axis.ranges
      ..axisLineAnimation = radialGaugeScope.animation
      ..axisElementsAnimation = radialGaugeScope.animation1
      ..gaugeThemeData = gaugeTheme
      ..themeData = themeData
      ..colorScheme = colorScheme
      ..renderer = renderer
      ..imageStream =
          axis.backgroundImage?.resolve(createLocalImageConfiguration(context))
      ..backgroundImage = axis.backgroundImage;
    super.updateRenderObject(context, renderObject);
  }
}

//// Represents the renderer of radial gauge axis element.
class RenderRadialAxisWidget extends RenderBox {
  /// Creates a object for [RenderRadialAxis].
  RenderRadialAxisWidget(
      {required double startAngle,
      required double endAngle,
      required double radiusFactor,
      required double centerX,
      required double centerY,
      required bool canRotateLabels,
      required bool canScaleToFit,
      required bool showFirstLabel,
      required bool showLastLabel,
      ValueChanged<AxisLabelCreatedArgs>? onLabelCreated,
      ValueChanged<double>? onAxisTapped,
      required double minimum,
      required double maximum,
      double? interval,
      required bool isInversed,
      required double minorTicksPerInterval,
      required bool showAxisLine,
      required bool showLabels,
      required bool showTicks,
      required double tickOffset,
      init.NumberFormat? numberFormat,
      String? labelFormat,
      required int maximumLabels,
      required double labelOffset,
      required bool useRangeColorForAxis,
      required ElementsPosition labelPosition,
      required ElementsPosition tickPosition,
      required GaugeSizeUnit offsetUnit,
      required double thickness,
      required GaugeSizeUnit thicknessUnit,
      Color? axisLineColor,
      Gradient? axisLineGradient,
      required CornerStyle axisLineCornerStyle,
      List<double>? axisLineDashArray,
      required GaugeTextStyle gaugeTextStyle,
      required double majorTickLength,
      required double majorTickThickness,
      required GaugeSizeUnit majorTickLengthUnit,
      Color? majorTickColor,
      List<double>? majorTickDashArray,
      required double minorTickLength,
      required double minorTickThickness,
      required GaugeSizeUnit minorTickLengthUnit,
      Color? minorTickColor,
      List<double>? minorTickDashArray,
      required SfGaugeThemeData gaugeThemeData,
      required ThemeData themeData,
      required SfColorScheme colorScheme,
      RadialAxisRenderer? renderer,
      List<GaugeRange>? ranges,
      Animation<double>? axisElementsAnimation,
      Animation<double>? axisLineAnimation,
      ImageStream? imageStream,
      required ValueNotifier<int> repaintNotifier,
      ImageProvider? backgroundImage})
      : _startAngle = startAngle,
        _endAngle = endAngle,
        _radiusFactor = radiusFactor,
        _centerX = centerX,
        _centerY = centerY,
        _canRotateLabels = canRotateLabels,
        _canScaleToFit = canScaleToFit,
        _showFirstLabel = showFirstLabel,
        _showLastLabel = showLastLabel,
        _onLabelCreated = onLabelCreated,
        _onAxisTapped = onAxisTapped,
        _minimum = minimum,
        _maximum = maximum,
        _interval = interval,
        _isInversed = isInversed,
        _minorTicksPerInterval = minorTicksPerInterval,
        _showAxisLine = showAxisLine,
        _showLabels = showLabels,
        _showTicks = showTicks,
        _tickOffset = tickOffset,
        _numberFormat = numberFormat,
        _labelFormat = labelFormat,
        _maximumLabels = maximumLabels,
        _labelOffset = labelOffset,
        _useRangeColorForAxis = useRangeColorForAxis,
        _labelPosition = labelPosition,
        _tickPosition = tickPosition,
        _offsetUnit = offsetUnit,
        _thickness = thickness,
        _thicknessUnit = thicknessUnit,
        _axisLineColor = axisLineColor,
        _axisLineGradient = axisLineGradient,
        _axisLineCornerStyle = axisLineCornerStyle,
        _axisLineDashArray = axisLineDashArray,
        _gaugeTextStyle = gaugeTextStyle,
        _majorTickLength = majorTickLength,
        _majorTickThickness = majorTickThickness,
        _majorTickLengthUnit = majorTickLengthUnit,
        _majorTickColor = majorTickColor,
        _majorTickDashArray = majorTickDashArray,
        _minorTickLength = minorTickLength,
        _minorTickThickness = minorTickThickness,
        _minorTickLengthUnit = minorTickLengthUnit,
        _minorTickColor = minorTickColor,
        _minorTickDashArray = minorTickDashArray,
        _axisLineAnimation = axisLineAnimation,
        _axisElementsAnimation = axisElementsAnimation,
        _gaugeThemeData = gaugeThemeData,
        _imageStream = imageStream,
        _ranges = ranges,
        _renderer = renderer,
        _repaintNotifier = repaintNotifier,
        _themeData = themeData,
        _colorScheme = colorScheme,
        _backgroundImage = backgroundImage {
    _isLabelsOutside = labelPosition == ElementsPosition.outside;
    _isTicksOutside = tickPosition == ElementsPosition.outside;
    _imageStreamListener = ImageStreamListener(_updateBackgroundImage);
  }

  final bool _useAxisElementsInsideRadius = true;
  late bool _isMaxiumValueIncluded = false;
  late Size _maximumLabelSize;
  late bool _isTicksOutside;
  late bool _isLabelsOutside;
  late double _maximumTickLength;
  late double _actualLabelOffset;
  late double _actualTickOffset;
  late double _diffInRadius;
  late double _center;
  late num _majorTicksCount;
  late Rect _axisRect;
  late double _startRadian;
  late double _endRadian;
  List<CircularAxisLabel>? _axisLabels;
  num? _actualInterval;
  late List<TickOffset> _majorTickOffsets;
  late List<TickOffset> _minorTickOffsets;
  late double _actualMajorTickLength;
  late double _actualMinorTickLength;
  late double _startCornerRadian;
  late double _sweepCornerRadian;
  late double _cornerAngle;
  ImageInfo? _backgroundImageInfo;
  late ImageStreamListener _imageStreamListener;

  late double _radius;
  late double _actualAxisWidth;
  late double _sweepAngle;
  late double _centerXPoint;
  late double _centerYPoint;
  late Offset _axisCenter;
  late double _axisOffset;
  late Size _axisSize;

  /// Axis path.
  Path axisPath = Path();

  /// Notifier for child repaint.
  final ValueNotifier<int> _repaintNotifier;

  /// Gets the renderer assigned to [RenderRadialAxisWidget].
  RadialAxisRenderer? get renderer => _renderer;
  RadialAxisRenderer? _renderer;

  /// Sets the renderer for [RenderRadialAxisWidget].
  set renderer(RadialAxisRenderer? value) {
    if (value == _renderer) {
      return;
    }

    _renderer = value;
    markNeedsPaint();
  }

  /// Gets the imageStream assigned to [RenderRadialAxisWidget].
  ImageStream? get imageStream => _imageStream;
  ImageStream? _imageStream;

  /// Sets the imageStream for [RenderRadialAxisWidget].
  set imageStream(ImageStream? value) {
    if (value == _imageStream) {
      return;
    }

    _removeImageStreamListener();
    _imageStream = value;
    _addImageStreamListener();
    markNeedsPaint();
  }

  /// Gets the animation assigned to [RenderRadialAxisWidget].
  Animation<double>? get axisLineAnimation => _axisLineAnimation;
  Animation<double>? _axisLineAnimation;

  /// Sets the animation for [RenderRadialAxisWidget].
  set axisLineAnimation(Animation<double>? value) {
    if (value == _axisLineAnimation) {
      return;
    }

    _removeAnimationListener();
    _axisLineAnimation = value;
    _addAnimationListener();
  }

  /// Gets the axis element animation assigned to [RenderRadialAxisWidget].
  Animation<double>? get axisElementsAnimation => _axisElementsAnimation;
  Animation<double>? _axisElementsAnimation;

  /// Sets the axis element animation for [RenderLinearRange].
  set axisElementsAnimation(Animation<double>? value) {
    if (value == _axisElementsAnimation) {
      return;
    }

    _removeAnimationListener();
    _axisElementsAnimation = value;
    _addAnimationListener();
  }

  /// Gets the gaugeThemeData assigned to [RenderRadialAxisWidget].
  SfGaugeThemeData get gaugeThemeData => _gaugeThemeData;
  SfGaugeThemeData _gaugeThemeData;

  /// Sets the gaugeThemeData for [RenderRadialAxisWidget].
  set gaugeThemeData(SfGaugeThemeData value) {
    if (value == _gaugeThemeData) {
      return;
    }
    _gaugeThemeData = value;
    markNeedsPaint();
  }

  /// Gets the themeData assigned to [RenderRadialAxisWidget].
  ThemeData get themeData => _themeData;
  ThemeData _themeData;

  /// Sets the themeData for [RenderRadialAxisWidget].
  set themeData(ThemeData value) {
    if (value == _themeData) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  /// Gets the colors of SfColorScheme
  SfColorScheme get colorScheme => _colorScheme;
  SfColorScheme _colorScheme;

  set colorScheme(SfColorScheme value) {
    if (value == _colorScheme) {
      return;
    }
    _colorScheme = value;
    markNeedsPaint();
  }

  /// Gets the startAngle assigned to [RenderRadialAxisWidget].
  double get startAngle => _startAngle;
  double _startAngle;

  /// Sets the startAngle for [RenderRadialAxisWidget].
  set startAngle(double value) {
    if (value == _startAngle) {
      return;
    }
    _startAngle = value;
    _updatePaint();
  }

  /// Gets the endAngle assigned to [RenderRadialAxisWidget].
  double get endAngle => _endAngle;
  double _endAngle;

  /// Sets the endAngle for [RenderRadialAxisWidget].
  set endAngle(double value) {
    if (value == _endAngle) {
      return;
    }
    _endAngle = value;
    _updatePaint();
  }

  /// Gets the radiusFactor assigned to [RenderRadialAxisWidget].
  double get radiusFactor => _radiusFactor;
  double _radiusFactor;

  /// Sets the radiusFactor for [RenderRadialAxisWidget].
  set radiusFactor(double value) {
    if (value == _radiusFactor) {
      return;
    }
    _radiusFactor = value;
    _updatePaint();
  }

  /// Gets the centerX assigned to [RenderRadialAxisWidget].
  double get centerX => _centerX;
  double _centerX;

  /// Sets the centerX for [RenderRadialAxisWidget].
  set centerX(double value) {
    if (value == _centerX) {
      return;
    }
    _centerX = value;
    _updatePaint();
  }

  /// Gets the centerY assigned to [RenderRadialAxisWidget].
  double get centerY => _centerY;
  double _centerY;

  /// Sets the centerY for [RenderRadialAxisWidget].
  set centerY(double value) {
    if (value == _centerY) {
      return;
    }
    _centerY = value;
    _updatePaint();
  }

  /// Gets the canRotateLabels assigned to [RenderRadialAxisWidget].
  bool get canRotateLabels => _canRotateLabels;
  bool _canRotateLabels;

  /// Sets the canRotateLabels for [RenderRadialAxisWidget].
  set canRotateLabels(bool value) {
    if (value == _canRotateLabels) {
      return;
    }
    _canRotateLabels = value;
    markNeedsPaint();
  }

  /// Gets the canScaleToFit assigned to [RenderRadialAxisWidget].
  bool get canScaleToFit => _canScaleToFit;
  bool _canScaleToFit;

  /// Sets the canScaleToFit for [RenderRadialAxisWidget].
  set canScaleToFit(bool value) {
    if (value == _canScaleToFit) {
      return;
    }
    _canScaleToFit = value;
    _updatePaint();
  }

  /// Gets the showFirstLabel assigned to [RenderRadialAxisWidget].
  bool get showFirstLabel => _showFirstLabel;
  bool _showFirstLabel;

  /// Sets the showFirstLabel for [RenderRadialAxisWidget].
  set showFirstLabel(bool value) {
    if (value == _showFirstLabel) {
      return;
    }
    _showFirstLabel = value;
    markNeedsPaint();
  }

  /// Gets the showLastLabel assigned to [RenderRadialAxisWidget].
  bool get showLastLabel => _showLastLabel;
  bool _showLastLabel;

  /// Sets the showLastLabel for [RenderRadialAxisWidget].
  set showLastLabel(bool value) {
    if (value == _showLastLabel) {
      return;
    }
    _showLastLabel = value;
    markNeedsPaint();
  }

  /// Gets the onLabelCreated assigned to [RenderRadialAxisWidget].
  ValueChanged<AxisLabelCreatedArgs>? get onLabelCreated => _onLabelCreated;
  ValueChanged<AxisLabelCreatedArgs>? _onLabelCreated;

  /// Sets the onLabelCreated for [RenderRadialAxisWidget].
  set onLabelCreated(ValueChanged<AxisLabelCreatedArgs>? value) {
    if (value == _onLabelCreated) {
      return;
    }
    _onLabelCreated = value;
    markNeedsPaint();
  }

  /// Gets the onAxisTapped assigned to [RenderRadialAxisWidget].
  ValueChanged<double>? get onAxisTapped => _onAxisTapped;
  ValueChanged<double>? _onAxisTapped;

  /// Sets the onAxisTapped for [RenderRadialAxisWidget].
  set onAxisTapped(ValueChanged<double>? value) {
    if (value == _onAxisTapped) {
      return;
    }
    _onAxisTapped = value;
    markNeedsPaint();
  }

  /// Gets the minimum assigned to [RenderRadialAxisWidget].
  double get minimum => _minimum;
  double _minimum;

  /// Sets the minimum for [RenderRadialAxisWidget].
  set minimum(double value) {
    if (value == _minimum) {
      return;
    }
    _minimum = value;
    _updatePaint();
  }

  /// Gets the maximum assigned to [RenderRadialAxisWidget].
  double get maximum => _maximum;
  double _maximum;

  /// Sets the maximum for [RenderRadialAxisWidget].
  set maximum(double value) {
    if (value == _maximum) {
      return;
    }
    _maximum = value;
    _updatePaint();
  }

  /// Gets the interval assigned to [RenderRadialAxisWidget].
  double? get interval => _interval;
  double? _interval;

  /// Sets the interval for [RenderRadialAxisWidget].
  set interval(double? value) {
    if (value == _interval) {
      return;
    }
    _interval = value;
    _updatePaint();
  }

  /// Gets the isInversed assigned to [RenderRadialAxisWidget].
  bool get isInversed => _isInversed;
  bool _isInversed;

  /// Sets the isInversed for [RenderRadialAxisWidget].
  set isInversed(bool value) {
    if (value == _isInversed) {
      return;
    }

    _isInversed = value;
    _updatePaint();
  }

  /// Gets the minorTicksPerInterval assigned to [RenderRadialAxisWidget].
  double get minorTicksPerInterval => _minorTicksPerInterval;
  double _minorTicksPerInterval;

  /// Sets the minorTicksPerInterval for [RenderRadialAxisWidget].
  set minorTicksPerInterval(double value) {
    if (value == _minorTicksPerInterval) {
      return;
    }
    _minorTicksPerInterval = value;
    markNeedsPaint();
  }

  /// Gets the showAxisLine assigned to [RenderRadialAxisWidget].
  bool get showAxisLine => _showAxisLine;
  bool _showAxisLine;

  /// Sets the showAxisLine for [RenderRadialAxisWidget]..
  set showAxisLine(bool value) {
    if (value == _showAxisLine) {
      return;
    }
    _showAxisLine = value;
    _updatePaint();
  }

  /// Gets the showLabels assigned to [RenderRadialAxisWidget].
  bool get showLabels => _showLabels;
  bool _showLabels;

  /// Sets the showLabels for [RenderRadialAxisWidget]..
  set showLabels(bool value) {
    if (value == _showLabels) {
      return;
    }
    _showLabels = value;
    _updatePaint();
  }

  /// Gets the showTicks assigned to [RenderRadialAxisWidget].
  bool get showTicks => _showTicks;
  bool _showTicks;

  /// Sets the showTicks for [RenderRadialAxisWidget]..
  set showTicks(bool value) {
    if (value == _showTicks) {
      return;
    }
    _showTicks = value;
    _updatePaint();
  }

  /// Gets the tickOffset assigned to [RenderRadialAxisWidget].
  double get tickOffset => _tickOffset;
  double _tickOffset;

  /// Sets the tickOffset for [RenderRadialAxisWidget].
  set tickOffset(double value) {
    if (value == _tickOffset) {
      return;
    }

    _tickOffset = value;
    _updatePaint();
  }

  /// Gets the numberFormat assigned to [RenderRadialAxisWidget].
  init.NumberFormat? get numberFormat => _numberFormat;
  init.NumberFormat? _numberFormat;

  /// Sets the numberFormat for [RenderRadialAxisWidget].
  set numberFormat(init.NumberFormat? value) {
    if (_numberFormat == value) {
      return;
    }
    _numberFormat = value;
    _updatePaint();
  }

  /// Gets the maximum labels assigned to [RenderRadialAxisWidget].
  int get maximumLabels => _maximumLabels;
  int _maximumLabels;

  /// Sets the maximum labels for [RenderRadialAxisWidget].
  set maximumLabels(int value) {
    if (value == _maximumLabels) {
      return;
    }
    _maximumLabels = value;
    markNeedsPaint();
  }

  /// Gets the labelOffset assigned to [RenderRadialAxisWidget].
  double get labelOffset => _labelOffset;
  double _labelOffset;

  /// Sets the labelOffset for [RenderRadialAxisWidget].
  set labelOffset(double value) {
    if (value == _labelOffset) {
      return;
    }
    _labelOffset = value;
    _updatePaint();
  }

  /// Gets the useRangeColorForAxis assigned to [RenderRadialAxisWidget].
  bool get useRangeColorForAxis => _useRangeColorForAxis;
  bool _useRangeColorForAxis;

  /// Sets the useRangeForAxis for [RenderRadialAxisWidget].
  set useRangeColorForAxis(bool value) {
    if (value == _useRangeColorForAxis) {
      return;
    }
    _useRangeColorForAxis = value;
    markNeedsPaint();
  }

  /// Gets the labelPosition assigned to [RenderRadialAxisWidget].
  ElementsPosition get labelPosition => _labelPosition;
  ElementsPosition _labelPosition;

  /// Sets the labelPosition for [RenderRadialAxisWidget].
  set labelPosition(ElementsPosition value) {
    if (value == _labelPosition) {
      return;
    }
    _labelPosition = value;
    _isLabelsOutside = labelPosition == ElementsPosition.outside;
    _updatePaint();
  }

  /// Gets the tickPosition assigned to [RenderRadialAxisWidget].
  ElementsPosition get tickPosition => _tickPosition;
  ElementsPosition _tickPosition;

  /// Sets the tickPosition for [RenderRadialAxisWidget].
  set tickPosition(ElementsPosition value) {
    if (value == _tickPosition) {
      return;
    }
    _tickPosition = value;
    _isTicksOutside = tickPosition == ElementsPosition.outside;
    _updatePaint();
  }

  /// Gets the offsetUnit assigned to [RenderRadialAxisWidget].
  GaugeSizeUnit get offsetUnit => _offsetUnit;
  GaugeSizeUnit _offsetUnit;

  /// Sets the offsetUnit for [RenderRadialAxisWidget].
  set offsetUnit(GaugeSizeUnit value) {
    if (value == _offsetUnit) {
      return;
    }
    _offsetUnit = value;
    markNeedsPaint();
  }

  /// Gets the thickness assigned to [RenderRadialAxisWidget].
  double get thickness => _thickness;
  double _thickness;

  /// Sets the thickness for [RenderRadialAxisWidget]..
  set thickness(double value) {
    if (value == _thickness) {
      return;
    }
    _thickness = value;
    _updatePaint();
  }

  /// Gets the thicknessUnit assigned to [RenderRadialAxisWidget].
  GaugeSizeUnit get thicknessUnit => _thicknessUnit;
  GaugeSizeUnit _thicknessUnit;

  /// Sets the thicknessUnit for [RenderRadialAxisWidget]..
  set thicknessUnit(GaugeSizeUnit value) {
    if (value == _thicknessUnit) {
      return;
    }

    _thicknessUnit = value;
    _updatePaint();
  }

  /// Gets the axisLineColor assigned to [RenderRadialAxisWidget].
  Color? get axisLineColor => _axisLineColor;
  Color? _axisLineColor;

  /// Sets the axisLineColor for [RenderRadialAxisWidget]..
  set axisLineColor(Color? value) {
    if (value == _axisLineColor) {
      return;
    }

    _axisLineColor = value;
    markNeedsPaint();
  }

  /// Gets the axisLineGradient assigned to [RenderRadialAxisWidget].
  Gradient? get axisLineGradient => _axisLineGradient;
  Gradient? _axisLineGradient;

  /// Sets the axisLineGradient for [RenderRadialAxisWidget]..
  set axisLineGradient(Gradient? value) {
    if (value == _axisLineGradient) {
      return;
    }

    _axisLineGradient = value;
    markNeedsPaint();
  }

  /// Gets the axisLineCornerStyle assigned to [RenderRadialAxisWidget].
  CornerStyle get axisLineCornerStyle => _axisLineCornerStyle;
  CornerStyle _axisLineCornerStyle;

  /// Sets the axisLineCornerStyle for [RenderRadialAxisWidget]..
  set axisLineCornerStyle(CornerStyle value) {
    if (value == _axisLineCornerStyle) {
      return;
    }

    _axisLineCornerStyle = value;
    _updatePaint();
  }

  /// Gets the axisLineDashArray assigned to [RenderRadialAxisWidget].
  List<double>? get axisLineDashArray => _axisLineDashArray;
  List<double>? _axisLineDashArray;

  /// Sets the axisLineDashArray for [RenderRadialAxisWidget]..
  set axisLineDashArray(List<double>? value) {
    if (value == _axisLineDashArray) {
      return;
    }

    _axisLineDashArray = value;
    markNeedsPaint();
  }

  /// Gets the gaugeTextStyle assigned to [RenderRadialAxis].
  GaugeTextStyle get gaugeTextStyle => _gaugeTextStyle;
  GaugeTextStyle _gaugeTextStyle;

  /// Sets the gaugeTextStyle for [RenderRadialAxisWidget].
  set gaugeTextStyle(GaugeTextStyle value) {
    if (value == _gaugeTextStyle) {
      return;
    }

    _gaugeTextStyle = value;
    _updatePaint();
  }

  /// Gets the majorTickLength assigned to [RenderRadialAxis].
  double get majorTickLength => _majorTickLength;
  double _majorTickLength;

  /// Sets the majorTickLength for [RenderRadialAxis]..
  set majorTickLength(double value) {
    if (value == _majorTickLength) {
      return;
    }

    _majorTickLength = value;
    _updatePaint();
  }

  /// Gets the majorTickThickness assigned to [RenderRadialAxis].
  double get majorTickThickness => _majorTickThickness;
  double _majorTickThickness;

  /// Sets the majorTickThickness for [RenderRadialAxisWidget]..
  set majorTickThickness(double value) {
    if (value == _majorTickThickness) {
      return;
    }

    _majorTickThickness = value;
    markNeedsPaint();
  }

  /// Gets the majorTickLengthUnit assigned to [RenderRadialAxis].
  GaugeSizeUnit get majorTickLengthUnit => _majorTickLengthUnit;
  GaugeSizeUnit _majorTickLengthUnit;

  /// Sets the majorTickLengthUnit for [RenderRadialAxis]..
  set majorTickLengthUnit(GaugeSizeUnit value) {
    if (value == _majorTickLengthUnit) {
      return;
    }

    _majorTickLengthUnit = value;
    _updatePaint();
  }

  /// Gets the majorTickColor assigned to [RenderRadialAxis].
  Color? get majorTickColor => _majorTickColor;
  Color? _majorTickColor;

  /// Sets the majorTickColor for [RenderRadialAxis]..
  set majorTickColor(Color? value) {
    if (value == _majorTickColor) {
      return;
    }

    _majorTickColor = value;
    markNeedsPaint();
  }

  /// Gets the majorTickDashArray assigned to [RenderRadialAxis].
  List<double>? get majorTickDashArray => _majorTickDashArray;
  List<double>? _majorTickDashArray;

  /// Sets the majorTickDashArray for [RenderRadialAxis]..
  set majorTickDashArray(List<double>? value) {
    if (value == _majorTickDashArray) {
      return;
    }

    _majorTickDashArray = value;
    markNeedsPaint();
  }

  /// Gets the minorTickLength assigned to [RenderRadialAxis].
  double get minorTickLength => _minorTickLength;
  double _minorTickLength;

  /// Sets the minorTickLength for [RenderRadialAxis]..
  set minorTickLength(double value) {
    if (value == _minorTickLength) {
      return;
    }

    _minorTickLength = value;
    _updatePaint();
  }

  /// Gets the minorTickThickness assigned to [RenderRadialAxis]..
  double get minorTickThickness => _minorTickThickness;
  double _minorTickThickness;

  /// Sets the minorTickThickness for [RenderRadialAxis]..
  set minorTickThickness(double value) {
    if (value == _minorTickThickness) {
      return;
    }

    _minorTickThickness = value;
    markNeedsPaint();
  }

  /// Gets the minorTickLengthUnit assigned to [RenderRadialAxis].
  GaugeSizeUnit get minorTickLengthUnit => _minorTickLengthUnit;
  GaugeSizeUnit _minorTickLengthUnit;

  /// Sets the minorTickLengthUnit for [RenderRadialAxis].
  set minorTickLengthUnit(GaugeSizeUnit value) {
    if (value == _minorTickLengthUnit) {
      return;
    }

    _minorTickLengthUnit = value;
    _updatePaint();
  }

  /// Gets the minorTickColor assigned to [RenderRadialAxis].
  Color? get minorTickColor => _minorTickColor;
  Color? _minorTickColor;

  /// Sets the minorTickColor for [RenderRadialAxis].
  set minorTickColor(Color? value) {
    if (value == _minorTickColor) {
      return;
    }

    _minorTickColor = value;
    markNeedsPaint();
  }

  /// Gets the minorTickDashArray assigned to [RenderRadialAxis].
  List<double>? get minorTickDashArray => _minorTickDashArray;
  List<double>? _minorTickDashArray;

  /// Sets the minorTickDashArray for [RenderRadialAxisWidget]..
  set minorTickDashArray(List<double>? value) {
    if (value == _minorTickDashArray) {
      return;
    }

    _minorTickDashArray = value;
    markNeedsPaint();
  }

  /// Gets the backgroundImage assigned to [RenderRadialAxis].
  ImageProvider? get backgroundImage => _backgroundImage;
  ImageProvider? _backgroundImage;

  /// Sets the backgroundImage for [RenderRadialAxis]..
  set backgroundImage(ImageProvider? value) {
    if (value == _backgroundImage) {
      return;
    }

    _backgroundImage = value;
    markNeedsPaint();
  }

  /// Gets the labelFormat assigned to [RenderRadialAxis].
  String? get labelFormat => _labelFormat;
  String? _labelFormat;

  /// Sets the labelFormat for [RenderRadialAxis]..
  set labelFormat(String? value) {
    if (value == _labelFormat) {
      return;
    }

    _labelFormat = value;
    _updatePaint();
  }

  /// Gets the ranges assigned to [RenderRadialAxis].
  List<GaugeRange>? get ranges => _ranges;
  List<GaugeRange>? _ranges;

  /// Sets the ranges for [RenderRadialAxis].
  set ranges(List<GaugeRange>? value) {
    if (value == _ranges) {
      return;
    }

    _ranges = value;
    markNeedsPaint();
  }

  void _addAnimationListener() {
    if (_axisLineAnimation != null) {
      _axisLineAnimation!.addListener(markNeedsPaint);
    }

    if (_axisElementsAnimation != null) {
      _axisElementsAnimation!.addListener(markNeedsPaint);
    }
  }

  void _removeAnimationListener() {
    if (_axisLineAnimation != null) {
      _axisLineAnimation!.removeListener(markNeedsPaint);
    }

    if (_axisElementsAnimation != null) {
      _axisElementsAnimation!.removeListener(markNeedsPaint);
    }
  }

  void _addImageStreamListener() {
    if (_imageStream != null) {
      _imageStream?.addListener(_imageStreamListener);
    }
  }

  void _removeImageStreamListener() {
    if (_imageStream != null) {
      _imageStream?.removeListener(_imageStreamListener);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addAnimationListener();
    _addImageStreamListener();
  }

  @override
  void detach() {
    _removeAnimationListener();
    _removeImageStreamListener();
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) {
    if (onAxisTapped != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
    _axisSize = size;
    _calculateAxisElementsPosition();
  }

  void _updatePaint() {
    markNeedsPaint();
    _repaintNotifier.value++;
  }

  /// Calculates the sweep angle of the pointer.
  double _getSweepAngle(double currentValue) {
    return (renderer != null && renderer!.valueToFactor(currentValue) != null)
        ? renderer!.valueToFactor(currentValue) ?? valueToFactor(currentValue)
        : valueToFactor(currentValue);
  }

  /// To calculate the radius and the center point based on the angle.
  Offset getAxisBounds() {
    final Offset centerOffset = _getCenter();
    final double minScale = math.min(_axisSize.height, _axisSize.width);
    final double x = ((centerOffset.dx * 2) - minScale) / 2;
    final double y = ((centerOffset.dy * 2) - minScale) / 2;
    Rect bounds = Rect.fromLTRB(x, y, minScale, minScale);
    final double centerYDiff = (_axisSize.height / 2 - centerOffset.dy).abs();
    final double centerXDiff = (_axisSize.width / 2 - centerOffset.dx).abs();
    double diff = 0;
    if (_axisSize.width > _axisSize.height) {
      diff = centerYDiff / 2;
      final double angleRadius = _axisSize.height / 2 + diff;
      if (_axisSize.width / 2 < angleRadius) {
        final double actualDiff = _axisSize.width / 2 - _axisSize.height / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(
          x - diff / 2, y, x + minScale + (diff / 2), y + minScale + diff);
    } else {
      diff = centerXDiff / 2;
      final double angleRadius = _axisSize.width / 2 + diff;

      if (_axisSize.height / 2 < angleRadius) {
        final double actualDiff = _axisSize.height / 2 - _axisSize.width / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(x - diff / 2, y - diff / 2,
          x + minScale + (diff / 2), y + minScale + (diff / 2));
    }

    _diffInRadius = diff;

    return Offset(
        bounds.left + (bounds.width / 2), bounds.top + (bounds.height / 2));
  }

  /// Get the RadialAxis radius.
  double getRadius() {
    _center = math.min(_axisSize.width / 2, _axisSize.height / 2);

    if (!canScaleToFit) {
      _radius = _center * radiusFactor;
    } else {
      _radius = (_center + _diffInRadius) * radiusFactor;
    }

    return _radius;
  }

  /// Get the RadialAxis centerX.
  double getCenterX() {
    if (!canScaleToFit) {
      _centerXPoint = (_axisSize.width / 2) - (centerX * _axisSize.width);
    } else {
      final Offset centerPoint = getAxisBounds();
      _centerXPoint = centerPoint.dx;
    }

    return _centerXPoint;
  }

  /// Get the RadialAxis centerY.
  double getCenterY() {
    if (!canScaleToFit) {
      _centerYPoint = (_axisSize.height / 2) - (centerY * _axisSize.height);
    } else {
      final Offset centerPoint = getAxisBounds();
      _centerYPoint = centerPoint.dy;
    }

    return _centerYPoint;
  }

  /// Get the RadialAxis centerY.
  Offset getAxisCenter() {
    getCenterX();
    getCenterY();

    if (!canScaleToFit) {
      _axisCenter = Offset(_axisSize.width / 2 - _centerXPoint,
          _axisSize.height / 2 - _centerYPoint);
    } else {
      _axisCenter = Offset(_centerXPoint, _centerYPoint);
    }

    return _axisCenter;
  }

  /// Calculates the default values of the axis.
  void _calculateDefaultValues() {
    _isTicksOutside = tickPosition == ElementsPosition.outside;
    _isLabelsOutside = labelPosition == ElementsPosition.outside;

    _startRadian = getDegreeToRadian(startAngle);
    getAxisSweepAngle();
    _endRadian = getDegreeToRadian(_sweepAngle);
    getAxisCenter();
    getRadius();
    _actualAxisWidth = getActualValue(thickness, thicknessUnit, false);

    _actualMajorTickLength = _getTickLength(true);
    _actualMinorTickLength = _getTickLength(false);
    _maximumTickLength = _actualMajorTickLength > _actualMinorTickLength
        ? _actualMajorTickLength
        : _actualMinorTickLength;
    _actualLabelOffset = getActualValue(labelOffset, offsetUnit, true);
    _actualTickOffset = getActualValue(tickOffset, offsetUnit, true);
  }

  /// Methods to calculate axis elements position.
  void _calculateAxisElementsPosition() {
    _calculateDefaultValues();
    _axisLabels =
        (renderer != null && renderer!.generateVisibleLabels() != null)
            ? renderer!.generateVisibleLabels() ?? generateVisibleLabels()
            : generateVisibleLabels();
    if (showLabels) {
      _measureAxisLabels();
    }

    _axisOffset = _useAxisElementsInsideRadius ? getAxisOffset() : 0;

    if (showTicks) {
      _calculateMajorTicksPosition();
      _calculateMinorTickPosition();
    }

    if (showLabels) {
      _calculateAxisLabelsPosition();
    }

    _calculateAxisRect();
    if (showAxisLine) {
      _calculateCornerStylePosition();
    }
  }

  /// To calculate the center based on the angle.
  Offset _getCenter() {
    final double x = _axisSize.width / 2;
    final double y = _axisSize.height / 2;
    _center = math.min(_axisSize.width / 2, _axisSize.height / 2);
    _radius = _center;
    Offset actualCenter = Offset(x, y);
    final double actualStartAngle = _getWrapAngle(startAngle, -630, 630);
    final double actualEndAngle =
        _getWrapAngle(startAngle + _sweepAngle.abs(), -630, 630);
    final List<double> regions = <double>[
      -630,
      -540,
      -450,
      -360,
      -270,
      -180,
      -90,
      0,
      90,
      180,
      270,
      360,
      450,
      540,
      630
    ];
    final List<int> region = <int>[];
    if (actualStartAngle < actualEndAngle) {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] > actualStartAngle && regions[i] < actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    } else {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] < actualStartAngle && regions[i] > actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    }

    final double startRadian = 2 * math.pi * (actualStartAngle / 360);
    final double endRadian = 2 * math.pi * (actualEndAngle / 360);
    final Offset startPoint = Offset(x + (_radius * math.cos(startRadian)),
        y + (_radius * math.sin(startRadian)));
    final Offset endPoint = Offset(x + (_radius * math.cos(endRadian)),
        y + (_radius * math.sin(endRadian)));

    switch (region.length) {
      case 0:
        actualCenter = _getCenterForLengthZero(
            startPoint, endPoint, x, y, _radius, region);
        break;
      case 1:
        actualCenter =
            _getCenterLengthOne(startPoint, endPoint, x, y, _radius, region);
        break;
      case 2:
        actualCenter =
            _getCenterForLengthTwo(startPoint, endPoint, x, y, _radius, region);
        break;
      case 3:
        actualCenter = _getCenterForLengthThree(
            startPoint, endPoint, x, y, _radius, region);
        break;
    }

    return actualCenter;
  }

  /// Creates a animation object for pointer elements.
  Animation<double>? createPointerAnimation(dynamic pointer) {
    if (pointer.pointerAnimationController != null) {
      double animationStartValue, animationEndValue;
      final bool enableAnimation = pointer.enableAnimation as bool;

      late double begin, end;
      if (pointer is RenderRangePointer) {
        animationStartValue = pointer.animationStartValue ?? 0;
        animationEndValue = isInversed
            ? _getSweepAngle(pointer.getSweepAngle())
            : pointer.getSweepAngle();
        pointer.animationStartValue = animationEndValue;
      } else {
        animationStartValue = _getSweepAngle(pointer.oldValue ?? minimum);
        animationEndValue = _getSweepAngle(pointer.value);
      }

      begin = enableAnimation ? 0 : pointer.pointerInterval![0]! as double;
      end = enableAnimation ? 1 : pointer.pointerInterval![1]! as double;

      return Tween<double>(begin: animationStartValue, end: animationEndValue)
          .animate(CurvedAnimation(
              parent: pointer.pointerAnimationController!,
              curve: Interval(begin, end,
                  curve: getCurveAnimation(pointer.animationType))));
    } else {
      return null;
    }
  }

  /// Calculate the center point when the region length is zero.
  Offset _getCenterForLengthZero(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double longX = (x - startPoint.dx).abs() > (x - endPoint.dx).abs()
        ? startPoint.dx
        : endPoint.dx;
    final double longY = (y - startPoint.dy).abs() > (y - endPoint.dy).abs()
        ? startPoint.dy
        : endPoint.dy;
    final Offset midPoint =
        Offset((x + longX).abs() / 2, (y + longY).abs() / 2);
    final double xValue = x + (x - midPoint.dx);
    final double yValue = y + (y - midPoint.dy);
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterLengthOne(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1 = Offset.zero;
    Offset point2 = Offset.zero;
    final double maxRadian = 2 * math.pi * region[0] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));

    switch (region[0]) {
      case 270:
        point1 = Offset(startPoint.dx, maxPoint.dy);
        point2 = Offset(endPoint.dx, y);
        break;
      case 0:
      case 360:
        point1 = Offset(x, endPoint.dy);
        point2 = Offset(maxPoint.dx, startPoint.dy);
        break;
      case 90:
        point1 = Offset(endPoint.dx, y);
        point2 = Offset(startPoint.dx, maxPoint.dy);
        break;
      case 180:
        point1 = Offset(maxPoint.dx, startPoint.dy);
        point2 = Offset(x, endPoint.dy);
        break;
    }

    final Offset midPoint =
        Offset((point1.dx + point2.dx) / 2, (point1.dy + point2.dy) / 2);
    final double xValue =
        x + ((x - midPoint.dx) >= radius ? 0 : (x - midPoint.dx));
    final double yValue =
        y + ((y - midPoint.dy) >= radius ? 0 : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterForLengthTwo(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1;
    Offset point2;
    final double minRadian = 2 * math.pi * region[0] / 360;
    final double maxRadian = 2 * math.pi * region[1] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));
    final Offset minPoint = Offset(
        x + (radius * math.cos(minRadian)), y + (radius * math.sin(minRadian)));

    if ((region[0] == 0 && region[1] == 90) ||
        (region[0] == 180 && region[1] == 270)) {
      point1 = Offset(minPoint.dx, maxPoint.dy);
    } else {
      point1 = Offset(maxPoint.dx, minPoint.dy);
    }

    if (region[0] == 0 || region[0] == 180) {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[0]),
          _getMinMaxValue(startPoint, endPoint, region[1]));
    } else {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[1]),
          _getMinMaxValue(startPoint, endPoint, region[0]));
    }

    final Offset midPoint = Offset(
        (point1.dx - point2.dx).abs() / 2 >= radius
            ? 0
            : (point1.dx + point2.dx) / 2,
        (point1.dy - point2.dy).abs() / 2 >= radius
            ? 0
            : (point1.dy + point2.dy) / 2);
    final double xValue = x +
        (midPoint.dx == 0
            ? 0
            : (x - midPoint.dx) >= radius
                ? 0
                : (x - midPoint.dx));
    final double yValue = y +
        (midPoint.dy == 0
            ? 0
            : (y - midPoint.dy) >= radius
                ? 0
                : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is three.
  Offset _getCenterForLengthThree(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double region0Radian = 2 * math.pi * region[0] / 360;
    final double region1Radian = 2 * math.pi * region[1] / 360;
    final double region2Radian = 2 * math.pi * region[2] / 360;
    final Offset region0Point = Offset(x + (radius * math.cos(region0Radian)),
        y + (radius * math.sin(region0Radian)));
    final Offset region1Point = Offset(x + (radius * math.cos(region1Radian)),
        y + (radius * math.sin(region1Radian)));
    final Offset region2Point = Offset(x + (radius * math.cos(region2Radian)),
        y + (radius * math.sin(region2Radian)));
    Offset regionStartPoint = Offset.zero;
    Offset regionEndPoint = Offset.zero;
    switch (region[2]) {
      case 0:
      case 360:
        regionStartPoint = Offset(region0Point.dx, region1Point.dy);
        regionEndPoint =
            Offset(region2Point.dx, math.max(startPoint.dy, endPoint.dy));
        break;
      case 90:
        regionStartPoint =
            Offset(math.min(startPoint.dx, endPoint.dx), region0Point.dy);
        regionEndPoint = Offset(region1Point.dx, region2Point.dy);
        break;
      case 180:
        regionStartPoint =
            Offset(region2Point.dx, math.min(startPoint.dy, endPoint.dy));
        regionEndPoint = Offset(region0Point.dx, region1Point.dy);
        break;
      case 270:
        regionStartPoint = Offset(region1Point.dx, region2Point.dy);
        regionEndPoint =
            Offset(math.max(startPoint.dx, endPoint.dx), region0Point.dy);
        break;
    }

    final Offset midRegionPoint = Offset(
        (regionStartPoint.dx - regionEndPoint.dx).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dx + regionEndPoint.dx) / 2,
        (regionStartPoint.dy - regionEndPoint.dy).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dy + regionEndPoint.dy) / 2);
    final double xValue = x +
        (midRegionPoint.dx == 0
            ? 0
            : (x - midRegionPoint.dx) >= radius
                ? 0
                : (x - midRegionPoint.dx));
    final double yValue = y +
        (midRegionPoint.dy == 0
            ? 0
            : (y - midRegionPoint.dy) >= radius
                ? 0
                : (y - midRegionPoint.dy));
    return Offset(xValue, yValue);
  }

  /// To calculate the value based on the angle.
  double _getMinMaxValue(Offset startPoint, Offset endPoint, int degree) {
    final double minX = math.min(startPoint.dx, endPoint.dx);
    final double minY = math.min(startPoint.dy, endPoint.dy);
    final double maxX = math.max(startPoint.dx, endPoint.dx);
    final double maxY = math.max(startPoint.dy, endPoint.dy);
    switch (degree) {
      case 270:
        return maxY;
      case 0:
      case 360:
        return minX;
      case 90:
        return minY;
      case 180:
        return maxX;
    }

    return 0;
  }

  /// To calculate the wrap angle
  double _getWrapAngle(double angle, double min, double max) {
    if (max - min == 0) {
      return min;
    }

    angle = ((angle - min) % (max - min)) + min;
    while (angle < min) {
      angle += max - min;
    }

    return angle;
  }

  /// Calculates the rounded corner position.
  void _calculateCornerStylePosition() {
    final double cornerCenter = (_axisRect.right - _axisRect.left) / 2;
    _cornerAngle = cornerRadiusAngle(cornerCenter, _actualAxisWidth / 2);

    switch (axisLineCornerStyle) {
      case CornerStyle.startCurve:
        {
          _startCornerRadian = isInversed
              ? getDegreeToRadian(-_cornerAngle)
              : getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = isInversed
              ? getDegreeToRadian((-_sweepAngle) + _cornerAngle)
              : getDegreeToRadian(_sweepAngle - _cornerAngle);
        }
        break;
      case CornerStyle.endCurve:
        {
          _startCornerRadian = getDegreeToRadian(0);
          _sweepCornerRadian = isInversed
              ? getDegreeToRadian((-_sweepAngle) + _cornerAngle)
              : getDegreeToRadian(_sweepAngle - _cornerAngle);
        }
        break;
      case CornerStyle.bothCurve:
        {
          _startCornerRadian = isInversed
              ? getDegreeToRadian(-_cornerAngle)
              : getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = isInversed
              ? getDegreeToRadian((-_sweepAngle) + (2 * _cornerAngle))
              : getDegreeToRadian(_sweepAngle - (2 * _cornerAngle));
        }
        break;
      case CornerStyle.bothFlat:
        _startCornerRadian = !isInversed
            ? getDegreeToRadian(0)
            : getDegreeToRadian(startAngle + _sweepAngle);
        _sweepCornerRadian =
            getDegreeToRadian(_sweepAngle * (isInversed ? -1 : 1));
        break;
    }
  }

  /// Calculates the axis rect.
  void _calculateAxisRect() {
    final double axisOffset = _radius - (_actualAxisWidth / 2 + _axisOffset);
    _axisRect = Rect.fromLTRB(-axisOffset, -axisOffset, axisOffset, axisOffset);

    axisPath.reset();
    final double centerX = canScaleToFit ? _axisCenter.dx : size.width / 2;
    final double centerY = canScaleToFit ? _axisCenter.dy : size.height / 2;
    final Rect rect = Rect.fromLTRB(
      _axisRect.left + centerX,
      _axisRect.top + centerY,
      _axisRect.right + centerX,
      _axisRect.bottom + centerY,
    );

    axisPath.arcTo(rect, _startRadian, _endRadian, false);
  }

  /// Method to calculate the angle from the tapped point.
  void calculateAngleFromOffset(Offset offset) {
    final double actualCenterX =
        canScaleToFit ? _axisCenter.dx : size.width * centerX;
    final double actualCenterY =
        canScaleToFit ? _axisCenter.dy : size.height * centerY;
    double angle =
        math.atan2(offset.dy - actualCenterY, offset.dx - actualCenterX) *
                (180 / math.pi) +
            360;
    final double actualEndAngle = startAngle + _sweepAngle;
    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > actualEndAngle) {
      angle %= 360;
    }

    if (angle >= startAngle && angle <= actualEndAngle) {
      final double angleFactor = (angle - startAngle) / _sweepAngle;

      final double value = (renderer != null &&
              renderer!.factorToValue(angleFactor) != null)
          ? renderer!.factorToValue(angleFactor) ?? factorToValue(angleFactor)
          : factorToValue(angleFactor);
      if (value >= minimum && value <= maximum) {
        final double tappedValue = _angleToValue(angle);
        onAxisTapped!(tappedValue);
      }
    }
  }

  /// Calculate the offset for axis line based on ticks and labels
  double getAxisOffset() {
    double offset = 0;
    offset = _isTicksOutside
        ? showTicks
            ? (_maximumTickLength + _actualTickOffset)
            : 0
        : 0;
    offset += _isLabelsOutside
        ? showLabels
            ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2 +
                _actualLabelOffset)
            : 0
        : 0;
    return offset;
  }

  /// Converts the axis value to angle.
  double _valueToAngle(double value) {
    double angle = 0;
    value = value.clamp(minimum, maximum);
    if (!isInversed) {
      angle =
          (_sweepAngle / (maximum - minimum).abs()) * (minimum - value).abs();
    } else {
      angle = _sweepAngle -
          ((_sweepAngle / (maximum - minimum).abs()) * (minimum - value).abs());
    }

    return angle;
  }

  /// Converts the angle to corresponding axis value.
  double _angleToValue(double angle) {
    double value = 0;
    if (!isInversed) {
      value = (((angle - startAngle) / _sweepAngle) * (maximum - minimum)) +
          minimum;
    } else {
      value = maximum -
          (((angle - startAngle) / _sweepAngle) * (maximum - minimum));
    }

    return value;
  }

  /// Calculates the major ticks position.
  void _calculateMajorTicksPosition() {
    if (_axisLabels != null && _axisLabels!.isNotEmpty) {
      double angularSpaceForTicks;
      if (_actualInterval != null) {
        _majorTicksCount = (maximum - minimum) / _actualInterval!;
        angularSpaceForTicks =
            getDegreeToRadian(_sweepAngle / _majorTicksCount);
      } else {
        _majorTicksCount = _axisLabels!.length;
        angularSpaceForTicks =
            getDegreeToRadian(_sweepAngle / (_majorTicksCount - 1));
      }

      final double axisLineWidth = showAxisLine ? _actualAxisWidth : 0;
      double angleForTicks = 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      _majorTickOffsets = <TickOffset>[];
      angleForTicks = isInversed
          ? getDegreeToRadian(startAngle + _sweepAngle - 90)
          : getDegreeToRadian(startAngle - 90);
      final double offset = _isLabelsOutside
          ? showLabels
              ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2 +
                  _actualLabelOffset)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset =
            _radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = _radius -
            (axisLineWidth +
                _actualMajorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = _actualMajorTickLength > _actualMinorTickLength;

        // Calculates the major tick position based on the tick length
        // and another features offset value
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = _radius + _actualTickOffset;
          tickEndOffset = _radius + _actualMajorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? _radius - offset
              : _radius -
                  (_maximumTickLength - _actualMajorTickLength + offset);
          tickEndOffset = _radius - (offset + _maximumTickLength);
        }
      }

      _calculateOffsetForMajorTicks(
          tickStartOffset, tickEndOffset, angularSpaceForTicks, angleForTicks);
    }
  }

  /// Calculates the offset for major ticks
  void _calculateOffsetForMajorTicks(double tickStartOffset,
      double tickEndOffset, double angularSpaceForTicks, double angleForTicks) {
    final num length =
        _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
    for (num i = 0; i <= length; i++) {
      double tickAngle = 0;
      final num count =
          _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
      if (i == 0 || i == count) {
        tickAngle =
            _getTickPositionInCorner(i, angleForTicks, tickStartOffset, true);
      } else {
        tickAngle = angleForTicks;
      }
      final List<Offset> tickPosition =
          _getTickPosition(tickStartOffset, tickEndOffset, tickAngle);
      final TickOffset tickOffset = TickOffset();
      tickOffset.startPoint = tickPosition[0];
      tickOffset.endPoint = tickPosition[1];
      final double degree = (isInversed
              ? getRadianToDegree(tickAngle) + 90 - (startAngle + _sweepAngle)
              : (getRadianToDegree(tickAngle) + 90 - startAngle)) /
          _sweepAngle;
      tickOffset.value =
          (renderer != null && renderer!.factorToValue(degree) != null)
              ? renderer!.factorToValue(degree) ?? factorToValue(degree)
              : factorToValue(degree);
      final Offset centerPoint =
          !canScaleToFit ? Offset(_centerXPoint, _centerYPoint) : Offset.zero;
      tickOffset.startPoint = Offset(tickOffset.startPoint.dx - centerPoint.dx,
          tickOffset.startPoint.dy - centerPoint.dy);
      tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
          tickOffset.endPoint.dy - centerPoint.dy);
      _majorTickOffsets.add(tickOffset);
      if (isInversed) {
        angleForTicks -= angularSpaceForTicks;
      } else {
        angleForTicks += angularSpaceForTicks;
      }
    }
  }

  /// Calculates the angle to adjust the start and end tick
  double _getTickPositionInCorner(
      num num, double angleForTicks, double startOffset, bool isMajor) {
    final double thickness = isMajor ? majorTickThickness : minorTickThickness;
    final double angle =
        cornerRadiusAngle(startOffset + _actualAxisWidth / 2, thickness / 2);
    if (num == 0) {
      final double ticksAngle = !isInversed
          ? getRadianToDegree(angleForTicks) + angle
          : getRadianToDegree(angleForTicks) - angle;
      return getDegreeToRadian(ticksAngle);
    } else {
      final double ticksAngle = !isInversed
          ? getRadianToDegree(angleForTicks) - angle
          : getRadianToDegree(angleForTicks) + angle;
      return getDegreeToRadian(ticksAngle);
    }
  }

  /// Calculates the minor tick position
  void _calculateMinorTickPosition() {
    if (_axisLabels != null && _axisLabels!.isNotEmpty) {
      final double axisLineWidth = showAxisLine ? _actualAxisWidth : 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      final double offset = _isLabelsOutside
          ? showLabels
              ? (_actualLabelOffset +
                  math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset =
            _radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = _radius -
            (axisLineWidth +
                _actualMinorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = _actualMinorTickLength > _actualMajorTickLength;
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = _radius + _actualTickOffset;
          tickEndOffset = _radius + _actualMinorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? _radius - offset
              : _radius -
                  (_maximumTickLength - _actualMinorTickLength + offset);
          tickEndOffset = _radius - (_maximumTickLength + offset);
        }
      }

      _calculateOffsetForMinorTicks(tickStartOffset, tickEndOffset);
    }
  }

  /// Calculates the offset for minor ticks
  ///
  /// This method is quite a long method. This method could be refactored into
  /// the smaller method but it leads to passing more number of parameter and
  /// which degrades the performance
  void _calculateOffsetForMinorTicks(
      double tickStartOffset, double tickEndOffset) {
    _minorTickOffsets = <TickOffset>[];
    double angularSpaceForTicks;
    double totalMinorTicks;
    if (_actualInterval != null) {
      final double majorTicksInterval = (maximum - minimum) / _actualInterval!;
      angularSpaceForTicks =
          getDegreeToRadian(_sweepAngle / majorTicksInterval);
      final double maximumLabelValue =
          _axisLabels![_axisLabels!.length - 2].value.toDouble();
      int remainingTicks;
      final double difference = maximum - maximumLabelValue;
      if (difference == _actualInterval) {
        remainingTicks = 0;
      } else {
        final double minorTickInterval =
            (_actualInterval! / 2) / minorTicksPerInterval;
        remainingTicks = difference ~/ minorTickInterval;
      }

      final int labelLength = difference == _actualInterval
          ? _axisLabels!.length - 1
          : _axisLabels!.length - 2;
      totalMinorTicks = (labelLength * minorTicksPerInterval) + remainingTicks;
    } else {
      angularSpaceForTicks =
          getDegreeToRadian(_sweepAngle / (_majorTicksCount - 1));
      totalMinorTicks = (_axisLabels!.length - 1) * minorTicksPerInterval;
    }

    double angleForTicks = isInversed
        ? getDegreeToRadian(startAngle + _sweepAngle - 90)
        : getDegreeToRadian(startAngle - 90);

    const num minorTickIndex = 1; // Since the minor tick rendering
    // needs to be start in the index one
    final double minorTickAngle =
        angularSpaceForTicks / (minorTicksPerInterval + 1);

    for (num i = minorTickIndex; i <= totalMinorTicks; i++) {
      if (isInversed) {
        angleForTicks -= minorTickAngle;
      } else {
        angleForTicks += minorTickAngle;
      }

      final double factor = (isInversed
              ? getRadianToDegree(angleForTicks) +
                  90 -
                  (startAngle + _sweepAngle)
              : (getRadianToDegree(angleForTicks) + 90 - startAngle)) /
          _sweepAngle;

      final double tickFactor = (renderer != null)
          ? renderer!.factorToValue(factor) ?? factorToValue(factor)
          : factorToValue(factor);
      final double tickValue = double.parse(tickFactor.toStringAsFixed(5));
      if (tickValue <= maximum && tickValue >= minimum) {
        if (tickValue == maximum) {
          angleForTicks = _getTickPositionInCorner(
              i, angleForTicks, tickStartOffset, false);
        }
        final List<Offset> tickPosition =
            _getTickPosition(tickStartOffset, tickEndOffset, angleForTicks);
        final TickOffset tickOffset = TickOffset();
        tickOffset.startPoint = tickPosition[0];
        tickOffset.endPoint = tickPosition[1];
        tickOffset.value = tickValue;

        final Offset centerPoint =
            !canScaleToFit ? Offset(_centerXPoint, _centerYPoint) : Offset.zero;
        tickOffset.startPoint = Offset(
            tickOffset.startPoint.dx - centerPoint.dx,
            tickOffset.startPoint.dy - centerPoint.dy);
        tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
            tickOffset.endPoint.dy - centerPoint.dy);
        _minorTickOffsets.add(tickOffset);
        if (i % minorTicksPerInterval == 0) {
          if (isInversed) {
            angleForTicks -= minorTickAngle;
          } else {
            angleForTicks += minorTickAngle;
          }
        }
      }
    }
  }

  /// Calculate the axis label position.
  void _calculateAxisLabelsPosition() {
    if (_axisLabels != null && _axisLabels!.isNotEmpty) {
      // Calculates the angle between each  axis label
      double labelsInterval;
      if (_actualInterval != null) {
        labelsInterval = (maximum - minimum) / _actualInterval!;
      } else {
        labelsInterval = (_axisLabels!.length - 1).toDouble();
      }
      final double labelSpaceInAngle = _sweepAngle / labelsInterval;
      final double labelSpaceInRadian = getDegreeToRadian(labelSpaceInAngle);
      final double tickLength = _actualMajorTickLength > _actualMinorTickLength
          ? _actualMajorTickLength
          : _actualMinorTickLength;
      final double tickPadding = showTicks ? tickLength + _actualTickOffset : 0;
      double labelRadian = 0;
      double labelAngle = 0;
      double labelPosition = 0;
      if (!isInversed) {
        labelAngle = startAngle - 90;
        labelRadian = getDegreeToRadian(labelAngle);
      } else {
        labelAngle = startAngle + _sweepAngle - 90;
        labelRadian = getDegreeToRadian(labelAngle);
      }

      final double labelSize =
          math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2;
      if (_isLabelsOutside) {
        final double featureOffset = labelSize;
        labelPosition = _useAxisElementsInsideRadius
            ? _radius - featureOffset
            : _radius + tickPadding + _actualLabelOffset;
      } else {
        labelPosition =
            _radius - (_actualAxisWidth + tickPadding + _actualLabelOffset);
      }

      _calculateLabelPosition(labelPosition, labelRadian, labelAngle,
          labelSpaceInRadian, labelSpaceInAngle);
    }
  }

  // Method to calculate label position
  void _calculateLabelPosition(double labelPosition, double labelRadian,
      double labelAngle, double labelSpaceInRadian, double labelSpaceInAngle) {
    for (int i = 0; i < _axisLabels!.length; i++) {
      final CircularAxisLabel label = _axisLabels![i];
      label.angle = labelAngle;
      if (_isMaxiumValueIncluded && i == _axisLabels!.length - 1) {
        labelAngle =
            isInversed ? startAngle - 90 : startAngle + _sweepAngle - 90;
        label.value = maximum;
        label.angle = labelAngle;
        labelRadian = getDegreeToRadian(labelAngle);
      } else {
        final double coordinateValue = (isInversed
                ? labelAngle + 90 - (startAngle + _sweepAngle)
                : (labelAngle + 90 - startAngle)) /
            _sweepAngle;
        label.value = (renderer != null &&
                renderer!.factorToValue(coordinateValue) != null)
            ? renderer!.factorToValue(coordinateValue) ??
                factorToValue(coordinateValue)
            : factorToValue(coordinateValue);
      }

      if (!canScaleToFit) {
        final double x =
            ((size.width / 2) - (labelPosition * math.sin(labelRadian))) -
                _centerXPoint;
        final double y =
            ((size.height / 2) + (labelPosition * math.cos(labelRadian))) -
                _centerYPoint;
        label.position = Offset(x, y);
      } else {
        final double x =
            _axisCenter.dx - (labelPosition * math.sin(labelRadian));
        final double y =
            _axisCenter.dy + (labelPosition * math.cos(labelRadian));
        label.position = Offset(x, y);
      }

      if (!isInversed) {
        labelRadian += labelSpaceInRadian;
        labelAngle += labelSpaceInAngle;
      } else {
        labelRadian -= labelSpaceInRadian;
        labelAngle -= labelSpaceInAngle;
      }
    }
  }

  /// To find the maximum label size
  void _measureAxisLabels() {
    _maximumLabelSize = Size.zero;
    for (int i = 0; i < _axisLabels!.length; i++) {
      final CircularAxisLabel label = _axisLabels![i];
      label.labelSize = getTextSize(label.text, label.labelStyle);
      final double maxWidth = _maximumLabelSize.width < label.labelSize.width
          ? label.needsRotateLabel
              ? label.labelSize.height
              : label.labelSize.width
          : _maximumLabelSize.width;
      final double maxHeight = _maximumLabelSize.height < label.labelSize.height
          ? label.labelSize.height
          : _maximumLabelSize.height;

      _maximumLabelSize = Size(maxWidth, maxHeight);
    }
  }

  /// Gets the start and end offset of tick
  List<Offset> _getTickPosition(
      double tickStartOffset, double tickEndOffset, double angleForTicks) {
    final Offset centerPoint =
        !canScaleToFit ? Offset(size.width / 2, size.height / 2) : _axisCenter;
    final double tickStartX =
        centerPoint.dx - tickStartOffset * math.sin(angleForTicks);
    final double tickStartY =
        centerPoint.dy + tickStartOffset * math.cos(angleForTicks);
    final double tickStopX =
        centerPoint.dx + (1 - tickEndOffset) * math.sin(angleForTicks);
    final double tickStopY =
        centerPoint.dy - (1 - tickEndOffset) * math.cos(angleForTicks);
    final Offset startOffset = Offset(tickStartX, tickStartY);
    final Offset endOffset = Offset(tickStopX, tickStopY);
    return <Offset>[startOffset, endOffset];
  }

  ///Method to calculate teh sweep angle of axis
  double getAxisSweepAngle() {
    final double actualEndAngle = endAngle > 360 ? endAngle % 360 : endAngle;
    final double actualStartAngle =
        startAngle > 360 ? startAngle % 360 : startAngle;
    double totalAngle = actualEndAngle - actualStartAngle;
    totalAngle = totalAngle <= 0 ? (totalAngle + 360) : totalAngle;
    _sweepAngle = totalAngle;
    return _sweepAngle;
  }

  ///Calculates the axis width based on the coordinate unit
  double getActualValue(double? value, GaugeSizeUnit sizeUnit, bool isOffset) {
    double actualValue = 0;
    if (value != null) {
      switch (sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            if (!isOffset) {
              value = value < 0 ? 0 : value;
              value = value > 1 ? 1 : value;
            }

            actualValue = value * _radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
          break;
      }
    }

    return actualValue;
  }

  ///Calculates the maximum tick length
  double _getTickLength(bool isMajorTick) {
    if (isMajorTick) {
      return getActualValue(majorTickLength, majorTickLengthUnit, false);
    } else {
      return getActualValue(minorTickLength, minorTickLengthUnit, false);
    }
  }

  /// Calculates the interval of axis based on its range
  num _getNiceInterval() {
    if (interval != null) {
      return interval!;
    }

    return calculateAxisInterval(maximumLabels);
  }

  /// To calculate the axis label based on the maximum axis label
  num calculateAxisInterval(int actualMaximumValue) {
    final num delta = _getAxisRange();
    final num circumference = 2 * math.pi * _center * (_sweepAngle / 360);
    final num desiredIntervalCount =
        math.max(circumference * ((0.533 * actualMaximumValue) / 100), 1);
    num niceInterval = delta / desiredIntervalCount;
    final num minimumInterval =
        math.pow(10, (math.log(niceInterval) / math.log(10)).floor());
    final List<double> intervalDivisions = <double>[10, 5, 2, 1];
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num currentInterval = minimumInterval * intervalDivisions[i];
      if (desiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }

    return niceInterval;
  }

  /// Update the background image
  void _updateBackgroundImage(ImageInfo? imageInfo, bool synchronousCall) {
    if (imageInfo?.image != null) {
      _backgroundImageInfo = imageInfo;
      markNeedsPaint();
    }
  }

  /// Gets the current axis labels
  CircularAxisLabel _getAxisLabel(num i) {
    num value = i;
    String labelText = value.toString();
    final List<String> list = labelText.split('.');
    value = double.parse(value.toStringAsFixed(3));
    if (list.isNotEmpty &&
        list.length > 1 &&
        (list[1] == '0' || list[1] == '00' || list[1] == '000')) {
      value = value.round();
    }

    labelText = value.toString();

    if (numberFormat != null) {
      labelText = numberFormat!.format(value);
    }
    if (labelFormat != null) {
      labelText = labelFormat!.replaceAll(RegExp('{value}'), labelText);
    }

    AxisLabelCreatedArgs? labelCreatedArgs;
    GaugeTextStyle? argsLabelStyle;
    if (onLabelCreated != null) {
      labelCreatedArgs = AxisLabelCreatedArgs();
      labelCreatedArgs.text = labelText;
      onLabelCreated!(labelCreatedArgs);

      labelText = labelCreatedArgs.text;
      argsLabelStyle = labelCreatedArgs.labelStyle;
    }

    final GaugeTextStyle labelStyle = argsLabelStyle ?? gaugeTextStyle;
    final CircularAxisLabel label = CircularAxisLabel(
        labelStyle,
        labelText,
        i,
        labelCreatedArgs != null &&
            labelCreatedArgs.canRotate != null &&
            labelCreatedArgs.canRotate!);
    label.value = value;
    return label;
  }

  /// Returns the axis range
  num _getAxisRange() {
    return maximum - minimum;
  }

  /// Calculates the visible labels based on axis interval and range
  List<CircularAxisLabel>? generateVisibleLabels() {
    _isMaxiumValueIncluded = false;
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    _actualInterval = _getNiceInterval();
    for (num i = minimum; i <= maximum; i += _actualInterval!) {
      final CircularAxisLabel currentLabel = _getAxisLabel(i);
      visibleLabels.add(currentLabel);
    }

    final CircularAxisLabel label = visibleLabels[visibleLabels.length - 1];
    if (label.value != maximum && label.value < maximum) {
      _isMaxiumValueIncluded = true;
      final CircularAxisLabel currentLabel = _getAxisLabel(maximum);
      visibleLabels.add(currentLabel);
    }

    return visibleLabels;
  }

  /// Converts the axis value to factor based on angle.
  double valueToFactor(double value) {
    final double angle = _valueToAngle(value);
    return angle / _sweepAngle;
  }

  /// Converts the factor value to axis value.
  double factorToValue(double factor) {
    final double angle = isInversed
        ? (factor * _sweepAngle) + startAngle + _sweepAngle
        : (factor * _sweepAngle) + startAngle;

    return _angleToValue(angle);
  }

  /// Method to draw the axis line.
  void _drawAxisLine(Canvas canvas) {
    // whether the dash array is enabled for axis.
    final bool isDashedAxisLine = _getIsDashedLine();
    SweepGradient? gradient;
    if (axisLineGradient != null && axisLineGradient!.colors.isNotEmpty) {
      gradient = SweepGradient(
          stops: calculateGradientStops(
              _getGradientOffset(), isInversed, _sweepAngle),
          colors: isInversed
              ? axisLineGradient!.colors.reversed.toList()
              : axisLineGradient!.colors);
    }
    if (axisLineCornerStyle == CornerStyle.bothFlat || isDashedAxisLine) {
      _drawAxisPath(
          canvas, _startRadian, _endRadian, gradient, isDashedAxisLine);
    } else {
      _drawAxisPath(canvas, _startCornerRadian, _sweepCornerRadian, gradient,
          isDashedAxisLine);
    }
  }

  /// Returns the gradient stop of axis line gradient.
  List<double?> _getGradientOffset() {
    if (axisLineGradient!.stops != null &&
        axisLineGradient!.stops!.isNotEmpty) {
      return axisLineGradient!.stops!;
    } else {
      // Calculates the gradient stop values based on the provided color
      final double difference = 1 / axisLineGradient!.colors.length;
      final List<double?> offsets =
          List<double?>.filled(axisLineGradient!.colors.length, null);
      for (int i = 0; i < axisLineGradient!.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  /// Method to draw axis line.
  void _drawAxisPath(Canvas canvas, double startRadian, double endRadian,
      SweepGradient? gradient, bool isDashedAxisLine) {
    if (_axisLineAnimation != null) {
      endRadian = endRadian * _axisLineAnimation!.value;
    }

    canvas.save();
    canvas.translate(_axisCenter.dx, _axisCenter.dy);
    canvas.rotate(isInversed
        ? getDegreeToRadian(startAngle + _sweepAngle)
        : getDegreeToRadian(startAngle));

    Path path = Path();
    //whether the style of paint is fill.
    bool isFill = false;
    if (axisLineCornerStyle != CornerStyle.bothFlat) {
      if (isDashedAxisLine) {
        path = _getPath(endRadian, isFill);
      } else {
        isFill = true;
        final double outerRadius = _radius - _axisOffset;
        final double innerRadius = outerRadius - _actualAxisWidth;

        // Adds the rounded corner at start of axis line.
        if (_axisLineCornerStyle == CornerStyle.startCurve ||
            _axisLineCornerStyle == CornerStyle.bothCurve) {
          _drawStartCurve(path, endRadian, innerRadius, outerRadius);
        }

        path.addArc(Rect.fromCircle(center: Offset.zero, radius: outerRadius),
            _startCornerRadian, endRadian);

        // Adds the rounded corner at end of axis line.
        if (axisLineCornerStyle == CornerStyle.endCurve ||
            axisLineCornerStyle == CornerStyle.bothCurve) {
          _drawEndCurve(path, endRadian, innerRadius, outerRadius);
        }
        path.arcTo(Rect.fromCircle(center: Offset.zero, radius: innerRadius),
            endRadian + _startCornerRadian, -endRadian, false);
      }
    } else {
      path = _getPath(endRadian, isFill);
    }

    _renderPath(isDashedAxisLine, path, canvas, gradient, isFill);
  }

  // Method to render the path.
  void _renderPath(bool isDashedAxisLine, Path path, Canvas canvas,
      SweepGradient? gradient, bool isFill) {
    final Paint paint = _getPaint(gradient, isFill);
    if (!isDashedAxisLine) {
      canvas.drawPath(path, paint);
    } else {
      if (axisLineDashArray != null) {
        canvas.drawPath(
            dashPath(path,
                dashArray: CircularIntervalList<double>(axisLineDashArray!)),
            paint);
      }
    }

    canvas.restore();
  }

  /// Returns the axis path
  Path _getPath(double endRadian, bool isFill) {
    final Path path = Path();
    isFill = false;
    if (isInversed) {
      endRadian = endRadian * -1;
    }

    path.addArc(_axisRect, 0, endRadian);
    return path;
  }

  Paint _getPaint(
    SweepGradient? gradient,
    bool isFill,
  ) {
    final Paint paint = Paint()
      ..color = axisLineColor ??
          _gaugeThemeData.axisLineColor ??
          colorScheme.onSurface[35]!
      ..style = !isFill ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = _actualAxisWidth;
    if (gradient != null) {
      paint.shader = gradient.createShader(_axisRect);
    }

    return paint;
  }

  /// Draws the start corner style
  void _drawStartCurve(
      Path path, double endRadian, double innerRadius, double outerRadius) {
    final Offset midPoint = getDegreeToPoint(
        isInversed ? -_cornerAngle : _cornerAngle,
        (innerRadius + outerRadius) / 2,
        Offset.zero);
    final double midStartAngle = getDegreeToRadian(180);

    double midEndAngle = midStartAngle + getDegreeToRadian(180);
    midEndAngle = isInversed ? -midEndAngle : midEndAngle;
    path.addArc(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle);
  }

  ///Draws the end corner curve
  void _drawEndCurve(
      Path path, double sweepRadian, double innerRadius, double outerRadius) {
    final double curveCornerAngle =
        axisLineCornerStyle == CornerStyle.bothCurve ? _cornerAngle : 0;
    final double angle = isInversed
        ? getRadianToDegree(sweepRadian) - curveCornerAngle
        : getRadianToDegree(sweepRadian) + curveCornerAngle;
    final Offset midPoint =
        getDegreeToPoint(angle, (innerRadius + outerRadius) / 2, Offset.zero);

    final double midStartAngle = sweepRadian / 2;

    final double midEndAngle = isInversed
        ? midStartAngle - getDegreeToRadian(180)
        : midStartAngle + getDegreeToRadian(180);

    path.arcTo(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle,
        false);
  }

  /// Checks whether the axis line is dashed line
  bool _getIsDashedLine() {
    return axisLineDashArray != null &&
        axisLineDashArray!.isNotEmpty &&
        axisLineDashArray!.length > 1 &&
        axisLineDashArray![0] > 0 &&
        axisLineDashArray![1] > 0;
  }

  /// Returns the corresponding range color for the value
  Color? _getRangeColor(num value, SfGaugeThemeData gaugeThemeData) {
    Color? color;
    if (ranges != null && ranges!.isNotEmpty) {
      for (int i = 0; i < ranges!.length; i++) {
        if (ranges![i].startValue <= value.roundToDouble() &&
            ranges![i].endValue >= value.roundToDouble()) {
          color = ranges![i].color ??
              gaugeThemeData.rangeColor ??
              const Color(0xFFF67280);
          break;
        }
      }
    }
    return color;
  }

  /// Method to draw the major ticks
  void _drawMajorTicks(Canvas canvas, bool isDarkTheme) {
    double length = _majorTickOffsets.length.toDouble();
    final Color colorSchemeMajorTickColor = colorScheme.onSurface[46]!;
    if (_axisElementsAnimation != null) {
      length = _majorTickOffsets.length * _axisElementsAnimation!.value;
    }

    if (_actualMajorTickLength > 0 && majorTickThickness > 0) {
      final Paint tickPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = majorTickThickness;
      for (int i = 0; i < length; i++) {
        final TickOffset tickOffset = _majorTickOffsets[i];
        if (!(i == 0 && _sweepAngle == 360)) {
          tickPaint.color = useRangeColorForAxis
              ? _getRangeColor(tickOffset.value, _gaugeThemeData) ??
                  majorTickColor ??
                  _gaugeThemeData.majorTickColor ??
                  colorSchemeMajorTickColor
              : majorTickColor ??
                  _gaugeThemeData.majorTickColor ??
                  colorSchemeMajorTickColor;

          if (majorTickDashArray != null && majorTickDashArray!.isNotEmpty) {
            final Path path = Path()
              ..moveTo(tickOffset.startPoint.dx, tickOffset.startPoint.dy)
              ..lineTo(tickOffset.endPoint.dx, tickOffset.endPoint.dy);
            canvas.drawPath(
                dashPath(path,
                    dashArray:
                        CircularIntervalList<double>(majorTickDashArray!)),
                tickPaint);
          } else {
            if ((i == _majorTickOffsets.length - 1) && _sweepAngle == 360) {
              // Reposition the last tick when its sweep angle is 360
              final double x1 = (_majorTickOffsets[0].startPoint.dx +
                      _majorTickOffsets[i].startPoint.dx) /
                  2;
              final double y1 = (_majorTickOffsets[0].startPoint.dy +
                      _majorTickOffsets[i].startPoint.dy) /
                  2;
              final double x2 = (_majorTickOffsets[0].endPoint.dx +
                      _majorTickOffsets[i].endPoint.dx) /
                  2;
              final double y2 = (_majorTickOffsets[0].endPoint.dy +
                      _majorTickOffsets[i].endPoint.dy) /
                  2;
              canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
            } else {
              canvas.drawLine(
                  tickOffset.startPoint, tickOffset.endPoint, tickPaint);
            }
          }
        }
      }
    }
  }

  /// Method to draw the minor ticks.
  void _drawMinorTicks(Canvas canvas, bool isDarkTheme) {
    double length = _minorTickOffsets.length.toDouble();
    final Color colorSchemeMinorTickColor = colorScheme.onSurface[71]!;
    if (_axisElementsAnimation != null) {
      length = _minorTickOffsets.length * _axisElementsAnimation!.value;
    }
    if (_actualMinorTickLength > 0 && minorTickThickness > 0) {
      final Paint tickPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = minorTickThickness;
      for (int i = 0; i < length; i++) {
        final TickOffset tickOffset = _minorTickOffsets[i];
        tickPaint.color = useRangeColorForAxis
            ? _getRangeColor(tickOffset.value, _gaugeThemeData) ??
                minorTickColor ??
                _gaugeThemeData.minorTickColor ??
                colorSchemeMinorTickColor
            : minorTickColor ??
                _gaugeThemeData.minorTickColor ??
                colorSchemeMinorTickColor;
        if (minorTickDashArray != null && minorTickDashArray!.isNotEmpty) {
          final Path path = Path()
            ..moveTo(tickOffset.startPoint.dx, tickOffset.startPoint.dy)
            ..lineTo(tickOffset.endPoint.dx, tickOffset.endPoint.dy);
          canvas.drawPath(
              dashPath(path,
                  dashArray: CircularIntervalList<double>(minorTickDashArray!)),
              tickPaint);
        } else {
          canvas.drawLine(
              tickOffset.startPoint, tickOffset.endPoint, tickPaint);
        }
      }
    }
  }

  /// Method to draw the axis labels.
  void _drawAxisLabels(Canvas canvas, bool isDarkTheme) {
    double length = _axisLabels!.length.toDouble();
    if (_axisElementsAnimation != null) {
      length = _axisLabels!.length * _axisElementsAnimation!.value;
    }
    for (int i = 0; i < length; i++) {
      if (!((i == 0 && !showFirstLabel) ||
          (i == _axisLabels!.length - 1 && !showLastLabel))) {
        final CircularAxisLabel label = _axisLabels![i];
        final Color labelColor = label.labelStyle.color ??
            _gaugeThemeData.axisLabelTextStyle?.color ??
            _gaugeThemeData.axisLabelColor ??
            colorScheme.onSurface[184]!;
        final TextStyle axisLabelTextStyle =
            _themeData.textTheme.bodySmall!.copyWith(
          color: ranges != null && ranges!.isNotEmpty && useRangeColorForAxis
              ? _getRangeColor(label.value, _gaugeThemeData) ?? labelColor
              : labelColor,
          fontSize: label.labelStyle.fontSize ??
              _gaugeThemeData.axisLabelTextStyle?.fontSize,
          fontFamily: label.labelStyle.fontFamily ??
              _gaugeThemeData.axisLabelTextStyle?.fontFamily,
          fontStyle: label.labelStyle.fontStyle ??
              _gaugeThemeData.axisLabelTextStyle?.fontStyle,
          fontWeight: label.labelStyle.fontWeight ??
              _gaugeThemeData.axisLabelTextStyle?.fontWeight,
        );

        final TextSpan span =
            TextSpan(text: label.text, style: axisLabelTextStyle);

        final TextPainter textPainter = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center);

        textPainter.layout();
        _renderText(canvas, textPainter, label);
      }
    }
  }

  // Methods to render the range label.
  void _renderText(
      Canvas canvas, TextPainter textPainter, CircularAxisLabel label) {
    if (canRotateLabels || label.needsRotateLabel) {
      canvas.save();
      canvas.translate(label.position.dx, label.position.dy);
      // Rotates the labels to its calculated angle.
      canvas.rotate(getDegreeToRadian(label.angle));
      canvas.scale(-1);
      textPainter.paint(canvas,
          Offset(-label.labelSize.width / 2, -label.labelSize.height / 2));
      canvas.restore();
    } else {
      textPainter.paint(
          canvas,
          Offset(label.position.dx - label.labelSize.width / 2,
              label.position.dy - label.labelSize.height / 2));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final bool isDarkTheme = _themeData.brightness == Brightness.dark;
    _calculateAxisElementsPosition();
    if (backgroundImage != null && _backgroundImageInfo != null) {
      Rect rect;
      if (!canScaleToFit) {
        final double radius = math.min(size.width, size.height) / 2;
        rect = Rect.fromLTRB(
            size.width / 2 - radius - _centerXPoint,
            size.height / 2 - radius - _centerYPoint,
            size.width / 2 + radius - _centerXPoint,
            size.height / 2 + radius - _centerYPoint);
      } else {
        rect = Rect.fromLTRB(_axisCenter.dx - _radius, _axisCenter.dy - _radius,
            _axisCenter.dx + _radius, _axisCenter.dx + _radius);
      }

      // Draws the background image of axis
      paintImage(
        canvas: canvas,
        rect: rect,
        scale: _backgroundImageInfo!.scale,
        image: _backgroundImageInfo!.image,
        fit: BoxFit.fill,
      );
    }

    if (showAxisLine && _actualAxisWidth > 0) {
      _drawAxisLine(canvas);
    }

    if (showTicks) {
      _drawMajorTicks(canvas, isDarkTheme);
      _drawMinorTicks(canvas, isDarkTheme);
    }

    if (showLabels) {
      _drawAxisLabels(canvas, isDarkTheme);
    }
  }
}
