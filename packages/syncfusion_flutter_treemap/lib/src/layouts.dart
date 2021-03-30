import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../src/legend.dart';
import '../treemap.dart';
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

  /// Area to be occupied by the squarified tile.
  double? _area;

  /// TopLeft position of the squarified tile.
  Offset? _offset;

  /// Size of the squarified tile.
  late Size _size;

  /// Size of the respected tile's label builder which is used to position the
  /// tooltip. Applicable only for hierarchical (parent) tiles.
  Size? _labelBuilderSize;

  /// Surrounded padding of the respected tile.
  EdgeInsetsGeometry? _padding;

  /// Child of the tile.
  Map<String, TreemapTile>? _descendants;
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
    required this.colorMappers,
    required this.legend,
    required this.onSelectionChanged,
    required this.selectionSettings,
    required this.tooltipSettings,
  }) : super(key: key);

  /// Represents the length of the given data source.
  final int dataCount;

  /// Returns a value based on which index passed through it.
  final IndexedDoubleValueMapper weightValueMapper;

  /// Collection of [TreemapLevel] which specifies the grouping in the
  /// given data source.
  final List<TreemapLevel> levels;

  /// Collection of [TreemapColorMapper] which specifies treemap color based
  /// on the data.
  final List<TreemapColorMapper>? colorMappers;

  /// Invoke at the time of selection is handled.
  final ValueChanged<TreemapTile>? onSelectionChanged;

  /// Option to customize the selected tiles appearance.
  final TreemapSelectionSettings selectionSettings;

  /// Customizes the appearance of the tooltip.
  final TreemapTooltipSettings tooltipSettings;

  /// Specifies the type of the treemap.
  final LayoutType layoutType;

  /// The [legend] property provides additional information about the data
  /// rendered in the tree map.
  final TreemapLegend? legend;

  @override
  _TreemapState createState() => _TreemapState();
}

class _TreemapState extends State<Treemap> {
  final Color _baseColor = Color.fromRGBO(42, 80, 160, 1);
  late GlobalKey _tooltipKey;
  late Map<String, TreemapTile> _dataSource;

  late int _levelsLength;
  double _totalWeight = 0.0;

  // Set true if there is a tooltip builder for any of the TreemapLevels. We had
  // checked this while the tiles were grouped. If true, we've added a treemap
  // widget, and a tooltip widget to stack as children.
  bool _isTooltipEnabled = false;
  bool _canUpdateTileColor = true;
  late Future<bool> _computeDataSource;

  _SquarifiedTreemap get _squarified => _SquarifiedTreemap(
        dataCount: widget.dataCount,
        dataSource: _dataSource,
        totalWeight: _totalWeight,
        tooltipKey: _tooltipKey,
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
      );

  _SliceAndDiceTreemap get _sliceAndDice => _SliceAndDiceTreemap(
        dataCount: widget.dataCount,
        dataSource: _dataSource,
        type: widget.layoutType,
        totalWeight: _totalWeight,
        tooltipKey: _tooltipKey,
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
      );

  TreemapTooltip get _tooltip =>
      TreemapTooltip(key: _tooltipKey, settings: widget.tooltipSettings);

  Widget _buildTreemap(BuildContext context, bool hasData) {
    Widget current = widget.layoutType == LayoutType.squarified
        ? _squarified
        : _sliceAndDice;
    if (widget.legend != null) {
      final LegendWidget legend = LegendWidget(
          dataSource: widget.colorMappers ?? _dataSource,
          settings: widget.legend!);

      if (widget.legend!.offset == null) {
        switch (widget.legend!.position) {
          case TreemapLegendPosition.top:
            current =
                Column(children: <Widget>[legend, Expanded(child: current)]);
            break;
          case TreemapLegendPosition.bottom:
            current =
                Column(children: <Widget>[Expanded(child: current), legend]);
            break;
          case TreemapLegendPosition.left:
            current = Row(children: <Widget>[legend, Expanded(child: current)]);
            break;
          case TreemapLegendPosition.right:
            current = Row(children: <Widget>[Expanded(child: current), legend]);
            break;
        }
      } else {
        current = Stack(
          children: <Widget>[
            current,
            Align(
              alignment: _getLegendAlignment(widget.legend!.position),
              child: Padding(padding: _getLegendOffset(), child: legend),
            ),
          ],
        );
      }
    }

    return current;
  }

