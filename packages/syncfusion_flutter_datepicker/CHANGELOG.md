## 15/03/2024

**General**
* Provided th​e Material 3 themes support.

**Bug fixes**
* \#FB50679 - Now, text size remains consistent when the app state or themes gets changed.

## [24.1.46] - 17/01/2024

**General**
* Upgraded the `intl` package to the latest version 0.19.0.

## [19.4.38] - 12/17/2021
**Features**
* Provided support to extendable range selection direction in the date range picker.

**Bug fixes**
* Now, the action button is working properly without selecting any dates in the `SfDateRangePicker`.

## [19.3.43] - 09/30/2021

**Features**
* Added a Today button in the Date Range Picker to move to today’s date.
* Added a selectable day predicate callback to decide whether a cell is selectable or not.

## [19.2.44] - 06/30/2021
**Features**
* Provided support to display week numbers of the year.
* Provided extendable range selection support to extend the selected range.

## [19.1.54-beta] - 03/30/2021
**Features**
* Implemented the free scroll support in the date range picker.
* Implemented action buttons to confirm and cancel the selection in the date range picker.
* Provided the support for enabling and disable the swiping interaction in the date range picker.

**Breaking changes**
* Now, the header text will align to the left instead of center when the multiview is enabled in the date range picker.

## [18.4.34-beta]
**Breaking changes**
* Now, the `date` and `visibleDates` types are changed from dynamic to respective types in the cell builder of the Date range picker.

## [18.4.30-beta]
**Features**
* Hijri date picker support is provided.
* The custom builder support is provided for the month cells and year cells in the date range picker.
* Vertical date picker support provided.

## [18.3.47-beta] - 11/03/2020
**Bug fixes**
* Now, the 24th-month date view in the `SfDateRangePicker` is rendering correctly.

## [18.3.44-beta] - 10/27/2020
**Bug fixes**
* Now, the `startRangeSelectionColor` and `endRangeSelectionColor` have been applied properly to the range selection of month view with `selectionShape` as a rectangle.
* Now, when defining the image for the `cellDecoration` property, the 'DateRangePickerMonthCellStyle' works correctly.

## [18.3.35-beta] - 10/01/2020
**Bug fixes**
* Now, the `endDate` of `PickerDateRange` in `DateRangePickerSelectionChangedArgs` will not be set before the `startDate`.

## [18.2.59-beta] - 09/23/2020 
No changes.

## [18.2.57-beta] - 09/08/2020 
**Bug fixes**
* Now, the Locale translation was working fine for the month view header of the `SfDateRangePicker`.

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

## [18.2.44-beta]

**Breaking changes**
* The `selectionTextStyle`, `selectionColor`, `startRangeSelectionColor`, `rangeSelectionColor`, `endRangeSelectionColor`, `rangeTextStyle` and `selectionStyle` properties from `DateRangePickerMonthCellStyle` class has been deprecated, use the same properties from `SfDateRangePicker` class instead.

**Features**
* Enable/disable built in view switching support.
* Multi-date picker view support

## [18.1.48-beta] - 05/05/2020

No changes.

## [18.1.46-beta] - 04/28/2020

No changes.

## [18.1.45-beta] - 04/21/2020

No changes.

## [18.1.44-beta] - 04/14/2020 

No changes.

## [18.1.43-beta] - 04/07/2020 

No changes.

## [18.1.42-beta] - 04/01/2020 

No changes.

## [18.1.36-beta] - 03/19/2020

Initial release.

**Features** 
* Supports four types of built-in views such as month, year, decade, and century views. 
* Navigate back and forth the date-range views and between different view modes. 
* Select single, multiple, and range of dates in month view. 
* First day of week support. 
* Supports minimum and maximum date range. 
* Disable dates support and weekend, special and blackout dates in month view. 
* Localization support. 
* Theme support. 
* Right to left support. 
* Accessibility support. 
* Selection style customization.