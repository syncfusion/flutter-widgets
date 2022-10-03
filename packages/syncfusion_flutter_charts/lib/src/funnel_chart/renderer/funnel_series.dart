import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../chart/chart_series/series.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart';
import '../../pyramid_chart/utils/common.dart';
import '../base/funnel_base.dart';
import '../base/funnel_state_properties.dart';
import 'renderer_extension.dart';
import 'series_base.dart';

/// Renders Funnel series.
///
/// The FunnelSeries is the SfFunnelChart Type series.
/// To render a funnel chart, create an instance of FunnelSeries, and add it to the series property of [SfFunnelChart].
///
/// Provides options to customize the [opacity], [borderWidth], [borderColor] and [pointColorMapper] of the funnel segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
class FunnelSeries<T, D> extends FunnelSeriesBase<T, D> {
  /// Creating an argument constructor of FunnelSeries class.
  FunnelSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    FunnelSeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
    List<T>? dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? yValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? textFieldMapper,
    String? name,
    String? neckWidth,
    String? neckHeight,
    String? height,
    String? width,
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
    ActivationMode? explodeGesture,
    String? explodeOffset,
    SelectionBehavior? selectionBehavior,
    num? explodeIndex,
    List<int>? initialSelectedDataIndexes,
  }) : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            dataSource: dataSource,
            xValueMapper: (int index) =>
                xValueMapper!(dataSource![index], index),
            yValueMapper: (int index) =>
                yValueMapper!(dataSource![index], index),
            pointColorMapper: (int index) => pointColorMapper != null
                ? pointColorMapper(dataSource![index], index)
                : null,
            textFieldMapper: (int index) => textFieldMapper != null
                ? textFieldMapper(dataSource![index], index)
                : null,
            name: name,
            neckWidth: neckWidth,
            neckHeight: neckHeight,
            height: height,
            width: width,
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
            explodeGesture: explodeGesture,
            explodeOffset: explodeOffset,
            selectionBehavior: selectionBehavior,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Create the funnel series renderer.
  FunnelSeriesRenderer createRenderer(FunnelSeries<T, D> series) {
    FunnelSeriesRenderer? seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as FunnelSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return FunnelSeriesRendererExtension();
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

    return other is FunnelSeries &&
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
        other.neckWidth == neckWidth &&
        other.neckHeight == neckHeight &&
        other.height == height &&
        other.width == width &&
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
        other.explodeGesture == explodeGesture &&
        other.explodeOffset == explodeOffset &&
        other.selectionBehavior == selectionBehavior &&
        other.explodeIndex == explodeIndex &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
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
      neckWidth,
      neckHeight,
      height,
      width,
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
      explodeGesture,
      explodeOffset,
      selectionBehavior,
      explodeIndex,
      initialSelectedDataIndexes
    ];
    return Object.hashAll(values);
  }
}

/// Creates series renderer for Funnel series.
class FunnelSeriesRenderer extends ChartSeriesRenderer {
  /// Calling the default constructor of FunnelSeriesRenderer class.
  FunnelSeriesRenderer();
}

/// We can redraw the series with updating or creating new points by using this controller.If we need to access the redrawing methods
/// in this before we must get the ChartSeriesController onRendererCreated event.
class FunnelSeriesController {
  /// Creating an argument constructor of FunnelSeriesController class.
  FunnelSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                    onRendererCreated: (FunnelSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer.seriesRendererDetails.series.yAxisName);
  ///                    },
  ///                ),
  ///        )
  ///   );
  ///}
  ///```
  final FunnelSeriesRenderer seriesRenderer;

  /// Used to process only the newly added, updated and removed data points in a series,
  /// instead of processing all the data points.
  ///
  /// To re-render the chart with modified data points, setState() will be called.
  /// This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called by passing updated data points indexes.
  /// Chart will process only that point and skip various steps like bounds calculation,
  /// old data points processing, etc. Thus, this will improve the app’s performance.
  ///
  /// The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point in the existing series.
  ///
  /// Returns `void`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    FunnelSeriesController _funnelSeriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated: (FunnelSeriesController controller) {
  ///                       _funnelSeriesController = controller;
  ///                    },
  ///                ),
  ///        )
  ///   ),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           _funnelSeriesController.updateDataSource(
  ///               addedDataIndexes: <int>[chartData.length -1],
  ///               removedDataIndexes: <int>[0],
  ///           );
  ///      })
  ///   )]
  ///  );
  /// }
  ///```
  void updateDataSource(
      {List<int>? addedDataIndexes,
      List<int>? removedDataIndexes,
      List<int>? updatedDataIndexes,
      int? addedDataIndex,
      int? removedDataIndex,
      int? updatedDataIndex}) {
    if (removedDataIndexes != null && removedDataIndexes.isNotEmpty) {
      _removeDataPointsList(removedDataIndexes);
    } else if (removedDataIndex != null) {
      _removeDataPoint(removedDataIndex);
    }
    if (addedDataIndexes != null && addedDataIndexes.isNotEmpty) {
      _addOrUpdateDataPoints(addedDataIndexes, false);
    } else if (addedDataIndex != null) {
      _addOrUpdateDataPoint(addedDataIndex, false);
    }
    if (updatedDataIndexes != null && updatedDataIndexes.isNotEmpty) {
      _addOrUpdateDataPoints(updatedDataIndexes, true);
    } else if (updatedDataIndex != null) {
      _addOrUpdateDataPoint(updatedDataIndex, true);
    }
    _updateFunnelSeries();
  }

