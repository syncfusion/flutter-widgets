import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show
        GestureArenaTeam,
        TapGestureRecognizer,
        HorizontalDragGestureRecognizer;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'render_slider_base.dart';
import 'slider_shapes.dart';

/// A Material Design range slider.
///
/// Used to select a range between [min] and [max].
/// It supports both numeric and date ranges.
///
/// The range slider elements are:
///
/// * The "track", which is the rounded rectangle in which
/// the thumbs are slides over.
/// * The "thumb", which is a shape that slides horizontally when
/// the user drags it.
/// * The "active" side of the range slider is between
/// the left and right thumbs.
/// * The "inactive" side of the range slider is between the [min] value and the
/// left thumb, and the right thumb and the [max] value.
/// For RTL, the inactive side of the range slider is between
/// the [max] value and the left thumb, and the right thumb and the [min] value.
/// * The "divisors", which is a shape that renders on the track based on
/// the given [interval] value.
/// * The "ticks", which is a shape that rendered based on
/// given [interval] value.
/// Basically, it is rendered below the track. It is also called “major ticks”.
/// * The "minor ticks", which is a shape that renders between two major ticks
/// based on given [minorTicksPerInterval] value.
/// Basically, it is rendered below the track.
/// * The "labels", which is a text that rendered based on
/// given [interval] value.
/// Basically, it is rendered below the track and the major ticks.
///
/// The range slider will be disabled if [onChanged] is null or
/// [min] is equal to [max].
///
/// The range slider widget doesn’t maintains any state.
/// Alternatively, the widget calls the [onChanged] callback with the new values
/// when the state of range slider changes. To update the range slider’s visual
/// appearance with the new values, rebuilds the range slider
/// with the new values.
///
/// Range slider can be customized using the [SfRangeSliderTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderTheme-class.html) with the help of [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), or the [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) with the help of [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html).
/// It is also possible to override the appearance using [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html) which were set using the properties of the widget like [activeColor] and [inactiveColor].
///
/// ## Example
///
/// This snippet shows how to create a numeric [SfRangeSlider].
///
/// ```dart
/// SfRangeValues _values = SfRangeValues(4.0, 8.0);
///
/// @override
/// Widget build(BuildContext context) {
///   return MaterialApp(
///      home: Scaffold(
///          body: Center(
///              child: SfRangeSlider(
///                     min: 0.0,
///                     max: 10.0,
///                     values: _values,
///                     onChanged: (SfRangeValues newValues) {
///                         setState(() {
///                             _values = newValues;
///                         });
///                   },
///              )
///           )
///       )
///   );
/// }
/// ```
///
/// This snippet shows how to create a date [SfRangeSlider].
///
/// ```dart
/// SfRangeValues _values = SfRangeValues(
///       DateTime(2002, 01, 01), DateTime(2003, 01, 01));
///
/// SfRangeSlider(
///  min: DateTime(2000, 01, 01, 00),
///  max: DateTime(2005, 12, 31, 24),
///  values: _values,
///  interval: 1,
///  dateFormat: DateFormat.y(),
/// dateIntervalType: DateIntervalType.years,
///  onChanged: (SfRangeValues newValues) {
///    setState(() {
///      _values = newValues;
///    });
///  },
/// )
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html), for customizing the visual appearance of the range slider.
/// * [numberFormat] and [dateFormat], for formatting the numeric and
/// date labels.
/// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the visual appearance of the range slider.
class SfRangeSlider extends StatefulWidget {
  /// Creates a [SfRangeSlider].
  const SfRangeSlider(
      {Key key,
      this.min = 0.0,
      this.max = 1.0,
      @required this.values,
      @required this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval,
      this.showTicks = false,
      this.showLabels = false,
      this.showDivisors = false,
      this.enableTooltip = false,
      this.enableIntervalSelection = false,
      this.inactiveColor,
      this.activeColor,
      this.labelPlacement,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape,
      this.divisorShape,
      this.overlayShape,
      this.thumbShape,
      this.tickShape,
      this.minorTickShape,
      this.tooltipShape,
      this.startThumbIcon,
      this.endThumbIcon})
      : assert(min != null),
        assert(max != null),
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// The minimum value that the user can select.
  ///
  /// Defaults to 0.0. Must be less than the [max].
  final dynamic min;

  /// The maximum value that the user can select.
  ///
  /// Defaults to 1.0. Must be greater than the [min].
  final dynamic max;

  /// The values currently selected in the range slider.
  ///
  /// The range slider's start and end thumbs are drawn
  /// corresponding to these values.
  ///
  /// For date values, the range slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType], and
  /// [dateFormat] for date values,
  /// if the labels, ticks, and divisors are needed.
  ///
  /// This snippet shows how to create a numeric [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// This snippet shows how to create a date [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///        DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   values: _values,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///      _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [onChanged], to update the visual appearance of
  /// the range slider when the user drags the thumb through interaction.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final SfRangeValues values;

  /// Called when the user is selecting a new values for the slider by dragging.
  ///
  /// The range slider passes the new values to the callback but
  /// does not change its state until the parent widget rebuilds
  /// the range slider with new values.
  ///
  /// If it is null, the range slider will be disabled.
  ///
  /// This snippet shows how to create a numeric [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  final ValueChanged<SfRangeValues> onChanged;

  /// Splits the range slider into given interval.
  /// It is mandatory if labels, major ticks and divisors are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the labels, major ticks,
  /// and divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date values, the range slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// divisors are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is DateIntervalType.years, then the range slider will
  /// render the labels, major ticks, and divisors at 2000, 2001, 2002 and
  /// so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to set numeric interval in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// This snippet shows how to set date interval in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///         DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///      _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showDivisors], to render divisors at given interval.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final double interval;

