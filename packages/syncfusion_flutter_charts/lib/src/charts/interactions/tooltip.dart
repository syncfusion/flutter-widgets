import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart' show DataMarkerType;

import '../axis/axis.dart';
import '../base.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'behavior.dart';

/// Customizes the tooltip.
///
/// This class provides options for customizing the properties of the tooltip.
class TooltipBehavior extends ChartBehavior {
  /// Creating an argument constructor of TooltipBehavior class.
  TooltipBehavior({
    this.enable = false,
    this.textStyle,
    this.activationMode = ActivationMode.singleTap,
    this.animationDuration = 350,
    this.opacity = 1.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.duration = 3000,
    this.shouldAlwaysShow = false,
    this.elevation = 2.5,
    this.canShowMarker = true,
    this.textAlignment = ChartAlignment.center,
    this.decimalPlaces = 3,
    this.tooltipPosition = TooltipPosition.auto,
    this.shared = false,
    this.color,
    this.header,
    this.format,
    this.builder,
    this.shadowColor,
  });

  /// Toggles the visibility of the tooltip.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool enable;

  /// Color of the tooltip.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     color: Colors.red
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Header of the tooltip. By default, the series name will be displayed
  /// in the header.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     header: 'Default'
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final String? header;

  /// Opacity of the tooltip.
  ///
  /// The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     opacity: 0.7
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double opacity;

  /// Customizes the tooltip text.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     textStyle: TextStyle(
  ///       color: Colors.green
  ///     )
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Specifies the number decimals to be displayed in tooltip text.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     decimalPlaces: 1
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final int decimalPlaces;

  /// Formats the tooltip text.
  ///
  /// By default, the tooltip will be rendered with x and y-values.
  ///
  /// You can add prefix or suffix to x, y, and series name values in the
  /// tooltip by formatting them.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     format:'point.y %'
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final String? format;

  /// Duration for animating the tooltip.
  ///
  /// Defaults to `350`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     animationDuration: 1000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final int animationDuration;

  /// Toggles the visibility of the marker in the tooltip.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     canShowMarker: false
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool canShowMarker;

  /// Gesture for activating the tooltip.
  ///
  /// Tooltip can be activated in tap, double tap, and long press.
  ///
  /// Defaults to `ActivationMode.tap`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     activationMode: ActivationMode.doubleTap
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final ActivationMode activationMode;

  /// Border color of the tooltip.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     borderColor: Colors.red,
  ///     borderWidth: 3
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the tooltip.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     borderColor: Colors.red,
  ///     borderWidth: 3
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Builder of the tooltip.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     builder: (dynamic data, dynamic point, dynamic series,
  ///      int pointIndex, int seriesIndex) {
  ///       return Container(
  ///         height: 50,
  ///         width: 100,
  ///         decoration: const BoxDecoration(
  ///           color: Color.fromRGBO(66, 244, 164, 1),
  ///         ),
  ///         child: Text('$pointIndex'),
  ///       );
  ///     }
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  ///```
  final ChartWidgetBuilder? builder;

  /// Color of the tooltip shadow.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shadowColor: Colors.green
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final Color? shadowColor;

  /// Elevation of the tooltip.
  ///
  /// Defaults to `2.5`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     elevation: 10
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double elevation;

  /// Shows or hides the tooltip.
  ///
  /// By default, the tooltip will be hidden on touch.
  /// To avoid this, set this property to true.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shouldAlwaysShow: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// Duration for displaying the tooltip.
  ///
  /// Defaults to `3000`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     duration: 1000
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final double duration;

  /// Alignment of the text in the tooltip.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     textAlignment : ChartAlignment.near
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final ChartAlignment textAlignment;

  /// Show tooltip at tapped position.
  ///
  /// Defaults to `TooltipPosition.auto`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     tooltipPosition: TooltipPosition.pointer
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final TooltipPosition tooltipPosition;

  /// Share the tooltip with same index points.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late TooltipBehavior tooltipBehavior;
  ///
  /// void initState() {
  ///   tooltipBehavior = TooltipBehavior(
  ///     enable: true,
  ///     shared: true
  ///   );
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     tooltipBehavior: tooltipBehavior
  ///   );
  /// }
  /// ```
  final bool shared;

  /// Displays the tooltip at the specified x and y-positions.
  ///
  /// * x & y - logical pixel values to position the tooltip.
  void showByPixel(double x, double y) {
    assert(!x.isNaN);
    assert(!y.isNaN);
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent == null) {
      return;
    }

    final Offset primaryLocalPosition = Offset(x, y);
    final Offset primaryPosition = parent.localToGlobal(primaryLocalPosition);
    RenderBox? child = parent.plotArea?.lastChild;
    while (child != null) {
      final StackParentData childParentData =
          child.parentData! as StackParentData;
      if (child is ChartSeriesRenderer) {
        final bool isHit = child.hitInsideSegment(primaryLocalPosition);
        if (isHit) {
          final TooltipInfo? info =
              child.tooltipInfo(position: primaryLocalPosition);
          if (info != null) {
            parent.raiseTooltip(info);
          }
          break;
        }
      }
      child = childParentData.previousSibling;
    }

    parent.raiseTooltip(TooltipInfo(
      primaryPosition: primaryPosition,
      secondaryPosition: primaryPosition,
    ));
  }

