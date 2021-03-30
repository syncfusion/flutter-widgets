library treemap;

import 'package:flutter/material.dart';

import 'src/layouts.dart';
import 'src/legend.dart';

export 'src/layouts.dart' show TreemapTile;
export 'src/legend.dart' hide LegendWidget;

/// Signature to return the string values from the data source based
/// on the index.
///
/// See also:
/// * [IndexedDoubleValueMapper] which is similar, but it returns a
/// double value.
/// * [TreemapTileWidgetBuilder] returns a widget based on a given tile.
typedef IndexedStringValueMapper = String? Function(int index);

/// Signature to return the double values from the data source based
/// on the index.
///
/// See also:
/// * [IndexedStringValueMapper] which is similar, but it returns a string.
typedef IndexedDoubleValueMapper = double Function(int index);

/// Signature to return the colors or other types from the data source based
/// on the tile based on which colors will be applied.
///
/// See also:
/// * [IndexedDoubleValueMapper] which is similar, but it returns a double
/// value.
/// * [TreemapTileWidgetBuilder] returns a widget based on a given tile.
typedef TreemapTileColorValueMapper = dynamic Function(TreemapTile tile);

/// Signature to return a widget based on the given tile.
///
/// See also:
/// * [IndexedStringValueMapper] returns a string based on the given index.
/// * [TreemapTileColorValueMapper] returns a dynamic value based on the group
/// and parent.
typedef TreemapTileWidgetBuilder = Widget? Function(
    BuildContext context, TreemapTile tile);

/// The levels collection which forms either flat or hierarchal treemap.
///
/// You can have more than one [TreemapLevel] in this collection to form a
/// hierarchal treemap. The 0th index of the [SfTreemap.levels] collection
/// forms the base level of the treemap or flat treemap. From the 1st index,
/// the values returned in the [TreemapLevel.groupMapper] callback will form as
/// inner tiles of the tile formed in the previous level for which the indices
/// match.This hierarchy will go on till the last [TreemapLevel] in the
/// [Treemap.levels] collection.
///
/// ```dart
/// List<SocialMediaUsers> _socialMediaUsersData;
///
///   @override
///   void initState() {
///     _socialMediaUsersData = <SocialMediaUsers>[
///       SocialMediaUsers('India', 'Facebook', 280),
///       SocialMediaUsers('India', 'Instagram', 88),
///       SocialMediaUsers('USA', 'Facebook', 190),
///       SocialMediaUsers('USA', 'Instagram', 120),
///       SocialMediaUsers('Japan', 'Twitter', 48),
///       SocialMediaUsers('Japan', 'Instagram', 31),
///     ];
///     super.initState();
///   }
///
/// @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfTreemap(
///         dataCount: _socialMediaUsersData.length,
///         weightValueMapper: (int index) {
///           return _socialMediaUsersData[index].usersInMillions;
///         },
///       levels: [
///         TreemapLevel(
///             color: Colors.red,
///             padding: EdgeInsets.all(2),
///             groupMapper: (int index) {
///               return _socialMediaUsersData[index].country;
///             }),
///         ],
///       ),
///     );
///   }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// See also:
/// * [SfTreemap], to know how treemap render the tiles.
class TreemapLevel {
  /// Creates a [TreemapLevel].
  ///
  /// The levels collection which forms either flat or hierarchal treemap.
  ///
  /// You can have more than one [TreemapLevel] in this collection to form a
  /// hierarchal treemap. The 0th index of the [TreemapLevel.levels] collection
  /// forms the base level of the treemap or flat treemap. From the 1st index,
  /// the values returned in the [TreemapLevel.groupMapper] callback will form
  /// as inner tiles of the tile formed in the previous level for which the
  /// indices match.This hierarchy will go on till the last [TreemapLevel] in
  /// the [TreemapLevel.levels] collection.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap], to know how treemap render the tiles.
  const TreemapLevel({
    this.color,
    this.border,
    this.padding = const EdgeInsets.all(1.0),
    required this.groupMapper,
    this.colorValueMapper,
    this.tooltipBuilder,
    this.labelBuilder,
    this.itemBuilder,
  });

  /// Specifies the color applied to the tiles.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               color: Colors.red,
  ///            ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [border], to set the border to the tiles.
  /// * [padding], to apply a space around the tiles.
  final Color? color;

  /// Specifies the border of the rectangular box with rounded corners.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               color: Colors.red,
  ///               border: const RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.all(Radius.circular(15)),
  ///                 side: BorderSide(color: Colors.black, width: 2),
  ///               ),
  ///             ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [padding], to apply a space around the tiles.
  /// * [groupMapper] denotes the group which the tile has be mapped in the
  ///  internal data source.
  final RoundedRectangleBorder? border;

  /// Sets the padding around the tiles based on the value.
  ///
  ///  ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               color: Colors.red,
  ///               border: const RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.all(Radius.circular(15)),
  ///                 side: BorderSide(color: Colors.black, width: 2),
  ///               ),
  ///               padding: EdgeInsets.all(2),
  ///            ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [groupMapper] denotes the group which the tile has be mapped in the
  ///  internal data source.
  /// * [labelBuilder], displays a basic information about the tiles.
  final EdgeInsetsGeometry? padding;

  /// Returns the group to be mapped based on the data source.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               color: Colors.red,
  ///               border: const RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.all(Radius.circular(15)),
  ///                 side: BorderSide(color: Colors.black, width: 2),
  ///               ),
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///             ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [labelBuilder], displays a basic information about the tiles.
  /// * [tooltipBuilder], displays an additional information about the tile
  /// while interacting.
  final IndexedStringValueMapper groupMapper;

