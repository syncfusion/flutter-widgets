import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide DataCell, DataRow;

import '../../grid_common/enums.dart';
import '../../grid_common/row_column_index.dart';
import '../../grid_common/utility_helper.dart';
import '../../grid_common/visible_line_info.dart';
import '../helper/callbackargs.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../selection/selection_manager.dart' as selection_manager;
import '../selection/selection_manager.dart';
import '../sfdatagrid.dart';
import '../widgets/scrollview_widget.dart';
import 'cell_renderers.dart';
import 'column.dart';

/// A base class which provides functionalities for [DataCell].
abstract class DataCellBase {
  /// Key is an identifier of [DataCell].
  Key? key;

  /// Decide whether the [DataCell] to visible.
  bool isVisible = true;

  /// Decide whether the cell is ensured. when its re-using the [DataCell].
  bool isEnsured = false;

  /// Decides whether [DataCell] is dirty, to refresh it.
  bool isDirty = false;

  /// Decides whether the [DataCell] has the current-cell.
  bool isCurrentCell = false;

  /// Decide whether the [DataCell] is in edit mode.
  bool isEditing = false;

  /// The column index of the [DataCell].
  int columnIndex = -1;

  /// The row index of the [DataCell].
  int rowIndex = -1;

  /// Count of spanned [DataCell].
  int columnSpan = 0;

  /// Count of spanned [DataRow].
  int rowSpan = 0;

  /// Holds the text style of an widget.
  TextStyle? textStyle;

  /// Holds the cell type.
  /// Eg: GridCell, HeaderCell etc.
  CellType? cellType;

  /// Hold the widget going to place in each [DataCell].
  Widget? columnElement;

  /// Holds the editable widget. When [DataCell] enter into edit mode.
  Widget? editingWidget;

  /// Holds the renderer based on cell type.
  /// Eg: GridHeaderCellRenderer, GridCellTextFieldRenderer etc.
  GridCellRendererBase? renderer;

  /// Holds the corresponding [DataRow], the [DataCell] is present in it.
  DataRowBase? dataRow;

  /// [GridColumn] which is associated with [DataCell].
  GridColumn? gridColumn;

  /// Hold the spanned [DataCell] details.
  StackedHeaderCell? stackedHeaderCell;

  /// Holds the summary column details.
  GridSummaryColumn? summaryColumn;

  /// Initialize the columnElement
  Widget? _onInitializeColumnElement(bool isInEdit) => null;

  /// Update the columnElement.
  void updateColumn() {}

  /// Perform touch interaction on [DataCell]
  /// Eg: selection interaction
  void onTouchUp() {
    if (dataRow != null) {
      final DataGridConfiguration dataGridConfiguration =
          dataRow!.dataGridStateDetails!();
      if (rowIndex <= grid_helper.getHeaderIndex(dataGridConfiguration) ||
          grid_helper.isFooterWidgetRow(rowIndex, dataGridConfiguration) ||
          grid_helper.isTableSummaryIndex(dataGridConfiguration, rowIndex) ||
          dataGridConfiguration.selectionMode == SelectionMode.none) {
        return;
      }

      final RowColumnIndex currentRowColumnIndex =
          RowColumnIndex(rowIndex, columnIndex);
      dataGridConfiguration.rowSelectionManager
          .handleTap(currentRowColumnIndex);
    }
  }
}

