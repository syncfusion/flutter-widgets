import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_legend.dart';
import '../common/core_tooltip.dart';
import '../common/legend.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';

/// Renders the chart trendline.
///
/// A trendline is a straight line that connects two or more price points
/// and then extends into the future to act as a line of support.
/// Trendlines provide support for forward and backward forecasting.
///
/// Provides option to customize the trendline types, [width], [forwardForecast]
/// and [backwardForecast].
class Trendline {
  /// Creating an argument constructor of Trendline class.
  Trendline({
    this.enableTooltip = true,
    this.intercept,
    this.name,
    this.dashArray,
    this.color = Colors.blue,
    this.type = TrendlineType.linear,
    this.backwardForecast = 0,
    this.forwardForecast = 0,
    this.opacity = 1,
    this.isVisible = true,
    this.width = 2,
    this.animationDuration = 1500,
    this.animationDelay = 0,
    this.valueField = 'high',
    this.isVisibleInLegend = true,
    this.legendIconType = LegendIconType.horizontalLine,
    this.markerSettings = const MarkerSettings(),
    this.polynomialOrder = 2,
    this.period = 2,
    this.onRenderDetailsUpdate,
  });

  /// Determines the animation time of trendline.
  ///
  /// Defaults to `1500 `.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(animationDuration: 150)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double animationDuration;

  /// Delay duration of the trendline animation.
  /// It takes a millisecond value as input.
  /// By default,the trendline will get animated for the specified duration.
  /// If animationDelay is specified, then the trendline will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to '0'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(animationDelay: 500)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double? animationDelay;

  /// Specifies the backward forecasting of trendlines.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(backwardForecast: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double backwardForecast;

  /// Specifies the forward forecasting of trendlines.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(forwardForecast: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double forwardForecast;

  /// Width of trendlines.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(width: 4)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double width;

  /// Opacity of the trendline.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(opacity: 0.85)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double opacity;

  /// Pattern of dashes and gaps used to stroke the trendline.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(dashArray: <double>[2,3])
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final List<double>? dashArray;

  /// Enables the tooltip for trendlines.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(enableTooltip: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool enableTooltip;

  /// Color of the trendline.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(color: Colors.greenAccent)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final Color color;

  /// Provides the name for trendline.
  ///
  /// Defaults to `type` of the trendline chosen.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(name: 'Trendline1')
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final String? name;

  /// Specifies the intercept value of the trendlines.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(intercept: 20)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double? intercept;

  /// Determines the visibility of the trendline.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(isVisible: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Specifies the type of legend icon for trendline.
  ///
  /// Defaults to `LegendIconType.HorizontalLine`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(legendIconType: LegendIconType.circle)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final LegendIconType legendIconType;

  /// Specifies the intercept value of the trendlines.
  ///
  /// Defaults to `TrendlineType.linear`.
  ///
  /// Also refer [TrendlineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(type: TrendlineType.power)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final TrendlineType type;

  /// To choose the valueField(low or high) to render the trendline.
  ///
  /// Defaults to `high`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(valueField: 'low')
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final String valueField;

  /// Settings to configure the marker of trendline.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(
  ///             markerSettings: MarkerSettings(isVisible: true)
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final MarkerSettings markerSettings;

  /// Show/hides the legend for trendline.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(isVisibleInLegend: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool isVisibleInLegend;

  /// Specifies the order of the polynomial for polynomial trendline.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(
  ///             type: TrendlineType.polynomial,
  ///             polynomialOrder: 4
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final int polynomialOrder;

  /// Specifies the period for moving average trendline.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(period: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final int period;

  /// Callback which gets called while rendering the trendline.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <Trendline>[
  ///           Trendline(
  ///             onRenderDetailsUpdate: (TrendlineRenderParams args) {
  ///               print('Slope value: ' + args.slope![0].toString());
  ///               print('r-squared value: ' + args.rSquaredValue.toString());
  ///               print('Intercept value (x): ' + args.intercept.toString());
  ///             }
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final ChartTrendlineRenderCallback? onRenderDetailsUpdate;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is Trendline &&
        other.enableTooltip == enableTooltip &&
        other.intercept == intercept &&
        other.name == name &&
        other.dashArray == dashArray &&
        other.color == color &&
        other.type == type &&
        other.backwardForecast == backwardForecast &&
        other.forwardForecast == forwardForecast &&
        other.opacity == opacity &&
        other.isVisible == isVisible &&
        other.width == width &&
        other.animationDuration == animationDuration &&
        other.valueField == valueField &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.markerSettings == markerSettings &&
        other.polynomialOrder == polynomialOrder &&
        other.period == period;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      enableTooltip,
      intercept,
      name,
      dashArray,
      color,
      type,
      backwardForecast,
      forwardForecast,
      opacity,
      isVisible,
      width,
      animationDuration,
      valueField,
      isVisibleInLegend,
      legendIconType,
      markerSettings,
      polynomialOrder,
      period
    ];
    return Object.hashAll(values);
  }
}

class TrendlineContainer extends StatefulWidget {
  const TrendlineContainer({
    super.key,
    required this.trendlines,
  });

  final List<Trendline> trendlines;

  @override
  State<TrendlineContainer> createState() => _TrendlineContainerState();
}

class _TrendlineContainerState extends State<TrendlineContainer> {
  @override
  Widget build(BuildContext context) {
    return TrendlineStack(
      children: List<Widget>.generate(
        widget.trendlines.length,
        (int index) {
          final Trendline trendline = widget.trendlines[index];
          return TrendlineWidget(
            index: index,
            isVisible: trendline.isVisible,
            name: trendline.name,
            color: trendline.color,
            dashArray: trendline.dashArray,
            opacity: trendline.opacity,
            width: trendline.width,
            type: trendline.type,
            valueField: trendline.valueField,
            period: trendline.period,
            intercept: trendline.intercept,
            polynomialOrder: trendline.polynomialOrder,
            backwardForecast: trendline.backwardForecast,
            forwardForecast: trendline.forwardForecast,
            isVisibleInLegend: trendline.isVisibleInLegend,
            legendIconType: trendline.legendIconType,
            markerSettings: trendline.markerSettings,
            onRenderDetailsUpdate: trendline.onRenderDetailsUpdate,
          );
        },
      ),
    );
  }
}

class TrendlineStack extends MultiChildRenderObjectWidget {
  const TrendlineStack({super.key, super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTrendlineStack();
  }
}

class TrendlineParentData extends ContainerBoxParentData<TrendlineRenderer> {}

class RenderTrendlineStack extends RenderBox
    with
        ContainerRenderObjectMixin<TrendlineRenderer, TrendlineParentData>,
        RenderBoxContainerDefaultsMixin<TrendlineRenderer,
            TrendlineParentData> {
  CartesianSeriesRenderer? renderer;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    RenderBox? child = lastChild;
    while (child != null) {
      final TrendlineParentData childParentData =
          child.parentData! as TrendlineParentData;
      final bool isChildHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      isHit = isHit || isChildHit;
      child = childParentData.previousSibling;
    }

    return isHit;
  }

  void handlePointerHover(Offset localPosition) {
    TrendlineRenderer? child = lastChild;
    while (child != null) {
      if (child.enableTooltip &&
          renderer != null &&
          renderer!.parent != null &&
          renderer!.parent!.tooltipBehavior != null) {
        child.handlePointerHover(localPosition);
      }
      child = childBefore(child);
    }
  }

