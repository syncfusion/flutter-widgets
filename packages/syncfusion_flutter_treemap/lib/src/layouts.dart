import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart';

import '../src/legend.dart';
import '../treemap.dart';
import 'animated_border.dart';
import 'controller.dart';
import 'tooltip.dart';

// Combines the two color values and returns a new saturated color. We have
// used black color as default mix color.
Color _getSaturatedColor(Color color, double factor,
    [Color mix = Colors.black]) {
  return color == Colors.transparent
      ? color
      : Color.fromRGBO(
          ((1 - factor) * color.red + factor * mix.red).toInt(),
          ((1 - factor) * color.green + factor * mix.green).toInt(),
          ((1 - factor) * color.blue + factor * mix.blue).toInt(),
          1);
}

/// Ignored scaling to the label builder and item builder and provides the
/// opacity animation.
Widget _buildAnimatedBuilder(
    TreemapTile tile, Size scale, AnimationStatus status, Widget child) {
  Size gap = Size.zero;
  if (tile.level.border != null) {
    gap = Size(tile.level.border!.dimensions.horizontal,
        tile.level.border!.dimensions.vertical);
  }

  if (tile.level.padding != null) {
    gap = Size(tile.level.padding!.horizontal + gap.width,
        tile.level.padding!.vertical + gap.height);
  }

  child = Transform(
    transform: Matrix4.identity()..scale(1.0 / scale.width, 1.0 / scale.height),
    child: child,
  );

  double width;
  double height;
  // We have to increase the label/item builder's size while drilling down
  // to maintain its position so used [OverflowBox].
  if (scale.width < 1 || scale.height < 1) {
    width = scale.width < 1
        ? tile._size!.width * scale.width - gap.width
        : tile._size!.width - gap.width;
    height = scale.height < 1
        ? tile._size!.height * scale.height - gap.height
        : tile._size!.height - gap.height;
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        // If the tile size is smaller than padding or border, it will
        // return a negative value.  When we using negative value to the
        // [SizedBox], we get box constraints issue. For that, we set the width
        // and height is 0.0 to the sized box when the width or height having a
        // negative value.
        width: width > 0 ? width : 0.0,
        height: height > 0 ? height : 0.0,
        child: child,
      ),
    );
  } else {
    width = scale.width > 1
        ? tile._size!.width * scale.width - gap.width
        : tile._size!.width - gap.width;
    height = scale.height > 1
        ? tile._size!.height * scale.height - gap.height
        : tile._size!.height - gap.height;
    return OverflowBox(
        alignment: Alignment.topLeft,
        maxHeight: height > 0 ? height : 0.0,
        maxWidth: width > 0 ? width : 0.0,
        child: child);
  }
}

Widget? _buildLabeAndItemBuilder(
    Widget current,
    TreemapTile tile,
    int visibleIndex,
    AnimationStatus animationStatus,
    Animation<double> scalingAndTranslationAnimation,
    Animation<double> opacityAnimation,
    Tween<Size> currentLevelScale,
    Tween<Size> nextLevelScale,
    Tween<double> tileOpacity,
    Tween<double> labelAndItemBuilderOpacity) {
  Size? scaleSize;
  if (animationStatus == AnimationStatus.forward &&
      visibleIndex == tile._levelIndex) {
    // If we set align property to the label builder the label builder size
    // is gets tile size. If we scale tile the label builder size is not
    // increased. So the label builder align improper position. For than we
    //need to increase the label builder size.
    return Opacity(
      opacity: tileOpacity.evaluate(opacityAnimation),
      child: _buildAnimatedBuilder(
          tile,
          currentLevelScale.evaluate(scalingAndTranslationAnimation),
          animationStatus,
          current),
    );
  } else if (animationStatus == AnimationStatus.reverse) {
    if (visibleIndex == tile._levelIndex) {
      scaleSize = nextLevelScale.evaluate(scalingAndTranslationAnimation);
      scaleSize = scaleSize.width > scaleSize.height
          ? Size(scaleSize.width / scaleSize.width,
              scaleSize.height / scaleSize.width)
          : Size(scaleSize.width / scaleSize.height,
              scaleSize.height / scaleSize.height);
      return Opacity(
        opacity:
            labelAndItemBuilderOpacity.evaluate(scalingAndTranslationAnimation),
        child: _buildAnimatedBuilder(tile, scaleSize, animationStatus, current),
      );
    } else {
      current = _buildAnimatedBuilder(
          tile,
          currentLevelScale.evaluate(scalingAndTranslationAnimation),
          animationStatus,
          current);
      if (tile._isDrilled) {
        current = Opacity(
          opacity: tileOpacity.evaluate(opacityAnimation),
          child: current,
        );
      }
    }
  }

  return current;
}

/// Specifies the kind of pointer.
enum PointerKind {
  /// Indicates the pointer kind as touch.
  touch,

  /// Indicates the pointer kind as hover.
  hover
}

/// The [SfTreemap]'s layout type.
enum LayoutType {
  /// Squarified layout.
  squarified,

  /// Slice layout.
  slice,

  /// Dice layout.
  dice
}

/// Contains information about the treemap tile.
class TreemapTile {
  TreemapTile._();

  /// Name of the tile group. This is the value returned in the
  /// [TreemapLevel.groupMapper].
  String get group => _group;
  late String _group;

  /// Contains the indices of the data source which forms this tile.
  List<int> get indices => _indices;
  late List<int> _indices;

  /// Weight of the respected tile.
  double get weight => _weight;
  late double _weight;

  /// Color of the tile.
  Color get color => _color;
  late Color _color;

  /// Respected tile level details.
  TreemapLevel get level => _level;
  late TreemapLevel _level;

  /// Specifies whether this tile has any descendant tiles.
  bool get hasDescendants => _hasDescendants;
  late bool _hasDescendants;

  /// Area to be occupied by the squarified tile.
  double? _area;

  /// TopLeft position of the squarified tile.
  Offset? _offset;

  /// Size of the squarified tile.
  Size? _size;

  /// Size of the respected tile's label builder which is used to position the
  /// tooltip. Applicable only for hierarchical (parent) tiles.
  Size _labelBuilderSize = Size.zero;

  /// Surrounded padding of the respected tile.
  EdgeInsetsGeometry? _padding;

  /// Child of the tile.
  Map<String, TreemapTile>? _descendants;

  /// Level index of the tile.
  late int _levelIndex;

  /// Which represents which tile is actually drilled. When we drilldown
  /// to the 0->1->2 level, 0 and 1 tiles are already drilled. The second tile
  /// is drilled with animation ends.
  bool _isDrilled = false;

  /// Stores the color value.
  dynamic _colorValue;
}

