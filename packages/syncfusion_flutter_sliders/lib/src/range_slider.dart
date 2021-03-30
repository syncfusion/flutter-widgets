import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
/// It supports horizontal and vertical orientations.
/// It also supports both numeric and date ranges.
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
  /// Creates a horizontal [SfRangeSlider].
  const SfRangeSlider(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.values,
      required this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDivisors = false,
      this.enableTooltip = false,
      this.enableIntervalSelection = false,
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
      this.endThumbIcon})
      : _sliderType = SliderType.horizontal,
        _tooltipPosition = null,
        assert(min != null),
        assert(max != null),
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// Creates a vertical [SfRangeSlider].
  ///
  /// ## TooltipPosition
  ///
  /// Enables tooltip in left or right position for vertical range slider.
  ///
  /// ## Example
  ///
  /// This snippet shows how to create a vertical SfRangeSlider with
  /// right side tooltip
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues (30,60));
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///      home: Scaffold(
  ///          body: Center(
  ///              child: SfRangeSlider.vertical(
  ///                   min: 10.0,
  ///                   max: 100.0,
  ///                     values: _values,
  ///                     enableTooltip: true,
  ///                     tooltipPosition: SliderTooltipPosition.right,
  ///                     onChanged: (dynamic newValues) {
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
  /// See also:
  ///
  /// * Check the default constructor for horizontal range slider.
  const SfRangeSlider.vertical(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.values,
      required this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDivisors = false,
      this.enableTooltip = false,
      this.enableIntervalSelection = false,
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
      SliderTooltipPosition tooltipPosition = SliderTooltipPosition.left})
      : _sliderType = SliderType.vertical,
        _tooltipPosition = tooltipPosition,
        assert(tooltipShape is! SfPaddleTooltipShape),
        assert(min != null),
        assert(max != null),
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// This is used to determine the type of the range slider which is
  /// horizontal or vertical.
  final SliderType _sliderType;

  /// This is only applicable for vertical range sliders.
  final SliderTooltipPosition? _tooltipPosition;

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
  final ValueChanged<SfRangeValues>? onChanged;

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
  final double? interval;

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
  final double? stepSize;

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
  final SliderStepDuration? stepDuration;

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
  final Color? inactiveColor;

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
  final Color? activeColor;

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
  final NumberFormat? numberFormat;

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
  final DateFormat? dateFormat;

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
  final DateIntervalType? dateIntervalType;

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
  final LabelFormatterCallback? labelFormatterCallback;

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
  final TooltipTextFormatterCallback? tooltipTextFormatterCallback;

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
  ///   semanticFormatterCallback: (dynamic value, SfThumb thumb) {
  ///     return 'The $thumb value is ${value}';
  ///   }
  ///   onChanged: (dynamic newValues) {
  ///     setState(() {
  ///      _values = newValues;
  ///    });
  ///  },
  ///  )
  /// ```
  final RangeSliderSemanticFormatterCallback? semanticFormatterCallback;

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
  final Widget? startThumbIcon;

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
  final Widget? endThumbIcon;

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
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (values.start.runtimeType == DateTime && dateFormat != null) {
      properties.add(StringProperty(
          'dateFormat',
          'Formatted value is ' +
              (dateFormat!.format(values.start)).toString()));
    }
    properties.add(
        EnumProperty<DateIntervalType>('dateIntervalType', dateIntervalType));
    properties.add(ObjectFlagProperty<TooltipTextFormatterCallback>.has(
        'tooltipTextFormatterCallback', tooltipTextFormatterCallback));
    properties.add(ObjectFlagProperty<LabelFormatterCallback>.has(
        'labelFormatterCallback', labelFormatterCallback));
    properties.add(ObjectFlagProperty<RangeSliderSemanticFormatterCallback>.has(
        'semanticFormatterCallback', semanticFormatterCallback));
  }
}

