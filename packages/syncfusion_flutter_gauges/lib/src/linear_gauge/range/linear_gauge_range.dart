import 'package:flutter/material.dart';
import '../../linear_gauge/gauge/linear_gauge_scope.dart';

import '../../linear_gauge/range/linear_gauge_range_renderer.dart';
import '../../linear_gauge/utils/enum.dart';

/// [LinearGaugeRange] has properties for customizing linear gauge range.
class LinearGaugeRange extends SingleChildRenderObjectWidget {
  /// Creates a new range in linear gauge.
  ///
  const LinearGaugeRange(
      {Key? key,
      this.startValue = 0,
      double? midValue,
      this.endValue = 100,
      this.startWidth = 5.0,
      this.endWidth = 5.0,
      double? midWidth,
      this.color,
      this.shaderCallback,
      this.rangeShapeType = LinearRangeShapeType.flat,
      this.edgeStyle = LinearEdgeStyle.bothFlat,
      this.position = LinearElementPosition.outside,
      Widget? child})
      : assert(startValue <= endValue),
        midValue = midValue ?? startValue,
        midWidth = midWidth ?? startWidth,
        super(key: key, child: child);

  /// Specifies the start value of the range.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set the startvalue for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  startValue: 65,
  ///  );
  /// ```
  ///
  final double startValue;

  /// Specifies the mid value of the range.
  ///
  /// This snippet shows how to set midvalue for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  midValue: 100,
  ///  );
  /// ```
  ///
  final double midValue;

  /// Specifies the end value of the range.
  /// Defaults to 100.
  ///
  /// This snippet shows how to set endvalue for range in [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  endValue: 150,
  ///  );
  /// ```
  ///
  final double endValue;

  /// Specifies the start width of the range.
  /// Defaults to 5.0.
  ///
  /// This snippet shows how to set startWidth for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  /// startValue: 0.0,
  /// startWidth: 10,
  ///  );
  /// ```
  ///
  final double startWidth;

  /// Specifies the end width of the range.
  ///
  /// Defaults to 5.0.
  ///
  /// This snippet shows how to set endWidth for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  /// endValue: 500.0,
  /// endWidth: 250,
  ///  );
  /// ```
  ///
  final double endWidth;

  /// Specifies the mid width value of the range.
  ///
  ///
  /// This snippet shows how to set midWidth for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  /// midValue: 100.0,
  /// midWidth: 150,
  ///  );
  /// ```
  ///
  final double midWidth;

  /// Specifies the color value of the range.
  ///
  /// Defaults to Color(0xffF45656) in LightTheme
  /// and Color(0xffFF7B7B) in DarkTheme.
  ///
  /// This snippet shows how to set the color for a [LinearGaugeRange].
  ///
  /// ```dart
  ///
  ///  LinearGaugeRange(
  ///  color: Colors.Red,
  ///  );
  /// ```
  ///
  final Color? color;

  /// Specifies the shape type of a range as flat or curve.
  ///
  /// Defaults to [LinearRangeShapeType.flat].
  ///
  /// This snippet shows how to set rangeShapeType for [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  rangeShapeType: LinearRangeShapeType.flat,
  ///  );
  /// ```
  ///
  final LinearRangeShapeType rangeShapeType;

  /// Specifies the edge style of the range.
  ///
  /// Defaults to [LinearEdgeStyle.bothFlat].
  ///
  /// This snippet shows how to set rangeShapeType for a range in [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  edgeStyle: LinearEdgeStyle.StartCurve,
  ///  );
  /// ```
  ///
  final LinearEdgeStyle edgeStyle;

  /// Called to get the gradient color for the range.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to set shaderCallback for a range in [LinearGaugeRange]
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
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

  /// Specifies position of a range with respect to axis.
  ///
  /// Defaults to [LinearElementPosition.outside].
  ///
  /// This snippet shows how to set the range position in [LinearGaugeRange].
  ///
  /// ```dart
  ///
  /// LinearGaugeRange(
  ///  position: LinearElementPosition.inside,
  ///  );
  /// ```
  ///
  final LinearElementPosition position;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final LinearGaugeScope linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    return RenderLinearRange(
        color: color ??
            (isDarkTheme ? const Color(0xffFF7B7B) : const Color(0xffF45656)),
        position: position,
        startValue: startValue,
        midValue: midValue,
        endValue: endValue,
        startThickness: startWidth,
        midThickness: midWidth,
        endThickness: endWidth,
        rangeShapeType: rangeShapeType,
        shaderCallback: shaderCallback,
        edgeStyle: edgeStyle,
        orientation: linearGaugeScope.orientation,
        isMirrored: linearGaugeScope.isMirrored,
        isAxisInversed: linearGaugeScope.isAxisInversed,
        rangeAnimation: linearGaugeScope.animation);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLinearRange renderObject) {
    final LinearGaugeScope linearGaugeScope = LinearGaugeScope.of(context);
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    renderObject
      ..color = color ??
          (isDarkTheme ? const Color(0xffFF7B7B) : const Color(0xffF45656))
      ..position = position
      ..startValue = startValue
      ..midValue = midValue
      ..endValue = endValue
      ..startThickness = startWidth
      ..midThickness = midWidth
      ..endThickness = endWidth
      ..rangeShapeType = rangeShapeType
      ..edgeStyle = edgeStyle
      ..shaderCallback = shaderCallback
      ..orientation = linearGaugeScope.orientation
      ..isMirrored = linearGaugeScope.isMirrored
      ..isAxisInversed = linearGaugeScope.isAxisInversed
      ..rangeAnimation = linearGaugeScope.animation;

    super.updateRenderObject(context, renderObject);
  }
}
