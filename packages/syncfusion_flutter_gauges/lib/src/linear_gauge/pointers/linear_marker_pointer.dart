import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearMarkerPointer] has properties for customizing linear gauge pointers.
abstract class LinearMarkerPointer {
  /// Creates a pointer for linear axis with the default or required properties.
  LinearMarkerPointer(
      {required this.value,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.enableAnimation = false,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.offset = 0.0,
      this.markerAlignment = LinearMarkerAlignment.center,
      this.position = LinearElementPosition.cross,
      this.dragBehavior = LinearMarkerDragBehavior.free,
      this.onAnimationCompleted});

  /// Specifies the linear axis value to place the pointer.
  ///
  /// Defaults to 0.
  final double value;

  /// Specifies whether to enable animation or not, when the pointer moves.
  ///
  /// Defaults to false.
  final bool enableAnimation;

  /// Specifies the animation duration for the pointer.
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000.
  final int animationDuration;

  /// Specifies the type of the animation for the pointer.
  ///
  /// Defaults to [LinearAnimationType.ease].
  final LinearAnimationType animationType;

  /// Specifies the offset value which represent the gap from the linear axis.
  /// Origin of this property will be relates to [LinearMarkerPointer.position].
  ///
  /// Defaults to 0.
  final double offset;

  /// Specifies the annotation position with respect to linear axis.
  ///
  final LinearElementPosition position;

  /// Signature for a callback that report that a value was changed for a marker pointer.
  final ValueChanged<double>? onChanged;

  /// Signature for a callback that reports the value of a marker pointer has started to change.
  final ValueChanged<double>? onChangeStart;

  /// Signature for a callback that reports the value changes are ended for a marker pointer.
  final ValueChanged<double>? onChangeEnd;

  /// Specifies the marker alignment.
  ///
  /// Defaults to center.
  final LinearMarkerAlignment markerAlignment;

  /// Specifies the animation completed callback.
  ///
  final VoidCallback? onAnimationCompleted;

  /// Specifies the drag behavior for the pointer.
  ///
  /// Defaults to [LinearMarkerDragBehavior.free].
  ///
  /// ```dart
  /// double _startMarkerValue = 30.0;
  /// double _endMarkerValue = 60.0;
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///     home: Scaffold(
  ///       appBar: AppBar(
  ///         title: const Text('Drag behavior'),
  ///       ),
  ///       body: SfLinearGauge(
  ///         markerPointers: [
  ///           LinearShapePointer(
  ///             value: _startMarkerValue,
  ///             dragBehavior: LinearMarkerDragBehavior.constrained,
  ///             onChanged: (double value) {
  ///               setState(() {
  ///                 _startMarkerValue = value;
  ///               });
  ///             },
  ///           ),
  ///           LinearShapePointer(
  ///             value: _endMarkerValue,
  ///             onChanged: (double value) {
  ///               setState(() {
  ///                 _endMarkerValue = value;
  ///               });
  ///             },
  ///           )
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final LinearMarkerDragBehavior dragBehavior;
}

/// Represents the render object base class for shape and widget pointer.
class RenderLinearPointerBase extends RenderProxyBox {
  /// Creates a instance for [RenderLinearPointerBase]
  RenderLinearPointerBase(
      {required double value,
      ValueChanged<double>? onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      required double offset,
      required LinearElementPosition position,
      required LinearMarkerAlignment markerAlignment,
      required bool isAxisInversed,
      required bool isMirrored,
      Animation<double>? pointerAnimation,
      VoidCallback? onAnimationCompleted,
      required LinearMarkerDragBehavior dragBehavior,
      this.animationController})
      : _value = value,
        _onChanged = onChanged,
        _offset = offset,
        _position = position,
        _dragBehavior = dragBehavior,
        _markerAlignment = markerAlignment,
        _pointerAnimation = pointerAnimation,
        _isAxisInversed = isAxisInversed,
        _isMirrored = isMirrored,
        _onAnimationCompleted = onAnimationCompleted;

  /// Gets or sets the shape pointer old value.
  double? oldValue;

  /// Gets or sets the animation controller assigned to [RenderLinearPointerBase].
  AnimationController? animationController;

  /// Sets the pointers constrained value.
  ConstrainedBy constrainedBy = ConstrainedBy.none;

