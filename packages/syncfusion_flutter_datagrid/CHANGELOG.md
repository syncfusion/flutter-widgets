## Unreleased

**Features**

* Provided support for displaying column header icons, such as sort and filter icons, when hovering over the column header cells.

## [22.2.9] - 08/15/2023

**Bugs**

* The RangeError exception will no longer be thrown when changing the showCheckboxColumn property along with selection mode.

## [22.2.5] - 07/27/2023

**Features**

* Now, the current date is automatically selected as the initial date in the date picker within the Advanced UI filter menu when it falls between the first and last dates of the column or matches either of them.

## [22.1.39] - 07/18/2023

**Bugs**

* The state of the header checkbox cell is reset when updating the data grid rows.

## [22.1.34] - 06/21/2023

**Features**

* Provided the support to customize the visibility of horizontal and vertical scrollbars in the DataGrid.
* Provide the support to show the filter icon when the mouse hovers over the column header. Users have the option to enable or disable this hover feature by `showFilterIconOnHover`.
* Provided the support to set a `key` to the `DataGridRow`, it helps automate the data grid rows during automated testing.
* Provided the support to rearrange columns by dragging and dropping them.

## [21.2.10] - 06/13/2023

**Bugs**

* The DataGrid now properly retains focus on the current cell even when the keyboard is opened on Android and iOS platforms

## [21.2.4] - 05/09/2023

**Bugs**

* The `ColumnWidthMode` now calculates column width for header cells properly by taking into account the `maximumWidth` and `minimumWidth` properties, even when the source is empty.

## [21.1.41] - 04/18/2023

**Bugs**

* The `OK` button is now properly displayed in the UI filter menu when using the `Material3` design.

## [21.1.35] - 03/23/2023

**Features**

* Provided the support to change the position (left or right) of sort and filter icons in the column headers when sorting or filtering is applied.
* The `onCellSubmit`, `canSubmitCell`, and `performSorting` methods are marked async so that cell submission and sorting can be asynchronous.
* Provided the support to change the text style of all the elements in the filter pop menu. Users can set different text styles for enabled and disabled items.
* Provided the support to get the `currentcell` details when `navigationMode` is `row`.

## [20.4.53] - 03/07/2023

**Bugs**

* The scrolling performance is improved when autofitting the rows using `onQueryRowHeight` callback with large collection of rows.

## [20.4.51] - 02/21/2023

**Bugs**

* The RangeError exception is no longer be thrown when rebuilding the DataGrid after applying the filtering.
* The filter is now applied properly to the DataGrid when changing the DataGridSource dynamically.

## [20.4.48] - 02/01/2023

**Features**

* Added support for restricting column resizing by checking the `columnIndex` in the `onColumnResizeStart` callback.

**Bugs** 

* Fixed a LateInitializationError that occurred when opening the filter popup menu after rebuilding the DataGrid with an applied filter.
* Fixed a Type mismatch error that occurred when using an integer value in advanced filtering for a double type column.

**Breaking changes**

* `Command` key operations for selection and multi-column sorting have been replaced with `Control` key operations on the macOS platform.

## [20.4.43] - 01/10/2023

**Bugs**

* Edited rows from the grid when filtering and paging are applied. If the currently applied filter condition is not satisfied, the edited row will no longer be displayed in the DataGrid.

## [20.4.38] - 12/21/2022

**Features**

* Provided the support to change the shape of the built-in checkbox column.
* Provided the support to change the filter icon and its color. The padding around the filter icon can also be customized.
* Provided the support to customize the filter options in the filter popup. Users can hide the sorting and “Clear Filter” options and show only the checked listbox view or advanced filter popup view to apply filtering.
* Provided the support to customize the color of the sort order number and its rounded background.
* Provided the support to change the elevation effect when setting the `frozenPaneLineColor` property.

**Bugs**

* The filtering is now properly applied when programmatically adding the filter conditions and filter popup menu is now opened with proper items in checked listbox.

## [20.3.60] - 12/06/2022

**Bugs**

* The `onFilterChanging` and `onFilterChanged` callbacks will be called now when tapping `Select All` option to select all the rows in the checked listbox filtering.
* The current cell is now properly removed when setting the `selectedIndex` property as -1 programmatically.

## [20.3.59] - 11/29/2022

**Bugs**

