import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../grid_common/row_column_index.dart';
import '../helper/callbackargs.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../runtime/column.dart';
import '../runtime/generator.dart';
import '../sfdatagrid.dart';
import 'rendering_widget.dart';

/// A widget which displays in the cells.
class GridCell extends StatefulWidget {
  /// Creates the [GridCell] for [SfDataGrid] widget.
  const GridCell(
      {required Key key,
      required this.dataCell,
      required this.isDirty,
      required this.backgroundColor,
      required this.child,
      required this.dataGridStateDetails})
      : super(key: key);

  /// Holds the information required to display the cell.
  final DataCellBase dataCell;

  /// The [child] contained by the [GridCell].
  final Widget child;

  /// The color to paint behind the [child].
  final Color backgroundColor;

  /// Decides whether the [GridCell] should be refreshed when [SfDataGrid] is
  /// rebuild.
  final bool isDirty;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  State<StatefulWidget> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  late PointerDeviceKind _kind;
  Timer? tapTimer;

  DataGridStateDetails get dataGridStateDetails => widget.dataGridStateDetails;

  bool _isDoubleTapEnabled(DataGridConfiguration dataGridConfiguration) =>
      dataGridConfiguration.onCellDoubleTap != null ||
      (dataGridConfiguration.allowEditing &&
          dataGridConfiguration.editingGestureType ==
              EditingGestureType.doubleTap);

  void _handleOnTapDown(TapDownDetails details, bool isSecondaryTapDown) {
    _kind = details.kind!;
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    // Clear editing when tap on the stacked header cell.
    if (widget.dataCell.cellType == CellType.stackedHeaderCell &&
        dataGridConfiguration.currentCell.isEditing) {
      dataGridConfiguration.currentCell.onCellSubmit(dataGridConfiguration);
    }

    if (_isDoubleTapEnabled(dataGridConfiguration)) {
      _handleDoubleTapOnEditing(
          dataGridConfiguration, dataCell, details, isSecondaryTapDown);
    }
  }

  void _handleDoubleTapOnEditing(DataGridConfiguration dataGridConfiguration,
      DataCellBase dataCell, TapDownDetails details, bool isSecondaryTapDown) {
    if (tapTimer != null && tapTimer!.isActive) {
      tapTimer!.cancel();
    } else {
      tapTimer?.cancel();
      // 190 millisecond to satisfies all desktop touchpad double-tap
      // action
      tapTimer = Timer(const Duration(milliseconds: 190), () {
        if (dataGridConfiguration.allowEditing && dataCell.isEditing) {
          tapTimer?.cancel();
          return;
        }
        _handleOnTapUp(
            isSecondaryTapDown: isSecondaryTapDown,
            tapDownDetails: details,
            tapUpDetails: null,
            dataGridConfiguration: dataGridConfiguration,
            dataCell: dataCell,
            kind: _kind);
        tapTimer?.cancel();
      });
    }
  }

  Widget _wrapInsideGestureDetector() {
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    // Check the DoubleTap is enabled
    // If its enable, we have to ignore the onTapUp and we need to handle both
    // tap and double tap in onTap itself to avoid the delay on double tap
    // callback
    final bool isDoubleTapEnabled = _isDoubleTapEnabled(dataGridConfiguration);
    return GestureDetector(
      onTapUp: isDoubleTapEnabled
          ? null
          : (TapUpDetails details) {
              _handleOnTapUp(
                  tapUpDetails: details,
                  tapDownDetails: null,
                  dataGridConfiguration: dataGridConfiguration,
                  dataCell: dataCell,
                  kind: _kind);
            },
      onTapDown: (TapDownDetails details) => _handleOnTapDown(details, false),
      onTap: isDoubleTapEnabled
          ? () {
              if (tapTimer != null && !tapTimer!.isActive) {
                _handleOnDoubleTap(
                    dataCell: dataCell,
                    dataGridConfiguration: dataGridConfiguration);
              }
            }
          : null,
      onTapCancel: () {
        if (tapTimer != null && tapTimer!.isActive) {
          tapTimer?.cancel();
        }
      },
      onSecondaryTapUp: (TapUpDetails details) {
        _handleOnSecondaryTapUp(
            tapUpDetails: details,
            dataGridConfiguration: dataGridConfiguration,
            dataCell: dataCell,
            kind: _kind);
      },
      onSecondaryTapDown: (TapDownDetails details) =>
          _handleOnTapDown(details, true),
      child: _wrapInsideContainer(),
    );
  }