  /// Returns a color or value based on which tile color will be updated.
  ///
  /// If this returns a color, then this color will be applied to the tile
  /// straightaway.
  ///
  /// If it returns a value other than the color, then you must set the
  /// [SfTreemap.colorMappers] property.
  ///
  /// The value returned from the [colorValueMapper] will be used for the
  /// comparison in the [TreemapColorMapper.value] or [TreemapColorMapper.from]
  /// and [TreemapColorMapper.to]. Then, the [TreemapColorMapper.color] will be
  /// applied to the respective tiles.
  ///
  /// If it returns null, we have applied color based on the tile weight.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///  List<TreemapColorMapper> _colorMappers;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     _colorMappers = <TreemapColorMapper>[
  ///       TreemapColorMapper.range(0, 100, Colors.green),
  ///       TreemapColorMapper.range(101, 200, Colors.blue),
  ///       TreemapColorMapper.range(201, 300, Colors.red),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         colorMappers: _colorMappers,
  ///         levels: [
  ///           TreemapLevel(
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               colorValueMapper: (TreemapTile tile) => tile.weight,
  ///               ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [color], to set the color to the tiles.
  /// * [border], to set the border to the tiles.
  final TreemapTileColorValueMapper? colorValueMapper;

  /// Returns a widget for the treemap label based on the tile.
  ///
  /// A treemap label displays additional information about the tile
  /// on a treemap.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               color: Colors.red,
  ///               labelBuilder: (BuildContext context, TreemapTile tile) {
  ///                 return Padding(
  ///                   padding: EdgeInsets.all(4.0),
  ///                   child: Text(tile.group),
  ///                 );
  ///               }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapLevel.itemBuilder], shows icons, images and text
  /// in the treemap tiles and customizes their position.
  final TreemapTileWidgetBuilder? labelBuilder;

  /// Returns a widget for the treemap tile based on the index.
  ///
  /// A treemap item builder displays icons, images and text in the treemap
  /// tiles and customizes their position.
  ///
  /// By default , widget will be align top left of the tile. If we need to
  /// customize it, the Align widget can be wrapped and aligned.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               color: Colors.red,
  ///               itemBuilder: (BuildContext context, TreemapTile tile) {
  ///                 return Icon(Icons.mobile_friendly);
  ///               }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapLevel.labelBuilder], for showing the additional information
  /// about the tile.
  final TreemapTileWidgetBuilder? itemBuilder;

  /// Returns a widget for the tooltip based on the treemap tile.
  ///
  /// It displays additional information about the tiles on the treemap.
  /// The returned widget will then be wrapped in the existing tooltip shape
  /// which comes with the nose at the bottom.
  ///
  /// It is possible to customize the border appearance using the
  /// [TreemapTooltipSettings.borderColor] and
  /// [TreemapTooltipSettings.borderWidth]. To customize the corners, use
  /// [TreemapTooltipSettings.borderRadius].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///               color: Colors.red,
  ///               border: const RoundedRectangleBorder(
  ///                 borderRadius: BorderRadius.all(Radius.circular(15)),
  ///                 side: BorderSide(color: Colors.black, width: 2),
  ///               ),
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///                 return Text('Country: ${tile.group}\n Users: ${tile.weight}');
  ///               },
  ///               ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  /// See also:
  /// * [itemBuilder], displays the returned widget to the background
  /// of the tiles.
  final TreemapTileWidgetBuilder? tooltipBuilder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TreemapLevel &&
        other.color == color &&
        other.border == border &&
        other.padding == padding &&
        other.groupMapper == groupMapper &&
        other.colorValueMapper == colorValueMapper &&
        other.labelBuilder == labelBuilder &&
        other.itemBuilder == itemBuilder &&
        other.tooltipBuilder == tooltipBuilder;
  }

  @override
  int get hashCode => hashValues(
      groupMapper, color, border, colorValueMapper, padding, tooltipBuilder);
}

/// Customized the appearance of the tiles in selection state.
///
/// ```dart
/// List<SocialMediaUsers> _source;
///
/// @override
/// void initState() {
///   _source = <SocialMediaUsers>[
///     SocialMediaUsers('India', 'Facebook', 280),
///     SocialMediaUsers('India', 'Instagram', 88),
///     SocialMediaUsers('USA', 'Facebook', 190),
///     SocialMediaUsers('USA', 'Instagram', 120),
///     SocialMediaUsers('Japan', 'Twitter', 48),
///     SocialMediaUsers('Japan', 'Instagram', 31),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemap(
///       dataCount: _source.length,
///       weightValueMapper: (int index) {
///         return _source[index].usersInMillions;
///       },
///       levels: [
///         TreemapLevel(
///           groupMapper: (int index) {
///             return _source[index].country;
///           },
///         ),
///       ],
///       onSelectionChanged: (TreemapTile tile) {},
///       selectionSettings: const TreemapSelectionSettings(),
///     ),
///   );
/// }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// See also:
/// * [TreemapSelectionSettings.color], for changing the selected tile color.
/// * [TreemapSelectionSettings.border], for applying border color, width and
///  border radius to the selected tile.
class TreemapSelectionSettings {
  /// Creates [TreemapSelectionSettings].
  ///
  /// Customized the appearance of the tiles in selection state.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       onSelectionChanged: (TreemapTile tile) {},
  ///       selectionSettings: const TreemapSelectionSettings(),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapSelectionSettings.color], for changing the selected tile color.
  /// * [TreemapSelectionSettings.border], for applying border color, width and
  ///  border radius to the selected tile.
  const TreemapSelectionSettings({this.color, this.border});

  /// Customizes the color of the selected tile.
  ///
  /// See also:
  /// * [border], for applying border color and border radius to the
  /// selected tile.
  final Color? color;

