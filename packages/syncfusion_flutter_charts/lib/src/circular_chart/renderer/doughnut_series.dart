part of charts;

/// This class has the properties of the Doughnut series.
///
/// To render a doughnut chart, create an instance of [DoughnutSeries], and add it to the series
/// collection property of [SfCircularChart].
///
/// Provide options for opacity, stroke width, stroke color, and point color mapper to customize the appearance.
///
class DoughnutSeries<T, D> extends CircularSeries<T, D> {
  /// Creating an argument constructor of DoughnutSeries class.
  DoughnutSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      CircularSeriesRendererCreatedCallback? onRendererCreated,
      List<T>? dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartShaderMapper<T>? pointShaderMapper,
      ChartValueMapper<T, String>? pointRadiusMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      ChartValueMapper<T, String>? sortFieldValueMapper,
      int? startAngle,
      int? endAngle,
      String? radius,
      String? innerRadius,
      bool? explode,
      bool? explodeAll,
      int? explodeIndex,
      String? explodeOffset,
      ActivationMode? explodeGesture,
      double? groupTo,
      CircularChartGroupMode? groupMode,
      PointRenderMode? pointRenderMode,
      EmptyPointSettings? emptyPointSettings,
      Color? strokeColor,
      double? strokeWidth,
      DataLabelSettings? dataLabelSettings,
      bool? enableTooltip,
      bool? enableSmartLabels,
      String? name,
      double? opacity,
      double? animationDuration,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings? selectionSettings,
      SelectionBehavior? selectionBehavior,
      SortingOrder? sortingOrder,
      LegendIconType? legendIconType,
      CornerStyle? cornerStyle,
      List<int>? initialSelectedDataIndexes})
      : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          onRendererCreated: onRendererCreated,
          dataSource: dataSource,
          xValueMapper: (int index) => xValueMapper(dataSource![index], index),
          yValueMapper: (int index) => yValueMapper(dataSource![index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource![index], index)
              : null,
          pointRadiusMapper: pointRadiusMapper == null
              ? null
              : (int index) => pointRadiusMapper(dataSource![index], index),
          pointShaderMapper: pointShaderMapper != null
              ? (dynamic data, int index, Color color, Rect rect) =>
                  pointShaderMapper(dataSource![index], index, color, rect)
              : null,
          dataLabelMapper: (int index) => dataLabelMapper != null
              ? dataLabelMapper(dataSource![index], index)
              : null,
          sortFieldValueMapper: sortFieldValueMapper != null
              ? (int index) => sortFieldValueMapper(dataSource![index], index)
              : null,
          animationDuration: animationDuration,
          startAngle: startAngle,
          endAngle: endAngle,
          radius: radius,
          innerRadius: innerRadius,
          explode: explode,
          opacity: opacity,
          explodeAll: explodeAll,
          explodeIndex: explodeIndex,
          explodeOffset: explodeOffset,
          explodeGesture: explodeGesture,
          pointRenderMode: pointRenderMode,
          groupMode: groupMode,
          groupTo: groupTo,
          emptyPointSettings: emptyPointSettings,
          borderColor: strokeColor,
          borderWidth: strokeWidth,
          dataLabelSettings: dataLabelSettings,
          enableTooltip: enableTooltip,
          name: name,
          selectionSettings: selectionSettings,
          selectionBehavior: selectionBehavior,
          legendIconType: legendIconType,
          sortingOrder: sortingOrder,
          enableSmartLabels: enableSmartLabels,
          cornerStyle: cornerStyle,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  /// Create the  circular series renderer.
  DoughnutSeriesRenderer? createRenderer(CircularSeries<T, D> series) {
    DoughnutSeriesRenderer? seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as DoughnutSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return DoughnutSeriesRenderer();
  }
}

class _DoughnutChartPainter extends CustomPainter {
  _DoughnutChartPainter({
    required this.chartState,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  }) : super(repaint: notifier);
  final SfCircularChartState chartState;
  final int index;
  final bool isRepaint;
  final AnimationController? animationController;
  final Animation<double>? seriesAnimation;

  late DoughnutSeriesRenderer seriesRenderer;

  /// To paint series
  @override
  void paint(Canvas canvas, Size size) {
    final SfCircularChart chart = chartState._chart;
    num? pointStartAngle;
    seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[index]
        as DoughnutSeriesRenderer;
    pointStartAngle = seriesRenderer._start;
    seriesRenderer._innerRadius = seriesRenderer._currentInnerRadius;
    seriesRenderer._radius = seriesRenderer._currentRadius;
    ChartPoint<dynamic> point;
    seriesRenderer._pointRegions = <_Region>[];
    ChartPoint<dynamic>? _oldPoint;
    final DoughnutSeriesRenderer? oldSeriesRenderer =
        (chartState._widgetNeedUpdate &&
                !chartState._isLegendToggled &&
                chartState._prevSeriesRenderer?._seriesType == 'doughnut')
            ? chartState._prevSeriesRenderer as DoughnutSeriesRenderer
            : null;
    seriesRenderer._renderPaths.clear();
    seriesRenderer._renderList.clear();
    for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
      point = seriesRenderer._renderPoints![i];
      _oldPoint = (oldSeriesRenderer != null &&
              oldSeriesRenderer._oldRenderPoints != null &&
              (oldSeriesRenderer._oldRenderPoints!.length - 1 >= i))
          ? oldSeriesRenderer._oldRenderPoints![i]
          : ((chartState._isLegendToggled &&
                  chartState._prevSeriesRenderer?._seriesType == 'doughnut')
              ? chartState._oldPoints![i]
              : null);
      pointStartAngle = seriesRenderer._circularRenderPoint(
          chart,
          seriesRenderer,
          point,
          pointStartAngle,
          point.innerRadius,
          point.outerRadius,
          canvas,
          index,
          i,
          seriesAnimation?.value ?? 1,
          1,
          _checkIsAnyPointSelect(seriesRenderer, point, chart),
          _oldPoint,
          chartState._oldPoints);
    }

    if (seriesRenderer._renderList.isNotEmpty) {
      Shader? _chartShader;
      if (chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails = ChartShaderDetails(seriesRenderer._renderList[1],
            seriesRenderer._renderList[2], 'series');
        _chartShader = chart.onCreateShader!(chartShaderDetails);
      }
      for (int k = 0; k < seriesRenderer._renderPaths.length; k++) {
        _drawPath(
            canvas,
            seriesRenderer._renderList[0],
            seriesRenderer._renderPaths[k],
            seriesRenderer._renderList[1],
            _chartShader);
      }
      if (seriesRenderer._renderList[0].strokeColor != null &&
          seriesRenderer._renderList[0].strokeWidth != null &&
          seriesRenderer._renderList[0].strokeWidth > 0) {
        final Paint paint = Paint();
        paint.color = seriesRenderer._renderList[0].strokeColor;
        paint.strokeWidth = seriesRenderer._renderList[0].strokeWidth;
        paint.style = PaintingStyle.stroke;
        for (int k = 0; k < seriesRenderer._renderPaths.length; k++) {
          canvas.drawPath(seriesRenderer._renderPaths[k], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DoughnutChartPainter oldDelegate) => isRepaint;
}

/// Creates series renderer for Doughnut series
class DoughnutSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of DoughnutSeriesRenderer class.
  DoughnutSeriesRenderer();

  /// stores the series of the corresponding series for renderer
  late CircularSeries<dynamic, dynamic> series;

  //ignore: unused_field
  late num _innerRadius;

  //ignore: unused_field
  late num _radius;
}
