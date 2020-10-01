part of officechart;

/// Represents the Chart serie collection.
class ChartSeriesCollection {
  /// Create a instance of [ChartSeriesCollection] class.
  ChartSeriesCollection(Worksheet worksheet, Chart chart) {
    _worksheet = worksheet;
    _chart = chart;
    _innerList = [];
  }

  /// Parent worksheet.
  Worksheet _worksheet;

  /// Parent chart.
  Chart _chart;

  /// Inner list.
  List<ChartSerie> _innerList;

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
  ChartSerie operator [](index) => innerList[index];

  /// Add serie to the chart serie collection.
  ChartSerie _add() {
    final ChartSerie serie = ChartSerie(_worksheet, _chart);
    innerList.add(serie);
    return serie;
  }

  /// Clear the innerList.
  void _clear() {
    _innerList.clear();
  }
}