* The focus is now moved to widgets that are outside the DataGrid when the canSubmitCell method returns true.

## [20.3.57] - 11/15/2022

**Bugs**

* The listeners in `SelectionController` class are properly disposed.

## [20.3.49] - 10/11/2022

**Bugs**

* The current cell is now updating properly while adding a row at runtime through the `RowSelectionManager`.
* SfDataPager is now working properly when changing the `pageCount` property at run time.

## [20.3.48] - 10/05/2022

**Bugs**

* Filtering is now working properly when page count is set for paging to apply whole data sorting.

## [20.3.47] - 09/29/2022

**Breaking changes**

* The left and border is now drawn by default in DataGrid. Hence, there is no need to add `Container` widget as parent for DataGrid to set left and top borders.
* If sorting is enabled for columns, an icon to notify the unsorted state of columns will be shown by default.

**Bugs**

* The `onSelectionChanged` callback is now properly called with the collection of deselected rows while deselecting through the checkbox in the column header.
* The parent scrollview widget of DataGrid is not now scrolled at application level when swiping a row in DataGrid.

**Features**

* Provided the support to perform Excel-like UI filtering and programmatic filtering of columns. Users can filter numeric, text, and date type columns with different filtering options.
* Provided the support to show the unsort icon in header cells when sorting is not applied to columns. When sorting, the ascending or descending icon will be shown.
* Using the `canSubmitCell` method, disallow the focus from the cell to other widgets outside the DataGrid or other cells in the DataGrid when editing is canceled.

## [20.2.43] - 08/23/2022

**Bugs**

* The `handlePageChange` method will not be called infinite times when using it asynchronously and switching between the pages very fast.

## [20.2.39] - 07/19/2022

**Bugs**

* The `handlePageChange` method is now called only once on initial loading of `SfDataPager`.
* The widths are properly set to columns when hiding some columns and using `columnWidthMode`.

## [20.2.38] - 07/12/2022

**Bugs**

* The next and previous buttons in `SfDataPager` are disabled even though the currently selected page is the last and the first page, respectively.

## [20.2.36] - 06/30/2022

**Bugs**

* The [verticalScrollController](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/verticalScrollController.html) and [horizontalScrollController](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/horizontalScrollController.html) are no longer disposed when the user sets in the application level.

## [20.1.58] - 05/31/2022

**Bugs**

* The null check operator used on a null value exception will no longer be thrown when deselecting all the selected rows programmatically.

## [20.1.57] - 05/24/2022

**Bugs**

* Checkbox is now properly unchecked when it is unchecked after being ticked

## [20.1.55] - 05/12/2022

**Bugs**

* BoxConstraints has a negative minimum height exception will no longer be thrown when opening the keyboard for `TextField` which is adjacent to `DataGrid`.
* Back key works properly while tapping the back key on an `Android` device and `DataGrid` has focus.

## [20.1.52] - 05/03/2022

**Bugs**

* DataGrid is now extended to its maximum height when setting the shrinkWrapRows to true and onQueryRowHeight callback.

## [20.1.48] - 04/12/2022

**Bugs**

* The animation will no longer be visible for checkbox column while scrolling when the `rowCacheExtent` property is set to the number of rows available in DataGrid.
* The `DataGridSource.handlePageChange` method will now wait asynchronously until the `Future.delayed` value specified in the method.
* Other cells will not be moved into edit mode when the last row is removed and a cell in that row is in edit mode.

## [20.1.47] - 04/04/2022

**Bugs**

* Other cell will not be moved into edit mode when trying to click it and returning false from `canSubmitCell` method for currentcell.

**Features**

* Provided the support to check whether the currentcell is in editing mode using `DataGridController.isCurrentCellInEditing` property.
* Provided the support to set the custom sort icon using `SfDataGridThemeData.sortIcon` property.

## [19.4.54] - 03/01/2022 

**Bugs**

* Horizontal scrollbar will no longer be shown when you type the text beyond the cell width on editing.

## [19.4.50] - 02/08/2022

**Bugs**

* Cell will no longer be navigated to non visible column's cell which is placed in 0th index.

## [19.4.42] - 01/11/2022

**Bugs**

* The null check operator exception will no longer be thrown when long press the table summary rows.

## [19.4.38] - 12/17/2021

**Features**

