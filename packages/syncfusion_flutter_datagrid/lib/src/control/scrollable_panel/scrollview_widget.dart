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
    _verticalController = ScrollController()..addListener(_verticalListener);
    _horizontalController = ScrollController()
      ..addListener(_horizontalListener);

    _height = widget.height;
    _width = widget.width;
    _dataGridSettings
      ..verticalController = _verticalController
      ..horizontalController = _horizontalController;

    _dataGridSettings.rowSelectionManager
        .addListener(_handleSelectionController);

    if (_dataGridFocusNode == null) {
      _dataGridFocusNode = FocusNode(onKey: _handleFocusKeyOperation);
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
      final newValue = _verticalController!.offset;
      _container.verticalOffset = newValue;
      _container.setRowHeights();
      _container.resetSwipeOffset();
      _isScrolling = true;
      _container._isDirty = true;
      _isLoadMoreViewLoaded = false;
    });
  }

  void _horizontalListener() {
    setState(() {
      final newValue = _horizontalController!.offset;
      _container.horizontalOffset = newValue;
      _dataGridSettings.columnSizer._refresh(widget.width);
      _container.resetSwipeOffset();
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
    final columnSizer = _dataGridSettings.columnSizer;
    if (columnSizer._isColumnSizerLoadedInitially) {
      columnSizer
        .._initialRefresh(widget.width)
        .._isColumnSizerLoadedInitially = false;
    } else {
      columnSizer._refresh(widget.width);
    }
  }

  void _ensureWidgets() {
    if (_dataGridSettings.source._effectiveRows.isEmpty) {
      return;
    }

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
            ? NeverScrollableScrollPhysics()
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
                  ? NeverScrollableScrollPhysics()
                  : _dataGridSettings.horizontalScrollPhysics,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: min(_width, extentWidth)),
                child: _VisualContainer(
                  key: ValueKey('SfDataGrid-VisualContainer'),
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
      final List<Widget> headerRows = [];
      if (_dataGridSettings.stackedHeaderRows.isNotEmpty) {
        headerRows.addAll(_rowGenerator.items
            .where((rows) =>
                rows.rowRegion == RowRegion.header &&
                rows.rowType == RowType.stackedHeaderRow)
            .map<Widget>((dataRow) => _HeaderCellsWidget(
                  key: dataRow._key!,
                  dataRow: dataRow,
                  isDirty: _container._isDirty || dataRow._isDirty,
                ))
            .toList(growable: false));
      }
      headerRows.addAll(_rowGenerator.items
          .where((rows) =>
              rows.rowRegion == RowRegion.header &&
              rows.rowType == RowType.headerRow)
          .map<Widget>((dataRow) => _HeaderCellsWidget(
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
        final lineInfo = _container.scrollRows.getVisibleLineAtLineIndex(i);
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
          final loadMoreAlignment =
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
    final dataGridThemeData = _dataGridSettings.dataGridThemeData;
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
      final elevationLine = ClipRect(
          child: Container(
              width: axis == Axis.vertical ? 1 : 0,
              height: axis == Axis.horizontal ? 1 : 0,
              margin: margin,
              decoration: BoxDecoration(color: Color(0xFF000000), boxShadow: [
                BoxShadow(
                  color: dataGridThemeData.brightness == Brightness.light
                      ? Color(0x3D000000)
                      : Color(0x3DFFFFFF),
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
            .firstWhereOrNull((cell) => cell.columnIndex == columnIndex);
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
    final remainingViewPortHeight =
        (_dataGridSettings.container.extentHeight < _height)
            ? _height - _dataGridSettings.container.extentHeight
            : 0.0;
    final remainingViewPortWidth =
        (_dataGridSettings.container.extentWidth < _width)
            ? _width - _dataGridSettings.container.extentWidth
            : 0.0;

    final DataRowBase? columnHeaderRow = _dataGridSettings
        .container.rowGenerator.items
        .firstWhereOrNull((row) => row.rowType == RowType.headerRow);

    // Provided the margin to allow shadow only to the corresponding side.
    // In 4.0 pixels, 1.0 pixel defines the size of the container and
    // 3.0 pixels defines the amount of spreadRadius.
    final double margin = dataGridThemeData.frozenPaneElevation + 4.0;

    final frozenColumnIndex =
        _GridIndexResolver.getLastFrozenColumnIndex(_dataGridSettings);
    final footerFrozenColumnIndex =
        _GridIndexResolver.getStartFooterFrozenColumnIndex(_dataGridSettings);
    final frozenRowIndex =
        _GridIndexResolver.getLastFrozenRowIndex(_dataGridSettings);
    final footerFrozenRowIndex =
        _GridIndexResolver.getStartFooterFrozenRowIndex(_dataGridSettings);

    if (columnHeaderRow != null &&
        frozenColumnIndex >= 0 &&
        !_canDisableHorizontalScrolling(_dataGridSettings)) {
      final top = getTopPosition(columnHeaderRow, frozenColumnIndex);
      final left = columnHeaderRow._getColumnWidth(
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
      final top = getTopPosition(columnHeaderRow, footerFrozenColumnIndex);
      final right = columnHeaderRow._getColumnWidth(
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
      final top = columnHeaderRow._getRowHeight(0, frozenRowIndex);

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
      final bottom = columnHeaderRow._getRowHeight(
          footerFrozenRowIndex, _dataGridSettings.container.rowCount);

      drawElevation(
          start: 0.0,
          end: remainingViewPortWidth,
          axis: Axis.vertical,
          bottom: bottom + remainingViewPortHeight,
          margin: EdgeInsets.only(top: margin));
    }
  }

  void _handleSelectionController() async {
    setState(() {
      /* Rebuild the DataGrid when the selection or currentcell is processed. */
    });
  }

  bool _handleFocusKeyOperation(FocusNode focusNode, RawKeyEvent e) {
    bool needToMoveFocus() {
      final _DataGridSettings dataGridSettings = _dataGridSettings;

      bool canAllowToRemoveFocus(int rowIndex, int columnIndex) =>
          (dataGridSettings.navigationMode == GridNavigationMode.cell &&
              _dataGridSettings.currentCell.rowIndex == rowIndex &&
              _dataGridSettings.currentCell.columnIndex == columnIndex) ||
          (dataGridSettings.navigationMode == GridNavigationMode.row &&
              _dataGridSettings.currentCell.rowIndex == rowIndex) ||
          !_dataGridFocusNode!.hasPrimaryFocus;

      if (e.isShiftPressed) {
        final firstRowIndex =
            _SelectionHelper.getFirstRowIndex(_dataGridSettings);
        final firstCellIndex =
            _SelectionHelper.getFirstCellIndex(_dataGridSettings);

        if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
          return false;
        } else {
          return true;
        }
      } else {
        final lastRowIndex =
            _SelectionHelper.getLastNavigatingRowIndex(_dataGridSettings);
        final lastCellIndex =
            _SelectionHelper.getLastCellIndex(_dataGridSettings);

        if (canAllowToRemoveFocus(lastRowIndex, lastCellIndex)) {
          return false;
        } else {
          return true;
        }
      }
    }

    if (e.logicalKey == LogicalKeyboardKey.tab) {
      return needToMoveFocus();
    } else {
      return _dataGridFocusNode!.hasPrimaryFocus;
    }
  }

  void _handleKeyOperation(RawKeyEvent e) {
    if (_dataGridFocusNode!.hasPrimaryFocus) {
      if (e.runtimeType == RawKeyDownEvent) {
        _rowSelectionManager.handleKeyEvent(e);
        if (e.isControlPressed) {
          _dataGridSettings.isControlKeyPressed = true;
        }
      }
      if (e.runtimeType == RawKeyUpEvent) {
        if (e.logicalKey == LogicalKeyboardKey.controlLeft ||
            e.logicalKey == LogicalKeyboardKey.controlRight) {
          _dataGridSettings.isControlKeyPressed = false;
        }
      }
    }
  }

  @override
  void didUpdateWidget(_ScrollViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        _container._needToSetHorizontalOffset) {
      _width = widget.width;
      _height = widget.height;
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

    final List<Positioned> children = [];

    _addHeaderRows(children);

    _addScrollView(children);

    _addFreezePaneLinesElevation(children);

    _addLoadMoreView(children);

    _container._isDirty = false;
    _isScrolling = false;

    return RawKeyboardListener(
        focusNode: _dataGridFocusNode!,
        onKey: _handleKeyOperation,
        child: Container(
            height: _height,
            width: _width,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
                fit: StackFit.passthrough, children: List.from(children))));
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
  final _VisualContainerHelper? container = dataGridSettings.container;
  if (container != null) {
    return (container.scrollRows.headerExtent +
            container.scrollRows.footerExtent) >
        dataGridSettings.viewHeight;
  } else {
    return false;
  }
}

bool _canDisableHorizontalScrolling(_DataGridSettings dataGridSettings) {
  final _VisualContainerHelper? container = dataGridSettings.container;
  if (container != null) {
    return (container.scrollColumns.headerExtent +
            container.scrollColumns.footerExtent) >
        dataGridSettings.viewWidth;
  } else {
    return false;
  }
}
