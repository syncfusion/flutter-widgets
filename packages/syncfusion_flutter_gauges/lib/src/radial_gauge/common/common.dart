import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import '../utils/enum.dart';

/// Signature for the callback that reports the custom renderer has been extended
/// and set to the gauge axis
typedef GaugeAxisRendererFactory<GaugeAxisRenderer> = GaugeAxisRenderer
    Function();

/// Signature for the callback that reports the custom renderer has been extended
/// and set to the marker pointer
typedef MarkerPointerRendererFactory<MarkerPointerRenderer>
    = MarkerPointerRenderer Function();

/// Signature for the callback that report the custom renderer has been extended
/// and set to the needle pointer
typedef NeedlePointerRendererFactory<NeedlePointerRenderer>
    = NeedlePointerRenderer Function();

/// This class has the property of the guage text style.
///
/// Provides the options of color, font family, font style, font size, and
/// font-weight to customize the appearance.
class GaugeTextStyle {
  /// Creates a gauge text style with default or required properties.
  GaugeTextStyle(
      {this.color,
      this.fontFamily = 'Segoe UI',
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 12});

  /// To set the color of guage text.
  Color? color;

  /// To set the font family to guage text.
  ///
  ///Defaults to `Roboto`.
  String fontFamily;

  /// To set the font style to guage text.
  FontStyle fontStyle;

  /// To set the font weight to guage text.
  ///
  /// Defaults to FontWeight.normal
  FontWeight fontWeight;

  /// To set the font size to guage text
  ///
  /// Defaults to `12`.
  double fontSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeTextStyle &&
        other.color == color &&
        other.fontFamily == fontFamily &&
        other.fontStyle == fontStyle &&
        other.fontWeight == fontWeight &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      color,
      fontFamily,
      fontStyle,
      fontWeight,
      fontSize
    ];
    return hashList(values);
  }
}

/// Title of the gauge.
///
/// Takes a string and displays it as the title of the gauge.
/// By default, the text of the gauge will be horizontally center aligned.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///            title: GaugeTitle(
///                    text: 'Gauge Title',
///                    textStyle: TextStyle(
///                                 color: Colors.red,
///                                 fontSize: 12,
///                                 fontStyle: FontStyle.normal,
///                                 fontWeight: FontWeight.w400,
///                                 fontFamily: 'Roboto'
///                               ))
///        ));
///}
/// ```
class GaugeTitle {
  /// Creates the gauge title with default or required properties.
  GaugeTitle(
      {required this.text,
      this.textStyle = const TextStyle(
          fontSize: 15.0,
          fontFamily: 'Segoe UI',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      this.alignment = GaugeAlignment.center,
      this.borderColor,
      this.borderWidth = 0,
      this.backgroundColor});

  /// Text to be displayed as gauge title.
  ///
  /// If the text of the gauge exceeds, then text will be wrapped into
  /// multiple rows.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title'
  ///                   )
  ///        ));
  ///}
  ///```
  final String text;

  /// The style to use for the gauge title text.
  ///
  /// Using [TextStyle] to add the style to the axis labels.
  ///
  /// Defaults to the [TextStyle] property with font size `12.0`
  /// and font family `Segoe UI`.
  ///
  /// Also refer [TextStyle]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    textStyle: TextStyle(
  ///                                 color: Colors.red,
  ///                                 fontSize: 12,
  ///                                 fontStyle: FontStyle.normal,
  ///                                 fontWeight: FontWeight.w400,
  ///                                 fontFamily: 'Roboto'
  ///                               ))
  ///        ));
  ///}
  ///```
  final TextStyle textStyle;

  /// The color that fills the title of the gauge.
  ///
  /// Changing the background color will cause the gauge title to the new color.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    backgroundColor: Colors.red
  ///                   )
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  /// The color that fills the border with the title of the gauge.
  ///
  /// Defaults to `null`.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    borderColor: Colors.red,
  ///                      borderWidth: 1
  ///                   )
  ///        ));
  ///}
  ///```
  final Color? borderColor;

  /// Specifies the border width of the gauge title.
  ///
  /// Defaults to `0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    borderColor: Colors.red,
  ///                    borderWidth: 1
  ///                   )
  ///        ));
  ///}
  ///```
  final double borderWidth;

  /// How the title text should be aligned horizontally.
  ///
  /// The alignment is applicable when the width of the gauge title is
  /// less than the width of the gauge.
  ///
  /// [GaugeAlignment.near] places the title at the beginning of gauge
  /// whereas the [GaugeAlignment.center] moves the gauge title to the center
  /// of gauge and the [GaugeAlignment.far] places the gauge title at the
  /// end of the gauge.
  ///
  /// Defaults to `GaugeAlignment.center`.
  ///
  /// Also refer [GaugeAlignment]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    alignment: GaugeAlignment.far
  ///                   )
  ///        ));
  ///}
  ///```
  final GaugeAlignment alignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeTitle &&
        other.text == text &&
        other.alignment == alignment &&
        other.textStyle == textStyle &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      text,
      alignment,
      textStyle,
      borderWidth,
      borderColor,
      backgroundColor
    ];
    return hashList(values);
  }
}

