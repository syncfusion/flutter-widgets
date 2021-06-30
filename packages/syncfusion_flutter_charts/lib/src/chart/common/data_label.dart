part of charts;

/// Customizes the data label.
///
/// Data labels can be added to a chart series by enabling the [isVisible] option in the dataLabelSettings. It has
/// options to customize the appearance of the data label.
///
/// Provide options like color, border width, border color, alignment and data label text style for customization.
///
@immutable
class DataLabelSettings {
  /// Creating an argument constructor of DataLabelSettings class.
  const DataLabelSettings(
      {this.alignment = ChartAlignment.center,
      this.color,
      this.textStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12),
      this.margin = const EdgeInsets.fromLTRB(5, 5, 5, 5),
      this.opacity = 1,
      this.labelAlignment = ChartDataLabelAlignment.auto,
      this.borderRadius = 5,
      this.isVisible = false,
      this.angle = 0,
      this.builder,
      this.useSeriesColor = false,
      this.offset,
      this.showCumulativeValues = false,
      this.showZeroValue = true,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.labelIntersectAction = LabelIntersectAction.hide,
      this.connectorLineSettings = const ConnectorLineSettings(),
      this.labelPosition = ChartDataLabelPosition.inside});

  ///Alignment of the data label.
  ///
  ///The data label can be aligned far, near, or center of the data point position.
  ///
  ///Defaults to `ChartAlignment.center`.
  ///
  ///Also refer [ChartAlignment].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(isVisible: true, alignment: ChartAlignment.center),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartAlignment alignment;

  ///Color of the data label.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(isVisible: true, color: Colors.red),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color? color;

  ///Customizes the data label font.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(isVisible:true,
  ///                    textStyle: TextStyle(color: Colors.red)),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

  final TextStyle textStyle;

  ///Margin between the data label text and its shape.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       margin: const EdgeInsets.all(2),
  ///                       borderColor: Colors.red,
  ///                       borderWidth: 2),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Opacity of the data label.
  ///
  ///The value ranges from 0 to 1.
  ///
  ///Defaults to `1`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       color: Colors.pink,
  ///                       opacity: 0.5),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double opacity;

  ///Uses the series color for filling the data label shape
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       useSeriesColor: true),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool useSeriesColor;

  ///Position of the data label.
  ///
  /// _Note:_  This is applicable for Cartesian chart.
  ///
  ///Defaults to `ChartDataLabelAlignment.auto`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <LineSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                         isVisible: true,
  ///                         labelAlignment: ChartDataLabelAlignment.auto),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartDataLabelAlignment labelAlignment;

  /// Customizes the data label border radius.
  ///
  /// Defaults to `5`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       borderRadius: 3,
  ///                       borderColor: Colors.red,
  ///                       borderWidth: 2),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double borderRadius;

  ///Toggles the visibility of the data label in the series.
  ///
  ///Defaults to `false`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true)
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isVisible;

  ///Rotation angle of the data label.
  ///
  ///Defaults to `0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       angle:40)
  ///              ],
  ///        ));
  ///}
  ///```
  final int angle;

  ///Border color of the data label.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       borderColor: Colors.red,
  ///                       borderWidth: 2),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the data label.
  ///
  ///Defaults to `0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       borderColor: Colors.red,
  ///                       borderWidth: 2),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Position of the data label.
  ///
  /// _Note:_  This is applicable for pie and doughnut series types alone.
  ///
  ///Defaults to `ChartDataLabelPosition.inside`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, String>>[
  ///                PieSeries<SalesData, String>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       labelPosition: ChartDataLabelPosition.outside),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartDataLabelPosition labelPosition;

  ///Customizes the connector lines. Connector line is rendered when the data label is
  /// placed outside the chart.
  ///
  ///  _Note:_ This is applicable for pie and doughnut series types alone.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, String>>[
  ///                PieSeries<SalesData, String>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,
  ///                       connectorLineSettings:ConnectorLineSettings(
  ///                             width: 6,
  ///                             type:ConnectorType.curve)),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ConnectorLineSettings connectorLineSettings;

  ///Action on data labels intersection.
  ///
  ///The intersecting data labels can be hidden.
  ///
  ///Defaults to `LabelIntersectAction.hide`.
  ///
  ///Also refer [LabelIntersectAction].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,color: Colors.yellow
  ///                       labelIntersectAction: LabelIntersectAction.none),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final LabelIntersectAction labelIntersectAction;

  ///Builder for data label.
  ///
  /// Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,color: Colors.yellow
  ///                       builder: (dynamic data, dynamic point, dynamic series,
  ///                           int pointIndex, int seriesIndex) {
  ///                         return Container(height: 30, width: 30,
  ///                          child: Image.asset('images/horse.jpg'));
  ///          }),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartWidgetBuilder<dynamic>? builder;

  /// To show the cummulative values in stacked type series charts.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <SplineSeries<SalesData, num>>[
  ///                StepAreaSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,color: Colors.yellow
  ///                       showCumulativeValues:true,
  ///          ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool showCumulativeValues;

  ///Hides the data label and its connector line, if the data point value is 0 (Zero).
  ///
  ///If the data label is enabled, it will be visible for all the data points in the series.
  ///By using this property, we can hide the data label and its connector line, for the data
  ///points if its value is 0 (Zero).
  ///
  ///Defaults to `true`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                  dataLabelSettings: DataLabelSettings(
  ///                       isVisible: true,color: Colors.yellow,
  ///                       showZeroValue: false
  ///          ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool showZeroValue;

  ///Moves the data label vertically or horizontally from its position.
  ///
  ///If you wish to reposition the data label, you can achieve using this property.
  ///You can move the data label in both vertical and horizontal direction from
  ///its position. It takes the logical pixel value for x and y values as input.
  ///
  ///Positive value for x, moves the data label to right and negative value
  ///moves to left.
  ///Positive value for y, moves the data label upwards and negative value
  ///moves downwards.
  ///
  ///These are applied to the data label's final position. i.e. after considering
  ///the position and alignment values.
  ///
  ///Also refer [labelAlignment].
  ///
  ///_Note:_  This property is only applicable for Cartesian charts and not for
  /// Circular, Pyramid and Funnel charts.
  ///
  ///Defaults to `null`.

  final Offset? offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DataLabelSettings &&
        other.alignment == alignment &&
        other.color == color &&
        other.textStyle == textStyle &&
        other.margin == margin &&
        other.opacity == opacity &&
        other.labelAlignment == labelAlignment &&
        other.borderRadius == borderRadius &&
        other.isVisible == isVisible &&
        other.angle == angle &&
        other.builder == builder &&
        other.useSeriesColor == useSeriesColor &&
        other.offset == offset &&
        other.showCumulativeValues == showCumulativeValues &&
        other.showZeroValue == showZeroValue &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.labelIntersectAction == labelIntersectAction &&
        other.connectorLineSettings == connectorLineSettings &&
        other.labelPosition == labelPosition;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      alignment,
      color,
      textStyle,
      margin,
      opacity,
      labelAlignment,
      borderRadius,
      isVisible,
      angle,
      builder,
      useSeriesColor,
      offset,
      showCumulativeValues,
      showZeroValue,
      borderColor,
      borderWidth,
      labelIntersectAction,
      connectorLineSettings,
      labelPosition
    ];
    return hashList(values);
  }
}

///Datalabel renderer class for mutable fields and methods
class DataLabelSettingsRenderer {
  /// Creates an argument constructor for DataLabelSettings renderer class
  DataLabelSettingsRenderer(this._dataLabelSettings) {
    _angle = _dataLabelSettings.angle;
    _offset = _dataLabelSettings.offset;
    _color = _dataLabelSettings.color;
  }

  final DataLabelSettings _dataLabelSettings;

  Color? _color;

  TextStyle? _textStyle;

  TextStyle? _originalStyle;

  late int _angle;

  Offset? _offset;

  /// To render charts with data labels
  void _renderDataLabel(
      SfCartesianChartState chartState,
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point,
      Animation<double> animationController,
      Canvas canvas,
      int labelIndex,
      DataLabelSettingsRenderer dataLabelSettingsRenderer) {
    _calculateDataLabelPosition(seriesRenderer, point, labelIndex, chartState,
        dataLabelSettingsRenderer, animationController);
    _drawDataLabel(canvas, seriesRenderer, chartState, _dataLabelSettings,
        point, labelIndex, animationController, dataLabelSettingsRenderer);
  }
}
