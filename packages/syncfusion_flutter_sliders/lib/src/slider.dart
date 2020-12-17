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
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'render_slider_base.dart';
import 'slider_shapes.dart';

/// A Material Design slider.
///
/// Used to select a value between [min] and [max].
/// It supports both numeric and date values.
///
/// The slider elements are:
///
/// * The "track", which is the rounded rectangle in which
/// the thumb is slides over.
/// * The "thumb", which is a shape that slides horizontally when
/// the user drags it.
/// * The "active" side of the slider is between the [min] value and thumb.
/// * The "inactive" side of the slider is between the thumb and
/// the [max] value.
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
/// The slider will be disabled if [onChanged] is null or
/// [min] is equal to [max].
///
/// The slider widget doesn’t maintains any state.
/// Alternatively, the widget calls the [onChanged] callback with a new value
/// when the state of slider changes. To update the slider’s visual
/// appearance with a new value, rebuilds the slider with a new value.
///
/// Slider can be customized using the [SfSliderTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderTheme-class.html) with the help of [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), or the [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) with the help of [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html).
/// It is also possible to override the appearance using [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html) which were set using the properties of the widget like [activeColor] and [inactiveColor].
///
/// ## Example
///
/// This snippet shows how to create a numeric [SfSlider].
///
/// ```dart
/// double _value = 4.0;
///
/// @override
/// Widget build(BuildContext context) {
///   return MaterialApp(
///      home: Scaffold(
///          body: Center(
///              child: SfSlider(
///                     min: 0.0,
///                     max: 10.0,
///                     value: _value,
///                     onChanged: (dynamic newValue) {
///                         setState(() {
///                             _value = newValue;
///                         });
///                   },
///              )
///           )
///       )
///   );
/// }
/// ```
///
/// This snippet shows how to create a date [SfSlider].
///
/// ```dart
/// DateTime _value = DateTime(2002, 01, 01);
///
/// SfSlider(
///  min: DateTime(2000, 01, 01, 00),
///  max: DateTime(2005, 12, 31, 24),
///  value: _value,
///  interval: 1,
///  dateFormat: DateFormat.y(),
/// dateIntervalType: DateIntervalType.years,
///  onChanged: (dynamic newValue) {
///    setState(() {
///      _value = newValue;
///    });
///  },
/// )
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html), for customizing the visual appearance of the slider.
/// * [numberFormat] and [dateFormat], for formatting the numeric and
/// date labels.
/// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the visual appearance of the slider.
class SfSlider extends StatefulWidget {
  /// Creates a [SfSlider].
  const SfSlider(
      {Key key,
      this.min = 0.0,
      this.max = 1.0,
      @required this.value,
      @required this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval,
      this.showTicks = false,
      this.showLabels = false,
      this.showDivisors = false,
      this.enableTooltip = false,
      this.activeColor,
      this.inactiveColor,
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
      this.thumbIcon})
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

