import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant [SfDataGrid] widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfDataGridTheme(
///       data: SfDataGridThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfDataGrid(columns: [],
///       source: _dataGridSource)
///     ),
///   );
/// }
/// ```
class SfDataGridTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  const SfDataGridTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant [SfDataGrid]
  /// widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGridTheme(
  ///       data: SfDataGridThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfDataGrid(columns: [],
  ///       source: _dataGridSource)
  ///     ),
  ///   );
  /// }
  /// ```
  final SfDataGridThemeData data;

  /// The widget below this widget in the tree.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGridTheme(
  ///       data: SfDataGridThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfDataGrid(columns: [],
  ///       source: _dataGridSource)
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfDataGridTheme]
  /// instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.dataGridThemeData] if there
  /// is no [SfDataGridTheme] in the given build context.
  ///
  static SfDataGridThemeData of(BuildContext context) {
    final SfDataGridTheme? sfDataGridTheme =
        context.dependOnInheritedWidgetOfExactType<SfDataGridTheme>();
    return sfDataGridTheme?.data ?? SfTheme.of(context).dataGridThemeData;
  }

  @override
  bool updateShouldNotify(SfDataGridTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfDataGridTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfDataGridTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfDataGridTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfDataGridTheme]. Use
///  this class to configure a [SfDataGridTheme] widget
///
/// To obtain the current theme, use [SfDataGridTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfDataGridTheme(
///       data: SfDataGridThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfDataGrid(columns: [],
///       source: _dataGridSource)
///     ),
///   );
/// }
/// ```
///
@immutable
class SfDataGridThemeData with Diagnosticable {
  /// Create a [SfDataGridThemeData] that's used to configure a
  /// [SfDataGridTheme].
  factory SfDataGridThemeData({
    Brightness? brightness,
    Color? gridLineColor,
    double? gridLineStrokeWidth,
    Color? selectionColor,
    DataGridCurrentCellStyle? currentCellStyle,
    Color? frozenPaneLineColor,
    double? frozenPaneLineWidth,
    Color? sortIconColor,
    Color? headerHoverColor,
    Color? headerColor,
    double? frozenPaneElevation,
    Color? rowHoverColor,
    Color? columnResizeIndicatorColor,
    double? columnResizeIndicatorStrokeWidth,
    TextStyle? rowHoverTextStyle,
    Widget? sortIcon,
  }) {
    return SfDataGridThemeData.raw(
        brightness: brightness,
        gridLineColor: gridLineColor,
        gridLineStrokeWidth: gridLineStrokeWidth,
        selectionColor: selectionColor,
        currentCellStyle: currentCellStyle,
        frozenPaneLineColor: frozenPaneLineColor,
        frozenPaneLineWidth: frozenPaneLineWidth,
        headerHoverColor: headerHoverColor,
        sortIconColor: sortIconColor,
        headerColor: headerColor,
        frozenPaneElevation: frozenPaneElevation,
        rowHoverColor: rowHoverColor,
        columnResizeIndicatorColor: columnResizeIndicatorColor,
        columnResizeIndicatorStrokeWidth: columnResizeIndicatorStrokeWidth,
        rowHoverTextStyle: rowHoverTextStyle,
        sortIcon: sortIcon);
  }

  /// Create a [SfDataGridThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfDataGridThemeData] constructor.
  ///
  const SfDataGridThemeData.raw(
      {required this.brightness,
      required this.gridLineColor,
      required this.gridLineStrokeWidth,
      required this.selectionColor,
      required this.currentCellStyle,
      required this.frozenPaneLineColor,
      required this.frozenPaneLineWidth,
      required this.sortIconColor,
      required this.headerColor,
      required this.headerHoverColor,
      required this.frozenPaneElevation,
      required this.columnResizeIndicatorColor,
      required this.columnResizeIndicatorStrokeWidth,
      required this.rowHoverColor,
      required this.rowHoverTextStyle,
      required this.sortIcon});

  /// The brightness of the overall theme of the
  /// application for the [SfDataGrid] widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).colorScheme.brightness], brightness for
  /// datagrid widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           dataGridThemeData: SfDataGridThemeData(
  ///             brightness: Brightness.dark
  ///           )
  ///         ),
  ///         child: SfDataGrid(),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final Brightness? brightness;

  /// The color for grid line.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           dataGridThemeData: SfDataGridThemeData(
  ///             gridLineColor: Colors.red
  ///           )
  ///         ),
  ///         child: SfDataGrid(),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final Color? gridLineColor;

  /// The width for grid line.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           dataGridThemeData: SfDataGridThemeData(
  ///             gridLineStrokeWidth: 2
  ///           )
  ///         ),
  ///         child: SfDataGrid(),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final double? gridLineStrokeWidth;

  /// Defines the default configuration of selection in [SfDataGrid].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           dataGridThemeData: SfDataGridThemeData(
  ///             selectionStyle: DataGridCellStyle(
  ///               backgroundColor: Colors.blue,
  ///               textStyle: TextStyle(color: Colors.black)
  ///             )
  ///           )
  ///         ),
  ///         child: SfDataGrid(),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final Color? selectionColor;

