import '../../linear_gauge/axis/linear_axis_label.dart';

/// Signature used by [SfLinearGauge] to build a representation of the
/// custom labels.
typedef GenerateLabelsCallback = List<LinearAxisLabel> Function();

/// Signature used by [SfLinearGauge] for value to factor.
typedef ValueToFactorCallback = double Function(double value);

/// Signature used by [SfLinearGauge] for factor to value.
typedef FactorToValueCallback = double Function(double factor);

/// Signature used by [SfLinearGauge] for label formatting.
typedef LabelFormatterCallback = String Function(String value);