/// The mixin  methods or fields are reusing to the other different class.
mixin _TreemapMixin {
  /// Represents the opacity animation for the tile when the
  /// drilldown animation is progress.
  ///
  /// If we forward drill down 0th level to 1st level, It will be increase
  /// opacity 1.0 to 0.0 in the 0th level tiles and elements.
  ///
  /// If we backward drill down 1st level to 0th level, It will be decrease
  /// opacity 0.0 to 1.0 the 0th level tiles and elements.
  late Tween<double> _tileOpacity;

  /// When the drilldown animation is backward, decrease the opacity 1.0 to 0.0
  /// for the label and item builder.
  late Tween<double> _labelAndItemBuilderOpacity;

  /// Represents the translation offset animation for the tile when the
  /// drilldown animation is progress.
  late Tween<Offset> _visibleTileTranslation;

  /// Represents the scaling animation for the tile when the
  /// drilldown animation is progress.
  late Tween<Size> _visibleTileScaleSize;

  /// Represents the translation offset animation for the tile when the
  /// drilldown animation is progress.
  late Tween<Offset> _nextTileTranslation;

  /// Represents the scaling animation for the tile when the
  /// drilldown animation is progress.
  late Tween<Size> _nextTileScaleSize;

  /// Current drill down tile details.
  late TreemapTile _visibleTile;

  /// If we drilled-in or drilled-out tiles, the scaling and translation
  /// only happens for the first half of the duration.
  late CurvedAnimation _scaleAndTranslationAnimation;

  /// If we drilled-in or drilled-out tiles, opacity only applies for
  /// the second half of the duration.
  late CurvedAnimation _opacityAnimation;

  /// Which represents the size of the treemap.
  Size? size;

  /// Calculates the scale and translation value by using the current
  /// drilldown tile size and offset.
  void _computeDrilldownTweenValue(
      TreemapTile visibleTile,
      AnimationController drilldownAnimationController,
      GlobalKey breadcrumbKey,
      bool isDrilledIn) {
    if (isDrilledIn) {
      final Size currentScale = Size(size!.width / visibleTile._size!.width,
          size!.height / visibleTile._size!.height);
      final Offset currentTranslation =
          _getTranslation(visibleTile._offset!, currentScale);
      _scaleAndTranslationAnimation.curve =
          const Interval(0, 0.5, curve: Curves.easeInOut);
      _opacityAnimation.curve =
          const Interval(0.5, 1.0, curve: Curves.easeInOut);
      _visibleTileTranslation
        ..begin = Offset.zero
        ..end = currentTranslation;
      _visibleTileScaleSize
        ..begin = const Size(1.0, 1.0)
        ..end = currentScale;
      _tileOpacity
        ..begin = 1.0
        ..end = 0.0;
      drilldownAnimationController.forward(from: 0.01);
    } else {
      _scaleAndTranslationAnimation.curve =
          const Interval(0.5, 1.0, curve: Curves.easeInOut);
      _opacityAnimation.curve = const Interval(0, 0.5, curve: Curves.easeInOut);
      _computeDrilledOutTweenValue(visibleTile, breadcrumbKey);
      drilldownAnimationController.reverse(from: 0.99);
    }

    _visibleTile = visibleTile;
  }

  void _computeDrilledOutTweenValue(
      TreemapTile tappedTile, GlobalKey breadcrumbKey) {
    late TreemapTile currentDrilledTile;
    if (breadcrumbKey.currentState != null) {
      final _BreadcrumbsState breadcrumbRenderBox =
          breadcrumbKey.currentState! as _BreadcrumbsState;
      // if we drilled-out 2nd level to 0th level, the first level tile should
      // be widget size and 0th level size should be greater than widget size.
      // So calculates the scale factor which we need to increase the size of
      // the 0th tiles by using the current drilled tile size.
      currentDrilledTile =
          breadcrumbRenderBox._tiles[tappedTile._levelIndex + 2];
    }

    _buildTiles(tappedTile._descendants!, tappedTile.weight, size!);
    // It represents which size we need to increase the from scale
    // value to the current level tiles.
    final Size currentLevelScale = Size(
        size!.width / currentDrilledTile._size!.width,
        size!.height / currentDrilledTile._size!.height);
    // It represents the offset we need to translate in the animation begin
    // to the current level tiles.
    final Offset currentLevelTranslation =
        _getTranslation(currentDrilledTile._offset!, currentLevelScale);
    // It represents which size we need to increase the from scale
    // value to the current visible tiles.
    final Size nextLevelScale =
        Size(1.0 / currentLevelScale.width, 1.0 / currentLevelScale.height);
    // It represents the offset we need to translate in the animation begin
    // to the current visible tiles.
    final Offset nextLevelTranslation =
        _getTranslation(currentLevelTranslation, nextLevelScale);
    _nextTileTranslation
      ..begin = nextLevelTranslation
      ..end = Offset.zero;
    _nextTileScaleSize
      ..begin = nextLevelScale
      ..end = const Size(1.0, 1.0);
    _visibleTileScaleSize
      ..begin = const Size(1.0, 1.0)
      ..end = currentLevelScale;
    _visibleTileTranslation
      ..begin = Offset.zero
      ..end = currentLevelTranslation;
    _tileOpacity
      ..begin = 1.0
      ..end = 0.0;
    _labelAndItemBuilderOpacity
      ..begin = 0.0
      ..end = 1.0;
  }

  Offset _getTranslation(Offset tileOffset, Size scaleSize) {
    return -Offset(
        tileOffset.dx * scaleSize.width, tileOffset.dy * scaleSize.height);
  }

  /// Scales to the current visible level and load its descendants
  /// with animation.
  Widget _buildAnimatedTreemap(
      AnimationController controller, GlobalKey breadcrumbKey,
      {TreemapLayoutDirection direction = TreemapLayoutDirection.topLeft}) {
    late List<TreemapTile> breadcrumbTiles;
    if (breadcrumbKey.currentState != null) {
      final _BreadcrumbsState breadcrumbRenderBox =
          breadcrumbKey.currentState! as _BreadcrumbsState;
      breadcrumbTiles = breadcrumbRenderBox._tiles;
    }

    final TreemapTile tile = controller.status == AnimationStatus.reverse
        ? _visibleTile
        // Gets the previous tapped tiles.
        : breadcrumbTiles[breadcrumbTiles.length - 2];

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final Offset translation = _getLayoutDirectionTranslation(direction,
            _visibleTileTranslation.evaluate(_scaleAndTranslationAnimation));
        final Size scaleSize =
            _visibleTileScaleSize.evaluate(_scaleAndTranslationAnimation);
        if (controller.status != AnimationStatus.reverse) {
          return Stack(
            children: <Widget>[
              Transform(
                alignment: _getEffectiveAlignment(direction),
                transform: Matrix4.identity()
                  ..scale(scaleSize.width, scaleSize.height)
                  ..leftTranslate(translation.dx, translation.dy),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildTiles(tile._descendants!, tile.weight, size!,
                      canLayoutTiles: false),
                ),
              ),
              if (controller.value > 0.5)
                Opacity(
                  opacity: 1.0 - _tileOpacity.evaluate(_opacityAnimation),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _buildTiles(
                        _visibleTile._descendants!, _visibleTile.weight, size!),
                  ),
                )
            ],
          );
        } else {
          return _buildDrilledOutAnimatedTiles(
              tile, breadcrumbTiles.last, scaleSize, translation, direction);
        }
      },
    );
  }

  Widget _buildDrilledOutAnimatedTiles(
      TreemapTile tile,
      TreemapTile lastBreadcrumbTile,
      Size scaleSize,
      Offset translation,
      TreemapLayoutDirection direction) {
    final Offset descendantsTranslation = _getLayoutDirectionTranslation(
        direction,
        _nextTileTranslation.evaluate(_scaleAndTranslationAnimation));
    final Size descendantsScaleSize =
        _nextTileScaleSize.evaluate(_scaleAndTranslationAnimation);
    return Stack(
      children: <Widget>[
        Transform(
          alignment: _getEffectiveAlignment(direction),
          transform: Matrix4.identity()
            ..scale(scaleSize.width, scaleSize.height)
            ..leftTranslate(translation.dx, translation.dy),
          child: Stack(
            clipBehavior: Clip.none,
            children: _buildTiles(tile._descendants!, tile.weight, size!,
                canLayoutTiles: false),
          ),
        ),
        Transform(
          alignment: _getEffectiveAlignment(direction),
          transform: Matrix4.identity()
            ..scale(descendantsScaleSize.width, descendantsScaleSize.height)
            ..leftTranslate(
                descendantsTranslation.dx, descendantsTranslation.dy),
          child: Opacity(
            opacity: 1.0 - _tileOpacity.evaluate(_opacityAnimation),
            child: Stack(
              clipBehavior: Clip.none,
              children: _buildTiles(lastBreadcrumbTile._descendants!,
                  lastBreadcrumbTile.weight, size!,
                  canLayoutTiles: false),
            ),
          ),
        )
      ],
    );
  }

  Offset _getLayoutDirectionTranslation(
      TreemapLayoutDirection layoutDirection, Offset translation) {
    switch (layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return translation;
      case TreemapLayoutDirection.topRight:
        return -Offset(translation.dx, -translation.dy);
      case TreemapLayoutDirection.bottomLeft:
        return Offset(translation.dx, -translation.dy);
      case TreemapLayoutDirection.bottomRight:
        return -translation;
    }
  }

  AlignmentGeometry _getEffectiveAlignment(
      TreemapLayoutDirection layoutDirection) {
    switch (layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return Alignment.topLeft;
      case TreemapLayoutDirection.topRight:
        return Alignment.topRight;
      case TreemapLayoutDirection.bottomLeft:
        return Alignment.bottomLeft;
      case TreemapLayoutDirection.bottomRight:
        return Alignment.bottomRight;
    }
  }

  /// Loads label builder and descendants for the tiles.
  Widget? _getDescendants(BuildContext context, TreemapTile tile,
      TreemapController controller, bool enableDrilldown,
      {AnimationController? animationController}) {
    Widget? child;
    // Ignored current tile descendants while enable drilldown.
    if (enableDrilldown) {
      if (tile.level.labelBuilder != null) {
        child = _buildLabeAndItemBuilder(
          tile.level.labelBuilder!(context, tile)!,
          tile,
          controller.visibleLevelIndex,
          animationController!.status,
          _scaleAndTranslationAnimation,
          _opacityAnimation,
          _visibleTileScaleSize,
          _nextTileScaleSize,
          _tileOpacity,
          _labelAndItemBuilderOpacity,
        );
      }

      return child;
    }

    if (tile.level.labelBuilder != null && tile.hasDescendants) {
      final Widget? labelBuilder = tile.level.labelBuilder!(context, tile);
      if (labelBuilder == null) {
        return Stack(
          children: _buildTiles(tile._descendants!, tile.weight, tile._size!),
        );
      }

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          labelBuilder,
          Expanded(
            // The [TreemapLevel.padding] and [TreemapLevel.border] values has
            // been previous applied by using padding widget to this column.
            // So we will get constraints size with considering that.
            // Therefore we haven't considered [TreemapLevel.padding] and
            // [TreemapLevel.border] values while passing size to children.
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              // To get the actual size of the parent tile, we had taken the
              // size of the label builder and subtracted from it.
              tile._labelBuilderSize = Size(
                  tile._size!.width - constraints.maxWidth,
                  tile._size!.height - constraints.maxHeight);
              return Stack(
                children: _buildTiles(
                    tile._descendants!,
                    tile.weight,
                    Size(tile._size!.width - tile._labelBuilderSize.width,
                        tile._size!.height - tile._labelBuilderSize.height)),
              );
            }),
          ),
        ],
      );
    }
    // In flat or hierarchical levels[levels.length - 1] level i.e., last level
    // doesn't have descendants. So, we had included the label builder
    // widget directly.
    // No need to consider the [TreemapLevel.padding] and [TreemapLevel.border]
    // values because labelBuilder will be the child of padding widget.
    else if (tile.level.labelBuilder != null) {
      child = tile.level.labelBuilder!(context, tile);
    } else if (tile.hasDescendants) {
      child = _buildDescendants(tile);
    }

    return child;
  }

  Widget _buildDescendants(TreemapTile tile) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
          children: _buildTiles(
        tile._descendants!,
        tile.weight,
        constraints.biggest,
      ));
    });
  }

  /// Creates the get tiles methods and overrides to the slice, dice
  /// and squarified class.
  List<Widget> _buildTiles(
      Map<String, TreemapTile> source, double aggregatedWeight, Size size,
      {bool canLayoutTiles = true}) {
    return <Widget>[];
  }
}

