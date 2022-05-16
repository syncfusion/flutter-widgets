import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/shape_helper.dart';
import '../utils/shape_helper.dart' as shape_helper;

/// Callback which returns toggled indices and teh current toggled index.
typedef ToggledIndicesChangedCallback = void Function(
    List<int> indices, int currentIndex);

/// Called with the details of single legend item.
typedef ItemRenderCallback = void Function(ItemRendererDetails);

/// Signature to return a [Widget] for the given value.
typedef LegendPointerBuilder = Widget Function(
    BuildContext context, dynamic value);

enum _LegendType { vector, solidBar, gradientBar }

/// Positions the legend in the different directions.
enum LegendPosition {
  /// Places the legend at left.
  left,

  /// Places the legend at right.
  right,

  /// Places the legend at top.
  top,

  /// Places the legend at bottom.
  bottom,
}

/// Behavior of the legend items when it overflows.
enum LegendOverflowMode {
  /// It will place all the legend items in single line and enables scrolling.
  scroll,

  /// It will wrap and place the remaining legend items to next line.
  wrap,

  /// It will wrap and place the remaining legend items to next
  /// line with scrolling.
  wrapScroll,

  /// Exceeding items will be clipped.
  none,
}

/// Option to place the labels either between the bars or
/// on the bar in bar legend.
enum LegendLabelsPlacement {
  /// [LegendLabelsPlacement.Item] places labels in the center
  /// of the bar.
  onItem,

  /// [LegendLabelsPlacement.betweenItems] places labels
  /// in-between two bars.
  betweenItems
}

/// Placement of edge labels in the bar legend.
enum LegendEdgeLabelsPlacement {
  /// Places the edge labels in inside of the legend items.
  inside,

  /// Place the edge labels in the center of the starting position of the
  /// legend bars.
  center
}

/// Behavior of the labels when it overflowed from the shape.
enum LegendLabelOverflow {
  /// It hides the overflowed labels.
  hide,

  /// It does not make any change even if the labels overflowed.
  visible,

  /// It trims the labels based on the available space in their respective
  /// legend item.
  ellipsis
}

/// Applies gradient or solid color for the bar segments.
enum LegendPaintingStyle {
  /// Applies solid color for bar segments.
  solid,

  /// Applies gradient color for bar segments.
  gradient
}

/// Specifies the alignment of legend.
enum LegendAlignment {
  /// Denotes near.
  near,

  /// Denotes center.
  center,

  /// Denotes far.
  far,
}

/// Details of single legend item.
class ItemRendererDetails {
  /// Creates [ItemRendererDetails].
  ItemRendererDetails({
    required this.index,
    required this.text,
    required this.color,
    required this.iconType,
    this.iconBorder,
  });

  /// Index of the legend item.
  final int index;

  /// Particular legend item text.
  String text;

  /// Particular legend icon color.
  Color? color;

  /// Particular legend icon type.
  ShapeMarkerType iconType;

  /// Border of the icon.
  BorderSide? iconBorder;
}

/// Represents the class of items in legends.
class LegendItem {
  /// Creates a [LegendItem].
  const LegendItem(
      {required this.text,
      this.color,
      this.shader,
      this.imageProvider,
      this.iconType,
      this.iconStrokeWidth,
      this.overlayMarkerType,
      this.degree,
      this.endAngle,
      this.startAngle})
      : assert(color != null || shader != null || imageProvider != null);

  /// Specifies the text of the legend.
  final String text;

  /// Specifies the color of the icon.
  final Color? color;

  /// Specifies the shader of the icon.
  final Shader? shader;

  /// Identifies an image.
  final ImageProvider? imageProvider;

  /// Specifies the type of the icon.
  final ShapeMarkerType? iconType;

  /// Specifies the stroke width of the icon.
  final double? iconStrokeWidth;

  /// Specifies the overlay marker for cartesian line type icon.
  final ShapeMarkerType? overlayMarkerType;

  /// Specifies the start angle for radial bar icon.
  final double? startAngle;

  /// Specifies the degree for radial bar icon.
  final double? degree;

  /// Specifies the end angle for radial bar icon.
  final double? endAngle;
}

/// Represents the class for legends.
class SfLegend extends StatefulWidget {
  /// Creates a [SfLegend].
  const SfLegend({
    Key? key,
    required this.items,
    this.title,
    this.color,
    this.border,
    this.position = LegendPosition.top,
    this.overflowMode = LegendOverflowMode.wrap,
    this.spacing = 5.0,
    this.itemSpacing = 10.0,
    this.itemRunSpacing,
    this.iconSize = const Size(8.0, 8.0),
    this.iconBorder,
    this.direction,
    this.scrollDirection,
    this.width,
    this.height,
    this.alignment = LegendAlignment.center,
    this.offset,
    this.padding = const EdgeInsets.all(10.0),
    this.margin,
    this.textStyle,
    this.iconType = ShapeMarkerType.circle,
    this.imageProvider,
    this.toggledIconColor,
    this.toggledTextOpacity = 0.5,
    this.onToggledIndicesChanged,
    this.onItemRenderer,
    this.isComplex = false,
    this.toggledIndices,
    required this.child,
  })  : _type = _LegendType.vector,
        segmentSize = null,
        labelsPlacement = null,
        edgeLabelsPlacement = null,
        labelOverflow = null,
        segmentPaintingStyle = null,
        itemBuilder = null,
        itemCount = 0,
        toggledItemColor = null,
        pointerBuilder = null,
        pointerSize = Size.zero,
        pointerColor = null,
        pointerController = null,
        assert(itemSpacing >= 0),
        assert(spacing >= 0),
        assert(!isComplex || (isComplex && offset == null)),
        super(key: key);

