// ignore_for_file: always_specify_types

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../../charts.dart';
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../utils/helper.dart';

/// Class which holds the properties of multi-level labels
class ChartMultiLevelLabel<T> {
  /// Constructor for ChartMultiLevelLabel class
  const ChartMultiLevelLabel({this.start, this.end, int? level, this.text})
      : level = level ?? 0;

  /// Start value of the multi-level label.
  /// The value from where the multi-level label border needs to start.
  ///
  /// The [start] value for the category axis needs to string type, in the case of
  ///  date-time or date-time category axes need to be date-time and in the
  /// case of numeric or logarithmic axes need to double.
  ///
  /// Defaults to 'null'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis:
  ///         NumericAxis(multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final T? start;

  /// End value of the multi-level label.
  /// The value where the multi-level label border needs to end.
  ///
  /// The [end] value for the category axis need to string type, in the case of
  ///  date-time or date-time category axes need to be date-time and in the
  /// case of numeric or logarithmic axes need to double.
  ///
  /// Defaults to 'null'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis:
  ///         NumericAxis(multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final T? end;

  /// Text to be displayed in grouping label as the multi-level label.
  ///
  /// Defaults to 'null'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis:
  ///         NumericAxis(multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final String? text;

  /// Level specifies in which row the multi-level label should be positioned.
  ///
  /// Defaults to '0'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis:
  ///         NumericAxis(multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First Level',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final int? level;
}

/// Provides options to customize the start, the end value of a multi-level label,
/// text, and level of the multi-level labels.
///
/// The [start] and [end] values need to be double type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis: NumericAxis(
///         multiLevelLabels: const <NumericMultiLevelLabel>[
///           NumericMultiLevelLabel(
///             start: 0,
///             end: 2,
///             text: 'First',
///           ),
///           NumericMultiLevelLabel(
///             start: 2,
///             end: 4,
///             text: 'Second',
///           )
///         ]
///       )
///     )
///   );
/// }
///```
class NumericMultiLevelLabel extends ChartMultiLevelLabel<double> {
  /// Constructor for NumericMultiLevelLabel class
  const NumericMultiLevelLabel({this.start, this.end, int? level, String? text})
      : super(start: start, end: end, text: text, level: level);

  @override
  final double? start;

  @override
  final double? end;
}

/// Provides options to customize the start, the end value of a multi-level label,
///  text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be string type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis: CategoryAxis(
///         multiLevelLabels: const <CategoricalMultiLevelLabel>[
///           CategoricalMultiLevelLabel(start: 'Jan', end: 'Feb', text: 'First')
///         ]
///       )
///     )
///   );
/// }
///```
class CategoricalMultiLevelLabel extends ChartMultiLevelLabel<String> {
  /// Constructor for CategoricalMultiLevelLabel class
  const CategoricalMultiLevelLabel(
      {this.start, this.end, int? level, String? text})
      : super(start: start, end: end, text: text, level: level);

  @override
  final String? start;

  @override
  final String? end;
}

/// Provides options to customize the start, the end value of a multi-level label,
///  text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be date-time type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis: DateTimeAxis(
///         multiLevelLabels: <DateTimeMultiLevelLabel>[
///           DateTimeMultiLevelLabel(
///             start: DateTime(2020, 2, 3),
///             end: DateTime(2020, 2, 5),
///             text: 'First'
///           )
///         ]
///       )
///     )
///   );
/// }
///```
class DateTimeMultiLevelLabel extends ChartMultiLevelLabel<DateTime> {
  /// Constructor for DateTimeMultiLevelLabel class
  const DateTimeMultiLevelLabel(
      {this.start, this.end, int? level, String? text})
      : super(start: start, end: end, text: text, level: level);

  @override
  final DateTime? start;

  @override
  final DateTime? end;
}

/// Provides options to customize the start, the end value of a multi-level label,
///  text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be date-time type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis: DateTimeCategoryAxis(
///         multiLevelLabels: <DateTimeCategoricalMultiLevelLabel>[
///           DateTimeCategoricalMultiLevelLabel(
///             start: DateTime(2020, 2, 3),
///             end: DateTime(2020, 2, 5),
///             text: 'First'
///           )
///         ]
///       )
///     )
///   );
/// }
///```
class DateTimeCategoricalMultiLevelLabel extends DateTimeMultiLevelLabel {
  /// Constructor for DateTimeCategoryMultiLevelLabel class
  const DateTimeCategoricalMultiLevelLabel(
      {this.start, this.end, int? level, String? text})
      : super(start: start, end: end, text: text, level: level);

  @override
  final DateTime? start;

  @override
  final DateTime? end;
}

/// Provides options to customize the start, the end value of a multi-level label,
/// text, and level of the multi-level labels.
///
/// The [start] and [end] values need to be double type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis:
///         LogarithmicAxis(multiLevelLabels: const <LogarithmicMultiLevelLabel>[
///           LogarithmicMultiLevelLabel(
///             start: 0,
///             end: 4,
///             text: 'First',
///           )
///         ]
///       )
///     )
///   );
/// }
///```
class LogarithmicMultiLevelLabel extends NumericMultiLevelLabel {
  /// Constructor for LogarithmicMultiLevelLabel class
  const LogarithmicMultiLevelLabel(
      {this.start, this.end, int? level, String? text})
      : super(start: start, end: end, text: text, level: level);

  @override
  final double? start;

  @override
  final double? end;
}

/// Customize the multi-level label’s border color, width, type, and
/// text style such as color, font size, etc.
///
/// When the multi-level label’s width exceeds its respective segment,
/// then the label will get trimmed and on tapping / hovering over the trimmed label,
///  a tooltip will be shown.
///
/// Also refer [multiLevelLabelFormatter].
///
class MultiLevelLabelStyle {
  /// Creating an argument constructor of MultiLevelLabelStyle class.
  const MultiLevelLabelStyle(
      {this.textStyle,
      this.borderWidth = 0,
      this.borderColor,
      this.borderType = MultiLevelBorderType.rectangle});

  /// Specifies the text style of the multi-level labels.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabelStyle: MultiLevelLabelStyle(
  ///           textStyle: TextStyle(
  ///           fontSize: 10,
  ///           color: Colors.black,
  ///           )
  ///         ),
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final TextStyle? textStyle;

  /// Specifies the border width of multi-level labels.
  ///
  ///  Defaults to '0'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabelStyle: MultiLevelLabelStyle(
  ///           borderWidth: 2.0
  ///         ),
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final double borderWidth;

  /// Specifies the border color of multi-level labels.
  ///
  ///  Defaults to 'null'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabelStyle: MultiLevelLabelStyle(
  ///           borderColor: Colors.black
  ///         ),
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final Color? borderColor;

  /// Specifies the border type of multi-level labels.
  ///
  ///  Defaults to 'MultiLevelLabelBorderType.rectangle'
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis: NumericAxis(
  ///         multiLevelLabelStyle: MultiLevelLabelStyle(
  ///           borderType: MultiLevelBorderType.curlyBrace
  ///         ),
  ///         multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             text: 'First',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  ///```
  final MultiLevelBorderType borderType;
}

/// Holds the multi-level axis label information
class AxisMultiLevelLabel {
  /// Creating an argument constructor of MultiLevelLabel class
  AxisMultiLevelLabel(
      this.actualStart, this.actualEnd, this.index, this.level, this.text);

