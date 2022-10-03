import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide DataCell, DataRow;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../grid_common/line_size_host.dart';
import '../../grid_common/scroll_axis.dart';
import '../../grid_common/scrollbar.dart';
import '../../grid_common/visible_line_info.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../helper/selection_helper.dart' as selection_helper;
import '../runtime/column.dart';
import '../runtime/generator.dart';
import '../selection/selection_manager.dart';
import '../sfdatagrid.dart';
import 'rendering_widget.dart';

/// A [StatefulWidget] that build all the data grid views from the widget level.
class ScrollViewWidget extends StatefulWidget {
  /// Creates a [ScrollViewWidget] for the [SfDataGrid].
  const ScrollViewWidget(
      {required this.width,
      required this.height,
      required this.dataGridStateDetails});

  /// The parent width of the datagid.
  final double width;

  /// The parent height of the datagid.
  final double height;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  State<StatefulWidget> createState() => _ScrollViewWidgetState();
}

class _ScrollViewWidgetState extends State<ScrollViewWidget> {
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
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    _verticalController = dataGridConfiguration.verticalScrollController;
    _verticalController!.addListener(_verticalListener);
    _horizontalController = dataGridConfiguration.horizontalScrollController;
    _horizontalController!.addListener(_horizontalListener);
    _height = widget.height;
    _width = widget.width;

    dataGridConfiguration.rowSelectionManager
        .addListener(_handleSelectionController);

    if (_dataGridFocusNode == null) {
      // [FocusNode.onKey] callback is not firing on key navigation after flutter
      // 2.2.0 and its breaking our key navigation on tab, shift + tab, arrow keys.
      // So, we have used the focus widget and its need to remove when below
      // mentioned issue is resolved on framework end.
      //_dataGridFocusNode = FocusNode(onKey: _handleFocusKeyOperation);
      _dataGridFocusNode = FocusNode();
      dataGridConfiguration.dataGridFocusNode = _dataGridFocusNode;
      if (dataGridConfiguration.source.sortedColumns.isNotEmpty) {
        _dataGridFocusNode!.requestFocus();
      }
    }