/// Create the style of axis major tick.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            majorTickStyle: MajorTickStyle(color: Colors.red,
///            thickness: 3,
///            length: 10),
///            )]
///        ));
///}
/// ```
class MajorTickStyle {
  /// Creates a major tick style with default or required properties.
  ///
  /// The arguments [length], [thickness], must be non-negative.
  MajorTickStyle(
      {this.length = 7,
      this.thickness = 1.5,
      this.lengthUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.dashArray})
      : assert(length >= 0, 'Tick length must be a non-negative value.'),
        assert(thickness >= 0, 'Tick thickness must be a non-negative value.');

  /// Specifies the length of the tick.
  ///
  /// You can specify tick length either in logical pixel or radius factor
  /// using the [lengthUnit] property. if [lengthUnit] is
  /// [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here tick length is calculated by [length] * axis radius value.
  ///
  /// Example: [length] value is 0.2 and axis radius is 100,
  /// tick length is 20(0.2 * 100) logical pixels. if [lengthUnit] is
  /// [GaugeSizeUnit.logicalPixel], defined value is set to the tick length.
  ///
  /// Defaults to `7` and [lengthUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(length: 10),)]
  ///        ));
  ///}
  /// ```
  final double length;

  /// Calculates the tick length size either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], tick length size is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(lengthUnit: GaugeSizeUnit.factor,
  ///              length:0.05),)]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the thickness of tick in logical pixels.
  ///
  /// Defaults to `1.5`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(thickness: 2),)]
  ///        ));
  ///}
  /// ```
  final double thickness;

  /// Specifies the color of tick.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(color: Colors.lightBlue),)]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// Specifies the dash array to draw the dashed line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(dashArray: <double>[2.5, 2.5]),)]
  ///        ));
  ///}
  /// ```
  final List<double>? dashArray;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MajorTickStyle &&
        other.length == length &&
        other.thickness == thickness &&
        other.lengthUnit == lengthUnit &&
        other.color == color &&
        listEquals(other.dashArray, dashArray);
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      length,
      thickness,
      lengthUnit,
      color,
      dashArray
    ];
    return hashList(values);
  }
}

/// Create the style of axis minor tick.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            minorTickStyle: MinorTickStyle(color: Colors.red,
///            thickness: 3,
///            length: 10),
///            )]
///        ));
///}
/// ```
class MinorTickStyle extends MajorTickStyle {
  /// Creates a minor tick style with default or required properties.
  ///
  /// The arguments [length], [thickness], must be non-negative.
  MinorTickStyle(
      {double length = 5,
      GaugeSizeUnit lengthUnit = GaugeSizeUnit.logicalPixel,
      Color? color,
      double thickness = 1.5,
      List<double>? dashArray})
      : assert(length >= 0, 'Tick length must be a non-negative value.'),
        assert(thickness >= 0, 'Tick thickness must be a non-negative value.'),
        super(
          length: length,
          lengthUnit: lengthUnit,
          thickness: thickness,
          dashArray: dashArray,
          color: color,
        );
}

/// Create the style of axis line.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///           axisLineStyle: AxisLineStyle(color: Colors.red,
///           thickness: 20),
///            )]
///        ));
///}
/// ```
class AxisLineStyle {
  /// Creates a minor tick style with default or required properties.
  ///
  /// The arguments [thickness], must be non-negative.
  AxisLineStyle(
      {this.thickness = 10,
      this.thicknessUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.gradient,
      this.cornerStyle = CornerStyle.bothFlat,
      this.dashArray})
      : assert(thickness >= 0,
            'Axis line thickness must be a non-negative value.'),
        assert(
            (gradient != null && gradient is SweepGradient) || gradient == null,
            'The gradient must be null or else '
            'the gradient must be equal to sweep gradient.');

  /// Calculates the axis line thickness either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], axis line thickness is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(thickness: 0.2,
  ///           thicknessUnit: GaugeSizeUnit.factor),)]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit thicknessUnit;

