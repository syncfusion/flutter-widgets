part of charts;

/// It is the data type for the circular chart and it has the properties is used to assign at the value
/// declaration of the circular chart.
///
/// It provides the options for color, stroke color, fill color, radius, angle to customize the circular chart.
///
class ChartPoint<D> {
  /// Creating an argument constructor of ChartPoint class.
  ChartPoint([this.x, this.y, this.radius, this.pointColor, this.sortValue]);

  /// X value of chart point
  dynamic x;

  /// Y value of chart point
  num? y;

  /// Degree of chart point
  num? degree;

  /// Start angle of chart point
  num? startAngle;

  /// End angle of chart point
  num? endAngle;

  /// Middle angle of chart point
  num? midAngle;

  /// Center position of chart point
  Offset? center;

  /// Text value of chart point
  String? text;

  /// Fill  color of the chart point
  late Color fill;

  /// Color of chart point
  late Color color;

  /// Stroke color of chart point
  late Color strokeColor;

  /// Sort value of chart point
  D? sortValue;

  /// Stroke width of chart point
  late num strokeWidth;

  /// Inner radius of chart point
  num? innerRadius;

  /// Outer radius of chart point
  num? outerRadius;

  /// To set the explode value of chart point
  bool? isExplode;

  /// To set the shadow value of chart point
  bool? isShadow;

  /// to set the empty value of chart point
  bool isEmpty = false;

  /// To set the visibility of chart point
  bool isVisible = true;

  /// To set the selected or unselected of chart point
  bool isSelected = false;

  /// Data label positin of chart point
  late Position dataLabelPosition;

  /// Render position of chart point
  ChartDataLabelPosition? renderPosition;

  /// Label rect of chart point.
  late Rect labelRect;

  /// Size of the Data label of chart point
  Size dataLabelSize = const Size(0, 0);

  /// Saturation region value of chart point
  bool saturationRegionOutside = false;

  /// Y ratio of chart point
  late num yRatio;

  /// Height Ratio of chart point
  late num heightRatio;

  /// Radius of the chart point
  String? radius;

  /// Color property of the chart point
  Color? pointColor;

  /// To execute onTooltipRender event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// To execute OnDataLabelRender event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;

  /// Current point index.
  late int index;

  // Data type
  dynamic _data;

  /// PointShader Mapper
  ChartShaderMapper<dynamic>? _pointShaderMapper;

  /// Shader of chart point
  Shader? get shader =>
      _pointShaderMapper != null && center != null && outerRadius != null
          ? _pointShaderMapper!(
              _data,
              index,
              fill,
              Rect.fromCircle(
                center: center!,
                radius: outerRadius!.toDouble(),
              ),
            )
          : null;

  /// Path of circular Series
  Rect? _pathRect;

  /// Stores the tooltip label text.
  late String _tooltipLabelText;

  /// Stores the tooltip header text.
  late String _tooltipHeaderText;
}

class _Region {
  _Region(
      this.start,
      this.end,
      this.startAngle,
      this.endAngle,
      this.seriesIndex,
      this.pointIndex,
      this.center,
      this.innerRadius,
      this.outerRadius);
  int seriesIndex;
  int pointIndex;
  num startAngle;
  num start;
  num end;
  num endAngle;
  Offset? center;
  num? innerRadius;
  num outerRadius;
}

class _StyleOptions {
  _StyleOptions({this.fill, this.strokeWidth, this.strokeColor, this.opacity});
  Color? fill;
  Color? strokeColor;
  double? opacity;
  num? strokeWidth;
}

/// This class holds the properties of the connector line.
///
/// ConnectorLineSetting is the Argument type of [DataLabelSettings], It is used to customize the data label connected lines while the data label
/// position is outside the chart. It is enabled by setting the data label visibility.
///
/// It provides the options for length, width, color, and enum type [ConnectorType] to customize the appearance.
///
class ConnectorLineSettings {
  /// Creating an argument constructor of ConnectorLineSettings class.
  const ConnectorLineSettings(
      {this.length, double? width, ConnectorType? type, this.color})
      : width = width ?? 1.0,
        type = type ?? ConnectorType.line;

  ///Length of the connector line.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            length: '8%
  ///           )
  ///          )
  ///        ));
  ///}
  ///```
  final String? length;

  ///Width of the connector line.
  ///
  ///Defaults to `1.0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            width: 2
  ///           )
  ///          )
  ///        ));
  ///}
  ///```
  final double width;

  ///Color of the connector line.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            color: Colors.red,
  ///           )
  ///          )
  ///        ));
  ///}
  ///```
  final Color? color;

  ///Type of the connector line.
  ///
  ///Defaults to `ConnectorType.line`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///             type: ConnectorType.curve
  ///           )
  ///          )
  ///        ));
  ///}
  ///```
  final ConnectorType type;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ConnectorLineSettings &&
        other.length == length &&
        other.width == width &&
        other.color == color &&
        other.type == type;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[length, width, color, type];
    return hashList(values);
  }
}

class _ChartInteraction {
  _ChartInteraction(this.seriesIndex, this.pointIndex, this.series, this.point,
      [this.region]);
  int? seriesIndex;
  int? pointIndex;
  dynamic series;
  dynamic point;
  _Region? region;
}