  /// Apply border to the selected by initializing the [border] property.
  ///
  /// You can change the border color and border width of the selected tile
  /// using the [RoundedRectangleBorder.size] property and border radius applied
  /// using the [RoundedRectangleBorder.borderRadius] property.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       onSelectionChanged: (TreemapTile tile) {},
  ///       selectionSettings: TreemapSelectionSettings(
  ///         border: RoundedRectangleBorder(
  ///           side: BorderSide(
  ///             color: Colors.red,
  ///             width: 2,
  ///           ),
  ///           borderRadius: BorderRadius.circular(20),
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [color], for changing the selected tile color.
  final RoundedRectangleBorder? border;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TreemapSelectionSettings &&
        other.color == color &&
        other.border == border;
  }

  @override
  int get hashCode => hashValues(color, border);
}

/// Customizes the appearance of the tooltip.
///
/// ```dart
/// List<SocialMediaUsers> _socialMediaUsersData;
///
///   @override
///   void initState() {
///     _socialMediaUsersData = <SocialMediaUsers>[
///       SocialMediaUsers('India', 'Facebook', 280),
///       SocialMediaUsers('India', 'Instagram', 88),
///       SocialMediaUsers('USA', 'Facebook', 190),
///       SocialMediaUsers('USA', 'Instagram', 120),
///       SocialMediaUsers('Japan', 'Twitter', 48),
///       SocialMediaUsers('Japan', 'Instagram', 31),
///     ];
///     super.initState();
///   }
///
/// @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfTreemap(
///         dataCount: _socialMediaUsersData.length,
///         weightValueMapper: (int index) {
///           return _socialMediaUsersData[index].usersInMillions;
///         },
///         tooltipSettings: TreemapTooltipSettings(
///           color: Colors.blue,
///           borderWidth: 2.0,
///           borderColor: Colors.white,
///         ),
///         levels: [
///           TreemapLevel(
///               padding: EdgeInsets.all(2),
///               groupMapper: (int index) {
///                 return _socialMediaUsersData[index].country;
///               },
///               color: Colors.red,
///               tooltipBuilder: (BuildContext context, TreemapTile tile) {
///                 return Padding(
///                   padding: EdgeInsets.all(10.0),
///                   child: Text(
///                       'Country ${tile.group}' + '\n Users ${tile.weight}'),
///                 );
///               }),
///         ],
///       ),
///     );
///   }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// See also:
/// * [TreemapLevel.tooltipBuilder], to enable the tooltip.
class TreemapTooltipSettings {
  /// Creates [TreemapTooltipSettings].
  ///
  /// Customizes the appearance of the tooltip.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         tooltipSettings: TreemapTooltipSettings(
  ///           color: Colors.blue,
  ///           borderWidth: 2.0,
  ///           borderColor: Colors.white,
  ///         ),
  ///         levels: [
  ///           TreemapLevel(
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               color: Colors.red,
  ///               tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///                 return Padding(
  ///                   padding: EdgeInsets.all(10.0),
  ///                   child: Text(
  ///                       'Country ${tile.group}' + '\n Users ${tile.weight}'),
  ///                 );
  ///               }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  const TreemapTooltipSettings({
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(4.0),
    ),
  });

  /// Fills the tooltip by this color.
  ///
  /// See also:
  /// * [borderColor], to set the border color.
  /// * [borderWidth], to set the border width.
  /// * [borderRadius], to set the border radius.
  final Color? color;

  /// Specifies the border color applies to the tooltip.
  ///
  /// See also:
  /// * [color], to set the fill color.
  /// * [borderWidth], to set the border width.
  /// * [borderRadius], to set the border radius.
  final Color? borderColor;

  /// Specifies the border width applies to the tooltip.
  ///
  /// See also:
  /// * [color], to set the fill color.
  /// * [borderColor], to set the border color.
  /// * [borderRadius], to set the border radius.
  final double borderWidth;

  /// Specifies the border radius applies to the tooltip.
  ///
  /// See also:
  /// * [color], to set the fill color.
  /// * [borderColor], to set the border color.
  /// * [borderWidth], to set the border width.
  final BorderRadiusGeometry borderRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TreemapTooltipSettings &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => hashValues(color, borderColor, borderWidth, borderRadius);

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  TreemapTooltipSettings copyWith({
    Color? color,
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
  }) {
    return TreemapTooltipSettings(
        color: color ?? this.color,
        borderColor: borderColor ?? this.borderColor,
        borderWidth: borderWidth ?? this.borderWidth,
        borderRadius: borderRadius ?? this.borderRadius);
  }
}