class _SfRangeSliderState extends State<SfRangeSlider>
    with TickerProviderStateMixin {
  late AnimationController overlayStartController;
  late AnimationController overlayEndController;
  late AnimationController stateController;
  late AnimationController startPositionController;
  late AnimationController endPositionController;
  late AnimationController tooltipAnimationStartController;
  late AnimationController tooltipAnimationEndController;
  late RangeController rangeController;
  final Duration duration = const Duration(milliseconds: 100);
  Timer? tooltipDelayTimer;

  void _onChanged(SfRangeValues values) {
    if (values != widget.values) {
      widget.onChanged!(values);
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
        SfRangeSliderTheme.of(context)!;
    final double minTrackHeight = math.min(
        rangeSliderThemeData.activeTrackHeight,
        rangeSliderThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        rangeSliderThemeData.activeTrackHeight,
        rangeSliderThemeData.inactiveTrackHeight);
    rangeSliderThemeData = rangeSliderThemeData.copyWith(
      activeTrackHeight: rangeSliderThemeData.activeTrackHeight,
      inactiveTrackHeight: rangeSliderThemeData.inactiveTrackHeight,
      tickOffset: rangeSliderThemeData.tickOffset,
      inactiveLabelStyle: rangeSliderThemeData.inactiveLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      activeLabelStyle: rangeSliderThemeData.activeLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      tooltipTextStyle: rangeSliderThemeData.tooltipTextStyle ??
          themeData.textTheme.bodyText1!.copyWith(
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

    if (widget._sliderType == SliderType.vertical) {
      return rangeSliderThemeData.copyWith(
          tickSize: rangeSliderThemeData.tickSize ?? const Size(8.0, 1.0),
          minorTickSize:
              rangeSliderThemeData.minorTickSize ?? const Size(5.0, 1.0),
          labelOffset: rangeSliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(5.0, 0.0)
                  : const Offset(13.0, 0.0)));
    } else {
      return rangeSliderThemeData.copyWith(
          tickSize: rangeSliderThemeData.tickSize ?? const Size(1.0, 8.0),
          minorTickSize:
              rangeSliderThemeData.minorTickSize ?? const Size(1.0, 5.0),
          labelOffset: rangeSliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(0.0, 5.0)
                  : const Offset(0.0, 13.0)));
    }
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
    tooltipAnimationStartController =
        AnimationController(vsync: this, duration: duration);
    tooltipAnimationEndController =
        AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.onChanged != null && (widget.min != widget.max) ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    overlayStartController.dispose();
    overlayEndController.dispose();
    stateController.dispose();
    startPositionController.dispose();
    endPositionController.dispose();
    tooltipAnimationStartController.dispose();
    tooltipAnimationEndController.dispose();
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
      minorTicksPerInterval: widget.minorTicksPerInterval,
      showTicks: widget.showTicks,
      showLabels: widget.showLabels,
      showDivisors: widget.showDivisors,
      enableTooltip: widget.enableTooltip,
      enableIntervalSelection: widget.enableIntervalSelection,
      inactiveColor:
          widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
      activeColor: widget.activeColor ?? themeData.primaryColor,
      labelPlacement: widget.labelPlacement,
      numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
      dateIntervalType: widget.dateIntervalType,
      dateFormat: widget.dateFormat,
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
      rangeSliderThemeData: _getRangeSliderThemeData(themeData, isActive),
      state: this,
      sliderType: widget._sliderType,
      tooltipPosition: widget._tooltipPosition,
      startThumbIcon: widget.startThumbIcon,
      endThumbIcon: widget.endThumbIcon,
    );
  }
}

class _RangeSliderRenderObjectWidget extends RenderObjectWidget {
  const _RangeSliderRenderObjectWidget(
      {Key? key,
      required this.min,
      required this.max,
      required this.values,
      required this.onChanged,
      required this.interval,
      required this.stepSize,
      required this.stepDuration,
      required this.minorTicksPerInterval,
      required this.showTicks,
      required this.showLabels,
      required this.showDivisors,
      required this.enableTooltip,
      required this.enableIntervalSelection,
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
      required this.rangeSliderThemeData,
      required this.startThumbIcon,
      required this.endThumbIcon,
      required this.state,
      required this.tooltipPosition,
      required this.sliderType})
      : super(key: key);
  final SliderType sliderType;
  final SliderTooltipPosition? tooltipPosition;
  final dynamic min;
  final dynamic max;
  final SfRangeValues values;
  final ValueChanged<SfRangeValues>? onChanged;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
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
  final DateIntervalType? dateIntervalType;
  final DateFormat? dateFormat;
  final SfRangeSliderThemeData rangeSliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final RangeSliderSemanticFormatterCallback? semanticFormatterCallback;
  final SfDivisorShape divisorShape;
  final SfTrackShape trackShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTooltipShape tooltipShape;
  final Widget? startThumbIcon;
  final Widget? endThumbIcon;
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
      sliderType: sliderType,
      tooltipPosition: tooltipPosition,
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
      ..tooltipPosition = tooltipPosition
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
  _RangeSliderRenderObjectWidget get widget =>
      // ignore: avoid_as
      super.widget as _RangeSliderRenderObjectWidget;