  /// Displays the tooltip at the specified x and y-values.
  ///
  /// * x & y - x & y point values at which the tooltip needs to be shown.
  ///
  /// * xAxisName - name of the x axis the given point must be bind to.
  ///
  /// * yAxisName - name of the y axis the given point must be bind to.
  void show(dynamic x, double y, [String? xAxisName, String? yAxisName]) {
    assert(x != null);
    assert(!y.isNaN);
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null) {
      final RenderChartAxis? xAxis =
          xAxisName != null ? parent.axisFromName(xAxisName) : parent.xAxis;
      final RenderChartAxis? yAxis =
          yAxisName != null ? parent.axisFromName(yAxisName) : parent.yAxis;
      final Offset position =
          rawValueToPixelPoint(x, y, xAxis, yAxis, parent.isTransposed);
      showByPixel(position.dx, position.dy);
    }
  }

  /// Displays the tooltip at the specified series and point index.
  ///
  /// * seriesIndex - index of the series for which the pointIndex is specified
  ///
  /// * pointIndex - index of the point for which the tooltip should be shown
  void showByIndex(int seriesIndex, int pointIndex) {
    final RenderBehaviorArea? parent = parentBox as RenderBehaviorArea?;
    if (parent != null) {
      if (shared) {
        String? text;
        String? header;
        num? baseXValue;
        Offset? position;
        ChartTooltipInfo? tooltipInfo;
        final List<Color?> markerColors = <Color?>[];
        final List<ChartTooltipInfo> tooltipInfoList = <ChartTooltipInfo>[];
        final RenderBox? firstChild = parent.plotArea?.firstChild;
        RenderBox? series = firstChild;
        while (series != null && series.parentData != null) {
          final ContainerParentDataMixin<RenderBox> seriesParentData =
              series.parentData! as ContainerParentDataMixin<RenderBox>;
          // It specifies for cartesian series renderer.
          if (series is CartesianSeriesRenderer &&
              series.isVisible() &&
              series.enableTooltip) {
            final ChartTooltipInfo? info = series
                .tooltipInfoFromPointIndex(pointIndex) as ChartTooltipInfo?;
            if (info != null && series.index == seriesIndex) {
              baseXValue = (info.point as CartesianChartPoint).xValue;
              break;
            }
          }

          series = seriesParentData.nextSibling;
        }

        RenderBox? child = firstChild;
        while (child != null && child.parentData != null) {
          final ContainerParentDataMixin<RenderBox> childParentData =
              child.parentData! as ContainerParentDataMixin<RenderBox>;
          if (child is ChartSeriesRenderer &&
              child.isVisible() &&
              child.enableTooltip) {
            final ChartTooltipInfo? info = child
                .tooltipInfoFromPointIndex(pointIndex) as ChartTooltipInfo?;
            if (info != null && info.text != null) {
              if (child.index == seriesIndex) {
                tooltipInfo ??= info;
                position ??= info.primaryPosition;
              }
            }

            // It specifies for circular & funnel & pyramid series renderer.
            if (baseXValue == null) {
              if (tooltipInfo?.point.x == info?.point.x) {
                tooltipInfoList.add(info!);
              }
            } else {
              // It specifies for cartesian series renderer.
              if (child.canFindLinearVisibleIndexes) {
                final int binaryIndex = binarySearch(child.xValues,
                    baseXValue.toDouble(), 0, child.dataCount - 1);
                if (binaryIndex >= 0) {
                  final ChartTooltipInfo? info =
                      child.tooltipInfoFromPointIndex(binaryIndex)
                          as ChartTooltipInfo?;
                  if (info != null && info.text != null) {
                    final num? infoXValue =
                        (info.point as CartesianChartPoint).xValue;
                    if (infoXValue != null && baseXValue == infoXValue) {
                      tooltipInfoList.add(info);
                    }
                  }
                }
              } else {
                final int index = child.xValues.indexOf(baseXValue);
                if (index >= 0) {
                  final ChartTooltipInfo? info = child
                      .tooltipInfoFromPointIndex(index) as ChartTooltipInfo?;
                  if (info != null && info.text != null) {
                    tooltipInfoList.add(info);
                  }
                }
              }
            }
          }

          child = childParentData.nextSibling;
        }

        for (final ChartTooltipInfo info in tooltipInfoList) {
          if (text == null) {
            text = '${info.text}';
          } else {
            text += '\n';
            text += '${info.text}';
          }
          if (info.markerColors.isNotEmpty) {
            markerColors.add(info.markerColors[0]);
          }
        }

        if (tooltipInfo != null && text != null && position != null) {
          parent.showTooltip(ChartTooltipInfo(
            primaryPosition: position,
            secondaryPosition: tooltipInfo.secondaryPosition,
            text: text,
            data: tooltipInfo.data,
            point: tooltipInfo.point,
            series: tooltipInfo.series,
            renderer: tooltipInfo.renderer,
            header: header ?? tooltipInfo.header,
            seriesIndex: seriesIndex,
            pointIndex: pointIndex,
            segmentIndex: tooltipInfo.segmentIndex,
            markerColors: markerColors,
            markerBorderColor: tooltipInfo.markerBorderColor,
            markerType: tooltipInfo.markerType,
          ));
        }
      } else {
        parent.plotArea?.visitChildren((RenderObject child) {
          if (child is ChartSeriesRenderer &&
              child.isVisible() &&
              child.enableTooltip) {
            if (child.index == seriesIndex) {
              final TooltipInfo? info =
                  child.tooltipInfoFromPointIndex(pointIndex);
              if (info != null) {
                parent.showTooltip(info);
              }
            }
          }
        });
      }
    }
  }

  /// Hides the tooltip if it is displayed.
  void hide() {
    (parentBox as RenderBehaviorArea?)?.hideTooltip();
  }
}

