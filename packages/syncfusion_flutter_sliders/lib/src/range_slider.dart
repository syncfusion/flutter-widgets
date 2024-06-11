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
/// * The "dividers", which is a shape that renders on the track based on
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
      this.onChangeStart,
      this.onChangeEnd,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDividers = false,
      this.enableTooltip = false,
      this.shouldAlwaysShowTooltip = false,
      this.enableIntervalSelection = false,
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
      this.endThumbIcon})
      : isInversed = false,
        _sliderType = SliderType.horizontal,
        _tooltipPosition = null,
        assert(min != max),
        assert(interval == null || interval > 0),
        assert(!enableIntervalSelection ||
            (enableIntervalSelection && (interval != null && interval > 0))),
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
      this.onChangeStart,
      this.onChangeEnd,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDividers = false,
      this.enableTooltip = false,
      this.shouldAlwaysShowTooltip = false,
      this.enableIntervalSelection = false,
      this.dragMode = SliderDragMode.onThumb,
      this.isInversed = false,
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
      SliderTooltipPosition tooltipPosition = SliderTooltipPosition.left})
      : _sliderType = SliderType.vertical,
        _tooltipPosition = tooltipPosition,
        assert(tooltipShape is! SfPaddleTooltipShape),
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
  /// if the labels, ticks, and dividers are needed.
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

  /// The [onChangeStart] callback will be called when the user starts to
  /// tap or drag the range slider. This callback is only used to notify
  /// the user about the start interaction and it does not update the
  /// range slider value.
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
  ///     body: SfRangeSlider(
  ///       min: 0,
  ///       max: 10,
  ///       values: _values,
  ///       onChangeStart: (SfRangeValues startValue) {
  ///         print('Interaction start');
  ///       },
  ///       onChanged: (SfRangeValues newValues) {
  ///         setState(() {
  ///           _values = newValues;
  ///         });
  ///       },
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
  /// tap or drag the range slider.
  ///
  /// This callback is only used to notify the user about the end interaction
  /// and it does not update the range slider thumb value.
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfRangeSlider(
  ///       min: 0,
  ///       max: 10,
  ///       values: _values,
  ///       onChangeEnd: (SfRangeValues endValue) {
  ///         print('Interaction end');
  ///       },
  ///       onChanged: (SfRangeValues newValues) {
  ///         setState(() {
  ///           _values = newValues;
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// •	The [onChangeStart] callback used to notify the user about the
  ///   interaction begins.
  /// •	The [onChanged] callback used to update the range slider thumb value.

  final ValueChanged<SfRangeValues>? onChangeEnd;

  /// Splits the range slider into given interval.
  /// It is mandatory if labels, major ticks and dividers are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the labels, major ticks,
  /// and dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date values, the range slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// dividers are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is [DateIntervalType.years], then the range slider will
  /// render the labels, major ticks, and dividers at 2000, 2001, 2002 and
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
  /// * [showDividers], to render dividers at given interval.
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
  /// [stepDuration] is SliderStepDuration(years: 1, months: 6),
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
  ///      stepDuration: SliderStepDuration(years: 1, months: 6),
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

  /// Option to render the dividers on the track.
  ///
  /// It is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the range slider will render the dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show dividers in [SfRangeSlider].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   values: _values,
  ///   interval: 2,
  ///   showDividers: true,
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
  /// * [dividerShape] and [SfRangeSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfRangeSliderThemeData-class.html) for customizing
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

  /// Option to show tooltip always in range slider.
  ///
  /// Defaults to false.
  ///
  /// When this property is enabled, the tooltip is always displayed to the
  /// start and end thumbs of the selector. This property works independent of
  /// the[enableTooltip] property. While this property is enabled, the tooltip
  /// will always appear during interaction.
  ///
  /// This snippet shows how to show the tooltip in the [SfRangeSlider].
  ///
  ///  ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 6.0);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfRangeSlider(
  ///       min: 0,
  ///       max: 10,
  ///       values: _values,
  ///       shouldAlwaysShowTooltip: true,
  ///       onChanged: (SfRangeValues newValues) {
  ///         setState(() {
  ///           _values = newValues;
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ````
  final bool shouldAlwaysShowTooltip;

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

  /// Represents the behavior of thumb dragging in the [SfRangeSlider].
  ///
  /// When [dragMode] is set to [SliderDragMode.onThumb], individual thumb can
  /// be moved by dragging it.
  ///
  /// When [dragMode] is set to [SliderDragMode.betweenThumbs], both the thumbs
  /// can be moved at the same time by dragging in the area between start and
  /// end thumbs. The range between the start and end thumb will always be the
  /// same. Hence, it is not possible to move the individual thumb.
  ///
  /// When [dragMode] is set to [SliderDragMode.both], individual thumb can be
  /// moved by dragging it, and also both the thumbs can be moved at the same
  /// time by dragging in the area between start and end thumbs.
  ///
  /// Defaults to [SliderDragMode.onThumb].
  ///
  /// This code snippet shows the behavior of thumb dragging.
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// SfRangeSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   interval: 2,
  ///   showLabels: true,
  ///   dragMode: SliderDragMode.betweenThumbs,
  ///   values: _values,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _values = newValues;
  ///     });
  ///   }
  /// )
  /// ```
  ///
  /// See also:
  /// * The [enableIntervalSelection], to select the particular interval based
  /// on the position of the tap or click.
  final SliderDragMode dragMode;

  /// Option to inverse the range slider.
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to inverse the [SfRangeSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfRangeSlider.vertical(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   isInversed = true,
  ///   onChanged: (SfRangeValues newValues) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  ///
  final bool isInversed;

  /// Color applied to the inactive track and active dividers.
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

  /// Color applied to the active track, thumb, overlay, and inactive dividers.
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

  /// Position of the edge labels.
  ///
  /// The edge labels in an axis can be shifted inside
  /// the axis bounds or placed at the edges.
  ///
  /// Defaults to `EdgeLabelPlacement.auto`.
  ///
  /// Also refer [EdgeLabelPlacement].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return SfRangeSlider(
  ///        edgeLabelPlacement: EdgeLabelPlacement.inside,
  ///    );
  ///}
  ///```
  final EdgeLabelPlacement edgeLabelPlacement;

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
  /// dividers are needed.
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
  /// dividers are needed.
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

  /// Base class for [SfRangeSlider] dividers shapes.
  final SfDividerShape dividerShape;

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
  State<SfRangeSlider> createState() => _SfRangeSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      values.toDiagnosticsNode(name: 'values'),
    );
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    properties.add(DiagnosticsProperty<bool>('isInversed', isInversed,
        defaultValue: false));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<SfRangeValues>>.has(
        'onChangeEnd', onChangeEnd));
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
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties.add(EnumProperty<EdgeLabelPlacement>(
        'edgeLabelPlacement', edgeLabelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (values.start.runtimeType == DateTime && dateFormat != null) {
      properties.add(StringProperty('dateFormat',
          'Formatted value is ${dateFormat!.format(values.start)}'));
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

  void _onChanged(SfRangeValues values) {
    if (values != widget.values) {
      widget.onChanged!(values);
    }
  }

  void _onChangeStart(SfRangeValues values) {
    if (widget.onChangeStart != null) {
      widget.onChangeStart!(values);
    }
  }

  void _onChangeEnd(SfRangeValues values) {
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(values);
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
    final bool isMaterial3 = themeData.useMaterial3;
    final SfRangeSliderThemeData effectiveThemeData =
        RangeSliderThemeData(context);
    final Color labelColor = isMaterial3
        ? themeData.colorScheme.onSurfaceVariant
        : isActive
            ? themeData.textTheme.bodyLarge!.color!.withOpacity(0.87)
            : themeData.colorScheme.onSurface.withOpacity(0.32);
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
      inactiveLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(rangeSliderThemeData.inactiveLabelStyle),
      activeLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(rangeSliderThemeData.activeLabelStyle),
      tooltipTextStyle: themeData.textTheme.bodyLarge!
          .copyWith(
              fontSize: isMaterial3 ? 12 : 14,
              color: isMaterial3
                  ? themeData.colorScheme.onPrimary
                  : themeData.colorScheme.surface)
          .merge(rangeSliderThemeData.tooltipTextStyle),
      inactiveTrackColor: widget.inactiveColor ??
          rangeSliderThemeData.inactiveTrackColor ??
          effectiveThemeData.inactiveTrackColor,
      activeTrackColor: widget.activeColor ??
          rangeSliderThemeData.activeTrackColor ??
          effectiveThemeData.activeTrackColor,
      thumbColor: widget.activeColor ??
          rangeSliderThemeData.thumbColor ??
          effectiveThemeData.thumbColor,
      activeTickColor: rangeSliderThemeData.activeTickColor ??
          effectiveThemeData.activeTickColor,
      inactiveTickColor: rangeSliderThemeData.inactiveTickColor ??
          effectiveThemeData.inactiveTickColor,
      disabledActiveTickColor: rangeSliderThemeData.disabledActiveTickColor ??
          effectiveThemeData.disabledActiveTickColor,
      disabledInactiveTickColor:
          rangeSliderThemeData.disabledInactiveTickColor ??
              effectiveThemeData.disabledInactiveTickColor,
      activeMinorTickColor: rangeSliderThemeData.activeMinorTickColor ??
          effectiveThemeData.activeMinorTickColor,
      inactiveMinorTickColor: rangeSliderThemeData.inactiveMinorTickColor ??
          effectiveThemeData.disabledInactiveMinorTickColor,
      disabledActiveMinorTickColor:
          rangeSliderThemeData.disabledActiveMinorTickColor ??
              effectiveThemeData.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          rangeSliderThemeData.disabledInactiveMinorTickColor ??
              effectiveThemeData.disabledInactiveMinorTickColor,
      // ignore: lines_longer_than_80_chars
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          rangeSliderThemeData.overlayColor ??
          effectiveThemeData.overlayColor,
      inactiveDividerColor: widget.activeColor ??
          rangeSliderThemeData.inactiveDividerColor ??
          effectiveThemeData.inactiveDividerColor,
      activeDividerColor: widget.inactiveColor ??
          rangeSliderThemeData.activeDividerColor ??
          effectiveThemeData.activeDividerColor,
      disabledInactiveDividerColor:
          rangeSliderThemeData.disabledInactiveDividerColor ??
              effectiveThemeData.disabledInactiveDividerColor,
      disabledActiveDividerColor:
          rangeSliderThemeData.disabledActiveDividerColor ??
              effectiveThemeData.disabledActiveDividerColor,
      disabledActiveTrackColor: rangeSliderThemeData.disabledActiveTrackColor ??
          effectiveThemeData.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          rangeSliderThemeData.disabledInactiveTrackColor ??
              effectiveThemeData.disabledInactiveTrackColor,
      disabledThumbColor: rangeSliderThemeData.disabledThumbColor ??
          effectiveThemeData.disabledThumbColor,
      tooltipBackgroundColor: rangeSliderThemeData.tooltipBackgroundColor ??
          effectiveThemeData.tooltipBackgroundColor,
      thumbStrokeColor: rangeSliderThemeData.thumbStrokeColor,
      overlappingThumbStrokeColor:
          rangeSliderThemeData.overlappingThumbStrokeColor ??
              themeData.colorScheme.surface,
      activeDividerStrokeColor: rangeSliderThemeData.activeDividerStrokeColor,
      inactiveDividerStrokeColor:
          rangeSliderThemeData.inactiveDividerStrokeColor,
      overlappingTooltipStrokeColor:
          rangeSliderThemeData.overlappingTooltipStrokeColor ??
              themeData.colorScheme.surface,
      trackCornerRadius:
          rangeSliderThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: rangeSliderThemeData.thumbRadius,
      overlayRadius: rangeSliderThemeData.overlayRadius,
      activeDividerRadius:
          rangeSliderThemeData.activeDividerRadius ?? minTrackHeight / 4,
      inactiveDividerRadius:
          rangeSliderThemeData.inactiveDividerRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: rangeSliderThemeData.thumbStrokeWidth,
      activeDividerStrokeWidth: rangeSliderThemeData.activeDividerStrokeWidth,
      inactiveDividerStrokeWidth:
          rangeSliderThemeData.inactiveDividerStrokeWidth,
    );

    if (widget._sliderType == SliderType.horizontal) {
      return rangeSliderThemeData.copyWith(
          tickSize: rangeSliderThemeData.tickSize ?? const Size(1.0, 8.0),
          minorTickSize:
              rangeSliderThemeData.minorTickSize ?? const Size(1.0, 5.0),
          labelOffset: rangeSliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(0.0, 5.0)
                  : const Offset(0.0, 13.0)));
    } else {
      return rangeSliderThemeData.copyWith(
          tickSize: rangeSliderThemeData.tickSize ?? const Size(8.0, 1.0),
          minorTickSize:
              rangeSliderThemeData.minorTickSize ?? const Size(5.0, 1.0),
          labelOffset: rangeSliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(5.0, 0.0)
                  : const Offset(13.0, 0.0)));
    }
  }

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void didUpdateWidget(SfRangeSlider oldWidget) {
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
      onChangeStart: widget.onChangeStart != null ? _onChangeStart : null,
      onChangeEnd: widget.onChangeEnd != null ? _onChangeEnd : null,
      interval: widget.interval,
      stepSize: widget.stepSize,
      stepDuration: widget.stepDuration,
      minorTicksPerInterval: widget.minorTicksPerInterval,
      showTicks: widget.showTicks,
      showLabels: widget.showLabels,
      showDividers: widget.showDividers,
      enableTooltip: widget.enableTooltip,
      shouldAlwaysShowTooltip: widget.shouldAlwaysShowTooltip,
      dragMode: widget.dragMode,
      enableIntervalSelection: widget.enableIntervalSelection,
      isInversed: widget._sliderType == SliderType.horizontal &&
              Directionality.of(context) == TextDirection.rtl ||
          widget.isInversed,
      inactiveColor:
          widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
      activeColor: widget.activeColor ?? themeData.primaryColor,
      labelPlacement: widget.labelPlacement,
      edgeLabelPlacement: widget.edgeLabelPlacement,
      numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
      dateIntervalType: widget.dateIntervalType,
      dateFormat: widget.dateFormat,
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
      rangeSliderThemeData: _getRangeSliderThemeData(themeData, isActive),
      sliderType: widget._sliderType,
      tooltipPosition: widget._tooltipPosition,
      startThumbIcon: widget.startThumbIcon,
      endThumbIcon: widget.endThumbIcon,
      state: this,
    );
  }
}

