part of charts;

class _ChartContainer extends SingleChildRenderObjectWidget {
  const _ChartContainer({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ChartContainerBox();
  }
}

class _ChartContainerBox extends RenderShiftedBox {
  _ChartContainerBox() : super(null);
  double minHeight = 300;
  double minWidth = 300;

  @override
  void performLayout() {
    double height = constraints.maxHeight;
    double width = constraints.maxWidth;
    if (height == double.infinity) {
      height = minHeight;
    }
    if (width == double.infinity) {
      width = minWidth;
    }
    child!.layout(
        BoxConstraints(
          minHeight: 0.0,
          maxHeight: height,
          minWidth: 0.0,
          maxWidth: width,
        ),
        parentUsesSize:
            false); // True- Parent widget recomputes again respect to every build of child widget, False- Parent widget not rebuild respect to child widget build
    size = Size(width,
        height); // constraints.maxHeight become infinity when widget is placed inside row/column
  }

  @override
  // ignore: unnecessary_overrides
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

/// It has the properties of the chart title.
///
/// ChartTitle  can define and customize the Chart title using title property of SfCartesianChart.
/// The text property of ChartTitle is used to set the text for the title.
///
/// It provides an option of text, text style, alignment border color and width to customize the appearance.
///
class ChartTitle {
  /// Creating an argument constructor of ChartTitle class.
  ChartTitle(
      {this.text = '',
      TextStyle? textStyle,
      this.alignment = ChartAlignment.center,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.backgroundColor})
      : textStyle = _getTextStyle(
            textStyle: textStyle,
            fontSize: 15.0,
            fontFamily: 'Segoe UI',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal);

  ///Text to be displayed as chart title. Any desired text can be set as chart title.
  ///If the width of the chart title exceeds the width of the chart, then the title will
  ///be wrapped to multiple rows.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title'
  ///                   )
  ///        ));
  ///}
  ///```
  final String text;

  ///Customizes the appearance of the chart title text.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title',
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

  ///Aligns the chart title.
  ///
  ///The alignment change is applicable only when the width of the
  ///chart title is less than the width of the chart.
  ///
  ///  * `ChartAlignment.near` places the chart title at the beginning of the chart
  ///
  ///  * `ChartAlignment.far` moves the chart title to end of the chart
  ///
  ///  * `ChartAlignment.center` places the title at the center position of the chart’s width.
  ///
  ///Defaults to `ChartAlignment.center`
  ///
  ///Also refer [ChartAlignment]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title',
  ///                    alignment: ChartAlignment.near
  ///                   )
  ///        ));
  ///}
  ///```
  final ChartAlignment alignment;

  ///Background color of the chart title.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title',
  ///                    backgroundColor: Colors.white,
  ///                   )
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  ///Border color of the chart title.
  ///
  ///Defaults to `Colors.transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title',
  ///                    borderColor: Colors.red,
  ///                   )
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the chart title.
  ///
  ///Defaults to `0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Chart Title',
  ///                    borderWidth: 1
  ///                   )
  ///        ));
  ///}
  ///```
  final double borderWidth;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ChartTitle &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.backgroundColor == backgroundColor;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      text,
      textStyle,
      alignment,
      borderColor,
      borderWidth,
      backgroundColor
    ];
    return hashList(values);
  }
}

/// This class has the property of the chart text style.
///
/// ChartTextStyle is the type of argument in the [ChartTitle] class, it used to set the text style of the chart title.
/// It has the properties to customize the chart title text.
///
/// Provides the options of color, font family, font style, font size, and font-weight to customize the appearance.
///
@Deprecated('Use [TextStyle] instead of [ChartTextStyle] ')
class ChartTextStyle extends TextStyle {
  /// Creating an argument constructor of ChartTextStyle class.
  const ChartTextStyle(
      {this.color,
      this.fontFamily = 'Roboto',
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 12})
      : super(
          color: color,
          fontFamily: fontFamily,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          fontSize: fontSize,
          inherit: true,
        );