  /// Specifies the label text style
  TextStyle? textStyle;

  /// Hold the size of the label
  Size? labelSize;

  /// Contains the text of the label
  String? text;

  /// Contains the trimmed text of the label
  String? trimmedText;

  /// Contains the label text to be rendered
  String? renderText;

  /// Stores the index value of multi-level label
  int? index;

  /// Stores the re-ordered level
  int? actualLevel;

  /// Stores the level given by the user
  int? level;

  /// Stores the actual start value
  num? actualStart;

  /// Stores the actual end value
  num? actualEnd;

  /// To store the rect region for trimmed labels tooltip rendering
  Rect? multiLabelRegion;
}

/// To set the axis border end
void setAxisBorderEndPoint(
    ChartAxisRendererDetails axisRendererDetails, double borderStartPoint) {
  final ChartAxis axis = axisRendererDetails.axis;
  double borderEndPoint = 0.0;
  final bool isLabelPositionInside =
      axis.labelPosition == ChartDataLabelPosition.inside;
  if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
    final double labelHeight = axisRendererDetails.maximumLabelSize.height;
    borderEndPoint = axis.opposedPosition == false
        ? (isLabelPositionInside
            ? borderStartPoint - labelHeight
            : borderStartPoint + labelHeight)
        : (isLabelPositionInside
            ? borderStartPoint + labelHeight
            : borderStartPoint - labelHeight);
  } else {
    final double labelWidth = axisRendererDetails.maximumLabelSize.width;
    borderEndPoint = axis.opposedPosition == false
        ? (isLabelPositionInside
            ? borderStartPoint + labelWidth
            : borderStartPoint - labelWidth)
        : (isLabelPositionInside
            ? borderStartPoint - labelWidth
            : borderStartPoint + labelWidth);
  }
  if (axis.majorTickLines.width > 0 || axis.minorTickLines.width > 0) {
    final double maximumTickHeight =
        math.max(axis.majorTickLines.size, axis.minorTickLines.size);
    if (axisRendererDetails.isInsideTickPosition! == isLabelPositionInside) {
      if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
        borderEndPoint = axis.opposedPosition == false
            ? (isLabelPositionInside
                ? borderEndPoint - maximumTickHeight
                : borderEndPoint + maximumTickHeight)
            : (isLabelPositionInside
                ? borderEndPoint + maximumTickHeight
                : borderEndPoint - maximumTickHeight);
      } else {
        borderEndPoint = axis.opposedPosition == false
            ? (isLabelPositionInside
                ? borderEndPoint + maximumTickHeight
                : borderEndPoint - maximumTickHeight)
            : (isLabelPositionInside
                ? borderEndPoint - maximumTickHeight
                : borderEndPoint + maximumTickHeight);
      }
    }
  }
  if (axisRendererDetails.crossValue != null &&
      axisRendererDetails.crossRange != null &&
      !axis.placeLabelsNearAxisLine) {
    borderEndPoint = _getAxisCrossingBorderEnd(axisRendererDetails);
  }
  axisRendererDetails.axisBorderEnd = borderEndPoint;
}

/// To get the axis border end while axis-crossing
double _getAxisCrossingBorderEnd(ChartAxisRendererDetails axisRendererDetails) {
  final ChartAxis axis = axisRendererDetails.axis;
  double borderEndPoint = 0.0;
  const double axisLabelLinePadding = 5.0;
  final double labelOffset = axisRendererDetails.labelOffset!;
  final Size labelSize = axisRendererDetails.maximumLabelSize;
  final bool isOpposed = axis.opposedPosition;
  final bool isHorizontalAxis =
      axisRendererDetails.orientation == AxisOrientation.horizontal;
  if (axis.labelPosition == ChartDataLabelPosition.outside) {
    borderEndPoint = labelOffset +
        (isHorizontalAxis
            ? (isOpposed ? -labelSize.height : labelSize.height) +
                (isOpposed ? axisLabelLinePadding : -axisLabelLinePadding)
            : (isOpposed ? labelSize.width : -labelSize.width) +
                (isOpposed ? -axisLabelLinePadding : axisLabelLinePadding));
  } else {
    borderEndPoint = labelOffset +
        (isHorizontalAxis
            ? (isOpposed ? labelSize.height : -labelSize.height) +
                (isOpposed ? -axisLabelLinePadding : axisLabelLinePadding)
            : (isOpposed ? -labelSize.width : labelSize.width) +
                (isOpposed ? axisLabelLinePadding : -axisLabelLinePadding));
  }
  return borderEndPoint;
}

/// To render horizontal axis border
void renderHorizontalAxisBorder(
    ChartAxisRendererDetails axisRendererDetails,
    Canvas canvas,
    double pointX,
    double pointY,
    bool isBetweenTicks,
    double betweenTickPositionValue,
    int index) {
  final Rect bounds = axisRendererDetails.bounds;
  final ChartAxis axis = axisRendererDetails.axis;
  final Paint borderPaint = Paint()
    ..strokeWidth = axis.borderWidth
    ..color = axis.borderColor != Colors.transparent
        ? axis.borderColor!
        : axisRendererDetails.renderingDetails.chartTheme.axisLineColor
    ..style = PaintingStyle.stroke;
  if (axisRendererDetails.crossValue != null &&
      axisRendererDetails.crossRange != null &&
      !axis.placeLabelsNearAxisLine) {
    final double axisBorderEnd = axisRendererDetails.axisBorderEnd!;
    final double maximumLabelHeight =
        axisRendererDetails.maximumLabelSize.height;
    pointY = axisBorderEnd +
        ((axis.labelPosition == ChartDataLabelPosition.outside)
            ? (axis.opposedPosition ? maximumLabelHeight : -maximumLabelHeight)
            : (axis.opposedPosition
                ? -maximumLabelHeight
                : maximumLabelHeight));
  }
  final double startOffsetX = pointX + betweenTickPositionValue;
  final Offset borderStartOffset = Offset(startOffsetX, pointY);
  final Offset borderEndOffset =
      Offset(startOffsetX, axisRendererDetails.axisBorderEnd!);
  if (isBetweenTicks ||
      (bounds.left.roundToDouble() < borderStartOffset.dx.roundToDouble() &&
          bounds.right.roundToDouble() >
              borderStartOffset.dx.roundToDouble())) {
    canvas.drawLine(borderStartOffset, borderEndOffset, borderPaint);
    if (axis.axisBorderType == AxisBorderType.rectangle && index == 0) {
      canvas.drawLine(Offset(bounds.left, pointY), Offset(bounds.right, pointY),
          borderPaint);
      canvas.drawLine(Offset(bounds.left, borderEndOffset.dy),
          Offset(bounds.right, borderEndOffset.dy), borderPaint);
    }
  }
}

