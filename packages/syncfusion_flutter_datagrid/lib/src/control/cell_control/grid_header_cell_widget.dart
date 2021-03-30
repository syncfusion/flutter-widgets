part of datagrid;

/// A widget which displays in the header cells.
class GridHeaderCell extends StatefulWidget {
  /// Creates the [GridHeaderCell] for [SfDataGrid] widget.
  const GridHeaderCell({
    required Key key,
    required this.dataCell,
    required this.backgroundColor,
    required this.isDirty,
    required this.child,
  }) : super(key: key);

  /// Holds the information required to display the cell.
  final DataCellBase dataCell;

  /// The [child] contained by the [GridCell].
  final Widget child;

  /// The color to paint behind the [child].
  final Color backgroundColor;

  /// Decides whether the [GridCell] should be refreshed when [SfDataGrid] is
  /// rebuild.
  final bool isDirty;

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

  void _handleOnTapUp(TapUpDetails tapUpDetails) {
    final DataCellBase? dataCell = widget.dataCell;
    if (dataCell == null) {
      return;
    }
    final _DataGridSettings? dataGridSettings =
        dataCell._dataRow!._dataGridStateDetails!();
    if (dataGridSettings == null) {
      return;
    }
    if (dataGridSettings.onCellTap != null) {
      final DataGridCellTapDetails details = DataGridCellTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!,
          globalPosition: tapUpDetails.globalPosition,
          localPosition: tapUpDetails.localPosition,
          kind: _kind);
      dataGridSettings.onCellTap!(details);
    }

