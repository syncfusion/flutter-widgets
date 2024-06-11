import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../axis/axis.dart';
import '../axis/logarithmic_axis.dart';
import '../base.dart';
import '../series/chart_series.dart';
import '../series/histogram_series.dart';
import '../series/waterfall_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'callbacks.dart';
import 'chart_point.dart';
import 'connector_line.dart';
import 'element_widget.dart';

/// Customizes the data label.
///
/// Data labels can be added to a chart series by enabling the [isVisible]
/// option in the dataLabelSettings. It has options to customize the appearance
/// of the data label.
///
/// Provide options like color, border width, border color, alignment and
/// data label text style for customization.
@immutable
class DataLabelSettings {
  /// Creating an argument constructor of DataLabelSettings class.
  const DataLabelSettings({
    this.isVisible = false,
    this.alignment = ChartAlignment.center,
    this.color,
    this.textStyle,
    this.margin = const EdgeInsets.all(5.0),
    this.opacity = 1.0,
    this.labelAlignment = ChartDataLabelAlignment.auto,
    this.borderRadius = 5.0,
    this.angle = 0,
    this.builder,
    this.useSeriesColor = false,
    this.offset = Offset.zero,
    this.showCumulativeValues = false,
    this.showZeroValue = true,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.overflowMode = OverflowMode.none,
    this.labelIntersectAction = LabelIntersectAction.shift,
    this.connectorLineSettings = const ConnectorLineSettings(),
    this.labelPosition = ChartDataLabelPosition.inside,
  });

  /// Alignment of the data label.
  ///
  /// The data label can be aligned far, near, or center of the
  /// data point position.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           alignment: ChartAlignment.center
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartAlignment alignment;

  /// Rotation angle of the data label.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           angle:40
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final int angle;

  /// Border color of the data label.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 2
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Customizes the data label border radius.
  ///
  /// Defaults to `5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           borderRadius: 3,
  ///           borderColor: Colors.red,
  ///           borderWidth: 2
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double borderRadius;

