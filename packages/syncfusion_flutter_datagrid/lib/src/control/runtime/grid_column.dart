part of datagrid;

/// Provides the base functionalities for all the column types in [SfDataGrid].
class GridColumn {
  /// Creates the [GridColumn] for [SfDataGrid] widget.
  GridColumn(
      {@required this.mappingName,
      ColumnWidthMode columnWidthMode,
      Alignment textAlignment,
      Alignment headerTextAlignment,
      bool softWrap,
      TextOverflow headerTextOverflow,
      bool headerTextSoftWrap,
      bool visible,
      bool allowSorting,
      double minimumWidth,
      double maximumWidth,
      double width,
      this.maxLines,
      this.overflow,
      this.headerText,
      this.headerStyle,
      this.cellStyle,
      this.padding,
      this.headerPadding})
      : columnWidthMode = columnWidthMode ?? ColumnWidthMode.none,
        textAlignment = textAlignment ?? Alignment.centerLeft,
        headerTextAlignment = headerTextAlignment ?? Alignment.center,
        softWrap = softWrap ?? false,
        headerTextOverflow = headerTextOverflow ?? TextOverflow.ellipsis,
        headerTextSoftWrap = headerTextSoftWrap ?? false,
        visible = visible ?? true,
        allowSorting = allowSorting ?? true,
        minimumWidth = minimumWidth ?? double.nan,
        maximumWidth = maximumWidth ?? double.nan,
        width = width ?? double.nan {
    _actualWidth = double.nan;
    _autoWidth = double.nan;
  }

  double _autoWidth;

  /// How the column widths are determined.
  ///
  /// This takes higher priority than [SfDataGrid.columnWidthMode].
  ///
  /// Defaults to [ColumnWidthMode.none]
  ///
  /// Also refer [ColumnWidthMode]
  final ColumnWidthMode columnWidthMode;

  /// The name to map the data member in the underlying data object of
  /// datasource.
  ///
  /// Defaults to null
  final String mappingName;

  /// The cell type of the column which denotes renderer associated with column.
  String get cellType => _cellType;
  String _cellType;

  /// How the text in cells except header cell is aligned.
  ///
  /// Defaults to null
  final Alignment textAlignment;

  /// How the text in header cell is aligned.
  ///
  /// Defaults to null
  final Alignment headerTextAlignment;

  /// An optional maximum number of lines for the text to span, wrapping
  /// if necessary in cells except header cell.
  ///
  /// Defaults to null
  final int maxLines;

  /// How visual overflow should be handled in cells except header cell.
  ///
  /// Defaults to null
  ///
  /// Also refer [TextOverflow]
  final TextOverflow overflow;

  /// Whether the text should break at soft line breaks.
  ///
  /// Defaults to false
  final bool softWrap;

  /// The actual display width of the column when auto fitted based on
  /// [SfDataGrid.columnWidthMode] or [columnWidthMode].
  ///
  /// Defaults to [double.nan]
  double _actualWidth;

  /// The text which displays in header cell.
  ///
  /// Defaults to null.
  final String headerText;

  /// The minimum width of the column.
  ///
  /// The column width could not be set or auto sized lesser than the
  /// [minimumWidth]
  ///
  /// Defaults to [double.nan]
  final double minimumWidth;

  /// The maximum width of the column.
  ///
  /// The column width could not be set or auto sized greater than the
  /// [maximumWidth]
  ///
  /// Defaults to [double.nan]
  final double maximumWidth;

  /// Decides how visual overflow of header text should be handled.
  ///
  /// Defaults to Ellipsis
  ///
  /// Also refer [TextOverflow]
  final TextOverflow headerTextOverflow;

  /// Decides Whether the header text should break at soft line breaks.
  ///
  /// Defaults to false
  final bool headerTextSoftWrap;

  /// The width of the column.
  ///
  /// If value is lesser than [minimumWidth], then [minimumWidth]
  /// is set to [width].
  /// Otherwise, If value is greater than [maximumWidth], then the
  /// [maximumWidth] is set to [width].
  ///
  /// Defaults to [double.nan]
  final double width;

