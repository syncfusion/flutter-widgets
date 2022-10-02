/// The Syncfusion Flutter DataGrid is used to display and manipulate data in a
/// tabular view. Its rich feature set includes different types of columns,
/// selections, column sizing, etc.
///
/// To use, import `package:syncfusion_flutter_datagrid/datagrid.dart`.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=-ULsEfjxFuY}
///
/// See also:
///
/// * [Syncfusion Flutter DataGrid product page](https://www.syncfusion.com/flutter-widgets/flutter-datagrid)
/// * [User guide documentation](https://help.syncfusion.com/flutter/datagrid/overview)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter/sfdatagrid)
library datagrid;

export './src/datagrid_widget/sfdatagrid.dart'
    hide
        updateSelectedIndex,
        updateSelectedRow,
        updateCurrentCellIndex,
        updateVerticalOffset,
        updateHorizontalOffset,
        notifyDataGridPropertyChangeListeners,
        handleLoadMoreRows,
        handleRefresh,
        updateDataSource,
        effectiveRows,
        setPageCount,
        setChildColumnIndexes,
        getChildColumnIndexes,
        addFilterConditions,
        removeFilterConditions,
        refreshEffectiveRows,
        DataGridThemeHelper;
export './src/datapager/sfdatapager.dart'
    hide SfDataPagerState, DataPagerThemeHelper;
export './src/grid_common/row_column_index.dart';
export 'src/datagrid_widget/helper/callbackargs.dart'
    hide setColumnSizerInRowHeightDetailsArgs;
export 'src/datagrid_widget/helper/enums.dart'
    hide FilteredFrom, AdvancedFilterType;
export 'src/datagrid_widget/runtime/column.dart'
    hide
        ColumnResizeController,
        refreshColumnSizer,
        initialRefresh,
        resetAutoCalculation,
        updateColumnSizerLoadedInitiallyFlag,
        getSortIconWidth,
        getFilterIconWidth,
        getAutoFitRowHeight,
        setStateDetailsInColumnSizer,
        isColumnSizerLoadedInitially,
        FilterElement,
        GridCheckboxColumn,
        DataGridFilterHelper,
        DataGridCheckboxFilterHelper,
        DataGridAdvancedFilterHelper;
export 'src/datagrid_widget/selection/selection_manager.dart'
    show RowSelectionManager, SelectionManagerBase;
export 'src/datagrid_widget/widgets/cell_widget.dart'
    show GridHeaderCellElement;
