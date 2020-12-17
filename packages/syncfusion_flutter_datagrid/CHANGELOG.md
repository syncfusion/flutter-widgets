## Unreleased

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