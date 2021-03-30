import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'render_slider_base.dart';
import 'slider_shapes.dart';

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
/// * The "divisors", which is a shape that renders on the track based on the
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
      this.controller,
      this.enabled = true,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.deferredUpdateDelay = 500,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDivisors = false,
      this.enableTooltip = false,
      this.enableIntervalSelection = false,
      this.enableDeferredUpdate = false,
      this.dragMode = SliderDragMode.onThumb,
      this.inactiveColor,
      this.activeColor,
      this.labelPlacement = LabelPlacement.onTicks,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape = const SfTrackShape(),
      this.divisorShape = const SfDivisorShape(),
      this.overlayShape = const SfOverlayShape(),
      this.thumbShape = const SfThumbShape(),
      this.tickShape = const SfTickShape(),
      this.minorTickShape = const SfMinorTickShape(),
      this.tooltipShape = const SfRectangularTooltipShape(),
      this.startThumbIcon,
      this.endThumbIcon,
      required this.child})
      : assert(min != null),
        assert(max != null),
        assert(min != max),
        assert(interval == null || interval > 0),
        assert(stepSize == null || stepSize > 0),
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
  /// for date values, if the labels, ticks, and divisors are needed.
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
  ///     onChanged: (SfRangeValues values) {
  ///     }
  ///     child: Container(
  ///         height: 200,
  ///         color: Colors.green[100],
  ///     ),
  /// )
  /// ```
  final ValueChanged<SfRangeValues>? onChanged;

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
  ///  RangeController _rangeController;
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
  ///                                xValueMapper: (Data sales, _) => sales.x,
  ///                                yValueMapper: (Data sales, _) => sales.y)
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
  ///  RangeController _rangeController;
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
  /// It is mandatory if labels, major ticks and divisors are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the labels, major ticks,
  /// and divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date values, the range selector doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType], and [dateFormat]
  /// for date values, if labels, ticks, and divisors are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is DateIntervalType.years, then the range selector will
  /// render the labels, major ticks, and divisors at 2000, 2001, 2002 and
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
  /// * [showDivisors], to render divisors at given interval.
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
  /// [stepDuration] is SliderDuration(years: 1, months: 6), the range selector
  /// will move the thumbs at DateTime(2015, 01, 01), DateTime(2016, 07, 01),
  /// DateTime(2018, 01, 01),and DateTime(2019, 07, 01).
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
  ///      stepDuration: SliderDuration(years: 1, months: 6),
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

  /// Option to render the divisors on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range selector will render the divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show divisors in [SfRangeSelector].
  ///
  /// ```dart
  /// SfRangeValues _initialValues = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSelector(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   initialValues: _initialValues,
  ///   interval: 2,
  ///   showDivisors: true,
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
  /// * [divisorShape] and [SfRangeSelectorThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSelectorThemeData-class.html) for customizing
  /// the divisor’s visual appearance.
  final bool showDivisors;

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
  /// When [dragMode] is set to `SliderDragMode.onThumb`,
  /// individual thumb can be moved by dragging it.
  ///
  /// When [dragMode] is set to `SliderDragMode.betweenThumbs`, both the thumbs
  /// can be moved at the same time by dragging in the area between start and
  /// end thumbs. The range between the start and end thumb will always
  /// be the same. Hence, it is not possible to move the individual thumb.
  ///
  /// When [dragMode] is set to `SliderDragMode.both`, individual thumb
  /// can be moved by dragging it, and also both the thumbs can be moved
  /// at the same time by dragging in the area between start and end thumbs.
  ///
  /// Defaults to `SliderDragMode.onThumb`.
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

  /// Color applied to the inactive track and active divisors.
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

  /// Color applied to the active track, thumb, overlay, and inactive divisors.
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
  /// divisors are needed.
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
  /// divisors are needed.
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
  /// SfRangeValues _values = SfRangeValues(40.0, 60.0);
  ///
  /// ```dart
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

  /// Base class for [SfRangeSelector] divisors shapes.
  final SfDivisorShape divisorShape;

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
  _SfRangeSelectorState createState() => _SfRangeSelectorState();

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
        ifFalse: 'Range selector is disabled',
        showName: false));
    properties.add(DoubleProperty('interval', interval));
    properties.add(DoubleProperty('stepSize', stepSize));
    if (stepDuration != null) {
      properties.add(stepDuration!.toDiagnosticsNode(name: 'stepDuration'));
    }

    properties.add(IntProperty('minorTicksPerInterval', minorTicksPerInterval));
    properties.add(FlagProperty('showTicks',
        value: showTicks,
        ifTrue: 'Ticks are showing',
        ifFalse: 'Ticks are not showing',
        showName: false));
    properties.add(FlagProperty('showLabels',
        value: showLabels,
        ifTrue: 'Labels are showing',
        ifFalse: 'Labels are not showing',
        showName: false));
    properties.add(FlagProperty('showDivisors',
        value: showDivisors,
        ifTrue: 'Divisors are  showing',
        ifFalse: 'Divisors are not showing',
        showName: false));
    properties.add(FlagProperty('enableTooltip',
        value: enableTooltip,
        ifTrue: 'Tooltip is enabled',
        ifFalse: 'Tooltip is disabled',
        showName: false));
    properties.add(FlagProperty('enableIntervalSelection',
        value: enableIntervalSelection,
        ifTrue: 'Interval selection is enabled',
        ifFalse: 'Interval selection is disabled',
        showName: false));
    properties.add(FlagProperty('enableDeferredUpdate',
        value: enableDeferredUpdate,
        ifTrue: 'Deferred update is enabled',
        ifFalse: 'Deferred update is disabled',
        showName: false));
    properties.add(EnumProperty<SliderDragMode>('dragMode', dragMode));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (initialValues != null &&
        initialValues!.start.runtimeType == DateTime &&
        dateFormat != null) {
      properties.add(StringProperty(
          'dateFormat',
          'Formatted value is ' +
              (dateFormat!.format(initialValues!.start)).toString()));
    }

    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChanged', onChanged));
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
  Timer? tooltipDelayTimer;
  final Duration duration = const Duration(milliseconds: 100);

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  SfRangeSelectorThemeData _getRangeSelectorThemeData(ThemeData themeData) {
    SfRangeSelectorThemeData rangeSelectorThemeData =
        SfRangeSelectorTheme.of(context)!;
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
      inactiveLabelStyle: rangeSelectorThemeData.inactiveLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: widget.enabled
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      activeLabelStyle: rangeSelectorThemeData.activeLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: widget.enabled
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      tooltipTextStyle: rangeSelectorThemeData.tooltipTextStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: rangeSelectorThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(255, 255, 255, 1)
                  : const Color.fromRGBO(0, 0, 0, 1)),
      inactiveTrackColor: widget.inactiveColor ??
          rangeSelectorThemeData.inactiveTrackColor ??
          themeData.primaryColor.withOpacity(0.24),
      activeTrackColor: widget.activeColor ??
          rangeSelectorThemeData.activeTrackColor ??
          themeData.primaryColor,
      thumbColor: widget.activeColor ??
          rangeSelectorThemeData.thumbColor ??
          themeData.primaryColor,
      activeTickColor: rangeSelectorThemeData.activeTickColor,
      inactiveTickColor: rangeSelectorThemeData.inactiveTickColor,
      disabledActiveTickColor: rangeSelectorThemeData.disabledActiveTickColor,
      disabledInactiveTickColor:
          rangeSelectorThemeData.disabledInactiveTickColor,
      activeMinorTickColor: rangeSelectorThemeData.activeMinorTickColor,
      inactiveMinorTickColor: rangeSelectorThemeData.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          rangeSelectorThemeData.disabledActiveMinorTickColor,
      // ignore: lines_longer_than_80_chars
      disabledInactiveMinorTickColor:
          rangeSelectorThemeData.disabledInactiveMinorTickColor,
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          rangeSelectorThemeData.overlayColor ??
          themeData.primaryColor.withOpacity(0.12),
      inactiveDivisorColor: widget.activeColor ??
          rangeSelectorThemeData.inactiveDivisorColor ??
          themeData.colorScheme.primary.withOpacity(0.54),
      activeDivisorColor: widget.inactiveColor ??
          rangeSelectorThemeData.activeDivisorColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.54),
      disabledInactiveDivisorColor:
          rangeSelectorThemeData.disabledInactiveDivisorColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledActiveDivisorColor:
          rangeSelectorThemeData.disabledActiveDivisorColor ??
              themeData.colorScheme.onPrimary.withOpacity(0.12),
      disabledActiveTrackColor:
          rangeSelectorThemeData.disabledActiveTrackColor ??
              themeData.colorScheme.onSurface.withOpacity(0.32),
      disabledInactiveTrackColor:
          rangeSelectorThemeData.disabledInactiveTrackColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledThumbColor: rangeSelectorThemeData.disabledThumbColor,
      thumbStrokeColor: rangeSelectorThemeData.thumbStrokeColor,
      overlappingThumbStrokeColor:
          rangeSelectorThemeData.overlappingThumbStrokeColor ??
              themeData.colorScheme.surface,
      activeDivisorStrokeColor: rangeSelectorThemeData.activeDivisorStrokeColor,
      inactiveDivisorStrokeColor:
          rangeSelectorThemeData.inactiveDivisorStrokeColor,
      overlappingTooltipStrokeColor:
          rangeSelectorThemeData.overlappingTooltipStrokeColor ??
              themeData.colorScheme.surface,
      activeRegionColor: rangeSelectorThemeData.activeRegionColor,
      inactiveRegionColor:
          widget.inactiveColor ?? rangeSelectorThemeData.inactiveRegionColor,
      tooltipBackgroundColor: rangeSelectorThemeData.tooltipBackgroundColor ??
          (widget.tooltipShape is SfPaddleTooltipShape
              ? themeData.primaryColor
              : (rangeSelectorThemeData.brightness == Brightness.light)
                  ? const Color.fromRGBO(97, 97, 97, 1)
                  : const Color.fromRGBO(224, 224, 224, 1)),
      trackCornerRadius:
          rangeSelectorThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: rangeSelectorThemeData.thumbRadius,
      overlayRadius: rangeSelectorThemeData.overlayRadius,
      activeDivisorRadius:
          rangeSelectorThemeData.activeDivisorRadius ?? minTrackHeight / 4,
      inactiveDivisorRadius:
          rangeSelectorThemeData.inactiveDivisorRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: rangeSelectorThemeData.thumbStrokeWidth,
      activeDivisorStrokeWidth: rangeSelectorThemeData.activeDivisorStrokeWidth,
      inactiveDivisorStrokeWidth:
          rangeSelectorThemeData.inactiveDivisorStrokeWidth,
    );

    return rangeSelectorThemeData;
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      assert(widget.controller!.start != null);
      assert(widget.controller!.end != null);
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
      values: widget.initialValues,
      enabled: widget.enabled && widget.min != widget.max,
      interval: widget.interval,
      stepSize: widget.stepSize,
      stepDuration: widget.stepDuration,
      deferUpdateDelay: widget.deferredUpdateDelay,
      minorTicksPerInterval: widget.minorTicksPerInterval,
      showTicks: widget.showTicks,
      showLabels: widget.showLabels,
      showDivisors: widget.showDivisors,
      enableTooltip: widget.enableTooltip,
      enableIntervalSelection: widget.enableIntervalSelection,
      deferUpdate: widget.enableDeferredUpdate,
      dragMode: widget.dragMode,
      inactiveColor:
          widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
      activeColor: widget.activeColor ?? themeData.primaryColor,
      labelPlacement: widget.labelPlacement,
      numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
      dateFormat: widget.dateFormat,
      dateIntervalType: widget.dateIntervalType,
      labelFormatterCallback:
          widget.labelFormatterCallback ?? _getFormattedLabelText,
      tooltipTextFormatterCallback:
          widget.tooltipTextFormatterCallback ?? _getFormattedTooltipText,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      trackShape: widget.trackShape,
      divisorShape: widget.divisorShape,
      overlayShape: widget.overlayShape,
      thumbShape: widget.thumbShape,
      tickShape: widget.tickShape,
      minorTickShape: widget.minorTickShape,
      tooltipShape: widget.tooltipShape,
      child: widget.child,
      rangeSelectorThemeData: _getRangeSelectorThemeData(themeData),
      startThumbIcon: widget.startThumbIcon,
      endThumbIcon: widget.endThumbIcon,
      state: this,
    );
  }
}

