import 'package:flutter/material.dart';

import '../../linear_gauge/utils/enum.dart';
import 'linear_marker_pointer.dart';

/// Represents the render object of shape pointer.
class RenderLinearWidgetPointer extends RenderLinearPointerBase {
  /// Creates a instance for [RenderLinearWidgetPointer].
  RenderLinearWidgetPointer(
      {required double value,
      ValueChanged<double>? onChanged,
      ValueChanged<double>? onChangeStart,
      ValueChanged<double>? onChangeEnd,
      required double offset,
      required LinearElementPosition position,
      required LinearMarkerAlignment markerAlignment,
      required bool isAxisInversed,
      required bool isMirrored,
      Animation<double>? pointerAnimation,
      VoidCallback? onAnimationCompleted,
      required LinearMarkerDragBehavior dragBehavior,
      AnimationController? animationController})
      : super(
          value: value,
          onChanged: onChanged,
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
          offset: offset,
          position: position,
          dragBehavior: dragBehavior,
          markerAlignment: markerAlignment,
          isAxisInversed: isAxisInversed,
          isMirrored: isMirrored,
          pointerAnimation: pointerAnimation,
          animationController: animationController,
          onAnimationCompleted: onAnimationCompleted,
        );

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (pointerAnimation == null ||
        (pointerAnimation != null && pointerAnimation!.value > 0)) {
      super.paint(context, offset);
    }
  }
}
