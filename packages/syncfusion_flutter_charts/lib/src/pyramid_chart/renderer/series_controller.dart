import 'dart:ui';

import '../../chart/chart_series/series.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart';
import '../base/pyramid_state_properties.dart';
import '../utils/common.dart';
import 'pyramid_series.dart';
import 'renderer_extension.dart';

/// We can redraw the series with updating or creating new points by using this controller.If we need to access the redrawing methods
/// in this before we must get the ChartSeriesController onRendererCreated event.
class PyramidSeriesController {
  /// Creating an argument constructor of PyramidSeriesController class.
  PyramidSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                    onRendererCreated: (PyramidSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer.seriesRendererDetails.series.yAxisName);
  ///                    },
  ///                ),
  ///        )
  ///    );
  ///}
  ///```
  final PyramidSeriesRenderer seriesRenderer;

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
  ///    PyramidSeriesController _pyramidSeriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated: (PyramidSeriesController controller) {
  ///                       _pyramidSeriesController = controller;
  ///                    },
  ///                ),
  ///        )
  ///   ),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           _pyramidSeriesController.updateDataSource(
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
    _updatePyramidSeries();
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
    final PyramidSeriesRendererExtension renderer =
        seriesRenderer as PyramidSeriesRendererExtension;
    final PyramidSeries<dynamic, dynamic> series = renderer.series;
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
    //Remove the redundant index from the list
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
    final PyramidSeriesRendererExtension renderer =
        seriesRenderer as PyramidSeriesRendererExtension;
    if (renderer.dataPoints.isNotEmpty &&
        index >= 0 &&
        index < renderer.dataPoints.length) {
      renderer.dataPoints.removeAt(index);
    }
  }

  /// After add/remove/update data points, recalculate the chart angle and positions.
  void _updatePyramidSeries() {
    final PyramidSeriesRendererExtension renderer =
        seriesRenderer as PyramidSeriesRendererExtension;
    final PyramidStateProperties stateProperties = renderer.stateProperties;
    stateProperties.chartSeries.processDataPoints();
    stateProperties.chartSeries.initializeSeriesProperties(renderer);
    renderer.repaintNotifier.value++;
    if (renderer.series.dataLabelSettings.isVisible &&
        stateProperties.renderDataLabel != null) {
      stateProperties.renderDataLabel!.state?.render();
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
  ///```dart
  /// late PyramidSeriesController pyramidSeriesController;
  /// SfPyramidChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  /// PointInfo<double> chartPoint1 = seriesController.pixelToPoint(value);
  ///   },
  ///   series:  PyramidSeries<ChartSampleData, String>(
  ///       onRendererCreated: (PyramidSeriesController seriesController) {
  ///         pyramidSeriesController = seriesController;
  ///       }
  ///     ),
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
  /// late PyramidSeriesController pyramidSeriesController;
  /// SfPyramidChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///   },
  ///   series:  PyramidSeries<ChartSampleData, String>(
  ///       onRendererCreated: (PyramidSeriesController seriesController) {
  ///         pyramidSeriesController = seriesController;
  ///       }
  ///     ),
  /// );
  /// ```
  PointInfo<dynamic> pixelToPoint(Offset position) {
    return pyramidFunnelPixelToPoint(position, seriesRenderer);
  }
}

/// Creates series renderer for Pyramid series.
class PyramidSeriesRenderer extends ChartSeriesRenderer {
  /// Calling the default constructor of PyramidSeriesRenderer class.
  PyramidSeriesRenderer();
}