  /// Defines the default configuration of current cell in [SfDataGrid].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           dataGridThemeData: SfDataGridThemeData(
  ///             currentCellStyle: DataGridCurrentCellStyle(
  ///               borderColor: Colors.red, borderWidth: 2
  ///             )
  ///           )
  ///         ),
  ///         child: SfDataGrid(),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final DataGridCurrentCellStyle? currentCellStyle;

  /// The width of the line which indicates the frozen pane.
  ///
  /// This is applicable for both the frozen column and row.
  final double? frozenPaneLineWidth;

  /// The color of the line which indicates the frozen pane.
  ///
  /// This is applicable for both the frozen column and row.
  final Color? frozenPaneLineColor;

  /// The color of the sort icon which indicates the ascending or descending
  /// order.
  final Color? sortIconColor;

  /// The background color of header cells when a pointer is hovering over it
  /// in [SfDataGrid].
  final Color? headerHoverColor;

  /// The color for the header cells in the [SfDataGrid].
  final Color? headerColor;

  /// The elevation of the frozen pane line.
  ///
  /// This controls the size of the shadow below the frozen pane line.
  ///
  /// This is applicable for both the frozen column and row.
  ///
  /// If you want to hide the shadow and show only line, you can set this
  /// property as 0.0.
  ///
  /// Defaults to 5.0. The value is always non-negative.
  final double? frozenPaneElevation;

  /// The color of the line which indicates the column resizing.
  final Color? columnResizeIndicatorColor;

  /// The width of the line which indicates the column resizing.
  final double? columnResizeIndicatorStrokeWidth;

  /// The color for the row when a pointer is hovering over it.
  final Color? rowHoverColor;

  /// The default [TextStyle] for the row when a pointer is hovering over it.
  final TextStyle? rowHoverTextStyle;

  /// The icon to display for sort order.

  ///

  /// If icon is given, the animation will be automatically applied and
  /// rotated according to sorting order.

  ///

  /// [SfDataGridThemeData.sortIconColor] – The color of the sort icon.
  final Widget? sortIcon;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfDataGridThemeData copyWith({
    Brightness? brightness,
    Color? gridLineColor,
    double? gridLineStrokeWidth,
    Color? selectionColor,
    DataGridCurrentCellStyle? currentCellStyle,
    double? frozenPaneLineWidth,
    Color? frozenPaneLineColor,
    Color? sortIconColor,
    Color? headerHoverColor,
    Color? headerColor,
    double? frozenPaneElevation,
    Color? columnResizeIndicatorColor,
    double? columnResizeIndicatorStrokeWidth,
    Color? rowHoverColor,
    TextStyle? rowHoverTextStyle,
    Widget? sortIcon,
  }) {
    return SfDataGridThemeData.raw(
      brightness: brightness ?? this.brightness,
      gridLineColor: gridLineColor ?? this.gridLineColor,
      gridLineStrokeWidth: gridLineStrokeWidth ?? this.gridLineStrokeWidth,
      selectionColor: selectionColor ?? this.selectionColor,
      currentCellStyle: currentCellStyle ?? this.currentCellStyle,
      frozenPaneLineColor: frozenPaneLineColor ?? this.frozenPaneLineColor,
      frozenPaneLineWidth: frozenPaneLineWidth ?? this.frozenPaneLineWidth,
      sortIconColor: sortIconColor ?? this.sortIconColor,
      headerColor: headerColor ?? this.headerColor,
      headerHoverColor: headerHoverColor ?? this.headerHoverColor,
      frozenPaneElevation: frozenPaneElevation ?? this.frozenPaneElevation,
      columnResizeIndicatorColor:
          columnResizeIndicatorColor ?? this.columnResizeIndicatorColor,
      columnResizeIndicatorStrokeWidth: columnResizeIndicatorStrokeWidth ??
          this.columnResizeIndicatorStrokeWidth,
      rowHoverColor: rowHoverColor ?? this.rowHoverColor,
      rowHoverTextStyle: rowHoverTextStyle ?? this.rowHoverTextStyle,
      sortIcon: sortIcon ?? this.sortIcon,
    );
  }