  /// Option to select discrete values.
  ///
  /// [stepSize] doesn’t work for [DateTime] range slider.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [stepSize] is 2.0,
  /// the range slider will move the thumbs at 0.0, 2.0, 4.0, 6.0, 8.0 and 10.0.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to set numeric stepSize in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   stepSize: 2,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  final double stepSize;

  /// Option to select discrete date values.
  ///
  /// For example, if [min] is DateTime(2015, 01, 01) and
  /// [max] is DateTime(2020, 01, 01) and
  /// [stepDuration] is SliderDuration(years: 1, months: 6),
  /// the range slider will move the thumbs at DateTime(2015, 01, 01),
  /// DateTime(2016, 07, 01), DateTime(2018, 01, 01),and DateTime(2019, 07, 01).
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set stepDuration in [SfRangeSlider].
  ///
  /// ```dart
  ///
  ///   SfRangeValues _values = SfRangeValues(
  ///           DateTime(2017, 04,01), DateTime(2018, 08, 01));
  ///
  ///   SfRangeSlider(
  ///      min: DateTime(2015, 01, 01),
  ///      max: DateTime(2020, 01, 01),
  ///      values: _values,
  ///      enableTooltip: true,
  ///      stepDuration: SliderDuration(years: 1, months: 6),
  ///      interval: 2,
  ///      showLabels: true,
  ///      showTicks: true,
  ///      minorTicksPerInterval: 1,
  ///      dateIntervalType: DateIntervalType.years,
  ///      dateFormat: DateFormat.yMd(),
  ///      onChanged: (SfRangeValues newValues) {
  ///       setState(() {
  ///         _values = newValues;
  ///       });
  ///     },
  ///  )
  /// ```
  ///
  /// See also:
  ///
  /// * [interval], for setting the interval.
  /// * [dateIntervalType], for changing the interval type.
  /// * [dateFormat] for formatting the date labels.
  final SliderStepDuration stepDuration;

  /// Number of smaller ticks between two major ticks.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the major ticks at 0.0, 2.0, 4.0 and so on.
  /// If minorTicksPerInterval is 1, then smaller ticks will be rendered on
  /// 1.0, 3.0 and so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to show minor ticks in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showTicks: true,
  ///   minorTicksPerInterval: 1,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks], to render major ticks at given interval.
  /// * [minorTickShape] and [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing
  /// the minor tick’s visual appearance.
  final int minorTicksPerInterval;

  /// Option to render the major ticks on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the major ticks at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show major ticks in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showTicks: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tickShape] and [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html) for customizing the
  /// major tick’s visual appearance.
  final bool showTicks;

  /// Option to render the labels on given interval.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show labels in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showLabels: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [numberFormat] and [dateFormat], for formatting the numeric and
  /// date labels.
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the appearance of the labels.
  final bool showLabels;

  /// Option to render the divisors on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show divisors in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showDivisors: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  /// * [divisorShape] and [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html) for customizing
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
  /// This snippet shows how to enable tooltip in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tooltipTextFormatterCallback], for changing the default tooltip text.
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the appearance of the tooltip text.
  final bool enableTooltip;

  /// Option to select the particular interval based on
  /// the position of the tap or click.
  ///
  /// Both the thumbs are moved to the selected interval if the
  /// [enableIntervalSelection] property is true,
  /// otherwise the nearest thumb is moved to the touch position.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to enable  selecting the particular interval
  /// in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues  _values = SfRangeValues(40.0, 80.0);
  ///
  /// SfRangeSlider(
  ///    min: 0.0,
  ///    max: 100.0,
  ///    values: _values,
  ///    interval: 20,
  ///    showLabels: true,
  ///    enableTooltip: true,
  ///    enableIntervalSelection: true,
  ///    showTicks: true,
  ///    onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  final bool enableIntervalSelection;

  /// Color applied to the inactive track and active divisors.
  ///
  /// The inactive side of the range slider is between the [min] value and
  /// the left thumb, and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the range slider is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive color in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   inactiveColor: Colors.red,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the individual
  /// inactive range slider element’s visual.
  final Color inactiveColor;

  /// Color applied to the active track, thumb, overlay, and inactive divisors.
  ///
  /// The active side of the range slider is between the start and end thumbs.
  ///
  /// This snippet shows how to set active color in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   activeColor: Colors.red,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the individual active range slider element’s visual.
  final Color activeColor;

  /// Option to place the labels either between the major ticks or
  /// on the major ticks.
  ///
  /// Defaults to [LabelPlacement.onTicks].
  ///
  /// This snippet shows how to set label placement in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///         DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   values: _values,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   labelPlacement: LabelPlacement.betweenTicks,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  final LabelPlacement labelPlacement;

  /// Formats the numeric labels.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set number format in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   numberFormat: NumberFormat(‘\$’),
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [labelFormatterCallback], for formatting the numeric and date labels.
  final NumberFormat numberFormat;

  /// Formats the date labels. It is mandatory for date [SfRangeSlider].
  ///
  /// For date values, the range slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// divisors are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date format in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///         DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   values: _values,
  ///   interval: 1,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [interval], for setting the interval.
  /// * [numberFormat], for formatting the numeric labels.
  /// * [labelFormatterCallback], for formatting the numeric and date label.
  /// * [dateIntervalType], for changing the interval type.
  final DateFormat dateFormat;

  /// The type of date interval. It is mandatory for date [SfRangeSlider].
  ///
  /// It can be years to seconds.
  ///
  /// For date values, the range slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// divisors are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date interval type in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///         DateTime(2002, 01, 01), DateTime(2003, 01, 01));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   values: _values,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  final DateIntervalType dateIntervalType;

