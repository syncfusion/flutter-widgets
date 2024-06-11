## Unreleased

**Features**

* Provided support for adding timestamp and LTV in PDF signature.

## [25.2.6] - 05/28/2024

**Bugs**

* Resolved the issue where flattening some form fields was not working in a specific PDF document.

## [25.2.5] - 05/21/2024

**Bugs**

* Preservation issues no longer occur when drawing on a page with negative crop box x and y coordinates.

## [25.1.42] - 04/30/2024

**Bugs**

* Extracting text from an encrypted PDF document will no longer significantly increase file size and corrupt the document.

## [25.1.41] - 04/23/2024

**Bugs**

* The existing signature no longer becomes invalid when adding a second signature to the PDF document.

## [25.1.39] - 04/09/2024

**Bugs**

* RangeError will no longer occur while extracting text lines from the PDF document.

## [25.1.37] - 03/26/2024

**Bugs**

* Preservation issue will no longer occur while flattening the signature field in the PDF document.

* The issue with the invalid signature has been resolved when signing the PDF document.

## [25.1.35] - 03/15/2024

**Breaking changes**

* The `sign` method in the `IPdfExternalSigner` class has been changed to an asynchronous type, and the `signSync` method has been added for synchronous signing.

**Features**

* Provided support for importing and exporting annotations in the PDF document.

* Provided support for asynchronous external signing in the PDF document.

## [24.2.8] - 02/27/2024

**Bugs**

* Resolved the issue where extracting text returns incorrect results for a specific PDF document.

* Invalid font name error will no longer occur when extracting text from specific PDF document.

## [24.2.5] - 02/13/2024

**Bugs**

* Extracting text lines will no longer return incorrect results for specific PDF documents.

## [24.2.4] - 02/06/2024

**Bugs**

* Find text related issues are now resolved in PDF documents.

* Extract text is now working properly in specific PDF document.

## [24.2.3] - 01/31/2024

**Features**

* Provided support to check and uncheck the check box field items.

## [24.1.46] - 01/17/2024

**General**

* Upgraded the `intl` package to the latest version 0.19.0.

## [24.1.45] - 01/09/2024

**Bugs**

* Preservation failure no longer occurs in Mac PDF viewer while saving specific encrypted PDF document.

## [24.1.44] - 01/03/2023

**Bugs**

* Null check error will no longer occur while removing pages from the PDF document.

## [24.1.43] - 12/27/2023

**Bugs**

* Preservation issue will no longer occur while flattening text box field in specific PDF document.

## [24.1.41] - 12/18/2023

**Features**

* Provided support for text markup and popup annotations.

* Provided support for adding annotation flags to PDF annotations.

**Bugs**

* The issue of retrieving incorrect values from the text box field after saving an encrypted PDF document has been resolved.

## [23.1.44] - 11/07/2023

**Bugs**

* The null reference exception that occurred while retrieving the page from the form fields in the PDF has been resolved.

## [23.1.40] - 10/10/2023

**Bugs**

* Resolved the incorrect image dimension recording in PdfBitmap.

## [23.1.39] - 10/04/2023

**Features**

* Support has been provided for back color, border color, and border style in the PDF signature field.

## [22.2.11] - 08/29/2023

**Bugs**

* High memory consumption will no longer occurs while extracting text from large PDF documents.

* Null check exceptions will no longer occur while drawing PDF grid in a loaded page.

## [22.2.9] - 08/15/2023

**Bugs**

* Null reference exceptions will no longer occur when retrieving form fields from the PDF document.

## [22.2.5] - 07/27/2023

**Bugs**

* Resolved white background preservation while flattening loaded empty signature field.

* Type casting issue no longer occurs while flattening specific PDF document.

## [22.1.36] - 06/28/2023

**Bugs**

* Resolved the space between text missing issue in the extract text layout and lines.

* PDF signature added with signed name is now valid in Adobe viewer.

## [21.2.4] - 05/09/2023

**Bugs**

* Null reference exceptions will no longer occur while getting form fields from the PDF document.

* Now, spaces are preserved properly when extracting text with the layout.

