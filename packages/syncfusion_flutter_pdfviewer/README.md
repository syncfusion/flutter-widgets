![syncfusion_flutter_pdfviewer](https://cdn.syncfusion.com/content/images/pdfviewer-banner.png)

# Flutter PDF Viewer library

The Flutter PDF Viewer plugin lets you view PDF documents seamlessly and efficiently on the Android, iOS, Web, Windows, and macOS platforms. It has highly interactive and customizable features such as magnification, virtual bidirectional scrolling, page navigation, text selection, text search, page layout options, document link navigation, bookmark navigation, form filling, and reviewing with text markup annotations.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [PDF Viewer features](#pdf-viewer-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
	- [Add PDF Viewer to the widget tree](#add-pdf-viewer-to-the-widget-tree)
	- [Load PDF document from the Asset](#load-pdf-document-from-the-asset)
	- [Load PDF document from the Network](#load-pdf-document-from-the-network)
	- [Load PDF document from the File](#load-pdf-document-from-the-file)
	- [Load PDF document from the Memory](#load-pdf-document-from-the-memory)
	- [Load encrypted PDF document](#load-encrypted-pdf-document)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## PDF Viewer features

* **Virtual Scrolling** - Easily scroll through the pages in the document with a fluent experience. The pages are rendered only when required to increase the loading and scrolling performance.

* **Magnification** - The content of the document can be efficiently zoomed in and out.

* **Page Layout and Scroll Options** - Layout the pages efficiently in a page by page (single page) scrolling mode or continuous scrolling mode. Also, scroll through pages in both horizontal and vertical direction.

* **Page navigation** - Navigate to the desired pages instantly.

  ![syncfusion_flutter_pdfviewer_page_navigation](https://cdn.syncfusion.com/content/images/PDFViewer/pagination-dialog.png)

* **Text selection** - Select text presented in a PDF document.

  ![syncfusion_flutter_pdfviewer_text_selection](https://cdn.syncfusion.com/content/images/PDFViewer/text-selection.png)

* **Text search** - Search for text and navigate to all its occurrences in a PDF document instantly.

  ![syncfusion_flutter_pdfviewer_text_search](https://cdn.syncfusion.com/content/images/PDFViewer/text-search.png)

* **Bookmark navigation** - Bookmarks saved in the document are loaded and made ready for easy navigation. This feature helps in navigation within the PDF document of the topics bookmarked already.

  ![syncfusion_flutter_pdfviewer_bookmark_navigation](https://cdn.syncfusion.com/content/images/PDFViewer/bookmark-navigation.png)

* **Document link annotation navigation** - Navigate to the desired topic or position by tapping the document link annotation of the topics in the table of contents in a PDF document.

* **Hyperlink navigation** - Detects hyperlinks, and tapping on the hyperlink will open the URL in a default web browser.

* **Text markup annotations** - Add, remove, and modify text markup annotations in PDF files. The available text markups are highlight, underline, strikethrough and squiggly. This feature will help mark important passages, emphasize specific words or phrases, indicate that certain content should be removed or indicate that text contains possible errors.

  ![syncfusion_flutter_pdfviewer_text_markup_highlight](https://cdn.syncfusion.com/content/images/PDFViewer/highlight.png)

  ![syncfusion_flutter_pdfviewer_text_markup_underline](https://cdn.syncfusion.com/content/images/PDFViewer/underline.png)

  ![syncfusion_flutter_pdfviewer_text_markup_strikethrough](https://cdn.syncfusion.com/content/images/PDFViewer/strikethrough.png)

  ![syncfusion_flutter_pdfviewer_text_markup_squiggly](https://cdn.syncfusion.com/content/images/PDFViewer/squiggly.png)

* **Form filling** - Fill, edit, flatten, save, export, and import AcroForm field data in a PDF document.

  ![syncfusion_flutter_pdfviewer_form_filling](https://cdn.syncfusion.com/content/images/PDFViewer/form-filling.gif)

* **Right to Left (RTL)** - Change the user interface and functionalities such as text search and text copying to accommodate RTL languages such as Hebrew and Arabic.

* **Themes** - Easily switch between the light and dark theme.

  ![syncfusion_flutter_pdfviewer_theme](https://cdn.syncfusion.com/content/images/PDFViewer/bookmark-navigation-dark.png)

* **Localization** - All static text within the PDF Viewer can be localized to any supported language.

  ![syncfusion_flutter_pdfviewer_localization](https://cdn.syncfusion.com/content/images/PDFViewer/localization.png)

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play-store.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web-sample-browser.png"/></a>
  <a href="https://www.microsoft.com/en-us/p/syncfusion-flutter-gallery/9nhnbwcsf85d?activetab=pivot:overviewtab"><img src="https://cdn.syncfusion.com/content/images/FTControl/windows-store.png"/></a> 
</p>
<p align="center">
  <a href="https://install.appcenter.ms/orgs/syncfusion-demos/apps/syncfusion-flutter-gallery/distribution_groups/release"><img src="https://cdn.syncfusion.com/content/images/FTControl/macos-app-center.png"/></a>
  <a href="https://snapcraft.io/syncfusion-flutter-gallery"><img src="https://cdn.syncfusion.com/content/images/FTControl/snap-store.png"/></a>
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/github-samples.png"/></a>
</p>

## Other useful links

Take a look at the following to learn more about Syncfusion Flutter PDF Viewer:

* [Syncfusion Flutter PDF Viewer product page](https://www.syncfusion.com/flutter-widgets/flutter-pdf-viewer)
* [User guide documentation](https://help.syncfusion.com/flutter/pdf-viewer/overview)

## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_pdfviewer/install).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
```

## Add PDF Viewer to the widget tree

Add the **SfPdfViewer** widget as a child of any widget. Here, the **SfPdfViewer** widget is added as a child of the **Container** widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')));
}
```

### Web integration

We have used [PdfJs](https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.min.js) for rendering the PDF page as an image on the web platform, so the script file must be referred to in your `web/index.html` file.

On your `web/index.html` file, add the following `script` tags, somewhere in the `body` of the document:

```html
<script src="//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"></script>
<script type="text/javascript">
   pdfjsLib.GlobalWorkerOptions.workerSrc = "//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.worker.min.js";
</script>
```

## Load PDF document from the Asset

The [SfPdfViewer.asset](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/SfPdfViewer/SfPdfViewer.asset.html) creates a widget that displays the PDF document obtained from an [AssetBundle](https://api.flutter.dev/flutter/services/AssetBundle-class.html).

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: SfPdfViewer.asset(
              'assets/flutter-succinctly.pdf'));
}
```

## Load PDF document from the Network

The [SfPdfViewer.network](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/SfPdfViewer/SfPdfViewer.network.html) creates a widget that displays the PDF document obtained from a URL.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'));
}
```

## Load PDF document from the File

The [SfPdfViewer.file](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/SfPdfViewer/SfPdfViewer.file.html) creates a widget that displays the PDF document obtained from a [File](https://api.flutter.dev/flutter/dart-io/File-class.html).

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: SfPdfViewer.file(
              File('storage/emulated/0/Download/flutter-succinctly.pdf')));
}
```

## Load PDF document from the Memory

The [SfPdfViewer.memory](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/SfPdfViewer/SfPdfViewer.memory.html) creates a widget that displays the PDF document obtained from the [Uint8List](https://api.flutter.dev/flutter/dart-typed_data/Uint8List-class.html).

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: SfPdfViewer.memory(
              bytes));
}
```

## Load encrypted PDF document

Encrypted or password-protected document can be loaded in the **SfPdfViewer** widget by specifying the password in [password](https://pub.dev/documentation/syncfusion_flutter_pdfviewer/latest/pdfviewer/SfPdfViewer/password.html) property.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/encrypted.pdf',
              password: 'syncfusion')));
}
```

## Support and Feedback

* For any other queries, reach our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components),  [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.       