/// To render vertical axis border
void renderVerticalAxisBorder(
    ChartAxisRendererDetails axisRendererDetails,
    Canvas canvas,
    double pointX,
    double pointY,
    bool isBetweenTicks,
    double betweenTickPositionValue,
    int index) {
  final ChartAxis axis = axisRendererDetails.axis;
  final Paint borderPaint = Paint()
    ..strokeWidth = axis.borderWidth
    ..color = axis.borderColor != Colors.transparent
        ? axis.borderColor!
        : axisRendererDetails.renderingDetails.chartTheme.axisLineColor
    ..style = PaintingStyle.stroke;
  final Rect bounds = axisRendererDetails.bounds;
  if (axisRendererDetails.crossValue != null &&
      axisRendererDetails.crossRange != null &&
      !axis.placeLabelsNearAxisLine) {
    final double axisBorderEnd = axisRendererDetails.axisBorderEnd!;
    final double maximumLabelWidth = axisRendererDetails.maximumLabelSize.width;
    pointX = axisBorderEnd +
        ((axis.labelPosition == ChartDataLabelPosition.outside)
            ? (axis.opposedPosition ? -maximumLabelWidth : maximumLabelWidth)
            : (axis.opposedPosition ? maximumLabelWidth : -maximumLabelWidth));
  }
  final double startOffsetY = pointY + betweenTickPositionValue;
  final Offset borderStartOffset = Offset(pointX, startOffsetY);
  final Offset borderEndOffset =
      Offset(axisRendererDetails.axisBorderEnd!, startOffsetY);
  if (isBetweenTicks ||
      (bounds.bottom.roundToDouble() > borderEndOffset.dy.roundToDouble() &&
          bounds.top.roundToDouble() < borderEndOffset.dy.roundToDouble())) {
    canvas.drawLine(borderStartOffset, borderEndOffset, borderPaint);
    if (axis.axisBorderType == AxisBorderType.rectangle && index == 0) {
      canvas.drawLine(Offset(borderStartOffset.dx, bounds.top),
          Offset(borderStartOffset.dx, bounds.bottom), borderPaint);
      canvas.drawLine(Offset(borderEndOffset.dx, bounds.top),
          Offset(borderEndOffset.dx, bounds.bottom), borderPaint);
    }
  }
}

/// To generate multi-level labels
void generateMultiLevelLabels(ChartAxisRendererDetails axisRendererDetails) {
  final ChartAxis axis = axisRendererDetails.axis;
  // ignore: strict_raw_type
  final List<ChartMultiLevelLabel> multiLevelLabelsList =
      axis.multiLevelLabels!;
  for (int index = 0; index < multiLevelLabelsList.length; index++) {
    final String labelText = multiLevelLabelsList[index].text ?? '';
    final num actualStart =
        _getActualValue(axisRendererDetails, multiLevelLabelsList[index].start);
    final num actualEnd =
        _getActualValue(axisRendererDetails, multiLevelLabelsList[index].end);
    _setMinMaxMultiLevelLabelRange(actualStart, actualEnd, axisRendererDetails);
    if ((axis is NumericAxis || axis is LogarithmicAxis) &&
        // ignore: unnecessary_null_comparison
        (actualStart != null && actualEnd != null)) {
      assert((actualStart <= actualEnd) == true,
          'The start value should be less than the end value');
    }
    axisRendererDetails.visibleAxisMultiLevelLabels.add(AxisMultiLevelLabel(
        actualStart,
        actualEnd,
        index,
        multiLevelLabelsList[index].level,
        labelText));
  }
  _sortMultiLevelLabels(axisRendererDetails);
  _triggerMultiLabelRenderCallback(axisRendererDetails);
}

/// To trigger the multi-level axis label event
void _triggerMultiLabelRenderCallback(
    ChartAxisRendererDetails axisRendererDetails) {
  final TextStyle multiLevelLabelStyle =
      axisRendererDetails.chartThemeData.axisMultiLevelLabelTextStyle!;
  final List<AxisMultiLevelLabel> visibleAxisMultiLevelLabels =
      axisRendererDetails.visibleAxisMultiLevelLabels;
  Rect axisBounds = axisRendererDetails.stateProperties.chartAxis.axisClipRect;
  for (int i = 0; i < visibleAxisMultiLevelLabels.length; i++) {
    String actualText = visibleAxisMultiLevelLabels[i].text ?? '';
    String? trimmedText;
    TextStyle labelTextStyle = multiLevelLabelStyle.copyWith();
    if (axisRendererDetails.axis.multiLevelLabelFormatter != null) {
      final MultiLevelLabelRenderDetails multiLevelLabelRenderDetails =
          MultiLevelLabelRenderDetails(
              visibleAxisMultiLevelLabels[i].actualLevel!,
              actualText,
              labelTextStyle,
              visibleAxisMultiLevelLabels[i].index!,
              axisRendererDetails.name);
      final ChartAxisLabel chartAxisLabel = axisRendererDetails
          .axis.multiLevelLabelFormatter!(multiLevelLabelRenderDetails);
      labelTextStyle = labelTextStyle.merge(chartAxisLabel.textStyle);
      actualText = chartAxisLabel.text;
    }
    final Size textSize = measureText(actualText, labelTextStyle, 0);
    if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
      if (axisRendererDetails.axis.plotOffset != 0) {
        final double plotOffset = axisRendererDetails.axis.plotOffset;
        axisBounds = Rect.fromLTRB(axisBounds.left + plotOffset, axisBounds.top,
            axisBounds.right - (2 * plotOffset), axisBounds.bottom);
      }
      final bool isBetweenTicks = isLabelBetweenTicks(axisRendererDetails.axis);
      final double betweenTicksInterval = isBetweenTicks ? 0.5 : 0;
      final double labelStart = (valueToCoefficient(
                  visibleAxisMultiLevelLabels[i].actualStart! -
                      betweenTicksInterval,
                  axisRendererDetails) *
              axisBounds.width) +
          axisBounds.left;
      final double labelEnd = (valueToCoefficient(
                  visibleAxisMultiLevelLabels[i].actualEnd! +
                      betweenTicksInterval,
                  axisRendererDetails) *
              axisBounds.width) +
          axisBounds.left;
      final double labelRectWidth = (labelEnd - labelStart).abs();
      if ((labelRectWidth > 0.0) && labelRectWidth <= textSize.width) {
        const double trimmedTextWidthPadding = 10.0;
        final num maxWidth = labelRectWidth - trimmedTextWidthPadding;
        trimmedText = getTrimmedText(actualText, maxWidth, labelTextStyle,
            isRtl: axisRendererDetails.stateProperties.renderingDetails.isRtl);
      }
    }
    final String renderText = trimmedText ?? actualText;
    final Size labelSize = measureText(renderText, labelTextStyle, 0);
    visibleAxisMultiLevelLabels[i].textStyle = labelTextStyle;
    visibleAxisMultiLevelLabels[i].labelSize = labelSize;
    visibleAxisMultiLevelLabels[i].text = actualText;
    visibleAxisMultiLevelLabels[i].trimmedText = trimmedText;
    visibleAxisMultiLevelLabels[i].renderText = renderText;
  }
}