/// Collection of [TreemapColorMapper] which specifies tile’s color based on
/// the data.
///
/// The [TreemapLevel.colorValueMapper] which will be called for each tiles in
/// the respective level, needs to return a color or value based on which
/// tiles color will be updated.
///
/// If it returns a color, then this color will be applied to the tiles
/// straightaway. If it returns a value other than the color, then this value
/// will be compared with the [TreemapColorMapper.value] for the exact value
/// or [TreemapColorMapper.from] and [TreemapColorMapper.to] for the range of
/// values. Then the respective [TreemapColorMapper.color] will be applied to
/// that tile.
///
/// The below code snippet represents how color can be applied to the shape
/// based on the [TreemapColorMapper.value] property of [TreemapColorMapper].
///
/// ```dart
/// List<SocialMediaUsers> _socialMediaUsersData;
///   List<TreemapColorMapper> _colorMappers;
///
///   @override
///   void initState() {
///     _socialMediaUsersData = <SocialMediaUsers>[
///       SocialMediaUsers('India', 'Facebook', 280),
///       SocialMediaUsers('India', 'Instagram', 88),
///       SocialMediaUsers('USA', 'Facebook', 190),
///       SocialMediaUsers('USA', 'Instagram', 120),
///       SocialMediaUsers('Japan', 'Twitter', 48),
///       SocialMediaUsers('Japan', 'Instagram', 31),
///     ];
///     _colorMappers = <TreemapColorMapper>[
///       TreemapColorMapper.value('India', Colors.green),
///       TreemapColorMapper.value(USA, Colors.blue),
///       TreemapColorMapper.value(Japan, Colors.red),
///     ];
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfTreemap(
///         dataCount: _socialMediaUsersData.length,
///         weightValueMapper: (int index) {
///           return _socialMediaUsersData[index].usersInMillions;
///         },
///         colorMappers: _colorMappers,
///         levels: [
///           TreemapLevel(
///               groupMapper: (int index) {
///                 return _socialMediaUsersData[index].country;
///               },
///               colorValueMapper: (TreemapTile tile) => tile.group,
///           ),
///         ],
///       ),
///     );
///   }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// The below code snippet represents how color can be applied to the shape
/// based on the range between [TreemapColorMapper.from] and
/// [TreemapColorMapper.to] properties of [TreemapColorMapper].
///
/// ```dart
/// List<SocialMediaUsers> _socialMediaUsersData;
///   List<TreemapColorMapper> _colorMappers;
///
///   @override
///   void initState() {
///     _socialMediaUsersData = <SocialMediaUsers>[
///       SocialMediaUsers('India', 'Facebook', 280),
///       SocialMediaUsers('India', 'Instagram', 88),
///       SocialMediaUsers('USA', 'Facebook', 190),
///       SocialMediaUsers('USA', 'Instagram', 120),
///       SocialMediaUsers('Japan', 'Twitter', 48),
///       SocialMediaUsers('Japan', 'Instagram', 31),
///     ];
///     _colorMappers = <TreemapColorMapper>[
///       TreemapColorMapper.range(0, 100, Colors.green),
///       TreemapColorMapper.range(101, 200, Colors.blue),
///       TreemapColorMapper.range(201, 300, Colors.red),
///     ];
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: SfTreemap(
///         dataCount: _socialMediaUsersData.length,
///         weightValueMapper: (int index) {
///           return _socialMediaUsersData[index].usersInMillions;
///         },
///         colorMappers: _colorMappers,
///         levels: [
///           TreemapLevel(
///               groupMapper: (int index) {
///                 return _socialMediaUsersData[index].country;
///               },
///               colorValueMapper: (TreemapTile tile) => tile.weight,
///           ),
///         ],
///       ),
///     );
///   }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
/// See also:
/// * [SfTreemap.legend], to enable and customize the legend.
class TreemapColorMapper {
  /// Applies color to the tiles which lies between the
  /// [TreemapColorMapper.from] and [TreemapColorMapper.to] given range. The
  /// [TreemapColorMapper.from] and [TreemapColorMapper.to] must not be null.
  ///
  /// Applies this [TreemapColorMapper.color] value to the tiles which are in
  /// the given range. The legend item color and text are based on the
  /// [TreemapColorMapper.name] value.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///   List<TreemapColorMapper> _colorMappers;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     _colorMappers = <TreemapColorMapper>[
  ///       TreemapColorMapper.range(0, 100, Colors.green),
  ///       TreemapColorMapper.range(101, 200, Colors.blue),
  ///       TreemapColorMapper.range(201, 300, Colors.red),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         colorMappers: _colorMappers,
  ///         levels: [
  ///           TreemapLevel(
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               colorValueMapper: (TreemapTile tile) => tile.weight,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap.legend], to enable and customize the legend.
  const TreemapColorMapper.range(
      {required this.from, required this.to, required this.color, this.name})
      : assert(from != null && to != null && from <= to),
        value = null;

  /// Applies the color to the tiles which is equal to the given
  /// [TreemapColorMapper.value]. The [TreemapColorMapper.value] must not be
  /// null.
  ///
  /// Applies this [TreemapColorMapper.color] value to the tiles which are in
  /// the given [TreemapColorMapper.value]. The legend item color and text are
  /// based on the [TreemapColorMapper.color] and [TreemapColorMapper.value].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///   List<TreemapColorMapper> _colorMappers;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     _colorMappers = <TreemapColorMapper>[
  ///       TreemapColorMapper.value('India', Colors.green),
  ///       TreemapColorMapper.value(USA, Colors.blue),
  ///       TreemapColorMapper.value(Japan, Colors.red),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         colorMappers: _colorMappers,
  ///         levels: [
  ///           TreemapLevel(
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               colorValueMapper: (TreemapTile tile) => tile.group,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap.legend], to enable and customize the legend.
  const TreemapColorMapper.value({required this.value, required this.color})
      : assert(value != null),
        from = null,
        to = null,
        name = null;

  /// Specifies the color applies to the tile based on the value returned in
  /// the [TreemapLevel.colorValueMapper].
  ///
  /// See also:
  /// * [name], sets the identifier text for the color mapping.
  final Color color;

  /// Sets the range start for the color mapping.
  ///
  /// The tile will render in the specified [color] if the value
  /// returned in the [TreemapLevel.colorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// See also:
  /// * [to], sets the end range for the color mapping.
  final double? from;

  /// Sets the range end for the color mapping.
  ///
  /// The tile will render in the specified [color] if the value
  /// returned in the [TreemapLevel.colorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// See also:
  /// * [color], maps the color to the tiles based on the value returned
  /// in [TreemapLevel.colorValueMapper].
  final double? to;

  /// Sets the value for the value color mapping.
  ///
  /// The tile would render in the specified [color] if the value returned in
  /// the [TreemapLevel.colorValueMapper] is value to this [value].
  ///
  /// See also:
  /// * [color], maps the color to the tiles based on the value returned
  /// in [TreemapLevel.colorValueMapper].
  final String? value;

  /// Sets the identifier text to the color mapping. The same will be used
  /// to the legend item text and [color] will be used as legend item color.
  ///
  /// See also:
  /// * [from], sets the start range for the color mapping.
  /// * [to], sets the end range for the color mapping.
  final String? name;
}