  /// Signature for formatting or changing the whole numeric or date label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [values].
  /// * The formatted value based on the numeric or date format
  /// is given by `formattedText`.
  ///
  /// This snippet shows how to set label format in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(100.0, 10000.0);
  ///
  /// SfRangeSlider(
  ///   min: 100.0,
  ///   max: 10000.0,
  ///   values: _values,
  ///   interval: 9000.0,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   labelFormatterCallback: (dynamic actualValue, String formattedText) {
  ///     return actualValue == 10000 ? '\$ $ formattedText +' : '\$ $ formattedText';
  ///   },
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  final LabelFormatterCallback labelFormatterCallback;

  /// Signature for formatting or changing the whole tooltip label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [values].
  /// * The formatted value based on the numeric or date format
  /// is given by `formattedText`.
  ///
  /// This snippet shows how to set tooltip format in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(
  ///      DateTime(2010, 01, 01, 13, 00, 00),
  ///      DateTime(2010, 01, 01, 17, 00, 00));
  ///
  /// SfRangeSlider(
  ///   min: DateTime(2010, 01, 01, 9, 00, 00),
  ///   max: DateTime(2010, 01, 01, 21, 05, 00),
  ///   values: _values,
  ///   interval: 4,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   dateFormat: DateFormat('h a'),
  ///   dateIntervalType: DateIntervalType.hours,
  ///   tooltipTextFormatterCallback:
  ///       (dynamic actualValue, String formattedText) {
  ///     return DateFormat('h:mm a').format(actualValue);
  ///   },
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   },
  /// )
  /// ```
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;

  /// The callback used to create a semantic value from the slider's values.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to
  /// inform users what the currently selected value is with more context.
  ///
  /// In the example below, a range slider for currency values is configured to
  /// announce a value with a currency label.
  ///
  /// SfRangeValues _values = SfRangeValues(40.0, 60.0);
  ///
  /// ```dart
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 100.0,
  ///   values: _values,
  ///   interval: 20,
  ///   stepSize: 10,
  ///   semanticFormatterCallback: (SfRangeValues values) {
  ///     return '${values.start} and ${values.end}';
  ///   }
  ///   onChanged: (dynamic newValues) {
  ///     setState(() {
  ///      _values = newValues;
  ///    });
  ///  },
  ///  )
  /// ```
  final SfRangeSliderSemanticFormatterCallback semanticFormatterCallback;

  /// Base class for [SfRangeSlider] track shapes.
  final SfTrackShape trackShape;

  /// Base class for [SfRangeSlider] divisors shapes.
  final SfDivisorShape divisorShape;

  /// Base class for [SfRangeSlider] overlay shapes.
  final SfOverlayShape overlayShape;

  ///  Base class for [SfRangeSlider] thumb shapes.
  final SfThumbShape thumbShape;

  /// Base class for [SfRangeSlider] major tick shapes.
  final SfTickShape tickShape;

  /// Base class for [SfRangeSlider] minor tick shapes.
  final SfTickShape minorTickShape;

  /// Renders rectangular or paddle shape tooltip.
  ///
  /// Defaults to [SfRectangularTooltipShape]
  ///
  ///```dart
  /// SfRangeValues _values = SfRangeValues(40.0, 60.0);
  ///
  /// SfRangeSlider(
  ///  min: 0.0,
  ///  max:  100.0,
  ///  values: _values,
  ///  showLabels: true,
  ///  showTicks: true,
  ///  interval: 20,
  ///  enableTooltip: true,
  ///  tooltipShape: SfPaddleTooltipShape(),
  ///  onChanged: (SfRangeValues newValues) {
  ///    setState(() {
  ///      _values = newValues;
  ///    });
  ///  },
  /// )
  ///```
  final SfTooltipShape tooltipShape;

  /// Sets the widget inside the left thumb.
  ///
  /// Defaults to `null`.
  ///
  /// It is possible to set any widget inside the left thumb. If the widget
  /// exceeds the size of the thumb, increase the
  /// [SfSliderThemeData.thumbRadius] based on it.
  ///
  /// This snippet shows how to show start thumb icon in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  ///   startThumbIcon:  Icon(
  ///       Icons.home,
  ///       color: Colors.green,
  ///       size: 20.0,
  ///   ),
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [thumbShape], for customizing the thumb shape.
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the individual active range slider element’s visual.
  final Widget startThumbIcon;

  /// Sets the widget inside the right thumb.
  ///
  /// Defaults to `null`.
  ///
  /// It is possible to set any widget inside the right thumb. If the widget
  /// exceeds the size of the thumb, increase the
  /// [SfSliderThemeData.thumbRadius] based on it.
  ///
  /// This snippet shows how to show end thumb icon in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   endThumbIcon:  Icon(
  ///       Icons.home,
  ///       color: Colors.green,
  ///       size: 20.0,
  ///   ),
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [thumbShape], for customizing the thumb shape.
  /// * [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html), for customizing the individual active range slider element’s visual.
  final Widget endThumbIcon;

  @override
  _SfRangeSliderState createState() => _SfRangeSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      values.toDiagnosticsNode(name: 'values'),
    );
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(DoubleProperty('interval', interval));
    properties.add(DoubleProperty('stepSize', stepSize));
    if (stepDuration != null) {
      properties.add(stepDuration.toDiagnosticsNode(name: 'stepDuration'));
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
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (values.start.runtimeType == DateTime) {
      properties.add(StringProperty(
          'dateFormat',
          'Formatted value is ' +
              (dateFormat.format(values.start)).toString()));
    }
    properties.add(
        EnumProperty<DateIntervalType>('dateIntervalType', dateIntervalType));
    properties.add(ObjectFlagProperty<TooltipTextFormatterCallback>.has(
        'tooltipTextFormatterCallback', tooltipTextFormatterCallback));
    properties.add(ObjectFlagProperty<LabelFormatterCallback>.has(
        'labelFormatterCallback', labelFormatterCallback));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'semanticFormatterCallback', semanticFormatterCallback));
  }
}

