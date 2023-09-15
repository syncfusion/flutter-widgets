import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

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

  Future<void> _handleOnTapDown(
      TapDownDetails details, bool isSecondaryTapDown) async {
    _kind = details.kind!;
    final DataCellBase dataCell = widget.dataCell;
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    // Clear editing when tap on the stacked header cell.
    if (widget.dataCell.cellType == CellType.stackedHeaderCell &&
        dataGridConfiguration.currentCell.isEditing) {
      await dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration);
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

  @override
  GridHeaderCellElement createElement() {
    return GridHeaderCellElement(this, dataCell.gridColumn!);
  }
}

/// An instantiation of a [GridHeaderCell] widget at a particular location in the tree.
class GridHeaderCellElement extends StatefulElement {
  /// Creates the [GridHeaderCellElement] for [GridHeaderCell] widget.
  GridHeaderCellElement(GridHeaderCell gridHeaderCell, this.column)
      : super(gridHeaderCell);

  /// A GridColumn which displays in the header cells.
  final GridColumn column;
}

class _GridHeaderCellState extends State<GridHeaderCell> {
  DataGridSortDirection? _sortDirection;
  Color _sortIconColor = Colors.transparent;
  int _sortNumber = -1;
  Color _sortNumberBackgroundColor = Colors.transparent;
  Color _sortNumberTextColor = Colors.transparent;
  late PointerDeviceKind _kind;
  late Widget? _sortIcon;
  bool isHovered = false;

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
  Future<void> _clearEditing(
      DataGridConfiguration dataGridConfiguration) async {
    if (dataGridConfiguration.currentCell.isEditing) {
      await dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration);
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
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return _buildHeaderCell(child, _sortDirection, constraints.maxWidth);
      });
    }

    _ensureSortIconVisibility(column!, dataGridConfiguration);

    Widget child = _wrapInsideCellContainer(
        dataGridConfiguration: dataGridConfiguration,
        child: checkHeaderCellConstraints(widget.child),
        dataCell: widget.dataCell,
        key: widget.key!,
        backgroundColor: widget.backgroundColor);

    Widget getFeedbackWidget(DataGridConfiguration configuration) {
      return dataGridConfiguration.columnDragFeedbackBuilder != null
          ? dataGridConfiguration.columnDragFeedbackBuilder!(
              context, widget.dataCell.gridColumn!)
          : Container(
              width: widget.dataCell.gridColumn!.actualWidth,
              height: dataGridConfiguration.headerRowHeight,
              decoration: BoxDecoration(
                  color: dataGridConfiguration.colorScheme!.brightness ==
                          Brightness.light
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF303030),
                  border: Border.all(
                      color: dataGridConfiguration
                          .dataGridThemeHelper!.gridLineColor,
                      width: dataGridConfiguration
                          .dataGridThemeHelper!.gridLineStrokeWidth)),
              child: widget.child);
    }

    Widget buildDraggableHeaderCell(Widget child) {
      final DataGridConfiguration configuration = dataGridStateDetails();
      final bool isWindowsPlatform =
          configuration.columnDragAndDropController.isWindowsPlatform!;
      return Draggable<Widget>(
        onDragStarted: () {
          configuration.columnDragAndDropController
              .onPointerDown(widget.dataCell);
        },
        ignoringFeedbackPointer: isWindowsPlatform,
        feedback: MouseRegion(
            cursor: isWindowsPlatform
                ? MouseCursor.defer
                : (dataGridConfiguration.isMacPlatform && !kIsWeb)
                    ? SystemMouseCursors.grabbing
                    : SystemMouseCursors.move,
            child: getFeedbackWidget(configuration)),
        child: child,
      );
    }

    if (dataGridConfiguration.columnDragAndDropController
            .canAllowColumnDragAndDrop() &&
        dataGridConfiguration
            .columnDragAndDropController.canWrapDraggableView &&
        !dataGridConfiguration
            .columnResizeController.canSwitchResizeColumnCursor) {
      child = buildDraggableHeaderCell(child);
    }

    return Container(
        key: widget.key,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            border: _getCellBorder(
          dataGridConfiguration,
          widget.dataCell,
        )),
        child: child);
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

  void _ensureSortIconVisibility(
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
        _sortNumberBackgroundColor = dataGridConfiguration
                .dataGridThemeHelper!.sortOrderNumberBackgroundColor ??
            dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.12);
        _sortNumberTextColor =
            dataGridConfiguration.dataGridThemeHelper!.sortOrderNumberColor ??
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

  Widget _buildHeaderCell(Widget child, DataGridSortDirection? sortDirection,
      double availableWidth) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    final GridColumn gridColumn = widget.dataCell.gridColumn!;
    final bool isSortedColumn = dataGridConfiguration.source.sortedColumns.any(
        (SortColumnDetails element) => element.name == gridColumn.columnName);
    final bool isSortNumberVisible = _sortNumber != 1;

    if ((isSortedColumn ||
            (gridColumn.allowSorting && dataGridConfiguration.allowSorting)) ||
        (gridColumn.allowFiltering && dataGridConfiguration.allowFiltering)) {
      final double sortIconWidth =
          getSortIconWidth(dataGridConfiguration.columnSizer, gridColumn);
      final double filterIconWidth =
          getFilterIconWidth(dataGridConfiguration.columnSizer, gridColumn);

      if ((sortIconWidth > 0 && sortIconWidth < availableWidth) ||
          (filterIconWidth > 0 && filterIconWidth < availableWidth)) {
        final Map<String, Widget> children = <String, Widget>{};

        if (sortIconWidth > 0 &&
            availableWidth > sortIconWidth + filterIconWidth) {
          _sortIconColor =
              dataGridConfiguration.dataGridThemeHelper!.sortIconColor;
          _sortIcon = dataGridConfiguration.dataGridThemeHelper!.sortIcon;

          if (_sortDirection != null) {
            if (_sortIcon == null || _sortIcon is Icon) {
              children['sortIcon'] = _SortIcon(
                sortDirection: _sortDirection!,
                sortIconColor: _sortIconColor,
                sortIcon: _sortIcon,
              );
            } else {
              if (sortDirection == DataGridSortDirection.ascending) {
                children['sortIcon'] =
                    _BuilderSortIconAscending(sortIcon: _sortIcon);
              } else if (sortDirection == DataGridSortDirection.descending) {
                children['sortIcon'] =
                    _BuilderSortIconDescending(sortIcon: _sortIcon);
              }
            }
            if (_sortNumber != -1) {
              children['sortNumber'] = _getSortNumber();
            }
          } else if (gridColumn.allowSorting &&
              dataGridConfiguration.allowSorting) {
            const IconData unsortIconData = IconData(
              0xe700,
              fontFamily: 'UnsortIcon',
              fontPackage: 'syncfusion_flutter_datagrid',
            );

            children['sortIcon'] = _sortIcon ??
                Icon(unsortIconData, color: _sortIconColor, size: 16);
          }
        }

        if (filterIconWidth > 0 && availableWidth > filterIconWidth) {
          children['filterIcon'] = _FilterIcon(
            dataGridConfiguration: dataGridConfiguration,
            column: gridColumn,
          );
        }

        bool canShowColumnHeaderIcon() {
          final bool isFilteredColumn = dataGridConfiguration
              .source.filterConditions
              .containsKey(gridColumn.columnName);
          if (dataGridConfiguration.showColumnHeaderIconOnHover &&
              dataGridConfiguration.isDesktop) {
            return isHovered ||
                dataGridConfiguration
                    .dataGridFilterHelper!.isFilterPopupMenuShowing ||
                isFilteredColumn ||
                isSortedColumn;
          } else if (!dataGridConfiguration.showColumnHeaderIconOnHover &&
              dataGridConfiguration.showFilterIconOnHover &&
              dataGridConfiguration.isDesktop) {
            return isHovered ||
                dataGridConfiguration
                    .dataGridFilterHelper!.isFilterPopupMenuShowing;
          } else {
            return true;
          }
        }

        Widget buildHeaderCellIcons(bool isColumnHeaderIconVisible) {
          return Container(
            padding: dataGridConfiguration.columnSizer.iconsOuterPadding,
            child: Center(
              child: isColumnHeaderIconVisible
                  ? Row(
                      children: <Widget>[
                        if (children.containsKey('sortIcon'))
                          children['sortIcon']!,
                        if (children.containsKey('sortNumber'))
                          children['sortNumber']!,
                        if (children.containsKey('filterIcon'))
                          children['filterIcon']!,
                      ],
                    )
                  : (dataGridConfiguration.showFilterIconOnHover &&
                          !dataGridConfiguration.showColumnHeaderIconOnHover)
                      ? Row(
                          children: <Widget>[
                            if (children.containsKey('sortIcon'))
                              children['sortIcon']!,
                            if (children.containsKey('sortNumber'))
                              children['sortNumber']!,
                          ],
                        )
                      : const SizedBox(),
            ),
          );
        }

        late Widget headerCell;
        final bool isColumnHeaderIconVisible = canShowColumnHeaderIcon();
        if (gridColumn.sortIconPosition == ColumnHeaderIconPosition.end &&
            gridColumn.filterIconPosition == ColumnHeaderIconPosition.end) {
          headerCell = Row(
            children: <Widget>[
              Flexible(child: Container(child: child)),
              buildHeaderCellIcons(isColumnHeaderIconVisible)
            ],
          );
        } else if (gridColumn.sortIconPosition ==
                ColumnHeaderIconPosition.start &&
            gridColumn.filterIconPosition == ColumnHeaderIconPosition.start) {
          headerCell = Row(
            children: <Widget>[
              buildHeaderCellIcons(isColumnHeaderIconVisible),
              Flexible(child: child),
            ],
          );
        } else if (gridColumn.sortIconPosition ==
                ColumnHeaderIconPosition.end &&
            gridColumn.filterIconPosition == ColumnHeaderIconPosition.start) {
          headerCell = Row(
            children: <Widget>[
              if (isColumnHeaderIconVisible)
                Center(
                  child: children['filterIcon'] ?? const SizedBox(),
                ),
              Flexible(
                child: Container(child: child),
              ),
              if (isColumnHeaderIconVisible ||
                  (dataGridConfiguration.showFilterIconOnHover &&
                      !dataGridConfiguration.showColumnHeaderIconOnHover))
                Container(
                  padding: dataGridConfiguration.columnSizer.iconsOuterPadding,
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: children['sortIcon'] ?? const SizedBox(),
                      ),
                      if (isSortNumberVisible)
                        Center(child: children['sortNumber']),
                    ],
                  ),
                ),
            ],
          );
        } else {
          headerCell = Row(
            children: <Widget>[
              if (isColumnHeaderIconVisible ||
                  (dataGridConfiguration.showFilterIconOnHover &&
                      !dataGridConfiguration.showColumnHeaderIconOnHover))
                Container(
                  padding: dataGridConfiguration.columnSizer.iconsOuterPadding,
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: children['sortIcon'] ?? const SizedBox(),
                      ),
                      if (isSortNumberVisible)
                        Center(child: children['sortNumber']),
                    ],
                  ),
                ),
              Flexible(
                child: Container(child: child),
              ),
              if (isColumnHeaderIconVisible)
                Center(
                  child: children['filterIcon'] ?? const SizedBox(),
                ),
            ],
          );
        }

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: headerCell,
        );
      }
    }
    return child;
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

  Future<void> _makeSort(DataCellBase dataCell) async {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    //End-edit before perform sorting
    if (dataGridConfiguration.currentCell.isEditing) {
      await dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, canRefresh: false);
    }

    final GridColumn column = dataCell.gridColumn!;

    if (column.allowSorting && dataGridConfiguration.allowSorting) {
      final String sortColumnName = column.columnName;
      final bool allowMultiSort = dataGridConfiguration.isMacPlatform
          ? (dataGridConfiguration.isCommandKeyPressed &&
              dataGridConfiguration.allowMultiColumnSorting)
          : dataGridConfiguration.isDesktop
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

class _BuilderSortIconAscending extends StatelessWidget {
  const _BuilderSortIconAscending({required this.sortIcon});

  final Widget? sortIcon;

  @override
  Widget build(BuildContext context) {
    return sortIcon!;
  }
}

class _BuilderSortIconDescending extends StatelessWidget {
  const _BuilderSortIconDescending({required this.sortIcon});

  final Widget? sortIcon;

  @override
  Widget build(BuildContext context) {
    return sortIcon!;
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

class _FilterIcon extends StatelessWidget {
  const _FilterIcon(
      {Key? key, required this.column, required this.dataGridConfiguration})
      : super(key: key);

  final GridColumn column;
  final DataGridConfiguration dataGridConfiguration;

  void onHandleTap(TapUpDetails details, BuildContext context) {
    if (dataGridConfiguration.isDesktop) {
      // The `showMenu` displays the popup view relative to the topmost of the
      // material app. If using more than one material app in the parent of the
      // data grid, it will be laid out based on the top most material apps'
      // global position. So, it will be displayed in the wrong position. Since
      // the overlay is the parent of every material app widget, we resolved
      // the issue by converting the global to local position of the current
      // overlay and used that new offset to display the show menu.
      final RenderBox renderBox =
          Overlay.of(context).context.findRenderObject()! as RenderBox;
      final Offset newOffset = renderBox.globalToLocal(details.globalPosition);
      final Size viewSize = renderBox.size;
      showMenu(
          context: context,
          color:
              dataGridConfiguration.colorScheme!.brightness == Brightness.light
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF303030),
          constraints: const BoxConstraints(maxWidth: 274.0),
          position: RelativeRect.fromSize(newOffset & Size.zero, viewSize),
          items: <PopupMenuEntry<String>>[
            _FilterPopupMenuItem<String>(
                column: column, dataGridConfiguration: dataGridConfiguration),
          ]).then((_) {
        if (dataGridConfiguration.isDesktop) {
          notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
              propertyName: 'Filtering');
          dataGridConfiguration.dataGridFilterHelper!.isFilterPopupMenuShowing =
              false;
        }
      });
    } else {
      Navigator.push<_FilterPopup>(
          context,
          MaterialPageRoute<_FilterPopup>(
              builder: (BuildContext context) => _FilterPopup(
                  column: column,
                  dataGridConfiguration: dataGridConfiguration)));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isHovered = false;
    final bool isFiltered = dataGridConfiguration.source.filterConditions
        .containsKey(column.columnName);

    return GestureDetector(
      onTapUp: (TapUpDetails details) => onHandleTap(details, context),
      child: Padding(
        padding: column.filterIconPadding,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: isFiltered
                ? _FilteredIcon(
                    iconColor: isHovered
                        ? (dataGridConfiguration
                                .dataGridThemeHelper!.filterIconHoverColor ??
                            dataGridConfiguration.colorScheme!.onSurface
                                .withOpacity(0.87))
                        : (dataGridConfiguration
                                .dataGridThemeHelper!.filterIconColor ??
                            dataGridConfiguration
                                .dataGridFilterHelper!.iconColor),
                    filterIcon:
                        dataGridConfiguration.dataGridThemeHelper!.filterIcon,
                    gridColumnName: column.columnName,
                  )
                : _UnfilteredIcon(
                    iconColor: isHovered
                        ? (dataGridConfiguration
                                .dataGridThemeHelper!.filterIconHoverColor ??
                            dataGridConfiguration.colorScheme!.onSurface
                                .withOpacity(0.87))
                        : (dataGridConfiguration
                                .dataGridThemeHelper!.filterIconColor ??
                            dataGridConfiguration
                                .dataGridFilterHelper!.iconColor),
                    filterIcon:
                        dataGridConfiguration.dataGridThemeHelper!.filterIcon,
                    gridColumnName: column.columnName,
                  ),
          );
        }),
      ),
    );
  }
}