* The preservation issue no longer occurs after modifying the values in the fields of the PDF document.

## [21.1.41] - 04/18/2023

**Bugs**

* The unhandled exception that occurred during the extraction of text and flattening of form fields in the PDF document has been resolved.

## [21.1.39] - 04/11/2023

**Bugs**

* RTL bookmark title is now properly retrieved from Encrypted PDF documents.

## [21.1.37] - 03/29/2023

**Bugs**

* Text words are now properly split while extracting text from PDF documents.

## [20.4.54] - 03/15/2023

**Bugs**

* The issue of PDF document size increasing after removing pages has been resolved.

## [20.4.50] - 02/14/2023

**Bugs**

* Resolved the document corruption exception when signing existing signed PDF documents.

* Text bounds are now retrieved properly when finding text from cropped PDF documents.

## [20.3.57] - 11/15/2022

**Bugs**

* Alpha channel is not initialized properly in transparent brush is now resolved.

## [20.3.56] - 11/08/2022

**Features**

* Provided support to set signed date while signing the pdf document.

## [20.2.48] - 09/06/2022

**Bugs**

* The type casting issue when trying to get annotation is now resolved.

## [20.2.45] - 08/23/2022

**Bugs**

* The font is not updated properly for loaded form fields is now resolved.

## [20.2.36] - 06/30/2022

**Breaking changes**

* The `save` method has been changed to an asynchronous type in the `PdfDocument` and the `saveSync` method has been added for synchronous.

**Features**

* Provided asynchronous save support for PDF documents.

**Bugs**

* The preservation issue when flattening the PDF text box field is now resolved.

* Resolved the document corruption issue while modifying encrypted PDF document.

## [20.1.48-beta] - 04/12/2022

**Bugs**

* The layout issue when extracting text from the PDF document is now resolved.

## [20.1.47-beta] - 04/04/2022

**Features**

* Provided support to extract RTL text from an existing PDF document along with its bounds.

* Provided support to find RTL text in an existing PDF document.

**Known Limitation**

* Combination of RTL and LTR text in find operations will not work. For example "80٪ خصم في المحدد jeans".

## [19.4.41-beta] - 01/04/2022

**Bugs**

* Typecasting exceptions will no longer occur while extracting text from the PDF document.

## [19.3.55-beta] - 11/23/2021

**Bugs**

* Exception will no longer be thrown while extracting text from a particular PDF document.

## [19.3.48-beta] - 11/02/2021

**Bugs**

* Emoji character preservation issue has been resolved now.

* Null check exception will no longer be thrown while removing the password from a PDF document.

## [19.3.47-beta] - 10/26/2021

**Features**

* Provided support to identify whether the TextGlyph is rotated or not.

## [19.3.46-beta] - 10/19/2021

**Bugs**

* The text search bounds related issue has now been resolved.

## [19.3.45-beta] - 10/12/2021

**Bugs**

* The PDF destination retrieval related issue has now been resolved.

## [19.2.56-beta.1] - 08/17/2021

**Bugs**

* Resolved the RangeError while extracting text lines from the PDF document.
* The TextLine extraction bounds related issue has been resolved now.

## [19.2.56-beta] - 08/17/2021

**Features**

* Provided the support to get or set rotation in an existing PDF page.

## [19.2.48-beta] - 07/20/2021

**Bugs**

* The white space missing issue while extracting text has been resolved now.
* The unhandled exception when encrypting PDF document is resolved now.

## [19.2.44-beta] - 06/30/2021

**Features**

* Provided the support to import and export form fields.
* Provided the support to add skew transformation in PDF graphics.

**Bugs**

* The text extraction issue has been resolved now.
* The document corruption issue while removing pages has been resolved now.

## [19.1.67-beta] - 06/08/2021

**Bugs**

* The wrong text bounds calculation issue has been resolved now.

## [19.1.54-beta] - 03/30/2021

**Breaking changes**

* The property flatten has been removed from the `PdfAnnotation` and `PdfAnnotationCollection`. And added a new method called `flatten` and `flattenAllAnnotations` instead.