/// A data visualization widget that provides an effective way to visualize
/// flat and hierarchical data as rectangles that are sized and colored based
/// on quantitative variables.
///
/// Labels - Add any type of widgets (like text widget) to improve the
/// readability of the individual tiles by providing brief descriptions.
///
/// Layouts - Use different layouts based on the algorithms such as squarified,
/// slice, and dice to represent flat and hierarchically structured data.
///
/// Hierarchical support - Along with the flat level, treemap supports
/// hierarchical structure too. Each tile of the treemap is a rectangle which is
/// filled with smaller rectangles representing sub-data.
///
/// Colors - Categorize the tiles on the treemap by customizing their color
/// based on the levels. It is possible to set the tile color for a specific
/// value or for a range of values.
///
/// Tooltip - Display additional information about the tile using a completely
/// customizable tooltip on the treemap.
///
/// Legend - Use different legend styles to provide information on the treemap
/// data clearly.
///
/// Selection - Allows you to select the tiles to highlight it and do any
/// specific functionalities like showing pop-up or navigate to a different
/// page.
///
/// Custom background widgets - Add any type of custom widgets such as image
/// widget as a background of the tiles to enrich the UI and easily visualize
/// the type of data that a particular tile shows.
///
/// To populate the treemap with the data source, set the count of the data
/// source to the [dataCount] property of the treemap. The quantitative value of
/// the underlying data has to be returned from the [weightValueMapper]
/// callback. Based on this value, every tile (rectangle) will have its size.
///
/// The data will be grouped based on the values returned from the
/// [TreemapLevel.groupMapper] callback from the each [TreemapLevel]. Each
/// unique value returned from the callback will have its own tile and its size
/// will be based on the value returned in the [weightValueMapper] for the same
/// index. If the same values returned for the multiple indices in
/// [TreemapLevel.groupMapper] callback, it will be grouped, and its size will
/// be the sum of values returned from [weightValueMapper] for those indices.
///
/// You can have more than one [TreemapLevel] in the [levels] collection to form
/// a hierarchal treemap. The 0th index of the [levels] collection forms the
/// base level of the treemap. From the 1st index, the values returned in the
/// [TreemapLevel.groupMapper] callback will form as inner tiles of the tile
/// formed in the previous level for which the indices match. This hierarchy
/// will go on till the last [TreemapLevel] in the [levels] collection.
///
/// ```dart
/// List<SocialMediaUsers> _socialMediaUsersData;
/// List<TreemapColorMapper> _colorMappers;
///
/// @override
/// void initState() {
///   _socialMediaUsersData = <SocialMediaUsers>[
///     SocialMediaUsers('India', 'Facebook', 280),
///     SocialMediaUsers('India', 'Instagram', 88),
///     SocialMediaUsers('USA', 'Facebook', 190),
///     SocialMediaUsers('USA', 'Instagram', 120),
///     SocialMediaUsers('Japan', 'Twitter', 48),
///     SocialMediaUsers('Japan', 'Instagram', 31),
///   ];
///   _colorMappers = <TreemapColorMapper>[
///     TreemapColorMapper.range(0, 100, Colors.green),
///     TreemapColorMapper.range(101, 200, Colors.blue),
///     TreemapColorMapper.range(201, 300, Colors.red),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemap(
///       dataCount: _socialMediaUsersData.length,
///       weightValueMapper: (int index) {
///         return _socialMediaUsersData[index].usersInMillions;
///       },
///       colorMappers: _colorMappers,
///       levels: [
///         TreemapLevel(
///             color: Colors.red,
///             border: const RoundedRectangleBorder(
///               borderRadius: BorderRadius.all(Radius.circular(15)),
///               side: BorderSide(color: Colors.black, width: 2),
///             ),
///             padding: EdgeInsets.all(2),
///             groupMapper: (int index) {
///               return _socialMediaUsersData[index].country;
///             },
///             colorValueMapper: (TreemapTile tile) => tile.weight,
///             tooltipBuilder: (BuildContext context, TreemapTile tile) {
///               return Text('Country: ${tile.group}\n Users: ${tile.weight}');
///             },
///             labelBuilder: (BuildContext context, TreemapTile tile) {
///               return Text('Country : ${tile.group}');
///             },
///             itemBuilder: (BuildContext context, TreemapTile tile) {
///               return Center(child: Icon(Icons.home, size: 15));
///             }),
///       ],
///     ),
///   );
/// }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// See also:
/// * [SfTreemap.slice], to render the tiles horizontally.
/// * [SfTreemap.dice], to render the tiles vertically.
/// * [TreemapLevel.tooltipBuilder], to enable tooltip.
/// * [SfTreemap.legend], to enable legend.
/// * [TreemapLevel.labelBuilder], to add a label for each tile.
class SfTreemap extends StatelessWidget {
  /// Creates a treemap based on the squarified algorithm.
  ///
  /// To populate the treemap with the data source, set the count
  /// of the data source to the [SfTreemap.dataCount] property of the treemap.
  /// The quantitative value of the underlying data has to be returned
  /// from the [SfTreemap.weightValueMapper] callback. Based on this value,
  /// every tile (rectangle) will have its size.
  ///
  /// The data will be grouped based on the values returned from the
  /// [TreemapLevel.groupMapper] callback from the each [TreemapLevel].
  /// Each unique value returned from the callback will have its own tile
  /// and its size will be based on the value returned in the
  /// [SfTreemap.weightValueMapper] for the same index. If the same values
  /// returned for the multiple indices in [TreemapLevel.groupMapper] callback,
  /// it will be grouped, and its size will be the sum of values returned from
  /// [SfTreemap.weightValueMapper] for those indices.
  ///
  /// You can have more than one [TreemapLevel] in the [SfTreemap.levels]
  /// collection to form a hierarchal treemap. The 0th index of the
  /// [SfTreemap.levels] collection forms the base level of the treemap. From
  /// the 1st index, the values returned in the [TreemapLevel.groupMapper]
  /// callback will form as inner tiles of the tile formed in the previous level
  /// for which the indices match. This hierarchy will go on till the last
  /// [TreemapLevel] in the [SfTreemap.levels] collection.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  /// List<TreemapColorMapper> _colorMappers;
  ///
  /// @override
  /// void initState() {
  ///   _socialMediaUsersData = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(0, 100, Colors.green),
  ///     TreemapColorMapper.range(101, 200, Colors.blue),
  ///     TreemapColorMapper.range(201, 300, Colors.red),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _socialMediaUsersData.length,
  ///       weightValueMapper: (int index) {
  ///         return _socialMediaUsersData[index].usersInMillions;
  ///       },
  ///       colorMappers: _colorMappers,
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             border: const RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(15)),
  ///               side: BorderSide(color: Colors.black, width: 2),
  ///             ),
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             },
  ///             colorValueMapper: (TreemapTile tile) => tile.weight,
  ///             tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country: ${tile.group}\n Users: ${tile.weight}');
  ///             },
  ///             labelBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country : ${tile.group}');
  ///             },
  ///             itemBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Center(child: Icon(Icons.home, size: 15));
  ///             }),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap.slice], to render the tiles horizontally.
  /// * [SfTreemap.dice], to render the tiles vertically.
  const SfTreemap({
    Key? key,
    required this.dataCount,
    required this.levels,
    required this.weightValueMapper,
    this.colorMappers,
    this.legend,
    this.onSelectionChanged,
    this.selectionSettings = const TreemapSelectionSettings(),
    this.tooltipSettings = const TreemapTooltipSettings(),
  })  : assert(dataCount > 0),
        assert(levels.length > 0),
        assert(colorMappers == null || colorMappers.length > 0),
        _layoutType = LayoutType.squarified,
        super(key: key);

  /// Creates a treemap based on the slice algorithm.
  ///
  /// To populate the treemap with the data source, set the count of the data
  /// source to the [SfTreemap.dataCount] property of the treemap. The
  /// quantitative value of the underlying data has to be returned from the
  /// [SfTreemap.weightValueMapper] callback. Based on this value, every tile
  /// (rectangle) will have its size.
  ///
  /// The data will be grouped based on the values returned from the
  /// [TreemapLevel.groupMapper] callback from the each [TreemapLevel]. Each
  /// unique value returned from the callback will have its own tile and its
  /// size will be based on the value returned in the
  /// [SfTreemap.weightValueMapper] for the same index. If the same values
  /// returned for the multiple indices in [TreemapLevel.groupMapper] callback,
  /// it will be grouped, and its size will be the sum of values returned from
  /// [SfTreemap.weightValueMapper] for those
  /// indices.
  ///
  /// You can have more than one [TreemapLevel] in the [SfTreemap.levels]
  /// collection to form a hierarchal treemap. The 0th index of the
  /// [SfTreemap.levels] collection forms the base level of the treemap. From
  /// the 1st index, the values returned in the [TreemapLevel.groupMapper]
  /// callback will form as inner tiles of the tile formed in the previous level
  /// for which the indices match. This hierarchy will go on till the last
  /// [TreemapLevel] in the [SfTreemap.levels] collection.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  /// List<TreemapColorMapper> _colorMappers;
  ///
  /// @override
  /// void initState() {
  ///   _socialMediaUsersData = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(0, 100, Colors.green),
  ///     TreemapColorMapper.range(101, 200, Colors.blue),
  ///     TreemapColorMapper.range(201, 300, Colors.red),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap.slice(
  ///       dataCount: _socialMediaUsersData.length,
  ///       weightValueMapper: (int index) {
  ///         return _socialMediaUsersData[index].usersInMillions;
  ///       },
  ///       colorMappers: _colorMappers,
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             border: const RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(15)),
  ///               side: BorderSide(color: Colors.black, width: 2),
  ///             ),
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             },
  ///             colorValueMapper: (TreemapTile tile) => tile.weight,
  ///             tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country: ${tile.group}\n Users: ${tile.weight}');
  ///             },
  ///             labelBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country : ${tile.group}');
  ///             },
  ///             itemBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Center(child: Icon(Icons.home, size: 15));
  ///             }),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap], to render based on squarified algorithm.
  /// * [SfTreemap.dice], to render the tiles vertically.
  const SfTreemap.slice({
    Key? key,
    required this.dataCount,
    required this.levels,
    required this.weightValueMapper,
    this.colorMappers,
    this.legend,
    this.onSelectionChanged,
    this.selectionSettings = const TreemapSelectionSettings(),
    this.tooltipSettings = const TreemapTooltipSettings(),
  })  : assert(dataCount > 0),
        assert(levels.length > 0),
        assert(colorMappers == null || colorMappers.length > 0),
        _layoutType = LayoutType.slice,
        super(key: key);

  /// Creates a treemap based on the dice algorithm.
  ///
  /// To populate the treemap with the data source, set the count of the data
  /// source to the [SfTreemap.dataCount] property of the treemap. The
  /// quantitative value of the underlying data has to be returned from the
  /// [SfTreemap.weightValueMapper] callback. Based on this value, every tile
  /// (rectangle) will have its size.
  ///
  /// The data will be grouped based on the values returned from the
  /// [TreemapLevel.groupMapper] callback from the each [TreemapLevel]. Each
  /// unique value returned from the callback will have its own tile and its
  /// size will be based on the value returned in the
  /// [SfTreemap.weightValueMapper] for the same index. If the same values
  /// returned for the multiple indices in [TreemapLevel.groupMapper] callback,
  /// it will be grouped, and its size will be the sum of values returned from
  /// [SfTreemap.weightValueMapper] for those indices.
  ///
  /// You can have more than one [TreemapLevel] in the [SfTreemap.levels]
  /// collection to form a hierarchal treemap. The 0th index of the
  /// [SfTreemap.levels] collection forms the base level of the treemap. From
  /// the 1st index, the values returned in the [TreemapLevel.groupMapper]
  /// callback will form as inner tiles of the tile formed in the previous level
  /// for which the indices match. This hierarchy will go on till the last
  /// [TreemapLevel] in the [SfTreemap.levels] collection.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  /// List<TreemapColorMapper> _colorMappers;
  ///
  /// @override
  /// void initState() {
  ///   _socialMediaUsersData = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(0, 100, Colors.green),
  ///     TreemapColorMapper.range(101, 200, Colors.blue),
  ///     TreemapColorMapper.range(201, 300, Colors.red),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap.dice(
  ///       dataCount: _socialMediaUsersData.length,
  ///       weightValueMapper: (int index) {
  ///         return _socialMediaUsersData[index].usersInMillions;
  ///       },
  ///       colorMappers: _colorMappers,
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             border: const RoundedRectangleBorder(
  ///               borderRadius: BorderRadius.all(Radius.circular(15)),
  ///               side: BorderSide(color: Colors.black, width: 2),
  ///             ),
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             },
  ///             colorValueMapper: (TreemapTile tile) => tile.weight,
  ///             tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country: ${tile.group}\n Users: ${tile.weight}');
  ///             },
  ///             labelBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Text('Country : ${tile.group}');
  ///             },
  ///             itemBuilder: (BuildContext context, TreemapTile tile) {
  ///               return Center(child: Icon(Icons.home, size: 15));
  ///             }),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap], to render based on squarified algorithm.
  /// * [SfTreemap.slice], to render the tiles horizontally.
  const SfTreemap.dice({
    Key? key,
    required this.dataCount,
    required this.levels,
    required this.weightValueMapper,
    this.colorMappers,
    this.legend,
    this.onSelectionChanged,
    this.selectionSettings = const TreemapSelectionSettings(),
    this.tooltipSettings = const TreemapTooltipSettings(),
  })  : assert(dataCount > 0),
        assert(levels.length > 0),
        assert(colorMappers == null || colorMappers.length > 0),
        _layoutType = LayoutType.dice,
        super(key: key);

  /// Specifies the length of the data source.
  ///
  /// To populate the treemap with the data source, set the count of the data
  /// source to the [dataCount] property of the treemap. The [weightValueMapper]
  /// and [TreemapLevel.groupMapper] will be called number of times equal to the
  /// [dataCount] to determine the number of tiles and the size of the tiles.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             }),
  ///          ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  /// See also:
  /// * [SfTreemap], to know how treemap render the tiles.
  final int dataCount;

  /// Returns the values which determines the weight of each tile.
  ///
  /// The quantitative value of the underlying data has to be returned from the
  /// [weightValueMapper] callback. Based on this value, every tile (rectangle)
  /// will have its size.
  ///
  /// The data will be grouped based on the values returned from the
  /// [TreemapLevel.groupMapper] callback from the each [TreemapLevel]. Each
  /// unique value returned from the callback will have its own tile and its
  /// size will be based on the value returned in the [weightValueMapper] for
  /// the same index. If the same values returned for the multiple indices in
  /// [TreemapLevel.groupMapper] callback, it will be grouped, and its size will
  /// be the sum of values returned from [weightValueMapper] for those indices.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap], to know how treemap render the tiles.
  final IndexedDoubleValueMapper weightValueMapper;

  /// The levels collection which forms either flat or hierarchal treemap.
  ///
  /// You can have more than one [TreemapLevel] in this collection to form a
  /// hierarchal treemap. The 0th index of the [levels] collection forms the
  /// base level of the treemap or flat treemap. From the 1st index, the values
  /// returned in the [TreemapLevel.groupMapper] callback will form as inner
  /// tiles of the tile formed in the previous level for which the indices
  /// match.This hierarchy will go on till the last TreemapLevel in the [levels]
  /// collection.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///       levels: [
  ///         TreemapLevel(
  ///             color: Colors.red,
  ///             padding: EdgeInsets.all(2),
  ///             groupMapper: (int index) {
  ///               return _socialMediaUsersData[index].country;
  ///             }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [SfTreemap], to know how treemap render the tiles.
  final List<TreemapLevel> levels;

  /// Customizes the appearance of the tooltip.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         tooltipSettings: TreemapTooltipSettings(
  ///           color: Colors.blue,
  ///           borderWidth: 2.0,
  ///           borderColor: Colors.white,
  ///         ),
  ///         levels: [
  ///           TreemapLevel(
  ///               padding: EdgeInsets.all(2),
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               color: Colors.red,
  ///               tooltipBuilder: (BuildContext context, TreemapTile tile) {
  ///                 return Padding(
  ///                   padding: EdgeInsets.all(10.0),
  ///                   child: Text(
  ///                       'Country ${tile.group}' + '\n Users ${tile.weight}'),
  ///                 );
  ///               }),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapLevel.tooltipBuilder], to enable the tooltip.
  final TreemapTooltipSettings tooltipSettings;

  /// Collection of [TreemapColorMapper] which specifies tile’s color based on
  /// the data.
  ///
  /// The [TreemapLevel.colorValueMapper] which will be called for each tiles in
  /// the respective level, needs to return a color or value based on which
  /// tiles color will be updated.
  ///
  /// If it returns a color, then this color will be applied to the tiles
  /// straightaway. If it returns a value other than the color, then this value
  /// will be compared with the [TreemapColorMapper.value] for the exact value
  /// or [TreemapColorMapper.from] and [TreemapColorMapper.to] for the range of
  /// values. Then the respective [TreemapColorMapper.color] will be applied to
  /// that tile.
  ///
  /// The below code snippet represents how color can be applied to the shape
  /// based on the [TreemapColorMapper.value] property of [TreemapColorMapper].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///   List<TreemapColorMapper> _colorMappers;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     _colorMappers = <TreemapColorMapper>[
  ///       TreemapColorMapper.value('India', Colors.green),
  ///       TreemapColorMapper.value(USA, Colors.blue),
  ///       TreemapColorMapper.value(Japan, Colors.red),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         colorMappers: _colorMappers,
  ///         levels: [
  ///           TreemapLevel(
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               colorValueMapper: (TreemapTile tile) => tile.group,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// The below code snippet represents how color can be applied to the shape
  /// based on the range between [TreemapColorMapper.from] and
  /// [TreemapColorMapper.to]properties of [TreemapColorMapper].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _socialMediaUsersData;
  ///   List<TreemapColorMapper> _colorMappers;
  ///
  ///   @override
  ///   void initState() {
  ///     _socialMediaUsersData = <SocialMediaUsers>[
  ///       SocialMediaUsers('India', 'Facebook', 280),
  ///       SocialMediaUsers('India', 'Instagram', 88),
  ///       SocialMediaUsers('USA', 'Facebook', 190),
  ///       SocialMediaUsers('USA', 'Instagram', 120),
  ///       SocialMediaUsers('Japan', 'Twitter', 48),
  ///       SocialMediaUsers('Japan', 'Instagram', 31),
  ///     ];
  ///     _colorMappers = <TreemapColorMapper>[
  ///       TreemapColorMapper.range(0, 100, Colors.green),
  ///       TreemapColorMapper.range(101, 200, Colors.blue),
  ///       TreemapColorMapper.range(201, 300, Colors.red),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: SfTreemap(
  ///         dataCount: _socialMediaUsersData.length,
  ///         weightValueMapper: (int index) {
  ///           return _socialMediaUsersData[index].usersInMillions;
  ///         },
  ///         colorMappers: _colorMappers,
  ///         levels: [
  ///           TreemapLevel(
  ///               groupMapper: (int index) {
  ///                 return _socialMediaUsersData[index].country;
  ///               },
  ///               colorValueMapper: (TreemapTile tile) => tile.weight,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  /// See also:
  /// * [legend], to enable and customize the legend.
  final List<TreemapColorMapper>? colorMappers;

  /// Called when the user selected the tile.
  ///
  /// * tile - contains information about the treemap tile.
  ///
  /// To do any specific functionalities like showing pop-up or navigate to a
  /// different page, use the [onSelectionChanged] callback.
  ///
  /// See also:
  /// * [TreemapTile], contains information about the treemap tile.
  final ValueChanged<TreemapTile>? onSelectionChanged;

  /// Customized the appearance of the tiles in selection state.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       onSelectionChanged: (TreemapTile tile) {},
  ///       selectionSettings: const TreemapSelectionSettings(),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapSelectionSettings.color], for changing the selected tile color.
  /// * [TreemapSelectionSettings.border], for applying border color, width and
  ///  border radius to the selected tile.
  final TreemapSelectionSettings selectionSettings;

  /// Specifies the type of the treemap.
  final LayoutType _layoutType;

  /// Shows legend for the data rendered in the treemap.
  ///
  /// Defaults to `null`.
  ///
  /// By default, legend will not be shown.
  ///
  /// If [SfTreemap.colorMappers] is null, then the legend items' icon color and
  /// legend item's text will be applied based on the value of
  /// [TreemapLevel.color] and the values returned from the
  /// [TreemapLevel.groupMapper] callback of first [TreemapLevel] added in the
  /// [levels] collection.
  ///
  /// If [SfTreemap.colorMappers] is not null and TreemapColorMapper.value()
  /// constructor is used, the legend item's icon color will be applied based on
  /// the [TreemapColorMapper.color] property and the legend text applied based
  /// on the [TreemapColorMapper.value] property.
  ///
  /// And, when using [TreemapColorMapper.range] constructor, the legend item's
  /// icon color will be applied based on the [TreemapColorMapper.color]
  /// property and the legend text will be applied based on the
  /// [TreemapColorMapper.name] property. If the
  /// [TreemapColorMapper.name] property is null, then the text will
  /// be applied based on the [TreemapColorMapper.from] and
  /// [TreemapColorMapper.to] properties
  ///
  /// The below code snippet represents how to setting default legend
  /// to the tree map.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// The below code snippet represents how to setting bar legend
  /// to the tree map.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * To render bar legend, refer [TreemapLegend.bar] constructor.
  final TreemapLegend? legend;

  @override
  Widget build(BuildContext context) {
    return Treemap(
      layoutType: _layoutType,
      dataCount: dataCount,
      levels: levels,
      weightValueMapper: weightValueMapper,
      colorMappers: colorMappers,
      legend: legend,
      onSelectionChanged: onSelectionChanged,
      selectionSettings: selectionSettings,
      tooltipSettings: tooltipSettings,
    );
  }
}