  /// The amount of space between the contents of the cell and the cell's
  /// border.
  ///
  /// This is applicable for grid cells alone.
  ///
  /// Defaults to 16
  final EdgeInsetsGeometry padding;

  /// The amount of space between the contents of the header cell and the
  /// header cell's border.
  ///
  /// Defaults to 16
  final EdgeInsetsGeometry headerPadding;

  /// The style of the header cell in the column.
  ///
  /// Defaults to null
  ///
  /// ``` dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGrid(
  ///       source: _employeeDataSource,
  ///       columns: [
  ///         GridNumericColumn(mappingName: 'id', headerText: 'ID',
  ///                     headerStyle : DataGridHeaderCellStyle(
  ///                           textStyle: TextStyle(
  ///                              color: Colors.red,
  ///                              fontWeight: FontWeight.bold))),
  ///         GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///         GridTextColumn(mappingName: 'designation',
  ///             headerText: 'Designation'),
  ///         GridNumericColumn(mappingName: 'salary', headerText: 'Salary')
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// ```
  final DataGridHeaderCellStyle headerStyle;

  /// The style of the cells in the column except header cell.
  ///
  /// Defaults to null
  ///
  /// ``` dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGrid(
  ///       source: _employeeDataSource,
  ///       columns: [
  ///         GridNumericColumn(mappingName: 'id', headerText: 'ID',
  ///            cellStyle : DataGridCellStyle(
  ///              textStyle: TextStyle(color: Colors.red))),
  ///         GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///         GridTextColumn(mappingName: 'designation',
  ///             headerText: 'Designation'),
  ///         GridNumericColumn(mappingName: 'salary', headerText: 'Salary')
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// ```
  final DataGridCellStyle cellStyle;

  /// Whether column should be hidden.
  ///
  /// Defaults to false.
  final bool visible;

  /// Decides whether user can sort the column simply by tapping the column
  /// header.
  ///
  /// Defaults to true.
  ///
  /// This is applicable only if the [SfDataGrid.allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [SfDataGrid.allowSorting] – which allows users to sort the columns in
  /// [SfDataGrid].
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowSorting;

  /// Gets the formatted value based on the given format.
  ///
  /// This is applicable for column such as [GridNumericColumn]
  /// and [GridDateTimeColumn].
  String getFormattedValue(Object cellValue) => cellValue?.toString();

  /// Sets the cell type which indicates the renderer for the column.
  ///
  /// Call this method in constructor of the column when you write the custom
  /// column and renderer.
  @protected
  void setCellType(String cellType) {
    _cellType = cellType;
  }
}

/// A column which displays the values of the string in its cells.
///
/// This column has all the required APIs to customize the widget [Text] as it
/// displays [Text] for all the cells.
///
/// ``` dart
/// @override
/// Widget build(BuildContext context) {
///   return SfDataGrid(
///     source: employeeDataSource,
///     columns: [
///     GridTextColumn(mappingName: 'name', headerText : 'Name'),
///     GridTextColumn(mappingName: 'designation', headerText : 'Designation'),
///   ],
///   );
/// }
/// ```
class GridTextColumn extends GridColumn {
  /// Creates a String column using [mappingName] and [headerText].
  GridTextColumn(
      {@required String mappingName,
      ColumnWidthMode columnWidthMode,
      Alignment textAlignment,
      Alignment headerTextAlignment,
      bool softWrap,
      TextOverflow headerTextOverflow,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry headerPadding,
      bool headerTextSoftWrap,
      bool visible,
      bool allowSorting,
      double minimumWidth,
      double maximumWidth,
      double width,
      int maxLines,
      TextOverflow overflow,
      String headerText,
      DataGridHeaderCellStyle headerStyle,
      DataGridCellStyle cellStyle})
      : super(
            mappingName: mappingName,
            columnWidthMode: columnWidthMode,
            textAlignment: textAlignment,
            headerTextAlignment: headerTextAlignment ?? Alignment.centerLeft,
            softWrap: softWrap,
            headerTextOverflow: headerTextOverflow,
            headerTextSoftWrap: headerTextSoftWrap,
            visible: visible,
            allowSorting: allowSorting,
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            width: width,
            maxLines: maxLines,
            overflow: overflow ?? TextOverflow.ellipsis,
            headerText: headerText,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
            padding: padding,
            headerPadding: headerPadding) {
    _cellType = 'TextField';
  }
}

