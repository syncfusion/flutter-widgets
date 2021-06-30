part of datagrid;

class _ScrollViewWidget extends StatefulWidget {
  const _ScrollViewWidget(
      {required this.dataGridStateDetails,
      required this.width,
      required this.height});

  final _DataGridStateDetails dataGridStateDetails;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _ScrollViewWidgetState();
}

class _ScrollViewWidgetState extends State<_ScrollViewWidget> {
  ScrollController? _verticalController;
  ScrollController? _horizontalController;
  FocusNode? _dataGridFocusNode;
  double _width = 0.0;
  double _height = 0.0;
  bool _isScrolling = false;

  // This flag is used to restrict the load more view from being shown for
  // every moment when datagrid reached at bottom on vertical scrolling.
  bool _isLoadMoreViewLoaded = false;

  @override
  void initState() {
    _verticalController = _dataGridSettings.verticalScrollController;
    _verticalController!.addListener(_verticalListener);
    _horizontalController = _dataGridSettings.horizontalScrollController;
    _horizontalController!.addListener(_horizontalListener);
    _height = widget.height;
    _width = widget.width;

    _dataGridSettings.rowSelectionManager
        .addListener(_handleSelectionController);

    if (_dataGridFocusNode == null) {
      // [FocusNode.onKey] callback is not firing on key navigation after flutter
      // 2.2.0 and its breaking our key navigation on tab, shift + tab, arrow keys.
      // So, we have used the focus widget and its need to remove when below
      // mentioned issue is resolved on framework end.
      //_dataGridFocusNode = FocusNode(onKey: _handleFocusKeyOperation);
      _dataGridFocusNode = FocusNode();
      _dataGridSettings.dataGridFocusNode = _dataGridFocusNode!;
      if (_dataGridSettings.source.sortedColumns.isNotEmpty) {
        _dataGridFocusNode!.requestFocus();
      }
    }

    super.initState();
  }

  _DataGridSettings get _dataGridSettings => widget.dataGridStateDetails();

  _VisualContainerHelper get _container => _dataGridSettings.container;

  _RowGenerator get _rowGenerator => _dataGridSettings.rowGenerator;

  SelectionManagerBase get _rowSelectionManager =>
      _dataGridSettings.rowSelectionManager;

  void _verticalListener() {
    setState(() {
      final double newValue = _verticalController!.offset;
      _container.verticalOffset = newValue;
      _container.setRowHeights();
      _container.resetSwipeOffset();
      _isScrolling = true;
      _container._isDirty = true;
      _dataGridSettings.scrollingState = ScrollDirection.forward;
      _isLoadMoreViewLoaded = false;
    });
  }

  void _horizontalListener() {
    setState(() {
      final double newValue = _horizontalController!.offset;
      _container.horizontalOffset = newValue;
      // Updating the width of all columns initially and inside the
      // `ScrollViewWidget` build method when setting the container_isDirty to
      // `true`. Thus, Don't necessary to update column widths while horizontal
      // scrolling.
      // _dataGridSettings.columnSizer._refresh(widget.width);
      _container.resetSwipeOffset();
      _dataGridSettings.scrollingState = ScrollDirection.forward;
      _isScrolling = true;
      _container._isDirty = true;
    });
  }

  void _updateAxis() {
    final double width = _width;
    final double height = _height;
    _container.updateAxis(Size(width, height));
  }

  void _setHorizontalOffset() {
    if (_container._needToSetHorizontalOffset) {
      _container.horizontalOffset = _horizontalController!.hasClients
          ? _horizontalController!.offset
          : 0.0;
      _container.scrollColumns.markDirty();
    }

    _container._needToSetHorizontalOffset = false;
  }

  void _updateColumnSizer() {
    final ColumnSizer columnSizer = _dataGridSettings.columnSizer;
    if (columnSizer._isColumnSizerLoadedInitially) {
      columnSizer
        .._initialRefresh(widget.width)
        .._isColumnSizerLoadedInitially = false;
    } else {
      columnSizer._refresh(widget.width);
    }
  }

  void _ensureWidgets() {
    if (!_container._isPreGenerator) {
      _container.preGenerateItems();
    } else {
      if (_container._needToRefreshColumn) {
        _ensureItems(true);
        _container._needToRefreshColumn = false;
      } else {
        _ensureItems(false);
      }
    }
  }

