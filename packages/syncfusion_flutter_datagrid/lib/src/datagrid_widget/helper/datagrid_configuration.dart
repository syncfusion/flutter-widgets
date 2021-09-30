import 'package:flutter/material.dart' hide SelectionChangedCallback;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../runtime/cell_renderers.dart';
import '../runtime/column.dart';
import '../runtime/generator.dart';
import '../selection/selection_manager.dart';
import '../sfdatagrid.dart';
import '../widgets/scrollview_widget.dart';
import 'enums.dart';

/// Signature for the `_DataGridConfiguration` callback.
typedef DataGridStateDetails = DataGridConfiguration Function();

/// Holding to core setting of data grid
class DataGridConfiguration {
  // late assignable values and non-null

  /// ToDo
  late Map<String, GridCellRendererBase> cellRenderers;

  /// ToDo
  late DataGridSource source;

  /// ToDo
  late List<GridColumn> columns;

  /// ToDo
  late VisualContainerHelper container;

  /// ToDo
  late RowGenerator rowGenerator;

  /// ToDo
  late ColumnWidthMode columnWidthMode;

  /// ToDo
  late ColumnWidthCalculationRange columnWidthCalculationRange;

  /// ToDo
  late ColumnSizer columnSizer;

  /// ToDo
  late SelectionManagerBase rowSelectionManager;

  /// ToDo
  late DataGridController controller;

  /// ToDo
  late CurrentCellManager currentCell;

  /// ToDo
  late ColumnResizeController columnResizeController;

  /// ToDo
  late double viewWidth;

  /// ToDo
  late double viewHeight;

  /// ToDo
  late ScrollPhysics horizontalScrollPhysics;

  /// ToDo
  late ScrollPhysics verticalScrollPhysics;

  /// ToDo
  int headerLineCount = 0;

  /// ToDo
  int frozenColumnsCount = 0;

  /// ToDo
  int footerFrozenColumnsCount = 0;

  /// ToDo
  int frozenRowsCount = 0;

  /// ToDo
  int footerFrozenRowsCount = 0;

  /// ToDo
  int? rowsPerPage;

  /// ToDo
  double rowHeight = double.nan;

  /// ToDo
  double headerRowHeight = double.nan;

  /// ToDo
  double defaultColumnWidth = double.nan;

  /// ToDo
  double swipingOffset = 0.0;

  /// ToDo
  double refreshIndicatorDisplacement = 40.0;

  /// ToDo
  double refreshIndicatorStrokeWidth = 2.0;

  /// ToDo
  double swipeMaxOffset = 200.0;

  /// ToDo
  double textScaleFactor = 1.0;

  /// ToDo
  double footerHeight = 49.0;

  /// ToDo
  bool allowSorting = false;

  /// ToDo
  bool allowMultiColumnSorting = false;

  /// ToDo
  bool isControlKeyPressed = false;

  /// ToDo
  bool allowTriStateSorting = false;

  /// ToDo
  bool showSortNumbers = false;

  /// ToDo
  bool isDesktop = false;

  /// ToDo
  bool isScrollbarAlwaysShown = false;

  /// ToDo
  bool allowPullToRefresh = false;

  /// ToDo
  bool allowSwiping = false;
  // This flag is used to restrict the scrolling while updating the swipe offset
  // of a row that already swiped in view.
  /// ToDo
  bool isSwipingApplied = false;

  /// ToDo
  bool highlightRowOnHover = true;

  /// ToDo
  bool allowColumnsResizing = false;

  /// ToDo
  bool allowEditing = false;

  /// ToDo
  bool showCheckboxColumn = false;

  /// Todo
  bool? headerCheckboxState = false;

  /// Todo
  DataGridCheckboxColumnSettings checkboxColumnSettings =
      const DataGridCheckboxColumnSettings();

  /// ToDo
  SortingGestureType sortingGestureType = SortingGestureType.tap;

  /// ToDo
  GridNavigationMode navigationMode = GridNavigationMode.row;

  /// ToDo
  TextDirection textDirection = TextDirection.ltr;

  /// ToDo
  GridLinesVisibility gridLinesVisibility = GridLinesVisibility.horizontal;

  /// ToDo
  GridLinesVisibility headerGridLinesVisibility =
      GridLinesVisibility.horizontal;

  /// ToDo
  SelectionMode selectionMode = SelectionMode.none;

  /// ToDo
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;

  /// ToDo
  ScrollDirection scrollingState = ScrollDirection.idle;

  /// ToDo
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  /// ToDo
  Paint? gridPaint;

  /// ToDo
  BoxPainter? boxPainter;

  /// ToDo
  FocusNode? dataGridFocusNode;

  /// ToDo
  ImageConfiguration? configuration;

  /// ToDo
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  /// ToDo
  Animation<double>? swipingAnimation;

  /// ToDo
  AnimationController? swipingAnimationController;

  /// ToDo
  List<StackedHeaderRow> stackedHeaderRows = <StackedHeaderRow>[];

  /// The collection of [TableSummaryRow].
  ///
  /// This enables you to show the total or summary for columns i.e Max, Min,
  /// Average and Count for whole DataGrid.
  List<GridTableSummaryRow> tableSummaryRows = <GridTableSummaryRow>[];

  /// ToDo
  VisualDensity visualDensity = VisualDensity.adaptivePlatformDensity;

  /// ToDo
  SfDataGridThemeData? dataGridThemeData;

  /// ToDo
  ScrollController? verticalScrollController;

  /// ToDo
  ScrollController? horizontalScrollController;

  /// ToDo
  DataGridSwipeStartCallback? onSwipeStart;

  /// ToDo
  DataGridSwipeUpdateCallback? onSwipeUpdate;

  /// ToDo
  DataGridSwipeEndCallback? onSwipeEnd;

  /// ToDo
  DataGridSwipeActionsBuilder? startSwipeActionsBuilder;

  /// ToDo
  DataGridSwipeActionsBuilder? endSwipeActionsBuilder;

  /// ToDo
  QueryRowHeightCallback? onQueryRowHeight;

  /// ToDo
  SelectionChangingCallback? onSelectionChanging;

  /// ToDo
  SelectionChangedCallback? onSelectionChanged;

  /// ToDo
  CurrentCellActivatedCallback? onCurrentCellActivated;

  /// ToDo
  CurrentCellActivatingCallback? onCurrentCellActivating;

  /// ToDo
  DataGridCellTapCallback? onCellTap;

  /// ToDo
  DataGridCellDoubleTapCallback? onCellDoubleTap;

  /// ToDo
  DataGridCellTapCallback? onCellSecondaryTap;

  /// ToDo
  DataGridCellLongPressCallback? onCellLongPress;

  /// ToDo
  LoadMoreViewBuilder? loadMoreViewBuilder;

  /// ToDo
  ColumnResizeStartCallback? onColumnResizeStart;

  /// ToDo
  ColumnResizeUpdateCallback? onColumnResizeUpdate;

  /// ToDo
  ColumnResizeEndCallback? onColumnResizeEnd;

  /// ToDo
  Widget? footer;
}
