import '../../radial_gauge/axis/radial_axis.dart';
import '../../radial_gauge/axis/radial_axis_label.dart';

/// Represents the renderer for gauge axis
abstract class GaugeAxisRenderer {
  /// Represents the gauge axis
  late RadialAxis axis;

  /// Returns the visible labels on [RadialAxis]
  ///
  /// Modify the actual labels generated, which are calculated on the basis
  /// of scale range and interval.
  /// Generate your own labels based on needs, in order to be shown in
  /// the gauge.
  List<CircularAxisLabel>? generateVisibleLabels();

  /// Returns converted factor value from the axis value.
  ///
  /// The arguments to this method is axis value.
  /// The calculated value of the factor should be between 0 and 1.
  /// If the axis range from 0 to 100 and pass the axis value is 50,
  /// this method return factor value is 0.5.
  /// Overriding method, you can modify the factor value based on needs.
  double? valueToFactor(double value);

  /// Returns converted axis value from the factor.
  ///
  /// The arguments to this method is factor which value between 0 to 1.
  /// If the axis range from 0 to 100 and pass the factor value is 0.5,
  /// this method return axis value is 50.
  /// Overriding method, you can modify the axis value based on needs.
  double? factorToValue(double factor);
}

/// Represents the renderer for radial axis
class RadialAxisRenderer extends GaugeAxisRenderer {
  /// Creates the instance for radial axis renderer
  RadialAxisRenderer() : super();

  @override
  List<CircularAxisLabel>? generateVisibleLabels() {
    return null;
  }

  @override
  double? valueToFactor(double value) {
    return null;
  }

  @override
  double? factorToValue(double factor) {
    return null;
  }
}
