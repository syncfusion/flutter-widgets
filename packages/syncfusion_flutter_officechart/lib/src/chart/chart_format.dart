part of officechart;

///Represents chart format
class ChartFormat {
  /// Represents the angle of first slice in a doughnut or pie chart., in degrees (clockwise from vertical).
  /// Can be a value from 0 through 360.
  late int firstSliceAngle;

  /// Represents the hole size percentage of a doughnut chart., between 10 and 90 percent.
  late int holeSizePercent;

  /// Represents the space between bar/column clusters, as a percentage of the bar/column width in bar/column charts.
  /// Represents the space between the primary and secondary sections, in Pie of Pie and Bar of Pie charts.
  late int gapWidth;

  /// Represents the distance between the data series in a 3-D chart, as a percentage of the marker width.( 0 - 500 );
  late int gapDepth;

  /// Represents percentage of the size of the secondary pie. ( 5 - 200 ).
  late int pieSecondSize;
}
