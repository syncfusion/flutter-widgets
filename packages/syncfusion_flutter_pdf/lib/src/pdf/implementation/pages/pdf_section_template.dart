part of pdf;

/// Represents a page template for all the pages in the section.
class PdfSectionTemplate extends PdfDocumentTemplate {
  /// Initializes a new instance of the [PdfSectionCollection] class.
  PdfSectionTemplate() : super() {
    leftTemplate = topTemplate = rightTemplate = bottomTemplate = stamp = true;
  }

  /// Gets or sets value indicating whether parent Left page template
  /// should be used or not.
  bool leftTemplate;

  /// Gets or sets value indicating whether parent top page template
  /// should be used or not.
  bool topTemplate;

  /// Gets or sets value indicating whether parent right page template
  /// should be used or not.
  bool rightTemplate;

  /// Gets or sets value indicating whether parent bottom page template
  /// should be used or not.
  bool bottomTemplate;

  /// Gets or sets value indicating whether the parent stamp elements
  /// should be used or not.
  bool stamp;
}
