## Unreleased

**Features**

* Provided support for loading the PDF document on a specified page.
* Provided support for active viewport rendering. That is, at a higher zoom level, this feature renders only the part of the PDF document that is visible on the screen, ignoring the parts that are outside the viewport.
* Provided support to undo and redo the data filled in PDF forms.

**General**

* Provided the Material 3 theme support.

## [24.2.9] - 03/05/2024

**General**

* Upgraded the `js` package to the latest version 0.7.1 in the `syncfusion_pdfviewer_web` package.

## [24.2.8] - 02/27/2024

**Bugs**

* Now the page will be centered while zooming out in landscape orientation with pinch gestures in Single Page layout mode.

## [24.2.7] - 02/20/2024

**Features**

* Provided support to check and uncheck the grouped checkbox form fields that behave like a radio button in the PDF document.

## [24.2.5] - 02/13/2024

**Bugs**

* Now, the `SfPdfViewer` will not crash unexpectedly when closing the application before the PDF document is loaded on iOS and macOS platforms.

## [24.1.47] - 01/23/2024

**Bugs**

* Now, when viewing a single-page document in a continuous page layout, the user can fully zoom out of the document with a pinch gesture in the `SfPdfViewer` widget.

## [24.1.46] - 01/17/2024

**Bugs**

* Now, the application will not crash when switching the PDF document in the `SfPdfViewer` widget on the Windows platform.

**General**

* Upgraded the `intl` package to the latest version 0.19.0.

## [24.1.45] - 01/09/2024

**Bugs**

* Now, the `SfPdfViewer` will render the PDF pages considering the crop box value in iOS.
* Now, when using German locale, the 'Open' label in the hyperlink and password dialogs will be translated properly.

## [24.1.41] - 18/12/2023

**Bugs**

* Now, the `SfPdfViewer` will be properly deployed without namespace errors when built with a Gradle version greater than 8.x.

**Features**

* Provided support to add, remove, modify, and save text markup annotations in PDF files. The available text markups are highlight, underline, strikethrough, and squiggly.
* Provided support to scroll vertically in single-page layout mode.

## [23.2.6] - 11/28/2023 

**Bugs**

* Now, the `SfPdfViewer` will render the PDF pages considering the crop box value in iOS.
* Now, the position is maintained in the zoomed document when performing panning in `SfPdfViewer`.
* Now, the focus of the text form field is maintained when scrolling is performed in `SfPdfViewer`.

**Features**

* Enhanced the user experience of the scroll head by increasing its size in `SfPdfViewer`.

## [23.2.4] - 11/20/2023

**Bugs**

* Now, the `SfPdfViewer` will trigger the `onTap` callback when there is a slight touch slop too.

## [23.1.44] - 11/07/2023

**Bugs**

* Now, the `SfPdfViewer` does not trigger the `onTap` callback when performing a double-tap zoom.
* Now, in the single-page layout mode, the page position is maintained properly in landscape orientation when performing zoom in a specific PDF document.

**Features**

* Support to render the background color in the form fields has been provided.

## [23.1.42] - 10/24/2023

**Bugs**

* Now, the form fields are properly rendered in a document with a different page size in `SfPdfViewer`.

**Features**

* Provided support to render **digital signatures** in existing PDF documents in a non-interactive way to avoid data loss while viewing. The document's integrity is preserved if no editing operation is performed.

## [23.1.40] - 10/10/2023

**Bugs**

* Now, the default selection of the first item in the radio button form fields has been removed.

**Features**

* Provided the support to restrict the text form field editing based on its maximum length.

## [23.1.38] - 09/26/2023

**Bugs**

* Now, the PDF page content will be clear on iOS when zoomed in.

**Features**

* Provided support for the `continueImportOnError` option in the `importFormData` method.

## [23.1.36] - 09/15/2023

**Bugs**

* Now, the `pagePosition` property in `PdfGestureDetails` will return the tapped position in the PDF page coordinates.

## [22.2.10] - 08/22/2023

**Bugs**

* Now, the `AlertDialog` or `DatePicker` dialog is properly closed when invoked in the `onFormFieldFocusChange` callback.

**Features**

* Enhanced the user experience of the combo box form field by switching the `PopupMenuButton` with a `DropdownButton` widget in `SfPdfViewer`.
* Support for localization for the texts in the built-in signature pad dialog has been provided.

## [22.2.5] - 07/27/2023

**Bugs**

* The multi-line text form fields will now have the proper font size.

**Features**

* Support for filling out the list box form field has been provided.
* Support for filling or editing form fields programmatically has been provided.
* Provided focus change and value change callback support for form fields.
* Provided the support for the `onTap` callback to retrieve the page number, position, and page position when tapping on the `SfPdfViewer`.

