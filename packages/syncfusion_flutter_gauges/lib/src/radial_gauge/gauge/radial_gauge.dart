import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis.dart';
import '../../radial_gauge/gauge/radial_gauge_scope.dart';
import '../../radial_gauge/title/radial_title.dart';
import '../../radial_gauge/utils/enum.dart';

/// Create a radial gauge widget to displays numerical values on a circular scale.
/// It has a rich set of features
/// such as axes, ranges, pointers, and annotations that are fully
/// customizable and extendable.
/// Use it to create speedometers, temperature monitors, dashboards,
/// meter gauges, multi axis clocks, watches, activity gauges, compasses,
/// and more.
///
/// The radial gauge widget allows customizing its appearance
/// using [SfGaugeThemeData] available from the [SfGaugeTheme] widget or
/// the [SfTheme] with the help of [SfThemeData].
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge());
///}
/// ```
/// See also:
///
/// * [SfTheme] and [SfThemeData], for customizing the visual appearance
/// of the radial gauge.
/// * [SfGaugeTheme] and [SfGaugeThemeData], for customizing the visual
/// appearance of the radial gauge.
class SfRadialGauge extends StatefulWidget {
  /// Creates a radial gauge with default or required axis.
  ///
  /// To enable the loading animation set [enableLoadingAnimation] is true.
  // ignore: prefer_const_constructors_in_immutables
  SfRadialGauge(
      {Key? key,
      List<RadialAxis>? axes,
      this.enableLoadingAnimation = false,
      this.animationDuration = 2000,
      this.backgroundColor = Colors.transparent,
      this.title})
      : axes = axes ?? <RadialAxis>[RadialAxis()],
        super(key: key);

  /// Add a list of radial axis to the gauge and customize each axis by
  /// adding it to the [axes] collection.
  ///
  /// Also refer [RadialAxis]
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            )]
  ///        ));
  ///}
  /// ```
  final List<RadialAxis> axes;

  /// Add the title to the top of the radial gauge.
  ///
  /// The [title] is a type of [GaugeTitle].
  ///
  /// To specify title description to [GaugeTitle.text] property and
  /// title style to [GaugeTitle.textStyle] property.
  ///
  /// Defaults to `null`..
  ///
  /// Also refer [GaugeTitle].
  ///
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
  final GaugeTitle? title;

  /// Specifies the load time animation for axis elements, range and
  /// pointers with [animationDuration].
  ///
  /// Defaults to false
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(enableLoadingAnimation: true
  ///        ));
  ///}
  /// ```
  final bool enableLoadingAnimation;

  /// Specifies the load time animation duration.
  ///
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 2000
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(animationDuration: 4000
  ///        ));
  ///}
  /// ```
  final double animationDuration;

  /// The background color of the [SfRadialGauge].
  ///
  /// The [backgroundColor] applied for the [SfRadialGauge] boundary.
  ///
  /// This property is a type of [Color].
  ///
  /// Defaults to Colors.transparent.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///           backgroundColor: Colors.yellow
  ///          axes:<RadialAxis>[RadialAxis(
  ///            )]
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return SfRadialGaugeState();
  }
}

/// Represents the radial gauge state
class SfRadialGaugeState extends State<SfRadialGauge>
    with SingleTickerProviderStateMixin {
  /// Represents the gauge theme
  late SfGaugeThemeData _gaugeTheme;

  @override
  void didChangeDependencies() {
    _gaugeTheme = _updateThemeData(context);
    super.didChangeDependencies();
  }

  SfGaugeThemeData _updateThemeData(BuildContext context) {
    SfGaugeThemeData gaugeThemeData = SfGaugeTheme.of(context)!;
    gaugeThemeData = gaugeThemeData.copyWith(
        titleTextStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: gaugeThemeData.titleColor, fontSize: 15)
            .merge(gaugeThemeData.titleTextStyle)
            .merge(widget.title?.textStyle));
    return gaugeThemeData;
  }

  /// Methods to add the title of circular gauge
  Widget _addGaugeTitle() {
    if (widget.title != null && widget.title!.text.isNotEmpty) {
      final Widget titleWidget = Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          decoration: BoxDecoration(
              color: widget.title!.backgroundColor ??
                  _gaugeTheme.titleBackgroundColor,
              border: Border.all(
                  color:
                      widget.title!.borderColor ?? _gaugeTheme.titleBorderColor,
                  width: widget.title!.borderWidth)),
          alignment: (widget.title!.alignment == GaugeAlignment.near)
              ? Alignment.topLeft
              : (widget.title!.alignment == GaugeAlignment.far)
                  ? Alignment.topRight
                  : (widget.title!.alignment == GaugeAlignment.center)
                      ? Alignment.topCenter
                      : Alignment.topCenter,
          child: Text(
            widget.title!.text,
            style: _gaugeTheme.titleTextStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ));

      return titleWidget;
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> radialAxes = <Widget>[];

    for (int i = 0; i < widget.axes.length; i++) {
      radialAxes.add(RadialGaugeScope(
          enableLoadingAnimation: widget.enableLoadingAnimation,
          animationDuration: widget.animationDuration.toInt(),
          child: widget.axes[i]));
    }

    return RepaintBoundary(
        child: LimitedBox(
            maxHeight: 350,
            maxWidth: 350,
            child: Container(
                color: widget.backgroundColor,
                child: Column(children: <Widget>[
                  _addGaugeTitle(),
                  Expanded(
                      child: Stack(
                          textDirection: TextDirection.ltr,
                          children: radialAxes))
                ]))));
  }

  /// Method to convert the [SfRadialGauge] as an image.
  ///
  /// Returns the `dart:ui.image`
  ///
  ///As this method is in the widget’s state class, you have to use a global
  ///key to access the state to call this method.
  ///
  /// ```dart
  /// final GlobalKey<SfRadialGaugeState> _radialGaugeKey = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [SfRadialGauge(key: _radialGaugeKey),
  ///               RaisedButton(
  ///                child: Text(
  ///                   'To Image',
  ///                 ),
  ///                 onPressed: _renderImage,
  ///                 shape: RoundedRectangleBorder(
  ///                     borderRadius: BorderRadius.circular(20)),
  ///               ),
  ///       ],
  ///     ),
  ///   );
  /// }

  ///  Future<void> _renderImage() async {
  ///   dart_ui.Image data = await
  ///                     _radialGaugeKey.currentState.toImage(pixelRatio: 3.0);
  ///   final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
  ///   if (data != null) {
  ///     await Navigator.of(context).push(
  ///       MaterialPageRoute(
  ///         builder: (BuildContext context) {
  ///           return Scaffold(
  ///             appBar: AppBar(),
  ///             body: Center(
  ///               child: Container(
  ///                 color: Colors.white,
  ///                 child: Image.memory(bytes.buffer.asUint8List()),
  ///               ),
  ///             ),
  ///           );
  ///         },
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  Future<dart_ui.Image> toImage({double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary? boundary =
        context.findRenderObject() as RenderRepaintBoundary?;
    final dart_ui.Image image = await boundary!.toImage(pixelRatio: pixelRatio);
    return image;
  }
}
