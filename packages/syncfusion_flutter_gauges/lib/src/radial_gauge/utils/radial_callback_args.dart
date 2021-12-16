import '../styles/radial_text_style.dart';

/// Returns the AxisLabelCreatedArgs used by the [
/// RadialAxis.onLabelCreated] event.
class AxisLabelCreatedArgs {
  /// Holds the label text
  late String text;

  /// Specifies the label style
  GaugeTextStyle? labelStyle;

  /// whether to rotate the label based on angle.
  bool? canRotate;
}

/// Returns the ValueChangingArgs used by the
/// [GaugePointer.onValueChanging] event
class ValueChangingArgs {
  /// Specifies the pointer value.
  late double value;

  /// Whether to cancel the new pointer value.
  bool? cancel;
}