/// Provides functionality to display the cell.
class DataCell extends DataCellBase {
  @override
  Widget? _onInitializeColumnElement(bool isInEdit) {
    if (cellType != CellType.indentCell) {
      if (renderer != null) {
        renderer!.setCellStyle(this);
        return renderer!.onPrepareWidgets(this);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  void updateColumn() {
    if (renderer == null) {
      return;
    }
    renderer!
      ..setCellStyle(this)
      ..onPrepareWidgets(this);
  }
}

/// A base class which provides functionalities for [DataRow].
abstract class DataRowBase {
  /// Key is an identifier of [DataRow].
  Key? key;

  /// Hold's the footer view widget.
  Widget? footerView;

  /// Decides whether [DataRow] is dirty, to refresh it.
  bool isDirty = false;

  /// Decide whether the [DataRow] is ensured. when its re-using.
  bool isEnsured = false;

  /// Decide whether the [DataRow] to visible.
  bool isVisible = true;

  /// Holds the collection of visible [DataCell].
  List<DataCellBase> visibleColumns = <DataCellBase>[];

  /// This flag is used to indicating whether the row is swiped or not.
  bool isSwipingRow = false;

  /// Decide whether the any of the [DataCell] present in [DataRow] is in
  /// edit mode.
  bool isEditing = false;

  /// The row index of the [DataRow].
  int rowIndex = -1;

  /// The type of the [DataRow].
  RowType rowType = RowType.headerRow;

  /// The region of the [DataRow] to identify whether the row is scrollable
  RowRegion rowRegion = RowRegion.header;

  /// Decides whether the [DataRow] is currently active
  bool isCurrentRow = false;

  /// Decides whether the [DataRow] is hovered.
  bool isHoveredRow = false;

  /// Holds the details of row configuration.
  DataGridRow? dataGridRow;

  /// Holds the configuration of collection [DataGridCell].
  DataGridRowAdapter? dataGridRowAdapter;

  /// Holds the [DataGridStateDetails].
  DataGridStateDetails? dataGridStateDetails;

  /// Holds the `GridTableSummaryRow` for the current summary row.
  GridTableSummaryRow? tableSummaryRow;

  /// Refresh the column elements in [DataRow]. When index changed.
  void rowIndexChanged() {
    if (rowIndex < 0) {
      return;
    }

    for (final DataCellBase col in visibleColumns) {
      col
        ..rowIndex = rowIndex
        ..dataRow = this
        ..updateColumn();
    }
  }

  void _onGenerateVisibleColumns(VisibleLinesCollection visibleColumnLines) {}

  void _initializeDataRow(VisibleLinesCollection visibleColumnLines) {
    _onGenerateVisibleColumns(visibleColumnLines);
  }

  void _ensureColumns(VisibleLinesCollection visibleColumnLines) {}

  /// Returns the `VisibleLineInfo` for the given column index.
  VisibleLineInfo? getColumnVisibleLineInfo(int index) =>
      dataGridStateDetails!()
          .container
          .scrollColumns
          .getVisibleLineAtLineIndex(index);

  /// Returns the `VisibleLineInfo` for the given row index.
  VisibleLineInfo? getRowVisibleLineInfo(int index) => dataGridStateDetails!()
      .container
      .scrollRows
      .getVisibleLineAtLineIndex(index);

  /// Gets the width of a given column index from the `scrollColumns` collection.
  double getColumnWidth(int startIndex, int endIndex, {bool lineNull = false}) {
    if (startIndex != endIndex || lineNull) {
      final List<DoubleSpan> currentPos = dataGridStateDetails!()
          .container
          .scrollColumns
          .rangeToRegionPoints(startIndex, endIndex, true);
      return currentPos[1].length;
    }

    final VisibleLineInfo? line = getColumnVisibleLineInfo(startIndex);
    if (line == null) {
      return 0;
    }

    return line.size;
  }

  /// Gets the height of a given row index from the `scrollRows` collection.
  double getRowHeight(int startIndex, int endIndex) {
    if (startIndex != endIndex) {
      final List<DoubleSpan> currentPos = dataGridStateDetails!()
          .container
          .scrollRows
          .rangeToRegionPoints(startIndex, endIndex, true);
      return currentPos[1].length;
    }

    final VisibleLineInfo? line = getRowVisibleLineInfo(startIndex);
    if (line == null) {
      return 0;
    }

    return line.size;
  }

  /// Decides whether the [DataRow] is selected.
  bool get isSelectedRow => _isSelectedRow;
  bool _isSelectedRow = false;

  /// Decides whether the [DataRow] is selected.
  set isSelectedRow(bool newValue) {
    if (_isSelectedRow != newValue) {
      _isSelectedRow = newValue;
      for (final DataCellBase dataCell in visibleColumns) {
        dataCell
          ..isDirty = true
          ..updateColumn();
      }
    }
  }
}

/// Provides functionality to process the row.
class DataRow extends DataRowBase {
  /// Creates [DataCell] for [SfDataGrid] widget.
  DataRow();

  @override
  void _onGenerateVisibleColumns(VisibleLinesCollection visibleColumnLines) {
    visibleColumns.clear();

    int startColumnIndex = 0;
    int endColumnIndex = -1;

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0) {
          continue;
        }

        startColumnIndex = 0;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex - 1]
                .lineIndex;
      } else if (i == 1) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0 &&
            visibleColumnLines.lastBodyVisibleIndex < 0) {
          continue;
        }

