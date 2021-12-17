/// Enumerator that represents the PDF page orientations.
enum PdfPageOrientation {
  /// Portrait orientation.
  portrait,

  /// Landscape orientation.
  landscape,
}

/// The number of degrees by which the page should be rotated clockwise
/// when displayed or printed.
enum PdfPageRotateAngle {
  /// The page is rotated as 0 angle.
  rotateAngle0,

  /// The page is rotated as 90 angle.
  rotateAngle90,

  /// The page is rotated as 180 angle.
  rotateAngle180,

  /// The page is rotated as 270 angle.
  rotateAngle270
}

/// Specifies the docking style of the page template.
enum PdfDockStyle {
  /// The page template is not docked.
  none,

  /// The page template edge is docked to the bottom page's side.
  bottom,

  /// The page template edge is docked to the top page's side.
  top,

  /// The page template edge is docked to the left page's side.
  left,

  /// The page template edge is docked to the right page's side.
  right,

  /// The page template stretch on full page.
  fill
}

/// Specifies how the page template is aligned relative to the template area.
enum PdfAlignmentStyle {
  /// Specifies no alignment.
  none,

  /// The template is top left aligned.
  topLeft,

  /// The template is top center aligned.
  topCenter,

  /// The template is top right aligned.
  topRight,

  /// The template is middle left aligned.
  middleLeft,

  /// The template is middle center aligned.
  middleCenter,

  /// The template is middle right aligned.
  middleRight,

  /// The template is bottom left aligned.
  bottomLeft,

  /// The template is bottom center aligned.
  bottomCenter,

  ///  The template is bottom right aligned.
  bottomRight,
}

/// Specifies numbering style of page labels.
enum PdfNumberStyle {
  /// No numbering at all.
  none,

  /// Decimal arabic numerals.
  numeric,

  /// Lowercase letters a-z.
  lowerLatin,

  /// Lowercase roman numerals.
  lowerRoman,

  /// Uppercase letters A-Z.
  upperLatin,

  /// Uppercase roman numerals.
  upperRoman
}

/// Specifies tab order types for form fields
enum PdfFormFieldsTabOrder {
  /// Form fields are visited default order
  none,

  /// Form fields are visited rows running horizontally across the page
  row,

  /// Form fields are visited column running vertically up and down the page
  column,

  /// Form fields are visited based on the structure tree
  structure,

  /// Form fields are visited manual order
  manual,
}

/// TemplateArea can be header/footer on of the following types.
enum TemplateType {
  /// Page template is not used as header.
  none,

  /// Page template is used as Top.
  top,

  /// Page template is used as Bottom.
  bottom,

  /// Page template is used as Left.
  left,

  /// Page template is used as Right.
  right
}