/// To sort the levels of multi-level labels
void _sortMultiLevelLabels(ChartAxisRendererDetails axisRendererDetails) {
  final List<AxisMultiLevelLabel> visibleAxisMultiLevelLabels =
      axisRendererDetails.visibleAxisMultiLevelLabels;
  axisRendererDetails.visibleAxisMultiLevelLabels.sort(
      (AxisMultiLevelLabel a, AxisMultiLevelLabel b) =>
          a.level!.compareTo(b.level!));
  int currentLevel = 0;
  int previousLevel = 0;
  if (visibleAxisMultiLevelLabels.length > 1) {
    for (int count = 0; count < visibleAxisMultiLevelLabels.length; count++) {
      previousLevel = currentLevel;
      if (count == 0 && visibleAxisMultiLevelLabels[count].level != 0) {
        currentLevel = 0;
      } else if (visibleAxisMultiLevelLabels[count].level! >
              previousLevel + 1 &&
          visibleAxisMultiLevelLabels[count].level !=
              visibleAxisMultiLevelLabels[count - 1].level) {
        currentLevel = previousLevel + 1;
      } else if (visibleAxisMultiLevelLabels[count].level ==
              previousLevel + 1 &&
          visibleAxisMultiLevelLabels[count].level !=
              visibleAxisMultiLevelLabels[count - 1].level) {
        currentLevel = visibleAxisMultiLevelLabels[count].level!;
      } else {
        currentLevel = previousLevel;
      }
      visibleAxisMultiLevelLabels[count].actualLevel = currentLevel;
      axisRendererDetails.highestLevel = math.max(previousLevel, currentLevel);
    }
  } else {
    visibleAxisMultiLevelLabels[currentLevel].actualLevel = currentLevel;
    axisRendererDetails.highestLevel = currentLevel;
  }
}

/// To get the minimum and maximum start values for multi-level labels
void _setMinMaxMultiLevelLabelRange(num startValue, num endValue,
    ChartAxisRendererDetails axisRendererDetails) {
  if (axisRendererDetails.minimumMultiLevelLabelValue == null &&
      axisRendererDetails.maximumMultiLevelLabelValue == null) {
    axisRendererDetails.minimumMultiLevelLabelValue = startValue;
    axisRendererDetails.maximumMultiLevelLabelValue = endValue;
  }
  if (axisRendererDetails.minimumMultiLevelLabelValue! > startValue) {
    axisRendererDetails.minimumMultiLevelLabelValue = startValue;
  }
  if (axisRendererDetails.maximumMultiLevelLabelValue! < endValue) {
    axisRendererDetails.maximumMultiLevelLabelValue = endValue;
  }
}

/// Calculate the maximum bound for multi-level labels
void calculateMultiLevelLabelBounds(
    ChartAxisRendererDetails axisRendererDetails) {
  AxisMultiLevelLabel axisMultiLevelLabel;
  final int highestLevel = axisRendererDetails.highestLevel!;
  final Map<int, Size> maximumSizeMapping = <int, Size>{};
  double maximumWidth = 0.0, maximumHeight = 0.0;
  int currentLevel;
  for (int multiLevelLabelsCount = 0;
      multiLevelLabelsCount <
          axisRendererDetails.visibleAxisMultiLevelLabels.length;
      multiLevelLabelsCount++) {
    axisMultiLevelLabel =
        axisRendererDetails.visibleAxisMultiLevelLabels[multiLevelLabelsCount];
    currentLevel = axisMultiLevelLabel.actualLevel!;
    for (int levelCount = 0; levelCount <= highestLevel; levelCount++) {
      if (currentLevel == levelCount) {
        double maxWidth = maximumSizeMapping[levelCount]?.width ?? 0.0,
            maxHeight = maximumSizeMapping[levelCount]?.height ?? 0.0;
        maxWidth = axisMultiLevelLabel.labelSize!.width > maxWidth
            ? axisMultiLevelLabel.labelSize!.width
            : maxWidth;
        maxHeight = axisMultiLevelLabel.labelSize!.height > maxHeight
            ? axisMultiLevelLabel.labelSize!.height
            : maxHeight;
        maximumSizeMapping[levelCount] = Size(maxWidth, maxHeight);
      }
    }
  }
  final MultiLevelBorderType multiLevelLabelBorderType =
      axisRendererDetails.axis.multiLevelLabelStyle.borderType;
  double gapPadding = 6.0;
  if (multiLevelLabelBorderType == MultiLevelBorderType.squareBrace) {
    gapPadding = 3.0;
  }
  if (multiLevelLabelBorderType == MultiLevelBorderType.curlyBrace) {
    gapPadding = 18.0;
  }
  for (int k = 0; k <= highestLevel; k++) {
    final Size currentLevelMaximumSize = Size(
        maximumSizeMapping[k]!.width + gapPadding,
        maximumSizeMapping[k]!.height + gapPadding);
    axisRendererDetails.multiLevelsMaximumSize.add(currentLevelMaximumSize);
    maximumWidth += currentLevelMaximumSize.width;
    maximumHeight += currentLevelMaximumSize.height;
  }
  axisRendererDetails.multiLevelLabelTotalSize =
      Size(maximumWidth, maximumHeight);
}

/// To get the multi-level label rectangle.
Rect _getMultiLevelLabelRect(ChartAxisRendererDetails axisRendererDetails,
    num startValue, num endValue, int currentLevel) {
  const double bracePadding = 5;
  final Rect axisBounds = axisRendererDetails.bounds;
  final bool isNotDefaultChart = (axisRendererDetails.axis.labelPosition ==
          ChartDataLabelPosition.inside) ^
      (axisRendererDetails.axis.opposedPosition);
  final bool isBetweenTicks = isLabelBetweenTicks(axisRendererDetails.axis);
  final double betweenTicksInterval = isBetweenTicks ? 0.5 : 0;
  final bool isBraceType =
      axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
              MultiLevelBorderType.squareBrace ||
          axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
              MultiLevelBorderType.curlyBrace;
  double multiLevelLabelStart = axisRendererDetails.axisBorderEnd!;
  double left = 0.0, right = 0.0, top = 0.0, bottom = 0.0;
  if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
    multiLevelLabelStart = axisRendererDetails.axisBorderEnd! +
        (isBraceType ? (isNotDefaultChart ? -bracePadding : bracePadding) : 0);
    left = ((valueToCoefficient(
                    startValue - betweenTicksInterval, axisRendererDetails) *
                axisBounds.width) +
            axisBounds.left)
        .roundToDouble();
    right = ((valueToCoefficient(
                    endValue + betweenTicksInterval, axisRendererDetails) *
                axisBounds.width) +
            axisBounds.left)
        .roundToDouble();
    bottom = multiLevelLabelStart +
        (isNotDefaultChart
            ? (-axisRendererDetails.multiLevelsMaximumSize[currentLevel].height)
            : axisRendererDetails.multiLevelsMaximumSize[currentLevel].height);
    for (int i = 0; i < currentLevel; i++) {
      bottom = bottom +
          (isNotDefaultChart
              ? (-axisRendererDetails.multiLevelsMaximumSize[i].height)
              : axisRendererDetails.multiLevelsMaximumSize[i].height);
    }
    top = bottom -
        (isNotDefaultChart
            ? (-axisRendererDetails.multiLevelsMaximumSize[currentLevel].height)
            : axisRendererDetails.multiLevelsMaximumSize[currentLevel].height);
  } else {
    multiLevelLabelStart = axisRendererDetails.axisBorderEnd! +
        (isBraceType ? (isNotDefaultChart ? bracePadding : -bracePadding) : 0);
    top = ((valueToCoefficient(
                    startValue - betweenTicksInterval, axisRendererDetails) *
                axisBounds.height) +
            axisBounds.top)
        .roundToDouble();
    top = (axisBounds.top + axisBounds.height) - (top - axisBounds.top);
    bottom = ((valueToCoefficient(
                    endValue + betweenTicksInterval, axisRendererDetails) *
                axisBounds.height) +
            axisBounds.top)
        .roundToDouble();
    bottom = (axisBounds.top + axisBounds.height) - (bottom - axisBounds.top);
    left = multiLevelLabelStart -
        (isNotDefaultChart
            ? (-axisRendererDetails.multiLevelsMaximumSize[currentLevel].width)
            : axisRendererDetails.multiLevelsMaximumSize[currentLevel].width);
    for (int i = 0; i < currentLevel; i++) {
      left = left -
          (isNotDefaultChart
              ? (-axisRendererDetails.multiLevelsMaximumSize[i].width)
              : axisRendererDetails.multiLevelsMaximumSize[i].width);
    }
    right = left +
        (isNotDefaultChart
            ? (-axisRendererDetails.multiLevelsMaximumSize[currentLevel].width)
            : axisRendererDetails.multiLevelsMaximumSize[currentLevel].width);
  }
  return Rect.fromLTRB(left, top, right, bottom);
}