  /// Creates a [SfLegend].
  const SfLegend.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.title,
    this.color,
    this.border,
    this.offset,
    this.padding,
    this.margin,
    this.position = LegendPosition.top,
    this.overflowMode = LegendOverflowMode.wrap,
    this.itemSpacing = 10.0,
    this.itemRunSpacing,
    this.spacing = 5.0,
    this.direction,
    this.scrollDirection,
    this.width,
    this.height,
    this.alignment = LegendAlignment.center,
    this.toggledItemColor,
    this.onToggledIndicesChanged,
    this.isComplex = false,
    this.toggledIndices,
    required this.child,
  })  : _type = _LegendType.vector,
        items = null,
        iconSize = Size.zero,
        textStyle = null,
        imageProvider = null,
        iconType = null,
        iconBorder = null,
        segmentSize = null,
        labelsPlacement = null,
        edgeLabelsPlacement = null,
        labelOverflow = null,
        segmentPaintingStyle = null,
        toggledIconColor = null,
        toggledTextOpacity = 0.5,
        onItemRenderer = null,
        pointerBuilder = null,
        pointerSize = Size.zero,
        pointerColor = null,
        pointerController = null,
        assert(!isComplex || (isComplex && offset == null)),
        super(key: key);

  /// Creates a [SfLegend].
  const SfLegend.bar({
    Key? key,
    required this.items,
    this.title,
    this.color,
    this.border,
    this.position = LegendPosition.top,
    this.overflowMode = LegendOverflowMode.scroll,
    this.itemSpacing = 2.0,
    this.direction,
    this.scrollDirection,
    this.offset,
    this.padding = const EdgeInsets.all(10.0),
    this.margin,
    this.textStyle,
    this.segmentSize,
    this.labelsPlacement,
    this.edgeLabelsPlacement = LegendEdgeLabelsPlacement.inside,
    this.labelOverflow = LegendLabelOverflow.visible,
    this.segmentPaintingStyle = LegendPaintingStyle.solid,
    this.isComplex = false,
    this.toggledIndices,
    this.pointerBuilder,
    this.pointerSize = const Size(16.0, 12.0),
    this.pointerColor,
    this.pointerController,
    required this.child,
  })  : _type = segmentPaintingStyle == LegendPaintingStyle.solid
            ? _LegendType.solidBar
            : _LegendType.gradientBar,
        iconType = null,
        imageProvider = null,
        iconSize = Size.zero,
        iconBorder = null,
        itemRunSpacing = null,
        spacing = 0.0,
        itemBuilder = null,
        itemCount = 0,
        alignment = null,
        width = null,
        height = null,
        toggledIconColor = null,
        toggledItemColor = null,
        toggledTextOpacity = 0.0,
        onToggledIndicesChanged = null,
        onItemRenderer = null,
        assert(itemSpacing >= 0),
        assert(!isComplex || (isComplex && offset == null)),
        super(key: key);

  /// Specifies the legend items.
  final List<LegendItem>? items;

  /// Enables a title for the legends to provide a small note about the legends.
  final Widget? title;

  /// The color to fill in the background of the legend.
  final Color? color;

  /// A border to draw surround the legend.
  final BorderSide? border;

  /// Positions the legend in the different directions.
  final LegendPosition position;

  /// Wraps or scrolls the legend items when it overflows.
  final LegendOverflowMode overflowMode;

  /// Specifies the space between the legend text and the icon.
  final double spacing;

  /// Specifies the space between the each legend items.
  final double itemSpacing;

  /// Specifies the cross axis run spacing for the wrapped elements.
  final double? itemRunSpacing;

  /// Specifies the shape of the legend icon.
  final ShapeMarkerType? iconType;

  /// Identifies an image.
  final ImageProvider? imageProvider;

  /// Specifies the size of the legend icon.
  final Size iconSize;

  /// Specifies border of the icon.
  final BorderSide? iconBorder;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis? direction;

  /// Scroll the legend items in either horizontal or vertical direction.
  final Axis? scrollDirection;

  /// Specifies the alignment of legend.
  final LegendAlignment? alignment;

  /// Specifies the width of legend.
  final double? width;

  /// Specifies the height of legend.
  final double? height;

  /// Places the legend in custom position.
  final Offset? offset;

  /// Empty space inside the decoration.
  final EdgeInsetsGeometry? padding;

  /// Empty space outside the decoration.
  final EdgeInsetsGeometry? margin;

  /// Customizes the legend item's text style.
  final TextStyle? textStyle;

  /// specifies the segment size in case of bar legend.
  final Size? segmentSize;

  /// Place the labels either between the segments or on the segments.
  final LegendLabelsPlacement? labelsPlacement;

  /// Place the edge labels either inside or outside of the bar legend.
  final LegendEdgeLabelsPlacement? edgeLabelsPlacement;

  /// Trims or removes the legend text when it is overflowed from the
  /// bar legend.
  final LegendLabelOverflow? labelOverflow;

  /// Applies gradient or solid color for the bar segments.
  final LegendPaintingStyle? segmentPaintingStyle;

  /// Widget builder for legend items.
  final IndexedWidgetBuilder? itemBuilder;

  /// Specifies the item count.
  final int itemCount;

  /// Specifies the child.
  final Widget child;

  /// Callback on toggle index changed.
  final ToggledIndicesChangedCallback? onToggledIndicesChanged;

  /// Called every time while rendering a legend item.
  final ItemRenderCallback? onItemRenderer;

  /// Specifies the toggle item color.
  final Color? toggledIconColor;

  /// Specifies the toggle item's text color opacity.
  final double toggledTextOpacity;

  /// Specifies the toggle item's color. Applicable for vector builder.
  final Color? toggledItemColor;

  /// Avoid the legend rendering if its size is greater than its child.
  final bool isComplex;

  /// Returns a widget for the given value.
  /// Pointer which is used to denote the exact color on the segment
  /// for the hovered shape or bubble. The [pointerBuilder] will be called
  /// when the user interacts with the shapes or bubbles i.e., while tapping in
  /// touch devices and hovering in the mouse enabled devices.
  final LegendPointerBuilder? pointerBuilder;

  /// Set the pointer size for the pointer support in the bar legend.
  final Size pointerSize;

  /// Set the pointer color for the pointer support in the  bar legend.
  final Color? pointerColor;

  /// Specifies the pointer controller.
  final PointerController? pointerController;

  /// Represents the toggled item indices.
  final List<int>? toggledIndices;

  /// Specifies the legend type.
  final _LegendType _type;

  @override
  // ignore: library_private_types_in_public_api
  _SfLegendState createState() => _SfLegendState();
}

class _SfLegendState extends State<SfLegend> {
  bool _omitLegend = false;
  TextStyle? _textStyle;

  Widget _buildResponsiveLayout(Widget? current,
      [BoxConstraints? baseConstraints]) {
    if (current == null) {
      return widget.child;
    }

    if (widget.offset == null) {
      switch (widget.position) {
        case LegendPosition.top:
          current = Column(children: <Widget>[
            Align(
              alignment: _getEffectiveLegendItemsAlignment(
                  widget.position, widget.alignment ?? LegendAlignment.center),
              child: current,
            ),
            _buildChild(baseConstraints)
          ]);
          break;
        case LegendPosition.bottom:
          current = Column(children: <Widget>[
            _buildChild(baseConstraints),
            Align(
              alignment: _getEffectiveLegendItemsAlignment(
                  widget.position, widget.alignment ?? LegendAlignment.center),
              child: current,
            )
          ]);
          break;
        case LegendPosition.left:
          current = Row(children: <Widget>[
            Align(
                alignment: _getEffectiveLegendItemsAlignment(widget.position,
                    widget.alignment ?? LegendAlignment.center),
                child: current),
            _buildChild(baseConstraints)
          ]);
          break;
        case LegendPosition.right:
          current = Row(children: <Widget>[
            _buildChild(baseConstraints),
            Align(
                alignment: _getEffectiveLegendItemsAlignment(widget.position,
                    widget.alignment ?? LegendAlignment.center),
                child: current)
          ]);
          break;
      }
    } else {
      current = Stack(
        children: <Widget>[
          widget.child,
          Align(
            alignment: _getEffectiveAlignment(widget.position),
            child: Padding(padding: _getEffectiveEdgeInsets(), child: current),
          ),
        ],
      );
    }
    return current;
  }

