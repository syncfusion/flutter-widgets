import '../pdf_document/pdf_document_template.dart';

/// Represents a page template for all the pages in the section.
/// ```dart
/// //Create a new PDF documentation
/// PdfDocument document = PdfDocument();
/// //Create a new PDF section
/// PdfSection section = document.sections!.add();
/// //Create a section template
/// PdfSectionTemplate template = PdfSectionTemplate();
/// //Sets the template for the page in the section
/// section.template = template;
/// //Create a new PDF page and draw the text
/// section.pages.add().graphics.drawString(
///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfSectionTemplate extends PdfDocumentTemplate {
  /// Initializes a new instance of the [PdfSectionCollection] class.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate();
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfSectionTemplate() : super() {
    leftTemplate = topTemplate = rightTemplate = bottomTemplate = stamp = true;
  }

  /// Gets or sets value indicating whether parent Left page template
  /// should be used or not.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate()..leftTemplate = false;
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool leftTemplate;

  /// Gets or sets value indicating whether parent top page template
  /// should be used or not.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate()..topTemplate = false;
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool topTemplate;

  /// Gets or sets value indicating whether parent right page template
  /// should be used or not.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate()..rightTemplate = false;
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool rightTemplate;

  /// Gets or sets value indicating whether parent bottom page template
  /// should be used or not.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate()..bottomTemplate = false;
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool bottomTemplate;

  /// Gets or sets value indicating whether the parent stamp elements
  /// should be used or not.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a section template
  /// PdfSectionTemplate template = PdfSectionTemplate()..stamp = false;
  /// //Sets the template for the page in the section
  /// section.template = template;
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool stamp;
}
