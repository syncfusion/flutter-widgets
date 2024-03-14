import 'package:flutter/material.dart';
import '../../linear_gauge/gauge/linear_gauge.dart';
import '../../linear_gauge/gauge/linear_gauge_scope.dart';
import '../../linear_gauge/pointers/linear_bar_renderer.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearBarPointer] has properties for customizing the linear gauge bar pointer.
class LinearBarPointer extends SingleChildRenderObjectWidget {
  /// Creates a new instance for [LinearBarPointer].
  const LinearBarPointer(
      {Key? key,
      required this.value,
      this.enableAnimation = true,
      this.animationDuration = 1000,
      this.animationType = LinearAnimationType.ease,
      this.onAnimationCompleted,
      this.thickness = 5.0,
      double offset = 0,
      this.edgeStyle = LinearEdgeStyle.bothFlat,
      this.position = LinearElementPosition.cross,
      this.shaderCallback,
      this.color,
      this.borderColor,
      this.borderWidth = 0,
      Widget? child})
      : offset = offset > 0 ? offset : 0,
        super(key: key, child: child);

  /// Specifies the pointer value of [SfLinearGauge.barPointers].
  /// This value must be between the min and max value of an axis track.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set value for pointer in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 50,
  /// )])
  ///
  /// ```
  ///
  final double value;

  /// Specifies the edge style to a bar pointer.
  ///
  /// Defaults to [LinearEdgeStyle.bothFlat].
  ///
  /// This snippet shows how to set edge style to a bar pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// barPointers: [
  /// LinearBarPointer(
  /// edgeStyle: LinearEdgeStyle.endCurve,
  /// )])
  ///
  /// ```
  ///
  final LinearEdgeStyle edgeStyle;

  /// Called to get the gradient color for the bar pointer.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to use a shaderCallback to get the colors for bar pointer.
  ///
  /// ```dart
  ///
  /// LinearBarPointer(
  ///  shaderCallback: (Rect bounds) {
  ///  return LinearGradient(colors: [
  ///  Color(0xffE8DA5D),
  ///  Color(0xffFB7D55),
  ///  ], stops: <double>[
  ///  0.4,
  ///  0.9
  ///  ]).createShader(bounds);
  ///  )
  /// ```
  ///
  final ShaderCallback? shaderCallback;

  /// Specifies the solid color of bar pointers.
  ///
  /// Defaults to Color(0xff0074E3).
  ///
  /// This snippet shows how to set the color for bar pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  ///  color: Colors.red,
  ///  )])
  /// ```
  ///
  final Color? color;

  /// Specifies the border color for bar pointer.
  ///
  /// Defaults to Color(0xff0074E3).
  ///
  /// This snippet shows how to set border color for bar pointers in
  /// [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  ///  borderColor: Colors.blue,
  ///  )])
  /// ```
  ///
  final Color? borderColor;

  /// Specifies the border width of bar pointer.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set border width for bar pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  ///  borderWidth: 2,
  ///  )])
  /// ```
  ///
  final double borderWidth;

  /// Specifies the thickness of bar pointer.
  ///
  /// Defaults to 5.0.
  ///
  /// This snippet shows how to set thickness of bar pointer.
  ///
  /// ```dart
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 40,
  /// thickness: 80,
  ///  )])
  /// ```
  ///
  final double thickness;

  /// Specifies the offset for bar pointer with respect to axis.
  /// The offset cannot be negative.
  /// The offset value will not be effective when the bar pointer is in cross position.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set margin value for bar pointer.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 40,
  /// offset: 10,
  ///  )])
  /// ```
  ///
  final double offset;

  /// Specifies position of bar pointer with respect to axis.
  ///
  /// Defaults to [LinearElementPosition.cross].
  ///
  /// This snippet shows how to set the bar pointer position in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 40,
  /// position: LinearElementPosition.outside,
  ///  )])
  /// ```
  ///
  final LinearElementPosition position;

  /// Specifies the loading animation for bar pointers with [animationDuration].
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to set load time animation in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 20,
  /// enableAnimation: true,
  ///  )])
  /// ```
  ///
  final bool enableAnimation;

  /// Specifies the load time animation duration with [enableAnimation].
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000.
  ///
  /// This snippet shows how to set animation duration for bar pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 20,
  /// enableAnimation: true,
  /// animationDuration: 4000
  ///  )])
  /// ```
  ///
  final int animationDuration;

  /// Specifies the animation type for bar pointers.
  ///
  /// Defaults to [LinearAnimationType.ease].
  ///
  /// This snippet shows how to set animation type for bar pointers.
  ///
  /// ```dart
  ///
  /// SfLinearGauge (
  /// barPointers: [
  /// LinearBarPointer(
  /// value: 20,
  /// enableAnimation: true,
  /// animationType: LinearAnimationType.bounceOut
  ///  )])
  /// ```
  ///
  final LinearAnimationType animationType;

  /// Called when the bar pointer animation is completed.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to use this [onAnimationCompleted] callback.
  ///
  /// ```dart
  /// SfLinearGauge(
  ///  barPointer:[
  ///  LinearBarPointer(
  ///   onAnimationCompleted: ()=> {
  ///     printf("Bar Pointer animation is completed");
  ///   },
  ///  )]);
  ///  ```
  final VoidCallback? onAnimationCompleted;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final LinearGaugeScope linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData themeData = Theme.of(context);
    final bool isMaterial3 = themeData.useMaterial3;
    final bool isDarkTheme = themeData.brightness == Brightness.dark;
    final Color barPointerColor = isMaterial3
        ? (isDarkTheme ? const Color(0XFFFFF500) : const Color(0XFF06AEE0))
        : themeData.colorScheme.primary;
    return RenderLinearBarPointer(
        value: value,
        edgeStyle: edgeStyle,
        shaderCallback: shaderCallback,
        color: color ?? barPointerColor,
        borderColor: borderColor ?? barPointerColor,
        borderWidth: borderWidth,
        thickness: thickness,
        offset: offset,
        position: position,
        orientation: linearGaugeScope.orientation,
        isAxisInversed: linearGaugeScope.isAxisInversed,
        onAnimationCompleted: onAnimationCompleted,
        animationController: linearGaugeScope.animationController,
        pointerAnimation: linearGaugeScope.animation);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLinearBarPointer renderObject) {
    final LinearGaugeScope linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData themeData = Theme.of(context);
    final bool isMaterial3 = themeData.useMaterial3;
    final bool isDarkTheme = themeData.brightness == Brightness.dark;
    final Color barPointerColor = isMaterial3
        ? (isDarkTheme ? const Color(0XFFFFF500) : const Color(0XFF06AEE0))
        : themeData.colorScheme.primary;
    renderObject
      ..value = value
      ..edgeStyle = edgeStyle
      ..shaderCallback = shaderCallback
      ..color = color ?? barPointerColor
      ..borderColor = borderColor ?? barPointerColor
      ..borderWidth = borderWidth
      ..thickness = thickness
      ..offset = offset
      ..position = position
      ..orientation = linearGaugeScope.orientation
      ..onAnimationCompleted = onAnimationCompleted
      ..pointerAnimation = linearGaugeScope.animation
      ..animationController = linearGaugeScope.animationController
      ..isAxisInversed = linearGaugeScope.isAxisInversed;

    super.updateRenderObject(context, renderObject);
  }
}