class _RangeSliderRenderObjectWidget extends RenderObjectWidget {
  const _RangeSliderRenderObjectWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.values,
    required this.onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.interval,
    required this.stepSize,
    required this.stepDuration,
    required this.minorTicksPerInterval,
    required this.showTicks,
    required this.showLabels,
    required this.showDividers,
    required this.enableTooltip,
    required this.shouldAlwaysShowTooltip,
    required this.enableIntervalSelection,
    required this.dragMode,
    required this.isInversed,
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
    required this.rangeSliderThemeData,
    required this.startThumbIcon,
    required this.endThumbIcon,
    required this.tooltipPosition,
    required this.sliderType,
    required this.state,
  }) : super(key: key);
  final SliderType sliderType;
  final SliderTooltipPosition? tooltipPosition;
  final dynamic min;
  final dynamic max;
  final SfRangeValues? values;
  final ValueChanged<SfRangeValues>? onChanged;
  final ValueChanged<SfRangeValues>? onChangeStart;
  final ValueChanged<SfRangeValues>? onChangeEnd;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDividers;
  final bool enableTooltip;
  final bool enableIntervalSelection;
  final bool isInversed;
  final bool shouldAlwaysShowTooltip;

  final Color inactiveColor;
  final Color activeColor;

  final SliderDragMode dragMode;
  final LabelPlacement labelPlacement;
  final EdgeLabelPlacement edgeLabelPlacement;
  final NumberFormat numberFormat;
  final DateIntervalType? dateIntervalType;
  final DateFormat? dateFormat;
  final SfRangeSliderThemeData rangeSliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final RangeSliderSemanticFormatterCallback? semanticFormatterCallback;
  final SfDividerShape dividerShape;
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
      enableIntervalSelection: enableIntervalSelection,
      dragMode: dragMode,
      isInversed: isInversed,
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
      sliderThemeData: rangeSliderThemeData,
      sliderType: sliderType,
      tooltipPosition: tooltipPosition,
      textDirection: Directionality.of(context),
      mediaQueryData: MediaQuery.of(context),
      state: state,
      gestureSettings: MediaQuery.of(context).gestureSettings,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderRangeSlider renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..values = values!
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDividers = showDividers
      ..enableTooltip = enableTooltip
      ..shouldAlwaysShowTooltip = shouldAlwaysShowTooltip
      ..enableIntervalSelection = enableIntervalSelection
      ..dragMode = dragMode
      ..isInversed = isInversed
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

