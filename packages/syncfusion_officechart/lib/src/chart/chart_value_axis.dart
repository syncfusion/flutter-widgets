import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../officechart.dart';

/// Represents an axis on the chart.
class ChartValueAxis extends ChartAxis {
  /// Create an instances of [ChartValueAxis] class.
  ChartValueAxis(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    chart = chart;
    super.parentChart = chart;
  }

  // Parent worksheet.
  // ignore: unused_field
  late Worksheet _worksheet;

  // Parent chart.
  late Chart _chart;

  // ignore: public_member_api_docs
  Chart get chart {
    return _chart;
  }
}
