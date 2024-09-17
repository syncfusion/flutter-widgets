import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../officechart.dart';

/// Represents the Chart serie collection.
class ChartSeriesCollection {
  /// Create a instance of [ChartSeriesCollection] class.
  ChartSeriesCollection(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
    _innerList = <ChartSerie>[];
  }

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// Parent chart.
  late Chart _chart;

  /// Inner list.
  late List<ChartSerie> _innerList;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Represents the innerList.
  List<ChartSerie> get innerList {
    return _innerList;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _innerList.length;
  }

  /// Indexer of the class
  ChartSerie operator [](dynamic index) => innerList[index];

  /// Add serie to the chart serie collection.
  ChartSerie add() {
    final ChartSerie serie = ChartSerie(_worksheet, _chart);
    innerList.add(serie);
    return serie;
  }

  /// Clear the innerList.
  void _clear() {
    _innerList.clear();
  }

  // ignore: public_member_api_docs
  void clear() {
    _clear();
  }
}
