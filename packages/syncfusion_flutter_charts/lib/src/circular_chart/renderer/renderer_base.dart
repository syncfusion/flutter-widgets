import '../../chart/chart_series/series.dart';

/// Creates a series renderer for Circular series
class CircularSeriesRenderer extends ChartSeriesRenderer {
  /// Creates an instance of circular series renderer
  CircularSeriesRenderer();
}

///Creates series renderer for Doughnut series
class PieSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of PieSeriesRenderer class.
  PieSeriesRenderer();
}

/// Creates series renderer for Doughnut series
class DoughnutSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of DoughnutSeriesRenderer class.
  DoughnutSeriesRenderer();
}

/// Creates series renderer for RadialBar series
class RadialBarSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of RadialBarSeriesRenderer class.
  RadialBarSeriesRenderer();
}