**Features**

* Provided the support to add image position in the PDF grid cell.
* Provided the support to set clip using the path data on the PDF graphics.
* Provided the support to add encryption options when protecting the PDF files.
* Provided the support to create, read, modify, fill, and flatten PDF form fields.
* Provided the support to digitally sign the PDF document.

**Bugs**

* The wrong header row index retrieved from the PDF grid begin cell callback has been resolved now.

## [18.4.48-beta] - 03/23/2021

**Bugs**

* The page size is not updated properly when adding margins issue resolved now.

## [18.4.43-beta] - 02/16/2021

**Bugs**

* The bookmark Unicode text preservation issue resolved now.

## [18.4.42-beta] - 02/09/2021

**Bugs**

* The unhandled exception when adding watermarks to the PDF document is resolved now.

## [18.4.41-beta] - 02/02/2021

**Bugs**

* The text rendering issue while using the PdfTextElement is resolved now.

## [18.4.34-beta] - 01/12/2021

**Features**

* Provided the support to set clip using path data on the PDF graphics.

## [18.4.32-beta] - 12/30/2020

**Features**

* Provided the support to add image position in PDF grid cell.

## [18.4.31-beta] - 12/22/2020

**Bugs**

* The header row index issue has been resolved now.

## [18.4.30-beta] - 12/17/2020

**Breaking changes**

* The `extractTextWithLine` method has been removed and added a new `extractTextLines` method instead.

**Features**

* Provided the support to encrypt or decrypt a PDF document.
* Provided the support to create, read, and edit layers in PDF documents.
* Provided the support to create a PDF conformance document.
* Provided the support to extract text with the layout.
* Provided the support to draw an image with pagination.
* Provided the support to add an attachment to the PDF document.
* Provided the support to add the document information in a PDF document.

**Bugs**

* The bookmark parsing issue has been resolved now.

## [18.3.52-beta] - 12/01/2020

* The method `extractTextWithLine` from `PdfTextExtractor` has been deprecated and added new method called `extractTextLines` instead.

## [18.3.51-beta] - 11/24/2020

**Bugs**

* The typecasting issue has been resolved now.

## [18.3.35-beta] - 10/01/2020

**Features**

* Support provided to parse the existing PDF document.
* Support provided to add or remove the PDF pages in an existing PDF document.
* Support provided to add the graphical content to the existing PDF document page.
* Provided the incremental update support for the existing PDF document.
* Support provided to create and load the annotations in a new or existing PDF document.
* Support provided to load the existing PDF document bookmarks with its destination.
* Support provided to extract the text in an existing PDF document along with its bounds.
* Support provided to find the text in an existing PDF document along with its bounds and page index.
* Support provided to flatten the supported annotations in an existing PDF document.
* Support provided to save the PDF document with a cross-reference stream.

## [18.2.59-beta.1] - 09/24/2020

**Bugs**

* The meta package issue has been resolved now.

## [18.1.52-beta] - 05/14/2020

**Bugs**

* Text will be preserved properly while using the TrueType font.

## [18.1.36-beta] - 03/19/2020

Initial release

**Features** 

* Provided the support for creating a PDF document with pages and sections.
* Provided the support for adding text, images, shapes, and more.
* Provided the support for adding Unicode text with True Type font.
* Provided the support for drawing right-to-left (RTL) language text with True Type font.
* Provided the support to create a customizable table.
* Provided the support to create a table using DataTable as an external source.
* Provided the support for adding headers and footers with text, images, shapes, and dynamic fields such as page numbers, date and time, and more.
* Provided the support for adding a flow layout text using PdfTextElement.
* Provided the support for bullets and lists with more customization
* Provided the support for creating bookmarks to the PDF.
* Provided the support for drawing images (JPEG and PNG only) to the PDF document.
* Provided the support for adding hyperlinks and internal document navigations.
* Provided the support for color, pen, and brushes. 
* Provided the support for adding Chinese, Japanese, and Korean text with the standard CJK fonts.
* Provided the support for creating and drawing PdfTemplates.