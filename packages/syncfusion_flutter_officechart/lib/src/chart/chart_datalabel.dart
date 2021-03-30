part of officechart;

/// Represents the Chart data labels class.
class ChartDataLabels {
  /// Create an instances of [ChartDataLabels] class.
  ChartDataLabels(ChartSerie serie) {
    _parentSerie = serie;
  }

  /// Gets or sets a boolean value indicating whether
  /// to display data label values.
  bool isValue = false;

  /// Gets or sets a boolean value indicating whether to display
  /// category name for data labels.
  bool isCategoryName = false;

  /// Gets or sets a boolean value indicating whether to display series name for data labels.
  bool isSeriesName = false;

  /// Represent the chart text area object.
  ChartTextArea? _textArea;

  /// Represents number format.
  String? numberFormat;

  /// Represent parent Serie.
  late ChartSerie _parentSerie;

  /// Gets chart text area object.
  ChartTextArea get textArea {
    _textArea ??= ChartTextArea(_parentSerie);

    return _textArea!;
  }

  /// Sets chart text area object.
  set textArea(ChartTextArea value) {
    _textArea = value;
  }
}