* Provided the support to set the different swipe offset for right and left swiping.
* Provided the support to select multiple rows when tapping another row and press and hold the SHIFT key
* Provided the support to wrap the DataGrid’s width and height based on number of rows and columns available when DataGrid’s  parent size is infinity.
* Provided the support to show a dropdown button for choosing a different number of rows to show on each page.
* Provided the support to set the number of rows to be added with the currently visible items in viewport size for reusing during vertical scrolling.

**Bugs**

* Range exception will no longer be thrown when DataGridSource is changed at run time with multiple rows are selected.

## [19.3.55] - 11/23/2021

**Bugs**

* The `assertion failed` exception will no longer be thrown when you scroll horizontally using scrollbar thumb track and `isScrollbarAlwaysShown` is enabled.

## [19.3.54] - 11/17/2021

**Bugs**

* Now, `onQueryRowHeight` callback will be called for all the rows in view when all the rows are available in view.

## [19.3.53] - 11/12/2021

**Breaking changes**

* Now, [onCellLongPress](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/onCellLongPress.html) callback will be called when long a pointer has remained in contact with the screen at the same location for a long period of time.

## [19.3.47] - 26/10/2021

**Bugs**

* `debugDisposed` and `debugDuringDeviceUpdate` errors are no longer occurred in debug mode when rebuilding the app from any of the DataGrid's `onCellDoubleTap` callback.

## [19.3.44] - 10/05/2021

**Features**
* Provided the support to export the DataGrid content with sorted order.

**Bugs**
* The focus is now retained in the `TextField`, which is outside the DataGrid, when calling the `notifyListeners` from TextField’s `onPressed` callback to update the data in DataGrid.

## [19.3.43] - 10/01/2021
 
**Features**
* Provided the support to resize the columns by tapping and dragging the right border of the column header.
* Provided the support to show an additional unbound row to display a summary or totals. Users can display a minimum, maximum, average, and count in columns.
* Provided the support to export the DataGrid content, such as rows, stacked header rows, and table summary rows, to Excel and PDF format with several customization options.
* Provided the support to show a checkbox in each row to select entire rows when the boxes are checked. Users can select or deselect all the rows by selecting the checkbox in the header.
* Provided the support to sort all the rows in DataGrid instead of current page alone when the paging is used.
* Provided the support to set the size for the page buttons in `SfDataPager`.
 
**Breaking changes**
* The `onCellRenderersCreated` callback has been removed from the `SfDataGrid`.

## [19.2.44-beta] - 06/30/2021

**Features**
* Provided the support to edit cell values. An editor widget can be loaded based on the column type to edit cell values.
* Provided the support to fit the rows and columns based on the value of the cells to improve readability.
* Provided the support to highlight a row when mouse hovers over it in Web and Desktop platforms.
* Provided the support to show an additional row that can be displayed below to last row. Widgets can also be displayed in the footer row.
* Provided the support to listen the vertical and horizontal scroll changes.
* Provided the support to write the entire logic for custom sorting instead of performing built-in sorting.

**Breaking changes**
* [GridTextColumn](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/GridTextColumn-class.html) class has been deprecated. Use [GridColumn](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/GridColumn-class.html) instead.
* \#I324459 - The DataGrid's built-in left and top borders have been removed. Set the required border configuration in the [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) widget and add `SfDataGrid` as a child.
* The `DataGridSource` class's `handleSort` method has been removed. To write the whole logic for custom sorting, override the `performSorting` method in `DataGridSource` class.

## [19.1.67-beta] - 06/08/2021

**Bugs**

*  Now, the background color for row is applied when transparent color is set.

## [19.1.56-beta] - 04/13/2021

**Bugs**

*  The column headers are now visible when the rows are empty.

## [19.1.55-beta] - 04/06/2021 

**Bugs**	
* Now, in Flutter 2.0,  text can be typed in TextField widget when you load it in cells in web platform.

**Features**
* Provided the support to refresh the data when the datagrid is pulled down.
* Provided the support to swipe a row “right to left” or “left to right” for custom actions such as deleting, editing, and so on. When the user swipes a row, the row will be moved, and swipe view will be shown for custom actions.
* Provided the support to scroll to a specific row, column, or cell. Also, users can scroll a row or column based on offset values.

**Breaking Changes**

