import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      this.onValueChanged,
      this.enableAnimation = true,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.onAnimationCompleted,
      double offset = 0.0,
      this.position = LinearElementPosition.cross,
      this.markerAlignment = LinearMarkerAlignment.center,
      required Widget child})
      : offset = offset > 0 ? offset : 0,
        super(key: key, child: child);

  /// Specifies the pointer value for [WidgetPointer].
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
  /// value: 20
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
  /// value: 20
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
  /// value: 20
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
  /// value: 50
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

  /// Signature for callbacks that report that an underlying value has changed.
  ///
  /// This snippet shows how to call onvaluechange function in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: _pointerValue
  /// onValueChanged: (value) =>
  /// {setState(() =>
  /// {_pointerValue = value})},
  /// )])
  ///
  /// ```
  ///
  @override
  final ValueChanged? onValueChanged;

  /// Specifies the marker alignment.
  ///
  /// Defaults to [MarkerAlignment.center].
  ///
  /// This snippet shows how to set marker alignment in[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearWidgetPointer(
  /// value: 30,
  /// markerAlignment: MarkerAlignment.end
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

  @override
  RenderObject createRenderObject(BuildContext context) {
    final LinearGaugeScope scope = LinearGaugeScope.of(context);
    return RenderLinearWidgetPointer(
        value: value,
        onValueChanged: onValueChanged,
        offset: offset,
        position: position,
        markerAlignment: markerAlignment,
        animationController: scope.animationController,
        onAnimationCompleted: onAnimationCompleted,
        pointerAnimation: scope.animation);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLinearWidgetPointer renderObject) {
    final LinearGaugeScope scope = LinearGaugeScope.of(context);

    renderObject
      ..value = value
      ..onValueChanged = onValueChanged
      ..offset = offset
      ..position = position
      ..markerAlignment = markerAlignment
      ..onAnimationCompleted = onAnimationCompleted
      ..animationController = scope.animationController
      ..pointerAnimation = scope.animation;

    super.updateRenderObject(context, renderObject);
  }
}