  void _invalidate() {
    _canUpdateTileColor = true;
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
    final String? groupKey = (currentLevel.groupMapper(dataIndex));
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
    ((ancestor?._descendants ??= {}) ?? _dataSource).update(
      groupKey,
      (TreemapTile tile) {
        tile._weight += weight;
        tile.indices.add(dataIndex);
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
          .._indices = [dataIndex]
          .._weight = weight
          .._padding = padding;
        if (color != null) {
          tile._color = color;
        }

        if (nextLevelIndex < _levelsLength) {
          _groupTiles(weight, dataIndex,
              currentLevelIndex: nextLevelIndex, ancestor: tile);
        }
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
    if (colorValue is Color) {
      return colorValue;
    } else if (colorMappers != null) {
      // Value color mapping.
      if (colorValue is String) {
        for (final TreemapColorMapper mapper in colorMappers) {
          assert(mapper.value != null);
          if (mapper.value == colorValue) {
            return mapper.color;
          }
        }
      }
      // Range color mapping.
      else if (colorValue is num) {
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
        return mapper.color;
      }
    }

    return null;
  }

  // Returns the position of the legend for align widget based on the
  // [TreemapLegend.position].
  AlignmentGeometry _getLegendAlignment(TreemapLegendPosition position) {
    switch (position) {
      case TreemapLegendPosition.top:
        return Alignment.topCenter;
      case TreemapLegendPosition.bottom:
        return Alignment.bottomCenter;
      case TreemapLegendPosition.left:
        return Alignment.centerLeft;
      case TreemapLegendPosition.right:
        return Alignment.centerRight;
    }
  }

  // By default, we have aligned the legends at topCenter. Based on the
  // alignments we had applied the offset values.
  // In [TreemapLegend.offset].dx, for (+)ve value, the legends gets moved from
  // left to right and for (-)ve value, the legends gets moved from right to
  // left.
  // In [TreemapLegend.offset].dy, for (+)ve value, the legends gets moved from
  // top to bottom and for (-)ve value, the legends gets moved from bottom to
  // top.
  EdgeInsetsGeometry _getLegendOffset() {
    final Offset offset = widget.legend!.offset!;
    final TreemapLegendPosition legendPosition = widget.legend!.position;
    switch (legendPosition) {
      case TreemapLegendPosition.top:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            top: offset.dy > 0 ? offset.dy : 0);
      case TreemapLegendPosition.left:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            left: offset.dx > 0 ? offset.dx : 0);
      case TreemapLegendPosition.right:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() : 0);
      case TreemapLegendPosition.bottom:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() : 0);
    }
  }

  @override
  void initState() {
    _levelsLength = widget.levels.length;
    _dataSource = <String, TreemapTile>{};
    _tooltipKey = GlobalKey();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _computeDataSource,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = Size(
              constraints.hasBoundedWidth ? constraints.maxWidth : 300,
              constraints.hasBoundedHeight ? constraints.maxHeight : 300);
          return SizedBox(
              width: size.width,
              height: size.height,
              child: snapshot.hasData
                  ? Stack(children: [
                      _buildTreemap(context, snapshot.hasData),
                      if (_isTooltipEnabled) _tooltip,
                    ])
                  : null);
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
    required this.dataSource,
    required this.totalWeight,
    required this.tooltipKey,
    required this.onSelectionChanged,
    required this.selectionSettings,
  }) : super(key: key);

  final int dataCount;
  final Map<String, TreemapTile> dataSource;
  final double totalWeight;
  final GlobalKey tooltipKey;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;

  @override
  _SquarifiedTreemapState createState() => _SquarifiedTreemapState();
}

class _SquarifiedTreemapState extends State<_SquarifiedTreemap> {
  Size? _size;
  late List<Widget> _children;
  late _TreemapController _treemapController;

