import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart' as shape_helper;
import 'package:syncfusion_flutter_core/core.dart';

import '../utils/helper.dart';

/// Callback which is used to generate a widget legend item.
typedef LegendItemBuilder = Widget Function(BuildContext context, int index);

/// Callback which is used to pass the toggled details to target.
typedef LegendItemTapCallback = void Function(LegendItem, bool);

/// Callback which returns toggled indices and teh current toggled index.
typedef ToggledIndicesChangedCallback = void Function(
    List<int> indices, int currentIndex);

/// Called with the details of single legend item.
typedef ItemRenderCallback = void Function(ItemRendererDetails);

/// Signature to return a [Widget] for the given value.
typedef LegendPointerBuilder = Widget Function(
    BuildContext context, dynamic value);

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

/// Specifies the visibility of the legend.
enum LegendScrollbarVisibility {
  /// Denotes always visible.
  visible,

  /// Denotes always hidden.
  hidden,

  /// Denotes auto.
  auto,
}

/// The legend provider.
abstract class LegendItemProvider {
  /// Builds the legend item.
  List<LegendItem>? buildLegendItems(int index);

  /// Returns the legend icon type.
  ShapeMarkerType effectiveLegendIconType();
}

/// Details of single legend item.
class ItemRendererDetails {
  /// Creates [ItemRendererDetails].
  ItemRendererDetails({
    required this.item,
    required this.index,
    required this.text,
    required this.color,
    required this.iconType,
    required this.iconBorderColor,
    required this.iconBorderWidth,
  });

  /// Hold complete details about the item.
  final LegendItem item;

  /// Index of the legend item.
  final int index;

  /// Particular legend item text.
  String text;

  /// Particular legend icon color.
  Color? color;

  /// Particular legend icon type.
  ShapeMarkerType iconType;

  /// Border color of the icon.
  Color? iconBorderColor;

  /// Border width of the icon.
  double? iconBorderWidth;
}

/// Represents the class of items in legends.
class LegendItem {
  /// Creates a [LegendItem].
  LegendItem({
    required this.text,
    required this.iconType,
    required this.iconColor,
    required this.iconBorderWidth,
    this.iconBorderColor,
    this.shader,
    this.imageProvider,
    this.onTap,
    this.onRender,
    this.isToggled = false,
    this.overlayMarkerType,
    this.degree,
    this.endAngle,
    this.startAngle,
  });

  /// Specifies the text of the legend.
  final String text;

  /// Specifies the color of the icon.
  final Color iconColor;

  /// Specifies the border of the icon.
  final Color? iconBorderColor;

  /// Specifies the border width of icon.
  final double? iconBorderWidth;

  /// Specifies the shader of the icon.
  final Shader? shader;

  /// Identifies an image.
  final ImageProvider? imageProvider;

  /// Specifies the type of the icon.
  final ShapeMarkerType iconType;

  /// Specifies the overlay marker for cartesian line type icon.
  final ShapeMarkerType? overlayMarkerType;

  /// Specifies the start angle for radial bar icon.
  final double? startAngle;

  /// Specifies the degree for radial bar icon.
  final double? degree;

  /// Specifies the end angle for radial bar icon.
  final double? endAngle;

  /// Invoked when tapping the legend item.
  final LegendItemTapCallback? onTap;

  /// Specifies whether the current item is toggled.
  final bool isToggled;

  /// Invoked when the item is created.
  final ItemRenderCallback? onRender;

  /// Specifies the legend item is tapped.
  VoidCallback? onToggled;
}

/// The base layout for the legend dependents.
class LegendLayout extends StatefulWidget {
  /// Constructor for the [LegendLayout].
  const LegendLayout({
    Key? key,
    this.showLegend = false,
    this.padding = const EdgeInsets.all(10),
    this.backgroundImage,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.7,
    this.legendItems,
    this.legendItemBuilder,
    this.legendWidthFactor = 0.3,
    this.legendHeightFactor = 0.3,
    this.legendPosition = LegendPosition.top,
    this.legendWrapDirection = Axis.horizontal,
    this.legendOverflowMode = LegendOverflowMode.wrap,
    this.legendFloatingOffset,
    this.legendAlignment = LegendAlignment.center,
    this.legendTitleAlignment = LegendAlignment.center,
    this.legendBorderColor,
    this.legendBackgroundColor,
    this.legendBorderWidth = 1.0,
    this.legendTitle,
    this.itemsScrollDirection = Axis.vertical,
    this.itemInnerSpacing = 10.0,
    this.itemSpacing = 10.0,
    this.itemPadding = 0.0,
    this.itemRunSpacing = 6.0,
    this.itemIconHeight = 8.0,
    this.itemIconWidth = 8.0,
    this.itemOpacity = 1.0,
    this.itemIconBorderColor,
    this.itemIconBorderWidth,
    required this.itemTextStyle,
    this.scrollbarVisibility = LegendScrollbarVisibility.auto,
    this.enableToggling = false,
    this.toggledIconColor,
    this.toggledTextOpacity = 0.5,
    this.toggledItemColor,
    this.isResponsive = false,
    this.onTouchDown,
    this.onTouchMove,
    this.onTouchUp,
    required this.child,
  }) : super(key: key);

  /// Specifies whether to shows or hides the legend.
  final bool showLegend;

  /// Specifies the legend items.
  final List<LegendItem>? legendItems;

  /// Widget builder for legend items.
  final LegendItemBuilder? legendItemBuilder;

  /// Specifies the width of legend.
  final double legendWidthFactor;

  /// Specifies the height of legend.
  final double legendHeightFactor;

  /// Places the legend in custom position.
  final Offset? legendFloatingOffset;

  /// Positions the legend in the different directions.
  final LegendPosition legendPosition;

  /// Empty space inside the decoration.
  final EdgeInsets padding;

  /// Empty padding around the legend item.
  final double itemPadding;

  /// A border to draw surround the legend layout.
  final Color? borderColor;

  /// A border to draw surround the legend layout.
  final double borderWidth;

  /// Specifies the child.
  final Widget child;

  /// Specifies the alignment of legend.
  final LegendAlignment legendAlignment;

  /// The background image to the legend layout.
  final ImageProvider? backgroundImage;

  /// The background color to the legend.
  final Color? backgroundColor;

  /// A border color to the item icon.
  final Color? itemIconBorderColor;

