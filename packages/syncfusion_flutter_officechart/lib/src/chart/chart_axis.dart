part of officechart;

/// Represents an axis on the chart.
class ChartAxis {
  /// Represents the parent chart.
  late Chart _parentChart;

  /// Represent the chart text area object.
  ChartTextArea? _titleArea;

  /// Represents number format.
  late String numberFormat;

  /// Represents minimumvalue of Axis.
  double _minimumValue = 0;

  /// Represents maximum value of Axis.
  double _maximumValue = 0;

  /// Gets or sets a boolean value indicating if the axis has major grid lines.
  bool hasMajorGridLines = false;

  /// Automatic minimum selected.
  bool _isAutoMin = true;

  /// Automatic minimum selected.
  bool _isAutoMax = true;

  /// Gets chart text area object.
  ChartTextArea get titleArea {
    _titleArea ??= ChartTextArea(_parentChart);

    return _titleArea!;
  }

  /// Sets chart text area object.
  set titleArea(ChartTextArea? value) {
    _titleArea = value;
  }

  /// Gets chart axis title.
  String? get title {
    if (_titleArea == null) {
      return null;
    }
    return _titleArea!.text;
  }

  /// Sets chart axis title.
  set title(String? value) {
    titleArea.text = value;
  }

  /// Gets indicates whether chart axis have title or not.
  bool get _hasAxisTitle {
    return _titleArea != null;
  }

  /// Represents minimumvalue of Axis.
  double get minimumValue {
    return _minimumValue;
  }

  /// Sets minimumvalue of Axis.
  set minimumValue(double value) {
    _minimumValue = value;
    _isAutoMin = false;
  }

  /// Represents maximumvalue of Axis.
  double get maximumValue {
    return _maximumValue;
  }

  /// Sets maximumvalue of Axis.
  set maximumValue(double value) {
    _maximumValue = value;
    _isAutoMax = false;
  }
}
