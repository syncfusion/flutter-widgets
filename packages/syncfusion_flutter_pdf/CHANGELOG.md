## [Unreleased]

**Breaking changes**

* The method `extractTextWithLine` has been removed and add new method `extractTextLines` instead.

**Features**

* Support provided to encrypt or decrypt a PDF document.
* Support provided to create, read, and edit layers in a PDF document.
* Support provided to create PDF conformance document.
* Support provided to extract text with the layout.
* Support provided to draw an image with pagination.
* Support provided to add an attachment to the PDF document.
* Support provided to add document information in a PDF document.

**Bugs**

* The bookmark parsing issue has been resolved now.

## [18.3.52-beta] - 12/01/2020

* The method `extractTextWithLine` from `PdfTextExtractor` has been deprecated and added new method called `extractTextLines` instead.

## [18.3.51-beta] - 11/24/2020

**Bugs**

* The typecasting issue has been resolved now.

## [18.3.48-beta] - 11/11/2020

No changes.

## [18.3.47-beta] - 11/05/2020

No changes.

## [18.3.44-beta] - 10/27/2020

No changes.

## [18.3.42-beta] - 10/20/2020

No changes.

## [18.3.40-beta] - 10/13/2020

No changes.

## [18.3.38-beta] - 10/07/2020

No changes.

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

## [18.2.59-beta] - 09/23/2020

No changes.

## [18.2.57-beta] - 09/08/2020

No changes.

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

## [18.2.44-beta] - 07/07/2020

No changes.

## [18.1.52-beta] - 05/14/2020

**Bugs**

* Text will be preserved properly while using the TrueType font.

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