class _UnfilteredIcon extends StatelessWidget {
  const _UnfilteredIcon(
      {Key? key,
      required this.iconColor,
      required this.filterIcon,
      required this.gridColumnName})
      : super(key: key);

  final Color iconColor;
  final Widget? filterIcon;
  final String? gridColumnName;

  @override
  Widget build(BuildContext context) {
    return filterIcon ??
        Icon(
          const IconData(0xe702,
              fontFamily: 'FilterIcon',
              fontPackage: 'syncfusion_flutter_datagrid'),
          size: 18.0,
          color: iconColor,
          key: ValueKey<String>(
              'datagrid_filtering_${gridColumnName}_filterIcon'),
        );
  }
}

class _FilteredIcon extends StatelessWidget {
  const _FilteredIcon(
      {Key? key,
      required this.iconColor,
      required this.filterIcon,
      required this.gridColumnName})
      : super(key: key);

  final Color iconColor;
  final Widget? filterIcon;
  final String? gridColumnName;

  @override
  Widget build(BuildContext context) {
    return filterIcon ??
        Icon(
          const IconData(0xe704,
              fontFamily: 'FilterIcon',
              fontPackage: 'syncfusion_flutter_datagrid'),
          size: 18.0,
          color: iconColor,
          key: ValueKey<String>(
              'datagrid_filtering_${gridColumnName}_filterIcon'),
        );
  }
}