@immutable
class ChartTooltipInfo<T, D> extends TooltipInfo {
  const ChartTooltipInfo({
    required super.primaryPosition,
    required super.secondaryPosition,
    super.text,
    super.surfaceBounds,
    required this.data,
    required this.point,
    required this.series,
    required this.renderer,
    required this.header,
    required this.seriesIndex,
    required this.segmentIndex,
    required this.pointIndex,
    this.hasMultipleYValues = false,
    this.markerColors = const <Color?>[],
    this.markerBorderColor,
    this.markerType = DataMarkerType.circle,
  });

  final T data;
  final ChartPoint<D> point;
  final ChartSeries<T, D> series;
  final ChartSeriesRenderer<T, D> renderer;
  final String header;
  final int seriesIndex;
  final int segmentIndex;
  final int pointIndex;
  final bool hasMultipleYValues;
  final List<Color?> markerColors;
  final Color? markerBorderColor;
  final DataMarkerType markerType;

  ChartTooltipInfo<T, D> copyWith({
    Offset? primaryPosition,
    Offset? secondaryPosition,
    Rect? surfaceBounds,
    String? text,
    T? data,
    ChartPoint<D>? point,
    ChartSeries<T, D>? series,
    ChartSeriesRenderer<T, D>? renderer,
    String? name,
    int? seriesIndex,
    int? segmentIndex,
    int? pointIndex,
    List<Color?>? markerColors,
    Color? markerBorderColor,
    DataMarkerType? markerShape,
  }) {
    return ChartTooltipInfo<T, D>(
      primaryPosition: primaryPosition ?? this.primaryPosition,
      secondaryPosition: secondaryPosition ?? this.secondaryPosition,
      text: text ?? this.text,
      surfaceBounds: surfaceBounds ?? this.surfaceBounds,
      data: data ?? this.data,
      point: point ?? this.point,
      series: series ?? this.series,
      renderer: renderer ?? this.renderer,
      header: name ?? this.header,
      seriesIndex: seriesIndex ?? this.seriesIndex,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      pointIndex: pointIndex ?? this.pointIndex,
      markerColors: markerColors ?? this.markerColors,
      markerBorderColor: markerBorderColor ?? this.markerBorderColor,
      markerType: markerShape ?? this.markerType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ChartTooltipInfo &&
        other.text == text &&
        other.surfaceBounds == surfaceBounds &&
        other.header == header &&
        other.seriesIndex == seriesIndex &&
        other.segmentIndex == segmentIndex &&
        other.pointIndex == pointIndex;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      primaryPosition,
      secondaryPosition,
      text,
      surfaceBounds,
    ];
    return Object.hashAll(values);
  }
}

@immutable
class TrendlineTooltipInfo<T, D> extends ChartTooltipInfo<T, D> {
  const TrendlineTooltipInfo({
    required super.primaryPosition,
    required super.secondaryPosition,
    super.text,
    super.surfaceBounds,
    required super.data,
    required super.point,
    required super.series,
    required super.renderer,
    required super.header,
    required super.seriesIndex,
    required super.segmentIndex,
    required super.pointIndex,
    super.hasMultipleYValues = false,
    super.markerColors = const <Color?>[],
    super.markerBorderColor,
    super.markerType,
  });
}