/// The [Treemap] is a widget for data visualization that uses
/// nested rectangles to view hierarchical data.
class Treemap extends StatefulWidget {
  /// Creates [Treemap].
  const Treemap({
    Key? key,
    required this.layoutType,
    required this.dataCount,
    required this.levels,
    required this.weightValueMapper,
    required this.layoutDirection,
    required this.sortAscending,
    required this.colorMappers,
    required this.legend,
    required this.tileHoverColor,
    required this.tileHoverBorder,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.tooltipSettings,
    required this.enableDrilldown,
    required this.breadcrumbs,
  }) : super(key: key);

  /// Represents the length of the given data source.
  final int dataCount;

  /// Returns a value based on which index passed through it.
  final IndexedDoubleValueMapper weightValueMapper;

  /// Collection of [TreemapLevel] which specifies the grouping in the
  /// given data source.
  final List<TreemapLevel> levels;

  /// Start position the tiles based on the [layoutDirection].
  final TreemapLayoutDirection layoutDirection;

  /// Position the tiles in ascending or descending order.
  final bool sortAscending;

  /// Collection of [TreemapColorMapper] which specifies treemap color based
  /// on the data.
  final List<TreemapColorMapper>? colorMappers;

  /// Invoke at the time of selection is handled.
  final ValueChanged<TreemapTile>? onSelectionChanged;

  /// Option to customize the selected tiles appearance.
  final TreemapSelectionSettings selectionSettings;

  /// Customizes the appearance of the tooltip.
  final TreemapTooltipSettings tooltipSettings;

  /// Enables color for the tile while hovering.
  final Color? tileHoverColor;

  /// Applies the border color around the hovering tile.
  final RoundedRectangleBorder? tileHoverBorder;

  /// Specifies the type of the treemap.
  final LayoutType layoutType;

  /// The [legend] property provides additional information about the data
  /// rendered in the tree map.
  final TreemapLegend? legend;

  /// Options to enable drilldown.
  ///
  /// A large amount of data can be virtualized into a small number of views.
  /// Each item level can be drilled down.
  final bool enableDrilldown;

  /// The breadcrumbs items align horizontally across the top of the treemap.
  /// It provides to navigate the current tile to the previous tile.
  final TreemapBreadcrumbs? breadcrumbs;

  @override
  State<Treemap> createState() => _TreemapState();
}

class _TreemapState extends State<Treemap> with SingleTickerProviderStateMixin {
  final Color _baseColor = const Color.fromRGBO(60, 119, 233, 1);
  late GlobalKey _tooltipKey;
  late GlobalKey _breadcrumbKey;
  late Map<String, TreemapTile> _dataSource;
  late TreemapController _controller;
  late PointerController _pointerController;
  late bool _isDesktop;
  late int _levelsLength;

  AnimationController? _drilldownAnimationController;
  double _totalWeight = 0.0;

  // Set true if there is a tooltip builder for any of the TreemapLevels. We had
  // checked this while the tiles were grouped. If true, we've added a treemap
  // widget, and a tooltip widget to stack as children.
  bool _isTooltipEnabled = false;
  bool _canUpdateTileColor = true;
  late Future<bool> _computeDataSource;

  _SquarifiedTreemap get _squarified => _SquarifiedTreemap(
      dataCount: widget.dataCount,
      layoutDirection: widget.layoutDirection,
      tooltipKey: _tooltipKey,
      breadcrumbKey: _breadcrumbKey,
      onSelectionChanged: widget.onSelectionChanged,
      selectionSettings: widget.selectionSettings,
      enableDrillDown: widget.enableDrilldown,
      controller: _controller,
      drilldownAnimationController: _drilldownAnimationController,
      initialTile: TreemapTile._()
        .._group = 'Home'
        .._levelIndex = -1
        .._offset = Offset.zero
        .._descendants = _dataSource
        .._weight = _totalWeight
        .._isDrilled = true);

  _SliceAndDiceTreemap get _sliceAndDice => _SliceAndDiceTreemap(
        dataCount: widget.dataCount,
        sortAscending: widget.sortAscending,
        type: widget.layoutType,
        tooltipKey: _tooltipKey,
        breadcrumbKey: _breadcrumbKey,
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
        enableDrillDown: widget.enableDrilldown,
        controller: _controller,
        drilldownAnimationController: _drilldownAnimationController,
        initialTile: TreemapTile._()
          .._group = 'Home'
          .._levelIndex = -1
          .._offset = Offset.zero
          .._descendants = _dataSource
          .._weight = _totalWeight
          .._isDrilled = true,
      );

  TreemapTooltip get _tooltip =>
      TreemapTooltip(key: _tooltipKey, settings: widget.tooltipSettings);