  /// Gets or sets the onChangeStart assigned to [RenderLinearPointerBase].
  ValueChanged<double>? onChangeStart;

  /// Gets or sets the onChangeEnd assigned to [RenderLinearPointerBase].
  ValueChanged<double>? onChangeEnd;

  /// Sets the minimum value to the pointer for dragging.
  double? dragRangeMin;

  /// Sets the maximum value to the pointer for dragging.
  double? dragRangeMax;

  /// Gets and sets the value assigned to [RenderLinearPointerBase].
  double get value => _value;
  double _value;
  set value(double value) {
    if (value == _value) {
      return;
    }
    if (animationController != null && animationController!.isAnimating) {
      oldValue = _value;
      animationController!.stop();
    }
    _value = value;
    if (animationController != null && oldValue != value) {
      animationController!.forward(from: 0.01);
    }
    markNeedsLayout();
  }

  /// Gets and sets the onChanged assigned to [RenderLinearPointerBase].
  ValueChanged<double>? get onChanged => _onChanged;
  ValueChanged<double>? _onChanged;
  set onChanged(ValueChanged<double>? value) {
    if (value == _onChanged) {
      return;
    }
    _onChanged = value;
  }

  /// Gets and sets the offset assigned to [RenderLinearPointerBase].
  double get offset => _offset;
  double _offset;
  set offset(double value) {
    if (value == _offset) {
      return;
    }
    _offset = value;
    markNeedsLayout();
  }

  /// Gets and sets the position assigned to [RenderLinearPointerBase].
  LinearElementPosition get position => _position;
  LinearElementPosition _position;
  set position(LinearElementPosition value) {
    if (value == _position) {
      return;
    }
    _position = value;
    markNeedsLayout();
  }

  /// Gets and sets the animation assigned to [RenderLinearPointerBase].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }
    _removeAnimationListener();
    _pointerAnimation = value;
    _addAnimationListener();
  }

  void _addAnimationListener() {
    if (pointerAnimation == null) {
      return;
    }
    pointerAnimation!.addListener(markNeedsPaint);
    pointerAnimation!.addStatusListener(_animationStatusListener);
  }

  /// Gets and sets the Marker Alignment assigned to [RenderLinearPointerBase].
  LinearMarkerAlignment? get markerAlignment => _markerAlignment;
  LinearMarkerAlignment? _markerAlignment;
  set markerAlignment(LinearMarkerAlignment? value) {
    if (value == _markerAlignment) {
      return;
    }
    _markerAlignment = value;
    markNeedsLayout();
  }

  /// Gets and sets the isAxisInversed assigned to [RenderLinearPointerBase].
  bool get isAxisInversed => _isAxisInversed;
  bool _isAxisInversed;
  set isAxisInversed(bool value) {
    if (value == _isAxisInversed) {
      return;
    }

    _isAxisInversed = value;
    markNeedsLayout();
  }

  /// Gets and sets the isMirrored to [RenderLinearPointerBase].
  bool get isMirrored => _isMirrored;
  bool _isMirrored;
  set isMirrored(bool value) {
    if (value == _isMirrored) {
      return;
    }

    _isMirrored = value;
    markNeedsPaint();
  }

  void _removeAnimationListener() {
    if (pointerAnimation == null) {
      return;
    }
    pointerAnimation!.removeListener(markNeedsPaint);
    pointerAnimation!.removeStatusListener(_animationStatusListener);
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (onAnimationCompleted != null) {
        onAnimationCompleted!();
      }
      if (oldValue != value) {
        oldValue = value;
      }
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addAnimationListener();
  }

  @override
  void detach() {
    _removeAnimationListener();
    super.detach();
  }

  /// Gets and sets the drag behavior assigned to [RenderLinearPointerBase].
  LinearMarkerDragBehavior get dragBehavior => _dragBehavior;
  LinearMarkerDragBehavior _dragBehavior;
  set dragBehavior(LinearMarkerDragBehavior value) {
    if (value == _dragBehavior) {
      return;
    }
    _dragBehavior = value;
  }

  /// Gets and sets the animation completed callback.
  VoidCallback? get onAnimationCompleted => _onAnimationCompleted;
  VoidCallback? _onAnimationCompleted;
  set onAnimationCompleted(VoidCallback? value) {
    if (value == _onAnimationCompleted) {
      return;
    }
    _onAnimationCompleted = value;
  }
}
