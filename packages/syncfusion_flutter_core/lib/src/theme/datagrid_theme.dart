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
  const SfDataGridThemeData({
    this.gridLineColor,
    this.gridLineStrokeWidth,
    this.selectionColor,
    this.currentCellStyle,
    this.frozenPaneLineColor,
    this.frozenPaneLineWidth,
    this.sortIconColor,
    this.headerColor,
    this.headerHoverColor,
    this.frozenPaneElevation,
    this.columnResizeIndicatorColor,
    this.columnResizeIndicatorStrokeWidth,
    this.rowHoverColor,
    this.rowHoverTextStyle,
    this.sortIcon,
    this.filterIcon,
    this.filterIconColor,
    this.filterIconHoverColor,
    this.sortOrderNumberColor,
    this.sortOrderNumberBackgroundColor,
    this.filterPopupTextStyle,
    this.filterPopupDisabledTextStyle,
    this.columnDragIndicatorColor,
    this.columnDragIndicatorStrokeWidth,
    this.groupExpanderIcon,
    this.indentColumnWidth,
    this.indentColumnColor,
    this.captionSummaryRowColor,
    this.filterPopupCheckColor,
    this.filterPopupCheckboxFillColor,
    this.filterPopupInputBorderColor,
    this.filterPopupBackgroundColor,
    this.filterPopupIconColor,
    this.filterPopupDisabledIconColor,
    this.advancedFilterPopupDropdownColor,
    this.noMatchesFilteringLabelColor,
    this.okFilteringLabelColor,
    this.okFilteringLabelButtonColor,
    this.cancelFilteringLabelColor,
    this.cancelFilteringLabelButtonColor,
    this.searchAreaFocusedBorderColor,
    this.searchAreaCursorColor,
    this.andRadioActiveColor,
    this.andRadioFillColor,
    this.orRadioActiveColor,
    this.orRadioFillColor,
    this.advancedFilterValueDropdownFocusedBorderColor,
    this.advancedFilterTypeDropdownFocusedBorderColor,
    this.calendarIconColor,
    this.advancedFilterValueTextAreaCursorColor,
    this.caseSensitiveIconColor,
    this.caseSensitiveIconActiveColor,
    this.advancedFilterPopupDropdownIconColor,
    this.searchIconColor,
    this.closeIconColor,
    this.advancedFilterValueDropdownIconColor,
    this.advancedFilterTypeDropdownIconColor,
    this.filterPopupTopDividerColor,
    this.filterPopupBottomDividerColor,
    this.okFilteringLabelDisabledButtonColor,
    this.appBarBottomBorderColor,
  });

  /// Create a [SfDataGridThemeData] that's used to configure a
  /// [SfDataGridTheme].
  factory SfDataGridThemeData.raw({
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
    Widget? filterIcon,
    Color? filterIconColor,
    Color? filterIconHoverColor,
    Color? sortOrderNumberColor,
    Color? sortOrderNumberBackgroundColor,
    TextStyle? filterPopupTextStyle,
    TextStyle? filterPopupDisabledTextStyle,
    Color? columnDragIndicatorColor,
    double? columnDragIndicatorStrokeWidth,
    Widget? groupExpanderIcon,
    double? indentColumnWidth,
    Color? indentColumnColor,
    Color? captionSummaryRowColor,
    Color? filterPopupCheckColor,
    WidgetStateProperty<Color?>? filterPopupCheckboxFillColor,
    Color? filterPopupInputBorderColor,
    Color? filterPopupBackgroundColor,
    Color? filterPopupIconColor,
    Color? filterPopupDisabledIconColor,
    Color? advancedFilterPopupDropdownColor,
    Color? noMatchesFilteringLabelColor,
    Color? okFilteringLabelColor,
    Color? okFilteringLabelButtonColor,
    Color? cancelFilteringLabelColor,
    Color? cancelFilteringLabelButtonColor,
    Color? searchAreaCursorColor,
    Color? searchAreaFocusedBorderColor,
    Color? andRadioActiveColor,
    WidgetStateProperty<Color?>? andRadioFillColor,
    Color? orRadioActiveColor,
    WidgetStateProperty<Color?>? orRadioFillColor,
    Color? advancedFilterValueDropdownFocusedBorderColor,
    Color? advancedFilterTypeDropdownFocusedBorderColor,
    Color? calendarIconColor,
    Color? advancedFilterValueTextAreaCursorColor,
    Color? searchIconColor,
    Color? closeIconColor,
    Color? advancedFilterPopupDropdownIconColor,
    Color? caseSensitiveIconActiveColor,
    Color? caseSensitiveIconColor,
    Color? advancedFilterTypeDropdownIconColor,
    Color? advancedFilterValueDropdownIconColor,
    Color? filterPopupTopDividerColor,
    Color? filterPopupBottomDividerColor,
    Color? okFilteringLabelDisabledButtonColor,
    Color? appBarBottomBorderColor,
  }) {
    brightness = brightness ?? Brightness.light;
    return SfDataGridThemeData(
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
      sortIcon: sortIcon,
      filterIcon: filterIcon,
      filterIconColor: filterIconColor,
      filterIconHoverColor: filterIconHoverColor,
      sortOrderNumberColor: sortOrderNumberColor,
      sortOrderNumberBackgroundColor: sortOrderNumberBackgroundColor,
      filterPopupTextStyle: filterPopupTextStyle,
      filterPopupDisabledTextStyle: filterPopupDisabledTextStyle,
      columnDragIndicatorColor: columnDragIndicatorColor,
      columnDragIndicatorStrokeWidth: columnDragIndicatorStrokeWidth,
      groupExpanderIcon: groupExpanderIcon,
      indentColumnWidth: indentColumnWidth,
      indentColumnColor: indentColumnColor,
      captionSummaryRowColor: captionSummaryRowColor,
      filterPopupCheckColor: filterPopupCheckColor,
      filterPopupCheckboxFillColor: filterPopupCheckboxFillColor,
      filterPopupInputBorderColor: filterPopupInputBorderColor,
      filterPopupBackgroundColor: filterPopupBackgroundColor,
      filterPopupIconColor: filterPopupIconColor,
      filterPopupDisabledIconColor: filterPopupDisabledIconColor,
      advancedFilterPopupDropdownColor: advancedFilterPopupDropdownColor,
      noMatchesFilteringLabelColor: noMatchesFilteringLabelColor,
      okFilteringLabelColor: okFilteringLabelColor,
      okFilteringLabelButtonColor: okFilteringLabelButtonColor,
      cancelFilteringLabelColor: cancelFilteringLabelColor,
      cancelFilteringLabelButtonColor: cancelFilteringLabelButtonColor,
      searchAreaCursorColor: searchAreaCursorColor,
      searchAreaFocusedBorderColor: searchAreaFocusedBorderColor,
      andRadioActiveColor: andRadioActiveColor,
      andRadioFillColor: andRadioFillColor,
      orRadioActiveColor: orRadioActiveColor,
      orRadioFillColor: orRadioFillColor,
      calendarIconColor: calendarIconColor,
      advancedFilterTypeDropdownFocusedBorderColor:
          advancedFilterTypeDropdownFocusedBorderColor,
      advancedFilterValueDropdownFocusedBorderColor:
          advancedFilterValueDropdownFocusedBorderColor,
      advancedFilterValueTextAreaCursorColor:
          advancedFilterValueTextAreaCursorColor,
      searchIconColor: searchIconColor,
      closeIconColor: closeIconColor,
      advancedFilterPopupDropdownIconColor:
          advancedFilterPopupDropdownIconColor,
      caseSensitiveIconActiveColor: caseSensitiveIconActiveColor,
      caseSensitiveIconColor: caseSensitiveIconColor,
      advancedFilterTypeDropdownIconColor: advancedFilterTypeDropdownIconColor,
      advancedFilterValueDropdownIconColor:
          advancedFilterValueDropdownIconColor,
      filterPopupBottomDividerColor: filterPopupBottomDividerColor,
      filterPopupTopDividerColor: filterPopupTopDividerColor,
      okFilteringLabelDisabledButtonColor: okFilteringLabelDisabledButtonColor,
      appBarBottomBorderColor: appBarBottomBorderColor,
    );
  }

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

  /// If the [Icon] type is assigned,
  /// the animation will be automatically applied and rotated
  /// according to sorting order.
  ///
  /// If you want to change the icon based on each state of the sorting,
  /// you can use the [Builder] widget and return
  /// the respective icon for the state.
  /// You have to return the icons for all the three states even
  /// if you want to change the icon for specific state.
  ///
  /// The below example shows how to load different icon for each state
  /// i.e. ascending, descending and unsorted order.
  ///

  ///

  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(title: const Text('Flutter SfDataGrid')),
  ///     body: SfDataGridTheme(
  ///       data: SfDataGridThemeData(
  ///         sortIcon: Builder(
  ///           builder: (context) {
  ///             Widget? icon;
  ///             String columnName = '';
  ///             context.visitAncestorElements((element) {
  ///               if (element is GridHeaderCellElement) {
  ///                 columnName = element.column.columnName;
  ///               }
  ///               return true;
  ///             });

  ///             var column = _employeeDataSource.sortedColumns
  ///                 .where((element) => element.name == columnName)
  ///                 .firstOrNull;
  ///             if (column != null) {
  ///               if (column.sortDirection ==
  ///                      DataGridSortDirection.ascending) {
  ///                 icon = const Icon(Icons.arrow_circle_up_rounded,
  ///                         size: 16);
  ///               } else if (column.sortDirection ==
  ///                      DataGridSortDirection.descending) {
  ///                 icon = const Icon(Icons.arrow_circle_down_rounded,
  ///                         size: 16);
  ///               }
  ///             }

  ///             return icon ?? const Icon(Icons.sort_rounded, size: 16);
  ///           },
  ///         ),
  ///       ),
  ///       child: SfDataGrid(),
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget? sortIcon;

  /// The icon to indicate the filtering applied in column.
  ///
  /// If you want to change the icon filter or filtered state, you can use the
  /// [Builder](https://api.flutter.dev/flutter/widgets/Builder-class.html)
  /// widget and return the respective icon for the state. You have to return
  /// the icons for both the states even if you want to change the icon
  /// for specific state.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid',
  ///           overflow: TextOverflow.ellipsis),
  ///     ),
  ///     body: SfDataGridTheme(
  ///       data: SfDataGridThemeData(filterIcon: Builder(
  ///         builder: (context) {
  ///           Widget? icon;
  ///           String columnName = '';
  ///           context.visitAncestorElements((element) {
  ///             if (element is GridHeaderCellElement) {
  ///               columnName = element.column.columnName;
  ///             }
  ///             return true;
  ///           });
  ///           var column = _employeeDataSource.filterConditions.keys
  ///               .where((element) => element == columnName)
  ///               .firstOrNull;

  ///           if (column != null) {
  ///             icon = const Icon(
  ///               Icons.filter_alt_outlined,
  ///               size: 20,
  ///               color: Colors.purple,
  ///             );
  ///           }
  ///           return icon ??
  ///               const Icon(
  ///                 Icons.filter_alt_off_outlined,
  ///                 size: 20,
  ///                 color: Colors.deepOrange,
  ///               );
  ///         },
  ///       )),
  ///       child: SfDataGrid(
  ///         source: _employeeDataSource,
  ///         allowFiltering: true,
  ///         allowSorting: true,
  ///         columns: getColumns(),
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget? filterIcon;

  /// The color of the filter icon which indicates whether
  /// the column is filtered or not.
  ///
  /// This is not applicable when `filterIcon` property is set.
  /// This applies the color to default filter icon only.
  final Color? filterIconColor;

  /// The color for the filter icon when a pointer is hovering over it.
  ///
  /// This is not applicable when `filterIcon` property is set.
  /// This applies the color to default filter icon only.
  final Color? filterIconHoverColor;

  /// The color of the number displayed when the order of the sorting is shown.
  final Color? sortOrderNumberColor;

  /// The color of the rounded background displayed
  /// when the order of the sorting is shown.
  final Color? sortOrderNumberBackgroundColor;

  /// The [TextStyle] of the options in filter popup menu except the items
  /// which are already selected.
  final TextStyle? filterPopupTextStyle;

  /// The [TextStyle] of the disabled options in filter popup menu.
  final TextStyle? filterPopupDisabledTextStyle;

  /// The stroke width of the column drag indicator.
  final double? columnDragIndicatorStrokeWidth;

  /// The color of the column drag indicator.
  final Color? columnDragIndicatorColor;

  /// This icon indicates the expand-collapse state of a group in a
  /// caption summary row.
  ///
  /// It will be displayed only if the
  /// [SfDataGrid.autoExpandCollapseGroup] property is set to true.
  final Widget? groupExpanderIcon;

  /// The width of an indent column.
  ///
  /// Defaults to 40.0.
  final double? indentColumnWidth;

  /// The color of an indent column.
  final Color? indentColumnColor;

  /// The color of the caption summary row.
  final Color? captionSummaryRowColor;

  /// The checkmark color of the checkbox in the filter popup.
  final Color? filterPopupCheckColor;

  /// The fill color of the checkbox in the filter popup.
  final WidgetStateProperty<Color?>? filterPopupCheckboxFillColor;

  /// The border color of the text field (input box) inside the filter popup.
  final Color? filterPopupInputBorderColor;

  /// The background color of the filter popup.
  final Color? filterPopupBackgroundColor;

  /// The color of icons displayed in the filter popup.
  final Color? filterPopupIconColor;

  /// The color of disabled icons in the filter popup.
  final Color? filterPopupDisabledIconColor;

  /// The background color of the dropdown in the advanced filter popup.
  final Color? advancedFilterPopupDropdownColor;

  /// The color of the "No Matches" filtering label when no results are found.
  final Color? noMatchesFilteringLabelColor;

  /// The color of the OK label in the filtering popup.
  final Color? okFilteringLabelColor;

  /// The color of the OK button in the filtering popup.
  final Color? okFilteringLabelButtonColor;

  /// The color of the cancel label in the filtering popup.
  final Color? cancelFilteringLabelColor;

  /// The color of the cancel button in the filtering popup.
  final Color? cancelFilteringLabelButtonColor;

  /// The cursor color in the search area.
  final Color? searchAreaCursorColor;

  /// The focused border color of the search area.
  final Color? searchAreaFocusedBorderColor;

  /// The active (selected) color of the "AND" radio button.
  final Color? andRadioActiveColor;

  /// The fill color of the "AND" radio button.
  final WidgetStateProperty<Color?>? andRadioFillColor;

  /// The active (selected) color of the "OR" radio button.
  final Color? orRadioActiveColor;

  /// The fill color of the "OR" radio button.
  final WidgetStateProperty<Color?>? orRadioFillColor;

  /// The color of the calendar icon.
  final Color? calendarIconColor;

  /// The focused border color of the advanced filter type dropdown.
  final Color? advancedFilterTypeDropdownFocusedBorderColor;

  /// The focused border color of the advanced filter value dropdown.
  final Color? advancedFilterValueDropdownFocusedBorderColor;

  /// The cursor color in the advanced filter value text area.
  final Color? advancedFilterValueTextAreaCursorColor;

  /// The color of the search icon.
  final Color? searchIconColor;

  /// The color of the close icon.
  final Color? closeIconColor;

  /// The color of the dropdown icon of the advanced filter popup.
  final Color? advancedFilterPopupDropdownIconColor;

  /// The active color of the case-sensitive icon.
  final Color? caseSensitiveIconActiveColor;

  /// The default color of the case-sensitive icon.
  final Color? caseSensitiveIconColor;

  /// The background color of the advanced filter type dropdown icon.
  final Color? advancedFilterTypeDropdownIconColor;

  /// The background color of the advanced filter value dropdown icon.
  final Color? advancedFilterValueDropdownIconColor;

  /// The color of the bottom divider in the filter popup.
  final Color? filterPopupBottomDividerColor;

  /// The color of the top divider in the filter popup.
  final Color? filterPopupTopDividerColor;

  /// The color of the disabled OK button in the filtering popup.
  final Color? okFilteringLabelDisabledButtonColor;

  /// The color of the bottom border of the app bar.
  final Color? appBarBottomBorderColor;

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
    Widget? filterIcon,
    Color? filterIconColor,
    Color? filterIconHoverColor,
    Color? sortOrderNumberColor,
    Color? sortOrderNumberBackgroundColor,
    TextStyle? filterPopupTextStyle,
    TextStyle? filterPopupDisabledTextStyle,
    double? columnDragIndicatorStrokeWidth,
    Color? columnDragIndicatorColor,
    Widget? groupExpanderIcon,
    double indentColumnWidth = 40.0,
    Color? indentColumnColor,
    Color? captionSummaryRowColor,
    Color? filterPopupCheckColor,
    WidgetStateProperty<Color?>? filterPopupCheckboxFillColor,
    Color? filterPopupInputBorderColor,
    Color? filterPopupBackgroundColor,
    Color? filterPopupIconColor,
    Color? filterPopupDisabledIconColor,
    Color? advancedFilterPopupDropdownColor,
    Color? noMatchesFilteringLabelColor,
    Color? okFilteringLabelColor,
    Color? okFilteringLabelButtonColor,
    Color? cancelFilteringLabelColor,
    Color? cancelFilteringLabelButtonColor,
    Color? searchAreaCursorColor,
    Color? searchAreaFocusedBorderColor,
    Color? andRadioActiveColor,
    WidgetStateProperty<Color?>? andRadioFillColor,
    Color? orRadioActiveColor,
    WidgetStateProperty<Color?>? orRadioFillColor,
    Color? advancedFilterTypeDropdownFocusedBorderColor,
    Color? advancedFilterValueDropdownFocusedBorderColor,
    Color? calendarIconColor,
    Color? advancedFilterValueTextAreaCursorColor,
    Color? searchIconColor,
    Color? closeIconColor,
    Color? advancedFilterPopupDropdownIconColor,
    Color? caseSensitiveIconActiveColor,
    Color? caseSensitiveIconColor,
    Color? advancedFilterTypeDropdownIconColor,
    Color? advancedFilterValueDropdownIconColor,
    Color? filterPopupTopDividerColor,
    Color? filterPopupBottomDividerColor,
    Color? okFilteringLabelDisabledButtonColor,
    Color? appBarBottomBorderColor,
  }) {
    return SfDataGridThemeData.raw(
      brightness: brightness,
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
      columnResizeIndicatorStrokeWidth:
          columnResizeIndicatorStrokeWidth ??
          this.columnResizeIndicatorStrokeWidth,
      rowHoverColor: rowHoverColor ?? this.rowHoverColor,
      rowHoverTextStyle: rowHoverTextStyle ?? this.rowHoverTextStyle,
      sortIcon: sortIcon ?? this.sortIcon,
      filterIcon: filterIcon ?? this.filterIcon,
      filterIconColor: filterIconColor ?? this.filterIconColor,
      filterIconHoverColor: filterIconHoverColor ?? this.filterIconHoverColor,
      sortOrderNumberColor: sortOrderNumberColor ?? this.sortOrderNumberColor,
      sortOrderNumberBackgroundColor:
          sortOrderNumberBackgroundColor ?? this.sortOrderNumberBackgroundColor,
      filterPopupTextStyle: filterPopupTextStyle ?? this.filterPopupTextStyle,
      filterPopupDisabledTextStyle:
          filterPopupDisabledTextStyle ?? this.filterPopupDisabledTextStyle,
      columnDragIndicatorColor:
          columnDragIndicatorColor ?? this.columnDragIndicatorColor,
      columnDragIndicatorStrokeWidth:
          columnDragIndicatorStrokeWidth ?? this.columnDragIndicatorStrokeWidth,
      groupExpanderIcon: groupExpanderIcon ?? this.groupExpanderIcon,
      indentColumnWidth: indentColumnWidth,
      indentColumnColor: indentColumnColor ?? this.indentColumnColor,
      captionSummaryRowColor:
          captionSummaryRowColor ?? this.captionSummaryRowColor,
      filterPopupCheckColor:
          filterPopupCheckColor ?? this.filterPopupCheckColor,
      filterPopupCheckboxFillColor:
          filterPopupCheckboxFillColor ?? this.filterPopupCheckboxFillColor,
      filterPopupInputBorderColor:
          filterPopupInputBorderColor ?? this.filterPopupInputBorderColor,
      filterPopupBackgroundColor:
          filterPopupBackgroundColor ?? this.filterPopupBackgroundColor,
      filterPopupIconColor: filterPopupIconColor ?? this.filterPopupIconColor,
      filterPopupDisabledIconColor:
          filterPopupDisabledIconColor ?? this.filterPopupDisabledIconColor,
      advancedFilterPopupDropdownColor:
          advancedFilterPopupDropdownColor ??
          this.advancedFilterPopupDropdownColor,
      noMatchesFilteringLabelColor:
          noMatchesFilteringLabelColor ?? this.noMatchesFilteringLabelColor,
      okFilteringLabelColor:
          okFilteringLabelColor ?? this.okFilteringLabelColor,
      okFilteringLabelButtonColor:
          okFilteringLabelButtonColor ?? this.okFilteringLabelButtonColor,
      cancelFilteringLabelColor:
          cancelFilteringLabelColor ?? this.cancelFilteringLabelColor,
      cancelFilteringLabelButtonColor:
          cancelFilteringLabelButtonColor ??
          this.cancelFilteringLabelButtonColor,
      searchAreaCursorColor:
          searchAreaCursorColor ?? this.searchAreaCursorColor,
      searchAreaFocusedBorderColor:
          searchAreaFocusedBorderColor ?? this.searchAreaFocusedBorderColor,
      andRadioActiveColor: andRadioActiveColor ?? this.andRadioActiveColor,
      andRadioFillColor: andRadioFillColor ?? this.andRadioFillColor,
      orRadioActiveColor: orRadioActiveColor ?? this.orRadioActiveColor,
      orRadioFillColor: orRadioFillColor ?? this.orRadioFillColor,
      calendarIconColor: calendarIconColor ?? this.calendarIconColor,
      advancedFilterValueDropdownFocusedBorderColor:
          advancedFilterValueDropdownFocusedBorderColor ??
          this.advancedFilterValueDropdownFocusedBorderColor,
      advancedFilterTypeDropdownFocusedBorderColor:
          advancedFilterTypeDropdownFocusedBorderColor ??
          this.advancedFilterTypeDropdownFocusedBorderColor,
      advancedFilterValueTextAreaCursorColor:
          advancedFilterValueTextAreaCursorColor ??
          this.advancedFilterValueTextAreaCursorColor,
      searchIconColor: searchIconColor ?? this.searchIconColor,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      advancedFilterPopupDropdownIconColor:
          advancedFilterPopupDropdownIconColor ??
          this.advancedFilterPopupDropdownIconColor,
      caseSensitiveIconActiveColor:
          caseSensitiveIconActiveColor ?? this.caseSensitiveIconActiveColor,
      caseSensitiveIconColor:
          caseSensitiveIconColor ?? this.caseSensitiveIconColor,
      advancedFilterTypeDropdownIconColor:
          advancedFilterTypeDropdownIconColor ??
          this.advancedFilterTypeDropdownIconColor,
      advancedFilterValueDropdownIconColor:
          advancedFilterValueDropdownIconColor ??
          this.advancedFilterValueDropdownIconColor,
      filterPopupBottomDividerColor:
          filterPopupBottomDividerColor ?? this.filterPopupBottomDividerColor,
      filterPopupTopDividerColor:
          filterPopupTopDividerColor ?? this.filterPopupTopDividerColor,
      okFilteringLabelDisabledButtonColor:
          okFilteringLabelDisabledButtonColor ??
          this.okFilteringLabelDisabledButtonColor,
      appBarBottomBorderColor:
          appBarBottomBorderColor ?? this.appBarBottomBorderColor,
    );
  }

  /// Linearly interpolate between two themes.
  static SfDataGridThemeData? lerp(
    SfDataGridThemeData? a,
    SfDataGridThemeData? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return SfDataGridThemeData(
      gridLineColor: Color.lerp(a!.gridLineColor, b!.gridLineColor, t),
      gridLineStrokeWidth: lerpDouble(
        a.gridLineStrokeWidth,
        b.gridLineStrokeWidth,
        t,
      ),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      currentCellStyle: DataGridCurrentCellStyle.lerp(
        a.currentCellStyle,
        b.currentCellStyle,
        t,
      ),
      frozenPaneLineColor: Color.lerp(
        a.frozenPaneLineColor,
        b.frozenPaneLineColor,
        t,
      ),
      frozenPaneLineWidth: lerpDouble(
        a.frozenPaneLineWidth,
        b.frozenPaneLineWidth,
        t,
      ),
      sortIconColor: Color.lerp(a.sortIconColor, b.sortIconColor, t),
      headerHoverColor: Color.lerp(a.headerHoverColor, b.headerHoverColor, t),
      headerColor: Color.lerp(a.headerColor, b.headerColor, t),
      frozenPaneElevation: lerpDouble(
        a.frozenPaneElevation,
        b.frozenPaneElevation,
        t,
      ),
      rowHoverColor: Color.lerp(a.rowHoverColor, b.rowHoverColor, t),
      columnResizeIndicatorColor: Color.lerp(
        a.columnResizeIndicatorColor,
        b.columnResizeIndicatorColor,
        t,
      ),
      columnResizeIndicatorStrokeWidth: lerpDouble(
        a.columnResizeIndicatorStrokeWidth,
        b.columnResizeIndicatorStrokeWidth,
        t,
      ),
      rowHoverTextStyle: TextStyle.lerp(
        a.rowHoverTextStyle,
        b.rowHoverTextStyle,
        t,
      ),
      filterIconColor: Color.lerp(a.filterIconColor, b.filterIconColor, t),
      filterIconHoverColor: Color.lerp(
        a.filterIconHoverColor,
        b.filterIconHoverColor,
        t,
      ),
      sortOrderNumberColor: Color.lerp(
        a.sortOrderNumberColor,
        b.sortOrderNumberColor,
        t,
      ),
      sortOrderNumberBackgroundColor: Color.lerp(
        a.sortOrderNumberBackgroundColor,
        b.sortOrderNumberBackgroundColor,
        t,
      ),
      filterPopupTextStyle: TextStyle.lerp(
        a.filterPopupTextStyle,
        b.filterPopupTextStyle,
        t,
      ),
      filterPopupDisabledTextStyle: TextStyle.lerp(
        a.filterPopupDisabledTextStyle,
        b.filterPopupDisabledTextStyle,
        t,
      ),
      columnDragIndicatorColor: Color.lerp(
        a.columnDragIndicatorColor,
        b.columnDragIndicatorColor,
        t,
      ),
      columnDragIndicatorStrokeWidth: lerpDouble(
        a.columnDragIndicatorStrokeWidth,
        b.columnDragIndicatorStrokeWidth,
        t,
      ),
      indentColumnColor: Color.lerp(
        a.indentColumnColor,
        b.indentColumnColor,
        t,
      ),
      captionSummaryRowColor: Color.lerp(
        a.captionSummaryRowColor,
        b.captionSummaryRowColor,
        t,
      ),
      filterPopupCheckColor: Color.lerp(
        a.filterPopupCheckColor,
        b.filterPopupCheckColor,
        t,
      ),
      filterPopupCheckboxFillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        return Color.lerp(
          a.filterPopupCheckboxFillColor?.resolve(states),
          b.filterPopupCheckboxFillColor?.resolve(states),
          t,
        );
      }),
      filterPopupInputBorderColor: Color.lerp(
        a.filterPopupInputBorderColor,
        b.filterPopupInputBorderColor,
        t,
      ),
      filterPopupBackgroundColor: Color.lerp(
        a.filterPopupBackgroundColor,
        b.filterPopupBackgroundColor,
        t,
      ),
      filterPopupIconColor: Color.lerp(
        a.filterPopupIconColor,
        b.filterPopupIconColor,
        t,
      ),
      filterPopupDisabledIconColor: Color.lerp(
        a.filterPopupDisabledIconColor,
        b.filterPopupDisabledIconColor,
        t,
      ),
      advancedFilterPopupDropdownColor: Color.lerp(
        a.advancedFilterPopupDropdownColor,
        b.advancedFilterPopupDropdownColor,
        t,
      ),
      noMatchesFilteringLabelColor: Color.lerp(
        a.noMatchesFilteringLabelColor,
        b.noMatchesFilteringLabelColor,
        t,
      ),
      okFilteringLabelColor: Color.lerp(
        a.okFilteringLabelColor,
        b.okFilteringLabelColor,
        t,
      ),
      okFilteringLabelButtonColor: Color.lerp(
        a.okFilteringLabelButtonColor,
        b.okFilteringLabelButtonColor,
        t,
      ),
      cancelFilteringLabelColor: Color.lerp(
        a.cancelFilteringLabelColor,
        b.cancelFilteringLabelColor,
        t,
      ),
      cancelFilteringLabelButtonColor: Color.lerp(
        a.cancelFilteringLabelButtonColor,
        b.cancelFilteringLabelButtonColor,
        t,
      ),
      searchAreaFocusedBorderColor: Color.lerp(
        a.searchAreaFocusedBorderColor,
        b.searchAreaFocusedBorderColor,
        t,
      ),
      searchAreaCursorColor: Color.lerp(
        a.searchAreaCursorColor,
        b.searchAreaCursorColor,
        t,
      ),
      andRadioActiveColor: Color.lerp(
        a.andRadioActiveColor,
        b.andRadioActiveColor,
        t,
      ),
      andRadioFillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        return Color.lerp(
          a.andRadioFillColor?.resolve(states),
          b.andRadioFillColor?.resolve(states),
          t,
        );
      }),
      orRadioActiveColor: Color.lerp(
        a.orRadioActiveColor,
        b.orRadioActiveColor,
        t,
      ),
      orRadioFillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        return Color.lerp(
          a.orRadioFillColor?.resolve(states),
          b.orRadioFillColor?.resolve(states),
          t,
        );
      }),
      calendarIconColor: Color.lerp(
        a.calendarIconColor,
        b.calendarIconColor,
        t,
      ),
      advancedFilterValueDropdownFocusedBorderColor: Color.lerp(
        a.advancedFilterValueDropdownFocusedBorderColor,
        b.advancedFilterValueDropdownFocusedBorderColor,
        t,
      ),
      advancedFilterTypeDropdownFocusedBorderColor: Color.lerp(
        a.advancedFilterTypeDropdownFocusedBorderColor,
        b.advancedFilterTypeDropdownFocusedBorderColor,
        t,
      ),
      advancedFilterValueTextAreaCursorColor: Color.lerp(
        a.advancedFilterValueTextAreaCursorColor,
        b.advancedFilterValueTextAreaCursorColor,
        t,
      ),
      searchIconColor: Color.lerp(a.searchIconColor, b.searchIconColor, t),
      closeIconColor: Color.lerp(a.closeIconColor, b.closeIconColor, t),
      advancedFilterPopupDropdownIconColor: Color.lerp(
        a.advancedFilterPopupDropdownIconColor,
        b.advancedFilterPopupDropdownIconColor,
        t,
      ),
      caseSensitiveIconActiveColor: Color.lerp(
        a.caseSensitiveIconActiveColor,
        b.caseSensitiveIconActiveColor,
        t,
      ),
      caseSensitiveIconColor: Color.lerp(
        a.caseSensitiveIconColor,
        b.caseSensitiveIconColor,
        t,
      ),
      advancedFilterValueDropdownIconColor: Color.lerp(
        a.advancedFilterValueDropdownIconColor,
        b.advancedFilterValueDropdownIconColor,
        t,
      ),
      advancedFilterTypeDropdownIconColor: Color.lerp(
        a.advancedFilterTypeDropdownIconColor,
        b.advancedFilterTypeDropdownIconColor,
        t,
      ),
      filterPopupBottomDividerColor: Color.lerp(
        a.filterPopupBottomDividerColor,
        b.filterPopupBottomDividerColor,
        t,
      ),
      filterPopupTopDividerColor: Color.lerp(
        a.filterPopupTopDividerColor,
        b.filterPopupTopDividerColor,
        t,
      ),
      okFilteringLabelDisabledButtonColor: Color.lerp(
        a.okFilteringLabelDisabledButtonColor,
        b.okFilteringLabelDisabledButtonColor,
        t,
      ),
      appBarBottomBorderColor: Color.lerp(
        a.appBarBottomBorderColor,
        b.appBarBottomBorderColor,
        t,
      ),
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
        other.sortIcon == sortIcon &&
        other.filterIcon == filterIcon &&
        other.filterIconColor == filterIconColor &&
        other.filterIconHoverColor == filterIconHoverColor &&
        other.sortOrderNumberColor == sortOrderNumberColor &&
        other.sortOrderNumberBackgroundColor ==
            sortOrderNumberBackgroundColor &&
        other.filterPopupTextStyle == filterPopupTextStyle &&
        other.filterPopupDisabledTextStyle == filterPopupDisabledTextStyle &&
        other.columnDragIndicatorColor == columnDragIndicatorColor &&
        other.columnDragIndicatorStrokeWidth ==
            columnDragIndicatorStrokeWidth &&
        other.groupExpanderIcon == groupExpanderIcon &&
        other.indentColumnWidth == indentColumnWidth &&
        other.indentColumnColor == indentColumnColor &&
        other.captionSummaryRowColor == captionSummaryRowColor &&
        other.filterPopupCheckColor == filterPopupCheckColor &&
        other.filterPopupCheckboxFillColor == filterPopupCheckboxFillColor &&
        other.filterPopupInputBorderColor == filterPopupInputBorderColor &&
        other.filterPopupBackgroundColor == filterPopupBackgroundColor &&
        other.filterPopupIconColor == filterPopupIconColor &&
        other.filterPopupDisabledIconColor == filterPopupDisabledIconColor &&
        other.advancedFilterPopupDropdownColor ==
            advancedFilterPopupDropdownColor &&
        other.noMatchesFilteringLabelColor == noMatchesFilteringLabelColor &&
        other.okFilteringLabelColor == okFilteringLabelColor &&
        other.okFilteringLabelButtonColor == okFilteringLabelButtonColor &&
        other.cancelFilteringLabelColor == cancelFilteringLabelColor &&
        other.cancelFilteringLabelButtonColor ==
            cancelFilteringLabelButtonColor &&
        other.searchAreaFocusedBorderColor == searchAreaFocusedBorderColor &&
        other.searchAreaCursorColor == searchAreaCursorColor &&
        other.andRadioActiveColor == andRadioActiveColor &&
        other.andRadioFillColor == andRadioFillColor &&
        other.orRadioActiveColor == orRadioActiveColor &&
        other.orRadioFillColor == orRadioFillColor &&
        other.calendarIconColor == calendarIconColor &&
        other.advancedFilterValueDropdownFocusedBorderColor ==
            advancedFilterValueDropdownFocusedBorderColor &&
        other.advancedFilterTypeDropdownFocusedBorderColor ==
            advancedFilterTypeDropdownFocusedBorderColor &&
        other.advancedFilterValueTextAreaCursorColor ==
            advancedFilterValueTextAreaCursorColor &&
        other.searchIconColor == searchIconColor &&
        other.closeIconColor == closeIconColor &&
        other.advancedFilterPopupDropdownIconColor ==
            advancedFilterPopupDropdownIconColor &&
        other.caseSensitiveIconActiveColor == caseSensitiveIconActiveColor &&
        other.caseSensitiveIconColor == caseSensitiveIconColor &&
        other.advancedFilterValueDropdownIconColor ==
            advancedFilterValueDropdownIconColor &&
        other.advancedFilterTypeDropdownIconColor ==
            advancedFilterTypeDropdownIconColor &&
        other.filterPopupBottomDividerColor == filterPopupBottomDividerColor &&
        other.filterPopupTopDividerColor == filterPopupTopDividerColor &&
        other.okFilteringLabelDisabledButtonColor ==
            okFilteringLabelDisabledButtonColor &&
        other.appBarBottomBorderColor == appBarBottomBorderColor;
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
      sortIcon,
      filterIcon,
      filterIconColor,
      filterIconHoverColor,
      sortOrderNumberColor,
      sortOrderNumberBackgroundColor,
      filterPopupTextStyle,
      filterPopupDisabledTextStyle,
      columnDragIndicatorColor,
      columnDragIndicatorStrokeWidth,
      groupExpanderIcon,
      indentColumnWidth,
      indentColumnColor,
      captionSummaryRowColor,
      filterPopupCheckColor,
      filterPopupCheckboxFillColor,
      filterPopupInputBorderColor,
      filterPopupBackgroundColor,
      filterPopupIconColor,
      filterPopupDisabledIconColor,
      advancedFilterPopupDropdownColor,
      noMatchesFilteringLabelColor,
      okFilteringLabelColor,
      okFilteringLabelButtonColor,
      cancelFilteringLabelColor,
      cancelFilteringLabelButtonColor,
      searchAreaFocusedBorderColor,
      searchAreaCursorColor,
      andRadioActiveColor,
      andRadioFillColor,
      orRadioActiveColor,
      orRadioFillColor,
      calendarIconColor,
      advancedFilterValueDropdownFocusedBorderColor,
      advancedFilterTypeDropdownFocusedBorderColor,
      advancedFilterValueTextAreaCursorColor,
      searchIconColor,
      closeIconColor,
      advancedFilterPopupDropdownIconColor,
      caseSensitiveIconActiveColor,
      caseSensitiveIconColor,
      advancedFilterTypeDropdownIconColor,
      advancedFilterValueDropdownIconColor,
      filterPopupBottomDividerColor,
      filterPopupTopDividerColor,
      okFilteringLabelDisabledButtonColor,
      appBarBottomBorderColor,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const SfDataGridThemeData defaultData = SfDataGridThemeData();
    properties.add(
      ColorProperty(
        'gridLineColor',
        gridLineColor,
        defaultValue: defaultData.gridLineColor,
      ),
    );
    properties.add(
      DoubleProperty(
        'gridLineStrokeWidth',
        gridLineStrokeWidth,
        defaultValue: defaultData.gridLineStrokeWidth,
      ),
    );
    properties.add(
      ColorProperty(
        'selectionColor',
        selectionColor,
        defaultValue: defaultData.selectionColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<DataGridCurrentCellStyle>(
        'currentCellStyle',
        currentCellStyle,
        defaultValue: defaultData.currentCellStyle,
      ),
    );
    properties.add(
      ColorProperty(
        'frozenPaneLineColor',
        frozenPaneLineColor,
        defaultValue: defaultData.frozenPaneLineColor,
      ),
    );
    properties.add(
      DoubleProperty(
        'frozenPaneLineWidth',
        frozenPaneLineWidth,
        defaultValue: defaultData.frozenPaneLineWidth,
      ),
    );
    properties.add(
      ColorProperty(
        'sortIconColor',
        sortIconColor,
        defaultValue: defaultData.sortIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'headerHoverColor',
        headerHoverColor,
        defaultValue: defaultData.headerHoverColor,
      ),
    );
    properties.add(
      ColorProperty(
        'headerColor',
        headerColor,
        defaultValue: defaultData.headerColor,
      ),
    );
    properties.add(
      DoubleProperty(
        'frozenPaneElevation',
        frozenPaneElevation,
        defaultValue: defaultData.frozenPaneElevation,
      ),
    );
    properties.add(
      ColorProperty(
        'columnResizeIndicatorColor',
        columnResizeIndicatorColor,
        defaultValue: defaultData.columnResizeIndicatorColor,
      ),
    );
    properties.add(
      DoubleProperty(
        'columnResizeIndicatorStrokeWidth',
        columnResizeIndicatorStrokeWidth,
        defaultValue: defaultData.columnResizeIndicatorStrokeWidth,
      ),
    );
    properties.add(
      ColorProperty(
        'rowHoverColor',
        rowHoverColor,
        defaultValue: defaultData.rowHoverColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'rowHoverTextStyle',
        rowHoverTextStyle,
        defaultValue: defaultData.rowHoverTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget>(
        'sortIcon',
        sortIcon,
        defaultValue: defaultData.sortIcon,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget>(
        'filterIcon',
        filterIcon,
        defaultValue: defaultData.filterIcon,
      ),
    );
    properties.add(
      ColorProperty(
        'filterIconColor',
        filterIconColor,
        defaultValue: defaultData.filterIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterIconHoverColor',
        filterIconHoverColor,
        defaultValue: defaultData.filterIconHoverColor,
      ),
    );
    properties.add(
      ColorProperty(
        'sortOrderNumberColor',
        sortOrderNumberColor,
        defaultValue: defaultData.sortOrderNumberColor,
      ),
    );
    properties.add(
      ColorProperty(
        'sortOrderNumberBackgroundColor',
        sortOrderNumberBackgroundColor,
        defaultValue: defaultData.sortOrderNumberBackgroundColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'filterPopupTextStyle',
        filterPopupTextStyle,
        defaultValue: defaultData.filterPopupTextStyle,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'filterPopupDisabledTextStyle',
        filterPopupDisabledTextStyle,
        defaultValue: defaultData.filterPopupDisabledTextStyle,
      ),
    );
    properties.add(
      ColorProperty(
        'columnDragIndicatorColor',
        columnDragIndicatorColor,
        defaultValue: defaultData.columnDragIndicatorColor,
      ),
    );
    properties.add(
      DiagnosticsProperty<double>(
        'columnDragIndicatorStrokeWidth',
        columnDragIndicatorStrokeWidth,
        defaultValue: defaultData.columnDragIndicatorStrokeWidth,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget>(
        'groupExpanderIcon',
        groupExpanderIcon,
        defaultValue: defaultData.groupExpanderIcon,
      ),
    );
    properties.add(
      DiagnosticsProperty<double>(
        'indentColumnWidth',
        indentColumnWidth,
        defaultValue: defaultData.indentColumnWidth,
      ),
    );
    properties.add(
      ColorProperty(
        'indentColumnColor',
        indentColumnColor,
        defaultValue: defaultData.indentColumnColor,
      ),
    );
    properties.add(
      ColorProperty(
        'captionSummaryRowColor',
        captionSummaryRowColor,
        defaultValue: defaultData.captionSummaryRowColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupCheckColor',
        filterPopupCheckColor,
        defaultValue: defaultData.filterPopupCheckColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupCheckboxFillColor',
        filterPopupCheckboxFillColor?.resolve({}),
        defaultValue: defaultData.filterPopupCheckboxFillColor?.resolve({}),
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupInputBorderColor',
        filterPopupInputBorderColor,
        defaultValue: defaultData.filterPopupInputBorderColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupBackgroundColor',
        filterPopupBackgroundColor,
        defaultValue: defaultData.filterPopupBackgroundColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupIconColor',
        filterPopupIconColor,
        defaultValue: defaultData.filterPopupIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupDisabledIconColor',
        filterPopupDisabledIconColor,
        defaultValue: defaultData.filterPopupDisabledIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterPopupDropdownColor',
        advancedFilterPopupDropdownColor,
        defaultValue: defaultData.advancedFilterPopupDropdownColor,
      ),
    );
    properties.add(
      ColorProperty(
        'noMatchesFilteringLabelColor',
        noMatchesFilteringLabelColor,
        defaultValue: defaultData.noMatchesFilteringLabelColor,
      ),
    );
    properties.add(
      ColorProperty(
        'okFilteringLabelColor',
        okFilteringLabelColor,
        defaultValue: defaultData.okFilteringLabelColor,
      ),
    );
    properties.add(
      ColorProperty(
        'okFilteringLabelButtonColor',
        okFilteringLabelButtonColor,
        defaultValue: defaultData.okFilteringLabelButtonColor,
      ),
    );
    properties.add(
      ColorProperty(
        'cancelFilteringLabelColor',
        cancelFilteringLabelColor,
        defaultValue: defaultData.cancelFilteringLabelColor,
      ),
    );
    properties.add(
      ColorProperty(
        'cancelFilteringLabelButtonColor',
        cancelFilteringLabelButtonColor,
        defaultValue: defaultData.cancelFilteringLabelButtonColor,
      ),
    );
    properties.add(
      ColorProperty(
        'searchAreaFocusedBorderColor',
        searchAreaFocusedBorderColor,
        defaultValue: defaultData.searchAreaFocusedBorderColor,
      ),
    );
    properties.add(
      ColorProperty(
        'searchAreaCursorColor',
        searchAreaCursorColor,
        defaultValue: defaultData.searchAreaCursorColor,
      ),
    );
    properties.add(
      ColorProperty(
        'andRadioActiveColor',
        andRadioActiveColor,
        defaultValue: defaultData.andRadioActiveColor,
      ),
    );
    properties.add(
      ColorProperty(
        'andRadioFillColor',
        andRadioFillColor?.resolve({}),
        defaultValue: defaultData.andRadioFillColor?.resolve({}),
      ),
    );
    properties.add(
      ColorProperty(
        'orRadioActiveColor',
        orRadioActiveColor,
        defaultValue: defaultData.orRadioActiveColor,
      ),
    );
    properties.add(
      ColorProperty(
        'orRadioFillColor',
        orRadioFillColor?.resolve({}),
        defaultValue: defaultData.orRadioFillColor?.resolve({}),
      ),
    );
    properties.add(
      ColorProperty(
        'calendarIconColor',
        calendarIconColor,
        defaultValue: defaultData.calendarIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterValueDropdownFocusedBorderColor',
        advancedFilterValueDropdownFocusedBorderColor,
        defaultValue: defaultData.advancedFilterValueDropdownFocusedBorderColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterTypeDropdownFocusedBorderColor',
        advancedFilterTypeDropdownFocusedBorderColor,
        defaultValue: defaultData.advancedFilterTypeDropdownFocusedBorderColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterValueTextAreaCursorColor',
        advancedFilterValueTextAreaCursorColor,
        defaultValue: defaultData.advancedFilterValueTextAreaCursorColor,
      ),
    );
    properties.add(
      ColorProperty(
        'searchIconColor',
        searchIconColor,
        defaultValue: defaultData.searchIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'closeIconColor',
        closeIconColor,
        defaultValue: defaultData.closeIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterPopupDropdownIconColor',
        advancedFilterPopupDropdownIconColor,
        defaultValue: defaultData.advancedFilterPopupDropdownIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'caseSensitiveIconActiveColor',
        caseSensitiveIconActiveColor,
        defaultValue: defaultData.caseSensitiveIconActiveColor,
      ),
    );
    properties.add(
      ColorProperty(
        'caseSensitiveIconColor',
        caseSensitiveIconColor,
        defaultValue: defaultData.caseSensitiveIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterValueDropdownIconColor',
        advancedFilterValueDropdownIconColor,
        defaultValue: defaultData.advancedFilterValueDropdownIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'advancedFilterTypeDropdownIconColor',
        advancedFilterTypeDropdownIconColor,
        defaultValue: defaultData.advancedFilterTypeDropdownIconColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupBottomDividerColor',
        filterPopupBottomDividerColor,
        defaultValue: defaultData.filterPopupBottomDividerColor,
      ),
    );
    properties.add(
      ColorProperty(
        'filterPopupTopDividerColor',
        filterPopupTopDividerColor,
        defaultValue: defaultData.filterPopupTopDividerColor,
      ),
    );
    properties.add(
      ColorProperty(
        'okFilteringLabelDisabledButtonColor',
        okFilteringLabelDisabledButtonColor,
        defaultValue: defaultData.okFilteringLabelDisabledButtonColor,
      ),
    );
    properties.add(
      ColorProperty(
        'appBarBottomBorderColor',
        appBarBottomBorderColor,
        defaultValue: defaultData.appBarBottomBorderColor,
      ),
    );
  }
}

/// Defines the configuration of the current cell in [SfDataGrid].
class DataGridCurrentCellStyle {
  /// Create a [DataGridCurrentCellStyle] that's used to configure
  /// a style for the current cell in [SfDataGrid].
  const DataGridCurrentCellStyle({
    required this.borderColor,
    required this.borderWidth,
  });

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
    final List<Object> values = <Object>[borderColor, borderWidth];
    return Object.hashAll(values);
  }

  /// Linearly interpolate between two styles.
  static DataGridCurrentCellStyle? lerp(
    DataGridCurrentCellStyle? a,
    DataGridCurrentCellStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return DataGridCurrentCellStyle(
      borderColor: Color.lerp(a!.borderColor, b!.borderColor, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
    );
  }
}