  /// Border width of the data label.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 2
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Builder for data label.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           builder: (dynamic data, dynamic point,
  ///               dynamic series, int pointIndex, int seriesIndex) {
  ///             return Container(
  ///               height: 30,
  ///               width: 30,
  ///               child: Image.asset('images/horse.jpg')
  ///             );
  ///           }
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartWidgetBuilder? builder;

  /// Color of the data label.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           color: Colors.red
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Customizes the connector lines. Connector line is rendered when the
  /// data label is placed outside the chart.
  ///
  ///  _Note:_ This is applicable for pie and doughnut series types alone.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, String>>[
  ///       PieSeries<SalesData, String>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           connectorLineSettings: ConnectorLineSettings(
  ///             width: 6,
  ///             type:ConnectorType.curve
  ///           )
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ConnectorLineSettings connectorLineSettings;

  /// Toggles the visibility of the data label in the series.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Position of the data label.
  ///
  /// _Note:_  This is applicable for Cartesian chart.
  ///
  /// Defaults to `ChartDataLabelAlignment.auto`.
  ///
  /// Also refer [ChartDataLabelAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           labelAlignment: ChartDataLabelAlignment.top
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartDataLabelAlignment labelAlignment;

  /// Action on data labels intersection.
  ///
  /// The intersecting data labels can be hidden.
  ///
  /// _Note:_ This is applicable for pie, doughnut, funnel and
  /// pyramid series types alone.
  ///
  /// Defaults to `LabelIntersectAction.shift`.
  ///
  /// Also refer [LabelIntersectAction].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, num>>[
  ///       PieSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           labelIntersectAction: LabelIntersectAction.shift
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final LabelIntersectAction labelIntersectAction;

  /// Position of the data label.
  ///
  /// _Note:_  This is applicable for pie and doughnut series types alone.
  ///
  /// Defaults to `ChartDataLabelPosition.inside`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, num>>[
  ///       PieSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           labelPosition: ChartDataLabelPosition.outside
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartDataLabelPosition labelPosition;

  /// Margin between the data label text and its shape.
  ///
  /// Defaults to `EdgeInsets.fromLTRB(5, 5, 5, 5)`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           margin: const EdgeInsets.all(2),
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final EdgeInsets margin;

  /// Moves the data label vertically or horizontally from its position.
  ///
  /// If you wish to reposition the data label, you can achieve using this
  /// property. You can move the data label in both vertical and horizontal
  /// direction from its position. It takes the logical pixel value for
  /// x and y values as input.
  ///
  /// Positive value for x, moves the data label to right and negative value
  /// moves to left.
  /// Positive value for y, moves the data label upwards and negative value
  /// moves downwards.
  ///
  /// These are applied to the data label's final position. i.e. after
  /// considering the position and alignment values.
  ///
  /// Also refer [labelAlignment].
  ///
  /// _Note:_  This property is only applicable for Cartesian charts and not for
  /// Circular, Pyramid and Funnel charts.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           offset: Offset(200,200)
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Offset offset;

  /// Opacity of the data label.
  ///
  /// The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           opacity: 0.8
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double opacity;

  /// Action on data labels when it’s overflowing from its region area.
  ///
  /// The overflowing data label rendering behavior can be changed based
  /// on this. If `overflowMode` property is set to `OverflowMode.none`
  /// then the `labelIntersectAction` takes the priority, else
  /// `overflowMode` takes the priority.
  ///
  /// _Note:_ This is applicable for pie, doughnut, pyramid, and funnel series
  /// types alone.
  ///
  /// Defaults to `OverflowMode.none`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, num>>[
  ///       PieSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           overflowMode: OverflowMode.shift
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final OverflowMode overflowMode;

  /// To show the cumulative values in stacked type series charts.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true
  ///         ),
  ///       ),
  ///       StackedColumnSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           showCumulativeValues: true
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showCumulativeValues;

  /// Hides the data label and its connector line, if the
  /// data point value is 0 (Zero).
  ///
  /// If the data label is enabled, it will be visible for all the data points
  /// in the series. By using this property, we can hide the data label and its
  /// connector line, for the data points if its value is 0 (Zero).
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCircularChart(
  ///     series: <PieSeries<SalesData, num>>[
  ///       PieSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           showZeroValue: false
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showZeroValue;

  /// Customizes the data label font.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           textStyle: TextStyle(
  ///             fontSize: 12
  ///           )
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Uses the series color for filling the data label shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         dataLabelSettings: DataLabelSettings(
  ///           isVisible: true,
  ///           useSeriesColor: true
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool useSeriesColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DataLabelSettings &&
        other.alignment == alignment &&
        other.color == color &&
        other.textStyle == textStyle &&
        other.margin == margin &&
        other.opacity == opacity &&
        other.labelAlignment == labelAlignment &&
        other.borderRadius == borderRadius &&
        other.isVisible == isVisible &&
        other.angle == angle &&
        other.builder == builder &&
        other.useSeriesColor == useSeriesColor &&
        other.offset == offset &&
        other.showCumulativeValues == showCumulativeValues &&
        other.showZeroValue == showZeroValue &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.overflowMode == overflowMode &&
        other.labelIntersectAction == labelIntersectAction &&
        other.connectorLineSettings == connectorLineSettings &&
        other.labelPosition == labelPosition;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      alignment,
      color,
      textStyle,
      margin,
      opacity,
      labelAlignment,
      borderRadius,
      isVisible,
      angle,
      builder,
      useSeriesColor,
      offset,
      showCumulativeValues,
      showZeroValue,
      borderColor,
      borderWidth,
      overflowMode,
      labelIntersectAction,
      connectorLineSettings,
      labelPosition
    ];
    return Object.hashAll(values);
  }
}

typedef _ChartDataLabelWidgetBuilder<T, D> = Widget Function(
  T data,
  int yIndex,
  ChartSeries<T, D> series,
  int pointIndex,
  int seriesIndex,
  ChartDataPointType position,
);

// ignore: must_be_immutable
class CartesianChartDataLabelPositioned
    extends ParentDataWidget<ChartElementParentData>
    with LinkedListEntry<CartesianChartDataLabelPositioned> {
  CartesianChartDataLabelPositioned({
    super.key,
    required this.x,
    required this.y,
    required this.dataPointIndex,
    required this.position,
    required super.child,
  });

  final num x;
  final num y;
  final int dataPointIndex;
  final ChartDataPointType position;

  Offset offset = Offset.zero;
  Size size = Size.zero;
  Rect bounds = Rect.zero;
  Rect rotatedBounds = Rect.zero;
  bool isVisible = true;
  ChartDataLabelAlignment labelAlignment = ChartDataLabelAlignment.auto;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ChartElementParentData);
    final ChartElementParentData parentData =
        renderObject.parentData! as ChartElementParentData;
    bool needsLayout = false;

    if (parentData.x != x) {
      parentData.x = x;
      needsLayout = true;
    }

    if (parentData.y != y) {
      parentData.y = y;
      needsLayout = true;
    }

    if (parentData.dataPointIndex != dataPointIndex) {
      parentData.dataPointIndex = dataPointIndex;
      needsLayout = true;
    }