  /// A border width to the item icon.
  final double? itemIconBorderWidth;

  /// A border to draw surround the legend.
  final Color? legendBorderColor;

  /// A legend background.
  final Color? legendBackgroundColor;

  /// A border to draw surround the legend.
  final double legendBorderWidth;

  /// Opacity of the item.
  final double itemOpacity;

  /// Specifies the space between the legend text and the icon.
  final double itemInnerSpacing;

  /// Specifies the cross axis run spacing for the wrapped elements.
  final double itemRunSpacing;

  /// Specifies the size of the legend icon.
  final double itemIconHeight;

  /// Specifies the size of the legend icon.
  final double itemIconWidth;

  /// Toggles the scrollbar visibility.
  final LegendScrollbarVisibility scrollbarVisibility;

  /// Customizes the legend item's text style.
  final TextStyle itemTextStyle;

  /// Avoid the legend rendering if its size is greater than its child.
  final bool isResponsive;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis legendWrapDirection;

  /// Scroll the legend items in either horizontal or vertical direction.
  final Axis? itemsScrollDirection;

  /// The title which provide a small note about the legends.
  final Widget? legendTitle;

  /// Specifies the alignment of legend title.
  final LegendAlignment legendTitleAlignment;

  /// Wraps or scrolls the legend items when it overflows.
  final LegendOverflowMode legendOverflowMode;

  /// Specifies the space between the each legend items.
  final double itemSpacing;

  /// Specifies whether to enable toggling.
  final bool enableToggling;

  /// Specifies the toggle item color.
  final Color? toggledIconColor;

  /// Specifies the toggle item's color. Applicable for vector builder.
  final Color? toggledItemColor;

  /// Specifies the toggle item's text color opacity.
  final double toggledTextOpacity;

  /// Called when touch down.
  final Function(Offset)? onTouchDown;

  /// Called when touch move.
  final Function(Offset)? onTouchMove;

  /// Called when touch up.
  final Function(Offset)? onTouchUp;

  @override
  State<StatefulWidget> createState() => LegendLayoutState();
}

/// State of [LegendLayout].
class LegendLayoutState extends State<LegendLayout> {
  late GlobalKey _legendKey;
  late GlobalKey _plotAreaKey;

  List<LegendItem>? _items;

  LegendPosition _effectiveLegendPosition(
      LegendPosition position, TextDirection direction) {
    if (position == LegendPosition.top || position == LegendPosition.bottom) {
      return position;
    }

    if (direction == TextDirection.rtl) {
      if (position == LegendPosition.left) {
        return LegendPosition.right;
      }
      if (position == LegendPosition.right) {
        return LegendPosition.left;
      }
    }

    return position;
  }

  /// Updates the new items to legend.
  void update(List<LegendItem> items) {
    _items = items;
    final RenderObjectElement? legendElement =
        _legendKey.currentContext as RenderObjectElement?;
    if (legendElement != null &&
        legendElement.mounted &&
        legendElement.renderObject.attached) {
      final RenderObject? renderObject = legendElement.findRenderObject();
      if (renderObject != null &&
          renderObject.attached &&
          renderObject is RenderConstrainedLayoutBuilder) {
        renderObject.markNeedsBuild();
      }
    }
  }

  @override
  void initState() {
    _legendKey = GlobalKey();
    _plotAreaKey = GlobalKey();
    _items = widget.legendItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget? legend = widget.showLegend
        ? LayoutBuilder(
            key: _legendKey,
            builder: (BuildContext context, BoxConstraints constraints) {
              return _buildLegend();
            },
          )
        : null;

    return _LegendLayoutHandler(
      onTouchDown: widget.onTouchDown,
      onTouchMove: widget.onTouchMove,
      onTouchUp: widget.onTouchUp,
      backgroundImage: widget.backgroundImage,
      legendBackgroundColor: widget.legendBackgroundColor,
      legendBorderColor: widget.legendBorderColor,
      legendBorderWidth: widget.legendBorderWidth,
      legendWidthFactor: widget.legendWidthFactor,
      legendHeightFactor: widget.legendHeightFactor,
      legendFloatingOffset: widget.legendFloatingOffset,
      legendPosition: _effectiveLegendPosition(
          widget.legendPosition, Directionality.of(context)),
      legendAlignment: widget.legendAlignment,
      padding: widget.padding,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      isResponsive: widget.isResponsive,
      legendTitleAlignment: widget.legendTitleAlignment,
      legendTitle: widget.legendTitle,
      legend: legend,
      // TODO(VijayakumarM): Testing needed.
      plotArea: KeyedSubtree(
        key: _plotAreaKey,
        child: widget.child,
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.itemPadding / 2),
      child: _VectorLegend(
        title: widget.legendTitle,
        items: _items,
        direction: widget.legendWrapDirection,
        itemSpacing: widget.itemSpacing,
        itemRunSpacing: widget.itemRunSpacing,
        overflowMode: widget.legendOverflowMode,
        scrollbarVisibility: widget.scrollbarVisibility,
        iconBorderColor: widget.itemIconBorderColor,
        iconBorderWidth: widget.itemIconBorderWidth,
        iconSize: Size(widget.itemIconWidth, widget.itemIconHeight),
        itemBuilder: widget.legendItemBuilder,
        spacing: widget.itemInnerSpacing,
        itemPadding: widget.itemPadding,
        textStyle: widget.itemTextStyle,
        enableToggling: widget.enableToggling,
        toggledIconColor: widget.toggledIconColor,
        toggledItemColor: widget.toggledItemColor,
        toggledTextOpacity: widget.toggledTextOpacity,
        itemIconOpacity: widget.itemOpacity,
      ),
    );
  }
}

enum _LegendSlot { legendTitle, legend, plotArea }