        if (visibleColumnLines.length >
            visibleColumnLines.firstBodyVisibleIndex) {
          startColumnIndex =
              visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex]
                  .lineIndex;
        } else {
          continue;
        }

        endColumnIndex =
            visibleColumnLines[visibleColumnLines.lastBodyVisibleIndex]
                .lineIndex;
      } else {
        if (visibleColumnLines.firstFooterVisibleIndex >=
            visibleColumnLines.length) {
          continue;
        }

        startColumnIndex =
            visibleColumnLines[visibleColumnLines.firstFooterVisibleIndex]
                .lineIndex;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.length - 1].lineIndex;
      }

      for (int index = startColumnIndex; index <= endColumnIndex; index++) {
        DataCellBase? dc = _createColumn(index);
        visibleColumns.add(dc);
        dc = null;
      }
    }
  }

  @override
  void _ensureColumns(VisibleLinesCollection visibleColumnLines) {
    // Need to ignore footer view Row. because footer view row doesn't have
    // visible columns.
    if (rowType == RowType.footerRow) {
      return;
    }

    for (int i = 0; i < visibleColumns.length; i++) {
      visibleColumns[i].isEnsured = false;
    }

    int startColumnIndex = 0;
    int endColumnIndex = -1;

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0) {
          continue;
        }

        startColumnIndex = 0;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex - 1]
                .lineIndex;
      } else if (i == 1) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0 &&
            visibleColumnLines.lastBodyVisibleIndex < 0) {
          continue;
        }

        if (visibleColumnLines.length >
            visibleColumnLines.firstBodyVisibleIndex) {
          startColumnIndex =
              visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex]
                  .lineIndex;
        } else {
          continue;
        }

        endColumnIndex =
            visibleColumnLines[visibleColumnLines.lastBodyVisibleIndex]
                .lineIndex;
      } else {
        if (visibleColumnLines.firstFooterVisibleIndex >=
            visibleColumnLines.length) {
          continue;
        }

        startColumnIndex =
            visibleColumnLines[visibleColumnLines.firstFooterVisibleIndex]
                .lineIndex;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.length - 1].lineIndex;
      }

      for (int index = startColumnIndex; index <= endColumnIndex; index++) {
        DataCellBase? dc = _indexer(index);
        if (dc == null) {
          DataCellBase? dataCell = _reUseCell(startColumnIndex, endColumnIndex);

          dataCell ??= visibleColumns.firstWhereOrNull((DataCellBase col) =>
              col.columnIndex == -1 && col.cellType != CellType.indentCell);

          _updateColumn(dataCell, index);
          dataCell = null;
        }

        dc ??= visibleColumns
            .firstWhereOrNull((DataCellBase col) => col.columnIndex == index);

        if (dc != null) {
          if (!dc.isVisible) {
            dc.isVisible = true;
          }
        } else {
          dc = _createColumn(index);
          visibleColumns.add(dc);
        }

        dc.isEnsured = true;
        dc = null;
      }
    }

    for (final DataCellBase col in visibleColumns) {
      if (!col.isEnsured || col.columnIndex == -1) {
        col.isVisible = false;
      }
    }
  }

  DataCellBase _createColumn(int index) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();
    final bool canIncrementHeight = rowType == RowType.headerRow &&
        dataGridConfiguration.stackedHeaderRows.isNotEmpty;
    final DataCellBase dc = DataCell()
      ..dataRow = this
      ..columnIndex = index
      ..rowIndex = rowIndex;
    dc.key = ObjectKey(dc);
    final int columnIndex = grid_helper.resolveToGridVisibleColumnIndex(
        dataGridConfiguration, index);
    dc.gridColumn = dataGridConfiguration.columns[columnIndex];
    _checkForCurrentCell(dataGridConfiguration, dc);
    if (rowIndex == grid_helper.getHeaderIndex(dataGridConfiguration) &&
        rowIndex >= 0) {
      dc
        ..renderer = dataGridConfiguration.cellRenderers['ColumnHeader']
        ..cellType = CellType.headerCell;
    } else {
      if (dataGridConfiguration.showCheckboxColumn &&
          dc.gridColumn != null &&
          dc.columnIndex == 0) {
        dc.renderer = dataGridConfiguration.cellRenderers['Checkbox'];
        dc.cellType = CellType.checkboxCell;
      } else {
        dc
          ..renderer = dataGridConfiguration.cellRenderers['TextField']
          ..cellType = CellType.gridCell;
      }
    }
    if (canIncrementHeight) {
      final int rowSpan = grid_helper.getRowSpan(
          dataGridConfiguration, dc.dataRow!.rowIndex - 1, index, false,
          mappingName: dc.gridColumn!.columnName);
      dc.rowSpan = rowSpan;
    }

    dc.columnElement = dc._onInitializeColumnElement(false);
    return dc;
  }

  DataCellBase? _indexer(int index) {
    for (final DataCellBase column in visibleColumns) {
      if (rowType == RowType.tableSummaryRow ||
          rowType == RowType.tableSummaryCoveredRow) {
        if (index >= column.columnIndex &&
            index <= column.columnIndex + column.columnSpan) {
          return column;
        }
      }
      if (column.columnIndex == index) {
        return column;
      }
    }

    return null;
  }

  DataCellBase? _reUseCell(int startColumnIndex, int endColumnIndex) =>
      visibleColumns.firstWhereOrNull((DataCellBase cell) =>
          cell.gridColumn != null &&
          (cell.columnIndex < 0 ||
              cell.columnIndex < startColumnIndex ||
              cell.columnIndex > endColumnIndex) &&
          !cell.isEnsured &&
          !cell.isEditing);

  void _updateColumn(DataCellBase? dc, int index) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();
    final bool canIncrementHeight = rowType == RowType.headerRow &&
        dataGridConfiguration.stackedHeaderRows.isNotEmpty;
    if (dc != null) {
      if (index < 0 || index >= dataGridConfiguration.container.columnCount) {
        dc.isVisible = false;
      } else {
        dc
          ..columnIndex = index
          ..rowIndex = rowIndex
          ..key = dc.key
          ..isVisible = true;
        final int columnIndex = grid_helper.resolveToGridVisibleColumnIndex(
            dataGridConfiguration, index);
        dc.gridColumn = dataGridConfiguration.columns[columnIndex];
        _checkForCurrentCell(dataGridConfiguration, dc);
        _updateRenderer(dataGridConfiguration, dc, dc.gridColumn);
        if (canIncrementHeight) {
          final int rowSpan = grid_helper.getRowSpan(
              dataGridConfiguration, dc.dataRow!.rowIndex - 1, index, false,
              mappingName: dc.gridColumn!.columnName);
          dc.rowSpan = rowSpan;
        } else {
          dc.rowSpan = 0;
        }
        dc
          ..columnElement = dc._onInitializeColumnElement(false)
          ..isEnsured = true;
      }

      if (dc.isVisible != true) {
        dc.isVisible = true;
      }
    } else {
      dc = _createColumn(index);
      visibleColumns.add(dc);
    }
  }

  void _updateRenderer(DataGridConfiguration dataGridConfiguration,
      DataCellBase dataCell, GridColumn? column) {
    GridCellRendererBase? newRenderer;
    if (rowRegion == RowRegion.header && rowType == RowType.headerRow) {
      newRenderer = dataGridConfiguration.cellRenderers['ColumnHeader'];
      dataCell.cellType = CellType.headerCell;
    } else {
      if (dataGridConfiguration.showCheckboxColumn &&
          column != null &&
          dataCell.columnIndex == 0) {
        newRenderer = dataGridConfiguration.cellRenderers['Checkbox'];
        dataCell.cellType = CellType.checkboxCell;
      } else {
        newRenderer = dataGridConfiguration.cellRenderers['TextField'];
        dataCell.cellType = CellType.gridCell;
      }
    }

    dataCell.renderer = newRenderer;
    newRenderer = null;
  }

  void _checkForCurrentCell(
      DataGridConfiguration dataGridConfiguration, DataCellBase dc) {
    if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
      final CurrentCellManager currentCellManager =
          dataGridConfiguration.currentCell;
      if (currentCellManager.columnIndex != -1 &&
          currentCellManager.rowIndex != -1 &&
          currentCellManager.rowIndex == rowIndex &&
          currentCellManager.columnIndex == dc.columnIndex) {
        dc.isCurrentCell = true;
      } else {
        dc.isCurrentCell = false;
      }
    }
  }
}

/// Helps to generate the [DataRow] for data grid.
class RowGenerator {
  /// Creates the [RowGenerator] for the [SfDataGrid].
  RowGenerator({required this.dataGridStateDetails});

  /// Collection of visible [DataRow]'s.
  final List<DataRowBase> items = <DataRowBase>[];

  DataGridConfiguration get _dataGridConfiguration => dataGridStateDetails();

