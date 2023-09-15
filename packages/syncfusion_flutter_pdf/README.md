![syncfusion_flutter_pdf_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter-PDF-Banner.png)

# Flutter PDF library

Flutter PDF is a feature-rich and high-performance non-UI PDF library written natively in Dart. It allows you to add robust PDF functionalities to Flutter applications.

See an interactive demo here: https://flutter.syncfusion.com/#/pdf/invoice

## Overview

The PDF package is a non-UI, reusable Flutter library for creating PDF reports programmatically with formatted text, images, shapes, tables, links, lists, headers, footers, and more. The library can be used to create, read, edit, and secure PDF documents in Flutter mobile and web platforms without dependency on Adobe Acrobat. The creation of a PDF follows the most popular PDF 1.7 (ISO 32000-1) and latest PDF 2.0 (ISO 32000-2) specifications.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

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
  - [Load and modify an existing PDF document](#load-and-modify-an-existing-pdf-document)
  - [Create and load annotations](#create-and-load-annotations)
  - [Add bookmarks](#add-bookmarks)
  - [Extract text](#extract-text)
  - [Find text](#find-text)
  - [Encryption and decryption](#encryption-and-decryption)
  - [PDF conformance](#pdf-conformance)
  - [PDF form](#pdf-form)
  - [Digital signature](#digital-signature)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Key features

The following are the key features of Syncfusion Flutter PDF:

* Create multipage PDF files from scratch.
* Add Unicode and RTL text.
* Insert JPEG and PNG images in the PDF document.
* Generate tables in PDF files with different styles and formats.
* Add headers and footers.
* Add different shapes to PDF files.
* Add paragraphs, bullets, and lists.
* Open, modify, and save existing PDF files.
* Encrypt and decrypt PDF files with advanced standards.
* Add, modify, and remove interactive elements such as bookmarks, annotations, hyperlinks, and attachments.
* Create PDF/A-1B, PDF/A-2B, PDF/A-3B conformances.
* Digitally sign PDF documents.
* Use on mobile and web platforms.

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores and viewing the sample code in GitHub.

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

Take a look at the following to learn more about Syncfusion Flutter PDF:

* [Syncfusion Flutter PDF product page](https://www.syncfusion.com/flutter-widgets/pdf-library)
* [User guide documentation](https://help.syncfusion.com/flutter/pdf/overview)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub.dev](https://pub.dartlang.org/packages/syncfusion_flutter_pdf#-installing-tab-).

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
File('HelloWorld.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Add text using TrueType fonts

Use the following code to add a Unicode text to the PDF document.

```dart
//Create a new PDF document.
final PdfDocument document = PdfDocument();
//Read font data.
final Uint8List fontData = File('arial.ttf').readAsBytesSync();
//Create a PDF true type font object.
final PdfFont font = PdfTrueTypeFont(fontData, 12);
//Draw text using ttf font.
document.pages.add().graphics.drawString('Hello World!!!', font,
    bounds: const Rect.fromLTWH(0, 0, 200, 50));
// Save the document.
File('TrueType.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Add images to a PDF document

The PdfBitmap class is used to draw images in a PDF document. Syncfusion Flutter PDF supports PNG and JPEG images. Refer to the following code to draw images in a PDF document. 

```dart
//Create a new PDF document.
final PdfDocument document = PdfDocument();
//Read image data.
final Uint8List imageData = File('input.png').readAsBytesSync();
//Load the image using PdfBitmap.
final PdfBitmap image = PdfBitmap(imageData);
//Draw the image to the PDF page.
document.pages
    .add()
    .graphics
    .drawImage(image, const Rect.fromLTWH(0, 0, 500, 200));
// Save the document.
File('ImageToPDF.pdf').writeAsBytes(await document.save());
// Dispose the document.
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

// Create a new PDF document.
final PdfDocument document = PdfDocument();
// Add a new page to the document.
final PdfPage page = document.pages.add();
// Create a new PDF text element class and draw the flow layout text.
final PdfLayoutResult layoutResult = PdfTextElement(
        text: paragraphText,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
    .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
// Draw the next paragraph/content.
page.graphics.drawLine(
    PdfPen(PdfColor(255, 0, 0)),
    Offset(0, layoutResult.bounds.bottom + 10),
    Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
// Save the document.
File('TextFlow.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Add bullets and lists

Add the following code to create bullets and lists in a PDF document.

```dart
// Create a new PDF document.
final PdfDocument document = PdfDocument();
// Add a new page to the document.
final PdfPage page = document.pages.add();
// Create a PDF ordered list.
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
// Draw the list to the PDF page.
orderedList.draw(
    page: page,
    bounds: Rect.fromLTWH(
        0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document.
File('BulletandList.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Add tables

Add the following code to create a PDF table.

```dart
// Create a new PDF document.
final PdfDocument document = PdfDocument();
// Add a new page to the document.
final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
final PdfGrid grid = PdfGrid();
// Specify the grid column count.
grid.columns.add(count: 3);
// Add a grid header row.
final PdfGridRow headerRow = grid.headers.add(1)[0];
headerRow.cells[0].value = 'Customer ID';
headerRow.cells[1].value = 'Contact Name';
headerRow.cells[2].value = 'Country';
// Set header font.
headerRow.style.font =
    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid.
PdfGridRow row = grid.rows.add();
row.cells[0].value = 'ALFKI';
row.cells[1].value = 'Maria Anders';
row.cells[2].value = 'Germany';
// Add next row.
row = grid.rows.add();
row.cells[0].value = 'ANATR';
row.cells[1].value = 'Ana Trujillo';
row.cells[2].value = 'Mexico';
// Add next row.
row = grid.rows.add();
row.cells[0].value = 'ANTON';
row.cells[1].value = 'Antonio Mereno';
row.cells[2].value = 'Mexico';
// Set grid format.
grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
        0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document.
File('PDFTable.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Add headers and footers

Use the following code to add headers and footers to a PDF document.

```dart
//Create a new PDF document.
final PdfDocument document = PdfDocument();
//Create a PDF page template and add header content.
final PdfPageTemplateElement headerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the header.
headerTemplate.graphics.drawString(
    'This is page header', PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Add the header element to the document.
document.template.top = headerTemplate;
//Create a PDF page template and add footer content.
final PdfPageTemplateElement footerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the footer.
footerTemplate.graphics.drawString(
    'This is page footer', PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Set footer in the document.
document.template.bottom = footerTemplate;
//Now create pages.
document.pages.add();
document.pages.add();
// Save the document.
File('HeaderandFooter.pdf').writeAsBytes(await document.save());
// Dispose the document.
document.dispose();
```

### Load and modify an existing PDF document

Add the following code to load and modify the existing PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Get the existing PDF page.
final PdfPage page = document.pages[0];
//Draw text in the PDF page.
page.graphics.drawString(
    'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(0, 0, 150, 20));
//Save the document.
File('output.pdf').writeAsBytes(await document.save());
//Dispose the document.
document.dispose();
```

Add the following code to add or remove a page from the existing PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Remove the page from the document.
document.pages.removeAt(0);
//Add new page and draw text.
document.pages.add().graphics.drawString(
    'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: const Rect.fromLTWH(0, 0, 150, 20));
//Save the document.
File('output.pdf').writeAsBytes(await document.save());
//Dispose the document.
document.dispose();
```

### Create and load annotations

Using this package, we can create and load annotations in a new or existing PDF document.

Add the following code to create a new annotation in a PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Create a new rectangle annotation and add to the PDF page.
document.pages[0].annotations.add(PdfRectangleAnnotation(
      Rect.fromLTWH(0, 0, 150, 100), 'Rectangle',
      color: PdfColor(255, 0, 0), setAppearance: true));
//Save the document.
File('annotations.pdf').writeAsBytes(await document.save());
//Dispose the document.
document.dispose();
```

Add the following code to load the annotation and modify it.

```dart
//Load and modify the existing annotation.
final PdfRectangleAnnotation rectangleAnnotation =
    document.pages[0].annotations[0] as PdfRectangleAnnotation;
//Change the annotation text.
rectangleAnnotation.text = 'Changed';
```

Refer to our documentation for more details about [annotations](https://help.syncfusion.com/flutter/pdf/working-with-annotations).

### Add bookmarks

Add the following code to create bookmarks in a PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Create a document bookmark.
final PdfBookmark bookmark = document.bookmarks.add('Page 1');
//Set the destination page and location.
bookmark.destination = PdfDestination(document.pages[1], Offset(20, 20));
//Set the bookmark color.
bookmark.color = PdfColor(255, 0, 0);
//Save the document.
File('bookmark.pdf').writeAsBytes(await document.save());
//Dispose the document.
document.dispose();
```

Refer to our documentation for more details about [bookmarks](https://help.syncfusion.com/flutter/pdf/working-with-bookmarks).

### Extract text

Using this package, we can extract text from an existing PDF document along with its bounds.

Add the following code to extract text from a PDF document.

```dart
//Load an existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Extract the text from all the pages.
String text = PdfTextExtractor(document).extractText();
//Dispose the document.
document.dispose();
```

The following code sample explains how to extract text from a specific page.

```dart
//Load an existing PDF document.
PdfDocument document =
   PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Extract the text from page 1.
String text = PdfTextExtractor(document).extractText(startPageIndex: 0);
//Dispose the document.
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-text-extraction) for more details.

### Find text

Using this package, we can find text in an existing PDF document along with its bounds and page index.

Add the following code to find text in a PDF document.

```dart
//Load an existing PDF document.
PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());
//Find the text and get matched items.
List<MatchedItem> textCollection =
    PdfTextExtractor(document).findText(['text1', 'text2']); 
//Get the matched item in the collection using index.
MatchedItem matchedText = textCollection[0];
//Get the text bounds.
Rect textBounds = matchedText.bounds;  
//Get the page index.
int pageIndex = matchedText.pageIndex; 
//Get the text.
String text = matchedText.text;
//Dispose the document.
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-text-extraction#working-with-find-text) for more details.

### Encryption and decryption

Encrypt new or existing PDF documents with encryption standards like 40-bit RC4, 128-bit RC4, 128-bit AES, and 256-bit AES, and the advanced encryption standard 256-bit AES Revision 6 (PDF 2.0) to protect documents against unauthorized access. Using this package, you can also decrypt existing encrypted documents.

Add the following code to encrypt an existing PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());

//Add security to the document.
final PdfSecurity security = document.security;

//Set password.
security.userPassword = 'userpassword@123';
security.ownerPassword = 'ownerpassword@123';

//Set the encryption algorithm.
security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;

//Save the document.
File('secured.pdf').writeAsBytes(await document.save());

//Dispose the document.
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-security) for more details.

### PDF conformance

Using this package, we can create PDF conformance documents, such as:

* PDF/A-1B
* PDF/A-2B
* PDF/A-3B

Add the following code to create a PDF conformance document.

```dart
//Create a PDF conformance document.
final PdfDocument document = PdfDocument(conformanceLevel: PdfConformanceLevel.a1b)
  ..pages.add().graphics.drawString('Hello World',
      PdfTrueTypeFont(File('Roboto-Regular.ttf').readAsBytesSync(), 12),
      bounds: Rect.fromLTWH(20, 20, 200, 50), brush: PdfBrushes.black);
//Save and dispose the document.
File('conformance.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-pdf-conformance) for more details.

### PDF form

PDF forms provide the best way to collect information from users. Using this package, we can create, modify, fill, and flatten PDF forms.

Add the following code to create PDF form.

```dart
//Create a new PDF document.
PdfDocument document = PdfDocument();

//Create a new page to add form fields.
PdfPage page = document.pages.add();

//Create text box field and add to the forms collection.
document.form.fields.add(PdfTextBoxField(
    page, 'firstname', Rect.fromLTWH(0, 0, 100, 20),
    text: 'John'));

//Create check box field and add to the form.
document.form.fields.add(PdfCheckBoxField(
    page, 'checkbox', Rect.fromLTWH(150, 0, 30, 30),
    isChecked: true));

//Save and dispose the document.
File('form.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

Add the following code to fill the existing PDF form.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());

//Get the form.
PdfForm form = document.form;

//Get text box and fill value.
PdfTextBoxField name = document.form.fields[0] as PdfTextBoxField;
name.text = 'John';

//Get the radio button and select.
PdfRadioButtonListField gender = form.fields[1] as PdfRadioButtonListField;
gender.selectedIndex = 1;

//Save and dispose the document.
File('output.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

Add the following code to flatten the existing form.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());

//Get the form.
PdfForm form = document.form;

//Flatten all the form fields.
form.flattenAllFields();

//Save and dispose the document.
File('output.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-forms) for more details.

### Digital signature

PDF digital signature is the best way to protect your PDF files from being forged. Using this package, we can digitally sign a PDF document using X509 certificates (.pfx file with private key).

Add the following code to sign the PDF document.

```dart
//Create a new PDF document.
PdfDocument document = PdfDocument();

//Add a new PDF page.
PdfPage page = document.pages.add();

//Create signature field.
PdfSignatureField signatureField = PdfSignatureField(page, 'Signature',
    bounds: Rect.fromLTWH(0, 0, 200, 50),
    signature: PdfSignature(
       certificate:
          PdfCertificate(File('certificate.pfx').readAsBytesSync(), 'password@123')
    ));
  
//Add the signature field to the document.
document.form.fields.add(signatureField);

//Save and dispose the PDF document
File('signed.pdf').writeAsBytes(await document.save());
document.dispose();
```
Add the following code to sign the existing PDF document.

```dart
//Load the existing PDF document.
final PdfDocument document =
    PdfDocument(inputBytes: File('input.pdf').readAsBytesSync());

//Get the signature field.
PdfSignatureField signatureField =
    document.form.fields[0] as PdfSignatureField;

//Get signature field and sign.
signatureField.signature = PdfSignature(
  certificate:
      PdfCertificate(File('certificate.pfx').readAsBytesSync(), 'password@123'),
);

//Save and dispose the document.
File('output.pdf').writeAsBytesSync(await document.save());
document.dispose();
```

Refer to our [documentation](https://help.syncfusion.com/flutter/pdf/working-with-digital-signature) for more details.


## Support and feedback

* For any questions, please post them in our [community forums](https://www.syncfusion.com/forums) or contact our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create). You can also submit a feature request or a bug alert through our [feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 22,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,600+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components),  [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to deploy enterprise software in our Bold line of products for dashboarding and reporting. Many customers have saved millions in licensing fees by deploying our software.