/// A column used to display the numeric values in its cells (int, double).
///
/// [GridNumericColumn] supports [numberFormat] for formatting numeric values.
///
/// ``` dart
/// @override
/// Widget build(BuildContext context) {
///   return SfDataGrid(
///     source: employeeDataSource(),
///     columns: [
///      GridNumericColumn(mappingName: 'id', headerText : 'ID'),
///      GridNumericColumn(mappingName: 'salary', headerText : 'Salary'),
///   ],
///   );
/// }
/// ```
class GridNumericColumn extends GridColumn {
  /// Creates a numeric column using [mappingName] and [headerText].
  GridNumericColumn({
    @required String mappingName,
    this.numberFormat,
    ColumnWidthMode columnWidthMode,
    Alignment textAlignment,
    Alignment headerTextAlignment,
    bool softWrap,
    TextOverflow headerTextOverflow,
    EdgeInsetsGeometry padding,
    EdgeInsetsGeometry headerPadding,
    bool headerTextSoftWrap,
    bool visible,
    bool allowSorting,
    double minimumWidth,
    double maximumWidth,
    double width,
    int maxLines,
    TextOverflow overflow,
    String headerText,
    DataGridHeaderCellStyle headerStyle,
    DataGridCellStyle cellStyle,
  }) : super(
            mappingName: mappingName,
            columnWidthMode: columnWidthMode,
            textAlignment: textAlignment ?? Alignment.centerRight,
            headerTextAlignment: headerTextAlignment ?? Alignment.centerRight,
            softWrap: softWrap,
            headerTextOverflow: headerTextOverflow,
            headerTextSoftWrap: headerTextSoftWrap,
            visible: visible,
            allowSorting: allowSorting,
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            width: width,
            maxLines: maxLines,
            overflow: overflow,
            headerText: headerText,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
            padding: padding,
            headerPadding: headerPadding) {
    _cellType = 'Numeric';
  }

  /// [intl.NumberFormat] to format a number in a locale-specific way.
  ///
  /// Defaults to null.
  ///
  /// ``` dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGrid(
  ///       source: _employeeDataSource,
  ///       columns: [
  ///         GridNumericColumn(mappingName: 'id', headerText: 'ID'),
  ///         GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///         GridTextColumn(mappingName: 'designation',
  ///             headerText: 'Designation'),
  ///         GridNumericColumn(mappingName: 'salary', headerText: 'Salary',
  ///           numberFormat :
  ///                    NumberFormat.currency(locale: 'en_US', symbol: '\$'))
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final intl.NumberFormat numberFormat;

  @override
  String getFormattedValue(Object cellValue) {
    if (numberFormat != null) {
      return numberFormat.format(cellValue);
    }
    return cellValue.toString();
  }
}