  Widget _buildTreemap(BuildContext context, bool hasData) {
    Widget current = widget.layoutType == LayoutType.squarified
        ? _squarified
        : _sliceAndDice;

    if (widget.enableDrilldown) {
      // ignore: no_leading_underscores_for_local_identifiers
      final _Breadcrumbs _breadcrumbs = _Breadcrumbs(
        key: _breadcrumbKey,
        settings: widget.breadcrumbs!,
        controller: _controller,
        animationController: _drilldownAnimationController!,
        levels: widget.levels,
        initialTile: TreemapTile._()
          .._group = 'Home'
          .._levelIndex = -1
          .._offset = Offset.zero
          .._descendants = _dataSource
          .._weight = _totalWeight
          .._isDrilled = true,
      );
      switch (widget.breadcrumbs!.position) {
        case TreemapBreadcrumbPosition.top:
          current = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _breadcrumbs,
              Expanded(child: ClipRect(child: current))
            ],
          );
          break;
        case TreemapBreadcrumbPosition.bottom:
          current = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: ClipRect(child: current)),
              _breadcrumbs,
            ],
          );
          break;
      }
    }

    if (widget.legend != null) {
      current = Legend(
        colorMappers: widget.colorMappers,
        dataSource: _dataSource,
        legend: widget.legend!,
        controller: _pointerController,
        child: current,
      );
    }

    return current;
  }

  Offset _getLegendPointerOffset(double? value) {
    double normalized = 0.0;
    if (value != null &&
        widget.colorMappers != null &&
        widget.colorMappers!.isNotEmpty) {
      final int length = widget.colorMappers!.length;
      // Range color mapper.
      if (widget.colorMappers![0].from != null) {
        final double slab = 1 / length;
        double factor = 0.0;
        for (int i = 0; i < length; i++) {
          final TreemapColorMapper mapper = widget.colorMappers![i];
          if (mapper.from! <= value && mapper.to! >= value) {
            factor = (value - mapper.from!) / (mapper.to! - mapper.from!);
            if (widget.legend!.segmentPaintingStyle ==
                TreemapLegendPaintingStyle.solid) {
              // Setting the index of the segment based on the hovered
              // tile for solid bar legend types.
              _pointerController.segmentIndex = i;
              normalized += factor;
              break;
            } else {
              normalized += factor * slab;
              break;
            }
          } else if (widget.legend!.segmentPaintingStyle ==
              TreemapLegendPaintingStyle.gradient) {
            normalized += slab;
          }
        }
      } else {
        // Equal color mapper.
        if (widget.legend!.segmentPaintingStyle ==
            TreemapLegendPaintingStyle.solid) {
          _pointerController.segmentIndex = value.toInt();
          // To place the pointer at the center of the segment in case of
          // solid bar legend type.
          normalized = 0.5;
        } else {
          normalized = value / (length - 1);
        }
      }
    }
    return Offset(normalized, normalized);
  }

  void _updateLegendPointer(double? value) {
    if (widget.legend != null &&
        _isDesktop &&
        widget.legend!.showPointerOnHover) {
      _pointerController
        ..position = value != null ? _getLegendPointerOffset(value) : null
        ..colorValue = value;
    }
  }

  void _invalidate() {
    _canUpdateTileColor = true;
    _totalWeight = 0.0;
    _dataSource.clear();
    _obtainDataSource();
  }

  void _obtainDataSource() {
    _computeDataSource =
        _obtainDataSourceAndBindColorMappers().then((bool value) => value);
  }

  Future<bool> _obtainDataSourceAndBindColorMappers() async {
    if (_dataSource.isEmpty) {
      for (int i = 0; i < widget.dataCount; i++) {
        final double weight = widget.weightValueMapper(i);
        assert(weight > 0);
        _totalWeight += weight;
        _groupTiles(weight, i);
      }
    }

    if (_dataSource.isNotEmpty && _canUpdateTileColor) {
      _bindColorMappersIntoDataSource(_dataSource);
      _canUpdateTileColor = false;
    }

    return true;
  }

  void _groupTiles(double weight, int dataIndex,
      {int currentLevelIndex = 0, TreemapTile? ancestor}) {
    final TreemapLevel currentLevel = widget.levels[currentLevelIndex];
    final String? groupKey = currentLevel.groupMapper(dataIndex);
    final Color? color = currentLevel.color;
    final EdgeInsetsGeometry? padding = currentLevel.padding;
    final int nextLevelIndex = currentLevelIndex + 1;
    _isTooltipEnabled |= currentLevel.tooltipBuilder != null;

    // If the groupKey is null, we have checked for next level. If we have next
    // level, we will add that level as children to the current ancestor.
    // Eg.: Consider we have 3 levels, [0] and [2] has group key but [1] didn't
    // have group key, here we have considered the [2] as child to the [0].
    if (groupKey == null) {
      if (nextLevelIndex < _levelsLength) {
        _groupTiles(weight, dataIndex,
            currentLevelIndex: nextLevelIndex, ancestor: ancestor);
      }
      return;
    }

    // We used the dataSource for grouping tiles based on the group key during
    // the first step, i.e.[0]. For further levels, i.e.[0+i], we used the same
    // ancestor in _groupTiles method as _dataSource[i].descendants to update or
    // add the tiles.
    //
    // Example : Lets consider a sample data with three levels,
    //
    // SampleData(level0: 'A', level1: 'A1', level2: 'A11', weight: 1),
    // SampleData(level0: 'B', level1: 'B1', level2: 'B21', weight: 2),
    // SampleData(level0: 'C', level2: 'C11', weight: 3),
    //
    // We have three levels, [0] is level0, [1] is level1 and [2] is level2.
    //
    // Let's take the 1st data and search the group key for level[0]. If the
    // group key is not null, in the dataSource, we've changed it.
    // Then we checked the group key for [1]. We have tested for the next
    // level[1] group key. If the group key is not null, we have modified it in
    // the dataSource. If it was null, we had repeated this step again.
    // Similarly we have checked completely until last level for 1st data.
    //
    // After that, we search for the second data and again continue with the
    // steps above. Checked the group key for [2]. We have modified in
    // dataSource[0][0].descendants if it is not null. Likewise, We've also
    // checked for the next stages.
    ((ancestor?._descendants ??= <String, TreemapTile>{}) ?? _dataSource)
        .update(
      groupKey,
      (TreemapTile tile) {
        tile._weight += weight;
        tile.indices.add(dataIndex);
        tile._levelIndex = currentLevelIndex;
        if (nextLevelIndex < _levelsLength) {
          _groupTiles(weight, dataIndex,
              currentLevelIndex: nextLevelIndex, ancestor: tile);
        }
        return tile;
      },
      ifAbsent: () {
        final TreemapTile tile = TreemapTile._()
          .._group = groupKey
          .._level = currentLevel
          .._indices = <int>[dataIndex]
          .._weight = weight
          .._padding = padding
          .._levelIndex = currentLevelIndex
          .._hasDescendants = false;
        if (color != null) {
          tile._color = color;
        }

        if (nextLevelIndex < _levelsLength) {
          _groupTiles(weight, dataIndex,
              currentLevelIndex: nextLevelIndex, ancestor: tile);
        }
        ancestor?._hasDescendants = true;
        return tile;
      },
    );
  }

  void _bindColorMappersIntoDataSource(Map<String, TreemapTile>? source) {
    if (source != null && source.isNotEmpty) {
      final double baseWeight =
          source.values.map((TreemapTile tile) => tile._weight).reduce(max);
      for (final TreemapTile tile in source.values) {
        tile._color = _getColor(tile) ??
            _getSaturatedColor(
                _baseColor, 1 - (tile._weight / baseWeight), Colors.white);
        _bindColorMappersIntoDataSource(tile._descendants);
      }
    }
  }

  Color? _getColor(TreemapTile tile) {
    final List<TreemapColorMapper>? colorMappers = widget.colorMappers;
    final Object? colorValue = tile.level.colorValueMapper?.call(tile);
    TreemapColorMapper mapper;
    if (colorValue is Color) {
      return colorValue;
    } else if (colorMappers != null) {
      // Value color mapping.
      if (colorValue is String) {
        for (int i = 0; i < colorMappers.length; i++) {
          mapper = colorMappers[i];
          assert(mapper.value != null);
          if (mapper.value == colorValue) {
            tile._colorValue = i;
            return mapper.color;
          }
        }
      }
      // Range color mapping.
      else if (colorValue is num) {
        tile._colorValue = colorValue;
        return _getRangeColor(colorValue, colorMappers);
      }
      // When colorValue is null, returned the color based on the tile weight.
      else if (colorValue == null) {
        return tile.level.color ?? _getRangeColor(tile._weight, colorMappers);
      }
    }

    return tile.level.color;
  }

  Color? _getRangeColor(num value, List<TreemapColorMapper> colorMappers) {
    for (final TreemapColorMapper mapper in colorMappers) {
      assert(mapper.from != null &&
          mapper.to != null &&
          mapper.from! <= mapper.to!);
      if ((mapper.from != null && mapper.to != null) &&
          (mapper.from! <= value && mapper.to! >= value)) {
        if (mapper.minSaturation != null && mapper.maxSaturation != null) {
          return _getSaturatedColor(
              mapper.color,
              1 -
                  lerpDouble(mapper.minSaturation, mapper.maxSaturation,
                      (value - mapper.from!) / (mapper.to! - mapper.from!))!,
              Colors.white);
        }
        return mapper.color;
      }
    }

    return null;
  }

  void _handleDrillDown(TreemapTile tile, bool isDrilledIn) {
    if (_tooltipKey.currentContext != null) {
      final RenderTooltip tooltipRenderBox =
          _tooltipKey.currentContext!.findRenderObject()!
              // ignore: avoid_as
              as RenderTooltip;
      tooltipRenderBox.hide(immediately: true);
    }
  }

  @override
  void initState() {
    _levelsLength = widget.levels.length;
    _dataSource = <String, TreemapTile>{};
    _tooltipKey = GlobalKey();
    _breadcrumbKey = GlobalKey();
    _controller = TreemapController();
    if (widget.enableDrilldown) {
      _drilldownAnimationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000));
      _controller.addDrillDownListener(_handleDrillDown);
    }
    _pointerController = PointerController();
    _obtainDataSource();
    super.initState();
  }

  @override
  void didUpdateWidget(Treemap oldWidget) {
    _canUpdateTileColor =
        (oldWidget.colorMappers == null && widget.colorMappers != null) ||
            (oldWidget.colorMappers != null && widget.colorMappers == null) ||
            (oldWidget.colorMappers != null &&
                widget.colorMappers != null &&
                oldWidget.colorMappers!.length != widget.colorMappers!.length);

    if (_levelsLength != widget.levels.length) {
      _levelsLength = widget.levels.length;
      _invalidate();
    } else if (widget.dataCount != oldWidget.dataCount) {
      _invalidate();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _dataSource.clear();
    _controller.dispose();
    if (widget.enableDrilldown) {
      _drilldownAnimationController!.dispose();
      _controller.removeDrillDownListener(_handleDrillDown);
    }
    _pointerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    return FutureBuilder<bool>(
      future: _computeDataSource,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = Size(
              constraints.hasBoundedWidth ? constraints.maxWidth : 300,
              constraints.hasBoundedHeight ? constraints.maxHeight : 300);

          // While resizing or changing orientation in an running drill down
          // animation, force it to complete.
          if (widget.enableDrilldown &&
              _drilldownAnimationController!.isAnimating) {
            _drilldownAnimationController!.value =
                _drilldownAnimationController!.status == AnimationStatus.forward
                    ? 1.0
                    : 0.0;
          }

          return SizedBox(
            width: size.width,
            height: size.height,
            child: snapshot.hasData
                ? Stack(children: <Widget>[
                    _buildTreemap(context, snapshot.hasData),
                    if (_isTooltipEnabled) _tooltip,
                  ])
                : null,
          );
        });
      },
    );
  }
}

/// Display hierarchical data using nested rectangles.
class _SquarifiedTreemap extends StatefulWidget {
  const _SquarifiedTreemap({
    Key? key,
    required this.dataCount,
    required this.layoutDirection,
    required this.tooltipKey,
    required this.breadcrumbKey,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.enableDrillDown,
    required this.controller,
    required this.drilldownAnimationController,
    required this.initialTile,
  }) : super(key: key);

  final int dataCount;
  final TreemapLayoutDirection layoutDirection;
  final GlobalKey tooltipKey;
  final GlobalKey breadcrumbKey;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;
  final bool enableDrillDown;
  final TreemapController controller;
  final AnimationController? drilldownAnimationController;
  final TreemapTile initialTile;

  @override
  _SquarifiedTreemapState createState() => _SquarifiedTreemapState();
}

