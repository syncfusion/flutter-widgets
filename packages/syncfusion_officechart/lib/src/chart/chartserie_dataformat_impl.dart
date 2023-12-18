part of officechart;

///Represents chart series format
class _ChartSerieDataFormatImpl implements ChartSerieDataFormat {
  /// Create a instance of [_ChartSerieDataFormatImpl] class.
  _ChartSerieDataFormatImpl(Chart chart) {
    _markerBackgroundColor = '#000000';
    _markerForegroundColor = '#000000';
    _markerStyle = ExcelChartMarkerType.none;
    _chart = chart;
  }

  /// Represents the marker background fill color.
  late String _markerBackgroundColor;

  /// Represents the marker Border fill color.
  late String _markerForegroundColor;

  ///Represnets the marker style for a series in a line chart,stock chart.
  late ExcelChartMarkerType _markerStyle;

  ///Represents chart format
  ChartFormat? _chartFormat;

  /// Parent chart.
  late Chart _chart;

  ///Represents the distance of pie slice from center of pie.
  int _percent = 0;

  ///Get marker background color
  @override
  String get markerBackgroundColor {
    return _markerBackgroundColor;
  }

  ///Set marker background color
  @override
  set markerBackgroundColor(String value) {
    _markerBackgroundColor = value;
  }

  ///Get marker Border color
  @override
  String get markerBorderColor {
    return _markerForegroundColor;
  }

  ///Set marker Border color
  @override
  set markerBorderColor(String value) {
    _markerForegroundColor = value;
  }

  ///Set marker style
  @override
  set markerStyle(ExcelChartMarkerType value) {
    _markerStyle = value;
  }

  ///Get marker style.
  @override
  ExcelChartMarkerType get markerStyle {
    return _markerStyle;
  }

  ///Get chart format
  @override
  ChartFormat get commonSerieOptions {
    _chartFormat ??= _ChartformatImpl(_chart);
    return _chartFormat!;
  }

  ///Set chart format
  @override
  set commonSerieOptions(ChartFormat? chartFormat) {}

  /// Get the distance of pie slice from center of pie.
  @override
  int get pieExplosionPercent {
    return _percent;
  }

  /// Set the distance of pie slice from center of pie.
  @override
  set pieExplosionPercent(int value) {
    if (value < 0 || value > 400) {
      throw Exception('percent');
    }
    _percent = value;
  }
}