  Widget _buildChild([BoxConstraints? baseConstraints]) {
    Widget? current;
    if (!widget.isComplex) {
      current = widget.child;
    } else {
      current = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints childConstraints) {
          Widget? child;
          if ((baseConstraints!.biggest - childConstraints.biggest) <=
              childConstraints.biggest) {
            child = widget.child;
          } else {
            SchedulerBinding.instance.addPostFrameCallback(
              (Duration timeStamp) {
                setState(() {
                  _omitLegend = true;
                });
              },
            );
          }

          return SizedBox(
            width: childConstraints.maxWidth,
            height: childConstraints.maxHeight,
            child: child,
          );
        },
      );
    }

    return Expanded(child: current);
  }

  Widget? _buildLegend() {
    Widget current;
    if (_omitLegend) {
      return null;
    }

    switch (widget._type) {
      case _LegendType.vector:
        current = _VectorLegend(
          items: widget.items,
          direction: widget.direction,
          iconBorder: widget.iconBorder,
          iconSize: widget.iconSize,
          iconType: widget.iconType,
          imageProvider: widget.imageProvider,
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          itemSpacing: widget.itemSpacing,
          itemRunSpacing: widget.itemRunSpacing,
          overflowMode: widget.overflowMode,
          onItemRenderer: widget.onItemRenderer,
          onToggledIndicesChanged: widget.onToggledIndicesChanged,
          position: widget.position,
          spacing: widget.spacing,
          textStyle: _textStyle,
          toggledIndices: widget.toggledIndices,
          toggledIconColor: widget.toggledIconColor,
          toggledItemColor: widget.toggledItemColor,
          toggledTextOpacity: widget.toggledTextOpacity,
        );
        break;
      case _LegendType.solidBar:
        current = _SolidBarLegend(
          items: widget.items,
          labelsPlacement: widget.labelsPlacement,
          direction: widget.direction,
          segmentSize: widget.segmentSize,
          position: widget.position,
          itemSpacing: widget.itemSpacing,
          padding: widget.padding,
          edgeLabelsPlacement: widget.edgeLabelsPlacement,
          labelOverflow: widget.labelOverflow,
          textStyle: _textStyle,
          pointerBuilder: widget.pointerBuilder,
          pointerColor: widget.pointerColor,
          pointerSize: widget.pointerSize,
          pointerController: widget.pointerController,
        );
        break;
      case _LegendType.gradientBar:
        current = _GradientBarLegend(
          items: widget.items,
          labelsPlacement: widget.labelsPlacement,
          direction: widget.direction,
          segmentSize: widget.segmentSize,
          position: widget.position,
          itemSpacing: widget.itemSpacing,
          padding: widget.padding,
          edgeLabelsPlacement: widget.edgeLabelsPlacement,
          labelOverflow: widget.labelOverflow,
          textStyle: _textStyle,
          pointerBuilder: widget.pointerBuilder,
          pointerColor: widget.pointerColor,
          pointerSize: widget.pointerSize,
          pointerController: widget.pointerController,
        );
        break;
    }

    if (widget.padding != null) {
      current = Padding(padding: widget.padding!, child: current);
    }

    if (widget.title == null) {
      if (widget.overflowMode == LegendOverflowMode.scroll) {
        current = SingleChildScrollView(
          scrollDirection: widget.scrollDirection ??
              (widget.position == LegendPosition.top ||
                      widget.position == LegendPosition.bottom
                  ? Axis.horizontal
                  : Axis.vertical),
          child: current,
        );
      } else if (widget.overflowMode == LegendOverflowMode.wrapScroll) {
        current = SingleChildScrollView(
          scrollDirection: widget.direction == Axis.horizontal
              ? Axis.vertical
              : Axis.horizontal,
          child: current,
        );
      } else if (widget.overflowMode == LegendOverflowMode.none) {
        current = SingleChildScrollView(
            scrollDirection: widget.scrollDirection == Axis.horizontal
                ? Axis.horizontal
                : Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            child: current);
      }
    } else {
      if (widget.position == LegendPosition.top ||
          widget.position == LegendPosition.bottom) {
        current = Column(
          mainAxisAlignment: widget.position == LegendPosition.top
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: <Widget>[
            widget.title!,
            if (widget.overflowMode == LegendOverflowMode.scroll)
              (widget.width != null || widget.height != null)
                  ? Expanded(
                      child: SingleChildScrollView(
                          scrollDirection:
                              widget.scrollDirection ?? Axis.horizontal,
                          child: current),
                    )
                  : SingleChildScrollView(
                      scrollDirection:
                          widget.scrollDirection ?? Axis.horizontal,
                      child: current)
            else if (widget.overflowMode == LegendOverflowMode.wrapScroll)
              Expanded(
                child: SingleChildScrollView(
                    scrollDirection: widget.direction == Axis.horizontal
                        ? Axis.vertical
                        : Axis.horizontal,
                    child: current),
              )
            else if (widget.overflowMode == LegendOverflowMode.none)
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: widget.direction == Axis.horizontal
                          ? Axis.horizontal
                          : Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      child: current))
            else
              (widget.width != null || widget.height != null)
                  ? Expanded(child: current)
                  : current
          ],
        );
      } else {
        current = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.title!,
            Flexible(
              child: widget.overflowMode == LegendOverflowMode.scroll
                  ? SingleChildScrollView(
                      scrollDirection: widget.scrollDirection ?? Axis.vertical,
                      child: current)
                  : widget.overflowMode == LegendOverflowMode.wrapScroll
                      ? SingleChildScrollView(
                          scrollDirection: widget.direction == Axis.horizontal
                              ? Axis.vertical
                              : Axis.horizontal,
                          child: current)
                      : widget.overflowMode == LegendOverflowMode.none
                          ? SingleChildScrollView(
                              scrollDirection:
                                  widget.direction == Axis.horizontal
                                      ? Axis.vertical
                                      : Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: current)
                          : current,
            ),
          ],
        );
      }
    }

    if (widget.color != null || widget.border != null) {
      current = DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          border: widget.border != null
              ? Border.all(
                  color: widget.border!.color, width: widget.border!.width)
              : null,
        ),
        child: current,
      );
    }

    if (widget.width != null || widget.height != null) {
      current = SizedBox(
        width: widget.width,
        height: widget.height,
        child: current,
      );
    }

    if (widget.margin != null) {
      current = Padding(padding: widget.margin!, child: current);
    }

    return current;
  }

  AlignmentGeometry _getEffectiveAlignment(LegendPosition position) {
    switch (position) {
      case LegendPosition.top:
        return Alignment.topCenter;
      case LegendPosition.bottom:
        return Alignment.bottomCenter;
      case LegendPosition.left:
        return Alignment.centerLeft;
      case LegendPosition.right:
        return Alignment.centerRight;
    }
  }

  AlignmentGeometry _getEffectiveLegendItemsAlignment(
      LegendPosition position, LegendAlignment alignment) {
    switch (position) {
      case LegendPosition.top:
      case LegendPosition.bottom:
        if (alignment == LegendAlignment.near) {
          return Alignment.centerLeft;
        } else if (alignment == LegendAlignment.far) {
          return Alignment.centerRight;
        } else {
          return Alignment.center;
        }
      case LegendPosition.left:
      case LegendPosition.right:
        if (alignment == LegendAlignment.near) {
          return Alignment.topCenter;
        } else if (alignment == LegendAlignment.far) {
          return Alignment.bottomCenter;
        } else {
          return Alignment.center;
        }
    }
  }

  EdgeInsetsGeometry _getEffectiveEdgeInsets() {
    final Offset offset = widget.offset!;
    final LegendPosition legendPosition = widget.position;
    switch (legendPosition) {
      case LegendPosition.top:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            top: offset.dy > 0 ? offset.dy : 0);
      case LegendPosition.left:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            left: offset.dx > 0 ? offset.dx : 0);
      case LegendPosition.right:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() : 0);
      case LegendPosition.bottom:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    if (widget.itemBuilder == null) {
      _textStyle = themeData.textTheme.caption!
          .copyWith(
              color: themeData.textTheme.caption!.color!.withOpacity(0.87))
          .merge(widget.textStyle);
    }
    if (!widget.isComplex) {
      return _buildResponsiveLayout(_buildLegend());
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _buildResponsiveLayout(_buildLegend(), constraints);
      },
    );
  }
}

class _VectorLegend extends StatefulWidget {
  const _VectorLegend({
    this.items,
    this.direction,
    this.iconBorder,
    this.iconSize = Size.zero,
    this.iconType,
    this.imageProvider,
    this.itemBuilder,
    this.itemCount,
    this.itemSpacing,
    this.itemRunSpacing,
    this.overflowMode,
    this.onItemRenderer,
    this.onToggledIndicesChanged,
    this.position,
    this.spacing,
    this.textStyle,
    this.toggledIconColor,
    this.toggledItemColor,
    this.toggledTextOpacity,
    this.toggledIndices,
  });

  /// Specifies the legend items.
  final List<LegendItem>? items;

  /// Specifies the shape of the legend icon.
  final ShapeMarkerType? iconType;

  /// Identifies an image.
  final ImageProvider? imageProvider;

  /// Specifies the size of the legend icon.
  final Size iconSize;

  /// Specifies border of the icon.
  final BorderSide? iconBorder;

  /// Customizes the legend item's text style.
  final TextStyle? textStyle;

  /// Specifies the space between the legend text and the icon.
  final double? spacing;

  /// Specifies the toggle item's text color opacity.
  final double? toggledTextOpacity;

  /// Wraps or scrolls the legend items when it overflows.
  final LegendOverflowMode? overflowMode;

  /// Callback on toggle index changed.
  final ToggledIndicesChangedCallback? onToggledIndicesChanged;

  /// Called every time while rendering a legend item.
  final ItemRenderCallback? onItemRenderer;

  /// Widget builder for legend items.
  final IndexedWidgetBuilder? itemBuilder;

  /// Specifies the item count.
  final int? itemCount;

  /// Specifies the toggle item color.
  final Color? toggledIconColor;

  /// Specifies the toggle item's color. Applicable for vector builder.
  final Color? toggledItemColor;

  /// Positions the legend in the different directions.
  final LegendPosition? position;

  /// Specifies the space between the each legend items.
  final double? itemSpacing;

  /// Specifies the cross axis run spacing for the wrapped elements.
  final double? itemRunSpacing;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis? direction;

  final List<int>? toggledIndices;

  @override
  _VectorLegendState createState() => _VectorLegendState();
}

class _VectorLegendState extends State<_VectorLegend>
    with SingleTickerProviderStateMixin {
  List<Widget> _buildLegendItems(ThemeData themeData) {
    final List<Widget> items = <Widget>[];
    if (widget.items != null) {
      final int length = widget.items!.length;
      for (int index = 0; index < length; index++) {
        final LegendItem item = widget.items![index];
        items.add(_LegendItem(
          index: index,
          text: item.text,
          textStyle: widget.textStyle,
          iconType: item.iconType ?? widget.iconType,
          iconStrokeWidth: item.iconStrokeWidth,
          imageProvider: item.imageProvider ?? widget.imageProvider,
          shader: item.shader,
          iconSize: widget.iconSize,
          iconColor: item.color,
          iconBorder: widget.iconBorder,
          spacing: widget.spacing,
          toggledIndices: widget.toggledIndices,
          toggledColor: _getEffectiveToggledColor(themeData),
          toggledTextOpacity: widget.toggledTextOpacity,
          onToggledIndicesChanged: widget.onToggledIndicesChanged,
          onItemRenderer: widget.onItemRenderer,
          overlayMarkerType: item.overlayMarkerType,
          degree: item.degree,
          startAngle: item.startAngle,
          endAngle: item.endAngle,
        ));
      }
    } else if (widget.itemCount != null &&
        widget.itemCount! > 0 &&
        widget.itemBuilder != null) {
      for (int index = 0; index < widget.itemCount!; index++) {
        items.add(_LegendItem(
          index: index,
          itemBuilder: widget.itemBuilder,
          toggledColor: _getEffectiveToggledColor(themeData),
          toggledIndices: widget.toggledIndices,
          onToggledIndicesChanged: widget.onToggledIndicesChanged,
        ));
      }
    }
    return items;
  }

  Color? _getEffectiveToggledColor(ThemeData themeData) {
    Color? toggledColor;
    if (widget.onToggledIndicesChanged != null) {
      toggledColor = widget.toggledIconColor ?? widget.toggledItemColor;
      if (toggledColor == null || toggledColor == Colors.transparent) {
        toggledColor = themeData.brightness == Brightness.light
            ? const Color.fromRGBO(230, 230, 230, 1)
            : const Color.fromRGBO(66, 66, 66, 1);
      }
    }

    return toggledColor;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final Widget current = Wrap(
      direction: widget.direction ??
          (widget.position == LegendPosition.top ||
                  widget.position == LegendPosition.bottom
              ? Axis.horizontal
              : Axis.vertical),
      spacing: widget.itemSpacing!,
      runSpacing: widget.itemRunSpacing ?? 6.0,
      runAlignment: WrapAlignment.center,
      children: _buildLegendItems(themeData),
    );

    return current;
  }
}