class _FilterPopupMenuItem<T> extends PopupMenuItem<T> {
  const _FilterPopupMenuItem(
      {required this.column, required this.dataGridConfiguration})
      : super(child: null);

  final GridColumn column;

  final DataGridConfiguration dataGridConfiguration;
  @override
  _FilterPopupMenuItemState<T> createState() => _FilterPopupMenuItemState<T>();
}

class _FilterPopupMenuItemState<T>
    extends PopupMenuItemState<T, _FilterPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return _FilterPopup(
        column: widget.column,
        dataGridConfiguration: widget.dataGridConfiguration);
  }
}

class _FilterPopup extends StatefulWidget {
  const _FilterPopup(
      {Key? key, required this.column, required this.dataGridConfiguration})
      : super(key: key);

  final GridColumn column;

  final DataGridConfiguration dataGridConfiguration;

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<_FilterPopup> {
  late bool isMobile;

  late bool isAdvancedFilter;

  late DataGridFilterHelper filterHelper;
  @override
  void initState() {
    super.initState();
    _initializeFilterProperties();
    filterHelper.isFilterPopupMenuShowing = true;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isMobile,
      replacement: Material(
        child: _buildPopupView(),
      ),
      child: SafeArea(
        child: Theme(
          data:
              ThemeData(colorScheme: widget.dataGridConfiguration.colorScheme),
          child: Scaffold(
            appBar: buildAppBar(context),
            resizeToAvoidBottomInset: true,
            body: _buildPopupView(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    filterHelper.isFilterPopupMenuShowing = false;
    super.dispose();
  }

  @override
  void deactivate() {
    filterHelper.isFilterPopupMenuShowing = false;
    super.deactivate();
  }

  void _initializeFilterProperties() {
    isMobile = !widget.dataGridConfiguration.isDesktop;
    filterHelper = widget.dataGridConfiguration.dataGridFilterHelper!;
    filterHelper.filterFrom = filterHelper.getFilterForm(widget.column);
    isAdvancedFilter = filterHelper.filterFrom == FilteredFrom.advancedFilter;
    filterHelper.checkboxFilterHelper.textController.clear();

    // Need to end edit the current cell to commit the cell value before showing
    // the filtering popup menu.
    filterHelper.endEdit();

    final DataGridAdvancedFilterHelper advancedFilterHelper =
        filterHelper.advancedFilterHelper;
    final List<FilterCondition>? filterConditions = widget.dataGridConfiguration
        .source.filterConditions[widget.column.columnName];

    if (filterConditions == null) {
      filterHelper.setFilterFrom(widget.column, FilteredFrom.none);
    }

    /// Initializes the data grid source for filtering.
    filterHelper.setDataGridSource(widget.column);

    // Need to initialize the filter values before set the values.
    advancedFilterHelper
      ..setAdvancedFilterType(widget.dataGridConfiguration, widget.column)
      ..generateFilterTypeItems(widget.column);

    /// Initializes the advanced filter properties.
    if (filterConditions != null && isAdvancedFilter) {
      advancedFilterHelper.setAdvancedFilterValues(
          widget.dataGridConfiguration, filterConditions, filterHelper);
    } else {
      advancedFilterHelper
          .resetAdvancedFilterValues(widget.dataGridConfiguration);
    }
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(52.0),
      child: AppBar(
        elevation: 0.0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(height: 1.0, color: filterHelper.borderColor)),
        backgroundColor: filterHelper.backgroundColor,
        leading: IconButton(
            key: const ValueKey<String>('datagrid_filtering_cancelFilter_icon'),
            onPressed: closePage,
            icon: Icon(Icons.close, size: 22.0, color: filterHelper.iconColor)),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
            widget.dataGridConfiguration.localizations
                .sortAndFilterDataGridFilteringLabel,
            style: filterHelper.textStyle),
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('datagrid_filtering_applyFilter_icon'),
            onPressed: canDisableOkButton() ? null : onHandleOkButtonTap,
            icon: Icon(Icons.check,
                size: 22.0,
                color: canDisableOkButton()
                    ? widget.dataGridConfiguration.colorScheme!.onSurface
                        .withOpacity(0.38)
                    : filterHelper.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupView() {
    final Color iconColor = filterHelper.iconColor;
    final AdvancedFilterType filterType =
        filterHelper.advancedFilterHelper.advancedFilterType;
    final SfLocalizations localizations =
        widget.dataGridConfiguration.localizations;
    final bool isSortAscendingEnabled =
        canEnableSortButton(DataGridSortDirection.ascending);
    final bool isSortDescendingEnabled =
        canEnableSortButton(DataGridSortDirection.descending);
    final bool isClearFilterEnabled = hasFilterConditions();
    const FilterPopupMenuOptions filterPopupMenuOptions =
        FilterPopupMenuOptions();
    bool isCheckboxFilterEnabled =
        filterPopupMenuOptions.filterMode == FilterMode.checkboxFilter;
    bool isAdvancedFilterEnabled =
        filterPopupMenuOptions.filterMode == FilterMode.advancedFilter;
    bool isBothFilterEnabled =
        filterPopupMenuOptions.filterMode == FilterMode.both;
    bool canShowSortingOptions = filterPopupMenuOptions.canShowSortingOptions;
    bool canShowClearFilterOption =
        filterPopupMenuOptions.canShowClearFilterOption;
    bool showColumnName = filterPopupMenuOptions.showColumnName;
    double advanceFilterTopPadding = 12;

    if (widget.column.filterPopupMenuOptions != null) {
      isCheckboxFilterEnabled =
          widget.column.filterPopupMenuOptions!.filterMode ==
              FilterMode.checkboxFilter;
      isAdvancedFilterEnabled =
          widget.column.filterPopupMenuOptions!.filterMode ==
              FilterMode.advancedFilter;
      isBothFilterEnabled =
          widget.column.filterPopupMenuOptions!.filterMode == FilterMode.both;
      canShowSortingOptions =
          widget.column.filterPopupMenuOptions!.canShowSortingOptions;
      canShowClearFilterOption =
          widget.column.filterPopupMenuOptions!.canShowClearFilterOption;
      showColumnName = widget.column.filterPopupMenuOptions!.showColumnName;
    }
    Widget buildPopup({Size? viewSize}) {
      return SingleChildScrollView(
        key: const ValueKey<String>('datagrid_filtering_scrollView'),
        child: Container(
          width: isMobile ? null : 274.0,
          color: filterHelper.backgroundColor,
          child: Column(
            children: <Widget>[
              if (canShowSortingOptions)
                _FilterPopupMenuTile(
                    style: isSortAscendingEnabled
                        ? filterHelper.textStyle
                        : filterHelper.disableTextStyle,
                    height: filterHelper.tileHeight,
                    prefix: Icon(
                      const IconData(0xe700,
                          fontFamily: 'FilterIcon',
                          fontPackage: 'syncfusion_flutter_datagrid'),
                      color: isSortAscendingEnabled
                          ? iconColor
                          : filterHelper.disableIconColor,
                      size: filterHelper.textStyle.fontSize! + 10,
                    ),
                    prefixPadding: EdgeInsets.only(
                        left: 4.0,
                        right: filterHelper.textStyle.fontSize!,
                        bottom: filterHelper.textStyle.fontSize! > 14
                            ? filterHelper.textStyle.fontSize! - 14
                            : 0),
                    onTap: isSortAscendingEnabled
                        ? onHandleSortAscendingTap
                        : null,
                    child: Text(
                        grid_helper.getSortButtonText(
                            localizations, true, filterType),
                        overflow: TextOverflow.ellipsis)),
              if (canShowSortingOptions)
                _FilterPopupMenuTile(
                  style: isSortDescendingEnabled
                      ? filterHelper.textStyle
                      : filterHelper.disableTextStyle,
                  height: filterHelper.tileHeight,
                  prefix: Icon(
                    const IconData(0xe701,
                        fontFamily: 'FilterIcon',
                        fontPackage: 'syncfusion_flutter_datagrid'),
                    color: isSortDescendingEnabled
                        ? iconColor
                        : filterHelper.disableIconColor,
                    size: filterHelper.textStyle.fontSize! + 10,
                  ),
                  prefixPadding: EdgeInsets.only(
                      left: 4.0,
                      right: filterHelper.textStyle.fontSize!,
                      bottom: filterHelper.textStyle.fontSize! > 14
                          ? filterHelper.textStyle.fontSize! - 14
                          : 0),
                  onTap: isSortDescendingEnabled
                      ? onHandleSortDescendingTap
                      : null,
                  child: Text(
                    grid_helper.getSortButtonText(
                      localizations,
                      false,
                      filterType,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (canShowSortingOptions)
                const Divider(indent: 8.0, endIndent: 8.0),
              if (canShowClearFilterOption)
                _FilterPopupMenuTile(
                  style: isClearFilterEnabled
                      ? filterHelper.textStyle
                      : filterHelper.disableTextStyle,
                  height: filterHelper.tileHeight,
                  prefix: Icon(
                      const IconData(0xe703,
                          fontFamily: 'FilterIcon',
                          fontPackage: 'syncfusion_flutter_datagrid'),
                      size: filterHelper.textStyle.fontSize! + 8,
                      color: isClearFilterEnabled
                          ? iconColor
                          : filterHelper.disableIconColor),
                  prefixPadding: EdgeInsets.only(
                      left: 4.0,
                      right: filterHelper.textStyle.fontSize!,
                      bottom: filterHelper.textStyle.fontSize! > 14
                          ? filterHelper.textStyle.fontSize! - 14
                          : 0),
                  onTap: isClearFilterEnabled ? onHandleClearFilterTap : null,
                  child: Text(getClearFilterText(localizations, showColumnName),
                      overflow: TextOverflow.ellipsis),
                ),
              if (isAdvancedFilterEnabled)
                _AdvancedFilterPopupMenu(
                  setState: setState,
                  dataGridConfiguration: widget.dataGridConfiguration,
                  advanceFilterTopPadding: advanceFilterTopPadding,
                ),
              if (isBothFilterEnabled)
                _FilterPopupMenuTile(
                  style: filterHelper.textStyle,
                  height: filterHelper.tileHeight,
                  onTap: onHandleExpansionTileTap,
                  prefix: Icon(
                      filterHelper.getFilterForm(widget.column) ==
                              FilteredFrom.advancedFilter
                          ? const IconData(0xe704,
                              fontFamily: 'FilterIcon',
                              fontPackage: 'syncfusion_flutter_datagrid')
                          : const IconData(0xe702,
                              fontFamily: 'FilterIcon',
                              fontPackage: 'syncfusion_flutter_datagrid'),
                      size: filterHelper.textStyle.fontSize! + 6,
                      color: iconColor),
                  suffix: Icon(
                      isAdvancedFilter
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: filterHelper.textStyle.fontSize! + 6,
                      color: iconColor),
                  prefixPadding: EdgeInsets.only(
                      left: 4.0,
                      right: filterHelper.textStyle.fontSize!,
                      bottom: filterHelper.textStyle.fontSize! > 14
                          ? filterHelper.textStyle.fontSize! - 14
                          : 0),
                  child: Text(
                    grid_helper.getFilterTileText(localizations, filterType),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (isCheckboxFilterEnabled || isBothFilterEnabled)
                Visibility(
                  visible: isAdvancedFilter,
                  replacement: _CheckboxFilterMenu(
                    column: widget.column,
                    setState: setState,
                    viewSize: viewSize,
                    dataGridConfiguration: widget.dataGridConfiguration,
                  ),
                  child: _AdvancedFilterPopupMenu(
                    setState: setState,
                    dataGridConfiguration: widget.dataGridConfiguration,
                    advanceFilterTopPadding: advanceFilterTopPadding,
                  ),
                ),
              if (!isMobile) const Divider(height: 10),
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 120.0,
                        height: filterHelper.tileHeight - 8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  // Issue:
                                  // FLUT-7487-The buttons UX in the filter popup menu is not very intuitive when using Material 3 design.
                                  //
                                  // Fix:
                                  // There is an issue with the button user experience (UX) in the filter popup menu,
                                  // which is caused by the default background color of the "ElevatedButton" widget
                                  // being set to the surface color in the Material 3 design. To address this issue,
                                  // we set the background color of the button to the primary color if it is not disabled.
                                  // This means that the default value is ignored, and the given color is used instead.
                                  if (states.contains(MaterialState.disabled)) {
                                    return null;
                                  } else {
                                    return filterHelper.primaryColor;
                                  }
                                },
                              ),
                            ),
                            onPressed: canDisableOkButton()
                                ? null
                                : onHandleOkButtonTap,
                            child: Text(localizations.okDataGridFilteringLabel,
                                style: TextStyle(
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: filterHelper.textStyle.fontSize,
                                    fontFamily:
                                        filterHelper.textStyle.fontFamily))),
                      ),
                      SizedBox(
                        width: 120.0,
                        height: filterHelper.tileHeight - 8,
                        child: OutlinedButton(
                            onPressed: closePage,
                            child: Text(
                              localizations.cancelDataGridFilteringLabel,
                              style: TextStyle(
                                  color: filterHelper.primaryColor,
                                  fontSize: filterHelper.textStyle.fontSize,
                                  fontFamily:
                                      filterHelper.textStyle.fontFamily),
                            )),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      );
    }

    if (isAdvancedFilterEnabled) {
      isAdvancedFilter = true;
    }
    if (isAdvancedFilterEnabled &&
        !canShowClearFilterOption &&
        !canShowSortingOptions) {
      advanceFilterTopPadding = 6;
    }

    if (isMobile) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              buildPopup(viewSize: constraints.biggest));
    } else {
      return buildPopup();
    }
  }

  void onHandleSortAscendingTap() {
    if (widget.dataGridConfiguration.allowSorting) {
      filterHelper.onSortButtonClick(
          widget.column, DataGridSortDirection.ascending);
    }
    Navigator.pop(context);
  }

  void onHandleSortDescendingTap() {
    if (widget.dataGridConfiguration.allowSorting) {
      filterHelper.onSortButtonClick(
          widget.column, DataGridSortDirection.descending);
    }
    Navigator.pop(context);
  }

  void onHandleClearFilterTap() {
    filterHelper.onClearFilterButtonClick(widget.column);
    Navigator.pop(context);
  }

  void onHandleExpansionTileTap() {
    setState(() {
      isAdvancedFilter = !isAdvancedFilter;
    });
  }

  void onHandleOkButtonTap() {
    filterHelper.createFilterConditions(!isAdvancedFilter, widget.column);
    Navigator.pop(context);
  }

  void closePage() {
    Navigator.pop(context);
  }

  bool hasFilterConditions() {
    return widget.dataGridConfiguration.source.filterConditions
        .containsKey(widget.column.columnName);
  }

  bool canDisableOkButton() {
    if (isAdvancedFilter) {
      final DataGridAdvancedFilterHelper helper =
          filterHelper.advancedFilterHelper;
      return (helper.filterValue1 == null && helper.filterValue2 == null) &&
          !helper.disableFilterTypes.contains(helper.filterType1) &&
          !helper.disableFilterTypes.contains(helper.filterType2);
    } else {
      final bool? isSelectAllChecked =
          filterHelper.checkboxFilterHelper.isSelectAllChecked;
      return (isSelectAllChecked != null && !isSelectAllChecked) ||
          filterHelper.checkboxFilterHelper.items.isEmpty;
    }
  }

  bool canEnableSortButton(DataGridSortDirection sortDirection) {
    final DataGridConfiguration configuration = widget.dataGridConfiguration;
    if (configuration.allowSorting && widget.column.allowSorting) {
      return configuration.source.sortedColumns.isEmpty ||
          !configuration.source.sortedColumns.any((SortColumnDetails column) =>
              column.name == widget.column.columnName &&
              column.sortDirection == sortDirection);
    }
    return false;
  }

  String getClearFilterText(SfLocalizations localization, bool showColumnName) {
    if (showColumnName) {
      return '${localization.clearFilterDataGridFilteringLabel} ${localization.fromDataGridFilteringLabel} "${widget.column.columnName}"';
    } else {
      return localization.clearFilterDataGridFilteringLabel;
    }
  }
}

class _FilterPopupMenuTile extends StatelessWidget {
  const _FilterPopupMenuTile(
      {Key? key,
      required this.child,
      this.onTap,
      this.prefix,
      this.suffix,
      this.height,
      required this.style,
      this.prefixPadding = EdgeInsets.zero})
      : super(key: key);

  final Widget child;

  final Widget? prefix;

  final Widget? suffix;

  final double? height;

  final TextStyle style;

  final VoidCallback? onTap;

  final EdgeInsets prefixPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: MaterialButton(
        onPressed: onTap,
        child: Row(
          children: <Widget>[
            Padding(
              padding: prefixPadding,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: prefix,
              ),
            ),
            Expanded(
              child: DefaultTextStyle(style: style, child: child),
            ),
            if (suffix != null) SizedBox(width: 40.0, child: suffix)
          ],
        ),
      ),
    );
  }
}

class _FilterMenuDropdown extends StatelessWidget {
  const _FilterMenuDropdown(
      {required this.child,
      required this.padding,
      required this.height,
      this.suffix,
      Key? key})
      : super(key: key);

  final Widget child;

  final Widget? suffix;

  final double height;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: Row(
          children: <Widget>[
            Expanded(
              child: child,
            ),
            if (suffix != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: suffix,
              )
          ],
        ),
      ),
    );
  }
}

class _CheckboxFilterMenu extends StatelessWidget {
  _CheckboxFilterMenu(
      {Key? key,
      required this.setState,
      required this.column,
      required this.viewSize,
      required this.dataGridConfiguration})
      : super(key: key);

  final StateSetter setState;

  final DataGridConfiguration dataGridConfiguration;

  final GridColumn column;

  final Size? viewSize;

  final FocusNode checkboxFocusNode = FocusNode(skipTraversal: true);

  bool get isMobile {
    return !dataGridConfiguration.isDesktop;
  }

  DataGridCheckboxFilterHelper get filterHelper {
    return dataGridConfiguration.dataGridFilterHelper!.checkboxFilterHelper;
  }

  @override
  Widget build(BuildContext context) {
    final Color onSurface = dataGridConfiguration.colorScheme!.onSurface;

    return Column(
      children: <Widget>[
        _buildSearchBox(onSurface, context),
        _buildCheckboxListView(context),
      ],
    );
  }

  Widget _buildCheckboxListView(BuildContext context) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    // 340.0 it's a occupied height in the current view by the other widgets.
    double occupiedHeight = 340.0;

    // Need to set the Checkbox Filter height in the mobile platform
    // based on the options enabled in the Filter popup menu
    if (column.filterPopupMenuOptions != null && isMobile) {
      if (!column.filterPopupMenuOptions!.canShowSortingOptions) {
        // 16.0 is the height of the divider shown below the sorting options
        occupiedHeight -= (helper.tileHeight * 2) + 16.0;
      }
      if (!column.filterPopupMenuOptions!.canShowClearFilterOption) {
        occupiedHeight -= helper.tileHeight;
      }
      if (column.filterPopupMenuOptions!.filterMode ==
          FilterMode.checkboxFilter) {
        occupiedHeight -= helper.tileHeight;
      }
    }

    // Gets the remaining height of the current view to fill the checkbox
    // listview in the mobile platform.
    final double checkboxHeight =
        isMobile ? max(viewSize!.height - occupiedHeight, 120.0) : 200.0;
    final double selectAllButtonHeight =
        isMobile ? helper.tileHeight - 4 : helper.tileHeight;

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Visibility(
        visible: filterHelper.items.isNotEmpty,
        replacement: SizedBox(
          height: checkboxHeight + selectAllButtonHeight,
          child: Center(
              child: Text(dataGridConfiguration
                  .localizations.noMatchesDataGridFilteringLabel)),
        ),
        child: CheckboxTheme(
          data: CheckboxThemeData(
            side: BorderSide(
                width: 2.0,
                color: dataGridConfiguration.colorScheme!.onSurface
                    .withOpacity(0.6)),

            // Issue: The checkbox fill color is applied even when the checkbox is not selected.
            // The framework changed this behavior in Flutter 3.13.0 onwards.
            // Refer to the issue: https://github.com/flutter/flutter/issues/130295
            // Guide: https://github.com/flutter/website/commit/224bdc9cc3e8dfb8af94d76f275824cdcf76ba4d
            // Fix: As per the framework guide, we have to set the fillColor property to transparent
            // when the checkbox is not selected.
            fillColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              if (!states.contains(MaterialState.selected)) {
                return Colors.transparent;
              }
              return helper.primaryColor;
            }),
          ),
          child: Column(children: <Widget>[
            _FilterPopupMenuTile(
              style: helper.textStyle,
              height: selectAllButtonHeight,
              prefixPadding: const EdgeInsets.only(left: 4.0, right: 10.0),
              prefix: Checkbox(
                focusNode: checkboxFocusNode,
                tristate: filterHelper.isSelectAllInTriState,
                value: filterHelper.isSelectAllChecked,
                onChanged: (_) => onHandleSelectAllCheckboxTap(),
              ),
              onTap: onHandleSelectAllCheckboxTap,
              child: Text(
                dataGridConfiguration
                    .localizations.selectAllDataGridFilteringLabel,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: checkboxHeight,
              child: ListView.builder(
                  key: const ValueKey<String>(
                      'datagrid_filtering_checkbox_listView'),
                  prototypeItem: buildCheckboxTile(
                      filterHelper.items.length - 1, helper.textStyle),
                  itemCount: filterHelper.items.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildCheckboxTile(index, helper.textStyle)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSearchBox(Color onSurface, BuildContext context) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    void onSearchboxSubmitted(String value) {
      if (filterHelper.items.isNotEmpty) {
        helper.createFilterConditions(true, column);
        Navigator.pop(context);
      } else {
        filterHelper.searchboxFocusNode.requestFocus();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SizedBox(
        height: isMobile ? helper.tileHeight : helper.tileHeight - 4,
        child: TextField(
          style: helper.textStyle,
          key: const ValueKey<String>('datagrid_filtering_search_textfield'),
          focusNode: filterHelper.searchboxFocusNode,
          controller: filterHelper.textController,
          onChanged: onHandleSearchTextFieldChanged,
          onSubmitted: onSearchboxSubmitted,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: helper.borderColor)),
              suffixIcon: Visibility(
                  visible: filterHelper.textController.text.isEmpty,
                  replacement: IconButton(
                      key: const ValueKey<String>(
                          'datagrid_filtering_clearSearch_icon'),
                      iconSize: helper.textStyle.fontSize! + 8,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                          width: 22.0, height: 22.0),
                      onPressed: () {
                        filterHelper.textController.clear();
                        onHandleSearchTextFieldChanged('');
                      },
                      icon: Icon(Icons.close, color: helper.iconColor)),
                  child: Icon(Icons.search,
                      size: helper.textStyle.fontSize! + 8,
                      color: helper.iconColor)),
              contentPadding: isMobile
                  ? const EdgeInsets.all(16.0)
                  : const EdgeInsets.all(8.0),
              border: const OutlineInputBorder(),
              hintStyle: helper.textStyle,
              hintText: dataGridConfiguration
                  .localizations.searchDataGridFilteringLabel),
        ),
      ),
    );
  }

  Widget? buildCheckboxTile(int index, TextStyle style) {
    if (filterHelper.items.isNotEmpty) {
      final FilterElement element = filterHelper.items[index];
      final String displayText = dataGridConfiguration.dataGridFilterHelper!
          .getDisplayValue(element.value);
      return _FilterPopupMenuTile(
          style: style,
          height: isMobile ? style.fontSize! + 34 : style.fontSize! + 26,
          prefixPadding: const EdgeInsets.only(left: 4.0, right: 10.0),
          prefix: Checkbox(
              focusNode: checkboxFocusNode,
              value: element.isSelected,
              onChanged: (_) => onHandleCheckboxTap(element)),
          onTap: () => onHandleCheckboxTap(element),
          child: Text(displayText, overflow: TextOverflow.ellipsis));
    }
    return null;
  }

  void onHandleCheckboxTap(FilterElement element) {
    element.isSelected = !element.isSelected;
    filterHelper.ensureSelectAllCheckboxState();
    setState(() {});
  }

  void onHandleSelectAllCheckboxTap() {
    final bool useSelected = filterHelper.isSelectAllInTriState ||
        (filterHelper.isSelectAllChecked != null &&
            filterHelper.isSelectAllChecked!);
    for (final FilterElement item in filterHelper.filterCheckboxItems) {
      item.isSelected = !useSelected;
    }

    filterHelper.ensureSelectAllCheckboxState();
    setState(() {});
  }

  void onHandleSearchTextFieldChanged(String value) {
    filterHelper.onSearchTextFieldTextChanged(value);
    setState(() {});
  }
}

class _AdvancedFilterPopupMenu extends StatelessWidget {
  const _AdvancedFilterPopupMenu(
      {Key? key,
      required this.setState,
      required this.dataGridConfiguration,
      required this.advanceFilterTopPadding})
      : super(key: key);

  final StateSetter setState;

  final DataGridConfiguration dataGridConfiguration;

  final double advanceFilterTopPadding;

  bool get isMobile {
    return !dataGridConfiguration.isDesktop;
  }

  DataGridAdvancedFilterHelper get filterHelper {
    return dataGridConfiguration.dataGridFilterHelper!.advancedFilterHelper;
  }

  @override
  Widget build(BuildContext context) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: <Widget>[
          _FilterMenuDropdown(
            height: helper.textStyle.fontSize! + 2,
            padding: EdgeInsets.only(top: advanceFilterTopPadding, bottom: 8.0),
            child: Text(
              '${dataGridConfiguration.localizations.showRowsWhereDataGridFilteringLabel}:',
              style: TextStyle(
                  fontFamily: helper.textStyle.fontFamily,
                  fontSize: helper.textStyle.fontSize,
                  color: helper.textStyle.color,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _FilterMenuDropdown(
            height: isMobile ? helper.tileHeight + 4 : helper.tileHeight - 4,
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildFilterTypeDropdown(isFirstButton: true),
          ),
          _FilterMenuDropdown(
            height: isMobile ? helper.tileHeight + 4 : helper.tileHeight - 4,
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            suffix: _getTrailingWidget(context, true),
            child: _buildFilterValueDropdown(isTopButton: true),
          ),
          _buildRadioButtons(),
          _FilterMenuDropdown(
            height: isMobile ? helper.tileHeight + 4 : helper.tileHeight - 4,
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: _buildFilterTypeDropdown(isFirstButton: false),
          ),
          _FilterMenuDropdown(
            height: isMobile ? helper.tileHeight + 4 : helper.tileHeight - 4,
            padding: const EdgeInsets.only(bottom: 8.0),
            suffix: _getTrailingWidget(context, false),
            child: _buildFilterValueDropdown(isTopButton: false),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons() {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;
    final SfLocalizations localizations = dataGridConfiguration.localizations;

    void handleChanged(bool? value) {
      setState(() {
        filterHelper.isOrPredicate = !filterHelper.isOrPredicate;
      });
    }

    return Row(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox.fromSize(
            size: const Size(24.0, 24.0),
            child: Radio<bool>(
                key: const ValueKey<String>('datagrid_filtering_and_button'),
                value: false,
                activeColor: helper.primaryColor,
                onChanged: handleChanged,
                groupValue: filterHelper.isOrPredicate),
          ),
          const SizedBox(width: 8.0),
          Text(
            localizations.andDataGridFilteringLabel,
            style: helper.textStyle,
          ),
        ]),
        const SizedBox(width: 16.0),
        Row(children: <Widget>[
          SizedBox.fromSize(
            size: const Size(24.0, 24.0),
            child: Radio<bool>(
                key: const ValueKey<String>('datagrid_filtering_or_button'),
                value: true,
                activeColor: helper.primaryColor,
                onChanged: handleChanged,
                groupValue: filterHelper.isOrPredicate),
          ),
          const SizedBox(width: 8.0),
          Text(
            localizations.orDataGridFilteringLabel,
            style: helper.textStyle,
          ),
        ]),
      ],
    );
  }

  Widget _buildFilterValueDropdown({required bool isTopButton}) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    void setValue(Object? value) {
      if (isTopButton) {
        filterHelper.filterValue1 = value;
      } else {
        filterHelper.filterValue2 = value;
      }
      setState(() {});
    }

    TextInputType getTextInputType() {
      if (filterHelper.advancedFilterType == AdvancedFilterType.text) {
        return TextInputType.text;
      }
      return TextInputType.number;
    }

    List<TextInputFormatter>? getInputFormatters() {
      if (filterHelper.advancedFilterType == AdvancedFilterType.date) {
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
        ];
      } else if (filterHelper.advancedFilterType ==
          AdvancedFilterType.numeric) {
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ];
      }
      return null;
    }

    Widget buildDropdownFormField() {
      return DropdownButtonHideUnderline(
        child: DropdownButtonFormField<Object>(
          key: isTopButton
              ? const ValueKey<String>(
                  'datagrid_filtering_filterValue_first_button')
              : const ValueKey<String>(
                  'datagrid_filtering_filterValue_second_button'),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: helper.borderColor),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: helper.borderColor))),
          icon: Icon(Icons.keyboard_arrow_down,
              size: helper.textStyle.fontSize! + 8, color: helper.iconColor),
          isExpanded: true,
          value: isTopButton
              ? filterHelper.filterValue1
              : filterHelper.filterValue2,
          style: helper.textStyle,
          items: filterHelper.items
              .map<DropdownMenuItem<Object>>((FilterElement value) =>
                  DropdownMenuItem<Object>(
                      value: value.value,
                      child: Text(helper.getDisplayValue(value.value))))
              .toList(),
          onChanged: enableDropdownButton(isTopButton) ? setValue : null,
        ),
      );
    }

    Widget buildTextField() {
      return TextField(
        style: helper.textStyle,
        key: isTopButton
            ? const ValueKey<String>(
                'datagrid_filtering_filterValue_first_button')
            : const ValueKey<String>(
                'datagrid_filtering_filterValue_second_button'),
        controller: isTopButton
            ? filterHelper.firstValueTextController
            : filterHelper.secondValueTextController,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: getTextInputType(),
        inputFormatters: getInputFormatters(),
        onChanged: (String? value) {
          value = value != null && value.isEmpty ? null : value;
          setValue(helper.getActualValue(value));
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: helper.borderColor)),
            contentPadding: isMobile
                ? const EdgeInsets.all(16.0)
                : const EdgeInsets.all(8.0),
            border: const OutlineInputBorder(),
            hintStyle: const TextStyle(fontSize: 14.0)),
      );
    }

    return canBuildTextField(isTopButton)
        ? buildTextField()
        : buildDropdownFormField();
  }

  Widget _buildFilterTypeDropdown({required bool isFirstButton}) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    void handleChanged(String? value) {
      if (isFirstButton) {
        filterHelper.filterType1 = value;
      } else {
        filterHelper.filterType2 = value;
      }

      // Need to set the filter values to null if the type is null or empty.
      if (filterHelper.disableFilterTypes.contains(value)) {
        if (isFirstButton) {
          filterHelper.filterValue1 = null;
        } else {
          filterHelper.filterValue2 = null;
        }
      }

      // Need to set the current filter value to the controller's text to retains
      // the same value in the text field itself.
      if (filterHelper.textFieldFilterTypes.contains(value)) {
        if (isFirstButton) {
          filterHelper.firstValueTextController.text =
              helper.getDisplayValue(filterHelper.filterValue1);
        } else {
          filterHelper.secondValueTextController.text =
              helper.getDisplayValue(filterHelper.filterValue2);
        }
      } else {
        // Need to set the filter values to null if that value doesn't exist in
        // the data source when the filter type switching from the text field to
        // dropdown.
        bool isInValidText(Object? filterValue) => !filterHelper.items
            .any((FilterElement element) => element.value == filterValue);
        if (isFirstButton) {
          if (isInValidText(filterHelper.filterValue1)) {
            filterHelper.filterValue1 = null;
          }
        } else {
          if (isInValidText(filterHelper.filterValue2)) {
            filterHelper.filterValue2 = null;
          }
        }
      }
      setState(() {});
    }

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        key: isFirstButton
            ? const ValueKey<String>(
                'datagrid_filtering_filterType_first_button')
            : const ValueKey<String>(
                'datagrid_filtering_filterType_second_button'),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: helper.borderColor)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: helper.borderColor))),
        icon: Icon(Icons.keyboard_arrow_down,
            size: helper.textStyle.fontSize! + 8, color: helper.iconColor),
        isExpanded: true,
        value:
            isFirstButton ? filterHelper.filterType1 : filterHelper.filterType2,
        style: helper.textStyle,
        items: filterHelper.filterTypeItems
            .map<DropdownMenuItem<String>>((String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value)))
            .toList(),
        onChanged: handleChanged,
      ),
    );
  }

  Widget? _getTrailingWidget(BuildContext context, bool isFirstButton) {
    final DataGridFilterHelper helper =
        dataGridConfiguration.dataGridFilterHelper!;

    if (filterHelper.advancedFilterType == AdvancedFilterType.numeric) {
      return null;
    }

    Future<void> handleDatePickerTap() async {
      final DateTime currentDate = DateTime.now();
      final DateTime firstDate = filterHelper.items.first.value as DateTime;
      final DateTime lastDate = filterHelper.items.last.value as DateTime;
      DateTime initialDate = firstDate;

      if ((currentDate.isAfter(firstDate) && currentDate.isBefore(lastDate)) ||
          (lastDate.day == currentDate.day &&
              lastDate.month == currentDate.month &&
              lastDate.year == currentDate.year)) {
        initialDate = currentDate;
      }
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: 'Select a date',
      );

      // Need to return if user presses the cancel button to close the data picker view.
      if (selectedDate == null) {
        return;
      }

      final bool isVaildDate = filterHelper.items
          .any((FilterElement element) => element.value == selectedDate);
      final String? filterType =
          isFirstButton ? filterHelper.filterType1 : filterHelper.filterType2;
      final bool isValidType = filterType != null &&
          filterHelper.textFieldFilterTypes.contains(filterType);
      selectedDate = isVaildDate || isValidType ? selectedDate : null;

      setState(() {
        final String newValue = helper.getDisplayValue(selectedDate);
        if (isFirstButton) {
          filterHelper.filterValue1 = selectedDate;
          filterHelper.firstValueTextController.text = newValue;
        } else {
          filterHelper.filterValue2 = selectedDate;
          filterHelper.secondValueTextController.text = newValue;
        }
      });
    }

    void handleCaseSensitiveTap() {
      setState(() {
        if (isFirstButton) {
          filterHelper.isCaseSensitive1 = !filterHelper.isCaseSensitive1;
        } else {
          filterHelper.isCaseSensitive2 = !filterHelper.isCaseSensitive2;
        }
      });
    }

    Color getColor() {
      final bool isSelected = isFirstButton
          ? filterHelper.isCaseSensitive1
          : filterHelper.isCaseSensitive2;
      return isSelected ? helper.primaryColor : helper.iconColor;
    }

    bool canEnableButton() {
      final String? value =
          isFirstButton ? filterHelper.filterType1 : filterHelper.filterType2;
      return value != null && !filterHelper.disableFilterTypes.contains(value);
    }

    if (filterHelper.advancedFilterType == AdvancedFilterType.text) {
      const IconData caseSensitiveIcon = IconData(0xe705,
          fontFamily: 'FilterIcon', fontPackage: 'syncfusion_flutter_datagrid');
      return IconButton(
          key: isFirstButton
              ? const ValueKey<String>(
                  'datagrid_filtering_case_sensitive_first_button')
              : const ValueKey<String>(
                  'datagrid_filtering_case_sensitive_second_button'),
          iconSize: 22.0,
          splashRadius: 20.0,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 22.0, height: 22.0),
          onPressed: canEnableButton() ? handleCaseSensitiveTap : null,
          icon: Icon(caseSensitiveIcon, size: 22.0, color: getColor()));
    } else {
      return IconButton(
          key: isFirstButton
              ? const ValueKey<String>(
                  'datagrid_filtering_date_picker_first_button')
              : const ValueKey<String>(
                  'datagrid_filtering_date_picker_second_button'),
          iconSize: 22.0,
          splashRadius: 20.0,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 22.0, height: 22.0),
          onPressed: canEnableButton() ? handleDatePickerTap : null,
          icon: Icon(Icons.calendar_today_outlined,
              size: 22.0,
              color: dataGridConfiguration.colorScheme!.onSurface
                  .withOpacity(0.6)));
    }
  }

  bool enableDropdownButton(bool isTopButton) {
    return !filterHelper.disableFilterTypes.contains(
        isTopButton ? filterHelper.filterType1 : filterHelper.filterType2);
  }

  bool canBuildTextField(bool isTopButton) {
    final String filterType =
        isTopButton ? filterHelper.filterType1! : filterHelper.filterType2!;
    if (filterHelper.textFieldFilterTypes.contains(filterType)) {
      return true;
    }
    return false;
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
  final bool isRowCell = dataCell.cellType == CellType.gridCell;
  final bool isCheckboxCell = dataCell.cellType == CellType.checkboxCell;

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

  final ColumnDragAndDropController dragAndDropController =
      dataGridConfiguration.columnDragAndDropController;

  final bool canDrawLeftColumnDragAndDropIndicator = dataGridConfiguration
          .allowColumnsDragging &&
      dragAndDropController.canDrawRightIndicator != null &&
      !dragAndDropController.canDrawRightIndicator! &&
      dragAndDropController.columnIndex == dataCell.columnIndex &&
      (!dataGridConfiguration.showCheckboxColumn
          ? dragAndDropController.dragColumnStartIndex != dataCell.columnIndex
          : dragAndDropController.dragColumnStartIndex! + 1 !=
              dataCell.columnIndex) &&
      isHeaderCell;

  final bool canDrawRightColumnDragAndDropIndicator = dataGridConfiguration
          .allowColumnsDragging &&
      dragAndDropController.canDrawRightIndicator != null &&
      dragAndDropController.canDrawRightIndicator! &&
      dragAndDropController.columnIndex == dataCell.columnIndex &&
      (!dataGridConfiguration.showCheckboxColumn
          ? dragAndDropController.dragColumnStartIndex != dataCell.columnIndex
          : dragAndDropController.dragColumnStartIndex! + 1 !=
              dataCell.columnIndex) &&
      isHeaderCell;

  final bool canSkipLeftColumnDragAndDropIndicator =
      canDrawLeftColumnDragAndDropIndicator &&
          (!dataGridConfiguration.showCheckboxColumn
              ? dragAndDropController.dragColumnStartIndex! + 1 ==
                  dataCell.columnIndex
              : (dragAndDropController.dragColumnStartIndex! + 2 ==
                      dataCell.columnIndex ||
                  dragAndDropController.columnIndex == 0));

  final bool canSkipRightColumnDragAndDropIndicator =
      canDrawRightColumnDragAndDropIndicator &&
          (!dataGridConfiguration.showCheckboxColumn
              ? dragAndDropController.dragColumnStartIndex! - 1 ==
                  dataCell.columnIndex
              : (dragAndDropController.dragColumnStartIndex! ==
                      dataCell.columnIndex ||
                  dragAndDropController.columnIndex == 0));

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

  final GridColumn firstVisibleColumn = dataGridConfiguration.columns
      .firstWhere((GridColumn column) => column.visible && column.width != 0.0);

  final GridColumn column = dataCell.gridColumn!;

  // To draw the top outer border for the DataGrid.
  final bool canDrawGridTopOuterBorder = rowIndex == 0 &&
      dataGridConfiguration.headerGridLinesVisibility !=
          GridLinesVisibility.none;

  // To draw the left outer border for the DataGrid Headers.
  final bool canDrawGridHeaderLeftOuterBorder =
      (isHeaderCell || isStackedHeaderCell) &&
          dataGridConfiguration.headerGridLinesVisibility !=
              GridLinesVisibility.none &&
          column.columnName == firstVisibleColumn.columnName;

  // To draw the left outer border for the DataGrid Rows.
  final bool canDrawGridRowsLeftOuterBorder = (isRowCell ||
          isTableSummaryCell ||
          isCheckboxCell) &&
      dataGridConfiguration.gridLinesVisibility != GridLinesVisibility.none &&
      column.columnName == firstVisibleColumn.columnName;

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

  BorderSide getLeftBorder() {
    if ((columnIndex == 0 &&
            (canDrawVerticalBorder ||
                canDrawHeaderVerticalBorder ||
                canDrawLeftColumnDragAndDropIndicator)) ||
        canDrawLeftFrozenBorder ||
        canDrawGridHeaderLeftOuterBorder ||
        canDrawGridRowsLeftOuterBorder) {
      if (canDrawLeftColumnDragAndDropIndicator &&
          !canSkipLeftColumnDragAndDropIndicator) {
        return BorderSide(
            width: dataGridConfiguration
                .dataGridThemeHelper!.columnDragIndicatorStrokeWidth,
            color: dataGridConfiguration
                .dataGridThemeHelper!.columnDragIndicatorColor);
      }
      if (canDrawLeftFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if ((columnIndex > 0 &&
              ((canDrawVerticalBorder || canDrawHeaderVerticalBorder) &&
                  !canDrawLeftFrozenBorder)) ||
          (canDrawGridRowsLeftOuterBorder ||
              canDrawGridHeaderLeftOuterBorder)) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else if (canDrawLeftColumnDragAndDropIndicator &&
        !canSkipLeftColumnDragAndDropIndicator) {
      return BorderSide(
          width: dataGridConfiguration
              .dataGridThemeHelper!.columnDragIndicatorStrokeWidth,
          color: dataGridConfiguration
              .dataGridThemeHelper!.columnDragIndicatorColor);
    } else {
      return BorderSide.none;
    }
  }

  BorderSide getTopBorder() {
    if ((rowIndex == 0 &&
            (canDrawHorizontalBorder || canDrawHeaderHorizontalBorder)) ||
        canDrawTopFrozenBorder ||
        canDrawStartBottomSummaryRowTopBorder ||
        canDrawGridTopOuterBorder) {
      if (canDrawTopFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if ((canDrawHorizontalBorder &&
              canDrawStartBottomSummaryRowTopBorder) ||
          canDrawGridTopOuterBorder) {
        return BorderSide(width: borderWidth, color: borderColor);
      } else {
        return BorderSide.none;
      }
    } else {
      return BorderSide.none;
    }
  }

  BorderSide getRightBorder() {
    if (canDrawVerticalBorder ||
        canDrawHeaderVerticalBorder ||
        canDrawRightFrozenBorder ||
        canDrawRightColumnDragAndDropIndicator) {
      if (canDrawRightFrozenBorder &&
          !isStackedHeaderCell &&
          !isFrozenPaneElevationApplied) {
        return BorderSide(
            width: frozenPaneLineWidth, color: frozenPaneLineColor);
      } else if (canDrawRightColumnDragAndDropIndicator &&
          !canSkipRightColumnDragAndDropIndicator) {
        return BorderSide(
            width: dataGridConfiguration
                .dataGridThemeHelper!.columnDragIndicatorStrokeWidth,
            color: dataGridConfiguration
                .dataGridThemeHelper!.columnDragIndicatorColor);
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

  BorderSide getBottomBorder() {
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
    start: getLeftBorder(),
    top: getTopBorder(),
    end: getRightBorder(),
    bottom: getBottomBorder(),
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

Future<void> _handleOnTapUp(
    {required TapUpDetails? tapUpDetails,
    required TapDownDetails? tapDownDetails,
    required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration,
    required PointerDeviceKind kind,
    bool isSecondaryTapDown = false}) async {
  // End edit the current editing cell if its editing mode is differed
  if (dataGridConfiguration.currentCell.isEditing) {
    if (await dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      await dataGridConfiguration.currentCell
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

Future<void> _handleOnDoubleTap(
    {required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration}) async {
  // End edit the current editing cell if its editing mode is differed
  if (dataGridConfiguration.currentCell.isEditing) {
    if (await dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      await dataGridConfiguration.currentCell
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

Future<void> _handleOnSecondaryTapUp(
    {required TapUpDetails tapUpDetails,
    required DataCellBase dataCell,
    required DataGridConfiguration dataGridConfiguration,
    required PointerDeviceKind kind}) async {
  // Need to end the editing cell when interacting with other tap gesture
  if (dataGridConfiguration.currentCell.isEditing) {
    if (await dataGridConfiguration.currentCell
        .canSubmitCell(dataGridConfiguration)) {
      await dataGridConfiguration.currentCell
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