    super.initState();
  }

  DataGridConfiguration get _dataGridConfiguration =>
      widget.dataGridStateDetails();

  VisualContainerHelper get _container => _dataGridConfiguration.container;

  RowGenerator get rowGenerator => _dataGridConfiguration.rowGenerator;

  SelectionManagerBase get _rowSelectionManager =>
      _dataGridConfiguration.rowSelectionManager;

  void _verticalListener() {
    setState(() {
      final double newValue = _verticalController!.offset;
      _container.verticalOffset = newValue;
      _container.setRowHeights();
      _container.resetSwipeOffset();
      _isScrolling = true;
      _container.isDirty = true;
      _dataGridConfiguration.scrollingState = ScrollDirection.forward;
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
      // DataGridSettings.columnSizer._refresh(widget.width);
      _container.resetSwipeOffset();
      _dataGridConfiguration.scrollingState = ScrollDirection.forward;
      if (!_dataGridConfiguration
          .columnResizeController.isResizeIndicatorVisible) {
        _isScrolling = true;
      }
      _container.isDirty = true;
    });
  }

  void _updateAxis() {
    final double width = _width;
    final double height = _height;
    _container.updateAxis(Size(width, height));
  }

  void _setHorizontalOffset() {
    if (_container.needToSetHorizontalOffset) {
      _container.horizontalOffset = _horizontalController!.hasClients
          ? _horizontalController!.offset
          : 0.0;
      _container.scrollColumns.markDirty();
    }

    _container.needToSetHorizontalOffset = false;
  }

  void _updateColumnSizer() {
    final ColumnSizer columnSizer = _dataGridConfiguration.columnSizer;
    if (isColumnSizerLoadedInitially(columnSizer)) {
      initialRefresh(columnSizer, widget.width);
      updateColumnSizerLoadedInitiallyFlag(columnSizer, false);
    } else {
      refreshColumnSizer(columnSizer, widget.width);
    }
  }

  void _ensureWidgets() {
    if (!_container.isPreGenerator) {
      _container._preGenerateItems();
    } else {
      if (_container.needToRefreshColumn) {
        _ensureItems(true);
        _container.needToRefreshColumn = false;
      } else {
        _ensureItems(false);
      }
    }
  }

  void _ensureItems(bool needToRefresh) {
    final VisibleLinesCollection visibleRows =
        _container.scrollRows.getVisibleLines();
    final VisibleLinesCollection visibleColumns =
        grid_helper.getVisibleLines(widget.dataGridStateDetails());

    if (_container.isGridLoaded && visibleColumns.isNotEmpty) {
      rowGenerator.ensureRows(visibleRows, visibleColumns);
    }

    if (needToRefresh) {
      if (visibleColumns.isNotEmpty) {
        rowGenerator.ensureColumns(visibleColumns);
      }
    }
  }

  Widget _buildScrollView(double extentWidth, double scrollViewHeight,
      double extentHeight, Size containerSize) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;

    // Issue:
    // FLUT-5857 - The horizontal scrollbar is not moving properly when scrolling
    // continuously through the scrollbar.
    //
    // Fix:
    // Issue occurred because of each scrollbar handles all the attached scrollbars
    // notifications. So, both scrollbars reacted to both scroll notifications.
    // We have fixed it by handling only to the respective scroll direction
    // based on the scrollbar.
    bool handleNotificationPredicate(
        ScrollNotification notification, Axis direction) {
      // Issue:
      // FLUT-6320 - Horizontal scrollbar is showing when typing the text in
      // TextField widget more than cell width in editing.
      //
      // Fix:
      // An issue occurred by reason of handling the `notificationPredicate` based
      // on the scroll direction. As the `notificationPredicate` callback will be
      // called for all the scrollable views, can't process with the scroll direction
      // alone. Hence, we have fixed the issue by considering the scroll view depth.
      return direction == Axis.vertical
          ? notification.depth == 0
          : notification.depth == 1;
    }

    // Issue:
    // FLUT-5857 - The exception is thrown when scrolling through the horizontal
    // scrollbar in web and desktop platforms.
    //
    // Fix:
    // Issue occurred due to the horizontal scrollbar listening to the vertical
    // controller. As per the flutter team suggestion, if add a scrollbar to the
    // parent of `SingleChildScrollView` in a nested scroll view, they can't be
    // identified and handled both scrollbar's notifications properly.
    // So, We have fixed the issue by moving both scrollbars to the parent of
    // both scroll views.
    // For more info: https://github.com/flutter/flutter/issues/70380#issuecomment-841502797
    Widget scrollView = Scrollbar(
      controller: _verticalController,
      thumbVisibility: dataGridConfiguration.isScrollbarAlwaysShown,
      notificationPredicate: (ScrollNotification notification) =>
          handleNotificationPredicate(notification, Axis.vertical),
      child: Scrollbar(
        controller: _horizontalController,
        thumbVisibility: dataGridConfiguration.isScrollbarAlwaysShown,
        notificationPredicate: (ScrollNotification notification) =>
            handleNotificationPredicate(notification, Axis.horizontal),
        child: SingleChildScrollView(
          controller: _verticalController,
          physics: dataGridConfiguration.isSwipingApplied
              ? const NeverScrollableScrollPhysics()
              : dataGridConfiguration.verticalScrollPhysics,
          child: ConstrainedBox(
            // FLUT-6553-BoxConstraints has a negative minimum height exception has been thrown.
            // we need to set height as 0 if it's negative value
            constraints: BoxConstraints(
                minHeight: max(0, min(scrollViewHeight, extentHeight))),
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              physics: dataGridConfiguration.isSwipingApplied
                  ? const NeverScrollableScrollPhysics()
                  : dataGridConfiguration.horizontalScrollPhysics,
              child: ConstrainedBox(
                // FLUT-6553-BoxConstraints has a negative minimum width exception has been thrown.
                // we need to set width as 0 if it's negative value
                constraints:
                    BoxConstraints(minWidth: max(0, min(_width, extentWidth))),
                child: _VisualContainer(
                  key: const ValueKey<String>('SfDataGrid-VisualContainer'),
                  isDirty: _container.isDirty,
                  rowGenerator: rowGenerator,
                  containerSize: containerSize,
                  dataGridStateDetails: widget.dataGridStateDetails,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_dataGridConfiguration.allowPullToRefresh) {
      scrollView = RefreshIndicator(
        key: dataGridConfiguration.refreshIndicatorKey,
        onRefresh: () => handleRefresh(dataGridConfiguration.source),
        strokeWidth: dataGridConfiguration.refreshIndicatorStrokeWidth,
        displacement: dataGridConfiguration.refreshIndicatorDisplacement,
        child: scrollView,
      );
    }

    return scrollView;
  }

  void _addScrollView(List<Widget> children) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    final double extentWidth = _container.extentWidth;
    final double headerRowsHeight = _container.scrollRows
        .rangeToRegionPoints(
            0, grid_helper.getHeaderIndex(dataGridConfiguration), true)[1]
        .length;
    final double extentHeight = _container.extentHeight - headerRowsHeight;
    final double scrollViewHeight = _height - headerRowsHeight;

    final Size containerSize = Size(
        _canDisableHorizontalScrolling(dataGridConfiguration)
            ? _width
            : max(_width, extentWidth),
        _canDisableVerticalScrolling(dataGridConfiguration)
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
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;

    final double containerWidth =
        _canDisableHorizontalScrolling(dataGridConfiguration)
            ? _width
            : max(_width, _container.extentWidth);

    List<Widget> buildHeaderRows() {
      final List<Widget> headerRows = <Widget>[];

      // Adds stacked header rows
      if (dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
        headerRows.addAll(rowGenerator.items
            .where((DataRowBase row) =>
                row.rowIndex >= 0 &&
                row.rowRegion == RowRegion.header &&
                row.rowType == RowType.stackedHeaderRow)
            .map<Widget>((DataRowBase dataRow) => _HeaderCellsWidget(
                  key: dataRow.key!,
                  dataRow: dataRow,
                  isDirty: _container.isDirty || dataRow.isDirty,
                  dataGridStateDetails: widget.dataGridStateDetails,
                ))
            .toList(growable: false));
      }

      // Adds column header row
      headerRows.addAll(rowGenerator.items
          .where((DataRowBase row) =>
              row.rowIndex >= 0 &&
              row.rowRegion == RowRegion.header &&
              row.rowType == RowType.headerRow)
          .map<Widget>((DataRowBase dataRow) => _HeaderCellsWidget(
                key: dataRow.key!,
                dataRow: dataRow,
                isDirty: _container.isDirty || dataRow.isDirty,
                dataGridStateDetails: widget.dataGridStateDetails,
              ))
          .toList(growable: false));

      return headerRows;
    }

    double getStartX() {
      if (dataGridConfiguration.textDirection == TextDirection.ltr) {
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

        late double maxScrollExtent;
        if (dataGridConfiguration
            .columnResizeController.isResizeIndicatorVisible) {
          // In RTL, Resolves the glitching issue of header rows while resizing
          // the column by calculating the maxScrollExtent manually.
          maxScrollExtent = _container.extentWidth -
              _horizontalController!.position.viewportDimension;
        } else {
          maxScrollExtent = _horizontalController!.position.maxScrollExtent;
        }

        return -(maxScrollExtent - _container.horizontalOffset);
      }
    }

    if (rowGenerator.items.isNotEmpty) {
      final List<Widget> headerRows = buildHeaderRows();
      for (int i = 0; i < headerRows.length; i++) {
        final VisibleLineInfo? lineInfo =
            _container.scrollRows.getVisibleLineAtLineIndex(i);
        final Positioned header = Positioned.directional(
            textDirection: dataGridConfiguration.textDirection,
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

  void _addIndicator(List<Widget> children) {
    final ColumnResizeController columnResizeController =
        _dataGridConfiguration.columnResizeController;
    if (columnResizeController.isResizeIndicatorVisible &&
        columnResizeController.resizingDataCell != null) {
      double top = 0;

      final DataGridThemeHelper? dataGridThemeHelper =
          _dataGridConfiguration.dataGridThemeHelper;
      int rowIndex = columnResizeController.rowIndex;

      if (columnResizeController.rowSpan > 0) {
        rowIndex -= columnResizeController.rowSpan;
      }

      if (rowIndex > 0) {
        top = columnResizeController.resizingDataCell!.dataRow!
            .getRowHeight(0, rowIndex - 1);
      }

      final Widget indicator = Positioned(
        top: top,
        left: columnResizeController.indicatorPosition,
        // Ignores the `hitTest` of the indicator to resolved the update of the
        // cursor visibility when hovering the column resizing indicator.
        child: IgnorePointer(
            child: _dataGridConfiguration.isDesktop
                ? Container(
                    width:
                        dataGridThemeHelper!.columnResizeIndicatorStrokeWidth,
                    height: _container.extentHeight - top,
                    color: dataGridThemeHelper.columnResizeIndicatorColor)
                : _getResizingCursor(
                    _dataGridConfiguration, dataGridThemeHelper!, top)),
      );
      children.add(indicator);
    }
  }

  void _addLoadMoreView(List<Widget> children) {
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    Future<void> loadMoreRows() async {
      _isLoadMoreViewLoaded = true;
      await handleLoadMoreRows(dataGridConfiguration.source);
    }

    if (_verticalController!.hasClients &&
        dataGridConfiguration.loadMoreViewBuilder != null) {
      // FLUT-3038 Need to restrict load more view when rows exist within the
      // view height.
      if ((_verticalController!.position.maxScrollExtent > 0.0) &&
          (_verticalController!.offset >=
              _verticalController!.position.maxScrollExtent) &&
          !_isLoadMoreViewLoaded) {
        final Widget? loadMoreView =
            dataGridConfiguration.loadMoreViewBuilder!(context, loadMoreRows);

        if (loadMoreView != null) {
          final Alignment loadMoreAlignment =
              dataGridConfiguration.textDirection == TextDirection.ltr
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
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    final DataGridThemeHelper? dataGridThemeHelper =
        dataGridConfiguration.dataGridThemeHelper;
    if (dataGridThemeHelper!.frozenPaneElevation <= 0.0 ||
        dataGridConfiguration.columns.isEmpty ||
        effectiveRows(dataGridConfiguration.source).isEmpty) {
      return;
    }
    final Color frozenLineColorWithOpacity =
        dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.38);

    final Color frozenLineColorWithoutOpacity =
        dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.14);

    void drawElevation({
      EdgeInsets? margin,
      double? bottom,
      double? start,
      double? end,
      double? top,
      Axis? axis,
      required Color frozenLineColor,
      required double blurRadiusValue,
      required double spreadRadiusValue,
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
                      color: frozenLineColor,
                      spreadRadius: spreadRadiusValue,
                      blurRadius: blurRadiusValue,
                    )
                  ])));

      children.add(Positioned.directional(
        top: top,
        end: end,
        start: start,
        bottom: bottom,
        textDirection: dataGridConfiguration.textDirection,
        child: elevationLine,
      ));
    }

    double getTopPosition(DataRowBase columnHeaderRow, int columnIndex) {
      double top = 0.0;
      if (dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
        top = columnHeaderRow.getRowHeight(
            0, dataGridConfiguration.stackedHeaderRows.length - 1);
        final DataCellBase? dataCell = columnHeaderRow.visibleColumns
            .firstWhereOrNull(
                (DataCellBase cell) => cell.columnIndex == columnIndex);
        // Need to ignore header cell spanned height from the total stacked
        // header rows height if it is spanned.
        if (dataCell != null && dataCell.rowSpan > 0) {
          top -= columnHeaderRow.getRowHeight(
              dataCell.rowIndex - dataCell.rowSpan, dataCell.rowIndex - 1);
        }
      }
      return top;
    }

    // The field remainingViewPortHeight and remainingViewPortWidth are used to
    // restrict the elevation height and width fill in the entire screen when
    // extent width and height is smaller than the view size.
    final double remainingViewPortHeight =
        (dataGridConfiguration.container.extentHeight < _height)
            ? _height - dataGridConfiguration.container.extentHeight
            : 0.0;
    final double remainingViewPortWidth =
        (dataGridConfiguration.container.extentWidth < _width)
            ? _width - dataGridConfiguration.container.extentWidth
            : 0.0;

    final DataRowBase? columnHeaderRow =
        dataGridConfiguration.container.rowGenerator.items.firstWhereOrNull(
            (DataRowBase row) => row.rowType == RowType.headerRow);

    // Provided the margin to allow shadow only to the corresponding side.
    // In 4.0 pixels, 1.0 pixel defines the size of the container and
    // 3.0 pixels defines the amount of spreadRadius.
    final double margin =
        dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation + 4.0;
    final int frozenColumnIndex =
        grid_helper.getLastFrozenColumnIndex(dataGridConfiguration);
    final int footerFrozenColumnIndex =
        grid_helper.getStartFooterFrozenColumnIndex(dataGridConfiguration);
    final int frozenRowIndex =
        grid_helper.getLastFrozenRowIndex(dataGridConfiguration);
    final int footerFrozenRowIndex =
        grid_helper.getStartFooterFrozenRowIndex(dataGridConfiguration);

    if (columnHeaderRow != null &&
        frozenColumnIndex >= 0 &&
        !_canDisableHorizontalScrolling(dataGridConfiguration)) {
      double spreadRadiusValue = 1.5;
      double blurRadiusValue = 0.0;
      Color frozenLineColor = frozenLineColorWithOpacity;
      final double top = getTopPosition(columnHeaderRow, frozenColumnIndex);
      final double left = columnHeaderRow.getColumnWidth(
          0, dataGridConfiguration.frozenColumnsCount - 1);
      if (dataGridConfiguration.textDirection == TextDirection.ltr &&
          dataGridConfiguration.container.horizontalOffset > 0) {
        spreadRadiusValue = 3.0;
        blurRadiusValue =
            dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation;
        frozenLineColor = frozenLineColorWithoutOpacity;
      }
      if (dataGridConfiguration.textDirection == TextDirection.rtl &&
          dataGridConfiguration.horizontalScrollController!.hasClients &&
          dataGridConfiguration
                  .horizontalScrollController!.position.maxScrollExtent >
              dataGridConfiguration.container.horizontalOffset) {
        spreadRadiusValue = 3.0;
        blurRadiusValue =
            dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation;
        frozenLineColor = frozenLineColorWithoutOpacity;
      }

      drawElevation(
          frozenLineColor: frozenLineColor,
          spreadRadiusValue: spreadRadiusValue,
          blurRadiusValue: blurRadiusValue,
          top: top,
          start: left,
          bottom: remainingViewPortHeight,
          axis: Axis.horizontal,
          margin: dataGridConfiguration.textDirection == TextDirection.rtl
              ? EdgeInsets.only(left: margin)
              : EdgeInsets.only(right: margin));
    }

    if (columnHeaderRow != null &&
        footerFrozenColumnIndex >= 0 &&
        !_canDisableHorizontalScrolling(dataGridConfiguration)) {
      double spreadRadiusValue = 3.0;
      double blurRadiusValue =
          dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation;
      Color frozenLineColor = frozenLineColorWithoutOpacity;
      final double top =
          getTopPosition(columnHeaderRow, footerFrozenColumnIndex);
      final double right = columnHeaderRow.getColumnWidth(
          footerFrozenColumnIndex, dataGridConfiguration.container.columnCount);
      if (dataGridConfiguration.textDirection == TextDirection.ltr &&
          dataGridConfiguration.horizontalScrollController!.hasClients &&
          dataGridConfiguration
                  .horizontalScrollController!.position.maxScrollExtent ==
              dataGridConfiguration.container.horizontalOffset) {
        spreadRadiusValue = 1.5;
        blurRadiusValue = 0.0;
        frozenLineColor = frozenLineColorWithOpacity;
      }
      if (dataGridConfiguration.textDirection == TextDirection.rtl &&
          dataGridConfiguration.container.horizontalOffset == 0) {
        spreadRadiusValue = 1.5;
        blurRadiusValue = 0.0;
        frozenLineColor = frozenLineColorWithOpacity;
      }

      drawElevation(
          frozenLineColor: frozenLineColor,
          spreadRadiusValue: spreadRadiusValue,
          blurRadiusValue: blurRadiusValue,
          top: top,
          bottom: remainingViewPortHeight,
          end: right + remainingViewPortWidth,
          axis: Axis.horizontal,
          margin: dataGridConfiguration.textDirection == TextDirection.rtl
              ? EdgeInsets.only(right: margin)
              : EdgeInsets.only(left: margin));
    }

    if (columnHeaderRow != null &&
        frozenRowIndex >= 0 &&
        !_canDisableVerticalScrolling(dataGridConfiguration)) {
      double spreadRadiusValue = 1.5;
      double blurRadiusValue = 0.0;
      Color frozenLineColor = frozenLineColorWithOpacity;
      final double top = columnHeaderRow.getRowHeight(0, frozenRowIndex);

      if (dataGridConfiguration.container.verticalOffset > 0) {
        spreadRadiusValue = 3.0;
        blurRadiusValue =
            dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation;
        frozenLineColor = frozenLineColorWithoutOpacity;
      }

      drawElevation(
          frozenLineColor: frozenLineColor,
          spreadRadiusValue: spreadRadiusValue,
          blurRadiusValue: blurRadiusValue,
          top: top,
          start: 0.0,
          end: remainingViewPortWidth,
          axis: Axis.vertical,
          margin: EdgeInsets.only(bottom: margin));
    }

    if (columnHeaderRow != null &&
        footerFrozenRowIndex >= 0 &&
        !_canDisableVerticalScrolling(dataGridConfiguration)) {
      double spreadRadiusValue = 3.0;
      double blurRadiusValue =
          dataGridConfiguration.dataGridThemeHelper!.frozenPaneElevation;
      Color frozenLineColor = frozenLineColorWithoutOpacity;
      final double bottom = columnHeaderRow.getRowHeight(
          footerFrozenRowIndex, dataGridConfiguration.container.rowCount);

      if (dataGridConfiguration.verticalScrollController!.hasClients &&
          dataGridConfiguration
                  .verticalScrollController!.position.maxScrollExtent ==
              dataGridConfiguration.container.verticalOffset) {
        spreadRadiusValue = 1.5;
        blurRadiusValue = 0.0;
        frozenLineColor = frozenLineColorWithOpacity;
      }

      drawElevation(
          frozenLineColor: frozenLineColor,
          spreadRadiusValue: spreadRadiusValue,
          blurRadiusValue: blurRadiusValue,
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
  //   final DataGridSettings dataGridSettings = DataGridSettings;
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
  //           selection_helper.getFirstRowIndex(DataGridSettings);
  //       final int firstCellIndex =
  //           selection_helper.getFirstCellIndex(DataGridSettings);
  //
  //       if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     } else {
  //       final int lastRowIndex =
  //           selection_helper.getLastNavigatingRowIndex(DataGridSettings);
  //       final int lastCellIndex =
  //           selection_helper.getLastCellIndex(DataGridSettings);
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
  //   final DataGridSettings dataGridSettings = DataGridSettings;
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
  //           selection_helper.getFirstRowIndex(DataGridSettings);
  //       final int firstCellIndex =
  //           selection_helper.getFirstCellIndex(DataGridSettings);
  //
  //       if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
  //         return KeyEventResult.ignored;
  //       } else {
  //         return KeyEventResult.handled;
  //       }
  //     } else {
  //       final int lastRowIndex =
  //           selection_helper.getLastNavigatingRowIndex(DataGridSettings);
  //       final int lastCellIndex =
  //           selection_helper.getLastCellIndex(DataGridSettings);
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
  //   final _CurrentCellManager currentCell = DataGridSettings.currentCell;
  //   if (DataGridSettings.allowEditing &&
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
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;

    void processKeys() {
      if (keyEvent.runtimeType == RawKeyDownEvent) {
        _rowSelectionManager.handleKeyEvent(keyEvent);
        if (keyEvent.isControlPressed) {
          dataGridConfiguration.isControlKeyPressed = true;
        }
        if (keyEvent.isShiftPressed) {
          dataGridConfiguration.isShiftKeyPressed = true;
        }
      }
      if (keyEvent.runtimeType == RawKeyUpEvent) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.controlLeft ||
            keyEvent.logicalKey == LogicalKeyboardKey.controlRight) {
          dataGridConfiguration.isControlKeyPressed = false;
        }
        if (keyEvent.logicalKey == LogicalKeyboardKey.shiftLeft ||
            keyEvent.logicalKey == LogicalKeyboardKey.shiftRight) {
          dataGridConfiguration.isShiftKeyPressed = false;
        }
      }
    }

    // Move to the next focusable widget when it reach the last and first
    // [DataGridCell] on tab & shift + tab key.
    KeyEventResult needToMoveFocus() {
      bool canAllowToRemoveFocus(int rowIndex, int columnIndex) =>
          (dataGridConfiguration.navigationMode == GridNavigationMode.cell &&
              currentCell.rowIndex == rowIndex &&
              currentCell.columnIndex == columnIndex) ||
          (dataGridConfiguration.navigationMode == GridNavigationMode.row &&
              currentCell.rowIndex == rowIndex) ||
          (!_dataGridFocusNode!.hasPrimaryFocus && currentCell.isEditing);

      if (keyEvent.isShiftPressed) {
        final int firstRowIndex =
            selection_helper.getFirstRowIndex(dataGridConfiguration);
        final int firstCellIndex =
            selection_helper.getFirstCellIndex(dataGridConfiguration);

        if (canAllowToRemoveFocus(firstRowIndex, firstCellIndex)) {
          return KeyEventResult.ignored;
        } else {
          return KeyEventResult.handled;
        }
      } else {
        final int lastRowIndex =
            selection_helper.getLastNavigatingRowIndex(dataGridConfiguration);
        final int lastCellIndex =
            selection_helper.getLastCellIndex(dataGridConfiguration);

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
      if (dataGridConfiguration.allowEditing &&
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
  void didUpdateWidget(ScrollViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final DataGridConfiguration dataGridConfiguration = _dataGridConfiguration;
    if (oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        _container.needToSetHorizontalOffset) {
      /// Need not to change the height when onScreenKeyboard appears.
      /// Cause: If we change the height on editing, editable widget will not move
      /// above the onScreenKeyboard on mobile platforms.
      final bool needToResizeHeight = !dataGridConfiguration.isDesktop &&
          dataGridConfiguration.currentCell.isEditing;

      _width = widget.width;
      _height = !needToResizeHeight ? widget.height : _height;
      _container
        ..needToSetHorizontalOffset = true
        ..isDirty = true;
      if (oldWidget.width != widget.width ||
          oldWidget.height != widget.height) {
        _container.resetSwipeOffset();
      }
      // FLUT-2047 Need to mark all visible rows height as dirty when DataGrid
      // size is changed if onQueryRowHeight is not null.
      if (oldWidget.width != widget.width &&
          dataGridConfiguration.onQueryRowHeight != null) {
        _container.rowHeightManager.reset();
      }
    }

    if (_verticalController != dataGridConfiguration.verticalScrollController) {
      _verticalController!.removeListener(_verticalListener);
      _verticalController =
          dataGridConfiguration.verticalScrollController ?? ScrollController();
      _verticalController!.addListener(_verticalListener);
    }

    if (_horizontalController !=
        dataGridConfiguration.horizontalScrollController) {
      _horizontalController!.removeListener(_horizontalListener);
      _horizontalController =
          dataGridConfiguration.horizontalScrollController ??
              ScrollController();
      _horizontalController!.addListener(_horizontalListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_container.isDirty && !_isScrolling) {
      //if shrink wrap width is set  then we need to calculate the total view width value by using _updateColumnSizer method to update the axis width
      //if the column size is changed at run time or setted by sample level we update the axis value based on this value.
      if (_dataGridConfiguration.shrinkWrapColumns) {
        _updateColumnSizer();
      }

      _height = _dataGridConfiguration.viewHeight =
          _dataGridConfiguration.shrinkWrapRows
              ? (_container.scrollRows as PixelScrollAxis).totalExtent
              : widget.height;
      _width = _dataGridConfiguration.viewWidth =
          _dataGridConfiguration.shrinkWrapColumns
              ? (_container.scrollColumns as PixelScrollAxis).totalExtent
              : widget.width;

      _updateAxis();

      //if shrink wrap width is not set we update the column size after updated the axis because we get the constraint max width
      if (!_dataGridConfiguration.shrinkWrapColumns) {
        _updateColumnSizer();
      }
      _container
        ..setRowHeights()
        ..needToRefreshColumn = true;

      // FLUT-6545 if shrinkWrapRows is ture, we need to the set the DataGrid maximum height
      // based on the row value set in the onQueryRowHeight callback
      if (_dataGridConfiguration.shrinkWrapRows) {
        _height = _dataGridConfiguration.viewHeight =
            (_container.scrollRows as PixelScrollAxis).totalExtent;
        _updateAxis();
      }
    }

    if (_container.needToSetHorizontalOffset) {
      _setHorizontalOffset();
    }

    if (_container.isDirty) {
      _ensureWidgets();
    }

    final List<Positioned> children = <Positioned>[];

    _addHeaderRows(children);

    _addScrollView(children);

    _addFreezePaneLinesElevation(children);

    _addLoadMoreView(children);

    _addIndicator(children);

    _container.isDirty = false;
    _isScrolling = false;

    Widget addContainer() {
      return Container(
        height: _height,
        width: _width,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
            fit: StackFit.passthrough,
            children: List<Positioned>.from(children)),
      );
    }

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
    //         child: DataGridSettings.allowColumnsResizing
    //             ? _wrapInsideGestureDetector(children)
    //             : _wrapInsideStack(children)));

    // [FocusNode.onKey] callback is not firing on key navigation after flutter
    // 2.2.0 and its breaking our key navigation on tab, shift + tab, arrow keys.
    // So, we have used the focus widget. Need to remove [Focus] widget when
    // below mentioned issue is resolved on framework end.
    // [https://github.com/flutter/flutter/issues/83023]
    return _dataGridConfiguration.isDesktop
        ? Focus(
            focusNode: _dataGridFocusNode,
            onKey: _handleKeyOperation,
            child: addContainer())
        : addContainer();
  }

  @override
  void dispose() {
    if (_verticalController != null &&
        _dataGridConfiguration.disposeVerticalScrollController) {
      _verticalController!
        ..removeListener(_verticalListener)
        ..dispose();
    }

    if (_horizontalController != null &&
        _dataGridConfiguration.disposeHorizontalScrollController) {
      _horizontalController!
        ..removeListener(_horizontalListener)
        ..dispose();
    }

    super.dispose();
  }
}

/// Return the resizing indicator for mobile platform
Widget _getResizingCursor(DataGridConfiguration dataGridConfiguration,
    DataGridThemeHelper themeData, double y) {
  const double cursorContainerHeight = 16.0;
  const double cursorContainerWidth = 16.0;

  final ColumnResizeController columnResizeController =
      dataGridConfiguration.columnResizeController;

  final int rowSpan = columnResizeController.rowSpan;
  final int rowIndex = columnResizeController.rowIndex;
  final Color indicatorColor = themeData.columnResizeIndicatorColor;
  final double strokeWidth = themeData.columnResizeIndicatorStrokeWidth;
  double rowHeight = dataGridConfiguration.container.rowHeights[rowIndex];

  // Consider the spanned row height to show the indicator at center
  if (rowSpan > 0) {
    rowHeight = columnResizeController.resizingDataCell!.dataRow!
        .getRowHeight(rowIndex - rowSpan, rowIndex);
  }

  return Stack(
    clipBehavior: Clip.none,
    children: <Positioned>[
      Positioned(
        child: Container(
          width: strokeWidth,
          color: indicatorColor,
          height: dataGridConfiguration.container.extentHeight - y,
        ),
      ),
      Positioned(
        left: (strokeWidth - cursorContainerWidth) / 2,
        top: (rowHeight - cursorContainerHeight) / 2,
        child: Container(
          height: cursorContainerHeight,
          width: cursorContainerWidth,
          padding: const EdgeInsets.all(.2),
          decoration:
              BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
          child: CustomPaint(
            painter: _CustomResizingCursorPainter(
                Colors.white, dataGridConfiguration.gridPaint!),
          ),
        ),
      ),
    ],
  );
}

/// Helps to draw the custom resizing cursor for mobile platforms
class _CustomResizingCursorPainter extends CustomPainter {
  _CustomResizingCursorPainter(this._arrowColor, this._arrowPaint);

  final Color _arrowColor;
  final Paint _arrowPaint;

  @override
  void paint(Canvas canvas, Size size) {
    // Center  point of the width
    final double horizontalCenterPoint = size.width / 2;
    // Center point of the height
    final double verticalCenterPoint = size.height / 2;
    // Consider the space between the left and right of arrow. It 1/4 range of
    // horizontal center point
    final double leftAndRightPadding = horizontalCenterPoint / 4;
    // Consider the space between the top and bottom of arrow. It 1/4 range of
    // height
    final double topAndBottomPadding = size.height / 4;

    Path? path = Path();
    _arrowPaint
      ..style = PaintingStyle.fill
      ..color = _arrowColor;

    /// Drawing left arrow
    path.moveTo(leftAndRightPadding, verticalCenterPoint);
    path.lineTo(
        horizontalCenterPoint - leftAndRightPadding, leftAndRightPadding);
    path.moveTo(
        horizontalCenterPoint - leftAndRightPadding, topAndBottomPadding);
    path.lineTo(horizontalCenterPoint - leftAndRightPadding,
        size.height - topAndBottomPadding);
    path.lineTo(leftAndRightPadding, verticalCenterPoint);
    path.close();
    canvas.drawPath(path, _arrowPaint);

    /// Drawing right arrow
    path.moveTo(
        horizontalCenterPoint + topAndBottomPadding, leftAndRightPadding);
    path.lineTo(size.width - leftAndRightPadding, verticalCenterPoint);
    path.moveTo(size.width - leftAndRightPadding, verticalCenterPoint);
    path.lineTo(horizontalCenterPoint + leftAndRightPadding,
        size.height - topAndBottomPadding);
    path.lineTo(verticalCenterPoint + leftAndRightPadding, topAndBottomPadding);
    path.close();
    canvas.drawPath(path, _arrowPaint);
    path = null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

bool _canDisableVerticalScrolling(DataGridConfiguration dataGridConfiguration) {
  final VisualContainerHelper container = dataGridConfiguration.container;
  return (container.scrollRows.headerExtent +
          container.scrollRows.footerExtent) >
      dataGridConfiguration.viewHeight;
}

bool _canDisableHorizontalScrolling(
    DataGridConfiguration dataGridConfiguration) {
  final VisualContainerHelper container = dataGridConfiguration.container;
  return (container.scrollColumns.headerExtent +
          container.scrollColumns.footerExtent) >
      dataGridConfiguration.viewWidth;
}

class _VisualContainer extends StatefulWidget {
  const _VisualContainer(
      {required Key key,
      required this.rowGenerator,
      required this.containerSize,
      required this.isDirty,
      required this.dataGridStateDetails})
      : super(key: key);

  final Size containerSize;
  final RowGenerator rowGenerator;
  final bool isDirty;
  final DataGridStateDetails dataGridStateDetails;

  @override
  State<StatefulWidget> createState() => _VisualContainerState();
}

class _VisualContainerState extends State<_VisualContainer> {
  void _addSwipeBackgroundWidget(List<Widget> children) {
    final DataGridConfiguration dataGridConfiguration =
        widget.dataGridStateDetails();
    if (dataGridConfiguration.allowSwiping &&
        dataGridConfiguration.swipingOffset.abs() > 0.0) {
      final DataRowBase? swipeRow = widget.rowGenerator.items
          .where((DataRowBase row) =>
              (row.rowRegion == RowRegion.body ||
                  row.rowType == RowType.dataRow) &&
              row.rowIndex >= 0)
          .firstWhereOrNull((DataRowBase row) => row.isSwipingRow);
      if (swipeRow != null) {
        final DataGridRowSwipeDirection swipeDirection =
            grid_helper.getSwipeDirection(
                dataGridConfiguration, dataGridConfiguration.swipingOffset);
        final int rowIndex = grid_helper.resolveToRecordIndex(
            dataGridConfiguration, swipeRow.rowIndex);

        switch (swipeDirection) {
          case DataGridRowSwipeDirection.startToEnd:
            if (dataGridConfiguration.startSwipeActionsBuilder != null) {
              final Widget? startSwipeWidget =
                  dataGridConfiguration.startSwipeActionsBuilder!(
                      context, swipeRow.dataGridRow!, rowIndex);
              children.add(startSwipeWidget ?? Container());
            }
            break;
          case DataGridRowSwipeDirection.endToStart:
            if (dataGridConfiguration.endSwipeActionsBuilder != null) {
              final Widget? endSwipeWidget =
                  dataGridConfiguration.endSwipeActionsBuilder!(
                      context, swipeRow.dataGridRow!, rowIndex);
              children.add(endSwipeWidget ?? Container());
            }
            break;
        }
      }
    }
  }

  void _addRows(List<Widget> children, RowRegion rowRegion) {
    if (rowRegion == RowRegion.header) {
      children.addAll(widget.rowGenerator.items
          .where((DataRowBase row) =>
              row.rowIndex >= 0 &&
              row.rowRegion == rowRegion &&
              (row.rowType == RowType.tableSummaryRow ||
                  row.rowType == RowType.tableSummaryCoveredRow ||
                  row.rowType == RowType.dataRow))
          .map<Widget>((DataRowBase dataRow) => addWidget(dataRow))
          .toList());
    } else if (rowRegion == RowRegion.body) {
      // Need to restrict the layout of the currently unused rows that keep the
      // row index to -1 in the `rowGenerator.items` collection.
      children.addAll(widget.rowGenerator.items
          .where((DataRowBase row) =>
              row.rowIndex >= 0 &&
              row.rowRegion == rowRegion &&
              (row.rowType == RowType.dataRow ||
                  row.rowType == RowType.footerRow))
          .map<Widget>((DataRowBase dataRow) => addWidget(dataRow))
          .toList());
    } else if (rowRegion == RowRegion.footer) {
      children.addAll(widget.rowGenerator.items
          .where((DataRowBase row) =>
              row.rowIndex >= 0 &&
              row.rowRegion == rowRegion &&
              (row.rowType == RowType.tableSummaryRow ||
                  row.rowType == RowType.tableSummaryCoveredRow ||
                  row.rowType == RowType.footerRow ||
                  row.rowType == RowType.dataRow))
          .map<Widget>((DataRowBase dataRow) => addWidget(dataRow))
          .toList());
    }
  }

  Widget addWidget(DataRowBase dataRow) {
    return _VirtualizingCellsWidget(
      key: dataRow.key!,
      dataRow: dataRow,
      isDirty: widget.isDirty || dataRow.isDirty,
      dataGridStateDetails: widget.dataGridStateDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    _addRows(children, RowRegion.header);

    _addRows(children, RowRegion.body);

    _addRows(children, RowRegion.footer);

    _addSwipeBackgroundWidget(children);

    return VisualContainerRenderObjectWidget(
      key: widget.key,
      containerSize: widget.containerSize,
      isDirty: widget.isDirty,
      dataGridStateDetails: widget.dataGridStateDetails,
      children: children,
    );
  }
}

class _VirtualizingCellsWidget extends StatefulWidget {
  const _VirtualizingCellsWidget(
      {required Key key,
      required this.dataRow,
      required this.isDirty,
      required this.dataGridStateDetails})
      : super(key: key);

  final DataRowBase dataRow;
  final bool isDirty;
  final DataGridStateDetails dataGridStateDetails;

  @override
  State<StatefulWidget> createState() => _VirtualizingCellsWidgetState();
}

class _VirtualizingCellsWidgetState extends State<_VirtualizingCellsWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (widget.dataRow.rowType == RowType.footerRow) {
      if (widget.dataRow.footerView != null) {
        children.add(widget.dataRow.footerView!);
      }
    } else {
      // Need to allow only the visible columns to the layout.
      final List<Widget> visibleColumns = widget.dataRow.visibleColumns
          .where((DataCellBase cell) => cell.isVisible && cell.columnIndex >= 0)
          .map<Widget>((DataCellBase cell) => cell.columnElement!)
          .toList(growable: false);
      children.addAll(visibleColumns);
    }

    return VirtualizingCellsRenderObjectWidget(
      key: widget.key!,
      dataRow: widget.dataRow,
      isDirty: widget.isDirty,
      dataGridStateDetails: widget.dataGridStateDetails,
      children: List<Widget>.from(children),
    );
  }
}

class _HeaderCellsWidget extends _VirtualizingCellsWidget {
  const _HeaderCellsWidget(
      {required Key key,
      required DataRowBase dataRow,
      bool isDirty = false,
      required DataGridStateDetails dataGridStateDetails})
      : super(
            key: key,
            dataRow: dataRow,
            isDirty: isDirty,
            dataGridStateDetails: dataGridStateDetails);
}

/// A class [VisualContainerHelper] is used to provide all the information of the
/// grid common to build a [SfDataGrid].
class VisualContainerHelper {
  /// Creates a [VisualContainerHelper] for the [SfDataGrid].
  VisualContainerHelper(
      {required this.rowGenerator, required this.dataGridStateDetails}) {
    isDirty = false;
    isGridLoaded = false;
    needToSetHorizontalOffset = false;
    rowHeightsProvider = _onCreateRowHeights();
    columnWidthsProvider = _onCreateColumnWidths();
  }

  /// Checks whether the `preGeneratedRows` method is called or not on
  /// initial loading alone.
  bool isPreGenerator = false;

  /// Decides whether the datagrid columns are needed to refresh or not.
  bool needToRefreshColumn = false;

  /// The length of the header line count.
  int headerLineCount = 1;

  /// Checks whether the datagrid's `VisualContainer` is currently changed or not.
  late bool isDirty;

  /// Used to check the grid is loaded initially or not.
  late bool isGridLoaded;

  /// Used to set the horizontal offset for LTR to RTL and vise versa,
  late bool needToSetHorizontalOffset;

  /// Holds an instance of [RowGenerator].
  late RowGenerator rowGenerator;

  /// Holds a instance of [PaddedEditableLineSizeHostBase] to determine the
  /// datagrid row heights.
  late PaddedEditableLineSizeHostBase rowHeightsProvider;

  /// Holds a instance of [PaddedEditableLineSizeHostBase] to determine the
  /// datagrid column widths.
  late PaddedEditableLineSizeHostBase columnWidthsProvider;

  /// Holds an instance of [RowHeightManager].
  RowHeightManager rowHeightManager = RowHeightManager();

  /// Maintains the collection of row height of the [SfDataGrid].
  PaddedEditableLineSizeHostBase get rowHeights => rowHeightsProvider;

  /// Maintains the collection of column widths of the [SfDataGrid].
  PaddedEditableLineSizeHostBase get columnWidths => columnWidthsProvider;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  /// A class [ScrollAxisBase] that can be used to control the scrolling of rows
  /// in the [SfDataGrid].
  ScrollAxisBase get scrollRows {
    _scrollRows ??=
        _createScrollAxis(true, verticalScrollBar, rowHeightsProvider);
    _scrollRows!.name = 'ScrollRows';

    return _scrollRows!;
  }

  ScrollAxisBase? _scrollRows;

  set scrollRows(ScrollAxisBase newValue) => _scrollRows = newValue;

  /// A class [ScrollAxisBase] that can be used to control the scrolling of columns
  /// in the [SfDataGrid].
  ScrollAxisBase get scrollColumns {
    _scrollColumns ??=
        _createScrollAxis(true, horizontalScrollBar, columnWidthsProvider);
    _scrollColumns!.name = 'ScrollColumns';
    return _scrollColumns!;
  }

  ScrollAxisBase? _scrollColumns;

  set scrollColumns(ScrollAxisBase newValue) => _scrollColumns = newValue;

  /// The horizontal scrollbar of the data grid.
  ScrollBarBase get horizontalScrollBar =>
      _horizontalScrollBar ?? (_horizontalScrollBar = ScrollInfo());
  ScrollBarBase? _horizontalScrollBar;

  /// The vertical scrollbar of the data grid.
  ScrollBarBase get verticalScrollBar =>
      _verticalScrollBar ?? (_verticalScrollBar = ScrollInfo());
  ScrollBarBase? _verticalScrollBar;

  /// Returns the number of rows is currently available in the data grid.
  int get rowCount => rowHeightsProvider.lineCount;

  set rowCount(int newValue) {
    if (newValue > rowCount) {
      _insertRows(rowCount, newValue - rowCount);
    } else if (newValue < rowCount) {
      _removeRows(newValue, rowCount - newValue);
    }
  }

  /// Returns the number of columns is currently available in the data grid.
  int get columnCount => columnWidthsProvider.lineCount;

  set columnCount(int newValue) {
    if (newValue > columnCount) {
      _insertColumns(columnCount, newValue - columnCount);
    } else if (newValue < columnCount) {
      _removeColumns(newValue, columnCount - newValue);
    }
  }

  /// Returns the number of frozen rows is currently available in the
  /// data grid.
  int get frozenRows => rowHeightsProvider.headerLineCount;

  set frozenRows(int newValue) {
    if (newValue < 0 || frozenRows == newValue) {
      return;
    }

    rowHeightsProvider.headerLineCount = newValue;
  }

  /// Returns the number of footer frozen rows is currently available in the
  /// data grid.
  int get footerFrozenRows => rowHeightsProvider.footerLineCount;

  set footerFrozenRows(int newValue) {
    if (newValue < 0 || footerFrozenRows == newValue) {
      return;
    }

    rowHeightsProvider.footerLineCount = newValue;
  }

  /// Returns the number of frozen columns is currently available in the
  /// data grid.
  int get frozenColumns => columnWidthsProvider.headerLineCount;

  set frozenColumns(int newValue) {
    if (newValue < 0 || frozenColumns == newValue) {
      return;
    }

    columnWidthsProvider.headerLineCount = newValue;
  }

  /// Returns the number of footer frozen columns is currently available in
  /// the data grid.
  int get footerFrozenColumns => columnWidthsProvider.footerLineCount;

  set footerFrozenColumns(int newValue) {
    if (newValue < 0 || footerFrozenColumns == newValue) {
      return;
    }

    columnWidthsProvider.footerLineCount = newValue;
  }

  /// Returns the current horizontal scrolling offset.
  double get horizontalOffset =>
      horizontalScrollBar.value - horizontalScrollBar.minimum;

  set horizontalOffset(double newValue) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.textDirection == TextDirection.ltr) {
      horizontalScrollBar.value = newValue + horizontalScrollBar.minimum;
    } else {
      horizontalScrollBar.value = max(horizontalScrollBar.minimum,
              horizontalScrollBar.maximum - horizontalScrollBar.largeChange) -
          newValue;
    }
    updateHorizontalOffset(
        dataGridConfiguration.controller, horizontalScrollBar.value);

    needToRefreshColumn = true;
  }

  /// Returns the current vertical scrolling offset.
  double get verticalOffset =>
      verticalScrollBar.value - verticalScrollBar.minimum;

  set verticalOffset(double newValue) {
    if (verticalScrollBar.value != (newValue + verticalScrollBar.minimum)) {
      final DataGridConfiguration dataGridConfiguration =
          dataGridStateDetails();
      verticalScrollBar.value = newValue + verticalScrollBar.minimum;
      updateVerticalOffset(
          dataGridConfiguration.controller, verticalScrollBar.value);
    }
  }

  /// Returns total width of all the columns in the data grid.
  double get extentWidth {
    final PixelScrollAxis pixelScrollColumns = scrollColumns as PixelScrollAxis;
    return pixelScrollColumns.totalExtent;
  }

  /// Returns total height of all the rows in the data grid.
  double get extentHeight {
    final PixelScrollAxis pixelScrollRows = scrollRows as PixelScrollAxis;
    return pixelScrollRows.totalExtent;
  }

  /// Sets the row height of all the data grid rows.
  void setRowHeights() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onQueryRowHeight == null) {
      return;
    }

    final VisibleLinesCollection visibleRows = scrollRows.getVisibleLines();

    if (visibleRows.length <= visibleRows.firstBodyVisibleIndex) {
      return;
    }

    final int endIndex =
        visibleRows[visibleRows.lastBodyVisibleIndex].lineIndex;

    const int headerStart = 0;

    final int headerEnd = scrollRows.headerLineCount - 1;
    rowHeightHelper(headerStart, headerEnd, RowRegion.header);

    rowHeightManager.updateRegion(headerStart, headerEnd, RowRegion.header);

    final int footerStart =
        visibleRows.length > visibleRows.firstFooterVisibleIndex &&
                scrollRows.footerLineCount > 0
            ? visibleRows[visibleRows.firstFooterVisibleIndex].lineIndex
            : -1;
    final int footerEnd =
        scrollRows.footerLineCount > 0 ? scrollRows.lineCount - 1 : -1;

    rowHeightHelper(footerStart, footerEnd, RowRegion.footer);

    rowHeightManager.updateRegion(footerStart, footerEnd, RowRegion.footer);

    final double bodyStart =
        visibleRows[visibleRows.firstBodyVisibleIndex].origin;

    final double bodyEnd =
        visibleRows[visibleRows.firstFooterVisibleIndex - 1].corner;

    final int bodyStartLineIndex =
        visibleRows[visibleRows.firstBodyVisibleIndex].lineIndex;

    double current = bodyStart;
    int currentEnd = endIndex;

    final LineSizeCollection lineSizeCollection =
        rowHeights as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    for (int index = bodyStartLineIndex;
        ((current <= bodyEnd ||
                    (current <= dataGridConfiguration.viewHeight)) ||
                dataGridConfiguration.shrinkWrapRows) &&
            index < scrollRows.firstFooterLineIndex;
        index++) {
      double height = rowHeights[index];

      if (!rowHeightManager.contains(index, RowRegion.body) &&
          !grid_helper.isFooterWidgetRow(index, dataGridConfiguration)) {
        final double rowHeight = rowGenerator.queryRowHeight(index, height);
        if (rowHeight != height) {
          height = rowHeight;
          rowHeights.setRange(index, index, height);
        }
      }

      current += height;
      currentEnd = index;
    }

    rowHeightManager.updateRegion(
        bodyStartLineIndex, currentEnd, RowRegion.body);

    if (rowHeightManager.dirtyRows.isNotEmpty) {
      for (final int index in rowHeightManager.dirtyRows) {
        if (index < 0 || index >= rowHeights.lineCount) {
          continue;
        }

        final double height = rowHeights[index];
        final double rowHeight = rowGenerator.queryRowHeight(index, height);
        if (rowHeight != height) {
          rowHeights.setRange(index, index, rowHeight);
        }
      }

      rowHeightManager.dirtyRows.clear();
    }

    lineSizeCollection.resumeUpdates();
    scrollRows.updateScrollBar(false);
  }

  /// Sets the row height to a specific range.
  void rowHeightHelper(int startIndex, int endIndex, RowRegion region) {
    if (startIndex < 0 || endIndex < 0) {
      return;
    }

    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    for (int index = startIndex; index <= endIndex; index++) {
      if (!rowHeightManager.contains(index, region)) {
        final double height = dataGridConfiguration.container.rowHeights[index];
        final double rowHeight = rowGenerator.queryRowHeight(index, height);
        if (rowHeight != height) {
          rowHeights.setRange(index, index, rowHeight);

          if (region == RowRegion.header &&
              index == grid_helper.getHeaderIndex(dataGridConfiguration)) {
            dataGridConfiguration.headerRowHeight = rowHeight;
          }
        }
      }
    }
  }

  void _preGenerateItems() {
    final VisibleLinesCollection visibleRows = scrollRows.getVisibleLines();
    final VisibleLinesCollection visibleColumns =
        grid_helper.getVisibleLines(dataGridStateDetails());

    if (visibleRows.isNotEmpty && visibleColumns.isNotEmpty) {
      rowGenerator.preGenerateRows(visibleRows, visibleColumns);
      isPreGenerator = true;
    }
  }

  PaddedEditableLineSizeHostBase _onCreateRowHeights() {
    final LineSizeCollection lineSizeCollection = LineSizeCollection();
    return lineSizeCollection;
  }

  PaddedEditableLineSizeHostBase _onCreateColumnWidths() {
    final LineSizeCollection lineSizeCollection = LineSizeCollection();
    return lineSizeCollection;
  }

  void _insertRows(int insertAtRowIndex, int count) {
    rowHeightsProvider.insertLines(insertAtRowIndex, count, null);
  }

  void _removeRows(int removeAtRowIndex, int count) {
    rowHeightsProvider.removeLines(removeAtRowIndex, count, null);
  }

  void _insertColumns(int insertAtColumnIndex, int count) {
    columnWidthsProvider.insertLines(insertAtColumnIndex, count, null);
  }

  void _removeColumns(int removeAtColumnIndex, int count) {
    final LineSizeCollection lineSizeCollection =
        columnWidths as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    columnWidthsProvider.removeLines(removeAtColumnIndex, count, null);
    lineSizeCollection.resumeUpdates();
  }

  /// Updates the scroll bar of `scrollRows` and `scrollColumns`.
  void updateScrollBars() {
    scrollRows.updateScrollBar(false);
    scrollColumns.updateScrollBar(false);
  }

  /// Sets the render size to the `scrollRows` and `scrollColumns`.
  void updateAxis(Size availableSize) {
    scrollRows.renderSize = availableSize.height;
    scrollColumns.renderSize = availableSize.width;
  }

  ScrollAxisBase _createScrollAxis(
      bool isPixelScroll, ScrollBarBase scrollBar, LineSizeHostBase lineSizes) {
    if (isPixelScroll) {
      final Object lineSize = lineSizes;
      if (lineSizes is DistancesHostBase) {
        return PixelScrollAxis.fromPixelScrollAxis(
            scrollBar, lineSizes, lineSize as DistancesHostBase);
      } else {
        return PixelScrollAxis.fromPixelScrollAxis(scrollBar, lineSizes, null);
      }
    } else {
      return LineScrollAxis(scrollBar, lineSizes);
    }
  }

  /// Returns the `VisibleLineInfo` for the given row index.
  VisibleLineInfo? getRowVisibleLineInfo(int index) =>
      scrollRows.getVisibleLineAtLineIndex(index);

  /// Returns the start and end index of the current visible lines.
  List<int> getStartEndIndex(VisibleLinesCollection visibleLines, int region) {
    int startIndex = 0;
    int endIndex = -1;
    switch (region) {
      case 0:
        if (visibleLines.firstBodyVisibleIndex > 0) {
          startIndex = 0;
          endIndex =
              visibleLines[visibleLines.firstBodyVisibleIndex - 1].lineIndex;
        }
        break;
      case 1:
        if ((visibleLines.firstBodyVisibleIndex <= 0 &&
                visibleLines.lastBodyVisibleIndex < 0) ||
            visibleLines.length <= visibleLines.firstBodyVisibleIndex) {
          return <int>[startIndex, endIndex];
        } else {
          startIndex =
              visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
          endIndex = visibleLines[visibleLines.lastBodyVisibleIndex].lineIndex;
        }
        break;
      case 2:
        if (visibleLines.firstFooterVisibleIndex < visibleLines.length) {
          startIndex =
              visibleLines[visibleLines.firstFooterVisibleIndex].lineIndex;
          endIndex = visibleLines[visibleLines.length - 1].lineIndex;
        }
        break;
    }

    return <int>[startIndex, endIndex];
  }

  /// Refreshes the default line size of column and row.
  void refreshDefaultLineSize() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    rowHeights.defaultLineSize = dataGridConfiguration.rowHeight;
    columnWidths.defaultLineSize = dataGridConfiguration.defaultColumnWidth;
  }

  /// Refreshes the header line count.
  void refreshHeaderLineCount() {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    headerLineCount = 1;
    if (dataGridConfiguration.stackedHeaderRows.isNotEmpty) {
      headerLineCount += dataGridConfiguration.stackedHeaderRows.length;
    }
    if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
      headerLineCount += grid_helper.getTableSummaryCount(
          dataGridConfiguration, GridTableSummaryRowPosition.top);
    }
    dataGridConfiguration.headerLineCount = headerLineCount;
  }

  int _getFooterLineCount(DataGridConfiguration dataGridConfiguration) {
    int footerLineCount = 0;
    // Add footer row widget to the rows
    if (dataGridConfiguration.footer != null) {
      footerLineCount++;
    }
    if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
      // Add bottom summary rows count
      footerLineCount += grid_helper.getTableSummaryCount(
          dataGridConfiguration, GridTableSummaryRowPosition.bottom);
    }
    return footerLineCount;
  }

  /// Updates the rows and columns count.
  void updateRowAndColumnCount() {
    final LineSizeCollection lineSizeCollection =
        columnWidths as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    _updateColumnCount(dataGridConfiguration);
    _updateRowCount(dataGridConfiguration);
    if (rowCount > 0) {
      for (int i = 0;
          i <= grid_helper.getHeaderIndex(dataGridConfiguration);
          i++) {
        rowHeights[i] = dataGridConfiguration.headerRowHeight;
      }
    }

    //need to update the indent column width here
    lineSizeCollection.resumeUpdates();
    updateScrollBars();
    _updateFreezePaneColumns(dataGridConfiguration);

    rowHeights.lineCount = rowCount;
    columnWidths.lineCount = columnCount;
  }

  void _updateColumnCount(DataGridConfiguration dataGridConfiguration) {
    final int columnCount = dataGridConfiguration.columns.length;
    this.columnCount = columnCount;
  }

  void _updateRowCount(DataGridConfiguration dataGridConfiguration) {
    final LineSizeCollection lineSizeCollection =
        rowHeights as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    int rowsCount = 0;
    rowsCount = effectiveRows(dataGridConfiguration.source).isNotEmpty
        ? effectiveRows(dataGridConfiguration.source).length
        : 0;
    rowsCount += dataGridConfiguration.headerLineCount;

    rowsCount += _getFooterLineCount(dataGridConfiguration);

    rowCount = rowsCount;

    // Sets footer row height
    if (dataGridConfiguration.footer != null) {
      rowHeights[grid_helper.getFooterViewRowIndex(dataGridConfiguration)] =
          dataGridConfiguration.footerHeight;
    }

    _updateFreezePaneRows(dataGridConfiguration);
    // FLUT-2047 Need to mark all visible rows height as dirty when
    // updating the row count if onQueryRowHeight is not null.
    if (dataGridStateDetails().onQueryRowHeight != null) {
      rowHeightManager.reset();
    }
    //need to reset the hidden state
    lineSizeCollection.resumeUpdates();
    //need to check again need to call the updateFreezePaneRows here
    _updateFreezePaneRows(dataGridConfiguration);
  }

  void _updateFreezePaneColumns(DataGridConfiguration dataGridConfiguration) {
    final int frozenColumnCount = grid_helper.resolveToScrollColumnIndex(
        dataGridConfiguration, dataGridConfiguration.frozenColumnsCount);
    if (frozenColumnCount > 0 && columnCount >= frozenColumnCount) {
      frozenColumns = frozenColumnCount;
    } else {
      frozenColumns = 0;
    }

    final int footerFrozenColumnsCount =
        dataGridConfiguration.footerFrozenColumnsCount;
    if (footerFrozenColumnsCount > 0 &&
        columnCount > frozenColumnCount + footerFrozenColumnsCount) {
      footerFrozenColumns = footerFrozenColumnsCount;
    } else {
      footerFrozenColumns = 0;
    }
  }

  void _updateFreezePaneRows(DataGridConfiguration dataGridConfiguration) {
    final int frozenRowCount = grid_helper.resolveToRowIndex(
        dataGridConfiguration, dataGridConfiguration.frozenRowsCount);
    if (frozenRowCount > 0 && rowCount >= frozenRowCount) {
      frozenRows = headerLineCount + dataGridConfiguration.frozenRowsCount;
    } else {
      frozenRows = headerLineCount;
    }

    final int footerFrozenRowsCount =
        dataGridConfiguration.footerFrozenRowsCount;
    final int bottomTableSummariesCount = grid_helper.getTableSummaryCount(
        dataGridConfiguration, GridTableSummaryRowPosition.bottom);
    footerFrozenRows = 0;
    if (footerFrozenRowsCount > 0 &&
        rowCount > frozenRows + footerFrozenRowsCount &&
        footerFrozenRowsCount < rowCount - frozenRowCount) {
      footerFrozenRows = footerFrozenRowsCount;
    }

    if (bottomTableSummariesCount > 0) {
      footerFrozenRows += bottomTableSummariesCount;
    }
  }

  /// Helps to reset the [DataGridRow] on each [DataRow] to refresh the
  /// [SfDataGrid] with editing and sorting is enabled.
  ///
  /// cause:
  /// * Instead of setting -1 to each rows on editing to refresh.
  void updateDataGridRows(DataGridConfiguration dataGridConfiguration) {
    void resetRowIndex(DataRowBase dataRow) {
      if (dataRow.rowType == RowType.dataRow) {
        final int resolvedRowIndex = grid_helper.resolveToRecordIndex(
            dataGridConfiguration, dataRow.rowIndex);
        if (resolvedRowIndex.isNegative) {
          return;
        }

        dataRow.dataGridRow =
            effectiveRows(dataGridConfiguration.source)[resolvedRowIndex];
        dataRow.dataGridRowAdapter = grid_helper.getDataGridRowAdapter(
            dataGridConfiguration, dataRow.dataGridRow!);
        dataRow.rowIndexChanged();
      }
    }

    rowGenerator.items.forEach(resetRowIndex);
  }

  /// Refreshes all the data grid rows in the `items` collection.
  void refreshView({bool clearEditing = true}) {
    void resetRowIndex(DataRowBase dataRow) {
      if (!clearEditing && dataRow.isEditing) {
        return;
      }
      dataRow.rowIndex = -1;
    }

    // Issue:
    // FLUT-6349 - Checkbox animation is happening for checkbox column
    // when setting rowCacheExtent count as available rows count.
    //
    // Fix:
    // We have resolved the issue by removing old data rows and creating
    // a new row for the corresponding index to restrict the checkbox state
    // changing animation issue when reusing.
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.rowsCacheExtent != null &&
        dataGridConfiguration.rowsCacheExtent! > 0) {
      rowGenerator.items.removeWhere(
          (DataRowBase dataRow) => dataRow.rowRegion == RowRegion.body);
      rowGenerator.items.forEach(resetRowIndex);
    } else {
      rowGenerator.items.forEach(resetRowIndex);
    }
  }

  /// Refreshes the data cell to update the current changes.
  void refreshViewStyle() {
    void updateColumn(DataCellBase dataCell) {
      dataCell
        ..isDirty = true
        ..updateColumn();
    }

    for (final DataRowBase dataRow in rowGenerator.items) {
      dataRow
        ..isDirty = true
        ..visibleColumns.forEach(updateColumn);
    }
  }

  /// Resets the swiping offset to disable swiping in the current view.
  void resetSwipeOffset({DataRowBase? swipedRow, bool canUpdate = false}) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (!dataGridConfiguration.allowSwiping) {
      return;
    }

    swipedRow = swipedRow ??
        dataGridConfiguration.rowGenerator.items
            .firstWhereOrNull((DataRowBase row) => row.isSwipingRow);

    if (swipedRow != null) {
      swipedRow.isSwipingRow = false;
    }

    dataGridConfiguration.swipingOffset = 0.0;
    dataGridConfiguration.isSwipingApplied = false;

    if (canUpdate) {
      notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
          propertyName: 'Swiping');
    }
  }
}

