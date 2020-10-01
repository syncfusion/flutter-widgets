![syncfusion_flutter_pdf_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter-PDF-Banner.png)

# Syncfusion Flutter PDF

Syncfusion Flutter PDF is a feature rich and high-performance non-UI PDF library written natively in Dart. It allows you to add robust PDF functionalities to Flutter applications.

## Overview

The PDF package is a non-UI and reusable flutter library to create PDF reports programmatically with formatted text, images, shapes, tables, links, lists, header and footer, and more. The creation of PDF file follows the most popular PDF 1.7 (ISO 32000-1) and latest PDF 2.0 (ISO 32000-2) specifications.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion Commercial License or Syncfusion Community license. For more details, please check the [LICENSE](LICENSE) file.

**Note:** Our packages are now compatible with Flutter for Web. However, this will be in Beta until Flutter for Web becomes stable.

![PDF Overview](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Flutter-PDF-Overview.png)

## Table of contents
- [Key features](#key-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
  - [Create a PDF document from simple text](#create-a-pdf-document-from-simple-text)
  - [Add text using TrueType fonts](#add-text-using-truetype-fonts)
  - [Add images to a PDF document](#add-images-to-a-pdf-document)
  - [PDF document with flow layout](#pdf-document-with-flow-layout)
  - [Add bullets and lists](#add-bullets-and-lists)
  - [Add tables](#add-tables)
  - [Add headers and footers](#add-headers-and-footers)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Key Features

The following are the key features of Syncfusion Flutter PDF.

* Create multipage PDF files from scratch.
* Add Unicode and RTL text.
* Insert JPEG and PNG images to the PDF document.
* Generate table in PDF files with different styles and formats.
* Add headers and footers to the PDF file.
* Add different shapes to PDF file.
* Add hyperlinks and bookmarks to the PDF file.
* Add paragraph, bullets, and lists to the PDF file.
* Mobile and web platforms support.

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores, and view sample’ codes in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Other useful links

Take a look at the following to learn more about Syncfusion Flutter PDF:

* [User guide documentation](https://help.syncfusion.com/flutter/pdf/overview)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_pdf#-installing-tab-).

## Getting started

Import the following package to your project to create a PDF document from scratch.

```dart
import 'package:syncfusion_flutter_pdf/pdf.dart';
```

### Create a PDF document from simple text

Add the following code to create a simple PDF document.

```dart
// Create a new PDF document.
final PdfDocument document = PdfDocument();
// Add a PDF page and draw text.
document.pages.add().graphics.drawString(
    'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(0, 0, 150, 20));
// Save the document.
File('HelloWorld.pdf').writeAsBytes(document.save());
// Dispose the document.
document.dispose();
```

### Add text using TrueType fonts

Use the following code to add a Unicode text to the PDF document.

```dart
//Create a new PDF document
final PdfDocument document = PdfDocument();
//Read font data
final Uint8List fontData = File('arial.ttf').readAsBytesSync();
//Create a PDF true type font object
final PdfFont font = PdfTrueTypeFont(fontData, 12);
//Draw text using ttf font
document.pages.add().graphics.drawString('Hello World!!!', font,
    bounds: const Rect.fromLTWH(0, 0, 200, 50));
// Save the document
File('TrueType.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

### Add images to a PDF document

PdfBitmap class is used to draw images to a PDF document. Now, Syncfusion Flutter PDF supports only PNG and JPEG images. Refer to the following code to draw images to a PDF document.

```dart
//Create a new PDF document
final PdfDocument document = PdfDocument();
//Read image data
final Uint8List imageData = File('input.png').readAsBytesSync();
//Load the image using PdfBitmap
final PdfBitmap image = PdfBitmap(imageData);
//Draw the image to the PDF page
document.pages
    .add()
    .graphics
    .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
// Save the document
File('ImageToPDF.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

### PDF document with flow layout

Add the following code to create a PDF document with flow layout.

```dart
const String paragraphText =
    'Adobe Systems Incorporated\'s Portable Document Format (PDF) is the de facto'
    'standard for the accurate, reliable, and platform-independent representation of a paged'
    'document. It\'s the only universally accepted file format that allows pixel-perfect layouts.'
    'In addition, PDF supports user interaction and collaborative workflows that are not'
    'possible with printed documents.';

// Create a new PDF document
final PdfDocument document = PdfDocument();
// Add a new page to the document
final PdfPage page = document.pages.add();
// Create a new PDF text element class and draw the flow layout text
final PdfLayoutResult layoutResult = PdfTextElement(
        text: paragraphText,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
    .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
// Draw the next paragraph/content
page.graphics.drawLine(
    PdfPen(PdfColor(255, 0, 0)),
    Offset(0, layoutResult.bounds.bottom + 10),
    Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
// Save the document
File('TextFlow.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

### Add bullets and lists

Add the following code to create bullets and lists in a PDF document.

```dart
// Create a new PDF document
final PdfDocument document = PdfDocument();
// Add a new page to the document
final PdfPage page = document.pages.add();
// Create a PDF ordered list
final PdfOrderedList orderedList = PdfOrderedList(
    items: PdfListItemCollection(<String>[
      'Mammals',
      'Reptiles',
      'Birds',
      'Insects',
      'Aquatic Animals'
    ]),
    marker: PdfOrderedMarker(
        style: PdfNumberStyle.numeric,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12)),
    markerHierarchy: true,
    format: PdfStringFormat(lineSpacing: 10),
    textIndent: 10);
// Create a un ordered list and add it as a sublist.
orderedList.items[0].subList = PdfUnorderedList(
    marker: PdfUnorderedMarker(
        font: PdfStandardFont(PdfFontFamily.helvetica, 10),
        style: PdfUnorderedMarkerStyle.disk),
    items: PdfListItemCollection(<String>[
      'body covered by hair or fur',
      'warm-blooded',
      'have a backbone',
      'produce milk',
      'Examples'
    ]),
    textIndent: 10,
    indent: 20);
// Draw the list to the PDF page
orderedList.draw(
    page: page,
    bounds: Rect.fromLTWH(
        0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document
File('BulletandList.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

### Add tables

Add the following code to create a PDF table.

```dart
// Create a new PDF document
final PdfDocument document = PdfDocument();
// Add a new page to the document
final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables
final PdfGrid grid = PdfGrid();
// Specify the grid columns count
grid.columns.add(count: 3);
// Add a grid header row
final PdfGridRow headerRow = grid.headers.add(1)[0];
headerRow.cells[0].value = 'Customer ID';
headerRow.cells[1].value = 'Contact Name';
headerRow.cells[2].value = 'Country';
// Set header font
headerRow.style.font =
    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid
PdfGridRow row = grid.rows.add();
row.cells[0].value = 'ALFKI';
row.cells[1].value = 'Maria Anders';
row.cells[2].value = 'Germany';
// Add next row
row = grid.rows.add();
row.cells[0].value = 'ANATR';
row.cells[1].value = 'Ana Trujillo';
row.cells[2].value = 'Mexico';
// Add next row
row = grid.rows.add();
row.cells[0].value = 'ANTON';
row.cells[1].value = 'Antonio Mereno';
row.cells[2].value = 'Mexico';
// Set grid format
grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table to the PDF page.
grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
        0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document
File('PDFTable.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

### Add headers and footers

Use the following code to add headers and footers to a PDF document.

```dart
//Create a new PDF document
final PdfDocument document = PdfDocument();
//Create a PDF page template and add a header content
final PdfPageTemplateElement headerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text to the header
headerTemplate.graphics.drawString(
    'This is page header', PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Add the header element to the document
document.template.top = headerTemplate;
//Create a PDF page template and add a footer content
final PdfPageTemplateElement footerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text to the footer
footerTemplate.graphics.drawString(
    'This is page footer', PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Set footer to the document.
document.template.bottom = footerTemplate;
//Now create pages
document.pages.add();
document.pages.add();
// Save the document
File('HeaderandFooter.pdf').writeAsBytes(document.save());
// Dispose the document
document.dispose();
```

## Support and feedback

* For any other queries, contact our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums). You can also submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.



