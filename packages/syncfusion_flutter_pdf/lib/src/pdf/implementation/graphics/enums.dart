part of pdf;

/// Specifies the type of horizontal text alignment.
enum PdfTextAlignment {
  /// Specifies the text is aligned to Left.
  left,

  /// Specifies the text is aligned to Center.
  center,

  /// Specifies the text is aligned to Right.
  right,

  /// Specifies the text as Justified text.
  justify
}

/// Specifies the type of Vertical alignment.
enum PdfVerticalAlignment {
  /// Specifies the element is aligned to Top.
  top,

  /// Specifies the element is aligned to Middle.
  middle,

  /// Specifies the element is aligned to Bottom.
  bottom,
}

/// Represents the text rendering direction.
enum PdfTextDirection {
  /// Specifies the default text order.
  none,

  /// Specifies the left to right direction.
  leftToRight,

  /// Specifies the right to left direction.
  rightToLeft
}

/// Defines set of color spaces.
enum PdfColorSpace {
  /// RGB color space.
  rgb,

  /// CMYK color space.
  cmyk,

  /// GrayScale color space.
  grayScale,

  /// Indexed color space.
  indexed
}

/// Specifies the text rendering mode.
class _TextRenderingMode {
  /// Fill text.
  static const int fill = 0;

  /// Stroke text.
  static const int stroke = 1;

  /// Fill, then stroke text.
  static const int fillStroke = 2;

  /// Neither fill nor stroke text (invisible).
  static const int none = 3;

  /// The flag showing that the text should be a part of a clipping path.
  static const int clipFlag = 4;
}

/// Possible dash styles of the pen.
enum PdfDashStyle {
  /// Solid line.
  solid,

  /// Dashed line.
  dash,

  /// Dotted line.
  dot,

  /// Dash-dot line.
  dashDot,

  /// Dash-dot-dot line.
  dashDotDot,

  /// User defined dash style.
  custom
}

/// Specifies the corner style of the shapes.
enum PdfLineJoin {
  /// The outer edges for the two segments are extended
  ///  until they meet at an angle.
  miter,

  /// An arc of a circle with a diameter equal to the line width is drawn
  /// around the point where the two segments meet, connecting the
  /// outer edges for the two segments.
  round,

  /// The two segments are finished with caps and the resulting notch beyond
  /// the ends of the segments is filled with a triangle.
  bevel
}

/// Specifies the line cap style to be used at the ends of the lines.
enum PdfLineCap {
  /// The stroke is squared off at the endpoint of the path.
  /// There is no projection beyond the end of the path.
  flat,

  /// A semicircular arc with a diameter equal to the line width is drawn
  ///  around the endpoint and filled in.
  round,

  ///	The stroke continues beyond the endpoint of the path for a distance
  /// equal to half the line width and is squared off.
  square
}

/// Specifies how the shapes are filled.
enum PdfFillMode {
  /// Nonzero winding number rule of determining "insideness" of point.
  winding,

  /// Even odd rule of determining "insideness" of point.
  alternate
}

/// Specifies the blend mode for transparency.
enum PdfBlendMode {
  /// Selects the source color, ignoring the backdrop.
  normal,

  /// Multiplies the backdrop and source color values.
  /// The result color is always at least as dark as either
  /// of the two constituent colors. Multiplying
  /// any color with black produces black; multiplying
  /// with white leaves the original color unchanged.
  /// Painting successive overlapping objects with a color
  /// other than black or white produces progressively darker colors.
  multiply,

  /// Multiplies the complements of the backdrop and source
  /// color values, then complements the result. The result
  /// color is always at least as light as either of the two
  /// constituent colors. Screening any color with white
  /// produces white; screening with black leaves the original
  /// color unchanged. The effect is similar to projecting
  /// multiple photographic slides simultaneously onto a single screen.
  screen,

  /// Multiplies or screens the colors, depending on
  /// the backdrop color value. Source colors overlay
  /// the backdrop while preserving its highlights and
  /// shadows. The backdrop color is not replaced but
  /// is mixed with the source color to reflect the
  /// lightness or darkness of the backdrop.
  overlay,

  /// Selects the darker of the backdrop and source colors.
  /// The backdrop is replaced with the source where the source
  /// is darker; otherwise, it is left unchanged.
  darken,

  /// Selects the lighter of the backdrop and source colors.
  /// The backdrop is replaced with the source where the source
  /// is lighter; otherwise, it is left unchanged.
  lighten,

  /// Brightens the backdrop color to reflect the source color.
  /// Painting with black produces no changes.
  colorDodge,

  /// Darkens the backdrop color to reflect the source color.
  /// Painting with white produces no change.
  colorBurn,

  /// Multiplies or screens the colors, depending on the source color value.
  /// The effect is similar to shining a harsh spotlight on the backdrop.
  hardLight,

  /// Darkens or lightens the colors, depending on the source color value.
  /// The effect is similar to shining a diffused spotlight on the backdrop.
  softLight,

  /// Subtracts the darker of the two constituent colors from the lighter color.
  /// Painting with white inverts the backdrop color;
  /// painting with black produces no change.
  difference,

  /// Produces an effect similar to that of the Difference mode
  /// but lower in contrast. Painting with white inverts
  /// the backdrop color; painting with black produces no change.
  exclusion,

  /// Creates a color with the hue of the source color and
  /// the saturation and luminosity of the backdrop color.
  hue,

  /// Creates a color with the saturation of the source color
  /// and the hue and luminosity of the backdrop color. Painting
  /// with this mode in an area of the backdrop that is a pure
  /// gray (no saturation) produces no change.
  saturation,

  /// Creates a color with the hue and saturation of
  /// the source color and the luminosity of the backdrop
  /// color. This preserves the gray levels of the backdrop
  /// and is useful for coloring monochrome images or tinting color images.
  color,

  /// Creates a color with the luminosity of the source color
  /// and the hue and saturation of the backdrop color. This
  /// produces an inverse effect to that of the Color mode.
  luminosity
}
