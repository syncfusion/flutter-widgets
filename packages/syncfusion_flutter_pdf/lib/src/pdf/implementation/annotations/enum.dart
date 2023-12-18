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
enum PdfAnnotationTypes {
  /// DocumentLinkAnnotation type.
  documentLinkAnnotation,

  /// Link annotation type.
  linkAnnotation,

  /// Link annotation type.
  textWebLinkAnnotation,

  /// LineAnnotation type.
  lineAnnotation,

  /// CircleAnnotation type.
  circleAnnotation,

  /// RectangleAnnotation type.
  rectangleAnnotation,

  /// PolygonAnnotation type.
  polygonAnnotation,

  /// WidgetAnnotation type
  widgetAnnotation,

  /// Highlight type annotation.
  highlight,

  /// Underline type annotation.
  underline,

  /// StrikeOut type annotation.
  strikeOut,

  /// Squiggly type annotation.
  squiggly,

  /// PopupAnnotation type.
  popupAnnotation,

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

/// Specifies the available data formats for submitting the form data.
enum PdfSubmitFormFlags {
  /// If clear, the Fields array specifies which fields to
  /// include in the submission. (All descendants of the specified fields in
  /// the field hierarchy are submitted as well.)
  /// If set, the Fields array tells which fields to exclude. All fields in the
  /// document’s interactive form are submitted except those listed in the
  /// Fields array and those whose NoExport flag.
  includeExclude,

  /// If set, all fields designated by the Fields array and the Include/
  /// Exclude flag are submitted, regardless of whether they have a value.
  /// For fields without a value, only the
  /// field name is transmitted.

  includeNoValueFields,

  /// Meaningful only if the SubmitPDF and XFDF flags are clear. If set,
  /// field names and values are submitted in HTML Form format. If
  /// clear, they are submitted in Forms Data Format
  exportFormat,

  /// If set, field names and values are submitted using an HTTP GET
  /// request. If clear, they are submitted using a POST request. This flag
  /// is meaningful only when the ExportFormat flag is set; if ExportFormat
  /// is clear, this flag must also be clear.
  getMethod,

  /// If set, the coordinates of the mouse click that caused the submitform
  /// action are transmitted as part of the form data. The coordinate
  /// values are relative to the upper-left corner of the field’s widget annotation
  /// rectangle.
  submitCoordinates,

  /// Meaningful only if the SubmitPDF flags are clear. If set,
  /// field names and values are submitted as XML Forms Data Format.
  xfdf,

  /// Meaningful only when the form is being submitted in
  /// Forms Data Format (that is, when both the XFDF and ExportFormat
  /// flags are clear). If set, the submitted FDF file includes the contents
  /// of all incremental updates to the underlying PDF document,
  /// as contained in the Differences entry in the FDF dictionary.
  /// If clear, the incremental updates are not included.
  includeAppendSaves,

  /// Meaningful only when the form is being submitted in
  /// Forms Data Format (that is, when both the XFDF and ExportFormat
  /// flags are clear). If set, the submitted FDF file includes all markup
  /// annotations in the underlying PDF document.
  /// If clear, markup annotations are not included.
  includeAnnotations,

  /// If set, the document is submitted as PDF, using the
  /// MIME content type application/pdf (described in Internet RFC
  /// 2045, Multipurpose Internet Mail Extensions (MIME), Part One:
  /// Format of Internet Message Bodies; see the Bibliography). If set, all
  /// other flags are ignored except GetMethod.
  submitPdf,

  /// If set, any submitted field values representing dates are
  /// converted to the standard format described.
  canonicalFormat,

  /// Meaningful only when the form is being submitted in
  /// Forms Data Format (that is, when both the XFDF and
  /// ExportFormat flags are clear) and the IncludeAnnotations flag is
  /// set. If set, it includes only those markup annotations whose T entry
  /// matches the name of the current user, as determined
  /// by the remote server to which the form is being submitted.
  exclNonUserAnnots,

  /// Meaningful only when the form is being submitted in
  /// Forms Data Format (that is, when both the XFDF and ExportFormat
  /// flags are clear). If set, the submitted FDF excludes the F entry.
  exclFKey,

  /// Meaningful only when the form is being submitted in
  /// Forms Data Format (that is, when both the XFDF and ExportFormat
  /// flags are clear). If set, the F entry of the submitted FDF is a file
  /// specification containing an embedded file stream representing the
  /// PDF file from which the FDF is being submitted.
  embedForm
}

/// Specifies the enumeration of submit data formats.
enum SubmitDataFormat {
  /// Data should be transmitted as Html.
  html,

  /// Data should be transmitted as Pdf.
  pdf,

  /// Data should be transmitted as Forms Data Format.
  fdf,

  /// Data should be transmitted as XML Forms Data Format.
  xfdf
}

/// Specifies Http request method.
enum HttpMethod {
  /// Data submitted using Http Get method.
  getHttp,

  /// Data submitted using Http Post method.
  post
}

/// Specifies the Style of the Text Markup Annotation
enum PdfTextMarkupAnnotationType {
  /// Represents highlight text markup annotation type.
  highlight,

  /// Represents underline text markup annotation type.
  underline,

  /// Represents squiggly text markup annotation type.
  squiggly,

  /// Represents strikethrough text markup annotation type.
  strikethrough,
}

/// Specifies the enumeration of popup annotation icons.
enum PdfPopupIcon {
  /// Indicates note popup annotation.
  note,

  /// Indicates comment popup annotation.
  comment,

  /// Indicates help popup annotation.
  help,

  /// Indicates insert popup annotation.
  insert,

  /// Indicates key popup annotation.
  key,

  /// Indicates new paragraph popup annotation.
  newParagraph,

  /// Indicates paragraph popup annotation.
  paragraph
}

/// Specifies the enumeration of the annotation flags.
enum PdfAnnotationFlags {
  /// Default value.
  defaultFlag,

  /// Represents invisible annotation flag's key.
  invisible,

  /// Represents hidden annotation flag's key.
  hidden,

  /// Represents print annotation flag's key.
  print,

  /// Represents annotation flag's key with no zooming.
  noZoom,

  /// Represents annotation flag's key with no rotation.
  noRotate,

  /// Represents annotation flag's key with no view.
  noView,

  /// Represents read only annotation flag's key.
  readOnly,

  /// Represents locked annotation flag's key.
  locked,

  /// Annotation flag's key with no toggle view.
  toggleNoView
}
