import 'area_series.dart';
import 'bar_series.dart';
import 'bubble_series.dart';
import 'column_series.dart';
import 'fast_line_series.dart';
import 'hilo_openclose_series.dart';
import 'hilo_series.dart';
import 'line_series.dart';
import 'range_area_series.dart';
import 'range_column_series.dart';
import 'scatter_series.dart';
import 'spline_area_sample.dart';
import 'spline_sample.dart';
import 'stacked_area100_sample.dart';
import 'stacked_area_sample.dart';
import 'stacked_bar100_sample.dart';
import 'stacked_bar_sample.dart';
import 'stacked_column100_sample.dart';
import 'stacked_column_sample.dart';
import 'stacked_line100_sample.dart';
import 'stacked_line_sample.dart';
import 'step_area_sample.dart';
import 'stepline_sample.dart';

/// Test method of performance of all series.
void performance() {
  areaPerformance();
  barPerformance();
  bubblePerformance();
  columnPerformance();
  fastLinePerformance();
  linePerformance();
  scatterPerformance();
  // candlePerformance();
  hiloPerformance();
  hiloOpenClosePerformance();
  rangeAreaPerformance();
  rangeColumnPerformance();
  splinePerformance();
  stackedareaPerformance();
  splineareaPerformance();
  steplinePerformance();
  stepareaPerformance();
  stackedarea100Performance();
  stackedbarPerformance();
  stackedbar100Performance();
  stackedlinePerformance();
  stackedline100Performance();
  stackedcolumnPerformance();
  stackedcolumn100Performance();
}

/// Represents the performance data
class PerformanceData {
  /// Creates an instance for performance data
  PerformanceData({this.year, this.category, this.x, this.sales1, this.sales2});

  /// Holds the year value
  DateTime? year;

  /// Holds the category value
  String? category;

  /// Holds the x value
  double? x;

  /// Holds the sales1 value
  int? sales1;

  /// Holds the sales2 value
  int? sales2;
}
