import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../base/circular_base.dart';
import '../utils/enum.dart';
import 'circular_series.dart';
import 'renderer_base.dart';
import 'renderer_extension.dart';

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
      String? name,
      double? animationDuration,
      double? animationDelay,
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
            animationDelay: animationDelay,
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
            sortingOrder: sortingOrder);

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
    return PieSeriesRendererExtension();
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
        other.animationDelay == animationDelay &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.dataLabelMapper == dataLabelMapper &&
        other.dataLabelSettings == dataLabelSettings &&
        other.dataSource == dataSource &&
        other.emptyPointSettings == emptyPointSettings &&
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
      animationDelay,
      borderColor,
      borderWidth,
      dataLabelMapper,
      dataLabelSettings,
      dataSource,
      emptyPointSettings,
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
    return Object.hashAll(values);
  }
}