class _SfRangeSliderState extends State<SfRangeSlider>
    with TickerProviderStateMixin {
  AnimationController overlayStartController;
  AnimationController overlayEndController;
  AnimationController stateController;
  AnimationController startPositionController;
  AnimationController endPositionController;
  AnimationController tooltipAnimationController;
  Timer tooltipDelayTimer;
  RangeController rangeController;
  final Duration duration = const Duration(milliseconds: 100);

  void _onChanged(SfRangeValues values) {
    if (values != widget.values) {
      widget.onChanged(values);
    }
  }

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  SfRangeSliderThemeData _getRangeSliderThemeData(
      ThemeData themeData, bool isActive) {
    SfRangeSliderThemeData rangeSliderThemeData =
        SfRangeSliderTheme.of(context);
    final double minTrackHeight = math.min(
        rangeSliderThemeData.activeTrackHeight,
        rangeSliderThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        rangeSliderThemeData.activeTrackHeight,
        rangeSliderThemeData.inactiveTrackHeight);
    rangeSliderThemeData = rangeSliderThemeData.copyWith(
      activeTrackHeight: rangeSliderThemeData.activeTrackHeight,
      inactiveTrackHeight: rangeSliderThemeData.inactiveTrackHeight,
      tickSize: rangeSliderThemeData.tickSize,
      minorTickSize: rangeSliderThemeData.minorTickSize,
      tickOffset: rangeSliderThemeData.tickOffset,
      labelOffset: rangeSliderThemeData.labelOffset ??
          (widget.showTicks ? const Offset(0.0, 5.0) : const Offset(0.0, 13.0)),
      inactiveLabelStyle: rangeSliderThemeData.inactiveLabelStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1.color.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      activeLabelStyle: rangeSliderThemeData.activeLabelStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1.color.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      tooltipTextStyle: rangeSliderThemeData.tooltipTextStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: rangeSliderThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(255, 255, 255, 1)
                  : const Color.fromRGBO(0, 0, 0, 1)),
      inactiveTrackColor: widget.inactiveColor ??
          rangeSliderThemeData.inactiveTrackColor ??
          themeData.primaryColor.withOpacity(0.24),
      activeTrackColor: widget.activeColor ??
          rangeSliderThemeData.activeTrackColor ??
          themeData.primaryColor,
      thumbColor: widget.activeColor ??
          rangeSliderThemeData.thumbColor ??
          themeData.primaryColor,
      activeTickColor: rangeSliderThemeData.activeTickColor,
      inactiveTickColor: rangeSliderThemeData.inactiveTickColor,
      disabledActiveTickColor: rangeSliderThemeData.disabledActiveTickColor,
      disabledInactiveTickColor: rangeSliderThemeData.disabledInactiveTickColor,
      activeMinorTickColor: rangeSliderThemeData.activeMinorTickColor,
      inactiveMinorTickColor: rangeSliderThemeData.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          rangeSliderThemeData.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          rangeSliderThemeData.disabledInactiveMinorTickColor,
      // ignore: lines_longer_than_80_chars
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          rangeSliderThemeData.overlayColor ??
          themeData.primaryColor.withOpacity(0.12),
      inactiveDivisorColor: widget.activeColor ??
          rangeSliderThemeData.inactiveDivisorColor ??
          themeData.colorScheme.primary.withOpacity(0.54),
      activeDivisorColor: widget.inactiveColor ??
          rangeSliderThemeData.activeDivisorColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.54),
      disabledInactiveDivisorColor:
          rangeSliderThemeData.disabledInactiveDivisorColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledActiveDivisorColor:
          rangeSliderThemeData.disabledActiveDivisorColor ??
              themeData.colorScheme.onPrimary.withOpacity(0.12),
      disabledActiveTrackColor: rangeSliderThemeData.disabledActiveTrackColor ??
          themeData.colorScheme.onSurface.withOpacity(0.32),
      disabledInactiveTrackColor:
          rangeSliderThemeData.disabledInactiveTrackColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledThumbColor: rangeSliderThemeData.disabledThumbColor,
      tooltipBackgroundColor: rangeSliderThemeData.tooltipBackgroundColor ??
          (widget.tooltipShape is SfPaddleTooltipShape
              ? themeData.primaryColor
              : (rangeSliderThemeData.brightness == Brightness.light)
                  ? const Color.fromRGBO(97, 97, 97, 1)
                  : const Color.fromRGBO(224, 224, 224, 1)),
      thumbStrokeColor: rangeSliderThemeData.thumbStrokeColor,
      overlappingThumbStrokeColor:
          rangeSliderThemeData.overlappingThumbStrokeColor ??
              themeData.colorScheme.surface,
      activeDivisorStrokeColor: rangeSliderThemeData.activeDivisorStrokeColor,
      inactiveDivisorStrokeColor:
          rangeSliderThemeData.inactiveDivisorStrokeColor,
      overlappingTooltipStrokeColor:
          rangeSliderThemeData.overlappingTooltipStrokeColor ??
              themeData.colorScheme.surface,
      trackCornerRadius:
          rangeSliderThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: rangeSliderThemeData.thumbRadius,
      overlayRadius: rangeSliderThemeData.overlayRadius,
      activeDivisorRadius:
          rangeSliderThemeData.activeDivisorRadius ?? minTrackHeight / 4,
      inactiveDivisorRadius:
          rangeSliderThemeData.inactiveDivisorRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: rangeSliderThemeData.thumbStrokeWidth,
      activeDivisorStrokeWidth: rangeSliderThemeData.activeDivisorStrokeWidth,
      inactiveDivisorStrokeWidth:
          rangeSliderThemeData.inactiveDivisorStrokeWidth,
    );

    return rangeSliderThemeData;
  }

  @override
  void initState() {
    super.initState();
    overlayStartController =
        AnimationController(vsync: this, duration: duration);
    overlayEndController = AnimationController(vsync: this, duration: duration);
    stateController = AnimationController(vsync: this, duration: duration);
    startPositionController =
        AnimationController(duration: Duration.zero, vsync: this);
    endPositionController =
        AnimationController(duration: Duration.zero, vsync: this);
    tooltipAnimationController =
        AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.onChanged != null && (widget.min != widget.max) ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    overlayStartController?.dispose();
    overlayEndController?.dispose();
    stateController?.dispose();
    startPositionController?.dispose();
    endPositionController?.dispose();
    tooltipAnimationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        widget.onChanged != null && (widget.min != widget.max);
    final ThemeData themeData = Theme.of(context);

    return _RangeSliderRenderObjectWidget(
      key: widget.key,
      min: widget.min,
      max: widget.max,
      values: widget.values,
      onChanged: isActive ? _onChanged : null,
      interval: widget.interval,
      stepSize: widget.stepSize,
      stepDuration: widget.stepDuration,
      minorTicksPerInterval: widget.minorTicksPerInterval ?? 0,
      showTicks: widget.showTicks,
      showLabels: widget.showLabels,
      showDivisors: widget.showDivisors,
      enableTooltip: widget.enableTooltip,
      enableIntervalSelection: widget.enableIntervalSelection,
      inactiveColor:
          widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
      activeColor: widget.activeColor ?? themeData.primaryColor,
      labelPlacement: widget.labelPlacement ?? LabelPlacement.onTicks,
      numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
      dateIntervalType: widget.dateIntervalType,
      dateFormat: widget.dateFormat,
      labelFormatterCallback:
          widget.labelFormatterCallback ?? _getFormattedLabelText,
      tooltipTextFormatterCallback:
          widget.tooltipTextFormatterCallback ?? _getFormattedTooltipText,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      trackShape: widget.trackShape ?? SfTrackShape(),
      divisorShape: widget.divisorShape ?? SfDivisorShape(),
      overlayShape: widget.overlayShape ?? SfOverlayShape(),
      thumbShape: widget.thumbShape ?? SfThumbShape(),
      tickShape: widget.tickShape ?? SfTickShape(),
      minorTickShape: widget.minorTickShape ?? SfMinorTickShape(),
      tooltipShape: widget.tooltipShape ?? SfRectangularTooltipShape(),
      rangeSliderThemeData: _getRangeSliderThemeData(themeData, isActive),
      state: this,
      startThumbIcon: widget.startThumbIcon,
      endThumbIcon: widget.endThumbIcon,
    );
  }
}