/// To draw the path for the multi-level labels.
void _drawMultiLevelLabelBorder(
    ChartAxisRendererDetails axisRendererDetails,
    Canvas canvas,
    Rect multiLevelLabelRect,
    Paint pathPaint,
    MultiLevelBorderType borderType,
    AxisMultiLevelLabel multiLevelLabel) {
  if (borderType == MultiLevelBorderType.rectangle) {
    canvas.drawRect(multiLevelLabelRect, pathPaint);
  } else if (borderType == MultiLevelBorderType.withoutTopAndBottom) {
    if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
      canvas.drawLine(multiLevelLabelRect.topLeft,
          multiLevelLabelRect.bottomLeft, pathPaint);
      canvas.drawLine(multiLevelLabelRect.topRight,
          multiLevelLabelRect.bottomRight, pathPaint);
    } else {
      canvas.drawLine(
          multiLevelLabelRect.topLeft, multiLevelLabelRect.topRight, pathPaint);
      canvas.drawLine(multiLevelLabelRect.bottomLeft,
          multiLevelLabelRect.bottomRight, pathPaint);
    }
  } else if (borderType == MultiLevelBorderType.squareBrace) {
    _drawSquareBracePath(axisRendererDetails, multiLevelLabelRect,
        multiLevelLabel.labelSize!, canvas, pathPaint);
  } else if (borderType == MultiLevelBorderType.curlyBrace) {
    _drawCurlyBracePath(axisRendererDetails, multiLevelLabelRect,
        multiLevelLabel.level!, multiLevelLabel.labelSize!, canvas, pathPaint);
  }
}

/// To draw the square brace path
void _drawSquareBracePath(ChartAxisRendererDetails axisRendererDetails,
    Rect multiLevelLabelRect, Size labelSize, Canvas canvas, Paint pathPaint) {
  const double textPadding = 2.0;
  final bool isInversed = axisRendererDetails.axis.isInversed;
  final bool isNotDefaultChart = (axisRendererDetails.axis.labelPosition ==
          ChartDataLabelPosition.inside) ^
      (axisRendererDetails.axis.opposedPosition);
  final double braceTopPadding = isNotDefaultChart ? -3.0 : 3.0;
  final Path pathBeforeText = Path();
  final Path pathAfterText = Path();
  if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
    pathBeforeText.moveTo(multiLevelLabelRect.left, multiLevelLabelRect.top);
    pathBeforeText.lineTo(
        multiLevelLabelRect.left,
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 +
            braceTopPadding);
    pathBeforeText.lineTo(
        multiLevelLabelRect.left +
            multiLevelLabelRect.width / 2 +
            (isInversed
                ? labelSize.width / 2 + textPadding
                : -labelSize.width / 2 - textPadding),
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 +
            braceTopPadding);
    pathAfterText.moveTo(multiLevelLabelRect.right, multiLevelLabelRect.top);
    pathAfterText.lineTo(
        multiLevelLabelRect.right,
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 +
            braceTopPadding);
    pathAfterText.lineTo(
        multiLevelLabelRect.right -
            multiLevelLabelRect.width / 2 +
            (isInversed
                ? -labelSize.width / 2 - textPadding
                : labelSize.width / 2 + textPadding),
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 +
            braceTopPadding);
  } else {
    pathBeforeText.moveTo(multiLevelLabelRect.right, multiLevelLabelRect.top);
    pathBeforeText.lineTo(
        multiLevelLabelRect.right -
            multiLevelLabelRect.width / 2 -
            braceTopPadding,
        multiLevelLabelRect.top);
    pathBeforeText.lineTo(
        multiLevelLabelRect.right -
            multiLevelLabelRect.width / 2 -
            braceTopPadding,
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 +
            (isInversed
                ? -labelSize.height / 2 - textPadding
                : labelSize.height / 2 + textPadding));
    pathAfterText.moveTo(multiLevelLabelRect.right, multiLevelLabelRect.bottom);
    pathAfterText.lineTo(
        multiLevelLabelRect.right -
            multiLevelLabelRect.width / 2 -
            braceTopPadding,
        multiLevelLabelRect.bottom);
    pathAfterText.lineTo(
        multiLevelLabelRect.right -
            multiLevelLabelRect.width / 2 -
            braceTopPadding,
        multiLevelLabelRect.bottom -
            multiLevelLabelRect.height / 2 +
            (isInversed
                ? labelSize.height / 2 + textPadding
                : -labelSize.height / 2 - textPadding));
  }
  canvas.drawPath(pathBeforeText, pathPaint);
  canvas.drawPath(pathAfterText, pathPaint);
}