    if (parentData.position != position) {
      parentData.position = position;
      needsLayout = true;
    }

    if (needsLayout) {
      final RenderObject? targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CartesianDataLabelStack;
}

// ignore: must_be_immutable
class DataLabelText extends Widget {
  DataLabelText({
    super.key,
    required this.text,
    required this.textStyle,
    this.color = Colors.transparent,
  });

  String text;
  TextStyle textStyle;
  Color color;

  @override
  Element createElement() {
    throw UnimplementedError();
  }

  @override
  String toStringShort() {
    return text;
  }
}

class CartesianDataLabelContainer<T, D> extends StatefulWidget {
  const CartesianDataLabelContainer({
    super.key,
    required this.series,
    required this.dataSource,
    this.mapper,
    this.builder,
    required this.settings,
    required this.positions,
  });

  final ChartWidgetBuilder<T, D>? builder;
  final List<T> dataSource;
  final ChartValueMapper<T, String>? mapper;
  final ChartSeries<T, D> series;
  final DataLabelSettings settings;
  final List<ChartDataPointType> positions;

  @override
  State<CartesianDataLabelContainer<T, D>> createState() =>
      _CartesianDataLabelContainerState<T, D>();
}

class _CartesianDataLabelContainerState<T, D>
    extends State<CartesianDataLabelContainer<T, D>>
    with ChartElementParentDataMixin<T, D> {
  List<CartesianChartDataLabelPositioned>? _builderChildren;
  LinkedList<CartesianChartDataLabelPositioned>? _textChildren;

  @override
  CartesianSeriesRenderer<T, D>? get renderer =>
      super.renderer as CartesianSeriesRenderer<T, D>?;

  Widget _dataLabelFromBuilder(
    T data,
    int yIndex,
    ChartSeries<T, D> series,
    int pointIndex,
    int seriesIndex,
    ChartDataPointType position,
  ) {
    final ChartPoint<D> point = renderer!.chartPoints[pointIndex];
    return widget.builder!(data, point, series, pointIndex, seriesIndex);
  }

  Widget _dataLabelFromMapper(
    T data,
    int yIndex,
    ChartSeries<T, D> series,
    int pointIndex,
    int seriesIndex,
    ChartDataPointType position,
  ) {
    final String text = widget.mapper!(data, pointIndex) ?? '';
    return _buildDataLabelText(text, pointIndex);
  }

  Widget _defaultDataLabel(
    T data,
    int yIndex,
    ChartSeries<T, D> series,
    int pointIndex,
    int seriesIndex,
    ChartDataPointType position,
  ) {
    final DataLabelSettings settings = widget.settings;
    final num value = stackedYValues != null && !settings.showCumulativeValues
        ? stackedYValues![pointIndex]
        : yLists![yIndex][pointIndex];
    final String formattedText = formatNumericValue(value, renderer!.yAxis);
    return _buildDataLabelText(formattedText, pointIndex);
  }

  Color _dataPointColor(int dataPointIndex) {
    final DataLabelSettings settings = widget.settings;
    if (settings.color != null) {
      return settings.color!.withOpacity(settings.opacity);
    } else if (settings.useSeriesColor) {
      final Color? pointColor = renderer!.pointColors.isNotEmpty
          ? renderer!.pointColors[dataPointIndex]
          : null;
      return (pointColor ?? renderer!.color ?? renderer!.paletteColor)
          .withOpacity(settings.opacity);
    } else {
      return Colors.transparent;
    }
  }

  DataLabelText _buildDataLabelText(String text, int pointIndex) {
    final RenderChartPlotArea parent = renderer!.parent!;
    final TextStyle dataLabelTextStyle = parent.themeData!.textTheme.bodySmall!
        .copyWith(color: Colors.transparent)
        .merge(parent.chartThemeData!.dataLabelTextStyle)
        .merge(widget.settings.textStyle);
    return DataLabelText(
      text: text,
      textStyle: dataLabelTextStyle,
      color: _dataPointColor(pointIndex),
    );
  }

  void _addToList(CartesianChartDataLabelPositioned child) {
    _builderChildren!.add(child);
  }

  void _addToLinkedList(CartesianChartDataLabelPositioned child) {
    _textChildren!.add(child);
  }

  void _buildLinearDataLabels(_ChartDataLabelWidgetBuilder<T, D> callback,
      Function(CartesianChartDataLabelPositioned) add) {
    final int yLength = yLists?.length ?? 0;
    List<Object?>? actualXValues;
    if (xRawValues != null && xRawValues!.isNotEmpty) {
      actualXValues = xRawValues;
    } else {
      actualXValues = xValues;
    }

    if (actualXValues == null || renderer!.visibleIndexes.isEmpty) {
      return;
    }

    final bool isEmptyMode = renderer! is! WaterfallSeriesRenderer<T, D> &&
        (renderer!.emptyPointSettings.mode == EmptyPointMode.drop ||
            renderer!.emptyPointSettings.mode == EmptyPointMode.gap);

    final bool hasSortedIndexes = renderer!.sortingOrder != SortingOrder.none &&
        sortedIndexes != null &&
        sortedIndexes!.isNotEmpty;

    final int start = renderer!.visibleIndexes[0];
    final int end = renderer!.visibleIndexes[1];
    final int xLength = actualXValues.length;
    for (int i = start; i <= end && i < xLength; i++) {
      _obtainLabel(i, actualXValues, yLength, callback, add, isEmptyMode,
          hasSortedIndexes);
    }
  }

  void _buildNonLinearDataLabels(_ChartDataLabelWidgetBuilder<T, D> callback,
      Function(CartesianChartDataLabelPositioned) add) {
    final int yLength = yLists?.length ?? 0;
    List<Object?>? actualXValues;
    if (xRawValues != null && xRawValues!.isNotEmpty) {
      actualXValues = xRawValues;
    } else {
      actualXValues = xValues;
    }

    if (actualXValues == null || renderer!.visibleIndexes.isEmpty) {
      return;
    }

    final bool isEmptyMode = renderer! is! WaterfallSeriesRenderer<T, D> &&
        (renderer!.emptyPointSettings.mode == EmptyPointMode.drop ||
            renderer!.emptyPointSettings.mode == EmptyPointMode.gap);

    final bool hasSortedIndexes = renderer!.sortingOrder != SortingOrder.none &&
        sortedIndexes != null &&
        sortedIndexes!.isNotEmpty;

    final int xLength = actualXValues.length;
    for (final int index in renderer!.visibleIndexes) {
      if (index < xLength) {
        _obtainLabel(index, actualXValues, yLength, callback, add, isEmptyMode,
            hasSortedIndexes);
      }
    }
  }

  void _obtainLabel(
    int index,
    List<Object?> rawXValues,
    int yLength,
    _ChartDataLabelWidgetBuilder<T, D> callback,
    Function(CartesianChartDataLabelPositioned) add,
    bool isEmptyMode,
    bool hasSortedIndexes,
  ) {
    if (isEmptyMode && renderer!.emptyPointIndexes.contains(index)) {
      return;
    }

    int pointIndex = hasSortedIndexes ? sortedIndexes![index] : index;
    final bool isHisto = renderer is HistogramSeriesRenderer;
    final int dataSourceLength = widget.dataSource.length;
    final num x = xValues![index];
    for (int k = 0; k < yLength; k++) {
      final List<num> yValues = yLists![k];
      final ChartDataPointType position = widget.positions[k];
      if (isHisto && pointIndex >= dataSourceLength) {
        pointIndex = dataSourceLength - 1;
      }
      final CartesianChartDataLabelPositioned child =
          CartesianChartDataLabelPositioned(
        x: x,
        y: yValues[index],
        dataPointIndex: index,
        position: position,
        child: callback(
          widget.dataSource[pointIndex],
          k,
          widget.series,
          index,
          renderer!.index,
          position,
        ),
      );
      add(child);
    }
  }

  @override
  void dispose() {
    _builderChildren?.clear();
    _textChildren?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChartElementLayoutBuilder<T, D>(
      state: this,
      builder: (BuildContext context, BoxConstraints constraints) {
        _builderChildren?.clear();
        _textChildren?.clear();
        if (renderer != null &&
            renderer!.controller.isVisible &&
            yLists != null &&
            yLists!.isNotEmpty) {
          _ChartDataLabelWidgetBuilder<T, D> callback;
          if (widget.builder != null) {
            callback = _dataLabelFromBuilder;
          } else {
            callback = widget.mapper != null
                ? _dataLabelFromMapper
                : _defaultDataLabel;
          }
          void Function(CartesianChartDataLabelPositioned child) add;
          if (widget.builder != null) {
            _builderChildren = <CartesianChartDataLabelPositioned>[];
            add = _addToList;
          } else {
            _textChildren = LinkedList<CartesianChartDataLabelPositioned>();
            add = _addToLinkedList;
          }

          if (xValues != null && xValues!.isNotEmpty) {
            if (renderer!.canFindLinearVisibleIndexes) {
              _buildLinearDataLabels(callback, add);
            } else {
              _buildNonLinearDataLabels(callback, add);
            }
          }
        }

        return ChartFadeTransition(
          opacity: animation!,
          child: CartesianDataLabelStack<T, D>(
            series: renderer,
            settings: widget.settings,
            labels: _textChildren,
            children: _builderChildren ?? <CartesianChartDataLabelPositioned>[],
          ),
        );
      },
    );
  }
}

class CartesianDataLabelStack<T, D> extends ChartElementStack {
  const CartesianDataLabelStack({
    super.key,
    required this.series,
    required this.labels,
    required this.settings,
    super.children,
  });