class _SquarifiedTreemapState extends State<_SquarifiedTreemap>
    with _TreemapMixin {
  // Calculate the size and position of the widget list based on the aggregated
  // weight and the size passed. We will get the size as widgetSize and
  // aggregateWeight as the total weight of the source at first time.
  // We will determine the size and offset of each tile in the source based on
  // groupArea. We had passed the actual size and weight of the tile to measure
  // its location and size for its children.
  @override
  List<Widget> _buildTiles(
      Map<String, TreemapTile> source, double aggregatedWeight, Size size,
      {Offset offset = Offset.zero,
      int start = 0,
      int? end,
      bool canLayoutTiles = true}) {
    final Size widgetSize = size;
    double groupArea = 0;
    double referenceArea;
    double? prevAspectRatio;
    double? groupInitialTileArea;
    final List<TreemapTile> tiles = source.values.toList();
    // Sorting the tiles in descending order.
    tiles.sort((TreemapTile src, TreemapTile target) =>
        target.weight.compareTo(src.weight));
    end ??= tiles.length;
    final List<Widget> children = <Widget>[];
    for (int i = start; i < end; i++) {
      final TreemapTile tile = tiles[i];
      if (!canLayoutTiles) {
        children.addAll(_getTileWidgets(
            tiles, size, offset, start, tiles.length,
            canLayoutTiles: false));
        return children;
      } else {
        // Area of rectangle = length * width.
        // Divide the tile weight with aggregatedWeight to get the area factor.
        // Multiply it with rectangular area to get the actual area of a tile.
        tile._area = widgetSize.height *
            widgetSize.width *
            (tile.weight / aggregatedWeight);
        groupInitialTileArea ??= tile._area;
        // Group start tile height or width based on the shortest side.
        final double area = (groupArea + tile._area!) / size.shortestSide;
        referenceArea = groupInitialTileArea! / area;
        final double currentAspectRatio = max(
            _getAspectRatio(referenceArea, area),
            _getAspectRatio(tile._area! / area, area));
        if (prevAspectRatio == null || currentAspectRatio < prevAspectRatio) {
          prevAspectRatio = currentAspectRatio;
          groupArea += tile._area!;
        } else {
          // Aligning the tiles vertically.
          if (size.width > size.height) {
            children.addAll(
              _getTileWidgets(tiles, Size(groupArea / size.height, size.height),
                  offset, start, i,
                  axis: Axis.vertical),
            );
            offset += Offset(groupArea / size.height, 0);
            size =
                Size(max(0, size.width) - groupArea / size.height, size.height);
          }
          // Aligning the tiles horizontally.
          else {
            children.addAll(_getTileWidgets(tiles,
                Size(size.width, groupArea / size.width), offset, start, i,
                axis: Axis.horizontal));
            offset += Offset(0, groupArea / size.width);
            size =
                Size(size.width, max(0, size.height) - groupArea / size.width);
          }
          start = i;
          groupInitialTileArea = groupArea = tile._area!;
          referenceArea =
              tile._area! / (groupInitialTileArea / size.shortestSide);
          prevAspectRatio =
              _getAspectRatio(referenceArea, tile._area! / size.shortestSide);
        }
      }
    }

    // Calculating the size and offset of the last tile or last group area in
    // the given source.
    if (size.width > size.height) {
      children.addAll(
        _getTileWidgets(tiles, Size(groupArea / size.height, size.height),
            offset, start, end,
            axis: Axis.vertical),
      );
    } else {
      children.addAll(
        _getTileWidgets(tiles, Size(groupArea / size.height, size.height),
            offset, start, end,
            axis: Axis.horizontal),
      );
    }

    return children;
  }

  List<Widget> _getTileWidgets(
      List<TreemapTile> source, Size size, Offset offset, int start, int end,
      {Axis? axis, bool canLayoutTiles = true}) {
    final List<_Tile> tiles = <_Tile>[];
    for (int i = start; i < end; i++) {
      final TreemapTile tileDetails = source[i];
      if (canLayoutTiles) {
        if (axis == Axis.vertical) {
          tileDetails
            .._size = Size(size.width, tileDetails._area! / size.width)
            .._offset = offset;
          offset += Offset(0, tileDetails._size!.height);
        } else {
          tileDetails
            .._size = Size(tileDetails._area! / size.height, size.height)
            .._offset = offset;
          offset += Offset(tileDetails._size!.width, 0);
        }
      }

      tiles.add(_Tile(
        size: tileDetails._size!,
        details: tileDetails,
        tooltipKey: widget.tooltipKey,
        layoutDirection: widget.layoutDirection,
        sortAscending: false,
        controller: widget.controller,
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
        drilldownAnimationController: widget.drilldownAnimationController,
        child: _getDescendants(
            context, tileDetails, widget.controller, widget.enableDrillDown,
            animationController: widget.drilldownAnimationController),
      ));
    }

    return tiles;
  }

  double _getAspectRatio(double width, double height) {
    return width > height ? width / height : height / width;
  }

  void _handleDrillDown(TreemapTile tile, bool isDrilledIn) {
    setState(() {
      _computeDrilldownTweenValue(tile, widget.drilldownAnimationController!,
          widget.breadcrumbKey, isDrilledIn);
    });
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.controller.visibleLevelIndex++;
      _visibleTile._isDrilled = true;
    }

    setState(() {
      // Refresh treemap tile after drill down animation ends.
    });
  }

  @override
  void initState() {
    _visibleTile = widget.initialTile;
    if (widget.enableDrillDown) {
      _scaleAndTranslationAnimation = CurvedAnimation(
          parent: widget.drilldownAnimationController!, curve: Curves.linear);
      _opacityAnimation = CurvedAnimation(
          parent: widget.drilldownAnimationController!, curve: Curves.linear);
      _tileOpacity = Tween<double>();
      _labelAndItemBuilderOpacity = Tween<double>();
      _visibleTileTranslation = Tween<Offset>();
      _visibleTileScaleSize = Tween<Size>();
      _nextTileTranslation = Tween<Offset>();
      _nextTileScaleSize = Tween<Size>();
      widget.controller.addDrillDownListener(_handleDrillDown);
      widget.drilldownAnimationController!
          .addStatusListener(_handleAnimationStatusChange);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(_SquarifiedTreemap oldWidget) {
    if (oldWidget.layoutDirection != widget.layoutDirection) {
      if (widget.tooltipKey.currentContext != null) {
        final RenderTooltip tooltipRenderBox = widget.tooltipKey.currentContext!
            .findRenderObject()! as RenderTooltip;
        tooltipRenderBox.hide(immediately: true);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.enableDrillDown) {
      widget.controller.removeDrillDownListener(_handleDrillDown);
      widget.drilldownAnimationController!
          .removeStatusListener(_handleAnimationStatusChange);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size newSize = constraints.biggest;
        if (size != newSize) {
          size = newSize;
        }

        if (widget.enableDrillDown &&
            (widget.drilldownAnimationController!.isAnimating)) {
          return _buildAnimatedTreemap(
            widget.drilldownAnimationController!,
            widget.breadcrumbKey,
            direction: widget.layoutDirection,
          );
        }

        return Stack(
          children: _buildTiles(
            _visibleTile._descendants!,
            _visibleTile.weight,
            size!,
          ),
        );
      },
    );
  }
}

class _SliceAndDiceTreemap extends StatefulWidget {
  const _SliceAndDiceTreemap({
    Key? key,
    required this.dataCount,
    required this.type,
    required this.sortAscending,
    required this.tooltipKey,
    required this.breadcrumbKey,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.enableDrillDown,
    required this.controller,
    required this.drilldownAnimationController,
    required this.initialTile,
  }) : super(key: key);

  final int dataCount;
  final LayoutType type;
  final bool sortAscending;
  final GlobalKey tooltipKey;
  final GlobalKey breadcrumbKey;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;
  final bool enableDrillDown;
  final TreemapController controller;
  final AnimationController? drilldownAnimationController;
  final TreemapTile initialTile;

  @override
  _SliceAndDiceTreemapState createState() => _SliceAndDiceTreemapState();
}

class _SliceAndDiceTreemapState extends State<_SliceAndDiceTreemap>
    with SingleTickerProviderStateMixin, _TreemapMixin {
  @override
  List<Widget> _buildTiles(
      Map<String, TreemapTile> source, double aggregatedWeight, Size size,
      {bool canLayoutTiles = true}) {
    final List<Widget> children = <Widget>[];
    final List<TreemapTile> tiles = source.values.toList();
    Offset offset = Offset.zero;
    // Sorting the tiles in ascending/descending order based on the
    // [sortAscending].
    if (widget.sortAscending) {
      tiles.sort((TreemapTile src, TreemapTile target) =>
          src.weight.compareTo(target.weight));
    } else {
      tiles.sort((TreemapTile target, TreemapTile src) =>
          src.weight.compareTo(target.weight));
    }
    for (final TreemapTile tile in tiles) {
      if (canLayoutTiles) {
        if (widget.type == LayoutType.slice) {
          tile
            .._size =
                Size(size.width, size.height * (tile.weight / aggregatedWeight))
            .._offset = offset;
          offset += Offset(0, tile._size!.height);
        } else {
          tile
            .._size =
                Size(size.width * (tile.weight / aggregatedWeight), size.height)
            .._offset = offset;
          offset += Offset(tile._size!.width, 0);
        }
      }

      children.add(_Tile(
        type: widget.type,
        size: tile._size!,
        details: tile,
        tooltipKey: widget.tooltipKey,
        layoutDirection: TreemapLayoutDirection.topLeft,
        sortAscending: widget.sortAscending,
        controller: widget.controller,
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
        drilldownAnimationController: widget.drilldownAnimationController,
        child: _getDescendants(
          context,
          tile,
          widget.controller,
          widget.enableDrillDown,
          animationController: widget.drilldownAnimationController,
        ),
      ));
    }

    return children;
  }

  void _handleDrillDown(TreemapTile tile, bool isDrilledIn) {
    setState(() {
      _computeDrilldownTweenValue(tile, widget.drilldownAnimationController!,
          widget.breadcrumbKey, isDrilledIn);
    });
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.controller.visibleLevelIndex++;
      _visibleTile._isDrilled = true;
    }

    setState(() {
      // Refresh treemap tile after drill down animation ends.
    });
  }

  @override
  void initState() {
    _visibleTile = widget.initialTile;
    if (widget.enableDrillDown) {
      _scaleAndTranslationAnimation = CurvedAnimation(
          parent: widget.drilldownAnimationController!, curve: Curves.linear);
      _opacityAnimation = CurvedAnimation(
          parent: widget.drilldownAnimationController!, curve: Curves.linear);
      _tileOpacity = Tween<double>();
      _labelAndItemBuilderOpacity = Tween<double>();
      _visibleTileTranslation = Tween<Offset>();
      _visibleTileScaleSize = Tween<Size>();
      _nextTileTranslation = Tween<Offset>();
      _nextTileScaleSize = Tween<Size>();
      widget.controller.addDrillDownListener(_handleDrillDown);
      widget.drilldownAnimationController!
          .addStatusListener(_handleAnimationStatusChange);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.enableDrillDown) {
      widget.controller.removeDrillDownListener(_handleDrillDown);
      widget.drilldownAnimationController!
          .removeStatusListener(_handleAnimationStatusChange);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size newSize = constraints.biggest;
        if (size != newSize) {
          size = newSize;
        }

        if (widget.drilldownAnimationController != null &&
            widget.drilldownAnimationController!.isAnimating) {
          return _buildAnimatedTreemap(
              widget.drilldownAnimationController!, widget.breadcrumbKey);
        }

        return Stack(
          children: _buildTiles(
            _visibleTile._descendants!,
            _visibleTile.weight,
            size!,
          ),
        );
      },
    );
  }
}

