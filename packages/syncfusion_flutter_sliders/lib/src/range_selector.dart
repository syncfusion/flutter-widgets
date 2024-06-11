import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'range_slider_base.dart';
import 'slider_shapes.dart';
import 'theme.dart';

/// A Material Design range selector.
///
/// Used to select a range between [min] and [max].
/// It supports both numeric and date ranges.
/// It accepts any type of framework widget or custom widget like [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html) as a child.
///
/// The range selector elements are:
///
/// * The "track", which is the rounded rectangle in which
/// the thumbs are slides over.
/// * The "thumb", which is a shape that slides horizontally when
/// the user drags it.
/// * The "active" side of the range selector is between
/// the left and right thumbs.
/// * The "inactive" side of the range selector is between the [min] value and
/// the left thumb, and the right thumb and the [max] value.
/// For RTL, the inactive side of the range selector is between the [max] value
/// and the left thumb, and the right thumb and the [min] value.
/// * The "dividers", which is a shape that renders on the track based on the
/// given [interval] value.
/// * The "ticks", which is a shape that rendered based on
/// given [interval] value. Basically, it is rendered below the track.
/// It is also called “major ticks”.
/// * The "minor ticks", which is a shape that renders between two major ticks
/// based on given [minorTicksPerInterval] value.
/// Basically, it is rendered below the track.
/// * The "labels", which is a text that rendered based on
/// given [interval] value.
/// Basically, it is rendered below the track and the major ticks.
/// * The "child", which can be any type of framework widget or custom widget
/// like [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html) as a child.
///
/// Either [controller] or [initialValues] need to be set
/// to render [SfRangeSelector].
///
/// The range selector will be disabled if [enabled] is false or
/// [min] is equal to [max].
///
/// The range selector widget maintains state internally.
/// So, the widget calls the [onChanged] callback with the new values
/// when the state of range selector changes.
///
/// Range selector can be customized using the [SfRangeSelectorTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorTheme-class.html) with the help of [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html),
/// or the [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) with the help of [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html).
/// It is also possible to override the appearance using [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html)
/// which were set using the properties of the widget like
/// [activeColor] and [inactiveColor].
///
/// ## Example
///
/// This snippet shows how to create a numeric [SfRangeSelector].
///
/// ```dart
/// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
///
/// SfRangeSelector(
///     min: 0.0,
///     max: 10.0,
///     initialValues: _initialValues,
///     interval: 1,
///     showTicks: true,
///     showLabels: true,
///     child: Container(
///         height: 200,
///         color: Colors.green[100],
///     ),
/// )
/// ```
///
/// This snippet shows how to create a date [SfRangeSelector].
///
/// ```dart
/// SfRangeValues _initialValues = SfRangeValues(
///      DateTime(2002, 12, 31, 24), DateTime(2003, 12, 31, 24));
///
/// SfRangeSelector(
///     min: DateTime(2000, 01, 01, 00),
///     max: DateTime(2005, 12, 31, 24),
///     initialValues: _initialValues,
///     interval: 1,
///     dateFormat: DateFormat.y(),
///     dateIntervalType: DateIntervalType.years,
///     child: Container(
///         height: 200,
///         color: Colors.green[100],
///     ),
/// )
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html), for customizing the visual appearance of the range selector.
/// * [numberFormat] and [dateFormat], for formatting the
/// numeric and date labels.
/// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the visual appearance of the range selector.
/// * [RangeController](https://pub.dev/documentation/syncfusion_flutter_core/latest/core/RangeController-class.html), for coordinating between [SfRangeSelector] and the widget which listens to it.
/// * [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html) and [RangeController](https://pub.dev/documentation/syncfusion_flutter_core/latest/core/RangeController-class.html), for selection and zooming.
class SfRangeSelector extends StatefulWidget {
  /// Creates a [SfRangeSelector].
  const SfRangeSelector(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      this.initialValues,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.controller,
      this.enabled = true,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.deferredUpdateDelay = 500,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDividers = false,
      this.enableTooltip = false,
      this.shouldAlwaysShowTooltip = false,
      this.enableIntervalSelection = false,
      this.enableDeferredUpdate = false,
      this.dragMode = SliderDragMode.onThumb,
      this.inactiveColor,
      this.activeColor,
      this.labelPlacement = LabelPlacement.onTicks,
      this.edgeLabelPlacement = EdgeLabelPlacement.auto,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape = const SfTrackShape(),
      this.dividerShape = const SfDividerShape(),
      this.overlayShape = const SfOverlayShape(),
      this.thumbShape = const SfThumbShape(),
      this.tickShape = const SfTickShape(),
      this.minorTickShape = const SfMinorTickShape(),
      this.tooltipShape = const SfRectangularTooltipShape(),
      this.startThumbIcon,
      this.endThumbIcon,
      required this.child})
      : assert(min != max),
        assert(interval == null || interval > 0),
        assert(stepSize == null || stepSize > 0),
        assert(!enableIntervalSelection ||
            (enableIntervalSelection && (interval != null && interval > 0))),
        assert(controller != null || initialValues != null),
        super(key: key);

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than [max].
  final dynamic min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than [min].
  final dynamic max;

  /// The values that initially selected in the range selector.
  ///
  /// The range selector's start and end thumbs are drawn
  /// corresponding to these values.
  ///
  /// For date values, the range selector doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType], and [dateFormat]
  /// for date values, if the labels, ticks, and dividers are needed.
  ///
  /// The range selector widget maintains state internally.
  /// So, the widget calls the [onChanged] callback with the new values
  /// when the state of range selector changes.
  ///
  /// This snippet shows how to create a numeric [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///     min: 0.0,
  ///     max: 10.0,
  ///     initialValues: _initialValues,
  ///     interval: 1,
  ///     showTicks: true,
  ///     showLabels: true,
  ///     child: Container(
  ///         height: 200,
  ///         color: Colors.green[100],
  ///     ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [RangeController](https://pub.dev/documentation/syncfusion_flutter_core/latest/core/RangeController-class.html), for coordinating between [SfRangeSelector] and the widget which listens to it.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final SfRangeValues? initialValues;

  /// Called when the user is selecting a new values
  /// for the selector by dragging.
  ///
  /// When the values of the range selector changes, the widget calls the
  /// [onChanged] callback with the new values.
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///     min: 1.0,
  ///     max: 10.0,
  ///     initialValues: _initialValues,
  ///     onChanged: (SfRangeValues values) {},
  ///     child: Container(
  ///         height: 200,
  ///         color: Colors.green[100],
  ///     ),
  /// )
  /// ```
  final ValueChanged<SfRangeValues>? onChanged;

  /// The [onChangeStart] callback will be called when the user starts
  /// to tap or drag the range selector. This callback is only used to
  /// notify the user about the start interaction and it does not update
  /// the range selector value.
  ///
  /// The last interacted thumb value will be passed to this callback.
  /// The value will be double or date time.
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfRangeSelector(
  ///       min: 0,
  ///       max: 10,
  ///       initialValues: _values,
  ///       onChangeStart: (SfRangeValues startValue) {
  ///         print('Interaction start');
  ///       },
  ///       child: Container(
  ///         height: 150,
  ///         color: Colors.green,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// •	The [onChangeEnd] callback used to notify the user about the
  ///   interaction end.
  /// •	The [onChanged] callback used to update the slider thumb value.
  final ValueChanged<SfRangeValues>? onChangeStart;

  /// The [onChangeEnd] callback will be called when the user ends
  /// tap or drag the range selector.
  ///
  /// This callback is only used to notify the user about the end interaction
  /// and it does not update the range selector thumb value.
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfRangeSelector(
  ///       min: 0,
  ///       max: 10,
  ///       initialValues: _values,
  ///       onChangeEnd: (SfRangeValues endValue) {
  ///         print('Interaction end');
  ///       },
  ///       child: Container(
  ///         height: 150,
  ///         color: Colors.green,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// •	The [onChangeStart] callback used to notify the user about the
  ///   interaction begins.
  /// •	The [onChanged] callback used to update the range selector thumb value.
  final ValueChanged<SfRangeValues>? onChangeEnd;

  /// Coordinates between [SfRangeSelector] and the widget which listens to it.
  ///
  /// Built-in support for selection and zooming with [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
  ///
  /// Range controller contains `start` and `end` values.
  ///
  /// `start` - represents the currently selected start value
  /// of the range selector.
  /// The start thumb of the range selector was drawn
  /// corresponding to this value.
  ///
  /// `end` - represents the currently selected end value of the range selector.
  /// The end thumb of the range selector was drawn corresponding to this value.
  ///
  /// `start` and `end` can be either `double` or `DateTime`.
  ///
  /// ## Selection in [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
  ///
  /// ```dart
  /// class RangeSelectorPage extends StatefulWidget {
  ///   const RangeSelectorPage({ Key key }) : super(key: key);
  ///   @override
  ///   _RangeSelectorPageState createState() => _RangeSelectorPageState();
  /// }
  ///
  /// class _RangeSelectorPageState extends State<RangeSelectorPage> {
  ///  final double _min = 2.0;
  ///  final double _max = 10.0;
  ///  late RangeController _rangeController;
  ///  SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///     _rangeController = RangeController(
  ///     start: _values.start,
  ///     end: _values.end);
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   _rangeController.dispose();
  ///   super.dispose();
  /// }
  ///
  /// final List<Data> chartData = <Data>[
  ///    Data(x:2.0, y: 2.2),
  ///    Data(x:3.0, y: 3.4),
  ///    Data(x:4.0, y: 2.8),
  ///    Data(x:5.0, y: 1.6),
  ///    Data(x:6.0, y: 2.3),
  ///    Data(x:7.0, y: 2.5),
  ///    Data(x:8.0, y: 2.9),
  ///    Data(x:9.0, y: 3.8),
  ///    Data(x:10.0, y: 3.7),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return MaterialApp(
  ///      home: Scaffold(
  ///          body: Center(
  ///              child: SfRangeSelector(
  ///                    min: _min,
  ///                    max: _max,
  ///                    interval: 1,
  ///                    showTicks: true,
  ///                    showLabels: true,
  ///                   controller: _rangeController,
  ///                    child: Container(
  ///                    height: 130,
  ///                   child: SfCartesianChart(
  ///                        margin: const EdgeInsets.all(0),
  ///                        primaryXAxis: NumericAxis(minimum: _min,
  ///                            maximum: _max,
  ///                            isVisible: false),
  ///                        primaryYAxis: NumericAxis(isVisible: false),
  ///                        plotAreaBorderWidth: 0,
  ///                        series: <SplineAreaSeries<Data, double>>[
  ///                            SplineAreaSeries<Data, double>(
  ///                                selectionSettings: SelectionSettings(
  ///                                    enable: true,
  ///                                    selectionController: _rangeController),
  ///                                color: Color.fromARGB(255, 126, 184, 253),
  ///                                dataSource: chartData,
  ///                                xValueMapper:
  ///                                  (Data sales, int value) => sales.x,
  ///                                yValueMapper:
  ///                                  (Data sales, int value) => sales.y)
  ///                             ],
  ///                         ),
  ///                     ),
  ///                 ),
  ///             )
  ///         )
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// ## Zooming in [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
  ///
  /// ```dart
  /// class RangeZoomingPage extends StatefulWidget {
  ///   const RangeZoomingPage({ Key key }) : super(key: key);
  ///   @override
  ///   _RangeZoomingPageState createState() => _RangeZoomingPageState();
  /// }
  ///
  /// class _RangeZoomingPageState extends State<RangeZoomingPage> {
  ///  final double _min = 2.0;
  ///  final double _max = 10.0;
  ///  SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///  late RangeController _rangeController;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///     _rangeController = RangeController(
  ///     start: _values.start,
  ///     end: _values.end);
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   _rangeController.dispose();
  ///   super.dispose();
  /// }
  ///
  /// final List<Data> chartData = <Data>[
  ///    Data(x:2.0, y: 2.2),
  ///    Data(x:3.0, y: 3.4),
  ///    Data(x:4.0, y: 2.8),
  ///    Data(x:5.0, y: 1.6),
  ///    Data(x:6.0, y: 2.3),
  ///    Data(x:7.0, y: 2.5),
  ///    Data(x:8.0, y: 2.9),
  ///    Data(x:9.0, y: 3.8),
  ///    Data(x:10.0, y: 3.7),
  /// ];
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return MaterialApp(
  ///      home: Scaffold(
  ///          body: Center(
  ///              child: SfRangeSelector(
  ///                    min: _min,
  ///                    max: _max,
  ///                    interval: 1,
  ///                    showTicks: true,
  ///                    showLabels: true,
  ///                   controller: _rangeController,
  ///                    child: Container(
  ///                    height: 130,
  ///                   child: SfCartesianChart(
  ///                        margin: const EdgeInsets.all(0),
  ///                        primaryXAxis: NumericAxis(minimum: _min,
  ///                            maximum: _max,
  ///                            isVisible: false,
  ///                            rangeController: _rangeController),
  ///                        primaryYAxis: NumericAxis(isVisible: false),
  ///                        plotAreaBorderWidth: 0,
  ///                        series: <SplineAreaSeries<Data, double>>[
  ///                            SplineAreaSeries<Data, double>(
  ///                                color: Color.fromARGB(255, 126, 184, 253),
  ///                                dataSource: chartData,
  ///                                xValueMapper:
  ///                                  (Data sales, int value) => sales.x,
  ///                                yValueMapper:
  ///                                  (Data sales, int value) => sales.y)
  ///                             ],
  ///                         ),
  ///                     ),
  ///                 ),
  ///             )
  ///         )
  ///     );
  ///   }
  /// }
  /// ```
  final RangeController? controller;

  /// Controls the range selector’s state whether it is disabled or enabled.
  ///
  /// Defaults to `true`.
  ///
  /// This snippet shows how to create disable state [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///     min: 0.0,
  ///     max: 10.0,
  ///     initialValues: _initialValues,
  ///     enabled: false,
  ///     child: Container(
  ///         height: 200,
  ///         color: Colors.green[100],
  ///     ),
  /// )
  /// ```
  final bool enabled;

  /// Splits the range selector into given interval.
  /// It is mandatory if labels, major ticks and dividers are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the labels, major ticks,
  /// and dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date values, the range selector doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType], and [dateFormat]
  /// for date values, if labels, ticks, and dividers are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is [DateIntervalType.years], then the range selector
  /// will render the labels, major ticks, and dividers at 2000, 2001, 2002 and
  /// so on.
  ///
  /// Defaults to null. Must be greater than 0.
  ///
  /// This snippet shows how to set numeric interval in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///    child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    )
  /// )
  /// ```
  ///
  /// This snippet shows how to set date interval in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(
  ///      DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSelector(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///    child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showDividers], to render dividers at given interval.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final double? interval;

  /// Option to select discrete values.
  ///
  /// [stepSize] doesn’t work for [DateTime] range selector and
  /// `lockRange` doesn't works with [stepSize].
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [stepSize] is 2.0,
  /// the range selector will move the thumbs at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to create discrete [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   stepSize: 2,
  ///   child: Container(
  ///     height: 200,
  ///     color: Colors.green[100],
  ///   )
  /// )
  /// ```
  final double? stepSize;

  /// Option to select discrete date values.
  ///
  /// For example, if [min] is DateTime(2015, 01, 01) and
  /// [max] is DateTime(2020, 01, 01) and
  /// [stepDuration] is SliderStepDuration(years: 1, months: 6), the range
  /// selector will move the thumbs at DateTime(2015, 01, 01),
  /// DateTime(2016, 07, 01), DateTime(2018, 01, 01),and DateTime(2019, 07, 01).
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set stepDuration in [SfRangeSelector].
  ///
  /// ```dart
  ///   SfRangeSelector(
  ///      min: DateTime(2015, 01, 01),
  ///      max: DateTime(2020, 01, 01),
  ///      initialValues: SfRangeValues(
  ///                         DateTime(2017, 04,01), DateTime(2018, 08, 01)),
  ///      enableTooltip: true,
  ///      stepDuration: SliderStepDuration(years: 1, months: 6),
  ///      interval: 2,
  ///      showLabels: true,
  ///      showTicks: true,
  ///      minorTicksPerInterval: 1,
  ///      dateIntervalType: DateIntervalType.years,
  ///      dateFormat: DateFormat.yMd(),
  ///      child: Container(
  ///        color: Colors.pink[100],
  ///         height: 150,
  ///     ),
  ///  )
  /// ```
  ///
  /// See also:
  ///
  /// * [interval], for setting the interval.
  /// * [dateIntervalType], for changing the interval type.
  /// * [dateFormat] for formatting the date labels.
  final SliderStepDuration? stepDuration;

  /// Customize the delay duration when [enableDeferredUpdate] is `true`.
  ///
  /// Defaults to `500 milliseconds`.
  ///
  /// This code snippet shows how to customize the delay duration
  /// for [enableDeferredUpdate] using [deferredUpdateDelay].
  ///
  /// ```dart
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   enableDeferredUpdate: true,
  ///   deferredUpdateDelay: 1000,
  ///   initialValues: SfRangeValues(4.0,8.0),
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  /// * [enableDeferredUpdate] to enable the defer update in range selector.
  final int deferredUpdateDelay;

  /// Number of smaller ticks between two major ticks.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the major ticks at 0.0, 2.0, 4.0 and so on.
  /// If minorTicksPerInterval is 1, then smaller ticks will be rendered on
  /// 1.0, 3.0 and so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to show minor ticks in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showTicks: true,
  ///   minorTicksPerInterval: 1,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks] to render major ticks at given interval.
  /// * [minorTickShape] and [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html) for customizing
  /// the minor tick’s visual appearance.
  final int minorTicksPerInterval;

  /// Option to render the major ticks on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the major ticks at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show major ticks in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showTicks: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tickShape] and [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html) for customizing the
  /// major tick’s visual appearance.
  final bool showTicks;

  /// Option to render the labels on given interval.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show labels in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showLabels: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [numberFormat] and [dateFormat] for formatting the
  /// numeric and date labels.
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html) to customize the appearance of the labels.
  final bool showLabels;

  /// Option to render the dividers on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show dividers in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showDividers: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///   ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  /// * [dividerShape] and [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html) for customizing
  /// the divider’s visual appearance.
  final bool showDividers;

  /// Option to enable tooltips for both the thumbs.
  ///
  /// Used to clearly indicate the current selection of the ranges
  /// during interaction.
  ///
  /// By default, tooltip text is formatted with either [numberFormat] or
  /// [dateFormat].
  ///
  /// This snippet shows how to enable tooltip in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tooltipTextFormatterCallback], for changing the default tooltip text.
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the appearance of the tooltip text.
  final bool enableTooltip;

  /// Option to show tooltip always in range selector.
  ///
  /// Defaults to false.
  ///
  /// When this property is enabled, the tooltip is always displayed to the
  /// start and end thumbs of the selector. This property works independent
  /// of the [enableTooltip] property. While this property is enabled, the
  /// tooltip will always appear during interaction.
  ///
  /// This snippet shows how to show the tooltip in the [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfRangeSelector(
  ///       min: 0,
  ///       max: 10,
  ///       initialValues: _values,
  ///       shouldAlwaysShowTooltip: true,
  ///       child: Container(
  ///         height: 150,
  ///         color: Colors.green,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShowTooltip;

  /// Option to select the particular interval based on
  /// the position of the tap or click.
  ///
  /// Both the thumbs are moved to the selected interval
  /// if the [enableIntervalSelection] property is true,
  /// otherwise the nearest thumb is moved to the touch position.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to enable  selecting the particular interval
  /// in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues  _initialValues = SfRangeValues(40.0, 80.0);
  ///
  /// SfRangeSelector(
  ///    min: 0.0,
  ///    max: 100.0,
  ///    initialValues: _initialValues,
  ///    interval: 20,
  ///    showLabels: true,
  ///    enableTooltip: true,
  ///     enableIntervalSelection: true,
  ///    showTicks: true,
  ///   child: Container(
  ///     height: 200,
  ///     color: Colors.pink[200],
  ///   )
  /// )
  /// ```
  final bool enableIntervalSelection;

  /// Defers the range update.
  ///
  /// Updates the [controller]’s start and end values and invoke the
  /// [onChanged] callback when the thumb is dragged and held for the duration
  /// specified in the [deferredUpdateDelay].
  /// However, range values are immediately updated in touch up action.
  ///
  /// By default, range values are updated as soon as
  /// the thumb is being dragged.
  ///
  /// Defaults to `false`.
  ///
  /// This code snippet shows how to enable the [enableDeferredUpdate] in
  /// [SfRangeSelector].
  ///
  /// ```dart
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   enableDeferredUpdate: true,
  ///   initialValues: SfRangeValues(4.0,8.0),
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [deferredUpdateDelay] to customize the delay duration
  /// for the [enableDeferredUpdate].
  final bool enableDeferredUpdate;

  /// Represents the behavior of thumb dragging in the [SfRangeSelector].
  ///
  /// When [dragMode] is set to [SliderDragMode.onThumb],
  /// individual thumb can be moved by dragging it.
  ///
  /// When [dragMode] is set to [SliderDragMode.betweenThumbs], both the thumbs
  /// can be moved at the same time by dragging in the area between start and
  /// end thumbs. The range between the start and end thumb will always
  /// be the same. Hence, it is not possible to move the individual thumb.
  ///
  /// When [dragMode] is set to [SliderDragMode.both], individual thumb
  /// can be moved by dragging it, and also both the thumbs can be moved
  /// at the same time by dragging in the area between start and end thumbs.
  ///
  /// Defaults to [SliderDragMode.onThumb].
  ///
  /// This code snippet shows the behavior of thumb dragging.
  ///
  /// ```dart
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   interval: 2,
  ///   showLabels: true,
  ///   dragMode: SliderDragMode.betweenThumbs,
  ///   initialValues: SfRangeValues(4.0,8.0),
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  final SliderDragMode dragMode;

  /// Color applied to the inactive track and active dividers.
  ///
  /// The inactive side of the range selector is between the [min] value and
  /// the left thumb, and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the range selector is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive color in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   inactiveColor: Colors.red,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the individual
  /// inactive range selector element’s visual.
  final Color? inactiveColor;

  /// Color applied to the active track, thumb, overlay, and inactive dividers.
  ///
  /// The active side of the range selector is between the start and end thumbs.
  ///
  /// This snippet shows how to set active color in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   activeColor: Colors.red,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the individual active range selector element’s visual.
  final Color? activeColor;

  /// Option to place the labels either between the major ticks or
  /// on the major ticks.
  ///
  /// Defaults to [LabelPlacement.onTicks].
  ///
  /// This snippet shows how to set label placement in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(
  ///         DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSelector(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   labelPlacement: LabelPlacement.betweenTicks,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  final LabelPlacement labelPlacement;

  /// Position of the edge labels.
  ///
  /// The edge labels in an axis can be shifted inside
  /// the axis bounds or placed at the edges.
  ///
  /// Defaults to `EdgeLabelPlacement.auto`.
  ///
  /// Also refer [EdgeLabelPlacement].
  ///
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return  SfRangeSelector(
  ///        edgeLabelPlacement: EdgeLabelPlacement.inside,
  ///    );
  ///}
  ///```

  final EdgeLabelPlacement edgeLabelPlacement;

  /// Formats the numeric labels.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set number format in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   numberFormat: NumberFormat(‘\$’),
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  /// See also:
  ///
  /// * [labelFormatterCallback], for formatting the numeric and date labels.
  final NumberFormat? numberFormat;

  /// Formats the date labels. It is mandatory for date [SfRangeSelector].
  ///
  /// For date values, the range selector doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// dividers are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date format in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(
  ///       DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSelector(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [interval], for setting the interval.
  /// * [numberFormat], for formatting the numeric labels.
  /// * [labelFormatterCallback], for formatting the numeric and date label.
  /// * [dateIntervalType], for changing the interval type.
  final DateFormat? dateFormat;

  /// The type of date interval. It is mandatory for date [SfRangeSelector].
  ///
  /// It can be years to seconds.
  ///
  /// For date values, the range selector doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// dividers are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date interval type in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(
  ///       DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSelector(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  /// )
  /// ```
  final DateIntervalType? dateIntervalType;

  /// Signature for formatting or changing the whole numeric or date label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [initialValues] or
  /// controller start and end values.
  /// * The formatted value based on the numeric or date format
  /// is given by `formattedText`.
  ///
  /// This snippet shows how to set label format in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(100.0, 10000.0);
  ///
  /// SfRangeSelector(
  ///   min: 100.0,
  ///   max: 10000.0,
  ///   initialValues: _initialValues,
  ///   interval: 9000.0,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   labelFormatterCallback: (dynamic actualValue, String formattedText) {
  ///     return actualValue == 10000 ? '\$ $ formattedText +' : '\$ $ formattedText';
  ///   },
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///   ),
  /// )
  /// ```
  final LabelFormatterCallback? labelFormatterCallback;

  /// Signature for formatting or changing the whole tooltip label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [initialValues] or
  /// controller start and end values.
  /// * The formatted value based on the numeric or date format
  /// is given by `formattedText`.
  ///
  /// This snippet shows how to set tooltip format in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(
  ///           DateTime(2010, 01, 01, 13, 00, 00),
  ///           DateTime(2010, 01, 01, 17, 00, 00));
  ///
  /// SfRangeSelector(
  ///   min: DateTime(2010, 01, 01, 9, 00, 00),
  ///   max: DateTime(2010, 01, 01, 21, 05, 00),
  ///   initialValues: _initialValues,
  ///   interval: 4,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   dateFormat: DateFormat('h a'),
  ///   dateIntervalType: DateIntervalType.hours,
  ///   tooltipTextFormatterCallback:
  ///       (dynamic actualValue, String formattedText) {
  ///     return DateFormat('h:mm a').format(actualValue);
  ///   },
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///   ),
  /// )
  /// ```
  final TooltipTextFormatterCallback? tooltipTextFormatterCallback;

  /// The callback used to create a semantic value from the selector's values.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to
  /// inform users what the currently selected value is with more context.
  ///
  /// In the example below, a range selector for currency values is
  /// configured to announce a value with a currency label.
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(40.0, 60.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 100.0,
  ///   initialValues: _values,
  ///   interval: 20,
  ///   stepSize: 10,
  ///   semanticFormatterCallback: (dynamic value, SfThumb thumb) {
  ///     return 'The $thumb value is ${value}';
  ///   },
  ///  child: Container(
  ///    height: 150,
  ///    color: Colors.pink[200],
  ///  ),
  /// )
  /// ```
  final RangeSelectorSemanticFormatterCallback? semanticFormatterCallback;

  /// Base class for [SfRangeSelector] track shapes.
  final SfTrackShape trackShape;

  /// Base class for [SfRangeSelector] dividers shapes.
  final SfDividerShape dividerShape;

  /// Base class for [SfRangeSelector] overlay shapes.
  final SfOverlayShape overlayShape;

  ///  Base class for [SfRangeSelector] thumb shapes.
  final SfThumbShape thumbShape;

  /// Base class for [SfRangeSelector] major tick shapes.
  final SfTickShape tickShape;

  /// Base class for [SfRangeSelector] minor tick shapes.
  final SfTickShape minorTickShape;

  /// Renders rectangular or paddle shape tooltip.
  ///
  /// Defaults to [SfRectangularTooltipShape]
  ///
  ///```dart
  /// SfRangeValues _values = SfRangeValues(40.0, 60.0);
  ///
  /// SfRangeSelector(
  ///  min: 0.0,
  ///  max: 100.0,
  ///  initialValues: _values,
  ///  showLabels: true,
  ///  showTicks: true,
  ///  interval: 20,
  ///  enableTooltip: true,
  ///  tooltipShape: SfPaddleTooltipShape(),
  ///  child: Container(
  ///     height: 150,
  ///     color: Colors.pink[200],
  ///  ),
  /// )
  ///```
  final SfTooltipShape tooltipShape;

  /// The content of range selector.
  ///
  /// If it is not null, [SfRangeSelectorThemeData]'s
  /// [SfRangeSelectorThemeData.activeRegionColor] and
  /// [SfRangeSelectorThemeData.inactiveRegionColor] applied on the child.
  ///
  /// The active side of the range selector is between the left and right thumb.
  /// The inactive side of the range selector is between the
  /// [min] value and left thumb as well as right thumb and [max] value.
  ///
  /// For RTL, The active side of the range selector is
  /// between the left and right thumb.
  /// The inactive side of the range selector is between the
  /// [min] value and right thumb as well as left thumb and [max] value.
  final Widget child;

  /// Sets the widget inside the left thumb.
  ///
  /// Defaults to `null`.
  ///
  /// It is possible to set any widget inside the left thumb. If the widget
  /// exceeds the size of the thumb, increase the
  /// [SfSliderThemeData.thumbRadius] based on it.
  ///
  /// This snippet shows how to show start thumb icon in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  ///   startThumbIcon:  Icon(
  ///       Icons.home,
  ///       color: Colors.green,
  ///       size: 20.0,
  ///   ),
  /// )
  /// ```
  /// See also:
  ///
  /// * [thumbShape], for customizing the thumb shape.
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the individual active range selector element’s visual.
  final Widget? startThumbIcon;

  /// Sets the widget inside the right thumb.
  ///
  /// Defaults to `null`.
  ///
  /// It is possible to set any widget inside the right thumb. If the widget
  /// exceeds the size of the thumb, increase the
  /// [SfSliderThemeData.thumbRadius] based on it.
  ///
  /// This snippet shows how to show end thumb icon in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   child: Container(
  ///       height: 200,
  ///       color: Colors.green[100],
  ///    ),
  ///   endThumbIcon:  Icon(
  ///       Icons.home,
  ///       color: Colors.green,
  ///       size: 20.0,
  ///   ),
  /// )
  /// ```
  /// See also:
  ///
  /// * [thumbShape], for customizing the thumb shape.
  /// * [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html), for customizing the individual active range selector element’s visual.
  final Widget? endThumbIcon;

  @override
  State<SfRangeSelector> createState() => _SfRangeSelectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (initialValues != null) {
      properties.add(
        initialValues!.toDiagnosticsNode(name: 'initialValues'),
      );
    }
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    if (controller != null) {
      properties.add(
        controller!.toDiagnosticsNode(name: 'controller'),
      );
    }
    properties.add(FlagProperty('enabled',
        value: enabled,
        ifTrue: 'Range selector is enabled',
        ifFalse: 'Range selector is disabled'));
    properties.add(DoubleProperty('interval', interval));
    properties.add(DoubleProperty('stepSize', stepSize));
    if (stepDuration != null) {
      properties.add(stepDuration!.toDiagnosticsNode(name: 'stepDuration'));
    }

    properties.add(IntProperty('minorTicksPerInterval', minorTicksPerInterval));
    properties.add(FlagProperty('showTicks',
        value: showTicks,
        ifTrue: 'Ticks are showing',
        ifFalse: 'Ticks are not showing'));
    properties.add(FlagProperty('showLabels',
        value: showLabels,
        ifTrue: 'Labels are showing',
        ifFalse: 'Labels are not showing'));
    properties.add(FlagProperty('showDividers',
        value: showDividers,
        ifTrue: 'Dividers are  showing',
        ifFalse: 'Dividers are not showing'));
    if (shouldAlwaysShowTooltip) {
      properties.add(FlagProperty('shouldAlwaysShowTooltip',
          value: shouldAlwaysShowTooltip, ifTrue: 'Tooltip is always visible'));
    } else {
      properties.add(FlagProperty('enableTooltip',
          value: enableTooltip,
          ifTrue: 'Tooltip is enabled',
          ifFalse: 'Tooltip is disabled'));
    }
    properties.add(FlagProperty('enableIntervalSelection',
        value: enableIntervalSelection,
        ifTrue: 'Interval selection is enabled',
        ifFalse: 'Interval selection is disabled'));
    properties.add(FlagProperty('enableDeferredUpdate',
        value: enableDeferredUpdate,
        ifTrue: 'Deferred update is enabled',
        ifFalse: 'Deferred update is disabled'));
    properties.add(EnumProperty<SliderDragMode>('dragMode', dragMode));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties.add(EnumProperty<EdgeLabelPlacement>(
        'edgeLabelPlacement', edgeLabelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (initialValues != null &&
        initialValues!.start.runtimeType == DateTime &&
        dateFormat != null) {
      properties.add(StringProperty('dateFormat',
          'Formatted value is ${dateFormat!.format(initialValues!.start)}'));
    }

    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChanged', onChanged));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChangeEnd', onChangeEnd));
    properties.add(
        EnumProperty<DateIntervalType>('dateIntervalType', dateIntervalType));
    properties.add(ObjectFlagProperty<TooltipTextFormatterCallback>.has(
        'tooltipTextFormatterCallback', tooltipTextFormatterCallback));
    properties.add(ObjectFlagProperty<LabelFormatterCallback>.has(
        'labelFormatterCallback', labelFormatterCallback));
    properties.add(
        ObjectFlagProperty<RangeSelectorSemanticFormatterCallback>.has(
            'semanticFormatterCallback', semanticFormatterCallback));
  }
}

class _SfRangeSelectorState extends State<SfRangeSelector>
    with TickerProviderStateMixin {
  late AnimationController overlayStartController;
  late AnimationController overlayEndController;
  late AnimationController startPositionController;
  late AnimationController endPositionController;
  late AnimationController stateController;
  late AnimationController tooltipAnimationStartController;
  late AnimationController tooltipAnimationEndController;
  final Duration duration = const Duration(milliseconds: 100);
  SfRangeValues? _values;

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  SfRangeSelectorThemeData _getRangeSelectorThemeData(ThemeData themeData) {
    SfRangeSelectorThemeData rangeSelectorThemeData =
        SfRangeSelectorTheme.of(context)!;
    final bool isMaterial3 = themeData.useMaterial3;
    final SfRangeSelectorThemeData effectiveThemeData =
        RangeSelectorThemeData(context);
    final Color labelColor = isMaterial3
        ? themeData.colorScheme.onSurfaceVariant
        : widget.enabled
            ? themeData.textTheme.bodyLarge!.color!.withOpacity(0.87)
            : themeData.colorScheme.onSurface.withOpacity(0.32);
    final double minTrackHeight = math.min(
        rangeSelectorThemeData.activeTrackHeight,
        rangeSelectorThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        rangeSelectorThemeData.activeTrackHeight,
        rangeSelectorThemeData.inactiveTrackHeight);
    rangeSelectorThemeData = rangeSelectorThemeData.copyWith(
      activeTrackHeight: rangeSelectorThemeData.activeTrackHeight,
      inactiveTrackHeight: rangeSelectorThemeData.inactiveTrackHeight,
      tickSize: rangeSelectorThemeData.tickSize,
      minorTickSize: rangeSelectorThemeData.minorTickSize,
      tickOffset: rangeSelectorThemeData.tickOffset,
      labelOffset: rangeSelectorThemeData.labelOffset ??
          (widget.showTicks ? const Offset(0.0, 5.0) : const Offset(0.0, 13.0)),
      inactiveLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(rangeSelectorThemeData.inactiveLabelStyle),
      activeLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(rangeSelectorThemeData.activeLabelStyle),
      tooltipTextStyle: themeData.textTheme.bodyLarge!
          .copyWith(
              fontSize: isMaterial3 ? 12 : 14,
              color: isMaterial3
                  ? themeData.colorScheme.onPrimary
                  : themeData.colorScheme.surface)
          .merge(rangeSelectorThemeData.tooltipTextStyle),
      inactiveTrackColor: widget.inactiveColor ??
          rangeSelectorThemeData.inactiveTrackColor ??
          effectiveThemeData.inactiveTrackColor,
      activeTrackColor: widget.activeColor ??
          rangeSelectorThemeData.activeTrackColor ??
          effectiveThemeData.activeTrackColor,
      thumbColor: widget.activeColor ??
          rangeSelectorThemeData.thumbColor ??
          effectiveThemeData.thumbColor,
      activeTickColor: rangeSelectorThemeData.activeTickColor ??
          effectiveThemeData.activeTickColor,
      inactiveTickColor: rangeSelectorThemeData.inactiveTickColor ??
          effectiveThemeData.inactiveTickColor,
      disabledActiveTickColor: rangeSelectorThemeData.disabledActiveTickColor ??
          effectiveThemeData.disabledActiveTickColor,
      disabledInactiveTickColor:
          rangeSelectorThemeData.disabledInactiveTickColor ??
              effectiveThemeData.disabledInactiveTickColor,
      activeMinorTickColor: rangeSelectorThemeData.activeMinorTickColor ??
          effectiveThemeData.activeMinorTickColor,
      inactiveMinorTickColor: rangeSelectorThemeData.inactiveMinorTickColor ??
          effectiveThemeData.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          rangeSelectorThemeData.disabledActiveMinorTickColor ??
              effectiveThemeData.disabledActiveMinorTickColor,
      // ignore: lines_longer_than_80_chars
      disabledInactiveMinorTickColor:
          rangeSelectorThemeData.disabledInactiveMinorTickColor ??
              effectiveThemeData.disabledInactiveMinorTickColor,
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          rangeSelectorThemeData.overlayColor ??
          effectiveThemeData.overlayColor,
      inactiveDividerColor: widget.activeColor ??
          rangeSelectorThemeData.inactiveDividerColor ??
          effectiveThemeData.inactiveDividerColor,
      activeDividerColor: widget.inactiveColor ??
          rangeSelectorThemeData.activeDividerColor ??
          effectiveThemeData.activeDividerColor,
      disabledInactiveDividerColor:
          rangeSelectorThemeData.disabledInactiveDividerColor ??
              effectiveThemeData.disabledInactiveDividerColor,
      disabledActiveDividerColor:
          rangeSelectorThemeData.disabledActiveDividerColor ??
              effectiveThemeData.disabledActiveDividerColor,
      disabledActiveTrackColor:
          rangeSelectorThemeData.disabledActiveTrackColor ??
              effectiveThemeData.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          rangeSelectorThemeData.disabledInactiveTrackColor ??
              effectiveThemeData.disabledInactiveTrackColor,
      disabledThumbColor: rangeSelectorThemeData.disabledThumbColor ??
          effectiveThemeData.disabledThumbColor,
      thumbStrokeColor: rangeSelectorThemeData.thumbStrokeColor,
      overlappingThumbStrokeColor:
          rangeSelectorThemeData.overlappingThumbStrokeColor ??
              themeData.colorScheme.surface,
      activeDividerStrokeColor: rangeSelectorThemeData.activeDividerStrokeColor,
      inactiveDividerStrokeColor:
          rangeSelectorThemeData.inactiveDividerStrokeColor,
      overlappingTooltipStrokeColor:
          rangeSelectorThemeData.overlappingTooltipStrokeColor ??
              themeData.colorScheme.surface,
      activeRegionColor: rangeSelectorThemeData.activeRegionColor ??
          effectiveThemeData.activeRegionColor,
      inactiveRegionColor: widget.inactiveColor ??
          rangeSelectorThemeData.inactiveRegionColor ??
          effectiveThemeData.inactiveRegionColor,
      tooltipBackgroundColor: rangeSelectorThemeData.tooltipBackgroundColor ??
          effectiveThemeData.tooltipBackgroundColor,
      trackCornerRadius:
          rangeSelectorThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: rangeSelectorThemeData.thumbRadius,
      overlayRadius: rangeSelectorThemeData.overlayRadius,
      activeDividerRadius:
          rangeSelectorThemeData.activeDividerRadius ?? minTrackHeight / 4,
      inactiveDividerRadius:
          rangeSelectorThemeData.inactiveDividerRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: rangeSelectorThemeData.thumbStrokeWidth,
      activeDividerStrokeWidth: rangeSelectorThemeData.activeDividerStrokeWidth,
      inactiveDividerStrokeWidth:
          rangeSelectorThemeData.inactiveDividerStrokeWidth,
    );

    return rangeSelectorThemeData;
  }

  void _onChangeStart(SfRangeValues values) {
    if (widget.onChangeStart != null && widget.enabled) {
      widget.onChangeStart!(values);
    }
  }

  void _onChangeEnd(SfRangeValues values) {
    if (widget.onChangeEnd != null && widget.enabled) {
      widget.onChangeEnd!(values);
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      assert(widget.controller!.start != null);
      assert(widget.controller!.end != null);
      _values = SfRangeValues(widget.controller!.start, widget.controller!.end);
    }

    overlayStartController =
        AnimationController(vsync: this, duration: duration);
    overlayEndController = AnimationController(vsync: this, duration: duration);
    stateController = AnimationController(vsync: this, duration: duration);
    startPositionController =
        AnimationController(duration: Duration.zero, vsync: this);
    endPositionController =
        AnimationController(duration: Duration.zero, vsync: this);
    tooltipAnimationStartController =
        AnimationController(vsync: this, duration: duration);
    tooltipAnimationEndController =
        AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.enabled && (widget.min != widget.max) ? 1.0 : 0.0;
    super.initState();
  }

  @override
  void didUpdateWidget(SfRangeSelector oldWidget) {
    if (oldWidget.shouldAlwaysShowTooltip != widget.shouldAlwaysShowTooltip) {
      if (widget.shouldAlwaysShowTooltip) {
        tooltipAnimationStartController.value = 1;
        tooltipAnimationEndController.value = 1;
      } else {
        tooltipAnimationStartController.value = 0;
        tooltipAnimationEndController.value = 0;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    overlayStartController.dispose();
    overlayEndController.dispose();
    startPositionController.dispose();
    endPositionController.dispose();
    tooltipAnimationStartController.dispose();
    tooltipAnimationEndController.dispose();
    stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return _RangeSelectorRenderObjectWidget(
      key: widget.key,
      min: widget.min,
      max: widget.max,
      values: _values ?? widget.initialValues,
      onChangeStart: widget.onChangeStart != null ? _onChangeStart : null,
      onChangeEnd: widget.onChangeEnd != null ? _onChangeEnd : null,
      enabled: widget.enabled && widget.min != widget.max,
      interval: widget.interval,
      stepSize: widget.stepSize,
      stepDuration: widget.stepDuration,
      deferUpdateDelay: widget.deferredUpdateDelay,
      minorTicksPerInterval: widget.minorTicksPerInterval,
      showTicks: widget.showTicks,
      showLabels: widget.showLabels,
      showDividers: widget.showDividers,
      enableTooltip: widget.enableTooltip,
      shouldAlwaysShowTooltip: widget.shouldAlwaysShowTooltip,
      enableIntervalSelection: widget.enableIntervalSelection,
      deferUpdate: widget.enableDeferredUpdate,
      dragMode: widget.dragMode,
      inactiveColor:
          widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
      activeColor: widget.activeColor ?? themeData.primaryColor,
      labelPlacement: widget.labelPlacement,
      edgeLabelPlacement: widget.edgeLabelPlacement,
      numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
      dateFormat: widget.dateFormat,
      dateIntervalType: widget.dateIntervalType,
      labelFormatterCallback:
          widget.labelFormatterCallback ?? _getFormattedLabelText,
      tooltipTextFormatterCallback:
          widget.tooltipTextFormatterCallback ?? _getFormattedTooltipText,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      trackShape: widget.trackShape,
      dividerShape: widget.dividerShape,
      overlayShape: widget.overlayShape,
      thumbShape: widget.thumbShape,
      tickShape: widget.tickShape,
      minorTickShape: widget.minorTickShape,
      tooltipShape: widget.tooltipShape,
      rangeSelectorThemeData: _getRangeSelectorThemeData(themeData),
      startThumbIcon: widget.startThumbIcon,
      endThumbIcon: widget.endThumbIcon,
      state: this,
      child: widget.child,
    );
  }
}

class _RangeSelectorRenderObjectWidget extends RenderObjectWidget {
  const _RangeSelectorRenderObjectWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.values,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.enabled,
    required this.interval,
    required this.stepSize,
    required this.stepDuration,
    required this.deferUpdateDelay,
    required this.minorTicksPerInterval,
    required this.showTicks,
    required this.showLabels,
    required this.showDividers,
    required this.enableTooltip,
    required this.shouldAlwaysShowTooltip,
    required this.enableIntervalSelection,
    required this.deferUpdate,
    required this.dragMode,
    required this.inactiveColor,
    required this.activeColor,
    required this.labelPlacement,
    required this.edgeLabelPlacement,
    required this.numberFormat,
    required this.dateFormat,
    required this.dateIntervalType,
    required this.labelFormatterCallback,
    required this.tooltipTextFormatterCallback,
    required this.semanticFormatterCallback,
    required this.trackShape,
    required this.dividerShape,
    required this.overlayShape,
    required this.thumbShape,
    required this.tickShape,
    required this.minorTickShape,
    required this.tooltipShape,
    required this.child,
    required this.rangeSelectorThemeData,
    required this.startThumbIcon,
    required this.endThumbIcon,
    required this.state,
  }) : super(key: key);

  final dynamic min;
  final dynamic max;
  final SfRangeValues? values;
  final ValueChanged<SfRangeValues>? onChangeStart;
  final ValueChanged<SfRangeValues>? onChangeEnd;
  final bool enabled;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
  final int deferUpdateDelay;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDividers;
  final bool enableTooltip;
  final bool enableIntervalSelection;
  final bool deferUpdate;
  final bool shouldAlwaysShowTooltip;
  final SliderDragMode dragMode;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final EdgeLabelPlacement edgeLabelPlacement;
  final NumberFormat numberFormat;
  final DateFormat? dateFormat;
  final DateIntervalType? dateIntervalType;
  final SfRangeSelectorThemeData rangeSelectorThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final RangeSelectorSemanticFormatterCallback? semanticFormatterCallback;
  final SfTrackShape trackShape;
  final SfDividerShape dividerShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfTooltipShape tooltipShape;
  final Widget child;
  final Widget? startThumbIcon;
  final Widget? endThumbIcon;
  final _SfRangeSelectorState state;

  @override
  _RenderRangeSelectorElement createElement() =>
      _RenderRangeSelectorElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderRangeSelector(
      min: min,
      max: max,
      values: values,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      enabled: enabled,
      interval: interval,
      stepSize: stepSize,
      stepDuration: stepDuration,
      deferUpdateDelay: deferUpdateDelay,
      minorTicksPerInterval: minorTicksPerInterval,
      showTicks: showTicks,
      showLabels: showLabels,
      showDividers: showDividers,
      enableTooltip: enableTooltip,
      shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
      isInversed: Directionality.of(context) == TextDirection.rtl,
      enableIntervalSelection: enableIntervalSelection,
      deferUpdate: deferUpdate,
      dragMode: dragMode,
      labelPlacement: labelPlacement,
      edgeLabelPlacement: edgeLabelPlacement,
      numberFormat: numberFormat,
      dateFormat: dateFormat,
      dateIntervalType: dateIntervalType,
      labelFormatterCallback: labelFormatterCallback,
      tooltipTextFormatterCallback: tooltipTextFormatterCallback,
      semanticFormatterCallback: semanticFormatterCallback,
      trackShape: trackShape,
      dividerShape: dividerShape,
      overlayShape: overlayShape,
      thumbShape: thumbShape,
      tickShape: tickShape,
      minorTickShape: minorTickShape,
      tooltipShape: tooltipShape,
      rangeSelectorThemeData: rangeSelectorThemeData,
      textDirection: Directionality.of(context),
      mediaQueryData: MediaQuery.of(context),
      state: state,
      gestureSettings: MediaQuery.of(context).gestureSettings,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderRangeSelector renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..isInteractive = enabled
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..deferUpdateDelay = deferUpdateDelay
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDividers = showDividers
      ..enableTooltip = enableTooltip
      ..shouldAlwaysShowTooltip = shouldAlwaysShowTooltip
      ..isInversed = Directionality.of(context) == TextDirection.rtl
      ..enableIntervalSelection = enableIntervalSelection
      ..deferUpdate = deferUpdate
      ..dragMode = dragMode
      ..labelPlacement = labelPlacement
      ..edgeLabelPlacement = edgeLabelPlacement
      ..numberFormat = numberFormat
      ..dateFormat = dateFormat
      ..dateIntervalType = dateIntervalType
      ..labelFormatterCallback = labelFormatterCallback
      ..tooltipTextFormatterCallback = tooltipTextFormatterCallback
      ..semanticFormatterCallback = semanticFormatterCallback
      ..trackShape = trackShape
      ..dividerShape = dividerShape
      ..overlayShape = overlayShape
      ..thumbShape = thumbShape
      ..tickShape = tickShape
      ..minorTickShape = minorTickShape
      ..tooltipShape = tooltipShape
      ..sliderThemeData = rangeSelectorThemeData
      ..textDirection = Directionality.of(context)
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderRangeSelectorElement extends RenderObjectElement {
  _RenderRangeSelectorElement(_RangeSelectorRenderObjectWidget rangeSelector)
      : super(rangeSelector);

  final Map<ChildElements, Element> _slotToChild = <ChildElements, Element>{};
  final Map<Element, ChildElements> _childToSlot = <Element, ChildElements>{};

  @override
  _RangeSelectorRenderObjectWidget get widget =>
      // ignore: avoid_as
      super.widget as _RangeSelectorRenderObjectWidget;

  @override
  _RenderRangeSelector get renderObject =>
      // ignore: avoid_as
      super.renderObject as _RenderRangeSelector;

  void _updateChild(Widget? widget, ChildElements slot) {
    final Element? oldChild = _slotToChild[slot];
    final Element? newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      _childToSlot.remove(oldChild);
      _slotToChild.remove(slot);
    }
    if (newChild != null) {
      _slotToChild[slot] = newChild;
      _childToSlot[newChild] = slot;
    }
  }

  void _updateRenderObject(RenderObject? child, ChildElements slot) {
    switch (slot) {
      case ChildElements.startThumbIcon:
        // ignore: avoid_as
        renderObject.startThumbIcon = child as RenderBox?;
        break;
      case ChildElements.endThumbIcon:
        // ignore: avoid_as
        renderObject.endThumbIcon = child as RenderBox?;
        break;
      case ChildElements.child:
        // ignore: avoid_as
        renderObject.child = child as RenderBox?;
        break;
    }
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _slotToChild.values.forEach(visitor);
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _updateChild(widget.startThumbIcon, ChildElements.startThumbIcon);
    _updateChild(widget.endThumbIcon, ChildElements.endThumbIcon);
    _updateChild(widget.child, ChildElements.child);
  }

  @override
  void update(_RangeSelectorRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.startThumbIcon, ChildElements.startThumbIcon);
    _updateChild(widget.endThumbIcon, ChildElements.endThumbIcon);
    _updateChild(widget.child, ChildElements.child);
  }

  @override
  void insertRenderObjectChild(RenderObject child, dynamic slotValue) {
    assert(child is RenderBox);
    assert(slotValue is ChildElements);
    // ignore: avoid_as
    final ChildElements slot = slotValue as ChildElements;
    _updateRenderObject(child, slot);
    assert(renderObject.childToSlot.keys.contains(child));
    assert(renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void removeRenderObjectChild(RenderObject child, ChildElements slot) {
    assert(child is RenderBox);
    assert(renderObject.childToSlot.keys.contains(child));
    _updateRenderObject(null, renderObject.childToSlot[child]!);
    assert(!renderObject.childToSlot.keys.contains(child));
    assert(!renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false, 'not reachable');
  }
}

class _RenderRangeSelector extends RenderBaseRangeSlider {
  _RenderRangeSelector({
    required dynamic min,
    required dynamic max,
    required SfRangeValues? values,
    required ValueChanged<SfRangeValues>? onChangeStart,
    required ValueChanged<SfRangeValues>? onChangeEnd,
    required bool enabled,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int deferUpdateDelay,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool shouldAlwaysShowTooltip,
    required bool isInversed,
    required bool enableIntervalSelection,
    required bool deferUpdate,
    required SliderDragMode dragMode,
    required LabelPlacement labelPlacement,
    required EdgeLabelPlacement edgeLabelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required RangeSelectorSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDividerShape dividerShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfRangeSelectorThemeData rangeSelectorThemeData,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
    required _SfRangeSelectorState state,
    required DeviceGestureSettings gestureSettings,
  })  : _state = state,
        _isEnabled = enabled,
        _deferUpdateDelay = deferUpdateDelay,
        _deferUpdate = deferUpdate,
        _semanticFormatterCallback = semanticFormatterCallback,
        super(
            min: min,
            max: max,
            values: values,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            interval: interval,
            stepSize: stepSize,
            stepDuration: stepDuration,
            minorTicksPerInterval: minorTicksPerInterval,
            showTicks: showTicks,
            showLabels: showLabels,
            showDividers: showDividers,
            enableTooltip: enableTooltip,
            shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
            isInversed: isInversed,
            enableIntervalSelection: enableIntervalSelection,
            dragMode: dragMode,
            labelPlacement: labelPlacement,
            edgeLabelPlacement: edgeLabelPlacement,
            numberFormat: numberFormat,
            dateFormat: dateFormat,
            dateIntervalType: dateIntervalType,
            labelFormatterCallback: labelFormatterCallback,
            tooltipTextFormatterCallback: tooltipTextFormatterCallback,
            trackShape: trackShape,
            dividerShape: dividerShape,
            overlayShape: overlayShape,
            thumbShape: thumbShape,
            tickShape: tickShape,
            minorTickShape: minorTickShape,
            tooltipShape: tooltipShape,
            sliderThemeData: rangeSelectorThemeData,
            sliderType: SliderType.horizontal,
            tooltipPosition: null,
            textDirection: textDirection,
            mediaQueryData: mediaQueryData,
            gestureSettings: gestureSettings) {
    _inactiveRegionColor = rangeSelectorThemeData.inactiveRegionColor!;
    _activeRegionColor = rangeSelectorThemeData.activeRegionColor!;
  }

  final _SfRangeSelectorState _state;
  late Color _inactiveRegionColor;
  late Color _activeRegionColor;
  Timer? _deferUpdateTimer;

  @override
  bool get isInteractive => _isEnabled;
  bool _isEnabled;
  set isInteractive(bool value) {
    if (_isEnabled == value) {
      return;
    }
    final bool wasEnabled = isInteractive;
    _isEnabled = value;
    if (wasEnabled != isInteractive) {
      if (isInteractive) {
        _state.stateController.forward();
      } else {
        _state.stateController.reverse();
      }
    }
    markNeedsLayout();
  }

  int get deferUpdateDelay => _deferUpdateDelay;
  int _deferUpdateDelay;
  set deferUpdateDelay(int value) {
    if (_deferUpdateDelay == value) {
      return;
    }
    _deferUpdateDelay = value;
  }

  bool get deferUpdate => _deferUpdate;
  late bool _deferUpdate;
  set deferUpdate(bool value) {
    if (_deferUpdate == value) {
      return;
    }
    _deferUpdate = value;
  }

  RangeSelectorSemanticFormatterCallback? get semanticFormatterCallback =>
      _semanticFormatterCallback;
  RangeSelectorSemanticFormatterCallback? _semanticFormatterCallback;
  set semanticFormatterCallback(RangeSelectorSemanticFormatterCallback? value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  @override
  set sliderThemeData(SfSliderThemeData value) {
    if (super.sliderThemeData == value) {
      return;
    }
    super.sliderThemeData = value;
    maxTrackHeight = getMaxTrackHeight();

    if (value is SfRangeSelectorThemeData) {
      _inactiveRegionColor = value.inactiveRegionColor!;
      _activeRegionColor = value.activeRegionColor!;
    }
    markNeedsPaint();
  }

  @override
  bool get mounted => _state.mounted;

  @override
  AnimationController get overlayStartController =>
      _state.overlayStartController;

  @override
  AnimationController get overlayEndController => _state.overlayEndController;

  @override
  AnimationController get stateController => _state.stateController;

  @override
  AnimationController get startPositionController =>
      _state.startPositionController;

  @override
  AnimationController get endPositionController => _state.endPositionController;

  @override
  AnimationController get tooltipAnimationStartController =>
      _state.tooltipAnimationStartController;

  @override
  AnimationController get tooltipAnimationEndController =>
      _state.tooltipAnimationEndController;

  @override
  RenderBox? get child => _child;
  RenderBox? _child;

  @override
  set child(RenderBox? value) {
    _child = updateChild(_child, value, ChildElements.child);
  }

  Iterable<RenderBox> get children sync* {
    if (startThumbIcon != null) {
      yield startThumbIcon!;
    }
    if (endThumbIcon != null) {
      yield endThumbIcon!;
    }
    if (child != null) {
      yield child!;
    }
  }

  double get elementsActualHeight => math.max(
      2 * trackOffset.dy,
      trackOffset.dy +
          maxTrackHeight / 2 +
          math.max(actualTickHeight, actualMinorTickHeight) +
          actualLabelHeight);

  // When the active track height and inactive track height are different,
  // a small gap is happens between min track height and child
  // So we adjust track offset to ignore that gap.
  double get adjustTrackY => sliderThemeData.activeTrackHeight >
          sliderThemeData.inactiveTrackHeight
      ? sliderThemeData.activeTrackHeight - sliderThemeData.inactiveTrackHeight
      : sliderThemeData.inactiveTrackHeight - sliderThemeData.activeTrackHeight;

  void _updateNewValues(SfRangeValues newValues) {
    if (_state.widget.onChanged != null) {
      _state.widget.onChanged!(newValues);
    }
    if (_state.widget.controller != null) {
      _state.widget.controller!.start = newValues.start;
      _state.widget.controller!.end = newValues.end;
    } else if (!_deferUpdate) {
      values = newValues;
      markNeedsPaint();
    }
  }

  void _handleRangeControllerChange() {
    if (_state.mounted &&
        _state.widget.controller != null &&
        (values.start != _state.widget.controller!.start ||
            values.end != _state.widget.controller!.end)) {
      values = SfRangeValues(
          getActualValue(value: _state.widget.controller!.start),
          getActualValue(value: _state.widget.controller!.end));

      markNeedsPaint();
    }
  }

  @override
  void updateValues(SfRangeValues newValues) {
    if (_isEnabled && !isIntervalTapped) {
      if (newValues.start != values.start || newValues.end != values.end) {
        if (_deferUpdate) {
          _deferUpdateTimer?.cancel();
          _deferUpdateTimer =
              Timer(Duration(milliseconds: _deferUpdateDelay), () {
            _updateNewValues(newValues);
          });
          values = newValues;
          markNeedsPaint();
        } else {
          _updateNewValues(newValues);
        }
      }
    }
    super.updateValues(newValues);
  }

  @override
  void updateIntervalTappedAndDeferredUpdateValues(SfRangeValues newValues) {
    if (isIntervalTapped) {
      _updateNewValues(newValues);
    }
    // Default, we only update new values when dragging.
    // If [deferUpdate] is enabled, new values are updated with
    // [deferUpdateDelay].
    // But touch up is handled before the [deferUpdateDelay] timer,
    // we have to invoke [onChanged] call back with new values and
    // update the new values to the [controller] immediately.
    if (_deferUpdate) {
      _deferUpdateTimer?.cancel();
      _updateNewValues(newValues);
    }
  }

  void _drawRegions(PaintingContext context, Rect trackRect, Offset offset,
      Offset startThumbCenter, Offset endThumbCenter) {
    final Paint inactivePaint = Paint()
      ..isAntiAlias = true
      ..color = _inactiveRegionColor;
    if (child != null && child!.size.height > 1 && child!.size.width > 1) {
      final double halfActiveTrackHeight =
          sliderThemeData.activeTrackHeight / 2;
      final double halfInactiveTrackHeight =
          sliderThemeData.inactiveTrackHeight / 2;
      final bool isMaxActive = sliderThemeData.activeTrackHeight >
          sliderThemeData.inactiveTrackHeight;
      Offset leftThumbCenter;
      Offset rightThumbCenter;
      if (textDirection == TextDirection.rtl) {
        leftThumbCenter = endThumbCenter;
        rightThumbCenter = startThumbCenter;
      } else {
        leftThumbCenter = startThumbCenter;
        rightThumbCenter = endThumbCenter;
      }

      //Below values are used to fit active and inactive region into the track.
      final double inactiveRegionAdj =
          isMaxActive ? halfActiveTrackHeight - halfInactiveTrackHeight : 0;
      final double activeRegionAdj =
          !isMaxActive ? halfInactiveTrackHeight - halfActiveTrackHeight : 0;
      context.canvas.drawRect(
          Rect.fromLTRB(trackRect.left, offset.dy, leftThumbCenter.dx,
              trackRect.top + inactiveRegionAdj),
          inactivePaint);
      final Paint activePaint = Paint()
        ..isAntiAlias = true
        ..color = _activeRegionColor;
      context.canvas.drawRect(
          Rect.fromLTRB(leftThumbCenter.dx, offset.dy, rightThumbCenter.dx,
              trackRect.top + activeRegionAdj),
          activePaint);
      context.canvas.drawRect(
          Rect.fromLTRB(rightThumbCenter.dx, offset.dy, trackRect.right,
              trackRect.top + inactiveRegionAdj),
          inactivePaint);
    }
  }

  void _increaseStartAction() {
    if (isInteractive) {
      final SfRangeValues newValues =
          SfRangeValues(increasedStartValue, values.end);
      if (getNumerizedValue(newValues.start) <=
          getNumerizedValue(newValues.end)) {
        _updateNewValues(newValues);
      }
    }
  }

  void _decreaseStartAction() {
    if (isInteractive) {
      _updateNewValues(SfRangeValues(decreasedStartValue, values.end));
    }
  }

  void _increaseEndAction() {
    if (isInteractive) {
      _updateNewValues(SfRangeValues(values.start, increasedEndValue));
    }
  }

  void _decreaseEndAction() {
    if (isInteractive) {
      final SfRangeValues newValues =
          SfRangeValues(values.start, decreasedEndValue);
      if (getNumerizedValue(newValues.start) <=
          (getNumerizedValue(newValues.end))) {
        _updateNewValues(newValues);
      }
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    if (_state.widget.controller != null) {
      _state.widget.controller!.addListener(_handleRangeControllerChange);
    }
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    _deferUpdateTimer?.cancel();
    if (_state.widget.controller != null) {
      _state.widget.controller!.removeListener(_handleRangeControllerChange);
    }
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  void performLayout() {
    double childHeight = 0.0;
    double childWidth = 0.0;
    final double minTrackHeight = math.min(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    final Offset trackCenterLeft = trackOffset;
    final double elementsHeightWithoutChild = elementsActualHeight;

    double elementsHeightAfterRenderedChild = math.max(
        trackCenterLeft.dy + minTrackHeight / 2,
        maxTrackHeight / 2 +
            minTrackHeight / 2 +
            math.max(actualTickHeight, actualMinorTickHeight) +
            actualLabelHeight);

    if (constraints.maxHeight < elementsHeightWithoutChild) {
      final double actualChildHeight =
          elementsHeightWithoutChild - elementsHeightAfterRenderedChild;
      final double spaceLeftInActualLayoutHeight =
          elementsHeightAfterRenderedChild - constraints.maxHeight;
      // Reduce the [elementsHeightAfterRenderedChild] from the
      // actual child height and remaining space in actual layout height to
      // match the given constraints height.
      elementsHeightAfterRenderedChild = elementsHeightAfterRenderedChild -
          spaceLeftInActualLayoutHeight -
          actualChildHeight;
    }

    if (child != null) {
      final double maxRadius = trackOffset.dx;
      final BoxConstraints childConstraints = constraints.deflate(
          EdgeInsets.only(
              left: maxRadius,
              right: maxRadius,
              bottom: elementsHeightAfterRenderedChild));
      child!.layout(childConstraints, parentUsesSize: true);
      // ignore: avoid_as
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset(maxRadius, 0);
      childHeight = child!.size.height;
      childWidth = child!.size.width;
    }

    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: actualThumbSize.width, height: actualThumbSize.height);
    startThumbIcon?.layout(contentConstraints, parentUsesSize: true);
    endThumbIcon?.layout(contentConstraints, parentUsesSize: true);

    final double actualWidth = childWidth > 0.0
        ? (childWidth + 2 * trackOffset.dx)
        : minTrackWidth + 2 * trackOffset.dx;

    final double actualHeight = childHeight + elementsHeightAfterRenderedChild;
    size = Size(
        constraints.hasBoundedWidth && (constraints.maxWidth < actualWidth)
            ? constraints.maxWidth
            : actualWidth,
        constraints.hasBoundedHeight && (constraints.maxHeight < actualHeight)
            ? constraints.maxHeight
            : actualHeight);

    generateLabelsAndMajorTicks();
    generateMinorTicks();
  }

  @override
  void drawRegions(PaintingContext context, Rect trackRect, Offset offset,
      Offset startThumbCenter, Offset endThumbCenter) {
    _drawRegions(context, trackRect, offset, startThumbCenter, endThumbCenter);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double childHeight = 0.0;
    if (child != null) {
      // ignore: avoid_as
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      context.paintChild(child!, childParentData.offset + offset);
      childHeight = child!.size.height;
      if (childHeight >= constraints.maxHeight) {
        childHeight -= elementsActualHeight -
            math.max(actualOverlaySize.height, actualThumbSize.height) / 2;
      }
    }

    final Offset actualTrackOffset = Offset(
        offset.dx,
        offset.dy +
            math.max(childHeight - adjustTrackY / 2,
                trackOffset.dy - maxTrackHeight / 2));

    drawRangeSliderElements(context, offset, actualTrackOffset);
  }

  // Create the semantics configuration for a single value.
  SemanticsConfiguration _createSemanticsConfiguration(
    dynamic value,
    dynamic increasedValue,
    dynamic decreasedValue,
    SfThumb thumb,
    VoidCallback increaseAction,
    VoidCallback decreaseAction,
  ) {
    final SemanticsConfiguration config = SemanticsConfiguration();
    config.isEnabled = isInteractive;
    config.textDirection = textDirection;
    if (isInteractive) {
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
    }

    if (semanticFormatterCallback != null) {
      config.value = semanticFormatterCallback!(value, thumb);
      config.increasedValue = semanticFormatterCallback!(increasedValue, thumb);
      config.decreasedValue = semanticFormatterCallback!(decreasedValue, thumb);
    } else {
      final String thumbValue = thumb.toString().split('.').last;
      config.value = 'the $thumbValue value is $value';
      config.increasedValue = 'the $thumbValue  value is $increasedValue';
      config.decreasedValue = 'the $thumbValue  value is $decreasedValue';
    }
    return config;
  }

  @override
  void assembleSemanticsNode(
    SemanticsNode node,
    SemanticsConfiguration config,
    Iterable<SemanticsNode> children,
  ) {
    assert(children.isEmpty);
    final SemanticsConfiguration startSemanticsConfiguration =
        _createSemanticsConfiguration(
      values.start,
      increasedStartValue,
      decreasedStartValue,
      SfThumb.start,
      _increaseStartAction,
      _decreaseStartAction,
    );
    final SemanticsConfiguration endSemanticsConfiguration =
        _createSemanticsConfiguration(
      values.end,
      increasedEndValue,
      decreasedEndValue,
      SfThumb.end,
      _increaseEndAction,
      _decreaseEndAction,
    );
    // Split the semantics node area between the start and end nodes.
    final Rect leftRect =
        Rect.fromPoints(node.rect.topLeft, node.rect.bottomCenter);
    final Rect rightRect =
        Rect.fromPoints(node.rect.topCenter, node.rect.bottomRight);
    startSemanticsNode ??= SemanticsNode();
    endSemanticsNode ??= SemanticsNode();
    switch (textDirection) {
      case TextDirection.ltr:
        startSemanticsNode!.rect = leftRect;
        endSemanticsNode!.rect = rightRect;
        break;
      case TextDirection.rtl:
        startSemanticsNode!.rect = rightRect;
        endSemanticsNode!.rect = leftRect;
        break;
    }

    startSemanticsNode!.updateWith(config: startSemanticsConfiguration);
    endSemanticsNode!.updateWith(config: endSemanticsConfiguration);

    final List<SemanticsNode> finalChildren = <SemanticsNode>[
      startSemanticsNode!,
      endSemanticsNode!,
    ];

    node.updateWith(config: config, childrenInInversePaintOrder: finalChildren);
  }

  @override
  void clearSemantics() {
    super.clearSemantics();
    startSemanticsNode = null;
    endSemanticsNode = null;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = isInteractive;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(StringProperty('deferredUpdateDelay', '$_deferUpdateDelay ms'));
    debugRangeSliderFillProperties(properties);
  }
}
