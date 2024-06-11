import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_base.dart';
import 'slider_shapes.dart';
import 'theme.dart';

/// A Material Design slider.
///
/// Used to select a value between [min] and [max].
/// It supports horizontal and vertical orientations.
/// It also supports both numeric and date values.
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
///  dateIntervalType: DateIntervalType.years,
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
  /// Creates a horizontal [SfSlider].
  const SfSlider(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.value,
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
      this.activeColor,
      this.inactiveColor,
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
      this.thumbIcon})
      : isInversed = false,
        _sliderType = SliderType.horizontal,
        _tooltipPosition = null,
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// Creates a vertical [SfSlider].
  ///
  /// ## TooltipPosition
  ///
  /// Enables tooltip in left or right position for vertical slider.
  ///
  /// Defaults to [SliderTooltipPosition.left].
  ///
  /// ## Example
  ///
  /// This snippet shows how to create a vertical SfSlider with right side
  /// tooltip.
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///      home: Scaffold(
  ///          body: Center(
  ///              child: SfSlider.vertical(
  ///                     min: 0.0,
  ///                     max: 10.0,
  ///                     value: _value,
  ///                     enableTooltip: true,
  ///                     tooltipPosition: SliderTooltipPosition.right,
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
  /// See also:
  ///
  /// * Check the default constructor for horizontal slider.
  const SfSlider.vertical(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.value,
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
      this.isInversed = false,
      this.activeColor,
      this.inactiveColor,
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
      this.thumbIcon,
      SliderTooltipPosition tooltipPosition = SliderTooltipPosition.left})
      : _sliderType = SliderType.vertical,
        _tooltipPosition = tooltipPosition,
        assert(tooltipShape is! SfPaddleTooltipShape),
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// This is used to determine the type of the slider which is horizontal or
  /// vertical.
  final SliderType _sliderType;

  /// This is only applicable for vertical sliders.
  final SliderTooltipPosition? _tooltipPosition;

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
  /// if the labels, ticks, and dividers are needed.
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
  final ValueChanged<dynamic>? onChanged;

  /// The [onChangeStart] callback will be called when the user starts
  /// to tap or drag the slider. This callback is only used to notify
  /// the user about the start interaction and it does not update the
  /// slider value.
  ///
  /// The last interacted thumb value will be passed to this callback.
  /// The value will be double or date time.
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfSlider(
  ///       min: 0,
  ///       max: 10,
  ///       value: _value,
  ///       onChangeStart: (dynamic newValue) {
  ///         print('Interaction starts');
  ///       },
  ///       onChanged: (dynamic newValue) {
  ///         setState(() {
  ///           _value = newValue;
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
  final ValueChanged<dynamic>? onChangeStart;

  /// The [`onChangeEnd`] callback will be called when the user ends
  /// tap or drag the slider.
  ///
  /// This callback is only used to notify the user about the end interaction
  /// and it does not update the slider thumb value.
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfSlider(
  ///       min: 0,
  ///       max: 10,
  ///       value: _value,
  ///       onChangeEnd: (dynamic endValue) {
  ///         print('Interaction end');
  ///       },
  ///       onChanged: (dynamic newValue) {
  ///         setState(() {
  ///           _value = newValue;
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
  /// •	The [onChanged] callback used to update the slider thumb value.

  final ValueChanged<dynamic>? onChangeEnd;

  /// Splits the slider into given interval.
  /// It is mandatory if labels, major ticks and dividers are needed.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the slider will render the labels, major ticks,
  /// and dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date value, if labels, ticks, and
  /// dividers are needed.
  ///
  /// For example, if [min] is DateTime(2000, 01, 01, 00) and
  /// [max] is DateTime(2005, 12, 31, 24), [interval] is 1.0,
  /// [dateFormat] is DateFormat.y(), and
  /// [dateIntervalType] is [DateIntervalType.years], then the slider will
  /// render the labels, major ticks, and dividers at 2000, 2001, 2002 and so
  /// on.
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
  /// * [showDividers], to render dividers at given interval.
  /// * [showTicks], to render major ticks at given interval.
  /// * [showLabels], to render labels at given interval.
  final double? interval;

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
  final double? stepSize;

  /// Option to select discrete date values.
  ///
  /// For example, if [min] is `DateTime(2015, 01, 01)` and
  /// [max] is `DateTime(2020, 01, 01)` and
  /// [stepDuration] is `SliderStepDuration(years: 1, months: 6)`,
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
  ///      stepDuration: SliderStepDuration(years: 1, months: 6),
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
  final SliderStepDuration? stepDuration;

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

  /// Option to render the dividers on the track.
  ///
  /// It is a shape which is used to represent
  /// the major interval points of the track.
  ///
  /// For example, if [min] is 0.0 and [max] is 10.0 and [interval] is 2.0,
  /// the slider will render the dividers at 0.0, 2.0, 4.0 and so on.
  ///
  /// Defaults to `false`.
  ///
  /// This snippet shows how to show dividers in [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 2,
  ///   showDividers: true,
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
  /// * [dividerShape] and [SfSliderThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfSliderThemeData-class.html) for customizing
  /// the divider’s visual appearance.
  final bool showDividers;

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

  /// Option to show tooltip always in slider.
  ///
  /// Defaults to false.
  ///
  /// When this property is enabled, the tooltip is always displayed to the
  /// start and end thumbs of the selector. This property works independent
  /// of the [enableTooltip] property. While this property is enabled, the
  /// tooltip will always appear during interaction.
  ///
  /// This snippet shows how to show the tooltip in the [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfSlider(
  ///       min: 0,
  ///       max: 10,
  ///       value: _value,
  ///       shouldAlwaysShowTooltip: true,
  ///       onChanged: (dynamic newValue) {
  ///         setState(() {
  ///           _value = newValue;
  ///         });
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShowTooltip;

  /// Option to inverse the slider.
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to inverse the [SfSlider].
  ///
  /// ```dart
  /// double _value = 4.0;
  ///
  /// SfSlider.vertical(
  ///   min: 0.0,
  ///   max: 10.0,
  ///   value: _value,
  ///   interval: 1,
  ///   isInversed = true,
  ///   onChanged: (dynamic newValue) {
  ///     setState(() {
  ///       _value = newValue;
  ///     });
  ///    },
  /// )
  /// ```
  final bool isInversed;

  /// Color applied to the inactive track and active dividers.
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
  final Color? inactiveColor;

  /// Color applied to the active track, thumb, overlay, and inactive dividers.
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
  final Color? activeColor;

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
  ///    return  SfSlider(
  ///        edgeLabelPlacement: EdgeLabelPlacement.inside,
  ///    );
  ///}
  ///```
  final EdgeLabelPlacement edgeLabelPlacement;

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
  final NumberFormat? numberFormat;

  /// Formats the date labels. It is mandatory for date [SfSlider].
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date values, if labels, ticks, and
  /// dividers are needed.
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
  final DateFormat? dateFormat;

  /// The type of date interval. It is mandatory for date [SfSlider].
  ///
  /// It can be years to seconds.
  ///
  /// For date value, the slider doesn’t have auto interval support.
  /// So, you may need to set [interval], [dateIntervalType],
  /// and [dateFormat] for date value, if labels, ticks, and
  /// dividers are needed.
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
  final DateIntervalType? dateIntervalType;

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
  final LabelFormatterCallback? labelFormatterCallback;

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
  final TooltipTextFormatterCallback? tooltipTextFormatterCallback;

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
  final SfSliderSemanticFormatterCallback? semanticFormatterCallback;

  /// Base class for [SfSlider] track shapes.
  final SfTrackShape trackShape;

  /// Base class for [SfSlider] dividers shapes.
  final SfDividerShape dividerShape;

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
  final Widget? thumbIcon;

  @override
  State<SfSlider> createState() => _SfSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('value', value));
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    properties.add(DiagnosticsProperty<bool>('isInversed', isInversed,
        defaultValue: false));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
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
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties.add(EnumProperty<EdgeLabelPlacement>(
        'edgeLabelPlacement', edgeLabelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (value.runtimeType == DateTime && dateFormat != null) {
      properties.add(StringProperty(
          'dateFormat', 'Formatted value is ${dateFormat!.format(value)}'));
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
  late AnimationController overlayController;
  late AnimationController stateController;
  late AnimationController tooltipAnimationController;
  Timer? tooltipDelayTimer;
  final Duration duration = const Duration(milliseconds: 100);

  void _onChanged(dynamic value) {
    if (value != widget.value) {
      widget.onChanged!(value);
    }
  }

  void _onChangeStart(dynamic value) {
    if (widget.onChangeStart != null) {
      widget.onChangeStart!(value);
    }
  }

  void _onChangeEnd(dynamic value) {
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(value);
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

    /// An instance for SlidersThemeData class
    final SfSliderThemeData effectiveThemeData = SlidersThemeData(context);
    final bool isMaterial3 = themeData.useMaterial3;
    final Color labelColor = isMaterial3
        ? themeData.colorScheme.onSurfaceVariant
        : isActive
            ? themeData.textTheme.bodyLarge!.color!.withOpacity(0.87)
            : themeData.colorScheme.onSurface.withOpacity(0.32);
    final double minTrackHeight = math.min(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    sliderThemeData = sliderThemeData.copyWith(
      activeTrackHeight: sliderThemeData.activeTrackHeight,
      inactiveTrackHeight: sliderThemeData.inactiveTrackHeight,
      tickOffset: sliderThemeData.tickOffset,
      inactiveLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(sliderThemeData.inactiveLabelStyle),
      activeLabelStyle: themeData.textTheme.bodyLarge!
          .copyWith(color: labelColor, fontSize: isMaterial3 ? 12 : 14)
          .merge(sliderThemeData.activeLabelStyle),
      tooltipTextStyle: themeData.textTheme.bodyLarge!
          .copyWith(
              fontSize: isMaterial3 ? 12 : 14,
              color: isMaterial3
                  ? themeData.colorScheme.onPrimary
                  : themeData.colorScheme.surface)
          .merge(sliderThemeData.tooltipTextStyle),
      inactiveTrackColor: widget.inactiveColor ??
          sliderThemeData.inactiveTrackColor ??
          effectiveThemeData.inactiveTrackColor,
      activeTrackColor: widget.activeColor ??
          sliderThemeData.activeTrackColor ??
          effectiveThemeData.activeTrackColor,
      thumbColor: widget.activeColor ??
          sliderThemeData.thumbColor ??
          effectiveThemeData.thumbColor,
      activeTickColor:
          sliderThemeData.activeTickColor ?? effectiveThemeData.activeTickColor,
      inactiveTickColor: sliderThemeData.inactiveTickColor ??
          effectiveThemeData.inactiveTickColor,
      disabledActiveTickColor: sliderThemeData.disabledActiveTickColor ??
          effectiveThemeData.disabledActiveTickColor,
      disabledInactiveTickColor: sliderThemeData.disabledInactiveTickColor ??
          effectiveThemeData.disabledInactiveTickColor,
      activeMinorTickColor: sliderThemeData.activeMinorTickColor ??
          effectiveThemeData.activeMinorTickColor,
      inactiveMinorTickColor: sliderThemeData.inactiveMinorTickColor ??
          effectiveThemeData.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          sliderThemeData.disabledActiveMinorTickColor ??
              effectiveThemeData.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          sliderThemeData.disabledInactiveMinorTickColor ??
              effectiveThemeData.disabledInactiveMinorTickColor,
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          sliderThemeData.overlayColor ??
          effectiveThemeData.overlayColor,
      inactiveDividerColor: widget.activeColor ??
          sliderThemeData.inactiveDividerColor ??
          effectiveThemeData.inactiveDividerColor,
      activeDividerColor: widget.inactiveColor ??
          sliderThemeData.activeDividerColor ??
          effectiveThemeData.activeDividerColor,
      disabledInactiveDividerColor:
          sliderThemeData.disabledInactiveDividerColor ??
              effectiveThemeData.disabledInactiveDividerColor,
      disabledActiveDividerColor: sliderThemeData.disabledActiveDividerColor ??
          effectiveThemeData.disabledActiveDividerColor,
      disabledActiveTrackColor: sliderThemeData.disabledActiveTrackColor ??
          effectiveThemeData.disabledActiveTrackColor,
      disabledInactiveTrackColor: sliderThemeData.disabledInactiveTrackColor ??
          effectiveThemeData.disabledInactiveTrackColor,
      disabledThumbColor: sliderThemeData.disabledThumbColor ??
          effectiveThemeData.disabledThumbColor,
      tooltipBackgroundColor: sliderThemeData.tooltipBackgroundColor ??
          effectiveThemeData.tooltipBackgroundColor,
      thumbStrokeColor: sliderThemeData.thumbStrokeColor,
      activeDividerStrokeColor: sliderThemeData.activeDividerStrokeColor,
      inactiveDividerStrokeColor: sliderThemeData.inactiveDividerStrokeColor,
      trackCornerRadius:
          sliderThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: sliderThemeData.thumbRadius,
      overlayRadius: sliderThemeData.overlayRadius,
      activeDividerRadius:
          sliderThemeData.activeDividerRadius ?? minTrackHeight / 4,
      inactiveDividerRadius:
          sliderThemeData.inactiveDividerRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: sliderThemeData.thumbStrokeWidth,
      activeDividerStrokeWidth: sliderThemeData.activeDividerStrokeWidth,
      inactiveDividerStrokeWidth: sliderThemeData.inactiveDividerStrokeWidth,
    );
    if (widget._sliderType == SliderType.horizontal) {
      return sliderThemeData.copyWith(
          tickSize: sliderThemeData.tickSize ?? const Size(1.0, 8.0),
          minorTickSize: sliderThemeData.minorTickSize ?? const Size(1.0, 5.0),
          labelOffset: sliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(0.0, 5.0)
                  : const Offset(0.0, 13.0)));
    } else {
      return sliderThemeData.copyWith(
          tickSize: sliderThemeData.tickSize ?? const Size(8.0, 1.0),
          minorTickSize: sliderThemeData.minorTickSize ?? const Size(5.0, 1.0),
          labelOffset: sliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(5.0, 0.0)
                  : const Offset(13.0, 0.0)));
    }
  }

  @override
  void didUpdateWidget(SfSlider oldWidget) {
    if (oldWidget.shouldAlwaysShowTooltip != widget.shouldAlwaysShowTooltip) {
      if (widget.shouldAlwaysShowTooltip) {
        tooltipAnimationController.value = 1;
      } else {
        tooltipAnimationController.value = 0;
      }
    }
    super.didUpdateWidget(oldWidget);
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
    overlayController.dispose();
    stateController.dispose();
    tooltipAnimationController.dispose();

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
        sliderThemeData: _getSliderThemeData(themeData, isActive),
        thumbIcon: widget.thumbIcon,
        tooltipPosition: widget._tooltipPosition,
        sliderType: widget._sliderType,
        state: this);
  }
}

class _SliderRenderObjectWidget extends RenderObjectWidget {
  const _SliderRenderObjectWidget(
      {Key? key,
      required this.min,
      required this.max,
      required this.value,
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
      required this.sliderThemeData,
      required this.thumbIcon,
      required this.state,
      required this.sliderType,
      required this.tooltipPosition})
      : super(key: key);

  final SliderType sliderType;
  final SliderTooltipPosition? tooltipPosition;
  final dynamic min;
  final dynamic max;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final ValueChanged<dynamic>? onChangeStart;
  final ValueChanged<dynamic>? onChangeEnd;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDividers;
  final bool enableTooltip;
  final bool isInversed;
  final bool shouldAlwaysShowTooltip;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final EdgeLabelPlacement edgeLabelPlacement;
  final NumberFormat numberFormat;
  final DateIntervalType? dateIntervalType;
  final DateFormat? dateFormat;
  final SfSliderThemeData sliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final SfSliderSemanticFormatterCallback? semanticFormatterCallback;
  final SfDividerShape dividerShape;
  final SfTrackShape trackShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTooltipShape tooltipShape;
  final Widget? thumbIcon;
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
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        minorTicksPerInterval: minorTicksPerInterval,
        interval: interval,
        stepSize: stepSize,
        stepDuration: stepDuration,
        showTicks: showTicks,
        showLabels: showLabels,
        showDividers: showDividers,
        enableTooltip: enableTooltip,
        shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
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
        sliderThemeData: sliderThemeData,
        sliderType: sliderType,
        tooltipPosition: tooltipPosition,
        textDirection: Directionality.of(context),
        mediaQueryData: MediaQuery.of(context),
        state: state,
        gestureSettings: MediaQuery.of(context).gestureSettings);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSlider renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..value = value
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
      ..sliderThemeData = sliderThemeData
      ..tooltipPosition = tooltipPosition
      ..textDirection = Directionality.of(context)
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderSliderElement extends RenderObjectElement {
  _RenderSliderElement(_SliderRenderObjectWidget slider) : super(slider);

  final Map<ChildElements, Element> _slotToChild = <ChildElements, Element>{};

  final Map<Element, ChildElements> _childToSlot = <Element, ChildElements>{};

  @override
  _SliderRenderObjectWidget get widget =>
      // ignore: avoid_as
      super.widget as _SliderRenderObjectWidget;

  @override
  // ignore: avoid_as
  _RenderSlider get renderObject => super.renderObject as _RenderSlider;

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
        renderObject.thumbIcon = child as RenderBox?;
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
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _updateChild(widget.thumbIcon, ChildElements.startThumbIcon);
  }

  @override
  void update(_SliderRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.thumbIcon, ChildElements.startThumbIcon);
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

class _RenderSlider extends RenderBaseSlider implements MouseTrackerAnnotation {
  _RenderSlider({
    required dynamic min,
    required dynamic max,
    required dynamic value,
    required ValueChanged<dynamic>? onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool shouldAlwaysShowTooltip,
    required bool isInversed,
    required LabelPlacement labelPlacement,
    required EdgeLabelPlacement edgeLabelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required SfSliderSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDividerShape dividerShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfSliderThemeData sliderThemeData,
    required SliderType sliderType,
    required SliderTooltipPosition? tooltipPosition,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
    required _SfSliderState state,
    required DeviceGestureSettings gestureSettings,
  })  : _state = state,
        _value = value,
        _semanticFormatterCallback = semanticFormatterCallback,
        _onChanged = onChanged,
        super(
          min: min,
          max: max,
          sliderType: sliderType,
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
          tooltipPosition: tooltipPosition,
          sliderThemeData: sliderThemeData,
          textDirection: textDirection,
          mediaQueryData: mediaQueryData,
        ) {
    final GestureArenaTeam team = GestureArenaTeam();
    if (sliderType == SliderType.horizontal) {
      horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
        ..team = team
        ..onStart = _onDragStart
        ..onUpdate = _onDragUpdate
        ..onEnd = _onDragEnd
        ..onCancel = _onDragCancel
        ..gestureSettings = gestureSettings;
    }

    if (sliderType == SliderType.vertical) {
      verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
        ..team = team
        ..onStart = _onVerticalDragStart
        ..onUpdate = _onVerticalDragUpdate
        ..onEnd = _onVerticalDragEnd
        ..onCancel = _onVerticalDragCancel
        ..gestureSettings = gestureSettings;
    }

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

    if (shouldAlwaysShowTooltip) {
      _state.tooltipAnimationController.value = 1;
    }

    updateTextPainter();

    if (isDateTime) {
      _valueInMilliseconds =
          // ignore: avoid_as
          (value as DateTime).millisecondsSinceEpoch.toDouble();
    }
  }

  final _SfSliderState _state;

  late Animation<double> _overlayAnimation;

  late Animation<double> _stateAnimation;

  late Animation<double> _tooltipAnimation;

  late bool _validForMouseTracker;

  late dynamic _newValue;

  ValueChanged<dynamic>? onChangeStart;

  ValueChanged<dynamic>? onChangeEnd;

  double? _valueInMilliseconds;

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
      _valueInMilliseconds =
          // ignore: avoid_as
          (_value as DateTime).millisecondsSinceEpoch.toDouble();
    }
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  ValueChanged<dynamic>? get onChanged => _onChanged;
  ValueChanged<dynamic>? _onChanged;

  set onChanged(ValueChanged<dynamic>? value) {
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

  SfSliderSemanticFormatterCallback? get semanticFormatterCallback =>
      _semanticFormatterCallback;
  SfSliderSemanticFormatterCallback? _semanticFormatterCallback;

  set semanticFormatterCallback(SfSliderSemanticFormatterCallback? value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  RenderBox? get thumbIcon => _thumbIcon;
  RenderBox? _thumbIcon;

  set thumbIcon(RenderBox? value) {
    _thumbIcon = _updateChild(_thumbIcon, value, ChildElements.startThumbIcon);
  }

  @override
  bool get isInteractive => onChanged != null;

  double get actualValue =>
      // ignore: avoid_as
      (isDateTime ? _valueInMilliseconds : _value.toDouble()) as double;

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_thumbIcon != null) {
      yield _thumbIcon!;
    }
  }

  dynamic get _increasedValue {
    return getNextSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  dynamic get _decreasedValue {
    return getPrevSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
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

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    mainAxisOffset = sliderType == SliderType.horizontal
        ? globalToLocal(details.globalPosition).dx
        : globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _updateValue();
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _updateValue();
    markNeedsPaint();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onVerticalDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    isInteractionEnd = false;
    onChangeStart?.call(_value);
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
                AnimationStatus.completed &&
            !shouldAlwaysShowTooltip) {
          _state.tooltipAnimationController.reverse();
        }
      });
    }

    _updateValue();
    markNeedsPaint();
  }

  void _updateValue() {
    final double factor = getFactorFromCurrentPosition();
    final double valueFactor = lerpDouble(actualMin, actualMax, factor)!;
    _newValue = getActualValue(valueInDouble: valueFactor);

    if (_newValue != _value) {
      onChanged!(_newValue);
    }
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      _state.overlayController.reverse();
      if (enableTooltip &&
          _state.tooltipDelayTimer == null &&
          !shouldAlwaysShowTooltip) {
        _state.tooltipAnimationController.reverse();
        if (_state.tooltipAnimationController.status ==
            AnimationStatus.dismissed) {
          willDrawTooltip = false;
        }
      }

      currentPointerType = PointerType.up;
      isInteractionEnd = true;
      onChangeEnd?.call(_newValue);
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
    if (willDrawTooltip || shouldAlwaysShowTooltip) {
      final Paint paint = Paint()
        ..color = sliderThemeData.tooltipBackgroundColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      final dynamic actualText = sliderType == SliderType.horizontal
          ? getValueFromPosition(thumbCenter.dx - offset.dx)
          : getValueFromPosition(trackRect.bottom - thumbCenter.dy);
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
      onChanged!(_increasedValue);
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged!(_decreasedValue);
    }
  }

  void _handleEnter(PointerEnterEvent event) {
    _state.overlayController.forward();
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationController.forward();
    }
  }

  void _handleExit(PointerExitEvent event) {
    // Ensuring whether the thumb is drag or move
    // not needed to call controller's reverse.
    if (_state.mounted && currentPointerType != PointerType.move) {
      _state.overlayController.reverse();
      if (enableTooltip && !shouldAlwaysShowTooltip) {
        _state.tooltipAnimationController.reverse();
      }
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    _overlayAnimation.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
    _tooltipAnimation.addListener(markNeedsPaint);
    _tooltipAnimation.addStatusListener(_handleTooltipAnimationStatusChange);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    _overlayAnimation.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    _tooltipAnimation.removeListener(markNeedsPaint);
    _tooltipAnimation.removeStatusListener(_handleTooltipAnimationStatusChange);
    super.detach();
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  void dispose() {
    horizontalDragGestureRecognizer?.dispose();
    verticalDragGestureRecognizer?.dispose();
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener get onEnter => _handleEnter;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  void performLayout() {
    super.performLayout();
    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: actualThumbSize.width, height: actualThumbSize.height);
    _thumbIcon?.layout(contentConstraints, parentUsesSize: true);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position) && isInteractive) {
      if (_thumbIcon != null &&
          ((_thumbIcon!.parentData! as BoxParentData).offset & _thumbIcon!.size)
              .contains(position)) {
        final Offset center = _thumbIcon!.size.center(Offset.zero);
        result.addWithRawTransform(
          transform: MatrixUtils.forceToPoint(center),
          position: position,
          hitTest: (BoxHitTestResult result, Offset? position) {
            return thumbIcon!.hitTest(result, position: center);
          },
        );
      }
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
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

    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbPosition = getFactorFromValue(actualValue) *
        (sliderType == SliderType.horizontal
            ? trackRect.width
            : trackRect.height);
    final Offset thumbCenter = sliderType == SliderType.horizontal
        ? Offset(trackRect.left + thumbPosition, trackRect.center.dy)
        : Offset(trackRect.center.dx, trackRect.bottom - thumbPosition);

    trackShape.paint(context, actualTrackOffset, thumbCenter, null, null,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        activePaint: null,
        inactivePaint: null);

    if (showLabels || showTicks || showDividers) {
      drawLabelsTicksAndDividers(context, trackRect, offset, thumbCenter, null,
          null, _stateAnimation, _value, null);
    }

    // Drawing overlay.
    overlayShape.paint(context, thumbCenter,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        animation: _overlayAnimation,
        thumb: null,
        paint: null);

    if (_thumbIcon != null) {
      (_thumbIcon!.parentData! as BoxParentData).offset = thumbCenter -
          Offset(_thumbIcon!.size.width / 2, _thumbIcon!.size.height / 2) -
          offset;
    }
    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: _thumbIcon,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: null,
        paint: null);

    // To avoid positioning the tooltip text on the edge, used a 5px margin.
    final Rect tooltipTargetRect = Rect.fromLTWH(
        5.0, trackRect.top, mediaQueryData.size.width - 5.0, trackRect.height);
    _drawTooltip(
        context, thumbCenter, offset, actualTrackOffset, tooltipTargetRect);
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
        config.value = semanticFormatterCallback!(value);
        config.increasedValue = semanticFormatterCallback!(_increasedValue);
        config.decreasedValue = semanticFormatterCallback!(_decreasedValue);
      } else {
        config.value = '$value';
        config.increasedValue = '$_increasedValue';
        config.decreasedValue = '$_decreasedValue';
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'thumbSize', thumbShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'activeDividerSize',
        dividerShape
            .getPreferredSize(sliderThemeData, isActive: true)
            .toString()));
    properties.add(StringProperty(
        'inactiveDividerSize',
        dividerShape
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