/// Creates tile of the treemap.
class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    this.type = LayoutType.squarified,
    required this.size,
    required this.details,
    required this.tooltipKey,
    required this.layoutDirection,
    required this.sortAscending,
    required this.controller,
    required this.child,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.drilldownAnimationController,
  }) : super(key: key);

  final LayoutType type;
  final Size size;
  final TreemapTile details;
  final GlobalKey tooltipKey;
  final TreemapLayoutDirection layoutDirection;
  final bool sortAscending;
  final TreemapController controller;
  final Widget? child;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;
  final AnimationController? drilldownAnimationController;

  @override
  Widget build(BuildContext context) {
    final dynamic ancestor = type == LayoutType.squarified
        ? context.findAncestorStateOfType<_SquarifiedTreemapState>()!
        : context.findAncestorStateOfType<_SliceAndDiceTreemapState>()!;

    Widget current = _TileDecor(
      size: size,
      details: details,
      tooltipKey: tooltipKey,
      sortAscending: sortAscending,
      controller: controller,
      onSelectionChanged: onSelectionChanged,
      selectionSettings: selectionSettings,
      drilldownAnimationController: drilldownAnimationController,
      ancestor: ancestor,
      child: child,
    );

    if (details._padding != null) {
      EdgeInsets padding =
          details._padding!.resolve(Directionality.of(context));
      // if we forward 0 -> 1st level, we need to ignore scaling to the 0th
      // level tiles only. If we backward 1 -> 0th level we need to ignore
      // scaling for both levels.
      if (drilldownAnimationController != null &&
          ((drilldownAnimationController!.status == AnimationStatus.forward &&
                  controller.visibleLevelIndex == details._levelIndex) ||
              drilldownAnimationController!.status ==
                  AnimationStatus.reverse)) {
        Size scaleSize;
        // If we driled-out 2 -> 0 level, we have used two scaling for second
        // and zeroth level tiles. So We should use the next tile Scale to the
        // second level tile and the visible level scale to the zeroth level
        // tiles.
        if (drilldownAnimationController!.status == AnimationStatus.reverse &&
            controller.visibleLevelIndex == details._levelIndex) {
          scaleSize = ancestor._nextTileScaleSize!
              .evaluate(ancestor._scaleAndTranslationAnimation) as Size;
        } else {
          scaleSize = ancestor._visibleTileScaleSize!
              .evaluate(ancestor._scaleAndTranslationAnimation) as Size;
        }

        padding = EdgeInsets.fromLTRB(
            padding.left / scaleSize.width,
            padding.top / scaleSize.height,
            padding.right / scaleSize.width,
            padding.bottom / scaleSize.height);
      }

      current = Padding(padding: padding, child: current);
    }

    return _buildPositionedWidget(current);
  }

  Widget _buildPositionedWidget(Widget current) {
    switch (layoutDirection) {
      case TreemapLayoutDirection.topLeft:
        return Positioned(
          width: size.width,
          height: size.height,
          left: details._offset!.dx,
          top: details._offset!.dy,
          child: current,
        );
      case TreemapLayoutDirection.topRight:
        return Positioned(
          width: size.width,
          height: size.height,
          right: details._offset!.dx,
          top: details._offset!.dy,
          child: current,
        );
      case TreemapLayoutDirection.bottomLeft:
        return Positioned(
          width: size.width,
          height: size.height,
          left: details._offset!.dx,
          bottom: details._offset!.dy,
          child: current,
        );
      case TreemapLayoutDirection.bottomRight:
        return Positioned(
          width: size.width,
          height: size.height,
          right: details._offset!.dx,
          bottom: details._offset!.dy,
          child: current,
        );
    }
  }
}

class _TileDecor extends StatefulWidget {
  const _TileDecor({
    Key? key,
    required this.size,
    required this.details,
    required this.tooltipKey,
    required this.sortAscending,
    required this.controller,
    required this.child,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.drilldownAnimationController,
    required this.ancestor,
  }) : super(key: key);

  final Size size;
  final TreemapTile details;
  final GlobalKey tooltipKey;
  final bool sortAscending;
  final TreemapController controller;
  final Widget? child;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;
  final AnimationController? drilldownAnimationController;
  final dynamic ancestor;

  @override
  _TileDecorState createState() => _TileDecorState();
}

class _TileDecorState extends State<_TileDecor> with TickerProviderStateMixin {
  static const double hoverSaturateFactor = 0.2;
  static const double selectionSaturateFactor = 0.4;
  late Animation<double> _animation;
  late AnimationController _controller;
  late ColorTween _colorTween;

  late bool _mouseIsConnected;
  late Treemap _ancestor;
  bool _isSelected = false;
  bool _isHover = false;

  bool get _canAddInteractableWidget {
    return widget.onSelectionChanged != null ||
        widget.details.level.tooltipBuilder != null ||
        (_ancestor.legend != null && _ancestor.legend!.showPointerOnHover);
  }

  RoundedRectangleBorder? _getBorder() {
    RoundedRectangleBorder? border;
    if (_isHover && widget.details == widget.controller.hoveredTile) {
      border = _ancestor.tileHoverBorder;
    } else if (_isSelected &&
        widget.details == widget.controller.selectedTile) {
      border = widget.selectionSettings.border;
    }
    if (border != null && widget.details.level.border != null) {
      return widget.details.level.border!.copyWith(
          side: border.side,
          borderRadius:
              border.borderRadius.resolve(Directionality.of(context)));
    }
    return border ?? widget.details.level.border;
  }

  Widget _buildTileDecor(Widget child, BuildContext context) {
    Widget current = child;
    if (_canAddInteractableWidget || _ancestor.enableDrilldown) {
      final bool allow = !_ancestor.enableDrilldown ||
          (widget.controller.visibleLevelIndex == widget.details._levelIndex &&
              !widget.drilldownAnimationController!.isAnimating);

      // if we enable drill down, handle hover, tooltip and selection for
      // last tiles only.
      if (_mouseIsConnected) {
        final _TreemapState treemapState =
            context.findAncestorStateOfType<_TreemapState>()!;
        current = MouseRegion(
          child: current,
          onEnter: (PointerEnterEvent event) {
            _showTooltip(PointerKind.hover, allow);

            if (widget.onSelectionChanged != null && !_isSelected && allow) {
              widget.controller.hoveredTile = widget.details;
            }

            treemapState
                ._updateLegendPointer(widget.details._colorValue?.toDouble());
          },
          onHover: (PointerHoverEvent event) {
            // Updating the [widget.controller.hoveredTile] when hover
            // over the same tile after deselected the tile.
            if (widget.onSelectionChanged != null && !_isSelected && allow) {
              widget.controller.hoveredTile ??= widget.details;
            }
          },
          onExit: (PointerExitEvent event) {
            widget.controller.hoveredTile = null;
            _hideTooltip(allow);
            treemapState._updateLegendPointer(null);
          },
        );
      }

      current = GestureDetector(
        onTapUp: (TapUpDetails details) {
          if (_ancestor.enableDrilldown &&
              widget.details.hasDescendants &&
              allow) {
            widget.controller.hoveredTile = null;
            widget.controller.notifyDrilldownListeners(widget.details, true);
          } else {
            _showTooltip(PointerKind.touch, allow);
            if (widget.onSelectionChanged != null && allow) {
              widget.controller.selectedTile = widget.details;
              // We are restricting hover action when tile is selected using
              // the [_isSelected] field. Updating [_isSelected] field only in
              // the [_handleSelectionChange] method, it is invoked once set
              // value to the selectedTile. So we need to update the
              // [widget.controller.selectedTile] before setting null to
              // the [widget.controller.hoveredTile] to avoid hover
              // action while selecting a tile.
              widget.controller.hoveredTile = null;
              widget.onSelectionChanged!(widget.details);
            }
          }
        },
        child: current,
      );
    }

    return current;
  }

  void _showTooltip(PointerKind kind, [bool allow = true]) {
    if (allow && widget.details.level.tooltipBuilder != null) {
      // ignore: avoid_as
      final RenderBox tileRenderBox = context.findRenderObject()! as RenderBox;
      // Taking the top left global position of the current tile.
      final Offset globalPosition = tileRenderBox.localToGlobal(Offset.zero);
      // We had used the tile size directly if the tile didn't have any
      // descendants. For parent tiles, the tooltip can only be shown on the
      // label builder. So, we had used the label builder height instead of the
      // tile height.
      final Size referenceTileSize =
          widget.details.hasDescendants && !_ancestor.enableDrilldown
              ? Size(widget.size.width, widget.details._labelBuilderSize.height)
              : widget.size;
      final RenderTooltip tooltipRenderBox =
          // ignore: avoid_as
          widget.tooltipKey.currentContext!.findRenderObject()!
              as RenderTooltip;
      tooltipRenderBox.show(
          globalPosition, widget.details, referenceTileSize, kind);
    }
  }