  /// Holds the [DataGridStateDetails].
  DataGridStateDetails dataGridStateDetails;

  VisualContainerHelper get _container => _dataGridConfiguration.container;

  /// Generates the rows for the [SfDataGrid] by using [DataGridSource].
  /// It's generating rows for the data grid initially.
  void preGenerateRows(VisibleLinesCollection? visibleRows,
      VisibleLinesCollection? visibleColumns) {
    if (items.isNotEmpty || _dataGridConfiguration.container.rowCount <= 0) {
      return;
    }

    if (visibleRows != null && visibleColumns != null) {
      for (int i = 0; i < visibleRows.length; i++) {
        VisibleLineInfo? line = visibleRows[i];
        late DataRowBase? dr;
        switch (line.region) {
          case ScrollAxisRegion.header:
            dr = _createHeaderRow(line.lineIndex, visibleColumns);
            break;
          case ScrollAxisRegion.body:
            dr = _createDataRow(line.lineIndex, visibleColumns);
            break;
          case ScrollAxisRegion.footer:
            dr = _createFooterRow(line.lineIndex, visibleColumns);
            break;
        }

        items.add(dr);
        dr = null;
        line = null;
      }
    }
  }

  /// Ensures the data grid rows based on current visible rows.
  void ensureRows(VisibleLinesCollection visibleRows,
      VisibleLinesCollection visibleColumns) {
    List<int>? actualStartAndEndIndex = <int>[];
    RowRegion? region = RowRegion.header;

    List<DataRowBase> reUseRows() => items
        .where((DataRowBase row) =>
            (row.rowIndex < 0 ||
                row.rowIndex < actualStartAndEndIndex![0] ||
                row.rowIndex > actualStartAndEndIndex[1]) &&
            !row.isEnsured &&
            !row.isEditing)
        .toList(growable: false);

    void reuseRow(int rowIndex, RowRegion rowRegion) {
      List<DataRowBase>? rows = reUseRows();
      if (rows.isNotEmpty) {
        _updateRow(rows, rowIndex, rowRegion);
        rows = null;
      }
    }

    for (final DataRowBase row in items) {
      row.isEnsured = false;
    }

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        region = RowRegion.header;
        actualStartAndEndIndex = _container.getStartEndIndex(visibleRows, i);
      } else if (i == 1) {
        region = RowRegion.body;
        actualStartAndEndIndex = _container.getStartEndIndex(visibleRows, i);
      } else {
        region = RowRegion.footer;
        actualStartAndEndIndex = _container.getStartEndIndex(visibleRows, i);
      }