  final CartesianSeriesRenderer<T, D>? series;
  final LinkedList<CartesianChartDataLabelPositioned>? labels;
  final DataLabelSettings settings;

  @override
  RenderCartesianDataLabelStack<T, D> createRenderObject(BuildContext context) {
    return RenderCartesianDataLabelStack<T, D>()
      ..series = series
      ..labels = labels
      ..settings = settings;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCartesianDataLabelStack<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..series = series
      ..labels = labels
      ..settings = settings;
  }
}

class RenderCartesianDataLabelStack<T, D> extends RenderChartElementStack {
  late CartesianSeriesRenderer<T, D>? series;
  late LinkedList<CartesianChartDataLabelPositioned>? labels;
  late DataLabelSettings settings;

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return false;
  }

  @override
  bool hitTestSelf(Offset position) {
    return series?.parent?.onDataLabelTapped != null;
  }

  int _findSelectedDataLabelIndex(Offset localPosition) {
    if (series?.parent?.onDataLabelTapped == null) {
      return -1;
    }

    if (childCount > 0) {
      RenderBox? child = lastChild;
      while (child != null) {
        final ChartElementParentData childParentData =
            child.parentData! as ChartElementParentData;
        if ((childParentData.offset & child.size).contains(localPosition)) {
          return childParentData.dataPointIndex;
        }
        child = childParentData.previousSibling;
      }
    } else if (labels != null) {
      for (int i = labels!.length - 1; i > -1; i--) {
        final CartesianChartDataLabelPositioned label = labels!.elementAt(i);
        final Rect rect = Rect.fromLTWH(
          label.offset.dx,
          label.offset.dy,
          label.size.width + settings.margin.horizontal,
          label.size.height + settings.margin.vertical,
        );
        if (rect.contains(localPosition)) {
          return label.dataPointIndex;
        }
      }
    }
    return -1;
  }

