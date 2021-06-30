part of charts;

/// This class has the properties of the pie series.
///
/// To render a pie chart, create an instance of [PieSeries], and add it to the series collection property of [SfCircularChart].
///
/// It provides the options for color, opacity, border color, and border width to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
class PieSeries<T, D> extends CircularSeries<T, D> {
  /// Creating an argument constructor of PieSeries class.
  PieSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      CircularSeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<T>? dataSource,
      ChartValueMapper<T, D>? xValueMapper,
      ChartValueMapper<T, num>? yValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartShaderMapper<T>? pointShaderMapper,
      ChartValueMapper<T, String>? pointRadiusMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      ChartValueMapper<T, String>? sortFieldValueMapper,
      int? startAngle,
      int? endAngle,
      String? radius,
      bool? explode,
      bool? explodeAll,
      int? explodeIndex,
      ActivationMode? explodeGesture,
      String? explodeOffset,
      double? groupTo,
      CircularChartGroupMode? groupMode,
      PointRenderMode? pointRenderMode,
      EmptyPointSettings? emptyPointSettings,
      Color? strokeColor,
      double? strokeWidth,
      double? opacity,
      DataLabelSettings? dataLabelSettings,
      bool? enableTooltip,
      bool? enableSmartLabels,
      String? name,
      double? animationDuration,
      SelectionBehavior? selectionBehavior,
      SortingOrder? sortingOrder,
      LegendIconType? legendIconType,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: (int index) =>
                xValueMapper!(dataSource![index], index),
            yValueMapper: (int index) =>
                yValueMapper!(dataSource![index], index),
            pointColorMapper: (int index) => pointColorMapper != null
                ? pointColorMapper(dataSource![index], index)
                : null,
            pointRadiusMapper: pointRadiusMapper == null
                ? null
                : (int index) => pointRadiusMapper(dataSource![index], index),
            dataLabelMapper: (int index) => dataLabelMapper != null
                ? dataLabelMapper(dataSource![index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource![index], index)
                : null,
            pointShaderMapper: pointShaderMapper != null
                ? (dynamic data, int index, Color color, Rect rect) =>
                    pointShaderMapper(dataSource![index], index, color, rect)
                : null,
            startAngle: startAngle,
            endAngle: endAngle,
            radius: radius,
            explode: explode,
            explodeAll: explodeAll,
            explodeIndex: explodeIndex,
            explodeOffset: explodeOffset,
            explodeGesture: explodeGesture,
            groupTo: groupTo,
            groupMode: groupMode,
            pointRenderMode: pointRenderMode,
            emptyPointSettings: emptyPointSettings,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            borderColor: strokeColor,
            borderWidth: strokeWidth,
            opacity: opacity,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            name: name,
            selectionBehavior: selectionBehavior,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            enableSmartLabels: enableSmartLabels);

