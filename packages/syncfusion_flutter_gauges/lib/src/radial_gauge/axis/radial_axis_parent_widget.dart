import 'dart:math' as math;

import 'package:flutter/gestures.dart'
    show
        DeviceGestureSettings,
        DragStartBehavior,
        GestureArenaTeam,
        HitTestTarget,
        HorizontalDragGestureRecognizer,
        PointerExitEvent,
        PointerHoverEvent,
        TapGestureRecognizer,
        VerticalDragGestureRecognizer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../radial_gauge/annotation/gauge_annotation_renderer.dart';
import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/pointers/marker_pointer_renderer.dart';
import '../../radial_gauge/pointers/needle_pointer_renderer.dart';
import '../../radial_gauge/pointers/range_pointer_renderer.dart';
import '../../radial_gauge/pointers/widget_pointer_renderer.dart';
import '../../radial_gauge/range/gauge_range_renderer.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

/// Default widget height.
/// This value is used when the parent layout size is infinite for the radial gauge.
const double kDefaultRadialGaugeSize = 350.0;

/// Represents the renderer of radial gauge axis.
class RadialAxisParentWidget extends MultiChildRenderObjectWidget {
  /// Creates instance for [RadialGaugeRenderWidget].
  const RadialAxisParentWidget({Key? key, required List<Widget> children})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderRadialAxisParent(
          gestureSettings: MediaQuery.of(context).gestureSettings);

  @override
  void updateRenderObject(
      BuildContext context, RenderRadialAxisParent renderObject) {
    super.updateRenderObject(context, renderObject);
  }

  @override
  MultiChildRenderObjectElement createElement() =>
      RadialAxisParentElement(this);
}

/// Radial gauge render widget element class.
class RadialAxisParentElement extends MultiChildRenderObjectElement {
  /// Creates a instance for [RadialAxisRenderElement].
  RadialAxisParentElement(MultiChildRenderObjectWidget widget) : super(widget);

  @override
  RenderRadialAxisParent get renderObject =>
      super.renderObject as RenderRadialAxisParent;

  @override
  void insertRenderObjectChild(RenderObject child, IndexedSlot<Element?> slot) {
    super.insertRenderObjectChild(child, slot);
    if (child is RenderRadialAxisWidget) {
      renderObject.axis = child;
    } else if (child is RenderWidgetPointer) {
      renderObject.addWidgetPointer(child);
    } else if (child is RenderNeedlePointer) {
      renderObject.addNeedlePointer(child);
    } else if (child is RenderRangePointer) {
      renderObject.addRangePointer(child);
    } else if (child is RenderMarkerPointer) {
      renderObject.addMarkerPointer(child);
    } else if (child is RenderGaugeRange) {
      renderObject.addRange(child);
    } else if (child is RenderGaugeAnnotation) {
      renderObject.addAnnotation(child);
    }
  }

  @override
  void removeRenderObjectChild(RenderObject child, dynamic slot) {
    super.removeRenderObjectChild(child, slot);
    if (child is RenderRadialAxisWidget) {
      renderObject.axis = null;
    } else if (child is RenderWidgetPointer) {
      renderObject.removeWidgetPointer(child);
    } else if (child is RenderNeedlePointer) {
      renderObject.removeNeedlePointer(child);
    } else if (child is RenderRangePointer) {
      renderObject.removeRangePointer(child);
    } else if (child is RenderMarkerPointer) {
      renderObject.removeMarkerPointer(child);
    } else if (child is RenderGaugeRange) {
      renderObject.removeRange(child);
    } else if (child is RenderGaugeAnnotation) {
      renderObject.removeAnnotation(child);
    }
  }
}