  // Calculate the size and position of the widget list based on the aggregated
  // weight and the size passed. We will get the size as widgetSize and
  // aggregateWeight as the total weight of the source at first time.
  // We will determine the size and offset of each tile in the source based on
  // groupArea. We had passed the actual size and weight of the tile to measure
  // its location and size for its children.
  List<Widget> _getTiles(
      Map<String, TreemapTile> source, double aggregatedWeight, Size size,
      {Offset offset = Offset.zero, int start = 0, int? end}) {
    final Size widgetSize = size;
    double groupArea = 0;
    double referenceArea;
    double? prevAspectRatio;
    double? groupInitialTileArea;
    final List tiles = source.values.toList();
    // Sorting the tiles in descending order.
    tiles.sort((src, target) => target.weight.compareTo(src.weight));
    end ??= tiles.length;
    final List<Widget> children = [];
    for (int i = start; i < end; i++) {
      final TreemapTile tile = tiles[i];
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
                Axis.vertical, offset, start, i),
          );
          offset += Offset(groupArea / size.height, 0);
          size =
              Size(max(0, size.width) - groupArea / size.height, size.height);
        }
        // Aligning the tiles horizontally.
        else {
          children.addAll(
            _getTileWidgets(tiles, Size(size.width, groupArea / size.width),
                Axis.horizontal, offset, start, i),
          );
          offset += Offset(0, groupArea / size.width);
          size = Size(size.width, max(0, size.height) - groupArea / size.width);
        }
        start = i;
        groupInitialTileArea = groupArea = tile._area!;
        referenceArea =
            tile._area! / (groupInitialTileArea / size.shortestSide);
        prevAspectRatio =
            _getAspectRatio(referenceArea, (tile._area! / size.shortestSide));
      }
    }

    // Calculating the size and offset of the last tile or last group area in
    // the given source.
    if (size.width > size.height) {
      children.addAll(
        _getTileWidgets(tiles, Size(groupArea / size.height, size.height),
            Axis.vertical, offset, start, end),
      );
    } else {
      children.addAll(
        _getTileWidgets(tiles, Size(groupArea / size.height, size.height),
            Axis.horizontal, offset, start, end),
      );
    }
    return children;
  }

  List<Widget> _getTileWidgets(
      List source, Size size, Axis axis, Offset offset, int start, int end) {
    final List<_Tile> tiles = [];
    for (int i = start; i < end; i++) {
      final TreemapTile tileDetails = source[i];
      if (axis == Axis.vertical) {
        tileDetails
          .._size = Size(size.width, tileDetails._area! / size.width)
          .._offset = offset;
        offset += Offset(0, tileDetails._size.height);
      } else {
        tileDetails
          .._size = Size(tileDetails._area! / size.height, size.height)
          .._offset = offset;
        offset += Offset(tileDetails._size.width, 0);
      }

      tiles.add(_Tile(
        size: tileDetails._size,
        details: tileDetails,
        tooltipKey: widget.tooltipKey,
        treemapController: _treemapController,
        child: _getDescendants(tileDetails),
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
      ));
    }
    return tiles;
  }

  Widget? _getDescendants(TreemapTile tile) {
    Widget? child;
    if (tile.level.labelBuilder != null && tile._descendants != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile.level.labelBuilder!(context, tile)!,
          Expanded(
            // The [TreemapLevel.padding] and [TreemapLevel.border] values has
            // been previous applied by using padding widget to this column.
            // So we will get constraints size with considering that. Therefore
            // we haven't considered [TreemapLevel.padding] and
            // [TreemapLevel.border] values while passing size to children.
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              // To get the actual size of the parent tile, we had taken the
              // size of the label builder and subtracted from it.
              tile._labelBuilderSize = Size(
                  tile._size.width - constraints.maxWidth,
                  tile._size.height - constraints.maxHeight);
              return Stack(
                children: _getTiles(
                    tile._descendants!,
                    tile.weight,
                    Size(tile._size.width - tile._labelBuilderSize!.width,
                        tile._size.height - tile._labelBuilderSize!.height)),
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
    } else if (tile._descendants != null) {
      child = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
            children: _getTiles(
                tile._descendants!, tile.weight, constraints.biggest));
      });
    }

    return child;
  }

  double _getAspectRatio(double width, double height) {
    return width > height ? width / height : height / width;
  }

  void _reupdateTiles() {
    _children.clear();
    _children = _getTiles(widget.dataSource, widget.totalWeight, _size!);
  }

  @override
  void initState() {
    _children = <Widget>[];
    _treemapController = _TreemapController();
    super.initState();
  }

  @override
  void didUpdateWidget(_SquarifiedTreemap oldWidget) {
    if (widget.dataCount != oldWidget.dataCount) {
      _reupdateTiles();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _children.clear();
    _treemapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size newSize = constraints.biggest;
        if (_size != newSize) {
          _size = newSize;
          _reupdateTiles();
        }

        return Stack(children: _children);
      },
    );
  }
}