class _RangeSelectorRenderObjectWidget extends RenderObjectWidget {
  const _RangeSelectorRenderObjectWidget(
      {Key? key,
      required this.min,
      required this.max,
      required this.values,
      required this.enabled,
      required this.interval,
      required this.stepSize,
      required this.stepDuration,
      required this.deferUpdateDelay,
      required this.minorTicksPerInterval,
      required this.showTicks,
      required this.showLabels,
      required this.showDivisors,
      required this.enableTooltip,
      required this.enableIntervalSelection,
      required this.deferUpdate,
      required this.dragMode,
      required this.inactiveColor,
      required this.activeColor,
      required this.labelPlacement,
      required this.numberFormat,
      required this.dateFormat,
      required this.dateIntervalType,
      required this.labelFormatterCallback,
      required this.tooltipTextFormatterCallback,
      required this.semanticFormatterCallback,
      required this.trackShape,
      required this.divisorShape,
      required this.overlayShape,
      required this.thumbShape,
      required this.tickShape,
      required this.minorTickShape,
      required this.tooltipShape,
      required this.child,
      required this.rangeSelectorThemeData,
      required this.startThumbIcon,
      required this.endThumbIcon,
      required this.state})
      : super(key: key);

  final dynamic min;
  final dynamic max;
  final SfRangeValues? values;
  final bool enabled;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
  final int deferUpdateDelay;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDivisors;
  final bool enableTooltip;
  final bool enableIntervalSelection;
  final bool deferUpdate;
  final SliderDragMode dragMode;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final NumberFormat numberFormat;
  final DateFormat? dateFormat;
  final DateIntervalType? dateIntervalType;
  final SfRangeSelectorThemeData rangeSelectorThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final RangeSelectorSemanticFormatterCallback? semanticFormatterCallback;
  final SfTrackShape trackShape;
  final SfDivisorShape divisorShape;
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
        enabled: enabled,
        interval: interval,
        stepSize: stepSize,
        stepDuration: stepDuration,
        deferUpdateDelay: deferUpdateDelay,
        minorTicksPerInterval: minorTicksPerInterval,
        showTicks: showTicks,
        showLabels: showLabels,
        showDivisors: showDivisors,
        enableTooltip: enableTooltip,
        enableIntervalSelection: enableIntervalSelection,
        deferUpdate: deferUpdate,
        dragMode: dragMode,
        inactiveColor: inactiveColor,
        activeColor: activeColor,
        labelPlacement: labelPlacement,
        numberFormat: numberFormat,
        dateFormat: dateFormat,
        dateIntervalType: dateIntervalType,
        labelFormatterCallback: labelFormatterCallback,
        tooltipTextFormatterCallback: tooltipTextFormatterCallback,
        semanticFormatterCallback: semanticFormatterCallback,
        trackShape: trackShape,
        divisorShape: divisorShape,
        overlayShape: overlayShape,
        thumbShape: thumbShape,
        tickShape: tickShape,
        minorTickShape: minorTickShape,
        tooltipShape: tooltipShape,
        rangeSelectorThemeData: rangeSelectorThemeData,
        textDirection: Directionality.of(context),
        mediaQueryData: MediaQuery.of(context),
        state: state);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderRangeSelector renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..isEnabled = enabled
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..deferUpdateDelay = deferUpdateDelay
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDivisors = showDivisors
      ..enableTooltip = enableTooltip
      ..enableIntervalSelection = enableIntervalSelection
      ..deferUpdate = deferUpdate
      ..dragMode = dragMode
      ..labelPlacement = labelPlacement
      ..numberFormat = numberFormat
      ..dateFormat = dateFormat
      ..dateIntervalType = dateIntervalType
      ..labelFormatterCallback = labelFormatterCallback
      ..tooltipTextFormatterCallback = tooltipTextFormatterCallback
      ..semanticFormatterCallback = semanticFormatterCallback
      ..trackShape = trackShape
      ..divisorShape = divisorShape
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
    final ChildElements slot = slotValue;
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