/// Radial gauge render object class.
class RenderRadialAxisParent extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>
    implements MouseTrackerAnnotation {
  /// Creates a render object.
  ///
  /// By default, the non-positioned children of the stack are aligned by their
  /// top left corners.
  RenderRadialAxisParent({
    required DeviceGestureSettings gestureSettings,
  }) : _gestureArenaTeam = GestureArenaTeam() {
    _verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
      ..team = _gestureArenaTeam
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..gestureSettings = gestureSettings
      ..dragStartBehavior = DragStartBehavior.start;

    _horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..team = _gestureArenaTeam
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..gestureSettings = gestureSettings
      ..dragStartBehavior = DragStartBehavior.start;

    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUP;

    onHover = _handlePointerHover;
    onExit = _handlePointerExit;
    onPointerUp = _handlePointerUp;
    onPointerCancel = _handlePointerCancel;
  }

  final GestureArenaTeam _gestureArenaTeam;

  late bool _validForMouseTracker;

  late TapGestureRecognizer _tapGestureRecognizer;
  late VerticalDragGestureRecognizer _verticalDragGestureRecognizer;
  late HorizontalDragGestureRecognizer _horizontalDragGestureRecognizer;

  final List<RenderWidgetPointer> _widgetPointers = <RenderWidgetPointer>[];
  final List<RenderNeedlePointer> _needlePointers = <RenderNeedlePointer>[];
  final List<RenderRangePointer> _rangePointers = <RenderRangePointer>[];
  final List<RenderMarkerPointer> _markerPointers = <RenderMarkerPointer>[];
  final List<RenderGaugeRange> _ranges = <RenderGaugeRange>[];
  final List<RenderGaugeAnnotation> _annotations = <RenderGaugeAnnotation>[];

  List<dynamic> _axisElements = <RenderBox>[];

  bool _restrictHitTestPointerChange = false;
  dynamic _pointerRenderObject;

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? onEnter;

  /// Mouse onHover callback.
  PointerHoverEventListener? onHover;

  @override
  PointerExitEventListener? onExit;

  /// Called when a pointer that triggered an [onPointerDown] is no longer in
  /// contact with the screen.
  PointerUpEventListener? onPointerUp;

  /// Called when the input from a pointer that triggered an [onPointerDown] is
  /// no longer directed towards this receiver.
  PointerCancelEventListener? onPointerCancel;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  /// Gets the axis assigned to [RenderRadialAxis].
  RenderRadialAxisWidget? get axis => _axis;
  RenderRadialAxisWidget? _axis;

  /// Sets the axis for [RenderRadialAxis].
  set axis(RenderRadialAxisWidget? value) {
    if (value == _axis) {
      return;
    }

    _axis = value;
    markNeedsLayout();
  }

  /// Adds the widget render object to widget pointer collection.
  void addWidgetPointer(RenderWidgetPointer widgetPointer) {
    _widgetPointers.add(widgetPointer);
    markNeedsLayout();
  }

  /// Removes the widget render object from widget pointer collection.
  void removeWidgetPointer(RenderWidgetPointer widgetPointer) {
    _widgetPointers.remove(widgetPointer);
    markNeedsLayout();
  }

  /// Adds the needle render object to needle pointer collection.
  void addNeedlePointer(RenderNeedlePointer needlePointers) {
    _needlePointers.add(needlePointers);
    markNeedsLayout();
  }

  /// Removes the needle render object from needle pointer collection.
  void removeNeedlePointer(RenderNeedlePointer needlePointers) {
    _needlePointers.remove(needlePointers);
    markNeedsLayout();
  }

  /// Adds the range render object to range pointer collection.
  void addRangePointer(RenderRangePointer rangePointer) {
    _rangePointers.add(rangePointer);
    markNeedsLayout();
  }

  /// Removes the range render object from range pointer collection.
  void removeRangePointer(RenderRangePointer rangePointer) {
    _rangePointers.remove(rangePointer);
    markNeedsLayout();
  }

  /// Adds the marker render object to marker pointer collection.
  void addMarkerPointer(RenderMarkerPointer markerPointer) {
    _markerPointers.add(markerPointer);
    markNeedsLayout();
  }

  /// Removes the marker render object from marker pointer collection.
  void removeMarkerPointer(RenderMarkerPointer markerPointer) {
    _markerPointers.remove(markerPointer);
    markNeedsLayout();
  }

  /// Adds the range render object to range collection.
  void addRange(RenderGaugeRange range) {
    _ranges.add(range);
    markNeedsLayout();
  }

  /// Removes the range render object from range collection.
  void removeRange(RenderGaugeRange range) {
    _ranges.remove(range);
    markNeedsLayout();
  }

  /// Adds the annotation render object to annotation collection.
  void addAnnotation(RenderGaugeAnnotation annotation) {
    _annotations.add(annotation);
    markNeedsLayout();
  }

  /// Removes the annotation render object from annotation collection.
  void removeAnnotation(RenderGaugeAnnotation annotation) {
    _annotations.remove(annotation);
    markNeedsLayout();
  }

  void _updateElements() {
    // ignore: always_specify_types
    _axisElements = [
      _ranges,
      _annotations,
      _markerPointers,
      _widgetPointers,
      _rangePointers,
      _needlePointers
    ].expand((List<RenderBox> x) => x).toList();

    for (int i = 0; i < _axisElements.length; i++) {
      _axisElements[i].axisRenderer = axis;
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }

  @override
  void performLayout() {
    final double actualHeight = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : kDefaultRadialGaugeSize;
    final double actualWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : kDefaultRadialGaugeSize;

    if (axis != null) {
      axis!.layout(
          BoxConstraints(maxHeight: actualHeight, maxWidth: actualWidth),
          parentUsesSize: true);
      _updateElements();
    }

    if (_axisElements.isNotEmpty) {
      for (int i = 0; i < _axisElements.length; i++) {
        _axisElements[i].layout(
            BoxConstraints(maxHeight: actualHeight, maxWidth: actualWidth),
            parentUsesSize: true);
      }
    }

    size = Size(actualWidth, actualHeight);

    RenderBox? childRenderBox = firstChild;
    while (childRenderBox != null) {
      final MultiChildLayoutParentData childParentData =
          childRenderBox.parentData! as MultiChildLayoutParentData;
      childParentData.offset = Offset.zero;
      childRenderBox = childParentData.nextSibling;
    }
  }

  /// Handles the drag update callback.
  void _handleDragUpdate(DragUpdateDetails details) {
    _updatePointerValue(details);
  }

  /// Handles the drag start callback.
  void _handleDragStart(DragStartDetails details) {
    _checkPointerDragging(details);
  }

  /// Handles the drag end callback.
  void _handleDragEnd(DragEndDetails details) {
    _checkPointerIsDragged();
  }

  /// Handles the tap up callback.
  void _handleTapUP(TapUpDetails details) {
    _checkIsAxisTapped(details);
  }

  /// Handles the pointer hover callback.
  void _handlePointerHover(PointerHoverEvent event) {
    if (_pointerRenderObject != null &&
        _pointerRenderObject.enableDragging as bool) {
      _enableOverlayForMarkerPointer(event);
    }
  }

  /// Handles the pointer exit callback.
  void _handlePointerExit(PointerExitEvent event) {
    if (!_restrictHitTestPointerChange) {
      _checkPointerIsDragged();
    }
  }

  /// Handles the pointer up callback.
  void _handlePointerUp(PointerUpEvent event) {
    _restrictHitTestPointerChange = false;
    _checkPointerIsDragged();
  }

  /// Handles the pointer cancel callback.
  void _handlePointerCancel(PointerCancelEvent event) {
    _restrictHitTestPointerChange = false;
    _checkPointerIsDragged();
  }

  /// Method to check whether the axis is tapped
  void _checkIsAxisTapped(TapUpDetails details) {
    final Offset offset = globalToLocal(details.globalPosition);
    if (axis!.onAxisTapped != null &&
        axis!.axisPath.getBounds().contains(offset)) {
      axis!.calculateAngleFromOffset(offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final bool isHit = super.defaultHitTestChildren(result, position: position);

    if (result.path.isNotEmpty) {
      final HitTestTarget child = result.path.last.target;
      if (isHit &&
          !_restrictHitTestPointerChange &&
          (child is RenderMarkerPointer ||
              child is RenderNeedlePointer ||
              child is RenderRangePointer ||
              child is RenderWidgetPointer)) {
        _pointerRenderObject = child;
      } else if (_restrictHitTestPointerChange) {
        return true;
      }
    }

    return isHit;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerHoverEvent) {
      return onHover?.call(event);
    }

    if (event is PointerDownEvent) {
      _restrictHitTestPointerChange = true;
      _tapGestureRecognizer.addPointer(event);
      _horizontalDragGestureRecognizer.addPointer(event);
      _verticalDragGestureRecognizer.addPointer(event);
    }

    if (event is PointerCancelEvent) {
      return onPointerCancel?.call(event);
    }

    if (event is PointerExitEvent) {
      return onExit?.call(event);
    }

    if (event is PointerUpEvent) {
      return onPointerUp?.call(event);
    }

    super.handleEvent(event, entry);
  }

  /// Method to update the pointer value
  void _updatePointerValue(DragUpdateDetails details) {
    final Offset tapPosition = globalToLocal(details.globalPosition);
    final dynamic pointer = _pointerRenderObject;
    if (pointer != null &&
        pointer.enableDragging as bool &&
        pointer.isDragStarted != null &&
        pointer.isDragStarted! as bool) {
      _updateDragValue(tapPosition.dx, tapPosition.dy, pointer);
    }
  }

  /// Method to check whether the axis pointer is dragging
  void _checkPointerDragging(DragStartDetails details) {
    final dynamic pointer = _pointerRenderObject;
    if (pointer != null) {
      if (pointer.enableDragging as bool) {
        pointer.isHovered = false;
        pointer.isDragStarted = true;
        pointer.isHovered = true;
        createPointerValueChangeStartArgs(pointer.value);
      } else {
        pointer.isDragStarted = false;
        pointer.isHovered = false;
      }
    }
  }

  /// Method to ensure whether the pointer was dragged
  void _checkPointerIsDragged() {
    final dynamic pointer = _pointerRenderObject;
    if (pointer != null && pointer.enableDragging as bool) {
      if (pointer.isDragStarted != null && pointer.isDragStarted! as bool) {
        createPointerValueChangeEndArgs(pointer.value);
      }

      pointer.isDragStarted = false;
      pointer.isHovered = false;
    }

    _pointerRenderObject = null;
  }

  /// Method to update the drag value.
  void _updateDragValue(double x, double y, dynamic pointer) {
    final double actualCenterX = axis!.canScaleToFit
        ? axis!.getAxisCenter().dx
        : size.width * axis!.centerX;
    final double actualCenterY = axis!.canScaleToFit
        ? axis!.getAxisCenter().dy
        : size.height * axis!.centerY;
    double angle =
        math.atan2(y - actualCenterY, x - actualCenterX) * (180 / math.pi) +
            360;
    final double endAngle = axis!.startAngle + axis!.getAxisSweepAngle();

    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > endAngle) {
      angle %= 360;
    }

    if (angle >= axis!.startAngle && angle <= endAngle) {
      double dragValue = 0;

      /// The current pointer value is calculated from the angle
      if (!axis!.isInversed) {
        dragValue = axis!.minimum +
            (angle - axis!.startAngle) *
                ((axis!.maximum - axis!.minimum) / axis!.getAxisSweepAngle());
      } else {
        dragValue = axis!.maximum -
            (angle - axis!.startAngle) *
                ((axis!.maximum - axis!.minimum) / axis!.getAxisSweepAngle());
      }

      if (this is RenderRangePointer) {
        final num calculatedInterval = axis!.calculateAxisInterval(3);
        // Restricts the dragging of range pointer from the minimum value
        // of axis
        if (dragValue < axis!.minimum + calculatedInterval / 2) {
          return;
        }
      }

      _setCurrentPointerValue(dragValue, pointer);
    }
  }

  /// Method to set the current pointer value
  void _setCurrentPointerValue(double dragValue, dynamic pointer) {
    final double actualValue = dragValue.clamp(axis!.minimum, axis!.maximum);
    if (pointer.onValueChanging != null) {
      final ValueChangingArgs args = ValueChangingArgs()..value = actualValue;
      pointer.onValueChanging!(args);
      if (args.cancel != null && args.cancel!) {
        return;
      }
    }

    if (pointer.isHovered != null && !(pointer.isHovered as bool)) {
      pointer.isHovered = true;
    }

    createPointerValueChangedArgs(actualValue);
  }

  /// Checks whether the mouse pointer is hovered on marker in web.
  void _enableOverlayForMarkerPointer(PointerHoverEvent event) {
    final Offset hoverPosition = globalToLocal(event.position);
    final dynamic pointer = _pointerRenderObject;
    if (pointer != null &&
        pointer is RenderMarkerPointer &&
        pointer.pointerRect != null) {
      pointer.isHovered = false;
      if (pointer.pointerRect!.contains(hoverPosition) &&
          _markerPointers.isNotEmpty &&
          !_markerPointers.any((RenderMarkerPointer element) =>
              element.isHovered != null && element.isHovered!)) {
        pointer.isHovered = true;
      }

      for (final RenderMarkerPointer markerPointerRenderer in _markerPointers) {
        if (markerPointerRenderer != pointer) {
          markerPointerRenderer.isHovered = false;
        }
      }
    }
  }

  /// Method to fire the on value change end event
  void createPointerValueChangeEndArgs(double currentValue) {
    if (_pointerRenderObject != null &&
        _pointerRenderObject.onValueChangeEnd != null) {
      _pointerRenderObject.onValueChangeEnd!(currentValue);
    }
  }

  /// Method to fire the on value changed event
  void createPointerValueChangedArgs(double currentValue) {
    if (_pointerRenderObject != null &&
        _pointerRenderObject.onValueChanged != null) {
      _pointerRenderObject.onValueChanged!(currentValue);
    }
  }

  /// Method to fire the on value change start event
  void createPointerValueChangeStartArgs(double currentValue) {
    if (_pointerRenderObject != null &&
        _pointerRenderObject.onValueChangeStart != null) {
      _pointerRenderObject.onValueChangeStart!(currentValue);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