/// Represents the class for generating legend item.
class _LegendItem extends StatefulWidget {
  /// Creates a [LegendItem].
  const _LegendItem({
    required this.index,
    this.itemBuilder,
    this.text,
    this.textStyle,
    this.iconType,
    this.iconStrokeWidth,
    this.imageProvider,
    this.shader,
    this.iconSize = Size.zero,
    this.iconColor,
    this.iconBorder,
    this.toggledColor,
    this.spacing,
    this.toggledTextOpacity,
    required this.toggledIndices,
    required this.onToggledIndicesChanged,
    this.onItemRenderer,
    this.overlayMarkerType,
    this.degree,
    this.startAngle,
    this.endAngle,
  });

  /// Specifies the item index.
  final int index;

  /// Widget builder for legend item.
  final IndexedWidgetBuilder? itemBuilder;

  /// Specifies the text of the items.
  final String? text;

  /// Specifies the style of the text.
  final TextStyle? textStyle;

  /// Specifies the shape of the legend icon.
  final ShapeMarkerType? iconType;

  /// Specifies the stroke width of the legend icon.
  final double? iconStrokeWidth;

  /// Identifies an image.
  final ImageProvider? imageProvider;

  /// Specifies the shader of the icon.
  final Shader? shader;

  /// Specifies the size of the legend icon.
  final Size iconSize;

  /// Specifies the color of the icon.
  final Color? iconColor;

  /// Specifies the border of the icon.
  final BorderSide? iconBorder;

  /// Specifies the space between the legend text and the icon.
  final double? spacing;

  /// Specifies the toggled indices.
  final List<int>? toggledIndices;

  /// Specifies the toggled item color.
  final Color? toggledColor;

  /// Specifies the toggle item's text color opacity.
  final double? toggledTextOpacity;

  /// Callback on toggle index changed.
  final ToggledIndicesChangedCallback? onToggledIndicesChanged;

  /// Called every time while rendering a legend item.
  final ItemRenderCallback? onItemRenderer;

  /// Specifies the overlay marker  for cartesian line type icon.
  final ShapeMarkerType? overlayMarkerType;

  /// Specifies the start angle for radial bar icon.
  final double? startAngle;

  /// Specifies the degree for radial bar icon.
  final double? degree;

  /// Specifies the end angle for radial bar icon.
  final double? endAngle;

  @override
  _LegendItemState createState() => _LegendItemState();
}

class _LegendItemState extends State<_LegendItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _toggleAnimationController;
  late Animation<double> _toggleAnimation;
  late ColorTween _iconColorTween;
  late Tween<double> _opacityTween;

  ImageInfo? _imageInfo;
  ImageStream? _imageStream;
  Completer<ImageInfo>? _completer;
  Future<ui.Image?>? _obtainImage;

  Widget _buildCustomPaint(
      ItemRendererDetails details, AsyncSnapshot<ui.Image?> snapshot) {
    Widget current = CustomPaint(
      size: widget.iconSize,
      painter: _LegendIconShape(
          color: details.color,
          iconType: details.iconType,
          iconBorder: details.iconBorder,
          iconStrokeWidth: widget.iconStrokeWidth,
          image: snapshot.data,
          shader: widget.shader,
          overlayMarkerType: widget.overlayMarkerType,
          degree: widget.degree,
          startAngle: widget.startAngle,
          endAngle: widget.endAngle),
    );

    if (widget.shader != null &&
        details.color != null &&
        !_toggleAnimationController.isDismissed) {
      current = _buildShaderMask(details.color!, current);
    }

    return current;
  }

  Widget _buildShaderMask(Color color, Widget current) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return LinearGradient(colors: <Color>[color, color])
            .createShader(bounds);
      },
      child: current,
    );
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.toggledIndices != null) {
      final List<int> newToggledIndices =
          List<int>.from(widget.toggledIndices!);
      if (!newToggledIndices.contains(widget.index)) {
        newToggledIndices.add(widget.index);
      } else {
        newToggledIndices.remove(widget.index);
      }
      widget.onToggledIndicesChanged?.call(newToggledIndices, widget.index);
    }
  }

  Future<ui.Image?>? _retrieveImageFromProvider() async {
    if (widget.iconType != ShapeMarkerType.image ||
        widget.imageProvider == null) {
      return null;
    }

    _completer = Completer<ImageInfo>();
    _imageStream?.removeListener(imageStreamListener(_completer!));
    _imageStream = widget.imageProvider!.resolve(ImageConfiguration.empty);
    _imageStream!.addListener(imageStreamListener(_completer!));
    _imageInfo?.dispose();
    _imageInfo = await _completer!.future;
    return _imageInfo!.image;
  }

  ImageStreamListener imageStreamListener(Completer<ImageInfo> completer) {
    return ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image);
    });
  }

  void rebuild() {
    setState(() {
      // Rebuilding the widget to update the UI while toggling.
    });
  }

  @override
  void initState() {
    _toggleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _toggleAnimation = CurvedAnimation(
        parent: _toggleAnimationController, curve: Curves.easeInOut);
    _toggleAnimation.addListener(rebuild);

    final Color? begin = widget.shader == null && widget.imageProvider == null
        ? widget.iconColor
        : null;
    _iconColorTween = ColorTween(begin: begin, end: widget.toggledColor);
    _opacityTween = Tween<double>(begin: 1.0, end: widget.toggledTextOpacity);

    if (widget.toggledIndices != null) {
      if (widget.toggledIndices!.contains(widget.index)) {
        _toggleAnimationController.value = 1.0;
      } else {
        _toggleAnimationController.value = 0.0;
      }
    }

    _obtainImage = _retrieveImageFromProvider();
    super.initState();
  }

  @override
  void didUpdateWidget(_LegendItem oldWidget) {
    if (widget.iconColor != oldWidget.iconColor) {
      final Color? begin = widget.shader == null && widget.imageProvider == null
          ? widget.iconColor
          : null;
      _iconColorTween.begin = begin;
    }

    if (widget.toggledColor != oldWidget.toggledColor &&
        widget.toggledColor != null) {
      _iconColorTween.end = widget.toggledColor;
    }

    if (widget.toggledTextOpacity != oldWidget.toggledTextOpacity) {
      _opacityTween = Tween<double>(begin: 1.0, end: widget.toggledTextOpacity);
    }

    if (widget.imageProvider != oldWidget.imageProvider) {
      _obtainImage = _retrieveImageFromProvider();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _toggleAnimation.removeListener(rebuild);
    _toggleAnimationController.dispose();
    _imageStream?.removeListener(imageStreamListener(_completer!));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image?>(
      future: _obtainImage,
      builder: (BuildContext context, AsyncSnapshot<ui.Image?> snapshot) {
        Widget current;
        if (widget.toggledIndices != null) {
          if (widget.toggledIndices!.contains(widget.index)) {
            _toggleAnimationController.forward();
          } else {
            _toggleAnimationController.reverse();
          }
        }

        if (widget.itemBuilder != null) {
          current = widget.itemBuilder!.call(context, widget.index);
          if (widget.onToggledIndicesChanged != null) {
            final Color? color = _iconColorTween.evaluate(_toggleAnimation);
            if (color != null) {
              current = _buildShaderMask(color, current);
            }
          }
        } else {
          final Color? referenceIconColor =
              _iconColorTween.evaluate(_toggleAnimation);
          final ItemRendererDetails details = ItemRendererDetails(
            index: widget.index,
            text: widget.text!,
            color: referenceIconColor,
            iconType: widget.iconType!,
            iconBorder: widget.iconBorder,
          );
          widget.onItemRenderer?.call(details);
          if (referenceIconColor != null &&
              referenceIconColor != details.color) {
            _iconColorTween.begin = details.color;
            details.color = _iconColorTween.evaluate(_toggleAnimation);
          }
          current = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildCustomPaint(details, snapshot),
              SizedBox(width: widget.spacing),
              Text(
                details.text,
                style: widget.textStyle!.copyWith(
                  color: widget.textStyle!.foreground == null
                      ? widget.textStyle!.color!
                          .withOpacity(_opacityTween.evaluate(_toggleAnimation))
                      : widget.textStyle!.foreground!.color,
                ),
              )
            ],
          );
        }

        if (widget.onToggledIndicesChanged != null) {
          current = MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapUp: _handleTapUp,
              behavior: HitTestBehavior.opaque,
              child: current,
            ),
          );
        }

        return current;
      },
    );
  }
}