  /// To set the color of chart text.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: ChartTextStyle(color: Colors.black),
  ///                  ));
  ///}
  ///```
  @override
  final Color? color;

  /// To set the font family of chart text.
  ///
  /// Defaults to `Roboto`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: ChartTextStyle(fontFamily: 'Roboto'),
  ///                  ));
  ///}
  ///```
  @override
  final String fontFamily;

  /// To set the font style of chart text.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: ChartTextStyle(fontStyle: FontStyle.normal),
  ///                  ));
  ///}
  ///```
  @override
  final FontStyle fontStyle;

  /// To set the font weight of chart text.
  ///
  /// Defaults to `FontStyle.normal`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: ChartTextStyle(fontWeight: FontWeight.normal),
  ///                  ));
  ///}
  ///```
  @override
  final FontWeight fontWeight;

  /// To change the font size of chart text
  ///
  /// Defaults to `12`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               primaryXAxis: CategoryAxis(
  ///                      labelStyle: ChartTextStyle(fontSize: 12),
  ///                  ));
  ///}
  ///```
  @override
  final double fontSize;
}

///Identify the series in chart.
///
///Legend contains list of chart series/data points in chart. It helps to
///identify the corresponding data series in chart. The name property of
///[SfCartesianChart] is used to define the label for the corresponding series
///legend item and for [SfCircularChart] type chart by default values mapped with
///xValueMapper will be displayed.
///
/// Provides options such as  isVisible, borderWidth, alignment, opacity, borderColor,
///padding and so on to customize the appearance of the legend.
///
@immutable
class Legend {
  /// Creating an argument constructor of Legend class.
  Legend(
      {bool? isVisible,
      LegendPosition? position,
      ChartAlignment? alignment,
      this.backgroundColor,
      Color? borderColor,
      double? borderWidth,
      double? opacity,
      this.height,
      this.width,
      double? padding,
      double? iconHeight,
      double? iconWidth,
      bool? toggleSeriesVisibility,
      TextStyle? textStyle,
      bool? isResponsive,
      LegendItemOrientation? orientation,
      LegendTitle? title,
      LegendItemOverflowMode? overflowMode,
      this.legendItemBuilder,
      Color? iconBorderColor,
      double? iconBorderWidth,
      double? itemPadding,
      this.offset,
      this.image})
      : isVisible = isVisible ?? false,
        position = position ?? LegendPosition.auto,
        alignment = alignment ?? ChartAlignment.center,
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0.0,
        iconBorderColor = iconBorderColor ?? Colors.transparent,
        iconBorderWidth = iconBorderWidth ?? 0.0,
        opacity = opacity ?? 1.0,
        padding = padding ?? 10.0,
        textStyle = _getTextStyle(
            textStyle: textStyle,
            fontSize: 13.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Segoe UI'),
        iconHeight = iconHeight ?? 12.0,
        iconWidth = iconWidth ?? 12.0,
        toggleSeriesVisibility = toggleSeriesVisibility ?? true,
        isResponsive = isResponsive ?? false,
        orientation = orientation ?? LegendItemOrientation.auto,
        overflowMode = overflowMode ?? LegendItemOverflowMode.scroll,
        itemPadding = itemPadding ?? 15.0,
        title = title ?? LegendTitle();

  /// Toggles the visibility of the legend.
  ///
  /// Defaults to `false`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true)
  ///        ));
  ///}
  ///```
  final bool? isVisible;

  ///Position of the legend.
  ///
  ///If the chart width is greater than chart height, then the
  ///legend will be placed at the right, else it will be placed
  ///at the bottom of the chart.The available options are auto,
  ///bottom, left, right, and top.
  ///
  ///Defaults to `LegendPosition.auto`
  ///
  ///Also refer [LegendPosition]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               position: LegendPosition.bottom)
  ///        ));
  ///}
  ///```
  final LegendPosition position;

  ///Alignment of the legend.
  ///
  ///Alignment will work if the legend width is greater than
  ///the total legend item's width.
  ///
  ///Defaults to `ChartAlignment.center`
  ///
  ///Also refer [ChartAlignment]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               alignment: ChartAlignment.near)
  ///        ));
  ///}
  ///```
  final ChartAlignment alignment;

  ///Background color of the legend.
  ///
  ///Used to change the background color of legend shape.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               backgroundColor: Colors.transparent)
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  ///Border color of the legend.
  ///
  ///Used to change the stroke color of the legend shape.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               borderColor: Colors.brown)
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the legend.
  ///
  ///Used to change the stroke width of the legend shape.
  ///
  ///Defaults to `0.0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               borderWidth: 3)
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Border color of the icon in the legend items.
  ///
  ///Used to change the stroke color of the legend icon shape.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               iconBorderColor: Colors.yellow)
  ///        ));
  ///}
  ///```
  final Color iconBorderColor;

  ///Border width of the icon in the legend items.
  ///
  ///Used to change the stroke width of the legend icon shape.
  ///
  ///Defaults to `0.0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               iconBorderWidth: 2)
  ///        ));
  ///}
  ///```
  final double iconBorderWidth;

  ///Opacity of the legend.
  ///
  ///Used to control the transparency of the legend icon shape.
  ///The value ranges from 0 to 1.
  ///
  ///Defaults to `1.0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               opacity: 0.5)
  ///        ));
  ///}
  ///```
  final double opacity;

  ///The height of the legend.
  ///
  ///It takes percentage value from the overall chart height.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               height: '30%')
  ///        ));
  ///}
  ///```
  final String? height;

  ///The width of the legend.
  ///
  ///It takes percentage value from the overall chart width.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               width: '30%')
  ///        ));
  ///}
  ///```
  final String? width;

  ///Padding between the legend items.
  ///
  ///Used to add padding between the icon shape and the text.
  ///
  ///Defaults to `5.0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               padding: 4.0)
  ///        ));
  ///}
  ///```
  final double padding;

  ///Height of the icon in legend item.
  ///
  ///Used to change the height of the icon shape.
  ///
  ///Defaults to `12`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               iconWidth: 14)
  ///        ));
  ///}
  ///```
  final double iconHeight;

  ///Width of the icon in legend item.
  ///
  ///Used to change the width of the icon shape.
  ///
  ///Defaults to `12`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               iconWidth: 14)
  ///        ));
  ///}
  ///```
  final double iconWidth;

  ///Toggles the series visibility.
  ///
  ///If it is set to false,
  ///then on tapping the legend item, series visibility will not be toggled.
  ///
  ///Defaults to `true`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               toggleSeriesVisibility: false)
  ///        ));
  ///}
  ///```
  final bool toggleSeriesVisibility;

  ///Customizes the legend item text.
  ///
  ///Used to change the text color, size, font family,
  ///fontStyle, and font weight.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               textStyle: TextStyle(color: Colors.red))
  ///        ));
  ///}
  ///```
  final TextStyle textStyle;

  ///Toggles the visibility of the legend.
  ///
  /// If the width or height of the legend is greater than the plot area bounds.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               isResponsive: true)
  ///        ));
  ///}
  ///```
  final bool isResponsive;

  ///Orientation of the legend.
  ///
  ///The legend items will be placed either in horizontal or
  ///in vertical orientation. By default, it is set to auto, i.e. if the legend position
  ///is top or bottom, orientation is set
  ///to horizontal, else it is set to vertical.
  ///
  ///Defaults to `LegendItemOrientation.auto`
  ///
  ///Also refer [LegendItemOrientation]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               orientation: LegendItemOrientation.vertical)
  ///        ));
  ///}
  ///```
  final LegendItemOrientation orientation;

  ///Customizes the legend title.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               title: ChartTitle(
  ///                    text: 'Countries'
  ///            ))
  ///        ));
  ///}
  ///```
  final LegendTitle title;

  ///Widget builder for legend items.
  ///
  ///Customize the appearance of legend items in
  ///template by using `legendItemBuilder` property of legend.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               legendItemBuilder: (String name, dynamic series,dynamic point, int index) {
  ///                 return Container(
  ///                  height: 30, width: 80,child: Row(children: <Widget>[
  ///                         Container(child: Image.asset('images/bike.png')),
  ///                       Container(child: Text(index.toString())),
  ///                     ]));
  ///               })
  ///        ));
  ///}
  ///```
  final LegendItemBuilder? legendItemBuilder;

  ///Overflow legend items.
  ///
  ///The legend items can be placed in multiple rows or scroll can be enabled
  ///using the overflowMode property if size of the total legend items exceeds the available size.
  ///It can be scrolled, wrapped, or left.
  ///
  ///Defaults to `LegendItemOverflowMode.scroll`
  ///
  ///Also refer [LegendItemOverflowMode]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               overflowMode: LegendOverflowMode.wrap)
  ///        ));
  ///}
  ///```
  final LegendItemOverflowMode overflowMode;

  ///Padding of the legend items.
  ///
  ///Used to add padding between the first legend text and the second legend icon shape.
  ///
  ///Defaults to `10.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               itemPadding: 5)
  ///        ));
  ///}
  ///```
  final double itemPadding;

  ///Places the legend in custom position.
  ///
  ///If the [offset] has been set, the legend is moved from its actual position.
  /// For example, if the [position] is `top`, then the legend will be placed in the top
  /// but in the position added to the actual top position.
  ///
  ///Also, the legend will not take a dedicated position for it and will be drawn
  /// on the top of the chart's plot area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               offset: Offset(20,40))
  ///        ));
  ///}
  ///```
  final Offset? offset;

  ///Used to add image to the legend icon.
  ///
  ///Default image size is `10.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               image: const AssetImage('images/bike.png'))
  ///        ));
  ///}
  ///```
  final ImageProvider? image;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is Legend &&
        other.isVisible == isVisible &&
        other.position == position &&
        other.alignment == alignment &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.opacity == opacity &&
        other.height == height &&
        other.width == width &&
        other.padding == padding &&
        other.iconHeight == iconHeight &&
        other.iconWidth == iconWidth &&
        other.toggleSeriesVisibility == toggleSeriesVisibility &&
        other.textStyle == textStyle &&
        other.isResponsive == isResponsive &&
        other.orientation == orientation &&
        other.title == title &&
        other.overflowMode == overflowMode &&
        other.legendItemBuilder == legendItemBuilder &&
        other.iconBorderColor == iconBorderColor &&
        other.iconBorderWidth == iconBorderWidth &&
        other.itemPadding == itemPadding &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      position,
      alignment,
      backgroundColor,
      borderColor,
      borderWidth,
      opacity,
      height,
      width,
      padding,
      iconHeight,
      iconWidth,
      toggleSeriesVisibility,
      textStyle,
      isResponsive,
      orientation,
      title,
      overflowMode,
      legendItemBuilder,
      iconBorderColor,
      iconBorderWidth,
      itemPadding,
      image
    ];
    return hashList(values);
  }
}