  Widget _wrapInsideContainer() => Container(
      key: widget.key,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          border: _getCellBorder(dataGridStateDetails(), widget.dataCell)),
      alignment: Alignment.center,
      child: _wrapInsideCellContainer(
        dataGridConfiguration: dataGridStateDetails(),
        child: widget.child,
        dataCell: widget.dataCell,
        key: widget.key!,
        backgroundColor: widget.backgroundColor,
      ));

  @override
  Widget build(BuildContext context) {
    return GridCellRenderObjectWidget(
      key: widget.key,
      dataCell: widget.dataCell,
      isDirty: widget.isDirty,
      dataGridStateDetails: dataGridStateDetails,
      child: _wrapInsideGestureDetector(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (tapTimer != null) {
      tapTimer = null;
    }
  }
}

/// A widget which displays in the header cells.
class GridHeaderCell extends StatefulWidget {
  /// Creates the [GridHeaderCell] for [SfDataGrid] widget.
  const GridHeaderCell(
      {required Key key,
      required this.dataCell,
      required this.backgroundColor,
      required this.isDirty,
      required this.child,
      required this.dataGridStateDetails})
      : super(key: key);

  /// Holds the information required to display the cell.
  final DataCellBase dataCell;

  /// The [child] contained by the [GridCell].
  final Widget child;

  /// The color to paint behind the [child].
  final Color backgroundColor;

  /// Decides whether the [GridCell] should be refreshed when [SfDataGrid] is
  /// rebuild.
  final bool isDirty;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  State<StatefulWidget> createState() => _GridHeaderCellState();
}

class _GridHeaderCellState extends State<GridHeaderCell> {
  DataGridSortDirection? _sortDirection;
  Color _sortIconColor = Colors.transparent;
  int _sortNumber = -1;
  Color _sortNumberBackgroundColor = Colors.transparent;
  Color _sortNumberTextColor = Colors.transparent;
  late PointerDeviceKind _kind;
  late Widget? _sortIcon;

  DataGridStateDetails get dataGridStateDetails => widget.dataGridStateDetails;

  void _handleOnTapUp(TapUpDetails tapUpDetails) {
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    // Clear editing when tap on the header cell
    _clearEditing(dataGridConfiguration);
    if (dataGridConfiguration.onCellTap != null) {
      final DataGridCellTapDetails details = DataGridCellTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!,
          globalPosition: tapUpDetails.globalPosition,
          localPosition: tapUpDetails.localPosition,
          kind: _kind);
      dataGridConfiguration.onCellTap!(details);
    }

    dataGridConfiguration.dataGridFocusNode?.requestFocus();
    if (dataGridConfiguration.sortingGestureType == SortingGestureType.tap) {
      _sort(dataCell);
    }
  }

  void _handleOnDoubleTap() {
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    // Clear editing when tap on the header cell
    _clearEditing(dataGridConfiguration);
    if (dataGridConfiguration.onCellDoubleTap != null) {
      final DataGridCellDoubleTapDetails details = DataGridCellDoubleTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!);
      dataGridConfiguration.onCellDoubleTap!(details);
    }

    dataGridConfiguration.dataGridFocusNode?.requestFocus();
    if (dataGridConfiguration.sortingGestureType ==
        SortingGestureType.doubleTap) {
      _sort(dataCell);
    }
  }

  void _handleOnSecondaryTapUp(TapUpDetails tapUpDetails) {
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    // Clear editing when tap on the header cell
    _clearEditing(dataGridConfiguration);
    if (dataGridConfiguration.onCellSecondaryTap != null) {
      final DataGridCellTapDetails details = DataGridCellTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!,
          globalPosition: tapUpDetails.globalPosition,
          localPosition: tapUpDetails.localPosition,
          kind: _kind);
      dataGridConfiguration.onCellSecondaryTap!(details);
    }
  }

  void _handleOnTapDown(TapDownDetails details) {
    _kind = details.kind!;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    // Clear editing when tap on the header cell
    _clearEditing(dataGridConfiguration);
  }

  /// Helps to clear the editing cell when tap on header cells
  void _clearEditing(DataGridConfiguration dataGridConfiguration) {
    if (dataGridConfiguration.currentCell.isEditing) {
      dataGridConfiguration.currentCell.onCellSubmit(dataGridConfiguration);
    }
  }

  Widget _wrapInsideGestureDetector() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    return GestureDetector(
      onTapUp: dataGridConfiguration.onCellTap != null ||
              dataGridConfiguration.sortingGestureType == SortingGestureType.tap
          ? _handleOnTapUp
          : null,
      onTapDown: _handleOnTapDown,
      onDoubleTap: dataGridConfiguration.onCellDoubleTap != null ||
              dataGridConfiguration.sortingGestureType ==
                  SortingGestureType.doubleTap
          ? _handleOnDoubleTap
          : null,
      onSecondaryTapUp: dataGridConfiguration.onCellSecondaryTap != null
          ? _handleOnSecondaryTapUp
          : null,
      onSecondaryTapDown: _handleOnTapDown,
      child: _wrapInsideContainer(),
    );
  }

  Widget _wrapInsideContainer() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    final GridColumn? column = widget.dataCell.gridColumn;

    Widget checkHeaderCellConstraints(Widget child) {
      final double iconWidth =
          getSortIconWidth(dataGridConfiguration.columnSizer, column!);
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (_sortDirection == null || constraints.maxWidth < iconWidth) {
          return child;
        } else {
          return _getCellWithSortIcon(child);
        }
      });
    }

    _ensureSortIconVisiblity(column!, dataGridConfiguration);

    return Container(
        key: widget.key,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: _getCellBorder(dataGridConfiguration, widget.dataCell)),
        child: _wrapInsideCellContainer(
          dataGridConfiguration: dataGridConfiguration,
          child: checkHeaderCellConstraints(widget.child),
          dataCell: widget.dataCell,
          key: widget.key!,
          backgroundColor: widget.backgroundColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GridCellRenderObjectWidget(
      key: widget.key,
      dataCell: widget.dataCell,
      isDirty: widget.isDirty,
      dataGridStateDetails: dataGridStateDetails,
      child: _wrapInsideGestureDetector(),
    );
  }

  void _ensureSortIconVisiblity(
      GridColumn column, DataGridConfiguration? dataGridConfiguration) {
    if (dataGridConfiguration != null) {
      final SortColumnDetails? sortColumn = dataGridConfiguration
          .source.sortedColumns
          .firstWhereOrNull((SortColumnDetails sortColumn) =>
              sortColumn.name == column.columnName);
      if (dataGridConfiguration.source.sortedColumns.isNotEmpty &&
          sortColumn != null) {
        final int sortNumber =
            dataGridConfiguration.source.sortedColumns.indexOf(sortColumn) + 1;
        _sortDirection = sortColumn.sortDirection;
        _sortIconColor =
            dataGridConfiguration.dataGridThemeHelper!.sortIconColor;
        _sortIcon = dataGridConfiguration.dataGridThemeHelper!.sortIcon;
        _sortNumberBackgroundColor =
            dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.12);
        _sortNumberTextColor =
            dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87);
        if (dataGridConfiguration.source.sortedColumns.length > 1 &&
            dataGridConfiguration.showSortNumbers) {
          _sortNumber = sortNumber;
        } else {
          _sortNumber = -1;
        }
      } else {
        _sortDirection = null;
        _sortNumber = -1;
      }
    }
  }

  Widget _getCellWithSortIcon(Widget child) {
    final List<Widget> children = <Widget>[];

    children.add(_SortIcon(
      sortDirection: _sortDirection!,
      sortIconColor: _sortIconColor,
      sortIcon: _sortIcon,
    ));

    if (_sortNumber != -1) {
      children.add(_getSortNumber());
    }

    return Row(children: <Widget>[
      Flexible(
        child: Container(child: child),
      ),
      Container(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: Center(child: Row(children: children)),
      )
    ]);
  }

  Widget _getSortNumber() {
    return Container(
      width: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _sortNumberBackgroundColor,
      ),
      child: Center(
        child: Text(_sortNumber.toString(),
            style: TextStyle(fontSize: 12, color: _sortNumberTextColor)),
      ),
    );
  }

  void _sort(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataCell.dataRow?.rowType == RowType.headerRow &&
        dataCell.dataRow?.rowIndex ==
            grid_helper.getHeaderIndex(dataGridConfiguration)) {
      _makeSort(dataCell);
    }
  }

  void _makeSort(DataCellBase dataCell) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    //End-edit before perform sorting
    if (dataGridConfiguration.currentCell.isEditing) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, canRefresh: false);
    }

    final GridColumn column = dataCell.gridColumn!;

    if (column.allowSorting && dataGridConfiguration.allowSorting) {
      final String sortColumnName = column.columnName;
      final bool allowMultiSort = dataGridConfiguration.isDesktop
          ? (dataGridConfiguration.isControlKeyPressed &&
              dataGridConfiguration.allowMultiColumnSorting)
          : dataGridConfiguration.allowMultiColumnSorting;
      final DataGridSource source = dataGridConfiguration.source;

      final List<SortColumnDetails> sortedColumns = source.sortedColumns;
      if (sortedColumns.isNotEmpty && allowMultiSort) {
        SortColumnDetails? sortedColumn = sortedColumns.firstWhereOrNull(
            (SortColumnDetails sortColumn) =>
                sortColumn.name == sortColumnName);
        if (sortedColumn == null) {
          final SortColumnDetails newSortColumn = SortColumnDetails(
              name: sortColumnName,
              sortDirection: DataGridSortDirection.ascending);
          sortedColumns.add(newSortColumn);
        } else {
          if (sortedColumn.sortDirection == DataGridSortDirection.descending &&
              dataGridConfiguration.allowTriStateSorting) {
            final SortColumnDetails? removedSortColumn =
                sortedColumns.firstWhereOrNull((SortColumnDetails sortColumn) =>
                    sortColumn.name == sortColumnName);
            sortedColumns.remove(removedSortColumn);
          } else {
            sortedColumn = SortColumnDetails(
                name: sortedColumn.name,
                sortDirection: sortedColumn.sortDirection ==
                        DataGridSortDirection.ascending
                    ? DataGridSortDirection.descending
                    : DataGridSortDirection.ascending);
            final SortColumnDetails? removedSortColumn =
                sortedColumns.firstWhereOrNull((SortColumnDetails sortColumn) =>
                    sortColumn.name == sortedColumn!.name);
            sortedColumns
              ..remove(removedSortColumn)
              ..add(sortedColumn);
          }
        }
      } else {
        SortColumnDetails? currentSortColumn = sortedColumns.firstWhereOrNull(
            (SortColumnDetails sortColumn) =>
                sortColumn.name == sortColumnName);
        if (sortedColumns.isNotEmpty && currentSortColumn != null) {
          if (currentSortColumn.sortDirection ==
                  DataGridSortDirection.descending &&
              dataGridConfiguration.allowTriStateSorting) {
            sortedColumns.clear();
          } else {
            currentSortColumn = SortColumnDetails(
                name: currentSortColumn.name,
                sortDirection: currentSortColumn.sortDirection ==
                        DataGridSortDirection.ascending
                    ? DataGridSortDirection.descending
                    : DataGridSortDirection.ascending);
            sortedColumns
              ..clear()
              ..add(currentSortColumn);
          }
        } else {
          final SortColumnDetails sortColumn = SortColumnDetails(
              name: sortColumnName,
              sortDirection: DataGridSortDirection.ascending);
          if (sortedColumns.isNotEmpty) {
            sortedColumns
              ..clear()
              ..add(sortColumn);
          } else {
            sortedColumns.add(sortColumn);
          }
        }
      }
      // Refreshes the datagrid source and performs sorting based on
      // `DataGridSource.sortedColumns`.
      source.sort();
    }
  }
}