class _LegendLayoutHandler
    extends SlottedMultiChildRenderObjectWidget<_LegendSlot, RenderBox> {
  const _LegendLayoutHandler({
    Key? key,
    this.onTouchDown,
    this.onTouchMove,
    this.onTouchUp,
    this.backgroundImage,
    this.legendBackgroundColor,
    this.legendBorderColor,
    this.legendBorderWidth = 1.0,
    required this.legendWidthFactor,
    required this.legendHeightFactor,
    required this.legendFloatingOffset,
    required this.legendPosition,
    required this.legendAlignment,
    required this.legendTitleAlignment,
    required this.padding,
    required this.borderColor,
    required this.backgroundColor,
    required this.borderWidth,
    required this.isResponsive,
    required this.legendTitle,
    required this.legend,
    required this.plotArea,
  }) : super(key: key);

  final Function(Offset)? onTouchDown;
  final Function(Offset)? onTouchMove;
  final Function(Offset)? onTouchUp;
  final ImageProvider? backgroundImage;
  final Color? legendBackgroundColor;
  final Color? legendBorderColor;
  final double legendBorderWidth;
  final double legendWidthFactor;
  final double legendHeightFactor;
  final Offset? legendFloatingOffset;
  final LegendPosition legendPosition;
  final LegendAlignment legendAlignment;
  final LegendAlignment legendTitleAlignment;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool isResponsive;
  final Widget? legendTitle;
  final Widget? legend;
  final Widget? plotArea;

  @override
  _RenderLegendLayoutHandler createRenderObject(BuildContext context) {
    return _RenderLegendLayoutHandler(
        backgroundImage: backgroundImage,
        legendBackgroundColor: legendBackgroundColor,
        legendBorderColor: legendBorderColor,
        legendBorderWidth: legendBorderWidth,
        legendWidthFactor: legendWidthFactor,
        legendHeightFactor: legendHeightFactor,
        legendFloatingOffset: legendFloatingOffset,
        legendPosition: legendPosition,
        legendAlignment: legendAlignment,
        legendTitleAlignment: legendTitleAlignment,
        padding: padding,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        isResponsive: isResponsive)
      ..onTouchDown = onTouchDown
      ..onTouchMove = onTouchMove
      ..onTouchUp = onTouchUp;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderLegendLayoutHandler renderObject) {
    renderObject
      ..backgroundImage = backgroundImage
      ..legendBackgroundColor = legendBackgroundColor
      ..legendBorderColor = legendBorderColor
      ..legendBorderWidth = legendBorderWidth
      ..legendWidthFactor = legendWidthFactor
      ..legendHeightFactor = legendHeightFactor
      ..legendFloatingOffset = legendFloatingOffset
      ..legendPosition = legendPosition
      ..legendAlignment = legendAlignment
      ..legendTitleAlignment = legendTitleAlignment
      ..padding = padding
      ..backgroundColor = backgroundColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..isResponsive = isResponsive
      ..onTouchDown = onTouchDown
      ..onTouchMove = onTouchMove
      ..onTouchUp = onTouchUp;
  }

  @override
  Iterable<_LegendSlot> get slots => _LegendSlot.values;

  @override
  Widget? childForSlot(_LegendSlot slot) {
    switch (slot) {
      case _LegendSlot.legendTitle:
        return legendTitle;
      case _LegendSlot.legend:
        return legend;
      case _LegendSlot.plotArea:
        return plotArea;
    }
  }
}