  void _ensureItems(bool needToRefresh) {
    final _VisibleLinesCollection visibleRows =
        _container.scrollRows.getVisibleLines();
    final _VisibleLinesCollection visibleColumns =
        _SfDataGridHelper.getVisibleLines(_rowGenerator.dataGridStateDetails());

    if (_container._isGridLoaded && visibleColumns.isNotEmpty) {
      _rowGenerator._ensureRows(visibleRows, visibleColumns);
    }

    if (needToRefresh) {
      if (visibleColumns.isNotEmpty) {
        _rowGenerator._ensureColumns(visibleColumns);
      }
    }
  }

  Widget _buildScrollView(double extentWidth, double scrollViewHeight,
      double extentHeight, Size containerSize) {
    Widget scrollView = Scrollbar(
      isAlwaysShown: _dataGridSettings.isScrollbarAlwaysShown,
      controller: _verticalController,
      child: SingleChildScrollView(
        controller: _verticalController,
        physics: _dataGridSettings.isSwipingApplied
            ? const NeverScrollableScrollPhysics()
            : _dataGridSettings.verticalScrollPhysics,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: min(scrollViewHeight, extentHeight)),
          child: Scrollbar(
            isAlwaysShown: _dataGridSettings.isScrollbarAlwaysShown,
            controller: _horizontalController,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              physics: _dataGridSettings.isSwipingApplied
                  ? const NeverScrollableScrollPhysics()
                  : _dataGridSettings.horizontalScrollPhysics,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: min(_width, extentWidth)),
                child: _VisualContainer(
                  key: const ValueKey<String>('SfDataGrid-VisualContainer'),
                  isDirty: _container._isDirty,
                  rowGenerator: _rowGenerator,
                  containerSize: containerSize,
                  dataGridSettings: _dataGridSettings,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_dataGridSettings.allowPullToRefresh) {
      scrollView = RefreshIndicator(
        child: scrollView,
        key: _dataGridSettings.refreshIndicatorKey,
        onRefresh: _dataGridSettings.source.handleRefresh,
        strokeWidth: _dataGridSettings.refreshIndicatorStrokeWidth,
        displacement: _dataGridSettings.refreshIndicatorDisplacement,
      );
    }

    return scrollView;
  }

  void _addScrollView(List<Widget> children) {
    final double extentWidth = _container.extentWidth;
    final double headerRowsHeight = _container.scrollRows
        .rangeToRegionPoints(0, _dataGridSettings.headerLineCount - 1, true)[1]
        .length;
    final double extentHeight = _container.extentHeight - headerRowsHeight;
    final double scrollViewHeight = _height - headerRowsHeight;

    final Size containerSize = Size(
        _canDisableHorizontalScrolling(_dataGridSettings)
            ? _width
            : max(_width, extentWidth),
        _canDisableVerticalScrolling(_dataGridSettings)
            ? scrollViewHeight
            : (extentHeight > scrollViewHeight
                ? extentHeight
                : scrollViewHeight));

    final Widget scrollView = _buildScrollView(
        extentWidth, scrollViewHeight, extentHeight, containerSize);

    final Positioned wrapScrollView = Positioned.fill(
      top: headerRowsHeight,
      child: scrollView,
    );

    children.add(wrapScrollView);
  }

  void _addHeaderRows(List<Widget> children) {
    final double containerWidth =
        _canDisableHorizontalScrolling(_dataGridSettings)
            ? _width
            : max(_width, _container.extentWidth);

    List<Widget> _buildHeaderRows() {
      final List<Widget> headerRows = <Widget>[];
      if (_dataGridSettings.stackedHeaderRows.isNotEmpty) {
        headerRows.addAll(_rowGenerator.items
            .where((DataRowBase rows) =>
                rows.rowRegion == RowRegion.header &&
                rows.rowType == RowType.stackedHeaderRow)
            .map<Widget>((DataRowBase dataRow) => _HeaderCellsWidget(
                  key: dataRow._key!,
                  dataRow: dataRow,
                  isDirty: _container._isDirty || dataRow._isDirty,
                ))
            .toList(growable: false));
      }
      headerRows.addAll(_rowGenerator.items
          .where((DataRowBase rows) =>
              rows.rowRegion == RowRegion.header &&
              rows.rowType == RowType.headerRow)
          .map<Widget>((DataRowBase dataRow) => _HeaderCellsWidget(
                key: dataRow._key!,
                dataRow: dataRow,
                isDirty: _container._isDirty || dataRow._isDirty,
              ))
          .toList(growable: false));
      return headerRows;
    }

    double getStartX() {
      if (_dataGridSettings.textDirection == TextDirection.ltr) {
        return -_container.horizontalOffset;
      } else {
        if (!_horizontalController!.hasClients ||
            _horizontalController!.offset <= 0.0 ||
            _horizontalController!.position.maxScrollExtent <= 0.0 ||
            _container.extentWidth <= _width) {
          return 0.0;
        } else if (_horizontalController!.position.maxScrollExtent ==
            _horizontalController!.offset) {
          return -_horizontalController!.position.maxScrollExtent;
        }

        return -(_horizontalController!.position.maxScrollExtent -
            _container.horizontalOffset);
      }
    }

    if (_rowGenerator.items.isNotEmpty) {
      final List<Widget> headerRows = _buildHeaderRows();
      for (int i = 0; i < headerRows.length; i++) {
        final _VisibleLineInfo? lineInfo =
            _container.scrollRows.getVisibleLineAtLineIndex(i);
        final Positioned header = Positioned.directional(
            textDirection: _dataGridSettings.textDirection,
            start: getStartX(),
            top: lineInfo?.origin,
            height: lineInfo?.size,
            // FLUT-1971 Changed the header row widget as extendwidth instead of
            // device width to resloved the issue of apply sorting to the
            // invisible columns.
            width: containerWidth,
            child: headerRows[i]);
        children.add(header);
      }
    }
  }

  void _addLoadMoreView(List<Widget> children) {
    Future<void> loadMoreRows() async {
      _isLoadMoreViewLoaded = true;
      await _dataGridSettings.source.handleLoadMoreRows();
    }

    if (_verticalController!.hasClients &&
        _dataGridSettings.loadMoreViewBuilder != null) {
      // FLUT-3038 Need to restrict load more view when rows exist within the
      // view height.
      if ((_verticalController!.position.maxScrollExtent > 0.0) &&
          (_verticalController!.offset >=
              _verticalController!.position.maxScrollExtent) &&
          !_isLoadMoreViewLoaded) {
        final Widget? loadMoreView =
            _dataGridSettings.loadMoreViewBuilder!(context, loadMoreRows);

        if (loadMoreView != null) {
          final Alignment loadMoreAlignment =
              _dataGridSettings.textDirection == TextDirection.ltr
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight;

          children.add(Positioned(
              top: 0.0,
              width: _width,
              height: _height,
              child: Align(
                alignment: loadMoreAlignment,
                child: loadMoreView,
              )));
        }
      }
    }
  }

  void _addFreezePaneLinesElevation(List<Widget> children) {
    final SfDataGridThemeData? dataGridThemeData =
        _dataGridSettings.dataGridThemeData;
    if (dataGridThemeData!.frozenPaneElevation <= 0.0 ||
        _dataGridSettings.columns.isEmpty ||
        _dataGridSettings.source._effectiveRows.isEmpty) {
      return;
    }

    void drawElevation({
      EdgeInsets? margin,
      double? bottom,
      double? start,
      double? end,
      double? top,
      Axis? axis,
    }) {
      final Widget elevationLine = ClipRect(
          child: Container(
              width: axis == Axis.vertical ? 1 : 0,
              height: axis == Axis.horizontal ? 1 : 0,
              margin: margin,
              decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: dataGridThemeData.brightness == Brightness.light
                          ? const Color(0x3D000000)
                          : const Color(0x3DFFFFFF),
                      offset: Offset.zero,
                      spreadRadius: 3.0,
                      blurRadius: dataGridThemeData.frozenPaneElevation,
                    )
                  ])));

