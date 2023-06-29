import 'rendering_details.dart';

/// Represents the state properties class.
class StateProperties {
  /// Creates an instance of state properties class.
  StateProperties(
    this.renderingDetails,
    this.chartState,
  );

  /// Holds the value of rendering details.
  final RenderingDetails renderingDetails;

  /// Holds the value of chart state.
  final dynamic chartState;

  /// Specifies the chart instance.
  dynamic get chart => chartState.widget;
}