/// To draw the curly brace path
void _drawCurlyBracePath(
    ChartAxisRendererDetails axisRendererDetails,
    Rect multiLevelLabelRect,
    int index,
    Size textSize,
    Canvas canvas,
    Paint paint) {
  final bool isInversed = axisRendererDetails.axis.isInversed;
  final bool isNotDefaultChart = (axisRendererDetails.axis.labelPosition ==
          ChartDataLabelPosition.inside) ^
      (axisRendererDetails.axis.opposedPosition);
  final Path curlyBracePath = Path();
  if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
    final double curlyBracePadding = isInversed ? -7.0 : 7.0;
    const double arrowWidth = 5.0;
    const double curlyBraceTopPadding = 6.0;
    Offset arrowPoint;
    arrowPoint = Offset(
        multiLevelLabelRect.left + multiLevelLabelRect.width / 2,
        multiLevelLabelRect.top +
            multiLevelLabelRect.height / 2 -
            textSize.height / 2 +
            curlyBraceTopPadding);
    final double halfPathHeight = (arrowPoint.dy - multiLevelLabelRect.top) / 2;
    final double curveEndPoint = multiLevelLabelRect.top +
        halfPathHeight +
        (isNotDefaultChart ? arrowWidth : -arrowWidth) / 2;

    curlyBracePath.moveTo(multiLevelLabelRect.left, multiLevelLabelRect.top);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.left,
        multiLevelLabelRect.top,
        multiLevelLabelRect.left + curlyBracePadding / 2,
        curveEndPoint);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.left + curlyBracePadding / 2,
        curveEndPoint,
        multiLevelLabelRect.left + curlyBracePadding,
        multiLevelLabelRect.top + halfPathHeight);
    curlyBracePath.lineTo(multiLevelLabelRect.left + curlyBracePadding,
        multiLevelLabelRect.top + halfPathHeight);
    curlyBracePath.lineTo(
        arrowPoint.dx + (isInversed ? arrowWidth : -arrowWidth),
        multiLevelLabelRect.top + halfPathHeight);
    curlyBracePath.lineTo(arrowPoint.dx, arrowPoint.dy);
    curlyBracePath.lineTo(
        arrowPoint.dx + (isInversed ? -arrowWidth : arrowWidth),
        multiLevelLabelRect.top + halfPathHeight);
    curlyBracePath.lineTo(multiLevelLabelRect.right - curlyBracePadding,
        multiLevelLabelRect.top + halfPathHeight);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.right - curlyBracePadding,
        multiLevelLabelRect.top + halfPathHeight,
        multiLevelLabelRect.right - curlyBracePadding / 2,
        curveEndPoint);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.right - curlyBracePadding / 2,
        curveEndPoint,
        multiLevelLabelRect.right,
        multiLevelLabelRect.top);
    curlyBracePath.lineTo(multiLevelLabelRect.right, multiLevelLabelRect.top);
  } else {
    final double curlyBracePadding = isInversed ? -12.0 : 12.0;
    const double arrowWidth = 5.0;
    const double curlyBraceWidthPadding = 15.0;
    final double textRectWidth =
        axisRendererDetails.multiLevelsMaximumSize[index].width -
            curlyBraceWidthPadding;
    final Offset arrowNosePoint = Offset(
        multiLevelLabelRect.left +
            (isNotDefaultChart ? -textRectWidth : textRectWidth),
        multiLevelLabelRect.top + multiLevelLabelRect.height / 2);
    final double halfPathWidth =
        (multiLevelLabelRect.right - arrowNosePoint.dx) / 2;
    final double curveEndPoint = multiLevelLabelRect.right -
        halfPathWidth +
        (isNotDefaultChart ? -arrowWidth : arrowWidth) / 2;

    curlyBracePath.moveTo(multiLevelLabelRect.right, multiLevelLabelRect.top);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.right,
        multiLevelLabelRect.top,
        curveEndPoint,
        multiLevelLabelRect.top - curlyBracePadding / 2);
    curlyBracePath.quadraticBezierTo(
        curveEndPoint,
        multiLevelLabelRect.top - curlyBracePadding / 2,
        multiLevelLabelRect.right - halfPathWidth,
        multiLevelLabelRect.top - curlyBracePadding);
    curlyBracePath.lineTo(multiLevelLabelRect.right - halfPathWidth,
        multiLevelLabelRect.top - curlyBracePadding);
    curlyBracePath.lineTo(multiLevelLabelRect.right - halfPathWidth,
        arrowNosePoint.dy + (isInversed ? -arrowWidth : arrowWidth));
    curlyBracePath.lineTo(arrowNosePoint.dx, arrowNosePoint.dy);
    curlyBracePath.lineTo(multiLevelLabelRect.right - halfPathWidth,
        arrowNosePoint.dy + (isInversed ? arrowWidth : -arrowWidth));
    curlyBracePath.lineTo(multiLevelLabelRect.right - halfPathWidth,
        multiLevelLabelRect.bottom + curlyBracePadding);
    curlyBracePath.quadraticBezierTo(
        multiLevelLabelRect.right - halfPathWidth,
        multiLevelLabelRect.bottom + curlyBracePadding,
        curveEndPoint,
        multiLevelLabelRect.bottom + curlyBracePadding / 2);
    curlyBracePath.quadraticBezierTo(
        curveEndPoint,
        multiLevelLabelRect.bottom + curlyBracePadding / 2,
        multiLevelLabelRect.right,
        multiLevelLabelRect.bottom);
    curlyBracePath.lineTo(
        multiLevelLabelRect.right, multiLevelLabelRect.bottom);
  }
  canvas.drawPath(curlyBracePath, paint);
}

/// Render multi-level label text
void _drawMultiLevelLabelText(
    ChartAxisRendererDetails axisRendererDetails,
    Canvas canvas,
    String renderText,
    Rect multiLevelBorderRect,
    AxisMultiLevelLabel multiLevelLabel) {
  final Size labelSize = multiLevelLabel.labelSize!;
  final bool isHorizontal =
      axisRendererDetails.orientation == AxisOrientation.horizontal;
  final bool isOpposed = axisRendererDetails.axis.opposedPosition == true;
  final bool isLabelPositionInside =
      axisRendererDetails.axis.labelPosition == ChartDataLabelPosition.inside;
  final bool isNotDefaultChart = isLabelPositionInside ^ isOpposed;
  Offset? textOffset;
  double textGapPadding = 0.0;
  final MultiLevelBorderType borderType =
      axisRendererDetails.axis.multiLevelLabelStyle.borderType;
  if (borderType == MultiLevelBorderType.rectangle ||
      borderType == MultiLevelBorderType.withoutTopAndBottom) {
    textOffset = Offset(
        multiLevelBorderRect.left +
            multiLevelBorderRect.width / 2 -
            labelSize.width / 2,
        multiLevelBorderRect.top +
            multiLevelBorderRect.height / 2 -
            labelSize.height / 2);
  } else if (borderType == MultiLevelBorderType.squareBrace) {
    textGapPadding = isNotDefaultChart ? -3.0 : 3.0;
    textOffset = Offset(
        multiLevelBorderRect.left +
            multiLevelBorderRect.width / 2 -
            labelSize.width / 2 -
            (isHorizontal ? 0 : textGapPadding),
        multiLevelBorderRect.top +
            multiLevelBorderRect.height / 2 -
            labelSize.height / 2 +
            (isHorizontal ? textGapPadding : 0));
  } else if (borderType == MultiLevelBorderType.curlyBrace) {
    textGapPadding = isNotDefaultChart ? -9.0 : 9.0;
    if (isHorizontal) {
      textOffset = Offset(
          multiLevelBorderRect.left +
              multiLevelBorderRect.width / 2 -
              labelSize.width / 2,
          multiLevelBorderRect.top +
              multiLevelBorderRect.height / 2 -
              labelSize.height / 2 +
              textGapPadding);
    } else {
      textGapPadding = isNotDefaultChart ? 18 : -18;
      final double textRectWidth = axisRendererDetails
              .multiLevelsMaximumSize[multiLevelLabel.actualLevel!].width +
          textGapPadding;

      textOffset = Offset(
          (isNotDefaultChart
                  ? multiLevelBorderRect.right
                  : multiLevelBorderRect.left) +
              textRectWidth / 2 -
              labelSize.width / 2,
          multiLevelBorderRect.top +
              multiLevelBorderRect.height / 2 -
              labelSize.height / 2);
    }
  }
  drawText(canvas, renderText, textOffset!, multiLevelLabel.textStyle!, 0);
}