      children.add(Positioned.directional(
        top: top,
        end: end,
        start: start,
        bottom: bottom,
        child: elevationLine,
        textDirection: _dataGridSettings.textDirection,
      ));
    }

    double getTopPosition(DataRowBase columnHeaderRow, int columnIndex) {
      double top = 0.0;
      if (_dataGridSettings.stackedHeaderRows.isNotEmpty) {
        top = columnHeaderRow._getRowHeight(
            0, _dataGridSettings.stackedHeaderRows.length - 1);
        final DataCellBase? dataCell = columnHeaderRow._visibleColumns
            .firstWhereOrNull(
                (DataCellBase cell) => cell.columnIndex == columnIndex);
        // Need to ignore header cell spanned height from the total stacked
        // header rows height if it is spanned.
        if (dataCell != null && dataCell._rowSpan > 0) {
          top -= columnHeaderRow._getRowHeight(
              dataCell.rowIndex - dataCell._rowSpan, dataCell.rowIndex - 1);
        }
      }
      return top;
    }

    // The field remainingViewPortHeight and remainingViewPortWidth are used to
    // restrict the elevation height and width fill in the entire screen when
    // extent width and height is smaller than the view size.
    final double remainingViewPortHeight =
        (_dataGridSettings.container.extentHeight < _height)
            ? _height - _dataGridSettings.container.extentHeight
            : 0.0;
    final double remainingViewPortWidth =
        (_dataGridSettings.container.extentWidth < _width)
            ? _width - _dataGridSettings.container.extentWidth
            : 0.0;

    final DataRowBase? columnHeaderRow =
        _dataGridSettings.container.rowGenerator.items.firstWhereOrNull(
            (DataRowBase row) => row.rowType == RowType.headerRow);

    // Provided the margin to allow shadow only to the corresponding side.
    // In 4.0 pixels, 1.0 pixel defines the size of the container and
    // 3.0 pixels defines the amount of spreadRadius.
    final double margin = dataGridThemeData.frozenPaneElevation + 4.0;

    final int frozenColumnIndex =
        _GridIndexResolver.getLastFrozenColumnIndex(_dataGridSettings);
    final int footerFrozenColumnIndex =
        _GridIndexResolver.getStartFooterFrozenColumnIndex(_dataGridSettings);
    final int frozenRowIndex =
        _GridIndexResolver.getLastFrozenRowIndex(_dataGridSettings);
    final int footerFrozenRowIndex =
        _GridIndexResolver.getStartFooterFrozenRowIndex(_dataGridSettings);

    if (columnHeaderRow != null &&
        frozenColumnIndex >= 0 &&
        !_canDisableHorizontalScrolling(_dataGridSettings)) {
      final double top = getTopPosition(columnHeaderRow, frozenColumnIndex);
      final double left = columnHeaderRow._getColumnWidth(
          0, _dataGridSettings.frozenColumnsCount - 1);

      drawElevation(
          top: top,
          start: left,
          bottom: remainingViewPortHeight,
          axis: Axis.horizontal,
          margin: _dataGridSettings.textDirection == TextDirection.rtl
              ? EdgeInsets.only(left: margin)
              : EdgeInsets.only(right: margin));
    }

    if (columnHeaderRow != null &&
        footerFrozenColumnIndex >= 0 &&
        !_canDisableHorizontalScrolling(_dataGridSettings)) {
      final double top =
          getTopPosition(columnHeaderRow, footerFrozenColumnIndex);
      final double right = columnHeaderRow._getColumnWidth(
          footerFrozenColumnIndex, _dataGridSettings.container.columnCount);

      drawElevation(
          top: top,
          bottom: remainingViewPortHeight,
          end: right + remainingViewPortWidth,
          axis: Axis.horizontal,
          margin: _dataGridSettings.textDirection == TextDirection.rtl
              ? EdgeInsets.only(right: margin)
              : EdgeInsets.only(left: margin));
    }

    if (columnHeaderRow != null &&
        frozenRowIndex >= 0 &&
        !_canDisableVerticalScrolling(_dataGridSettings)) {
      final double top = columnHeaderRow._getRowHeight(0, frozenRowIndex);

      drawElevation(
          top: top,
          start: 0.0,
          end: remainingViewPortWidth,
          axis: Axis.vertical,
          margin: EdgeInsets.only(bottom: margin));
    }

    if (columnHeaderRow != null &&
        footerFrozenRowIndex >= 0 &&
        !_canDisableVerticalScrolling(_dataGridSettings)) {
      final double bottom = columnHeaderRow._getRowHeight(
          footerFrozenRowIndex, _dataGridSettings.container.rowCount);

      drawElevation(
          start: 0.0,
          end: remainingViewPortWidth,
          axis: Axis.vertical,
          bottom: bottom + remainingViewPortHeight,
          margin: EdgeInsets.only(top: margin));
    }
  }

  void _handleSelectionController() {
    setState(() {
      /* Rebuild the DataGrid when the selection or currentcell is processed. */
    });
  }

  // -------------------------------------------------------------------------
  // Below method and callback are used in [RawKeyboardListener] widget.
  // Due to break on [FocusNode.onKey] callback after flutter 2.2.0.
  // So, instead of using the [RawKeyboardListener] we replaced with [Focus]
  // widget to adapt our all use case on key navigation. Need to remove the Focus
  // widget and its related method and callback when the below mentioned github
  // issue resolved on framework end.
  // [https://github.com/flutter/flutter/issues/83023]
  //---------------------------------------------------------------------------

  // KeyEventResult _handleFocusKeyOperation(FocusNode focusNode, RawKeyEvent e) {
  //   final _DataGridSettings dataGridSettings = _dataGridSettings;
  //   final _CurrentCellManager currentCell = dataGridSettings.currentCell;
  //
  //   KeyEventResult needToMoveFocus() {
  //     bool canAllowToRemoveFocus(int rowIndex, int columnIndex) =>
  //         (dataGridSettings.navigationMode == GridNavigationMode.cell &&
  //             currentCell.rowIndex == rowIndex &&
  //             currentCell.columnIndex == columnIndex) ||
  //         (dataGridSettings.navigationMode == GridNavigationMode.row &&
  //             currentCell.rowIndex == rowIndex) ||
  //         (!_dataGridFocusNode!.hasPrimaryFocus && currentCell.isEditing);
  //
  //     if (e.isShiftPressed) {
  //       final int firstRowIndex =
  //           _SelectionHelper.getFirstRowIndex(_dataGridSettings);
  //       final int firstCellIndex =
  //           _SelectionHelper.getFirstCellIndex(_dataGridSettings);
  //
  //       if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     } else {
  //       final int lastRowIndex =
  //           _SelectionHelper.getLastNavigatingRowIndex(_dataGridSettings);
  //       final int lastCellIndex =
  //           _SelectionHelper.getLastCellIndex(_dataGridSettings);
  //
  //       if (canAllowToRemoveFocus(lastRowIndex, lastCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     }
  //   }
  //
  //   if (e.logicalKey == LogicalKeyboardKey.tab) {
  //     return needToMoveFocus();
  //   } else {
  //     return _handleKeys(e);
  //   }
  // }

  // KeyEventResult _handleKeyOperation(
  //     FocusNode focusNode, RawKeyEvent keyEvent) {
  //   final _DataGridSettings dataGridSettings = _dataGridSettings;
  //   final _CurrentCellManager currentCell = dataGridSettings.currentCell;
  //
  //   KeyEventResult needToMoveFocus() {
  //     bool canAllowToRemoveFocus(int rowIndex, int columnIndex) =>
  //         (dataGridSettings.navigationMode == GridNavigationMode.cell &&
  //             currentCell.rowIndex == rowIndex &&
  //             currentCell.columnIndex == columnIndex) ||
  //         (dataGridSettings.navigationMode == GridNavigationMode.row &&
  //             currentCell.rowIndex == rowIndex) ||
  //         (!_dataGridFocusNode!.hasPrimaryFocus && currentCell.isEditing);
  //
  //     if (e.isShiftPressed) {
  //       final int firstRowIndex =
  //           _SelectionHelper.getFirstRowIndex(_dataGridSettings);
  //       final int firstCellIndex =
  //           _SelectionHelper.getFirstCellIndex(_dataGridSettings);
  //
  //       if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     } else {
  //       final int lastRowIndex =
  //           _SelectionHelper.getLastNavigatingRowIndex(_dataGridSettings);
  //       final int lastCellIndex =
  //           _SelectionHelper.getLastCellIndex(_dataGridSettings);
  //
  //       if (canAllowToRemoveFocus(lastRowIndex, lastCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     }
  //   }
  //
  //   if (e.logicalKey == LogicalKeyboardKey.tab) {
  //     return needToMoveFocus();
  //   } else {
  //     return _handleKeys(e);
  //   }
  // }

  // KeyEventResult _handleKeys(RawKeyEvent keyEvent) {
  //   final _CurrentCellManager currentCell = _dataGridSettings.currentCell;
  //   if (_dataGridSettings.allowEditing &&
  //       currentCell.isEditing &&
  //       !_dataGridFocusNode!.hasPrimaryFocus) {
  //     if (keyEvent.logicalKey == LogicalKeyboardKey.tab ||
  //         keyEvent.logicalKey == LogicalKeyboardKey.escape ||
  //         keyEvent.logicalKey == LogicalKeyboardKey.arrowDown ||
  //         keyEvent.logicalKey == LogicalKeyboardKey.arrowUp ||
  //         keyEvent.logicalKey == LogicalKeyboardKey.pageUp ||
  //         keyEvent.logicalKey == LogicalKeyboardKey.pageDown) {
  //       return KeyEventResult.handled;
  //     }
  //   }
  //
  //   return _dataGridFocusNode!.hasPrimaryFocus
  //       ? KeyEventResult.handled
  //       : KeyEventResult.ignored;
  // }

  // --------------------------------------------------------------------------

  KeyEventResult _handleKeyOperation(
      FocusNode focusNode, RawKeyEvent keyEvent) {
    final _DataGridSettings dataGridSettings = _dataGridSettings;
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;

    void processKeys() {
      if (keyEvent.runtimeType == RawKeyDownEvent) {
        _rowSelectionManager.handleKeyEvent(keyEvent);
        if (keyEvent.isControlPressed) {
          dataGridSettings.isControlKeyPressed = true;
        }
      }
      if (keyEvent.runtimeType == RawKeyUpEvent) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.controlLeft ||
            keyEvent.logicalKey == LogicalKeyboardKey.controlRight) {
          dataGridSettings.isControlKeyPressed = false;
        }
      }
    }

    // Move to the next focusable widget when it reach the last and first
    // [DataGridCell] on tab & shift + tab key.
    KeyEventResult needToMoveFocus() {
      bool canAllowToRemoveFocus(int rowIndex, int columnIndex) =>
          (dataGridSettings.navigationMode == GridNavigationMode.cell &&
              currentCell.rowIndex == rowIndex &&
              currentCell.columnIndex == columnIndex) ||
          (dataGridSettings.navigationMode == GridNavigationMode.row &&
              currentCell.rowIndex == rowIndex) ||
          (!_dataGridFocusNode!.hasPrimaryFocus && currentCell.isEditing);

      if (keyEvent.isShiftPressed) {
        final int firstRowIndex =
            _SelectionHelper.getFirstRowIndex(_dataGridSettings);
        final int firstCellIndex =
            _SelectionHelper.getFirstCellIndex(_dataGridSettings);

        if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
          return KeyEventResult.ignored;
        } else {
          return KeyEventResult.handled;
        }
      } else {
        final int lastRowIndex =
            _SelectionHelper.getLastNavigatingRowIndex(_dataGridSettings);
        final int lastCellIndex =
            _SelectionHelper.getLastCellIndex(_dataGridSettings);

        if (canAllowToRemoveFocus(lastRowIndex, lastCellIndex)) {
          return KeyEventResult.ignored;
        } else {
          return KeyEventResult.handled;
        }
      }
    }

    if (_dataGridFocusNode!.hasPrimaryFocus) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.tab &&
          needToMoveFocus() != KeyEventResult.handled) {
        return KeyEventResult.ignored;
      }

      processKeys();
      return KeyEventResult.handled;
    } else {
      // On Editing, we have to handle below [LogicalKeyboardKey]'s. For, that
      // we have return [KeyEventResult.handled] to handle those keys on
      // editing.
      if (_dataGridSettings.allowEditing &&
          currentCell.isEditing &&
          !_dataGridFocusNode!.hasPrimaryFocus) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.tab ||
            keyEvent.logicalKey == LogicalKeyboardKey.escape ||
            keyEvent.logicalKey == LogicalKeyboardKey.arrowDown ||
            keyEvent.logicalKey == LogicalKeyboardKey.arrowUp ||
            keyEvent.logicalKey == LogicalKeyboardKey.pageUp ||
            keyEvent.logicalKey == LogicalKeyboardKey.pageDown ||
            keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          processKeys();
          return KeyEventResult.handled;
        }
      }

      return KeyEventResult.ignored;
    }
  }

  @override
  void didUpdateWidget(_ScrollViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        _container._needToSetHorizontalOffset) {
      /// Need not to change the height when onScreenKeyboard appears.
      /// Cause: If we change the height on editing, editable widget will not move
      /// above the onScreenKeyboard on mobile platforms.
      final bool needToResizeHeight = !_dataGridSettings._isDesktop &&
          _dataGridSettings.currentCell.isEditing;

      _width = widget.width;
      _height = !needToResizeHeight ? widget.height : _height;
      _container
        .._needToSetHorizontalOffset = true
        .._isDirty = true;
      if (oldWidget.width != widget.width ||
          oldWidget.height != widget.height) {
        _container.resetSwipeOffset();
      }
      // FLUT-2047 Need to mark all visible rows height as dirty when DataGrid
      // size is changed if onQueryRowHeight is not null.
      if (oldWidget.width != widget.width &&
          _dataGridSettings.onQueryRowHeight != null) {
        _container.rowHeightManager.reset();
      }
    }

    if (_verticalController !=
        widget.dataGridStateDetails().verticalScrollController) {
      _verticalController!.removeListener(_verticalListener);
      _verticalController =
          widget.dataGridStateDetails().verticalScrollController ??
              ScrollController();
      _verticalController!.addListener(_verticalListener);
    }

    if (_horizontalController !=
        widget.dataGridStateDetails().horizontalScrollController) {
      _horizontalController!.removeListener(_horizontalListener);
      _horizontalController =
          widget.dataGridStateDetails().horizontalScrollController ??
              ScrollController();
      _horizontalController!.addListener(_horizontalListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_container._isDirty && !_isScrolling) {
      _updateAxis();
      _updateColumnSizer();
      _container
        ..setRowHeights()
        .._needToRefreshColumn = true;
    }

    if (_container._needToSetHorizontalOffset) {
      _setHorizontalOffset();
    }

    if (_container._isDirty) {
      _ensureWidgets();
    }

    final List<Positioned> children = <Positioned>[];

    _addHeaderRows(children);

    _addScrollView(children);

    _addFreezePaneLinesElevation(children);

    _addLoadMoreView(children);

    _container._isDirty = false;
    _isScrolling = false;

    // return RawKeyboardListener(
    //     focusNode: _dataGridFocusNode!,
    //     onKey: _handleKeyOperation,
    //     child: Container(
    //         height: _height,
    //         width: _width,
    //         decoration: const BoxDecoration(
    //           color: Colors.transparent,
    //         ),
    //         clipBehavior: Clip.antiAlias,
    //         child: _dataGridSettings.allowColumnsResizing
    //             ? _wrapInsideGestureDetector(children)
    //             : _wrapInsideStack(children)));

    // [FocusNode.onKey] callback is not firing on key navigation after flutter
    // 2.2.0 and its breaking our key navigation on tab, shift + tab, arrow keys.
    // So, we have used the focus widget. Need to remove [Focus] widget when
    // below mentioned issue is resolved on framework end.
    // [https://github.com/flutter/flutter/issues/83023]
    return Focus(
      focusNode: _dataGridFocusNode,
      onKey: _handleKeyOperation,
      child: Container(
        height: _height,
        width: _width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        child: _wrapInsideStack(children),
      ),
    );
  }

  Widget _wrapInsideStack(List<Positioned> children) {
    return Stack(
        fit: StackFit.passthrough, children: List<Positioned>.from(children));
  }

  @override
  void dispose() {
    if (_verticalController != null) {
      _verticalController!
        ..removeListener(_verticalListener)
        ..dispose();
    }

    if (_horizontalController != null) {
      _horizontalController!
        ..removeListener(_horizontalListener)
        ..dispose();
    }

    super.dispose();
  }
}

bool _canDisableVerticalScrolling(_DataGridSettings dataGridSettings) {
  final _VisualContainerHelper container = dataGridSettings.container;
  return (container.scrollRows.headerExtent +
          container.scrollRows.footerExtent) >
      dataGridSettings.viewHeight;
}

bool _canDisableHorizontalScrolling(_DataGridSettings dataGridSettings) {
  final _VisualContainerHelper container = dataGridSettings.container;
  return (container.scrollColumns.headerExtent +
          container.scrollColumns.footerExtent) >
      dataGridSettings.viewWidth;
}