/// Represents the class for rendering icon shape.
class _LegendIconShape extends CustomPainter {
  /// Represents [LegendIconShape]
  _LegendIconShape(
      {required this.color,
      required this.iconType,
      this.iconBorder,
      this.iconStrokeWidth,
      this.image,
      this.shader,
      this.overlayMarkerType,
      this.degree,
      this.startAngle,
      this.endAngle});

  /// Specifies the color of the icon.
  final Color? color;

  /// Specifies the icon type.
  final ShapeMarkerType? iconType;

  /// Specifies the border of the icon.
  final BorderSide? iconBorder;

  /// Specifies the stroke width of the icon.
  final double? iconStrokeWidth;

  /// Identifies an image.
  final ui.Image? image;

  /// Specifies the shader of the icon.
  final Shader? shader;

  /// Specifies the overlay marker for cartesian line icon type icon.
  final ShapeMarkerType? overlayMarkerType;

  /// Specifies the start angle for radial bar icon.
  final double? startAngle;

  /// Specifies the degree for radial bar icon.
  final double? degree;

  /// Specifies the end angle for radial bar icon.
  final double? endAngle;

  Paint _getFillPaint() {
    final Paint paint = Paint();
    if (shader != null) {
      paint.shader = shader;
    } else if (color != null) {
      paint.color = color!;
    }

    return paint;
  }

  Paint? _getStrokePaint() {
    if (iconStrokeWidth != null && color != null) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..color = color!
        ..strokeWidth = iconStrokeWidth!;
    }

