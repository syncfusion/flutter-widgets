import 'package:flutter/material.dart';

import '../../linear_gauge/gauge/linear_gauge.dart';
import '../utils/enum.dart';

/// Linear gauge scope class.
class LinearGaugeScope extends InheritedWidget {
  /// Creates a object for Linear gauge scope.
  const LinearGaugeScope(
      {Key? key,
      required Widget child,
      required this.orientation,
      required this.isMirrored,
      required this.isAxisInversed,
      this.animation,
      this.animationController})
      : super(key: key, child: child);

  /// Child animation.
  final Animation<double>? animation;

  /// Animation controller.
  final AnimationController? animationController;

  /// Specifies the orientation of [SfLinearGauge].
  final LinearGaugeOrientation orientation;

  /// Determines whether to mirror the axis elements.
  final bool isMirrored;

  /// Determines whether to invert the axis in [SfLinearGauge].
  final bool isAxisInversed;

  ///LinearGaugeScope method.
  static LinearGaugeScope of(BuildContext context) {
    late LinearGaugeScope scope;

    final InheritedWidget widget = context
        .getElementForInheritedWidgetOfExactType<LinearGaugeScope>()!
        .widget as InheritedWidget;

    if (widget is LinearGaugeScope) {
      scope = widget;
    }

    return scope;
  }

  @override
  bool updateShouldNotify(LinearGaugeScope oldWidget) {
    return orientation != oldWidget.orientation ||
        isMirrored != oldWidget.isMirrored ||
        isAxisInversed != oldWidget.isAxisInversed ||
        animationController != oldWidget.animationController ||
        animation != oldWidget.animation;
  }
}
