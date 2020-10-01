part of charts;

/// Holds the zooming gestures.
///
/// You can zoom in and zoom out using Zoombehavior. It can be used to customize the
///  DoubleTap zooming, selection zooming and zoomPinching.
abstract class ZoomBehavior {
  ///Hits while double tapping on the chart.
  ///* xPos - X value of the pan position.
  ///* yPos - Y value of the pan position.
  void onPan(double xPos, double yPos);

  ///Hits while double tapping on the chart.
  ///* xPos - X value of the double tap position.
  ///* yPos - Y value of the double tap position.
  ///* zoomFactor - zoomin and zoom out position
  void onDoubleTap(double xPos, double yPos, double zoomFactor);

  /// To paint in the chart plot area.
  ///
  /// * canvas - Canvas used to draw the chart.
  void onPaint(Canvas canvas);

  /// Chart can be zoomed by a rectangular selecting region on the plot area.
  ///
  /// * startX - start position of selectionzooming in X axis.
  /// * startY - start position of selectionzooming in Y axis.
  /// * currentX - end position of the selection zooming in X axis.
  /// * currentY - end position of the selection zooming in Y axis.
  void onDrawSelectionZoomRect(
      double currentX, double currentY, double startX, double startY);

  ///Chart can be pinched to zoom in / zoom out for starting position.
  ///
  /// * firstX - first position of pinching in X axis.
  /// * firstY - first position of pinching in Y axis.
  /// * secondX - last position of pinching in X axis.
  /// * secondY - last position of pinching in X axis.
  /// scaleFacator - scale factor is a number which scales some quantity in charts.
  void onPinchStart(ChartAxis axis, double firstX, double firstY,
      double secondX, double secondY, double scaleFactor);

  ///Chart can be pinched to zoom in / zoom out for ending position.
  ///
  /// * firstX - first position of pinching in X axis.
  /// * firstY - first position of pinching in Y axis.
  /// * secondX - last position of pinching in X axis.
  /// * secondY - last position of pinching in X axis.
  /// scaleFacator - scale factor is a number which scales some quantity in charts.
  void onPinchEnd(ChartAxis axis, double firstX, double firstY, double secondX,
      double secondY, double scaleFactor);

  ///Pinching can be performed by moving two fingers over the chart.
  ///
  ///* position - which position have to zoom in the axis.
  /// scaleFacator - scale factor is a number which scales some quantity in charts.
  void onPinch(
      ChartAxisRenderer axisRenderer, double position, double scaleFactor);
}