/// To draw multi-level labels
void drawMultiLevelLabels(
    ChartAxisRendererDetails axisRendererDetails, Canvas canvas) {
  final ChartAxis axis = axisRendererDetails.axis;
  final Paint multiLevelBorderPaint = Paint()
    ..color = axis.multiLevelLabelStyle.borderColor ??
        axisRendererDetails.renderingDetails.chartTheme.axisLineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = axis.multiLevelLabelStyle.borderWidth != 0
        ? axis.multiLevelLabelStyle.borderWidth
        : axis.axisLine.width;
  final bool isOpposed = axisRendererDetails.axis.opposedPosition;
  final bool isLabelPositionInside =
      axisRendererDetails.axis.labelPosition == ChartDataLabelPosition.inside;
  final bool isNotDefaultChart = isLabelPositionInside ^ isOpposed;
  const double bracePadding = 5;
  final double clipRectBorderPadding = multiLevelBorderPaint.strokeWidth / 2;
  final bool isBraceType =
      axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
              MultiLevelBorderType.squareBrace ||
          axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
              MultiLevelBorderType.curlyBrace;
  for (int k = 0;
      k < axisRendererDetails.visibleAxisMultiLevelLabels.length;
      k++) {
    double multiLevelLabelStart = axisRendererDetails.axisBorderEnd!;
    final AxisMultiLevelLabel multiLevelLabel =
        axisRendererDetails.visibleAxisMultiLevelLabels[k];
    final Rect multiLevelBorderRect = _getMultiLevelLabelRect(
        axisRendererDetails,
        multiLevelLabel.actualStart!,
        multiLevelLabel.actualEnd!,
        multiLevelLabel.actualLevel!);
    multiLevelLabel.multiLabelRegion = multiLevelBorderRect;
    final String renderText = multiLevelLabel.renderText!;
    canvas.save();
    if (axisRendererDetails.orientation == AxisOrientation.horizontal) {
      multiLevelLabelStart = multiLevelLabelStart +
          (isBraceType
              ? (isNotDefaultChart ? -bracePadding : bracePadding)
              : 0);
      canvas.clipRect(Rect.fromLTRB(
        axisRendererDetails.bounds.left - clipRectBorderPadding,
        multiLevelLabelStart +
            (isNotDefaultChart
                ? clipRectBorderPadding
                : -clipRectBorderPadding),
        axisRendererDetails.bounds.right + clipRectBorderPadding,
        multiLevelLabelStart +
            (isNotDefaultChart
                ? -axisRendererDetails.multiLevelLabelTotalSize.height -
                    clipRectBorderPadding
                : axisRendererDetails.multiLevelLabelTotalSize.height +
                    clipRectBorderPadding),
      ));
    } else {
      multiLevelLabelStart = multiLevelLabelStart +
          (isBraceType
              ? (isNotDefaultChart ? bracePadding : -bracePadding)
              : 0);
      canvas.clipRect(Rect.fromLTRB(
          multiLevelLabelStart +
              (isNotDefaultChart
                  ? axisRendererDetails.multiLevelLabelTotalSize.width +
                      clipRectBorderPadding
                  : -axisRendererDetails.multiLevelLabelTotalSize.width -
                      clipRectBorderPadding),
          axisRendererDetails.bounds.top - clipRectBorderPadding,
          multiLevelLabelStart +
              (isNotDefaultChart
                  ? -clipRectBorderPadding
                  : clipRectBorderPadding),
          axisRendererDetails.bounds.bottom + clipRectBorderPadding));
    }
    _drawMultiLevelLabelBorder(
        axisRendererDetails,
        canvas,
        multiLevelBorderRect,
        multiLevelBorderPaint,
        axis.multiLevelLabelStyle.borderType,
        multiLevelLabel);
    _drawMultiLevelLabelText(axisRendererDetails, canvas, renderText,
        multiLevelBorderRect, multiLevelLabel);
    canvas.restore();
  }
}

/// To get the label offset for vertical axis
double getLabelOffsetX(
    ChartAxisRendererDetails axisRendererDetails, Size textSize) {
  final ChartAxis axis = axisRendererDetails.axis;
  final bool isBetweenTicks = isLabelBetweenTicks(axis);
  final Rect axisBounds = axisRendererDetails.bounds;
  double pointX = 0.0;
  const double innerPadding = 5.0;
  if (axis.labelPosition == ChartDataLabelPosition.inside) {
    pointX = (!axis.opposedPosition)
        ? axisRendererDetails.labelOffset != null
            ? axisRendererDetails.labelOffset!
            : (axisBounds.left +
                    (axisRendererDetails.isInsideTickPosition! || isBetweenTicks
                        ? axis.majorTickLines.size
                        : 0)) +
                innerPadding
        : axisRendererDetails.labelOffset != null
            ? axisRendererDetails.labelOffset! - textSize.width
            : (axisBounds.left -
                    axisRendererDetails.maximumLabelSize.width -
                    (axisRendererDetails.isInsideTickPosition!
                        ? axis.majorTickLines.size
                        : 0.0)) +
                innerPadding;
  } else {
    pointX = ((!axis.opposedPosition)
            ? axisRendererDetails.labelOffset != null
                ? axisRendererDetails.labelOffset! - textSize.width
                : (axisBounds.left -
                    (axisRendererDetails.isInsideTickPosition!
                        ? 0
                        : axis.majorTickLines.size) -
                    textSize.width -
                    innerPadding)
            : (axisRendererDetails.labelOffset ??
                (axisBounds.left +
                    (axisRendererDetails.isInsideTickPosition!
                        ? 0
                        : axis.majorTickLines.size) +
                    innerPadding)))
        .toDouble();
  }
  return pointX;
}

/// To get the label offset for horizontal axis
double getLabelOffsetY(
    ChartAxisRendererDetails axisRendererDetails, int index) {
  final ChartAxis axis = axisRendererDetails.axis;
  final Rect axisBounds = axisRendererDetails.bounds;
  final double halfTextHeight = axisRendererDetails.maximumLabelSize.height / 2;
  double pointY = 0.0;
  const num innerPadding = 5;
  if (axis.labelPosition == ChartDataLabelPosition.inside) {
    pointY = axis.opposedPosition == false
        ? axisRendererDetails.labelOffset != null
            ? axisRendererDetails.labelOffset! -
                (2 * halfTextHeight) +
                (2 * innerPadding)
            : axisBounds.top +
                innerPadding -
                (index > 1 ? halfTextHeight : halfTextHeight * 2) -
                (axisRendererDetails.isInsideTickPosition!
                    ? axis.majorTickLines.size
                    : 0)
        : axisRendererDetails.labelOffset ??
            axisBounds.top +
                innerPadding +
                (axisRendererDetails.isInsideTickPosition!
                    ? axis.majorTickLines.size
                    : 0) +
                (index > 1 ? halfTextHeight : 0);
  } else {
    if (axisRendererDetails.labelOffset != null) {
      pointY = axis.opposedPosition == false
          ? axisRendererDetails.labelOffset!.toDouble() + innerPadding - 5
          : axisRendererDetails.labelOffset!.toDouble() -
              (2 * halfTextHeight) +
              (2 * innerPadding);
    } else {
      pointY = (axis.opposedPosition == false
              ? (axisBounds.top +
                  (((axisRendererDetails.isInsideTickPosition!)
                          ? 0
                          : axis.majorTickLines.size) +
                      innerPadding) +
                  (index > 1 ? halfTextHeight : 0))
              : (axisBounds.top -
                  ((((axisRendererDetails.isInsideTickPosition!)
                              ? 0
                              : axis.majorTickLines.size) +
                          innerPadding) -
                      (index > 1 ? halfTextHeight : 0)) -
                  (2 * (halfTextHeight - innerPadding))))
          .toDouble();
    }
  }
  return pointY;
}