class _RangeSliderRenderObjectWidget extends RenderObjectWidget {
  const _RangeSliderRenderObjectWidget(
      {Key key,
      this.min,
      this.max,
      this.values,
      this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval,
      this.showTicks,
      this.showLabels,
      this.showDivisors,
      this.enableTooltip,
      this.enableIntervalSelection,
      this.inactiveColor,
      this.activeColor,
      this.labelPlacement,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape,
      this.divisorShape,
      this.overlayShape,
      this.thumbShape,
      this.tickShape,
      this.minorTickShape,
      this.tooltipShape,
      this.rangeSliderThemeData,
      this.startThumbIcon,
      this.endThumbIcon,
      this.state})
      : super(key: key);

  final dynamic min;
  final dynamic max;
  final SfRangeValues values;
  final ValueChanged<SfRangeValues> onChanged;
  final double interval;
  final double stepSize;
  final SliderStepDuration stepDuration;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDivisors;
  final bool enableTooltip;
  final bool enableIntervalSelection;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final NumberFormat numberFormat;
  final DateIntervalType dateIntervalType;
  final DateFormat dateFormat;
  final SfRangeSliderThemeData rangeSliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final SfRangeSliderSemanticFormatterCallback semanticFormatterCallback;
  final SfDivisorShape divisorShape;
  final SfTrackShape trackShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTooltipShape tooltipShape;
  final Widget startThumbIcon;
  final Widget endThumbIcon;
  final _SfRangeSliderState state;

