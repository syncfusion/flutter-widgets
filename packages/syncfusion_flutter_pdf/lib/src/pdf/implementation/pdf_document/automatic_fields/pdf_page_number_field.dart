part of pdf;

/// Represents PDF document page number field.
/// Represents an automatic field to display page number within a section.
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
/// //Create the page number field
/// PdfPageNumberField pageNumber = PdfPageNumberField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
/// //Sets the number style for page number
/// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
/// //Create the composite field with page number page count
/// PdfCompositeField compositeField = PdfCompositeField(
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
///     text: 'Page No: {0}',
///     fields: <PdfAutomaticField>[pageNumber]);
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
class PdfPageNumberField extends _PdfMultipleValueField {
  // constructor
  /// Initializes a new instance of the [PdfPageNumberField] class
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
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page No: {0}',
  ///     fields: <PdfAutomaticField>[pageNumber]);
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
  PdfPageNumberField(
      {PdfFont? font, PdfBrush? brush, Rect? bounds, bool? isSectionPageNumber})
      : super(font: font, brush: brush, bounds: bounds) {
    _isSectionPageNumber =
        (isSectionPageNumber == null) ? false : isSectionPageNumber;
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
  /// //Create the page number field
  /// PdfPageNumberField pageNumber = PdfPageNumberField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  /// //Sets the number style for page number
  /// pageNumber.numberStyle = PdfNumberStyle.upperRoman;
  /// //Create the composite field with page number page count
  /// PdfCompositeField compositeField = PdfCompositeField(
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     text: 'Page No: {0}',
  ///     fields: <PdfAutomaticField>[pageNumber]);
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

  /// Represents an automatic field to display page number within a section.
  bool _isSectionPageNumber = false;

  //implementation
  @override
  String? _getValue(PdfGraphics graphics) {
    String? result;
    if (graphics._page is PdfPage) {
      final PdfPage page = _PdfDynamicField._getPageFromGraphics(graphics);
      result = _internalGetValue(page);
    }
    return result;
  }

  String _internalGetValue(PdfPage? page) {
    if (_isSectionPageNumber) {
      final PdfSection section = page!._section!;
      final int index = section._indexOf(page) + 1;
      return _PdfNumberConvertor._convert(index, numberStyle);
    } else {
      final PdfDocument document = page!._section!._parent!._document!;
      final int pageIndex = document.pages.indexOf(page) + 1;
      return _PdfNumberConvertor._convert(pageIndex, numberStyle);
    }
  }
}