/// Customizes the annotation of the circular chart.
///
///Circular chart allows you to mark the specific area of interest in the chart area.
/// You can add the custom widgets using this annotation feature, It has the properties for customizing the appearance.
///
/// The angle, orientation, height, and width of the inserted annotation can all be customized.
///
/// It provides options for angle, height, width, vertical and horizontal alignment to customize the appearance.
///
@immutable
class CircularChartAnnotation {
  /// Creating an argument constructor of CircularChartAnnotation class.
  const CircularChartAnnotation(
      {int? angle,
      String? radius,
      this.widget,
      String? height,
      String? width,
      ChartAlignment? horizontalAlignment,
      ChartAlignment? verticalAlignment})
      : angle = angle ?? 0,
        radius = radius ?? '0%',
        height = height ?? '0%',
        width = width ?? '0%',
        verticalAlignment = verticalAlignment ?? ChartAlignment.center,
        horizontalAlignment = horizontalAlignment ?? ChartAlignment.center;

  ///Angle to rotate the annotation.
  ///
  ///Defaults to `0`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    angle: 40,
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final int angle;

  ///Radius for placing the annotation.
  ///
  ///The value ranges from 0% to 100%.
  ///
  ///Defaults to `0%`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    radius: '10%'
  ///                    child: Container(
  ///                    child: const Text('Empty data'),
  ///               ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String radius;

  ///Considers any widget as annotation.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    child: Container(
  ///                     child:Text('Annotation')),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final Widget? widget;

  ///Height of the annotation.
  ///
  ///Defaults to `0%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    height: '10%',
  ///                    child: Container(
  ///                    child: const Text('Empty data'),
  ///                 ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String height;

  ///Width of the annotation.
  ///
  ///Defaults to `0%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    width: '10%',
  ///                    child: Container(
  ///                    child: const Text('Empty data'),
  ///                 ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String width;

  ///Aligns the annotation horizontally.
  ///
  ///Alignment can be set to near, far, or center.
  ///
  ///Defaults to `ChartAlignment.center`
  ///
  ///Also refer [ChartAlignment]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    horizontalAlignment: ChartAlignment.near
  ///                    child: Container(
  ///                    child: const Text('Empty data'),
  ///                 ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final ChartAlignment horizontalAlignment;

  ///Aligns the annotation vertically.
  ///
  ///Alignment can be set to near, far, or center.
  ///
  ///Defaults to `ChartAlignment.center`
  ///
  ///Also refer [ChartAlignment]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    verticalAlignment: ChartAlignment.near
  ///                    child: Container(
  ///                    child: const Text('Empty data'),
  ///                 ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final ChartAlignment verticalAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CircularChartAnnotation &&
        other.angle == angle &&
        other.radius == radius &&
        other.height == height &&
        other.horizontalAlignment == horizontalAlignment &&
        other.verticalAlignment == verticalAlignment &&
        other.widget == widget &&
        other.width == width;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      angle,
      radius,
      height,
      horizontalAlignment,
      verticalAlignment,
      widget,
      width
    ];
    return hashList(values);
  }
}

///To get circular series data label saturation color
Color _getCircularDataLabelColor(ChartPoint<dynamic> currentPoint,
    CircularSeriesRenderer seriesRenderer, SfCircularChartState _chartState) {
  Color color;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final DataLabelSettingsRenderer dataLabelSettingsRenderer =
      seriesRenderer._dataLabelSettingsRenderer;
  final String seriesType = seriesRenderer._seriesType == 'pie'
      ? 'Pie'
      : seriesRenderer._seriesType == 'doughnut'
          ? 'Doughnut'
          : seriesRenderer._seriesType == 'radialbar'
              ? 'RadialBar'
              : 'Default';
  switch (seriesType) {
    case 'Pie':
    case 'Doughnut':
      color = (currentPoint.renderPosition == ChartDataLabelPosition.inside &&
              !currentPoint.saturationRegionOutside)
          ? _getInnerColor(dataLabelSettingsRenderer._color, currentPoint.fill,
              _chartState._renderingDetails.chartTheme)
          : _getOuterColor(
              dataLabelSettingsRenderer._color,
              dataLabel.useSeriesColor
                  ? currentPoint.fill
                  : (_chartState._chart.backgroundColor ??
                      _chartState._renderingDetails.chartTheme
                          .plotAreaBackgroundColor),
              _chartState._renderingDetails.chartTheme);
      break;
    case 'RadialBar':
      final RadialBarSeries<dynamic, dynamic> radialBar =
          seriesRenderer._series as RadialBarSeries<dynamic, dynamic>;
      color = radialBar.trackColor;
      break;
    default:
      color = Colors.white;
  }
  return _getSaturationColor(color);
}

///To get inner data label color
Color _getInnerColor(
        Color? dataLabelColor, Color? pointColor, SfChartThemeData theme) =>
    // ignore: prefer_if_null_operators
    dataLabelColor != null
        ? dataLabelColor
        // ignore: prefer_if_null_operators
        : pointColor != null
            ? pointColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

///To get outer data label color
Color _getOuterColor(
        Color? dataLabelColor, Color backgroundColor, SfChartThemeData theme) =>
    // ignore: prefer_if_null_operators
    dataLabelColor != null
        ? dataLabelColor
        : backgroundColor != Colors.transparent
            ? backgroundColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

/// To check whether any point is selected
bool _checkIsAnyPointSelect(CircularSeriesRenderer seriesRenderer,
    ChartPoint<dynamic>? point, SfCircularChart chart) {
  bool isAnyPointSelected = false;
  final CircularSeries<dynamic, dynamic> series = seriesRenderer._series;
  if (series.initialSelectedDataIndexes.isNotEmpty) {
    int data;
    for (int i = 0; i < series.initialSelectedDataIndexes.length; i++) {
      data = series.initialSelectedDataIndexes[i];
      for (int j = 0; j < seriesRenderer._renderPoints!.length; j++) {
        if (j == data) {
          isAnyPointSelected = true;
          break;
        }
      }
    }
  }
  return isAnyPointSelected;
}
