import 'package:flutter/material.dart';

/// Radial gauge scope class.
class RadialAxisScope extends InheritedWidget {
  /// Creates a object for RadialAxisScope.
  const RadialAxisScope({
    Key? key,
    this.animation,
    this.animation1,
    this.animationController,
    this.pointerInterval,
    required this.isRadialGaugeAnimationEnabled,
    required this.repaintNotifier,
    required Widget child,
  }) : super(key: key, child: child);

  /// Child animation.
  final Animation<double>? animation;

  /// Child animation.
  final Animation<double>? animation1;

  /// Animation Controller.
  final AnimationController? animationController;

  /// Pointer Interval.
  final List<double?>? pointerInterval;

  /// Holds the pointer repaint notifier.
  final ValueNotifier<int> repaintNotifier;

  /// Whether the gauge animation enabled or not.
  final bool isRadialGaugeAnimationEnabled;

  /// RadialAxisScope static method.
  static RadialAxisScope of(BuildContext context) {
    late RadialAxisScope scope;

    final Widget widget = context
        .getElementForInheritedWidgetOfExactType<RadialAxisScope>()!
        .widget;

    if (widget is RadialAxisScope) {
      scope = widget;
    }

    return scope;
  }

  @override
  bool updateShouldNotify(RadialAxisScope oldWidget) {
    return pointerInterval != oldWidget.pointerInterval ||
        repaintNotifier != oldWidget.repaintNotifier ||
        animationController != oldWidget.animationController ||
        animation != oldWidget.animation ||
        isRadialGaugeAnimationEnabled !=
            oldWidget.isRadialGaugeAnimationEnabled ||
        animation1 != oldWidget.animation1;
  }
}