  void _hideTooltip(bool allow, {bool immediately = false}) {
    if (allow && widget.details.level.tooltipBuilder != null) {
      final RenderTooltip tooltipRenderBox =
          widget.tooltipKey.currentContext!.findRenderObject()!
              // ignore: avoid_as
              as RenderTooltip;
      tooltipRenderBox.hide(immediately: immediately);
    }
  }

  void _handleMouseTrackerChange() {
    if (!mounted) {
      return;
    }
    final bool mouseIsConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() {
        _mouseIsConnected = mouseIsConnected;
      });
    }
  }

  void _handleSelectionChange() {
    _isHover = false;
    final TreemapTile? selectedTile = widget.controller.selectedTile;
    final TreemapTile? previousSelectedTile =
        widget.controller.previousSelectedTile;
    if (selectedTile != null &&
        (selectedTile == widget.details || _isDescendant(selectedTile))) {
      _isSelected = true;
      _updateSelectionTweenColor();
      // We are using same controller for selection and hover. If we select
      // the hovered tile, [_controller] is already forwarded to 1 for hover
      // action. We need to start the controller from 0, to visible the
      // selection animation for desktop platforms.
      _mouseIsConnected ? _controller.forward(from: 0) : _controller.forward();
    } else if (previousSelectedTile != null &&
        (previousSelectedTile == widget.details ||
            _isDescendant(previousSelectedTile))) {
      _isSelected = false;
      _updateSelectionTweenColor();
      _controller.reverse();
    }
  }

  void _handleHover() {
    if (_isSelected) {
      return;
    }
    _isHover = true;
    final TreemapTile? hoveredTile = widget.controller.hoveredTile;
    final TreemapTile? previousHoveredTile =
        widget.controller.previousHoveredTile;
    if (hoveredTile != null &&
        (hoveredTile == widget.details || _isDescendant(hoveredTile))) {
      _updateHoverTweenColor();
      _controller.forward();
    } else if (previousHoveredTile != null &&
        (previousHoveredTile == widget.details ||
            _isDescendant(previousHoveredTile))) {
      _updateHoverTweenColor();
      _controller.reverse();
      //  If we enter and exit a tile faster [_controller.value] is not changed
      //  so [hoverBorder] is not removed from the tile. Thus we need to check
      //  [_controller.value] is dismissed.
      if (_controller.isDismissed) {
        _rebuild();
      }
    }
  }

  void _updateSelectionTweenColor() {
    final Color? selectionColor = widget.selectionSettings.color;
    if (selectionColor != Colors.transparent &&
        _mouseIsConnected &&
        _isSelected) {
      if (_ancestor.tileHoverColor != null &&
          _ancestor.tileHoverColor != Colors.transparent) {
        _colorTween.begin = _ancestor.tileHoverColor;
      } else if (_ancestor.tileHoverColor == Colors.transparent) {
        _colorTween.begin = widget.details.color;
      } else if (_ancestor.tileHoverColor == null) {
        _colorTween.begin =
            _getSaturatedColor(widget.details.color, hoverSaturateFactor);
      }
    } else {
      _colorTween.begin = widget.details.color;
    }
    _colorTween.end = selectionColor == null
        ? _getSaturatedColor(widget.details.color, selectionSaturateFactor)
        : selectionColor == Colors.transparent
            ? widget.details.color
            : selectionColor;
  }

  bool _isDescendant(TreemapTile source) {
    if (!source.hasDescendants) {
      return false;
    }

    if (widget.details.indices.length < source.indices.length) {
      return widget.details.indices
          .any((int index) => source.indices.contains(index));
    } else if (widget.details.indices.length == source.indices.length) {
      for (final int index in widget.details.indices) {
        final bool hasIndex = source.indices.contains(index);
        if (hasIndex &&
            // Restricted the parent tile selection when both the selected tile
            // and parent tile indices count, indices values are exactly same
            // by checking the level index.
            _ancestor.levels.indexOf(widget.details.level) >=
                _ancestor.levels.indexOf(source.level)) {
          return true;
        }
      }
    }
    return false;
  }

  void _rebuild() {
    if (mounted) {
      setState(() {
        // Rebuilding to update the selection color and border to the visual.
      });
    }
  }

  double _getColorFactor() {
    return _mouseIsConnected ? (_isHover ? 0.2 : 0.4) : 0.4;
  }

  void _updateHoverTweenColor() {
    _colorTween.begin = widget.details.color;
    if (_ancestor.tileHoverColor != null &&
        _ancestor.tileHoverColor != Colors.transparent) {
      _colorTween.end = _ancestor.tileHoverColor;
    } else if (_ancestor.tileHoverColor == Colors.transparent) {
      _colorTween.end = widget.details.color;
    } else {
      _colorTween.end =
          _getSaturatedColor(widget.details.color, _getColorFactor());
    }
  }

  void _handleDrilldownTweenColor() {
    if (widget.drilldownAnimationController!.status ==
            AnimationStatus.forward &&
        widget.controller.visibleLevelIndex == widget.details._levelIndex) {
      _colorTween.end = Colors.transparent;
    } else if (widget.drilldownAnimationController!.status ==
        AnimationStatus.reverse) {
      if (widget.details._isDrilled) {
        _colorTween.begin = widget.ancestor._visibleTile._levelIndex + 1 ==
                widget.details._levelIndex
            ? widget.details.color
            : Colors.transparent;
        _colorTween.end = Colors.transparent;
      }
    }
  }

  Color _getTileColor() {
    if (_ancestor.enableDrilldown &&
        widget.drilldownAnimationController!.isAnimating) {
      return _colorTween.evaluate(widget.ancestor._opacityAnimation)!;
    }

    return _colorTween.evaluate(_animation)!;
  }

  Widget _buildTileBorder(Widget child, EdgeInsets dimensions,
      RoundedRectangleBorder? border, Size? scaleSize) {
    if (border != null) {
      BorderRadius borderRadius =
          border.borderRadius.resolve(Directionality.of(context));
      if (widget.drilldownAnimationController != null &&
          ((widget.drilldownAnimationController!.status ==
                      AnimationStatus.forward &&
                  widget.controller.visibleLevelIndex ==
                      widget.details._levelIndex) ||
              widget.drilldownAnimationController!.status ==
                  AnimationStatus.reverse)) {
        // If we driled-out 2 -> 0 level, we have used two scaling for second
        // and zeroth level tiles. So We should use the next tile Scale to the
        // second level tile and the visible level scale to the zeroth level
        // tiles.
        if (widget.drilldownAnimationController!.status ==
                AnimationStatus.reverse &&
            widget.controller.visibleLevelIndex == widget.details._levelIndex) {
          scaleSize = widget.ancestor._nextTileScaleSize!
              .evaluate(widget.ancestor._scaleAndTranslationAnimation) as Size;
        }

        borderRadius = _getBorderRadius(borderRadius, scaleSize!);
        border = AnimatedBorder(
            borderRadius: borderRadius,
            side: border.side,
            scaleSize: scaleSize);
        dimensions = border.dimensions.resolve(Directionality.of(context));
        dimensions = EdgeInsets.fromLTRB(
            dimensions.left / scaleSize.width,
            dimensions.top / scaleSize.height,
            dimensions.right / scaleSize.width,
            dimensions.bottom / scaleSize.height);
      }
    }

    return CustomPaint(
      size: widget.size,
      foregroundPainter: _BorderPainter(border),
      child: ClipPath.shape(
          shape: border ?? const RoundedRectangleBorder(),
          child: Padding(padding: dimensions, child: child)),
    );
  }

  BorderRadius _getBorderRadius(BorderRadius borderRadius, Size scaleSize) {
    return BorderRadius.only(
        topRight: Radius.elliptical(borderRadius.topRight.x / scaleSize.width,
            borderRadius.topRight.y / scaleSize.height),
        bottomLeft: Radius.elliptical(
            borderRadius.bottomLeft.x / scaleSize.width,
            borderRadius.bottomLeft.y / scaleSize.height),
        bottomRight: Radius.elliptical(
            borderRadius.bottomRight.x / scaleSize.width,
            borderRadius.bottomRight.y / scaleSize.height),
        topLeft: Radius.elliptical(borderRadius.topLeft.x / scaleSize.width,
            borderRadius.topLeft.y / scaleSize.height));
  }

  Widget? _buildItemBuilder(Widget? current) {
    Widget? itemBuilder =
        widget.details.level.itemBuilder!(context, widget.details);
    if (itemBuilder == null) {
      return current;
    }

    if (_ancestor.enableDrilldown) {
      itemBuilder = _buildLabeAndItemBuilder(
        itemBuilder,
        widget.details,
        widget.controller.visibleLevelIndex,
        widget.drilldownAnimationController!.status,
        widget.ancestor._scaleAndTranslationAnimation,
        widget.ancestor._opacityAnimation,
        widget.ancestor._visibleTileScaleSize,
        widget.ancestor._nextTileScaleSize,
        widget.ancestor._tileOpacity,
        widget.ancestor._labelAndItemBuilderOpacity,
      );
    }

    if (current != null) {
      current = Stack(children: <Widget>[
        itemBuilder!,
        current,
      ]);
    } else {
      current = itemBuilder;
    }

    return current;
  }

  @override
  void initState() {
    _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    RendererBinding.instance.mouseTracker
        .addListener(_handleMouseTrackerChange);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation.addListener(_rebuild);

    _colorTween =
        ColorTween(begin: widget.details.color, end: widget.details.color);

    widget.controller
      ..addSelectionListener(_handleSelectionChange)
      ..addHoverListener(_handleHover);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _ancestor = context.findAncestorWidgetOfExactType<Treemap>()!;
    if (_ancestor.enableDrilldown) {
      _handleDrilldownTweenColor();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_TileDecor oldWidget) {
    if (widget.sortAscending != oldWidget.sortAscending) {
      _colorTween =
          ColorTween(begin: widget.details.color, end: widget.details.color);
      if (widget.details.level.tooltipBuilder != null) {
        final RenderTooltip tooltipRenderBox = widget.tooltipKey.currentContext!
            .findRenderObject()! as RenderTooltip;
        tooltipRenderBox.hide(immediately: true);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animation.removeListener(_rebuild);
    _controller.dispose();

    widget.controller
      ..removeSelectionListener(_handleSelectionChange)
      ..removeHoverListener(_handleHover);

    RendererBinding.instance.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? current =
        // Loads only the current visible tile label builder if the tiles have
        // descendants and we enable drilldown.
        !widget.details.hasDescendants || _ancestor.enableDrilldown
            ? widget.child
            : null;
    Size? scaleSize;
    if (_ancestor.enableDrilldown &&
        widget.ancestor._visibleTileScaleSize.begin != null) {
      scaleSize = widget.ancestor._visibleTileScaleSize!
          .evaluate(widget.ancestor._scaleAndTranslationAnimation) as Size;
    }

    if (widget.details.level.itemBuilder != null) {
      current = _buildItemBuilder(current);
    }

    // If we dynamically add a widget, the actual layout will be affected so
    // _TileDecor is disposed and initialized by _Tile. so _controller was
    // disposed as soon as the tile is selected so selection will not work as
    // expected. To avoid this issue, we always add ColoredBox and
    // _BorderPainter if selection is enabled.
    current = ColoredBox(color: _getTileColor(), child: current);

    final RoundedRectangleBorder? border = _getBorder();
    final EdgeInsetsGeometry dimensions = border?.dimensions ?? EdgeInsets.zero;
    if (border != null || widget.onSelectionChanged != null) {
      current = _buildTileBorder(current,
          dimensions.resolve(Directionality.of(context)), border, scaleSize);
    }

    if (!widget.details.hasDescendants || _ancestor.enableDrilldown) {
      return _buildTileDecor(current, context);
    } else {
      // Added descendant tiles to the siblings of the parent tile instead of
      // adding it as child, in order to get the respective touch pointer when
      // hovered or tapped on the parent tile or descendant tiles.
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildTileDecor(current, context),
          if (widget.child != null)
            _ancestor.enableDrilldown
                ? widget.child!
                : Padding(padding: dimensions, child: widget.child)
        ],
      );
    }
  }
}