      for (int index = actualStartAndEndIndex[0];
          index <= actualStartAndEndIndex[1];
          index++) {
        DataRowBase? dr = _indexer(index);
        if (dr == null) {
          final DataGridConfiguration dataGridConfiguration =
              dataGridStateDetails();
          if (region == RowRegion.body &&
              dataGridConfiguration.rowsCacheExtent != null &&
              dataGridConfiguration.rowsCacheExtent! > 0) {
            final int cacheLength =
                visibleRows.length + dataGridConfiguration.rowsCacheExtent!;
            final int footerRowsCount = dataGridConfiguration
                    .footerFrozenRowsCount +
                grid_helper.getTableSummaryCount(
                    dataGridConfiguration, GridTableSummaryRowPosition.bottom);

            if (items.length < cacheLength &&
                index >= (items.length - footerRowsCount)) {
              dr = _createDataRow(index, visibleColumns);
              dr.isEnsured = true;
              items.add(dr);
            } else {
              reuseRow(index, region);
            }
          } else {
            reuseRow(index, region);
          }
        }

        dr ??=
            items.firstWhereOrNull((DataRowBase row) => row.rowIndex == index);

        if (dr != null) {
          if (!dr.isVisible) {
            dr.isVisible = true;
          }

          dr.isEnsured = true;
        } else {
          switch (region) {
            case RowRegion.header:
              dr = _createHeaderRow(index, visibleColumns);
              break;
            case RowRegion.body:
              dr = _createDataRow(index, visibleColumns);
              break;
            case RowRegion.footer:
              dr = _createFooterRow(index, visibleColumns);
              break;
          }

          dr.isEnsured = true;
          items.add(dr);
        }

        dr = null;
      }
    }

    for (final DataRowBase row in items) {
      if (!row.isEnsured || row.rowIndex == -1) {
        row.isVisible = false;
      }
    }

    actualStartAndEndIndex = null;
    region = null;
  }

  /// Ensures the data grid columns based on current visible columns.
  void ensureColumns(VisibleLinesCollection visibleColumns) {
    for (final DataRowBase row in items) {
      row._ensureColumns(visibleColumns);
    }
  }

  DataRowBase _createDataRow(
      int rowIndex, VisibleLinesCollection visibleColumns,
      {RowRegion rowRegion = RowRegion.body}) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    DataRowBase dr;
    if (grid_helper.isFooterWidgetRow(rowIndex, dataGridConfiguration)) {
      dr = DataRow()
        ..rowIndex = rowIndex
        ..rowRegion = rowRegion
        ..rowType = RowType.footerRow
        ..dataGridStateDetails = dataGridStateDetails;
      dr.key = ObjectKey(dr);
      dr.footerView = _buildFooterWidget(dataGridConfiguration, rowIndex);
      return dr;
    } else {
      dr = DataRow()
        ..rowIndex = rowIndex
        ..rowRegion = rowRegion
        ..rowType = RowType.dataRow
        ..dataGridStateDetails = dataGridStateDetails;
      dr.key = ObjectKey(dr);
      dr
        ..dataGridRow =
            grid_helper.getDataGridRow(dataGridConfiguration, rowIndex)
        ..dataGridRowAdapter = grid_helper.getDataGridRowAdapter(
            dataGridConfiguration, dr.dataGridRow!);
      assert(grid_helper.debugCheckTheLength(
          dataGridConfiguration,
          dataGridConfiguration.columns.length,
          dr.dataGridRowAdapter!.cells.length,
          'SfDataGrid.columns.length == DataGridRowAdapter.cells.length'));
      _checkForCurrentRow(dr);
      _checkForSelection(dr);
      dr._initializeDataRow(visibleColumns);
      return dr;
    }
  }

  DataRowBase _createHeaderRow(
      int rowIndex, VisibleLinesCollection visibleColumns) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    DataRowBase dr;
    if (rowIndex == grid_helper.getHeaderIndex(dataGridConfiguration)) {
      dr = DataRow()
        ..rowIndex = rowIndex
        ..rowRegion = RowRegion.header
        ..rowType = RowType.headerRow
        ..dataGridStateDetails = dataGridStateDetails;
      dr
        ..key = ObjectKey(dr)
        .._initializeDataRow(visibleColumns);
      return dr;
    } else if (rowIndex < dataGridConfiguration.stackedHeaderRows.length) {
      dr = _SpannedDataRow();
      dr.key = ObjectKey(dr);
      dr.rowIndex = rowIndex;
      dr.rowRegion = RowRegion.header;
      dr.rowType = RowType.stackedHeaderRow;
      dr.dataGridStateDetails = dataGridStateDetails;
      _createStackedHeaderCell(
          dataGridConfiguration.stackedHeaderRows[rowIndex], rowIndex);
      dr._initializeDataRow(visibleColumns);
      return dr;
    } else if (grid_helper.isTopTableSummaryRow(
        dataGridConfiguration, rowIndex)) {
      dr = _createTableSummaryRow(rowIndex, GridTableSummaryRowPosition.top);
      dr
        ..key = ObjectKey(dr)
        ..rowRegion = RowRegion.header
        ..dataGridStateDetails = dataGridStateDetails
        .._initializeDataRow(visibleColumns);
      return dr;
    } else {
      return _createDataRow(rowIndex, visibleColumns,
          rowRegion: RowRegion.header);
    }
  }

  void _createStackedHeaderCell(StackedHeaderRow header, int rowIndex) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    for (final StackedHeaderCell column in header.cells) {
      final List<int> childSequence =
          grid_helper.getChildSequence(dataGridConfiguration, column, rowIndex);
      childSequence.sort();
      setChildColumnIndexes(column, childSequence);
    }
  }

  DataRowBase _createFooterRow(
      int rowIndex, VisibleLinesCollection visibleColumns) {
    DataRowBase dr;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (grid_helper.isBottomTableSummaryRow(dataGridConfiguration, rowIndex)) {
      dr = _createTableSummaryRow(rowIndex, GridTableSummaryRowPosition.bottom);
      dr
        ..key = ObjectKey(dr)
        ..dataGridStateDetails = dataGridStateDetails
        ..rowRegion = RowRegion.footer
        .._initializeDataRow(visibleColumns);
    } else {
      dr =
          _createDataRow(rowIndex, visibleColumns, rowRegion: RowRegion.footer);
    }
    return dr;
  }

  Widget? _buildFooterWidget(
      DataGridConfiguration dataGridConfiguration, int rowIndex) {
    if (dataGridConfiguration.footer == null) {
      return null;
    }

    BoxDecoration drawBorder() {
      final DataGridThemeHelper themeData =
          dataGridConfiguration.dataGridThemeHelper!;
      final GridLinesVisibility gridLinesVisibility =
          dataGridConfiguration.gridLinesVisibility;

      final bool canDrawHorizontalBorder = (gridLinesVisibility ==
                  GridLinesVisibility.horizontal ||
              gridLinesVisibility == GridLinesVisibility.both) &&
          grid_helper.getTableSummaryCount(
                  dataGridConfiguration, GridTableSummaryRowPosition.bottom) <=
              0;
      final bool canDrawVerticalBorder =
          gridLinesVisibility == GridLinesVisibility.vertical ||
              gridLinesVisibility == GridLinesVisibility.both;

      final bool canDrawTopFrozenBorder =
          dataGridConfiguration.footerFrozenRowsCount.isFinite &&
              dataGridConfiguration.footerFrozenRowsCount > 0 &&
              grid_helper.getStartFooterFrozenRowIndex(dataGridConfiguration) ==
                  rowIndex;

      return BoxDecoration(
        border: BorderDirectional(
          top: canDrawTopFrozenBorder && themeData.frozenPaneElevation <= 0.0
              ? BorderSide(
                  color: themeData.frozenPaneLineColor,
                  width: themeData.frozenPaneLineWidth)
              : BorderSide.none,
          bottom: canDrawHorizontalBorder
              ? BorderSide(
                  color: themeData.gridLineColor,
                  width: themeData.gridLineStrokeWidth)
              : BorderSide.none,
          end: canDrawVerticalBorder
              ? BorderSide(
                  color: themeData.gridLineColor,
                  width: themeData.gridLineStrokeWidth)
              : BorderSide.none,
        ),
      );
    }

    return Container(
        decoration: drawBorder(),
        clipBehavior: Clip.antiAlias,
        child: dataGridConfiguration.footer);
  }

  DataRowBase? _indexer(int index) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].rowIndex == index) {
        return items[i];
      }
    }

    return null;
  }

  void _updateRow(List<DataRowBase> rows, int index, RowRegion region) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    final VisibleLinesCollection visibleColumns =
        grid_helper.getVisibleLines(dataGridConfiguration);
    switch (region) {
      case RowRegion.header:
        _updateHeaderRow(
            rows, index, region, visibleColumns, dataGridConfiguration);
        break;
      case RowRegion.body:
        _updateDataRow(
            rows, index, region, visibleColumns, dataGridConfiguration);
        break;
      case RowRegion.footer:
        _updateFooterRow(
            rows, index, region, visibleColumns, dataGridConfiguration);
        break;
    }
  }

  DataRowBase _createTableSummaryRow(
      int rowIndex, GridTableSummaryRowPosition position) {
    final GridTableSummaryRow? tableSummaryRow = grid_helper.getTableSummaryRow(
        _dataGridConfiguration, rowIndex, position);
    final _SpannedDataRow spannedDataRow = _SpannedDataRow()
      ..rowIndex = rowIndex
      ..tableSummaryRow = tableSummaryRow;

    if (tableSummaryRow != null) {
      spannedDataRow.rowType = tableSummaryRow.showSummaryInRow
          ? RowType.tableSummaryCoveredRow
          : RowType.tableSummaryRow;
    }
    return spannedDataRow;
  }

  void _updateHeaderRow(
      List<DataRowBase> rows,
      int index,
      RowRegion region,
      VisibleLinesCollection visibleColumns,
      DataGridConfiguration dataGridConfiguration) {
    DataRowBase? dr;
    void createHeaderRow() {
      dr = _createHeaderRow(index, visibleColumns);
      items.add(dr!);
      dr = null;
    }

    if (index == grid_helper.getHeaderIndex(dataGridConfiguration)) {
      dr = rows.firstWhereOrNull(
          (DataRowBase row) => row.rowType == RowType.headerRow);
      if (dr != null) {
        dr!
          ..key = dr!.key
          ..rowIndex = index
          ..rowRegion = region
          ..rowType = RowType.headerRow
          ..rowIndexChanged();
        dr = null;
      } else {
        createHeaderRow();
      }
    } else if (index < dataGridConfiguration.stackedHeaderRows.length) {
      dr = rows.firstWhereOrNull(
          (DataRowBase r) => r.rowType == RowType.stackedHeaderRow);
      if (dr != null) {
        dr!
          ..key = dr!.key
          ..rowIndex = index
          ..rowRegion = region
          ..rowType = RowType.stackedHeaderRow
          ..rowIndexChanged();
        _createStackedHeaderCell(
            dataGridConfiguration.stackedHeaderRows[index], index);
        dr!._initializeDataRow(
            dataGridConfiguration.container.scrollRows.getVisibleLines());
      } else {
        createHeaderRow();
      }
    } else if (grid_helper.isTopTableSummaryRow(dataGridConfiguration, index)) {
      dr = rows.firstWhereOrNull((DataRowBase r) =>
          r.rowRegion == region &&
          (r.rowType == RowType.tableSummaryRow ||
              r.rowType == RowType.tableSummaryCoveredRow));
      if (dr != null) {
        dr!
          ..key = dr!.key
          ..rowRegion = region
          ..rowIndex = index
          .._initializeDataRow(visibleColumns);
      } else {
        createHeaderRow();
      }
    }
  }

  void _updateDataRow(
      List<DataRowBase> rows,
      int index,
      RowRegion region,
      VisibleLinesCollection visibleColumns,
      DataGridConfiguration dataGridConfiguration) {
    DataRowBase? row = rows.firstWhereOrNull(
        (DataRowBase row) => row is DataRow && row.rowType == RowType.dataRow);
    void createDataRow() {
      row = _createDataRow(index, visibleColumns);
      items.add(row!);
      row = null;
    }

    if (grid_helper.isFooterWidgetRow(index, dataGridConfiguration)) {
      row = rows
          .firstWhereOrNull((DataRowBase r) => r.rowType == RowType.footerRow);
      if (row != null) {
        row!
          ..key = row!.key
          ..rowIndex = index
          ..rowRegion = region
          ..rowType = RowType.footerRow;
        row!.footerView = _buildFooterWidget(dataGridConfiguration, index);
      } else {
        createDataRow();
      }
    } else if (row != null && row is DataRow) {
      if (index < 0 || index >= _container.scrollRows.lineCount) {
        row!.isVisible = false;
      } else {
        row!
          ..key = row!.key
          ..rowIndex = index
          ..rowRegion = region
          ..dataGridRow =
              grid_helper.getDataGridRow(dataGridConfiguration, index)
          ..dataGridRowAdapter = grid_helper.getDataGridRowAdapter(
              dataGridConfiguration, row!.dataGridRow!);
        assert(grid_helper.debugCheckTheLength(
            dataGridConfiguration,
            dataGridConfiguration.columns.length,
            row!.dataGridRowAdapter!.cells.length,
            'SfDataGrid.columns.length == DataGridRowAdapter.cells.length'));
        _checkForCurrentRow(row!);
        _checkForSelection(row!);
        row!.rowIndexChanged();
      }
      row = null;
    } else {
      createDataRow();
    }
  }

  void _updateFooterRow(
      List<DataRowBase> rows,
      int index,
      RowRegion region,
      VisibleLinesCollection visibleColumns,
      DataGridConfiguration dataGridConfiguration) {
    DataRowBase? dr;
    if (grid_helper.isBottomTableSummaryRow(dataGridConfiguration, index)) {
      dr = rows.firstWhereOrNull((DataRowBase r) =>
          r.rowRegion == region &&
          (r.rowType == RowType.tableSummaryRow ||
              r.rowType == RowType.tableSummaryCoveredRow));
      if (dr != null) {
        dr
          ..key = dr.key
          ..rowRegion = region
          ..rowIndex = index
          .._initializeDataRow(visibleColumns);
      } else {
        dr = _createFooterRow(index, visibleColumns);
        items.add(dr);
        dr = null;
      }
    } else {
      _updateDataRow(
          rows, index, region, visibleColumns, dataGridConfiguration);
    }
  }

  /// Invokes the [SfDataGrid.onQueryRowHeight] callback.
  double queryRowHeight(int rowIndex, double height) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    double rowHeight = height;
    if (dataGridConfiguration.onQueryRowHeight != null) {
      final RowHeightDetails details = RowHeightDetails(rowIndex, height);
      setColumnSizerInRowHeightDetailsArgs(
          details, dataGridConfiguration.columnSizer);
      rowHeight = dataGridConfiguration.onQueryRowHeight!(details);
    }

    return rowHeight;
  }

  void _checkForSelection(DataRowBase row) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    if (dataGridConfiguration.selectionMode != SelectionMode.none) {
      final int recordIndex =
          grid_helper.resolveToRecordIndex(dataGridConfiguration, row.rowIndex);
      final DataGridRow record =
          effectiveRows(dataGridConfiguration.source)[recordIndex];
      row._isSelectedRow =
          selection_manager.isSelectedRow(dataGridConfiguration, record);
    }
  }

  void _checkForCurrentRow(DataRowBase dr) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
      final CurrentCellManager currentCellManager =
          dataGridConfiguration.currentCell;

      DataCellBase? getDataCell() {
        if (dr.visibleColumns.isEmpty) {
          return null;
        }

        final DataCellBase? dc = dr.visibleColumns.firstWhereOrNull(
            (DataCellBase dataCell) =>
                dataCell.columnIndex == currentCellManager.columnIndex);
        return dc;
      }

      if (currentCellManager.rowIndex != -1 &&
          currentCellManager.columnIndex != -1 &&
          currentCellManager.rowIndex == dr.rowIndex) {
        final DataCellBase? dataCell = getDataCell();
        currentCellManager.setCurrentCellDirty(dr, dataCell, true);
      } else if (dr.isCurrentRow) {
        final DataCellBase? dataCell = getDataCell();
        currentCellManager.setCurrentCellDirty(dr, dataCell, false);
      } else {
        dr.isCurrentRow = false;
      }
    }
  }
}

