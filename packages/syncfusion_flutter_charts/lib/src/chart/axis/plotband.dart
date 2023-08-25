import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Render plot band.
///
/// Plot bands are also known as strip lines, which are used to shade the different ranges in plot
/// area with different colors to improve the readability of the chart.
///
/// Plot bands are drawn based on the
/// axis, you have to add plot bands using the plotBands property of the respective axis. You can also add
/// multiple plot bands to an axis.
///
/// Provides the property of visible, opacity, start, end, color, border color, and border width to
/// customize the appearance.
///
@immutable
class PlotBand {
  /// Creating an argument constructor of PlotBand class.
  // ignore: prefer_const_constructors_in_immutables
  PlotBand(
      {this.isVisible = true,
      this.start,
      this.end,
      this.color = Colors.grey,
      this.opacity = 1.0,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.text,
      this.textStyle,
      this.isRepeatable = false,
      this.repeatEvery = 1,
      this.verticalTextPadding,
      this.horizontalTextPadding,
      this.repeatUntil,
      this.textAngle,
      this.shouldRenderAboveSeries = false,
      this.sizeType = DateTimeIntervalType.auto,
      this.dashArray = const <double>[0, 0],
      this.size,
      this.associatedAxisStart,
      this.associatedAxisEnd,
      this.verticalTextAlignment = TextAnchor.middle,
      this.horizontalTextAlignment = TextAnchor.middle,
      this.gradient});

  /// Toggles the visibility of the plot band.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final bool isVisible;

  /// Specifies the start value of plot band.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                     start: 1,
  ///                     end: 5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic start;

  /// Specifies the end value of plot band.
  ///
  /// Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                     start: 1,
  ///                     end: 5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic end;

  /// Text to be displayed in the plot band segment.
  ///
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    text:'Winter'
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final String? text;

  /// Customizes the text style of plot band.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    textStyle: const TextStyle(color:Colors.red)
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final TextStyle? textStyle;

  /// Color of the plot band.
  ///
  /// Defaults to `Colors.grey`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    color: Colors.red
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final Color color;

  /// Color of the plot band border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    borderColor: Colors.red
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final Color borderColor;

  /// Width of the plot band border.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    borderWidth: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final double borderWidth;

  /// Opacity of the plot band. The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    opacity: 0.5
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final double opacity;

  /// Specifies the plot band need to be repeated in specified interval.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    isRepeatable: true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final bool isRepeatable;

  /// Interval of the plot band need to be repeated.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    repeatEvery: 200
  ///                )
  ///              ]
  ///           )
  ///        )
  ///     );
  ///}
  ///```
  final dynamic repeatEvery;

  /// End of the plot band need to be repeated.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    repeatUntil: 600
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic repeatUntil;

  /// Angle of the plot band text.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    textAngle: 90
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final double? textAngle;

  /// Specifies whether the plot band needs to be rendered above the series.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    shouldRenderAboveSeries: true
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final bool shouldRenderAboveSeries;

  /// Date time interval type of the plot band.
  ///
  /// Defaults to  `DateTimeIntervalType.auto`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    sizeType: DateTimeIntervalType.years
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final DateTimeIntervalType sizeType;

  /// Dashes of the series. Any number of values can be provided in the list. Odd value
  /// is considered as rendering size and even value is considered as gap.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    dashArray: <double>[10, 10]
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final List<double> dashArray;

  /// Size of the plot band.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    size: 20
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic size;

  /// Perpendicular axis start value.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    associatedAxisStart: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic associatedAxisStart;

  /// Perpendicular axis end value.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    associatedAxisStart: 2
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final dynamic associatedAxisEnd;

  /// Vertical text alignment of the plot band text.
  ///
  /// Defaults to `TextAnchor.middle`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    verticalTextAlignment: TextAnchor.start
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final TextAnchor verticalTextAlignment;

  /// Horizontal text alignment of the plot band text.
  ///
  /// Defaults to `TextAnchor.middle`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    horizontalTextAlignment: TextAnchor.end
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  ///```
  final TextAnchor horizontalTextAlignment;