/// To get the offset for horizontal axis title
double getHorizontalAxisTitleOffset(
    ChartAxisRendererDetails axisRendererDetails, Size textSize) {
  const double titlePadding = 8;
  final ChartAxis axis = axisRendererDetails.axis;
  final double maximumTickHeight =
      math.max(axis.majorTickLines.size, axis.minorTickLines.size);
  double rectStartPoint = axisRendererDetails.axisBorderEnd!;
  if (axisRendererDetails.isMultiLevelLabelEnabled) {
    const double bracePadding = 5;
    rectStartPoint = rectStartPoint +
        ((axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
                    MultiLevelBorderType.squareBrace ||
                axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
                    MultiLevelBorderType.curlyBrace)
            ? ((axisRendererDetails.axis.labelPosition ==
                        ChartDataLabelPosition.inside) ^
                    (axisRendererDetails.axis.opposedPosition)
                ? -bracePadding
                : bracePadding)
            : 0);
  }
  double top = 0.0;
  if (axis.labelPosition == ChartDataLabelPosition.outside) {
    if (axis.opposedPosition) {
      top = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! - textSize.height
          : rectStartPoint -
              (axisRendererDetails.isMultiLevelLabelEnabled
                  ? axisRendererDetails.multiLevelLabelTotalSize.height
                  : 0) -
              textSize.height -
              titlePadding;
    } else {
      top = axisRendererDetails.titleOffset ??
          rectStartPoint +
              (axisRendererDetails.isMultiLevelLabelEnabled
                  ? axisRendererDetails.multiLevelLabelTotalSize.height
                  : 0) +
              titlePadding;
    }
  } else {
    if (axis.opposedPosition) {
      top = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! - textSize.height
          : rectStartPoint -
              axisRendererDetails.maximumLabelSize.height -
              maximumTickHeight -
              textSize.height -
              titlePadding;
    } else {
      top = axisRendererDetails.titleOffset ??
          rectStartPoint +
              axisRendererDetails.maximumLabelSize.height +
              maximumTickHeight +
              titlePadding;
    }
  }
  return top;
}

/// To get the offset for vertical axis title
double getVerticalAxisTitleOffset(
    ChartAxisRendererDetails axisRendererDetails, Size textSize) {
  double left = 0.0;
  const int innerPadding = 5;
  const int axisCrossTitlePadding = 2;
  final ChartAxis axis = axisRendererDetails.axis;
  final double maximumTickHeight =
      math.max(axis.majorTickLines.size, axis.minorTickLines.size);
  double rectStartPoint = axisRendererDetails.axisBorderEnd!;
  if (axisRendererDetails.isMultiLevelLabelEnabled) {
    const double bracePadding = 5;
    rectStartPoint = axisRendererDetails.axisBorderEnd! +
        ((axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
                    MultiLevelBorderType.squareBrace ||
                axisRendererDetails.axis.multiLevelLabelStyle.borderType ==
                    MultiLevelBorderType.curlyBrace)
            ? ((axisRendererDetails.axis.labelPosition ==
                        ChartDataLabelPosition.inside) ^
                    (axisRendererDetails.axis.opposedPosition)
                ? bracePadding
                : -bracePadding)
            : 0);
  }
  if (axis.labelPosition == ChartDataLabelPosition.outside) {
    if (!axis.opposedPosition) {
      left = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! -
              textSize.height / 2 -
              axisCrossTitlePadding
          : rectStartPoint -
              ((axis.multiLevelLabels != null)
                  ? axisRendererDetails.multiLevelLabelTotalSize.width
                  : 0.0) -
              textSize.height / 2 -
              innerPadding;
    } else {
      left = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! +
              textSize.height / 2 +
              axisCrossTitlePadding
          : rectStartPoint +
              (axis.multiLevelLabels != null
                  ? axisRendererDetails.multiLevelLabelTotalSize.width
                  : 0.0) +
              innerPadding +
              textSize.height / 2;
    }
  } else {
    if (!axis.opposedPosition) {
      left = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! -
              textSize.height / 2 -
              axisCrossTitlePadding
          : rectStartPoint -
              maximumTickHeight -
              axisRendererDetails.maximumLabelSize.width -
              textSize.height / 2 -
              innerPadding;
    } else {
      left = axisRendererDetails.titleOffset != null
          ? axisRendererDetails.titleOffset! +
              textSize.height / 2 +
              axisCrossTitlePadding
          : rectStartPoint +
              maximumTickHeight +
              axisRendererDetails.maximumLabelSize.width +
              textSize.height / 2 +
              innerPadding;
    }
  }
  return left;
}

/// Returns the actual start or end value that is
/// for numeric and logarithmic axis, returns numeric value,
/// for date time axis returns milliseconds,
/// for category and date time category returns index value
num _getActualValue(ChartAxisRendererDetails axisRendererDetails,
    dynamic multiLevelLabelInputValue) {
  final ChartAxis axis = axisRendererDetails.axis;
  if (axis is NumericAxis) {
    multiLevelLabelInputValue = multiLevelLabelInputValue.toDouble();
  }
  if (axis is CategoryAxis) {
    final CategoryAxisDetails axisDetails =
        axisRendererDetails as CategoryAxisDetails;
    multiLevelLabelInputValue =
        axisDetails.labels.indexOf(multiLevelLabelInputValue);
  }
  if (axis is DateTimeAxis) {
    multiLevelLabelInputValue =
        multiLevelLabelInputValue.millisecondsSinceEpoch;
  }
  if (axis is DateTimeCategoryAxis) {
    final DateTimeCategoryAxisDetails axisDetails =
        axisRendererDetails as DateTimeCategoryAxisDetails;
    multiLevelLabelInputValue = axisDetails.labels.indexOf(
        axisRendererDetails.dateFormat.format(multiLevelLabelInputValue));
  }
  if (axis is LogarithmicAxis) {
    final LogarithmicAxisDetails axisDetails =
        axisRendererDetails as LogarithmicAxisDetails;
    multiLevelLabelInputValue = calculateLogBaseValue(
        multiLevelLabelInputValue, axisDetails.logarithmicAxis.logBase);
  }
  return multiLevelLabelInputValue as num;
}

/// To find the label is in between ticks
bool isLabelBetweenTicks(ChartAxis axis) {
  bool isBetweenTicks = false;
  if (axis is CategoryAxis || axis is DateTimeCategoryAxis) {
    if (axis is CategoryAxis) {
      final CategoryAxis chartAxis = axis;
      isBetweenTicks = chartAxis.labelPlacement == LabelPlacement.betweenTicks;
    } else if (axis is DateTimeCategoryAxis) {
      final DateTimeCategoryAxis chartAxis = axis;
      isBetweenTicks = chartAxis.labelPlacement == LabelPlacement.betweenTicks;
    }
  }
  return isBetweenTicks;
}