## [22.1.34] - 06/21/2023

**Features**

* Support for filling out the form fields, such as text boxes, dropdown menus, checkboxes, radio buttons, and signatures, has been provided. It also offers additional features, such as the ability to save, export, and import the form data.
* Support for loading the pages with the width fitted on the Windows and Web platforms has been provided.

**General**

* Upgraded the `http` package to the latest version 1.0.0.
* Upgraded the `device_info_plus` package to the latest version 9.0.2.

## [21.2.4] - 05/09/2023

**Bugs**

* Now, the `SfPdfViewer` does not execute the `onDocumentLoaded` callback before the Pdf document loads.

## [21.2.3] - 05/03/2023

**Features**

* Support for customising the visibility of the page loading busy indicator has been provided.

## [21.1.38] - 04/04/2023

**Bugs**

* Now, the `SfPdfViewer` does not cause excessive widget rebuilding when no actions are performed on the PDF.

## [20.4.55] - 03/21/2023

**Bugs**

* Now, the `SfPdfViewer` does not cause text fields to lose focus when scrolling is active on an Android tablet or the iPad.
* Now, the keyboard shortcut navigation on the web platform works properly.

**Features**

* Support to set and adjust the maximum zoom level has been provided.

## [20.4.51] - 02/21/2022

* The password dialog is now displayed properly in the `SfPdfViewer` when localized.

## [20.4.43] - 01/10/2022

* Support for scrolling via remote button clicks on Android TV has been provided.

## [20.3.58] - 11/22/2022

**Bugs**

* Now, the PDF page will not be zoomed while performing a mouse scroll in the mobile view of the web platform.

**Features**

* Support for the text web link navigation has been provided.

## [20.3.52] - 10/26/2022

* When copying PDF content from the `SfPdfViewer` widget, spacing between the words is now added properly.

## [20.3.47] - 09/29/2022

**Features**

* Now, text search will be performed asynchronously on mobile and desktop platforms.
* Now, the busy indicator will be displayed before rendering the pages.

**Breaking changes**

* The `searchText` method will now return just the `PdfTextSearchResult` object instead of the `Future<PdfTextSearchResult>`.  Since the search will be performed asynchronously, the results will be returned periodically on a page-by-page basis, which can be retrieved using the `addListener` method in the application.
* When we navigate to a particular page and perform a search, then the first instance to be highlighted will be the document's first one instead of the navigated page's first instance.

## [20.2.44-beta] - 08/16/2022

* Now, the scrolling works with the appropriate scrolling animation on a document with the default zoom level.

## [20.2.43-beta] - 08/08/2022

**Bugs**

* Now, the PDF pages are positioned properly when setting the `initialZoomLevel`.
* Now, the cache memory will be cleared properly after loading a PDF document in the `SfPdfViewer` widget.

## [20.2.36-beta] - 06/30/2022

**Features**

* Open URLs or website links in the default browser just by clicking them. Also, hide or customize the built-in hyperlink navigation dialog.
* Now, the `SfPdfViewer` supports changing the user interface and functionalities like text search and copying text to suit the RTL languages.
* Enhanced the performance of the scroll fling animation to provide smoother and fluid scrolling. That is, the time taken by scroll fling action has been reduced up to 60%.

**Bugs**

* The application will no longer crash while loading a high-quality document in the `SfPdfViewer` widget.
* Now, the PDF pages will be rendered properly while switching the device orientation from portrait to landscape or vice versa.


## [20.1.57-beta] - 05/24/2022

**Bugs**

* Now,  the application will not close unexpectedly when scrolling the specific PDF document on the iOS device.
* Now,  the clarity of the PDF page is updated properly when changing the orientation.

## [20.1.56-beta] - 05/17/2022

* Resolved linter warnings due to Flutter 3 SDK upgradation.

## [20.1.47-beta] - 04/04/2022

**Features**

* Windows platform support has been provided.

**Bugs**

* The scrolling and panning performance in zoomed documents has now been improved.

**Breaking changes**

The following platform packages have been renamed. No changes in your pubspec.yaml is required since these changes will be reflected automatically.

| Old package name                                  | New package name                        |
|:-------------------------------------------------:|:---------------------------------------:|
| syncfusion_flutter_pdfviewer_platform_interface   | syncfusion_pdfviewer_platform_interface |
| syncfusion_flutter_pdfviewer_web                  | syncfusion_pdfviewer_web                |
| syncfusion_flutter_pdfviewer_macos                | syncfusion_pdfviewer_macos              |

## [19.4.55-beta] - 03/08/2022

