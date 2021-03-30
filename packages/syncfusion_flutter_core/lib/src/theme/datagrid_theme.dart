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
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;

    gridLineColor ??= isLight
        ? const Color.fromRGBO(0, 0, 0, 0.26)
        : const Color.fromRGBO(255, 255, 255, 0.26);

    gridLineStrokeWidth ??= 1;

    selectionColor ??= isLight
        ? const Color.fromRGBO(238, 238, 238, 1)
        : const Color.fromRGBO(48, 48, 48, 1);

    currentCellStyle ??= isLight
        ? const DataGridCurrentCellStyle(
            borderColor: Color.fromRGBO(0, 0, 0, 0.36), borderWidth: 1.0)
        : const DataGridCurrentCellStyle(
            borderColor: Color.fromRGBO(255, 255, 255, 0.36), borderWidth: 1.0);

    frozenPaneLineColor ??= isLight
        ? const Color.fromRGBO(0, 0, 0, 0.24)
        : const Color.fromRGBO(255, 255, 255, 0.24);

    frozenPaneLineWidth ??= 2;

    headerHoverColor ??= isLight
        ? Color.fromRGBO(245, 245, 245, 1)
        : Color.fromRGBO(66, 66, 66, 1);

    sortIconColor ??= isLight ? Colors.black54 : Colors.white54;

    headerColor ??= isLight
        ? Color.fromRGBO(255, 255, 255, 1)
        : Color.fromRGBO(33, 33, 33, 1);

    frozenPaneElevation ??= 5.0;

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
    );
  }

  /// Create a [SfDataGridThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfDataGridThemeData] constructor.
  ///
  const SfDataGridThemeData.raw({
    required this.brightness,
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
  });

  /// The brightness of the overall theme of the
  /// application for the [SfDataGrid] widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
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
  final Brightness brightness;

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
  final Color gridLineColor;

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
  final double gridLineStrokeWidth;

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
  final Color selectionColor;

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
  final DataGridCurrentCellStyle currentCellStyle;

  /// The width of the line which indicates the frozen pane.
  ///
  /// This is applicable for both the frozen column and row.
  final double frozenPaneLineWidth;

  /// The color of the line which indicates the frozen pane.
  ///
  /// This is applicable for both the frozen column and row.
  final Color frozenPaneLineColor;

  /// The color of the sort icon which indicates the ascending or descending
  /// order.
  final Color sortIconColor;

  /// The background color of header cells when a pointer is hovering over it
  /// in [SfDataGrid].
  final Color headerHoverColor;

  /// The color for the header cells in the [SfDataGrid].
  final Color headerColor;

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
  final double frozenPaneElevation;

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
            lerpDouble(a.frozenPaneElevation, b.frozenPaneElevation, t));
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
        other.frozenPaneElevation == frozenPaneElevation;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
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