/// Legend renderer class for mutable fields and methods
class LegendRenderer {
  /// Creates an argument constructor for  Leged renderer class
  LegendRenderer(this._legend);

  //ignore: unused_field
  final Legend? _legend;
  final _LegendRenderer _renderer = _LegendRenderer();
  late LegendPosition _legendPosition;
  late LegendItemOrientation _orientation;
}

class _MeasureWidgetContext {
  _MeasureWidgetContext(
      {this.context, this.key, this.widget, this.seriesIndex, this.pointIndex});
  BuildContext? context;
  int? seriesIndex;
  int? pointIndex;
  Key? key;
  Size? size;
  Widget? widget;
  bool isRender = false;
}

/// Customizes the legend title.
///
///Takes a string and display the legend title.By default,the legend title horizontally center
///aligned to the chart's width and it will placed at the bottom of the chart.
///
///Provides Options to customize the [text], [textStyle] and [alignment] properties.
@immutable
class LegendTitle {
  /// Creating an argument constructor of LegendTitle class.
  LegendTitle({this.text, TextStyle? textStyle, ChartAlignment? alignment})
      : textStyle = _getTextStyle(
            textStyle: textStyle,
            fontSize: 12.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Segoe UI'),
        alignment = alignment ?? ChartAlignment.center;

  ///Legend title text.
  ///
  ///Used to change the text of the title.
  ///
  /// Defaults to `‘’`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               title: ChartTitle(
  ///                    text: 'Countries'
  ///            ))
  ///        ));
  ///}
  ///```
  final String? text;

  /// Customize the legend title text.
  ///
  /// Used to change the text color, size, font family, fontStyle, and font weight
  /// for the legend title.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               title: ChartTitle(
  ///                    text: 'Countries',
  ///                    textStyle: TextStyle(
  ///                                 color: Colors.red,
  ///                                 fontSize: 12,
  ///                                 fontStyle: FontStyle.normal,
  ///                                 fontWeight: FontWeight.w400,
  ///                                 fontFamily: 'Roboto')
  ///            ))
  ///        ));
  ///}
  ///```
  final TextStyle textStyle;

  /// Alignment of the legend title.
  ///
  /// Used to change the alignment of the title text.
  ///
  /// It can be `ChartAlignment.near`,`ChartAlignment.center`, or
  /// `ChartAlignment.far`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(
  ///               isVisible: true,
  ///               title: ChartTitle(
  ///                    text: 'Countries',
  ///                    alignment: ChartAlignment.center
  ///            ))
  ///        ));
  ///}
  ///```
  final ChartAlignment alignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is LegendTitle &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.text == text;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[text, textStyle, alignment];
    return hashList(values);
  }
}

