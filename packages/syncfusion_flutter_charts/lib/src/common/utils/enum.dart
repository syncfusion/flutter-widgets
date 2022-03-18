/// Legend Position in charts.
enum LegendPosition {
  /// - `LegendPosition.auto`, places the legend either at the bottom when the height is
  /// greater than the width, or at right when the width is greater than height.
  auto,

  /// - `LegendPosition.bottom`, places the legend below the plot area.
  bottom,

  /// - `LegendPosition.left`, places the legend at the left to the plot area.
  left,

  /// - `LegendPosition.right`, places the legend at the right to the plot area.
  right,

  /// - `LegendPosition.top`, places the legend at the top of the plot area.
  top
}

/// Alignment of various elements in chart.
enum ChartAlignment {
  /// - `ChartAlignment.near` aligns to the near position.
  near,

  /// - `ChartAlignment.center` aligns to the center position
  center,

  /// - `ChartAlignment.far` aligns to the far position.
  far
}

/// Mode to handle the legend items overflow.
enum LegendItemOverflowMode {
  /// - `LegendItemOverflowMode.wrap`, will wrap and place the remaining legend item to next line.
  wrap,

  /// - `LegendItemOverflowMode.scroll`, will place all the legend items in single
  /// line and enables scrolling.
  scroll,

  /// - `LegendItemOverflowMode.none`, will simply hides the remaining legend items.
  none
}

/// Orientation of legend items.
enum LegendItemOrientation {
  /// - `LegendItemOrientation.auto`, will align the legend items based on the position.
  auto,

  /// - `LegendItemOrientation.horizontal`, will align the legend items horizontally.
  horizontal,

  /// - `LegendItemOrientation.vertical`, will align the legend item vertically.
  vertical
}

/// It used to change the legend icons in different type of series and indicators.
enum LegendIconType {
  ///`LegendIconType.seriesType`, icon is same as seriestype.
  seriesType,

  ///`LegendIconType.circle`, icon is changed by circle shape.
  circle,

  ///`LegendIconType.rectangle`, icon is changed by rectangle shape.
  rectangle,

  ///`LegendIconType.image`, icon is changed by adding the assest image.
  image,

  ///`LegendIconType.pentagon`, icon is changed by pentagon shape.
  pentagon,

  ///`LegendIconType.verticalLine`, icon is changed by verticalline.
  verticalLine,

  ///`LegendIconType.horizontalLine`, icon is changed by horizotalline.
  horizontalLine,

  ///`LegendIconType.diamond`, icon is changed by diamond shape.
  diamond,

  ///`LegendIconType.triangle`, icon is changed by triangle shape.
  triangle,

  ///`LegendIconType.invertedTriangle`, icon is changed by invertedTriangle shape.
  invertedTriangle
}

/// Position of data labels in Cartesian chart.The position of data lables in cartesian charts can be changed using this property.
///
/// Defaults to `ChartDataLabelAlignment.auto`.
enum ChartDataLabelAlignment {
  /// - ChartDataLabelAlignment.auto places the data label either top or bottom position
  /// of a point based on the position.
  auto,

  /// - ChartDataLabelAlignment.outer places the data label at outside of a point.
  outer,

  /// - ChartDataLabelAlignment.top places the data label at the top position of a point.
  top,

  /// - ChartDataLabelAlignment.bottom places the data label at the bottom position of a point.
  bottom,

  /// - ChartDataLabelAlignment.middle places the data label at the center position of a point.
  middle
}

/// Position of data labels in Circular chart.
enum CircularLabelPosition {
  /// - CircularLabelPosition.curve places the data label inside the point.
  inside,

  /// - CircularLabelPosition.line places the data label outside the point.
  outside
}

/// PyramidMode for pyramid charts.
///
/// Defaults to `PyramidMode.linear`
enum PyramidMode {
  /// - PyramidMode.linear, linear pyramid will be rendered
  linear,

  /// - PyramidMode.surface, Surface pyramid will be displayed
  surface
}
