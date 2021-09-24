part of pdf;

/// Represents total PDF document page count automatic field.
/// Represents an automatic field to display total number of pages
/// in section(if set isSectionPageCount as true).
/// ```dart
/// //Create a new pdf document
/// PdfDocument document = PdfDocument();
/// //Add the pages to the document
/// for (int i = 1; i <= 5; i++) {
///   document.pages.add().graphics.drawString(
///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
///       bounds: Rect.fromLTWH(250, 0, 615, 100));
/// }
/// //Create the footer with specific bounds
/// PdfPageTemplateElement footer = PdfPageTemplateElement(
///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
/// //Create the page count field
/// PdfPageCountField count = PdfPageCountField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //set the number style for page count
/// count.numberStyle = PdfNumberStyle.upperRoman;
/// //Create the composite field with page number page count
/// PdfCompositeField compositeField = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///     text: 'Page Count: {0}',
///     fields: <PdfAutomaticField>[count]);
/// compositeField.bounds = footer.bounds;
/// //Add the composite field in footer
/// compositeField.draw(
///     footer.graphics,
///     Offset(
///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
/// //Add the footer at the bottom of the document
/// document.template.bottom = footer;
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPageCountField extends _PdfSingleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageCountField] class
  /// and may also with the classes are [PdfFont], [PdfBrush] and [Rect].
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the footer with specific bounds
  /// PdfPageTemplateElement footer = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
  /// //Create the page count field
  /// PdfPageCountField count = PdfPageCountField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //set the number style for page count
  /// count.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page Count: {0}',
  ///     fields: <PdfAutomaticField>[count]);
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(
  ///     footer.graphics,
  ///     Offset(
  ///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageCountField(
      {PdfFont? font, PdfBrush? brush, Rect? bounds, bool? isSectionPageCount})
      : super(font, brush, bounds) {
    _isSectionPageCount = isSectionPageCount != null && isSectionPageCount;
  }

  // fields
  /// Gets or sets the specific number style.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the footer with specific bounds
  /// PdfPageTemplateElement footer = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
  /// //Create the page count field
  /// PdfPageCountField count = PdfPageCountField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Gets or Sets the number style for page count
  /// count.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page Count: {0}',
  ///     fields: <PdfAutomaticField>[count]);
  /// compositeField.bounds = footer.bounds;
  /// //Add the composite field in footer
  /// compositeField.draw(
  ///     footer.graphics,
  ///     Offset(
  ///         290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfNumberStyle numberStyle = PdfNumberStyle.numeric;

  /// Represents an automatic field to display total number of pages in section.
  bool _isSectionPageCount = false;

  // implementation
  @override
  String? _getValue(PdfGraphics graphics) {
    String? result;
    if (graphics._page is PdfPage) {
      final PdfPage page = _PdfDynamicField._getPageFromGraphics(graphics);
      if (_isSectionPageCount) {
        final PdfSection section = page._section!;
        final int count = section._count;
        return PdfAutomaticField._convert(count, numberStyle);
      } else {
        final PdfDocument document = page._section!._parent!._document!;
        final int number = document.pages.count;
        return PdfAutomaticField._convert(number, numberStyle);
      }
    }
    return result;
  }
}