  /// The value currently selected in the slider.
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType], and
  /// [dateFormat] for date value,
  /// if the labels, ticks, and divisors are needed.
  ///
  /// This snippet shows how to create a numeric [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// This snippet shows how to create a date [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2002, 01, 01);
  ///
  /// SfSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   value: _value,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///      _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [onChanged], to update the visual appearance of
  /// the slider when the user drags the thumb through interaction.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final dynamic value;

  /// Called when the user is selecting a new value for the slider by dragging.
  ///
  /// The slider passes the new value to the callback but
  /// does not change its state until the parent widget rebuilds
  /// the slider with new value.
  ///
  /// If it is null, the slider will be disabled.
  ///
  /// This snippet shows how to create a numeric [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<dynamic> onChanged;

  /// Splits the slider into given interval.
  /// It is mandatory if labels, major ticks and divisors are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the slider will render the labels, major ticks,
  /// and divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date value, if labels, ticks, and
  /// divisors are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is DateIntervalType.years, then the slider will render
  /// the labels, major ticks, and divisors at 2000, 2001, 2002 and so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to set numeric interval in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// This snippet shows how to set date interval in [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2002, 01, 01);
  ///
  /// SfSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   value: _value,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///      _value = newValue;
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

  /// Option to select discrete value.
  ///
  /// [stepSize] doesn’t work for [DateTime] slider.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [stepSize] is 2.0,
  /// the slider will move the thumb at 0.0, 2.0, 4.0, 6.0, 8.0 and 10.0.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to set numeric stepSize in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   stepSize: 2,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  final double stepSize;

  /// Option to select discrete date values.
  ///
  /// For example, if [min] is `DateTime(2015, 01, 01)` and
  /// [max] is `DateTime(2020, 01, 01)` and
  /// [stepDuration] is `SliderDuration(years: 1, months: 6)`,
  /// the slider will move the thumb at DateTime(2015, 01, 01),
  /// DateTime(2016, 07, 01), DateTime(2018, 01, 01),and DateTime(2019, 07, 01).
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set stepDuration in [SfSlider].
  ///
  /// ```dart
  ///
  /// DateTime _value = DateTime(2017, 04,01);
  ///
  ///   SfSlider(
  ///      min: DateTime(2015, 01, 01),
  ///      max: DateTime(2020, 01, 01),
  ///      value: _value,
  ///      enableTooltip: true,
  ///      stepDuration: SliderDuration(years: 1, months: 6),
  ///      interval: 2,
  ///      showLabels: true,
  ///      showTicks: true,
  ///      minorTicksPerInterval: 1,
  ///      dateIntervalType: DateIntervalType.years,
  ///      dateFormat: DateFormat.yMd(),
  ///     onChanged: (dynamic newValue) {
  ///       setState(() {
  ///         _value = newValue;
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
  /// the slider will render the major ticks at 0.0, 2.0, 4.0 and so on.
  /// If minorTicksPerInterval is 1, then smaller ticks will be rendered on
  /// 1.0, 3.0 and so on.
  ///
  /// Defaults to `null`. Must be greater than 0.
  ///
  /// This snippet shows how to show minor ticks in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showTicks: true,
  ///   minorTicksPerInterval: 1,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks], to render major ticks at given interval.
  /// * [minorTickShape] and [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing
  /// the minor tick’s visual appearance.
  final int minorTicksPerInterval;

  /// Option to render the major ticks on the track.
  ///
  /// It is a shape which is used to represent
  /// the major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the slider will render the major ticks at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show major ticks in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showTicks: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tickShape] and [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html) for customizing the
  /// major tick’s visual appearance.
  final bool showTicks;

  /// Option to render the labels on given interval.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show labels in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   showLabels: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [numberFormat] and [dateFormat], for formatting the numeric and
  /// date labels.
  /// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the appearance of the labels.
  final bool showLabels;

  /// Option to render the divisors on the track.
  ///
  /// It is a shape which is used to represent
  /// the major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the slider will render the divisors at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show divisors in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showDivisors: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  /// * [divisorShape] and [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html) for customizing
  /// the divisor’s visual appearance.
  final bool showDivisors;

  /// Option to enable tooltip for the thumb.
  ///
  /// Used to clearly indicate the current selection of the value
  /// during interaction.
  ///
  /// By default, tooltip text is formatted with either [numberFormat] or
  /// [dateFormat].
  ///
  /// This snippet shows how to enable tooltip in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [tooltipTextFormatterCallback], for changing the default tooltip text.
  /// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the appearance of the tooltip text.
  final bool enableTooltip;

  /// Color applied to the inactive track and active divisors.
  ///
  /// The inactive side of the slider is between the thumb and the [max] value.
  ///
  /// This snippet shows how to set inactive color in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   inactiveColor: Colors.red,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the individual
  /// inactive slider element’s visual.
  final Color inactiveColor;

  /// Color applied to the active track, thumb, overlay, and inactive divisors.
  ///
  /// The active side of the slider is between the [min] value and the thumb.
  ///
  /// This snippet shows how to set active color in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   activeColor: Colors.red,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the individual active slider element’s visual.
  final Color activeColor;

  /// Option to place the labels either between the major ticks or
  /// on the major ticks.
  ///
  /// Defaults to [LabelPlacement.onTicks].
  ///
  /// This snippet shows how to set label placement in [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2002, 01, 01);
  ///
  /// SfSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   value: _value,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   labelPlacement: LabelPlacement.betweenTicks,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final LabelPlacement labelPlacement;

  /// Formats the numeric labels.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set number format in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   numberFormat: NumberFormat(‘\$’),
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [labelFormatterCallback], for formatting the numeric and date labels.
  final NumberFormat numberFormat;

  /// Formats the date labels. It is mandatory for date [SfSlider].
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// divisors are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date format in [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2002, 01, 01);
  ///
  /// SfSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   value: _value,
  ///   interval: 1,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
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

  /// The type of date interval. It is mandatory for date [SfSlider].
  ///
  /// It can be years to seconds.
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date value, if labels, ticks, and
  /// divisors are needed.
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set date interval type in [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2002, 01, 01);
  ///
  /// SfSlider(
  ///   min: DateTime(2000, 01, 01, 00),
  ///   max: DateTime(2005, 12, 31, 24),
  ///   value: _value,
  ///   interval: 1,
  ///   dateFormat: DateFormat.y(),
  ///   dateIntervalType: DateIntervalType.years,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final DateIntervalType dateIntervalType;

  /// Signature for formatting or changing the whole numeric or date label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [value].
  /// * The formatted value based on the numeric or
  /// date format is given by `formattedText`.
  ///
  /// This snippet shows how to set label format in [SfSlider].
  ///
  /// ```dart
  /// double _value = 10000.0;
  ///
  /// SfSlider(
  ///   min: 100.0,
  ///   max: 10000.0,
  ///   value: _value,
  ///   interval: 9000.0,
  ///   showLabels: true,
  ///   showTicks: true,
  ///   labelFormatterCallback: (dynamic actualValue, String formattedText) {
  ///     return actualValue == 10000 ? '\$ $ formattedText +' : '\$ $ formattedText';
  ///   },
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final LabelFormatterCallback labelFormatterCallback;

  /// Signature for formatting or changing the whole tooltip label text.
  ///
  /// * The actual value without formatting is given by `actualValue`.
  /// It is either [DateTime] or [double] based on given [value].
  /// * The formatted value based on the numeric or
  /// date format is given by `formattedText`.
  ///
  /// This snippet shows how to set tooltip format in [SfSlider].
  ///
  /// ```dart
  /// DateTime _value = DateTime(2010, 01, 01, 13, 00, 00);
  ///
  /// SfSlider(
  ///   min: DateTime(2010, 01, 01, 9, 00, 00),
  ///   max: DateTime(2010, 01, 01, 21, 05, 00),
  ///   value: _value,
  ///   interval: 4,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   dateFormat: DateFormat('h a'),
  ///   dateIntervalType: DateIntervalType.hours,
  ///   tooltipTextFormatterCallback:
  ///       (dynamic actualValue, String formattedText) {
  ///     return DateFormat('h:mm a').format(actualValue);
  ///   },
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;

  /// The callback used to create a semantic value from the slider's value.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to
  /// inform users what the currently selected value is with more context.
  ///
  /// In the example below, a slider value is configured to
  /// announce a value in dollar.
  ///
  /// double _value = 40.0;
  ///
  /// ```dart
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 100.0,
  ///   value: _value,
  ///   interval: 20,
  ///   stepSize: 10,
  ///   semanticFormatterCallback: (dynamic value) {
  ///     return '${value} dollars';
  ///   }
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///      _value = newValue;
  ///    });
  ///  },
  ///  )
  /// ```
  final SfSliderSemanticFormatterCallback semanticFormatterCallback;

  /// Base class for [SfSlider] track shapes.
  final SfTrackShape trackShape;

  /// Base class for [SfSlider] divisors shapes.
  final SfDivisorShape divisorShape;

  /// Base class for [SfSlider] overlay shapes.
  final SfOverlayShape overlayShape;

  ///  Base class for [SfSlider] thumb shapes.
  final SfThumbShape thumbShape;

  /// Base class for [SfSlider] major tick shapes.
  final SfTickShape tickShape;

  /// Base class for [SfSlider] minor tick shapes.
  final SfTickShape minorTickShape;

  /// Renders rectangular or paddle shape tooltip.
  ///
  /// Defaults to [SfRectangularTooltipShape]
  ///
  ///```dart
  /// double _value = 40.0;
  ///
  /// SfSlider(
  ///  min: 0.0,
  ///  max: 100.0,
  ///  value: _value,
  ///  showLabels: true,
  ///  showTicks: true,
  ///  interval: 20,
  ///  enableTooltip: true,
  ///  tooltipShape: SfPaddleTooltipShape(),
  ///  onChanged: (dynamic newValue) {
  ///    setState(() {
  ///      _value = newValue;
  ///    });
  ///  },
  /// )
  ///```
  final SfTooltipShape tooltipShape;

  /// Sets the widget inside the thumb.
  ///
  /// Defaults to `null`.
  ///
  /// It is possible to set any widget inside the thumb. If the widget
  /// exceeds the size of the thumb, increase the
  /// [SfSliderThemeData.thumbRadius] based on it.
  ///
  /// This snippet shows how to show thumb icon in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   showTicks: true,
  ///   showLabels: true,
  ///   enableTooltip: true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  ///   thumbIcon:  Icon(
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
  /// * [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html), for customizing the individual active slider element’s visual.
  final Widget thumbIcon;

  @override
  _SfSliderState createState() => _SfSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('value', value));
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
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
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (value.runtimeType == DateTime) {
      properties.add(StringProperty('dateFormat',
          'Formatted value is ' + (dateFormat.format(value.start)).toString()));
    }
    properties.add(
        EnumProperty<DateIntervalType>('dateIntervalType', dateIntervalType));
    properties.add(ObjectFlagProperty<TooltipTextFormatterCallback>.has(
        'tooltipTextFormatterCallback', tooltipTextFormatterCallback));
    properties.add(ObjectFlagProperty<LabelFormatterCallback>.has(
        'labelFormatterCallback', labelFormatterCallback));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'semanticFormatterCallback', semanticFormatterCallback));
  }
}