/// A column that shows any custom widget inside its cells.
///
/// [GridWidgetColumn] supports loading [Image], [Switch] and so on in cells
/// in column.
///
/// [SfDataGrid.cellBuilder] allows you to set the widget in a column as needed.
/// ``` dart
/// @override
/// Widget build(BuildContext context) {
///   return SfDataGrid(
///     source: employeeDataSource(),
///     cellBuilder: (BuildContext context, GridColumn column, int rowIndex){
///        return employees[rowIndex].image;
///      },
///     columns: [
///      GridWidgetColumn(mappingName: image, headerText : 'Image'),
///   ],
///   );
/// }
/// ```
class GridWidgetColumn extends GridColumn {
  /// Creates a widget column using [mappingName] and [headerText].
  GridWidgetColumn(
      {@required String mappingName,
      ColumnWidthMode columnWidthMode,
      Alignment textAlignment,
      Alignment headerTextAlignment,
      bool softWrap,
      TextOverflow headerTextOverflow,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry headerPadding,
      bool headerTextSoftWrap,
      bool visible,
      bool allowSorting,
      double minimumWidth,
      double maximumWidth,
      double width,
      int maxLines,
      TextOverflow overflow,
      String headerText,
      DataGridHeaderCellStyle headerStyle,
      DataGridCellStyle cellStyle})
      : super(
            mappingName: mappingName,
            columnWidthMode: columnWidthMode,
            textAlignment: textAlignment,
            headerTextAlignment: headerTextAlignment,
            softWrap: softWrap,
            headerTextOverflow: headerTextOverflow,
            headerTextSoftWrap: headerTextSoftWrap,
            visible: visible,
            allowSorting: allowSorting,
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            width: width,
            maxLines: maxLines,
            overflow: overflow,
            headerText: headerText,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
            padding: padding,
            headerPadding: headerPadding) {
    _cellType = 'Widget';
  }
}

/// A column which displays the values of DateTime in its cells.
///
/// [GridDateTimeColumn] supports [dateFormat] for formatting DateTime values.
///
/// ``` dart
/// @override
/// Widget build(BuildContext context) {
///   return SfDataGrid(
///     source: employeeDataSource(),
///     columns: [
///      GridNumericColumn(mappingName: 'id', headerText : 'ID'),
///      GridDateTimeColumn(mappingName: 'dateofjoining',
///              headerText : 'Date of Joining'),
///   ],
///   );
/// }
/// ```
class GridDateTimeColumn extends GridColumn {
  /// Creates a datetime column using [mappingName] and [headerText].
  GridDateTimeColumn(
      {@required String mappingName,
      this.dateFormat,
      ColumnWidthMode columnWidthMode,
      Alignment textAlignment,
      Alignment headerTextAlignment,
      bool softWrap,
      TextOverflow headerTextOverflow,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry headerPadding,
      bool headerTextSoftWrap,
      bool visible,
      bool allowSorting,
      double minimumWidth,
      double maximumWidth,
      double width,
      int maxLines,
      TextOverflow overflow,
      String headerText,
      DataGridHeaderCellStyle headerStyle,
      DataGridCellStyle cellStyle})
      : super(
            mappingName: mappingName,
            columnWidthMode: columnWidthMode,
            textAlignment: textAlignment ?? Alignment.centerRight,
            headerTextAlignment: headerTextAlignment ?? Alignment.centerRight,
            softWrap: softWrap,
            headerTextOverflow: headerTextOverflow,
            headerTextSoftWrap: headerTextSoftWrap,
            visible: visible,
            allowSorting: allowSorting,
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            width: width,
            maxLines: maxLines,
            overflow: overflow,
            headerText: headerText,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
            padding: padding,
            headerPadding: headerPadding) {
    _cellType = 'DateTime';
  }

  /// [intl.DateFormat] to format the dates in a locale-sensitive manner.
  ///
  /// Defaults to null.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDataGrid(
  ///       source: _employeeDataSource,
  ///       columns: [
  ///         GridNumericColumn(mappingName: 'id', headerText: 'ID'),
  ///         GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///         GridDateTimeColumn(
  ///             mappingName: 'dateOfJoining', headerText: 'Date of Joining',
  ///             dateFormat : DateFormat('dd/MM/yyyy')),
  ///         GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final intl.DateFormat dateFormat;

  final intl.DateFormat _defaultDateFormat = intl.DateFormat('dd-MM-yyyy');

  /// Gets the formatted value based on the given format.
  ///
  /// This method is overridden to format the given numeric value to specified
  /// [dateFormat].
  @override
  String getFormattedValue(Object cellValue) {
    if (dateFormat != null) {
      return dateFormat.format(cellValue);
    }
    return _defaultDateFormat.format(cellValue);
  }
}