* Now, the SfPdfViewer widget won't be crashed when scrolling continuously over the zoomed document.

## [19.4.48-beta] - 01/31/2022

**Breaking changes**

* `searchTextHighlightColor` property has been deprecated, instead use the `currentSearchTextHighlightColor` and `otherSearchTextHighlightColor` for customizing the search text highlight color.

## [19.4.40-beta] - 12/28/2021

* Now, PDF document will be loaded from the page of first occurrence when `searchText` is performed in `onDocumentLoaded` callback.

## [19.4.38-beta] - 12/17/2021

**Features**

* Support for loading password-protected or encrypted documents has been provided.
* Now, Page regions will be rendered in high resolution when a user zooms in on the page.

**Bugs**

* Now, PDF pages won't be overlapped when multi PDFs are placed inside `IndexedStack`

## [19.3.57-beta] - 12/07/2021

* `DisplayMetrics` deprecation warnings for Android R SDK in Android Plugin has been cleared now.

## [19.3.56-beta] - 11/30/2021

* Now, Linefeed will be included while copying PDF content in desktop platforms.

## [19.3.55-beta] - 11/23/2021

* PDF page clarity has been improved now when smaller page width document is loaded.

## [19.3.53-beta] - 11/12/2021

* Now, PDF pages can be panned when text selection is disabled.

## [19.3.46-beta] - 10/19/2021

* Support for text selection in multi-column PDF has been provided.

## [19.3.45-beta] - 10/12/2021

* Now, Network images won't be reloaded when rebuilding the SfPdfViewer widget.

## [19.3.43-beta] - 09/30/2021

**Features**

* Support for screen reading has been provided.
* Now, PDF document can be viewed page by page horizontally.
* Horizontal scrolling support has been provided.
* Support for text selection and text search in rotated document has been provided.

## [19.2.57-beta] - 08/24/2021

* Now, SfPdfViewer widget won't be rebuilding continuously without any user interaction.

## [19.2.51-beta] - 08/03/2021

* Now, `searchText` method works properly in `onDocumentLoaded` callback.

## [19.2.46-beta] - 07/06/2021

* Now, Grayscale images will be displayed properly in a PDF document while viewing in iOS 14.1 or later versions.

## [19.2.44-beta] - 06/30/2021

* The macOS platform support has been provided.

## [19.1.56-beta] - 04/13/2021

* Added headers parameter in `SfPdfViewer.network`.
* Now, PDF document will be displayed properly inside the `SizedBox` or `Container` Widgets in Web platform.

## [19.1.55-beta] - 04/06/2021

**Features**

* The Web platform support has been provided.
* Support to view the rotated PDF documents in the iOS platform has been provided.

## [18.4.48-beta] - 03/16/2021

* Now, the `computeDryLayout` has been implemented and SfPdfViewer widget will be compatible in all channels of Flutter SDK.

## [18.4.42-beta] - 02/09/2021

**Breaking changes**

* Now, the text selection color and handle color can be customized using `selectionColor` and `selectionHandleColor` properties of `TextSelectionTheme` respectively.

## [18.4.31-beta] - 12/22/2020

**Features**

* Now, the highlighted search instance in the zoomed document will be navigate properly.

## [18.4.30-beta] - 12/17/2020

**Features**

* Text Search - Select text presented in a PDF document.
* Text Selection - Search for text and navigate to all its occurrences in a PDF document instantly.
* Document Link Annotation - Navigate to the desired topic or position by tapping the document link annotation of the topics in the table of contents in a PDF document.
* Support to adjust the space between the pages has been provided.
* Provided `initialScrollOffset` and `initialZoomLevel` property to display the PDF document loaded with the specified scroll offset and zoom level respectively.

## [18.3.53-beta] - 12/08/2020

**Features**

* Page storage support has been provided, which preserves scroll offset and zoom level.
* Now, the async operation will be cancelled in case widget is being disposed and added mounted checks.

## [18.3.47-beta] - 11/05/2020

**Features**

* Now, the temporary PDF file created by Syncfusion Flutter SfPdfViewer will be inaccessible.

## [18.3.35-beta] - 10/01/2020

Initial release.

**Features**

* Virtual Scrolling - Easily scroll through the pages in the document with a fluent experience. The pages are rendered only when required to increase the loading and scrolling performance.
* Magnification - The content of the document can be efficiently zoomed in and out.
* Page navigation - Navigate to the desired pages instantly.
* Bookmark navigation - Bookmarks saved in the document are loaded and made ready for easy navigation. This feature helps navigate the topics bookmarked already within the PDF document.
* Themes - Easily switch between light and dark themes.
* Localization - All static text within the PDF Viewer can be localized to any supported language.