class _SfSliderState extends State<SfSlider> with TickerProviderStateMixin {
  AnimationController overlayController;
  AnimationController stateController;
  AnimationController tooltipAnimationController;
  Timer tooltipDelayTimer;
  final Duration duration = const Duration(milliseconds: 100);

  void _onChanged(dynamic value) {
    if (value != widget.value) {
      widget.onChanged(value);
    }
  }

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  SfSliderThemeData _getSliderThemeData(ThemeData themeData, bool isActive) {
    SfSliderThemeData sliderThemeData = SfSliderTheme.of(context);
    final double minTrackHeight = math.min(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    sliderThemeData = sliderThemeData.copyWith(
      activeTrackHeight: sliderThemeData.activeTrackHeight,
      inactiveTrackHeight: sliderThemeData.inactiveTrackHeight,
      tickSize: sliderThemeData.tickSize,
      minorTickSize: sliderThemeData.minorTickSize,
      tickOffset: sliderThemeData.tickOffset,
      labelOffset: sliderThemeData.labelOffset ??
          (widget.showTicks ? const Offset(0.0, 5.0) : const Offset(0.0, 13.0)),
      inactiveLabelStyle: sliderThemeData.inactiveLabelStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1.color.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      activeLabelStyle: sliderThemeData.activeLabelStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1.color.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      tooltipTextStyle: sliderThemeData.tooltipTextStyle ??
          themeData.textTheme.bodyText1.copyWith(
              color: sliderThemeData.brightness == Brightness.light
                  ? const Color.fromRGBO(255, 255, 255, 1)
                  : const Color.fromRGBO(0, 0, 0, 1)),
      inactiveTrackColor: widget.inactiveColor ??
          sliderThemeData.inactiveTrackColor ??
          themeData.primaryColor.withOpacity(0.24),
      activeTrackColor: widget.activeColor ??
          sliderThemeData.activeTrackColor ??
          themeData.primaryColor,
      thumbColor: widget.activeColor ??
          sliderThemeData.thumbColor ??
          themeData.primaryColor,
      activeTickColor: sliderThemeData.activeTickColor,
      inactiveTickColor: sliderThemeData.inactiveTickColor,
      disabledActiveTickColor: sliderThemeData.disabledActiveTickColor,
      disabledInactiveTickColor: sliderThemeData.disabledInactiveTickColor,
      activeMinorTickColor: sliderThemeData.activeMinorTickColor,
      inactiveMinorTickColor: sliderThemeData.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          sliderThemeData.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          sliderThemeData.disabledInactiveMinorTickColor,
      // ignore: lines_longer_than_80_chars
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          sliderThemeData.overlayColor ??
          themeData.primaryColor.withOpacity(0.12),
      inactiveDivisorColor: widget.activeColor ??
          sliderThemeData.inactiveDivisorColor ??
          themeData.colorScheme.primary.withOpacity(0.54),
      activeDivisorColor: widget.inactiveColor ??
          sliderThemeData.activeDivisorColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.54),
      disabledInactiveDivisorColor:
          sliderThemeData.disabledInactiveDivisorColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledActiveDivisorColor: sliderThemeData.disabledActiveDivisorColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.12),
      disabledActiveTrackColor: sliderThemeData.disabledActiveTrackColor ??
          themeData.colorScheme.onSurface.withOpacity(0.32),
      disabledInactiveTrackColor: sliderThemeData.disabledInactiveTrackColor ??
          themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledThumbColor: sliderThemeData.disabledThumbColor,
      tooltipBackgroundColor: sliderThemeData.tooltipBackgroundColor ??
          (widget.tooltipShape is SfPaddleTooltipShape
              ? themeData.primaryColor
              : (sliderThemeData.brightness == Brightness.light)
                  ? const Color.fromRGBO(97, 97, 97, 1)
                  : const Color.fromRGBO(224, 224, 224, 1)),
      thumbStrokeColor: sliderThemeData.thumbStrokeColor,
      activeDivisorStrokeColor: sliderThemeData.activeDivisorStrokeColor,
      inactiveDivisorStrokeColor: sliderThemeData.inactiveDivisorStrokeColor,
      trackCornerRadius:
          sliderThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: sliderThemeData.thumbRadius,
      overlayRadius: sliderThemeData.overlayRadius,
      activeDivisorRadius:
          sliderThemeData.activeDivisorRadius ?? minTrackHeight / 4,
      inactiveDivisorRadius:
          sliderThemeData.inactiveDivisorRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: sliderThemeData.thumbStrokeWidth,
      activeDivisorStrokeWidth: sliderThemeData.activeDivisorStrokeWidth,
      inactiveDivisorStrokeWidth: sliderThemeData.inactiveDivisorStrokeWidth,
    );