  /// Add or update the data points on dynamic series update.
  void _addOrUpdateDataPoints(List<int> indexes, bool needUpdate) {
    int dataIndex;
    for (int i = 0; i < indexes.length; i++) {
      dataIndex = indexes[i];
      _addOrUpdateDataPoint(dataIndex, needUpdate);
    }
  }

  /// Add or update a data point in the given index.
  void _addOrUpdateDataPoint(int index, bool needUpdate) {
    final FunnelSeriesRendererExtension renderer =
        seriesRenderer as FunnelSeriesRendererExtension;
    final FunnelSeries<dynamic, dynamic> series = renderer.series;
    if (index >= 0 &&
        series.dataSource!.length > index &&
        series.dataSource![index] != null) {
      final ChartIndexedValueMapper<dynamic>? xValue = series.xValueMapper;
      final ChartIndexedValueMapper<dynamic>? yValue = series.yValueMapper;
      final PointInfo<dynamic> currentPoint =
          PointInfo<dynamic>(xValue!(index), yValue!(index));
      if (currentPoint.x != null) {
        if (needUpdate) {
          if (renderer.dataPoints.length > index) {
            renderer.dataPoints[index] = currentPoint;
          }
        } else {
          if (renderer.dataPoints.length == index) {
            renderer.dataPoints.add(currentPoint);
          } else if (renderer.dataPoints.length > index && index >= 0) {
            renderer.dataPoints.insert(index, currentPoint);
          }
        }
      }
    }
  }

  /// Remove list of points.
  void _removeDataPointsList(List<int> removedDataIndexes) {
    /// Remove the redundant index from the list.
    final List<int> indexList = removedDataIndexes.toSet().toList();
    indexList.sort((int b, int a) => a.compareTo(b));
    int dataIndex;
    for (int i = 0; i < indexList.length; i++) {
      dataIndex = indexList[i];
      _removeDataPoint(dataIndex);
    }
  }

  /// Remove a data point in the given index.
  void _removeDataPoint(int index) {
    final FunnelSeriesRendererExtension renderer =
        seriesRenderer as FunnelSeriesRendererExtension;
    if (renderer.dataPoints.isNotEmpty &&
        index >= 0 &&
        index < renderer.dataPoints.length) {
      renderer.dataPoints.removeAt(index);
    }
  }

  /// After add/remove/update data points, recalculate the chart segments.
  void _updateFunnelSeries() {
    final FunnelSeriesRendererExtension renderer =
        seriesRenderer as FunnelSeriesRendererExtension;
    final FunnelStateProperties stateProperties = renderer.stateProperties;
    stateProperties.chartSeries.processDataPoints(renderer);
    stateProperties.chartSeries.initializeSeriesProperties(renderer);
    renderer.repaintNotifier.value++;
    if (renderer.series.dataLabelSettings.isVisible &&
        stateProperties.renderDataLabel != null) {
      stateProperties.renderDataLabel!.state!.render();
    }
    if (renderer.series.dataLabelSettings.isVisible &&
        stateProperties.renderingDetails.chartTemplate != null &&
        // ignore: unnecessary_null_comparison
        stateProperties.renderingDetails.chartTemplate!.state != null) {
      stateProperties.renderingDetails.chartTemplate!.state.templateRender();
    }
  }

  /// Converts chart data point value to logical pixel value.
  ///
  /// The [pointToPixel] method takes chart data point value as input and returns logical pixel value.
  ///
  /// _Note_: It returns the data point's center location value.
  ///
  ///```Dart
  /// late FunnelSeriesController seriesController;
  /// SfFunnelChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     PointInfo<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///     PointInfo<double> chartPoint1 = seriesController.pixelToPoint(value);
  ///   },
  ///     series: FunnelSeries<ChartSampleData, String>(
  ///         dataSource: funnelData,
  ///         onRendererCreated: (FunnelSeriesController funnelSeriesController) {
  ///           seriesController = FunnelSeriesController;
  ///         }
  ///     )
  /// );
  /// ```
  // ignore: unused_element
  Offset _pointToPixel(PointInfo<dynamic> point) {
    return pyramidFunnelPointToPixel(point, seriesRenderer);
  }

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and returns a chart data point.
  ///
  ///```dart
  /// late FunnelSeriesController seriesController;
  /// SfFunnelChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     PointInfo<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///   },
  ///     series: FunnelSeries<ChartSampleData, String>(
  ///         dataSource: funnelData,
  ///         onRendererCreated: (FunnelSeriesController funnelSeriesController) {
  ///           seriesController = FunnelSeriesController;
  ///         }
  ///     )
  /// );
  /// ```
  PointInfo<dynamic> pixelToPoint(Offset position) {
    return pyramidFunnelPixelToPoint(position, seriesRenderer);
  }
}