/// Provides functionality to process the spanned data row.
class _SpannedDataRow extends DataRow {
  @override
  void _onGenerateVisibleColumns(VisibleLinesCollection visibleColumnLines) {
    if (visibleColumnLines.isEmpty) {
      return;
    }
    visibleColumns.clear();

    _SpannedDataColumn dc;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();

    if (rowType == RowType.tableSummaryRow ||
        rowType == RowType.tableSummaryCoveredRow) {
      if (rowType == RowType.tableSummaryRow) {
        for (int i = 0; i < dataGridConfiguration.container.columnCount; i++) {
          if (!_isEnsuredSpannedCell(i)) {
            final int columnSpan = grid_helper.getSummaryColumnSpan(
                dataGridConfiguration, i, rowType, tableSummaryRow);
            dc = _createSpannedColumn(i, columnSpan, null);
            visibleColumns.add(dc);
          }
        }
      } else {
        final int columnSpan = grid_helper.getSummaryColumnSpan(
            dataGridConfiguration, 0, rowType, tableSummaryRow);
        dc = _createSpannedColumn(0, columnSpan, null);
        visibleColumns.add(dc);
      }
    } else if (rowType == RowType.stackedHeaderRow) {
      if (rowType == RowType.stackedHeaderRow) {
        if (dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
          final List<StackedHeaderCell> stackedColumns =
              dataGridConfiguration.stackedHeaderRows[rowIndex].cells;
          for (final StackedHeaderCell column in stackedColumns) {
            final List<List<int>> columnsSequence =
                grid_helper.getConsecutiveRanges(getChildColumnIndexes(column));

            for (final List<int> columns in columnsSequence) {
              dc = _createSpannedColumn(
                  columns.reduce(min), columns.length - 1, column);
              visibleColumns.add(dc);
            }
          }
        }
      }
    }
  }

