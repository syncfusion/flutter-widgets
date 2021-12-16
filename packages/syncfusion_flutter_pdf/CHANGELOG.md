## [19.3.55-beta] - 11/23/2021 

**Bugs**

* Exception will no longer been thrown while extracting text from particular PDF document.

## [19.3.48-beta] - 11/02/2021 

**Bugs**

* Emoji characters preservation issue has been resolved now.

* Null check exception will no longer been thrown while removing password from PDF document.

## [19.3.47-beta] - 10/26/2021 

**Features**

* Provided the support to identify whether the TextGlyph is rotated or not.

## [19.3.46-beta] - 10/19/2021 
**Bugs**

* The text search bounds related issue has been resolved now.

## [19.3.45-beta] - 10/12/2021 

**Bugs**

* PDF destination retrieval related issue has been resolved now.

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