/// Drawn a rectangular border with rounded corners.
class _BorderPainter extends CustomPainter {
  const _BorderPainter(this.border);

  /// A rectangular border with rounded corners.
  final RoundedRectangleBorder? border;

  @override
  void paint(Canvas canvas, Size size) {
    if (border != null) {
      border!.paint(canvas, Offset.zero & size);
    }
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) {
    return oldDelegate.border != border;
  }
}

/// It is a navigation strategy that reveals the location of the current tile.
class _Breadcrumbs extends StatefulWidget {
  /// Creates a [_Breadcrumbs].
  const _Breadcrumbs({
    Key? key,
    required this.settings,
    required this.controller,
    required this.animationController,
    required this.levels,
    required this.initialTile,
  }) : super(key: key);

  /// Configuration of the [_Breadcrumbs].
  final TreemapBreadcrumbs settings;

  /// Holds the information and notifies the listeners for all interactions.
  final TreemapController controller;

  /// An opacity animation.
  final AnimationController animationController;

  final List<TreemapLevel> levels;

  final TreemapTile initialTile;

  @override
  _BreadcrumbsState createState() => _BreadcrumbsState();
}

class _BreadcrumbsState extends State<_Breadcrumbs>
    with SingleTickerProviderStateMixin {
  late List<TreemapTile> _tiles;
  late GlobalKey _breadcrumbItemKey;
  late Animation<double> _opacityAnimation;
  late TreemapTile _current;
  late List<Widget?> _breadcrumbs;

  Size? _size;

  void _handleDrilldown(TreemapTile tile, bool isForward) {
    _current = tile;
    _size ??= _breadcrumbItemKey.currentContext!.size;
    final List<Widget?> fadeOutBreadcrumb = <Widget?>[];
    if (isForward) {
      _tiles.add(tile);
    } else {
      fadeOutBreadcrumb.addAll(_breadcrumbs);
    }

    _breadcrumbs.clear();
    final int breadcrumbTilesLength = _tiles.length;
    final int nextLevelIndex = _current._levelIndex + 1;

    for (int i = 0; i < breadcrumbTilesLength; i++) {
      _breadcrumbs.add(i > nextLevelIndex
          ? fadeOutBreadcrumb[i]
          : widget.settings.builder(context, _tiles[i], i == nextLevelIndex)!);
    }
  }

  void _handleStatusChange(AnimationStatus status) {
    if (widget.animationController.isDismissed) {
      widget.controller.visibleLevelIndex = _current._levelIndex + 1;
      final List<TreemapTile> tiles = <TreemapTile>[];
      for (int i = 0; i < _tiles.length; i++) {
        if (_tiles[i]._levelIndex >= widget.controller.visibleLevelIndex) {
          _tiles[i]._isDrilled = false;
          _breadcrumbs.removeLast();
        } else {
          tiles.add(_tiles[i]);
        }
      }
      _tiles = tiles;
    }

    setState(() {
      // Refresh breadcrumbs after opacity animation ends.
    });
  }

  @override
  void initState() {
    _tiles = <TreemapTile>[];
    _current = widget.initialTile;
    _tiles.add(_current);
    _breadcrumbItemKey = GlobalKey();

    _opacityAnimation = CurvedAnimation(
        parent: widget.animationController, curve: Curves.decelerate);
    widget.animationController.addStatusListener(_handleStatusChange);

    widget.controller.addDrillDownListener(_handleDrilldown);
    _breadcrumbs = <Widget?>[];
    super.initState();
  }

  @override
  void dispose() {
    widget.animationController.removeStatusListener(_handleStatusChange);
    widget.controller.removeDrillDownListener(_handleDrilldown);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    final int length = _tiles.length;
    if (_breadcrumbs.isEmpty) {
      _breadcrumbs.add(widget.settings.builder(context, _current, true));
    }
    final Color dividerColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
    final Widget divider = widget.settings.divider ??
        Icon(Icons.chevron_right, size: 16.0, color: dividerColor);

    for (int i = 0; i < length; i++) {
      if (_breadcrumbs[i] != null) {
        final Widget current = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (i != 0)
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: divider,
              ),
            _breadcrumbs[i]!,
          ],
        );

        final bool canApplyOpacity =
            (widget.animationController.status == AnimationStatus.forward &&
                    _current._levelIndex == _tiles[i]._levelIndex) ||
                widget.animationController.status == AnimationStatus.reverse &&
                    _current._levelIndex < _tiles[i]._levelIndex;

        children.add(_Breadcrumb(
          tile: _tiles[i],
          controller: widget.controller,
          animation: _opacityAnimation,
          canApplyOpacity: canApplyOpacity,
          child: current,
        ));
      }
    }

    Widget? current;
    if (children.isNotEmpty) {
      current = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    }

    final EdgeInsets padding = widget.levels[_current._levelIndex + 1].padding!
        .resolve(Directionality.of(context));
    current = AnimatedPadding(
      key: _breadcrumbItemKey,
      duration: const Duration(milliseconds: 1000),
      padding: EdgeInsets.only(
          left: padding.left, top: 11.0, bottom: 9.0, right: padding.right),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Opacity(opacity: 0.0, child: divider),
          if (current != null) current
        ],
      ),
    );

    if (_size != null) {
      current = SizedBox(height: _size!.height, child: current);
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: current);
  }
}

class _Breadcrumb extends StatefulWidget {
  const _Breadcrumb({
    Key? key,
    required this.tile,
    required this.controller,
    required this.animation,
    required this.canApplyOpacity,
    required this.child,
  }) : super(key: key);

  final TreemapTile tile;
  final TreemapController controller;
  final Animation<double> animation;
  final bool canApplyOpacity;
  final Widget child;

  @override
  _BreadcrumbState createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<_Breadcrumb> {
  @override
  Widget build(BuildContext context) {
    Widget current = widget.child;

    // State is not preserved, when a widget's visual tree is changed
    // dynamically. So that gesture widget wrapped into the ignore pointer.
    current = IgnorePointer(
      ignoring: !((widget.animation.isCompleted ||
              widget.animation.isDismissed) &&
          widget.tile._levelIndex != widget.controller.visibleLevelIndex - 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            widget.controller.notifyDrilldownListeners(widget.tile, false);
          },
          child: current,
        ),
      ),
    );

    if (widget.canApplyOpacity &&
        (widget.animation.status == AnimationStatus.forward ||
            widget.animation.status == AnimationStatus.reverse)) {
      current = FadeTransition(opacity: widget.animation, child: current);
    }

    return current;
  }
}