  @override
  void handleTapUp(Offset localPosition) {
    if (series?.parent?.onDataLabelTapped != null) {
      final int selectedIndex = _findSelectedDataLabelIndex(localPosition);
      if (selectedIndex == -1) {
        return;
      }

      final String text = childCount > 0
          ? ''
          : (labels!.elementAt(selectedIndex).child as DataLabelText).text;
      series!.parent!.onDataLabelTapped!(DataLabelTapDetails(
        series!.index,
        series!.viewportIndex(selectedIndex),
        text,
        settings,
        selectedIndex,
      ));
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child is! ChartElementParentData) {
      child.parentData = ChartElementParentData();
    }
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    if (series == null || series!.xAxis == null || series!.yAxis == null) {
      return;
    }

    if (childCount > 0) {
      ChartElementParentData? previousChildData;
      RenderBox? child = firstChild;
      while (child != null) {
        final ChartElementParentData currentChildData =
            child.parentData! as ChartElementParentData;
        currentChildData.isVisible = true;
        final RenderBox? nextSibling = currentChildData.nextSibling;
        ChartElementParentData? nextChildData;
        if (nextSibling != null) {
          nextChildData = nextSibling.parentData! as ChartElementParentData;
        }
        child.layout(constraints, parentUsesSize: true);
        currentChildData.labelAlignment = series!.effectiveDataLabelAlignment(
          settings.labelAlignment,
          currentChildData.position,
          previousChildData,
          currentChildData,
          nextChildData,
        );
        currentChildData.offset = _calculateAlignedPosition(
          currentChildData.labelAlignment,
          previousChildData,
          currentChildData,
          nextChildData,
          child.size,
        );
        currentChildData.offset +=
            _invokeDataLabelRender(currentChildData.dataPointIndex);
        currentChildData.bounds =
            _calculateBounds(child.size, currentChildData.offset);
        currentChildData.rotatedBounds =
            _calculateRotatedBounds(currentChildData.bounds);
        child = nextSibling;
        previousChildData = currentChildData;
      }
    } else if (labels != null) {
      ChartElementParentData? previousLabelData;
      ChartElementParentData? nextLabelData;
      for (final CartesianChartDataLabelPositioned currentLabel in labels!) {
        currentLabel.isVisible = true;
        final ChartElementParentData currentLabelData =
            nextLabelData ?? ChartElementParentData()
              ..x = currentLabel.x
              ..y = currentLabel.y
              ..dataPointIndex = currentLabel.dataPointIndex
              ..position = currentLabel.position;
        final CartesianChartDataLabelPositioned? nextLabel = currentLabel.next;
        if (nextLabel != null) {
          nextLabelData = ChartElementParentData()
            ..x = nextLabel.x
            ..y = nextLabel.y
            ..dataPointIndex = nextLabel.dataPointIndex
            ..position = nextLabel.position;
        }
        final DataLabelText details = currentLabel.child as DataLabelText;
        currentLabel.offset =
            _invokeDataLabelRender(currentLabel.dataPointIndex, details);
        currentLabel.size = measureText(details.text, details.textStyle);
        currentLabel.labelAlignment = series!.effectiveDataLabelAlignment(
          settings.labelAlignment,
          currentLabel.position,
          previousLabelData,
          currentLabelData,
          nextLabelData,
        );
        currentLabel.offset += _calculateAlignedPosition(
          currentLabel.labelAlignment,
          previousLabelData,
          currentLabelData,
          nextLabelData,
          currentLabel.size,
        );
        currentLabel.bounds =
            _calculateBounds(currentLabel.size, currentLabel.offset);
        currentLabel.rotatedBounds =
            _calculateRotatedBounds(currentLabel.bounds);
        previousLabelData = currentLabelData;
      }
    }

    _handleLabelIntersectAction();
  }

