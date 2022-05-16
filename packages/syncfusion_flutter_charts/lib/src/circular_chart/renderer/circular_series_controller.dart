import 'dart:ui';
import '../base/circular_state_properties.dart';
import '../utils/helper.dart';
import 'chart_point.dart';
import 'circular_series.dart';
import 'renderer_base.dart';
import 'renderer_extension.dart';

/// We can redraw the series by updating or creating new points by using this controller. If we need to access the redrawing methods
/// in this before we must get the ChartSeriesController onRendererCreated event.
class CircularSeriesController {
  /// Creating an argument constructor of CircularSeriesController class.
  CircularSeriesController(this.seriesRenderer);

  /// Used to access the series properties.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: PieSeries<SalesData, num>(
  ///                    onRendererCreated: (CircularSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer.seriesRendererDetails.series.yAxisName);
  ///                    },
  ///                ),
  ///        )
  ///     );
  ///}
  ///```
  late final CircularSeriesRenderer seriesRenderer;

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
  ///    CircularSeriesController seriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfCircularChart(
  ///            series: <CircularSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated: (CircularSeriesController controller) {
  ///                       seriesController = controller;
  ///                    },
  ///                ),
  ///              ],
  ///        )
  ///   ),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           seriesController.updateDataSource(
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
    _updateCircularSeries();
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
    final CircularSeriesRendererExtension renderer =
        seriesRenderer as CircularSeriesRendererExtension;
    final CircularSeries<dynamic, dynamic> series = renderer.series;
    if (index >= 0 &&
        series.dataSource!.length > index &&
        series.dataSource![index] != null) {
      final ChartPoint<dynamic> currentPoint =
          getCircularPoint(renderer, index);
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

  /// Remove the list of points.
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
    final CircularSeriesRendererExtension renderer =
        seriesRenderer as CircularSeriesRendererExtension;
    if (renderer.dataPoints.isNotEmpty &&
        index >= 0 &&
        index < renderer.dataPoints.length) {
      renderer.dataPoints.removeAt(index);
    }
  }

  /// After add/remove/update data points, recalculate the chart angle and positions.
  void _updateCircularSeries() {
    final CircularSeriesRendererExtension renderer =
        seriesRenderer as CircularSeriesRendererExtension;
    final CircularStateProperties stateProperties = renderer.stateProperties;
    stateProperties.chartSeries.processDataPoints(renderer);
    stateProperties.chartSeries.calculateAngleAndCenterPositions(renderer);
    renderer.repaintNotifier.value++;
    if (renderer.series.dataLabelSettings.isVisible &&
        stateProperties.renderDataLabel != null) {
      stateProperties.renderDataLabel!.state.render();
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
  /// late CircularSeriesController seriesController;
  /// SfCircularChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///     ChartPoint<double> chartPoint1 = seriesController.pixelToPoint(value);
  ///   },
  ///   series: <PieSeries<SalesData, String>>[
  ///     PieSeries<SalesData, String>(
  ///       onRendererCreated: (CircularSeriesController controller) {
  ///         seriesController = controller;
  ///       }
  ///     )
  ///   ]
  /// )
  /// ```

  // ignore: unused_element
  Offset _pointToPixel(ChartPoint<dynamic> point) {
    return circularPointToPixel(point,
        (seriesRenderer as CircularSeriesRendererExtension).stateProperties);
  }

  /// Converts logical pixel value to the data point value.
  ///
  /// The [pixelToPoint] method takes logical pixel value as input and returns a chart data point.
  ///
  ///```dart
  /// late CircularSeriesController seriesController;
  /// SfCircularChart(
  ///    onChartTouchInteractionDown: (ChartTouchInteractionArgs args) {
  ///     ChartPoint<double> chartPoint = seriesController.pixelToPoint(args.position);
  ///     Offset value = seriesController.pointToPixel(chartPoint);
  ///   },
  ///   series: <PieSeries<SalesData, String>>[
  ///     PieSeries<SalesData, String>(
  ///       onRendererCreated: (CircularSeriesController controller) {
  ///         seriesController = controller;
  ///       }
  ///     )
  ///   ]
  /// )
  /// ```

  ChartPoint<dynamic> pixelToPoint(Offset position) {
    final CircularSeriesRendererExtension renderer =
        seriesRenderer as CircularSeriesRendererExtension;
    return circularPixelToPoint(position, renderer.stateProperties);
  }
}
