part of charts;

/// This class has the properties of cartesian chart annotation.
///
/// Chart supports annotations that allow you to mark the specific area of interest in the chart area. You can add the custom widgets using this
/// annotation feature as depicted below.
///
/// The x and y values can be specified with axis units or pixel units, and these can be identified by
/// using coordinateUnit property. When the logical pixel is specified, the annotation will be placed to pixel values whereas the point is specified, then
/// the annotation will be placed to series point values.
///
/// Provides the options x, y, coordinateUnit, and widget to customize the cartesian chart annotation.
///
@immutable
class CartesianChartAnnotation {
  /// Creating an argument constructor of CartesianChartAnnotation class.
  const CartesianChartAnnotation(
      {this.widget,
      this.coordinateUnit = CoordinateUnit.logicalPixel,
      this.region = AnnotationRegion.chart,
      this.horizontalAlignment = ChartAlignment.center,
      this.verticalAlignment = ChartAlignment.center,
      this.x = 0,
      this.y = 0,
      this.xAxisName,
      this.yAxisName});

  ///Considers any widget as annotation.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Empty Data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        ));
  ///}
  ///```
  final Widget? widget;

  ///Specifies the coordinate units for placing the annotation in either logicalPixel or point.
  ///
  ///Defaults to `CoordinateUnit.logicalPixel`
  ///
  ///Also refer [CoordinateUnit]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final CoordinateUnit coordinateUnit;

  ///Annotations can be placed with respect to either plotArea or chart.
  ///
  ///Defaults to `AnnotationRegion.chart`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final AnnotationRegion region;

  ///Specifies the x-values as pixel or point values based on the coordinateUnit.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final dynamic x;

  ///Specifies the y-values as pixel or point values based on the coordinateUnit.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final num y;

  ///Specifies the x-axis name to the annotation that should be bound.
  ///
  ///Defaults to `‘’`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///              series: <ChartSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    xAxisName: 'Gold'
  ///                ),
  ///              ],
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60,
  ///                    xAxisName: 'Gold'
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String? xAxisName;

  ///Specifies the y-axis name to the annotation that should  be bound.
  ///
  ///Defaults to `‘’`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///             series: <ChartSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    yAxisName: 'Gold'
  ///                ),
  ///              ],
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60,
  ///                    yAxisName: 'Diamond'
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String? yAxisName;

  ///Aligns the annotations horizontally.
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
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60,
  ///                    HorizontalAlignment: HorizontalAlignment.near,
  ///               ),
  ///             ],
  ///        ));
  ///}
  ///```
  final ChartAlignment horizontalAlignment;

  ///Aligns the annotations vertically.
  ///
  /// Alignment can be set to near, far, or center.
  ///
  ///Defaults to `ChartAlignment.center`
  ///
  ///Also refer [ChartAlignment]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60,
  ///                    verticalAllignment: VerticalAlignment.bottom,
  ///               ),
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

    return other is CartesianChartAnnotation &&
        other.widget == widget &&
        other.coordinateUnit == coordinateUnit &&
        other.region == region &&
        other.horizontalAlignment == horizontalAlignment &&
        other.verticalAlignment == verticalAlignment &&
        other.x == x &&
        other.y == y &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      widget,
      coordinateUnit,
      region,
      horizontalAlignment,
      verticalAlignment,
      x,
      y,
      xAxisName,
      yAxisName
    ];
    return hashList(values);
  }
}