class _SliceAndDiceTreemap extends StatefulWidget {
  const _SliceAndDiceTreemap({
    Key? key,
    required this.dataCount,
    required this.type,
    required this.dataSource,
    required this.totalWeight,
    required this.tooltipKey,
    required this.onSelectionChanged,
    required this.selectionSettings,
  }) : super(key: key);

  final int dataCount;
  final LayoutType type;
  final Map<String, TreemapTile> dataSource;
  final double totalWeight;
  final GlobalKey tooltipKey;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;

  @override
  _SliceAndDiceTreemapState createState() => _SliceAndDiceTreemapState();
}

class _SliceAndDiceTreemapState extends State<_SliceAndDiceTreemap> {
  Size? _size;
  late List<Widget> _children;
  late _TreemapController _treemapController;

  List<Widget> _getTiles(
      Map<String, TreemapTile> source, double aggregatedWeight, Size size) {
    final List<Widget> children = [];
    final List tiles = source.values.toList();
    // Sorting the tiles in descending order.
    tiles.sort((src, target) => target.weight.compareTo(src.weight));
    for (final TreemapTile tile in tiles) {
      Size tileSize;
      // Finding a tile's size, based on its weight.
      if (widget.type == LayoutType.slice) {
        tileSize =
            Size(size.width, size.height * (tile.weight / aggregatedWeight));
      } else {
        tileSize =
            Size(size.width * (tile.weight / aggregatedWeight), size.height);
      }

      children.add(_Tile(
        type: widget.type,
        size: tileSize,
        details: tile,
        tooltipKey: widget.tooltipKey,
        treemapController: _treemapController,
        child: _getDescendants(tile, tileSize),
        onSelectionChanged: widget.onSelectionChanged,
        selectionSettings: widget.selectionSettings,
      ));
    }

    return children;
  }

  Widget? _getDescendants(TreemapTile tile, Size tileSize) {
    Widget? current;
    if (tile.level.labelBuilder != null && tile._descendants != null) {
      current = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile.level.labelBuilder!(context, tile)!,
          Expanded(
            // The [TreemapLevel.padding] and [TreemapLevel.border] values has
            // been previous applied by using padding widget to this column.
            // So we will get constraints size with considering that. Therefore
            // we haven't considered [TreemapLevel.padding] and
            // [TreemapLevel.border] values while passing size to children.
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              // To get the actual size of the parent tile, we had taken the
              // size of the label builder and subtracted from it.
              tile._labelBuilderSize = Size(
                  tileSize.width - constraints.maxWidth,
                  tileSize.height - constraints.maxHeight);
              final List<Widget> children = _getTiles(
                  tile._descendants!,
                  tile.weight,
                  Size(tileSize.width - tile._labelBuilderSize!.width,
                      tileSize.height - tile._labelBuilderSize!.height));
              return widget.type == LayoutType.slice
                  ? Column(children: children)
                  : Row(children: children);
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
      current = tile.level.labelBuilder!(context, tile);
    } else if (tile._descendants != null) {
      current = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final List<Widget> children =
            _getTiles(tile._descendants!, tile.weight, constraints.biggest);
        return widget.type == LayoutType.slice
            ? Column(children: children)
            : Row(children: children);
      });
    }