    return sliderThemeData;
  }

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(vsync: this, duration: duration);
    stateController = AnimationController(vsync: this, duration: duration);
    tooltipAnimationController =
        AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.onChanged != null && (widget.min != widget.max) ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    overlayController?.dispose();
    stateController?.dispose();
    tooltipAnimationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        widget.onChanged != null && (widget.min != widget.max);
    final ThemeData themeData = Theme.of(context);

    return _SliderRenderObjectWidget(
        key: widget.key,
        min: widget.min,
        max: widget.max,
        value: widget.value,
        onChanged: isActive ? _onChanged : null,
        interval: widget.interval,
        stepSize: widget.stepSize,
        stepDuration: widget.stepDuration,
        minorTicksPerInterval: widget.minorTicksPerInterval ?? 0,
        showTicks: widget.showTicks,
        showLabels: widget.showLabels,
        showDivisors: widget.showDivisors,
        enableTooltip: widget.enableTooltip,
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
        sliderThemeData: _getSliderThemeData(themeData, isActive),
        thumbIcon: widget.thumbIcon,
        state: this);
  }
}

class _SliderRenderObjectWidget extends RenderObjectWidget {
  const _SliderRenderObjectWidget(
      {Key key,
      this.min,
      this.max,
      this.value,
      this.onChanged,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval,
      this.showTicks,
      this.showLabels,
      this.showDivisors,
      this.enableTooltip,
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
      this.sliderThemeData,
      this.thumbIcon,
      this.state})
      : super(key: key);

