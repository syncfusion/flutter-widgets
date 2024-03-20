part of officechart;

/// Represents chart series format class
class ChartSerieDataFormat {
  ///	Represents background color of a marker.
  late String markerBackgroundColor;

  ///	Represents border color of a marker.
  late String markerBorderColor;

  ///	Represents the type of marker.
  late ExcelChartMarkerType markerStyle;

  ///Represents the chart series options.
  late ChartFormat commonSerieOptions;

  /// Represents the distance of a pie slice from the center of pie chart.
  late int pieExplosionPercent;
}