  /// Fills the plot band with gradient color.
  ///
  ///```dart
  ///final List <Color> color = <Color>[];
  ///    color.add(Colors.pink[50]);
  ///    color.add(Colors.pink[200]);
  ///    color.add(Colors.pink);
  ///
  ///final List<double> stops = <double>[];
  ///    stops.add(0.0);
  ///    stops.add(0.5);
  ///    stops.add(1.0);
  ///
  ///final LinearGradient gradients = LinearGradient(colors: color, stops: stops);
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    isVisible:true,
  ///                    gradient: gradients
  ///                )
  ///              ]
  ///           )
  ///        )
  ///     );
  ///}
  ///```
  final LinearGradient? gradient;

  /// To move the plot band text vertically.
  ///
  /// Takes pixel or percentage value. For pixel, input should be like `10px` and for percentage
  /// input should be like `10%`. If no suffix is specified (`10`), it will be considered as pixel value.
  /// Percentage value referes to the overall height of the chart. i.e. 100% is equal to the height
  /// of the chart.
  ///
  /// This is applicable for both vertical and horizontal axis. Positive value for this property
  /// moves the text upwards and negative value moves downwards.
  ///
  /// If [verticalTextAlignment] or [horizontalTextAlignment] is specified, text padding will be calculated
  /// from that modified position.
  ///
  /// Defaults to `null`.
  ///
  ///
  ///```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    verticalTextPadding:'30%',
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  final String? verticalTextPadding;

  /// To move the plot band text horizontally.
  ///
  /// Takes pixel or percentage value. For pixel, input should be like `10px` and for percentage
  /// input should be like `10%`. If no suffix is specified (`10`), it will be considered as pixel value.
  /// Percentage value referes to the overall width of the chart. i.e. 100% is equal to the width
  /// of the chart.
  ///
  /// This is applicable for both vertical and horizontal axis. Positive value for this property
  /// moves the text to right and negative value moves to left.
  ///
  /// If [verticalTextAlignment] or [horizontalTextAlignment] is specified, text padding will be calculated
  /// from that modified position.
  ///
  /// Defaults to `null`.
  ///```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             plotBands: <PlotBand>[
  ///                PlotBand(
  ///                    horizontalTextPadding:'30%',
  ///                )
  ///              ]
  ///           )
  ///        )
  ///    );
  ///}
  final String? horizontalTextPadding;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PlotBand &&
        other.isVisible == isVisible &&
        other.start == start &&
        other.end == end &&
        other.color == color &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.isRepeatable == isRepeatable &&
        other.repeatEvery == repeatEvery &&
        other.verticalTextPadding == verticalTextPadding &&
        other.horizontalTextPadding == horizontalTextPadding &&
        other.repeatUntil == repeatUntil &&
        other.textAngle == textAngle &&
        other.shouldRenderAboveSeries == shouldRenderAboveSeries &&
        other.sizeType == sizeType &&
        other.dashArray == dashArray &&
        other.size == size &&
        other.associatedAxisStart == associatedAxisStart &&
        other.associatedAxisEnd == associatedAxisEnd &&
        other.verticalTextAlignment == verticalTextAlignment &&
        other.horizontalTextAlignment == horizontalTextAlignment &&
        other.gradient == gradient;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      start,
      end,
      color,
      opacity,
      borderColor,
      borderWidth,
      text,
      textStyle,
      isRepeatable,
      repeatEvery,
      verticalTextPadding,
      horizontalTextPadding,
      repeatUntil,
      textAngle,
      shouldRenderAboveSeries,
      sizeType,
      dashArray,
      size,
      associatedAxisStart,
      associatedAxisEnd,
      verticalTextAlignment,
      horizontalTextAlignment,
      gradient
    ];
    return Object.hashAll(values);
  }
}

/// Method to get the plot band painter
CustomPainter getPlotBandPainter({
  required CartesianStateProperties stateProperties,
  required bool shouldRenderAboveSeries,
  required ValueNotifier<num> notifier,
}) {
  return _PlotBandPainter(
      stateProperties: stateProperties,
      shouldRenderAboveSeries: shouldRenderAboveSeries,
      notifier: notifier);
}

class _PlotBandPainter extends CustomPainter {
  _PlotBandPainter(
      {required this.stateProperties,
      required this.shouldRenderAboveSeries,
      required ValueNotifier<num> notifier})
      : chart = stateProperties.chart,
        super(repaint: notifier);

  final CartesianStateProperties stateProperties;

  final SfCartesianChart chart;

  final bool shouldRenderAboveSeries;