class _LegendLayoutParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderLegendLayoutHandler extends RenderBox
    with SlottedContainerRenderObjectMixin<_LegendSlot, RenderBox> {
  _RenderLegendLayoutHandler({
    ImageProvider? backgroundImage,
    required Color? legendBackgroundColor,
    required Color? legendBorderColor,
    required double legendBorderWidth,
    required double legendWidthFactor,
    required double legendHeightFactor,
    required Offset? legendFloatingOffset,
    required LegendPosition legendPosition,
    required LegendAlignment legendAlignment,
    required LegendAlignment legendTitleAlignment,
    required EdgeInsets padding,
    required Color? backgroundColor,
    required Color? borderColor,
    required double borderWidth,
    required bool isResponsive,
  })  : _backgroundImage = backgroundImage,
        _legendBackgroundColor = legendBackgroundColor,
        _legendBorderColor = legendBorderColor,
        _legendBorderWidth = legendBorderWidth,
        _legendWidthFactor = legendWidthFactor,
        _legendHeightFactor = legendHeightFactor,
        _legendFloatingOffset = legendFloatingOffset,
        _isLegendFloating = legendFloatingOffset != null,
        _legendPosition = legendPosition,
        _legendAlignment = legendAlignment,
        _legendTitleAlignment = legendTitleAlignment,
        _padding = padding,
        _backgroundColor = backgroundColor,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _isResponsive = isResponsive {
    _fetchImage();
  }

  final double _spaceBetweenLegendAndPlotArea = 5.0;
  bool _legendNeedsPaint = false;
  bool _isLegendFloating = false;
  Image? _image;

  RenderBox? get legendTitle => childForSlot(_LegendSlot.legendTitle);
  RenderBox? get legend => childForSlot(_LegendSlot.legend);
  RenderBox? get plotArea => childForSlot(_LegendSlot.plotArea);

  Function(Offset)? onTouchDown;
  Function(Offset)? onTouchMove;
  Function(Offset)? onTouchUp;

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (plotArea != null) plotArea!,
      if (legendTitle != null) legendTitle!,
      if (legend != null) legend!,
    ];
  }

  Color? get legendBorderColor => _legendBorderColor;
  Color? _legendBorderColor;
  set legendBorderColor(Color? value) {
    if (_legendBorderColor != value) {
      _legendBorderColor = value;
      markNeedsPaint();
    }
  }

  ImageProvider? get backgroundImage => _backgroundImage;
  ImageProvider? _backgroundImage;
  set backgroundImage(ImageProvider? value) {
    if (_backgroundImage != value) {
      _backgroundImage = value;
      _fetchImage();
    }
  }

  Color? get legendBackgroundColor => _legendBackgroundColor;
  Color? _legendBackgroundColor;
  set legendBackgroundColor(Color? value) {
    if (_legendBackgroundColor != value) {
      _legendBackgroundColor = value;
      markNeedsPaint();
    }
  }

  double get legendBorderWidth => _legendBorderWidth;
  double _legendBorderWidth = 1.0;
  set legendBorderWidth(double value) {
    if (_legendBorderWidth != value) {
      _legendBorderWidth = value;
      markNeedsPaint();
    }
  }

  double get legendWidthFactor => _legendWidthFactor;
  double _legendWidthFactor = 0.3;
  set legendWidthFactor(double value) {
    if (_legendWidthFactor != value) {
      _legendWidthFactor = value;
      markNeedsLayout();
    }
  }

  double get legendHeightFactor => _legendHeightFactor;
  double _legendHeightFactor = 0.3;
  set legendHeightFactor(double value) {
    if (_legendHeightFactor != value) {
      _legendHeightFactor = value;
      markNeedsLayout();
    }
  }

  Offset? get legendFloatingOffset => _legendFloatingOffset;
  Offset? _legendFloatingOffset;
  set legendFloatingOffset(Offset? value) {
    if (_legendFloatingOffset != value) {
      _legendFloatingOffset = value;
      _isLegendFloating = value != null;
      markNeedsLayout();
    }
  }

  LegendPosition get legendPosition => _legendPosition;
  LegendPosition _legendPosition;
  set legendPosition(LegendPosition value) {
    if (_legendPosition != value) {
      _legendPosition = value;
      markNeedsLayout();
    }
  }

  LegendAlignment get legendAlignment => _legendAlignment;
  LegendAlignment _legendAlignment;
  set legendAlignment(LegendAlignment value) {
    if (_legendAlignment != value) {
      _legendAlignment = value;
      markNeedsLayout();
    }
  }

  LegendAlignment get legendTitleAlignment => _legendTitleAlignment;
  LegendAlignment _legendTitleAlignment;
  set legendTitleAlignment(LegendAlignment value) {
    if (_legendTitleAlignment != value) {
      _legendTitleAlignment = value;
      markNeedsLayout();
    }
  }

  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }

  Color? get backgroundColor => _backgroundColor;
  Color? _backgroundColor;
  set backgroundColor(Color? value) {
    if (_backgroundColor != value) {
      _backgroundColor = value;
      markNeedsPaint();
    }
  }

  Color? get borderColor => _borderColor;
  Color? _borderColor;
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  double get borderWidth => _borderWidth;
  double _borderWidth = 0.7;
  set borderWidth(double value) {
    if (_borderWidth != value) {
      _borderWidth = value;
      markNeedsPaint();
    }
  }

  bool get isResponsive => _isResponsive;
  bool _isResponsive = false;
  set isResponsive(bool value) {
    if (_isResponsive != value) {
      _isResponsive = value;
    }
  }

  void _fetchImage() {
    if (backgroundImage != null) {
      fetchImage(backgroundImage).then((Image? value) {
        _image = value;
        markNeedsPaint();
      });
    } else {
      _image = null;
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _LegendLayoutParentData) {
      child.parentData = _LegendLayoutParentData();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final Iterable<_LegendSlot> slots = _LegendSlot.values.reversed;
    for (final _LegendSlot slot in slots) {
      final RenderBox? child = childForSlot(slot);
      if (child != null) {
        final BoxParentData childParentData =
            child.parentData! as BoxParentData;
        final bool isHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - childParentData.offset);
            return child.hitTest(result, position: transformed);
          },
        );
        if (isHit) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  void performLayout() {
    if (plotArea == null) {
      size = constraints.biggest;
      return;
    }

    final double desiredWidth =
        constraints.maxWidth.isInfinite ? 300 : constraints.maxWidth;
    final double desiredHeight =
        constraints.maxHeight.isInfinite ? 300 : constraints.maxHeight;
    final double availableWidth = desiredWidth - padding.horizontal;
    final double availableHeight = desiredHeight - padding.vertical;

    Size legendSize = Size.zero;
    double widthFactor = legendWidthFactor;
    double heightFactor = legendHeightFactor;

    if (widthFactor.isNaN) {
      widthFactor = 1.0;
    }

    if (heightFactor.isNaN) {
      heightFactor = 1.0;
    }

    Size legendTitleSize = Size.zero;
    _legendNeedsPaint = legend != null;
    if (_legendNeedsPaint) {
      BoxConstraints legendConstraints = BoxConstraints(
        maxWidth: availableWidth * widthFactor,
        maxHeight: availableHeight * heightFactor,
      );

      if (legendTitle != null) {
        legendTitle!.layout(legendConstraints, parentUsesSize: true);
        legendTitleSize = legendTitle!.size;
      }

      legendConstraints = legendConstraints.copyWith(
        maxWidth: availableWidth,
        maxHeight: max(0, legendConstraints.maxHeight - legendTitleSize.height),
      );
      legend!.layout(legendConstraints, parentUsesSize: true);
      if (legend!.size.isEmpty && legendTitleSize.isEmpty) {
        legendSize = Size.zero;
        _legendNeedsPaint = false;
      } else {
        legendSize = legend!.size;
        _legendNeedsPaint = true;
      }

      legendSize = Size(
        max(legendSize.width, legendTitleSize.width),
        legendSize.height + legendTitleSize.height,
      );
    }

    final double gap = _isLegendFloating || legendSize.isEmpty
        ? 0
        : _spaceBetweenLegendAndPlotArea;
    late BoxConstraints plotAreaConstraints;
    if (_isLegendFloating) {
      plotAreaConstraints = BoxConstraints(
        maxWidth: availableWidth,
        maxHeight: availableHeight,
      );
    } else {
      switch (legendPosition) {
        case LegendPosition.left:
        case LegendPosition.right:
          final double plotAreaWidth = availableWidth - legendSize.width - gap;
          plotAreaConstraints = BoxConstraints(
            maxWidth: plotAreaWidth < 0 ? 0 : plotAreaWidth,
            maxHeight: availableHeight,
          );
          break;

        case LegendPosition.top:
        case LegendPosition.bottom:
          final double plotAreaHeight =
              availableHeight - legendSize.height - gap;
          plotAreaConstraints = BoxConstraints(
            maxWidth: availableWidth,
            maxHeight: plotAreaHeight < 0 ? 0 : plotAreaHeight,
          );
          break;
      }
      if (isResponsive) {
        if (plotAreaConstraints.maxWidth < legendSize.width ||
            (plotAreaConstraints.maxHeight < legendSize.height ||
                legend!.size.height == 0)) {
          _legendNeedsPaint = false;
          plotAreaConstraints = BoxConstraints(
            maxWidth: availableWidth,
            maxHeight: availableHeight,
          );
        }
      }
    }

    plotArea!.layout(plotAreaConstraints, parentUsesSize: true);
    _alignChildren(
        legendSize, legendTitleSize, availableWidth, availableHeight);

    size = Size(desiredWidth, desiredHeight);
  }

  void _alignChildren(Size legendSize, Size legendTitleSize,
      double availableWidth, double availableHeight) {
    final double gap = _isLegendFloating || legendSize.isEmpty
        ? 0
        : _spaceBetweenLegendAndPlotArea;
    final BoxParentData plotAreaParentData =
        plotArea!.parentData! as BoxParentData;
    if (_legendNeedsPaint) {
      final BoxParentData legendParentData =
          legend!.parentData! as BoxParentData;
      final BoxParentData? legendTitleParentData =
          legendTitle?.parentData! as BoxParentData?;

      Size legendAreaSize;
      switch (legendPosition) {
        case LegendPosition.left:
        case LegendPosition.right:
          legendAreaSize = Size(
            legendSize.width,
            availableHeight,
          );
          break;

        case LegendPosition.top:
        case LegendPosition.bottom:
          legendAreaSize = Size(
            availableWidth,
            legendSize.height,
          );
          break;
      }

      if (_isLegendFloating) {
        plotAreaParentData.offset = padding.topLeft;

        final Alignment alignmentForLegend = _effectiveLegendAlignment();
        legendParentData.offset = alignmentForLegend
            .alongOffset(legendAreaSize - legendSize as Offset);
        switch (legendPosition) {
          case LegendPosition.left:
            legendParentData.offset += padding.topLeft;
            break;

          case LegendPosition.top:
            legendParentData.offset += padding.topLeft;
            break;

          case LegendPosition.right:
            legendParentData.offset = Offset(
                plotArea!.size.width - legendSize.width - padding.left - gap,
                legendParentData.offset.dy + padding.top);
            break;

          case LegendPosition.bottom:
            legendParentData.offset = Offset(
                legendParentData.offset.dx + padding.left,
                plotArea!.size.height - legendSize.height - padding.top);
            break;
        }

        legendTitleParentData?.offset = legendParentData.offset;
        legendParentData.offset = legendParentData.offset.translate(
            legendFloatingOffset!.dx,
            legendFloatingOffset!.dy + legendTitleSize.height);

        //Edge detection for legend.
        Offset legendOffset = legendParentData.offset;
        Offset legendTitleOffset = legendTitleParentData != null
            ? legendTitleParentData.offset
            : Offset.zero;
        final Offset parentOffset = plotAreaParentData.offset;
        if (legendOffset.dx < parentOffset.dx) {
          legendOffset = Offset(parentOffset.dx, legendOffset.dy);
          legendTitleOffset = Offset(legendOffset.dx, legendTitleOffset.dy);
        } else if ((legendOffset.dx + (legendSize.width + padding.left + gap)) >
            plotArea!.size.width) {
          legendOffset =
              Offset(plotArea!.size.width - legendSize.width, legendOffset.dy);
          legendTitleOffset = Offset(legendOffset.dx, legendTitleOffset.dy);
        }

        if (legendOffset.dy < parentOffset.dy) {
          legendOffset = Offset(legendOffset.dx, parentOffset.dy);
          legendTitleOffset = Offset(legendTitleOffset.dx, legendOffset.dy);
        } else if ((legendOffset.dy + (legendSize.height + padding.top + gap)) >
            plotArea!.size.height) {
          legendOffset = Offset(legendOffset.dx,
              plotArea!.size.height - legendSize.height + padding.top);
          legendTitleOffset = Offset(legendTitleOffset.dx, legendOffset.dy);
        }
        legendParentData.offset = legendOffset;
        legendTitleParentData?.offset = legendTitleOffset +
            _legendTitleAlignmentOffset(
                    legendTitleAlignment, legendTitleSize, legendSize)
                .translate(
                    legendPosition == LegendPosition.right
                        ? 0
                        : legendFloatingOffset!.dx,
                    legendPosition == LegendPosition.bottom
                        ? 0
                        : legendFloatingOffset!.dy);
      } else {
        final Alignment alignmentForLegend = _effectiveLegendAlignment();
        legendParentData.offset = alignmentForLegend
            .alongOffset(legendAreaSize - legendSize as Offset);
        final Size legendPortionFromAvailableSize =
            _isLegendFloating ? Size.zero : legendSize;
        switch (legendPosition) {
          case LegendPosition.left:
            legendParentData.offset += padding.topLeft;
            plotAreaParentData.offset = Offset(
                padding.left + legendPortionFromAvailableSize.width + gap,
                padding.top);
            break;

          case LegendPosition.top:
            legendParentData.offset += padding.topLeft;
            plotAreaParentData.offset = Offset(padding.left,
                padding.top + legendPortionFromAvailableSize.height + gap);
            break;

          case LegendPosition.right:
            legendParentData.offset +=
                Offset(padding.left + plotArea!.size.width + gap, padding.top);
            plotAreaParentData.offset = Offset(padding.left, padding.top);
            break;

          case LegendPosition.bottom:
            legendParentData.offset +=
                Offset(padding.left, padding.top + plotArea!.size.height + gap);
            plotAreaParentData.offset = Offset(padding.left, padding.top);
            break;
        }

        legendTitleParentData?.offset = legendParentData.offset +
            _legendTitleAlignmentOffset(
                legendTitleAlignment, legendTitleSize, legendSize);
        legendParentData.offset =
            legendParentData.offset.translate(0.0, legendTitleSize.height);
      }
    } else {
      plotAreaParentData.offset = padding.topLeft;
    }
  }

  Offset _legendTitleAlignmentOffset(
      LegendAlignment alignment, Size titleSize, Size areaSize) {
    switch (alignment) {
      case LegendAlignment.near:
        return Offset.zero;
      case LegendAlignment.center:
        return Offset(max(0.0, areaSize.width / 2 - titleSize.width / 2), 0.0);
      case LegendAlignment.far:
        return Offset(max(0.0, areaSize.width - titleSize.width), 0.0);
    }
  }

  Alignment _effectiveLegendAlignment() {
    switch (legendPosition) {
      case LegendPosition.left:
      case LegendPosition.right:
        switch (legendAlignment) {
          case LegendAlignment.near:
            return Alignment.topLeft;
          case LegendAlignment.center:
            return Alignment.centerLeft;
          case LegendAlignment.far:
            return Alignment.bottomLeft;
        }

      case LegendPosition.bottom:
      case LegendPosition.top:
        switch (legendAlignment) {
          case LegendAlignment.near:
            return Alignment.topLeft;
          case LegendAlignment.center:
            return Alignment.topCenter;
          case LegendAlignment.far:
            return Alignment.topRight;
        }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (plotArea == null) {
      return;
    }

    if (backgroundColor != null && backgroundColor != Colors.transparent) {
      context.canvas.drawRect(
        paintBounds,
        Paint()
          ..isAntiAlias = true
          ..color = backgroundColor!,
      );
    }

    if (_image != null) {
      paintImage(
        canvas: context.canvas,
        rect: paintBounds,
        image: _image!,
        fit: BoxFit.fill,
      );
    }

    if (borderColor != null &&
        borderColor != Colors.transparent &&
        borderWidth > 0) {
      context.canvas.drawRect(
        paintBounds.deflate(borderWidth / 2),
        Paint()
          ..isAntiAlias = true
          ..color = borderColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke,
      );
    }

    if (!_isLegendFloating && _legendNeedsPaint) {
      _drawLegendBackgroundAndBorder(context, offset);
      _paintLegend(context, offset);
    }

    final BoxParentData plotAreaParentData =
        plotArea!.parentData! as BoxParentData;
    context.paintChild(plotArea!, offset + plotAreaParentData.offset);

    if (_isLegendFloating && _legendNeedsPaint) {
      _drawLegendBackgroundAndBorder(context, offset);
      _paintLegend(context, offset);
    }
  }

  void _drawLegendBackgroundAndBorder(PaintingContext context, Offset offset) {
    if (legend != null) {
      final bool canDrawLegendBackground = legendBackgroundColor != null &&
          legendBackgroundColor != Colors.transparent;
      final bool canDrawLegendBorder = legendBorderColor != null &&
          legendBorderColor != Colors.transparent &&
          legendBorderWidth > 0;
      if (canDrawLegendBackground || canDrawLegendBorder) {
        Size legendSize = legend!.size;
        final BoxParentData legendParentData =
            legend!.parentData! as BoxParentData;
        final Rect legendBounds = legendParentData.offset & legend!.size;
        Offset legendTitleOffset = legendParentData.offset;
        if (legendTitle != null) {
          legendTitleOffset =
              (legendTitle!.parentData! as BoxParentData).offset;
          legendSize = Size(
              legendSize.width, legendTitle!.size.height + legendSize.height);
        }

        final Rect bounds = Rect.fromLTWH(
            legendBounds.left + offset.dx,
            legendTitleOffset.dy + offset.dy,
            legendSize.width,
            legendSize.height);
        if (canDrawLegendBackground) {
          context.canvas
              .drawRect(bounds, Paint()..color = legendBackgroundColor!);
        }

        if (canDrawLegendBorder) {
          context.canvas.drawRect(
            bounds.deflate(legendBorderWidth / 2),
            Paint()
              ..color = legendBorderColor!
              ..strokeWidth = legendBorderWidth
              ..style = PaintingStyle.stroke,
          );
        }
      }
    }
  }

  void _paintLegend(PaintingContext context, Offset offset) {
    if (legendTitle != null) {
      final BoxParentData legendTitleParentData =
          legendTitle!.parentData! as BoxParentData;
      context.paintChild(legendTitle!, offset + legendTitleParentData.offset);
    }

    final BoxParentData legendParentData = legend!.parentData! as BoxParentData;
    context.paintChild(legend!, offset + legendParentData.offset);
  }
}

class _VectorLegend extends StatefulWidget {
  const _VectorLegend({
    required this.title,
    required this.items,
    required this.direction,
    required this.iconBorderColor,
    required this.iconBorderWidth,
    required this.iconSize,
    required this.itemBuilder,
    required this.spacing,
    required this.itemSpacing,
    required this.itemPadding,
    required this.itemRunSpacing,
    required this.overflowMode,
    required this.scrollbarVisibility,
    required this.textStyle,
    required this.enableToggling,
    required this.toggledIconColor,
    required this.toggledItemColor,
    required this.toggledTextOpacity,
    required this.itemIconOpacity,
  });

  /// Specifies the legend title.
  final Widget? title;

  /// Specifies the legend items.
  final List<LegendItem>? items;

  /// Specifies the size of the legend icon.
  final Size iconSize;

  /// Specifies border color of the icon.
  final Color? iconBorderColor;

  /// Specifies border width of the icon.
  final double? iconBorderWidth;

  /// Customizes the legend item's text style.
  final TextStyle textStyle;

  /// Specifies the space between the legend text and the icon.
  final double spacing;

  /// Specifies the toggle item's text color opacity.
  final double itemIconOpacity;

  /// Specifies the toggle item's text color opacity.
  final double toggledTextOpacity;

  /// Wraps or scrolls the legend items when it overflows.
  final LegendOverflowMode overflowMode;

  /// Toggles the scrollbar visibility.
  final LegendScrollbarVisibility scrollbarVisibility;

  /// Widget builder for legend items.
  final IndexedWidgetBuilder? itemBuilder;

  /// Specifies whether to enable toggling.
  final bool enableToggling;

  /// Specifies the toggle item color.
  final Color? toggledIconColor;

  /// Specifies the toggle item's color. Applicable for vector builder.
  final Color? toggledItemColor;

  /// Specifies the space between the each legend items.
  final double itemSpacing;

  /// Specifies the cross axis run spacing for the wrapped elements.
  final double itemRunSpacing;

  /// Surrounding padding.
  final double itemPadding;

  /// Arranges the legend items in either horizontal or vertical direction.
  final Axis direction;

  @override
  State<_VectorLegend> createState() => _VectorLegendState();
}

class _VectorLegendState extends State<_VectorLegend> {
  ScrollController? _controller;

  List<Widget> _buildLegendItems(BuildContext context) {
    final List<Widget> legendItems = <Widget>[];
    if (widget.items != null) {
      final int length = widget.items!.length;
      for (int i = 0; i < length; i++) {
        final LegendItem item = widget.items![i];
        legendItems.add(_IconText(
          details: item,
          index: i,
          itemBuilder: widget.itemBuilder,
          padding: EdgeInsets.all(widget.itemPadding / 2),
          textStyle: widget.textStyle,
          iconSize: widget.iconSize,
          iconBorderColor: widget.iconBorderColor,
          iconBorderWidth: widget.iconBorderWidth,
          spacing: widget.spacing,
          iconOpacity: widget.itemIconOpacity,
          toggleEnabled: widget.enableToggling,
          isToggled: item.isToggled,
          toggledColor: _effectiveToggledColor(context),
          toggledTextOpacity: widget.toggledTextOpacity,
          onTap: item.onTap,
          overlayMarkerType: item.overlayMarkerType,
          degree: item.degree,
          startAngle: item.startAngle,
          endAngle: item.endAngle,
        ));
      }
    }

    return legendItems;
  }

  Color? _effectiveToggledColor(BuildContext context) {
    Color? toggledColor;
    if (widget.enableToggling) {
      toggledColor = widget.toggledIconColor ?? widget.toggledItemColor;
      if (toggledColor == null || toggledColor == Colors.transparent) {
        toggledColor = Theme.of(context).brightness == Brightness.light
            ? const Color.fromRGBO(230, 230, 230, 1)
            : const Color.fromRGBO(66, 66, 66, 1);
      }
    }

    return toggledColor;
  }

  Widget _wrapWithWrap(List<Widget> items) {
    final double horizontalPadding = widget.itemPadding / 2;
    return Padding(
      padding:
          EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
      child: Wrap(
        direction: widget.direction,
        spacing: widget.itemSpacing,
        runSpacing: widget.itemRunSpacing,
        runAlignment: WrapAlignment.center,
        children: items,
      ),
    );
  }

  Widget _wrapWithScrollable(Widget current, BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: _scrollDirection(),
        child: current,
      ),
    );
  }

  Axis _scrollDirection() {
    switch (widget.overflowMode) {
      case LegendOverflowMode.scroll:
        return widget.direction;

      case LegendOverflowMode.wrapScroll:
        switch (widget.direction) {
          case Axis.horizontal:
            return Axis.vertical;

          case Axis.vertical:
            return Axis.horizontal;
        }

      case LegendOverflowMode.wrap:
      case LegendOverflowMode.none:
        return Axis.vertical;
    }
  }

  Widget _wrapWithDirectional(List<Widget> items) {
    switch (widget.direction) {
      case Axis.horizontal:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );

      case Axis.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );
    }
  }

  @override
  void initState() {
    if (widget.scrollbarVisibility != LegendScrollbarVisibility.hidden) {
      _controller = ScrollController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = _buildLegendItems(context);
    Widget current;
    switch (widget.overflowMode) {
      case LegendOverflowMode.wrap:
      case LegendOverflowMode.wrapScroll:
        current = _wrapWithWrap(items);
        break;

      case LegendOverflowMode.scroll:
        current = _wrapWithDirectional(items);
        break;

      case LegendOverflowMode.none:
        current = SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: widget.direction,
          child: _wrapWithDirectional(items),
        );
        break;
    }

    switch (widget.overflowMode) {
      case LegendOverflowMode.scroll:
      case LegendOverflowMode.wrapScroll:
        current = _wrapWithScrollable(current, context);
        break;

      case LegendOverflowMode.wrap:
      case LegendOverflowMode.none:
        break;
    }

    switch (widget.scrollbarVisibility) {
      case LegendScrollbarVisibility.visible:
      case LegendScrollbarVisibility.auto:
        final double scrollbarThickness =
            defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android
                ? 4.0
                : 5.0;
        current = Scrollbar(
          controller: _controller,
          thickness: scrollbarThickness,
          thumbVisibility:
              widget.scrollbarVisibility == LegendScrollbarVisibility.visible,
          child: current,
        );
        break;

      case LegendScrollbarVisibility.hidden:
        break;
    }

    return current;
  }
}