  Offset _invokeDataLabelRender(int pointIndex, [DataLabelText? details]) {
    if (series!.parent?.onDataLabelRender != null) {
      final DataLabelRenderArgs dataLabelArgs = DataLabelRenderArgs(
        seriesRenderer: series,
        dataPoints: series!.chartPoints,
        viewportPointIndex: series!.viewportIndex(pointIndex),
        pointIndex: pointIndex,
      )..offset = settings.offset;
      if (details != null) {
        dataLabelArgs
          ..text = details.text
          ..textStyle = details.textStyle
          ..color = details.color;
      }

      series!.parent!.onDataLabelRender!(dataLabelArgs);
      if (details != null) {
        details
          ..text = dataLabelArgs.text ?? ''
          ..textStyle = details.textStyle.merge(dataLabelArgs.textStyle)
          ..color = dataLabelArgs.color;
      }

      return dataLabelArgs.offset;
    }

    return Offset.zero;
  }

  Offset _calculateAlignedPosition(
    ChartDataLabelAlignment alignment,
    ChartElementParentData? previous,
    ChartElementParentData current,
    ChartElementParentData? next,
    Size size,
  ) {
    final Offset position = series!.dataLabelPosition(current, alignment, size);

    ChartAlignment? xAlignment;
    ChartAlignment? yAlignment;
    if (series!.isTransposed) {
      yAlignment = ChartAlignment.center;
      if (settings.alignment != ChartAlignment.center) {
        xAlignment = settings.alignment;
      }
    } else {
      xAlignment = ChartAlignment.center;
      if (settings.alignment != ChartAlignment.center) {
        yAlignment = settings.alignment;
      }
    }
    final double x =
        _addPlacementAlignment(xAlignment, position.dx, size.width);
    final double y =
        _addPlacementAlignment(yAlignment, position.dy, size.height);
    return _alignWithInRange(current.x!, current.y!, x, y, paintBounds, size);
  }

  double _addPlacementAlignment(
      ChartAlignment? alignment, double position, double size) {
    if (alignment == null) {
      return position;
    }

    switch (alignment) {
      case ChartAlignment.near:
        return position + size;
      case ChartAlignment.far:
        return position - size;
      case ChartAlignment.center:
        return position - size / 2;
    }
  }

  Offset _alignWithInRange(num xPoint, num yPoint, double labelX, double labelY,
      Rect source, Size size) {
    final DoubleRange xRange = series!.xAxis!.effectiveVisibleRange!;
    final DoubleRange yRange = series!.yAxis!.effectiveVisibleRange!;
    num xValue = xPoint;
    if (series!.xAxis! is RenderLogarithmicAxis) {
      xValue = (series!.xAxis! as RenderLogarithmicAxis).toLog(xValue);
    }

    num yValue = yPoint;
    if (series!.yAxis! is RenderLogarithmicAxis) {
      yValue = (series!.yAxis! as RenderLogarithmicAxis).toLog(yValue);
    }

    if (!xRange.contains(xValue) || !yRange.contains(yValue)) {
      return const Offset(double.nan, double.nan);
    }

    if (labelX < source.left) {
      labelX = source.left;
    } else if (labelX + size.width > source.right) {
      labelX = source.right - size.width - settings.margin.horizontal;
    }

    if (labelY < source.top) {
      labelY = source.top;
    } else if (labelY + size.height > source.bottom) {
      labelY = source.bottom - size.height - settings.margin.vertical;
    }

    return Offset(labelX, labelY);
  }