  @override
  _RenderRangeSlider get renderObject =>
      // ignore: avoid_as
      super.renderObject as _RenderRangeSlider;

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
  }

  @override
  void update(_RangeSliderRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.startThumbIcon, ChildElements.startThumbIcon);
    _updateChild(widget.endThumbIcon, ChildElements.endThumbIcon);
  }

  @override
  void insertRenderObjectChild(RenderObject child, ChildElements slotValue) {
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

class _RenderRangeSlider extends RenderBaseSlider
    implements MouseTrackerAnnotation {
  _RenderRangeSlider({
    required dynamic min,
    required dynamic max,
    required SfRangeValues values,
    required ValueChanged<SfRangeValues>? onChanged,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDivisors,
    required bool enableTooltip,
    required bool enableIntervalSelection,
    required Color inactiveColor,
    required Color activeColor,
    required LabelPlacement labelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required RangeSliderSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDivisorShape divisorShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfRangeSliderThemeData sliderThemeData,
    required SliderType sliderType,
    required SliderTooltipPosition? tooltipPosition,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
    required _SfRangeSliderState state,
  })   : _state = state,
        _values = values,
        _onChanged = onChanged,
        _enableIntervalSelection = enableIntervalSelection,
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
            sliderThemeData: sliderThemeData,
            sliderType: sliderType,
            tooltipPosition: tooltipPosition,
            textDirection: textDirection,
            mediaQueryData: mediaQueryData) {
    final GestureArenaTeam team = GestureArenaTeam();

    if (sliderType == SliderType.horizontal) {
      horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
        ..team = team
        ..onStart = _onDragStart
        ..onUpdate = _onDragUpdate
        ..onEnd = _onDragEnd
        ..onCancel = _onDragCancel;
    }

    if (sliderType == SliderType.vertical) {
      verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
        ..team = team
        ..onStart = _onVerticalDragStart
        ..onUpdate = _onVerticalDragUpdate
        ..onEnd = _onVerticalDragEnd
        ..onCancel = _onVerticalDragCancel;
    }

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

  late Animation<double> _overlayStartAnimation;

  late Animation<double> _overlayEndAnimation;

  late Animation<double> _stateAnimation;

  late Animation<double> _tooltipStartAnimation;

  late Animation<double> _tooltipEndAnimation;

  SfRangeValues? _valuesInMilliseconds;

  // It stores the interaction start it's main axis at [tapDown] and [dragStart]
  // method, which is used to check whether dragging is started or not.
  double _interactionStartOffset = 0.0;

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

  ValueChanged<SfRangeValues>? get onChanged => _onChanged;
  ValueChanged<SfRangeValues>? _onChanged;

  set onChanged(ValueChanged<SfRangeValues>? value) {
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

  RangeSliderSemanticFormatterCallback? get semanticFormatterCallback =>
      _semanticFormatterCallback;

  RangeSliderSemanticFormatterCallback? _semanticFormatterCallback;

  set semanticFormatterCallback(RangeSliderSemanticFormatterCallback? value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
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

  SfThumb? get activeThumb => _activeThumb;
  SfThumb? _activeThumb;

  set activeThumb(SfThumb? value) {
    // Ensuring whether the animation is already completed
    // and calling controller's forward again is not needed.
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

  bool get isInteractive => onChanged != null;

  double get minThumbGap => sliderType == SliderType.vertical
      ? (actualMax - actualMin) * (8 / actualTrackRect.height).clamp(0.0, 1.0)
      : (actualMax - actualMin) * (8 / actualTrackRect.width).clamp(0.0, 1.0);

  SfRangeValues get actualValues =>
      isDateTime ? _valuesInMilliseconds! : _values;

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

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_startThumbIcon != null) {
      yield startThumbIcon!;
    }
    if (_endThumbIcon != null) {
      yield endThumbIcon!;
    }
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    _interactionStartOffset = (sliderType == SliderType.vertical
        ? globalToLocal(details.globalPosition).dy
        : globalToLocal(details.globalPosition).dx);
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    _interactionStartOffset = globalToLocal(details.globalPosition).dx;
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _updateRangeValues();
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _interactionStartOffset = globalToLocal(details.globalPosition).dy;
    mainAxisOffset = _interactionStartOffset;
    _beginInteraction();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _updateRangeValues();
    markNeedsPaint();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onVerticalDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    // This field is used in the [paint] method to handle the
    // interval selection animation, so we can't reset this
    // field in [endInteraction] method.
    _isIntervalTapped = false;
    final double startPosition = sliderType == SliderType.vertical
        ? actualTrackRect.bottom -
            getFactorFromValue(actualValues.start) * actualTrackRect.height
        : getFactorFromValue(actualValues.start) * actualTrackRect.width +
            actualTrackRect.left;
    final double endPosition = sliderType == SliderType.vertical
        ? actualTrackRect.bottom -
            getFactorFromValue(actualValues.end) * actualTrackRect.height
        : getFactorFromValue(actualValues.end) * actualTrackRect.width +
            actualTrackRect.left;
    final double leftThumbWidth = (startPosition - mainAxisOffset).abs();
    final double rightThumbWidth = (endPosition - mainAxisOffset).abs();

    if (rightThumbWidth == leftThumbWidth) {
      switch (activeThumb!) {
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

    final double value = lerpDouble(actualMin, actualMax, factor)!;
    _isDragging = (_interactionStartOffset - mainAxisOffset).abs() > 1;
    _isIntervalTapped = _enableIntervalSelection && !_isDragging;

    if (!_isIntervalTapped) {
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
      if (newValues.start != _values.start || newValues.end != _values.end) {
        onChanged!(newValues);
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
          final double? value =
              lerpDouble(actualMin, actualMax, getFactorFromCurrentPosition());
          final SfRangeValues newValues = _getSelectedRange(value!);
          _updatePositionControllerValue(newValues);
          onChanged!(newValues);
        }
      }

      _isDragging = false;
      currentPointerType = PointerType.up;
      _state.overlayStartController.reverse();
      _state.overlayEndController.reverse();
      if (enableTooltip && _state.tooltipDelayTimer == null) {
        _state.tooltipAnimationStartController.reverse();
        _state.tooltipAnimationEndController.reverse();
      }

      isInteractionEnd = true;
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

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (_state.tooltipAnimationStartController.status ==
            AnimationStatus.dismissed &&
        _state.tooltipAnimationEndController.status ==
            AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _drawOverlayAndThumb(
    PaintingContext context,
    Offset endThumbCenter,
    Offset startThumbCenter,
  ) {
    final bool isStartThumbActive = activeThumb == SfThumb.start;
    Offset thumbCenter = isStartThumbActive ? endThumbCenter : startThumbCenter;
    RenderBox? thumbIcon = isStartThumbActive ? _endThumbIcon : _startThumbIcon;
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
        thumb: isStartThumbActive ? SfThumb.end : SfThumb.start,
        paint: null);

    thumbCenter = isStartThumbActive ? startThumbCenter : endThumbCenter;
    thumbIcon = isStartThumbActive ? _startThumbIcon : _endThumbIcon;
    // Drawing overlay.
    overlayShape.paint(
      context,
      thumbCenter,
      parentBox: this,
      themeData: sliderThemeData,
      currentValues: _values,
      animation:
          isStartThumbActive ? _overlayStartAnimation : _overlayEndAnimation,
      thumb: activeThumb,
      paint: null,
    );
    showOverlappingThumbStroke = (getFactorFromValue(actualValues.start) -
                    getFactorFromValue(actualValues.end))
                .abs() *
            (sliderType == SliderType.vertical
                ? actualTrackRect.height
                : actualTrackRect.width) <
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

      final bool isStartThumbActive = activeThumb == SfThumb.start;
      Offset thumbCenter =
          isStartThumbActive ? endThumbCenter : startThumbCenter;
      dynamic actualText = (sliderType == SliderType.vertical)
          ? getValueFromPosition(trackRect.bottom - thumbCenter.dy)
          : getValueFromPosition(thumbCenter.dx - offset.dx);

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

      // Ignore overlapping tooltip stroke for bottom tooltip.
      showOverlappingTooltipStroke = false;
      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: isStartThumbActive
              ? _tooltipEndAnimation
              : _tooltipStartAnimation,
          trackRect: trackRect);

      thumbCenter = isStartThumbActive ? startThumbCenter : endThumbCenter;
      actualText = (sliderType == SliderType.vertical)
          ? getValueFromPosition(trackRect.bottom - thumbCenter.dy)
          : getValueFromPosition(thumbCenter.dx - offset.dx);

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
        showOverlappingTooltipStroke = sliderType == SliderType.vertical
            ? overlapRect.top < overlapRect.bottom
            : overlapRect.right > overlapRect.left;
      }

      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: isStartThumbActive
              ? _tooltipStartAnimation
              : _tooltipEndAnimation,
          trackRect: trackRect);
    }
  }

  void _increaseStartAction() {
    if (isInteractive) {
      final SfRangeValues actualNewValues =
          SfRangeValues(_increasedStartValue, values.end);
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        onChanged!(actualNewValues);
      }
    }
  }

  void _decreaseStartAction() {
    if (isInteractive) {
      onChanged!(SfRangeValues(_decreasedStartValue, values.end));
    }
  }

  void _increaseEndAction() {
    if (isInteractive) {
      onChanged!(SfRangeValues(values.start, _increasedEndValue));
    }
  }

  void _decreaseEndAction() {
    if (isInteractive) {
      final SfRangeValues actualNewValues =
          SfRangeValues(values.start, _decreasedEndValue);
      final SfRangeValues newValues = isDateTime
          ? SfRangeValues(
              actualNewValues.start.millisecondsSinceEpoch.toDouble(),
              actualNewValues.end.millisecondsSinceEpoch.toDouble())
          : actualNewValues;

      if (newValues.start <= newValues.end) {
        onChanged!(actualNewValues);
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
    cursorPosition = sliderType == SliderType.vertical
        ? details.localPosition.dy
        : details.localPosition.dx;
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
    _overlayStartAnimation.addListener(markNeedsPaint);
    _overlayEndAnimation.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
    _state.startPositionController.addListener(markNeedsPaint);
    _state.endPositionController.addListener(markNeedsPaint);
    _tooltipStartAnimation.addListener(markNeedsPaint);
    _tooltipStartAnimation
        .addStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.addListener(markNeedsPaint);
    _tooltipEndAnimation.addStatusListener(_handleTooltipAnimationStatusChange);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _overlayStartAnimation.removeListener(markNeedsPaint);
    _overlayEndAnimation.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    _state.startPositionController.removeListener(markNeedsPaint);
    _state.endPositionController.removeListener(markNeedsPaint);
    _tooltipStartAnimation.removeListener(markNeedsPaint);
    _tooltipStartAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
    _tooltipEndAnimation.removeListener(markNeedsPaint);
    _tooltipEndAnimation
        .removeStatusListener(_handleTooltipAnimationStatusChange);
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
      return onHover(event);
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestSelf(Offset position) => isInteractive;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset actualTrackOffset = sliderType == SliderType.vertical
        ? Offset(
            offset.dx +
                (size.width - actualHeight) / 2 +
                trackOffset.dy -
                maxTrackHeight / 2,
            offset.dy)
        : Offset(
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
        (sliderType == SliderType.vertical
            ? trackRect.height
            : trackRect.width);
    final double thumbEndPosition = getFactorFromValue(_isIntervalTapped
            ? getValueFromFactor(_state.endPositionController.value)
            : actualValues.end) *
        (sliderType == SliderType.vertical
            ? trackRect.height
            : trackRect.width);
    final Offset startThumbCenter = sliderType == SliderType.vertical
        ? Offset(trackRect.center.dx, trackRect.bottom - thumbStartPosition)
        : Offset(trackRect.left + thumbStartPosition, trackRect.center.dy);
    final Offset endThumbCenter = sliderType == SliderType.vertical
        ? Offset(trackRect.center.dx, trackRect.bottom - thumbEndPosition)
        : Offset(trackRect.left + thumbEndPosition, trackRect.center.dy);
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
          startThumbCenter, endThumbCenter, _stateAnimation, null, _values);
    }

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
      config.increasedValue = 'the  $thumbValue value is $increasedValue';
      config.decreasedValue = 'the  $thumbValue value is $decreasedValue';
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
    final Rect startRect = sliderType == SliderType.vertical
        ? Rect.fromPoints(node.rect.bottomRight, node.rect.centerLeft)
        : Rect.fromPoints(node.rect.topLeft, node.rect.bottomCenter);
    final Rect endRect = sliderType == SliderType.vertical
        ? Rect.fromPoints(node.rect.centerLeft, node.rect.topRight)
        : Rect.fromPoints(node.rect.topCenter, node.rect.bottomRight);
    if (sliderType == SliderType.vertical ||
        textDirection == TextDirection.ltr) {
      _startSemanticsNode!.rect = startRect;
      _endSemanticsNode!.rect = endRect;
    } else {
      _startSemanticsNode!.rect = endRect;
      _endSemanticsNode!.rect = startRect;
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
    config.isSemanticBoundary = isInteractive;
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