  @override
  _RenderRangeSliderElement createElement() => _RenderRangeSliderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderRangeSlider(
      min: min,
      max: max,
      values: values,
      onChanged: onChanged,
      interval: interval,
      stepSize: stepSize,
      stepDuration: stepDuration,
      minorTicksPerInterval: minorTicksPerInterval,
      showTicks: showTicks,
      showLabels: showLabels,
      showDivisors: showDivisors,
      enableTooltip: enableTooltip,
      enableIntervalSelection: enableIntervalSelection,
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
      sliderThemeData: rangeSliderThemeData,
      textDirection: Directionality.of(context),
      mediaQueryData: MediaQuery.of(context),
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderRangeSlider renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..values = values
      ..onChanged = onChanged
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDivisors = showDivisors
      ..enableTooltip = enableTooltip
      ..enableIntervalSelection = enableIntervalSelection
      ..inactiveColor = inactiveColor
      ..activeColor = activeColor
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
      ..sliderThemeData = rangeSliderThemeData
      ..textDirection = Directionality.of(context)
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderRangeSliderElement extends RenderObjectElement {
  _RenderRangeSliderElement(_RangeSliderRenderObjectWidget rangeSlider)
      : super(rangeSlider);

  final Map<ChildElements, Element> _slotToChild = <ChildElements, Element>{};

  final Map<Element, ChildElements> _childToSlot = <Element, ChildElements>{};

  @override
  _RangeSliderRenderObjectWidget get widget => super.widget;

  @override
  _RenderRangeSlider get renderObject => super.renderObject;

  void _mountChild(Widget newWidget, ChildElements slot) {
    final Element oldChild = _slotToChild[slot];
    final Element newChild = updateChild(oldChild, newWidget, slot);
    if (oldChild != null) {
      _slotToChild.remove(slot);
      _childToSlot.remove(oldChild);
    }
    if (newChild != null) {
      _slotToChild[slot] = newChild;
      _childToSlot[newChild] = slot;
    }
  }

  void _updateChild(Widget widget, ChildElements slot) {
    final Element oldChild = _slotToChild[slot];
    final Element newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      _childToSlot.remove(oldChild);
      _slotToChild.remove(slot);
    }
    if (newChild != null) {
      _slotToChild[slot] = newChild;
      _childToSlot[newChild] = slot;
    }
  }

  void _updateRenderObject(RenderObject child, ChildElements slot) {
    switch (slot) {
      case ChildElements.startThumbIcon:
        renderObject.startThumbIcon = child;
        break;
      case ChildElements.endThumbIcon:
        renderObject.endThumbIcon = child;
        break;
      case ChildElements.child:
        break;
    }
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _slotToChild.values.forEach(visitor);
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _mountChild(widget.startThumbIcon, ChildElements.startThumbIcon);
    _mountChild(widget.endThumbIcon, ChildElements.endThumbIcon);
  }

  @override
  void update(_RangeSliderRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.startThumbIcon, ChildElements.startThumbIcon);
    _updateChild(widget.endThumbIcon, ChildElements.endThumbIcon);
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
  void removeRenderObjectChild(RenderObject child, dynamic slot) {
    assert(child is RenderBox);
    assert(renderObject.childToSlot.keys.contains(child));
    _updateRenderObject(null, renderObject.childToSlot[child]);
    assert(!renderObject.childToSlot.keys.contains(child));
    assert(!renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false, 'not reachable');
  }
}

class _RenderRangeSlider extends RenderBaseSlider {
  _RenderRangeSlider({
    dynamic min,
    dynamic max,
    SfRangeValues values,
    ValueChanged<SfRangeValues> onChanged,
    double interval,
    double stepSize,
    SliderStepDuration stepDuration,
    int minorTicksPerInterval,
    bool showTicks,
    bool showLabels,
    bool showDivisors,
    bool enableTooltip,
    bool enableIntervalSelection,
    Color inactiveColor,
    Color activeColor,
    LabelPlacement labelPlacement,
    NumberFormat numberFormat,
    DateFormat dateFormat,
    DateIntervalType dateIntervalType,
    LabelFormatterCallback labelFormatterCallback,
    TooltipTextFormatterCallback tooltipTextFormatterCallback,
    SfRangeSliderSemanticFormatterCallback semanticFormatterCallback,
    SfTrackShape trackShape,
    SfDivisorShape divisorShape,
    SfOverlayShape overlayShape,
    SfThumbShape thumbShape,
    SfTickShape tickShape,
    SfTickShape minorTickShape,
    SfTooltipShape tooltipShape,
    SfRangeSliderThemeData sliderThemeData,
    TextDirection textDirection,
    MediaQueryData mediaQueryData,
    @required _SfRangeSliderState state,
  })  : _state = state,
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
            sliderThemeData: sliderThemeData,
            textDirection: textDirection,
            mediaQueryData: mediaQueryData) {
    _values = values;
    _onChanged = onChanged;
    _enableIntervalSelection = enableIntervalSelection;
    _semanticFormatterCallback = semanticFormatterCallback;
    _inactiveColor = inactiveColor;
    _activeColor = activeColor;
    final GestureArenaTeam team = GestureArenaTeam();

    dragGestureRecognizer = HorizontalDragGestureRecognizer()
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

    _tooltipAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationController, curve: Curves.fastOutSlowIn);

    if (isDateTime) {
      _valuesInMilliseconds = SfRangeValues(
          values.start.millisecondsSinceEpoch.toDouble(),
          values.end.millisecondsSinceEpoch.toDouble());
    }
    unformattedLabels = <double>[];
    updateTextPainter();