  Rect _calculateBounds(Size childSize, Offset offset) {
    return Rect.fromLTWH(
      offset.dx + settings.offset.dx,
      offset.dy - settings.offset.dy,
      childSize.width + settings.margin.horizontal,
      childSize.height + settings.margin.vertical,
    );
  }

  Rect _calculateRotatedBounds(Rect labelBounds) {
    final center = labelBounds.center;
    final radius = settings.angle * pi / 180;
    final corner1 = _rotatePoint(labelBounds.topLeft, center, radius);
    final corner2 = _rotatePoint(labelBounds.topRight, center, radius);
    final corner3 = _rotatePoint(labelBounds.bottomRight, center, radius);
    final corner4 = _rotatePoint(labelBounds.bottomLeft, center, radius);

    final left = min(corner1.dx, min(corner2.dx, min(corner3.dx, corner4.dx)));
    final right = max(corner1.dx, max(corner2.dx, max(corner3.dx, corner4.dx)));
    final top = min(corner1.dy, min(corner2.dy, min(corner3.dy, corner4.dy)));
    final bottom =
        max(corner1.dy, max(corner2.dy, max(corner3.dy, corner4.dy)));

    return Rect.fromLTWH(left, top, right - left, bottom - top);
  }

  Offset _rotatePoint(Offset point, Offset center, double radius) {
    final double dx = point.dx - center.dx;
    final double dy = point.dy - center.dy;
    return Offset(
      dx * cos(radius) - dy * sin(radius) + center.dx,
      dx * sin(radius) + dy * cos(radius) + center.dy,
    );
  }

  void _handleLabelIntersectAction() {
    if (series!.dataLabelSettings.labelIntersectAction !=
        LabelIntersectAction.none) {
      if (childCount > 0) {
        _handleLabelIntersectActionForWidgets();
      } else if (labels != null) {
        _handleLabelIntersectActionForLabels();
      }
    }
  }

  void _handleLabelIntersectActionForWidgets() {
    RenderBox? child = firstChild;
    while (child != null) {
      final ChartElementParentData currentChildData =
          child.parentData! as ChartElementParentData;
      if (!currentChildData.isVisible) {
        child = currentChildData.nextSibling;
        continue;
      }

      RenderBox? nextSibling = currentChildData.nextSibling;
      ChartElementParentData? nextChildData;
      currentChildData.isVisible = true;
      while (nextSibling != null) {
        nextChildData = nextSibling.parentData! as ChartElementParentData;
        if (!currentChildData.rotatedBounds.topLeft.isNaN &&
            !currentChildData.rotatedBounds.bottomRight.isNaN &&
            currentChildData.rotatedBounds
                .overlaps(nextChildData.rotatedBounds)) {
          nextChildData.isVisible = false;
        }
        nextSibling = nextChildData.nextSibling;
      }
      child = currentChildData.nextSibling;
    }
  }

  void _handleLabelIntersectActionForLabels() {
    for (final CartesianChartDataLabelPositioned label in labels!) {
      if (!label.isVisible) {
        continue;
      }
      CartesianChartDataLabelPositioned? nextLabel = label.next;
      while (nextLabel != null) {
        if (!label.rotatedBounds.topLeft.isNaN &&
            !label.rotatedBounds.bottomRight.isNaN &&
            label.rotatedBounds.overlaps(nextLabel.rotatedBounds)) {
          nextLabel.isVisible = false;
        }
        nextLabel = nextLabel.next;
      }
    }
  }

  @override
  void handleMultiSeriesDataLabelCollisions() {
    if (childCount > 0) {
      _handleMultiSeriesDataLabelCollisionsForWidgets();
    } else if (labels != null) {
      _handleMultiSeriesDataLabelCollisionsForLabels();
    }
  }

