import 'package:flutter/material.dart' hide SelectionChangedCallback;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
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

  /// A collection of [SfDataGrid] cell renderers.
  late Map<String, GridCellRendererBase> cellRenderers;

  /// The [DataGridSource] that provides the data for each row in [SfDataGrid]. Must
  /// be non-null.
  late DataGridSource source;

  /// The collection of the [GridColumn].
  late List<GridColumn> columns;

  /// Holds the details of the data grid's visual container.
  late VisualContainerHelper container;

  /// A class that can be generated the rows for the [SfDataGrid].
  late RowGenerator rowGenerator;

  /// How the column widths are determined.
  late ColumnWidthMode columnWidthMode;

  /// How the row count should be considered when calculating the width of a
  /// column.
  late ColumnWidthCalculationRange columnWidthCalculationRange;

  /// The [ColumnSizer] used to control the column width sizing operation of
  /// each columns.
  late ColumnSizer columnSizer;

  /// The [SelectionManagerBase] used to control the selection operations
  /// in [SfDataGrid].
  late SelectionManagerBase rowSelectionManager;

  /// The [DataGridController] used to control the current cell navigation and
  /// selection operation.
  late DataGridController controller;

  /// The [CurrentCellManager] used to manage the current cell operations.
  late CurrentCellManager currentCell;

  /// The [ColumnResizeController] used to control the column resizing operations.
  late ColumnResizeController columnResizeController;

  /// Provides the base functionalities to process the filtering in [SfDataGrid].
  late DataGridFilterHelper dataGridFilterHelper;

  /// The width of the current datagrid view.
  late double viewWidth;

  /// The height of the current datagrid view.
  late double viewHeight;

  /// How the horizontal scroll view should respond to the user input.
  late ScrollPhysics horizontalScrollPhysics;

  /// How the vertical scroll view should respond to the user input.
  late ScrollPhysics verticalScrollPhysics;

  /// The header line count in the [SfDataGrid].
  int headerLineCount = 0;

  /// The number of non-scrolling columns at the left side of [SfDataGrid].
  int frozenColumnsCount = 0;

  /// The number of non-scrolling columns at the right side of [SfDataGrid].
  int footerFrozenColumnsCount = 0;

  /// The number of non-scrolling rows at the top of [SfDataGrid].
  int frozenRowsCount = 0;

  /// The number of non-scrolling rows at the bottom of [SfDataGrid].
  int footerFrozenRowsCount = 0;

  /// The number of rows to show on each page.
  int? rowsPerPage;

  /// The height of each row except the column header.
  double rowHeight = double.nan;

  /// The height of the column header row.
  double headerRowHeight = double.nan;

  /// The default width of the [SfDataGrid] columns.
  double defaultColumnWidth = double.nan;

  /// How long the swiping is applied to the current `swipedRow`.
  double swipingOffset = 0.0;

  /// The distance from the [SfDataGrid]’s top or bottom edge to where the refresh
  /// indicator will settle.
  double refreshIndicatorDisplacement = 40.0;

  /// Defines `strokeWidth` for `RefreshIndicator` used by [SfDataGrid].
  double refreshIndicatorStrokeWidth = 2.0;

  /// Defines the maximum swipe offset set in [DataGridSwipeStartDetails] callback.
  double? effectiveSwipeMaxOffset;

  /// Defines the maximum offset in which a row can be swiped.
  double swipeMaxOffset = 200.0;

  /// The text scale factor of the current `MediaQuery` data.
  double textScaleFactor = 1.0;

  /// The height of the footer.
  double footerHeight = 49.0;

  /// Decides whether user can sort the column simply by tapping the column
  /// header.
  bool allowSorting = false;

  /// Decides whether user can sort more than one column.
  bool allowMultiColumnSorting = false;

  /// Checks whether the control key is pressed or not for enable multi sorting
  /// in Web and Desktop platforms.
  bool isControlKeyPressed = false;

  /// Checks whether the shift key is pressed or not for consecutive
  /// row selection in certain range
  bool isShiftKeyPressed = false;

  /// Decides whether user can sort the column in three states: ascending,
  /// descending, unsorted.
  bool allowTriStateSorting = false;

  /// Decides whether the sequence number should be displayed on the header cell
  ///  of sorted column during multi-column sorting.
  bool showSortNumbers = false;

  /// Checks whether the given platform is desktop or not.
  bool isDesktop = false;

  /// Indicates whether the horizontal and vertical scrollbars should always
  /// be visible.
  bool isScrollbarAlwaysShown = false;

  /// Decides whether refresh indicator should be shown when datagrid is pulled
  /// down.
  bool allowPullToRefresh = false;

  /// Decides whether to swipe a row “right to left” or “left to right” for custom
  /// actions such as deleting, editing, and so on.
  bool allowSwiping = false;

  /// This flag is used to restrict the scrolling while updating the swipe offset
  /// of a row that already swiped in view.
  bool isSwipingApplied = false;

  /// Decides whether to highlight a row when mouse hovers over it.
  bool highlightRowOnHover = true;

  /// Decides whether a column can be resized by the user interactively using a
  /// pointer.
  bool allowColumnsResizing = false;

  /// Decides whether cell should be moved into edit mode based on
  /// [editingGestureType].
  bool allowEditing = false;

  /// Decides whether [Checkbox] should be displayed in each row to select/deselect the rows.
  bool showCheckboxColumn = false;

  /// Checks whether the header check box is in active state or not.
  bool? headerCheckboxState = false;

  ///Decides Whether the height of [SfDataGrid] should be determined by the number of rows available.
  ///Defaults to false
  bool shrinkWrapRows = false;

  ///Decides Whether the width of [SfDataGrid] should be determined by the number of columns available.
  ///Defaults to false
  bool shrinkWrapColumns = false;

  /// Decides whether the UI filtering should be enabled for all the columns.
  ///
  /// [GridColumn.allowFiltering] has the highest priority over this property.
  bool allowFiltering = false;

  /// Called when the filtering is being applied through UI filtering.
  DataGridFilterChangingCallback? onFilterChanging;

  /// Called after the UI filtering is applied to [SfDataGrid].
  DataGridFilterChangedCallback? onFilterChanged;

  /// Contains all the properties of the checkbox column.
  DataGridCheckboxColumnSettings checkboxColumnSettings =
      const DataGridCheckboxColumnSettings();

  /// Decides whether the sorting should be applied on tap or double tap the
  /// column header.
  SortingGestureType sortingGestureType = SortingGestureType.tap;

  /// Decides whether the navigation in the [SfDataGrid] should be cell wise
  /// or row wise.
  GridNavigationMode navigationMode = GridNavigationMode.row;

  /// The text direction of the current `MediaQuery` data.
  TextDirection textDirection = TextDirection.ltr;

  /// Decides how many rows should be added with the currently visible items in viewport size.
  int? rowsCacheExtent;

  /// How the border should be visible.
  GridLinesVisibility gridLinesVisibility = GridLinesVisibility.horizontal;

  /// How the header cell border should be visible.
  GridLinesVisibility headerGridLinesVisibility =
      GridLinesVisibility.horizontal;

  /// How the rows should be selected.
  SelectionMode selectionMode = SelectionMode.none;

  /// Decides how column should be resized. It can be either along with indicator
  /// moves or releasing a pointer.
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;

  /// Indicates the scrolling state of the horizontal controller for ensure
  /// swiping.
  ScrollDirection scrollingState = ScrollDirection.idle;

  /// Decides whether the editing should be triggered on tap or double tap
  /// the cells.
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  /// A description of the style to use when drawing the datagrid's border and
  /// background color of the rows on a [Canvas].
  Paint? gridPaint;

  /// A class [BoxPainter] that paints a decoration on a [Canvas]. This is used
  /// to paint the current cell row border while rendering a corresponding row.
  BoxPainter? boxPainter;

  /// A class that can be used to handle focus events in the data grid.
  FocusNode? dataGridFocusNode;

  /// Provides the image configuration to draw decoration to the current cell
  /// on a [Canvas].
  ImageConfiguration? configuration;

  /// The key of the `RefreshIndicator` to call pull to refresh programmatically.
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  /// Animates the swiping to the swipeMaxOffset or beginning position.
  Animation<double>? swipingAnimation;

  /// The `AnimationContoller` is used to animate the swiping offsets.
  AnimationController? swipingAnimationController;

  /// A collection of [StackedHeaderRow].
  List<StackedHeaderRow> stackedHeaderRows = <StackedHeaderRow>[];

  /// The collection of [TableSummaryRow].
  ///
  /// This enables you to show the total or summary for columns i.e Max, Min,
  /// Average and Count for whole DataGrid.
  List<GridTableSummaryRow> tableSummaryRows = <GridTableSummaryRow>[];

  /// The density value for specifying the compactness of various UI components.
  VisualDensity visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Holds the color and typography values for a [SfDataGridTheme]. Use
  /// this class to configure a [SfDataGridTheme] widget.
  DataGridThemeHelper? dataGridThemeHelper;

  /// Instance of a [SfLocalizations] class that provide the localized resource
  /// values to the UI filtering lables.
  late SfLocalizations localizations;

  /// Controls a vertical scrolling in DataGrid.
  ScrollController? verticalScrollController;

  /// Controls a horizontal scrolling in DataGrid.
  ScrollController? horizontalScrollController;

  /// Called when row swiping is started.
  DataGridSwipeStartCallback? onSwipeStart;

  /// Called when row is being swiped
  DataGridSwipeUpdateCallback? onSwipeUpdate;

  /// Called when swiping of a row is ended (i.e. when reaches the max offset).
  DataGridSwipeEndCallback? onSwipeEnd;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reading direction.
  DataGridSwipeActionsBuilder? startSwipeActionsBuilder;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reverse of reading direction.
  DataGridSwipeActionsBuilder? endSwipeActionsBuilder;

  /// Invoked when the row height for each row is queried.
  QueryRowHeightCallback? onQueryRowHeight;

  /// Invoked when the row is being selected or being unselected
  SelectionChangingCallback? onSelectionChanging;

  /// Invoked when the row is selected.
  SelectionChangedCallback? onSelectionChanged;

  /// Invoked when the cell is activated.
  CurrentCellActivatedCallback? onCurrentCellActivated;

  /// Invoked when the cell is being activated.
  CurrentCellActivatingCallback? onCurrentCellActivating;

  /// Called when a tap with a cell has occurred.
  DataGridCellTapCallback? onCellTap;

  /// Called when user is tapped a cell with a primary button at the same cell
  /// twice in quick succession.
  DataGridCellDoubleTapCallback? onCellDoubleTap;

  /// Called when a tap with a cell has occurred with a secondary button.
  DataGridCellTapCallback? onCellSecondaryTap;

  /// Called when a long press gesture with a primary button has been
  /// recognized for a cell.
  DataGridCellLongPressCallback? onCellLongPress;

  /// A builder that sets the widget to display at the bottom of the datagrid
  /// when vertical scrolling reaches the end of the datagrid.
  LoadMoreViewBuilder? loadMoreViewBuilder;

  /// Called when a column is being resized when tapping and dragging the
  /// right-side border of the column header.
  ColumnResizeStartCallback? onColumnResizeStart;

  /// Called when a column is resizing when tapping and dragging the right-side
  /// border of the column header.
  ColumnResizeUpdateCallback? onColumnResizeUpdate;

  /// Called when a column is resized successfully.
  ColumnResizeEndCallback? onColumnResizeEnd;

  /// The widget to show over the bottom of the [SfDataGrid].
  Widget? footer;

  /// An instance of a [ThemeData.colorScheme] that can be used to configure the
  /// color properties in the [SfDataGrid].
  ColorScheme? colorScheme;

  /// Decides whether the Vertical ScrollController can be disposed of in the source itself.
  /// Default to true.
  bool disposeVerticalScrollController = true;

  /// Decides whether the Horizontal ScrollController can be disposed of in the source itself.
  /// Default to true.
  bool disposeHorizontalScrollController = true;
}
