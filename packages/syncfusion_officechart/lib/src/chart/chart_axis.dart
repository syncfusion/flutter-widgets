part of officechart;

/// Represents an axis on the chart.
class ChartAxis {
  /// Represents the parent chart.
  Chart _parentChart;

  /// Represent the chart text area object.
  ChartTextArea _titleArea;

  /// Represents number format .
  String numberFormat;

  /// Represents minimumvalue of Axis .
  double minimumValue;

  /// Represents maximum value of Axis .
  double maximumValue;

  /// Gets or sets a boolean value indicating if the axis has major grid lines.
  bool hasMajorGridLines = false;

  /// Gets chart text area object.
  ChartTextArea get titleArea {
    _titleArea ??= ChartTextArea(_parentChart);

    return _titleArea;
  }

  /// Sets chart text area object.
  set titleArea(ChartTextArea value) {
    _titleArea = value;
  }

  /// Gets chart axis title.
  String get title {
    if (_titleArea == null) return null;
    return _titleArea.text;
  }

  /// Sets chart axis title.
  set title(String value) {
    titleArea.text = value;
  }

  /// Gets indicates whether chart axis have title or not.
  bool get _hasAxisTitle {
    return _titleArea != null;
  }
}