    return iconBorder?.toPaint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (iconType == ShapeMarkerType.image && image != null) {
      paintImage(canvas: canvas, rect: Offset.zero & size, image: image!);
    } else {
      shape_helper.paint(
          canvas: canvas,
          rect: Offset.zero & size,
          shapeType: iconType!,
          paint: _getFillPaint(),
          borderPaint: _getStrokePaint(),
          overlayMarkerType: overlayMarkerType,
          degree: degree,
          startAngle: startAngle,
          endAngle: endAngle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _SolidBarLegend extends StatefulWidget {
  const _SolidBarLegend({
    required this.items,
    this.direction,
    this.position,
    this.itemSpacing,
    this.padding,
    this.labelOverflow,
    this.labelsPlacement,
    this.edgeLabelsPlacement,
    this.segmentSize,
    this.textStyle,
    this.pointerSize,
    this.pointerColor,
    this.pointerBuilder,
    this.pointerController,
  });

  /// Specifies the legend items.
  final List<LegendItem>? items;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis? direction;

  /// Positions the legend in the different directions.
  final LegendPosition? position;

  /// Specifies the space between the each legend items.
  final double? itemSpacing;

  /// Sets the padding around the legend.
  final EdgeInsetsGeometry? padding;

  /// Trims or removes the legend text when it is overflowed from the
  /// bar legend.
  final LegendLabelOverflow? labelOverflow;

  /// Option to place the labels either between the bars or
  /// on the bar in bar legend.
  final LegendLabelsPlacement? labelsPlacement;

  /// Place the edge labels either inside or outside of the bar legend.
  final LegendEdgeLabelsPlacement? edgeLabelsPlacement;

  /// Specifies the segment size in case of bar legend.
  final Size? segmentSize;

  /// Customizes the legend item's text style.
  final TextStyle? textStyle;

  /// Set the pointer size for the pointer support in the bar legend.
  final Size? pointerSize;

  /// Set the pointer color for the pointer support in the  bar legend.
  final Color? pointerColor;

  /// Returns a widget for the given value.
  /// Pointer which is used to denote the exact color on the segment
  /// for the hovered shape or bubble. The [pointerBuilder] will be called
  /// when the user interacts with the shapes or bubbles i.e., while tapping in
  /// touch devices and hovering in the mouse enabled devices.
  final LegendPointerBuilder? pointerBuilder;

  /// Specifies the pointer controller.
  final PointerController? pointerController;

  @override
  _SolidBarLegendState createState() => _SolidBarLegendState();
}

class _SolidBarLegendState extends State<_SolidBarLegend> {
  late Axis _direction;
  late TextDirection _textDirection;
  late TextPainter _textPainter;
  bool _isOverlapSegmentText = false;
  late Size _segmentSize;

  @override
  void initState() {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _segmentSize = widget.segmentSize ?? const Size(80.0, 12.0);
    final TextDirection textDirection = Directionality.of(context);
    _direction = widget.direction ??
        (widget.position == LegendPosition.top ||
                widget.position == LegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    _textDirection = textDirection == TextDirection.ltr
        ? textDirection
        : (_direction == Axis.vertical ? TextDirection.ltr : textDirection);
    _textPainter.textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final Widget child = Directionality(
      textDirection: _textDirection,
      child: Wrap(
        direction: _direction,
        spacing: widget.itemSpacing!,
        runSpacing: 6,
        runAlignment: WrapAlignment.center,
        children: _getBarSegments(),
      ),
    );

    return child;
  }

  List<Widget> _getBarSegments() {
    final List<Widget> legendItems = <Widget>[];

    if (widget.items != null) {
      final int length = widget.items!.length;
      String? currentText;
      String? startText;
      for (int i = 0; i < length; i++) {
        _isOverlapSegmentText = false;
        final LegendItem item = widget.items![i];
        if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
          if (i == length - 1) {
            currentText = widget.items![i - 1].text;
            currentText = _getTrimmedText(item.text, currentText, i, length);
          } else {
            if (i == 0) {
              final List<String> firstSegmentLabels =
                  _getStartSegmentLabel(item.text);
              if (firstSegmentLabels.length > 1) {
                startText = firstSegmentLabels[0];
                currentText = firstSegmentLabels[1];
                startText = _getTrimmedText(startText, currentText, i, length);
              } else {
                currentText = firstSegmentLabels[0];
              }
            } else {
              currentText = item.text;
            }

            currentText = _getTrimmedText(
                currentText, widget.items![i + 1].text, i, length);
          }
        } else {
          currentText = item.text;
          if (_direction == Axis.horizontal &&
              widget.labelsPlacement == LegendLabelsPlacement.onItem) {
            _isOverlapSegmentText =
                _getTextWidth(currentText) > _segmentSize.width;
            if (_isOverlapSegmentText &&
                widget.labelOverflow == LegendLabelOverflow.hide) {
              // Passing empty string in case of overlap segment.
              currentText = '';
            }
          }
        }
        legendItems.add(_SolidBarLegendItem(
          labelsPlacement: widget.labelsPlacement,
          labelOverflow: widget.labelOverflow,
          segmentSize: _segmentSize,
          iconColor: item.color,
          direction: _direction,
          textStyle: widget.textStyle,
          index: i,
          length: length,
          startText: startText,
          text: currentText,
          itemSpacing: widget.itemSpacing,
          edgeLabelsPlacement: widget.edgeLabelsPlacement,
          pointerSize: widget.pointerSize,
          pointerColor: widget.pointerColor,
          pointerBuilder: widget.pointerBuilder,
          pointerController: widget.pointerController,
        ));
      }
    }

    return legendItems;
  }

  List<String> _getStartSegmentLabel(String startSegmentLabel) {
    if (startSegmentLabel.isNotEmpty &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      final List<String> splitText = startSegmentLabel.split('},{');
      if (splitText.length > 1) {
        splitText[0] = splitText[0].replaceAll('{', '');
        splitText[1] = splitText[1].replaceAll('}', '');
      }
      return splitText;
    } else {
      return <String>[startSegmentLabel];
    }
  }

  String _getTrimmedText(
      String currentText, String? nextText, int index, int length) {
    if (widget.labelOverflow == LegendLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    final Size barSize = _segmentSize;
    double refCurrentTextWidth;
    double refNextTextWidth;
    if (_direction == Axis.horizontal &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      bool isLastInsideItem = false;
      if (index == length - 1) {
        isLastInsideItem =
            widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside;
        refNextTextWidth = _getTextWidth(nextText) / 2;
        refCurrentTextWidth = isLastInsideItem
            ? _getTextWidth(currentText)
            : _getTextWidth(currentText) / 2;
      } else {
        refCurrentTextWidth = _getTextWidth(currentText) / 2;
        refNextTextWidth = index + 1 == length - 1 &&
                widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth >
          barSize.width + widget.itemSpacing!;

      // Returning empty string in case of text overlapping the segment size
      // and overflow mode is [LegendLabelOverflow.hide]
      if (widget.labelOverflow == LegendLabelOverflow.hide &&
          _isOverlapSegmentText) {
        return '';
      } else if (widget.labelOverflow == LegendLabelOverflow.ellipsis) {
        final double textWidth = refCurrentTextWidth + refNextTextWidth;
        return _getTrimText(
            currentText,
            widget.textStyle!,
            _segmentSize.width + widget.itemSpacing! / 2,
            _textPainter,
            textWidth,
            refNextTextWidth,
            isLastInsideItem);
      }
    }

    return currentText;
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }
}

String _getTrimText(String text, TextStyle style, double maxWidth,
    TextPainter painter, double width,
    [double? nextTextHalfWidth, bool isInsideLastItem = false]) {
  final int actualTextLength = text.length;
  String trimmedText = text;
  int trimLength = 3; // 3 dots
  while (width > maxWidth) {
    if (trimmedText.length <= 4) {
      trimmedText = '${trimmedText[0]}...';
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      break;
    } else {
      trimmedText = text.replaceRange(
          actualTextLength - trimLength, actualTextLength, '...');
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      trimLength++;
    }

    if (isInsideLastItem && nextTextHalfWidth != null) {
      width = painter.width + nextTextHalfWidth;
    } else {
      width = nextTextHalfWidth != null
          ? painter.width / 2 + nextTextHalfWidth
          : painter.width;
    }
  }

  return trimmedText;
}

class _SolidBarLegendItem extends StatefulWidget {
  const _SolidBarLegendItem({
    Key? key,
    this.labelsPlacement,
    this.labelOverflow,
    this.segmentSize,
    this.iconColor,
    this.direction,
    this.textStyle,
    this.index,
    this.text,
    this.startText,
    this.edgeLabelsPlacement,
    this.itemSpacing,
    this.length,
    this.pointerSize,
    this.pointerColor,
    this.pointerBuilder,
    this.pointerController,
  }) : super(key: key);

  final LegendLabelsPlacement? labelsPlacement;
  final LegendLabelOverflow? labelOverflow;
  final Size? segmentSize;
  final Color? iconColor;
  final Axis? direction;
  final TextStyle? textStyle;
  final int? index;
  final int? length;
  final String? startText;
  final String? text;
  final LegendEdgeLabelsPlacement? edgeLabelsPlacement;
  final double? itemSpacing;
  final Size? pointerSize;
  final Color? pointerColor;
  final LegendPointerBuilder? pointerBuilder;
  final PointerController? pointerController;

  @override
  __SolidBarLegendItemState createState() => __SolidBarLegendItemState();
}

class __SolidBarLegendItemState extends State<_SolidBarLegendItem> {
  late TextPainter _textPainter;
  late TextDirection _textDirection;

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (widget.labelsPlacement == LegendLabelsPlacement.onItem &&
        widget.labelOverflow != LegendLabelOverflow.visible) {
      return CrossAxisAlignment.center;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  @override
  void initState() {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    widget.pointerController!.addListener(_rebuild);
    super.initState();
  }

  @override
  void dispose() {
    widget.pointerController!.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (widget.pointerController!.segmentIndex == widget.index ||
        widget.pointerController!.previousSegmentIndex == widget.index) {
      setState(() {
        // Rebuilding the currently hovered segment with pointer and
        // removing pointer in previously hovered segment.
      });
    }
  }

  Offset _getTextOffset(
      int index, String text, int dataSourceLength, bool isStartText) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();

    if (index == 0 && isStartText) {
      if (widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside) {
        return Offset.zero;
      } else {
        if (widget.direction == Axis.horizontal) {
          return Offset(-_textPainter.width / 2, 0.0);
        } else {
          return Offset(0.0, -_textPainter.height / 2);
        }
      }
    } else {
      if (widget.labelsPlacement == LegendLabelsPlacement.onItem &&
          widget.labelOverflow != LegendLabelOverflow.visible) {
        return Offset.zero;
      } else {
        if (widget.direction == Axis.horizontal) {
          return _getHorizontalTextOffset(index, text, dataSourceLength);
        } else {
          return _getVerticalTextOffset(index, text, dataSourceLength);
        }
      }
    }
  }

  Offset _getHorizontalTextOffset(
      int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      final double width = _textDirection == TextDirection.rtl &&
              widget.segmentSize!.width < _textPainter.width
          ? _textPainter.width
          : widget.segmentSize!.width;
      if (index == dataSourceLength - 1) {
        if (widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside) {
          return Offset(width - _textPainter.width, 0.0);
        }
        return Offset(width - _textPainter.width / 2, 0.0);
      }

      return Offset(
          width - _textPainter.width / 2 + widget.itemSpacing! / 2, 0.0);
    } else {
      final double xPosition = _textDirection == TextDirection.rtl &&
              widget.segmentSize!.width < _textPainter.width
          ? _textPainter.width / 2 - widget.segmentSize!.width / 2
          : widget.segmentSize!.width / 2 - _textPainter.width / 2;
      return Offset(xPosition, 0.0);
    }
  }

  Offset _getVerticalTextOffset(int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      if (index == dataSourceLength - 1) {
        if (widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside) {
          return Offset(0.0, widget.segmentSize!.width - _textPainter.height);
        }
        return Offset(0.0, widget.segmentSize!.width - _textPainter.height / 2);
      }

      return Offset(
          0.0,
          widget.segmentSize!.width -
              _textPainter.height / 2 +
              widget.itemSpacing! / 2);
    } else {
      return Offset(
          0.0, widget.segmentSize!.width / 2 - _textPainter.height / 2);
    }
  }

  Widget _getAlignedTextWidget(Offset offset, String text, bool isOverlapping) {
    if ((widget.labelOverflow == LegendLabelOverflow.hide && isOverlapping) ||
        text.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: offset != Offset.zero
          ? Transform.translate(
              offset: offset,
              child: Text(
                text,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: widget.textStyle,
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: widget.labelOverflow == LegendLabelOverflow.ellipsis &&
                      widget.labelsPlacement == LegendLabelsPlacement.onItem
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              style: widget.textStyle,
            ),
    );
  }

  Widget _getTextWidget(String? startText, String text) {
    Offset? startTextOffset;
    if (widget.index == 0 && startText != null) {
      startTextOffset =
          _getTextOffset(widget.index!, startText, widget.length!, true);
      startTextOffset = _textDirection == TextDirection.rtl &&
              widget.direction == Axis.horizontal
          ? -startTextOffset
          : startTextOffset;
    }
    Offset textOffset =
        _getTextOffset(widget.index!, text, widget.length!, false);
    textOffset = _textDirection == TextDirection.rtl ? -textOffset : textOffset;

    if (widget.index == 0 &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems &&
        startText != null) {
      return Stack(
        children: <Widget>[
          _getAlignedTextWidget(startTextOffset!, startText, false),
          _getAlignedTextWidget(textOffset, text, false),
        ],
      );
    } else {
      return _getAlignedTextWidget(textOffset, text, false);
    }
  }

  Widget _buildPointer() {
    Widget? current;
    Matrix4 matrix4;

    if (widget.index == widget.pointerController!.segmentIndex &&
        widget.pointerController!.position != null) {
      if (widget.pointerBuilder != null &&
          widget.pointerController!.colorValue != null) {
        current = SizedBox(
          width: widget.pointerSize!.width,
          height: widget.pointerSize!.height,
          child: widget.pointerBuilder!
              .call(context, widget.pointerController!.colorValue),
        );
      } else {
        current = CustomPaint(
          size: widget.pointerSize!,
          painter: _LegendIconShape(
            color: widget.pointerColor ??
                (Theme.of(context).brightness == Brightness.light
                    ? const Color.fromRGBO(0, 0, 0, 0.54)
                    : const Color.fromRGBO(255, 255, 255, 0.7)),
            iconType: ShapeMarkerType.invertedTriangle,
          ),
        );
      }

      if (widget.direction == Axis.horizontal) {
        matrix4 = Matrix4.identity()
          ..translate(widget.pointerController!.position!.dx *
                  widget.segmentSize!.width -
              (widget.pointerSize!.width / 2));
        if (_textDirection == TextDirection.rtl) {
          matrix4.invert();
        }
        current = Transform(transform: matrix4, child: current);
      } else {
        current = RotatedBox(quarterTurns: 3, child: current);
        matrix4 = Matrix4.identity()
          ..translate(
              0.0,
              widget.pointerController!.position!.dy *
                      widget.segmentSize!.width -
                  (widget.pointerSize!.width / 2));
        current = Transform(transform: matrix4, child: current);
      }
    } else {
      current = widget.direction == Axis.horizontal
          ? SizedBox(
              height: widget.pointerSize!.height,
              width: widget.pointerSize!.width)
          : SizedBox(
              height: widget.pointerSize!.width,
              width: widget.pointerSize!.height);
    }

    return current;
  }

  @override
  Widget build(BuildContext context) {
    _textDirection = Directionality.of(context);
    if (widget.direction == Axis.horizontal) {
      return SizedBox(
        width: widget.segmentSize!.width,
        child: Column(
          crossAxisAlignment: _getCrossAxisAlignment(),
          children: <Widget>[
            Align(
                alignment: _textDirection == TextDirection.ltr
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: _buildPointer()),
            Padding(
              // Gap between segment text and icon.
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Container(
                height: widget.segmentSize!.height,
                color: widget.iconColor,
              ),
            ),
            _getTextWidget(widget.startText, widget.text!)
          ],
        ),
      );
    } else {
      return SizedBox(
        height: widget.segmentSize!.width,
        child: Row(
          crossAxisAlignment: _getCrossAxisAlignment(),
          children: <Widget>[
            Align(alignment: Alignment.topCenter, child: _buildPointer()),
            Padding(
              // Gap between segment text and icon.
              padding: const EdgeInsets.only(right: 7.0),
              child: Container(
                width: widget.segmentSize!.height,
                color: widget.iconColor,
              ),
            ),
            _getTextWidget(widget.startText, widget.text!)
          ],
        ),
      );
    }
  }
}

class _GradientBarLegend extends StatefulWidget {
  const _GradientBarLegend({
    required this.items,
    this.labelsPlacement,
    this.segmentSize,
    this.direction,
    this.position,
    this.itemSpacing,
    this.padding,
    this.edgeLabelsPlacement,
    this.labelOverflow,
    this.textStyle,
    this.pointerBuilder,
    this.pointerColor,
    this.pointerSize,
    this.pointerController,
  });

  /// specifies the segment size in case of bar legend.
  final Size? segmentSize;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis? direction;

  /// Positions the legend in the different directions.
  final LegendPosition? position;

  /// Specifies the space between the each legend items.
  final double? itemSpacing;

  /// Specifies the legend items.
  final List<LegendItem>? items;

  /// Sets the padding around the legend.
  final EdgeInsetsGeometry? padding;

  /// Place the edge labels either inside or outside of the bar legend.
  final LegendEdgeLabelsPlacement? edgeLabelsPlacement;

  /// Trims or removes the legend text when it is overflowed from the
  /// bar legend.
  final LegendLabelOverflow? labelOverflow;

  /// Customizes the legend item's text style.
  final TextStyle? textStyle;

  /// Specifies the label placement.
  final LegendLabelsPlacement? labelsPlacement;

  /// Returns a widget for the given value.
  /// Pointer which is used to denote the exact color on the segment
  /// for the hovered shape or bubble. The [pointerBuilder] will be called
  /// when the user interacts with the shapes or bubbles i.e., while tapping in
  /// touch devices and hovering in the mouse enabled devices.
  final LegendPointerBuilder? pointerBuilder;

  /// Set the pointer size for the pointer support in the bar legend.
  final Size? pointerSize;

  /// Set the pointer color for the pointer support in the  bar legend.
  final Color? pointerColor;

  /// Specifies the pointer controller.
  final PointerController? pointerController;

  @override
  _GradientBarLegendState createState() => _GradientBarLegendState();
}

class _GradientBarLegendState extends State<_GradientBarLegend> {
  late List<Color> _colors;
  late List<_GradientBarLabel> _labels;

  late Axis _direction;
  late Size _segmentSize;
  late TextPainter _textPainter;
  late double _referenceArea;
  bool _isRTL = false;
  bool _isOverlapSegmentText = false;

  void _updateSegmentSize(double shortestSide) {
    if (_direction == Axis.horizontal) {
      final double availableWidth = widget.padding != null
          ? shortestSide - widget.padding!.horizontal
          : shortestSide;
      _segmentSize = widget.segmentSize == null
          ? Size(availableWidth, 12.0)
          : Size(
              widget.segmentSize!.width > availableWidth
                  ? availableWidth
                  : widget.segmentSize!.width,
              widget.segmentSize!.height);
      return;
    }

    final double availableHeight = widget.padding != null
        ? shortestSide - widget.padding!.vertical
        : shortestSide;
    _segmentSize = widget.segmentSize == null
        ? Size(12.0, availableHeight)
        : Size(
            widget.segmentSize!.width,
            widget.segmentSize!.height > availableHeight
                ? availableHeight
                : widget.segmentSize!.height);
  }

  void _collectLabelsAndColors() {
    _labels.clear();
    _colors.clear();

    /// Creating new instance at this point, since we are modifying
    /// the same list during the run time.
    _colors = <Color>[];
    _referenceArea = _direction == Axis.horizontal
        ? _segmentSize.width
        : _segmentSize.height;
    if (widget.items != null) {
      final int length = widget.items!.length;

      final double slab = _referenceArea /
          (widget.labelsPlacement == LegendLabelsPlacement.betweenItems &&
                  widget.items![0].text[0] != '{'
              ? length - 1
              : length);

      for (int i = 0; i < length; i++) {
        _isOverlapSegmentText = false;
        final LegendItem item = widget.items![i];
        String text;
        if (i == 0) {
          final List<String> firstSegmentLabels = _getStartSegmentLabel(item);
          text = firstSegmentLabels.length > 1
              ? firstSegmentLabels[1]
              : firstSegmentLabels[0];
        } else {
          text = item.text;
        }

        if (widget.items![0].text[0] == '{' &&
            widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
          _collectRageColorMapperLabels(i, item, text, slab, length);
        } else {
          final int positionIndex =
              widget.labelsPlacement == LegendLabelsPlacement.onItem
                  ? i + 1
                  : i;
          if (widget.labelsPlacement == LegendLabelsPlacement.onItem) {
            text = _getTrimmedText(text, i, length, slab);
          } else if (i < length - 1) {
            text = _getTrimmedText(
                text, i, length, slab, widget.items![i + 1].text);
          }

          _labels.add(_GradientBarLabel(
              text,
              _getTextOffset(text, positionIndex, length - 1, slab),
              _isOverlapSegmentText));
        }
        _colors.add(item.color!);
      }
    }
  }

  void _collectRageColorMapperLabels(
      int i, LegendItem item, String text, double slab, int length) {
    if (i == 0 &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      String startText;
      final List<String> firstSegmentLabels = _getStartSegmentLabel(item);
      startText = firstSegmentLabels[0];

      if (_direction == Axis.horizontal &&
          widget.labelsPlacement == LegendLabelsPlacement.betweenItems &&
          startText.isNotEmpty &&
          text.isNotEmpty) {
        final double refCurrentTextWidth =
            widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside
                ? _getTextWidth(startText)
                : _getTextWidth(startText) / 2;
        final double refNextTextWidth = _getTextWidth(text) / 2;
        _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
        if (widget.labelOverflow == LegendLabelOverflow.ellipsis) {
          if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
            final double textWidth = refCurrentTextWidth + refNextTextWidth;
            startText = _getTrimText(startText, widget.textStyle!, slab,
                _textPainter, textWidth, refNextTextWidth);
          }
        }
      }

      _labels.add(_GradientBarLabel(startText,
          _getTextOffset(startText, i, length, slab), _isOverlapSegmentText));
    } else if (i < length - 1) {
      text = _getTrimmedText(text, i, length, slab, widget.items![i + 1].text);
    }

    // For range color mapper, slab is equals to the color mapper
    // length. So adding +1 to point out its position index.
    _labels.add(_GradientBarLabel(text,
        _getTextOffset(text, i + 1, length, slab), _isOverlapSegmentText));
  }

  String _getTrimmedText(String currentText, int index, int length, double slab,
      [String? nextText]) {
    if (widget.labelOverflow == LegendLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    if (_direction == Axis.horizontal &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      double refCurrentTextWidth;
      double refNextTextWidth;
      bool isLastInsideItem = false;
      if (index == length - 1) {
        refNextTextWidth = _getTextWidth(nextText) / 2;

        if (widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside) {
          refCurrentTextWidth = _getTextWidth(currentText);
          isLastInsideItem = true;
        } else {
          refCurrentTextWidth = _getTextWidth(currentText) / 2;
          isLastInsideItem = false;
        }
      } else {
        refCurrentTextWidth = _getTextWidth(currentText) / 2;
        refNextTextWidth = index + 1 == length - 1 &&
                widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
      if (widget.labelOverflow == LegendLabelOverflow.ellipsis &&
          _isOverlapSegmentText) {
        if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
          final double textWidth = refCurrentTextWidth + refNextTextWidth;
          return _getTrimText(currentText, widget.textStyle!, slab,
              _textPainter, textWidth, refNextTextWidth, isLastInsideItem);
        }
      }
    } else if (_direction == Axis.horizontal &&
        widget.labelsPlacement == LegendLabelsPlacement.onItem) {
      final double textWidth = _getTextWidth(currentText);
      _isOverlapSegmentText = textWidth > slab;
      if (_isOverlapSegmentText) {
        return _getTrimText(
            currentText, widget.textStyle!, slab, _textPainter, textWidth);
      }
    }

    return currentText;
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }

  List<String> _getStartSegmentLabel(LegendItem item) {
    if (item.text[0] == '{' &&
        widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      final List<String> splitText = item.text.split('},{');
      if (splitText.length > 1) {
        splitText[0] = splitText[0].replaceAll('{', '');
        splitText[1] = splitText[1].replaceAll('}', '');
      }

      return splitText;
    } else {
      return <String>[(item.text)];
    }
  }

  Offset _getTextOffset(
      String? text, int positionIndex, int length, double slab) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    final bool canAdjustLabelToCenter =
        widget.edgeLabelsPlacement == LegendEdgeLabelsPlacement.center &&
                (positionIndex == 0 || positionIndex == length) ||
            (positionIndex > 0 && positionIndex < length) ||
            widget.labelsPlacement == LegendLabelsPlacement.onItem;
    if (_direction == Axis.horizontal) {
      return _getHorizontalOffset(
          canAdjustLabelToCenter, positionIndex, slab, length);
    } else {
      final double referenceTextWidth = canAdjustLabelToCenter
          ? _textPainter.height / 2
          : (positionIndex == length ? _textPainter.height : 0.0);
      if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
        return Offset(0.0, slab * positionIndex - referenceTextWidth);
      }

      return Offset(
          0.0, (slab * positionIndex) - referenceTextWidth - slab / 2);
    }
  }

  Offset _getHorizontalOffset(
      bool canAdjustLabelToCenter, int positionIndex, double slab, int length) {
    if (_isRTL) {
      final double referenceTextWidth = canAdjustLabelToCenter
          ? -_textPainter.width / 2
          : (positionIndex == 0 ? -_textPainter.width : 0.0);
      double dx =
          _segmentSize.width - (slab * positionIndex - referenceTextWidth);

      if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
        return Offset(dx, 0.0);
      }

      dx = _segmentSize.width - (slab * positionIndex);

      return Offset(dx + slab / 2 - _textPainter.width / 2, 0.0);
    }

    final double referenceTextWidth = canAdjustLabelToCenter
        ? _textPainter.width / 2
        : (positionIndex == length ? _textPainter.width : 0.0);
    if (widget.labelsPlacement == LegendLabelsPlacement.betweenItems) {
      return Offset(slab * positionIndex - referenceTextWidth, 0.0);
    }

    return Offset(
        slab * positionIndex - _textPainter.width / 2 - slab / 2, 0.0);
  }

  Widget _buildGradientBar() {
    return _direction == Axis.horizontal
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getChildren())
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getChildren());
  }

  List<Widget> _getChildren() {
    double? labelBoxWidth = _segmentSize.width;
    double? labelBoxHeight;
    Alignment startAlignment = Alignment.centerLeft;
    Alignment endAlignment = Alignment.centerRight;

    if (_direction == Axis.vertical) {
      labelBoxWidth = null;
      labelBoxHeight = _segmentSize.height;
      startAlignment = Alignment.topCenter;
      endAlignment = Alignment.bottomCenter;
    }

    if (_isRTL && _direction == Axis.horizontal) {
      final Alignment temp = startAlignment;
      startAlignment = endAlignment;
      endAlignment = temp;
    }

    final ThemeData themeData = Theme.of(context);
    return <Widget>[
      if (widget.pointerSize != Size.zero &&
          (kIsWeb ||
              themeData.platform == TargetPlatform.macOS ||
              themeData.platform == TargetPlatform.windows ||
              themeData.platform == TargetPlatform.linux))
        _buildPointer(themeData),
      Container(
        width: _segmentSize.width,
        height: _segmentSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: startAlignment, end: endAlignment, colors: _colors),
        ),
      ),
      SizedBox(
          width: _direction == Axis.vertical ? 7.0 : 0.0,
          height: _direction == Axis.horizontal ? 7.0 : 0.0),
      SizedBox(
          width: labelBoxWidth, height: labelBoxHeight, child: _getLabels()),
    ];
  }

  Widget _buildPointer(ThemeData themeData) {
    Widget? current;
    Matrix4 matrix4;

    if (widget.pointerController!.position != null) {
      if (widget.pointerBuilder != null &&
          widget.pointerController!.colorValue != null) {
        current = SizedBox(
          width: widget.pointerSize!.width,
          height: widget.pointerSize!.height,
          child: widget.pointerBuilder!
              .call(context, widget.pointerController!.colorValue),
        );
      } else {
        current = CustomPaint(
          size: widget.pointerSize!,
          painter: _LegendIconShape(
            color: widget.pointerColor ??
                (themeData.brightness == Brightness.light
                    ? const Color.fromRGBO(0, 0, 0, 0.54)
                    : const Color.fromRGBO(255, 255, 255, 0.7)),
            iconType: ShapeMarkerType.invertedTriangle,
          ),
        );
      }

      if (_direction == Axis.horizontal) {
        matrix4 = Matrix4.identity()
          ..translate(
              widget.pointerController!.position!.dx * _segmentSize.width -
                  (widget.pointerSize!.width / 2));
        if (_isRTL) {
          matrix4.invert();
        }
        current = Transform(transform: matrix4, child: current);
      } else {
        current = RotatedBox(quarterTurns: 3, child: current);
        matrix4 = Matrix4.identity()
          ..translate(
              0.0,
              widget.pointerController!.position!.dy * _segmentSize.height -
                  (widget.pointerSize!.width / 2));
        current = Transform(transform: matrix4, child: current);
      }
    } else {
      current = _direction == Axis.horizontal
          ? SizedBox(
              height: widget.pointerSize!.height,
              width: widget.pointerSize!.width)
          : SizedBox(
              height: widget.pointerSize!.width,
              width: widget.pointerSize!.height);
    }

    return current;
  }

  Widget _getLabels() {
    return Stack(
      textDirection: TextDirection.ltr,
      children: List<Widget>.generate(_labels.length, (int index) {
        if ((widget.labelOverflow == LegendLabelOverflow.hide &&
                _labels[index].isOverlapping) ||
            _labels[index].label.isEmpty) {
          return const SizedBox(height: 0.0, width: 0.0);
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Transform.translate(
            offset: _labels[index].offset,
            child: Text(
              _labels[index].label,
              style: widget.textStyle,
              softWrap: false,
            ),
          ),
        );
      }),
    );
  }

  void _rebuild() {
    setState(() {
      // Rebuilding to update the legend pointer.
    });
  }

  @override
  void initState() {
    _colors = <Color>[];
    _labels = <_GradientBarLabel>[];
    widget.pointerController!.addListener(_rebuild);
    super.initState();
  }

  @override
  void dispose() {
    _colors.clear();
    _labels.clear();
    widget.pointerController!.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    _textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
    _direction = widget.direction ??
        (widget.position == LegendPosition.top ||
                widget.position == LegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    textDirection = _isRTL
        ? (_direction == Axis.vertical ? TextDirection.ltr : textDirection)
        : textDirection;

    final Widget child = Directionality(
      textDirection: textDirection,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            constraints.hasBoundedWidth ? constraints.maxWidth : 300;
        final double height =
            constraints.hasBoundedHeight ? constraints.maxHeight : 300;
        _updateSegmentSize(Size(width, height).shortestSide);
        _collectLabelsAndColors();
        return _buildGradientBar();
      }),
    );

    return child;
  }
}

class _GradientBarLabel {
  _GradientBarLabel(this.label,
      [this.offset = Offset.zero, this.isOverlapping = false]);

  String label;
  Offset offset;
  bool isOverlapping;
}

/// Controller for legend
class PointerController extends ChangeNotifier {
  /// Gets or Sets the pointer offset value.
  Offset? get position => _position;
  Offset? _position;
  set position(Offset? value) {
    if (_position == value) {
      return;
    }
    _position = value;
    notifyListeners();
  }

  /// Specifies the color value for the particular legend segment.
  dynamic colorValue;

  /// Specifies the hovered segment index to render the marker pointer
  /// on that particulat segment in case of Solid bar legend type.
  int? get segmentIndex => _segmentIndex;
  int? _segmentIndex;
  set segmentIndex(int? value) {
    if (_segmentIndex == value) {
      return;
    }
    previousSegmentIndex = _segmentIndex;
    _segmentIndex = value;
  }

  /// Sepcifies the previous hovered segment index to
  /// rebuild the older solid bar segment without marker pointer.
  int? previousSegmentIndex;
}
