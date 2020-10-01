part of pdf;

/// Specifies the highlight mode for a field.
enum PdfHighlightMode {
  /// No highlighting.
  noHighlighting,

  /// Invert the contents of the field rectangle.
  invert,

  /// Invert the field's border.
  outline,

  /// Pushed highlighting.
  push
}

/// Specifies the file path type.
enum PdfFilePathType {
  /// Specifies the file location with out including the domain name.
  relative,

  /// Specifies the location, including the domain name.
  absolute
}

/// Specifies the annotation types.
enum _PdfAnnotationTypes {
  /// DocumentLinkAnnotation type.
  documentLinkAnnotation,

  /// Link annotation type.
  linkAnnotation,
  textWebLinkAnnotation,

  /// LineAnnotation type.
  lineAnnotation,

  /// CircleAnnotation type.
  circleAnnotation,

  /// RectangleAnnotation type.
  rectangleAnnotation,

  /// PolygonAnnotation type.
  polygonAnnotation,

  /// No annotation.
  noAnnotation
}

/// Specifies the available styles for a field border.
enum PdfBorderStyle {
  /// A solid rectangle surrounding the annotation.
  solid,

  /// A dashed rectangle surrounding the annotation.
  dashed,

  /// A simulated embossed rectangle that appears to be raised above the surface
  /// of the page.
  beveled,

  /// A simulated engraved rectangle that appears to be recessed below the surface
  /// of the page.
  inset,

  /// A single line along the bottom of the annotation rectangle.
  underline,

  /// A dotted rectangle surrounding the annotation.
  dot
}

/// Gets or sets the line intent of the annotation.
enum PdfLineIntent {
  /// Indicates Line Arrow as intent of the line annotation
  lineArrow,

  /// Indicates LineDimension as intent of the line annotation
  lineDimension,
}

/// Gets or sets the caption type of the annotation.
enum PdfLineCaptionType {
  /// Indicates Inline as annotation caption positioning
  inline,

  /// Indicates Top as annotation caption positioning
  top,
}

/// Specifies the line ending style to be used in the Line annotation.
enum PdfLineEndingStyle {
  /// Indicates None
  none,

  /// Indicates OpenArrow
  openArrow,

  /// Indicates ClosedArrow
  closedArrow,

  /// Indicates ROpenArrow
  rOpenArrow,

  /// Indicates RClosedArrow
  rClosedArrow,

  /// Indicates Butt
  butt,

  /// Indicates Diamond
  diamond,

  /// Indicates Circle
  circle,

  /// Indicates Square
  square,

  /// Indicates Slash
  slash
}
