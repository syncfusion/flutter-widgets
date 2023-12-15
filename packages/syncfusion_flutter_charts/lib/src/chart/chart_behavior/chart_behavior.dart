import 'package:flutter/material.dart';

/// Holds the gestures for chart.
///
/// The class ChartBehavior has the public methods to customize the chart behavior, pass the coordinates to detect
/// the specific point or area in the Rendered chart.
///
abstract class ChartBehavior {
  /// Hits while tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onTouchDown(double xPos, double yPos);

  /// Hits while release tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onTouchUp(double xPos, double yPos);

  /// Hits while double tapping on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onDoubleTap(double xPos, double yPos);

  /// Hits while tap and moving on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onTouchMove(double xPos, double yPos);

  /// Hits while a long tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onLongPress(double xPos, double yPos);

  /// Hits while enter tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onEnter(double xPos, double yPos);

  /// Hits while exit tap on the chart.
  ///
  /// * xPos - X value of the touch position.
  /// * yPos - Y value of the touch position.
  ///
  void onExit(double xPos, double yPos);

  /// Hit while try to render the chart.
  ///
  /// * canvas - Canvas used to draw the chart.
  ///
  void onPaint(Canvas canvas);
}