  /// Specifies the thickness of axis line.
  ///
  /// You can specify axis line thickness either in logical pixel or
  /// radius factor using the [thicknessUnit] property.
  /// if [thicknessUnit] is [GaugeSizeUnit.factor],
  /// value must be given from 0 to 1. Here thickness is calculated
  /// by [thickness] * axis radius value.
  ///
  /// Example: [thickness] value is 0.2 and axis radius is 100,
  /// thickness is 20(0.2 * 100) logical pixels.
  /// If [thicknessUnit] is [GaugeSizeUnit.logicalPixel], the defined value
  /// for axis line thickness is set.
  ///
  /// Defaults to `10` and [thicknessUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(thickness: 20),)]
  ///        ));
  ///}
  /// ```
  final double thickness;

  /// Specifies the color of axis line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(color: Colors.grey),)]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// The style to use for the axis line corner edge.
  ///
  /// * [CornerStyle.bothFlat] does not render the rounded corner on both side.
  /// * [CornerStyle.bothCurve] renders the rounded corner on both side.
  /// * [CornerStyle.startCurve] renders the rounded corner on start side.
  /// * [CornerStyle.endCurve] renders the rounded corner on end side.
  ///
  /// Defaults to `CornerStyle.bothFlat`.
  ///
  /// Also refer [CornerStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(cornerStyle: CornerStyle.bothCurve),)]
  ///        ));
  ///}
  /// ```
  final CornerStyle cornerStyle;

  /// Specifies the dash array for axis line to draw the dashed line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(dashArray: <double>[5, 5],)]
  ///        ));
  ///}
  /// ```
  final List<double>? dashArray;

  /// A gradient to use when filling the axis line.
  ///
  /// [gradient] of [AxisLineStyle] only support [SweepGradient] and
  /// specified [SweepGradient.stops] are applied within the axis range value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(dashArray: <double>[5, 5],
  ///           gradient: SweepGradient(
  ///                   colors: const <Color>[Colors.deepPurple,Colors.red,
  ///                     Color(0xFFFFDD00), Color(0xFFFFDD00),
  ///                     Color(0xFF30B32D), ],
  ///                   stops: const <double>[0,0.03, 0.5833333, 0.73, 1],
  ///                 ),)]
  ///        ));
  ///}
  /// ```
  final Gradient? gradient;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AxisLineStyle &&
        other.thickness == thickness &&
        other.thicknessUnit == thicknessUnit &&
        other.color == color &&
        other.gradient == gradient &&
        listEquals(other.dashArray, dashArray) &&
        other.cornerStyle == cornerStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      thickness,
      thicknessUnit,
      color,
      gradient,
      cornerStyle,
      dashArray
    ];
    return hashList(values);
  }
}

/// Returns the AxisLabelCreatedArgs used by the [
/// RadialAxis.onLabelCreated] event.
class AxisLabelCreatedArgs {
  /// Holds the label text
  late String text;

  /// Specifies the label style
  GaugeTextStyle? labelStyle;

  /// whether to rotate the label based on angle.
  bool? canRotate;
}

/// Returns the ValueChangingArgs used by the
/// [GaugePointer.onValueChanging] event
class ValueChangingArgs {
  /// Specifies the pointer value.
  late double value;

  /// Whether to cancel the new pointer value.
  bool? cancel;
}

/// Style for drawing pointer's tail.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 20, tailStyle:
///                 TailStyle(width: 5, lengthFactor: 0.2)
///           )])]
///        ));
///}
/// ```
class TailStyle {
  /// Creates the tail style with default or required properties.
  TailStyle(
      {this.color,
      this.width = 0,
      this.length = 0,
      this.borderWidth = 0,
      this.gradient,
      this.lengthUnit = GaugeSizeUnit.factor,
      this.borderColor})
      : assert(width >= 0, 'Tail width must be a non-negative value.'),
        assert(length >= 0, 'Tail length must be a non-negative value.'),
        assert(
            borderWidth >= 0,
            'Tail border width must be a '
            'non-negative value.');

  /// Specifies the color of the tail.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(color: Colors.lightBlue, width: 10, length: 0.1)
  ///           )])]
  ///        ));
  ///}
  ///```
  final Color? color;

  /// Specifies the width of the tail.
  ///
  /// Defaults to `0`.
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(width: 10, length: 0.1)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double width;

  /// Adjusts the tail length from center.
  ///
  /// You can specify length value either in logical pixel or
  /// radius factor using the [lengthUnit] property.
  /// If [lengthUnit] is [GaugeSizeUnit.factor], value will be given from 0
  /// to 1. Here tail length is calculated by [length] * axis radius value.
  ///
  /// Example: [length] value is 0.5 and axis radius is 100, tail
  /// length is 50(0.5 * 100) logical pixels from axis center.
  /// if [lengthUnit] is [GaugeSizeUnit.logicalPixel], defined value length
  /// from axis center.
  ///
  /// Defaults to `0` and [lengthUnit] is `GaugeSizeUnit.factor`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(width: 10,length: 0.2)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double length;

