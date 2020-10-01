![syncfusion_flutter_pdfviewer](https://cdn.syncfusion.com/content/images/pdfviewer-banner.png)

# Syncfusion Flutter PDF Viewer

The Syncfusion Flutter PDF Viewer widget lets you view the PDF documents seamlessly and efficiently in the Android and iOS platforms. It has highly interactive and customizable features such as magnification, virtual scrolling, page navigation, and bookmark navigation.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or Syncfusion Community License. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [PDF Viewer features](#pdf-viewer-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
    - [Add PDF Viewer to the widget tree](#add-pdf-viewer-to-the-widget-tree)
    - [Customize the visibility of scroll head and scroll status](#customize-the-visibility-of-scroll-head-and-scroll-status)
    - [Customize the visibility of page navigation dialog](#customize-the-visibility-of-page-navigation-dialog)
	- [Enable or disable the double-tap zoom ](#enable-or-disable-the-double-tap-zoom)
	- [Change the zoom level factor](#change-the-zoom-level-factor)
	- [Navigate to the desired pages](#navigate-to-the-desired-pages)
	- [Navigate to the desired bookmark topics](#navigate-to-the-desired-bookmark-topics)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## PDF Viewer features

* **Virtual Scrolling** - Easily scroll through the pages in the document with a fluent experience. The pages are rendered only when required to increase the loading and scrolling performance.

* **Magnification** - The content of the document can be efficiently zoomed in and out.

* **Page navigation** - Navigate to the desired pages instantly.
![syncfusion_flutter_pdfviewer_page_navigation](https://cdn.syncfusion.com/content/images/PDFViewer/pagination-dialog.png)

* **Bookmark navigation** - Bookmarks saved in the document are loaded and made ready for easy navigation. This feature helps in navigation within the PDF document of the topics bookmarked already.
![syncfusion_flutter_pdfviewer_bookmark_navigation](https://cdn.syncfusion.com/content/images/PDFViewer/bookmark-navigation.png)

* **Themes** - Easily switch between the light and dark theme.
![syncfusion_flutter_pdfviewer_theme](https://cdn.syncfusion.com/content/images/PDFViewer/bookmark-navigation-dark.png)

* **Localization** - All static text within the PDF Viewer can be localized to any supported language.
![syncfusion_flutter_pdfviewer_localization](https://cdn.syncfusion.com/content/images/PDFViewer/localization.png)

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>
</p>

## Other useful links

Take a look at the following to learn more about Syncfusion Flutter PDF Viewer:

* [Syncfusion Flutter PDF Viewer product page](https://www.syncfusion.com/flutter-widgets/flutter-pdfviewer)
* [User guide documentation](https://help.syncfusion.com/flutter/pdf-viewer/overview)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_pdfviewer#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
```

## Add PDF Viewer to the widget tree

Add the SfPdfViewer widget as a child of any widget. Here, the SfPdfViewer widget is added as a child of the Container widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')));
}
```

## Customize the visibility of scroll head and scroll status

As a default, the SfPdfViewer displays the scroll head and scroll status. You can customize the visibility of these items using the **canShowScrollHead** and **canShowScrollStatus** properties.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              canShowScrollHead: false,
              canShowScrollStatus: false)));
}
```

## Customize the visibility of page navigation dialog

As a default, the page navigation dialog will be displayed when the scroll head is tapped. You can customize the visibility of the page navigation dialog using the **canShowPaginationDialog** property.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              canShowPaginationDialog: false)));
}
```

## Enable or disable the double-tap zoom

As a default, the SfPdfViewer will be zoomed in and out when double-tapped. You can enable or disable the double-tap zoom using the **enableDoubleTapZooming** property.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              enableDoubleTapZooming: false)));
}
```

## Change the zoom level factor

The content of the document can be zoomed in and out either by pinch and zoom or changing the zoom level factor programmatically. You can change or control the zoom level factor using the **zoomLevel** property. The zoom level factor value can be set between 1.0 and 3.0.

```dart
PdfViewerController _pdfViewerController;

@override
void initState() {
  _pdfViewerController = PdfViewerController();
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Syncfusion Flutter PdfViewer'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.zoom_in,
            color: Colors.white,
          ),
          onPressed: () {
            _pdfViewerController.zoomLevel = 2;
          },
        ),
      ],
    ),
    body: SfPdfViewer.network(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      controller: _pdfViewerController,
    ),
  );
}
```
## Navigate to the desired pages

The SfPdfViewer provides options to navigate to the desired pages using the following controller methods.

* **jumpToPage()** - Navigates to the specified page number in a PDF document.
* **nextPage()** - Navigates to the next page of a PDF document.
* **previousPage()** - Navigates to the previous page of a PDF document.
* **firstPage()** - Navigates to the first page of a PDF document.
* **lastPage()** - Navigates to the last page of a PDF document.

```dart
PdfViewerController _pdfViewerController;

@override
void initState() {
  _pdfViewerController = PdfViewerController();
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Syncfusion Flutter PdfViewer'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
          ),
          onPressed: () {
            _pdfViewerController.previousPage();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          onPressed: () {
            _pdfViewerController.nextPage();
          },
        )
      ],
    ),
    body: SfPdfViewer.network(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      controller: _pdfViewerController,
    ),
  );
}
```

## Navigate to the desired bookmark topics

As a default, the SfPdfViewer provides a default bookmark view to navigate to the bookmarked topics. You can also navigate to the desired bookmark topic programmatically using the **jumpToBookmark()** controller method.

```dart
final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Syncfusion Flutter PdfViewer'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons. bookmark,
            color: Colors.white,
          ),
          onPressed: () {
            _pdfViewerKey.currentState?.openBookmarkView();
          },
        ),
      ],
    ),
    body: SfPdfViewer.network(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      key: _pdfViewerKey,
    ),
  );
}
```

## Support and Feedback

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.