    return current;
  }

  void _reupdateTiles() {
    _children.clear();
    _children = _getTiles(widget.dataSource, widget.totalWeight, _size!);
  }

  @override
  void initState() {
    _children = <Widget>[];
    _treemapController = _TreemapController();
    super.initState();
  }

  @override
  void didUpdateWidget(_SliceAndDiceTreemap oldWidget) {
    if (widget.dataCount != oldWidget.dataCount ||
        widget.type != oldWidget.type) {
      _reupdateTiles();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _children.clear();
    _treemapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size newSize = constraints.biggest;
        if (_size != newSize) {
          _size = newSize;
          _reupdateTiles();
        }

        return widget.type == LayoutType.slice
            ? Column(children: _children)
            : Row(children: _children);
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
    required this.treemapController,
    required this.child,
    required this.onSelectionChanged,
    required this.selectionSettings,
  }) : super(key: key);

  final LayoutType type;
  final Size size;
  final TreemapTile details;
  final GlobalKey tooltipKey;
  final _TreemapController treemapController;
  final Widget? child;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;

  @override
  Widget build(BuildContext context) {
    Widget current = _TileDecor(
      size: size,
      details: details,
      tooltipKey: tooltipKey,
      treemapController: treemapController,
      child: child,
      onSelectionChanged: onSelectionChanged,
      selectionSettings: selectionSettings,
    );

    if (details._padding != null) {
      current = Padding(padding: details._padding!, child: current);
    }

    return type == LayoutType.squarified
        ? Positioned(
            width: size.width,
            height: size.height,
            left: details._offset!.dx,
            top: details._offset!.dy,
            child: current)
        : SizedBox(width: size.width, height: size.height, child: current);
  }
}

class _TileDecor extends StatefulWidget {
  const _TileDecor({
    Key? key,
    required this.size,
    required this.details,
    required this.tooltipKey,
    required this.treemapController,
    required this.child,
    required this.onSelectionChanged,
    required this.selectionSettings,
  }) : super(key: key);

  final Size size;
  final TreemapTile details;
  final GlobalKey tooltipKey;
  final _TreemapController treemapController;
  final Widget? child;
  final ValueChanged<TreemapTile>? onSelectionChanged;
  final TreemapSelectionSettings selectionSettings;

  @override
  _TileDecorState createState() => _TileDecorState();
}

