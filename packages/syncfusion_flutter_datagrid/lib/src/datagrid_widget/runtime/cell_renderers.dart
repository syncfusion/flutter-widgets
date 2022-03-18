import 'package:flutter/material.dart' hide DataCell, DataRow;

import '../../../datagrid.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../selection/selection_manager.dart' as selection_manager;
import '../widgets/cell_widget.dart';
import 'generator.dart';

/// The base class for the cell renderer that used to display the widget.
abstract class GridCellRendererBase {
  /// Decide to enable the editing in the renderer.
  bool isEditable = true;

  late DataGridStateDetails _dataGridStateDetails;

  /// Called when the child widgets for the GridCell are prepared.
  Widget? onPrepareWidgets(DataCellBase dataCell) {
    return null;
  }

  /// Called when the style is set for the cell.
  void setCellStyle(DataCellBase dataCell) {}
}

/// A cell renderer which displays the header text in the
/// stacked columns of the stacked header rows.
class GridStackedHeaderCellRenderer
    extends GridVirtualizingCellRendererBase<Widget, Widget> {
  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    Widget? label = DefaultTextStyle(
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color:
                dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87)),
        child: dataCell.stackedHeaderCell!.child);

    dataCell.columnElement = GridCell(
      key: dataCell.key!,
      dataCell: dataCell,
      backgroundColor:
          dataGridConfiguration.colorScheme!.surface.withOpacity(0.0001),
      isDirty: dataGridConfiguration.container.isDirty || dataCell.isDirty,
      dataGridStateDetails: _dataGridStateDetails,
      child: label,
    );

    label = null;
  }
}

/// A cell renderer which displays the String value in the cell.
///
/// This renderer is typically used for `GridTextColumn`.
class GridCellTextFieldRenderer
    extends GridVirtualizingCellRendererBase<Text, TextField> {
  @override
  void setCellStyle(DataCellBase? dataCell) {
    if (dataCell != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      dataCell.textStyle = _getCellTextStyle(dataGridConfiguration, dataCell);
      super.setCellStyle(dataCell);
    }
  }

  TextStyle _getCellTextStyle(
      DataGridConfiguration dataGridConfiguration, DataCellBase dataCell) {
    final DataRowBase? dataRow = dataCell.dataRow;
    if (dataRow != null && dataRow.isSelectedRow) {
      return dataRow.isHoveredRow
          ? dataGridConfiguration.dataGridThemeHelper!.rowHoverTextStyle
          : TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: dataGridConfiguration.colorScheme!.onSurface
                  .withOpacity(0.87));
    } else {
      return dataRow!.isHoveredRow
          ? dataGridConfiguration.dataGridThemeHelper!.rowHoverTextStyle
          : TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: dataGridConfiguration.colorScheme!.onSurface
                  .withOpacity(0.87));
    }
  }
}

/// A cell renderer which displays the header text in the columns.
class GridHeaderCellRenderer
    extends GridVirtualizingCellRendererBase<Container, GridHeaderCell> {
  /// Creates the [GridHeaderCellRenderer] for [SfDataGrid] widget.
  GridHeaderCellRenderer() {
    super.isEditable = false;
  }

  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    final Widget child = DefaultTextStyle(
        key: dataCell.key,
        style: dataCell.textStyle!,
        child: dataCell.gridColumn!.label);
    if (dataGridConfiguration.showCheckboxColumn && dataCell.columnIndex == 0) {
      dataCell.columnElement = GridCell(
          key: dataCell.key!,
          dataCell: dataCell,
          backgroundColor: Colors.transparent,
          isDirty: dataGridConfiguration.container.isDirty ||
              dataCell.isDirty ||
              dataCell.dataRow!.isDirty,
          dataGridStateDetails: _dataGridStateDetails,
          child:
              _getCheckboxHeaderWidget(dataGridConfiguration, dataCell, child));
    } else {
      dataCell.columnElement = GridHeaderCell(
          key: dataCell.key!,
          dataCell: dataCell,
          backgroundColor: Colors.transparent,
          isDirty: dataGridConfiguration.container.isDirty ||
              dataCell.isDirty ||
              dataCell.dataRow!.isDirty,
          dataGridStateDetails: _dataGridStateDetails,
          child: child);
    }
  }

  @override
  void setCellStyle(DataCellBase dataCell) {
    TextStyle getDefaultHeaderTextStyle() {
      return TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color:
              _dataGridStateDetails().colorScheme!.onSurface.withOpacity(0.87));
    }

    dataCell.textStyle = getDefaultHeaderTextStyle();
  }

  /// Creates a widget which displays label by default. Also, it creates with Checkbox,
  /// only when the [DataGridConfiguration.showCheckboxOnHeader] is true.
  Widget _getCheckboxHeaderWidget(DataGridConfiguration dataGridConfiguration,
      DataCellBase dataCell, Widget child) {
    final Widget label = Flexible(
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            key: dataCell.key,
            style: dataCell.textStyle!,
            child: child));

    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
            visible: dataGridConfiguration
                .checkboxColumnSettings.showCheckboxOnHeader,
            child: Checkbox(
                tristate: true,
                value: dataGridConfiguration.headerCheckboxState,
                onChanged: (bool? newValue) {
                  if (dataGridConfiguration.selectionMode ==
                      SelectionMode.multiple) {
                    selection_manager.handleSelectionFromCheckbox(
                        dataGridConfiguration,
                        dataCell,
                        dataGridConfiguration.headerCheckboxState,
                        newValue);
                  }
                })),
        label
      ],
    ));
  }
}

