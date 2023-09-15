import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'renderer_extension.dart';
import 'series_base.dart';
import 'series_controller.dart';

/// Renders the pyramid series.
///
/// To render a pyramid chart, create an instance of [PyramidSeries], and add it to the series property of [SfPyramidChart],
/// it is the form of a triangle with lines dividing it into sections.
///
/// Provides the property of color, opacity, border color and border width for customizing the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
///
@immutable
// ignore: must_be_immutable
class PyramidSeries<T, D> extends PyramidSeriesBase<T, D> {
  /// Creating an argument constructor of PyramidSeries class.
  PyramidSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    PyramidSeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
    List<T>? dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? yValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? textFieldMapper,
    String? name,
    String? height,
    String? width,
    PyramidMode? pyramidMode,
    double? gapRatio,
    LegendIconType? legendIconType,
    EmptyPointSettings? emptyPointSettings,
    DataLabelSettings? dataLabelSettings,
    double? animationDuration,
    double? animationDelay,
    double? opacity,
    Color? borderColor,
    double? borderWidth,
    bool? explode,
    num? explodeIndex,
    ActivationMode? explodeGesture,
    String? explodeOffset,
    SelectionBehavior? selectionBehavior,
    List<int>? initialSelectedDataIndexes,
  }) : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          onRendererCreated: onRendererCreated,
          onPointTap: onPointTap,
          onPointDoubleTap: onPointDoubleTap,
          onPointLongPress: onPointLongPress,
          dataSource: dataSource,
          xValueMapper: (int index) => xValueMapper!(dataSource![index], index),
          yValueMapper: (int index) => yValueMapper!(dataSource![index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource![index], index)
              : null,
          textFieldMapper: (int index) => textFieldMapper != null
              ? textFieldMapper(dataSource![index], index)
              : null,
          name: name,
          height: height,
          width: width,
          pyramidMode: pyramidMode,
          gapRatio: gapRatio,
          emptyPointSettings: emptyPointSettings,
          dataLabelSettings: dataLabelSettings,
          legendIconType: legendIconType,
          opacity: opacity,
          borderColor: borderColor,
          borderWidth: borderWidth,
          animationDuration: animationDuration,
          animationDelay: animationDelay,
          explode: explode,
          explodeIndex: explodeIndex,
          explodeOffset: explodeOffset,
          explodeGesture: explodeGesture,
          selectionBehavior: selectionBehavior,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  /// Create the pyramid series renderer.
  PyramidSeriesRenderer createRenderer(PyramidSeries<T, D> series) {
    PyramidSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as PyramidSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return PyramidSeriesRendererExtension();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PyramidSeries &&
        other.onCreateRenderer == onCreateRenderer &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.textFieldMapper == textFieldMapper &&
        other.name == name &&
        other.height == height &&
        other.width == width &&
        other.pyramidMode == pyramidMode &&
        other.gapRatio == gapRatio &&
        other.legendIconType == legendIconType &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.explode == explode &&
        other.explodeIndex == explodeIndex &&
        other.explodeGesture == explodeGesture &&
        other.explodeOffset == explodeOffset &&
        other.selectionBehavior == selectionBehavior &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes);
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      onCreateRenderer,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress,
      dataSource,
      xValueMapper,
      yValueMapper,
      pointColorMapper,
      textFieldMapper,
      name,
      height,
      width,
      pyramidMode,
      gapRatio,
      legendIconType,
      emptyPointSettings,
      dataLabelSettings,
      animationDuration,
      animationDelay,
      opacity,
      borderColor,
      borderWidth,
      explode,
      explodeIndex,
      explodeGesture,
      explodeOffset,
      selectionBehavior,
      initialSelectedDataIndexes
    ];
    return Object.hashAll(values);
  }
}
