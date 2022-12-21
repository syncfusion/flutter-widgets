part of officechart;

/// Specifies the chart type.
enum ExcelChartType {
  /// Represents the clustered column chart.
  column,

  /// Represnts the 3D column chart
  column3D,

  /// Represents the column stacked chart.
  columnStacked,

  /// Represents the 100% stacked column chart.
  columnStacked100,

  /// Represents the 3D clustered column chart.
  columnClustered3D,

  /// Represents the 3D stacked column chart.
  columnStacked3D,

  /// Represents the 3D 100% stacked column chart.
  columnStacked1003D,

  /// Represents the clustered bar chart.
  bar,

  /// Represents the bar stacked chart.
  barStacked,

  /// Represents the 100% stacked bar chart.
  barStacked100,

  /// Represents the 3D stacked bar chart.
  barStacked3D,

  /// Represents the 3D clustered bar chart.
  barClustered3D,

  /// Represents the 3D 100% stacked bar chart.
  barStacked1003D,

  /// Represents the line chart.
  line,

  /// Represents the line stacked chart.
  lineStacked,

  /// Represents the  100% stacked line chart.
  lineStacked100,

  /// Represents the line chart with markers.
  lineMarkers,

  /// Represents the stacked line chart with markers.
  lineMarkersStacked,

  /// Represents the 100% stacked line chart with markers.
  lineMarkersStacked100,

  /// Represents the 3D line chart.
  line3D,

  /// Represents the Pie chart.
  pie,

  /// Represents the Pie chart.
  pie3D,

  /// Represents the pie of pie chart.
  pieOfPie,

  /// Represents the bar of pie chart.
  pieBar,

  /// Represents the area chart.
  area,

  /// Represents the stacked area chart.
  areaStacked,

  /// Represents the 100% stacked area chart.
  areaStacked100,

  /// Represents the stock chart with high, low and close values.
  stockHighLowClose,

  /// Represents the stock chart with open, high, low and close values.
  stockOpenHighLowClose,

  /// Represents the stock chart with volume, high, low and close values.
  stockVolumeHighLowClose,

  /// Represents the stock chart with volume, open, high, low and close values.
  stockVolumeOpenHighLowClose,

  /// Represents the doughnut chart.
  doughnut,

  /// Represents the doughnut Exploded chart.
  doughnutExploded,
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

/// Specifies the marker style for a point or series in a line chart, scatter chart, or radar chart.
enum ExcelChartMarkerType {
  /// Represents no markers.
  none,

  /// Represents square markers.
  square,

  /// Represents circular marker
  circle,

  /// Represents diamond shaped markers.
  diamond,

  /// Represents triangle markers.
  triangle,

  /// Represents square markers with X.
  xSquare,

  ///	Represents dow jones style custom marker
  dowJones,

  /// Represents plus sign marker
  plusSign,

  /// Represents square markers with asterisk
  starSquare,

  /// Represents standard deviation style custome marker
  standardDeviation,
}
