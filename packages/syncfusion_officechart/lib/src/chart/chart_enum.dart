part of officechart;

/// Specifies the chart type.
enum ExcelChartType {
  /// Represents the clustered column chart.
  column,

  /// Represents the line chart.
  line,

  /// Represents the clustered bar chart.
  bar,

  /// Represents the Pie chart.
  pie,

  /// Represents the bar stacked chart.
  barStacked,

  /// Represents the column stacked chart.
  columnStacked,

  /// Represents the line stacked chart.
  lineStacked,
}

/// Specifies the line pattern for the border.
enum ExcelChartLinePattern {
  /// Solid line.
  solid,

  /// Dashed line.
  dash,

  /// Alternating long dashed line.
  longDash,

  /// Rounded Dotted line.
  roundDot,

  /// Squared Dotted line.
  squareDot,

  /// Alternating dashes and dots.
  dashDot,

  /// Alternating long dashes and dots.
  longDashDot,

  /// Long Dash followed by two dots.
  longDashDotDot,

  /// No line.
  none,
}

/// Specifies the position of the legend on a chart.
enum ExcelLegendPosition {
  ///Represents the bottom of the chart.
  bottom,

  ///Represents the upper right-hand corner of the chart border.
  corner,

  ///Represents the top of the chart.
  top,

  ///Represents the right of the chart.
  right,

  ///Represents the left of the chart.
  left,

  ///Represents the NotDocked option.
  notDocked,
}

/// Specifies the axis types for charts in Excel.
enum ExcelAxisType {
  /// Axis displays categories.
  category,

  /// Axis displays values.
  value,

  /// Axis displays data series.
  serie,
}