  void _handleMultiSeriesDataLabelCollisionsForWidgets() {
    series?.parent?.visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer &&
          child.controller.isVisible &&
          child.index != series!.index &&
          child.index > series!.index &&
          child.dataLabelSettings.isVisible &&
          child.dataLabelSettings.labelIntersectAction !=
              LabelIntersectAction.none) {
        final RenderBox? nextSeriesDataLabelRenderBox =
            child.dataLabelContainer?.child;

        RenderBox? currentChild = firstChild;
        while (currentChild != null) {
          final ChartElementParentData currentChildData =
              currentChild.parentData! as ChartElementParentData;
          if (!currentChildData.isVisible) {
            currentChild = currentChildData.nextSibling;
            continue;
          }

          nextSeriesDataLabelRenderBox
              ?.visitChildren((RenderObject nextSeriesDataLabel) {
            final RenderCartesianDataLabelStack<T, D>?
                nextSeriesDataLabelStack =
                nextSeriesDataLabel as RenderCartesianDataLabelStack<T, D>;
            if (nextSeriesDataLabelStack!.childCount > 0) {
              RenderBox? nextChild = nextSeriesDataLabelStack.firstChild;
              while (nextChild != null) {
                final ChartElementParentData nextChildData =
                    nextChild.parentData! as ChartElementParentData;
                if (!nextChildData.isVisible) {
                  nextChild = nextChildData.nextSibling;
                  continue;
                }

                if (currentChildData.rotatedBounds
                    .overlaps(nextChildData.rotatedBounds)) {
                  nextChildData.isVisible = false;
                }
                nextChild = nextChildData.nextSibling;
              }
            }
          });
          currentChild = currentChildData.nextSibling;
        }
      }
    });
  }

  void _handleMultiSeriesDataLabelCollisionsForLabels() {
    series?.parent?.visitChildren((RenderObject child) {
      if (child is CartesianSeriesRenderer &&
          child.controller.isVisible &&
          child.index != series!.index &&
          child.index > series!.index &&
          child.dataLabelSettings.isVisible &&
          child.dataLabelSettings.labelIntersectAction !=
              LabelIntersectAction.none) {
        final RenderBox? nextSeriesDataLabelRenderBox =
            child.dataLabelContainer?.child;
        for (final CartesianChartDataLabelPositioned currentLabel in labels!) {
          if (!currentLabel.isVisible) {
            continue;
          }

          nextSeriesDataLabelRenderBox
              ?.visitChildren((RenderObject nextSeriesDataLabel) {
            final RenderCartesianDataLabelStack<T, D>?
                nextSeriesDataLabelStack =
                nextSeriesDataLabel as RenderCartesianDataLabelStack<T, D>;
            final LinkedList<CartesianChartDataLabelPositioned>? nextLabels =
                nextSeriesDataLabelStack!.labels;
            if (nextLabels != null && nextLabels.isNotEmpty) {
              for (final CartesianChartDataLabelPositioned nextLabel
                  in nextLabels) {
                if (!nextLabel.isVisible) {
                  continue;
                }

                if (!currentLabel.rotatedBounds.topLeft.isNaN &&
                    !currentLabel.rotatedBounds.bottomRight.isNaN &&
                    currentLabel.rotatedBounds
                        .overlaps(nextLabel.rotatedBounds)) {
                  nextLabel.isVisible = false;
                  break;
                }
              }
            }
          });
        }
      }
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (series == null || series!.xAxis == null || series!.yAxis == null) {
      return;
    }

    context.canvas
      ..save()
      ..clipRect(paintBounds);
    if (childCount > 0) {
      final EdgeInsets margin = settings.margin;
      final Offset marginOffset =
          offset + Offset(margin.horizontal / 2, margin.vertical);
      RenderBox? child = firstChild;
      while (child != null) {
        final ChartElementParentData childParentData =
            child.parentData! as ChartElementParentData;
        if (!childParentData.offset.isNaN && childParentData.isVisible) {
          context.paintChild(child, childParentData.offset + marginOffset);
        }
        child = childParentData.nextSibling;
      }
    } else if (labels != null) {
      final Paint fillPaint = Paint()..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()
        ..color = settings.borderColor
        ..strokeWidth = settings.borderWidth
        ..style = PaintingStyle.stroke;
      for (final CartesianChartDataLabelPositioned label in labels!) {
        if (label.offset.isNaN || !label.isVisible) {
          continue;
        }

        Color surfaceColor = series!.dataLabelSurfaceColor(label);
        final DataLabelText details = label.child as DataLabelText;
        surfaceColor =
            details.color == Colors.transparent ? surfaceColor : details.color;
        final TextStyle effectiveTextStyle =
            saturatedTextStyle(surfaceColor, details.textStyle);
        fillPaint
          ..color = details.color
          ..shader = series!.markerShader(label.offset & label.size);
        series!.drawDataLabelWithBackground(
          label.dataPointIndex,
          context.canvas,
          details.text,
          label.offset,
          settings.angle,
          effectiveTextStyle,
          fillPaint,
          strokePaint,
        );
      }
    }
    context.canvas.restore();
  }
}