///Handling empty points in charts
///
/// Data points with a null value are considered empty points. Empty data points are ignored and are not plotted in the chart.
/// By using the emptyPointSettings property in series, you can decide on the action taken for empty points.
/// Disponible modes are gap, zero, drop, and average.
///
/// Defaults to `EmptyPointMode.gap`.
///
/// _Note:_ This is common for cartesian, circular, pyramid and funnel charts.
class EmptyPointSettings {
  /// Creating an argument constructor of EmptyPointSettings class.
  EmptyPointSettings(
      {this.color = Colors.grey,
      this.mode = EmptyPointMode.gap,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0});

  ///Color of the empty data point.
  ///
  ///Defaults to `grey`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                   BubbleSeries<BubbleColors, num>(
  ///                       emptyPointSettings: EmptyPointSettings(color: Colors.black, mode:EmptyPointMode.Zero),
  ///                  ),
  ///             ],
  ///        ));
  ///}
  ///```
  final Color color;

  ///Border color of the empty data point.
  ///
  ///Defaults to `transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                   BubbleSeries<BubbleColors, num>(
  ///                       emptyPointSettings: EmptyPointSettings(borderColor: Colors.black, EmptyPointMode.zero),
  ///                  ),
  ///             ],
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the empty data point.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                   BubbleSeries<BubbleColors, num>(
  ///                       emptyPointSettings: EmptyPointSettings(borderColor: Colors.black,
  ///                         borderWidth:2, EmptyPointMode.average),
  ///                  ),
  ///             ],
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///By default, gap will be generated for empty points, i.e. data points with null value.
  ///
  ///The empty points display the values that can be considered as zero, average, or gap.
  ///
  /// Defaults to `EmptyPointMode.gap`.
  ///
  /// Also refer [EmptyPointMode].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                   BubbleSeries<BubbleColors, num>(
  ///                       emptyPointSettings: EmptyPointSettings(EmptyPointMode.zero),
  ///                  ),
  ///             ],
  ///        ));
  ///}
  ///```
  final EmptyPointMode mode;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is EmptyPointSettings &&
        other.color == color &&
        other.mode == mode &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      color,
      mode,
      borderColor,
      borderWidth
    ];
    return hashList(values);
  }
}