    dataGridSettings.dataGridFocusNode?.requestFocus();
    if (dataGridSettings.sortingGestureType == SortingGestureType.tap) {
      _sort(dataCell);
    }
  }

  void _handleOnDoubleTap() {
    final DataCellBase? dataCell = widget.dataCell;
    if (dataCell == null) {
      return;
    }
    final _DataGridSettings? dataGridSettings =
        dataCell._dataRow!._dataGridStateDetails!();
    if (dataGridSettings == null) {
      return;
    }
    if (dataGridSettings.onCellDoubleTap != null) {
      final DataGridCellDoubleTapDetails details = DataGridCellDoubleTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!);
      dataGridSettings.onCellDoubleTap!(details);
    }

    dataGridSettings.dataGridFocusNode?.requestFocus();
    if (dataGridSettings.sortingGestureType == SortingGestureType.doubleTap) {
      _sort(dataCell);
    }
  }

  void _handleOnLongPressEnd(LongPressEndDetails longPressEndDetails) {
    final DataCellBase? dataCell = widget.dataCell;
    if (dataCell == null) {
      return;
    }

    final _DataGridSettings? dataGridSettings =
        dataCell._dataRow!._dataGridStateDetails!();
    if (dataGridSettings == null) {
      return;
    }

    if (dataGridSettings.onCellLongPress != null) {
      final DataGridCellLongPressDetails details = DataGridCellLongPressDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!,
          globalPosition: longPressEndDetails.globalPosition,
          localPosition: longPressEndDetails.localPosition,
          velocity: longPressEndDetails.velocity);
      dataGridSettings.onCellLongPress!(details);
    }
  }

  void _handleOnSecondaryTapUp(TapUpDetails tapUpDetails) {
    final DataCellBase? dataCell = widget.dataCell;
    if (dataCell == null) {
      return;
    }
    final _DataGridSettings? dataGridSettings =
        dataCell._dataRow?._dataGridStateDetails!();
    if (dataGridSettings == null) {
      return;
    }
    if (dataGridSettings.onCellSecondaryTap != null) {
      final DataGridCellTapDetails details = DataGridCellTapDetails(
          rowColumnIndex:
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex),
          column: dataCell.gridColumn!,
          globalPosition: tapUpDetails.globalPosition,
          localPosition: tapUpDetails.localPosition,
          kind: _kind);
      dataGridSettings.onCellSecondaryTap!(details);
    }
  }

  void _handleOnTapDown(TapDownDetails details) {
    _kind = details.kind!;
  }

  Widget _wrapInsideGestureDetector() {
    final _DataGridSettings dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();
    return GestureDetector(
      onTapUp: dataGridSettings.onCellTap != null ||
              dataGridSettings.sortingGestureType == SortingGestureType.tap
          ? _handleOnTapUp
          : null,
      onTapDown: _handleOnTapDown,
      onDoubleTap: dataGridSettings.onCellDoubleTap != null ||
              dataGridSettings.sortingGestureType ==
                  SortingGestureType.doubleTap
          ? _handleOnDoubleTap
          : null,
      onLongPressEnd: dataGridSettings.onCellLongPress != null
          ? _handleOnLongPressEnd
          : null,
      onSecondaryTapUp: dataGridSettings.onCellSecondaryTap != null
          ? _handleOnSecondaryTapUp
          : null,
      onSecondaryTapDown: _handleOnTapDown,
      child: _wrapInsideContainer(),
    );
  }

  Widget _wrapInsideContainer() {
    final _DataGridSettings dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();
    final column = widget.dataCell.gridColumn;

    Widget checkHeaderCellConstraints(Widget child) {
      final iconWidth = dataGridSettings.columnSizer._getSortIconWidth(column!);
      return LayoutBuilder(builder: (context, constraints) {
        if (_sortDirection == null || constraints.maxWidth < iconWidth) {
          return child;
        } else {
          return _getCellWithSortIcon(child);
        }
      });
    }

    _ensureSortIconVisiblity(column!, dataGridSettings);

    return Container(
        key: widget.key,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(border: _getCellBorder(widget.dataCell)),
        child: _wrapInsideCellContainer(
          child: checkHeaderCellConstraints(widget.child),
          dataCell: widget.dataCell,
          key: widget.key!,
          backgroundColor: widget.backgroundColor,
        ));
  }

  Color? _getHoverBackgroundColor() {
    final _DataGridSettings? dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();
    if (dataGridSettings == null) {
      return null;
    }

    return dataGridSettings.dataGridThemeData!.headerHoverColor;
  }

  void onMouseHover() {
    final _DataGridSettings? dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();

    if (dataGridSettings != null) {
      widget.dataCell
        .._isDirty = true
        .._updateColumn();
      dataGridSettings.source._notifyDataGridPropertyChangeListeners(
          propertyName: 'hoverOnHeaderCell');
    }
  }

  void onMouseExit() {
    final _DataGridSettings? dataGridSettings =
        widget.dataCell._dataRow?._dataGridStateDetails!();

    if (dataGridSettings != null) {
      widget.dataCell
        .._isDirty = true
        .._updateColumn();
      dataGridSettings.source._notifyDataGridPropertyChangeListeners(
          propertyName: 'hoverOnHeaderCell');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Semantics(
      label: widget.dataCell.cellValue.toString(),
      child: MouseRegion(
        onHover: (event) {
          onMouseHover();
        },
        onExit: (event) {
          onMouseExit();
        },
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              mouseCursor: SystemMouseCursors.basic,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: _getHoverBackgroundColor(),
              onTap: () {},
              child: _wrapInsideGestureDetector(),
            )),
      ),
    );
    return _GridCellRenderObjectWidget(
      key: widget.key,
      dataCell: widget.dataCell,
      isDirty: widget.isDirty,
      child: child,
    );
  }

  void _ensureSortIconVisiblity(
      GridColumn column, _DataGridSettings? dataGridSettings) {
    if (dataGridSettings != null) {
      final sortColumn = dataGridSettings.source.sortedColumns.firstWhereOrNull(
          (sortColumn) => sortColumn.name == column.columnName);
      if (dataGridSettings.source.sortedColumns.isNotEmpty &&
          sortColumn != null) {
        final sortNumber =
            dataGridSettings.source.sortedColumns.indexOf(sortColumn) + 1;
        final isLight =
            dataGridSettings.dataGridThemeData!.brightness == Brightness.light;
        _sortDirection = sortColumn.sortDirection;
        _sortIconColor = dataGridSettings.dataGridThemeData!.sortIconColor;
        _sortNumberBackgroundColor =
            isLight ? Colors.grey[350]! : Colors.grey[700]!;
        _sortNumberTextColor = isLight ? Colors.black87 : Colors.white54;
        if (dataGridSettings.source.sortedColumns.length > 1 &&
            dataGridSettings.showSortNumbers) {
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
    final List<Widget> children = [];

    children.add(_SortIcon(
      sortDirection: _sortDirection!,
      sortIconColor: _sortIconColor,
    ));

    if (_sortNumber != -1) {
      children.add(_getSortNumber());
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(child: child),
          ),
          Container(
            padding: EdgeInsets.only(left: 4.0, right: 4.0),
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
    final _DataGridSettings dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();
    if (dataCell._dataRow?.rowType == RowType.headerRow &&
        dataCell._dataRow?.rowIndex ==
            _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      _makeSort(dataCell);
    }
  }

  Future<void> _makeSort(DataCellBase dataCell) async {
    final GridColumn column = dataCell.gridColumn!;
    final _DataGridSettings? dataGridSettings =
        widget.dataCell._dataRow!._dataGridStateDetails!();

    if (dataGridSettings != null &&
        column.allowSorting &&
        dataGridSettings.allowSorting) {
      final sortColumnName = column.columnName;
      final allowMultiSort = dataGridSettings._isDesktop
          ? (dataGridSettings.isControlKeyPressed &&
              dataGridSettings.allowMultiColumnSorting)
          : dataGridSettings.allowMultiColumnSorting;
      final source = dataGridSettings.source;

      final sortedColumns = source.sortedColumns;
      if (sortedColumns.isNotEmpty && allowMultiSort) {
        var sortedColumn = sortedColumns.firstWhereOrNull(
            (sortColumn) => sortColumn.name == sortColumnName);
        if (sortedColumn == null) {
          final newSortColumn = SortColumnDetails(
              name: sortColumnName,
              sortDirection: DataGridSortDirection.ascending);
          sortedColumns.add(newSortColumn);
          if (!await source._updateDataSource()) {
            sortedColumns.remove(newSortColumn);
          }
        } else {
          if (sortedColumn.sortDirection == DataGridSortDirection.descending &&
              dataGridSettings.allowTriStateSorting) {
            final removedSortColumn = sortedColumns.firstWhereOrNull(
                (sortColumn) => sortColumn.name == sortColumnName);
            sortedColumns.remove(removedSortColumn);
            await source._updateDataSource();
          } else {
            sortedColumn = SortColumnDetails(
                name: sortedColumn.name,
                sortDirection: sortedColumn.sortDirection ==
                        DataGridSortDirection.ascending
                    ? DataGridSortDirection.descending
                    : DataGridSortDirection.ascending);
            final removedSortColumn = sortedColumns.firstWhereOrNull(
                (sortColumn) => sortColumn.name == sortedColumn!.name);
            sortedColumns.remove(removedSortColumn);
            sortedColumns.add(sortedColumn);
            if (!await source._updateDataSource()) {
              sortedColumns.remove(sortedColumn);
            }
          }
        }
      } else {
        var currentSortColumn = sortedColumns.firstWhereOrNull(
            (sortColumn) => sortColumn.name == sortColumnName);
        if (sortedColumns.isNotEmpty && currentSortColumn != null) {
          if (currentSortColumn.sortDirection ==
                  DataGridSortDirection.descending &&
              dataGridSettings.allowTriStateSorting) {
            sortedColumns.clear();
            await source._updateDataSource();
          } else {
            currentSortColumn = SortColumnDetails(
                name: currentSortColumn.name,
                sortDirection: currentSortColumn.sortDirection ==
                        DataGridSortDirection.ascending
                    ? DataGridSortDirection.descending
                    : DataGridSortDirection.ascending);
            sortedColumns.clear();
            sortedColumns.add(currentSortColumn);
            if (!await source._updateDataSource()) {
              sortedColumns.remove(currentSortColumn);
            }
          }
        } else {
          final sortColumn = SortColumnDetails(
              name: sortColumnName,
              sortDirection: DataGridSortDirection.ascending);
          if (sortedColumns.isNotEmpty) {
            sortedColumns.clear();
            sortedColumns.add(sortColumn);
            if (!await source._updateDataSource()) {
              sortedColumns.remove(sortColumn);
            }
          } else {
            sortedColumns.add(sortColumn);
            if (!await source._updateDataSource()) {
              sortedColumns.remove(sortColumn);
            }
          }
        }
      }
      dataGridSettings.source
          ._notifyDataGridPropertyChangeListeners(propertyName: 'Sorting');
    }
  }
}

class _SortIcon extends StatefulWidget {
  _SortIcon({required this.sortDirection, required this.sortIconColor});
  final DataGridSortDirection sortDirection;
  final Color sortIconColor;
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
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _sortingAnimation = Tween(begin: 0.0, end: pi).animate(
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
    return Container(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                  angle: _sortingAnimation.value,
                  child: Icon(Icons.arrow_upward,
                      color: widget.sortIconColor, size: 16));
            }));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