/// A base class for cell renderer classes which displays widget in a cell.
abstract class GridVirtualizingCellRendererBase<T1 extends Widget,
    T2 extends Widget> extends GridCellRendererBase {
  /// Creates the [GridVirtualizingCellRendererBase] for [SfDataGrid] widget.
  GridVirtualizingCellRendererBase();

  /// Initializes the column element of a [DataCell]
  ///
  /// object with the given widget and required values.
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    // Need to restrict invisible rows (rowIndex == -1) from the item collection.
    // Because we generate the `ensureColumns` for all the data rows in the
    // `rowGenerator.items` collection not visible rows.
    if (dataCell.columnIndex < 0 || dataCell.rowIndex < 0) {
      return;
    }

    final int index = grid_helper.resolveToDataGridRowAdapterCellIndex(
        dataGridConfiguration, dataCell.columnIndex);
    final Widget child = dataCell.dataRow!.dataGridRowAdapter!.cells[index];

    Widget getChild() {
      if (dataGridConfiguration.currentCell.isEditing && dataCell.isEditing) {
        return dataCell.editingWidget ?? child;
      } else {
        return child;
      }
    }

    dataCell.columnElement = GridCell(
      key: dataCell.key!,
      dataCell: dataCell,
      backgroundColor: Colors.transparent,
      isDirty: dataGridConfiguration.container.isDirty ||
          dataCell.isDirty ||
          dataCell.dataRow!.isDirty,
      dataGridStateDetails: _dataGridStateDetails,
      child: DefaultTextStyle(
          key: dataCell.key, style: dataCell.textStyle!, child: getChild()),
    );
  }

  @override
  Widget? onPrepareWidgets(DataCellBase dataCell) {
    onInitializeDisplayWidget(dataCell);
    return dataCell.columnElement;
  }
}

/// A cell renderer which displays the check box column.
class GridCheckboxRenderer
    extends GridVirtualizingCellRendererBase<Widget, Widget> {
  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataCell.columnIndex < 0 || dataCell.rowIndex < 0) {
      return;
    }

    final bool selectionState = dataCell.dataRow!.isSelectedRow;

    dataCell.columnElement = GridCell(
        key: dataCell.key!,
        dataCell: dataCell,
        backgroundColor:
            dataGridConfiguration.checkboxColumnSettings.backgroundColor ??
                Colors.transparent,
        isDirty: dataGridConfiguration.container.isDirty ||
            dataCell.isDirty ||
            dataCell.dataRow!.isDirty,
        dataGridStateDetails: _dataGridStateDetails,
        child: Checkbox(
            value: selectionState,
            onChanged: (bool? newValue) {
              selection_manager.handleSelectionFromCheckbox(
                  dataGridConfiguration, dataCell, selectionState, newValue);
            }));
  }
}

/// A cell renderer which displays the widgets to the table summary rows.
class GridTableSummaryCellRenderer
    extends GridVirtualizingCellRendererBase<Widget, Widget> {
  @override
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    Widget getSummaryCell() {
      Widget? cell;
      final GridTableSummaryRow? tableSummaryRow =
          dataCell.dataRow!.tableSummaryRow;

      if (tableSummaryRow != null) {
        final int titleColumnSpan = grid_helper.getSummaryTitleColumnSpan(
            dataGridConfiguration, tableSummaryRow);
        if (dataCell.summaryColumn != null ||
            tableSummaryRow.showSummaryInRow ||
            (!tableSummaryRow.showSummaryInRow &&
                titleColumnSpan > 0 &&
                dataCell.columnIndex < titleColumnSpan)) {
          final GridSummaryColumn? summaryColumn = dataCell.summaryColumn;
          final RowColumnIndex rowColumnIndex =
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex);
          final String title = dataGridConfiguration.source
              .calculateSummaryValue(
                  tableSummaryRow, summaryColumn, rowColumnIndex);

          cell = dataGridConfiguration.source.buildTableSummaryCellWidget(
              tableSummaryRow, summaryColumn, rowColumnIndex, title);
        }
      }
      cell ??= Container();
      return cell;
    }

    Widget? label = DefaultTextStyle(
        style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color:
                dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87)),
        child: getSummaryCell());

    dataCell.columnElement = GridCell(
      key: dataCell.key!,
      dataCell: dataCell,
      backgroundColor: Colors.transparent,
      dataGridStateDetails: _dataGridStateDetails,
      isDirty: dataGridConfiguration.container.isDirty || dataCell.isDirty,
      child: label,
    );

    label = null;
  }
}

/// Sets the `dataGridConfiguration` to the cell renderers.
void setStateDetailsInCellRendererBase(GridCellRendererBase cellRendererBase,
    DataGridStateDetails dataGridStateDetails) {
  cellRendererBase._dataGridStateDetails = dataGridStateDetails;
}