  /// To paint plotbands
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    for (int axisIndex = 0;
        axisIndex < stateProperties.chartAxis.axisRenderersCollection.length;
        axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          stateProperties.chartAxis.axisRenderersCollection[axisIndex];
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      final ChartAxis axis = axisDetails.axis;
      for (int j = 0; j < axis.plotBands.length; j++) {
        final PlotBand plotBand = axis.plotBands[j];
        if (plotBand.isVisible &&
            shouldRenderAboveSeries != plotBand.shouldRenderAboveSeries) {
          clipRect = Rect.fromLTRB(
              stateProperties.chartAxis.axisClipRect.left,
              stateProperties.chartAxis.axisClipRect.top,
              stateProperties.chartAxis.axisClipRect.right,
              stateProperties.chartAxis.axisClipRect.bottom);
          canvas.clipRect(clipRect);
          _renderPlotBand(canvas, axisRenderer, plotBand);
        }
      }
    }
  }

  /// To find the start and end location for plotband
  ChartLocation _getStartAndEndValues(ChartAxisRenderer axisRenderer,
      dynamic start, dynamic end, PlotBand plotBand, bool isNeedRepeat) {
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    dynamic startValue = start is String && num.tryParse(start) != null
        ? num.tryParse(start)
        : start;

    dynamic endValue =
        end is String && num.tryParse(end) != null ? num.tryParse(end) : end;
    if (axisRenderer is DateTimeAxisRenderer) {
      startValue = startValue is DateTime
          ? startValue.millisecondsSinceEpoch
          : startValue;
      endValue = isNeedRepeat
          ? plotBand.repeatUntil is DateTime
              ? plotBand.repeatUntil.millisecondsSinceEpoch
              : plotBand.repeatUntil
          : endValue is DateTime
              ? endValue.millisecondsSinceEpoch
              : endValue;
    } else if (axisDetails is CategoryAxisDetails) {
      startValue = startValue is num
          ? startValue
          : axisDetails.labels.indexOf(startValue);
      endValue = isNeedRepeat
          ? plotBand.repeatUntil is num
              ? plotBand.repeatUntil.floor()
              : axisDetails.labels.indexOf(plotBand.repeatUntil)
          : endValue is num
              ? endValue
              : axisDetails.labels.indexOf(endValue);
    }
    if (axisDetails is DateTimeCategoryAxisDetails) {
      startValue = startValue is num
          ? startValue
          : (startValue is DateTime
              ? axisDetails.labels.indexOf(axisDetails.axis.isVisible
                  ? axisDetails.dateFormat.format(startValue)
                  : startValue.microsecondsSinceEpoch.toString())
              : axisDetails.labels.indexOf(startValue));
      endValue = isNeedRepeat
          ? plotBand.repeatUntil is num
              ? plotBand.repeatUntil.floor()
              : axisDetails.labels.indexOf(plotBand.repeatUntil)
          : endValue is num
              ? endValue
              : endValue is DateTime
                  ? axisDetails.labels.indexOf(axisDetails.axis.isVisible
                      ? axisDetails.dateFormat.format(endValue)
                      : endValue.microsecondsSinceEpoch.toString())
                  : axisDetails.labels.indexOf(endValue);
    } else if (axisRenderer is LogarithmicAxisRenderer ||
        axisRenderer is NumericAxisRenderer) {
      endValue = isNeedRepeat ? plotBand.repeatUntil : endValue;
    }
    return ChartLocation(startValue.toDouble(), endValue.toDouble());
  }

  /// Render a method for plotband
  void _renderPlotBand(
      Canvas canvas, ChartAxisRenderer axisRenderer, PlotBand plotBand) {
    num startValue, endValue;
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final bool isNeedRepeat = plotBand.isRepeatable &&
        plotBand.repeatUntil != null &&
        plotBand.repeatEvery != null;

    final ChartLocation startAndEndValues = _getStartAndEndValues(
        axisRenderer,
        plotBand.start ?? axisDetails.visibleRange!.minimum,
        plotBand.end ?? axisDetails.visibleRange!.maximum,
        plotBand,
        isNeedRepeat);
    startValue = startAndEndValues.x;
    endValue = startAndEndValues.y;
    if (isNeedRepeat) {
      num repeatStart = startValue, repeatEnd;
      while (repeatStart < endValue) {
        repeatEnd = _getPlotBandValue(axisRenderer, plotBand, repeatStart,
            plotBand.size ?? plotBand.repeatEvery);
        repeatEnd = repeatEnd > endValue ? endValue : repeatEnd;
        _renderPlotBandElement(
            axisRenderer, repeatStart, repeatEnd, plotBand, canvas);
        repeatStart = plotBand.size != null
            ? _getPlotBandValue(
                axisRenderer, plotBand, repeatStart, plotBand.repeatEvery)
            : repeatEnd;
      }
    } else {
      _renderPlotBandElement(
          axisRenderer, startValue, endValue, plotBand, canvas);
    }
  }

  /// To get and return value for date time axis
  num _getPlotBandValue(ChartAxisRenderer axisRenderer, PlotBand plotBand,
      num value, num increment) {
    final int addValue = increment.toInt();
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    DateTimeIntervalType intervalType;
    if (axisDetails is DateTimeAxisDetails) {
      intervalType = (plotBand.sizeType == DateTimeIntervalType.auto)
          ? axisDetails.actualIntervalType
          : plotBand.sizeType;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      switch (intervalType) {
        case DateTimeIntervalType.years:
          date = DateTime(date.year + addValue, date.month, date.day, date.hour,
              date.minute, date.second, date.millisecond);
          break;
        case DateTimeIntervalType.months:
          date = DateTime(date.year, date.month + addValue, date.day, date.hour,
              date.minute, date.second, date.millisecond);
          break;
        case DateTimeIntervalType.days:
          date = DateTime(date.year, date.month, date.day + addValue, date.hour,
              date.minute, date.second, date.millisecond);
          break;
        case DateTimeIntervalType.hours:
          date = DateTime(date.year, date.month, date.day, date.hour + addValue,
              date.minute, date.second, date.millisecond);
          break;
        case DateTimeIntervalType.minutes:
          date = DateTime(date.year, date.month, date.day, date.hour,
              date.minute + addValue, date.second, date.millisecond);
          break;
        case DateTimeIntervalType.seconds:
          date = DateTime(date.year, date.month, date.day, date.hour,
              date.minute, date.second + addValue, date.millisecond);
          break;
        case DateTimeIntervalType.milliseconds:
          date = DateTime(date.year, date.month, date.day, date.hour,
              date.minute, date.second, date.millisecond + addValue);
          break;
        case DateTimeIntervalType.auto:
          break;
      }
      value = date.millisecondsSinceEpoch;
    } else {
      value += addValue;
    }
    return value;
  }

  /// Render plotband element
  void _renderPlotBandElement(ChartAxisRenderer axisRenderer, num startValue,
      num endValue, PlotBand plotBand, Canvas canvas) {
    ChartLocation startPoint, endPoint, segmentStartPoint, segmentEndPoint;
    Rect plotBandRect;
    int textAngle;
    double? left, top, bottom, right;
    final ChartAxisRendererDetails axisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxis axis = axisDetails.axis;
    final Rect axisRect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(
            axisDetails.orientation == AxisOrientation.horizontal
                ? axis.plotOffset
                : 0,
            axisDetails.orientation == AxisOrientation.vertical
                ? axis.plotOffset
                : 0));
    final num visibleMin = axis is LogarithmicAxis
        ? pow(axis.logBase, axisDetails.visibleRange!.minimum)
        : axisDetails.visibleRange!.minimum;
    final num visibleMax = axis is LogarithmicAxis
        ? pow(axis.logBase, axisDetails.visibleRange!.maximum)
        : axisDetails.visibleRange!.maximum;

    endValue < 0
        ? endValue <= visibleMin
            ? endValue = visibleMin
            : endValue = endValue
        : endValue >= visibleMax
            ? endValue = visibleMax
            : endValue = endValue;

    startValue < 0
        ? startValue <= visibleMin
            ? startValue = visibleMin
            : startValue = startValue
        : startValue >= visibleMax
            ? startValue = visibleMax
            : startValue = startValue;

    startPoint = calculatePoint(startValue, startValue, axisDetails,
        axisDetails, stateProperties.requireInvertedAxis, null, axisRect);
    endPoint = calculatePoint(endValue, endValue, axisDetails, axisDetails,
        stateProperties.requireInvertedAxis, null, axisRect);

    ChartAxisRenderer? segmentAxisRenderer;
    if (plotBand.associatedAxisStart != null ||
        plotBand.associatedAxisEnd != null) {
      if (axis.associatedAxisName == null) {
        segmentAxisRenderer =
            (axisDetails.orientation == AxisOrientation.horizontal)
                ? stateProperties.chartAxis.primaryYAxisRenderer
                : stateProperties.chartAxis.primaryXAxisRenderer;
      } else {
        for (int axisIndex = 0;
            axisIndex <
                stateProperties.chartAxis.axisRenderersCollection.length;
            axisIndex++) {
          final ChartAxisRenderer targetAxisRenderer =
              stateProperties.chartAxis.axisRenderersCollection[axisIndex];
          final ChartAxisRendererDetails targetAxisDetails =
              AxisHelper.getAxisRendererDetails(targetAxisRenderer);
          if (axis.associatedAxisName == targetAxisDetails.name) {
            segmentAxisRenderer = axisRenderer;
          }
        }
      }
      final ChartLocation startAndEndValues = _getStartAndEndValues(
          segmentAxisRenderer!,
          plotBand.associatedAxisStart ?? startValue,
          plotBand.associatedAxisEnd ?? endValue,
          plotBand,
          false);
      final ChartAxisRendererDetails segmentAxisDetails =
          AxisHelper.getAxisRendererDetails(segmentAxisRenderer);
      if (segmentAxisDetails.orientation == AxisOrientation.horizontal) {
        segmentStartPoint = calculatePoint(
            startAndEndValues.x,
            startValue,
            segmentAxisDetails,
            axisDetails,
            stateProperties.requireInvertedAxis,
            null,
            axisRect);
        segmentEndPoint = calculatePoint(
            startAndEndValues.y,
            endValue,
            segmentAxisDetails,
            axisDetails,
            stateProperties.requireInvertedAxis,
            null,
            axisRect);
        left = plotBand.associatedAxisStart != null
            ? segmentStartPoint.x
            : axisRect.left;
        right = plotBand.associatedAxisEnd != null
            ? segmentEndPoint.x
            : axisRect.right;
      } else {
        segmentStartPoint = calculatePoint(
            startValue,
            startAndEndValues.x,
            axisDetails,
            segmentAxisDetails,
            stateProperties.requireInvertedAxis,
            null,
            axisRect);
        segmentEndPoint = calculatePoint(
            endValue,
            startAndEndValues.y,
            axisDetails,
            segmentAxisDetails,
            stateProperties.requireInvertedAxis,
            null,
            axisRect);
        top = plotBand.associatedAxisStart != null
            ? segmentStartPoint.y
            : axisRect.bottom;
        bottom = plotBand.associatedAxisEnd != null
            ? segmentEndPoint.y
            : axisRect.top;
      }
    }

    if (axisDetails.orientation == AxisOrientation.horizontal) {
      textAngle =
          plotBand.textAngle != null ? plotBand.textAngle!.toInt() : 270;
      plotBandRect = Rect.fromLTRB(left ?? startPoint.x, top ?? axisRect.top,
          right ?? endPoint.x, bottom ?? axisRect.bottom);
    } else {
      textAngle = plotBand.textAngle != null ? plotBand.textAngle!.toInt() : 0;
      plotBandRect = Rect.fromLTRB(left ?? axisRect.left, top ?? endPoint.y,
          right ?? axisRect.right, bottom ?? startPoint.y);
    }
    _drawPlotBand(plotBand, plotBandRect, textAngle, canvas, axis);
  }

  /// To draw the plotband
  void _drawPlotBand(PlotBand plotBand, Rect plotBandRect, int textAngle,
      Canvas canvas, ChartAxis axis) {
    final List<double> dashArray = plotBand.dashArray;
    bool needDashLine = true;

    final TextStyle plotBandLabelStyle = stateProperties
        .renderingDetails.chartTheme.plotBandLabelTextStyle!
        .merge(plotBand.textStyle);
    // ignore: unnecessary_null_comparison
    if (plotBandRect != null && plotBand.color != null) {
      Path? path;
      for (int i = 1; i < dashArray.length; i = i + 2) {
        if (dashArray[i] == 0) {
          needDashLine = false;
        }
      }

      path = Path()
        ..moveTo(plotBandRect.left, plotBandRect.top)
        ..lineTo(plotBandRect.left + plotBandRect.width, plotBandRect.top)
        ..lineTo(plotBandRect.left + plotBandRect.width,
            plotBandRect.top + plotBandRect.height)
        ..lineTo(plotBandRect.left, plotBandRect.top + plotBandRect.height)
        ..close();

      final Paint paint = Paint();
      Path? dashedPath;
      if (needDashLine) {
        paint.isAntiAlias = false;
        dashedPath =
            dashPath(path, dashArray: CircularIntervalList<double>(dashArray));
      } else {
        dashedPath = path;
      }
      // ignore: unnecessary_null_comparison
      if (path != null) {
        Paint fillPaint;
        if (plotBand.gradient != null) {
          fillPaint = Paint()
            ..shader = plotBand.gradient!.createShader(plotBandRect)
            ..style = PaintingStyle.fill;
        } else {
          fillPaint = Paint()
            ..color = plotBand.color.withOpacity(plotBand.opacity)
            ..style = PaintingStyle.fill;
        }
        canvas.drawPath(path, fillPaint);
        if (plotBand.borderWidth > 0 &&
            // ignore: unnecessary_null_comparison
            plotBand.borderColor != null &&
            // ignore: unnecessary_null_comparison
            dashedPath != null) {
          canvas.drawPath(
              dashedPath,
              paint
                ..color = plotBand.borderColor.withOpacity(plotBand.opacity)
                ..style = PaintingStyle.stroke
                ..strokeWidth = plotBand.borderWidth);
        }
      }
    }
    if (plotBand.text != null && plotBand.text!.isNotEmpty) {
      final Size textSize =
          measureText(plotBand.text!, plotBandLabelStyle, textAngle);
      num? x = 0;
      num? y = 0;
      if (plotBand.horizontalTextPadding != null &&
          plotBand.horizontalTextPadding != '') {
        if (plotBand.horizontalTextPadding!.contains('%')) {
          x = percentageToValue(
              plotBand.horizontalTextPadding!,
              chart.isTransposed
                  ? stateProperties.chartAxis.axisClipRect.bottom
                  : stateProperties.chartAxis.axisClipRect.right);
        } else if (plotBand.horizontalTextPadding!.contains('px')) {
          x = double.parse(plotBand.horizontalTextPadding!
              .substring(0, plotBand.horizontalTextPadding!.length - 2));
        } else {
          x = double.parse(plotBand.horizontalTextPadding!);
        }
      }
      if (plotBand.verticalTextPadding != null &&
          plotBand.verticalTextPadding != '') {
        if (plotBand.verticalTextPadding!.contains('%')) {
          y = percentageToValue(
              plotBand.verticalTextPadding!,
              chart.isTransposed
                  ? stateProperties.chartAxis.axisClipRect.right
                  : stateProperties.chartAxis.axisClipRect.bottom);
        } else if (plotBand.verticalTextPadding!.contains('px')) {
          y = double.parse(plotBand.verticalTextPadding!
              .substring(0, plotBand.verticalTextPadding!.length - 2));
        } else {
          y = double.parse(plotBand.verticalTextPadding!);
        }
      }

      drawText(
          canvas,
          plotBand.text!,
          Offset(
              plotBand.horizontalTextAlignment == TextAnchor.middle
                  ? (plotBandRect.left +
                          plotBandRect.width / 2 -
                          ((plotBandRect.left ==
                                  stateProperties.chartAxis.axisClipRect.right)
                              ? 0
                              : (plotBandRect.right ==
                                      stateProperties
                                          .chartAxis.axisClipRect.left)
                                  ? textSize.width
                                  : textSize.width / 2) +
                          x!) +
                      (textAngle != 0 ? textSize.width / 2 : 0)
                  : plotBand.horizontalTextAlignment == TextAnchor.start
                      ? plotBandRect.left + x!
                      : plotBandRect.right - textSize.width + x!,
              plotBand.verticalTextAlignment == TextAnchor.middle
                  ? (plotBandRect.top +
                          plotBandRect.height / 2 -
                          ((plotBandRect.bottom ==
                                  stateProperties.chartAxis.axisClipRect.top)
                              ? textSize.height
                              : (plotBandRect.top ==
                                      stateProperties
                                          .chartAxis.axisClipRect.bottom)
                                  ? 0 + y!
                                  : textSize.height + y!)) +
                      (textAngle != 0 ? textSize.height / 2 : 0)
                  : plotBand.verticalTextAlignment == TextAnchor.start
                      ? (plotBandRect.top - y!)
                      : plotBandRect.bottom - textSize.height - y!),
          plotBandLabelStyle,
          textAngle);
    }
  }

  @override
  bool shouldRepaint(_PlotBandPainter oldDelegate) => true;
}