  final dynamic min;
  final dynamic max;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;
  final double interval;
  final double stepSize;
  final SliderStepDuration stepDuration;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDivisors;
  final bool enableTooltip;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final NumberFormat numberFormat;
  final DateIntervalType dateIntervalType;
  final DateFormat dateFormat;
  final SfSliderThemeData sliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final SfSliderSemanticFormatterCallback semanticFormatterCallback;
  final SfDivisorShape divisorShape;
  final SfTrackShape trackShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTooltipShape tooltipShape;
  final Widget thumbIcon;
  final _SfSliderState state;

  @override
  _RenderSliderElement createElement() => _RenderSliderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSlider(
      min: min,
      max: max,
      value: value,
      onChanged: onChanged,
      minorTicksPerInterval: minorTicksPerInterval,
      interval: interval,
      stepSize: stepSize,
      stepDuration: stepDuration,
      showTicks: showTicks,
      showLabels: showLabels,
      showDivisors: showDivisors,
      enableTooltip: enableTooltip,
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
      sliderThemeData: sliderThemeData,
      textDirection: Directionality.of(context),
      mediaQueryData: MediaQuery.of(context),
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSlider renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..value = value
      ..onChanged = onChanged
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDivisors = showDivisors
      ..enableTooltip = enableTooltip
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
      ..sliderThemeData = sliderThemeData
      ..textDirection = Directionality.of(context)
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderSliderElement extends RenderObjectElement {
  _RenderSliderElement(_SliderRenderObjectWidget slider) : super(slider);

  final Map<ChildElements, Element> _slotToChild = <ChildElements, Element>{};

  final Map<Element, ChildElements> _childToSlot = <Element, ChildElements>{};

  @override
  _SliderRenderObjectWidget get widget => super.widget;

  @override
  _RenderSlider get renderObject => super.renderObject;

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
        renderObject.thumbIcon = child;
        break;
      case ChildElements.endThumbIcon:
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
    _mountChild(widget.thumbIcon, ChildElements.startThumbIcon);
  }

  @override
  void update(_SliderRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.thumbIcon, ChildElements.startThumbIcon);
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

class _RenderSlider extends RenderBaseSlider {
  _RenderSlider({
    dynamic min,
    dynamic max,
    dynamic value,
    ValueChanged<dynamic> onChanged,
    double interval,
    double stepSize,
    SliderStepDuration stepDuration,
    int minorTicksPerInterval,
    bool showTicks,
    bool showLabels,
    bool showDivisors,
    bool enableTooltip,
    Color inactiveColor,
    Color activeColor,
    LabelPlacement labelPlacement,
    NumberFormat numberFormat,
    DateFormat dateFormat,
    DateIntervalType dateIntervalType,
    LabelFormatterCallback labelFormatterCallback,
    TooltipTextFormatterCallback tooltipTextFormatterCallback,
    SfSliderSemanticFormatterCallback semanticFormatterCallback,
    SfTrackShape trackShape,
    SfDivisorShape divisorShape,
    SfOverlayShape overlayShape,
    SfThumbShape thumbShape,
    SfTickShape tickShape,
    SfTickShape minorTickShape,
    SfTooltipShape tooltipShape,
    SfSliderThemeData sliderThemeData,
    TextDirection textDirection,
    MediaQueryData mediaQueryData,
    @required _SfSliderState state,
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
    _value = value;
    _semanticFormatterCallback = semanticFormatterCallback;
    _onChanged = onChanged;
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

    _overlayAnimation = CurvedAnimation(
        parent: _state.overlayController, curve: Curves.fastOutSlowIn);

    _stateAnimation = CurvedAnimation(
        parent: _state.stateController, curve: Curves.easeInOut);

    _tooltipAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationController, curve: Curves.fastOutSlowIn);

    updateTextPainter();

    if (isDateTime) {
      _valueInMilliseconds = value.millisecondsSinceEpoch.toDouble();
    }
  }

  final _SfSliderState _state;

  Animation<double> _overlayAnimation;

  Animation<double> _stateAnimation;

  Animation<double> _tooltipAnimation;

  double _valueInMilliseconds;

  final Map<ChildElements, RenderBox> slotToChild =
      <ChildElements, RenderBox>{};

  final Map<RenderBox, ChildElements> childToSlot =
      <RenderBox, ChildElements>{};

  dynamic get value => _value;
  dynamic _value;

  set value(dynamic value) {
    if (_value == value) {
      return;
    }

    _value = value;
    if (isDateTime) {
      _valueInMilliseconds = _value.millisecondsSinceEpoch.toDouble();
    }
    markNeedsPaint();
  }

  ValueChanged<dynamic> get onChanged => _onChanged;
  ValueChanged<dynamic> _onChanged;

  set onChanged(ValueChanged<dynamic> value) {
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

  SfSliderSemanticFormatterCallback get semanticFormatterCallback =>
      _semanticFormatterCallback;
  SfSliderSemanticFormatterCallback _semanticFormatterCallback;
  set semanticFormatterCallback(SfSliderSemanticFormatterCallback value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  RenderBox get thumbIcon => _thumbIcon;
  RenderBox _thumbIcon;

  set thumbIcon(RenderBox value) {
    _thumbIcon = _updateChild(_thumbIcon, value, ChildElements.startThumbIcon);
  }

  bool get isInteractive => onChanged != null;

  double get actualValue => isDateTime ? _valueInMilliseconds : _value;

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_thumbIcon != null) {
      yield _thumbIcon;
    }
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

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    currentX = globalToLocal(details.globalPosition).dx;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    currentX = globalToLocal(details.globalPosition).dx;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    currentX = globalToLocal(details.globalPosition).dx;
    _updateValue();
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    isInteractionEnd = false;
    _state.overlayController.forward();
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationController.forward();
      _state.tooltipDelayTimer?.cancel();
      _state.tooltipDelayTimer = Timer(const Duration(milliseconds: 500), () {
        _state.tooltipDelayTimer = null;
        if (isInteractionEnd &&
            willDrawTooltip &&
            _state.tooltipAnimationController.status ==
                AnimationStatus.completed) {
          _state.tooltipAnimationController.reverse();
        }
      });
    }

    _updateValue();
    markNeedsPaint();
  }

  void _updateValue() {
    final double factor = getFactorFromCurrentPosition();
    final double valueFactor = lerpDouble(actualMin, actualMax, factor);
    final dynamic newValue = getActualValue(valueInDouble: valueFactor);

    if (newValue != _value) {
      onChanged(newValue);
    }
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      _state.overlayController.reverse();
      if (enableTooltip && _state.tooltipDelayTimer == null) {
        _state.tooltipAnimationController.reverse();
        if (_state.tooltipAnimationController.status ==
            AnimationStatus.dismissed) {
          willDrawTooltip = false;
        }
      }

      currentPointerType = PointerType.up;
      isInteractionEnd = true;
      markNeedsPaint();
    }
  }

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _drawTooltip(PaintingContext context, Offset thumbCenter, Offset offset,
      Offset actualTrackOffset, Rect trackRect) {
    if (willDrawTooltip) {
      final Paint paint = Paint()
        ..color = sliderThemeData.tooltipBackgroundColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      final dynamic actualText =
          getValueFromPosition(thumbCenter.dx - offset.dx);
      final String tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      final TextSpan textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: _tooltipAnimation,
          trackRect: trackRect);
    }
  }

  void increaseAction() {
    if (isInteractive) {
      onChanged(getNextSemanticValue(value, semanticActionUnit));
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged(getPrevSemanticValue(value, semanticActionUnit));
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _overlayAnimation?.addListener(markNeedsPaint);
    _stateAnimation?.addListener(markNeedsPaint);
    _tooltipAnimation?.addListener(markNeedsPaint);
    _tooltipAnimation?.addStatusListener(_handleTooltipAnimationStatusChange);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _overlayAnimation?.removeListener(markNeedsPaint);
    _stateAnimation?.removeListener(markNeedsPaint);
    _tooltipAnimation?.removeListener(markNeedsPaint);
    _tooltipAnimation
        ?.removeStatusListener(_handleTooltipAnimationStatusChange);
    super.detach();
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  bool hitTestSelf(Offset position) => isInteractive;

  @override
  void performLayout() {
    super.performLayout();
    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: sliderThemeData.thumbRadius * 2,
        height: sliderThemeData.thumbRadius * 2);
    _thumbIcon?.layout(contentConstraints, parentUsesSize: true);
  }

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
    final double thumbPosition =
        getFactorFromValue(actualValue) * trackRect.width;
    final Offset thumbCenter =
        Offset(trackRect.left + thumbPosition, trackRect.center.dy);

    trackShape.paint(context, actualTrackOffset, thumbCenter, null, null,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection);

    if (showLabels || showTicks || showDivisors) {
      drawLabelsTicksAndDivisors(context, trackRect, offset, thumbCenter, null,
          null, _stateAnimation, _value, null);
    }

    // Drawing overlay.
    overlayShape.paint(context, thumbCenter,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        animation: _overlayAnimation);

    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: _thumbIcon,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection);

    _drawTooltip(context, thumbCenter, offset, actualTrackOffset, trackRect);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.textDirection = textDirection;
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
      if (semanticFormatterCallback != null) {
        config.value = semanticFormatterCallback(value);
        config.increasedValue = semanticFormatterCallback(
            getNextSemanticValue(value, semanticActionUnit));
        config.decreasedValue = semanticFormatterCallback(
            getPrevSemanticValue(value, semanticActionUnit));
      } else {
        config.value = '$value';
        config.increasedValue =
            '${getNextSemanticValue(value, semanticActionUnit)}';
        config.decreasedValue =
            '${getPrevSemanticValue(value, semanticActionUnit)}';
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
