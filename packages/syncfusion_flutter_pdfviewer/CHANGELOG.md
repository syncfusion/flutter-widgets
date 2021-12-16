## Unreleased

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