    if (_enableIntervalSelection) {
      _state.startPositionController.value =
          getFactorFromValue(actualValues.start);
      _state.endPositionController.value = getFactorFromValue(actualValues.end);
    }
  }
  final _SfRangeSliderState _state;

  final Map<ChildElements, RenderBox> slotToChild =
      <ChildElements, RenderBox>{};

  final Map<RenderBox, ChildElements> childToSlot =
      <RenderBox, ChildElements>{};

  Animation<double> _overlayStartAnimation;

  Animation<double> _overlayEndAnimation;

  Animation<double> _stateAnimation;

  Animation<double> _tooltipAnimation;

  SfRangeValues _valuesInMilliseconds;

  // It stores the interaction start x-position at [tapDown] and [dragStart]
  // method, which is used to check whether dragging is started or not.
  double _interactionStartX = 0.0;

  bool _isDragging = false;

  bool _isIntervalTapped = false;

  static const Duration _positionAnimationDuration =
      Duration(milliseconds: 500);

  SfRangeValues get values => _values;
  SfRangeValues _values;
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
    markNeedsPaint();
  }

  ValueChanged<SfRangeValues> get onChanged => _onChanged;
  ValueChanged<SfRangeValues> _onChanged;
  set onChanged(ValueChanged<SfRangeValues> value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.stateController.forward();
      } else {
        _state.stateController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
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

  Color get inactiveColor => _inactiveColor;
  Color _inactiveColor;
  set inactiveColor(Color value) {
    if (_inactiveColor == value) {
      return;
    }
    _inactiveColor = value;
    markNeedsPaint();
  }

  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    if (_activeColor == value) {
      return;
    }
    _activeColor = value;
    markNeedsPaint();
  }

  SfRangeSliderSemanticFormatterCallback get semanticFormatterCallback =>
      _semanticFormatterCallback;
  SfRangeSliderSemanticFormatterCallback _semanticFormatterCallback;
  set semanticFormatterCallback(SfRangeSliderSemanticFormatterCallback value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  RenderBox get startThumbIcon => _startThumbIcon;
  RenderBox _startThumbIcon;
  set startThumbIcon(RenderBox value) {
    _startThumbIcon =
        _updateChild(_startThumbIcon, value, ChildElements.startThumbIcon);
  }

  RenderBox get endThumbIcon => _endThumbIcon;
  RenderBox _endThumbIcon;
  set endThumbIcon(RenderBox value) {
    _endThumbIcon =
        _updateChild(_endThumbIcon, value, ChildElements.endThumbIcon);
  }

  bool get isInteractive => onChanged != null;

  double get minThumbGap =>
      (actualMax - actualMin) * (8 / actualTrackRect.width).clamp(0.0, 1.0);

  SfRangeValues get actualValues =>
      isDateTime ? _valuesInMilliseconds : _values;

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_startThumbIcon != null) {
      yield startThumbIcon;
    }
    if (_endThumbIcon != null) {
      yield endThumbIcon;
    }
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    _interactionStartX = globalToLocal(details.globalPosition).dx;
    currentX = _interactionStartX;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    _interactionStartX = globalToLocal(details.globalPosition).dx;
    currentX = _interactionStartX;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    currentX = globalToLocal(details.globalPosition).dx;
    _updateRangeValues();
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
    final double startPosition =
        getFactorFromValue(actualValues.start) * actualTrackRect.width +
            actualTrackRect.left;
    final double endPosition =
        getFactorFromValue(actualValues.end) * actualTrackRect.width +
            actualTrackRect.left;
    final double leftThumbWidth = (startPosition - currentX).abs();
    final double rightThumbWidth = (endPosition - currentX).abs();

    if (rightThumbWidth == leftThumbWidth) {
      switch (activeThumb) {
        case SfThumb.start:
          _state.overlayStartController.forward();
          break;
        case SfThumb.end:
          _state.overlayEndController.forward();
          break;
      }
    } else {
      if (rightThumbWidth > leftThumbWidth) {
        activeThumb = SfThumb.start;
        _state.overlayStartController.forward();
      } else {
        activeThumb = SfThumb.end;
        _state.overlayEndController.forward();
      }
    }

    _forwardTooltipAnimation();
    isInteractionEnd = false;
    _updateRangeValues();
    markNeedsPaint();
  }

  void _forwardTooltipAnimation() {
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationController.forward();
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
        _state.tooltipAnimationController.status == AnimationStatus.completed) {
      _state.tooltipAnimationController.reverse();
      if (_state.tooltipAnimationController.status ==
          AnimationStatus.dismissed) {
        willDrawTooltip = false;
      }
    }
  }

  void _updateRangeValues() {
    double start;
    double end;
    SfRangeValues newValues;
    final double factor = getFactorFromCurrentPosition();
    if (isDateTime) {
      start = values.start.millisecondsSinceEpoch.toDouble();
      end = values.end.millisecondsSinceEpoch.toDouble();
    } else {
      start = values.start;
      end = values.end;
    }

    final double value = lerpDouble(actualMin, actualMax, factor);
    _isDragging = (_interactionStartX - currentX).abs() > 1;
    _isIntervalTapped = _enableIntervalSelection && !_isDragging;

    if (!_isIntervalTapped) {
      switch (activeThumb) {
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

      if (newValues.start != _values.start || newValues.end != _values.end) {
        onChanged(newValues);
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
              lerpDouble(actualMin, actualMax, getFactorFromCurrentPosition());
          final SfRangeValues newValues = _getSelectedRange(value);
          _updatePositionControllerValue(newValues);
          onChanged(newValues);
        }
      }

      _isDragging = false;
      currentPointerType = PointerType.up;
      _state.overlayStartController.reverse();
      _state.overlayEndController.reverse();
      if (enableTooltip && _state.tooltipDelayTimer == null) {
        _state.tooltipAnimationController.reverse();
      }

      isInteractionEnd = true;
      markNeedsPaint();
    }
  }

  void _updatePositionControllerValue(SfRangeValues newValues) {
    DateTime startDate;
    DateTime endDate;

    if (isDateTime) {
      startDate = newValues.start;
      endDate = newValues.end;
    }
    final double startValueFactor = getFactorFromValue(isDateTime
        ? startDate.millisecondsSinceEpoch.toDouble()
        : newValues.start);
    final double endValueFactor = getFactorFromValue(
        isDateTime ? endDate.millisecondsSinceEpoch.toDouble() : newValues.end);

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

  SfRangeValues _getSelectedRange(double value) {
    SfRangeValues rangeValues;
    dynamic start;
    dynamic end;

    for (int i = 0; i < divisions; i++) {
      final double currentLabel = unformattedLabels[i];
      if (i < divisions - 1) {
        final double nextLabel = unformattedLabels[i + 1];
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
        end = max;
        rangeValues = SfRangeValues(start, end);
      }
    }
    return rangeValues;
  }

  RenderBox _updateChild(
      RenderBox oldChild, RenderBox newChild, ChildElements slot) {
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

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _drawOverlayAndThumb(
    PaintingContext context,
    Offset endThumbCenter,
    Offset startThumbCenter,
  ) {
    final bool isLeftThumbActive = activeThumb == SfThumb.start;
    Offset thumbCenter = isLeftThumbActive ? endThumbCenter : startThumbCenter;
    RenderBox thumbIcon = isLeftThumbActive ? _endThumbIcon : _startThumbIcon;
    // Ignore overlapping thumb stroke for bottom thumb.
    showOverlappingThumbStroke = false;
    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: thumbIcon,
        themeData: sliderThemeData,
        currentValues: _values,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: isLeftThumbActive ? SfThumb.end : SfThumb.start);

    thumbCenter = isLeftThumbActive ? startThumbCenter : endThumbCenter;
    thumbIcon = isLeftThumbActive ? _startThumbIcon : _endThumbIcon;
    // Drawing overlay.
    overlayShape.paint(context, thumbCenter,
        parentBox: this,
        themeData: sliderThemeData,
        currentValues: _values,
        animation:
            isLeftThumbActive ? _overlayStartAnimation : _overlayEndAnimation,
        thumb: activeThumb);

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
        thumb: activeThumb);
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
        ..color = sliderThemeData.tooltipBackgroundColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      Offset thumbCenter =
          activeThumb == SfThumb.start ? endThumbCenter : startThumbCenter;
      dynamic actualText = getValueFromPosition(thumbCenter.dx - offset.dx);
      String tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      TextSpan textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      Rect bottomTooltipRect;
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

      // Ignore overlapping tooltip stroke for bottom tooltip.
      showOverlappingTooltipStroke = false;
      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: _tooltipAnimation,
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

      Rect topTooltipRect;
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
          animation: _tooltipAnimation,
          trackRect: trackRect);
    }
  }

  void _increaseStartAction() {
    if (isInteractive) {
      final SfRangeValues actualNewValues = SfRangeValues(
          _increaseValue(values.start, actualValues.start), values.end);
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        onChanged(actualNewValues);
      }
    }
  }

  void _decreaseStartAction() {
    if (isInteractive) {
      onChanged(SfRangeValues(
          _decreaseValue(values.start, actualValues.start), values.end));
    }
  }

  void _increaseEndAction() {
    if (isInteractive) {
      onChanged(SfRangeValues(
          values.start, _increaseValue(values.end, actualValues.end)));
    }
  }

  void _decreaseEndAction() {
    if (isInteractive) {
      final SfRangeValues actualNewValues = SfRangeValues(
          values.start, _decreaseValue(values.end, actualValues.end));
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        onChanged(actualNewValues);
      }
    }
  }

  dynamic _increaseValue(dynamic value, double actualValue) {
    return getNextSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  dynamic _decreaseValue(dynamic value, double actualValue) {
    return getPrevSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  @override
  void performLayout() {
    super.performLayout();

    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: sliderThemeData.thumbRadius * 2,
        height: sliderThemeData.thumbRadius * 2);
    startThumbIcon?.layout(contentConstraints, parentUsesSize: true);
    endThumbIcon?.layout(contentConstraints, parentUsesSize: true);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _overlayStartAnimation?.addListener(markNeedsPaint);
    _overlayEndAnimation?.addListener(markNeedsPaint);
    _stateAnimation?.addListener(markNeedsPaint);
    _state.startPositionController?.addListener(markNeedsPaint);
    _state.endPositionController?.addListener(markNeedsPaint);
    _tooltipAnimation?.addListener(markNeedsPaint);
    _tooltipAnimation?.addStatusListener(_handleTooltipAnimationStatusChange);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _overlayStartAnimation?.removeListener(markNeedsPaint);
    _overlayEndAnimation?.removeListener(markNeedsPaint);
    _stateAnimation?.removeListener(markNeedsPaint);
    _state.startPositionController?.removeListener(markNeedsPaint);
    _state.endPositionController?.removeListener(markNeedsPaint);
    _tooltipAnimation?.removeListener(markNeedsPaint);
    _tooltipAnimation
        ?.removeStatusListener(_handleTooltipAnimationStatusChange);
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
  bool hitTestSelf(Offset position) => isInteractive;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset actualTrackOffset = Offset(
        offset.dx,
        offset.dy +
            (size.height - actualHeight) / 2 +
            trackOffset.dy -
            maxTrackHeight / 2);

    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbStartPosition = getFactorFromValue(_isIntervalTapped
            ? getValueFromFactor(_state.startPositionController.value)
            : actualValues.start) *
        trackRect.width;
    final double thumbEndPosition = getFactorFromValue(_isIntervalTapped
            ? getValueFromFactor(_state.endPositionController.value)
            : actualValues.end) *
        trackRect.width;
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
        textDirection: textDirection);

    if (showLabels || showTicks || showDivisors) {
      drawLabelsTicksAndDivisors(context, trackRect, offset, null,
          startThumbCenter, endThumbCenter, _stateAnimation, null, _values);
    }

    _drawOverlayAndThumb(context, endThumbCenter, startThumbCenter);
    _drawTooltip(context, endThumbCenter, startThumbCenter, offset,
        actualTrackOffset, trackRect);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.textDirection = textDirection;
      config.customSemanticsActions = <CustomSemanticsAction, VoidCallback>{
        const CustomSemanticsAction(label: 'Decrease start value'):
            _decreaseStartAction,
        const CustomSemanticsAction(label: 'Increase start value'):
            _increaseStartAction,
        const CustomSemanticsAction(label: 'Decrease end value'):
            _decreaseEndAction,
        const CustomSemanticsAction(label: 'Increase end value'):
            _increaseEndAction,
      };

      assert(actualValues.start <= actualValues.end);
      if (_semanticFormatterCallback != null) {
        config.value = _semanticFormatterCallback(values);
      } else {
        config.value =
            // ignore: lines_longer_than_80_chars
            'The start value is ${values.start} and the end value is ${values.end}';
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
