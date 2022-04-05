part of officechart;

/// Specifies the chart type.
enum ExcelChartType {
  /// Represents the clustered column chart.
  column,

  /// Represents the column stacked chart.
  columnStacked,

  /// Represents the 100% stacked column chart.
  columnStacked100,

  /// Represents the clustered bar chart.
  bar,

  /// Represents the bar stacked chart.
  barStacked,

  /// Represents the 100% stacked bar chart.
  barStacked100,

  /// Represents the line chart.
  line,

  /// Represents the line stacked chart.
  lineStacked,

  /// Represents the  100% stacked line chart.
  lineStacked100,

  /// Represents the Pie chart.
  pie,

  /// Represents the area chart.
  area,

  /// Represents the stacked area chart.
  areaStacked,

  /// Represents the 100% stacked area chart.
  areaStacked100
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