  int _getRowSpan(int columnIndex, StackedHeaderCell? stackedHeaderCell,
      String mappingName) {
    int rowSpan = 0;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();
    if (rowType == RowType.stackedHeaderRow) {
      rowSpan = grid_helper.getRowSpan(
          dataGridConfiguration, rowIndex, columnIndex, true,
          stackedHeaderCell: stackedHeaderCell);
    } else if (rowType == RowType.headerRow) {
      rowSpan = grid_helper.getRowSpan(
          dataGridConfiguration, rowIndex - 1, columnIndex, false,
          mappingName: mappingName);
    }
    return rowSpan;
  }

  _SpannedDataColumn _createSpannedCell(_SpannedDataColumn dc, int columnIndex,
      int columnSpan, int rowSpan, GridColumn? gridColumn) {
    dc
      ..dataRow = this
      ..columnIndex = columnIndex
      ..rowIndex = rowIndex;
    dc.key = ObjectKey(dc);
    dc
      ..columnSpan = columnSpan
      ..rowSpan = rowSpan
      ..gridColumn = gridColumn
      ..isEnsured = true;
    return dc;
  }

  _SpannedDataColumn _createSpannedColumn(
      int index, int columnSpan, StackedHeaderCell? stackedHeaderCell) {
    _SpannedDataColumn dc = _SpannedDataColumn();
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();

    if (index >= grid_helper.resolveToStartColumnIndex(dataGridConfiguration)) {
      final int startColumnIndex =
          grid_helper.resolveToScrollColumnIndex(dataGridConfiguration, index);
      final GridColumn gridColumn =
          dataGridConfiguration.columns[startColumnIndex];
      final int rowSpan =
          _getRowSpan(index, stackedHeaderCell, gridColumn.columnName);

      if (rowType == RowType.stackedHeaderRow) {
        dc = _createSpannedCell(dc, index, columnSpan, rowSpan, gridColumn);
        dc
          ..renderer = dataGridConfiguration.cellRenderers['StackedHeader']
          ..stackedHeaderCell = stackedHeaderCell
          ..cellType = CellType.stackedHeaderCell;
      } else if (rowType == RowType.tableSummaryRow ||
          rowType == RowType.tableSummaryCoveredRow) {
        dc = _createSpannedCell(dc, index, columnSpan, rowSpan, gridColumn);
        dc
          ..renderer = dataGridConfiguration.cellRenderers['TableSummary']
          ..cellType = CellType.tableSummaryCell;

        // Sets the summaryColumn to the data cell.
        if (tableSummaryRow != null && tableSummaryRow!.columns.isNotEmpty) {
          if (rowType == RowType.tableSummaryRow) {
            final int titleColumnSpan = grid_helper.getSummaryTitleColumnSpan(
                dataGridConfiguration, tableSummaryRow!);
            if (dc.columnIndex >= titleColumnSpan) {
              dc.summaryColumn = tableSummaryRow!.columns.firstWhereOrNull(
                  (GridSummaryColumn element) =>
                      element.columnName == gridColumn.columnName);
            }
          }
        }
      }
    } else {
      // To create an indent cell if it exist in the spanned row.
      dc = _createSpannedCell(dc, index, columnSpan, 0, null);
    }

    dc.columnElement = dc._onInitializeColumnElement(false);
    return dc;
  }

