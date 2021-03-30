import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../linear_gauge/gauge/linear_gauge_scope.dart';
import '../../linear_gauge/pointers/linear_marker_pointer.dart';
import '../../linear_gauge/pointers/linear_shape_renderer.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearShapePointer] has properties for customizing the shape marker pointer.
class LinearShapePointer extends LeafRenderObjectWidget
    implements LinearMarkerPointer {
  /// Creates a shape marker pointer for linear axis.
  LinearShapePointer(
      {Key? key,
      required this.value,
      this.onValueChanged,
      this.enableAnimation = true,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.onAnimationCompleted,
      this.width,
      this.height,
      double offset = 0.0,
      this.markerAlignment = LinearMarkerAlignment.center,
      this.position = LinearElementPosition.outside,
      this.shapeType = LinearShapePointerType.invertedTriangle,
      this.color,
      this.borderColor,
      this.borderWidth = 0.0,
      this.elevation = 0,
      this.elevationColor = Colors.black})
      : offset = offset > 0 ? offset : 0,
        super(key: key);

  /// Specifies the pointer value of [ShapePointer].
  /// This value must be between the min and max value of an axis track.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set a value for a shape marker pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50,
  /// )])
  ///
  /// ```
  ///
  @override
  final double value;

  /// Specifies the loading animation for shape pointers with [animationDuration].
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to set load time animation for shape marker pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
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
  /// This snippet shows how to set loading animation duration of shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 20
  /// enableAnimation: true,
  /// animationDuration: 4000
  ///  )])
  /// ```
  ///
  @override
  final int animationDuration;

  /// Specifies the animation type of shape pointers.
  ///
  /// Defaults to [LinearAnimationType.ease].
  ///
  /// This snippet shows how to set animation type of shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 20
  /// enableAnimation: true,
  /// animationType: LinearAnimationType.linear
  ///  )])
  /// ```
  ///
  @override
  final LinearAnimationType animationType;

  /// Specifies the width of shape pointers.
  ///
  /// Defaults to 16.0.
  ///
  /// This snippet shows how to set a width for the shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// width: 30
  ///  )])
  /// ```
  ///
  final double? width;

  /// Specifies the offset for shape pointer with respect to axis.
  /// The offset cannot be negative.
  /// The offset value will not be effective when the shape pointer is in cross position.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set margin value for shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// margin: 10
  ///  )])
  /// ```
  ///
  @override
  final double offset;

  /// Specifies the height of the shape pointer.
  ///
  /// Defaults to 16.0.
  ///
  /// This snippet shows how to set a height for the shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// height: 30
  ///  )])
  /// ```
  ///
  final double? height;

  /// Specifies the position of shape pointers with respect to axis.
  ///
  /// Defaults to [LinearElementPosition.outside].
  ///
  /// This snippet shows how to set the shape pointer position in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// position: LinearElementPosition.inside
  ///  )])
  /// ```
  ///
  @override
  final LinearElementPosition position;

  /// Signature for callbacks that report that an underlying value has changed.
  ///
  /// This snippet shows how to call onvaluechange function in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// markerPointers: [
  /// LinearShapePointer(
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

  /// Specifies the built-in shape of shape marker pointer.
  ///
  /// Defaults to [LinearShapePointerType.invertedTriangle].
  ///
  /// This snippet shows how to set a shape to shape marker pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// shapeType: LinearShapePointerType.triangle
  ///  )])
  /// ```
  ///
  final LinearShapePointerType shapeType;

  /// Specifies the color for shape marker pointer.
  ///
  /// Defaults to [Colors.black54] in LightTheme
  /// and [Colors.white70] in DarkTheme.
  ///
  /// This snippet shows how to set color for a shape pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// color: Colors.Grey
  ///  )])
  /// ```
  ///
  final Color? color;

  /// Specifies the border color of shape pointer.
  ///
  /// Defaults to [Colors.black54] in LightTheme
  /// and [Colors.white70] in DarkTheme.
  ///
  /// This snippet shows how to set a border color for the shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// borderColor: Colors.Orange
  ///  )])
  /// ```
  ///
  final Color? borderColor;

  /// Specifies border width of shape pointer.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set a border width for the shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// borderWidth: 3
  ///  )])
  /// ```
  ///
  final double borderWidth;

  /// Provides elevation for shape pointers.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set elevation value for a shape marker pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// elevation: 2
  ///  )])
  /// ```
  ///
  final double elevation;

  /// Specifies elevation color for shape pointers with [elevation]
  ///
  /// Defaults to [Colors.Black].
  ///
  /// This snippet shows how to set elevation color for shape pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// elevationColor: Colors.grey[50]
  ///  )])
  /// ```
  ///
  final Color elevationColor;

  /// Specifies the alignment for shape marker pointer.
  ///
  /// Defaults to [MarkerAlignment.center].
  ///
  /// This snippet shows how to set a shape to shape-pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// markerPointers: [
  /// LinearShapePointer(
  /// value: 50
  /// markerAlignment: MarkerAlignment.end
  ///  )])
  /// ```
  ///
  @override
  final LinearMarkerAlignment markerAlignment;

  /// Called when the shape pointer animation is completed.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to use this [onAnimationCompleted] callback.
  ///
  /// ```dart
  /// SfLinearGauge(
  ///  markerPointers:[
  ///  LinearShapePointer(
  ///   onAnimationCompleted: ()=> {
  ///     printf("Shape Pointer animation is completed");
  ///   },
  ///  )]);
  ///  ```
  @override
  final VoidCallback? onAnimationCompleted;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    return RenderLinearShapePointer(
        value: value,
        onValueChanged: onValueChanged,
        color: color ?? (isDarkTheme ? Colors.white70 : Colors.black54),
        borderColor:
            borderColor ?? (isDarkTheme ? Colors.white70 : Colors.black54),
        borderWidth: borderWidth,
        width: width ?? (shapeType == LinearShapePointerType.diamond ? 12 : 16),
        height:
            height ?? (shapeType == LinearShapePointerType.rectangle ? 8 : 16),
        offset: offset,
        position: position,
        shapeType: shapeType,
        elevation: elevation,
        elevationColor: elevationColor,
        orientation: linearGaugeScope.orientation,
        isMirrored: linearGaugeScope.isMirrored,
        markerAlignment: markerAlignment,
        animationController: linearGaugeScope.animationController,
        onAnimationCompleted: onAnimationCompleted,
        pointerAnimation: linearGaugeScope.animation);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLinearShapePointer renderObject) {
    final linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    renderObject
      ..value = value
      ..onValueChanged = onValueChanged
      ..color = color ?? (isDarkTheme ? Colors.white70 : Colors.black54)
      ..borderColor =
          borderColor ?? (isDarkTheme ? Colors.white70 : Colors.black54)
      ..borderWidth = borderWidth
      ..width = width ?? (shapeType == LinearShapePointerType.diamond ? 12 : 16)
      ..height =
          height ?? (shapeType == LinearShapePointerType.rectangle ? 8 : 16)
      ..offset = offset
      ..position = position
      ..shapeType = shapeType
      ..elevation = elevation
      ..elevationColor = elevationColor
      ..orientation = linearGaugeScope.orientation
      ..isMirrored = linearGaugeScope.isMirrored
      ..markerAlignment = markerAlignment
      ..onAnimationCompleted = onAnimationCompleted
      ..animationController = linearGaugeScope.animationController
      ..pointerAnimation = linearGaugeScope.animation;

    super.updateRenderObject(context, renderObject);
  }
}