class _RenderRangeSelector extends RenderBaseSlider
    implements MouseTrackerAnnotation {
  _RenderRangeSelector({
    required dynamic min,
    required dynamic max,
    required SfRangeValues? values,
    required bool enabled,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int deferUpdateDelay,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDivisors,
    required bool enableTooltip,
    required bool enableIntervalSelection,
    required bool deferUpdate,
    required SliderDragMode dragMode,
    required Color inactiveColor,
    required Color activeColor,
    required LabelPlacement labelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required RangeSelectorSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDivisorShape divisorShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfRangeSelectorThemeData rangeSelectorThemeData,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
    required _SfRangeSelectorState state,
  })   : _state = state,
        _isEnabled = enabled,
        _enableIntervalSelection = enableIntervalSelection,
        _deferUpdateDelay = deferUpdateDelay,
        _dragMode = dragMode,
        _deferUpdate = deferUpdate,
        _semanticFormatterCallback = semanticFormatterCallback,
        super(
            min: min,
            max: max,
            interval: interval,
            stepSize: stepSize,
            stepDuration: stepDuration,
            minorTicksPerInterval: minorTicksPerInterval,
            showTicks: showTicks,
            showLabels: showLabels,
            showDivisors: showDivisors,
            enableTooltip: enableTooltip,
            labelPlacement: labelPlacement,
            numberFormat: numberFormat,
            dateFormat: dateFormat,
            dateIntervalType: dateIntervalType,
            labelFormatterCallback: labelFormatterCallback,
            tooltipTextFormatterCallback: tooltipTextFormatterCallback,
            trackShape: trackShape,
            divisorShape: divisorShape,
            overlayShape: overlayShape,
            thumbShape: thumbShape,
            tickShape: tickShape,
            minorTickShape: minorTickShape,
            tooltipShape: tooltipShape,
            sliderThemeData: rangeSelectorThemeData,
            textDirection: textDirection,
            mediaQueryData: mediaQueryData) {
    if (_state.widget.controller != null) {
      assert(_state.widget.controller!.start != null);
      assert(_state.widget.controller!.end != null);
      _values = SfRangeValues(
          _state.widget.controller!.start, _state.widget.controller!.end);
    } else {
      _values = values!;
    }

    final GestureArenaTeam team = GestureArenaTeam();

    horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = _onDragStart
      ..onUpdate = _onDragUpdate
      ..onEnd = _onDragEnd
      ..onCancel = _onDragCancel;

    tapGestureRecognizer = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _onTapDown
      ..onTapUp = _onTapUp;

    _overlayStartAnimation = CurvedAnimation(
        parent: _state.overlayStartController, curve: Curves.fastOutSlowIn);

    _overlayEndAnimation = CurvedAnimation(
        parent: _state.overlayEndController, curve: Curves.fastOutSlowIn);

    _stateAnimation = CurvedAnimation(
        parent: _state.stateController, curve: Curves.easeInOut);

    _tooltipStartAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationStartController,
        curve: Curves.fastOutSlowIn);

    _tooltipEndAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationEndController,
        curve: Curves.fastOutSlowIn);

    if (isDateTime) {
      _valuesInMilliseconds = SfRangeValues(
          _values.start.millisecondsSinceEpoch.toDouble(),
          _values.end.millisecondsSinceEpoch.toDouble());
    }
    unformattedLabels = <double>[];
    updateTextPainter();

    if (_enableIntervalSelection) {
      _state.startPositionController.value =
          getFactorFromValue(actualValues.start);
      _state.endPositionController.value = getFactorFromValue(actualValues.end);
    }

    _inactiveRegionColor = rangeSelectorThemeData.inactiveRegionColor;
    _activeRegionColor = rangeSelectorThemeData.activeRegionColor;
  }

  final _SfRangeSelectorState _state;

  final Map<ChildElements, RenderBox> slotToChild =
      <ChildElements, RenderBox>{};

  final Map<RenderBox, ChildElements> childToSlot =
      <RenderBox, ChildElements>{};

  late Animation<double> _overlayStartAnimation;

  late Animation<double> _overlayEndAnimation;

  late Animation<double> _stateAnimation;

  late Animation<double> _tooltipStartAnimation;

  late Animation<double> _tooltipEndAnimation;

  SfRangeValues? _valuesInMilliseconds;

  late Color _inactiveRegionColor;

  late Color _activeRegionColor;

  // It stores the interaction start x-position at [tapDown] and [dragStart]
  // method, which is used to check whether dragging is started or not.
  double _interactionStartX = 0.0;

  bool _isDragging = false;

  bool _isIntervalTapped = false;

  Timer? _deferUpdateTimer;

  bool _isLocked = false;

  bool _isDragStart = false;

  static const Duration _positionAnimationDuration =
      Duration(milliseconds: 500);

  SfRangeValues get values => _values;
  late SfRangeValues _values;

  set values(SfRangeValues values) {
    if (_values == values) {
      return;
    }

    _values = values;
    if (isDateTime) {
      _valuesInMilliseconds = SfRangeValues(
          _values.start.millisecondsSinceEpoch.toDouble(),
          _values.end.millisecondsSinceEpoch.toDouble());
    }
  }

  bool get isEnabled => _isEnabled;
  bool _isEnabled;

  set isEnabled(bool value) {
    if (_isEnabled == value) {
      return;
    }
    final bool wasEnabled = isEnabled;
    _isEnabled = value;
    if (wasEnabled != isEnabled) {
      if (isEnabled) {
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

  bool get enableIntervalSelection => _enableIntervalSelection;
  bool _enableIntervalSelection;

  set enableIntervalSelection(bool value) {
    if (_enableIntervalSelection == value) {
      return;
    }
    _enableIntervalSelection = value;

    _state.startPositionController.value =
        getFactorFromValue(actualValues.start);
    _state.endPositionController.value = getFactorFromValue(actualValues.end);
  }

  bool get deferUpdate => _deferUpdate;
  late bool _deferUpdate;

  set deferUpdate(bool value) {
    if (_deferUpdate == value) {
      return;
    }
    _deferUpdate = value;
  }

  SliderDragMode get dragMode => _dragMode;
  SliderDragMode _dragMode;

  set dragMode(SliderDragMode value) {
    if (_dragMode == value) {
      return;
    }
    _dragMode = value;
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
      _inactiveRegionColor = value.inactiveRegionColor;
      _activeRegionColor = value.activeRegionColor;
    }
    markNeedsPaint();
  }

  RenderBox? get startThumbIcon => _startThumbIcon;
  RenderBox? _startThumbIcon;

  set startThumbIcon(RenderBox? value) {
    _startThumbIcon =
        _updateChild(_startThumbIcon, value, ChildElements.startThumbIcon);
  }

  RenderBox? get endThumbIcon => _endThumbIcon;
  RenderBox? _endThumbIcon;

  set endThumbIcon(RenderBox? value) {
    _endThumbIcon =
        _updateChild(_endThumbIcon, value, ChildElements.endThumbIcon);
  }

  @override
  RenderBox? get child => _child;
  RenderBox? _child;

  @override
  set child(RenderBox? value) {
    _child = _updateChild(_child, value, ChildElements.child);
  }

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_startThumbIcon != null) {
      yield startThumbIcon!;
    }
    if (_endThumbIcon != null) {
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

  double get minThumbGap =>
      (actualMax - actualMin) * (8 / actualTrackRect.width).clamp(0.0, 1.0);

  SfRangeValues get actualValues =>
      isDateTime ? _valuesInMilliseconds! : _values;

  // When the active track height and inactive track height are different,
  // a small gap is happens between min track height and child
  // So we adjust track offset to ignore that gap.
  double get adjustTrackY => sliderThemeData.activeTrackHeight >
          sliderThemeData.inactiveTrackHeight
      ? sliderThemeData.activeTrackHeight - sliderThemeData.inactiveTrackHeight
      : sliderThemeData.inactiveTrackHeight - sliderThemeData.activeTrackHeight;

  dynamic get _increasedStartValue {
    return getNextSemanticValue(values.start, semanticActionUnit,
        actualValue: actualValues.start);
  }

  dynamic get _decreasedStartValue {
    return getPrevSemanticValue(values.start, semanticActionUnit,
        actualValue: actualValues.start);
  }

  dynamic get _increasedEndValue {
    return getNextSemanticValue(values.end, semanticActionUnit,
        actualValue: actualValues.end);
  }

  dynamic get _decreasedEndValue {
    return getPrevSemanticValue(values.end, semanticActionUnit,
        actualValue: actualValues.end);
  }

  SfThumb? get activeThumb => _activeThumb;
  SfThumb? _activeThumb;

  set activeThumb(SfThumb? value) {
    if (_activeThumb == value &&
        (_state.overlayEndController.status == AnimationStatus.completed ||
            _state.overlayStartController.status ==
                AnimationStatus.completed)) {
      return;
    }
    _activeThumb = value;
    if (value == SfThumb.start) {
      _state.overlayStartController.forward();
      _state.overlayEndController.reverse();
      if (enableTooltip) {
        willDrawTooltip = true;
        _state.tooltipAnimationStartController.forward();
        _state.tooltipAnimationEndController.reverse();
      }
    } else {
      _state.overlayEndController.forward();
      _state.overlayStartController.reverse();
      if (enableTooltip) {
        willDrawTooltip = true;
        _state.tooltipAnimationEndController.forward();
        _state.tooltipAnimationStartController.reverse();
      }
    }
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    _interactionStartX = globalToLocal(details.globalPosition).dx;
    mainAxisOffset = _interactionStartX;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    _isDragStart = true;
    _interactionStartX = globalToLocal(details.globalPosition).dx;
    mainAxisOffset = _interactionStartX;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _updateRangeValues(deltaX: details.delta.dx);
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    // This field is used in the [paint] method to handle the
    // interval selection animation, so we can't reset this
    // field in [endInteraction] method.
    _isIntervalTapped = false;
    isInteractionEnd = false;

    final double startPosition = getPositionFromValue(actualValues.start);
    final double endPosition = getPositionFromValue(actualValues.end);
    final double leftThumbWidth = (startPosition - mainAxisOffset).abs();
    final double rightThumbWidth = (endPosition - mainAxisOffset).abs();

    if ((_dragMode == SliderDragMode.both ||
            _dragMode == SliderDragMode.betweenThumbs) &&
        startPosition < (mainAxisOffset - minPreferredTouchWidth) &&
        (mainAxisOffset + minPreferredTouchWidth) < endPosition) {
      if (_isDragStart) {
        _isLocked = true;
      } else {
        return;
      }
    } else if (_dragMode == SliderDragMode.betweenThumbs) {
      return;
    } else if (rightThumbWidth == leftThumbWidth) {
      switch (activeThumb!) {
        case SfThumb.start:
          _state.overlayStartController.forward();
          break;
        case SfThumb.end:
          _state.overlayEndController.forward();
          break;
      }
    } else if (rightThumbWidth > leftThumbWidth) {
      activeThumb = SfThumb.start;
      _state.overlayStartController.forward();
    } else {
      activeThumb = SfThumb.end;
      _state.overlayEndController.forward();
    }

    _forwardTooltipAnimation();
    _updateRangeValues();
  }

  void _forwardTooltipAnimation() {
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationStartController.forward();
      _state.tooltipAnimationEndController.forward();
      _state.tooltipDelayTimer?.cancel();
      _state.tooltipDelayTimer = Timer(const Duration(milliseconds: 500), () {
        _reverseTooltipAnimation();
      });
    }
  }

  void _reverseTooltipAnimation() {
    _state.tooltipDelayTimer = null;
    if (isInteractionEnd &&
        willDrawTooltip &&
        _state.tooltipAnimationStartController.status ==
            AnimationStatus.completed) {
      _state.tooltipAnimationStartController.reverse();
    }
    if (isInteractionEnd &&
        willDrawTooltip &&
        _state.tooltipAnimationEndController.status ==
            AnimationStatus.completed) {
      _state.tooltipAnimationEndController.reverse();
    }
    if (_state.tooltipAnimationStartController.status ==
            AnimationStatus.dismissed &&
        _state.tooltipAnimationEndController.status ==
            AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _updateRangeValues({double? deltaX}) {
    SfRangeValues newValues;
    _isDragging = (_interactionStartX - mainAxisOffset).abs() > 1;
    _isIntervalTapped = _enableIntervalSelection && !_isDragging;

    if (_isLocked && deltaX != null) {
      newValues = _getLockRangeValues(deltaX);
    } else if (_dragMode == SliderDragMode.betweenThumbs) {
      return;
    } else {
      double start;
      double end;
      final double factor = getFactorFromCurrentPosition();
      final double value = lerpDouble(actualMin, actualMax, factor)!;
      if (isDateTime) {
        start = values.start.millisecondsSinceEpoch.toDouble();
        end = values.end.millisecondsSinceEpoch.toDouble();
      } else {
        start = values.start;
        end = values.end;
      }

      switch (activeThumb!) {
        case SfThumb.start:
          final double startValue = math.min(value, end - minThumbGap);
          final dynamic actualStartValue =
              getActualValue(valueInDouble: startValue);
          newValues = values.copyWith(start: actualStartValue);
          break;
        case SfThumb.end:
          final double endValue = math.max(value, start + minThumbGap);
          final dynamic actualEndValue =
              getActualValue(valueInDouble: endValue);
          newValues = values.copyWith(end: actualEndValue);
          break;
      }
    }

    _updateValuesBasedOnDeferredUpdate(newValues);
  }

  void _updateValuesBasedOnDeferredUpdate(SfRangeValues newValues) {
    if (_isEnabled && !_isIntervalTapped) {
      if (newValues.start != _values.start || newValues.end != _values.end) {
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
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      if (_enableIntervalSelection) {
        _state.startPositionController.value =
            getFactorFromValue(actualValues.start);
        _state.endPositionController.value =
            getFactorFromValue(actualValues.end);

        if (_isIntervalTapped) {
          final double value =
              lerpDouble(actualMin, actualMax, getFactorFromCurrentPosition())!;
          _updatePositionControllerValue(_getSelectedRange(value));
        }
      }

      // Default, we only update new values when dragging.
      // If [deferUpdate] is enabled, new values are updated with
      // [deferUpdateDelay].
      // But touch up is handled before the [deferUpdateDelay] timer,
      // we have to invoke [onChanged] call back with new values and
      // update the new values to the [controller] immediately.
      if (_deferUpdate) {
        _deferUpdateTimer?.cancel();
        _updateNewValues(values);
      }

      _isDragging = false;
      _state.overlayStartController.reverse();
      _state.overlayEndController.reverse();
      if (enableTooltip && _state.tooltipDelayTimer == null) {
        _state.tooltipAnimationStartController.reverse();
        _state.tooltipAnimationEndController.reverse();
      }

      isInteractionEnd = true;
      _isLocked = false;
      _isDragStart = false;
      currentPointerType = PointerType.up;
      markNeedsPaint();
    }
  }

  void _updatePositionControllerValue(SfRangeValues newValues) {
    DateTime? startDate;
    DateTime? endDate;

    if (isDateTime) {
      startDate = newValues.start;
      endDate = newValues.end;
    }
    final double startValueFactor = getFactorFromValue(isDateTime
        ? startDate!.millisecondsSinceEpoch.toDouble()
        : newValues.start);
    final double endValueFactor = getFactorFromValue(isDateTime
        ? endDate!.millisecondsSinceEpoch.toDouble()
        : newValues.end);

    final double startDistanceFactor =
        (startValueFactor - _state.startPositionController.value).abs();
    final double endDistanceFactor =
        (endValueFactor - _state.endPositionController.value).abs();
    _state.startPositionController.duration = startDistanceFactor != 0.0
        ? _positionAnimationDuration * (1.0 / startDistanceFactor)
        : Duration.zero;
    _state.endPositionController.duration = endDistanceFactor != 0.0
        ? _positionAnimationDuration * (1.0 / endDistanceFactor)
        : Duration.zero;
    _state.startPositionController
        .animateTo(startValueFactor, curve: Curves.easeInOut);
    _state.endPositionController
        .animateTo(endValueFactor, curve: Curves.easeInOut);
  }

  SfRangeValues _getLockRangeValues(double? deltaX) {
    double startPosition = getPositionFromValue(actualValues.start);
    double endPosition = getPositionFromValue(actualValues.end);
    final double lockedRangeWidth = endPosition - startPosition;
    startPosition += deltaX ?? 0.0;
    endPosition += deltaX ?? 0.0;
    final double actualMinInPx = getPositionFromValue(actualMin);
    final double actualMaxInPx = getPositionFromValue(actualMax);
    if (startPosition < actualMinInPx) {
      startPosition = actualMinInPx;
      endPosition = startPosition + lockedRangeWidth;
    } else if (endPosition > actualMaxInPx) {
      endPosition = actualMaxInPx;
      startPosition = endPosition - lockedRangeWidth;
    }

    return SfRangeValues(
        getValueFromPosition(startPosition), getValueFromPosition(endPosition));
  }

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
    markNeedsSemanticsUpdate();
  }

  SfRangeValues _getSelectedRange(double value) {
    late SfRangeValues rangeValues;
    dynamic start;
    dynamic end;

    for (int i = 0; i < divisions!; i++) {
      final double currentLabel = unformattedLabels![i];
      if (i < divisions! - 1) {
        final double nextLabel = unformattedLabels![i + 1];
        if (value >= currentLabel && value <= nextLabel) {
          if (isDateTime) {
            start = DateTime.fromMillisecondsSinceEpoch(currentLabel.toInt());
            end = DateTime.fromMillisecondsSinceEpoch(nextLabel.toInt());
          } else {
            start = currentLabel;
            end = nextLabel;
          }
          rangeValues = SfRangeValues(start, end);
          break;
        }
      } else {
        start = isDateTime
            ? DateTime.fromMillisecondsSinceEpoch(currentLabel.toInt())
            : currentLabel;
        end = this.max;
        rangeValues = SfRangeValues(start, end);
      }
    }
    return rangeValues;
  }

  RenderBox? _updateChild(
      RenderBox? oldChild, RenderBox? newChild, ChildElements slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      childToSlot[newChild] = slot;
      slotToChild[slot] = newChild;
      adoptChild(newChild);
    }
    return newChild;
  }

  void _handleRangeControllerChange() {
    if (_state.mounted &&
        _state.widget.controller != null &&
        (_values.start != _state.widget.controller!.start ||
            _values.end != _state.widget.controller!.end)) {
      values = SfRangeValues(
          getActualValue(value: _state.widget.controller!.start),
          getActualValue(value: _state.widget.controller!.end));

      markNeedsPaint();
    }
  }

  void _handlePositionControllerChange() {
    if (_isIntervalTapped) {
      final dynamic startValue = isDateTime
          ? DateTime.fromMillisecondsSinceEpoch(
              (getValueFromFactor(_state.startPositionController.value))
                  .toInt())
          : getValueFromFactor(_state.startPositionController.value);

      final dynamic endValue = isDateTime
          ? DateTime.fromMillisecondsSinceEpoch(
              (getValueFromFactor(_state.endPositionController.value)).toInt())
          : getValueFromFactor(_state.endPositionController.value);

      if (_state.widget.controller != null) {
        _state.widget.controller!.start = startValue;
        _state.widget.controller!.end = endValue;
      } else {
        values = SfRangeValues(startValue, endValue);
      }

      if (_state.widget.onChanged != null) {
        _state.widget.onChanged!(SfRangeValues(startValue, endValue));
      }
      markNeedsPaint();
    }
  }

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (_state.tooltipAnimationStartController.status ==
            AnimationStatus.dismissed &&
        _state.tooltipAnimationEndController.status ==
            AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _drawRegions(PaintingContext context, Rect trackRect, Offset offset,
      Offset startThumbCenter, Offset endThumbCenter) {
    final Paint paint = Paint()
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
          paint);
      paint.color = _activeRegionColor;
      context.canvas.drawRect(
          Rect.fromLTRB(leftThumbCenter.dx, offset.dy, rightThumbCenter.dx,
              trackRect.top + activeRegionAdj),
          paint);
      paint.color = _inactiveRegionColor;
      context.canvas.drawRect(
          Rect.fromLTRB(rightThumbCenter.dx, offset.dy, trackRect.right,
              trackRect.top + inactiveRegionAdj),
          paint);
    }
  }

  void _drawOverlayAndThumb(
    PaintingContext context,
    Offset endThumbCenter,
    Offset startThumbCenter,
  ) {
    final bool isLeftThumbActive = activeThumb == SfThumb.start;
    Offset thumbCenter = isLeftThumbActive ? endThumbCenter : startThumbCenter;
    RenderBox? thumbIcon = isLeftThumbActive ? _endThumbIcon : _startThumbIcon;
    showOverlappingThumbStroke = false;

    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: thumbIcon,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: isLeftThumbActive ? SfThumb.end : SfThumb.start,
        paint: null);

    thumbCenter = isLeftThumbActive ? startThumbCenter : endThumbCenter;
    thumbIcon = isLeftThumbActive ? _startThumbIcon : _endThumbIcon;
    // Drawing overlay.
    overlayShape.paint(context, thumbCenter,
        parentBox: this,
        themeData: sliderThemeData,
        currentValues: _values,
        animation:
            isLeftThumbActive ? _overlayStartAnimation : _overlayEndAnimation,
        thumb: activeThumb,
        paint: null);

    showOverlappingThumbStroke = (getFactorFromValue(actualValues.start) -
                    getFactorFromValue(actualValues.end))
                .abs() *
            actualTrackRect.width <
        actualThumbSize.width;

    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: thumbIcon,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: activeThumb,
        paint: null);
  }

  void _drawTooltip(
      PaintingContext context,
      Offset endThumbCenter,
      Offset startThumbCenter,
      Offset offset,
      Offset actualTrackOffset,
      Rect trackRect) {
    if (willDrawTooltip) {
      final Paint paint = Paint()
        ..color = sliderThemeData.tooltipBackgroundColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      final bool isLeftThumbActive = activeThumb == SfThumb.start;
      Offset thumbCenter =
          isLeftThumbActive ? endThumbCenter : startThumbCenter;
      dynamic actualText = getValueFromPosition(thumbCenter.dx - offset.dx);
      String tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      TextSpan textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      Rect? bottomTooltipRect;
      if (tooltipShape is SfPaddleTooltipShape) {
        bottomTooltipRect = getPaddleTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      } else if (tooltipShape is SfRectangularTooltipShape) {
        bottomTooltipRect = getRectangularTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      }

      showOverlappingTooltipStroke = false;
      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation:
              isLeftThumbActive ? _tooltipEndAnimation : _tooltipStartAnimation,
          trackRect: trackRect);

      thumbCenter =
          activeThumb == SfThumb.start ? startThumbCenter : endThumbCenter;
      actualText = getValueFromPosition(thumbCenter.dx - offset.dx);
      tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      Rect? topTooltipRect;
      if (tooltipShape is SfPaddleTooltipShape) {
        topTooltipRect = getPaddleTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      } else if (tooltipShape is SfRectangularTooltipShape) {
        topTooltipRect = getRectangularTooltipRect(
            textPainter,
            Offset(actualTrackOffset.dx, tooltipStartY),
            thumbCenter,
            trackRect,
            sliderThemeData);
      }
      if (bottomTooltipRect != null && topTooltipRect != null) {
        final Rect overlapRect = topTooltipRect.intersect(bottomTooltipRect);
        showOverlappingTooltipStroke = overlapRect.right > overlapRect.left;
      }

      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation:
              isLeftThumbActive ? _tooltipStartAnimation : _tooltipEndAnimation,
          trackRect: trackRect);
    }
  }

  void _increaseStartAction() {
    if (isEnabled) {
      final SfRangeValues actualNewValues =
          SfRangeValues(_increasedStartValue, values.end);
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        _updateNewValues(actualNewValues);
      }
    }
  }

  void _decreaseStartAction() {
    if (isEnabled) {
      _updateNewValues(SfRangeValues(_decreasedStartValue, values.end));
    }
  }

  void _increaseEndAction() {
    if (isEnabled) {
      _updateNewValues(SfRangeValues(values.start, _increasedEndValue));
    }
  }

  void _decreaseEndAction() {
    if (isEnabled) {
      final SfRangeValues actualNewValues =
          SfRangeValues(values.start, _decreasedEndValue);
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        _updateNewValues(actualNewValues);
      }
    }
  }

  void _handleExit(PointerExitEvent event) {
    // Ensuring whether the thumb is drag or move
    // not needed to call controller's reverse.
    if (currentPointerType != PointerType.move) {
      _state.overlayStartController.reverse();
      _state.overlayEndController.reverse();
      if (enableTooltip) {
        _state.tooltipAnimationStartController.reverse();
        _state.tooltipAnimationEndController.reverse();
      }
    }
  }

  void _handleHover(PointerHoverEvent details) {
    double cursorPosition = 0.0;
    cursorPosition = details.localPosition.dx;
    final double startThumbPosition = sliderType == SliderType.vertical
        ? actualTrackRect.bottom -
            getFactorFromValue(actualValues.start) * actualTrackRect.height
        : getFactorFromValue(actualValues.start) * actualTrackRect.width +
            actualTrackRect.left;
    final double endThumbPosition = sliderType == SliderType.vertical
        ? actualTrackRect.bottom -
            getFactorFromValue(actualValues.end) * actualTrackRect.height
        : getFactorFromValue(actualValues.end) * actualTrackRect.width +
            actualTrackRect.left;
    final double startThumbDistance =
        (cursorPosition - startThumbPosition).abs();
    final double endThumbDistance = (cursorPosition - endThumbPosition).abs();
    if (endThumbDistance > startThumbDistance) {
      activeThumb = SfThumb.start;
    } else {
      activeThumb = SfThumb.end;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _overlayStartAnimation.addListener(markNeedsPaint);
    _overlayEndAnimation.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
    _tooltipStartAnimation.addListener(markNeedsPaint);
    _tooltipStartAnimation
        .addStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.addListener(markNeedsPaint);
    _tooltipEndAnimation.addStatusListener(_handleTooltipAnimationStatusChange);
    _state.startPositionController.addListener(_handlePositionControllerChange);
    _state.endPositionController.addListener(_handlePositionControllerChange);
    if (_state.widget.controller != null) {
      _state.widget.controller!.addListener(_handleRangeControllerChange);
    }
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _deferUpdateTimer?.cancel();
    _overlayStartAnimation.removeListener(markNeedsPaint);
    _overlayEndAnimation.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    _tooltipStartAnimation.removeListener(markNeedsPaint);
    _tooltipStartAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.removeListener(markNeedsPaint);
    _tooltipEndAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
    _state.startPositionController
        .removeListener(_handlePositionControllerChange);
    _state.endPositionController
        .removeListener(_handlePositionControllerChange);
    if (_state.widget.controller != null) {
      _state.widget.controller!.removeListener(_handleRangeControllerChange);
    }
    super.detach();
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter => null;

  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => _handleHover;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerHoverEvent) {
      _handleHover(event);
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestSelf(Offset position) => isEnabled;

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) => false;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
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
          (elementsHeightAfterRenderedChild - constraints.maxHeight);
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
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      childParentData.offset = Offset(maxRadius, 0);
      childHeight = child!.size.height;
      childWidth = child!.size.width;
    }

    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: sliderThemeData.thumbRadius * 2,
        height: sliderThemeData.thumbRadius * 2);
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
  void paint(PaintingContext context, Offset offset) {
    double childHeight = 0.0;
    if (child != null) {
      // ignore: avoid_as
      final BoxParentData childParentData = child!.parentData as BoxParentData;
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

    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbStartPosition =
        getFactorFromValue(actualValues.start) * trackRect.width;
    final double thumbEndPosition =
        getFactorFromValue(actualValues.end) * trackRect.width;
    final Offset startThumbCenter =
        Offset(trackRect.left + thumbStartPosition, trackRect.center.dy);
    final Offset endThumbCenter =
        Offset(trackRect.left + thumbEndPosition, trackRect.center.dy);
    trackShape.paint(
        context, actualTrackOffset, null, startThumbCenter, endThumbCenter,
        parentBox: this,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        activePaint: null,
        inactivePaint: null);

    if (showLabels || showTicks || showDivisors) {
      drawLabelsTicksAndDivisors(context, trackRect, offset, null,
          startThumbCenter, endThumbCenter, _stateAnimation, null, values);
    }

    _drawRegions(context, trackRect, offset, startThumbCenter, endThumbCenter);
    _drawOverlayAndThumb(context, endThumbCenter, startThumbCenter);
    _drawTooltip(context, endThumbCenter, startThumbCenter, offset,
        actualTrackOffset, trackRect);
  }

  /// Describe the semantics of the start thumb.
  SemanticsNode? _startSemanticsNode = SemanticsNode();

  /// Describe the semantics of the end thumb.
  SemanticsNode? _endSemanticsNode = SemanticsNode();

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
    config.isEnabled = isEnabled;
    config.textDirection = textDirection;
    if (isEnabled) {
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
      _increasedStartValue,
      _decreasedStartValue,
      SfThumb.start,
      _increaseStartAction,
      _decreaseStartAction,
    );
    final SemanticsConfiguration endSemanticsConfiguration =
        _createSemanticsConfiguration(
      values.end,
      _increasedEndValue,
      _decreasedEndValue,
      SfThumb.end,
      _increaseEndAction,
      _decreaseEndAction,
    );
    // Split the semantics node area between the start and end nodes.
    final Rect leftRect =
        Rect.fromPoints(node.rect.topLeft, node.rect.bottomCenter);
    final Rect rightRect =
        Rect.fromPoints(node.rect.topCenter, node.rect.bottomRight);
    switch (textDirection) {
      case TextDirection.ltr:
        _startSemanticsNode!.rect = leftRect;
        _endSemanticsNode!.rect = rightRect;
        break;
      case TextDirection.rtl:
        _startSemanticsNode!.rect = rightRect;
        _endSemanticsNode!.rect = leftRect;
        break;
    }

    _startSemanticsNode!.updateWith(config: startSemanticsConfiguration);
    _endSemanticsNode!.updateWith(config: endSemanticsConfiguration);

    final List<SemanticsNode> finalChildren = <SemanticsNode>[
      _startSemanticsNode!,
      _endSemanticsNode!,
    ];

    node.updateWith(config: config, childrenInInversePaintOrder: finalChildren);
  }

  @override
  void clearSemantics() {
    super.clearSemantics();
    _startSemanticsNode = null;
    _endSemanticsNode = null;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = isEnabled;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'deferredUpdateDelay', _deferUpdateDelay.toString() + ' ms'));
    properties.add(StringProperty(
        'thumbSize', thumbShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'activeDivisorSize',
        divisorShape
            .getPreferredSize(sliderThemeData, isActive: true)
            .toString()));
    properties.add(StringProperty(
        'inactiveDivisorSize',
        divisorShape
            .getPreferredSize(sliderThemeData, isActive: false)
            .toString()));
    properties.add(StringProperty('overlaySize',
        overlayShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'tickSize', tickShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty('minorTickSize',
        minorTickShape.getPreferredSize(sliderThemeData).toString()));
  }
}
