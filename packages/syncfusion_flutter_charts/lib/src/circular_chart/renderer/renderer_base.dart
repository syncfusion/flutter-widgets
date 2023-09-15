import '../../chart/chart_series/series.dart';

/// Creates a series renderer for circular series.
class CircularSeriesRenderer extends ChartSeriesRenderer {
  /// Creates an instance of circular series renderer.
  CircularSeriesRenderer();
}

/// Creates a series renderer for pie series.
class PieSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of [PieSeriesRenderer] class.
  PieSeriesRenderer();
}

/// Creates series renderer for doughnut series.
class DoughnutSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of [DoughnutSeriesRenderer] class.
  DoughnutSeriesRenderer();
}

/// Creates a series renderer for radial bar series.
class RadialBarSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of [RadialBarSeriesRenderer] class.
  RadialBarSeriesRenderer();
}