  /// Calculates the pointer tail length either in logical pixel or
  /// radius factor.
  ///
  /// Using [GaugeSizeUnit], pointer tail length is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.factor`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(length: 30,
  ///                 lengthUnit: GaugeSizeUnit.logicalPixel, width: 10)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the border width of tail.
  ///
  /// Defaults to `0`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                 borderColor: Colors.red)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// Specifies the border color of tail.
  ///
  /// Defaults to `null`.
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                 borderColor: Colors.red)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? borderColor;

  /// A gradient to use when filling the needle tail.
  ///
  /// [gradient] of [TailStyle] only support [LinearGradient].
  /// You can use this to display the depth effect of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                    gradient: LinearGradient(
  ///                  colors: const <Color>[Color.fromRGBO(28, 114, 189, 1),
  ///                  Color.fromRGBO(28, 114, 189, 1),
  ///                    Color.fromRGBO(23, 173, 234, 1),
  ///                    Color.fromRGBO(23, 173, 234, 1)],
  ///                  stops: const <double>[0,0.5,0.5,1],
  ///
  ///             )
  ///                 )
  ///           )])]
  ///        ));
  ///}
  /// ```
  final LinearGradient? gradient;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TailStyle &&
        other.width == width &&
        other.borderWidth == borderWidth &&
        other.length == length &&
        other.gradient == gradient &&
        other.color == color &&
        other.lengthUnit == lengthUnit &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      width,
      color,
      borderWidth,
      length,
      gradient,
      lengthUnit,
      borderColor
    ];
    return hashList(values);
  }
}

/// A style in which draw needle pointer knob.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 30,
///              knobStyle: KnobStyle(knobRadius: 0.1),
///           )])]
///        ));
///}
/// ```
class KnobStyle {
  /// Creates the knob style with default or required properties.
  ///
  /// The arguments [knobRadius], [borderWidth] must be non-negative.
  KnobStyle(
      {this.knobRadius = 0.08,
      this.borderWidth = 0,
      this.sizeUnit = GaugeSizeUnit.factor,
      this.borderColor,
      this.color})
      : assert(knobRadius >= 0, 'Knob radius must be a non-negative value.'),
        assert(
            borderWidth >= 0,
            'Knob border width must be a '
            'non-negative value.');

  /// Adjusts the knob radius in needle pointer.
  ///
  /// You can specify knob radius value either in logical pixel or
  /// radius factor using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here knob radius size is calculated by [knobRadius] * axis radius value.
  ///
  /// Example: [knobRadius] value is 0.2 and axis radius is 100,
  /// knob radius is 20(0.2 * 100) logical pixels.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], defined value is
  /// set to the knob radius.
  ///
  /// Defaults to 0.08 and `sizeUnit` is `GaugeSizeUnit.factor`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(knobStyle: KnobStyle(knobRadius: 0.2),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double knobRadius;

  /// Calculates the knob radius size either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], pointer knob radius size is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.factor`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///                 knobStyle: KnobStyle(knobRadius: 10,
  ///                 sizeUnit: GaugeSizeUnit.logicalPixel),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit sizeUnit;

  /// Specifies the knob border width in logical pixel.
  ///
  /// Defaults to `0`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///                  knobStyle: KnobStyle(borderWidth: 2,
  ///                  borderColor : Colors.red),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// Specifies the knob color.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///              knobStyle: KnobStyle(color: Colors.red),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// Specifies the knob border color.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <Pointer>[
  ///             NeedlePointer(
  ///              knobStyle: KnobStyle(borderColor: Colors.red,
  ///              borderWidth: 2),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? borderColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is KnobStyle &&
        other.knobRadius == knobRadius &&
        other.borderWidth == borderWidth &&
        other.sizeUnit == sizeUnit &&
        other.borderColor == borderColor &&
        other.color == color;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      knobRadius,
      borderWidth,
      sizeUnit,
      borderColor,
      color
    ];
    return hashList(values);
  }
}

/// Details for the drawPointer method, such as the location of the pointer,
/// the angle, and the radius needed to draw the pointer.
@immutable
class PointerPaintingDetails {
  /// Creates the details which are required to paint the pointer
  const PointerPaintingDetails(
      {required this.startOffset,
      required this.endOffset,
      required this.pointerAngle,
      required this.axisRadius,
      required this.axisCenter});

  /// Specifies the starting position of the pointer in the logical pixels.
  final Offset startOffset;

  /// Specifies the ending position of the pointer in the logical pixels.
  final Offset endOffset;

  /// Specifies the angle of the current pointer value.
  final double pointerAngle;

  /// Specifies the axis radius in logical pixels.
  final double axisRadius;

  /// Specifies the center position of the axis in the logical pixels.
  final Offset axisCenter;
}
