## [unreleased]

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
