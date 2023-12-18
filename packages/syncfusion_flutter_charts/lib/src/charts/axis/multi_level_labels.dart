import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// Class which holds the properties of multi-level labels
class ChartMultiLevelLabel<T> {
  /// Constructor for ChartMultiLevelLabel class
  const ChartMultiLevelLabel({
    required this.start,
    required this.end,
    this.level = 0,
    this.text = '',
  });

  /// Start value of the multi-level label.
  /// The value from where the multi-level label border needs to start.
  ///
  /// The [start] value for the category axis needs to string type, in the case
  /// of date-time or date-time category axes need to be date-time and in the
  /// case of numeric or logarithmic axes need to double.
  ///
  /// Defaults to 'null'
  ///
  /// ```dart
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
  /// ```
  final T start;

  /// End value of the multi-level label.
  /// The value where the multi-level label border needs to end.
  ///
  /// The [end] value for the category axis need to string type, in the case of
  ///  date-time or date-time category axes need to be date-time and in the
  /// case of numeric or logarithmic axes need to double.
  ///
  /// Defaults to 'null'
  ///
  /// ```dart
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
  /// ```
  final T end;

  /// Text to be displayed in grouping label as the multi-level label.
  ///
  /// Defaults to 'null'
  ///
  /// ```dart
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
  /// ```
  final String text;

  /// Level specifies in which row the multi-level label should be positioned.
  ///
  /// Defaults to '0'
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCartesianChart(
  ///       primaryXAxis:
  ///         NumericAxis(multiLevelLabels: const <NumericMultiLevelLabel>[
  ///           NumericMultiLevelLabel(
  ///             start: 0,
  ///             end: 4,
  ///             level: 1,
  ///             text: 'First Level',
  ///           )
  ///         ]
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final int level;
}

/// Provides options to customize the start, the end value of a multi-level
/// label, text, and level of the multi-level labels.
///
/// The [start] and [end] values need to be double type.
///
/// ```dart
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
/// ```
class NumericMultiLevelLabel extends ChartMultiLevelLabel<double> {
  /// Constructor for [NumericMultiLevelLabel] class.
  const NumericMultiLevelLabel({
    required super.start,
    required super.end,
    super.level,
    super.text,
  });
}

/// Provides options to customize the start, the end value of a multi-level
/// label, text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be string type.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis: CategoryAxis(
///         multiLevelLabels: const <CategoricalMultiLevelLabel>[
///          CategoricalMultiLevelLabel(start: 'Jan', end: 'Feb', text: 'First')
///         ]
///       )
///     )
///   );
/// }
/// ```
class CategoricalMultiLevelLabel extends ChartMultiLevelLabel<String> {
  /// Constructor for [CategoricalMultiLevelLabel] class.
  const CategoricalMultiLevelLabel({
    required super.start,
    required super.end,
    super.level,
    super.text,
  });
}

/// Provides options to customize the start, the end value of a multi-level
/// label, text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be date-time type.
///
/// ```dart
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
/// ```
class DateTimeMultiLevelLabel extends ChartMultiLevelLabel<DateTime> {
  /// Constructor for [DateTimeMultiLevelLabel] class.
  const DateTimeMultiLevelLabel({
    required super.start,
    required super.end,
    super.level,
    super.text,
  });
}

/// Provides options to customize the start, the end value of a multi-level
/// label, text, and level of the multi-level labels.
///
/// The [start] and [end] value need to be date-time type.
///
/// ```dart
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
/// ```
class DateTimeCategoricalMultiLevelLabel extends DateTimeMultiLevelLabel {
  /// Constructor for [DateTimeCategoryMultiLevelLabel] class
  const DateTimeCategoricalMultiLevelLabel({
    required super.start,
    required super.end,
    super.level,
    super.text,
  });
}

/// Provides options to customize the start, the end value of a multi-level
/// label, text, and level of the multi-level labels.
///
/// The [start] and [end] values need to be double type.
///
///```dart
/// Widget build(BuildContext context) {
///   return Container(
///     child: SfCartesianChart(
///       primaryXAxis:
///        LogarithmicAxis(multiLevelLabels: const <LogarithmicMultiLevelLabel>[
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
  /// Constructor for LogarithmicMultiLevelLabel class.
  const LogarithmicMultiLevelLabel({
    required super.start,
    required super.end,
    super.level,
    super.text,
  });
}

/// Customize the multi-level label’s border color, width, type, and
/// text style such as color, font size, etc.
///
/// When the multi-level label’s width exceeds its respective segment,
/// then the label will get trimmed and on tapping / hovering over the trimmed
/// label, a tooltip will be shown.
///
/// Also refer [multiLevelLabelFormatter].
class MultiLevelLabelStyle {
  /// Creating an argument constructor of [MultiLevelLabelStyle] class.
  const MultiLevelLabelStyle({
    this.textStyle,
    this.borderWidth = 0,
    this.borderColor,
    this.borderType = MultiLevelBorderType.rectangle,
  });

  /// Specifies the text style of the multi-level labels.
  ///
  /// ```dart
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
  /// ```
  final TextStyle? textStyle;

  /// Specifies the border width of multi-level labels.
  ///
  /// Defaults to '0'
  ///
  /// ```dart
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
  /// ```
  final double borderWidth;

  /// Specifies the border color of multi-level labels.
  ///
  /// Defaults to 'null'
  ///
  /// ```dart
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
  /// ```
  final Color? borderColor;

  /// Specifies the border type of multi-level labels.
  ///
  /// Defaults to 'MultiLevelLabelBorderType.rectangle'
  ///
  /// ```dart
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
  /// ```
  final MultiLevelBorderType borderType;
}

/// Holds the multi-level axis label information.
class AxisMultilevelLabel {
  /// Argument constructor of [AxisMultilevelLabel] class.
  AxisMultilevelLabel(
    this.text,
    this.level,
    this.start,
    this.end,
  );

  /// Contains the text of the label.
  String text;

  /// Stores the level given by the user.
  int level;

  /// Stores the actual start value.
  num start;

  /// Stores the actual end value.
  num end;

  /// Contains the label text to be rendered.
  late Size actualTextSize;

  /// Contains the label text to be rendered.
  late String renderText;

  /// Contains the trimmed label text to be rendered.
  late String trimmedText;

  /// Specifies the label text style.
  late TextStyle style;

  /// Stores the transform start value.
  late num transformStart;

  /// Stores the transform end value.
  late num transformEnd;

  /// To store the rect region for trimmed labels tooltip rendering.
  late Rect region;
}