  void _ensureSpannedColumn(
      {required int columnIndex,
      required int columnSpan,
      StackedHeaderCell? stackedHeaderCell}) {
    DataCellBase? dc = _indexer(columnIndex);

    if (dc == null) {
      DataCellBase? dataCell =
          _reUseCell(columnIndex, columnIndex + columnSpan);
      dataCell ??= visibleColumns.firstWhereOrNull((DataCellBase col) =>
          col.columnIndex == -1 && col.cellType != CellType.indentCell);

      _updateSpannedColumn(
          dataCell, columnIndex, columnSpan, stackedHeaderCell);
      dataCell = null;
    }

    dc ??= visibleColumns
        .firstWhereOrNull((DataCellBase col) => col.columnIndex == columnIndex);

    if (dc != null) {
      if (!dc.isVisible) {
        dc.isVisible = true;
      }
    } else {
      dc = _createSpannedColumn(columnIndex, columnSpan, stackedHeaderCell);
      visibleColumns.add(dc);
    }

    dc.isEnsured = true;
    dc = null;
  }

  @override
  void _ensureColumns(VisibleLinesCollection visibleColumnLines) {
    if (rowIndex == -1) {
      return;
    }

    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();
    if (rowType == RowType.stackedHeaderRow &&
        dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
      final StackedHeaderRow stackedHeaderRow =
          dataGridConfiguration.stackedHeaderRows[rowIndex];
      final List<StackedHeaderCell> stackedColumns = stackedHeaderRow.cells;
      dataGridConfiguration.rowGenerator
          ._createStackedHeaderCell(stackedHeaderRow, rowIndex);
      for (final StackedHeaderCell column in stackedColumns) {
        final List<List<int>> columnsSequence =
            grid_helper.getConsecutiveRanges(getChildColumnIndexes(column));

        for (final List<int> columns in columnsSequence) {
          final int columnIndex = columns.reduce(min);
          final int columnSpan = columns.length - 1;
          _ensureSpannedColumn(
              columnSpan: columnSpan,
              columnIndex: columnIndex,
              stackedHeaderCell: column);
        }
      }
    } else {
      for (final DataCellBase column in visibleColumns) {
        column.isEnsured = false;
      }

      for (int i = 0; i < 3; i++) {
        final List<int> startAndEndIndex = dataGridConfiguration.container
            .getStartEndIndex(visibleColumnLines, i);

        for (int index = startAndEndIndex[0];
            index <= startAndEndIndex[1];
            index++) {
          if (!_isEnsuredSpannedCell(index)) {
            final int columnSpan = grid_helper.getSummaryColumnSpan(
                dataGridConfiguration, index, rowType, tableSummaryRow);
            _ensureSpannedColumn(columnIndex: index, columnSpan: columnSpan);
          }
        }
      }
    }

    for (final DataCellBase col in visibleColumns) {
      if (!col.isEnsured || col.columnIndex == -1) {
        col.isVisible = false;
      }
    }
  }

  void _updateSpannedColumn(DataCellBase? dc, int index, int columnSpan,
      StackedHeaderCell? stackedHeaderCell) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails!();
    if (dc != null) {
      if (index < 0 || index >= dataGridConfiguration.container.columnCount) {
        dc.isVisible = false;
      } else {
        final int columnIndex = grid_helper.resolveToGridVisibleColumnIndex(
            dataGridConfiguration, index);
        final GridColumn gridColumn =
            dataGridConfiguration.columns[columnIndex];
        final int rowSpan =
            _getRowSpan(index, stackedHeaderCell, gridColumn.columnName);

        dc
          ..columnIndex = index
          ..rowIndex = rowIndex
          ..columnSpan = columnSpan
          ..rowSpan = rowSpan
          ..key = dc.key
          ..isVisible = true;
        dc.gridColumn = gridColumn;
        if (rowType == RowType.stackedHeaderRow) {
          dc
            ..renderer = dataGridConfiguration.cellRenderers['StackedHeader']
            ..stackedHeaderCell = stackedHeaderCell
            ..cellType = CellType.stackedHeaderCell;
        }
        if (rowType == RowType.tableSummaryRow ||
            rowType == RowType.tableSummaryCoveredRow) {
          dc
            ..renderer = dataGridConfiguration.cellRenderers['TableSummary']
            ..cellType = CellType.tableSummaryCell;
        }

        dc
          ..columnElement = dc._onInitializeColumnElement(false)
          ..isEnsured = true;
      }

      if (dc.isVisible != true) {
        dc.isVisible = true;
      }
    } else {
      dc = _createSpannedColumn(index, columnSpan, stackedHeaderCell);
      visibleColumns.add(dc);
    }
  }

  bool _isEnsuredSpannedCell(int index) {
    return visibleColumns.any((DataCellBase cell) =>
        cell.isEnsured &&
        (index >= cell.columnIndex &&
            index <= cell.columnIndex + cell.columnSpan));
  }
}

/// Provides functionality to display the spanned cell.
class _SpannedDataColumn extends DataCell {}
