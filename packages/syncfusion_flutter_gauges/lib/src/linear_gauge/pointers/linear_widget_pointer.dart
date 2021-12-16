import 'package:flutter/material.dart';

import '../../linear_gauge/gauge/linear_gauge.dart';
import '../../linear_gauge/gauge/linear_gauge_scope.dart';
import '../../linear_gauge/pointers/linear_marker_pointer.dart';
import '../../linear_gauge/pointers/linear_widget_renderer.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearMarkerPointer] has properties for customizing widget marker pointer.
class LinearWidgetPointer extends SingleChildRenderObjectWidget
    implements LinearMarkerPointer {
  /// Creates a widget marker pointer.
  const LinearWidgetPointer(
      {Key? key,
      required this.value,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.enableAnimation = true,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.onAnimationCompleted,
      double offset = 0.0,
      this.position = LinearElementPosition.cross,
      this.markerAlignment = LinearMarkerAlignment.center,
      this.dragBehavior = LinearMarkerDragBehavior.free,
      required Widget child})
      : offset = offset > 0 ? offset : 0,
        super(key: key, child: child);

  /// Specifies the pointer value for [LinearWidgetPointer].
  /// This value must be between the min and max value of an axis track.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set a value for widget marker pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 50,
  /// )])
  ///
  /// ```
  ///
  @override
  final double value;

  /// Specifies the loading animation for widget marker pointers with
  /// [animationDuration].
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to set load time animation for widget marker pointers in ///[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 20,
  /// enableAnimation: true,
  ///  )])
  /// ```
  ///
  @override
  final bool enableAnimation;

  /// Specifies the load time animation duration with [enableAnimation].
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000.
  ///
  /// This snippet shows how to set animation duration for widget marker pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 20,
  /// enableAnimation: true,
  /// animationDuration: 4000
  ///  )])
  /// ```
  ///
  @override
  final int animationDuration;

  /// Specifies the animation type for widget marker pointers.
  ///
  /// Defaults to [LinearAnimationType.ease].
  ///
  /// This snippet shows how to set animation type of widget marker pointers in
  /// [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 20,
  /// enableAnimation: true,
  /// animationType: LinearAnimationType.linear
  ///  )])
  /// ```
  ///
  @override
  final LinearAnimationType animationType;

  /// Specifies the offset for widget pointer with respect to axis.
  /// The offset cannot be negative.
  /// The offset value will not be effective when the widget pointer is in cross position.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set margin value for widget marker pointers
  /// in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 50,
  /// margin: 15
  ///  )])
  /// ```
  ///
  @override
  final double offset;

  /// Specifies the position of widget marker pointers with respect to axis.
  ///
  /// Defaults to [LinearElementPosition.cross].
  ///
  /// This snippet shows how to set the position of widget marker pointers
  /// in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 50,
  /// position: LinearElementPosition.inside
  ///  )])
  /// ```
  ///
  @override
  final LinearElementPosition position;

  /// Signature for a callback that report that a value was changed for a marker pointer.
  ///
  /// This snippet shows how to call onChanged function in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  ///    value: _pointerValue,
  ///    child: Container(
  ///       height: 20,
  ///       width: 20,
  ///       color: Colors.red),
  ///    onChanged: (double value){
  ///      setState((){
  ///         _pointerValue = value;
  ///      })
  ///    }
  /// )])
  ///
  /// ```
  @override
  final ValueChanged<double>? onChanged;

  /// Signature for a callback that reports the value of a marker pointer has started to change.
  ///
  /// This snippet shows how to call onChangeStart function in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  ///    value: _pointerValue,
  ///    child: Container(
  ///       height: 20,
  ///       width: 20,
  ///       color: Colors.red),
  ///    onChangeStart: (double startValue) {
  ///       print('Start value $startValue');
  ///   },
  /// )])
  ///
  /// ```
  @override
  final ValueChanged<double>? onChangeStart;

  /// Signature for a callback that reports the value changes are ended for a marker pointer.
  ///
  /// This snippet shows how to call onChangeEnd function in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  ///    value: _pointerValue,
  ///    child: Container(
  ///       height: 20,
  ///       width: 20,
  ///       color: Colors.red),
  ///    onChangeEnd: (double endValue) {
  ///        print('End value $endValue');
  ///    },
  /// )])
  ///
  /// ```
  @override
  final ValueChanged<double>? onChangeEnd;

  /// Specifies the marker alignment.
  ///
  /// Defaults to [LinearMarkerAlignment.center].
  ///
  /// This snippet shows how to set marker alignment in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 30,
  /// markerAlignment: LinearMarkerAlignment.end
  /// )])
  ///
  /// ```
  ///
  @override
  final LinearMarkerAlignment markerAlignment;

  /// Called when the widget pointer animation is completed.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to use this [onAnimationCompleted] callback.
  ///
  /// ```dart
  /// SfLinearGauge(
  ///  markerPointers:[
  ///  LinearWidgetPointer(
  ///   onAnimationCompleted: ()=> {
  ///     printf("Widget Pointer animation is completed");
  ///   },
  ///  )]);
  ///  ```
  @override
  final VoidCallback? onAnimationCompleted;

  /// Specifies the drag behavior for widget marker pointer.
  ///
  /// Defaults to [LinearMarkerDragBehavior.free].
  ///
  /// This snippet shows how to set drag behavior for widget pointer.
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
  ///           LinearWidgetPointer(
  ///             value: _startMarkerValue,
  ///             dragBehavior: LinearMarkerDragBehavior.constrained,
  ///             onChanged: (double value) {
  ///               setState(() {
  ///                 _startMarkerValue = value;
  ///               });
  ///             },
  ///             child: Container(
  ///               height: 20.0,
  ///               width: 20.0,
  ///               color: Colors.red,
  ///             ),
  ///           ),
  ///           LinearWidgetPointer(
  ///             value: _endMarkerValue,
  ///             onChanged: (double value) {
  ///               setState(() {
  ///                 _endMarkerValue = value;
  ///               });
  ///             },
  ///             child: Container(
  ///               height: 20.0,
  ///               width: 20.0,
  ///               color: Colors.red,
  ///             ),
  ///           )
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final LinearMarkerDragBehavior dragBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final LinearGaugeScope scope = LinearGaugeScope.of(context);
    return RenderLinearWidgetPointer(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        offset: offset,
        position: position,
        markerAlignment: markerAlignment,
        animationController: scope.animationController,
        onAnimationCompleted: onAnimationCompleted,
        pointerAnimation: scope.animation,
        isAxisInversed: scope.isAxisInversed,
        isMirrored: scope.isMirrored,
        dragBehavior: dragBehavior);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLinearWidgetPointer renderObject) {
    final LinearGaugeScope scope = LinearGaugeScope.of(context);

    renderObject
      ..value = value
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..offset = offset
      ..position = position
      ..markerAlignment = markerAlignment
      ..dragBehavior = dragBehavior
      ..onAnimationCompleted = onAnimationCompleted
      ..isAxisInversed = scope.isAxisInversed
      ..isMirrored = scope.isMirrored
      ..animationController = scope.animationController
      ..pointerAnimation = scope.animation;

    super.updateRenderObject(context, renderObject);
  }
}