  void setXAxis(RenderChartAxis? value) {
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      child._xAxis = value;
      child = childAfter(child);
    }
  }

  void setYAxis(RenderChartAxis? value) {
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      child._yAxis = value;
      child = childAfter(child);
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! TrendlineParentData) {
      child.parentData = TrendlineParentData();
    }
  }

  void performUpdate(CartesianSeriesRenderer renderer) {
    this.renderer = renderer;
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      child.series = renderer;
      child.performUpdate();
      child = childAfter(child);
    }
  }

  DoubleRange range(RenderChartAxis axis, DoubleRange actualRange) {
    num minimum = actualRange.minimum;
    num maximum = actualRange.maximum;

    TrendlineRenderer? child = firstChild;
    while (child != null && !child.isToggled) {
      final DoubleRange current = child.range(axis);
      minimum = min(minimum, current.minimum);
      maximum = max(maximum, current.maximum);
      child = childAfter(child);
    }
    return DoubleRange(minimum, maximum);
  }

  List<LegendItem>? buildLegendItems(
      int seriesIndex, LegendItemProvider provider) {
    final List<LegendItem> legendItems = <LegendItem>[];
    const int trendlineIndex = 0;
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      final List<LegendItem>? items =
          child.buildLegendItems(trendlineIndex, provider);
      if (items != null) {
        legendItems.addAll(items);
      }
      child = childAfter(child);
    }
    return legendItems;
  }

  void updateLegendState(LegendItem seriesItem, bool seriesVisibility) {
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      child._updateLegendBasedOnSeries(seriesVisibility);
      child = childAfter(child);
    }
  }

  void populateDataSource(
    List<num> seriesXValues, {
    List<num>? seriesYValues,
    List<num>? seriesHighValues,
    List<num>? seriesLowValues,
  }) {
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      final String valueField = child.valueField!;
      List<num> currentYValues;
      if (valueField == 'low' && seriesLowValues != null) {
        currentYValues = seriesLowValues;
      } else if (valueField == 'high' && seriesHighValues != null) {
        currentYValues = seriesHighValues;
      } else if (seriesYValues != null) {
        currentYValues = seriesYValues;
      } else {
        currentYValues = <num>[];
      }
      child.populateDataSource(seriesXValues, currentYValues);
      child = childAfter(child);
    }
  }

  @override
  void performLayout() {
    TrendlineRenderer? child = firstChild;
    while (child != null) {
      child.layout(constraints);
      child = childAfter(child);
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class TrendlineWidget extends LeafRenderObjectWidget {
  const TrendlineWidget({
    super.key,
    required this.index,
    required this.isVisible,
    required this.name,
    required this.dashArray,
    required this.color,
    required this.opacity,
    required this.width,
    required this.isVisibleInLegend,
    required this.legendIconType,
    required this.type,
    required this.valueField,
    required this.intercept,
    required this.period,
    required this.polynomialOrder,
    required this.backwardForecast,
    required this.forwardForecast,
    required this.markerSettings,
    this.animationDuration,
    this.animationDelay,
    this.onRenderDetailsUpdate,
  });

  final int index;
  final bool isVisible;
  final String? name;
  final Color color;
  final double opacity;
  final List<double>? dashArray;
  final double width;
  final String valueField;
  final LegendIconType legendIconType;
  final TrendlineType type;
  final MarkerSettings markerSettings;
  final bool isVisibleInLegend;
  final int period;
  final int polynomialOrder;
  final double? intercept;
  final double forwardForecast;
  final double backwardForecast;
  final double? animationDuration;
  final double? animationDelay;
  final ChartTrendlineRenderCallback? onRenderDetailsUpdate;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TrendlineRenderer()
      ..index = index
      ..isVisible = isVisible
      ..name = name
      ..color = color
      ..width = width
      ..dashArray = dashArray
      ..opacity = opacity
      ..isVisibleInLegend = isVisibleInLegend
      ..legendIconType = legendIconType
      ..type = type
      ..period = period
      ..intercept = intercept
      ..valueField = valueField
      ..forwardForecast = forwardForecast
      ..backwardForecast = backwardForecast
      ..polynomialOrder = polynomialOrder
      ..markerSettings = markerSettings
      ..animationDelay = animationDelay
      ..animationDuration = animationDuration
      ..onRenderDetailsUpdate = onRenderDetailsUpdate;
  }

  @override
  void updateRenderObject(
      BuildContext context, TrendlineRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isVisible = isVisible
      ..name = name
      ..color = color
      ..width = width
      ..dashArray = dashArray
      ..opacity = opacity
      ..isVisibleInLegend = isVisibleInLegend
      ..legendIconType = legendIconType
      ..type = type
      ..period = period
      ..intercept = intercept
      ..valueField = valueField
      ..forwardForecast = forwardForecast
      ..backwardForecast = backwardForecast
      ..polynomialOrder = polynomialOrder
      ..markerSettings = markerSettings
      ..animationDelay = animationDelay
      ..animationDuration = animationDuration
      ..onRenderDetailsUpdate = onRenderDetailsUpdate;
  }
}

class TrendlineRenderer extends RenderBox {
  TrendlineRenderer();

  ChartLegendItem? _legendItem;

  int get index => _index;
  int _index = -1;
  set index(int value) {
    if (_index != value) {
      _index = value;
    }
  }

  bool get isVisible => _isVisible;
  bool _isVisible = true;
  set isVisible(bool value) {
    if (_isVisible != value) {
      _isVisible = value;
      isToggled = !value;
    }
  }

  bool get isToggled => _isToggled;
  bool _isToggled = false;
  set isToggled(bool value) {
    if (_isToggled != value) {
      _isToggled = value;
      series?.markNeedsUpdate();
    }
  }

  String? get name => _name;
  String? _name;
  set name(String? value) {
    if (_name != value) {
      _name = value;
      series?.markNeedsLegendUpdate();
    }
  }

  double get width => _width;
  double _width = 2;
  set width(double value) {
    if (value != _width) {
      _width = value;
      markNeedsPaint();
    }
  }

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  double get opacity => _opacity;
  double _opacity = 1.0;
  set opacity(double value) {
    if (_opacity != value) {
      _opacity = value;
      markNeedsPaint();
    }
  }

  List<double>? get dashArray => _dashArray;
  List<double>? _dashArray;
  set dashArray(List<double>? value) {
    if (_dashArray != value) {
      _dashArray = value;
      markNeedsPaint();
    }
  }

  bool get enableTooltip => _enableTooltip;
  bool _enableTooltip = true;
  set enableTooltip(bool value) {
    if (_enableTooltip != value) {
      _enableTooltip = value;
    }
  }

  double? get animationDuration => _animationDuration;
  double? _animationDuration = 0.0;
  set animationDuration(double? value) {
    if (_animationDuration != value) {
      _animationDuration = value;
    }
  }

  double? get animationDelay => _animationDelay;
  double? _animationDelay = 0.0;
  set animationDelay(double? value) {
    if (_animationDelay != value) {
      _animationDelay = value;
    }
  }

  bool get isVisibleInLegend => _isVisibleInLegend;
  bool _isVisibleInLegend = true;
  set isVisibleInLegend(bool value) {
    if (_isVisibleInLegend != value) {
      _isVisibleInLegend = value;
      if (series != null) {
        series!.markNeedsLegendUpdate();
      }
    }
  }

  LegendIconType get legendIconType => _legendIconType;
  LegendIconType _legendIconType = LegendIconType.horizontalLine;
  set legendIconType(LegendIconType value) {
    if (_legendIconType != value) {
      _legendIconType = value;
      series?.markNeedsLegendUpdate();
    }
  }

  TrendlineType get type => _type;
  TrendlineType _type = TrendlineType.linear;
  set type(TrendlineType value) {
    if (_type != value) {
      _type = value;
      markNeedsLayout();
    }
  }

  double get backwardForecast => _backwardForecast;
  double _backwardForecast = 0;
  set backwardForecast(double value) {
    if (_backwardForecast != value) {
      _backwardForecast = value;
      markNeedsLayout();
    }
  }

  double get forwardForecast => _forwardForecast;
  double _forwardForecast = 0;
  set forwardForecast(double value) {
    if (_forwardForecast != value) {
      _forwardForecast = value;
      markNeedsLayout();
    }
  }

  String? get valueField => _valueField;
  String? _valueField = 'high';
  set valueField(String? value) {
    if (_valueField != value) {
      _valueField = value;
      markNeedsLayout();
    }
  }

  int get period => _period;
  int _period = 2;
  set period(int value) {
    if (_period != value) {
      _period = value;
      markNeedsLayout();
    }
  }

  int get polynomialOrder => _polynomialOrder;
  int _polynomialOrder = 2;
  set polynomialOrder(int value) {
    if (_polynomialOrder != value) {
      if (value >= 2 && value <= 6) {
        _polynomialOrder = value;
        markNeedsLayout();
      }
    }
  }

  double? get intercept => _intercept;
  double? _intercept;
  set intercept(double? value) {
    if (intercept != value) {
      intercept = value;
      markNeedsLayout();
    }
  }

  MarkerSettings get markerSettings => _markerSettings;
  MarkerSettings _markerSettings = const MarkerSettings();
  set markerSettings(MarkerSettings value) {
    if (_markerSettings != value) {
      _markerSettings = value;
      markNeedsLayout();
    }
  }

  ChartTrendlineRenderCallback? onRenderDetailsUpdate;

  DoubleRange xRange = DoubleRange(double.infinity, double.negativeInfinity);
  DoubleRange yRange = DoubleRange(double.infinity, double.negativeInfinity);

  final List<Offset> _points = <Offset>[];

  final Path _path = Path();
  final List<ChartMarker> _markers = <ChartMarker>[];
  CartesianSeriesRenderer? series;
  List<num> trendlineXValues = <num>[];
  List<num> trendlineYValues = <num>[];
  List<int> trendSegmentIndexes = <int>[];

  RenderChartAxis? get xAxis => _xAxis;
  RenderChartAxis? _xAxis;

  RenderChartAxis? get yAxis => _yAxis;
  RenderChartAxis? _yAxis;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return enableTooltip;
  }

  void handlePointerHover(Offset localPosition) {
    final int nearestPointIndex = _nearestPointIndex(localPosition);
    if (nearestPointIndex != -1) {
      final TooltipInfo? info = tooltipInfo(pointIndex: nearestPointIndex);
      if (info != null) {
        series!.parent!.behaviorArea!.raiseTooltip(info);
      }
    }
  }

  int _nearestPointIndex(Offset position) {
    if (_points.isNotEmpty) {
      for (final int segmentIndex in trendSegmentIndexes) {
        final ChartMarker marker = series!.markerAt(segmentIndex);
        if (tooltipTouchBounds(
                _points[segmentIndex], marker.width, marker.height)
            .contains(position)) {
          return segmentIndex;
        }
      }
    }
    return -1;
  }

  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    for (final int segmentIndex in trendSegmentIndexes) {
      pointIndex ??= segmentIndex;
      final CartesianChartPoint<dynamic> chartPoint = _chartPoint(pointIndex);
      final ChartMarker marker =
          _markers.isNotEmpty ? _markers[pointIndex] : ChartMarker();
      final double markerHeight =
          markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = _points[pointIndex];
      return TrendlineTooltipInfo(
        primaryPosition:
            localToGlobal(preferredPos.translate(0, -markerHeight)),
        secondaryPosition:
            localToGlobal(preferredPos.translate(0, markerHeight)),
        text: series!.tooltipText(chartPoint),
        header: series!.parent!.tooltipBehavior!.shared
            ? series!.tooltipHeaderText(chartPoint)
            : series!.name,
        data: series!.dataSource![pointIndex],
        point: chartPoint,
        series: series!.widget,
        renderer: series!,
        seriesIndex: series!.index,
        segmentIndex: segmentIndex,
        pointIndex: pointIndex,
        markerColors: <Color?>[color],
        markerType: marker.type,
      );
    }
    return null;
  }

  CartesianChartPoint _chartPoint(int pointIndex) {
    final num xValue = trendlineXValues[pointIndex];
    return CartesianChartPoint(
      x: _xRawValue(xValue),
      xValue: xValue,
      y: trendlineYValues[pointIndex],
    );
  }

  dynamic _xRawValue(num value) {
    if (xAxis is RenderDateTimeAxis) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    } else if (xAxis is RenderCategoryAxis ||
        xAxis is RenderDateTimeCategoryAxis) {
      if (series != null && series!.xRawValues.isNotEmpty) {
        return series!.xRawValues[value.toInt()];
      }
    }
    return value;
  }

  DoubleRange range(RenderChartAxis axis) {
    if (axis == xAxis) {
      return xRange;
    } else {
      return yRange;
    }
  }

  void performUpdate() {
    markNeedsLayout();
  }

  void _calculateLinearPoints(
    List<num> seriesXValues,
    List<num> seriesYValues,
    List<num> sortedXValues,
    _SlopeIntercept slopeIntercept,
    _SlopeIntercept slopeInterceptData,
    Function(int, num) slopeValue,
    Function(num, double) forecastValue,
    List<num> slopeInterceptXValues,
    List<num> linearYValues,
  ) {
    final int length = seriesXValues.length;
    linearYValues.addAll(seriesYValues);
    for (int i = 0; i < length; i++) {
      slopeInterceptXValues.add(slopeValue(i, seriesXValues[i]));
    }

    slopeIntercept = _computeSlopeInterceptValues(
        seriesXValues, linearYValues, length, slopeIntercept);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN) {
      final double intercept = slopeIntercept.intercept!;
      final double slope = slopeIntercept.slope!;
      final double x1 = forecastValue(sortedXValues[0], -backwardForecast);
      final double x2 =
          forecastValue(sortedXValues[length - 1], forwardForecast);
      final double y1 = slope * x1 + intercept;
      final double y2 = slope * x2 + intercept;

      xRange = DoubleRange(x1, x2);
      yRange = DoubleRange(y1, y2);

      trendlineXValues
        ..add(x1)
        ..add(x2);

      trendlineYValues
        ..add(y1)
        ..add(y2);
    }
  }

  void _calculateExponentialPoints(
    List<num> seriesXValues,
    List<num> seriesYValues,
    List<num> sortedXValues,
    _SlopeIntercept slopeIntercept,
    _SlopeIntercept slopeInterceptData,
    Function(int, num) slopeValue,
    Function(num, double) forecastValue,
    List<num> slopeInterceptXValues,
    List<num> exponentialYValues,
  ) {
    final int length = seriesXValues.length;
    for (int i = 0; i < length; i++) {
      slopeInterceptXValues.add(slopeValue(i, seriesXValues[i]));
      exponentialYValues.add(log(seriesYValues[i]));
    }

    slopeIntercept = _computeSlopeInterceptValues(
        sortedXValues, exponentialYValues, length, slopeIntercept);

    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN) {
      final double intercept = slopeIntercept.intercept!;
      final double slope = slopeIntercept.slope!;
      final int midPoint = (length / 2).round();

      final double x1 = forecastValue(sortedXValues[0], -backwardForecast);
      final double x2 = sortedXValues[midPoint - 1].toDouble();
      final double x3 =
          forecastValue(sortedXValues[length - 1], forwardForecast);
      double y1 = intercept * exp(slope * x1);
      double y2 = intercept * exp(slope * x2);
      double y3 = intercept * exp(slope * x3);

      // Avoid rendering trendline when values are NaN.
      if (y1.isNaN || y2.isNaN || y3.isNaN) {
        y1 = 0;
        y2 = 0;
        y3 = 0;
      }

      xRange = DoubleRange(x1, x3);
      yRange = DoubleRange(y1, y3);

      trendlineXValues
        ..add(x1)
        ..add(x2)
        ..add(x3);

      trendlineYValues
        ..add(y1)
        ..add(y2)
        ..add(y3);
    }
  }

  void _calculatePowerPoints(
    List<num> seriesXValues,
    List<num> seriesYValues,
    List<num> sortedXValues,
    _SlopeIntercept slopeIntercept,
    _SlopeIntercept slopeInterceptData,
    Function(int, num) slopeValue,
    Function(num, double) forecastValue,
    List<num> slopeInterceptXValues,
    List<num> powerYValues,
  ) {
    final List<num> powerXValues = <num>[];
    final int length = seriesXValues.length;
    for (int i = 0; i < length; i++) {
      final num x = seriesXValues[i];
      final double logX = log(x);
      powerXValues.add(logX.isFinite ? logX : x);
      slopeInterceptXValues.add(log(slopeValue(i, x)));
      powerYValues.add(log(seriesYValues[i]));
    }

    slopeIntercept = _computeSlopeInterceptValues(
        powerXValues, powerYValues, length, slopeIntercept);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN) {
      final double intercept = slopeIntercept.intercept!;
      final double slope = slopeIntercept.slope!;
      final int midPoint = (length / 2).round();

      double x1 = forecastValue(sortedXValues[0], -backwardForecast);
      if (xAxis is! RenderDateTimeAxis) {
        x1 = x1 > -1 ? x1 : 0;
      }
      final double x2 = sortedXValues[midPoint - 1].toDouble();
      final double x3 =
          forecastValue(sortedXValues[length - 1], forwardForecast);
      double y1 = x1 == 0 ? 0 : intercept * pow(x1, slope);
      double y2 = intercept * pow(x2, slope);
      double y3 = intercept * pow(x3, slope);

      // Avoid rendering trendline when values are NaN.
      if (y1.isNaN || y2.isNaN || y3.isNaN) {
        y1 = 0;
        y2 = 0;
        y3 = 0;
      }

      xRange = DoubleRange(x1, x3);
      yRange = DoubleRange(y1, y3);

      trendlineXValues
        ..add(x1)
        ..add(x2)
        ..add(x3);

      trendlineYValues
        ..add(y1)
        ..add(y2)
        ..add(y3);
    }
  }

  void _calculateLogarithmicPoints(
    List<num> seriesXValues,
    List<num> seriesYValues,
    List<num> sortedXValues,
    _SlopeIntercept slopeIntercept,
    _SlopeIntercept slopeInterceptData,
    Function(int, num) slopeValue,
    Function(num, double) forecastValue,
    List<num> slopeInterceptXValues,
    List<num> logYValues,
  ) {
    final List<num> logXValues = <num>[];
    final int length = seriesXValues.length;

    logYValues.addAll(seriesYValues);
    for (int i = 0; i < length; i++) {
      final num x = seriesXValues[i];
      final double logX = log(x);
      logXValues.add(logX.isFinite ? logX : slopeValue(i, x));
      slopeInterceptXValues.add(log(slopeValue(i, x)));
    }

    slopeIntercept = _computeSlopeInterceptValues(
        logXValues, logYValues, length, slopeIntercept);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN) {
      final double intercept = slopeIntercept.intercept!;
      final double slope = slopeIntercept.slope!;
      final int midPoint = (length / 2).round();

      final double x1 = forecastValue(sortedXValues[0], -backwardForecast);
      final double x2 = sortedXValues[midPoint - 1].toDouble();
      final double x3 =
          forecastValue(sortedXValues[length - 1], forwardForecast);
      final double y1 = intercept + (slope * (log(x1).isFinite ? log(x1) : x1));
      final double y2 = intercept + (slope * (log(x2).isFinite ? log(x2) : x2));
      final double y3 = intercept + (slope * (log(x3).isFinite ? log(x3) : x3));

      xRange = DoubleRange(x1, x3);
      yRange = DoubleRange(y1, y3);

      trendlineXValues
        ..add(x1)
        ..add(x2)
        ..add(x3);

      trendlineYValues
        ..add(y1)
        ..add(y2)
        ..add(y3);
    }
  }

  void _calculateMovingAveragePoints(
      List<num> sortedXValues, List<num> seriesYValues) {
    final int xLength = sortedXValues.length;
    final int yLength = seriesYValues.length;
    final int trendPeriod = period;
    int periods = trendPeriod >= xLength ? xLength - 1 : trendPeriod;
    periods = max(2, periods);
    double? x1;
    double? y1;

    for (int i = 0; i < xLength - 1; i++) {
      y1 = 0.0;
      int count = 0;
      int nullCount = 0;
      for (int j = i; count < periods; j++) {
        count++;
        if (j >= yLength) {
          nullCount++;
        }
        y1 = y1! + (j >= yLength ? 0 : seriesYValues[j]);
      }
      y1 = ((periods - nullCount) <= 0) ? null : (y1! / (periods - nullCount));
      if (y1 != null && !y1.isNaN && i + periods < xLength + 1) {
        x1 = sortedXValues[periods - 1 + i].toDouble();
        trendlineXValues.add(x1);
        trendlineYValues.add(y1);
      }
    }

    if (x1 != null && y1 != null) {
      xRange = DoubleRange(x1, x1);
      yRange = DoubleRange(y1, y1);
    }
  }

  List<double>? _calculatePolynomialPoints(
    List<num> sortedXValues,
    List<num> seriesYValues,
    List<num?>? polynomialSlopes,
    Function(int, num) slopeValue,
    Function(num, [bool]) polynomialForeCastValue,
  ) {
    final int trendPolynomialOrder = polynomialOrder;
    polynomialSlopes = List<num?>.filled(trendPolynomialOrder + 1, null);
    final int length = sortedXValues.length;
    for (int i = 0; i < length; i++) {
      final num x = sortedXValues[i];
      final num y = seriesYValues[i];
      for (int j = 0; j <= trendPolynomialOrder; j++) {
        polynomialSlopes[j] ??= 0;
        polynomialSlopes[j] = polynomialSlopes[j]! + pow(x.toDouble(), j) * y;
      }
    }

    final List<List<double>> matrix =
        _computeMatrix(sortedXValues, trendPolynomialOrder);
    // The trendline will not be generated if there is just one data point or
    // if the x and y values are the same. For example (1,1), (1,1).
    // So, the line was commented and now marker alone will be rendered
    // in this case.
    // _polynomialSlopes = null;
    _gaussJordanElimination(matrix, polynomialSlopes);
    _computePoints(sortedXValues, seriesYValues, length, polynomialSlopes,
        polynomialForeCastValue);
    List<double>? polynomialSlopeValues;

    if (onRenderDetailsUpdate != null) {
      polynomialSlopeValues = List<double>.filled(trendPolynomialOrder + 1, 0);
      for (int i = 0; i < length; i++) {
        final num y = seriesYValues[i];
        for (int j = 0; j <= trendPolynomialOrder; j++) {
          polynomialSlopeValues[j] +=
              pow(slopeValue(i, sortedXValues[i]), j) * y;
        }
      }

      final List<num> slopeValues = <num>[];
      for (int k = 0; k < length; k++) {
        slopeValues.add(slopeValue(k, sortedXValues[k]));
      }

      final List<List<double>> matrix =
          _computeMatrix(slopeValues, trendPolynomialOrder);
      // To find the prompt polynomial slopes for the trendline equation,
      // gaussJordanElimination method is used here.
      _gaussJordanElimination(matrix, polynomialSlopeValues);
    }

    return polynomialSlopeValues;
  }

  List<List<double>> _computeMatrix(List<num> xValues, int polynomialOrder) {
    final int length = xValues.length;
    final List<double> numArray =
        List<double>.filled(2 * polynomialOrder + 1, 0);
    final List<List<double>> matrix = List<List<double>>.generate(
        polynomialOrder + 1,
        (int _) => List<double>.filled(polynomialOrder + 1, 0));
    for (int i = 0; i <= polynomialOrder; i++) {
      matrix[i] = List<double>.filled(polynomialOrder + 1, 0);
    }

    num num1 = 0;
    for (int i = 0; i < length; i++) {
      final num d = xValues[i];
      num num2 = 1.0;
      for (int j = 0; j < numArray.length; j++, num1++) {
        numArray[j] += num2;
        num2 *= d;
      }
    }

    for (int k = 0; k <= polynomialOrder; k++) {
      for (int l = 0; l <= polynomialOrder; l++) {
        matrix[k][l] = numArray[k + l];
      }
    }
    return matrix;
  }

  void _computePoints(
    List<num> sortedXValues,
    List<num> seriesYValues,
    int length,
    List<num?>? polynomialSlopes,
    Function(num, [bool]) polynomialForeCastValue,
  ) {
    final List<num?> polynomialSlopesList = polynomialSlopes!;
    final int polynomialSlopesLength = polynomialSlopesList.length;
    final double trendBackwardForecast =
        polynomialForeCastValue(backwardForecast, false);
    final double trendForwardForecast =
        polynomialForeCastValue(forwardForecast, true);

    num xMin = double.infinity;
    num xMax = double.negativeInfinity;
    num yMin = double.infinity;
    num yMax = double.negativeInfinity;

    double x1;
    double y1;
    num value = 1;
    for (int i = 1; i <= polynomialSlopesLength; i++) {
      if (i == 1) {
        x1 = sortedXValues[0] - trendBackwardForecast;
        y1 = _computePolynomialYValue(polynomialSlopesList, x1);
      } else if (i == polynomialSlopesLength) {
        x1 = sortedXValues[length - 1] + trendForwardForecast;
        y1 = _computePolynomialYValue(polynomialSlopesList, x1);
      } else {
        value += (length + trendForwardForecast) / polynomialSlopesLength;
        x1 = sortedXValues[value.floor() - 1] * 1.0;
        y1 = _computePolynomialYValue(polynomialSlopesList, x1);
      }

      xMin = min(xMin, x1);
      xMax = max(xMax, x1);
      yMin = min(yMin, y1);
      yMax = max(yMax, y1);

      trendlineXValues.add(x1);
      trendlineYValues.add(y1);
    }

    xRange = DoubleRange(xMin, xMax);
    yRange = DoubleRange(yMin, yMax);
  }

  double _computePolynomialYValue(List<num?> slopes, num x) {
    double sum = 0;
    for (int i = 0; i < slopes.length; i++) {
      sum += slopes[i]! * pow(x, i);
    }
    return sum;
  }

  bool _gaussJordanElimination(
      List<List<double>> matrix, List<num?> polynomialSlopes) {
    final int length = matrix.length;
    final List<int> list1 = List<int>.filled(length, 0);
    final List<int> list2 = List<int>.filled(length, 0);
    final List<int> list3 = List<int>.filled(length, 0);

    for (int i = 0; i < length; i++) {
      list3[i] = 0;
    }

    int j = 0;
    while (j < length) {
      num value = 0;
      int k = 0, l = 0, m = 0;
      while (m < length) {
        if (list3[m] != 1) {
          int n = 0;
          while (n < length) {
            if (list3[n] == 0 && matrix[m][n].abs() >= value == true) {
              value = matrix[m][n].abs();
              k = m;
              l = n;
            }
            ++n;
          }
        }
        ++m;
      }
      ++list3[l];
      if (k != l) {
        int o = 0;
        while (o < length) {
          final double val = matrix[k][o];
          matrix[k][o] = matrix[l][o];
          matrix[l][o] = val;
          ++o;
        }
        final num res = polynomialSlopes[k]!;
        polynomialSlopes[k] = polynomialSlopes[l];
        polynomialSlopes[l] = res;
      }
      list2[j] = k;
      list1[j] = l;
      if (matrix[l][l] == 0.0) {
        return false;
      }
      final num v = 1.0 / matrix[l][l];
      matrix[l][l] = 1.0;
      int p = 0;
      while (p < length) {
        matrix[l][p] *= v;
        ++p;
      }
      polynomialSlopes[l] = polynomialSlopes[l]! * v;
      int q = 0;
      while (q < length) {
        if (q != l) {
          final num mVal = matrix[q][l];
          matrix[q][l] = 0.0;
          int r = 0;
          while (r < length) {
            matrix[q][r] -= matrix[l][r] * mVal;
            ++r;
          }
          polynomialSlopes[q] =
              polynomialSlopes[q]! - (polynomialSlopes[l]! * mVal);
        }
        ++q;
      }
      ++j;
    }

    for (int s = length - 1; s >= 0; s--) {
      if (list2[s] != list1[s]) {
        for (int t = 0; t < length; t++) {
          final List<double> mat = matrix[t];
          final double number = mat[list2[s]];
          mat[list2[s]] = mat[list1[s]];
          mat[list1[s]] = number;
        }
      }
    }

    return true;
  }

  _SlopeIntercept _computeSlopeInterceptValues(
    List<num> xValues,
    List<num> yValues,
    int length,
    _SlopeIntercept slopeIntercept,
  ) {
    num xAvg = 0.0;
    num yAvg = 0.0;
    num xyAvg = 0.0;
    num xxAvg = 0.0;
    int index = 0;
    double slope = 0.0;
    double trendIntercept = 0.0;
    while (index < length) {
      final double x = xValues[index].toDouble();
      double y = yValues[index].toDouble();
      if (y.isNaN == true) {
        y = (yValues[index - 1] + yValues[index + 1]) / 2;
      }
      xAvg += x;
      yAvg += y;
      xyAvg += x * y;
      xxAvg += x * x;
      index++;
    }

    if (intercept != null &&
        intercept != 0 &&
        (type == TrendlineType.linear || type == TrendlineType.exponential)) {
      trendIntercept = intercept!;
      switch (type) {
        case TrendlineType.linear:
          slope = (xyAvg - (trendIntercept * xAvg)) / xxAvg;
          break;
        case TrendlineType.exponential:
          slope = (xyAvg - (log(trendIntercept.abs()) * xAvg)) / xxAvg;
          break;
        // ignore: no_default_cases
        default:
          break;
      }
    } else {
      slope = ((length * xyAvg) - (xAvg * yAvg)) /
          ((length * xxAvg) - (xAvg * xAvg));

      trendIntercept =
          (type == TrendlineType.exponential || type == TrendlineType.power)
              ? exp((yAvg - (slope * xAvg)) / length)
              : (yAvg - (slope * xAvg)) / length;
    }

    slopeIntercept.slope = slope;
    slopeIntercept.intercept = trendIntercept;
    return slopeIntercept;
  }

  DateTimeIntervalType _visibleIntervalType() {
    DateTimeIntervalType visibleIntervalType = DateTimeIntervalType.auto;
    if (xAxis is RenderDateTimeAxis) {
      visibleIntervalType = (xAxis! as RenderDateTimeAxis).visibleIntervalType;
    } else if (xAxis is RenderDateTimeCategoryAxis) {
      visibleIntervalType =
          (xAxis! as RenderDateTimeCategoryAxis).visibleIntervalType;
    }

    return visibleIntervalType;
  }

  /// It returns the date-time values of trendline series.
  int _computeDateTimeForeCast(DateTime date, num interval) {
    final int effectiveInterval = interval.floor();
    final DateTimeIntervalType visibleIntervalType = _visibleIntervalType();
    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        return DateTime(date.year + effectiveInterval, date.month, date.day,
                date.hour, date.minute, date.second)
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.months:
        return DateTime(date.year, date.month + effectiveInterval, date.day,
                date.hour, date.minute, date.second)
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.days:
        return date
            .add(Duration(days: effectiveInterval))
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.hours:
        return date
            .add(Duration(hours: effectiveInterval))
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.minutes:
        return date
            .add(Duration(minutes: effectiveInterval))
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.seconds:
        return date
            .add(Duration(seconds: effectiveInterval))
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.milliseconds:
        return date
            .add(Duration(milliseconds: effectiveInterval))
            .millisecondsSinceEpoch;

      case DateTimeIntervalType.auto:
        break;
    }
    return date.millisecondsSinceEpoch;
  }

  int _computeDateTimeDuration(bool isForward) {
    Duration duration = Duration.zero;
    final double forecast = isForward ? forwardForecast : backwardForecast;
    final int foreCastRoundValue = forecast.round();
    final DateTimeIntervalType visibleIntervalType = _visibleIntervalType();
    switch (visibleIntervalType) {
      case DateTimeIntervalType.auto:
        duration = Duration.zero;
        break;
      case DateTimeIntervalType.years:
        duration = Duration(days: (365.25 * forecast).round());
        break;
      case DateTimeIntervalType.months:
        duration = Duration(days: 31 * foreCastRoundValue);
        break;
      case DateTimeIntervalType.days:
        duration = Duration(days: foreCastRoundValue);
        break;
      case DateTimeIntervalType.hours:
        duration = Duration(hours: foreCastRoundValue);
        break;
      case DateTimeIntervalType.minutes:
        duration = Duration(minutes: foreCastRoundValue);
        break;
      case DateTimeIntervalType.seconds:
        duration = Duration(seconds: foreCastRoundValue);
        break;
      case DateTimeIntervalType.milliseconds:
        duration = Duration(milliseconds: foreCastRoundValue);
    }
    return duration.inMilliseconds;
  }

  void _transformLinearPoints() {
    final Function(num, num) transformX = series!.pointToPixelX;
    final Function(num, num) transformY = series!.pointToPixelY;
    final num x1 = trendlineXValues[0];
    final num y1 = trendlineYValues[0];
    final num x2 = trendlineXValues[1];
    final num y2 = trendlineYValues[1];

    final double x1Value = transformX(x1, y1);
    final double y1Value = transformY(x1, y1);
    final double x2Value = transformX(x2, y2);
    final double y2Value = transformY(x2, y2);

    _points.add(Offset(x1Value, y1Value));
    _points.add(Offset(x2Value, y2Value));

    _path
      ..moveTo(x1Value, y1Value)
      ..lineTo(x2Value, y2Value);
  }

  void _transformTrendlineWithControlPoints() {
    final Function(num, num) transformX = series!.pointToPixelX;
    final Function(num, num) transformY = series!.pointToPixelY;
    final num x1 = trendlineXValues[0];
    final num y1 = trendlineYValues[0];
    final double moveX = transformX(x1, y1);
    final double moveY = transformY(x1, y1);
    _points.add(Offset(moveX, moveY));
    _path.moveTo(moveX, moveY);

    final int length = trendlineXValues.length;
    for (int i = 0; i < length - 1; i++) {
      final num x2 = trendlineXValues[i + 1];
      final num y2 = trendlineYValues[i + 1];
      final List<Offset> controlPoints = _computeControlPoints(i);
      final double controlX1 = controlPoints[0].dx;
      final double controlY1 = controlPoints[0].dy;
      final double controlX2 = controlPoints[1].dx;
      final double controlY2 = controlPoints[1].dy;
      final double controlX1Value = transformX(controlX1, controlY1);
      final double controlY1Value = transformY(controlX1, controlY1);
      final double controlX2Value = transformX(controlX2, controlY2);
      final double controlY2Value = transformY(controlX2, controlY2);
      final double x2Value = transformX(x2, y2);
      final double y2Value = transformY(x2, y2);
      _points.add(Offset(x2Value, y2Value));
      _path.cubicTo(
        controlX1Value,
        controlY1Value,
        controlX2Value,
        controlY2Value,
        x2Value,
        y2Value,
      );
    }
  }

  void _transformMovingAveragePoints() {
    final Function(num, num) transformX = series!.pointToPixelX;
    final Function(num, num) transformY = series!.pointToPixelY;
    final num x1 = trendlineXValues[0];
    final num y1 = trendlineYValues[0];
    final double x1Value = transformX(x1, y1);
    final double y1Value = transformY(x1, y1);
    _points.add(Offset(x1Value, y1Value));
    _path.moveTo(x1Value, y1Value);

    final int length = trendlineXValues.length;
    for (int i = 1; i < length; i++) {
      final num x2 = trendlineXValues[i];
      final num y2 = trendlineYValues[i];
      final double x2Value = transformX(x2, y2);
      final double y2Value = transformY(x2, y2);
      _points.add(Offset(x2Value, y2Value));
      _path.lineTo(x2Value, y2Value);
    }
  }

  List<Offset> _computeControlPoints(int index) {
    final List<Offset> controlPoints = <Offset>[];
    final List<num> xValues = <num>[...trendlineXValues];
    final List<num> yValues = <num>[...trendlineYValues];
    final int length = xValues.length;
    List<num?> yCoefficient = List<num?>.filled(length, 0);
    yCoefficient = _computeNaturalSpline(
        xValues, yValues, yCoefficient, xValues.length, SplineType.natural);
    return _controlPoints(xValues, yValues, yCoefficient[index]!.toDouble(),
        yCoefficient[index + 1]!.toDouble(), index, controlPoints);
  }

  List<num?> _computeNaturalSpline(List<num> xValues, List<num> yValues,
      List<num?> yCoefficient, int length, SplineType splineType) {
    const double a = 6;
    num d1, d2, d3, dy1, dy2, p;

    final List<num?> u = List<num?>.filled(length, null);
    if (splineType == SplineType.clamped && length > 1) {
      final num x1 = xValues[0];
      final num x2 = xValues[1];
      final num y1 = yValues[0];
      final num y2 = yValues[1];
      final num xDiff = x2 - x1;
      final num yDiff = y2 - y1;
      final num xEnd = xValues[length - 1];
      final num xPenultimate = xValues[length - 2];
      final num yEnd = yValues[length - 1];
      final num yPenultimate = yValues[length - 2];
      final num d0 = xDiff / yDiff;
      final num dn = (xEnd - xPenultimate) / (yEnd - yPenultimate);

      u[0] = 0.5;
      yCoefficient[0] = (3 * yDiff / xDiff) - (3 * d0);
      yCoefficient[length - 1] =
          (3 * dn) - ((3 * (yEnd - yPenultimate)) / (xEnd - xPenultimate));
      if (yCoefficient[0] == double.infinity || yCoefficient[0]!.isNaN) {
        yCoefficient[0] = 0;
      }

      final num? endCoef = yCoefficient[length - 1];
      if (endCoef == double.infinity || endCoef!.isNaN) {
        yCoefficient[length - 1] = 0;
      }
    } else {
      yCoefficient[0] = u[0] = 0;
      yCoefficient[length - 1] = 0;
    }

    final int segmentCount = length - 1;
    for (int i = 1; i < segmentCount; i++) {
      yCoefficient[i] = 0;
      final num x = xValues[i];
      final num y = yValues[i];
      final num nextX = xValues[i + 1];
      final num nextY = yValues[i + 1];
      final num previousX = xValues[i - 1];
      final num previousY = yValues[i - 1];
      if (!y.isNaN && !nextY.isNaN && !previousY.isNaN) {
        d1 = x - previousX;
        d2 = nextX - previousX;
        d3 = nextX - x;
        dy1 = nextY - y;
        dy2 = y - previousY;
        if (x == previousX || x == nextX) {
          yCoefficient[i] = 0;
          u[i] = 0;
        } else {
          p = 1 / ((d1 * yCoefficient[i - 1]!) + (2 * d2));
          yCoefficient[i] = -p * d3;
          if (u[i - 1] != null) {
            u[i] = p * ((a * ((dy1 / d3) - (dy2 / d1))) - (d1 * u[i - 1]!));
          }
        }
      }
    }

    for (int i = length - 2; i >= 0; i--) {
      final num? yCoef1 = yCoefficient[i];
      final num? yCoef2 = yCoefficient[i + 1];
      if (u[i] != null && yCoef1 != null && yCoef2 != null) {
        yCoefficient[i] = (yCoef1 * yCoef2) + u[i]!;
      }
    }

    return yCoefficient;
  }

  List<Offset> _controlPoints(
    List<num> xValues,
    List<num?> yValues,
    double yCoefficient,
    double nextYCoefficient,
    int i,
    List<Offset> controlPoints,
  ) {
    final List<double?> values = List<double?>.filled(4, null);
    final num x = xValues[i];
    final num y = yValues[i]!;
    final num nextX = xValues[i + 1];
    final num nextY = yValues[i + 1]!;
    const double oneThird = 1 / 3.0;
    num deltaX2 = nextX - x;
    deltaX2 = deltaX2 * deltaX2;
    final num dx1 = (2 * x) + nextX;
    final num dx2 = x + (2 * nextX);
    final num dy1 = (2 * y) + nextY;
    final num dy2 = y + (2 * nextY);
    final double y1 = oneThird *
        (dy1 -
            (oneThird * deltaX2 * (yCoefficient + (0.5 * nextYCoefficient))));
    final double y2 = oneThird *
        (dy2 -
            (oneThird * deltaX2 * ((0.5 * yCoefficient) + nextYCoefficient)));
    values[0] = dx1 * oneThird;
    values[1] = y1;
    values[2] = dx2 * oneThird;
    values[3] = y2;
    controlPoints.add(Offset(values[0]!, values[1]!));
    controlPoints.add(Offset(values[2]!, values[3]!));
    return controlPoints;
  }

  double? _computeRSquaredValue(
    List<num> xValues,
    List<num> yValues,
    List<double>? slope,
    double? intercept,
    Function(int, num) slopeValue,
  ) {
    double rSquare = 0.0;
    const int power = 2;
    final List<num> xValue = <num>[];
    double yMean = 0;
    for (int i = 0; i < xValues.length; i++) {
      xValue.add(slopeValue(i, xValues[i]));
      yMean += yValues[i];
    }

    final int yLength = yValues.length;
    yMean = yMean / yLength;
    // Total sum of square.
    double sumOfSquare = 0.0;
    for (int j = 0; j < yLength; j++) {
      sumOfSquare += pow(yValues[j] - yMean, power);
    }
    // Sum of squares due to regression.
    double sumOfSquareDueToRegression = 0.0;
    switch (type) {
      case TrendlineType.linear:
        for (int k = 0; k < yLength; k++) {
          sumOfSquareDueToRegression +=
              pow(((slope![0] * xValue[k]) + intercept!) - yMean, power);
        }
        break;

      case TrendlineType.exponential:
        for (int k = 0; k < yLength; k++) {
          sumOfSquareDueToRegression +=
              pow((intercept! * exp(slope![0] * xValue[k])) - yMean, power);
        }
        break;

      case TrendlineType.power:
        for (int k = 0; k < yLength; k++) {
          sumOfSquareDueToRegression +=
              pow((intercept! * pow(xValue[k], slope![0])) - yMean, power);
        }
        break;

      case TrendlineType.logarithmic:
        for (int k = 0; k < yLength; k++) {
          sumOfSquareDueToRegression +=
              pow(((slope![0] * log(xValue[k])) + intercept!) - yMean, power);
        }
        break;

      case TrendlineType.polynomial:
        for (int k = 0; k < yLength; k++) {
          double yCap = 0.0;
          for (int i = 0; i < slope!.length; i++) {
            yCap += slope[i] * pow(xValue[k], i);
          }
          sumOfSquareDueToRegression += pow(yCap - yMean, power);
        }
        break;

      case TrendlineType.movingAverage:
        break;
    }

    rSquare = sumOfSquareDueToRegression / sumOfSquare;
    return rSquare.isNaN ? 0 : rSquare;
  }

  num _slopeXValue(int index, num value) {
    return index + 1;
  }

  num _slopeLogXValue(int index, num value) {
    return log(value);
  }

  num _forecastValue(num value, double forecast) {
    return value + forecast;
  }

  num _slopeDateTimeXValue(int index, num value) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return dateTime.difference(DateTime(1900)).inDays;
  }

  double _forecastDateTimeValue(num value, double forecast) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return _computeDateTimeForeCast(dateTime, forecast).toDouble();
  }

  num _polynomialForeCastValue(num forecast, [bool? isForeCast]) {
    return forecast;
  }

  double _polynomialForeCastDateTimeAxisValue(num forecast,
      [bool? isForeCast]) {
    return _computeDateTimeDuration(isForeCast!).toDouble();
  }

  void populateDataSource(List<num> seriesXValues, List<num> seriesYValues) {
    final bool trendIsVisible = !isToggled &&
        (type == TrendlineType.polynomial
            ? (polynomialOrder >= 2 && polynomialOrder <= 6)
            : !(type == TrendlineType.movingAverage) ||
                (period >= 2 && period <= seriesXValues.length - 1));

    if (series == null ||
        !series!.controller.isVisible ||
        !trendIsVisible ||
        seriesXValues.isEmpty ||
        seriesYValues.isEmpty) {
      return;
    }

    final List<num> yValues = <num>[];
    final List<num> slopeInterceptXValues = <num>[];
    final _SlopeIntercept slopeIntercept = _SlopeIntercept();
    _SlopeIntercept slopeInterceptData = _SlopeIntercept();
    List<num?>? polynomialSlopes;
    List<double>? polynomialSlopesData;
    List<double>? slope;

    late Function(int, num) slopeValue;
    late Function(num, double) forecastValue;
    late Function(num, [bool]) polynomialForeCastValue;

    late List<num> sortedXValues;
    if (series!.canFindLinearVisibleIndexes) {
      sortedXValues = seriesXValues;
    } else {
      final List<num> xValuesCopy = <num>[...seriesXValues];
      xValuesCopy.sort();
      sortedXValues = xValuesCopy;
    }

    _resetTrendlineDataHolders();
    yValues.clear();
    slopeInterceptXValues.clear();
    trendlineXValues.clear();
    trendlineYValues.clear();

    if (xAxis is RenderDateTimeAxis) {
      slopeValue = _slopeDateTimeXValue;
      forecastValue = _forecastDateTimeValue;
      polynomialForeCastValue = _polynomialForeCastDateTimeAxisValue;
    } else if (xAxis is RenderLogarithmicAxis) {
      slopeValue = _slopeLogXValue;
      forecastValue = _forecastValue;
      polynomialForeCastValue = _polynomialForeCastValue;
    } else if (xAxis is RenderCategoryAxis ||
        xAxis is RenderDateTimeCategoryAxis) {
      slopeValue = _slopeXValue;
      forecastValue = _forecastValue;
      polynomialForeCastValue = _polynomialForeCastValue;
    } else {
      slopeValue = _slopeXValue;
      forecastValue = _forecastValue;
      polynomialForeCastValue = _polynomialForeCastValue;
    }

    switch (type) {
      case TrendlineType.linear:
        _calculateLinearPoints(
            seriesXValues,
            seriesYValues,
            sortedXValues,
            slopeIntercept,
            slopeInterceptData,
            slopeValue,
            forecastValue,
            slopeInterceptXValues,
            yValues);
        break;

      case TrendlineType.exponential:
        _calculateExponentialPoints(
            seriesXValues,
            seriesYValues,
            sortedXValues,
            slopeIntercept,
            slopeInterceptData,
            slopeValue,
            forecastValue,
            slopeInterceptXValues,
            yValues);
        break;

      case TrendlineType.power:
        _calculatePowerPoints(
            seriesXValues,
            seriesYValues,
            sortedXValues,
            slopeIntercept,
            slopeInterceptData,
            slopeValue,
            forecastValue,
            slopeInterceptXValues,
            yValues);
        break;

      case TrendlineType.logarithmic:
        _calculateLogarithmicPoints(
            seriesXValues,
            seriesYValues,
            sortedXValues,
            slopeIntercept,
            slopeInterceptData,
            slopeValue,
            forecastValue,
            slopeInterceptXValues,
            yValues);
        break;

      case TrendlineType.polynomial:
        polynomialSlopesData = _calculatePolynomialPoints(
            sortedXValues,
            seriesYValues,
            polynomialSlopes,
            slopeValue,
            polynomialForeCastValue);
        slope = polynomialSlopesData;
        break;

      case TrendlineType.movingAverage:
        _calculateMovingAveragePoints(sortedXValues, seriesYValues);
        slope = null;
        break;
    }

    // Calculate slope and intercept values after calculated trendline points.
    if (!(type == TrendlineType.movingAverage ||
        type == TrendlineType.polynomial)) {
      slopeInterceptData = _computeSlopeInterceptValues(
          slopeInterceptXValues, yValues, seriesXValues.length, slopeIntercept);
      slope = <double>[slopeInterceptData.slope!];
    }

    // Trigger the onRenderDetailsUpdate event.
    if (onRenderDetailsUpdate != null) {
      final TrendlineRenderParams args = TrendlineRenderParams(
        slopeIntercept.intercept,
        series!.index,
        name,
        series!.name,
        _points,
        slope,
        _computeRSquaredValue(seriesXValues, seriesYValues, slope,
            slopeIntercept.intercept, slopeValue),
      );
      onRenderDetailsUpdate!(args);
    }

    // Calculate segment index based on the trendXValues.
    trendSegmentIndexes.clear();
    final int xLength = trendlineXValues.length;
    for (int i = 0; i < xLength; i++) {
      trendSegmentIndexes.add(i);
    }
  }

  List<LegendItem>? buildLegendItems(int index, LegendItemProvider provider) {
    if (isVisibleInLegend) {
      _legendItem = ChartLegendItem(
        text: name ?? _defaultTrendlineName(),
        iconType:
            _toShapeMarkerType(legendIconType, legendItemProvider: provider),
        iconColor: color!,
        iconBorderWidth: 2,
        series: series,
        seriesIndex: series!.index,
        pointIndex: index,
        isToggled: isToggled,
        onTap: _handleLegendItemTapped,
        onRender: _handleLegendItemCreated,
      );
      return <LegendItem>[_legendItem!];
    } else {
      _legendItem = null;
      return null;
    }
  }

  void _updateLegendBasedOnSeries(bool seriesToggled) {
    if (!isToggled) {
      if (_legendItem != null) {
        _legendItem!.onToggled?.call();
      }
    }
  }

  void _handleLegendItemTapped(LegendItem item, bool wasToggled) {
    if (_legendItem != null && series != null && series!.controller.isVisible) {
      if (series!.parent != null && series!.parent!.onLegendTapped != null) {
        final LegendTapArgs args =
            LegendTapArgs(_legendItem!.series, _legendItem!.seriesIndex);
        series!.parent!.onLegendTapped!(args);
      }
      isToggled = wasToggled;
      _legendItem!.onToggled?.call();
    }
  }

  void _handleLegendItemCreated(ItemRendererDetails details) {
    if (series != null &&
        series!.parent != null &&
        series!.parent!.onLegendItemRender != null) {
      final ChartLegendItem item = details.item as ChartLegendItem;
      final LegendIconType iconType = toLegendIconType(details.iconType);
      final LegendRenderArgs args =
          LegendRenderArgs(item.seriesIndex, item.pointIndex)
            ..text = details.text
            ..legendIconType = iconType
            ..color = details.color;
      series!.parent!.onLegendItemRender!(args);
      if (args.legendIconType != iconType) {
        details.iconType = _toShapeMarkerType(
            args.legendIconType ?? LegendIconType.seriesType);
      }

      details
        ..text = args.text ?? ''
        ..color = args.color ?? Colors.transparent;
    }
  }

  ShapeMarkerType _toShapeMarkerType(LegendIconType iconType,
      {LegendItemProvider? legendItemProvider}) {
    switch (iconType) {
      case LegendIconType.seriesType:
        if (legendItemProvider != null) {
          return legendItemProvider.effectiveLegendIconType();
        }
        return dashArray != null &&
                !dashArray!.every((double value) => value <= 0)
            ? ShapeMarkerType.lineSeriesWithDashArray
            : ShapeMarkerType.lineSeries;
      case LegendIconType.circle:
        return ShapeMarkerType.circle;
      case LegendIconType.rectangle:
        return ShapeMarkerType.rectangle;
      case LegendIconType.image:
        return ShapeMarkerType.image;
      case LegendIconType.pentagon:
        return ShapeMarkerType.pentagon;
      case LegendIconType.verticalLine:
        return ShapeMarkerType.verticalLine;
      case LegendIconType.horizontalLine:
        return ShapeMarkerType.horizontalLine;
      case LegendIconType.diamond:
        return ShapeMarkerType.diamond;
      case LegendIconType.triangle:
        return ShapeMarkerType.triangle;
      case LegendIconType.invertedTriangle:
        return ShapeMarkerType.invertedTriangle;
    }
  }

  String _defaultTrendlineName() {
    switch (type) {
      case TrendlineType.linear:
        return 'Linear';
      case TrendlineType.exponential:
        return 'Exponential';
      case TrendlineType.power:
        return 'Power';
      case TrendlineType.logarithmic:
        return 'Logarithmic';
      case TrendlineType.polynomial:
        return 'Polynomial';
      case TrendlineType.movingAverage:
        return 'Moving average';
    }
  }

  @override
  void performLayout() {
    if (!isToggled && (series != null && series!.controller.isVisible)) {
      transformValues();
    }
    size = constraints.biggest;
  }

  void transformValues() {
    if (series == null ||
        trendlineXValues.isEmpty ||
        trendlineYValues.isEmpty) {
      return;
    }

    _path.reset();
    switch (type) {
      case TrendlineType.linear:
        _transformLinearPoints();
        break;

      case TrendlineType.exponential:
      case TrendlineType.logarithmic:
      case TrendlineType.polynomial:
      case TrendlineType.power:
        _transformTrendlineWithControlPoints();
        break;

      case TrendlineType.movingAverage:
        _transformMovingAveragePoints();
        break;
    }

    if (markerSettings.isVisible) {
      _markers.clear();
      _calculateMarkerPositions();
    }
  }

  void _calculateMarkerPositions() {
    final Color themeFillColor = series!.parent!.themeData!.colorScheme.surface;
    final MarkerSettings settings = markerSettings;
    final int length = trendlineXValues.length;
    for (int i = 0; i < length; i++) {
      final ChartMarker marker = ChartMarker()
        ..x = trendlineXValues[i]
        ..y = trendlineYValues[i]
        ..index = i;
      marker.merge(
        borderColor: settings.borderColor ?? color,
        borderWidth: settings.borderWidth,
        color: settings.color ?? themeFillColor,
        height: settings.height,
        width: settings.width,
        image: settings.image,
        type: settings.shape,
      );
      final double positionX =
          series!.pointToPixelX(marker.x, marker.y) - marker.width / 2;
      final double positionY =
          series!.pointToPixelY(marker.x, marker.y) - marker.height / 2;
      marker.position = Offset(positionX, positionY);
      _markers.add(marker);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (series == null || !series!.controller.isVisible || isToggled) {
      return;
    }

    final Paint trendlinePaint = Paint()
      ..color = color!.withOpacity(opacity)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    if (trendlinePaint.color != Colors.transparent &&
        trendlinePaint.strokeWidth > 0) {
      drawDashes(context.canvas, dashArray, trendlinePaint, path: _path);
    }

    if (_markers.isNotEmpty) {
      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      for (final ChartMarker marker in _markers) {
        fillPaint.color = marker.color!;
        strokePaint
          ..color = marker.borderColor!
          ..strokeWidth = marker.borderWidth / 2;
        series!.drawDataMarker(
          marker.index,
          context.canvas,
          fillPaint,
          strokePaint,
          marker.position,
          Size(marker.width, marker.height),
          marker.type,
          series,
        );
      }
    }
  }

  void _resetTrendlineDataHolders() {
    _points.clear();
    _path.reset();
  }

  @override
  void dispose() {
    _points.clear();
    _path.reset();
    _markers.clear();
    super.dispose();
  }
}

class _SlopeIntercept {
  double? slope;
  double? intercept;
}