  /// Create the  pie series renderer.
  PieSeriesRenderer? createRenderer(CircularSeries<T, D> series) {
    PieSeriesRenderer? seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as PieSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return PieSeriesRenderer();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PieSeries &&
        other.animationDuration == animationDuration &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.dataLabelMapper == dataLabelMapper &&
        other.dataLabelSettings == dataLabelSettings &&
        other.dataSource == dataSource &&
        other.emptyPointSettings == emptyPointSettings &&
        other.enableSmartLabels == enableSmartLabels &&
        other.enableTooltip == enableTooltip &&
        other.endAngle == endAngle &&
        other.explode == explode &&
        other.explodeAll == explodeAll &&
        other.explodeGesture == explodeGesture &&
        other.explodeIndex == explodeIndex &&
        other.explodeOffset == explodeOffset &&
        other.groupMode == groupMode &&
        other.groupTo == groupTo &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes) &&
        other.legendIconType == legendIconType &&
        other.name == name &&
        other.onCreateRenderer == onCreateRenderer &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.opacity == opacity &&
        other.pointColorMapper == pointColorMapper &&
        other.pointRadiusMapper == pointRadiusMapper &&
        other.pointRenderMode == pointRenderMode &&
        other.pointShaderMapper == pointShaderMapper &&
        other.radius == radius &&
        other.selectionBehavior == selectionBehavior &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.sortingOrder == sortingOrder &&
        other.startAngle == startAngle &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      animationDuration,
      borderColor,
      borderWidth,
      dataLabelMapper,
      dataLabelSettings,
      dataSource,
      emptyPointSettings,
      enableSmartLabels,
      enableTooltip,
      endAngle,
      explode,
      explodeAll,
      explodeGesture,
      explodeIndex,
      explodeOffset,
      groupMode,
      groupTo,
      initialSelectedDataIndexes,
      legendIconType,
      name,
      onCreateRenderer,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress,
      opacity,
      pointColorMapper,
      pointRadiusMapper,
      pointRenderMode,
      pointShaderMapper,
      radius,
      selectionBehavior,
      sortFieldValueMapper,
      sortingOrder,
      startAngle,
      xValueMapper,
      yValueMapper
    ];
    return hashList(values);
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.chartState,
    required this.index,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  })  : chart = chartState._chart,
        super(repaint: notifier);
  final SfCircularChartState chartState;
  final SfCircularChart chart;
  final int index;
  final bool isRepaint;
  final AnimationController? animationController;
  final Animation<double>? seriesAnimation;

  late PieSeriesRenderer seriesRenderer;

  /// To paint series
  @override
  void paint(Canvas canvas, Size size) {
    num? pointStartAngle;
    seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[index]
        as PieSeriesRenderer;
    pointStartAngle = seriesRenderer._segmentRenderingValues['start'];
    seriesRenderer._pointRegions = <_Region>[];
    bool isAnyPointNeedSelect = false;
    if (chartState._renderingDetails.initialRender!) {
      isAnyPointNeedSelect =
          _checkIsAnyPointSelect(seriesRenderer, seriesRenderer._point, chart);
    }
    ChartPoint<dynamic>? _oldPoint;
    ChartPoint<dynamic>? point = seriesRenderer._point;
    final PieSeriesRenderer? oldSeriesRenderer =
        (chartState._renderingDetails.widgetNeedUpdate &&
                !chartState._renderingDetails.isLegendToggled &&
                chartState._prevSeriesRenderer != null &&
                chartState._prevSeriesRenderer!._seriesType == 'pie')
            ? chartState._prevSeriesRenderer! as PieSeriesRenderer
            : null;
    seriesRenderer._renderPaths.clear();
    seriesRenderer._renderList.clear();
    for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
      point = seriesRenderer._renderPoints![i];
      _oldPoint = (oldSeriesRenderer != null &&
              oldSeriesRenderer._oldRenderPoints != null &&
              (oldSeriesRenderer._oldRenderPoints!.length - 1 >= i))
          ? oldSeriesRenderer._oldRenderPoints![i]
          : ((chartState._renderingDetails.isLegendToggled &&
                  chartState._prevSeriesRenderer?._seriesType == 'pie')
              ? chartState._oldPoints![i]
              : null);
      point.innerRadius = 0.0;
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
          seriesAnimation?.value ?? 1,
          isAnyPointNeedSelect,
          _oldPoint,
          chartState._oldPoints);
    }
    if (seriesRenderer._renderList.isNotEmpty) {
      Shader? _chartShader;
      if (chart.onCreateShader != null) {
        ChartShaderDetails chartShaderDetails;
        chartShaderDetails =
            ChartShaderDetails(seriesRenderer._renderList[1], null, 'series');
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
          seriesRenderer._renderList[0].strokeWidth > 0 == true) {
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
  bool shouldRepaint(_PieChartPainter oldDelegate) => isRepaint;
}

/// Creates series renderer for Pie series
class PieSeriesRenderer extends CircularSeriesRenderer {
  /// Calling the default constructor of PieSeriesRenderer class.
  PieSeriesRenderer();
  @override
  late CircularSeries<dynamic, dynamic> _series;
  ChartPoint<dynamic>? _point;
}