class _TileDecorState extends State<_TileDecor> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late ColorTween _colorTween;

  bool _canAddInteractableWidget = false;
  bool _isSelected = false;
  bool _isHover = false;
  late bool _mouseIsConnected;

  late Treemap _ancestor;

  RoundedRectangleBorder? get _border =>
      (_isSelected && widget.details == widget.treemapController.selectedTile)
          ? (widget.details.level.border != null
              ? widget.details.level.border!.copyWith(
                  side: widget.selectionSettings.border?.side,
                  borderRadius: widget.selectionSettings.border?.borderRadius
                      .resolve(Directionality.of(context)))
              : widget.selectionSettings.border)
          : widget.details.level.border;

  Widget _buildTileDecor(Widget child, BuildContext context) {
    Widget? current = child;
    if (_canAddInteractableWidget) {
      if (_mouseIsConnected) {
        current = MouseRegion(
          child: current,
          onEnter: (PointerEnterEvent event) {
            if (widget.details.level.tooltipBuilder != null) {
              _showTooltip(PointerKind.hover);
            }

            if (widget.onSelectionChanged != null && !_isSelected) {
              widget.treemapController.hoveredTile = widget.details;
            }
          },
          onHover: (PointerHoverEvent event) {
            // Updating the [widget.treemapController.hoveredTile] when hover
            // over the same tile after deselected the tile.
            if (widget.onSelectionChanged != null && !_isSelected) {
              widget.treemapController.hoveredTile ??= widget.details;
            }
          },
          onExit: (PointerExitEvent event) {
            widget.treemapController.hoveredTile = null;
            if (widget.details.level.tooltipBuilder != null) {
              final RenderTooltip tooltipRenderBox =
                  widget.tooltipKey.currentContext?.findRenderObject()
                      // ignore: avoid_as
                      as RenderTooltip;
              tooltipRenderBox.hide();
            }
          },
        );
      }

      current = GestureDetector(
        onTapUp: (TapUpDetails details) {
          if (widget.details.level.tooltipBuilder != null) {
            _showTooltip(PointerKind.touch);
          }

          if (widget.onSelectionChanged != null) {
            widget.treemapController.selectedTile = widget.details;
            // We are restricting hover action when tile is selected using the
            // [_isSelected] field. Updating [_isSelected] field only in
            // the [_handleSelectionChange] method, it is invoked once set
            // value to the selectedTile. So we need to update the
            // [widget.treemapController.selectedTile] before setting null to
            // the [widget.treemapController.hoveredTile] to avoid hover action
            // while selecting a tile.
            widget.treemapController.hoveredTile = null;
            widget.onSelectionChanged!(widget.details);
          }
        },
        child: current,
      );
    }

    return current;
  }

  void _showTooltip(PointerKind kind) {
    // ignore: avoid_as
    final RenderBox tileRenderBox = context.findRenderObject() as RenderBox;
    // Taking the top left global position of the current tile.
    final Offset globalPosition = tileRenderBox.localToGlobal(Offset.zero);
    // We had used the tile size directly if the tile didn't have any
    // descendants. For parent tiles, the tooltip can only be shown on the
    // label builder. So, we had used the label builder height instead of the
    // tile height.
    final Size referenceTileSize = widget.details._descendants == null
        ? widget.size
        : Size(widget.size.width, widget.details._labelBuilderSize!.height);
    final RenderTooltip tooltipRenderBox =
        // ignore: avoid_as
        widget.tooltipKey.currentContext?.findRenderObject() as RenderTooltip;
    tooltipRenderBox.show(
        globalPosition, widget.details, referenceTileSize, kind);
  }

  void _handleMouseTrackerChange() {
    _mouseIsConnected =
        RendererBinding.instance?.mouseTracker.mouseIsConnected ?? false;
  }

  void _handleSelectionChange() {
    _isHover = false;
    final TreemapTile? selectedTile = widget.treemapController.selectedTile;
    final TreemapTile? previousSelectedTile =
        widget.treemapController.previousSelectedTile;
    if (selectedTile != null &&
        (selectedTile == widget.details || _isDescendant(selectedTile))) {
      _isSelected = true;
      _updateSelectionTweenColor();
      // We are using same controller for selection and hover. If we select the
      // hovered tile, [_controller] is already forwarded to 1 for hover action.
      // We need to start the controller from 0, to visible the selection
      // animation for desktop platforms.
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
    final TreemapTile? hoveredTile = widget.treemapController.hoveredTile;
    final TreemapTile? previousHoveredTile =
        widget.treemapController.previousHoveredTile;
    if (hoveredTile != null &&
        (hoveredTile == widget.details || _isDescendant(hoveredTile))) {
      _updateHoverTweenColor();
      _controller.forward();
    } else if (previousHoveredTile != null &&
        (previousHoveredTile == widget.details ||
            _isDescendant(previousHoveredTile))) {
      _updateHoverTweenColor();
      _controller.reverse();
    }
  }

  void _updateSelectionTweenColor() {
    final Color? selectionColor = widget.selectionSettings.color;
    _colorTween.begin = (_mouseIsConnected && _isSelected)
        ? _getSaturatedColor(widget.details.color, _getColorFactor())
        : widget.details.color;
    _colorTween.end = selectionColor == null
        ? _getSaturatedColor(widget.details.color, _getColorFactor())
        : selectionColor == Colors.transparent
            ? widget.details.color
            : selectionColor;
  }

  bool _isDescendant(TreemapTile source) {
    if (source._descendants == null) {
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
    _colorTween.end =
        _getSaturatedColor(widget.details.color, _getColorFactor());
  }

  @override
  void initState() {
    _mouseIsConnected =
        RendererBinding.instance?.mouseTracker.mouseIsConnected ?? false;
    RendererBinding.instance?.mouseTracker
        .addListener(_handleMouseTrackerChange);

    _canAddInteractableWidget = widget.onSelectionChanged != null ||
        widget.details.level.tooltipBuilder != null;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation.addListener(_rebuild);

    _colorTween =
        ColorTween(begin: widget.details.color, end: widget.details.color);

    widget.treemapController
      ..addSelectionListener(_handleSelectionChange)
      ..addHoverListener(_handleHover);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _ancestor = context.findAncestorWidgetOfExactType<Treemap>()!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();

    widget.treemapController
      ..removeSelectionListener(_handleSelectionChange)
      ..removeHoverListener(_handleHover);

    RendererBinding.instance?.mouseTracker
        .removeListener(_handleMouseTrackerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? current = widget.details._descendants == null ? widget.child : null;
    if (widget.details.level.itemBuilder != null) {
      if (current != null) {
        current = Stack(children: [
          widget.details.level.itemBuilder!.call(context, widget.details)!,
          current,
        ]);
      } else {
        current =
            widget.details.level.itemBuilder!.call(context, widget.details);
      }
    }

    // If we dynamically add a widget, the actual layout will be affected so
    // _TileDecor is disposed and initialized by _Tile. so _controller was
    // disposed as soon as the tile is selected so selection will not work as
    // expected. To avoid this issue, we always add ColoredBox and
    // _BorderPainter if selection is enabled.
    current = ColoredBox(
      color: _colorTween.evaluate(_animation)!,
      child: current,
    );

    final EdgeInsetsGeometry padding = _border?.dimensions ?? EdgeInsets.zero;
    if (_border != null || widget.onSelectionChanged != null) {
      current = CustomPaint(
        size: widget.size,
        foregroundPainter: _BorderPainter(_border),
        child: ClipPath.shape(
            shape: _border ?? const RoundedRectangleBorder(),
            child: Padding(padding: padding, child: current)),
      );
    }

    if (widget.details._descendants == null) {
      return _buildTileDecor(current, context);
    } else {
      // Added descendant tiles to the siblings of the parent tile instead of
      // adding it as child, in order to get the respective touch pointer when
      // hovered or tapped on the parent tile or descendant tiles.
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildTileDecor(current, context),
          if (widget.child != null)
            Padding(padding: padding, child: widget.child)
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

class _TreemapController {
  ObserverList<VoidCallback>? _selectionListeners =
      ObserverList<VoidCallback>();
  ObserverList<VoidCallback>? _hoverListeners = ObserverList<VoidCallback>();

  void addSelectionListener(VoidCallback listener) {
    _selectionListeners?.add(listener);
  }

  void addHoverListener(VoidCallback listener) {
    _hoverListeners?.add(listener);
  }

  void removeSelectionListener(VoidCallback listener) {
    _selectionListeners?.remove(listener);
  }

  void removeHoverListener(VoidCallback listener) {
    _hoverListeners?.remove(listener);
  }

  void notifySelectionListeners() {
    for (final VoidCallback listener in _selectionListeners!) {
      listener();
    }
  }

  void notifyHoverListeners() {
    for (final VoidCallback listener in _hoverListeners!) {
      listener();
    }
  }

  TreemapTile? get previousSelectedTile => _previousSelectedTile;
  TreemapTile? _previousSelectedTile;

  TreemapTile? get selectedTile => _selectedTile;
  TreemapTile? _selectedTile;
  set selectedTile(TreemapTile? value) {
    _previousSelectedTile = _selectedTile;
    _selectedTile = _selectedTile == value ? null : value;
    notifySelectionListeners();
  }

  TreemapTile? get previousHoveredTile => _previousHoveredTile;
  TreemapTile? _previousHoveredTile;

  TreemapTile? get hoveredTile => _hoveredTile;
  TreemapTile? _hoveredTile;
  set hoveredTile(TreemapTile? value) {
    if (_hoveredTile == value) {
      return;
    }
    _previousHoveredTile = _hoveredTile;
    _hoveredTile = value;
    notifyHoverListeners();
  }

  void dispose() {
    _selectionListeners = null;
    _hoverListeners = null;
  }
}