We have documented all the API breaking details in  [this](https://www.syncfusion.com/downloads/support/directtrac/general/doc/API_Breaking_Changes_in_Flutter_DataGrid_in_2021_Volume_1-1910747829.docx) document.

## [18.4.49-beta] - 03/23/2021

**Bugs**

* Stack overflow exception is no longer thrown when comparing two DataGridSource class with hashCode.

## [18.4.47-beta] - 03/09/2021

**Bugs**

* Now, if the widget is loaded using the 'headerCellBuilder' function, the padding will not be considered for the column header.

## [18.4.33-beta] - 01/05/2021 

**Bugs**
	
* Now, when moving from a page with fewer rows than the size of the view port, rows are not clipped to another page with more rows than the size of the view port.

## [18.4.31-beta] - 12/22/2020

**Breaking Changes**

* Now, the row index is started from 0 instead of 1 for first row in `onQueryRowStyle` and `onQueryCellStyle` callbacks.

## [18.4.30-beta] - 12/17/2020

**Features**

* Provided the support to show stacked headers i.e. unbound header rows. Unbound header rows span stacked header columns across multiple rows and columns.
* Provided the support to display an interactive view when the grid reaches its maximum offset while scrolling down. Tapping the interactive view triggers a callback to add more data from the data source of the grid at run time.
* Provided the support to highlight the header cells on mouse hover.
* Provided the callbacks support in SfDataPager to listen when page navigation is started and ended.
* Provided the support to set grid lines for header and stacked header cells.
* Provided the support to improve the compactness of the datagrid based on the visual density.

**Breaking Changes**

* All the properties in GridTextColumn, GridNumericColumn, GridDateTimeColumn and GridWidgetColumn classes are marked as final. So, these classes are immutable. 

## [18.3.53-beta] - 12/08/2020

**Bugs**

* Now, the last row is considered to calculate the auto-fit column width.

## [18.3.52-beta] - 12/01/2020
	
**Features**

* Provided the support to show the scrollbars always and set the scrollphysics for vertical and horizontal scrollbars.

## [18.3.50-beta] - 11/17/2020

**Features**

* Provided the support to recalculate the column widths at run time.

## [18.3.40-beta] - 10/13/2020

**Features**

* Provided the support to apply custom sorting by overriding the `compare` method in `DataGridSource` class.

## [18.3.35-beta] - 10/01/2020

**Features**
	
* Provided the data pager support to load data in segments. It is useful when loading huge amounts of data. 
* Provided the support to fix (freeze) columns on the left and right sides.  You can also fix (freeze) the rows at the top and bottom of a DataGrid.
* Provided the support to sort one or more column in the ascending order and descending order.
* Provided the support to listen to callbacks for the following cell interactions,
    * Tap

    * Double tap

    * Secondary tap

    * Long press

* Provided the support to refresh the specific row's height at run time

**Breaking changes**

* The `isHidden` property has been renamed as `visible` in the `GridColumn` class.
* The argument of `onQueryRowHeight` callback has been removed. Previously there was `height` parameter. Now, `RowHeightDetails` is passed as parameter which has `rowHeight` and `rowIndex` properties.

## [18.2.59-beta] - 09/23/2020

No changes.

## [18.2.57-beta] - 09/08/2020

No changes.

## [18.2.56-beta] - 09/01/2020

No changes.

## [18.2.55-beta] - 08/25/2020

No changes.

## [18.2.54-beta] - 08/18/2020

No changes.

## [18.2.48-beta] - 08/04/2020

No changes.

## [18.2.47-beta] - 07/28/2020

No changes.

## [18.2.46-beta] - 07/21/2020

No changes.

## [18.2.45-beta] - 07/14/2020

No changes.

## [18.2.44-beta] - 07/07/2020

Initial release.

**Features** 

* Column types - Show different data types (int, double, string, and date-time) in different types of columns. Also, load any widget in a column.
* Column sizing - Set the width of columns with various sizing options. Columns can also be sized based on their content.
* Auto row height - Set the height for rows based on the content of their cells.
* Selection - Select one or more rows. Keyboard navigation is supported for web platforms.
* Styling - Customize the appearance of cells and headers. Conditional styling is also supported.
* Theme - Use a dark or light theme.
* Accessibility - The DataGrid can easily be accessed by screen readers.
* Right to Left (RTL) - Right-to-left direction support for users working in RTL languages like Hebrew and Arabic.