class _RenderRangeSlider extends RenderBaseRangeSlider {
  _RenderRangeSlider({
    required dynamic min,
    required dynamic max,
    required SfRangeValues? values,
    required ValueChanged<SfRangeValues>? onChanged,
    required ValueChanged<SfRangeValues>? onChangeStart,
    required ValueChanged<SfRangeValues>? onChangeEnd,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool shouldAlwaysShowTooltip,
    required bool enableIntervalSelection,
    required SliderDragMode dragMode,
    required bool isInversed,
    required LabelPlacement labelPlacement,
    required EdgeLabelPlacement edgeLabelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required RangeSliderSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDividerShape dividerShape,
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
    required DeviceGestureSettings gestureSettings,
  })  : _state = state,
        _onChanged = onChanged,
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
          enableIntervalSelection: enableIntervalSelection,
          dragMode: dragMode,
          isInversed: isInversed,
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
          sliderThemeData: sliderThemeData,
          sliderType: sliderType,
          tooltipPosition: tooltipPosition,
          textDirection: textDirection,
          mediaQueryData: mediaQueryData,
          gestureSettings: gestureSettings,
        );

  final _SfRangeSliderState _state;

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

  @override
  bool get isInteractive => onChanged != null;

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
  bool get mounted => _state.mounted;

  @override
  void updateValues(SfRangeValues newValues) {
    if (!isIntervalTapped &&
        (newValues.start != values.start || newValues.end != values.end)) {
      onChanged!(newValues);
    }
    super.updateValues(newValues);
  }

  @override
  void updateIntervalTappedAndDeferredUpdateValues(SfRangeValues newValues) {
    if (isIntervalTapped) {
      onChanged!(newValues);
    }
  }

  void _increaseStartAction() {
    if (isInteractive) {
      final SfRangeValues newValues =
          SfRangeValues(increasedStartValue, values.end);
      if (getNumerizedValue(newValues.start) <=
          (getNumerizedValue(newValues.end))) {
        onChanged!(newValues);
      }
    }
  }

  void _decreaseStartAction() {
    if (isInteractive) {
      onChanged!(SfRangeValues(decreasedStartValue, values.end));
    }
  }

  void _increaseEndAction() {
    if (isInteractive) {
      onChanged!(SfRangeValues(values.start, increasedEndValue));
    }
  }

  void _decreaseEndAction() {
    if (isInteractive) {
      final SfRangeValues newValues =
          SfRangeValues(values.start, decreasedEndValue);
      if (getNumerizedValue(newValues.start) <=
          (getNumerizedValue(newValues.end))) {
        onChanged!(newValues);
      }
    }
  }

  Iterable<RenderBox> get children sync* {
    if (startThumbIcon != null) {
      yield startThumbIcon!;
    }
    if (endThumbIcon != null) {
      yield endThumbIcon!;
    }
  }

  @override
  void performLayout() {
    super.performLayout();
    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: actualThumbSize.width, height: actualThumbSize.height);
    startThumbIcon?.layout(contentConstraints, parentUsesSize: true);
    endThumbIcon?.layout(contentConstraints, parentUsesSize: true);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset actualTrackOffset = sliderType == SliderType.horizontal
        ? Offset(
            offset.dx,
            offset.dy +
                (size.height - actualHeight) / 2 +
                trackOffset.dy -
                maxTrackHeight / 2)
        : Offset(
            offset.dx +
                (size.width - actualHeight) / 2 +
                trackOffset.dx -
                maxTrackHeight / 2,
            offset.dy);

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
    final Rect startRect = sliderType == SliderType.horizontal
        ? Rect.fromPoints(node.rect.topLeft, node.rect.bottomCenter)
        : Rect.fromPoints(node.rect.bottomRight, node.rect.centerLeft);
    final Rect endRect = sliderType == SliderType.horizontal
        ? Rect.fromPoints(node.rect.topCenter, node.rect.bottomRight)
        : Rect.fromPoints(node.rect.centerLeft, node.rect.topRight);
    startSemanticsNode ??= SemanticsNode();
    endSemanticsNode ??= SemanticsNode();
    if (sliderType == SliderType.vertical ||
        textDirection == TextDirection.ltr) {
      startSemanticsNode!.rect = startRect;
      endSemanticsNode!.rect = endRect;
    } else {
      startSemanticsNode!.rect = endRect;
      endSemanticsNode!.rect = startRect;
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
    debugRangeSliderFillProperties(properties);
  }
}