/// Represents a class that manages the row heights in the `SfDataGrid`.
class RowHeightManager {
  /// Defines the range of a header.
  Range header = Range();

  /// Defines the range of a body.
  Range body = Range();

  /// Defines the range of a footer.
  Range footer = Range();

  /// Contains a list of row indexes that needs to be refreshed.
  List<int> dirtyRows = <int>[];

  /// Checks whether the row index exists in the given region or not.
  bool contains(int index, RowRegion region) {
    Range range;
    if (region == RowRegion.header) {
      range = header;
    } else if (region == RowRegion.body) {
      range = body;
    } else {
      range = footer;
    }

    if (range.isEmpty()) {
      if (dirtyRows.contains(index)) {
        dirtyRows.remove(index);
      }

      return false;
    }

    if (index >= range.start && index <= range.end) {
      if (dirtyRows.contains(index)) {
        dirtyRows.remove(index);
        return false;
      }

      return true;
    }

    return false;
  }

  /// Sets the row at the given row index as dirty to refresh it in the view.
  void setDirty(int rowIndex) {
    if (!dirtyRows.contains(rowIndex)) {
      dirtyRows.add(rowIndex);
    }
  }

  /// Gets the range of rows at the given index.
  Range getRange(int index) {
    if (index == 0) {
      return header;
    } else if (index == 1) {
      return body;
    } else {
      return footer;
    }
  }

  /// Resets the ranges of rows in the `SfDataGrid`.
  void reset() {
    header.start =
        header.end = body.start = body.end = footer.start = footer.end = -1;
  }

  /// Resets the body range in the `SfDataGrid`.
  void resetBody() {
    body.start = body.end = -1;
  }

  /// Resets the footer range in the `SfDataGrid`.
  void resetFooter() {
    footer.start = footer.end = -1;
  }

  /// Updates the body range in the `SfDataGrid`.
  void updateBody(int index, int count) {
    if ((index + count) <= body.start) {
      resetBody();
      return;
    } else if (index > body.end) {
      return;
    } else {
      body.end = index;
    }
  }

  /// Updates the region of the rows in the given index.
  void updateRegion(int start, int end, RowRegion region) {
    Range range;
    if (region == RowRegion.header) {
      range = header;
    } else if (region == RowRegion.body) {
      range = body;
    } else {
      range = footer;
    }

    range
      ..start = start
      ..end = end;
  }
}

/// Defines a class [Range] that specifies the range of the rows.
class Range {
  /// Specifies the range start index.
  int start = -1;

  /// Specifies the range end index.
  int end = -1;

  /// Checks whether the range is empty or not.
  bool isEmpty() => start < 0 || end < 0;
}