/// Represents the class for generating legend item.
class _IconText extends StatefulWidget {
  /// Creates a [_IconText].
  const _IconText({
    required this.details,
    required this.index,
    this.itemBuilder,
    required this.padding,
    required this.textStyle,
    required this.iconSize,
    required this.iconBorderColor,
    required this.iconBorderWidth,
    required this.spacing,
    required this.toggleEnabled,
    this.toggledColor,
    required this.toggledTextOpacity,
    required this.isToggled,
    required this.iconOpacity,
    this.onTap,
    this.overlayMarkerType,
    this.degree,
    this.startAngle,
    this.endAngle,
  });

  /// Hold item details.
  final LegendItem details;

  /// Specifies the item index.
  final int index;

  /// Widget builder for legend item.
  final IndexedWidgetBuilder? itemBuilder;

  /// Specifies the padding for the legend item.
  final EdgeInsets padding;

  /// Specifies the style of the text.
  final TextStyle textStyle;

  /// Specifies the size of the legend icon.
  final Size iconSize;

  /// Specifies the border color of the icon.
  final Color? iconBorderColor;

  /// Specifies the border width of the icon.
  final double? iconBorderWidth;

  /// Specifies the space between the legend text and the icon.
  final double spacing;

  /// Specifies whether to handle toggling.
  final bool toggleEnabled;

