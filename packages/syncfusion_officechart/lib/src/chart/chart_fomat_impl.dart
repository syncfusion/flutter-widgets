part of officechart;

///Represents chart format implement class
class _ChartformatImpl implements ChartFormat {
  /// Create an instances of [_ChartformatImpl] class.
  _ChartformatImpl(Chart chart) {
    _firstSliceAngle = 0;
    _doughnutHoleSize = 75;
    _gapWidth = 150;
    _gapDepth = 150;
    _pieSecondSize = 75;
    _chart = chart;
  }

  /// Represents the angle of the first pie-chart or dough-nut chart slice, in degrees (clockwise from vertical).
  /// Can be a value from 0 through 360.
  late int _firstSliceAngle;

  /// Represents the hole size is expressed as a percentage of the chart size, between 10 and 90 percent.
  late int _doughnutHoleSize;

  /// Represents the space between bar/column clusters, as a percentage of the bar/column width in bar/column charts.
  /// Represents the space between the primary and secondary sections, in Pie of Pie and Bar of Pie charts.
  late int _gapWidth;

  /// Represents or sets the distance between the data series in a 3-D chart, as a percentage of the marker width.( 0 - 500 )
  late int _gapDepth;

  /// Represents percentage of the size of the secondary pie. ( 5 - 200 ).
  late int _pieSecondSize;

  /// Parent chart.
  late Chart _chart;

  ///Get first slice angle
  @override
  int get firstSliceAngle {
    return _firstSliceAngle;
  }

  ///Set first slice angle
  @override
  set firstSliceAngle(int value) {
    if (value < 0 || value > 360) {
      throw Exception('First slice angle');
    }
    for (int i = 0; i < _chart.series.count; i++) {
      final ChartSerie serie1 = _chart.series[i];
      (serie1.serieFormat.commonSerieOptions as _ChartformatImpl)
          ._firstSliceAngle = value;
    }
  }

  ///Get doughnut chart hole size
  @override
  int get holeSizePercent {
    return _doughnutHoleSize;
  }

  ///Set doughnut chart hole size
  @override
  set holeSizePercent(int value) {
    if (value < 0 || value > 90) {
      throw Exception('DonutHoleSize');
    }
    for (int i = 0; i < _chart.series.count; i++) {
      final ChartSerie serie1 = _chart.series[i];
      (serie1.serieFormat.commonSerieOptions as _ChartformatImpl)
          ._doughnutHoleSize = value;
    }
  }

  ///Get gap width for chart series
  @override
  int get gapWidth {
    return _gapWidth;
  }

  ///Set gapWidth for chart series
  @override
  set gapWidth(int value) {
    if (value < 0 || value > 500) {
      throw Exception('gapWidth');
    }
    for (int i = 0; i < _chart.series.count; i++) {
      final ChartSerie serie1 = _chart.series[i];
      (serie1.serieFormat.commonSerieOptions as _ChartformatImpl)._gapWidth =
          value;
    }
  }

  ///Get second pie/bar size
  @override
  int get pieSecondSize {
    return _pieSecondSize;
  }

  ///Set second pie/bar size
  @override
  set pieSecondSize(int value) {
    if (value < 0 || value > 200) {
      throw Exception('gapWidth');
    }
    for (int i = 0; i < _chart.series.count; i++) {
      final ChartSerie serie1 = _chart.series[i];
      (serie1.serieFormat.commonSerieOptions as _ChartformatImpl)
          ._pieSecondSize = value;
    }
  }

  ///Get gap depth for chart series
  @override
  int get gapDepth {
    return _gapDepth;
  }

  ///Set gap depth for chart series
  @override
  set gapDepth(int value) {
    if (value < 0 || value > 500) {
      throw Exception('gapDepth');
    }
    for (int i = 0; i < _chart.series.count; i++) {
      final ChartSerie serie1 = _chart.series[i];
      (serie1.serieFormat.commonSerieOptions as _ChartformatImpl)._gapDepth =
          value;
    }
  }
}