  /// Linearly interpolate between two themes.
  static SfDataGridThemeData? lerp(
      SfDataGridThemeData? a, SfDataGridThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfDataGridThemeData(
      gridLineColor: Color.lerp(a!.gridLineColor, b!.gridLineColor, t),
      gridLineStrokeWidth:
          lerpDouble(a.gridLineStrokeWidth, b.gridLineStrokeWidth, t),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      currentCellStyle: DataGridCurrentCellStyle.lerp(
          a.currentCellStyle, b.currentCellStyle, t),
      frozenPaneLineColor:
          Color.lerp(a.frozenPaneLineColor, b.frozenPaneLineColor, t),
      frozenPaneLineWidth:
          lerpDouble(a.frozenPaneLineWidth, b.frozenPaneLineWidth, t),
      sortIconColor: Color.lerp(a.sortIconColor, b.sortIconColor, t),
      headerHoverColor: Color.lerp(a.headerHoverColor, b.headerHoverColor, t),
      headerColor: Color.lerp(a.headerColor, b.headerColor, t),
      frozenPaneElevation:
          lerpDouble(a.frozenPaneElevation, b.frozenPaneElevation, t),
      rowHoverColor: Color.lerp(a.rowHoverColor, b.rowHoverColor, t),
      columnResizeIndicatorColor: Color.lerp(
          a.columnResizeIndicatorColor, b.columnResizeIndicatorColor, t),
      columnResizeIndicatorStrokeWidth: lerpDouble(
          a.columnResizeIndicatorStrokeWidth,
          b.columnResizeIndicatorStrokeWidth,
          t),
      rowHoverTextStyle:
          TextStyle.lerp(a.rowHoverTextStyle, b.rowHoverTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfDataGridThemeData &&
        other.brightness == brightness &&
        other.gridLineColor == gridLineColor &&
        other.gridLineStrokeWidth == gridLineStrokeWidth &&
        other.selectionColor == selectionColor &&
        other.currentCellStyle == currentCellStyle &&
        other.frozenPaneLineWidth == frozenPaneLineWidth &&
        other.frozenPaneLineColor == frozenPaneLineColor &&
        other.sortIconColor == sortIconColor &&
        other.headerHoverColor == headerHoverColor &&
        other.headerColor == headerColor &&
        other.frozenPaneElevation == frozenPaneElevation &&
        other.rowHoverColor == rowHoverColor &&
        other.columnResizeIndicatorColor == columnResizeIndicatorColor &&
        other.columnResizeIndicatorStrokeWidth ==
            columnResizeIndicatorStrokeWidth &&
        other.rowHoverTextStyle == rowHoverTextStyle &&
        other.sortIcon == sortIcon;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      gridLineColor,
      gridLineStrokeWidth,
      selectionColor,
      currentCellStyle,
      frozenPaneLineColor,
      frozenPaneLineWidth,
      sortIconColor,
      headerHoverColor,
      headerColor,
      frozenPaneElevation,
      rowHoverColor,
      columnResizeIndicatorColor,
      columnResizeIndicatorStrokeWidth,
      rowHoverTextStyle,
      sortIcon
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfDataGridThemeData defaultData = SfDataGridThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('gridLineColor', gridLineColor,
        defaultValue: defaultData.gridLineColor));
    properties.add(DoubleProperty('gridLineStrokeWidth', gridLineStrokeWidth,
        defaultValue: defaultData.gridLineStrokeWidth));
    properties.add(ColorProperty('selectionColor', selectionColor,
        defaultValue: defaultData.selectionColor));
    properties.add(DiagnosticsProperty<DataGridCurrentCellStyle>(
        'currentCellStyle', currentCellStyle,
        defaultValue: defaultData.currentCellStyle));
    properties.add(ColorProperty('frozenPaneLineColor', frozenPaneLineColor,
        defaultValue: defaultData.frozenPaneLineColor));
    properties.add(DoubleProperty('frozenPaneLineWidth', frozenPaneLineWidth,
        defaultValue: defaultData.frozenPaneLineWidth));
    properties.add(ColorProperty('sortIconColor', sortIconColor,
        defaultValue: defaultData.sortIconColor));
    properties.add(ColorProperty('headerHoverColor', headerHoverColor,
        defaultValue: defaultData.headerHoverColor));
    properties.add(ColorProperty('headerColor', headerColor,
        defaultValue: defaultData.headerColor));
    properties.add(DoubleProperty('frozenPaneElevation', frozenPaneElevation,
        defaultValue: defaultData.frozenPaneElevation));
    properties.add(ColorProperty(
        'columnResizeIndicatorColor', columnResizeIndicatorColor,
        defaultValue: defaultData.columnResizeIndicatorColor));
    properties.add(DoubleProperty(
        'columnResizeIndicatorStrokeWidth', columnResizeIndicatorStrokeWidth,
        defaultValue: defaultData.columnResizeIndicatorStrokeWidth));
    properties.add(ColorProperty('rowHoverColor', rowHoverColor,
        defaultValue: defaultData.rowHoverColor));
    properties.add(DiagnosticsProperty<TextStyle>(
        'rowHoverTextStyle', rowHoverTextStyle,
        defaultValue: defaultData.rowHoverTextStyle));
  }
}

/// Defines the configuration of the current cell in [SfDataGrid].
class DataGridCurrentCellStyle {
  /// Create a [DataGridCurrentCellStyle] that's used to configure
  /// a style for the current cell in [SfDataGrid].
  const DataGridCurrentCellStyle(
      {required this.borderColor, required this.borderWidth});

  /// The color of the border in current cell.
  final Color borderColor;

  //// The width of the border in current cell.
  final double borderWidth;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DataGridCurrentCellStyle &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object> values = <Object>[
      borderColor,
      borderWidth,
    ];
    return hashList(values);
  }

  /// Linearly interpolate between two styles.
  static DataGridCurrentCellStyle? lerp(
      DataGridCurrentCellStyle? a, DataGridCurrentCellStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return DataGridCurrentCellStyle(
        borderColor: Color.lerp(a!.borderColor, b!.borderColor, t)!,
        borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!);
  }
}