  /// Specifies whether the current item is toggled.
  final bool isToggled;

  /// Specifies the toggled item color.
  final Color? toggledColor;

  /// Specifies the toggle item's text color opacity.
  final double toggledTextOpacity;

  /// Specifies the toggle item's text color opacity.
  final double iconOpacity;

  /// Invokes while tapping the legend item.
  final LegendItemTapCallback? onTap;

  /// Specifies the overlay marker  for cartesian line type icon.
  final ShapeMarkerType? overlayMarkerType;

  /// Specifies the start angle for radial bar icon.
  final double? startAngle;

  /// Specifies the degree for radial bar icon.
  final double? degree;

  /// Specifies the end angle for radial bar icon.
  final double? endAngle;

  @override
  _IconTextState createState() => _IconTextState();
}

class _IconTextState extends State<_IconText>
    with SingleTickerProviderStateMixin {
  late AnimationController _toggleAnimationController;
  late Animation<double> _toggleAnimation;
  late ColorTween _iconColorTween;
  late ColorTween _shaderMaskColorTween;
  late Tween<double> _opacityTween;

  ImageInfo? _imageInfo;
  ImageStream? _imageStream;
  Completer<ImageInfo>? _completer;
  Future<ui.Image?>? _obtainImage;
  bool _isToggled = false;

  Widget _buildCustomPaint(
      ItemRendererDetails details, AsyncSnapshot<ui.Image?> snapshot) {
    Widget current = CustomPaint(
      size: widget.iconSize,
      painter: _LegendIconShape(
        color: details.color!.withOpacity(widget.iconOpacity),
        iconType: details.iconType,
        iconBorderColor: details.iconBorderColor,
        iconBorderWidth: details.iconBorderWidth,
        image: snapshot.data,
        shader: widget.details.shader,
        overlayMarkerType: widget.overlayMarkerType,
        degree: widget.degree,
        startAngle: widget.startAngle,
        endAngle: widget.endAngle,
      ),
    );

    if (widget.details.shader != null &&
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

  Future<ui.Image?>? _retrieveImageFromProvider() async {
    if (widget.details.iconType != ShapeMarkerType.image ||
        widget.details.imageProvider == null) {
      return null;
    }

    _completer = Completer<ImageInfo>();
    _imageStream?.removeListener(imageStreamListener(_completer!));
    _imageStream =
        widget.details.imageProvider!.resolve(ImageConfiguration.empty);
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

  void _handleTapUp(TapUpDetails details) {
    widget.onTap?.call(widget.details, !_isToggled);
  }

  void _onToggled() {
    _isToggled = !_isToggled;
    if (_isToggled) {
      _toggleAnimationController.forward();
    } else {
      _toggleAnimationController.reverse();
    }
  }

  @override
  void initState() {
    _toggleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _toggleAnimationController.addListener(rebuild);
    _toggleAnimation = CurvedAnimation(
        parent: _toggleAnimationController, curve: Curves.easeInOut);

    final Color begin =
        widget.details.shader == null && widget.details.imageProvider == null
            ? widget.details.iconColor
            : Colors.transparent;
    _iconColorTween = ColorTween(begin: begin, end: widget.toggledColor);
    _shaderMaskColorTween = ColorTween(end: widget.toggledColor);
    _opacityTween = Tween<double>(begin: 1.0, end: widget.toggledTextOpacity);

    _isToggled = widget.isToggled;
    _toggleAnimationController.value = _isToggled ? 1.0 : 0.0;

    _obtainImage = _retrieveImageFromProvider();
    widget.details.onToggled = _onToggled;
    super.initState();
  }

  @override
  void didUpdateWidget(_IconText oldWidget) {
    if (widget.details.iconColor != oldWidget.details.iconColor ||
        widget.details.shader != oldWidget.details.shader) {
      _iconColorTween.begin =
          widget.details.shader == null && widget.details.imageProvider == null
              ? widget.details.iconColor
              : Colors.transparent;
    }

    if (widget.toggledColor != null &&
        widget.toggledColor != oldWidget.toggledColor) {
      _iconColorTween.end = widget.toggledColor;
      _shaderMaskColorTween.end = widget.toggledColor;
    }

    if (widget.toggledTextOpacity != oldWidget.toggledTextOpacity) {
      _opacityTween = Tween<double>(begin: 1.0, end: widget.toggledTextOpacity);
    }

    if (widget.details.imageProvider != oldWidget.details.imageProvider) {
      _obtainImage = _retrieveImageFromProvider();
    }

    widget.details.onToggled = _onToggled;
    if (widget.isToggled != oldWidget.isToggled) {
      _isToggled = widget.isToggled;
      _toggleAnimationController.value = _isToggled ? 1.0 : 0.0;
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
    // TODO(VijayakumarM): Avoid always wrapping into [FutureBuilder].
    return FutureBuilder<ui.Image?>(
      future: _obtainImage,
      builder: (BuildContext context, AsyncSnapshot<ui.Image?> snapshot) {
        Widget current;
        if (widget.itemBuilder != null) {
          current = widget.itemBuilder!.call(context, widget.index);
          final Color? color = _shaderMaskColorTween.evaluate(_toggleAnimation);
          if (color != null) {
            current = _buildShaderMask(color, current);
          }
        } else {
          final Color? effectiveIconColor =
              _iconColorTween.evaluate(_toggleAnimation);
          final ItemRendererDetails details = ItemRendererDetails(
            item: widget.details,
            index: widget.index,
            text: widget.details.text,
            color: effectiveIconColor,
            iconType: widget.details.iconType,
            iconBorderColor:
                widget.iconBorderColor ?? widget.details.iconBorderColor,
            iconBorderWidth:
                widget.iconBorderWidth ?? widget.details.iconBorderWidth,
          );
          widget.details.onRender?.call(details);
          if (effectiveIconColor != null &&
              effectiveIconColor != details.color) {
            _iconColorTween.begin = details.color;
            details.color = _iconColorTween.evaluate(_toggleAnimation);
          }
          current = SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildCustomPaint(details, snapshot),
                SizedBox(width: widget.spacing),
                Text(
                  details.text,
                  style: widget.textStyle.copyWith(
                    color: widget.textStyle.foreground == null
                        ? widget.textStyle.color!.withOpacity(
                            _opacityTween.evaluate(_toggleAnimation))
                        : widget.textStyle.foreground!.color,
                  ),
                )
              ],
            ),
          );
        }

        current = Padding(
          padding: widget.padding,
          child: current,
        );

        if (widget.toggleEnabled) {
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
  /// Represents [_LegendIconShape]
  _LegendIconShape({
    this.color,
    this.iconType = ShapeMarkerType.circle,
    this.iconBorderColor,
    this.iconBorderWidth,
    this.image,
    this.shader,
    this.overlayMarkerType,
    this.degree,
    this.startAngle,
    this.endAngle,
  });

  /// Specifies the color of the icon.
  final Color? color;

  /// Specifies the icon type.
  final ShapeMarkerType iconType;

  /// Specifies the border color of the icon.
  final Color? iconBorderColor;

  /// Specifies the border width of the icon.
  final double? iconBorderWidth;

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
    final Paint paint = Paint()..strokeWidth = iconBorderWidth ?? 1;
    if (shader != null) {
      paint.shader = shader;
    } else if (color != null) {
      paint.color = color!;
    }

    return paint;
  }

  Paint? _getStrokePaint() {
    return Paint()
      ..color = iconBorderColor ?? Colors.transparent
      ..strokeWidth = iconBorderWidth ?? 1
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (iconType == ShapeMarkerType.image && image != null) {
      paintImage(canvas: canvas, rect: Offset.zero & size, image: image!);
    } else {
      shape_helper.paint(
        canvas: canvas,
        rect: Offset.zero & size,
        shapeType: iconType,
        paint: _getFillPaint(),
        borderPaint: _getStrokePaint(),
        overlayMarkerType: overlayMarkerType,
        degree: degree,
        startAngle: startAngle,
        endAngle: endAngle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