class _SortIcon extends StatefulWidget {
  const _SortIcon(
      {required this.sortDirection,
      required this.sortIconColor,
      required this.sortIcon});
  final DataGridSortDirection sortDirection;
  final Color sortIconColor;
  final Widget? sortIcon;
  @override
  _SortIconState createState() => _SortIconState();
}

class _SortIconState extends State<_SortIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sortingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _sortingAnimation = Tween<double>(begin: 0.0, end: pi).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    if (widget.sortDirection == DataGridSortDirection.descending) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_SortIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortDirection == DataGridSortDirection.ascending &&
        widget.sortDirection == DataGridSortDirection.descending) {
      _animationController.forward();
    } else if (oldWidget.sortDirection == DataGridSortDirection.descending &&
        widget.sortDirection == DataGridSortDirection.ascending) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
              angle: _sortingAnimation.value,
              child: widget.sortIcon ??
                  Icon(Icons.arrow_upward,
                      color: widget.sortIconColor, size: 16));
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

BorderDirectional _getCellBorder(
    DataGridConfiguration dataGridConfiguration, DataCellBase dataCell) {
  final Color borderColor =
      dataGridConfiguration.dataGridThemeHelper!.gridLineColor;
  final double borderWidth =
      dataGridConfiguration.dataGridThemeHelper!.gridLineStrokeWidth;

  final int rowIndex = (dataCell.rowSpan > 0)
      ? dataCell.rowIndex - dataCell.rowSpan
      : dataCell.rowIndex;
  final int columnIndex = dataCell.columnIndex;
  final bool isStackedHeaderCell =
      dataCell.cellType == CellType.stackedHeaderCell;
  final bool isHeaderCell = dataCell.cellType == CellType.headerCell;
  final bool isTableSummaryCell =
      dataCell.cellType == CellType.tableSummaryCell;

  // To skip bottom border for the top data row of the starting row of bottom table
  // summary rows and draw top border for the bottom summary start row instead.
  final bool canSkipBottomBorder = grid_helper.getTableSummaryCount(
              dataGridConfiguration, GridTableSummaryRowPosition.bottom) >
          0 &&
      dataCell.rowIndex ==
          grid_helper.getStartBottomSummaryRowIndex(dataGridConfiguration) - 1;

  // To draw the top border for the starting row of the bottom table summary row.
  final bool canDrawStartBottomSummaryRowTopBorder = isTableSummaryCell &&
      dataCell.rowIndex ==
          grid_helper.getStartBottomSummaryRowIndex(dataGridConfiguration);

  final bool canDrawHeaderHorizontalBorder =
      (dataGridConfiguration.headerGridLinesVisibility ==
                  GridLinesVisibility.horizontal ||
              dataGridConfiguration.headerGridLinesVisibility ==
                  GridLinesVisibility.both) &&
          (isHeaderCell || isStackedHeaderCell);

  final bool canDrawHeaderVerticalBorder =
      (dataGridConfiguration.headerGridLinesVisibility ==
                  GridLinesVisibility.vertical ||
              dataGridConfiguration.headerGridLinesVisibility ==
                  GridLinesVisibility.both) &&
          (isHeaderCell || isStackedHeaderCell);

  final bool canDrawHorizontalBorder =
      (dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.horizontal ||
              dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.both) &&
          !isHeaderCell &&
          !isStackedHeaderCell;

  final bool canDrawVerticalBorder =
      (dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.vertical ||
              dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.both) &&
          !isStackedHeaderCell &&
          !isTableSummaryCell &&
          !isHeaderCell;

  // Frozen column and row checking
  final bool canDrawBottomFrozenBorder =
      dataGridConfiguration.frozenRowsCount.isFinite &&
          dataGridConfiguration.frozenRowsCount > 0 &&
          grid_helper.getLastFrozenRowIndex(dataGridConfiguration) == rowIndex;

  final bool canDrawTopFrozenBorder =
      dataGridConfiguration.footerFrozenRowsCount.isFinite &&
          dataGridConfiguration.footerFrozenRowsCount > 0 &&
          grid_helper.getStartFooterFrozenRowIndex(dataGridConfiguration) ==
              rowIndex;

  final bool canDrawRightFrozenBorder =
      dataGridConfiguration.frozenColumnsCount.isFinite &&
          dataGridConfiguration.frozenColumnsCount > 0 &&
          grid_helper.getLastFrozenColumnIndex(dataGridConfiguration) ==
              columnIndex;

  final bool canDrawLeftFrozenBorder =
      dataGridConfiguration.footerFrozenColumnsCount.isFinite &&
          dataGridConfiguration.footerFrozenColumnsCount > 0 &&
          grid_helper.getStartFooterFrozenColumnIndex(dataGridConfiguration) ==
              columnIndex;

  final bool isFrozenPaneElevationApplied =
      dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation > 0.0;

  final Color frozenPaneLineColor =
      dataGridConfiguration.dataGridThemeHelper!.frozenPaneLineColor;

  final double frozenPaneLineWidth =
      dataGridConfiguration.dataGridThemeHelper!.frozenPaneLineWidth;

  BorderSide _getLeftBorder() {
    if ((columnIndex == 0 &&
            (canDrawVerticalBorder || canDrawHeaderVerticalBorder)) ||
        canDrawLeftFrozenBorder) {
      if (canDrawLeftFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (columnIndex > 0 &&
          ((canDrawVerticalBorder || canDrawHeaderVerticalBorder) &&
              !canDrawLeftFrozenBorder)) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getTopBorder() {
    if ((rowIndex == 0 &&
            (canDrawHorizontalBorder || canDrawHeaderHorizontalBorder)) ||
        canDrawTopFrozenBorder ||
        canDrawStartBottomSummaryRowTopBorder) {
      if (canDrawTopFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (canDrawHorizontalBorder &&
          canDrawStartBottomSummaryRowTopBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getRightBorder() {
    if (canDrawVerticalBorder ||
        canDrawHeaderVerticalBorder ||
        canDrawRightFrozenBorder) {
      if (canDrawRightFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if ((canDrawVerticalBorder || canDrawHeaderVerticalBorder) &&
          !canDrawRightFrozenBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide _getBottomBorder() {
    if (canDrawHorizontalBorder ||
        canDrawHeaderHorizontalBorder ||
        canDrawBottomFrozenBorder) {
      if (canDrawBottomFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (!canDrawBottomFrozenBorder && !canSkipBottomBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  return BorderDirectional(
    start: _getLeftBorder(),
    top: _getTopBorder(),
    end: _getRightBorder(),
    bottom: _getBottomBorder(),
  );
}

Widget _wrapInsideCellContainer(
    {required DataGridConfiguration dataGridConfiguration,
    required DataCellBase dataCell,
    required Key key,
    required Color backgroundColor,
    required Widget child}) {
  final Color color =
      dataGridConfiguration.dataGridThemeHelper!.currentCellStyle.borderColor;
  final double borderWidth =
      dataGridConfiguration.dataGridThemeHelper!.currentCellStyle.borderWidth;

  Border getBorder() {
    final bool isCurrentCell = dataCell.isCurrentCell;
    return Border(
      bottom: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      left: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      top: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
      right: isCurrentCell
          ? BorderSide(color: color, width: borderWidth)
          : BorderSide.none,
    );
  }

  double getCellHeight(DataCellBase dataCell, double defaultHeight) {
    // Restricts the height calculation to the invisible data cell.
    if (!dataCell.isVisible) {
      return 0.0;
    }

    double height;
    if (dataCell.rowSpan > 0) {
      height = dataCell.dataRow!.getRowHeight(
          dataCell.rowIndex - dataCell.rowSpan, dataCell.rowIndex);
    } else {
      height = defaultHeight;
    }
    return height;
  }

  double getCellWidth(DataCellBase dataCell, double defaultWidth) {
    // Restricts the width calculation to the invisible data cell.
    if (!dataCell.isVisible) {
      return 0.0;
    }

    double width;
    if (dataCell.columnSpan > 0) {
      width = dataCell.dataRow!.getColumnWidth(
          dataCell.columnIndex, dataCell.columnIndex + dataCell.columnSpan);
    } else {
      width = defaultWidth;
    }
    return width;
  }

  Widget getChild(BoxConstraints constraint) {
    final double width = getCellWidth(dataCell, constraint.maxWidth);
    final double height = getCellHeight(dataCell, constraint.maxHeight);

    if (dataCell.isCurrentCell) {
      return Stack(
        children: <Widget>[
          Container(
              width: width,
              height: height,
              color: backgroundColor,
              child: child),
          Positioned(
              left: 0,
              top: 0,
              width: width,
              height: height,
              child: IgnorePointer(
                child: Container(
                    key: key,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(border: getBorder())),
              )),
        ],
      );
    } else {
      return Container(
          width: width, height: height, color: backgroundColor, child: child);
    }
  }

  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
    return getChild(constraint);
  });
}

// Gesture Events

void _handleOnTapUp(
    {required TapUpDetails? tapUpDetails,
    required TapDownDetails? tapDownDetails,
    required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration,
    required PointerDeviceKind kind,
    bool isSecondaryTapDown = false}) {
  // End edit the current editing cell if its editing mode is differed
  if (dataGridConfiguration.currentCell.isEditing) {
    if (dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, cancelCanSubmitCell: true);
    } else {
      return;
    }
  }

  if (!isSecondaryTapDown && dataGridConfiguration.onCellTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!,
        globalPosition: tapDownDetails != null
            ? tapDownDetails.globalPosition
            : tapUpDetails!.globalPosition,
        localPosition: tapDownDetails != null
            ? tapDownDetails.localPosition
            : tapUpDetails!.localPosition,
        kind: kind);
    dataGridConfiguration.onCellTap!(details);
  }

  dataGridConfiguration.dataGridFocusNode?.requestFocus();
  dataCell.onTouchUp();

  // Init the editing based on the editing mode
  if (dataGridConfiguration.editingGestureType == EditingGestureType.tap) {
    dataGridConfiguration.currentCell
        .onCellBeginEdit(editingDataCell: dataCell);
  }
}

void _handleOnDoubleTap(
    {required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration}) {
  // End edit the current editing cell if its editing mode is differed
  if (dataGridConfiguration.currentCell.isEditing) {
    if (dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, cancelCanSubmitCell: true);
    } else {
      return;
    }
  }

  if (dataGridConfiguration.onCellDoubleTap != null) {
    final DataGridCellDoubleTapDetails details = DataGridCellDoubleTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!);
    dataGridConfiguration.onCellDoubleTap!(details);
  }

  dataGridConfiguration.dataGridFocusNode?.requestFocus();
  dataCell.onTouchUp();

  // Init the editing based on the editing mode
  if (dataGridConfiguration.editingGestureType ==
      EditingGestureType.doubleTap) {
    dataGridConfiguration.currentCell
        .onCellBeginEdit(editingDataCell: dataCell);
  }
}

void _handleOnSecondaryTapUp(
    {required TapUpDetails tapUpDetails,
    required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration,
    required PointerDeviceKind kind}) {
  // Need to end the editing cell when interacting with other tap gesture
  if (dataGridConfiguration.currentCell.isEditing) {
    if (dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, cancelCanSubmitCell: true);
    } else {
      return;
    }
  }

  if (dataGridConfiguration.onCellSecondaryTap != null) {
    final DataGridCellTapDetails details = DataGridCellTapDetails(
        rowColumnIndex: RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
        column: dataCell.gridColumn!,
        globalPosition: tapUpDetails.globalPosition,
        localPosition: tapUpDetails.localPosition,
        kind: kind);
    dataGridConfiguration.onCellSecondaryTap!(details);
  }
}
