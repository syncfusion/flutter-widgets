import 'package:flutter/material.dart';
import '../../circular_chart/renderer/common.dart';
import '../chart_segment/chart_segment.dart';

/// Customizes the selection in chart.
///
///ChartSelectionBehavior is used to customize the behavior of the chart series segments on selection. It is based on the
/// current point coordinate and touch position. It has the methods to customize the selection behavior.
///
abstract class ChartSelectionBehavior {
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onTouchDown(double xPos, double yPos);

  /// Hits while double tapping on the chart..
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onDoubleTap(double xPos, double yPos);

  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onLongPress(double xPos, double yPos);

  /// It gets the fill property of the selected item in the series
  ///
  /// * paint - Paint value of the selected item.
  /// * seriesIndex - Series index of the selected point
  /// * pointIndex - Point index of the selected point in the series.
  /// * selectedSegment -  Value of Selected segment in the series.
  ///
  Paint getSelectedItemFill(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> selectedSegments);

  /// It gets the fill property of the unselected item in the series
  ///
  /// * paint - Paint value of the unselected item.
  /// * seriesIndex - Series index of the unselected point
  /// * pointIndex - Point index of the unselected point in the series.
  /// * unselectedSegment -  Value of unselected segment in the series.
  ///
  Paint getUnselectedItemFill(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> unselectedSegments);

  /// It gets the border property of the selected item in the series
  ///
  /// * paint - Paint value of the selected item.
  /// * seriesIndex - Series index of the selected point
  /// * pointIndex - Point index of the selected point in the series.
  /// * selectedSegment -  Value of Selected segment in the series.
  ///
  Paint getSelectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> selectedSegments);

  /// It gets the border property of the selected item in the series
  ///
  /// * paint - Paint value of the unselected item.
  /// * seriesIndex - Series index of the unselected point
  /// * pointIndex - Point index of the unselected point in the series.
  /// * unselectedSegment -  Value of unSelected segment in the series.
  ///
  Paint getUnselectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> unselectedSegments);

  /// It gets the fill property of the selected item in the series
  ///
  /// * color - Color value of the selected item.
  /// * seriesIndex - Series index of the selected point
  /// * pointIndex - Point index of the selected point in the series.
  /// * selected region -  Value of Selected region in the series.
  ///
  Color getCircularSelectedItemFill(Color color, int seriesIndex,
      int pointIndex, List<Region> selectedRegions);

  /// It gets the circular fill property of the unselected item in the series
  ///
  /// * color - Color value of the unselected item.
  /// * seriesIndex - Series index of the unselected point
  /// * pointIndex - Point index of the unselected point in the series.
  /// * unselectedRegion -  Value of unSelected region in the series.
  ///
  Color getCircularUnSelectedItemFill(Color color, int seriesIndex,
      int pointIndex, List<Region> unselectedRegions);

  /// It gets the circular border property of the seleted item in the series
  ///
  /// * color - Color value of the selected item.
  /// * seriesIndex - Series index of the selected point
  /// * pointIndex - Point index of the selected point in the series.
  /// * selectedRegion -  Value of Selected region of the series.
  ///
  Color getCircularSelectedItemBorder(Color color, int seriesIndex,
      int pointIndex, List<Region> selectedRegions);

  /// It gets the circular border property of the unselected item in the series
  ///
  /// * color - Color value of the unselected item.
  /// * seriesIndex - Series index of the unselected point
  /// * pointIndex - Point index of the unselected point in the series.
  /// * unselectedRegion -  Value of UnSelected region in the series.
  ///
  Color getCircularUnSelectedItemBorder(Color color, int seriesIndex,
      int pointIndex, List<Region> unselectedRegions);
}
